> ⚠️ this is a spec. the software doesn't exist yet. maybe encourage me so it doesn't become vaporware :)

# pass-teams

Collaborate with your team using pass(1)

`pass teams` stores GPG keys as part of your `pass` database, managing adding and removing team members and distributing their keys to everyone else on the team.

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

Public keyservers leak your identity. That's by design. GPG was designed in a simpler time, where they imagined everyone could have a single key, and be a single person, with a single facet of their persona. I hope we are beyond that now, and understand that people have many facets, and should be keeping separate email addresses, social media accounts, **and encryption keys** per aspect, only linking them by consent. And you should be able to remove an identity from the in

It was exactly this issue that killed the SKS Keyservers: [1](https://unix.stackexchange.com/questions/656205/sks-keyservers-gone-what-to-use-instead), [2](https://www.reddit.com/r/archlinux/comments/o5rcs6/psa_you_need_to_update_your_keyserver/), [3](https://medium.com/@mdrahony/are-sks-keyservers-safe-do-we-need-them-7056b495101c): by design they were *not* compliant with the GDPR, because their security assumption was that nothing could ever be unwritten, while the GDPR says the opposite, that users must be able to delete their personal data. For example, if someone has changed their name, or wants to disassociate themselves from a project that's gone sour, they need to be able to drop their old keys and put up new ones, or make sure those _other people's_ keys that were once signed by their old identity are also erased. (And the SKS team didn't help themselves by [being stubborn](https://web.archive.org/web/20180612183516/https://bitbucket.org/skskeyserver/sks-keyserver/issues/41/web-app-displays-uids-on-keys-that-have))

`pass teams` keeps your identity shared only amongst your team. You can choose to reuse an existing GPG key, but it's default workflow makes everyone a fresh key per `pass` repo.

## Related Work

* https://raymii.org/s/articles/GPG_noninteractive_batch_sign_trust_and_send_gnupg_keys.html
* https://www.passbolt.com/
