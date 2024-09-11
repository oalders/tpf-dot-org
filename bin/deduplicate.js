const fs = require('fs');
const cheerio = require('cheerio');

// Get the filename from the command line arguments
const filename = process.argv[2];

// Read the HTML file
const html = fs.readFileSync(filename, 'utf8');

// Load the HTML into Cheerio
const $ = cheerio.load(html, { decodeEntities: false });

// Find all the stylesheet links
const stylesheetLinks = new Set();

$('link[rel="stylesheet"]').each(function () {
  const href = $(this).attr('href');
  // If the href is already in the set, remove the duplicate link
  if (stylesheetLinks.has(href)) {
    $(this).remove();
  } else {
    stylesheetLinks.add(href);
  }
});

// Replace the href attribute of the matching link elements
// Create a map of regular expressions and their replacements
const replacements = new Map([
  [new RegExp('https://cdn2.editmysite.com/css/sites.css\\?.*'), '/css/sites.css'],
  [new RegExp('https://cdn2.editmysite.com/css/old/fancybox.css\\?.*'), '/css/old/fancybox.css'],
  [new RegExp('https://cdn2.editmysite.com/css/social-icons.css\\?.*'), '/css/social-icons.css']
]);

// Replace the href attribute of the matching link elements
$('link').each(function () {
  const link = $(this);
  const href = link.attr('href');

  for (const [regex, replacement] of replacements) {
    if (regex.test(href)) {
      link.attr('href', replacement);
      break;
    }
  }
});

// Remove blank lines
const cleanedHtml = $.html().replace(/(\r\n|\n|\r){2,}/g, '\n');

// Save the cleaned-up HTML back to the file
fs.writeFileSync(filename, cleanedHtml, 'utf8');

console.log('Duplicate stylesheet links removed. Links replaced.');
