<%@ Page Title="Watches Catalog" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeBehind="Products.aspx.cs" Inherits="CYPHER.Admin.Products" %>

<asp:Content ID="PageTitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    Watches Catalog
</asp:Content>

<asp:Content ID="PageHeaderContent" ContentPlaceHolderID="PageHeaderContent" runat="server">
    <div class="d-flex align-items-center justify-content-between w-100">
        <div>
            <span>Timepieces Inventory</span>
            <span class="badge ms-2" style="background: rgba(201,168,76,0.15); color: var(--admin-gold); font-size: 0.72rem;">
                <asp:Literal ID="litTotalCount" runat="server">0</asp:Literal> Items
            </span>
        </div>
    </div>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <!-- ── ALERT FEEDBACK ── -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false">
        <div class="admin-alert <%= AlertCssClass %>">
            <i class="fas <%= AlertIconClass %>"></i>
            <div><asp:Label ID="lblAlert" runat="server" /></div>
        </div>
    </asp:Panel>

    <!-- ── ADD / EDIT PRODUCT PANEL ── -->
    <asp:Panel ID="pnlEditProduct" runat="server" Visible="false" CssClass="admin-form-card border-gold">
        <div class="d-flex align-items-center justify-content-between mb-4 pb-2 border-bottom border-secondary border-opacity-25">
            <h4 style="font-family:'Cormorant Garamond',serif; color:var(--admin-gold); font-size:1.6rem; margin:0;">
                <asp:Literal ID="litFormTitle" runat="server">Add New Timepiece</asp:Literal>
            </h4>
            <asp:LinkButton ID="btnCloseForm" runat="server" OnClick="btnCloseForm_Click" CssClass="btn-admin-icon" ToolTip="Close Form">
                <i class="fas fa-times"></i>
            </asp:LinkButton>
        </div>

        <asp:HiddenField ID="hdnProductID" runat="server" Value="0" />

        <div class="admin-form">
            <div class="row g-3">
                <!-- Product Name -->
                <div class="col-md-6">
                    <label>Watch Model / Name *</label>
                    <asp:TextBox ID="txtProductName" runat="server" CssClass="form-control" placeholder="e.g. Submariner Date 41mm" required="required" />
                </div>

                <!-- Brand -->
                <div class="col-md-3">
                    <label>Brand *</label>
                    <asp:DropDownList ID="ddlBrand" runat="server" CssClass="form-select" />
                </div>

                <!-- Category -->
                <div class="col-md-3">
                    <label>Category *</label>
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select" />
                </div>

                <!-- Pricing & Stock -->
                <div class="col-md-4">
                    <label>Retail Price (&#8377;) *</label>
                    <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" TextMode="Number" step="0.01" placeholder="950000" required="required" />
                </div>

                <div class="col-md-4">
                    <label>Discount Percentage (%)</label>
                    <asp:TextBox ID="txtDiscount" runat="server" CssClass="form-control" TextMode="Number" step="0.1" placeholder="0" />
                </div>

                <div class="col-md-4">
                    <label>Stock Units in Vault *</label>
                    <asp:TextBox ID="txtStock" runat="server" CssClass="form-control" TextMode="Number" placeholder="5" required="required" />
                </div>

                <!-- Specs -->
                <div class="col-md-3">
                    <label>Movement</label>
                    <asp:TextBox ID="txtMovement" runat="server" CssClass="form-control" placeholder="e.g. Calibre 3235 Automatic" />
                </div>

                <div class="col-md-3">
                    <label>Gender</label>
                    <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-select">
                        <asp:ListItem Value="Unisex">Unisex</asp:ListItem>
                        <asp:ListItem Value="Men">Men</asp:ListItem>
                        <asp:ListItem Value="Women">Women</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="col-md-3">
                    <label>Case Diameter</label>
                    <asp:TextBox ID="txtCaseDiam" runat="server" CssClass="form-control" placeholder="e.g. 41mm" />
                </div>

                <div class="col-md-3">
                    <label>Water Resistance</label>
                    <asp:TextBox ID="txtWaterRes" runat="server" CssClass="form-control" placeholder="e.g. 300m / 1000ft" />
                </div>

                <div class="col-md-4">
                    <label>Case Material / Color</label>
                    <asp:TextBox ID="txtCaseColor" runat="server" CssClass="form-control" placeholder="e.g. Oystersteel / Black Dial" />
                </div>

                <div class="col-md-4">
                    <label>Strap Material</label>
                    <asp:TextBox ID="txtStrap" runat="server" CssClass="form-control" placeholder="e.g. Oyster Stainless Steel" />
                </div>

                <div class="col-md-4">
                    <label>Crystal Type</label>
                    <asp:TextBox ID="txtCrystal" runat="server" CssClass="form-control" placeholder="e.g. Scratch-resistant Sapphire" />
                </div>

                <!-- Images -->
                <div class="col-md-8">
                    <label>Primary Watch Image URL *</label>
                    <asp:TextBox ID="txtImageUrl" runat="server" CssClass="form-control" placeholder="/Content/images/watches/watch_rolex_submariner.jpg" />
                </div>

                <div class="col-md-4 d-flex align-items-center">
                    <div style="font-size:0.75rem; color:#888;">
                        <i class="fas fa-info-circle text-warning me-1"></i> You can use paths like <code>/Content/images/watches/watch_*.jpg</code> or full HTTP image URLs.
                    </div>
                </div>

                <!-- Description -->
                <div class="col-12">
                    <label>Watch Description & Heritage</label>
                    <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" placeholder="Detailed description of craftsmanship, heritage, and specifications..." />
                </div>

                <!-- Flags -->
                <div class="col-12">
                    <label class="mb-2">Merchandising & Visibility Flags</label>
                    <div class="d-flex flex-wrap gap-4 p-3 rounded" style="background:#111; border:1px solid rgba(255,255,255,0.06);">
                        <label class="d-flex align-items-center gap-2" style="cursor:pointer; margin:0; text-transform:none; color:#DDD;">
                            <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" />
                            <span><strong>Active in Store</strong> (Publicly Visible)</span>
                        </label>
                        <label class="d-flex align-items-center gap-2" style="cursor:pointer; margin:0; text-transform:none; color:#DDD;">
                            <asp:CheckBox ID="chkIsFeatured" runat="server" />
                            <span>Featured Showcase</span>
                        </label>
                        <label class="d-flex align-items-center gap-2" style="cursor:pointer; margin:0; text-transform:none; color:#DDD;">
                            <asp:CheckBox ID="chkIsNewArrival" runat="server" />
                            <span>New Arrival</span>
                        </label>
                        <label class="d-flex align-items-center gap-2" style="cursor:pointer; margin:0; text-transform:none; color:#DDD;">
                            <asp:CheckBox ID="chkIsBestSeller" runat="server" />
                            <span>Best Seller</span>
                        </label>
                    </div>
                </div>

                <!-- Actions -->
                <div class="col-12 d-flex justify-content-end gap-2 mt-4 pt-3 border-top border-secondary border-opacity-25">
                    <asp:Button ID="btnCancelEdit" runat="server" Text="Cancel" OnClick="btnCloseForm_Click" CssClass="btn-admin-secondary" CausesValidation="false" />
                    <asp:Button ID="btnSaveProduct" runat="server" Text="Save Timepiece" OnClick="btnSaveProduct_Click" CssClass="btn-admin-primary" />
                </div>
            </div>
        </div>
    </asp:Panel>

    <!-- ── SEARCH & FILTER TOOLBAR ── -->
    <div class="admin-toolbar">
        <div class="admin-toolbar-left">
            <!-- Search -->
            <div class="admin-input-group" style="min-width: 240px;">
                <i class="fas fa-search"></i>
                <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search by model or brand..." />
            </div>

            <!-- Brand Filter -->
            <asp:DropDownList ID="ddlFilterBrand" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged" style="max-width:180px;" />

            <!-- Category Filter -->
            <asp:DropDownList ID="ddlFilterCategory" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged" style="max-width:180px;" />

            <!-- Stock Filter -->
            <asp:DropDownList ID="ddlFilterStock" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged" style="max-width:160px;">
                <asp:ListItem Value="all">All Inventory</asp:ListItem>
                <asp:ListItem Value="in">In Stock (>5)</asp:ListItem>
                <asp:ListItem Value="low">Low Stock (&#8804;5)</asp:ListItem>
                <asp:ListItem Value="out">Out of Stock (0)</asp:ListItem>
            </asp:DropDownList>

            <asp:Button ID="btnSearch" runat="server" Text="Filter" OnClick="btnSearch_Click" CssClass="btn-admin-outline" />
            <asp:Button ID="btnResetFilter" runat="server" Text="Reset" OnClick="btnResetFilter_Click" CssClass="btn-admin-secondary" />
        </div>

        <div>
            <asp:LinkButton ID="btnShowAddProduct" runat="server" OnClick="btnShowAddProduct_Click" CssClass="btn-admin-primary">
                <i class="fas fa-plus-circle"></i> Add New Timepiece
            </asp:LinkButton>
        </div>
    </div>

    <!-- ── PRODUCTS DATA TABLE ── -->
    <div class="admin-table-card mt-0">
        <div class="table-responsive">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th style="width: 70px;">Watch</th>
                        <th>Model Details</th>
                        <th>Brand & Category</th>
                        <th>Pricing</th>
                        <th>Inventory</th>
                        <th>Merchandising</th>
                        <th>Status</th>
                        <th style="text-align:right;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptProducts" runat="server" OnItemCommand="rptProducts_ItemCommand">
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <img src="<%# ResolveUrl(Eval("ImageURL") != DBNull.Value && !string.IsNullOrEmpty(Eval("ImageURL").ToString()) ? Eval("ImageURL").ToString() : "~/Content/images/watches/watch_hero.jpg") %>" class="admin-thumb" alt="Watch" />
                                </td>
                                <td>
                                    <div style="font-weight:600; color:#FFF; font-size:0.9rem;">
                                        <%# Eval("ProductName") %>
                                    </div>
                                    <div style="font-size:0.75rem; color:#888;">
                                        ID: #<%# Eval("ProductID") %> &bull; <%# Eval("Movement") %> &bull; <%# Eval("CaseDiameter") %>
                                    </div>
                                </td>
                                <td>
                                    <div style="color:var(--admin-gold); font-weight:500;"><%# Eval("BrandName") %></div>
                                    <div style="font-size:0.75rem; color:#777;"><%# Eval("CategoryName") %></div>
                                </td>
                                <td>
                                    <div style="font-weight:600; color:#FFF;">
                                        &#8377;<%# Convert.ToDecimal(Eval("Price")).ToString("N0") %>
                                    </div>
                                    <%# Convert.ToDecimal(Eval("DiscountPercent")) > 0 ? "<span style='font-size:0.72rem; color:#2ecc71;'>" + Eval("DiscountPercent") + "% OFF</span>" : "" %>
                                </td>
                                <td>
                                    <span class="stock-badge <%# Convert.ToInt32(Eval("StockQuantity")) == 0 ? "out-stock" : (Convert.ToInt32(Eval("StockQuantity")) <= 5 ? "low-stock" : "in-stock") %>">
                                        <%# Eval("StockQuantity") %> in vault
                                    </span>
                                </td>
                                <td>
                                    <div class="d-flex flex-wrap gap-1">
                                        <%# Convert.ToBoolean(Eval("IsFeatured")) ? "<span class='badge bg-warning text-dark' style='font-size:0.65rem;'>Featured</span>" : "" %>
                                        <%# Convert.ToBoolean(Eval("IsNewArrival")) ? "<span class='badge bg-info text-dark' style='font-size:0.65rem;'>New</span>" : "" %>
                                        <%# Convert.ToBoolean(Eval("IsBestSeller")) ? "<span class='badge bg-success' style='font-size:0.65rem;'>Best Seller</span>" : "" %>
                                    </div>
                                </td>
                                <td>
                                    <span class="status-badge <%# Convert.ToBoolean(Eval("IsActive")) ? "active" : "inactive" %>">
                                        <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Archived" %>
                                    </span>
                                </td>
                                <td style="text-align:right;">
                                    <div class="d-flex justify-content-end gap-1">
                                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditProduct" CommandArgument='<%# Eval("ProductID") %>' CssClass="btn-admin-icon" ToolTip="Edit Timepiece">
                                            <i class="fas fa-edit"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnToggle" runat="server" CommandName="ToggleActive" CommandArgument='<%# Eval("ProductID") %>' CssClass="btn-admin-icon" ToolTip="Toggle Visibility / Archive">
                                            <i class="fas <%# Convert.ToBoolean(Eval("IsActive")) ? "fa-eye-slash" : "fa-eye" %>"></i>
                                        </asp:LinkButton>
                                    </div>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                    <% if (rptProducts.Items.Count == 0) { %>
                        <tr>
                            <td colspan="8" class="text-center py-5" style="color:#777;">
                                <i class="fas fa-clock fa-2x mb-2" style="color:var(--admin-gold); opacity:0.5;"></i><br />
                                No timepieces match your current filters.
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</asp:Content>
