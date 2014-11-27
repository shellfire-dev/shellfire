# [shellfire]

[shellfire] is a framework for building modular applications in POSIX-compliant shell script. It is designed to:-

* abstract away the differences (and myriad bugs) between multiple shell interpreters
* implement common idioms and functionality
* promote re-use of shell code with a modern, modular set of functions to get practical things done fast
* enable the development of fully standalone scripts, complete with resources (snippets)
* allow shell scripts to automatically determine and install their dependencies
* but have a minimal need to 'shell out' to binaries that might not be there - or might not behave

[shellfire] consists of a number of github repositories, called modules. Each module contains functions or resources in a specific namespace. You create a [shellfire] application by making a new repository (typically on GitHub) with a skeleton structure, and then adding the modules you need. You populate a template shell script, and then just code away. It couldn't be easier. [shellfire] scripts work straightaway from source control. When you're ready to do a release, you can use [fatten] to make a standalone script, and [swaddle] to then deploy it to GitHub releases, pages, etc as tarballs, debs, etc.

[shellfire] has been open sourced and enhanced from code previously used in-house by [stormmq](http://stormmq.com/) and [KisanHub](http://www.kisanhub.com/). The lead developer is [Raph Cohn](https://github.com/raphaelcohn). It's licensed under the MIT Licence.

## Why?
Because the shell matters, as shellshock showed us. Because the shell is powerful, but is a poorly understood programming language. And it needs proper constructs. And lastly, because we're fed up with having to install half an universe's worth of Ruby, Python and Perl to bootstrap our servers or run CI jobs\*. We like Rob Landley's Aboriginal Linux. And if we want to build our own bespoke, single purpose servers, managed switches and embedded routers post-Snowden, less is more.

\* And if you've had to work with some of the backwards-is-forwards sysadmins I have had to in some strange organisations, doing it all in the shell is the only way of getting it done at all.

_PS: If we could have our time again with the syntax of shell script, we probably would. But we're stuck with it. The flip side is, it hasn't changed in 15 years, so it works anywhere._

## Yeah, cool. So what uses it?

Well, not much yet, but, who knows? There's currently:-

* [swaddle], a tool for packaging, building package repositories, signing them, deploying their keys and publishing them on GitHub pages or wherever.
* [bish-bosh], a complete [MQTT](http://mqtt.org/) 3.1.1 client. Totally portable, totally scriptable, minimally dependent.
* [fatten], shellfire's own fattening tool

## You're mad. You should grow up and use Ruby, Python or Go.
We're proficient in all of them. Our lead developer also designed and built a message queue broker that handles 1,000,000 simultaneous users in C and Java, and a portfolio trading system in C#. A professional uses the language most appropriate to the problem domain. And we're very full grown. With beards and sandles, too.

## What platforms or shells are supported?

Code is known to run well on:-

* Linux (including as old as CentOS 5, which is pretty obsolescent)
* Mac OS X (using Homebrew where necessary)
* The BSDs (all of them)
* Cygwin
* AIX
* Solaris

We plan to support major distributions whilst there owners support them, as long as we can access without cost to the underlying technologies. We have limited interest in supporting obscure, dying or dead commercial platforms (eg HP-UX, Tru64). Please just go away and stop raping your customers. Thank you.

We work well on POSIX shells that support a `local` keyword or alias:-

* bash (3.2+)
* bash as sh
* ash derivatives
  * dash
  * BusyBox ash
* ksh88 derivatives
  * mksh
  * pdksh
  * AIX ksh88
  * Solaries ksh88

yash is not there yet but could be if there's interest. We're not going to support ksh93 as it's just too different, and zsh, great as it is an interactive shell, is a bit hit and miss.

## So what's included?
In homage to Python, batteries are included. Here's the list of modules and namespaces:-

* [core], the daddy of them all. Includes such beauties as
  * Compatiblity functions, abstracting away differences and allowing things like `pushd` in all shells
  * A set of base64 decode functions which decode regardless of what binaries you've got (if any at all)
  * A dependency framework to document required binaries, set up the `PATH` and automatically install packages that contain them, so you can rely on `date` doing the same thing on Mac OS X as well as Linux, say
  * A fully-fledged command line parser, which handles long options, argumented and unargumented values, golfed arguments with no third party dependencies, help messages, version information, verbosity settings, non-options and more
  * Snippets, so you can embed data, text, here docs or even specialised binaries inside shell scripts. Important to version control data, resources and here docs separately.
  * One-liner child process clean-up
  * Terminal aware colour coded messages (which know about ANSI and tput and fallback gracefully)
  * A hierachial configuration framework, so administrator and users can have their own settings for any command line switch
	* Configuration can be broken into fragments (like Debian run-parts), so that common across environments can be checked in, and passwords kept separate
    * Insecurely permissioned files aren't loaded
    * Administrators can also prevent overrides of sensitive values
  * Validation and path testing functions
  * Indirect variable access, a boolean type, string functions (startsWith, contains, etc)
  * Trivial to use, but always secure, random and cleaned up temporary files and folders
  * Signal management
  * Arrays even for shells without them, and more!
* [configure], an additional framework for more advanced configuration. Used by [swaddle] to let users define simple configuration files for package and repository definitions.
* [cpucount], functions to help with enumerating CPU numbers and deciding on load averages.
* [curl], superb interface to curl that works with the shell. Securely wraps curl so URLs, headers and credentials don't leak in process lists or environment variables, and parses headers, etc afterwards.
* [github api], a REST interface that uses [curl], [urlencode], [jsonreader] and [jsonwriter]. Currently, only supports enough to support [swaddle], but, if you're looking for an open source project, this is one to do. A complete command line, shell based GitHub client would be a real win. And one for Linode. And Digital Ocean. And ...
* [jsonreader], a pure shell JSON reader. Raises events rather than creating an anaemic DOM of objects and lists - which has always been the _right_ way to deal with structured data... Think SAX for JSON.
* [jsonwriter], writes JSON.
* [unicode], to correctly encode code points in UTF-8 and UTF-16 (uggh).
* [urlencode], for all the myriad URL encodings possible. Includes a URI template Level 4 encoder.
* [version], a simple module to compare version numbers. Yes, I know that's normally bad, but some things (like [curl]) need it as we can't do feature detection.
* [xmlwriter], writes XML.

Of course, this is just a start. If there's something you'd like to see, code it and submit a pull request. And let us know what you're doing with it.

Additionally, there's also

* [fatten], to make standalone shell scripts
* [paths.d], which contains common locations and package names for different package managers. Used by [core]'s dependency framework as a source of information on where to find programs.

## Getting Started: A 10 min tutorial

If you'd rather not follow along, or if you'd prefer to see a complete application, take a look at the files in `tutorial/overdrive`. (On a Mac with TextMate, `mate tutorial/overdrive`).

### Create a skeleton folder structure
Create a new repository on GitHub. For this example, we'll assume you called it `overdrive` and you are `normanville`. The [shellfire] application is called `overdrive`. Now, let's create the following folder structure:-

```bash
overdrive\
	.git\
	overdrive           # your shellfire application script
	etc\
		shellfire\
			paths.d\    # git submodule add https://github.com/shellfire-dev/paths.d
	lib\
		shellfire\
			core\       # git submodule add https://github.com/shellfire-dev/core
			jsonreader\ # git submodule add https://github.com/shellfire-dev/jsonreader
			unicode\    # git submodule add https://github.com/shellfire-dev/unicode
			xmlwriter\  # git submodule add https://github.com/shellfire-dev/xmlwriter
			overdrive\  # any code for your application broken out into namespaces
output\
```

So, let's do it:-
```bash
repository=overdrive
user=normanville
git clone "git@github.com:$user/$repository.git"
cd "$repository"

mkdir -p etc/shellfire
cd etc/shellfire
git submodule add "https://github.com/shellfire-dev/paths.d"
cd -

mkdir -p lib/shellfire
cd lib/shellfire
git submodule add "https://github.com/shellfire-dev/core"
git submodule add "https://github.com/shellfire-dev/jsonreader"
git submodule add "https://github.com/shellfire-dev/unicode"
git submodule add "https://github.com/shellfire-dev/xmlwriter"
mkdir overdrive
cd -

git submodule update --init

touch overdrive
chmod +x overdrive

cd ..
```


### Creating Hello World

Now all that's left is to add some boilerplate to the `overdrive` executable. This is unfortunate, but there's nothing to be done about it. We need _something_ so [shellfire] can bootstrap. Open `overdrive` in a text editor, and paste in this boilerplate to create a 'Hello World':-

```bash
#!/usr/bin/env sh

_program()
{	
	overdrive()
	{
		echo "Hello World"
	}
}

_program_name='overdrive'
_program_version='unversioned'
_program_package_or_build=''
_program_copyright='(c) 2014 normanville'
_program_licence='MIT'
_program_written_by='normanville'
_program_path="$([ "${_program_fattening_program_path+set}" = 'set' ] && printf '%s\n' "$_program_fattening_program_path" || ([ "${0%/*}" = "${0}" ] && printf '%s\n' '.' || printf '%s\n' "${0%/*}"))"
_program_libPath="${_program_path}/lib"
_program_etcPath="${_program_path}/etc"
_program_varPath="${_program_path}/var"
_program_entrypoint='overdrive'


# Assumes pwd, and so requires this code to be running from this folder
. "$_program_libPath"/shellfire/core/init.functions "$@"
```

Now run it with `./overdrive` - you should see `Hello World`. Try `./overdrive --help` and `./overdrive --version`. Of course, this isn't a very useful program. Let's at least give it a purpose.

### Parsing the command line
In many programs, parsing the command line is probably a large proportion of the logic. Its complex, brittle and frequently just hard work. [shellfire] aims to make it a little easier.

Let's start by taking some arguments using [core]'s command line parser. We're going to modify our hello world program to one that reads JSON gear box files and writes them as XML gear box files. So it'd be useful to be able to do something like `./overdrive /path/to/gearbox.json`.

Let's add the function `_program_commandLine_handleNonOptions()`. This is called back by the parser to let us handle non-options. We could use this take a list of files to work on. Let's use [shellfire] arrays:-

```bash
_program_commandLine_handleNonOptions()
{
	core_variable_array_initialise overdrive_jsonGearBoxFiles
	
	local jsonGearBoxFile
	for jsonGearBoxFile in "$@"
	do
		core_variable_array_append overdrive_jsonGearBoxFiles "$jsonGearBoxFile"
	done
}

# Assumes pwd, and so requires this code to be running from this folder
. "$_program_libPath"/shellfire/core/init.functions "$@"
```

Note, it's very important that the very last line of your program is always `. "$_program_libPath"/shellfire/core/init.functions "$@"`. It's magic. Sorry. Actually, when [fatten]ed, this line disappears - but you do want to run your code first, don't you?

Is it an error to not have any files? Well it, certainly isn't useful. Let's issue a warning.

```bash
# Replace _program_commandLine_handleNonOptions() with
_program_commandLine_handleNonOptions()
{
	core_variable_array_initialise overdrive_jsonGearBoxFiles
	
	local jsonGearBoxFile
	for jsonGearBoxFile in "$@"
	do
		core_variable_array_append overdrive_jsonGearBoxFiles "$jsonGearBoxFile"
	done
	
	if core_variable_array_isEmpty overdrive_jsonGearBoxFiles; then
		core_message WARN "You haven't specified any JSON gear box files - are you sure this is what you wanted?"
	fi
}
```

Actually, let's make that an error after all:-

```bash
# Replace _program_commandLine_handleNonOptions() with
_program_commandLine_handleNonOptions()
{
	core_variable_array_initialise overdrive_jsonGearBoxFiles
	
	local jsonGearBoxFile
	for jsonGearBoxFile in "$@"
	do
		core_variable_array_append overdrive_jsonGearBoxFiles "$jsonGearBoxFile"
	done
	
	if core_variable_array_isEmpty overdrive_jsonGearBoxFiles; then
		core_exitError $core_commandLine_exitCode_USAGE "You haven't specified any JSON gear box files - are you sure this is what you wanted?"
	fi
}
```

We need somewhere to store out output. How about an option `--output-path`? Let's tell the parser what to do:-

```bash
# Place this code above _program_commandLine_handleNonOptions()
_program_commandLine_optionExists()
{
	case "$optionName" in
	
		output-path)
			echo 'yes-argumented'
		;;
		
		*)
			echo 'no'
		;;
	
	esac
}
```

Of course, we want to actually get the value of that option! In this case, the parser will call `_program_commandLine_processOptionWithArgument()`:-

```bash
# Place this code below _program_commandLine_optionExists()
_program_commandLine_processOptionWithArgument()
{
	case "$optionName" in
	
		output-path)
			overdrive_outputPath="$optionValue"
		;;
	
	esac
}
```

By convention, we name variables set through command line options as `${_program_name}_lowerTitle`. Of course, it'd be nice to have a short option, `-o`, too, so let's do that:-

```bash
# Replace _program_commandLine_optionExists() and _program_commandLine_processOptionWithArgument() with
_program_commandLine_optionExists()
{
	case "$optionName" in
	
		o|output-path)
			echo 'yes-argumented'
		;;
		
		*)
			echo 'no'
		;;
	
	esac
}

_program_commandLine_processOptionWithArgument()
{
	case "$optionName" in
	
		o|output-path)
			overdrive_outputPath="$optionValue"
		;;
	
	esac
}
```

Now, we really ought to validate that output path. Do we need to create it? Possibly. Let's use one of the convenience functions in `core_validate`:-

```bash
# Replace _program_commandLine_processOptionWithArgument() with
_program_commandLine_processOptionWithArgument()
{
	case "$optionName" in
	
		o|output-path)
			core_validate_folderPathIsReadableAndSearchableAndWritableOrCanBeCreated $core_commandLine_exitCode_USAGE 'option' "$optionNameIncludingHyphens" "$optionValue"
			overdrive_outputPath="$optionValue"
		;;
	
	esac
}
```

Now, we always need an output path. We can't know for sure until all the options have been parsed. Of course, the parser let's us manage that in `_program_commandLine_validate()`:-

```bash
# Place this below _program_commandLine_handleNonOptions()
_program_commandLine_validate()
{
	if core_variable_isUnset overdrive_outputPath; then
		core_exitError $core_commandLine_exitCode_USAGE "Please specify --output-path"
	fi
}
```

That's a bit tough, though. Why don't we let an administrator set a value in configuration? Configuration is automatically parsed and loaded immediately prior to command line parsing. Of course, if that's the case, we'll need to validate what they've chosen. And, in this case, just because it makes sense, we could default the output path to the current working directory, but let the user know.

```bash
# Replace _program_commandLine_handleNonOptions() with
_program_commandLine_validate()
{
	if core_variable_isSet overdrive_outputPath; then
		core_validate_folderPathIsReadableAndSearchableAndWritableOrCanBeCreated $core_commandLine_exitCode_CONFIG 'configuration setting' 'overdrive_outputPath' "$overdrive_outputPath"
	else
		core_message INFO "Defaulting --output-path to current working directory"
		overdrive_outputPath="$(pwd)"
	fi
}
```

Of course, we ought to write an useful help message after all of this. Let's do that with `_program_commandLine_helpMessage()`:-

```bash
# Place this above _program_commandLine_optionExists()
_program_commandLine_helpMessage()
{
	_program_commandLine_helpMessage_usage="[OPTION]... -- [JSON GEAR BOX FILE]..."
	_program_commandLine_helpMessage_description="Turns JSON into XML."
	_program_commandLine_helpMessage_options="
  -s, --output-path PATH      PATH to output to.
                              Defaults to current working directory:-
                              $(pwd)"
    _program_commandLine_helpMessage_optionsSpacing='     '
	_program_commandLine_helpMessage_configurationKeys="
  swaddle_outputPath     Equivalent to --output-path
"
	_program_commandLine_helpMessage_examples="
  ${_program_name} -o /some/path -- some-json-gear-box-file.json
"
}
```

Let's check out our new help: `./overdrive --help`.

Now, we're repeating our self with the default value for the output path - once in `_program_commandLine_helpMessage()`, once in `_program_commandLine_validate()`. It's also a dynamic value. In a normal shell script, we might put that in a global value. But because of the way [shellfire] works, that's a bad idea (as it is in most normal programs). It'll be lost when the program's fattened, as all expression outside of functions aren't preserved ordinarily. And even if it wasn't, it'd be the value on the development machine. Instead, let's use an initialisation function:-

```bash
# Place this above _program_commandLine_helpMessage()
_program_commandLine_parseInitialise()
{
	overdrive_outputPath_default="$(pwd)"
}

# Replace _program_commandLine_helpMessage() with
_program_commandLine_helpMessage()
{
	_program_commandLine_helpMessage_usage="[OPTION]... -- [JSON GEAR BOX FILE]..."
	_program_commandLine_helpMessage_description="Turns JSON into XML."
	_program_commandLine_helpMessage_options="
  -s, --output-path PATH      PATH to output to.
                              Defaults to current working directory:-
                              $overdrive_outputPath_default"
    _program_commandLine_helpMessage_optionsSpacing='     '
	_program_commandLine_helpMessage_configurationKeys="
  swaddle_outputPath     Equivalent to --output-path
"
	_program_commandLine_helpMessage_examples="
  ${_program_name} -o /some/path -- some-json-gear-box-file.json
"
}

# Replace _program_commandLine_validate() with
_program_commandLine_validate()
{
	if core_variable_isSet overdrive_outputPath; then
		core_validate_folderPathIsReadableAndSearchableAndWritableOrCanBeCreated $core_commandLine_exitCode_CONFIG 'configuration setting' 'overdrive_outputPath' "$overdrive_outputPath"
	else
		core_message INFO "Defaulting --output-path to current working directory"
		overdrive_outputPath="$overdrive_outputPath_default"
	fi
}
```

Let's check out our new help: `./overdrive --help`. To make use of the configuration, you could create a file at, say, `$HOME/.overdrive/rc`:-

```bash
overdrive_outputPath="~/overdrive-output"
```

Now we might want to be able to force the output to overwrite files. Let's add a `--force` long option, with `-f` for short hand, with the last function the parser uses, `core_commandLine_processOptionWithoutArgument`:-

```bash
# Replace _program_commandLine_optionExists() with
_program_commandLine_optionExists()
{
	case "$optionName" in
	
		o|output-path)
			echo 'yes-argumented'
		;;
	
		f|force)
			echo 'yes-argumentless'
		;;
		
		*)
			echo 'no'
		;;
	
	esac
}

# Place this below _program_commandLine_optionExists()
_program_commandLine_processOptionWithoutArgument()
{
	case "$optionName" in
		
		f|force)
			overdrive_force='yes'
		;;
		
	esac
}

# Replace _program_commandLine_validate() with
_program_commandLine_validate()
{
	if core_variable_isSet overdrive_outputPath; then
		core_validate_folderPathIsReadableAndSearchableAndWritableOrCanBeCreated $core_commandLine_exitCode_CONFIG 'configuration setting' 'overdrive_outputPath' "$overdrive_outputPath"
	else
		core_message INFO "Defaulting --output-path to current working directory"
		overdrive_outputPath="$overdrive_outputPath_default"
	fi

	if core_variable_isSet overdrive_force; then
		core_validate_isBoolean $core_commandLine_exitCode_CONFIG 'configuration setting' 'overdrive_force' "$overdrive_force"
	else
		overdrive_force='no'
	fi
}
```

Of course, there's more we could do. We could validate that the JSON files in `_program_commandLine_handleNonOptions()` are extant, readable and not empty. We should document `--force`. We leave that as an exercise for you.

### Doing something useful

Recall in our boilerplate we had the following at the top of our program:-

```bash
_program()
{	
	overdrive()
	{
		echo "Hello World"
	}
}
```

Let's replace that with something more useful. Let's start by importing the namespaces we need:-

```bash
# Replace _program() with
_program()
{
	core_usesIn jsonreader
	core_usesIn xmlwriter
	
	overdrive()
	{
		echo "Hello World"
	}
}
```

We don't import `unicode`, even though `jsonreader` depends on it - it has a `core_usesIn` line in its logic.

Now, what's our program going to do? It's going to loop over each JSON file, and write each to a XML file. We need to create the output path, check if the XML files exist, and only overwrite if `--force` is specified. Let's write a loop in `overdrive()`:-

```bash
# Replace _program() with
_program()
{
	core_usesIn jsonreader
	core_usesIn xmlwriter
	
	# document dependency
	core_dependency_requires '*' mkdir
	overdrive()
	{
		mkdir -m 0755 -p "$overdrive_outputPath"
		core_variable_array_iterate overdrive_jsonGearBoxFiles overdrive_convertJsonFileToXml
	}
}
```

`overdrive_convertJsonFileToXml` is a callback that'll be passed each JSON file path. It's the name of a function we'll define (very few people seem to know that callbacks are both easy and powerful in shell script). Now, we could write this in our [shellfire] application:-

```bash
# Replace _program() with
_program()
{
	core_dependency_requires '*' mkdir
	overdrive()
	{
		mkdir -m 0755 -p "$overdrive_outputPath"
		core_variable_array_iterate overdrive_jsonGearBoxFiles overdrive_convertJsonFileToXml
	}
	
	overdrive_convertJsonFileToXml()
	{
		:
	}
}
```

But it's getting to get large, quickly. We should use a module. Let's create a private one for ourselves. Create the file `overdrive/lib/shellfire/overdrive/overdrive.functions`, and put the logic in there:-

```bash
core_usesIn jsonreader
core_usesIn xmlwriter
overdrive_convertJsonFileToXml()
{
	:
}
```

Now, let's import the module like any other:-

```bash
# Replace _program() with
_program()
{
	core_usesIn overdrive
	core_dependency_requires '*' mkdir
	overdrive()
	{
		mkdir -m 0755 -p "$overdrive_outputPath"
		core_variable_array_iterate overdrive_jsonGearBoxFiles overdrive_convertJsonFileToXml
	}
}
```

Right, let's add some logic to `overdrive_convertJsonFileToXml()` in `overdrive/lib/shellfire/overdrive/overdrive.functions`:-

```bash
# Replace overdrive_convertJsonFileToXml() with
overdrive_convertJsonFileToXml()
{
	# core_variable_array_element is set by core_variable_array_iterate
	local jsonGearBoxFilePath="$core_variable_array_element"
	
	local jsonGearBoxFileName="$(core_compatibility_basename "$jsonGearBoxFilePath")"
	# Of course, you could use the file program
	local extension='.json'
	if ! core_variable_endsWith "$jsonGearBoxFileName" "$extension"; then
		core_exitError $core_commandLine_exitCode_DATAERR "The JSON gear box file '$jsonGearBoxFilePath' doesn't end in '.json'"
	fi
	
	# Strip .json
	local gearBoxFileNameWithoutExtension="$(core_variable_allButLastN "$jsonGearBoxFileName" ${#extension})"
	
	local xmlOutputFilePath="$overdrive_outputPath"/"$gearBoxFileNameWithoutExtension".xml
	
	# Don't overwrite
	if [ -e "$xmlOutputFilePath" ]; then
		if core_variable_isFalse "$overdrive_force"; then
			core_message WARN "Skipping conversion of '$jsonGearBoxFileName' to XML as output file already exists"
		fi
		return 0
	fi
	
	{
		xmlwriter_declaration '1.0' 'UTF-8' 'no'
		xmlwriter_open JsonGearBox creator overdrive
			jsonreader_parse "$jsonGearBoxFilePath" overdrive_convertJsonFileToXml_callback
		xmlwriter_close JsonGearBox
	} >"$xmlOutputFilePath"
}
```

Let's write that conversion code:-

```bash
# Place below overdrive_convertJsonFileToXml()
overdrive_convertJsonFileToXml_callback()
{
	case "$eventKind" in
	
		root)
			xmlwriter_leaf value type "$eventVariant" "$eventValue"
		;;
		
		object)
			
			case "$eventVariant" in
				
				start)
					if [ "$eventValue" = 'object' ]; then
						xmlwriter_open object key "$eventKey" index "$eventIndex"
					else
						xmlwriter_open object index "$eventIndex"
					fi
				;;
				
				boolean|number|string)
					# eg <value key="hello" type="boolean">true</value>
					xmlwriter_leaf value key "$eventKey" index "$eventIndex" type "$eventVariant" "$eventValue"
				;;
				
				end)
					xmlwriter_close object
				;;
				
			esac
			
		;;
		
		array)
			
			case "$eventVariant" in
				
				start)
					if [ "$eventValue" = 'object' ]; then
						xmlwriter_open array key "$eventKey" index "$eventIndex"
					else
						xmlwriter_open array index "$eventIndex"
					fi
				;;
				
				boolean|number|string)
					# eg <value type="boolean">true</value>
					xmlwriter_leaf value index "$eventIndex" type "$eventVariant" "$eventValue"
				;;
				
				end)
					xmlwriter_close array
				;;
				
			esac
			
		;;
		
	esac
}
```

Now, let's try it out. Copy this JSON to `overdrive/gearbox.json:-

```bash
{
	"hello": "world",
	"array":
	[
		-0.5e+6,
		true,
		null,
		false,
		"something",
		{
			"nested": "value"
		}
	],
	"number": 50,
	"boolean": true
}
```

Let's convert the data: `./overdrive --output-path ~/output-path -- ./gearbox.json`. Take a look at `~/output-path/gearbox.xml`. Right, now, let's try again: `./overdrive --output-path ~/output-path -- ./gearbox.json`. Good, our logic stops an overwrite. Specify `-f` and try again: `./overdrive --output-path ~/output-path -f -- ./gearbox.json`.

### [fatten]ing

TO DO.


[shellfire]: https://github.com/shellfire-dev "shellfire homepage"
[fatten]: https://github.com/shellfire-dev/fatten "fatten homepage"
[swaddle]: https://github.com/raphaelcohn/swaddle "Swaddle homepage"
[bish-bosh]: https://github.com/raphaelcohn/bish-bosh "bish-bosh homepage"
[core]: https://github.com/shellfire-dev/core "shellfire core module homepage"
[configure]: https://github.com/shellfire-dev/configure "shellfire configure module homepage"
[cpucount]: https://github.com/shellfire-dev/cpucount "shellfire cpucount module homepage"
[github api]: https://github.com/shellfire-dev/github "shellfire github api module homepage"
[jsonreader]: https://github.com/shellfire-dev/jsonreader "shellfire jsonreader module homepage"
[jsonwriter]: https://github.com/shellfire-dev/jsonwriter "shellfire jsonwriter module homepage"
[unicode]: https://github.com/shellfire-dev/unicode "shellfire unicode module homepage"
[urlencode]: https://github.com/shellfire-dev/urlencode "shellfire urlencode module homepage"
[version]: https://github.com/shellfire-dev/version "shellfire version module homepage"
[xmlwriter]: https://github.com/shellfire-dev/xmlwriter "shellfire xmlwriter module homepage"
[paths.d]: https://github.com/shellfire-dev/paths.d "shellfire paths.d path data homepage"
