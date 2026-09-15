using System;
using System.Configuration;
using System.Net;
using System.Net.Mail;

namespace CYPHER.App_Code
{
    /// <summary>
    /// Email helper using SMTP configuration from Web.config.
    /// All methods are safe to call — they fail silently if SMTP is not configured.
    /// </summary>
    public static class EmailHelper
    {
        private static readonly string _host = ConfigurationManager.AppSettings["SmtpHost"];
        private static readonly int    _port = int.Parse(ConfigurationManager.AppSettings["SmtpPort"] ?? "587");
        private static readonly string _user = ConfigurationManager.AppSettings["SmtpUser"];
        private static readonly string _pass = ConfigurationManager.AppSettings["SmtpPass"];
        private static readonly bool   _ssl  = bool.Parse(ConfigurationManager.AppSettings["SmtpSSL"] ?? "true");
        private static readonly string _from = ConfigurationManager.AppSettings["SiteEmail"];

        /// <summary>Sends an order confirmation email to the customer.</summary>
        public static void SendOrderConfirmation(string toEmail, string toName,
            int orderId, decimal grandTotal)
        {
            string subject = string.Format("CYPHER — Order #{0} Confirmed!", orderId);
            string body = string.Format(@"
                <html><body style='font-family:Arial,sans-serif;color:#333;'>
                <div style='max-width:600px;margin:auto;border:1px solid #C9A84C;padding:30px;'>
                  <h2 style='color:#C9A84C;'>CYPHER Watches</h2>
                  <p>Dear {0},</p>
                  <p>Thank you for your order! Your order has been confirmed.</p>
                  <table style='width:100%;border-collapse:collapse;'>
                    <tr><td><strong>Order ID:</strong></td><td>#{1}</td></tr>
                    <tr><td><strong>Grand Total:</strong></td><td>₹{2:N2}</td></tr>
                    <tr><td><strong>Status:</strong></td><td>Processing</td></tr>
                    <tr><td><strong>Est. Delivery:</strong></td><td>{3:dd MMM yyyy}</td></tr>
                  </table>
                  <p>We will notify you when your order is shipped.</p>
                  <p style='color:#888;font-size:12px;'>CYPHER Watches | support@cypherwatch.com</p>
                </div>
                </body></html>", toName, orderId, grandTotal, DateTime.Now.AddDays(7));
            SendEmail(toEmail, subject, body);
        }

        /// <summary>Sends a password reset link (placeholder — link generation not implemented).</summary>
        public static void SendPasswordResetEmail(string toEmail, string resetToken)
        {
            string subject = "CYPHER — Password Reset Request";
            string resetLink = string.Format("https://yoursite.com/Pages/ResetPassword.aspx?token={0}", resetToken);
            string body = string.Format(@"
                <html><body style='font-family:Arial,sans-serif;color:#333;'>
                <div style='max-width:600px;margin:auto;border:1px solid #C9A84C;padding:30px;'>
                  <h2 style='color:#C9A84C;'>CYPHER Watches</h2>
                  <p>We received a request to reset your password.</p>
                  <p><a href='{0}' style='background:#C9A84C;color:#000;padding:10px 20px;
                     text-decoration:none;border-radius:4px;'>Reset Password</a></p>
                  <p>This link expires in 24 hours. If you did not request a reset, ignore this email.</p>
                </div>
                </body></html>", resetLink);
            SendEmail(toEmail, subject, body);
        }

        /// <summary>Sends a newsletter welcome email.</summary>
        public static void SendNewsletterWelcome(string toEmail)
        {
            string subject = "Welcome to CYPHER Newsletter!";
            string body = @"
                <html><body style='font-family:Arial,sans-serif;color:#333;'>
                <div style='max-width:600px;margin:auto;border:1px solid #C9A84C;padding:30px;'>
                  <h2 style='color:#C9A84C;'>CYPHER Watches</h2>
                  <p>Thank you for subscribing to our newsletter!</p>
                  <p>Stay tuned for exclusive offers, new arrivals, and luxury watch news.</p>
                  <p style='color:#888;font-size:12px;'>CYPHER Watches | support@cypherwatch.com</p>
                </div>
                </body></html>";
            SendEmail(toEmail, subject, body);
        }

        // ── Core Send Method ─────────────────────────────────────────

        private static void SendEmail(string to, string subject, string htmlBody)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(_user) || _user == "your-email@gmail.com")
                    return; // SMTP not configured — skip silently

                using (var smtp = new SmtpClient(_host, _port))
                {
                    smtp.Credentials = new NetworkCredential(_user, _pass);
                    smtp.EnableSsl   = _ssl;

                    using (var msg = new MailMessage())
                    {
                        msg.From       = new MailAddress(_from, "CYPHER Watches");
                        msg.To.Add(to);
                        msg.Subject    = subject;
                        msg.Body       = htmlBody;
                        msg.IsBodyHtml = true;
                        smtp.Send(msg);
                    }
                }
            }
            catch (Exception ex)
            {
                // Log but do not crash the application
                System.Diagnostics.Trace.TraceError("EmailHelper.SendEmail error: " + ex.Message);
            }
        }
    }
}
