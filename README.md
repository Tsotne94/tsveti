# CAFÉ TSVETI — digital menu

One self-contained page in Georgian, English and Russian. No build step, no
framework, no server. Drag the folder onto Cloudflare Pages and it is live.

```
cafe-tsveti/
  index.html              the whole site
  404.html                branded not-found page
  assets/                 photographs go here
  favicon.ico .svg        browser tab icons
  apple-touch-icon.png    iphone home screen
  icon-192 / 512 / maskable-512.png
  site.webmanifest        android home screen
  og-image.png            the picture shown when the link is shared
  robots.txt sitemap.xml
  _headers                security headers and cache rules
  deploy.sh               one-command publish
```

## Publishing

**Drag and drop**

1. Cloudflare dashboard, Workers & Pages, Create, Pages, Upload assets.
2. Name the project `cafe-tsveti`.
3. Drag the **folder itself** in, not a zip. Finder's Compress adds a
   `__MACOSX` folder that ends up published alongside your files.
4. Deploy. You get `https://cafe-tsveti.pages.dev`.

**From the terminal**

```sh
./deploy.sh              # publishes
./deploy.sh --dry-run    # checks the folder, publishes nothing
```

The script deletes `.DS_Store` files first, since Finder puts them in every
folder you open and they would otherwise be served.

There is no build command and no output directory to set.

## After the first deploy

Attach a custom domain under the project's Custom domains tab, then open
`index.html` and replace `https://cafe-tsveti.pages.dev` with it everywhere in
the head. It appears in the canonical link, the share card tags and the
structured data. Also update the two copies in `robots.txt` and `sitemap.xml`.

Then print a QR code for the tables:

```sh
npx qrcode-terminal https://your-domain.ge
```

## What is still blank

Anything left empty is hidden on the page rather than shown as a placeholder,
so the site is honest from the first deploy. These are all in the block marked
`1. EDIT THIS BLOCK` near the bottom of `index.html`:

| Setting     | Status                                                |
|-------------|-------------------------------------------------------|
| `instagram` | done, `cafe.tsveti`                                   |
| `hours`     | done, 09:00 to 23:00 daily                            |
| `mapsUrl`   | a Google Maps search for the cafe, replace with the real pin |
| `phoneText` / `phoneDial` | empty, the phone line is hidden         |
| `address`   | empty in all three languages, the address is hidden   |
| `facebook`  | empty, the link is hidden                             |

For `mapsUrl`: open the cafe in Google Maps, press Share, Copy link, paste.

Once the address and phone are real, add them to the structured data block in
the head as well, so Google shows them.

## Photographs

The strip above the footer is empty until you put files in `assets/`. Save them
with these names and they appear on their own:

```
assets/cheesecake.jpg
assets/coffee.jpg
assets/interior.jpg
```

Missing names are skipped without an error and the strip stays hidden if none
load, so a half-filled folder never breaks the page. To use different names or
more than three, edit the `photos` list in `index.html`, which also holds the
alt text in all three languages.

Portrait crops around 4:5 look best. Keep each file under about 400 KB.

## Changing the menu

Under `3. THE MENU`. Each item is one line carrying all three languages:

```js
{ ka: "ტირამისუ", en: "Tiramisu", ru: "Тирамису", price: "9.90" },
```

Two sizes instead of one price:

```js
{ ka: "ამერიკანო", en: "Americano", ru: "Американо",
  price: [["X1","4.80"],["X2","5.80"]] },
```

Prices are plain strings, so keep the two decimals. The lari sign and the
column layout are generated. To add a category, copy a category object and give
it a new `id`; its filter pill appears on its own. Interface words live in
`2. INTERFACE WORDS` just above the menu.

## How the three languages behave

The switch sits at the top right and is remembered in `localStorage`. Georgian
is the default for a first visit.

Each item carries a second line underneath. On Georgian that line is English;
on English or Russian it is the Georgian original, so a guest can point at the
Georgian name when ordering.

Georgian is set in Noto Serif Georgian, Latin and Cyrillic in EB Garamond, so
switching language changes the script without changing the texture of the page.

## Notes

- The logo is drawn in code, not placed as an image, so it stays sharp at any
  size and prints cleanly. The icons and share card were rendered from it.
- One light theme only, off-white. No dark mode, no search.
- The category pills filter the sheet in place. The page never scrolls on its
  own when you tap one.
- Categories with four or more items print in two columns on a wide screen with
  a centre fold line between them. Shorter ones stay in one column.
- The open/closed line and the clock read the visitor's device time against the
  `hours` values. Nothing server side.
- `_headers` sets a content security policy that allows only this page's own
  files plus Google Fonts. If you ever add an external script or an image from
  another domain it will be blocked until you add that host there.
- Tested down to a 320px viewport in all three languages. Whole folder is 164 KB
  before photographs.
