$csharpCode = @'
using System;
using System.Drawing;
using System.Drawing.Imaging;

public class LogoDetector2
{
    public static void Detect(string srcPath, string outputDir)
    {
        using (Bitmap orig = new Bitmap(srcPath))
        {
            int width = orig.Width;
            int height = orig.Height;

            Console.WriteLine("Image PixelFormat: " + orig.PixelFormat + " (" + width + "x" + height + ")");

            int minX = width, minY = height, maxX = 0, maxY = 0;
            int coloredCount = 0;

            for (int y = 0; y < height; y++)
            {
                for (int x = 0; x < width; x++)
                {
                    Color p = orig.GetPixel(x, y);

                    // Check if pixel has visible color and is NOT transparent and NOT pure white
                    bool isVisible = p.A > 20;
                    bool isNotWhite = (p.R < 240 || p.G < 240 || p.B < 240);

                    if (isVisible && isNotWhite)
                    {
                        coloredCount++;
                        if (x < minX) minX = x;
                        if (x > maxX) maxX = x;
                        if (y < minY) minY = y;
                        if (y > maxY) maxY = y;
                    }
                }
            }

            Console.WriteLine("Colored pixels: " + coloredCount + ". Bounds: X:[" + minX + ".." + maxX + "] Y:[" + minY + ".." + maxY + "]");

            if (coloredCount > 0)
            {
                int pad = 24;
                int cropX = Math.Max(0, minX - pad);
                int cropY = Math.Max(0, minY - pad);
                int cropW = Math.Min(width - cropX, (maxX - minX) + 1 + (pad * 2));
                int cropH = Math.Min(height - cropY, (maxY - minY) + 1 + (pad * 2));

                Console.WriteLine("Cropping to: X=" + cropX + ", Y=" + cropY + ", W=" + cropW + ", H=" + cropH);

                // 1. Cropped as-is
                Rectangle cropRect = new Rectangle(cropX, cropY, cropW, cropH);
                using (Bitmap cropped = orig.Clone(cropRect, PixelFormat.Format32bppArgb))
                {
                    cropped.Save(System.IO.Path.Combine(outputDir, "logo_raw.png"), ImageFormat.Png);

                    // 2. Transparent background version
                    using (Bitmap trans = new Bitmap(cropW, cropH, PixelFormat.Format32bppArgb))
                    {
                        for (int cy = 0; cy < cropH; cy++)
                        {
                            for (int cx = 0; cx < cropW; cx++)
                            {
                                Color cp = cropped.GetPixel(cx, cy);
                                if (cp.A < 20)
                                {
                                    trans.SetPixel(cx, cy, Color.FromArgb(0, 0, 0, 0));
                                }
                                else
                                {
                                    int minC = Math.Min(cp.R, Math.Min(cp.G, cp.B));
                                    if (minC >= 248)
                                    {
                                        trans.SetPixel(cx, cy, Color.FromArgb(0, 0, 0, 0));
                                    }
                                    else if (minC >= 210)
                                    {
                                        double f = (248.0 - minC) / 38.0;
                                        int a = (int)(f * cp.A);
                                        trans.SetPixel(cx, cy, Color.FromArgb(a, cp.R, cp.G, cp.B));
                                    }
                                    else
                                    {
                                        trans.SetPixel(cx, cy, cp);
                                    }
                                }
                            }
                        }
                        trans.Save(System.IO.Path.Combine(outputDir, "logo.png"), ImageFormat.Png);
                    }
                }
            }
        }
    }
}
'@

Add-Type -TypeDefinition $csharpCode -ReferencedAssemblies "System.Drawing.dll"

$src = "C:\Users\sreej\.gemini\antigravity-ide\brain\1787f72b-ff49-4ff3-b53d-3f3c16184d3a\.user_uploaded\media_1788933036195.png"
$dest = "d:\empire\empire_project_manager\assets\images"
[LogoDetector2]::Detect($src, $dest)
