
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Google Identity Toolkit
## version: v3
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Help the third party sites to implement federated login.
## 
## https://developers.google.com/identity-toolkit/v3/
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "identitytoolkit"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_IdentitytoolkitRelyingpartyCreateAuthUri_593676 = ref object of OpenApiRestCall_593408
proc url_IdentitytoolkitRelyingpartyCreateAuthUri_593678(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyCreateAuthUri_593677(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates the URI used by the IdP to authenticate the user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593790 = query.getOrDefault("fields")
  valid_593790 = validateParameter(valid_593790, JString, required = false,
                                 default = nil)
  if valid_593790 != nil:
    section.add "fields", valid_593790
  var valid_593791 = query.getOrDefault("quotaUser")
  valid_593791 = validateParameter(valid_593791, JString, required = false,
                                 default = nil)
  if valid_593791 != nil:
    section.add "quotaUser", valid_593791
  var valid_593805 = query.getOrDefault("alt")
  valid_593805 = validateParameter(valid_593805, JString, required = false,
                                 default = newJString("json"))
  if valid_593805 != nil:
    section.add "alt", valid_593805
  var valid_593806 = query.getOrDefault("oauth_token")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "oauth_token", valid_593806
  var valid_593807 = query.getOrDefault("userIp")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "userIp", valid_593807
  var valid_593808 = query.getOrDefault("key")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "key", valid_593808
  var valid_593809 = query.getOrDefault("prettyPrint")
  valid_593809 = validateParameter(valid_593809, JBool, required = false,
                                 default = newJBool(true))
  if valid_593809 != nil:
    section.add "prettyPrint", valid_593809
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593833: Call_IdentitytoolkitRelyingpartyCreateAuthUri_593676;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates the URI used by the IdP to authenticate the user.
  ## 
  let valid = call_593833.validator(path, query, header, formData, body)
  let scheme = call_593833.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593833.url(scheme.get, call_593833.host, call_593833.base,
                         call_593833.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593833, url, valid)

proc call*(call_593904: Call_IdentitytoolkitRelyingpartyCreateAuthUri_593676;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## identitytoolkitRelyingpartyCreateAuthUri
  ## Creates the URI used by the IdP to authenticate the user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593905 = newJObject()
  var body_593907 = newJObject()
  add(query_593905, "fields", newJString(fields))
  add(query_593905, "quotaUser", newJString(quotaUser))
  add(query_593905, "alt", newJString(alt))
  add(query_593905, "oauth_token", newJString(oauthToken))
  add(query_593905, "userIp", newJString(userIp))
  add(query_593905, "key", newJString(key))
  if body != nil:
    body_593907 = body
  add(query_593905, "prettyPrint", newJBool(prettyPrint))
  result = call_593904.call(nil, query_593905, nil, nil, body_593907)

var identitytoolkitRelyingpartyCreateAuthUri* = Call_IdentitytoolkitRelyingpartyCreateAuthUri_593676(
    name: "identitytoolkitRelyingpartyCreateAuthUri", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/createAuthUri",
    validator: validate_IdentitytoolkitRelyingpartyCreateAuthUri_593677,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyCreateAuthUri_593678,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyDeleteAccount_593946 = ref object of OpenApiRestCall_593408
proc url_IdentitytoolkitRelyingpartyDeleteAccount_593948(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyDeleteAccount_593947(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete user account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593949 = query.getOrDefault("fields")
  valid_593949 = validateParameter(valid_593949, JString, required = false,
                                 default = nil)
  if valid_593949 != nil:
    section.add "fields", valid_593949
  var valid_593950 = query.getOrDefault("quotaUser")
  valid_593950 = validateParameter(valid_593950, JString, required = false,
                                 default = nil)
  if valid_593950 != nil:
    section.add "quotaUser", valid_593950
  var valid_593951 = query.getOrDefault("alt")
  valid_593951 = validateParameter(valid_593951, JString, required = false,
                                 default = newJString("json"))
  if valid_593951 != nil:
    section.add "alt", valid_593951
  var valid_593952 = query.getOrDefault("oauth_token")
  valid_593952 = validateParameter(valid_593952, JString, required = false,
                                 default = nil)
  if valid_593952 != nil:
    section.add "oauth_token", valid_593952
  var valid_593953 = query.getOrDefault("userIp")
  valid_593953 = validateParameter(valid_593953, JString, required = false,
                                 default = nil)
  if valid_593953 != nil:
    section.add "userIp", valid_593953
  var valid_593954 = query.getOrDefault("key")
  valid_593954 = validateParameter(valid_593954, JString, required = false,
                                 default = nil)
  if valid_593954 != nil:
    section.add "key", valid_593954
  var valid_593955 = query.getOrDefault("prettyPrint")
  valid_593955 = validateParameter(valid_593955, JBool, required = false,
                                 default = newJBool(true))
  if valid_593955 != nil:
    section.add "prettyPrint", valid_593955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593957: Call_IdentitytoolkitRelyingpartyDeleteAccount_593946;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete user account.
  ## 
  let valid = call_593957.validator(path, query, header, formData, body)
  let scheme = call_593957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593957.url(scheme.get, call_593957.host, call_593957.base,
                         call_593957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593957, url, valid)

proc call*(call_593958: Call_IdentitytoolkitRelyingpartyDeleteAccount_593946;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## identitytoolkitRelyingpartyDeleteAccount
  ## Delete user account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593959 = newJObject()
  var body_593960 = newJObject()
  add(query_593959, "fields", newJString(fields))
  add(query_593959, "quotaUser", newJString(quotaUser))
  add(query_593959, "alt", newJString(alt))
  add(query_593959, "oauth_token", newJString(oauthToken))
  add(query_593959, "userIp", newJString(userIp))
  add(query_593959, "key", newJString(key))
  if body != nil:
    body_593960 = body
  add(query_593959, "prettyPrint", newJBool(prettyPrint))
  result = call_593958.call(nil, query_593959, nil, nil, body_593960)

var identitytoolkitRelyingpartyDeleteAccount* = Call_IdentitytoolkitRelyingpartyDeleteAccount_593946(
    name: "identitytoolkitRelyingpartyDeleteAccount", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/deleteAccount",
    validator: validate_IdentitytoolkitRelyingpartyDeleteAccount_593947,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyDeleteAccount_593948,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyDownloadAccount_593961 = ref object of OpenApiRestCall_593408
proc url_IdentitytoolkitRelyingpartyDownloadAccount_593963(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyDownloadAccount_593962(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Batch download user accounts.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593964 = query.getOrDefault("fields")
  valid_593964 = validateParameter(valid_593964, JString, required = false,
                                 default = nil)
  if valid_593964 != nil:
    section.add "fields", valid_593964
  var valid_593965 = query.getOrDefault("quotaUser")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = nil)
  if valid_593965 != nil:
    section.add "quotaUser", valid_593965
  var valid_593966 = query.getOrDefault("alt")
  valid_593966 = validateParameter(valid_593966, JString, required = false,
                                 default = newJString("json"))
  if valid_593966 != nil:
    section.add "alt", valid_593966
  var valid_593967 = query.getOrDefault("oauth_token")
  valid_593967 = validateParameter(valid_593967, JString, required = false,
                                 default = nil)
  if valid_593967 != nil:
    section.add "oauth_token", valid_593967
  var valid_593968 = query.getOrDefault("userIp")
  valid_593968 = validateParameter(valid_593968, JString, required = false,
                                 default = nil)
  if valid_593968 != nil:
    section.add "userIp", valid_593968
  var valid_593969 = query.getOrDefault("key")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = nil)
  if valid_593969 != nil:
    section.add "key", valid_593969
  var valid_593970 = query.getOrDefault("prettyPrint")
  valid_593970 = validateParameter(valid_593970, JBool, required = false,
                                 default = newJBool(true))
  if valid_593970 != nil:
    section.add "prettyPrint", valid_593970
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593972: Call_IdentitytoolkitRelyingpartyDownloadAccount_593961;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Batch download user accounts.
  ## 
  let valid = call_593972.validator(path, query, header, formData, body)
  let scheme = call_593972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593972.url(scheme.get, call_593972.host, call_593972.base,
                         call_593972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593972, url, valid)

proc call*(call_593973: Call_IdentitytoolkitRelyingpartyDownloadAccount_593961;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## identitytoolkitRelyingpartyDownloadAccount
  ## Batch download user accounts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593974 = newJObject()
  var body_593975 = newJObject()
  add(query_593974, "fields", newJString(fields))
  add(query_593974, "quotaUser", newJString(quotaUser))
  add(query_593974, "alt", newJString(alt))
  add(query_593974, "oauth_token", newJString(oauthToken))
  add(query_593974, "userIp", newJString(userIp))
  add(query_593974, "key", newJString(key))
  if body != nil:
    body_593975 = body
  add(query_593974, "prettyPrint", newJBool(prettyPrint))
  result = call_593973.call(nil, query_593974, nil, nil, body_593975)

var identitytoolkitRelyingpartyDownloadAccount* = Call_IdentitytoolkitRelyingpartyDownloadAccount_593961(
    name: "identitytoolkitRelyingpartyDownloadAccount", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/downloadAccount",
    validator: validate_IdentitytoolkitRelyingpartyDownloadAccount_593962,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyDownloadAccount_593963,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyEmailLinkSignin_593976 = ref object of OpenApiRestCall_593408
proc url_IdentitytoolkitRelyingpartyEmailLinkSignin_593978(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyEmailLinkSignin_593977(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reset password for a user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593979 = query.getOrDefault("fields")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = nil)
  if valid_593979 != nil:
    section.add "fields", valid_593979
  var valid_593980 = query.getOrDefault("quotaUser")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = nil)
  if valid_593980 != nil:
    section.add "quotaUser", valid_593980
  var valid_593981 = query.getOrDefault("alt")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = newJString("json"))
  if valid_593981 != nil:
    section.add "alt", valid_593981
  var valid_593982 = query.getOrDefault("oauth_token")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "oauth_token", valid_593982
  var valid_593983 = query.getOrDefault("userIp")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "userIp", valid_593983
  var valid_593984 = query.getOrDefault("key")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "key", valid_593984
  var valid_593985 = query.getOrDefault("prettyPrint")
  valid_593985 = validateParameter(valid_593985, JBool, required = false,
                                 default = newJBool(true))
  if valid_593985 != nil:
    section.add "prettyPrint", valid_593985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593987: Call_IdentitytoolkitRelyingpartyEmailLinkSignin_593976;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reset password for a user.
  ## 
  let valid = call_593987.validator(path, query, header, formData, body)
  let scheme = call_593987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593987.url(scheme.get, call_593987.host, call_593987.base,
                         call_593987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593987, url, valid)

proc call*(call_593988: Call_IdentitytoolkitRelyingpartyEmailLinkSignin_593976;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## identitytoolkitRelyingpartyEmailLinkSignin
  ## Reset password for a user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593989 = newJObject()
  var body_593990 = newJObject()
  add(query_593989, "fields", newJString(fields))
  add(query_593989, "quotaUser", newJString(quotaUser))
  add(query_593989, "alt", newJString(alt))
  add(query_593989, "oauth_token", newJString(oauthToken))
  add(query_593989, "userIp", newJString(userIp))
  add(query_593989, "key", newJString(key))
  if body != nil:
    body_593990 = body
  add(query_593989, "prettyPrint", newJBool(prettyPrint))
  result = call_593988.call(nil, query_593989, nil, nil, body_593990)

var identitytoolkitRelyingpartyEmailLinkSignin* = Call_IdentitytoolkitRelyingpartyEmailLinkSignin_593976(
    name: "identitytoolkitRelyingpartyEmailLinkSignin", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/emailLinkSignin",
    validator: validate_IdentitytoolkitRelyingpartyEmailLinkSignin_593977,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyEmailLinkSignin_593978,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyGetAccountInfo_593991 = ref object of OpenApiRestCall_593408
proc url_IdentitytoolkitRelyingpartyGetAccountInfo_593993(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyGetAccountInfo_593992(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the account info.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593994 = query.getOrDefault("fields")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "fields", valid_593994
  var valid_593995 = query.getOrDefault("quotaUser")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "quotaUser", valid_593995
  var valid_593996 = query.getOrDefault("alt")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = newJString("json"))
  if valid_593996 != nil:
    section.add "alt", valid_593996
  var valid_593997 = query.getOrDefault("oauth_token")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "oauth_token", valid_593997
  var valid_593998 = query.getOrDefault("userIp")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "userIp", valid_593998
  var valid_593999 = query.getOrDefault("key")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "key", valid_593999
  var valid_594000 = query.getOrDefault("prettyPrint")
  valid_594000 = validateParameter(valid_594000, JBool, required = false,
                                 default = newJBool(true))
  if valid_594000 != nil:
    section.add "prettyPrint", valid_594000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594002: Call_IdentitytoolkitRelyingpartyGetAccountInfo_593991;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the account info.
  ## 
  let valid = call_594002.validator(path, query, header, formData, body)
  let scheme = call_594002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594002.url(scheme.get, call_594002.host, call_594002.base,
                         call_594002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594002, url, valid)

proc call*(call_594003: Call_IdentitytoolkitRelyingpartyGetAccountInfo_593991;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## identitytoolkitRelyingpartyGetAccountInfo
  ## Returns the account info.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594004 = newJObject()
  var body_594005 = newJObject()
  add(query_594004, "fields", newJString(fields))
  add(query_594004, "quotaUser", newJString(quotaUser))
  add(query_594004, "alt", newJString(alt))
  add(query_594004, "oauth_token", newJString(oauthToken))
  add(query_594004, "userIp", newJString(userIp))
  add(query_594004, "key", newJString(key))
  if body != nil:
    body_594005 = body
  add(query_594004, "prettyPrint", newJBool(prettyPrint))
  result = call_594003.call(nil, query_594004, nil, nil, body_594005)

var identitytoolkitRelyingpartyGetAccountInfo* = Call_IdentitytoolkitRelyingpartyGetAccountInfo_593991(
    name: "identitytoolkitRelyingpartyGetAccountInfo", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/getAccountInfo",
    validator: validate_IdentitytoolkitRelyingpartyGetAccountInfo_593992,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyGetAccountInfo_593993,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyGetOobConfirmationCode_594006 = ref object of OpenApiRestCall_593408
proc url_IdentitytoolkitRelyingpartyGetOobConfirmationCode_594008(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyGetOobConfirmationCode_594007(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get a code for user action confirmation.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594009 = query.getOrDefault("fields")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "fields", valid_594009
  var valid_594010 = query.getOrDefault("quotaUser")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "quotaUser", valid_594010
  var valid_594011 = query.getOrDefault("alt")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = newJString("json"))
  if valid_594011 != nil:
    section.add "alt", valid_594011
  var valid_594012 = query.getOrDefault("oauth_token")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "oauth_token", valid_594012
  var valid_594013 = query.getOrDefault("userIp")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "userIp", valid_594013
  var valid_594014 = query.getOrDefault("key")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "key", valid_594014
  var valid_594015 = query.getOrDefault("prettyPrint")
  valid_594015 = validateParameter(valid_594015, JBool, required = false,
                                 default = newJBool(true))
  if valid_594015 != nil:
    section.add "prettyPrint", valid_594015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594017: Call_IdentitytoolkitRelyingpartyGetOobConfirmationCode_594006;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a code for user action confirmation.
  ## 
  let valid = call_594017.validator(path, query, header, formData, body)
  let scheme = call_594017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594017.url(scheme.get, call_594017.host, call_594017.base,
                         call_594017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594017, url, valid)

proc call*(call_594018: Call_IdentitytoolkitRelyingpartyGetOobConfirmationCode_594006;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## identitytoolkitRelyingpartyGetOobConfirmationCode
  ## Get a code for user action confirmation.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594019 = newJObject()
  var body_594020 = newJObject()
  add(query_594019, "fields", newJString(fields))
  add(query_594019, "quotaUser", newJString(quotaUser))
  add(query_594019, "alt", newJString(alt))
  add(query_594019, "oauth_token", newJString(oauthToken))
  add(query_594019, "userIp", newJString(userIp))
  add(query_594019, "key", newJString(key))
  if body != nil:
    body_594020 = body
  add(query_594019, "prettyPrint", newJBool(prettyPrint))
  result = call_594018.call(nil, query_594019, nil, nil, body_594020)

var identitytoolkitRelyingpartyGetOobConfirmationCode* = Call_IdentitytoolkitRelyingpartyGetOobConfirmationCode_594006(
    name: "identitytoolkitRelyingpartyGetOobConfirmationCode",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/getOobConfirmationCode",
    validator: validate_IdentitytoolkitRelyingpartyGetOobConfirmationCode_594007,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyGetOobConfirmationCode_594008,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyGetProjectConfig_594021 = ref object of OpenApiRestCall_593408
proc url_IdentitytoolkitRelyingpartyGetProjectConfig_594023(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyGetProjectConfig_594022(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get project configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   delegatedProjectNumber: JString
  ##                         : Delegated GCP project number of the request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectNumber: JString
  ##                : GCP project number of the request.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594024 = query.getOrDefault("fields")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "fields", valid_594024
  var valid_594025 = query.getOrDefault("quotaUser")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "quotaUser", valid_594025
  var valid_594026 = query.getOrDefault("delegatedProjectNumber")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "delegatedProjectNumber", valid_594026
  var valid_594027 = query.getOrDefault("alt")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = newJString("json"))
  if valid_594027 != nil:
    section.add "alt", valid_594027
  var valid_594028 = query.getOrDefault("oauth_token")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "oauth_token", valid_594028
  var valid_594029 = query.getOrDefault("userIp")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "userIp", valid_594029
  var valid_594030 = query.getOrDefault("key")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "key", valid_594030
  var valid_594031 = query.getOrDefault("projectNumber")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "projectNumber", valid_594031
  var valid_594032 = query.getOrDefault("prettyPrint")
  valid_594032 = validateParameter(valid_594032, JBool, required = false,
                                 default = newJBool(true))
  if valid_594032 != nil:
    section.add "prettyPrint", valid_594032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594033: Call_IdentitytoolkitRelyingpartyGetProjectConfig_594021;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get project configuration.
  ## 
  let valid = call_594033.validator(path, query, header, formData, body)
  let scheme = call_594033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594033.url(scheme.get, call_594033.host, call_594033.base,
                         call_594033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594033, url, valid)

proc call*(call_594034: Call_IdentitytoolkitRelyingpartyGetProjectConfig_594021;
          fields: string = ""; quotaUser: string = "";
          delegatedProjectNumber: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          projectNumber: string = ""; prettyPrint: bool = true): Recallable =
  ## identitytoolkitRelyingpartyGetProjectConfig
  ## Get project configuration.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   delegatedProjectNumber: string
  ##                         : Delegated GCP project number of the request.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectNumber: string
  ##                : GCP project number of the request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594035 = newJObject()
  add(query_594035, "fields", newJString(fields))
  add(query_594035, "quotaUser", newJString(quotaUser))
  add(query_594035, "delegatedProjectNumber", newJString(delegatedProjectNumber))
  add(query_594035, "alt", newJString(alt))
  add(query_594035, "oauth_token", newJString(oauthToken))
  add(query_594035, "userIp", newJString(userIp))
  add(query_594035, "key", newJString(key))
  add(query_594035, "projectNumber", newJString(projectNumber))
  add(query_594035, "prettyPrint", newJBool(prettyPrint))
  result = call_594034.call(nil, query_594035, nil, nil, nil)

var identitytoolkitRelyingpartyGetProjectConfig* = Call_IdentitytoolkitRelyingpartyGetProjectConfig_594021(
    name: "identitytoolkitRelyingpartyGetProjectConfig", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/getProjectConfig",
    validator: validate_IdentitytoolkitRelyingpartyGetProjectConfig_594022,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyGetProjectConfig_594023,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyGetRecaptchaParam_594036 = ref object of OpenApiRestCall_593408
proc url_IdentitytoolkitRelyingpartyGetRecaptchaParam_594038(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyGetRecaptchaParam_594037(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get recaptcha secure param.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594039 = query.getOrDefault("fields")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "fields", valid_594039
  var valid_594040 = query.getOrDefault("quotaUser")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "quotaUser", valid_594040
  var valid_594041 = query.getOrDefault("alt")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = newJString("json"))
  if valid_594041 != nil:
    section.add "alt", valid_594041
  var valid_594042 = query.getOrDefault("oauth_token")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "oauth_token", valid_594042
  var valid_594043 = query.getOrDefault("userIp")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "userIp", valid_594043
  var valid_594044 = query.getOrDefault("key")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "key", valid_594044
  var valid_594045 = query.getOrDefault("prettyPrint")
  valid_594045 = validateParameter(valid_594045, JBool, required = false,
                                 default = newJBool(true))
  if valid_594045 != nil:
    section.add "prettyPrint", valid_594045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594046: Call_IdentitytoolkitRelyingpartyGetRecaptchaParam_594036;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get recaptcha secure param.
  ## 
  let valid = call_594046.validator(path, query, header, formData, body)
  let scheme = call_594046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594046.url(scheme.get, call_594046.host, call_594046.base,
                         call_594046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594046, url, valid)

proc call*(call_594047: Call_IdentitytoolkitRelyingpartyGetRecaptchaParam_594036;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## identitytoolkitRelyingpartyGetRecaptchaParam
  ## Get recaptcha secure param.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594048 = newJObject()
  add(query_594048, "fields", newJString(fields))
  add(query_594048, "quotaUser", newJString(quotaUser))
  add(query_594048, "alt", newJString(alt))
  add(query_594048, "oauth_token", newJString(oauthToken))
  add(query_594048, "userIp", newJString(userIp))
  add(query_594048, "key", newJString(key))
  add(query_594048, "prettyPrint", newJBool(prettyPrint))
  result = call_594047.call(nil, query_594048, nil, nil, nil)

var identitytoolkitRelyingpartyGetRecaptchaParam* = Call_IdentitytoolkitRelyingpartyGetRecaptchaParam_594036(
    name: "identitytoolkitRelyingpartyGetRecaptchaParam",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/getRecaptchaParam",
    validator: validate_IdentitytoolkitRelyingpartyGetRecaptchaParam_594037,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyGetRecaptchaParam_594038,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyGetPublicKeys_594049 = ref object of OpenApiRestCall_593408
proc url_IdentitytoolkitRelyingpartyGetPublicKeys_594051(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyGetPublicKeys_594050(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get token signing public key.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594052 = query.getOrDefault("fields")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "fields", valid_594052
  var valid_594053 = query.getOrDefault("quotaUser")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "quotaUser", valid_594053
  var valid_594054 = query.getOrDefault("alt")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = newJString("json"))
  if valid_594054 != nil:
    section.add "alt", valid_594054
  var valid_594055 = query.getOrDefault("oauth_token")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "oauth_token", valid_594055
  var valid_594056 = query.getOrDefault("userIp")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "userIp", valid_594056
  var valid_594057 = query.getOrDefault("key")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "key", valid_594057
  var valid_594058 = query.getOrDefault("prettyPrint")
  valid_594058 = validateParameter(valid_594058, JBool, required = false,
                                 default = newJBool(true))
  if valid_594058 != nil:
    section.add "prettyPrint", valid_594058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594059: Call_IdentitytoolkitRelyingpartyGetPublicKeys_594049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get token signing public key.
  ## 
  let valid = call_594059.validator(path, query, header, formData, body)
  let scheme = call_594059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594059.url(scheme.get, call_594059.host, call_594059.base,
                         call_594059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594059, url, valid)

proc call*(call_594060: Call_IdentitytoolkitRelyingpartyGetPublicKeys_594049;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## identitytoolkitRelyingpartyGetPublicKeys
  ## Get token signing public key.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594061 = newJObject()
  add(query_594061, "fields", newJString(fields))
  add(query_594061, "quotaUser", newJString(quotaUser))
  add(query_594061, "alt", newJString(alt))
  add(query_594061, "oauth_token", newJString(oauthToken))
  add(query_594061, "userIp", newJString(userIp))
  add(query_594061, "key", newJString(key))
  add(query_594061, "prettyPrint", newJBool(prettyPrint))
  result = call_594060.call(nil, query_594061, nil, nil, nil)

var identitytoolkitRelyingpartyGetPublicKeys* = Call_IdentitytoolkitRelyingpartyGetPublicKeys_594049(
    name: "identitytoolkitRelyingpartyGetPublicKeys", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/publicKeys",
    validator: validate_IdentitytoolkitRelyingpartyGetPublicKeys_594050,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyGetPublicKeys_594051,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyResetPassword_594062 = ref object of OpenApiRestCall_593408
proc url_IdentitytoolkitRelyingpartyResetPassword_594064(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyResetPassword_594063(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reset password for a user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594065 = query.getOrDefault("fields")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "fields", valid_594065
  var valid_594066 = query.getOrDefault("quotaUser")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "quotaUser", valid_594066
  var valid_594067 = query.getOrDefault("alt")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = newJString("json"))
  if valid_594067 != nil:
    section.add "alt", valid_594067
  var valid_594068 = query.getOrDefault("oauth_token")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "oauth_token", valid_594068
  var valid_594069 = query.getOrDefault("userIp")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "userIp", valid_594069
  var valid_594070 = query.getOrDefault("key")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "key", valid_594070
  var valid_594071 = query.getOrDefault("prettyPrint")
  valid_594071 = validateParameter(valid_594071, JBool, required = false,
                                 default = newJBool(true))
  if valid_594071 != nil:
    section.add "prettyPrint", valid_594071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594073: Call_IdentitytoolkitRelyingpartyResetPassword_594062;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reset password for a user.
  ## 
  let valid = call_594073.validator(path, query, header, formData, body)
  let scheme = call_594073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594073.url(scheme.get, call_594073.host, call_594073.base,
                         call_594073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594073, url, valid)

proc call*(call_594074: Call_IdentitytoolkitRelyingpartyResetPassword_594062;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## identitytoolkitRelyingpartyResetPassword
  ## Reset password for a user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594075 = newJObject()
  var body_594076 = newJObject()
  add(query_594075, "fields", newJString(fields))
  add(query_594075, "quotaUser", newJString(quotaUser))
  add(query_594075, "alt", newJString(alt))
  add(query_594075, "oauth_token", newJString(oauthToken))
  add(query_594075, "userIp", newJString(userIp))
  add(query_594075, "key", newJString(key))
  if body != nil:
    body_594076 = body
  add(query_594075, "prettyPrint", newJBool(prettyPrint))
  result = call_594074.call(nil, query_594075, nil, nil, body_594076)

var identitytoolkitRelyingpartyResetPassword* = Call_IdentitytoolkitRelyingpartyResetPassword_594062(
    name: "identitytoolkitRelyingpartyResetPassword", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/resetPassword",
    validator: validate_IdentitytoolkitRelyingpartyResetPassword_594063,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyResetPassword_594064,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartySendVerificationCode_594077 = ref object of OpenApiRestCall_593408
proc url_IdentitytoolkitRelyingpartySendVerificationCode_594079(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartySendVerificationCode_594078(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Send SMS verification code.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594080 = query.getOrDefault("fields")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "fields", valid_594080
  var valid_594081 = query.getOrDefault("quotaUser")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "quotaUser", valid_594081
  var valid_594082 = query.getOrDefault("alt")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = newJString("json"))
  if valid_594082 != nil:
    section.add "alt", valid_594082
  var valid_594083 = query.getOrDefault("oauth_token")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "oauth_token", valid_594083
  var valid_594084 = query.getOrDefault("userIp")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "userIp", valid_594084
  var valid_594085 = query.getOrDefault("key")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "key", valid_594085
  var valid_594086 = query.getOrDefault("prettyPrint")
  valid_594086 = validateParameter(valid_594086, JBool, required = false,
                                 default = newJBool(true))
  if valid_594086 != nil:
    section.add "prettyPrint", valid_594086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594088: Call_IdentitytoolkitRelyingpartySendVerificationCode_594077;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Send SMS verification code.
  ## 
  let valid = call_594088.validator(path, query, header, formData, body)
  let scheme = call_594088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594088.url(scheme.get, call_594088.host, call_594088.base,
                         call_594088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594088, url, valid)

proc call*(call_594089: Call_IdentitytoolkitRelyingpartySendVerificationCode_594077;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## identitytoolkitRelyingpartySendVerificationCode
  ## Send SMS verification code.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594090 = newJObject()
  var body_594091 = newJObject()
  add(query_594090, "fields", newJString(fields))
  add(query_594090, "quotaUser", newJString(quotaUser))
  add(query_594090, "alt", newJString(alt))
  add(query_594090, "oauth_token", newJString(oauthToken))
  add(query_594090, "userIp", newJString(userIp))
  add(query_594090, "key", newJString(key))
  if body != nil:
    body_594091 = body
  add(query_594090, "prettyPrint", newJBool(prettyPrint))
  result = call_594089.call(nil, query_594090, nil, nil, body_594091)

var identitytoolkitRelyingpartySendVerificationCode* = Call_IdentitytoolkitRelyingpartySendVerificationCode_594077(
    name: "identitytoolkitRelyingpartySendVerificationCode",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/sendVerificationCode",
    validator: validate_IdentitytoolkitRelyingpartySendVerificationCode_594078,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartySendVerificationCode_594079,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartySetAccountInfo_594092 = ref object of OpenApiRestCall_593408
proc url_IdentitytoolkitRelyingpartySetAccountInfo_594094(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartySetAccountInfo_594093(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Set account info for a user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594095 = query.getOrDefault("fields")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "fields", valid_594095
  var valid_594096 = query.getOrDefault("quotaUser")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = nil)
  if valid_594096 != nil:
    section.add "quotaUser", valid_594096
  var valid_594097 = query.getOrDefault("alt")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = newJString("json"))
  if valid_594097 != nil:
    section.add "alt", valid_594097
  var valid_594098 = query.getOrDefault("oauth_token")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "oauth_token", valid_594098
  var valid_594099 = query.getOrDefault("userIp")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "userIp", valid_594099
  var valid_594100 = query.getOrDefault("key")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "key", valid_594100
  var valid_594101 = query.getOrDefault("prettyPrint")
  valid_594101 = validateParameter(valid_594101, JBool, required = false,
                                 default = newJBool(true))
  if valid_594101 != nil:
    section.add "prettyPrint", valid_594101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594103: Call_IdentitytoolkitRelyingpartySetAccountInfo_594092;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Set account info for a user.
  ## 
  let valid = call_594103.validator(path, query, header, formData, body)
  let scheme = call_594103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594103.url(scheme.get, call_594103.host, call_594103.base,
                         call_594103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594103, url, valid)

proc call*(call_594104: Call_IdentitytoolkitRelyingpartySetAccountInfo_594092;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## identitytoolkitRelyingpartySetAccountInfo
  ## Set account info for a user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594105 = newJObject()
  var body_594106 = newJObject()
  add(query_594105, "fields", newJString(fields))
  add(query_594105, "quotaUser", newJString(quotaUser))
  add(query_594105, "alt", newJString(alt))
  add(query_594105, "oauth_token", newJString(oauthToken))
  add(query_594105, "userIp", newJString(userIp))
  add(query_594105, "key", newJString(key))
  if body != nil:
    body_594106 = body
  add(query_594105, "prettyPrint", newJBool(prettyPrint))
  result = call_594104.call(nil, query_594105, nil, nil, body_594106)

var identitytoolkitRelyingpartySetAccountInfo* = Call_IdentitytoolkitRelyingpartySetAccountInfo_594092(
    name: "identitytoolkitRelyingpartySetAccountInfo", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/setAccountInfo",
    validator: validate_IdentitytoolkitRelyingpartySetAccountInfo_594093,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartySetAccountInfo_594094,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartySetProjectConfig_594107 = ref object of OpenApiRestCall_593408
proc url_IdentitytoolkitRelyingpartySetProjectConfig_594109(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartySetProjectConfig_594108(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Set project configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594110 = query.getOrDefault("fields")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = nil)
  if valid_594110 != nil:
    section.add "fields", valid_594110
  var valid_594111 = query.getOrDefault("quotaUser")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "quotaUser", valid_594111
  var valid_594112 = query.getOrDefault("alt")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = newJString("json"))
  if valid_594112 != nil:
    section.add "alt", valid_594112
  var valid_594113 = query.getOrDefault("oauth_token")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = nil)
  if valid_594113 != nil:
    section.add "oauth_token", valid_594113
  var valid_594114 = query.getOrDefault("userIp")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "userIp", valid_594114
  var valid_594115 = query.getOrDefault("key")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "key", valid_594115
  var valid_594116 = query.getOrDefault("prettyPrint")
  valid_594116 = validateParameter(valid_594116, JBool, required = false,
                                 default = newJBool(true))
  if valid_594116 != nil:
    section.add "prettyPrint", valid_594116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594118: Call_IdentitytoolkitRelyingpartySetProjectConfig_594107;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Set project configuration.
  ## 
  let valid = call_594118.validator(path, query, header, formData, body)
  let scheme = call_594118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594118.url(scheme.get, call_594118.host, call_594118.base,
                         call_594118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594118, url, valid)

proc call*(call_594119: Call_IdentitytoolkitRelyingpartySetProjectConfig_594107;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## identitytoolkitRelyingpartySetProjectConfig
  ## Set project configuration.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594120 = newJObject()
  var body_594121 = newJObject()
  add(query_594120, "fields", newJString(fields))
  add(query_594120, "quotaUser", newJString(quotaUser))
  add(query_594120, "alt", newJString(alt))
  add(query_594120, "oauth_token", newJString(oauthToken))
  add(query_594120, "userIp", newJString(userIp))
  add(query_594120, "key", newJString(key))
  if body != nil:
    body_594121 = body
  add(query_594120, "prettyPrint", newJBool(prettyPrint))
  result = call_594119.call(nil, query_594120, nil, nil, body_594121)

var identitytoolkitRelyingpartySetProjectConfig* = Call_IdentitytoolkitRelyingpartySetProjectConfig_594107(
    name: "identitytoolkitRelyingpartySetProjectConfig",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/setProjectConfig",
    validator: validate_IdentitytoolkitRelyingpartySetProjectConfig_594108,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartySetProjectConfig_594109,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartySignOutUser_594122 = ref object of OpenApiRestCall_593408
proc url_IdentitytoolkitRelyingpartySignOutUser_594124(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartySignOutUser_594123(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sign out user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594125 = query.getOrDefault("fields")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = nil)
  if valid_594125 != nil:
    section.add "fields", valid_594125
  var valid_594126 = query.getOrDefault("quotaUser")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = nil)
  if valid_594126 != nil:
    section.add "quotaUser", valid_594126
  var valid_594127 = query.getOrDefault("alt")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = newJString("json"))
  if valid_594127 != nil:
    section.add "alt", valid_594127
  var valid_594128 = query.getOrDefault("oauth_token")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "oauth_token", valid_594128
  var valid_594129 = query.getOrDefault("userIp")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = nil)
  if valid_594129 != nil:
    section.add "userIp", valid_594129
  var valid_594130 = query.getOrDefault("key")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = nil)
  if valid_594130 != nil:
    section.add "key", valid_594130
  var valid_594131 = query.getOrDefault("prettyPrint")
  valid_594131 = validateParameter(valid_594131, JBool, required = false,
                                 default = newJBool(true))
  if valid_594131 != nil:
    section.add "prettyPrint", valid_594131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594133: Call_IdentitytoolkitRelyingpartySignOutUser_594122;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sign out user.
  ## 
  let valid = call_594133.validator(path, query, header, formData, body)
  let scheme = call_594133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594133.url(scheme.get, call_594133.host, call_594133.base,
                         call_594133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594133, url, valid)

proc call*(call_594134: Call_IdentitytoolkitRelyingpartySignOutUser_594122;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## identitytoolkitRelyingpartySignOutUser
  ## Sign out user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594135 = newJObject()
  var body_594136 = newJObject()
  add(query_594135, "fields", newJString(fields))
  add(query_594135, "quotaUser", newJString(quotaUser))
  add(query_594135, "alt", newJString(alt))
  add(query_594135, "oauth_token", newJString(oauthToken))
  add(query_594135, "userIp", newJString(userIp))
  add(query_594135, "key", newJString(key))
  if body != nil:
    body_594136 = body
  add(query_594135, "prettyPrint", newJBool(prettyPrint))
  result = call_594134.call(nil, query_594135, nil, nil, body_594136)

var identitytoolkitRelyingpartySignOutUser* = Call_IdentitytoolkitRelyingpartySignOutUser_594122(
    name: "identitytoolkitRelyingpartySignOutUser", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/signOutUser",
    validator: validate_IdentitytoolkitRelyingpartySignOutUser_594123,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartySignOutUser_594124,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartySignupNewUser_594137 = ref object of OpenApiRestCall_593408
proc url_IdentitytoolkitRelyingpartySignupNewUser_594139(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartySignupNewUser_594138(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Signup new user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594140 = query.getOrDefault("fields")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "fields", valid_594140
  var valid_594141 = query.getOrDefault("quotaUser")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = nil)
  if valid_594141 != nil:
    section.add "quotaUser", valid_594141
  var valid_594142 = query.getOrDefault("alt")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = newJString("json"))
  if valid_594142 != nil:
    section.add "alt", valid_594142
  var valid_594143 = query.getOrDefault("oauth_token")
  valid_594143 = validateParameter(valid_594143, JString, required = false,
                                 default = nil)
  if valid_594143 != nil:
    section.add "oauth_token", valid_594143
  var valid_594144 = query.getOrDefault("userIp")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = nil)
  if valid_594144 != nil:
    section.add "userIp", valid_594144
  var valid_594145 = query.getOrDefault("key")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "key", valid_594145
  var valid_594146 = query.getOrDefault("prettyPrint")
  valid_594146 = validateParameter(valid_594146, JBool, required = false,
                                 default = newJBool(true))
  if valid_594146 != nil:
    section.add "prettyPrint", valid_594146
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594148: Call_IdentitytoolkitRelyingpartySignupNewUser_594137;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Signup new user.
  ## 
  let valid = call_594148.validator(path, query, header, formData, body)
  let scheme = call_594148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594148.url(scheme.get, call_594148.host, call_594148.base,
                         call_594148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594148, url, valid)

proc call*(call_594149: Call_IdentitytoolkitRelyingpartySignupNewUser_594137;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## identitytoolkitRelyingpartySignupNewUser
  ## Signup new user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594150 = newJObject()
  var body_594151 = newJObject()
  add(query_594150, "fields", newJString(fields))
  add(query_594150, "quotaUser", newJString(quotaUser))
  add(query_594150, "alt", newJString(alt))
  add(query_594150, "oauth_token", newJString(oauthToken))
  add(query_594150, "userIp", newJString(userIp))
  add(query_594150, "key", newJString(key))
  if body != nil:
    body_594151 = body
  add(query_594150, "prettyPrint", newJBool(prettyPrint))
  result = call_594149.call(nil, query_594150, nil, nil, body_594151)

var identitytoolkitRelyingpartySignupNewUser* = Call_IdentitytoolkitRelyingpartySignupNewUser_594137(
    name: "identitytoolkitRelyingpartySignupNewUser", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/signupNewUser",
    validator: validate_IdentitytoolkitRelyingpartySignupNewUser_594138,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartySignupNewUser_594139,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyUploadAccount_594152 = ref object of OpenApiRestCall_593408
proc url_IdentitytoolkitRelyingpartyUploadAccount_594154(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyUploadAccount_594153(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Batch upload existing user accounts.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594155 = query.getOrDefault("fields")
  valid_594155 = validateParameter(valid_594155, JString, required = false,
                                 default = nil)
  if valid_594155 != nil:
    section.add "fields", valid_594155
  var valid_594156 = query.getOrDefault("quotaUser")
  valid_594156 = validateParameter(valid_594156, JString, required = false,
                                 default = nil)
  if valid_594156 != nil:
    section.add "quotaUser", valid_594156
  var valid_594157 = query.getOrDefault("alt")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = newJString("json"))
  if valid_594157 != nil:
    section.add "alt", valid_594157
  var valid_594158 = query.getOrDefault("oauth_token")
  valid_594158 = validateParameter(valid_594158, JString, required = false,
                                 default = nil)
  if valid_594158 != nil:
    section.add "oauth_token", valid_594158
  var valid_594159 = query.getOrDefault("userIp")
  valid_594159 = validateParameter(valid_594159, JString, required = false,
                                 default = nil)
  if valid_594159 != nil:
    section.add "userIp", valid_594159
  var valid_594160 = query.getOrDefault("key")
  valid_594160 = validateParameter(valid_594160, JString, required = false,
                                 default = nil)
  if valid_594160 != nil:
    section.add "key", valid_594160
  var valid_594161 = query.getOrDefault("prettyPrint")
  valid_594161 = validateParameter(valid_594161, JBool, required = false,
                                 default = newJBool(true))
  if valid_594161 != nil:
    section.add "prettyPrint", valid_594161
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594163: Call_IdentitytoolkitRelyingpartyUploadAccount_594152;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Batch upload existing user accounts.
  ## 
  let valid = call_594163.validator(path, query, header, formData, body)
  let scheme = call_594163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594163.url(scheme.get, call_594163.host, call_594163.base,
                         call_594163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594163, url, valid)

proc call*(call_594164: Call_IdentitytoolkitRelyingpartyUploadAccount_594152;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## identitytoolkitRelyingpartyUploadAccount
  ## Batch upload existing user accounts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594165 = newJObject()
  var body_594166 = newJObject()
  add(query_594165, "fields", newJString(fields))
  add(query_594165, "quotaUser", newJString(quotaUser))
  add(query_594165, "alt", newJString(alt))
  add(query_594165, "oauth_token", newJString(oauthToken))
  add(query_594165, "userIp", newJString(userIp))
  add(query_594165, "key", newJString(key))
  if body != nil:
    body_594166 = body
  add(query_594165, "prettyPrint", newJBool(prettyPrint))
  result = call_594164.call(nil, query_594165, nil, nil, body_594166)

var identitytoolkitRelyingpartyUploadAccount* = Call_IdentitytoolkitRelyingpartyUploadAccount_594152(
    name: "identitytoolkitRelyingpartyUploadAccount", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/uploadAccount",
    validator: validate_IdentitytoolkitRelyingpartyUploadAccount_594153,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyUploadAccount_594154,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyVerifyAssertion_594167 = ref object of OpenApiRestCall_593408
proc url_IdentitytoolkitRelyingpartyVerifyAssertion_594169(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyVerifyAssertion_594168(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Verifies the assertion returned by the IdP.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594170 = query.getOrDefault("fields")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "fields", valid_594170
  var valid_594171 = query.getOrDefault("quotaUser")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = nil)
  if valid_594171 != nil:
    section.add "quotaUser", valid_594171
  var valid_594172 = query.getOrDefault("alt")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = newJString("json"))
  if valid_594172 != nil:
    section.add "alt", valid_594172
  var valid_594173 = query.getOrDefault("oauth_token")
  valid_594173 = validateParameter(valid_594173, JString, required = false,
                                 default = nil)
  if valid_594173 != nil:
    section.add "oauth_token", valid_594173
  var valid_594174 = query.getOrDefault("userIp")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = nil)
  if valid_594174 != nil:
    section.add "userIp", valid_594174
  var valid_594175 = query.getOrDefault("key")
  valid_594175 = validateParameter(valid_594175, JString, required = false,
                                 default = nil)
  if valid_594175 != nil:
    section.add "key", valid_594175
  var valid_594176 = query.getOrDefault("prettyPrint")
  valid_594176 = validateParameter(valid_594176, JBool, required = false,
                                 default = newJBool(true))
  if valid_594176 != nil:
    section.add "prettyPrint", valid_594176
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594178: Call_IdentitytoolkitRelyingpartyVerifyAssertion_594167;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verifies the assertion returned by the IdP.
  ## 
  let valid = call_594178.validator(path, query, header, formData, body)
  let scheme = call_594178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594178.url(scheme.get, call_594178.host, call_594178.base,
                         call_594178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594178, url, valid)

proc call*(call_594179: Call_IdentitytoolkitRelyingpartyVerifyAssertion_594167;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## identitytoolkitRelyingpartyVerifyAssertion
  ## Verifies the assertion returned by the IdP.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594180 = newJObject()
  var body_594181 = newJObject()
  add(query_594180, "fields", newJString(fields))
  add(query_594180, "quotaUser", newJString(quotaUser))
  add(query_594180, "alt", newJString(alt))
  add(query_594180, "oauth_token", newJString(oauthToken))
  add(query_594180, "userIp", newJString(userIp))
  add(query_594180, "key", newJString(key))
  if body != nil:
    body_594181 = body
  add(query_594180, "prettyPrint", newJBool(prettyPrint))
  result = call_594179.call(nil, query_594180, nil, nil, body_594181)

var identitytoolkitRelyingpartyVerifyAssertion* = Call_IdentitytoolkitRelyingpartyVerifyAssertion_594167(
    name: "identitytoolkitRelyingpartyVerifyAssertion", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/verifyAssertion",
    validator: validate_IdentitytoolkitRelyingpartyVerifyAssertion_594168,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyVerifyAssertion_594169,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyVerifyCustomToken_594182 = ref object of OpenApiRestCall_593408
proc url_IdentitytoolkitRelyingpartyVerifyCustomToken_594184(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyVerifyCustomToken_594183(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Verifies the developer asserted ID token.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594185 = query.getOrDefault("fields")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = nil)
  if valid_594185 != nil:
    section.add "fields", valid_594185
  var valid_594186 = query.getOrDefault("quotaUser")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = nil)
  if valid_594186 != nil:
    section.add "quotaUser", valid_594186
  var valid_594187 = query.getOrDefault("alt")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = newJString("json"))
  if valid_594187 != nil:
    section.add "alt", valid_594187
  var valid_594188 = query.getOrDefault("oauth_token")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = nil)
  if valid_594188 != nil:
    section.add "oauth_token", valid_594188
  var valid_594189 = query.getOrDefault("userIp")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = nil)
  if valid_594189 != nil:
    section.add "userIp", valid_594189
  var valid_594190 = query.getOrDefault("key")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = nil)
  if valid_594190 != nil:
    section.add "key", valid_594190
  var valid_594191 = query.getOrDefault("prettyPrint")
  valid_594191 = validateParameter(valid_594191, JBool, required = false,
                                 default = newJBool(true))
  if valid_594191 != nil:
    section.add "prettyPrint", valid_594191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594193: Call_IdentitytoolkitRelyingpartyVerifyCustomToken_594182;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verifies the developer asserted ID token.
  ## 
  let valid = call_594193.validator(path, query, header, formData, body)
  let scheme = call_594193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594193.url(scheme.get, call_594193.host, call_594193.base,
                         call_594193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594193, url, valid)

proc call*(call_594194: Call_IdentitytoolkitRelyingpartyVerifyCustomToken_594182;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## identitytoolkitRelyingpartyVerifyCustomToken
  ## Verifies the developer asserted ID token.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594195 = newJObject()
  var body_594196 = newJObject()
  add(query_594195, "fields", newJString(fields))
  add(query_594195, "quotaUser", newJString(quotaUser))
  add(query_594195, "alt", newJString(alt))
  add(query_594195, "oauth_token", newJString(oauthToken))
  add(query_594195, "userIp", newJString(userIp))
  add(query_594195, "key", newJString(key))
  if body != nil:
    body_594196 = body
  add(query_594195, "prettyPrint", newJBool(prettyPrint))
  result = call_594194.call(nil, query_594195, nil, nil, body_594196)

var identitytoolkitRelyingpartyVerifyCustomToken* = Call_IdentitytoolkitRelyingpartyVerifyCustomToken_594182(
    name: "identitytoolkitRelyingpartyVerifyCustomToken",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/verifyCustomToken",
    validator: validate_IdentitytoolkitRelyingpartyVerifyCustomToken_594183,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyVerifyCustomToken_594184,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyVerifyPassword_594197 = ref object of OpenApiRestCall_593408
proc url_IdentitytoolkitRelyingpartyVerifyPassword_594199(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyVerifyPassword_594198(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Verifies the user entered password.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594200 = query.getOrDefault("fields")
  valid_594200 = validateParameter(valid_594200, JString, required = false,
                                 default = nil)
  if valid_594200 != nil:
    section.add "fields", valid_594200
  var valid_594201 = query.getOrDefault("quotaUser")
  valid_594201 = validateParameter(valid_594201, JString, required = false,
                                 default = nil)
  if valid_594201 != nil:
    section.add "quotaUser", valid_594201
  var valid_594202 = query.getOrDefault("alt")
  valid_594202 = validateParameter(valid_594202, JString, required = false,
                                 default = newJString("json"))
  if valid_594202 != nil:
    section.add "alt", valid_594202
  var valid_594203 = query.getOrDefault("oauth_token")
  valid_594203 = validateParameter(valid_594203, JString, required = false,
                                 default = nil)
  if valid_594203 != nil:
    section.add "oauth_token", valid_594203
  var valid_594204 = query.getOrDefault("userIp")
  valid_594204 = validateParameter(valid_594204, JString, required = false,
                                 default = nil)
  if valid_594204 != nil:
    section.add "userIp", valid_594204
  var valid_594205 = query.getOrDefault("key")
  valid_594205 = validateParameter(valid_594205, JString, required = false,
                                 default = nil)
  if valid_594205 != nil:
    section.add "key", valid_594205
  var valid_594206 = query.getOrDefault("prettyPrint")
  valid_594206 = validateParameter(valid_594206, JBool, required = false,
                                 default = newJBool(true))
  if valid_594206 != nil:
    section.add "prettyPrint", valid_594206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594208: Call_IdentitytoolkitRelyingpartyVerifyPassword_594197;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verifies the user entered password.
  ## 
  let valid = call_594208.validator(path, query, header, formData, body)
  let scheme = call_594208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594208.url(scheme.get, call_594208.host, call_594208.base,
                         call_594208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594208, url, valid)

proc call*(call_594209: Call_IdentitytoolkitRelyingpartyVerifyPassword_594197;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## identitytoolkitRelyingpartyVerifyPassword
  ## Verifies the user entered password.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594210 = newJObject()
  var body_594211 = newJObject()
  add(query_594210, "fields", newJString(fields))
  add(query_594210, "quotaUser", newJString(quotaUser))
  add(query_594210, "alt", newJString(alt))
  add(query_594210, "oauth_token", newJString(oauthToken))
  add(query_594210, "userIp", newJString(userIp))
  add(query_594210, "key", newJString(key))
  if body != nil:
    body_594211 = body
  add(query_594210, "prettyPrint", newJBool(prettyPrint))
  result = call_594209.call(nil, query_594210, nil, nil, body_594211)

var identitytoolkitRelyingpartyVerifyPassword* = Call_IdentitytoolkitRelyingpartyVerifyPassword_594197(
    name: "identitytoolkitRelyingpartyVerifyPassword", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/verifyPassword",
    validator: validate_IdentitytoolkitRelyingpartyVerifyPassword_594198,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyVerifyPassword_594199,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyVerifyPhoneNumber_594212 = ref object of OpenApiRestCall_593408
proc url_IdentitytoolkitRelyingpartyVerifyPhoneNumber_594214(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyVerifyPhoneNumber_594213(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Verifies ownership of a phone number and creates/updates the user account accordingly.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594215 = query.getOrDefault("fields")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "fields", valid_594215
  var valid_594216 = query.getOrDefault("quotaUser")
  valid_594216 = validateParameter(valid_594216, JString, required = false,
                                 default = nil)
  if valid_594216 != nil:
    section.add "quotaUser", valid_594216
  var valid_594217 = query.getOrDefault("alt")
  valid_594217 = validateParameter(valid_594217, JString, required = false,
                                 default = newJString("json"))
  if valid_594217 != nil:
    section.add "alt", valid_594217
  var valid_594218 = query.getOrDefault("oauth_token")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = nil)
  if valid_594218 != nil:
    section.add "oauth_token", valid_594218
  var valid_594219 = query.getOrDefault("userIp")
  valid_594219 = validateParameter(valid_594219, JString, required = false,
                                 default = nil)
  if valid_594219 != nil:
    section.add "userIp", valid_594219
  var valid_594220 = query.getOrDefault("key")
  valid_594220 = validateParameter(valid_594220, JString, required = false,
                                 default = nil)
  if valid_594220 != nil:
    section.add "key", valid_594220
  var valid_594221 = query.getOrDefault("prettyPrint")
  valid_594221 = validateParameter(valid_594221, JBool, required = false,
                                 default = newJBool(true))
  if valid_594221 != nil:
    section.add "prettyPrint", valid_594221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594223: Call_IdentitytoolkitRelyingpartyVerifyPhoneNumber_594212;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verifies ownership of a phone number and creates/updates the user account accordingly.
  ## 
  let valid = call_594223.validator(path, query, header, formData, body)
  let scheme = call_594223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594223.url(scheme.get, call_594223.host, call_594223.base,
                         call_594223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594223, url, valid)

proc call*(call_594224: Call_IdentitytoolkitRelyingpartyVerifyPhoneNumber_594212;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## identitytoolkitRelyingpartyVerifyPhoneNumber
  ## Verifies ownership of a phone number and creates/updates the user account accordingly.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594225 = newJObject()
  var body_594226 = newJObject()
  add(query_594225, "fields", newJString(fields))
  add(query_594225, "quotaUser", newJString(quotaUser))
  add(query_594225, "alt", newJString(alt))
  add(query_594225, "oauth_token", newJString(oauthToken))
  add(query_594225, "userIp", newJString(userIp))
  add(query_594225, "key", newJString(key))
  if body != nil:
    body_594226 = body
  add(query_594225, "prettyPrint", newJBool(prettyPrint))
  result = call_594224.call(nil, query_594225, nil, nil, body_594226)

var identitytoolkitRelyingpartyVerifyPhoneNumber* = Call_IdentitytoolkitRelyingpartyVerifyPhoneNumber_594212(
    name: "identitytoolkitRelyingpartyVerifyPhoneNumber",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/verifyPhoneNumber",
    validator: validate_IdentitytoolkitRelyingpartyVerifyPhoneNumber_594213,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyVerifyPhoneNumber_594214,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
