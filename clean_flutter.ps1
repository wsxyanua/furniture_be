Write-Host "="*70 -ForegroundColor Cyan
Write-Host "XÓA CACHE VÀ REBUILD FLUTTER APP" -ForegroundColor Yellow
Write-Host "="*70 -ForegroundColor Cyan

Write-Host "`n Chuyển đến thư mục Flutter..." -ForegroundColor White
Set-Location "C:\Users\admin\AndroidStudioProjects\furniture_fe"

Write-Host "`n Bước 1: Flutter Clean..." -ForegroundColor Yellow
flutter clean

Write-Host "`n Bước 2: Flutter Pub Get..." -ForegroundColor Yellow
flutter pub get

Write-Host "`n HOÀN THÀNH!" -ForegroundColor Green
Write-Host "="*70 -ForegroundColor Cyan
Write-Host "`n BÂY GIỜ:" -ForegroundColor Yellow
Write-Host "   1. Mở Android Studio / VS Code" -ForegroundColor White
Write-Host "   2. Stop app hiện tại (Shift + F5)" -ForegroundColor White
Write-Host "   3. Run lại app (F5)" -ForegroundColor White
Write-Host "   4.  Ảnh sẽ hiển thị ĐÚNG!" -ForegroundColor Green
Write-Host "="*70 -ForegroundColor Cyan
