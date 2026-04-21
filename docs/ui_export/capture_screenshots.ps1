#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# RiLyBricoule — ADB Screenshot Capture Script
# ═══════════════════════════════════════════════════════════════
# 
# USAGE (PowerShell):
#   .\docs\ui_export\capture_screenshots.ps1
#
# Requirements: ADB installed, device connected
# This script is a GUIDE — run it manually, pausing between
# screenshots to navigate to each screen on your phone.
# ═══════════════════════════════════════════════════════════════

# ─── Instructions ─────────────────────────────────────────────
# 1. Run the app: flutter run -d R58M67Y3F1Y
# 2. Navigate to each screen on your phone
# 3. For each screen, run: flutter screenshot --out=docs/ui_export/screenshots/XXX_name.png
# ─────────────────────────────────────────────────────────────

Write-Host "═══ RiLyBricoule Screenshot Capture ═══" -ForegroundColor Cyan
Write-Host ""
Write-Host "Step 1: Make sure your app is running on the device" -ForegroundColor Yellow
Write-Host "Step 2: Navigate to each screen and press Enter to capture" -ForegroundColor Yellow
Write-Host ""

$screenshotDir = "docs\ui_export\screenshots"

$screens = @(
    @{ Name = "001_splash"; Desc = "Splash Screen (launch app)" }
    @{ Name = "002_welcome"; Desc = "Welcome Screen" }
    @{ Name = "003_login"; Desc = "Login Screen" }
    @{ Name = "004_register"; Desc = "Register Screen" }
    @{ Name = "005_forgot_password"; Desc = "Forgot Password" }
    @{ Name = "006_home"; Desc = "Home (tab 0)" }
    @{ Name = "007_search_list"; Desc = "Search List (tab 1)" }
    @{ Name = "008_search_map"; Desc = "Search Map" }
    @{ Name = "009_filters"; Desc = "Filters Bottom Sheet" }
    @{ Name = "010_reservations_upcoming"; Desc = "Reservations Upcoming (tab 2)" }
    @{ Name = "011_reservations_ongoing"; Desc = "Reservations Ongoing" }
    @{ Name = "012_reservations_completed"; Desc = "Reservations Completed" }
    @{ Name = "013_reservations_cancelled"; Desc = "Reservations Cancelled" }
    @{ Name = "014_reservations_empty"; Desc = "Reservations Empty State" }
    @{ Name = "015_conversation_list"; Desc = "Conversation List (tab 3)" }
    @{ Name = "016_conversation_list_empty"; Desc = "Conversation List Empty" }
    @{ Name = "017_profile"; Desc = "Profile (tab 4)" }
    @{ Name = "018_notifications_list"; Desc = "Notifications List" }
    @{ Name = "019_notifications_empty"; Desc = "Notifications Empty" }
    @{ Name = "020_all_categories"; Desc = "All Categories" }
    @{ Name = "021_sort_bottom_sheet"; Desc = "Sort Bottom Sheet" }
    @{ Name = "022_provider_profile"; Desc = "Provider Profile" }
    @{ Name = "023_all_services"; Desc = "All Services (provider)" }
    @{ Name = "024_all_reviews"; Desc = "All Reviews (provider)" }
    @{ Name = "025_booking_date_time"; Desc = "Booking: Date/Time + Address" }
    @{ Name = "026_booking_summary"; Desc = "Booking: Summary" }
    @{ Name = "027_booking_payment"; Desc = "Booking: Payment" }
    @{ Name = "028_booking_status"; Desc = "Booking: Confirmation" }
    @{ Name = "029_reservation_details"; Desc = "Reservation Details / Timeline" }
    @{ Name = "030_leave_review"; Desc = "Leave Review" }
    @{ Name = "031_invoice"; Desc = "Invoice" }
    @{ Name = "032_chat_thread"; Desc = "Chat Thread" }
    @{ Name = "033_edit_profile"; Desc = "Edit Profile" }
    @{ Name = "034_payment_methods"; Desc = "Payment Methods" }
    @{ Name = "035_add_payment_method"; Desc = "Add Payment Method" }
    @{ Name = "036_payment_policy_info"; Desc = "Payment Policy Info" }
    @{ Name = "037_favorites"; Desc = "Favorites" }
    @{ Name = "038_language"; Desc = "Language Bottom Sheet" }
    @{ Name = "039_help"; Desc = "Help Center" }
    @{ Name = "040_about"; Desc = "About" }
    @{ Name = "041_discover_swipe"; Desc = "Discover Swipe" }
    @{ Name = "042_provider_dashboard"; Desc = "Provider Dashboard" }
    @{ Name = "043_provider_services"; Desc = "Provider Services" }
    @{ Name = "044_provider_bookings"; Desc = "Provider Bookings" }
    @{ Name = "045_provider_planning"; Desc = "Provider Planning" }
    @{ Name = "046_provider_chat_list"; Desc = "Provider Chat List" }
    @{ Name = "047_provider_chat_thread"; Desc = "Provider Chat Thread" }
    @{ Name = "048_provider_notifications"; Desc = "Provider Notifications" }
    @{ Name = "049_provider_earnings"; Desc = "Provider Earnings" }
    @{ Name = "050_provider_reviews"; Desc = "Provider Reviews" }
    @{ Name = "051_provider_profile_self"; Desc = "Provider Profile (self)" }
    @{ Name = "052_provider_edit_profile"; Desc = "Provider Edit Profile" }
    @{ Name = "053_provider_settings"; Desc = "Provider Settings" }
    @{ Name = "054_provider_mission_details"; Desc = "Provider Mission Details" }
    @{ Name = "055_provider_drawer"; Desc = "Provider Drawer" }
)

$captured = 0
foreach ($screen in $screens) {
    $num = $captured + 1
    Write-Host ""
    Write-Host "[$num/55] Navigate to: $($screen.Desc)" -ForegroundColor Green
    $key = Read-Host "Press Enter to capture (or 's' to skip)"
    
    if ($key -ne 's') {
        $outPath = "$screenshotDir\$($screen.Name).png"
        flutter screenshot --out=$outPath -d R58M67Y3F1Y
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✅ Saved: $outPath" -ForegroundColor Green
            $captured++
        } else {
            Write-Host "  ❌ Failed to capture" -ForegroundColor Red
        }
    } else {
        Write-Host "  ⏭️ Skipped" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "═══ Done! $captured/$($screens.Count) screenshots captured ═══" -ForegroundColor Cyan
Write-Host "Output: $screenshotDir" -ForegroundColor Cyan
