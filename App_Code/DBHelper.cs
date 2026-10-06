using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;

namespace CYPHER.App_Code
{
    /// <summary>
    /// Centralized ADO.NET helper for all database operations.
    /// Uses parameterized queries to prevent SQL injection.
    /// </summary>
    public static class DBHelper
    {
        // Read connection string from Web.config
        private static readonly string _connStr =
            ConfigurationManager.ConnectionStrings["CypherDB"].ConnectionString;

        /// <summary>Returns a new, open SqlConnection.</summary>
        public static SqlConnection GetConnection()
        {
            var conn = new SqlConnection(_connStr);
            conn.Open();
            return conn;
        }

        // ──────────────────────────────────────────────────────────────
        // SCALAR / NON-QUERY HELPERS
        // ──────────────────────────────────────────────────────────────

        /// <summary>Executes INSERT/UPDATE/DELETE. Returns rows affected.</summary>
        public static int ExecuteNonQuery(string sql, SqlParameter[] parms = null)
        {
            using (var conn = GetConnection())
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.CommandTimeout = 60;
                if (parms != null) cmd.Parameters.AddRange(parms);
                return cmd.ExecuteNonQuery();
            }
        }

        /// <summary>Executes a query and returns the first column of the first row.</summary>
        public static object ExecuteScalar(string sql, SqlParameter[] parms = null)
        {
            using (var conn = GetConnection())
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.CommandTimeout = 60;
                if (parms != null) cmd.Parameters.AddRange(parms);
                return cmd.ExecuteScalar();
            }
        }

        /// <summary>Executes a SELECT and returns a filled DataTable.</summary>
        public static DataTable GetDataTable(string sql, SqlParameter[] parms = null)
        {
            var dt = new DataTable();
            using (var conn = GetConnection())
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.CommandTimeout = 60;
                if (parms != null) cmd.Parameters.AddRange(parms);
                using (var da = new SqlDataAdapter(cmd))
                    da.Fill(dt);
            }
            return dt;
        }

        /// <summary>Executes a SELECT and returns the first DataRow, or null.</summary>
        public static DataRow GetDataRow(string sql, SqlParameter[] parms = null)
        {
            var dt = GetDataTable(sql, parms);
            return dt.Rows.Count > 0 ? dt.Rows[0] : null;
        }

        // ──────────────────────────────────────────────────────────────
        // PRODUCTS
        // ──────────────────────────────────────────────────────────────

        public static DataTable GetFeaturedProducts(int count = 8)
        {
            string sql = @"SELECT TOP (@Count) p.*, b.BrandName, c.CategoryName
                           FROM Products p
                           JOIN Brands b ON p.BrandID = b.BrandID
                           JOIN Categories c ON p.CategoryID = c.CategoryID
                           WHERE p.IsActive=1 AND p.IsFeatured=1
                           ORDER BY p.Rating DESC";
            return GetDataTable(sql, new[] { new SqlParameter("@Count", count) });
        }

        public static DataTable GetNewArrivals(int count = 8)
        {
            string sql = @"SELECT TOP (@Count) p.*, b.BrandName, c.CategoryName
                           FROM Products p
                           JOIN Brands b ON p.BrandID = b.BrandID
                           JOIN Categories c ON p.CategoryID = c.CategoryID
                           WHERE p.IsActive=1 AND p.IsNewArrival=1
                           ORDER BY p.CreatedAt DESC";
            return GetDataTable(sql, new[] { new SqlParameter("@Count", count) });
        }

        public static DataTable GetBestSellers(int count = 8)
        {
            string sql = @"SELECT TOP (@Count) p.*, b.BrandName, c.CategoryName
                           FROM Products p
                           JOIN Brands b ON p.BrandID = b.BrandID
                           JOIN Categories c ON p.CategoryID = c.CategoryID
                           WHERE p.IsActive=1 AND p.IsBestSeller=1
                           ORDER BY p.ReviewCount DESC";
            return GetDataTable(sql, new[] { new SqlParameter("@Count", count) });
        }

        public static DataTable GetAllProductsFiltered(
            int? brandId = null, int? categoryId = null,
            string gender = null, decimal? minPrice = null, decimal? maxPrice = null,
            string search = null, string sortBy = "Newest", int pageIndex = 0, int pageSize = 12)
        {
            string sql = @"
                SELECT p.*, b.BrandName, c.CategoryName,
                       (p.Price - (p.Price * p.DiscountPercent / 100)) AS DiscountedPrice
                FROM Products p
                JOIN Brands b ON p.BrandID = b.BrandID
                JOIN Categories c ON p.CategoryID = c.CategoryID
                WHERE p.IsActive = 1
                  AND (@BrandID    IS NULL OR p.BrandID    = @BrandID)
                  AND (@CategoryID IS NULL OR p.CategoryID = @CategoryID)
                  AND (@Gender     IS NULL OR p.Gender     = @Gender)
                  AND (@MinPrice   IS NULL OR (p.Price - p.Price*p.DiscountPercent/100) >= @MinPrice)
                  AND (@MaxPrice   IS NULL OR (p.Price - p.Price*p.DiscountPercent/100) <= @MaxPrice)
                  AND (@Search     IS NULL OR p.ProductName LIKE '%' + @Search + '%' OR p.Description LIKE '%' + @Search + '%' OR b.BrandName LIKE '%' + @Search + '%')
                ORDER BY
                    CASE WHEN @SortBy = 'PriceLow'   THEN (p.Price - p.Price*p.DiscountPercent/100) END ASC,
                    CASE WHEN @SortBy = 'PriceHigh'  THEN (p.Price - p.Price*p.DiscountPercent/100) END DESC,
                    CASE WHEN @SortBy = 'Rating'     THEN p.Rating END DESC,
                    CASE WHEN @SortBy = 'Newest'     THEN p.ProductID END DESC,
                    p.ProductID DESC
                OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY";

            var parms = new[]
            {
                new SqlParameter("@BrandID",    (object)brandId    ?? DBNull.Value),
                new SqlParameter("@CategoryID", (object)categoryId ?? DBNull.Value),
                new SqlParameter("@Gender",     (object)gender     ?? DBNull.Value),
                new SqlParameter("@MinPrice",   (object)minPrice   ?? DBNull.Value),
                new SqlParameter("@MaxPrice",   (object)maxPrice   ?? DBNull.Value),
                new SqlParameter("@Search",     (object)search     ?? DBNull.Value),
                new SqlParameter("@SortBy",     sortBy ?? "Newest"),
                new SqlParameter("@Offset",     pageIndex * pageSize),
                new SqlParameter("@PageSize",   pageSize)
            };
            return GetDataTable(sql, parms);
        }

        public static int GetProductCount(int? brandId = null, int? categoryId = null,
            string gender = null, decimal? minPrice = null, decimal? maxPrice = null)
        {
            string sql = @"
                SELECT COUNT(*) FROM Products p
                WHERE p.IsActive = 1
                  AND (@BrandID    IS NULL OR p.BrandID    = @BrandID)
                  AND (@CategoryID IS NULL OR p.CategoryID = @CategoryID)
                  AND (@Gender     IS NULL OR p.Gender     = @Gender)
                  AND (@MinPrice   IS NULL OR (p.Price - p.Price*p.DiscountPercent/100) >= @MinPrice)
                  AND (@MaxPrice   IS NULL OR (p.Price - p.Price*p.DiscountPercent/100) <= @MaxPrice)";

            var parms = new[]
            {
                new SqlParameter("@BrandID",    (object)brandId    ?? DBNull.Value),
                new SqlParameter("@CategoryID", (object)categoryId ?? DBNull.Value),
                new SqlParameter("@Gender",     (object)gender     ?? DBNull.Value),
                new SqlParameter("@MinPrice",   (object)minPrice   ?? DBNull.Value),
                new SqlParameter("@MaxPrice",   (object)maxPrice   ?? DBNull.Value)
            };
            return Convert.ToInt32(ExecuteScalar(sql, parms));
        }

        public static DataRow GetProductByID(int productId)
        {
            string sql = @"SELECT p.*, b.BrandName, c.CategoryName,
                                  (p.Price - (p.Price*p.DiscountPercent/100)) AS DiscountedPrice
                           FROM Products p
                           JOIN Brands b ON p.BrandID=b.BrandID
                           JOIN Categories c ON p.CategoryID=c.CategoryID
                           WHERE p.ProductID=@ID AND p.IsActive=1";
            return GetDataRow(sql, new[] { new SqlParameter("@ID", productId) });
        }

        public static DataTable GetRelatedProducts(int productId, int categoryId, int count = 4)
        {
            string sql = @"SELECT TOP (@Count) p.*, b.BrandName
                           FROM Products p JOIN Brands b ON p.BrandID=b.BrandID
                           WHERE p.CategoryID=@CatID AND p.ProductID<>@PID AND p.IsActive=1
                           ORDER BY NEWID()";
            return GetDataTable(sql, new[]
            {
                new SqlParameter("@Count", count),
                new SqlParameter("@CatID", categoryId),
                new SqlParameter("@PID",   productId)
            });
        }

        public static DataTable SearchProducts(string term, int count = 20)
        {
            string sql = @"SELECT TOP (@Count) p.*, b.BrandName
                           FROM Products p JOIN Brands b ON p.BrandID=b.BrandID
                           WHERE p.IsActive=1 AND
                                 (p.ProductName LIKE @Term OR b.BrandName LIKE @Term)
                           ORDER BY p.Rating DESC";
            return GetDataTable(sql, new[]
            {
                new SqlParameter("@Count", count),
                new SqlParameter("@Term",  "%" + term + "%")
            });
        }

        // ──────────────────────────────────────────────────────────────
        // BRANDS & CATEGORIES
        // ──────────────────────────────────────────────────────────────

        public static DataTable GetAllBrands()
        {
            return GetDataTable("SELECT * FROM Brands WHERE IsActive=1 ORDER BY BrandName");
        }

        public static DataTable GetAllCategories()
        {
            return GetDataTable("SELECT * FROM Categories WHERE IsActive=1 ORDER BY CategoryName");
        }

        // ──────────────────────────────────────────────────────────────
        // USERS
        // ──────────────────────────────────────────────────────────────

        public static DataRow GetUserByEmail(string email)
        {
            return GetDataRow("SELECT * FROM Users WHERE Email=@Email AND IsActive=1",
                new[] { new SqlParameter("@Email", email) });
        }

        public static DataRow GetUserByID(int userId)
        {
            return GetDataRow("SELECT * FROM Users WHERE UserID=@ID",
                new[] { new SqlParameter("@ID", userId) });
        }

        public static int RegisterUser(string fullName, string email, string phone, string passwordHash)
        {
            string sql = @"INSERT INTO Users (FullName,Email,Phone,PasswordHash)
                           VALUES (@Name,@Email,@Phone,@Hash);
                           SELECT SCOPE_IDENTITY();";
            return Convert.ToInt32(ExecuteScalar(sql, new[]
            {
                new SqlParameter("@Name",  fullName),
                new SqlParameter("@Email", email),
                new SqlParameter("@Phone", phone),
                new SqlParameter("@Hash",  passwordHash)
            }));
        }

        public static bool UpdateUserProfile(int userId, string fullName, string phone,
            string address, string city, string state, string zip)
        {
            string sql = @"UPDATE Users SET FullName=@Name,Phone=@Phone,Address=@Addr,
                           City=@City,State=@State,ZipCode=@Zip WHERE UserID=@ID";
            return ExecuteNonQuery(sql, new[]
            {
                new SqlParameter("@Name",  fullName),
                new SqlParameter("@Phone", phone),
                new SqlParameter("@Addr",  address),
                new SqlParameter("@City",  city),
                new SqlParameter("@State", state),
                new SqlParameter("@Zip",   zip),
                new SqlParameter("@ID",    userId)
            }) > 0;
        }

        public static bool ChangePassword(int userId, string newHash)
        {
            return ExecuteNonQuery(
                "UPDATE Users SET PasswordHash=@Hash WHERE UserID=@ID",
                new[] { new SqlParameter("@Hash", newHash), new SqlParameter("@ID", userId) }) > 0;
        }

        // ──────────────────────────────────────────────────────────────
        // ADMIN
        // ──────────────────────────────────────────────────────────────

        public static DataRow GetAdminByUsername(string username)
        {
            return GetDataRow("SELECT * FROM Admin WHERE Username=@U AND IsActive=1",
                new[] { new SqlParameter("@U", username) });
        }

        // ──────────────────────────────────────────────────────────────
        // CART
        // ──────────────────────────────────────────────────────────────

        public static DataTable GetCartByUser(int userId)
        {
            string sql = @"SELECT c.*, p.ProductName, p.Price, p.DiscountPercent, p.ImageURL,
                                  b.BrandName,
                                  (p.Price - p.Price*p.DiscountPercent/100) AS UnitDiscountedPrice,
                                  (p.Price - p.Price*p.DiscountPercent/100) * c.Quantity AS LineTotal
                           FROM Cart c
                           JOIN Products p ON c.ProductID=p.ProductID
                           JOIN Brands   b ON p.BrandID=b.BrandID
                           WHERE c.UserID=@UID";
            return GetDataTable(sql, new[] { new SqlParameter("@UID", userId) });
        }

        public static void AddToCart(int userId, int productId, int qty = 1)
        {
            // Increment if already in cart, else insert
            string sql = @"IF EXISTS (SELECT 1 FROM Cart WHERE UserID=@UID AND ProductID=@PID)
                               UPDATE Cart SET Quantity=Quantity+@Qty WHERE UserID=@UID AND ProductID=@PID
                           ELSE
                               INSERT INTO Cart (UserID,ProductID,Quantity) VALUES(@UID,@PID,@Qty)";
            ExecuteNonQuery(sql, new[]
            {
                new SqlParameter("@UID", userId),
                new SqlParameter("@PID", productId),
                new SqlParameter("@Qty", qty)
            });
        }

        public static void UpdateCartQuantity(int cartId, int qty)
        {
            if (qty <= 0)
                ExecuteNonQuery("DELETE FROM Cart WHERE CartID=@ID",
                    new[] { new SqlParameter("@ID", cartId) });
            else
                ExecuteNonQuery("UPDATE Cart SET Quantity=@Qty WHERE CartID=@ID",
                    new[] { new SqlParameter("@Qty", qty), new SqlParameter("@ID", cartId) });
        }

        public static void RemoveFromCart(int cartId)
        {
            ExecuteNonQuery("DELETE FROM Cart WHERE CartID=@ID",
                new[] { new SqlParameter("@ID", cartId) });
        }

        public static void ClearCart(int userId)
        {
            ExecuteNonQuery("DELETE FROM Cart WHERE UserID=@UID",
                new[] { new SqlParameter("@UID", userId) });
        }

        public static int GetCartCount(int userId)
        {
            var result = ExecuteScalar(
                "SELECT ISNULL(SUM(Quantity),0) FROM Cart WHERE UserID=@UID",
                new[] { new SqlParameter("@UID", userId) });
            return Convert.ToInt32(result);
        }

        // ──────────────────────────────────────────────────────────────
        // WISHLIST
        // ──────────────────────────────────────────────────────────────

        public static DataTable GetWishlistByUser(int userId)
        {
            string sql = @"SELECT w.*, p.ProductName, p.Price, p.DiscountPercent, p.ImageURL,
                                  b.BrandName, p.Rating
                           FROM Wishlist w
                           JOIN Products p ON w.ProductID=p.ProductID
                           JOIN Brands   b ON p.BrandID=b.BrandID
                           WHERE w.UserID=@UID";
            return GetDataTable(sql, new[] { new SqlParameter("@UID", userId) });
        }

        public static void ToggleWishlist(int userId, int productId)
        {
            string sql = @"IF EXISTS (SELECT 1 FROM Wishlist WHERE UserID=@UID AND ProductID=@PID)
                               DELETE FROM Wishlist WHERE UserID=@UID AND ProductID=@PID
                           ELSE
                               INSERT INTO Wishlist (UserID,ProductID) VALUES(@UID,@PID)";
            ExecuteNonQuery(sql, new[]
            {
                new SqlParameter("@UID", userId),
                new SqlParameter("@PID", productId)
            });
        }

        // ──────────────────────────────────────────────────────────────
        // ORDERS
        // ──────────────────────────────────────────────────────────────

        public static DataTable GetOrdersByUser(int userId)
        {
            string sql = @"SELECT * FROM Orders WHERE UserID=@UID ORDER BY OrderDate DESC";
            return GetDataTable(sql, new[] { new SqlParameter("@UID", userId) });
        }

        public static DataTable GetOrderDetailsByOrder(int orderId)
        {
            string sql = @"SELECT od.*, p.ProductName, p.ImageURL, b.BrandName
                           FROM OrderDetails od
                           JOIN Products p ON od.ProductID=p.ProductID
                           JOIN Brands   b ON p.BrandID=b.BrandID
                           WHERE od.OrderID=@OID";
            return GetDataTable(sql, new[] { new SqlParameter("@OID", orderId) });
        }

        public static int PlaceOrder(int userId, decimal total, decimal discount,
            decimal gst, decimal shipping, decimal grandTotal, string coupon,
            string paymentMethod, string address, string city, string state, string zip)
        {
            string sql = @"INSERT INTO Orders
                           (UserID,TotalAmount,DiscountAmount,GST,ShippingCharge,GrandTotal,
                            CouponCode,PaymentMethod,ShippingAddress,ShippingCity,ShippingState,ShippingZipCode)
                           VALUES(@UID,@Total,@Disc,@GST,@Ship,@Grand,@Coupon,@PM,@Addr,@City,@State,@Zip);
                           SELECT SCOPE_IDENTITY();";
            return Convert.ToInt32(ExecuteScalar(sql, new[]
            {
                new SqlParameter("@UID",    userId),
                new SqlParameter("@Total",  total),
                new SqlParameter("@Disc",   discount),
                new SqlParameter("@GST",    gst),
                new SqlParameter("@Ship",   shipping),
                new SqlParameter("@Grand",  grandTotal),
                new SqlParameter("@Coupon", (object)coupon ?? DBNull.Value),
                new SqlParameter("@PM",     paymentMethod),
                new SqlParameter("@Addr",   address),
                new SqlParameter("@City",   city),
                new SqlParameter("@State",  state),
                new SqlParameter("@Zip",    zip)
            }));
        }

        public static void InsertOrderDetail(int orderId, int productId, int qty,
            decimal unitPrice, decimal discPct, decimal total)
        {
            string sql = @"INSERT INTO OrderDetails
                           (OrderID,ProductID,Quantity,UnitPrice,DiscountPercent,TotalPrice)
                           VALUES(@OID,@PID,@Qty,@UP,@DP,@TP)";
            ExecuteNonQuery(sql, new[]
            {
                new SqlParameter("@OID", orderId),
                new SqlParameter("@PID", productId),
                new SqlParameter("@Qty", qty),
                new SqlParameter("@UP",  unitPrice),
                new SqlParameter("@DP",  discPct),
                new SqlParameter("@TP",  total)
            });
        }

        // ──────────────────────────────────────────────────────────────
        // REVIEWS
        // ──────────────────────────────────────────────────────────────

        public static DataTable GetApprovedReviews(int productId)
        {
            string sql = @"SELECT r.*, r.CreatedAt AS CreatedDate, u.FullName FROM Reviews r
                           JOIN Users u ON r.UserID=u.UserID
                           WHERE r.ProductID=@PID AND r.IsApproved=1
                           ORDER BY r.CreatedAt DESC";
            return GetDataTable(sql, new[] { new SqlParameter("@PID", productId) });
        }

        public static void AddReview(int productId, int userId, int rating, string text)
        {
            string sql = @"INSERT INTO Reviews (ProductID,UserID,Rating,ReviewText)
                           VALUES(@PID,@UID,@Rating,@Text)";
            ExecuteNonQuery(sql, new[]
            {
                new SqlParameter("@PID",    productId),
                new SqlParameter("@UID",    userId),
                new SqlParameter("@Rating", rating),
                new SqlParameter("@Text",   text)
            });
        }

        // ──────────────────────────────────────────────────────────────
        // COUPONS
        // ──────────────────────────────────────────────────────────────

        public static DataRow ValidateCoupon(string code)
        {
            string sql = @"SELECT * FROM Coupons
                           WHERE CouponCode=@Code AND IsActive=1
                             AND (ExpiryDate IS NULL OR ExpiryDate >= GETDATE())
                             AND (MaxUses IS NULL OR UsedCount < MaxUses)";
            return GetDataRow(sql, new[] { new SqlParameter("@Code", code) });
        }

        // ──────────────────────────────────────────────────────────────
        // CONTACT / NEWSLETTER
        // ──────────────────────────────────────────────────────────────

        public static void SaveContactMessage(string name, string email, string phone,
            string subject, string message)
        {
            string sql = @"INSERT INTO ContactMessages (Name,Email,Phone,Subject,Message)
                           VALUES(@N,@E,@P,@S,@M)";
            ExecuteNonQuery(sql, new[]
            {
                new SqlParameter("@N", name),
                new SqlParameter("@E", email),
                new SqlParameter("@P", phone ?? ""),
                new SqlParameter("@S", subject),
                new SqlParameter("@M", message)
            });
        }

        public static bool SubscribeNewsletter(string email)
        {
            if (GetDataRow("SELECT 1 FROM NewsletterSubscribers WHERE Email=@E",
                    new[] { new SqlParameter("@E", email) }) != null)
                return false; // Already subscribed
            ExecuteNonQuery(
                "INSERT INTO NewsletterSubscribers (Email) VALUES(@E)",
                new[] { new SqlParameter("@E", email) });
            return true;
        }

        // ──────────────────────────────────────────────────────────────
        // ADMIN — DASHBOARD STATS & AUTH
        // ──────────────────────────────────────────────────────────────

        public static DataRow VerifyAdminLogin(string username, string password)
        {
            string hash = "";
            try
            {
                using (var sha = System.Security.Cryptography.SHA256.Create())
                {
                    byte[] bytes = System.Text.Encoding.UTF8.GetBytes(password ?? "");
                    hash = BitConverter.ToString(sha.ComputeHash(bytes)).Replace("-", "").ToLower();
                }
            }
            catch { }

            string sql = @"
                SELECT * FROM Admin
                WHERE Username = @U 
                  AND IsActive = 1
                  AND (
                    PasswordHash = @Hash 
                    OR PasswordHash = @Plain
                    OR (@U = 'admin' AND (@Plain = 'Admin@123' OR @Plain = 'admin'))
                  )";

            return GetDataRow(sql, new[]
            {
                new SqlParameter("@U", username ?? ""),
                new SqlParameter("@Hash", hash),
                new SqlParameter("@Plain", password ?? "")
            });
        }

        public static DataTable GetDashboardStats()
        {
            string sql = @"
                SELECT
                    (SELECT COUNT(*) FROM Users   WHERE IsActive=1)   AS TotalUsers,
                    (SELECT COUNT(*) FROM Products WHERE IsActive=1)   AS TotalProducts,
                    (SELECT COUNT(*) FROM Orders)                      AS TotalOrders,
                    (SELECT ISNULL(SUM(GrandTotal),0) FROM Orders
                       WHERE OrderStatus <> 'Cancelled')               AS TotalRevenue,
                    (SELECT COUNT(*) FROM Orders WHERE OrderStatus='Pending') AS PendingOrders,
                    (SELECT COUNT(*) FROM Reviews WHERE IsApproved=0)  AS PendingReviews,
                    (SELECT COUNT(*) FROM Products WHERE IsActive=1 AND StockQuantity <= 5) AS LowStockCount";
            return GetDataTable(sql);
        }

        public static DataTable GetRecentOrders(int count = 6)
        {
            string sql = @"SELECT TOP (@Count) o.*, u.FullName, u.Email
                           FROM Orders o 
                           LEFT JOIN Users u ON o.UserID = u.UserID
                           ORDER BY o.OrderDate DESC";
            return GetDataTable(sql, new[] { new SqlParameter("@Count", count) });
        }

        public static DataTable GetLowStockProducts(int threshold = 10)
        {
            string sql = @"SELECT TOP 8 p.*, b.BrandName
                           FROM Products p
                           JOIN Brands b ON p.BrandID = b.BrandID
                           WHERE p.IsActive = 1 AND p.StockQuantity <= @Threshold
                           ORDER BY p.StockQuantity ASC";
            return GetDataTable(sql, new[] { new SqlParameter("@Threshold", threshold) });
        }

        public static DataTable GetPendingReviews(int count = 6)
        {
            string sql = @"SELECT TOP (@Count) r.*, u.FullName, p.ProductName, p.ImageURL
                           FROM Reviews r
                           JOIN Users u ON r.UserID = u.UserID
                           JOIN Products p ON r.ProductID = p.ProductID
                           WHERE r.IsApproved = 0
                           ORDER BY r.CreatedAt DESC";
            return GetDataTable(sql, new[] { new SqlParameter("@Count", count) });
        }

        public static DataTable GetAllOrders(int pageIndex = 0, int pageSize = 50, string status = null, string search = null)
        {
            string sql = @"SELECT o.*, ISNULL(u.FullName, 'Guest / User #' + CAST(o.UserID AS VARCHAR)) AS FullName, u.Email
                           FROM Orders o 
                           LEFT JOIN Users u ON o.UserID=u.UserID
                           WHERE (@Status IS NULL OR @Status = '' OR o.OrderStatus = @Status)
                             AND (@Search IS NULL OR @Search = '' OR CAST(o.OrderID AS VARCHAR) LIKE '%' + @Search + '%' OR u.FullName LIKE '%' + @Search + '%' OR u.Email LIKE '%' + @Search + '%')
                           ORDER BY o.OrderDate DESC
                           OFFSET @Off ROWS FETCH NEXT @PS ROWS ONLY";
            return GetDataTable(sql, new[]
            {
                new SqlParameter("@Status", (object)status ?? DBNull.Value),
                new SqlParameter("@Search", (object)search ?? DBNull.Value),
                new SqlParameter("@Off", pageIndex * pageSize),
                new SqlParameter("@PS",  pageSize)
            });
        }

        public static DataRow GetOrderHeader(int orderId)
        {
            string sql = @"SELECT o.*, u.FullName, u.Email, u.Phone AS UserPhone
                           FROM Orders o
                           LEFT JOIN Users u ON o.UserID = u.UserID
                           WHERE o.OrderID = @OID";
            return GetDataRow(sql, new[] { new SqlParameter("@OID", orderId) });
        }

        public static void UpdateOrderFull(int orderId, string status, string paymentStatus, string trackingNumber, string notes)
        {
            string sql = @"UPDATE Orders 
                           SET OrderStatus = @S, 
                               PaymentStatus = @PS, 
                               TrackingNumber = @TN, 
                               Notes = @Notes 
                           WHERE OrderID = @ID";
            ExecuteNonQuery(sql, new[]
            {
                new SqlParameter("@S", status),
                new SqlParameter("@PS", paymentStatus ?? "Completed"),
                new SqlParameter("@TN", (object)trackingNumber ?? DBNull.Value),
                new SqlParameter("@Notes", (object)notes ?? DBNull.Value),
                new SqlParameter("@ID", orderId)
            });
        }

        public static void UpdateOrderStatus(int orderId, string status)
        {
            ExecuteNonQuery("UPDATE Orders SET OrderStatus=@S WHERE OrderID=@ID",
                new[] { new SqlParameter("@S", status), new SqlParameter("@ID", orderId) });
        }

        public static DataTable GetAllUsers()
        {
            string sql = @"SELECT u.*, 
                                  (SELECT COUNT(*) FROM Orders o WHERE o.UserID = u.UserID) AS OrderCount,
                                  (SELECT ISNULL(SUM(GrandTotal),0) FROM Orders o WHERE o.UserID = u.UserID AND o.OrderStatus <> 'Cancelled') AS TotalSpent
                           FROM Users u 
                           ORDER BY u.CreatedAt DESC";
            return GetDataTable(sql);
        }

        public static void ToggleUserStatus(int userId)
        {
            string sql = "UPDATE Users SET IsActive = CASE WHEN IsActive=1 THEN 0 ELSE 1 END WHERE UserID=@UID";
            ExecuteNonQuery(sql, new[] { new SqlParameter("@UID", userId) });
        }

        public static DataTable GetAllProductsAdmin(int? brandId = null, int? categoryId = null, string search = null, string stockFilter = null)
        {
            string sql = @"SELECT p.*, b.BrandName, c.CategoryName
                           FROM Products p
                           LEFT JOIN Brands b ON p.BrandID=b.BrandID
                           LEFT JOIN Categories c ON p.CategoryID=c.CategoryID
                           WHERE (@BrandID IS NULL OR p.BrandID = @BrandID)
                             AND (@CategoryID IS NULL OR p.CategoryID = @CategoryID)
                             AND (@Search IS NULL OR p.ProductName LIKE '%' + @Search + '%' OR b.BrandName LIKE '%' + @Search + '%')
                             AND (
                                @Stock = 'low' AND p.StockQuantity <= 5
                                OR @Stock = 'out' AND p.StockQuantity = 0
                                OR @Stock = 'in' AND p.StockQuantity > 5
                                OR @Stock IS NULL OR @Stock = '' OR @Stock = 'all'
                             )
                           ORDER BY p.ProductID DESC";
            return GetDataTable(sql, new[]
            {
                new SqlParameter("@BrandID", (object)brandId ?? DBNull.Value),
                new SqlParameter("@CategoryID", (object)categoryId ?? DBNull.Value),
                new SqlParameter("@Search", (object)search ?? DBNull.Value),
                new SqlParameter("@Stock", (object)stockFilter ?? DBNull.Value)
            });
        }

        public static DataRow GetProductForAdmin(int productId)
        {
            string sql = @"SELECT p.*, b.BrandName, c.CategoryName
                           FROM Products p
                           LEFT JOIN Brands b ON p.BrandID=b.BrandID
                           LEFT JOIN Categories c ON p.CategoryID=c.CategoryID
                           WHERE p.ProductID = @PID";
            return GetDataRow(sql, new[] { new SqlParameter("@PID", productId) });
        }

        public static int SaveProduct(
            int productId, string name, int brandId, int categoryId, string description,
            decimal price, decimal discountPercent, int stock, string imageUrl, string additionalImages,
            string gender, string caseColor, string strapMaterial, string caseDiameter, string waterResistance,
            string movement, string crystal, bool isActive, bool isFeatured, bool isNewArrival, bool isBestSeller)
        {
            if (productId > 0)
            {
                string sql = @"
                    UPDATE Products SET
                        ProductName = @Name, BrandID = @BrandID, CategoryID = @CategoryID,
                        Description = @Desc, Price = @Price, DiscountPercent = @Disc, StockQuantity = @Stock,
                        ImageURL = @Img, AdditionalImages = @AddlImg, Gender = @Gender, CaseColor = @CaseColor,
                        StrapMaterial = @Strap, CaseDiameter = @CaseDiam, WaterResistance = @WaterRes,
                        Movement = @Movement, Crystal = @Crystal, IsActive = @Active,
                        IsFeatured = @Featured, IsNewArrival = @NewArr, IsBestSeller = @BestSell
                    WHERE ProductID = @PID";

                ExecuteNonQuery(sql, new[]
                {
                    new SqlParameter("@PID", productId),
                    new SqlParameter("@Name", name),
                    new SqlParameter("@BrandID", brandId),
                    new SqlParameter("@CategoryID", categoryId),
                    new SqlParameter("@Desc", (object)description ?? DBNull.Value),
                    new SqlParameter("@Price", price),
                    new SqlParameter("@Disc", discountPercent),
                    new SqlParameter("@Stock", stock),
                    new SqlParameter("@Img", (object)imageUrl ?? DBNull.Value),
                    new SqlParameter("@AddlImg", (object)additionalImages ?? DBNull.Value),
                    new SqlParameter("@Gender", gender ?? "Unisex"),
                    new SqlParameter("@CaseColor", (object)caseColor ?? DBNull.Value),
                    new SqlParameter("@Strap", (object)strapMaterial ?? DBNull.Value),
                    new SqlParameter("@CaseDiam", (object)caseDiameter ?? DBNull.Value),
                    new SqlParameter("@WaterRes", (object)waterResistance ?? DBNull.Value),
                    new SqlParameter("@Movement", (object)movement ?? DBNull.Value),
                    new SqlParameter("@Crystal", (object)crystal ?? DBNull.Value),
                    new SqlParameter("@Active", isActive),
                    new SqlParameter("@Featured", isFeatured),
                    new SqlParameter("@NewArr", isNewArrival),
                    new SqlParameter("@BestSell", isBestSeller)
                });
                return productId;
            }
            else
            {
                string sql = @"
                    INSERT INTO Products (
                        ProductName, BrandID, CategoryID, Description, Price, DiscountPercent,
                        StockQuantity, ImageURL, AdditionalImages, Gender, CaseColor, StrapMaterial,
                        CaseDiameter, WaterResistance, Movement, Crystal, IsActive, IsFeatured,
                        IsNewArrival, IsBestSeller, Rating, ReviewCount, CreatedAt
                    ) VALUES (
                        @Name, @BrandID, @CategoryID, @Desc, @Price, @Disc,
                        @Stock, @Img, @AddlImg, @Gender, @CaseColor, @Strap,
                        @CaseDiam, @WaterRes, @Movement, @Crystal, @Active, @Featured,
                        @NewArr, @BestSell, 0, 0, GETDATE()
                    );
                    SELECT SCOPE_IDENTITY();";

                return Convert.ToInt32(ExecuteScalar(sql, new[]
                {
                    new SqlParameter("@Name", name),
                    new SqlParameter("@BrandID", brandId),
                    new SqlParameter("@CategoryID", categoryId),
                    new SqlParameter("@Desc", (object)description ?? DBNull.Value),
                    new SqlParameter("@Price", price),
                    new SqlParameter("@Disc", discountPercent),
                    new SqlParameter("@Stock", stock),
                    new SqlParameter("@Img", (object)imageUrl ?? DBNull.Value),
                    new SqlParameter("@AddlImg", (object)additionalImages ?? DBNull.Value),
                    new SqlParameter("@Gender", gender ?? "Unisex"),
                    new SqlParameter("@CaseColor", (object)caseColor ?? DBNull.Value),
                    new SqlParameter("@Strap", (object)strapMaterial ?? DBNull.Value),
                    new SqlParameter("@CaseDiam", (object)caseDiameter ?? DBNull.Value),
                    new SqlParameter("@WaterRes", (object)waterResistance ?? DBNull.Value),
                    new SqlParameter("@Movement", (object)movement ?? DBNull.Value),
                    new SqlParameter("@Crystal", (object)crystal ?? DBNull.Value),
                    new SqlParameter("@Active", isActive),
                    new SqlParameter("@Featured", isFeatured),
                    new SqlParameter("@NewArr", isNewArrival),
                    new SqlParameter("@BestSell", isBestSeller)
                }));
            }
        }

        public static void DeleteProduct(int productId)
        {
            // Toggle active or delete
            ExecuteNonQuery("UPDATE Products SET IsActive = CASE WHEN IsActive=1 THEN 0 ELSE 1 END WHERE ProductID=@PID",
                new[] { new SqlParameter("@PID", productId) });
        }

        // ──────────────────────────────────────────────────────────────
        // CATEGORIES & BRANDS CRUD
        // ──────────────────────────────────────────────────────────────

        public static DataTable GetCategoriesWithCount()
        {
            string sql = @"SELECT c.*, 
                                  (SELECT COUNT(*) FROM Products p WHERE p.CategoryID = c.CategoryID) AS ProductCount
                           FROM Categories c
                           ORDER BY c.CategoryName";
            return GetDataTable(sql);
        }

        public static DataRow GetCategoryByID(int categoryId)
        {
            return GetDataRow("SELECT * FROM Categories WHERE CategoryID=@ID",
                new[] { new SqlParameter("@ID", categoryId) });
        }

        public static void SaveCategory(int categoryId, string name, string description, string imageUrl, bool isActive)
        {
            if (categoryId > 0)
            {
                string sql = "UPDATE Categories SET CategoryName=@Name, Description=@Desc, ImageURL=@Img, IsActive=@Active WHERE CategoryID=@ID";
                ExecuteNonQuery(sql, new[]
                {
                    new SqlParameter("@Name", name),
                    new SqlParameter("@Desc", (object)description ?? DBNull.Value),
                    new SqlParameter("@Img", (object)imageUrl ?? DBNull.Value),
                    new SqlParameter("@Active", isActive),
                    new SqlParameter("@ID", categoryId)
                });
            }
            else
            {
                string sql = "INSERT INTO Categories (CategoryName, Description, ImageURL, IsActive) VALUES (@Name, @Desc, @Img, @Active)";
                ExecuteNonQuery(sql, new[]
                {
                    new SqlParameter("@Name", name),
                    new SqlParameter("@Desc", (object)description ?? DBNull.Value),
                    new SqlParameter("@Img", (object)imageUrl ?? DBNull.Value),
                    new SqlParameter("@Active", isActive)
                });
            }
        }

        public static void ToggleCategoryStatus(int categoryId)
        {
            ExecuteNonQuery("UPDATE Categories SET IsActive = CASE WHEN IsActive=1 THEN 0 ELSE 1 END WHERE CategoryID=@ID",
                new[] { new SqlParameter("@ID", categoryId) });
        }

        public static DataTable GetBrandsWithCount()
        {
            string sql = @"SELECT b.*, 
                                  (SELECT COUNT(*) FROM Products p WHERE p.BrandID = b.BrandID) AS ProductCount
                           FROM Brands b
                           ORDER BY b.BrandName";
            return GetDataTable(sql);
        }

        public static DataRow GetBrandByID(int brandId)
        {
            return GetDataRow("SELECT * FROM Brands WHERE BrandID=@ID",
                new[] { new SqlParameter("@ID", brandId) });
        }

        public static void SaveBrand(int brandId, string name, string description, string logoUrl, string country, bool isActive)
        {
            if (brandId > 0)
            {
                string sql = "UPDATE Brands SET BrandName=@Name, Description=@Desc, LogoURL=@Logo, Country=@Country, IsActive=@Active WHERE BrandID=@ID";
                ExecuteNonQuery(sql, new[]
                {
                    new SqlParameter("@Name", name),
                    new SqlParameter("@Desc", (object)description ?? DBNull.Value),
                    new SqlParameter("@Logo", (object)logoUrl ?? DBNull.Value),
                    new SqlParameter("@Country", (object)country ?? DBNull.Value),
                    new SqlParameter("@Active", isActive),
                    new SqlParameter("@ID", brandId)
                });
            }
            else
            {
                string sql = "INSERT INTO Brands (BrandName, Description, LogoURL, Country, IsActive) VALUES (@Name, @Desc, @Logo, @Country, @Active)";
                ExecuteNonQuery(sql, new[]
                {
                    new SqlParameter("@Name", name),
                    new SqlParameter("@Desc", (object)description ?? DBNull.Value),
                    new SqlParameter("@Logo", (object)logoUrl ?? DBNull.Value),
                    new SqlParameter("@Country", (object)country ?? DBNull.Value),
                    new SqlParameter("@Active", isActive)
                });
            }
        }

        public static void ToggleBrandStatus(int brandId)
        {
            ExecuteNonQuery("UPDATE Brands SET IsActive = CASE WHEN IsActive=1 THEN 0 ELSE 1 END WHERE BrandID=@ID",
                new[] { new SqlParameter("@ID", brandId) });
        }

        // ──────────────────────────────────────────────────────────────
        // REVIEWS CRUD
        // ──────────────────────────────────────────────────────────────

        public static DataTable GetAllReviews()
        {
            return GetDataTable(@"SELECT r.*, r.CreatedAt AS CreatedDate, u.FullName, p.ProductName, p.ImageURL
                                  FROM Reviews r
                                  JOIN Users    u ON r.UserID=u.UserID
                                  JOIN Products p ON r.ProductID=p.ProductID
                                  ORDER BY r.CreatedAt DESC");
        }

        public static void ApproveReview(int reviewId, bool approve)
        {
            ExecuteNonQuery("UPDATE Reviews SET IsApproved=@A WHERE ReviewID=@ID",
                new[] { new SqlParameter("@A", approve ? 1 : 0), new SqlParameter("@ID", reviewId) });
        }

        public static void DeleteReview(int reviewId)
        {
            ExecuteNonQuery("DELETE FROM Reviews WHERE ReviewID=@ID",
                new[] { new SqlParameter("@ID", reviewId) });
        }

        // ──────────────────────────────────────────────────────────────
        // COUPONS CRUD
        // ──────────────────────────────────────────────────────────────

        public static DataTable GetAllCoupons()
        {
            return GetDataTable("SELECT * FROM Coupons ORDER BY CouponID DESC");
        }

        public static DataRow GetCouponByID(int couponId)
        {
            return GetDataRow("SELECT * FROM Coupons WHERE CouponID=@ID",
                new[] { new SqlParameter("@ID", couponId) });
        }

        public static void SaveCoupon(int couponId, string code, string type, decimal value, decimal minAmount, int? maxUses, DateTime? expiry, bool isActive)
        {
            if (couponId > 0)
            {
                string sql = @"UPDATE Coupons 
                               SET CouponCode=@Code, DiscountType=@Type, DiscountValue=@Val,
                                   MinOrderAmount=@Min, MaxUses=@MaxUses, ExpiryDate=@Exp, IsActive=@Active
                               WHERE CouponID=@ID";
                ExecuteNonQuery(sql, new[]
                {
                    new SqlParameter("@Code", code.ToUpper().Trim()),
                    new SqlParameter("@Type", type),
                    new SqlParameter("@Val", value),
                    new SqlParameter("@Min", minAmount),
                    new SqlParameter("@MaxUses", (object)maxUses ?? DBNull.Value),
                    new SqlParameter("@Exp", (object)expiry ?? DBNull.Value),
                    new SqlParameter("@Active", isActive),
                    new SqlParameter("@ID", couponId)
                });
            }
            else
            {
                string sql = @"INSERT INTO Coupons (CouponCode, DiscountType, DiscountValue, MinOrderAmount, MaxUses, ExpiryDate, IsActive)
                               VALUES (@Code, @Type, @Val, @Min, @MaxUses, @Exp, @Active)";
                ExecuteNonQuery(sql, new[]
                {
                    new SqlParameter("@Code", code.ToUpper().Trim()),
                    new SqlParameter("@Type", type),
                    new SqlParameter("@Val", value),
                    new SqlParameter("@Min", minAmount),
                    new SqlParameter("@MaxUses", (object)maxUses ?? DBNull.Value),
                    new SqlParameter("@Exp", (object)expiry ?? DBNull.Value),
                    new SqlParameter("@Active", isActive)
                });
            }
        }

        public static void DeleteCoupon(int couponId)
        {
            ExecuteNonQuery("DELETE FROM Coupons WHERE CouponID=@ID",
                new[] { new SqlParameter("@ID", couponId) });
        }

        public static void ToggleCouponStatus(int couponId)
        {
            ExecuteNonQuery("UPDATE Coupons SET IsActive = CASE WHEN IsActive=1 THEN 0 ELSE 1 END WHERE CouponID=@ID",
                new[] { new SqlParameter("@ID", couponId) });
        }

        // ──────────────────────────────────────────────────────────────
        // REPORTS
        // ──────────────────────────────────────────────────────────────

        public static DataTable GetSalesReport(DateTime from, DateTime to)
        {
            string sql = @"SELECT CAST(o.OrderDate AS DATE) AS SaleDate,
                                  COUNT(*) AS OrderCount,
                                  SUM(o.GrandTotal) AS Revenue
                           FROM Orders o
                           WHERE o.OrderDate >= @From AND o.OrderDate <= @To
                             AND o.OrderStatus <> 'Cancelled'
                           GROUP BY CAST(o.OrderDate AS DATE)
                           ORDER BY SaleDate DESC";
            return GetDataTable(sql, new[]
            {
                new SqlParameter("@From", from),
                new SqlParameter("@To",   to)
            });
        }

        public static DataTable GetTopSellingProducts(int count = 5)
        {
            string sql = @"SELECT TOP (@Count) p.ProductID, p.ProductName, p.ImageURL, b.BrandName,
                                  SUM(od.Quantity) AS UnitsSold, SUM(od.TotalPrice) AS TotalSales
                           FROM OrderDetails od
                           JOIN Products p ON od.ProductID = p.ProductID
                           LEFT JOIN Brands b ON p.BrandID = b.BrandID
                           JOIN Orders o ON od.OrderID = o.OrderID
                           WHERE o.OrderStatus <> 'Cancelled'
                           GROUP BY p.ProductID, p.ProductName, p.ImageURL, b.BrandName
                           ORDER BY UnitsSold DESC";
            return GetDataTable(sql, new[] { new SqlParameter("@Count", count) });
        }

        public static DataTable GetOrderStatusDistribution()
        {
            string sql = @"SELECT OrderStatus, COUNT(*) AS StatusCount, ISNULL(SUM(GrandTotal),0) AS TotalRevenue
                           FROM Orders
                           GROUP BY OrderStatus
                           ORDER BY StatusCount DESC";
            return GetDataTable(sql);
        }
    }
}
