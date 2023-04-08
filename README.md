# Llamachat

Example client for 100% local chat agent powered by [llamaste](https://github.com/jtp184/llamaste)

![example queries](https://github.com/jtp184/llamachat/blob/main/img/img_01.png?raw=true)

Sinatra server running thin client streams tokens as they are generated, and signals completion with a style change.

![partial query](https://github.com/jtp184/llamachat/blob/main/img/img_02.png?raw=true)
![completed query](https://github.com/jtp184/llamachat/blob/main/img/img_03.png?raw=true)

## Usage

```bash
git clone https://github.com/jtp184/llamachat.git
cd llamachat
bundle install
# Set up models and change the MODEL_PARAMS in app.rb
bundle exec rackup
```
Navigate to [`localhost:9292`](http://localhost:9292) to use the client
