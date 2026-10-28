# cf-dns

Creates and updates Cloudflare DNS records from the command line. For hosts that get a new IP after every rebuild.

## Requirements

- `curl`, `jq`
- Cloudflare API token with `Zone.DNS:Edit` in `CF_API_TOKEN`

## Usage

```bash
cf-dns set <name> <ip>      # create or update an A record
cf-dns get <name>           # print the current record
cf-dns del <name>           # delete the record (asks first)
```

`set` prints the record id and the old value when it changed one.

## Configuration

| Option         | Default       | Meaning                             |
|----------------|---------------|-------------------------------------|
| `CF_API_TOKEN` | —             | API token; required                 |
| `CF_ZONE`      | `example.com` | Zone the record belongs to          |
| `CF_TTL`       | `300`         | TTL in seconds; `1` means automatic |

## Structure

```
cf-dns/
├── cf-dns        # the script
└── doc/          # API notes and token setup
```

## More

- [doc/token.md](doc/token.md) — how to create the token with minimal scope
- License: WTFPL
