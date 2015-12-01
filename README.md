# logviewer

A Log viewer application based on vert.x and ... to be decided

What the logviewer shall do?

- Watch the logging steam live via a web console
- Generate events based on the log stream (e.g. to send mails)
- - This can also be a more sophisticated filter like if a event happended over x times within 5 minutes
- Search within the logs 


## About the modules

### loggenerator
This project creates test log entries. It uses text files from the [Gutenberg Project] 
https://www.gutenberg.org/ to randomly create log entries so we can live test logviewer. 