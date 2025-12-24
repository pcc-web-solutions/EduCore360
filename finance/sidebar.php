<?php require_once __DIR__."/uac.php"; ?>
<div class="left-side-menu">
    <div class="slimscroll-menu">
        <div id="sidebar-menu">
            <ul class="metismenu" id="side-menu">   
                <li>
                    <a href="javascript: void(0);">
                        <i class="fas fa-cog"></i>
                        <span>Settings</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("finance/coa.php"); ?>">Chart of Accounts</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("finance/charge.php"); ?>">Set Up Charges</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("finance/tax_rate.php"); ?>">Set Up Tax Rates</a></li>
                    </ul>
                </li>
                <li>
                    <a href="javascript: void(0);">
                        <i class="fas fa-pie-chart"></i>
                        <span>Sales</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("finance/receipt.php"); ?>">Sales Receipts</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("finance/invoice.php"); ?>">Sales Invoices</a></li>
                    </ul>
                </li>
                <li>
                    <a href="javascript: void(0);">
                        <i class="fas fa-dollar"></i>
                        <span>Payments</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("finance/bill.php"); ?>">Company Bills</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("finance/salary.php"); ?>">Employee Salaries</a></li>
                    </ul>
                </li>
            </ul>
        </div>
        <div class="clearfix"></div>
    </div>
</div>