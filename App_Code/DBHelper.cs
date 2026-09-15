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
            string sql = @"SELECT r.*, u.FullName FROM Reviews r
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
        // ADMIN — DASHBOARD STATS
        // ──────────────────────────────────────────────────────────────

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
                    (SELECT COUNT(*) FROM Reviews WHERE IsApproved=0)  AS PendingReviews";
            return GetDataTable(sql);
        }

        public static DataTable GetAllOrders(int pageIndex = 0, int pageSize = 20)
        {
            string sql = @"SELECT o.*, u.FullName, u.Email
                           FROM Orders o JOIN Users u ON o.UserID=u.UserID
                           ORDER BY o.OrderDate DESC
                           OFFSET @Off ROWS FETCH NEXT @PS ROWS ONLY";
            return GetDataTable(sql, new[]
            {
                new SqlParameter("@Off", pageIndex * pageSize),
                new SqlParameter("@PS",  pageSize)
            });
        }

        public static DataTable GetAllUsers()
        {
            return GetDataTable("SELECT * FROM Users ORDER BY CreatedAt DESC");
        }

        public static DataTable GetAllProducts()
        {
            return GetDataTable(@"SELECT p.*, b.BrandName, c.CategoryName
                                  FROM Products p
                                  JOIN Brands b ON p.BrandID=b.BrandID
                                  JOIN Categories c ON p.CategoryID=c.CategoryID
                                  ORDER BY p.CreatedAt DESC");
        }

        public static void UpdateOrderStatus(int orderId, string status)
        {
            ExecuteNonQuery("UPDATE Orders SET OrderStatus=@S WHERE OrderID=@ID",
                new[] { new SqlParameter("@S", status), new SqlParameter("@ID", orderId) });
        }

        public static DataTable GetAllReviews()
        {
            return GetDataTable(@"SELECT r.*, u.FullName, p.ProductName
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

        public static DataTable GetSalesReport(DateTime from, DateTime to)
        {
            string sql = @"SELECT CAST(o.OrderDate AS DATE) AS SaleDate,
                                  COUNT(*) AS OrderCount,
                                  SUM(o.GrandTotal) AS Revenue
                           FROM Orders o
                           WHERE o.OrderDate >= @From AND o.OrderDate <= @To
                             AND o.OrderStatus <> 'Cancelled'
                           GROUP BY CAST(o.OrderDate AS DATE)
                           ORDER BY SaleDate";
            return GetDataTable(sql, new[]
            {
                new SqlParameter("@From", from),
                new SqlParameter("@To",   to)
            });
        }
    }
}
