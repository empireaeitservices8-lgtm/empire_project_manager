$csharpCode = @'
using System;
using System.Drawing;
using System.Drawing.Imaging;

public class LogoThemeGenerator
{
    public static void GenerateDarkThemeLogo(string srcPath, string outputPath)
    {
        using (Bitmap logo = new Bitmap(srcPath))
        {
            int w = logo.Width;
            int h = logo.Height;

            using (Bitmap darkLogo = new Bitmap(w, h, PixelFormat.Format32bppArgb))
            {
                for (int y = 0; y < h; y++)
                {
                    for (int x = 0; x < w; x++)
                    {
                        Color p = logo.GetPixel(x, y);
                        if (p.A == 0)
                        {
                            darkLogo.SetPixel(x, y, Color.FromArgb(0, 0, 0, 0));
                            continue;
                        }

                        // Check if pixel is part of the dark navy/black parts (R < 60, G < 60, B < 80)
                        // vs the teal 'e' (where G > 100 or B > 120 and G > R)
                        bool isTeal = (p.G > 100 || p.B > 120) && (p.G > p.R + 20 || p.B > p.R + 20);

                        if (isTeal)
                        {
                            // Keep vibrant teal
                            darkLogo.SetPixel(x, y, p);
                        }
                        else
                        {
                            // It's the dark navy 'm' and 'empireaei' text: convert to bright platinum/white
                            // Preserving alpha anti-aliasing
                            int brightness = Math.Max(220, (int)(255 - ((p.R + p.G + p.B) / 3.0)));
                            Color newColor = Color.FromArgb(p.A, 245, 248, 252);
                            darkLogo.SetPixel(x, y, newColor);
                        }
                    }
                }

                darkLogo.Save(outputPath, ImageFormat.Png);
                Console.WriteLine("Dark theme logo created at: " + outputPath);
            }
        }
    }
}
'@

Add-Type -TypeDefinition $csharpCode -ReferencedAssemblies "System.Drawing.dll"

$src = "d:\empire\empire_project_manager\assets\images\logo.png"
$dest = "d:\empire\empire_project_manager\assets\images\logo_dark_theme.png"
[LogoThemeGenerator]::GenerateDarkThemeLogo($src, $dest)
