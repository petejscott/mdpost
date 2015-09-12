# mdpost
create static website from markdown files

## Setup
Requires a specific directory structure for the project:
/_articles
	/articlename
		index.md -- markdown file
/_templates
	/templatename
		template.html -- template file

## Usage
Assuming current path is the root of the website project:
mdpost.sh -t templatename -a articlename

The article's markdown file will be converted to html and inserted into the template in the spot marked with {md:content}

A full index.html file will be created at /_articles/articlename/index.html (the markdown file will be retained)
