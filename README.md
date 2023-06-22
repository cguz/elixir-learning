# Elixir Learning

- All data structures are inmutable

## Create Mix Project

    $ mix new chatbotserver

## Run command 

    $ elixir lib/chatbotserver.ex

    Compiled into bytecode (in memory) and then run on Erlang virtual machine

### Interactive Shell

    $ iex 
    $ iex> c "lib/chatbot.ex"
    $ iex> ChatbotServer.hello("Martin")

or 

    $ iex lib/chatbotserver.ex

or 

    $ iex -S mix 

## Recompile

    $ iex> r ChatbotServer

## Help 

    h Map.put

## Pipeline of functions

    request
    |> parse
    |> route
    |> format_response


    conv = parse(request)
    conv = route(conv)
    format_response(conv)

    format_response(route(parse(request)))

## String

    parts = String.split(lines, "\n")

    List.first(parts)

    Enum.at(parts, 1)

## Variables

Assign and match a variable

    a = 2

Match the value of a variable

    ^a = 2

    [first, 2, 3] = [1, 2, 3]

## Map

Keys as Atoms 

    conv = %{ method: "GET", path: "/wildthings" }

    conv[:method] // works with all maps

    conv.method // it works because the keys are Atoms

Add a new variable in the Map

    conv = Map.put(conv, :resp_body, "Bears")

    conv = %{ conv | resp_body: "Bears, Lions, Tigers" }

## Functions

- Private defp

## Rewrite requests  for /bears?id=1 to /bears/1, /bears?id=2 to /bears/2

def rewrite_path(%{path: "/bears?id=" <> id} = conv) do
  %{ conv | path: "/bears/#{id}" }
end