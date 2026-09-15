using System;
using System.Web;
using System.Web.SessionState;

namespace CYPHER
{
    /// <summary>
    /// Global Application class — handles application-level events.
    /// </summary>
    public class Global : HttpApplication
    {
        /// <summary>Fires once when the application starts.</summary>
        protected void Application_Start(object sender, EventArgs e)
        {
            // Application startup logic
        }

        /// <summary>Fires at the start of every request.</summary>
        protected void Application_BeginRequest(object sender, EventArgs e)
        {
            // Optional: enforce HTTPS, set culture, etc.
        }

        /// <summary>Fires when a new session starts.</summary>
        protected void Session_Start(object sender, EventArgs e)
        {
            // Initialize session-level defaults (e.g., empty cart)
            if (Session["CartCount"] == null)
                Session["CartCount"] = 0;
        }

        /// <summary>Fires when an unhandled error occurs.</summary>
        protected void Application_Error(object sender, EventArgs e)
        {
            Exception ex = Server.GetLastError();
            if (ex != null)
            {
                // Log to Application event log in production
                System.Diagnostics.Trace.TraceError("Unhandled error: " + ex.Message);
            }
        }

        /// <summary>Fires when a session ends (timeout or abandon).</summary>
        protected void Session_End(object sender, EventArgs e)
        {
            // Cleanup session resources if needed
        }

        /// <summary>Fires when the application shuts down.</summary>
        protected void Application_End(object sender, EventArgs e)
        {
            // Cleanup application resources
        }
    }
}
