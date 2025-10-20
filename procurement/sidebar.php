<?php require_once __DIR__."/uac.php"; ?>
<div class="left-side-menu">
    <div class="slimscroll-menu">
        <div id="sidebar-menu">
            <ul class="metismenu" id="side-menu">   
                <li>
                    <a href="javascript: void(0);">
                        <i class="far fa-folder"></i>
                        <span>Setups</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("procurement/base_uom.php"); ?>">Base Unit Of Measure</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("procurement/item_uom.php"); ?>">Item Unit Of Measure</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("procurement/stock_item.php"); ?>">Stock Items List</a></li>
                    </ul>
                </li>
                <li>
                    <a href="javascript: void(0);">
                        <i class="far fa-folder"></i>
                        <span>Documents</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("procurement/transfer_order.php"); ?>">Transfer Orders</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("procurement/store_requisition.php"); ?>">Store Requisitions</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("procurement/purchase_requisition.php"); ?>">Purchase Requisitions</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("procurement/purchase_order.php"); ?>">Purchase Orders</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("procurement/delivery_note.php"); ?>">Order Delivery Notes</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("procurement/delivery_invoice.php"); ?>">Delivery Invoices</a></li>
                    </ul>
                </li>
                <li>
                    <a href="javascript: void(0);">
                        <i class="far fa-folder"></i>
                        <span>Reports</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("procurement/s11.php"); ?>">Form S11</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("procurement/s13.php"); ?>">Form S13</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("procurement/s16.php"); ?>">Form S16</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("procurement/s19.php"); ?>">Form S19</a></li>
                    </ul>
                </li>
            </ul>
        </div>
        <div class="clearfix"></div>
    </div>
</div>