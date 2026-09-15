using System;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.SessionState;

namespace CYPHER.App_Code
{
    /// <summary>
    /// Manages user and admin sessions, authentication, and password hashing.
    /// </summary>
    public static class SessionHelper
    {
        // ── Session Key Constants ───────────────────────────────────
        private const string KEY_USER_ID    = "UserID";
        private const string KEY_USER_NAME  = "UserName";
        private const string KEY_USER_EMAIL = "UserEmail";
        private const string KEY_IS_LOGGED  = "IsLoggedIn";
        private const string KEY_ADMIN_ID   = "AdminID";
        private const string KEY_ADMIN_NAME = "AdminName";
        private const string KEY_IS_ADMIN   = "IsAdminLoggedIn";
        private const string KEY_CART_COUNT = "CartCount";

        // ── User Session ─────────────────────────────────────────────

        /// <summary>Saves user info in session after successful login.</summary>
        public static void LoginUser(int userId, string name, string email)
        {
            var session = HttpContext.Current.Session;
            session[KEY_USER_ID]    = userId;
            session[KEY_USER_NAME]  = name;
            session[KEY_USER_EMAIL] = email;
            session[KEY_IS_LOGGED]  = true;
        }

        /// <summary>Clears user session data and redirects to login.</summary>
        public static void LogoutUser()
        {
            var session = HttpContext.Current.Session;
            session.Remove(KEY_USER_ID);
            session.Remove(KEY_USER_NAME);
            session.Remove(KEY_USER_EMAIL);
            session.Remove(KEY_IS_LOGGED);
            session.Remove(KEY_CART_COUNT);
        }

        public static bool IsUserLoggedIn
        {
            get
            {
                return HttpContext.Current.Session[KEY_IS_LOGGED] != null
                       && (bool)HttpContext.Current.Session[KEY_IS_LOGGED];
            }
        }

        public static int CurrentUserID
        {
            get { return IsUserLoggedIn ? (int)HttpContext.Current.Session[KEY_USER_ID] : 0; }
        }

        public static string CurrentUserName
        {
            get { return IsUserLoggedIn ? (string)HttpContext.Current.Session[KEY_USER_NAME] : string.Empty; }
        }

        public static string CurrentUserEmail
        {
            get { return IsUserLoggedIn ? (string)HttpContext.Current.Session[KEY_USER_EMAIL] : string.Empty; }
        }

        // ── Admin Session ────────────────────────────────────────────

        public static void LoginAdmin(int adminId, string adminName)
        {
            var session = HttpContext.Current.Session;
            session[KEY_ADMIN_ID]   = adminId;
            session[KEY_ADMIN_NAME] = adminName;
            session[KEY_IS_ADMIN]   = true;
        }

        public static void LogoutAdmin()
        {
            var session = HttpContext.Current.Session;
            session.Remove(KEY_ADMIN_ID);
            session.Remove(KEY_ADMIN_NAME);
            session.Remove(KEY_IS_ADMIN);
        }

        public static bool IsAdminLoggedIn
        {
            get
            {
                return HttpContext.Current.Session[KEY_IS_ADMIN] != null
                       && (bool)HttpContext.Current.Session[KEY_IS_ADMIN];
            }
        }

        public static int CurrentAdminID
        {
            get { return IsAdminLoggedIn ? (int)HttpContext.Current.Session[KEY_ADMIN_ID] : 0; }
        }

        public static string CurrentAdminName
        {
            get { return IsAdminLoggedIn ? (string)HttpContext.Current.Session[KEY_ADMIN_NAME] : string.Empty; }
        }

        // ── Cart Count ───────────────────────────────────────────────

        public static void SetCartCount(int count)
        {
            HttpContext.Current.Session[KEY_CART_COUNT] = count;
        }

        public static int GetCartCount()
        {
            var val = HttpContext.Current.Session[KEY_CART_COUNT];
            return val != null ? (int)val : 0;
        }

        public static void RefreshCartCount()
        {
            if (IsUserLoggedIn)
                SetCartCount(DBHelper.GetCartCount(CurrentUserID));
        }

        // ── Page Guards ──────────────────────────────────────────────

        /// <summary>Redirects to login if user is not authenticated.</summary>
        public static void RequireUserLogin(string returnUrl = null)
        {
            if (!IsUserLoggedIn)
            {
                string url = "~/Pages/Login.aspx";
                if (!string.IsNullOrEmpty(returnUrl))
                    url += "?ReturnUrl=" + HttpUtility.UrlEncode(returnUrl);
                HttpContext.Current.Response.Redirect(url, true);
            }
        }

        /// <summary>Redirects to admin login if admin is not authenticated.</summary>
        public static void RequireAdminLogin()
        {
            if (!IsAdminLoggedIn)
                HttpContext.Current.Response.Redirect("~/Admin/AdminLogin.aspx", true);
        }

        // ── Password Hashing ─────────────────────────────────────────

        /// <summary>Hashes a password using SHA-256. In production, use bcrypt.</summary>
        public static string HashPassword(string plainText)
        {
            if (string.IsNullOrEmpty(plainText)) return string.Empty;
            using (var sha = SHA256.Create())
            {
                byte[] bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(plainText));
                var sb = new StringBuilder();
                foreach (byte b in bytes)
                    sb.Append(b.ToString("x2"));
                return sb.ToString();
            }
        }

        /// <summary>Verifies a password against a stored hash.</summary>
        public static bool VerifyPassword(string plainText, string storedHash)
        {
            return HashPassword(plainText).Equals(storedHash, StringComparison.OrdinalIgnoreCase);
        }

        // ── Utility ──────────────────────────────────────────────────

        /// <summary>Generates a random order reference number.</summary>
        public static string GenerateOrderRef()
        {
            return "CYP" + DateTime.Now.ToString("yyMMdd") + new Random().Next(1000, 9999).ToString();
        }
    }
}
