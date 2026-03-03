# GitHub Pages Setup Guide

This guide will help you set up your privacy policy and marketing pages on GitHub Pages.

## Files Included

1. **`index.html`** - Marketing/landing page for your app
2. **`privacy-policy.html`** - Privacy policy page (required for App Store)

## Quick Setup Steps

### Option 1: Using GitHub Pages (Recommended)

1. **Create a GitHub Repository**
   ```bash
   # If you haven't already, create a repo for your app
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/YOUR_USERNAME/buddha-app.git
   git push -u origin main
   ```

2. **Enable GitHub Pages**
   - Go to your repository on GitHub
   - Click **Settings** → **Pages**
   - Under "Source", select **Deploy from a branch**
   - Choose **main** branch and **/ (root)** folder
   - Click **Save**

3. **Your pages will be available at:**
   - Marketing page: `https://YOUR_USERNAME.github.io/buddha-app/`
   - Privacy policy: `https://YOUR_USERNAME.github.io/buddha-app/privacy-policy.html`

### Option 2: Using a Custom Domain

1. Follow steps 1-2 above
2. In GitHub Pages settings, add your custom domain
3. Update the URLs in your HTML files if needed

## Before Publishing

### Update Contact Information

**In `privacy-policy.html`:**
- Line ~140: Replace `privacy@example.com` with your actual email
- Line ~141: Replace `https://example.com` with your actual website

**In `index.html`:**
- Line ~280: Replace `support@example.com` with your actual support email
- Update any other placeholder links

### Customize Content

- Add your actual App Store badge when available
- Update copyright year and name
- Add screenshots if desired
- Customize colors/branding if needed

## App Store Connect URLs

Once your pages are live, use these URLs in App Store Connect:

- **Support URL:** `https://YOUR_USERNAME.github.io/buddha-app/privacy-policy.html`
- **Marketing URL:** `https://YOUR_USERNAME.github.io/buddha-app/`
- **Privacy Policy URL:** `https://YOUR_USERNAME.github.io/buddha-app/privacy-policy.html`

## Testing Locally

Before pushing to GitHub, test locally:

1. Open `index.html` in your browser
2. Click the "Privacy Policy" link to test navigation
3. Check all links work correctly
4. Test on mobile devices if possible

## File Structure

```
buddha-app/
├── index.html              # Marketing page
├── privacy-policy.html     # Privacy policy
└── README_GitHubPages.md   # This file
```

## Notes

- GitHub Pages is free for public repositories
- Pages are served over HTTPS automatically
- Updates are live within minutes of pushing to GitHub
- You can use a custom domain if you have one

## Troubleshooting

**Pages not showing?**
- Check that GitHub Pages is enabled in Settings
- Verify the branch and folder are correct
- Wait a few minutes for changes to propagate

**Links not working?**
- Use relative paths (e.g., `privacy-policy.html` not `/privacy-policy.html`)
- Check file names match exactly (case-sensitive)

**Need help?**
- GitHub Pages documentation: https://docs.github.com/en/pages
- Contact GitHub support if issues persist










