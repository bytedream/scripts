## Github Webhook

A simple webhook server, which saves a github repository whenever changes were made.

Inspired from [this webhook api](https://github.com/go-playground/webhooks).
The library is pretty useful, but too overloaded for my purposes.

#### Requires

 - [gorilla/mux](https://github.com/gorilla/mux), but if you want to, you can easily cut out the gurilla/mux api and replace it with the api you prefer

#### Usage

1. Create a repository [webhook](https://docs.github.com/en/developers/webhooks-and-events/creating-webhooks) on github.
2. Not necessary, but highly recommended: Choose a [secret](https://docs.github.com/en/developers/webhooks-and-events/securing-your-webhooks) for the webhook.
3. Set the value of `gitTree` in [main.go](main.go#L19) to the directory you want to clone the repositories in.
4. Set the value of `secret` in [main.go](main.go#L20) to the secret, you have chosen in step 2.
5. Replace the ids in `gw.AddPushEvent` and `gw.AddRepositoryEvent` in [main.go](main.go#L401) with the id of the repository you created the webhook for.
6. Set the callback path in the `main` method in [main.go](main.go#L405) to the path you have chosen when creating the webhook.
7. Set the port in the `main` method in [main.go](main.go#L407) to the port github is sending the webhook callback.
