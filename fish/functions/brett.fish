function __should_na
  set -l cmd (history --max=1|awk '{print $1;}')
  set -l cds cd z j popd g
  if contains $cmd $cds
    ~/scripts/fish/na
  end
end

function fallback --description 'allow a fallback value for variable'
  if test (count $argv) = 1
    echo $argv
  else
    echo $argv[1..-2]
  end
end

function get_ext --description "Get the file extension from the argument"
  set -l splits (string split "." "$argv")
  echo $splits[-1]
end

function ...;cd ../..;end
function ....;cd ../../..;end

function ax -d "Make file executable"
  chmod a+x $argv
end

function cat;bat --style plain --theme OneHalfDark $argv;end
function c;clear;end

## App shortcuts with completion for filetype

function sublp;subl -p $argv;end
complete -c sublp -d "Sublime project" -a "*.sublime-project"

function acorn;open -a Acorn $argv;end
complete -c acorn -d "Image" -a "*.{png,jpg,jpeg,psd}"
complete -c acorn -d "Acorn" -a "*.acorn"

function afff;open -a 'Affinity Photo' $argv;end
complete -c afff -d "Image" -a "*.{png,jpg,jpeg}"
complete -c afff -d "Affinity Photo" -a "*.{afphoto,psd}"

function affd;open -a 'Affinity Designer' $argv;end
complete -c affd -d "Illustration" -a "*.{ai,eps}"
complete -c affd -d "Affinity Designer" -a "*.{afdesign}"

function alpha;open -a ImageAlpha $argv;end
complete -c alpha -d "Image" -a "*.{png,gif}"

function optim;open -a ImageOptim $argv;end
complete -c optim -d "Image" -a "*.{png,jpg,jpeg,gif}"

function by;open -a Byword $argv;end
complete -c by -d "Markdown File" -a "*.{md,mkd,mmd,markdown,mkdn}"
complete -c by -d "Text File" -a "*.{text,txt}"

function chrome;open -a '/Applications/Google Chrome.app' $argv;end
complete -c chrome -d "HTML File" -a "*.{html,htm}"

function mmdc;open -a '/Applications/MultiMarkdown Composer.app' $argv;end
complete -c mmdc -d "Markdown File" -a "*.{md,mkd,mmd,markdown,mkdn}"
complete -c mmdc -d "Text File" -a "*.{text,txt}"

function tp;open -a TaskPaper $argv;end
complete -c tp -d "TaskPaper File" -a "*.taskpaper"

function xc;open -a Xcode $argv;end
complete -c xc -d "Xcode project" -a "*.xcodeproj"

function code;code-insiders $argv;end

##

function bunches;subl ~/Dropbox/Sync/Bunches/ $argv;end

function bh;~/scripts/buildhelp.rb $argv;end

function f -d "Open directory in Finder"
  open -F (fallback $argv ".")
end

function clip -d "Copy file or STDIN to clipboard"
    set -l ftype (file "$argv"|grep -c 'text')
    if test $ftype -eq 1
        command cat "$argv" | ~/scripts/rpbcopy;
        echo "Contents of $argv are in the clipboard.";
    else
        echo "File \"$argv\" is not plain text.";
    end
end

function cbp
  pbpaste | cat
end

function crush -d "pngcrush"
  pngcrush -e _sm.png -rem alla -brute -reduce $argv
end
complete -c crush -d "PNG" -a "*.png"

function degit -d "Remove all traces of git from a folder"
  find . -name '.git' -exec rm -rf {} \;
end

function docx2md --description "Convert docx to markdown: docx2md [source] [target]"
  pandoc -o "$2" --extract-media=(dirname "$argv[2]") "$argv[1]"
end

function eds;~/scripts/editscript $argv;end

function flush -d "Flush DNS cache"
  sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder
end

function gmine -d "Resolve git conflicts with mine"
  git st|grep -e '^U'|sed -e 's/^UU *//'|xargs git checkout --ours
end

function gtheirs -d "Resolve git conflicts with theirs"
  git st|grep -e '^U'|sed -e 's/^UU *//'|xargs git checkout --theirs
end

function gitar -d "Add and remove all unstaged git files"
  git ls-files -d -m -o -z --exclude-standard | xargs -0 git update-index --add --remove
end

function 64enc -d "encode a given image file as base64 and output css background property to clipboard"
  openssl base64 -in "$argv" | awk -v ext=(get_ext $argv) '{ str1=str1 $0 }END{ print "background:url(data:image/"ext";base64,"str1");" }'|pbcopy
  echo "$argv encoded to clipboard"
end

function 64font -d "encode a given font file as base64 and output css background property to clipboard"
  openssl base64 -in "$argv" | awk -v ext=(get_ext $argv) '{ str1=str1 $0 }END{ print "src:url(\"data:font/"ext";base64,"str1"\")  format(\""ext"\");" }'|pbcopy
  echo "$argv encoded as font and copied to clipboard"
end

function imgsize --description "Quickly get image dimensions from the command line"
  if test -f $argv
    set -l height (sips -g pixelHeight "$argv"|tail -n 1|awk '{print $2}')
    set -l width (sips -g pixelWidth "$argv"|tail -n 1|awk '{print $2}')
    echo "$width x $height"
  else
    echo "File not found"
  end
end

function gist -d "gist is defunkt, use jist"
  jist -p -c $argv
end
function gistp -d "private gist"
  jist -c $argv
end
function pbgist -d "public gist from clipboard"
  jist -pcP $argv
end
function pbgistp -d "private gist from clipboard"
  jist -cP $argv
end

function gt -d "jump to top level of git repo"
  cd (git rev-parse --show-toplevel) $argv
end

function ip;curl icanhazip.com $argv;end

function lt -d "List directory from oldest to newest"
  ls -Atr1 $argv && echo "------Newest--"
end
function ltr -d "List directory from newest to oldest"
  ls -At1 $argv && echo "------Oldest--"
end

function npmg;npm install -g $argv;end

function ack -d "ack defaults, ~/.ackrc for more"
  /usr/local/bin/ack --smart-case $argv
end
function mack -d "ack for markdown"
  ack --type=markdown -i $argv
end

function ag -d "Silver Surfer defaults, smart case, ignore VCS"
  ag -SU $argv
end

function o;open -a $argv;end
complete -c o -a (basename -s .app /Applications{,/Setapp}/*.app|awk '{printf "\"%s\" ", $0 }')

function _up -d "inspired by `bd`: https://github.com/vigneshwaranr/bd"
  set -l rx (ruby -e "print '$argv'.gsub(/\s+/,'').split('').join('.*?')")
  # fish doesn't allow ${var} protection
  # so the square brackets are interpreted as array counters...
  set -l rx (printf "/(.*\/%s[^\/]*\/).*/i" $rx)
  echo $PWD | ruby -e "print STDIN.read.sub($rx,'\1')"
end

function up -d "cd to a parent folder with fuzzy matching"
  if test (count $argv) -eq 0
    echo "up: traverses up the current working directory to first match and cds to it"
    echo "Missing argument"
  else
    cd (_up "$argv")
  end
end

function urlenc -d "url encode the passed string"
  if test (count $argv) > 0
    echo -n "$argv" | perl -pe's/([^-_.~A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg'
  else
    command cat | perl -pe's/([^-_.~A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg'
  end
end

function dash -d "Open argument in Dash"
  open "dash://"(urlenc $argv)
end

function dman -d "Open man page in Dash"
  open "dash://man:"(urlenc $argv)
end

function js -d "jslint with color coding"
  jsl -conf ~/jslint.conf -process "$argv" \
  | sed -E 's/(.+)\(([0-9]+)\):/\1:\2/g' \
  | colout '^\S+\.\w+$' green bold \
  | colout '(\d) ((?:error|warning)\(s\))' red,magenta \
  | colout '(?:lint )?warning:.*$' yellow \
  | colout '(?:\d+) (.*[Ee]rror:.*)$' red \
  | colout '^(\.*)(\^)' black,green bold,bold \
  | colout '^(\/.*?)([^\/]+\.\S+)(:\d+) ' black,green,green bold,bold,normal
end

# flying through bundle identifiers more efficiently than `osascript`, faster than `defaults read`, it's `bid` to the rescue!
# fuzzy string matching, returns title and bundle id for first match
# `bid preview`
function bid -d "Get bundle id for app name"
  # (and remove ".app" and escapes from the end if it exists due to autocomplete)
  set -l shortname (echo "$argv"| sed -E 's/\.app$//'|sed 's/\\\//g')
  set -l location
  # if the file is a match in apps folder, don't spotlight
  if test -d "/Applications/$shortname.localized/$shortname.app"
    set location "/Applications/$shortname.localized/$shortname.app"
  else if test -d "/Applications/$shortname.app"
    set location "/Applications/$shortname.app"
  else # use spotlight
    set location (mdfind -onlyin /Applications -onlyin /Applications/Setapp -onlyin /Applications/Utilities -onlyin ~/Applications -onlyin /Developer/Applications "kMDItemKind==Application && kMDItemDisplayName=='*$shortname*'cdw"|head -n1)
  end
  # No result? Die.
  if test -z $location
    echo "$argv not found, I quit"
    return
  end
  # Find the bundleid using spotlight metadata
  set -l bundleid (mdls -name kMDItemCFBundleIdentifier -r "$location")
  # return the result or an error message
  if test -z $bundleid
    echo "Error getting bundle ID for \"$argv\""
  else
    echo "$location: $bundleid"
  end
end

set_color 8aC374 && figlet -f block -w 80 "The Lab"

