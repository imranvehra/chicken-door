# Draws the chicken app icon in the sizes phones need (run from this folder):
#   icon-512.png, icon-192.png (Android / manifest), apple-touch-icon.png (iPhone, 180 px).
# The drawing is defined on a 512 x 512 grid and scaled.
Add-Type -AssemblyName System.Drawing

function Draw-Chicken([int]$size, [string]$file) {
    $bmp = New-Object System.Drawing.Bitmap $size, $size
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.Clear([System.Drawing.Color]::Transparent)
    $g.ScaleTransform($size / 512.0, $size / 512.0)

    function C([string]$hex) { [System.Drawing.ColorTranslator]::FromHtml($hex) }
    $outline = New-Object System.Drawing.Pen (C '#3e2723'), 9
    $outline.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

    # Background: rounded green square with a lighter ground strip
    $bg = New-Object System.Drawing.Drawing2D.GraphicsPath
    $r = 110
    $bg.AddArc(0, 0, $r, $r, 180, 90); $bg.AddArc(512 - $r, 0, $r, $r, 270, 90)
    $bg.AddArc(512 - $r, 512 - $r, $r, $r, 0, 90); $bg.AddArc(0, 512 - $r, $r, $r, 90, 90); $bg.CloseFigure()
    $g.FillPath((New-Object System.Drawing.SolidBrush (C '#2e7d32')), $bg)
    $g.SetClip($bg)
    $g.FillEllipse((New-Object System.Drawing.SolidBrush (C '#43a047')), -60, 420, 632, 220)
    $g.ResetClip()

    $white = New-Object System.Drawing.SolidBrush (C '#ffffff')
    $red = New-Object System.Drawing.SolidBrush (C '#e53935')
    $orange = New-Object System.Drawing.SolidBrush (C '#ffa000')

    # Legs and feet
    $leg = New-Object System.Drawing.Pen (C '#ffa000'), 16
    $leg.StartCap = [System.Drawing.Drawing2D.LineCap]::Round; $leg.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($leg, 225, 380, 215, 450); $g.DrawLine($leg, 215, 450, 185, 462); $g.DrawLine($leg, 215, 450, 240, 465)
    $g.DrawLine($leg, 295, 380, 305, 450); $g.DrawLine($leg, 305, 450, 280, 465); $g.DrawLine($leg, 305, 450, 335, 462)

    # Tail feathers
    $tail = [System.Drawing.PointF[]]@(
        (New-Object System.Drawing.PointF 150, 270), (New-Object System.Drawing.PointF 70, 170),
        (New-Object System.Drawing.PointF 140, 215), (New-Object System.Drawing.PointF 110, 130),
        (New-Object System.Drawing.PointF 175, 205), (New-Object System.Drawing.PointF 185, 250))
    $g.FillPolygon($white, $tail); $g.DrawPolygon($outline, $tail)

    # Body
    $g.FillEllipse($white, 115, 195, 280, 215); $g.DrawEllipse($outline, 115, 195, 280, 215)

    # Comb (behind the head outline)
    foreach ($c in @(@(312, 92), @(345, 80), @(378, 94))) { $g.FillEllipse($red, $c[0], $c[1], 46, 46); $g.DrawEllipse($outline, $c[0], $c[1], 46, 46) }

    # Head
    $g.FillEllipse($white, 285, 110, 150, 150); $g.DrawEllipse($outline, 285, 110, 150, 150)

    # Beak
    $beak = [System.Drawing.PointF[]]@((New-Object System.Drawing.PointF 428, 165), (New-Object System.Drawing.PointF 485, 188), (New-Object System.Drawing.PointF 428, 210))
    $g.FillPolygon($orange, $beak); $g.DrawPolygon($outline, $beak)

    # Wattle
    $g.FillEllipse($red, 405, 205, 34, 52); $g.DrawEllipse($outline, 405, 205, 34, 52)

    # Eye
    $g.FillEllipse((New-Object System.Drawing.SolidBrush (C '#212121')), 370, 150, 24, 24)
    $g.FillEllipse($white, 378, 155, 8, 8)

    # Wing
    $wing = New-Object System.Drawing.Drawing2D.GraphicsPath
    $wing.AddBezier(175, 270, 230, 235, 320, 250, 330, 300)
    $wing.AddBezier(330, 300, 280, 345, 210, 340, 175, 270)
    $g.FillPath((New-Object System.Drawing.SolidBrush (C '#eeeeee')), $wing); $g.DrawPath($outline, $wing)

    $g.Dispose()
    $bmp.Save((Join-Path $PSScriptRoot $file), [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

Draw-Chicken 512 'icon-512.png'
Draw-Chicken 192 'icon-192.png'
Draw-Chicken 180 'apple-touch-icon.png'
"icons written"
