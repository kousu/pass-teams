> ⚠️ this is a spec. the software doesn't exist yet. maybe encourage me so it doesn't become vaporware :)

# pass-teams

Collaborate with your team using [pass(1)](https://passwordstore.org).

`pass teams` expands your `pass` database with GPG keys, managing the addition and removal of team members and distribution of their keys to everyone else on the team. Keys are exposed only to the team, and GPG's awful key verification is streamlined.

## Why use a password manager at all?

All the usual reasons: it helps you avoid reusing credentials, it makes it less likely your passwords will get stolen, it lets you keep an overview of what services you're subscribed to....

## But why use a password manager _with a team_?

Better question! Keeping an overview of what services your organization has access to is still a big benefit. But using a password manager likeYour team should _not_ be sharing secrets; rather, where possible, they should be generating tokens (so: one account, multiple credentials, independently revokable) or delegating permissions to individual accounts.

Many, maybe even most, modern SaaS sites allow you to create a Team (or "Organization" or "Project" or some other noun) and add your organization's members to it. `ssh` lets you put multiple keys under `~/.ssh/authorized_keys` (especially: under `~root/.ssh/authorized_keys`) and they don't all have to be owned by the same person. These delegation methods are far far better than sharing a single personal account with multiple people. If you find yourself putting a lot of passwords into a team password manager, you won't be able to audit who did what, and your apps suck and you should get better ones.

[1password teams](https://1password.com/teams/) and [LastPass teams](https://lastpass.com/teams_trial.php) are making a lot of money off encouraging this outdated security practice and we should be very skeptical of it.

That said. the use cases I've found I can't avoid this is:

- root/sudo passwords on servers
- firmware / BIOS passwords
- WiFi credentials generated for IoT/robots
- wordpress admin passwords ([lol](https://wordpress.org/plugins/multiple-admin-email-addresses/) "hasn't been tested with the last 3 wordpress releases" it say)
- other apps that suck







## Why not passbolt?

[PassBolt](https://passbolt.com) is very similar to pass: it uses GPG to share keys. But rather than being a wrapper for pass(1), it is a [complete](https://github.com/passbolt/passbolt_api/blob/98397bba750c5757f731947ea8cfc2631e6c611e/src/Utility/OpenPGP/Backends/Gnupg.php) [reimplementation](https://github.com/passbolt/passbolt_browser_extenson/blob/264a2e35efd998826fec87c1dae3108b65ded4eb/src/all/background_page/model/openpgp/OpenpgpModel.js) as a [webapp](https://github.com/passbolt/passbolt_api) + [browser extension](https://github.com/passbolt/passbolt_browser_extenson/b), and needs [a database and webserver configured](https://help.passbolt.com/faq/hosting/how-to-install-passbolt-non-interactive). I think that is too much to maintain for a tool you need to be simple and highly reliable.

Plus they are monetized, selling a [hosted option](https://signup.passbolt.com/pricing/pro) which means their interests are not fully aligned with their users.

But my biggest concern is that, despite spending a lot of effort on making an (admittedly very nicely done) UI, it doesn't actually guarantee the security level that pass and GPG are meant to: it does not have a key verification UI. [What kind of encryption does passbolt use?](https://help.passbolt.com/faq/security/encryption-tech) claims

> Passbolt servers never have access to your passwords in clear text. 

but [How are public keys trusted?](https://help.passbolt.com/faq/security/public-key-trust) admits that keys are auto-trusted:

> Currently the client trust all the keys that are sent from the passbolt server.
> The server also trust the key sent by the client during setup. While we believe this setup
> can be sufficient for most organisations, since the keys are sent over https,
> we also acknowledge that it is far from ideal.

This means it only has the security level of security of iMessage or WhatsApp: if they choose or are compelled, they, or, you, as a self-hosted server admin, _or the server software itself_, can [insert ghost keys](https://www.theregister.com/2018/11/29/gchq_encrypted_apps/) and wait for the next user who makes changes to break the encryption for them.

`pass teams` starts by getting the key verification UI right, and builds out from there.


## Why not keyservers?

Public keyservers leak your identity. That's by design. GPG was designed in a simpler time, where they imagined everyone could have a single key, and be a single person, with a single facet of their persona. I hope we are beyond that now, and understand that people have many facets, and should be keeping separate email addresses, social media accounts, **and encryption keys** per aspect, only linking them by consent, and with the ability to limit exposure by deleting accounts (**and encryption keys**) in the future. Without compartmentalization, it is reasonably feasible to build surveillance tech that maps out people's social networks and digital movements.

It was exactly this issue that killed the SKS Keyservers: [1](https://unix.stackexchange.com/questions/656205/sks-keyservers-gone-what-to-use-instead), [2](https://www.reddit.com/r/archlinux/comments/o5rcs6/psa_you_need_to_update_your_keyserver/), [3](https://medium.com/@mdrahony/are-sks-keyservers-safe-do-we-need-them-7056b495101c): by design they were *not* compliant with the GDPR, because their security assumption was that nothing could ever be unwritten, while the GDPR says the opposite, that users must be able to delete their personal data. For example, if someone has changed their name, or wants to disassociate themselves from a project that's gone sour, they need to be able to drop their old keys and put up new ones, or make sure those _other people's_ keys that were once signed by their old identity are also erased. Once people realized this and started submitting complaints, SKS crumped under the legal pressure (And the SKS team didn't help themselves by [being stubborn about these kinds of issues](https://web.archive.org/web/20180612183516/https://bitbucket.org/skskeyserver/sks-keyserver/issues/41/web-app-displays-uids-on-keys-that-have)).

`pass teams` keeps your identity shared only amongst your team. You can choose to reuse an existing GPG key, but it's default workflow makes everyone a fresh key per `pass` repo.



## Related Work

* https://raymii.org/s/articles/GPG_noninteractive_batch_sign_trust_and_send_gnupg_keys.html
* https://www.passbolt.com/
