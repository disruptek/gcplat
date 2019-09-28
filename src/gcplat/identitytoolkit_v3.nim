
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_579408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579408): Option[Scheme] {.used.} =
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
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_IdentitytoolkitRelyingpartyCreateAuthUri_579676 = ref object of OpenApiRestCall_579408
proc url_IdentitytoolkitRelyingpartyCreateAuthUri_579678(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyCreateAuthUri_579677(path: JsonNode;
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
  var valid_579790 = query.getOrDefault("fields")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = nil)
  if valid_579790 != nil:
    section.add "fields", valid_579790
  var valid_579791 = query.getOrDefault("quotaUser")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "quotaUser", valid_579791
  var valid_579805 = query.getOrDefault("alt")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = newJString("json"))
  if valid_579805 != nil:
    section.add "alt", valid_579805
  var valid_579806 = query.getOrDefault("oauth_token")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "oauth_token", valid_579806
  var valid_579807 = query.getOrDefault("userIp")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "userIp", valid_579807
  var valid_579808 = query.getOrDefault("key")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "key", valid_579808
  var valid_579809 = query.getOrDefault("prettyPrint")
  valid_579809 = validateParameter(valid_579809, JBool, required = false,
                                 default = newJBool(true))
  if valid_579809 != nil:
    section.add "prettyPrint", valid_579809
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

proc call*(call_579833: Call_IdentitytoolkitRelyingpartyCreateAuthUri_579676;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates the URI used by the IdP to authenticate the user.
  ## 
  let valid = call_579833.validator(path, query, header, formData, body)
  let scheme = call_579833.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579833.url(scheme.get, call_579833.host, call_579833.base,
                         call_579833.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579833, url, valid)

proc call*(call_579904: Call_IdentitytoolkitRelyingpartyCreateAuthUri_579676;
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
  var query_579905 = newJObject()
  var body_579907 = newJObject()
  add(query_579905, "fields", newJString(fields))
  add(query_579905, "quotaUser", newJString(quotaUser))
  add(query_579905, "alt", newJString(alt))
  add(query_579905, "oauth_token", newJString(oauthToken))
  add(query_579905, "userIp", newJString(userIp))
  add(query_579905, "key", newJString(key))
  if body != nil:
    body_579907 = body
  add(query_579905, "prettyPrint", newJBool(prettyPrint))
  result = call_579904.call(nil, query_579905, nil, nil, body_579907)

var identitytoolkitRelyingpartyCreateAuthUri* = Call_IdentitytoolkitRelyingpartyCreateAuthUri_579676(
    name: "identitytoolkitRelyingpartyCreateAuthUri", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/createAuthUri",
    validator: validate_IdentitytoolkitRelyingpartyCreateAuthUri_579677,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyCreateAuthUri_579678,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyDeleteAccount_579946 = ref object of OpenApiRestCall_579408
proc url_IdentitytoolkitRelyingpartyDeleteAccount_579948(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyDeleteAccount_579947(path: JsonNode;
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
  var valid_579949 = query.getOrDefault("fields")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "fields", valid_579949
  var valid_579950 = query.getOrDefault("quotaUser")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = nil)
  if valid_579950 != nil:
    section.add "quotaUser", valid_579950
  var valid_579951 = query.getOrDefault("alt")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = newJString("json"))
  if valid_579951 != nil:
    section.add "alt", valid_579951
  var valid_579952 = query.getOrDefault("oauth_token")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = nil)
  if valid_579952 != nil:
    section.add "oauth_token", valid_579952
  var valid_579953 = query.getOrDefault("userIp")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = nil)
  if valid_579953 != nil:
    section.add "userIp", valid_579953
  var valid_579954 = query.getOrDefault("key")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "key", valid_579954
  var valid_579955 = query.getOrDefault("prettyPrint")
  valid_579955 = validateParameter(valid_579955, JBool, required = false,
                                 default = newJBool(true))
  if valid_579955 != nil:
    section.add "prettyPrint", valid_579955
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

proc call*(call_579957: Call_IdentitytoolkitRelyingpartyDeleteAccount_579946;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete user account.
  ## 
  let valid = call_579957.validator(path, query, header, formData, body)
  let scheme = call_579957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579957.url(scheme.get, call_579957.host, call_579957.base,
                         call_579957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579957, url, valid)

proc call*(call_579958: Call_IdentitytoolkitRelyingpartyDeleteAccount_579946;
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
  var query_579959 = newJObject()
  var body_579960 = newJObject()
  add(query_579959, "fields", newJString(fields))
  add(query_579959, "quotaUser", newJString(quotaUser))
  add(query_579959, "alt", newJString(alt))
  add(query_579959, "oauth_token", newJString(oauthToken))
  add(query_579959, "userIp", newJString(userIp))
  add(query_579959, "key", newJString(key))
  if body != nil:
    body_579960 = body
  add(query_579959, "prettyPrint", newJBool(prettyPrint))
  result = call_579958.call(nil, query_579959, nil, nil, body_579960)

var identitytoolkitRelyingpartyDeleteAccount* = Call_IdentitytoolkitRelyingpartyDeleteAccount_579946(
    name: "identitytoolkitRelyingpartyDeleteAccount", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/deleteAccount",
    validator: validate_IdentitytoolkitRelyingpartyDeleteAccount_579947,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyDeleteAccount_579948,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyDownloadAccount_579961 = ref object of OpenApiRestCall_579408
proc url_IdentitytoolkitRelyingpartyDownloadAccount_579963(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyDownloadAccount_579962(path: JsonNode;
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
  var valid_579964 = query.getOrDefault("fields")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "fields", valid_579964
  var valid_579965 = query.getOrDefault("quotaUser")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "quotaUser", valid_579965
  var valid_579966 = query.getOrDefault("alt")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = newJString("json"))
  if valid_579966 != nil:
    section.add "alt", valid_579966
  var valid_579967 = query.getOrDefault("oauth_token")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "oauth_token", valid_579967
  var valid_579968 = query.getOrDefault("userIp")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "userIp", valid_579968
  var valid_579969 = query.getOrDefault("key")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "key", valid_579969
  var valid_579970 = query.getOrDefault("prettyPrint")
  valid_579970 = validateParameter(valid_579970, JBool, required = false,
                                 default = newJBool(true))
  if valid_579970 != nil:
    section.add "prettyPrint", valid_579970
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

proc call*(call_579972: Call_IdentitytoolkitRelyingpartyDownloadAccount_579961;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Batch download user accounts.
  ## 
  let valid = call_579972.validator(path, query, header, formData, body)
  let scheme = call_579972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579972.url(scheme.get, call_579972.host, call_579972.base,
                         call_579972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579972, url, valid)

proc call*(call_579973: Call_IdentitytoolkitRelyingpartyDownloadAccount_579961;
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
  var query_579974 = newJObject()
  var body_579975 = newJObject()
  add(query_579974, "fields", newJString(fields))
  add(query_579974, "quotaUser", newJString(quotaUser))
  add(query_579974, "alt", newJString(alt))
  add(query_579974, "oauth_token", newJString(oauthToken))
  add(query_579974, "userIp", newJString(userIp))
  add(query_579974, "key", newJString(key))
  if body != nil:
    body_579975 = body
  add(query_579974, "prettyPrint", newJBool(prettyPrint))
  result = call_579973.call(nil, query_579974, nil, nil, body_579975)

var identitytoolkitRelyingpartyDownloadAccount* = Call_IdentitytoolkitRelyingpartyDownloadAccount_579961(
    name: "identitytoolkitRelyingpartyDownloadAccount", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/downloadAccount",
    validator: validate_IdentitytoolkitRelyingpartyDownloadAccount_579962,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyDownloadAccount_579963,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyEmailLinkSignin_579976 = ref object of OpenApiRestCall_579408
proc url_IdentitytoolkitRelyingpartyEmailLinkSignin_579978(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyEmailLinkSignin_579977(path: JsonNode;
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
  var valid_579979 = query.getOrDefault("fields")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "fields", valid_579979
  var valid_579980 = query.getOrDefault("quotaUser")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "quotaUser", valid_579980
  var valid_579981 = query.getOrDefault("alt")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = newJString("json"))
  if valid_579981 != nil:
    section.add "alt", valid_579981
  var valid_579982 = query.getOrDefault("oauth_token")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "oauth_token", valid_579982
  var valid_579983 = query.getOrDefault("userIp")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "userIp", valid_579983
  var valid_579984 = query.getOrDefault("key")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "key", valid_579984
  var valid_579985 = query.getOrDefault("prettyPrint")
  valid_579985 = validateParameter(valid_579985, JBool, required = false,
                                 default = newJBool(true))
  if valid_579985 != nil:
    section.add "prettyPrint", valid_579985
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

proc call*(call_579987: Call_IdentitytoolkitRelyingpartyEmailLinkSignin_579976;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reset password for a user.
  ## 
  let valid = call_579987.validator(path, query, header, formData, body)
  let scheme = call_579987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579987.url(scheme.get, call_579987.host, call_579987.base,
                         call_579987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579987, url, valid)

proc call*(call_579988: Call_IdentitytoolkitRelyingpartyEmailLinkSignin_579976;
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
  var query_579989 = newJObject()
  var body_579990 = newJObject()
  add(query_579989, "fields", newJString(fields))
  add(query_579989, "quotaUser", newJString(quotaUser))
  add(query_579989, "alt", newJString(alt))
  add(query_579989, "oauth_token", newJString(oauthToken))
  add(query_579989, "userIp", newJString(userIp))
  add(query_579989, "key", newJString(key))
  if body != nil:
    body_579990 = body
  add(query_579989, "prettyPrint", newJBool(prettyPrint))
  result = call_579988.call(nil, query_579989, nil, nil, body_579990)

var identitytoolkitRelyingpartyEmailLinkSignin* = Call_IdentitytoolkitRelyingpartyEmailLinkSignin_579976(
    name: "identitytoolkitRelyingpartyEmailLinkSignin", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/emailLinkSignin",
    validator: validate_IdentitytoolkitRelyingpartyEmailLinkSignin_579977,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyEmailLinkSignin_579978,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyGetAccountInfo_579991 = ref object of OpenApiRestCall_579408
proc url_IdentitytoolkitRelyingpartyGetAccountInfo_579993(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyGetAccountInfo_579992(path: JsonNode;
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
  var valid_579994 = query.getOrDefault("fields")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "fields", valid_579994
  var valid_579995 = query.getOrDefault("quotaUser")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "quotaUser", valid_579995
  var valid_579996 = query.getOrDefault("alt")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = newJString("json"))
  if valid_579996 != nil:
    section.add "alt", valid_579996
  var valid_579997 = query.getOrDefault("oauth_token")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "oauth_token", valid_579997
  var valid_579998 = query.getOrDefault("userIp")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "userIp", valid_579998
  var valid_579999 = query.getOrDefault("key")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "key", valid_579999
  var valid_580000 = query.getOrDefault("prettyPrint")
  valid_580000 = validateParameter(valid_580000, JBool, required = false,
                                 default = newJBool(true))
  if valid_580000 != nil:
    section.add "prettyPrint", valid_580000
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

proc call*(call_580002: Call_IdentitytoolkitRelyingpartyGetAccountInfo_579991;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the account info.
  ## 
  let valid = call_580002.validator(path, query, header, formData, body)
  let scheme = call_580002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580002.url(scheme.get, call_580002.host, call_580002.base,
                         call_580002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580002, url, valid)

proc call*(call_580003: Call_IdentitytoolkitRelyingpartyGetAccountInfo_579991;
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
  var query_580004 = newJObject()
  var body_580005 = newJObject()
  add(query_580004, "fields", newJString(fields))
  add(query_580004, "quotaUser", newJString(quotaUser))
  add(query_580004, "alt", newJString(alt))
  add(query_580004, "oauth_token", newJString(oauthToken))
  add(query_580004, "userIp", newJString(userIp))
  add(query_580004, "key", newJString(key))
  if body != nil:
    body_580005 = body
  add(query_580004, "prettyPrint", newJBool(prettyPrint))
  result = call_580003.call(nil, query_580004, nil, nil, body_580005)

var identitytoolkitRelyingpartyGetAccountInfo* = Call_IdentitytoolkitRelyingpartyGetAccountInfo_579991(
    name: "identitytoolkitRelyingpartyGetAccountInfo", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/getAccountInfo",
    validator: validate_IdentitytoolkitRelyingpartyGetAccountInfo_579992,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyGetAccountInfo_579993,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyGetOobConfirmationCode_580006 = ref object of OpenApiRestCall_579408
proc url_IdentitytoolkitRelyingpartyGetOobConfirmationCode_580008(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyGetOobConfirmationCode_580007(
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
  var valid_580009 = query.getOrDefault("fields")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "fields", valid_580009
  var valid_580010 = query.getOrDefault("quotaUser")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "quotaUser", valid_580010
  var valid_580011 = query.getOrDefault("alt")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = newJString("json"))
  if valid_580011 != nil:
    section.add "alt", valid_580011
  var valid_580012 = query.getOrDefault("oauth_token")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "oauth_token", valid_580012
  var valid_580013 = query.getOrDefault("userIp")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "userIp", valid_580013
  var valid_580014 = query.getOrDefault("key")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "key", valid_580014
  var valid_580015 = query.getOrDefault("prettyPrint")
  valid_580015 = validateParameter(valid_580015, JBool, required = false,
                                 default = newJBool(true))
  if valid_580015 != nil:
    section.add "prettyPrint", valid_580015
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

proc call*(call_580017: Call_IdentitytoolkitRelyingpartyGetOobConfirmationCode_580006;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a code for user action confirmation.
  ## 
  let valid = call_580017.validator(path, query, header, formData, body)
  let scheme = call_580017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580017.url(scheme.get, call_580017.host, call_580017.base,
                         call_580017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580017, url, valid)

proc call*(call_580018: Call_IdentitytoolkitRelyingpartyGetOobConfirmationCode_580006;
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
  var query_580019 = newJObject()
  var body_580020 = newJObject()
  add(query_580019, "fields", newJString(fields))
  add(query_580019, "quotaUser", newJString(quotaUser))
  add(query_580019, "alt", newJString(alt))
  add(query_580019, "oauth_token", newJString(oauthToken))
  add(query_580019, "userIp", newJString(userIp))
  add(query_580019, "key", newJString(key))
  if body != nil:
    body_580020 = body
  add(query_580019, "prettyPrint", newJBool(prettyPrint))
  result = call_580018.call(nil, query_580019, nil, nil, body_580020)

var identitytoolkitRelyingpartyGetOobConfirmationCode* = Call_IdentitytoolkitRelyingpartyGetOobConfirmationCode_580006(
    name: "identitytoolkitRelyingpartyGetOobConfirmationCode",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/getOobConfirmationCode",
    validator: validate_IdentitytoolkitRelyingpartyGetOobConfirmationCode_580007,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyGetOobConfirmationCode_580008,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyGetProjectConfig_580021 = ref object of OpenApiRestCall_579408
proc url_IdentitytoolkitRelyingpartyGetProjectConfig_580023(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyGetProjectConfig_580022(path: JsonNode;
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
  var valid_580024 = query.getOrDefault("fields")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "fields", valid_580024
  var valid_580025 = query.getOrDefault("quotaUser")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "quotaUser", valid_580025
  var valid_580026 = query.getOrDefault("delegatedProjectNumber")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "delegatedProjectNumber", valid_580026
  var valid_580027 = query.getOrDefault("alt")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = newJString("json"))
  if valid_580027 != nil:
    section.add "alt", valid_580027
  var valid_580028 = query.getOrDefault("oauth_token")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "oauth_token", valid_580028
  var valid_580029 = query.getOrDefault("userIp")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "userIp", valid_580029
  var valid_580030 = query.getOrDefault("key")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "key", valid_580030
  var valid_580031 = query.getOrDefault("projectNumber")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "projectNumber", valid_580031
  var valid_580032 = query.getOrDefault("prettyPrint")
  valid_580032 = validateParameter(valid_580032, JBool, required = false,
                                 default = newJBool(true))
  if valid_580032 != nil:
    section.add "prettyPrint", valid_580032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580033: Call_IdentitytoolkitRelyingpartyGetProjectConfig_580021;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get project configuration.
  ## 
  let valid = call_580033.validator(path, query, header, formData, body)
  let scheme = call_580033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580033.url(scheme.get, call_580033.host, call_580033.base,
                         call_580033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580033, url, valid)

proc call*(call_580034: Call_IdentitytoolkitRelyingpartyGetProjectConfig_580021;
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
  var query_580035 = newJObject()
  add(query_580035, "fields", newJString(fields))
  add(query_580035, "quotaUser", newJString(quotaUser))
  add(query_580035, "delegatedProjectNumber", newJString(delegatedProjectNumber))
  add(query_580035, "alt", newJString(alt))
  add(query_580035, "oauth_token", newJString(oauthToken))
  add(query_580035, "userIp", newJString(userIp))
  add(query_580035, "key", newJString(key))
  add(query_580035, "projectNumber", newJString(projectNumber))
  add(query_580035, "prettyPrint", newJBool(prettyPrint))
  result = call_580034.call(nil, query_580035, nil, nil, nil)

var identitytoolkitRelyingpartyGetProjectConfig* = Call_IdentitytoolkitRelyingpartyGetProjectConfig_580021(
    name: "identitytoolkitRelyingpartyGetProjectConfig", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/getProjectConfig",
    validator: validate_IdentitytoolkitRelyingpartyGetProjectConfig_580022,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyGetProjectConfig_580023,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyGetRecaptchaParam_580036 = ref object of OpenApiRestCall_579408
proc url_IdentitytoolkitRelyingpartyGetRecaptchaParam_580038(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyGetRecaptchaParam_580037(path: JsonNode;
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
  var valid_580039 = query.getOrDefault("fields")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "fields", valid_580039
  var valid_580040 = query.getOrDefault("quotaUser")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "quotaUser", valid_580040
  var valid_580041 = query.getOrDefault("alt")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = newJString("json"))
  if valid_580041 != nil:
    section.add "alt", valid_580041
  var valid_580042 = query.getOrDefault("oauth_token")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "oauth_token", valid_580042
  var valid_580043 = query.getOrDefault("userIp")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "userIp", valid_580043
  var valid_580044 = query.getOrDefault("key")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "key", valid_580044
  var valid_580045 = query.getOrDefault("prettyPrint")
  valid_580045 = validateParameter(valid_580045, JBool, required = false,
                                 default = newJBool(true))
  if valid_580045 != nil:
    section.add "prettyPrint", valid_580045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580046: Call_IdentitytoolkitRelyingpartyGetRecaptchaParam_580036;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get recaptcha secure param.
  ## 
  let valid = call_580046.validator(path, query, header, formData, body)
  let scheme = call_580046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580046.url(scheme.get, call_580046.host, call_580046.base,
                         call_580046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580046, url, valid)

proc call*(call_580047: Call_IdentitytoolkitRelyingpartyGetRecaptchaParam_580036;
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
  var query_580048 = newJObject()
  add(query_580048, "fields", newJString(fields))
  add(query_580048, "quotaUser", newJString(quotaUser))
  add(query_580048, "alt", newJString(alt))
  add(query_580048, "oauth_token", newJString(oauthToken))
  add(query_580048, "userIp", newJString(userIp))
  add(query_580048, "key", newJString(key))
  add(query_580048, "prettyPrint", newJBool(prettyPrint))
  result = call_580047.call(nil, query_580048, nil, nil, nil)

var identitytoolkitRelyingpartyGetRecaptchaParam* = Call_IdentitytoolkitRelyingpartyGetRecaptchaParam_580036(
    name: "identitytoolkitRelyingpartyGetRecaptchaParam",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/getRecaptchaParam",
    validator: validate_IdentitytoolkitRelyingpartyGetRecaptchaParam_580037,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyGetRecaptchaParam_580038,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyGetPublicKeys_580049 = ref object of OpenApiRestCall_579408
proc url_IdentitytoolkitRelyingpartyGetPublicKeys_580051(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyGetPublicKeys_580050(path: JsonNode;
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
  var valid_580052 = query.getOrDefault("fields")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "fields", valid_580052
  var valid_580053 = query.getOrDefault("quotaUser")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "quotaUser", valid_580053
  var valid_580054 = query.getOrDefault("alt")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = newJString("json"))
  if valid_580054 != nil:
    section.add "alt", valid_580054
  var valid_580055 = query.getOrDefault("oauth_token")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "oauth_token", valid_580055
  var valid_580056 = query.getOrDefault("userIp")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "userIp", valid_580056
  var valid_580057 = query.getOrDefault("key")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "key", valid_580057
  var valid_580058 = query.getOrDefault("prettyPrint")
  valid_580058 = validateParameter(valid_580058, JBool, required = false,
                                 default = newJBool(true))
  if valid_580058 != nil:
    section.add "prettyPrint", valid_580058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580059: Call_IdentitytoolkitRelyingpartyGetPublicKeys_580049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get token signing public key.
  ## 
  let valid = call_580059.validator(path, query, header, formData, body)
  let scheme = call_580059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580059.url(scheme.get, call_580059.host, call_580059.base,
                         call_580059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580059, url, valid)

proc call*(call_580060: Call_IdentitytoolkitRelyingpartyGetPublicKeys_580049;
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
  var query_580061 = newJObject()
  add(query_580061, "fields", newJString(fields))
  add(query_580061, "quotaUser", newJString(quotaUser))
  add(query_580061, "alt", newJString(alt))
  add(query_580061, "oauth_token", newJString(oauthToken))
  add(query_580061, "userIp", newJString(userIp))
  add(query_580061, "key", newJString(key))
  add(query_580061, "prettyPrint", newJBool(prettyPrint))
  result = call_580060.call(nil, query_580061, nil, nil, nil)

var identitytoolkitRelyingpartyGetPublicKeys* = Call_IdentitytoolkitRelyingpartyGetPublicKeys_580049(
    name: "identitytoolkitRelyingpartyGetPublicKeys", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/publicKeys",
    validator: validate_IdentitytoolkitRelyingpartyGetPublicKeys_580050,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyGetPublicKeys_580051,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyResetPassword_580062 = ref object of OpenApiRestCall_579408
proc url_IdentitytoolkitRelyingpartyResetPassword_580064(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyResetPassword_580063(path: JsonNode;
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
  var valid_580065 = query.getOrDefault("fields")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "fields", valid_580065
  var valid_580066 = query.getOrDefault("quotaUser")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "quotaUser", valid_580066
  var valid_580067 = query.getOrDefault("alt")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = newJString("json"))
  if valid_580067 != nil:
    section.add "alt", valid_580067
  var valid_580068 = query.getOrDefault("oauth_token")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "oauth_token", valid_580068
  var valid_580069 = query.getOrDefault("userIp")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "userIp", valid_580069
  var valid_580070 = query.getOrDefault("key")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "key", valid_580070
  var valid_580071 = query.getOrDefault("prettyPrint")
  valid_580071 = validateParameter(valid_580071, JBool, required = false,
                                 default = newJBool(true))
  if valid_580071 != nil:
    section.add "prettyPrint", valid_580071
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

proc call*(call_580073: Call_IdentitytoolkitRelyingpartyResetPassword_580062;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reset password for a user.
  ## 
  let valid = call_580073.validator(path, query, header, formData, body)
  let scheme = call_580073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580073.url(scheme.get, call_580073.host, call_580073.base,
                         call_580073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580073, url, valid)

proc call*(call_580074: Call_IdentitytoolkitRelyingpartyResetPassword_580062;
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
  var query_580075 = newJObject()
  var body_580076 = newJObject()
  add(query_580075, "fields", newJString(fields))
  add(query_580075, "quotaUser", newJString(quotaUser))
  add(query_580075, "alt", newJString(alt))
  add(query_580075, "oauth_token", newJString(oauthToken))
  add(query_580075, "userIp", newJString(userIp))
  add(query_580075, "key", newJString(key))
  if body != nil:
    body_580076 = body
  add(query_580075, "prettyPrint", newJBool(prettyPrint))
  result = call_580074.call(nil, query_580075, nil, nil, body_580076)

var identitytoolkitRelyingpartyResetPassword* = Call_IdentitytoolkitRelyingpartyResetPassword_580062(
    name: "identitytoolkitRelyingpartyResetPassword", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/resetPassword",
    validator: validate_IdentitytoolkitRelyingpartyResetPassword_580063,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyResetPassword_580064,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartySendVerificationCode_580077 = ref object of OpenApiRestCall_579408
proc url_IdentitytoolkitRelyingpartySendVerificationCode_580079(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartySendVerificationCode_580078(
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
  var valid_580080 = query.getOrDefault("fields")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "fields", valid_580080
  var valid_580081 = query.getOrDefault("quotaUser")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "quotaUser", valid_580081
  var valid_580082 = query.getOrDefault("alt")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = newJString("json"))
  if valid_580082 != nil:
    section.add "alt", valid_580082
  var valid_580083 = query.getOrDefault("oauth_token")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "oauth_token", valid_580083
  var valid_580084 = query.getOrDefault("userIp")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "userIp", valid_580084
  var valid_580085 = query.getOrDefault("key")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "key", valid_580085
  var valid_580086 = query.getOrDefault("prettyPrint")
  valid_580086 = validateParameter(valid_580086, JBool, required = false,
                                 default = newJBool(true))
  if valid_580086 != nil:
    section.add "prettyPrint", valid_580086
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

proc call*(call_580088: Call_IdentitytoolkitRelyingpartySendVerificationCode_580077;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Send SMS verification code.
  ## 
  let valid = call_580088.validator(path, query, header, formData, body)
  let scheme = call_580088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580088.url(scheme.get, call_580088.host, call_580088.base,
                         call_580088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580088, url, valid)

proc call*(call_580089: Call_IdentitytoolkitRelyingpartySendVerificationCode_580077;
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
  var query_580090 = newJObject()
  var body_580091 = newJObject()
  add(query_580090, "fields", newJString(fields))
  add(query_580090, "quotaUser", newJString(quotaUser))
  add(query_580090, "alt", newJString(alt))
  add(query_580090, "oauth_token", newJString(oauthToken))
  add(query_580090, "userIp", newJString(userIp))
  add(query_580090, "key", newJString(key))
  if body != nil:
    body_580091 = body
  add(query_580090, "prettyPrint", newJBool(prettyPrint))
  result = call_580089.call(nil, query_580090, nil, nil, body_580091)

var identitytoolkitRelyingpartySendVerificationCode* = Call_IdentitytoolkitRelyingpartySendVerificationCode_580077(
    name: "identitytoolkitRelyingpartySendVerificationCode",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/sendVerificationCode",
    validator: validate_IdentitytoolkitRelyingpartySendVerificationCode_580078,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartySendVerificationCode_580079,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartySetAccountInfo_580092 = ref object of OpenApiRestCall_579408
proc url_IdentitytoolkitRelyingpartySetAccountInfo_580094(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartySetAccountInfo_580093(path: JsonNode;
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
  var valid_580095 = query.getOrDefault("fields")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "fields", valid_580095
  var valid_580096 = query.getOrDefault("quotaUser")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "quotaUser", valid_580096
  var valid_580097 = query.getOrDefault("alt")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = newJString("json"))
  if valid_580097 != nil:
    section.add "alt", valid_580097
  var valid_580098 = query.getOrDefault("oauth_token")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "oauth_token", valid_580098
  var valid_580099 = query.getOrDefault("userIp")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "userIp", valid_580099
  var valid_580100 = query.getOrDefault("key")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "key", valid_580100
  var valid_580101 = query.getOrDefault("prettyPrint")
  valid_580101 = validateParameter(valid_580101, JBool, required = false,
                                 default = newJBool(true))
  if valid_580101 != nil:
    section.add "prettyPrint", valid_580101
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

proc call*(call_580103: Call_IdentitytoolkitRelyingpartySetAccountInfo_580092;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Set account info for a user.
  ## 
  let valid = call_580103.validator(path, query, header, formData, body)
  let scheme = call_580103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580103.url(scheme.get, call_580103.host, call_580103.base,
                         call_580103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580103, url, valid)

proc call*(call_580104: Call_IdentitytoolkitRelyingpartySetAccountInfo_580092;
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
  var query_580105 = newJObject()
  var body_580106 = newJObject()
  add(query_580105, "fields", newJString(fields))
  add(query_580105, "quotaUser", newJString(quotaUser))
  add(query_580105, "alt", newJString(alt))
  add(query_580105, "oauth_token", newJString(oauthToken))
  add(query_580105, "userIp", newJString(userIp))
  add(query_580105, "key", newJString(key))
  if body != nil:
    body_580106 = body
  add(query_580105, "prettyPrint", newJBool(prettyPrint))
  result = call_580104.call(nil, query_580105, nil, nil, body_580106)

var identitytoolkitRelyingpartySetAccountInfo* = Call_IdentitytoolkitRelyingpartySetAccountInfo_580092(
    name: "identitytoolkitRelyingpartySetAccountInfo", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/setAccountInfo",
    validator: validate_IdentitytoolkitRelyingpartySetAccountInfo_580093,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartySetAccountInfo_580094,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartySetProjectConfig_580107 = ref object of OpenApiRestCall_579408
proc url_IdentitytoolkitRelyingpartySetProjectConfig_580109(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartySetProjectConfig_580108(path: JsonNode;
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
  var valid_580110 = query.getOrDefault("fields")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "fields", valid_580110
  var valid_580111 = query.getOrDefault("quotaUser")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "quotaUser", valid_580111
  var valid_580112 = query.getOrDefault("alt")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = newJString("json"))
  if valid_580112 != nil:
    section.add "alt", valid_580112
  var valid_580113 = query.getOrDefault("oauth_token")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "oauth_token", valid_580113
  var valid_580114 = query.getOrDefault("userIp")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "userIp", valid_580114
  var valid_580115 = query.getOrDefault("key")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "key", valid_580115
  var valid_580116 = query.getOrDefault("prettyPrint")
  valid_580116 = validateParameter(valid_580116, JBool, required = false,
                                 default = newJBool(true))
  if valid_580116 != nil:
    section.add "prettyPrint", valid_580116
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

proc call*(call_580118: Call_IdentitytoolkitRelyingpartySetProjectConfig_580107;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Set project configuration.
  ## 
  let valid = call_580118.validator(path, query, header, formData, body)
  let scheme = call_580118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580118.url(scheme.get, call_580118.host, call_580118.base,
                         call_580118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580118, url, valid)

proc call*(call_580119: Call_IdentitytoolkitRelyingpartySetProjectConfig_580107;
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
  var query_580120 = newJObject()
  var body_580121 = newJObject()
  add(query_580120, "fields", newJString(fields))
  add(query_580120, "quotaUser", newJString(quotaUser))
  add(query_580120, "alt", newJString(alt))
  add(query_580120, "oauth_token", newJString(oauthToken))
  add(query_580120, "userIp", newJString(userIp))
  add(query_580120, "key", newJString(key))
  if body != nil:
    body_580121 = body
  add(query_580120, "prettyPrint", newJBool(prettyPrint))
  result = call_580119.call(nil, query_580120, nil, nil, body_580121)

var identitytoolkitRelyingpartySetProjectConfig* = Call_IdentitytoolkitRelyingpartySetProjectConfig_580107(
    name: "identitytoolkitRelyingpartySetProjectConfig",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/setProjectConfig",
    validator: validate_IdentitytoolkitRelyingpartySetProjectConfig_580108,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartySetProjectConfig_580109,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartySignOutUser_580122 = ref object of OpenApiRestCall_579408
proc url_IdentitytoolkitRelyingpartySignOutUser_580124(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartySignOutUser_580123(path: JsonNode;
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
  var valid_580125 = query.getOrDefault("fields")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "fields", valid_580125
  var valid_580126 = query.getOrDefault("quotaUser")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "quotaUser", valid_580126
  var valid_580127 = query.getOrDefault("alt")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = newJString("json"))
  if valid_580127 != nil:
    section.add "alt", valid_580127
  var valid_580128 = query.getOrDefault("oauth_token")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "oauth_token", valid_580128
  var valid_580129 = query.getOrDefault("userIp")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "userIp", valid_580129
  var valid_580130 = query.getOrDefault("key")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "key", valid_580130
  var valid_580131 = query.getOrDefault("prettyPrint")
  valid_580131 = validateParameter(valid_580131, JBool, required = false,
                                 default = newJBool(true))
  if valid_580131 != nil:
    section.add "prettyPrint", valid_580131
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

proc call*(call_580133: Call_IdentitytoolkitRelyingpartySignOutUser_580122;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sign out user.
  ## 
  let valid = call_580133.validator(path, query, header, formData, body)
  let scheme = call_580133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580133.url(scheme.get, call_580133.host, call_580133.base,
                         call_580133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580133, url, valid)

proc call*(call_580134: Call_IdentitytoolkitRelyingpartySignOutUser_580122;
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
  var query_580135 = newJObject()
  var body_580136 = newJObject()
  add(query_580135, "fields", newJString(fields))
  add(query_580135, "quotaUser", newJString(quotaUser))
  add(query_580135, "alt", newJString(alt))
  add(query_580135, "oauth_token", newJString(oauthToken))
  add(query_580135, "userIp", newJString(userIp))
  add(query_580135, "key", newJString(key))
  if body != nil:
    body_580136 = body
  add(query_580135, "prettyPrint", newJBool(prettyPrint))
  result = call_580134.call(nil, query_580135, nil, nil, body_580136)

var identitytoolkitRelyingpartySignOutUser* = Call_IdentitytoolkitRelyingpartySignOutUser_580122(
    name: "identitytoolkitRelyingpartySignOutUser", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/signOutUser",
    validator: validate_IdentitytoolkitRelyingpartySignOutUser_580123,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartySignOutUser_580124,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartySignupNewUser_580137 = ref object of OpenApiRestCall_579408
proc url_IdentitytoolkitRelyingpartySignupNewUser_580139(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartySignupNewUser_580138(path: JsonNode;
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
  var valid_580140 = query.getOrDefault("fields")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "fields", valid_580140
  var valid_580141 = query.getOrDefault("quotaUser")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "quotaUser", valid_580141
  var valid_580142 = query.getOrDefault("alt")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = newJString("json"))
  if valid_580142 != nil:
    section.add "alt", valid_580142
  var valid_580143 = query.getOrDefault("oauth_token")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "oauth_token", valid_580143
  var valid_580144 = query.getOrDefault("userIp")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "userIp", valid_580144
  var valid_580145 = query.getOrDefault("key")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "key", valid_580145
  var valid_580146 = query.getOrDefault("prettyPrint")
  valid_580146 = validateParameter(valid_580146, JBool, required = false,
                                 default = newJBool(true))
  if valid_580146 != nil:
    section.add "prettyPrint", valid_580146
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

proc call*(call_580148: Call_IdentitytoolkitRelyingpartySignupNewUser_580137;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Signup new user.
  ## 
  let valid = call_580148.validator(path, query, header, formData, body)
  let scheme = call_580148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580148.url(scheme.get, call_580148.host, call_580148.base,
                         call_580148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580148, url, valid)

proc call*(call_580149: Call_IdentitytoolkitRelyingpartySignupNewUser_580137;
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
  var query_580150 = newJObject()
  var body_580151 = newJObject()
  add(query_580150, "fields", newJString(fields))
  add(query_580150, "quotaUser", newJString(quotaUser))
  add(query_580150, "alt", newJString(alt))
  add(query_580150, "oauth_token", newJString(oauthToken))
  add(query_580150, "userIp", newJString(userIp))
  add(query_580150, "key", newJString(key))
  if body != nil:
    body_580151 = body
  add(query_580150, "prettyPrint", newJBool(prettyPrint))
  result = call_580149.call(nil, query_580150, nil, nil, body_580151)

var identitytoolkitRelyingpartySignupNewUser* = Call_IdentitytoolkitRelyingpartySignupNewUser_580137(
    name: "identitytoolkitRelyingpartySignupNewUser", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/signupNewUser",
    validator: validate_IdentitytoolkitRelyingpartySignupNewUser_580138,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartySignupNewUser_580139,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyUploadAccount_580152 = ref object of OpenApiRestCall_579408
proc url_IdentitytoolkitRelyingpartyUploadAccount_580154(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyUploadAccount_580153(path: JsonNode;
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
  var valid_580155 = query.getOrDefault("fields")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "fields", valid_580155
  var valid_580156 = query.getOrDefault("quotaUser")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "quotaUser", valid_580156
  var valid_580157 = query.getOrDefault("alt")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = newJString("json"))
  if valid_580157 != nil:
    section.add "alt", valid_580157
  var valid_580158 = query.getOrDefault("oauth_token")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "oauth_token", valid_580158
  var valid_580159 = query.getOrDefault("userIp")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "userIp", valid_580159
  var valid_580160 = query.getOrDefault("key")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "key", valid_580160
  var valid_580161 = query.getOrDefault("prettyPrint")
  valid_580161 = validateParameter(valid_580161, JBool, required = false,
                                 default = newJBool(true))
  if valid_580161 != nil:
    section.add "prettyPrint", valid_580161
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

proc call*(call_580163: Call_IdentitytoolkitRelyingpartyUploadAccount_580152;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Batch upload existing user accounts.
  ## 
  let valid = call_580163.validator(path, query, header, formData, body)
  let scheme = call_580163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580163.url(scheme.get, call_580163.host, call_580163.base,
                         call_580163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580163, url, valid)

proc call*(call_580164: Call_IdentitytoolkitRelyingpartyUploadAccount_580152;
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
  var query_580165 = newJObject()
  var body_580166 = newJObject()
  add(query_580165, "fields", newJString(fields))
  add(query_580165, "quotaUser", newJString(quotaUser))
  add(query_580165, "alt", newJString(alt))
  add(query_580165, "oauth_token", newJString(oauthToken))
  add(query_580165, "userIp", newJString(userIp))
  add(query_580165, "key", newJString(key))
  if body != nil:
    body_580166 = body
  add(query_580165, "prettyPrint", newJBool(prettyPrint))
  result = call_580164.call(nil, query_580165, nil, nil, body_580166)

var identitytoolkitRelyingpartyUploadAccount* = Call_IdentitytoolkitRelyingpartyUploadAccount_580152(
    name: "identitytoolkitRelyingpartyUploadAccount", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/uploadAccount",
    validator: validate_IdentitytoolkitRelyingpartyUploadAccount_580153,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyUploadAccount_580154,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyVerifyAssertion_580167 = ref object of OpenApiRestCall_579408
proc url_IdentitytoolkitRelyingpartyVerifyAssertion_580169(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyVerifyAssertion_580168(path: JsonNode;
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
  var valid_580170 = query.getOrDefault("fields")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "fields", valid_580170
  var valid_580171 = query.getOrDefault("quotaUser")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "quotaUser", valid_580171
  var valid_580172 = query.getOrDefault("alt")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = newJString("json"))
  if valid_580172 != nil:
    section.add "alt", valid_580172
  var valid_580173 = query.getOrDefault("oauth_token")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "oauth_token", valid_580173
  var valid_580174 = query.getOrDefault("userIp")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "userIp", valid_580174
  var valid_580175 = query.getOrDefault("key")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "key", valid_580175
  var valid_580176 = query.getOrDefault("prettyPrint")
  valid_580176 = validateParameter(valid_580176, JBool, required = false,
                                 default = newJBool(true))
  if valid_580176 != nil:
    section.add "prettyPrint", valid_580176
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

proc call*(call_580178: Call_IdentitytoolkitRelyingpartyVerifyAssertion_580167;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verifies the assertion returned by the IdP.
  ## 
  let valid = call_580178.validator(path, query, header, formData, body)
  let scheme = call_580178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580178.url(scheme.get, call_580178.host, call_580178.base,
                         call_580178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580178, url, valid)

proc call*(call_580179: Call_IdentitytoolkitRelyingpartyVerifyAssertion_580167;
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
  var query_580180 = newJObject()
  var body_580181 = newJObject()
  add(query_580180, "fields", newJString(fields))
  add(query_580180, "quotaUser", newJString(quotaUser))
  add(query_580180, "alt", newJString(alt))
  add(query_580180, "oauth_token", newJString(oauthToken))
  add(query_580180, "userIp", newJString(userIp))
  add(query_580180, "key", newJString(key))
  if body != nil:
    body_580181 = body
  add(query_580180, "prettyPrint", newJBool(prettyPrint))
  result = call_580179.call(nil, query_580180, nil, nil, body_580181)

var identitytoolkitRelyingpartyVerifyAssertion* = Call_IdentitytoolkitRelyingpartyVerifyAssertion_580167(
    name: "identitytoolkitRelyingpartyVerifyAssertion", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/verifyAssertion",
    validator: validate_IdentitytoolkitRelyingpartyVerifyAssertion_580168,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyVerifyAssertion_580169,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyVerifyCustomToken_580182 = ref object of OpenApiRestCall_579408
proc url_IdentitytoolkitRelyingpartyVerifyCustomToken_580184(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyVerifyCustomToken_580183(path: JsonNode;
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
  var valid_580185 = query.getOrDefault("fields")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "fields", valid_580185
  var valid_580186 = query.getOrDefault("quotaUser")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "quotaUser", valid_580186
  var valid_580187 = query.getOrDefault("alt")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = newJString("json"))
  if valid_580187 != nil:
    section.add "alt", valid_580187
  var valid_580188 = query.getOrDefault("oauth_token")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "oauth_token", valid_580188
  var valid_580189 = query.getOrDefault("userIp")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "userIp", valid_580189
  var valid_580190 = query.getOrDefault("key")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "key", valid_580190
  var valid_580191 = query.getOrDefault("prettyPrint")
  valid_580191 = validateParameter(valid_580191, JBool, required = false,
                                 default = newJBool(true))
  if valid_580191 != nil:
    section.add "prettyPrint", valid_580191
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

proc call*(call_580193: Call_IdentitytoolkitRelyingpartyVerifyCustomToken_580182;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verifies the developer asserted ID token.
  ## 
  let valid = call_580193.validator(path, query, header, formData, body)
  let scheme = call_580193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580193.url(scheme.get, call_580193.host, call_580193.base,
                         call_580193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580193, url, valid)

proc call*(call_580194: Call_IdentitytoolkitRelyingpartyVerifyCustomToken_580182;
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
  var query_580195 = newJObject()
  var body_580196 = newJObject()
  add(query_580195, "fields", newJString(fields))
  add(query_580195, "quotaUser", newJString(quotaUser))
  add(query_580195, "alt", newJString(alt))
  add(query_580195, "oauth_token", newJString(oauthToken))
  add(query_580195, "userIp", newJString(userIp))
  add(query_580195, "key", newJString(key))
  if body != nil:
    body_580196 = body
  add(query_580195, "prettyPrint", newJBool(prettyPrint))
  result = call_580194.call(nil, query_580195, nil, nil, body_580196)

var identitytoolkitRelyingpartyVerifyCustomToken* = Call_IdentitytoolkitRelyingpartyVerifyCustomToken_580182(
    name: "identitytoolkitRelyingpartyVerifyCustomToken",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/verifyCustomToken",
    validator: validate_IdentitytoolkitRelyingpartyVerifyCustomToken_580183,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyVerifyCustomToken_580184,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyVerifyPassword_580197 = ref object of OpenApiRestCall_579408
proc url_IdentitytoolkitRelyingpartyVerifyPassword_580199(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyVerifyPassword_580198(path: JsonNode;
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
  var valid_580200 = query.getOrDefault("fields")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "fields", valid_580200
  var valid_580201 = query.getOrDefault("quotaUser")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "quotaUser", valid_580201
  var valid_580202 = query.getOrDefault("alt")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = newJString("json"))
  if valid_580202 != nil:
    section.add "alt", valid_580202
  var valid_580203 = query.getOrDefault("oauth_token")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "oauth_token", valid_580203
  var valid_580204 = query.getOrDefault("userIp")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "userIp", valid_580204
  var valid_580205 = query.getOrDefault("key")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "key", valid_580205
  var valid_580206 = query.getOrDefault("prettyPrint")
  valid_580206 = validateParameter(valid_580206, JBool, required = false,
                                 default = newJBool(true))
  if valid_580206 != nil:
    section.add "prettyPrint", valid_580206
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

proc call*(call_580208: Call_IdentitytoolkitRelyingpartyVerifyPassword_580197;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verifies the user entered password.
  ## 
  let valid = call_580208.validator(path, query, header, formData, body)
  let scheme = call_580208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580208.url(scheme.get, call_580208.host, call_580208.base,
                         call_580208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580208, url, valid)

proc call*(call_580209: Call_IdentitytoolkitRelyingpartyVerifyPassword_580197;
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
  var query_580210 = newJObject()
  var body_580211 = newJObject()
  add(query_580210, "fields", newJString(fields))
  add(query_580210, "quotaUser", newJString(quotaUser))
  add(query_580210, "alt", newJString(alt))
  add(query_580210, "oauth_token", newJString(oauthToken))
  add(query_580210, "userIp", newJString(userIp))
  add(query_580210, "key", newJString(key))
  if body != nil:
    body_580211 = body
  add(query_580210, "prettyPrint", newJBool(prettyPrint))
  result = call_580209.call(nil, query_580210, nil, nil, body_580211)

var identitytoolkitRelyingpartyVerifyPassword* = Call_IdentitytoolkitRelyingpartyVerifyPassword_580197(
    name: "identitytoolkitRelyingpartyVerifyPassword", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/verifyPassword",
    validator: validate_IdentitytoolkitRelyingpartyVerifyPassword_580198,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyVerifyPassword_580199,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyVerifyPhoneNumber_580212 = ref object of OpenApiRestCall_579408
proc url_IdentitytoolkitRelyingpartyVerifyPhoneNumber_580214(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyVerifyPhoneNumber_580213(path: JsonNode;
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
  var valid_580215 = query.getOrDefault("fields")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "fields", valid_580215
  var valid_580216 = query.getOrDefault("quotaUser")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "quotaUser", valid_580216
  var valid_580217 = query.getOrDefault("alt")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = newJString("json"))
  if valid_580217 != nil:
    section.add "alt", valid_580217
  var valid_580218 = query.getOrDefault("oauth_token")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "oauth_token", valid_580218
  var valid_580219 = query.getOrDefault("userIp")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "userIp", valid_580219
  var valid_580220 = query.getOrDefault("key")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "key", valid_580220
  var valid_580221 = query.getOrDefault("prettyPrint")
  valid_580221 = validateParameter(valid_580221, JBool, required = false,
                                 default = newJBool(true))
  if valid_580221 != nil:
    section.add "prettyPrint", valid_580221
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

proc call*(call_580223: Call_IdentitytoolkitRelyingpartyVerifyPhoneNumber_580212;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verifies ownership of a phone number and creates/updates the user account accordingly.
  ## 
  let valid = call_580223.validator(path, query, header, formData, body)
  let scheme = call_580223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580223.url(scheme.get, call_580223.host, call_580223.base,
                         call_580223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580223, url, valid)

proc call*(call_580224: Call_IdentitytoolkitRelyingpartyVerifyPhoneNumber_580212;
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
  var query_580225 = newJObject()
  var body_580226 = newJObject()
  add(query_580225, "fields", newJString(fields))
  add(query_580225, "quotaUser", newJString(quotaUser))
  add(query_580225, "alt", newJString(alt))
  add(query_580225, "oauth_token", newJString(oauthToken))
  add(query_580225, "userIp", newJString(userIp))
  add(query_580225, "key", newJString(key))
  if body != nil:
    body_580226 = body
  add(query_580225, "prettyPrint", newJBool(prettyPrint))
  result = call_580224.call(nil, query_580225, nil, nil, body_580226)

var identitytoolkitRelyingpartyVerifyPhoneNumber* = Call_IdentitytoolkitRelyingpartyVerifyPhoneNumber_580212(
    name: "identitytoolkitRelyingpartyVerifyPhoneNumber",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/verifyPhoneNumber",
    validator: validate_IdentitytoolkitRelyingpartyVerifyPhoneNumber_580213,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyVerifyPhoneNumber_580214,
    schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
