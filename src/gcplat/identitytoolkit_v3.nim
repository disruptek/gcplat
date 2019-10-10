
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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
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
  Call_IdentitytoolkitRelyingpartyCreateAuthUri_588709 = ref object of OpenApiRestCall_588441
proc url_IdentitytoolkitRelyingpartyCreateAuthUri_588711(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyCreateAuthUri_588710(path: JsonNode;
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
  var valid_588823 = query.getOrDefault("fields")
  valid_588823 = validateParameter(valid_588823, JString, required = false,
                                 default = nil)
  if valid_588823 != nil:
    section.add "fields", valid_588823
  var valid_588824 = query.getOrDefault("quotaUser")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "quotaUser", valid_588824
  var valid_588838 = query.getOrDefault("alt")
  valid_588838 = validateParameter(valid_588838, JString, required = false,
                                 default = newJString("json"))
  if valid_588838 != nil:
    section.add "alt", valid_588838
  var valid_588839 = query.getOrDefault("oauth_token")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "oauth_token", valid_588839
  var valid_588840 = query.getOrDefault("userIp")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "userIp", valid_588840
  var valid_588841 = query.getOrDefault("key")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "key", valid_588841
  var valid_588842 = query.getOrDefault("prettyPrint")
  valid_588842 = validateParameter(valid_588842, JBool, required = false,
                                 default = newJBool(true))
  if valid_588842 != nil:
    section.add "prettyPrint", valid_588842
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

proc call*(call_588866: Call_IdentitytoolkitRelyingpartyCreateAuthUri_588709;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates the URI used by the IdP to authenticate the user.
  ## 
  let valid = call_588866.validator(path, query, header, formData, body)
  let scheme = call_588866.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588866.url(scheme.get, call_588866.host, call_588866.base,
                         call_588866.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588866, url, valid)

proc call*(call_588937: Call_IdentitytoolkitRelyingpartyCreateAuthUri_588709;
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
  var query_588938 = newJObject()
  var body_588940 = newJObject()
  add(query_588938, "fields", newJString(fields))
  add(query_588938, "quotaUser", newJString(quotaUser))
  add(query_588938, "alt", newJString(alt))
  add(query_588938, "oauth_token", newJString(oauthToken))
  add(query_588938, "userIp", newJString(userIp))
  add(query_588938, "key", newJString(key))
  if body != nil:
    body_588940 = body
  add(query_588938, "prettyPrint", newJBool(prettyPrint))
  result = call_588937.call(nil, query_588938, nil, nil, body_588940)

var identitytoolkitRelyingpartyCreateAuthUri* = Call_IdentitytoolkitRelyingpartyCreateAuthUri_588709(
    name: "identitytoolkitRelyingpartyCreateAuthUri", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/createAuthUri",
    validator: validate_IdentitytoolkitRelyingpartyCreateAuthUri_588710,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyCreateAuthUri_588711,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyDeleteAccount_588979 = ref object of OpenApiRestCall_588441
proc url_IdentitytoolkitRelyingpartyDeleteAccount_588981(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyDeleteAccount_588980(path: JsonNode;
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
  var valid_588982 = query.getOrDefault("fields")
  valid_588982 = validateParameter(valid_588982, JString, required = false,
                                 default = nil)
  if valid_588982 != nil:
    section.add "fields", valid_588982
  var valid_588983 = query.getOrDefault("quotaUser")
  valid_588983 = validateParameter(valid_588983, JString, required = false,
                                 default = nil)
  if valid_588983 != nil:
    section.add "quotaUser", valid_588983
  var valid_588984 = query.getOrDefault("alt")
  valid_588984 = validateParameter(valid_588984, JString, required = false,
                                 default = newJString("json"))
  if valid_588984 != nil:
    section.add "alt", valid_588984
  var valid_588985 = query.getOrDefault("oauth_token")
  valid_588985 = validateParameter(valid_588985, JString, required = false,
                                 default = nil)
  if valid_588985 != nil:
    section.add "oauth_token", valid_588985
  var valid_588986 = query.getOrDefault("userIp")
  valid_588986 = validateParameter(valid_588986, JString, required = false,
                                 default = nil)
  if valid_588986 != nil:
    section.add "userIp", valid_588986
  var valid_588987 = query.getOrDefault("key")
  valid_588987 = validateParameter(valid_588987, JString, required = false,
                                 default = nil)
  if valid_588987 != nil:
    section.add "key", valid_588987
  var valid_588988 = query.getOrDefault("prettyPrint")
  valid_588988 = validateParameter(valid_588988, JBool, required = false,
                                 default = newJBool(true))
  if valid_588988 != nil:
    section.add "prettyPrint", valid_588988
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

proc call*(call_588990: Call_IdentitytoolkitRelyingpartyDeleteAccount_588979;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete user account.
  ## 
  let valid = call_588990.validator(path, query, header, formData, body)
  let scheme = call_588990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588990.url(scheme.get, call_588990.host, call_588990.base,
                         call_588990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588990, url, valid)

proc call*(call_588991: Call_IdentitytoolkitRelyingpartyDeleteAccount_588979;
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
  var query_588992 = newJObject()
  var body_588993 = newJObject()
  add(query_588992, "fields", newJString(fields))
  add(query_588992, "quotaUser", newJString(quotaUser))
  add(query_588992, "alt", newJString(alt))
  add(query_588992, "oauth_token", newJString(oauthToken))
  add(query_588992, "userIp", newJString(userIp))
  add(query_588992, "key", newJString(key))
  if body != nil:
    body_588993 = body
  add(query_588992, "prettyPrint", newJBool(prettyPrint))
  result = call_588991.call(nil, query_588992, nil, nil, body_588993)

var identitytoolkitRelyingpartyDeleteAccount* = Call_IdentitytoolkitRelyingpartyDeleteAccount_588979(
    name: "identitytoolkitRelyingpartyDeleteAccount", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/deleteAccount",
    validator: validate_IdentitytoolkitRelyingpartyDeleteAccount_588980,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyDeleteAccount_588981,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyDownloadAccount_588994 = ref object of OpenApiRestCall_588441
proc url_IdentitytoolkitRelyingpartyDownloadAccount_588996(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyDownloadAccount_588995(path: JsonNode;
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
  var valid_588997 = query.getOrDefault("fields")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = nil)
  if valid_588997 != nil:
    section.add "fields", valid_588997
  var valid_588998 = query.getOrDefault("quotaUser")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = nil)
  if valid_588998 != nil:
    section.add "quotaUser", valid_588998
  var valid_588999 = query.getOrDefault("alt")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = newJString("json"))
  if valid_588999 != nil:
    section.add "alt", valid_588999
  var valid_589000 = query.getOrDefault("oauth_token")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "oauth_token", valid_589000
  var valid_589001 = query.getOrDefault("userIp")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = nil)
  if valid_589001 != nil:
    section.add "userIp", valid_589001
  var valid_589002 = query.getOrDefault("key")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "key", valid_589002
  var valid_589003 = query.getOrDefault("prettyPrint")
  valid_589003 = validateParameter(valid_589003, JBool, required = false,
                                 default = newJBool(true))
  if valid_589003 != nil:
    section.add "prettyPrint", valid_589003
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

proc call*(call_589005: Call_IdentitytoolkitRelyingpartyDownloadAccount_588994;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Batch download user accounts.
  ## 
  let valid = call_589005.validator(path, query, header, formData, body)
  let scheme = call_589005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589005.url(scheme.get, call_589005.host, call_589005.base,
                         call_589005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589005, url, valid)

proc call*(call_589006: Call_IdentitytoolkitRelyingpartyDownloadAccount_588994;
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
  var query_589007 = newJObject()
  var body_589008 = newJObject()
  add(query_589007, "fields", newJString(fields))
  add(query_589007, "quotaUser", newJString(quotaUser))
  add(query_589007, "alt", newJString(alt))
  add(query_589007, "oauth_token", newJString(oauthToken))
  add(query_589007, "userIp", newJString(userIp))
  add(query_589007, "key", newJString(key))
  if body != nil:
    body_589008 = body
  add(query_589007, "prettyPrint", newJBool(prettyPrint))
  result = call_589006.call(nil, query_589007, nil, nil, body_589008)

var identitytoolkitRelyingpartyDownloadAccount* = Call_IdentitytoolkitRelyingpartyDownloadAccount_588994(
    name: "identitytoolkitRelyingpartyDownloadAccount", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/downloadAccount",
    validator: validate_IdentitytoolkitRelyingpartyDownloadAccount_588995,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyDownloadAccount_588996,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyEmailLinkSignin_589009 = ref object of OpenApiRestCall_588441
proc url_IdentitytoolkitRelyingpartyEmailLinkSignin_589011(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyEmailLinkSignin_589010(path: JsonNode;
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
  var valid_589012 = query.getOrDefault("fields")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "fields", valid_589012
  var valid_589013 = query.getOrDefault("quotaUser")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "quotaUser", valid_589013
  var valid_589014 = query.getOrDefault("alt")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = newJString("json"))
  if valid_589014 != nil:
    section.add "alt", valid_589014
  var valid_589015 = query.getOrDefault("oauth_token")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "oauth_token", valid_589015
  var valid_589016 = query.getOrDefault("userIp")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "userIp", valid_589016
  var valid_589017 = query.getOrDefault("key")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "key", valid_589017
  var valid_589018 = query.getOrDefault("prettyPrint")
  valid_589018 = validateParameter(valid_589018, JBool, required = false,
                                 default = newJBool(true))
  if valid_589018 != nil:
    section.add "prettyPrint", valid_589018
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

proc call*(call_589020: Call_IdentitytoolkitRelyingpartyEmailLinkSignin_589009;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reset password for a user.
  ## 
  let valid = call_589020.validator(path, query, header, formData, body)
  let scheme = call_589020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589020.url(scheme.get, call_589020.host, call_589020.base,
                         call_589020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589020, url, valid)

proc call*(call_589021: Call_IdentitytoolkitRelyingpartyEmailLinkSignin_589009;
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
  var query_589022 = newJObject()
  var body_589023 = newJObject()
  add(query_589022, "fields", newJString(fields))
  add(query_589022, "quotaUser", newJString(quotaUser))
  add(query_589022, "alt", newJString(alt))
  add(query_589022, "oauth_token", newJString(oauthToken))
  add(query_589022, "userIp", newJString(userIp))
  add(query_589022, "key", newJString(key))
  if body != nil:
    body_589023 = body
  add(query_589022, "prettyPrint", newJBool(prettyPrint))
  result = call_589021.call(nil, query_589022, nil, nil, body_589023)

var identitytoolkitRelyingpartyEmailLinkSignin* = Call_IdentitytoolkitRelyingpartyEmailLinkSignin_589009(
    name: "identitytoolkitRelyingpartyEmailLinkSignin", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/emailLinkSignin",
    validator: validate_IdentitytoolkitRelyingpartyEmailLinkSignin_589010,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyEmailLinkSignin_589011,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyGetAccountInfo_589024 = ref object of OpenApiRestCall_588441
proc url_IdentitytoolkitRelyingpartyGetAccountInfo_589026(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyGetAccountInfo_589025(path: JsonNode;
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
  var valid_589027 = query.getOrDefault("fields")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "fields", valid_589027
  var valid_589028 = query.getOrDefault("quotaUser")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "quotaUser", valid_589028
  var valid_589029 = query.getOrDefault("alt")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = newJString("json"))
  if valid_589029 != nil:
    section.add "alt", valid_589029
  var valid_589030 = query.getOrDefault("oauth_token")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "oauth_token", valid_589030
  var valid_589031 = query.getOrDefault("userIp")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "userIp", valid_589031
  var valid_589032 = query.getOrDefault("key")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "key", valid_589032
  var valid_589033 = query.getOrDefault("prettyPrint")
  valid_589033 = validateParameter(valid_589033, JBool, required = false,
                                 default = newJBool(true))
  if valid_589033 != nil:
    section.add "prettyPrint", valid_589033
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

proc call*(call_589035: Call_IdentitytoolkitRelyingpartyGetAccountInfo_589024;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the account info.
  ## 
  let valid = call_589035.validator(path, query, header, formData, body)
  let scheme = call_589035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589035.url(scheme.get, call_589035.host, call_589035.base,
                         call_589035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589035, url, valid)

proc call*(call_589036: Call_IdentitytoolkitRelyingpartyGetAccountInfo_589024;
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
  var query_589037 = newJObject()
  var body_589038 = newJObject()
  add(query_589037, "fields", newJString(fields))
  add(query_589037, "quotaUser", newJString(quotaUser))
  add(query_589037, "alt", newJString(alt))
  add(query_589037, "oauth_token", newJString(oauthToken))
  add(query_589037, "userIp", newJString(userIp))
  add(query_589037, "key", newJString(key))
  if body != nil:
    body_589038 = body
  add(query_589037, "prettyPrint", newJBool(prettyPrint))
  result = call_589036.call(nil, query_589037, nil, nil, body_589038)

var identitytoolkitRelyingpartyGetAccountInfo* = Call_IdentitytoolkitRelyingpartyGetAccountInfo_589024(
    name: "identitytoolkitRelyingpartyGetAccountInfo", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/getAccountInfo",
    validator: validate_IdentitytoolkitRelyingpartyGetAccountInfo_589025,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyGetAccountInfo_589026,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyGetOobConfirmationCode_589039 = ref object of OpenApiRestCall_588441
proc url_IdentitytoolkitRelyingpartyGetOobConfirmationCode_589041(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyGetOobConfirmationCode_589040(
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
  var valid_589042 = query.getOrDefault("fields")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "fields", valid_589042
  var valid_589043 = query.getOrDefault("quotaUser")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "quotaUser", valid_589043
  var valid_589044 = query.getOrDefault("alt")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = newJString("json"))
  if valid_589044 != nil:
    section.add "alt", valid_589044
  var valid_589045 = query.getOrDefault("oauth_token")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "oauth_token", valid_589045
  var valid_589046 = query.getOrDefault("userIp")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "userIp", valid_589046
  var valid_589047 = query.getOrDefault("key")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "key", valid_589047
  var valid_589048 = query.getOrDefault("prettyPrint")
  valid_589048 = validateParameter(valid_589048, JBool, required = false,
                                 default = newJBool(true))
  if valid_589048 != nil:
    section.add "prettyPrint", valid_589048
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

proc call*(call_589050: Call_IdentitytoolkitRelyingpartyGetOobConfirmationCode_589039;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a code for user action confirmation.
  ## 
  let valid = call_589050.validator(path, query, header, formData, body)
  let scheme = call_589050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589050.url(scheme.get, call_589050.host, call_589050.base,
                         call_589050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589050, url, valid)

proc call*(call_589051: Call_IdentitytoolkitRelyingpartyGetOobConfirmationCode_589039;
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
  var query_589052 = newJObject()
  var body_589053 = newJObject()
  add(query_589052, "fields", newJString(fields))
  add(query_589052, "quotaUser", newJString(quotaUser))
  add(query_589052, "alt", newJString(alt))
  add(query_589052, "oauth_token", newJString(oauthToken))
  add(query_589052, "userIp", newJString(userIp))
  add(query_589052, "key", newJString(key))
  if body != nil:
    body_589053 = body
  add(query_589052, "prettyPrint", newJBool(prettyPrint))
  result = call_589051.call(nil, query_589052, nil, nil, body_589053)

var identitytoolkitRelyingpartyGetOobConfirmationCode* = Call_IdentitytoolkitRelyingpartyGetOobConfirmationCode_589039(
    name: "identitytoolkitRelyingpartyGetOobConfirmationCode",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/getOobConfirmationCode",
    validator: validate_IdentitytoolkitRelyingpartyGetOobConfirmationCode_589040,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyGetOobConfirmationCode_589041,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyGetProjectConfig_589054 = ref object of OpenApiRestCall_588441
proc url_IdentitytoolkitRelyingpartyGetProjectConfig_589056(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyGetProjectConfig_589055(path: JsonNode;
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
  var valid_589057 = query.getOrDefault("fields")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "fields", valid_589057
  var valid_589058 = query.getOrDefault("quotaUser")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "quotaUser", valid_589058
  var valid_589059 = query.getOrDefault("delegatedProjectNumber")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "delegatedProjectNumber", valid_589059
  var valid_589060 = query.getOrDefault("alt")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = newJString("json"))
  if valid_589060 != nil:
    section.add "alt", valid_589060
  var valid_589061 = query.getOrDefault("oauth_token")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "oauth_token", valid_589061
  var valid_589062 = query.getOrDefault("userIp")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "userIp", valid_589062
  var valid_589063 = query.getOrDefault("key")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "key", valid_589063
  var valid_589064 = query.getOrDefault("projectNumber")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "projectNumber", valid_589064
  var valid_589065 = query.getOrDefault("prettyPrint")
  valid_589065 = validateParameter(valid_589065, JBool, required = false,
                                 default = newJBool(true))
  if valid_589065 != nil:
    section.add "prettyPrint", valid_589065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589066: Call_IdentitytoolkitRelyingpartyGetProjectConfig_589054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get project configuration.
  ## 
  let valid = call_589066.validator(path, query, header, formData, body)
  let scheme = call_589066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589066.url(scheme.get, call_589066.host, call_589066.base,
                         call_589066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589066, url, valid)

proc call*(call_589067: Call_IdentitytoolkitRelyingpartyGetProjectConfig_589054;
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
  var query_589068 = newJObject()
  add(query_589068, "fields", newJString(fields))
  add(query_589068, "quotaUser", newJString(quotaUser))
  add(query_589068, "delegatedProjectNumber", newJString(delegatedProjectNumber))
  add(query_589068, "alt", newJString(alt))
  add(query_589068, "oauth_token", newJString(oauthToken))
  add(query_589068, "userIp", newJString(userIp))
  add(query_589068, "key", newJString(key))
  add(query_589068, "projectNumber", newJString(projectNumber))
  add(query_589068, "prettyPrint", newJBool(prettyPrint))
  result = call_589067.call(nil, query_589068, nil, nil, nil)

var identitytoolkitRelyingpartyGetProjectConfig* = Call_IdentitytoolkitRelyingpartyGetProjectConfig_589054(
    name: "identitytoolkitRelyingpartyGetProjectConfig", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/getProjectConfig",
    validator: validate_IdentitytoolkitRelyingpartyGetProjectConfig_589055,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyGetProjectConfig_589056,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyGetRecaptchaParam_589069 = ref object of OpenApiRestCall_588441
proc url_IdentitytoolkitRelyingpartyGetRecaptchaParam_589071(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyGetRecaptchaParam_589070(path: JsonNode;
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
  var valid_589072 = query.getOrDefault("fields")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "fields", valid_589072
  var valid_589073 = query.getOrDefault("quotaUser")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "quotaUser", valid_589073
  var valid_589074 = query.getOrDefault("alt")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = newJString("json"))
  if valid_589074 != nil:
    section.add "alt", valid_589074
  var valid_589075 = query.getOrDefault("oauth_token")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "oauth_token", valid_589075
  var valid_589076 = query.getOrDefault("userIp")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "userIp", valid_589076
  var valid_589077 = query.getOrDefault("key")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "key", valid_589077
  var valid_589078 = query.getOrDefault("prettyPrint")
  valid_589078 = validateParameter(valid_589078, JBool, required = false,
                                 default = newJBool(true))
  if valid_589078 != nil:
    section.add "prettyPrint", valid_589078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589079: Call_IdentitytoolkitRelyingpartyGetRecaptchaParam_589069;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get recaptcha secure param.
  ## 
  let valid = call_589079.validator(path, query, header, formData, body)
  let scheme = call_589079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589079.url(scheme.get, call_589079.host, call_589079.base,
                         call_589079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589079, url, valid)

proc call*(call_589080: Call_IdentitytoolkitRelyingpartyGetRecaptchaParam_589069;
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
  var query_589081 = newJObject()
  add(query_589081, "fields", newJString(fields))
  add(query_589081, "quotaUser", newJString(quotaUser))
  add(query_589081, "alt", newJString(alt))
  add(query_589081, "oauth_token", newJString(oauthToken))
  add(query_589081, "userIp", newJString(userIp))
  add(query_589081, "key", newJString(key))
  add(query_589081, "prettyPrint", newJBool(prettyPrint))
  result = call_589080.call(nil, query_589081, nil, nil, nil)

var identitytoolkitRelyingpartyGetRecaptchaParam* = Call_IdentitytoolkitRelyingpartyGetRecaptchaParam_589069(
    name: "identitytoolkitRelyingpartyGetRecaptchaParam",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/getRecaptchaParam",
    validator: validate_IdentitytoolkitRelyingpartyGetRecaptchaParam_589070,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyGetRecaptchaParam_589071,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyGetPublicKeys_589082 = ref object of OpenApiRestCall_588441
proc url_IdentitytoolkitRelyingpartyGetPublicKeys_589084(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyGetPublicKeys_589083(path: JsonNode;
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
  var valid_589085 = query.getOrDefault("fields")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "fields", valid_589085
  var valid_589086 = query.getOrDefault("quotaUser")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "quotaUser", valid_589086
  var valid_589087 = query.getOrDefault("alt")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = newJString("json"))
  if valid_589087 != nil:
    section.add "alt", valid_589087
  var valid_589088 = query.getOrDefault("oauth_token")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "oauth_token", valid_589088
  var valid_589089 = query.getOrDefault("userIp")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "userIp", valid_589089
  var valid_589090 = query.getOrDefault("key")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "key", valid_589090
  var valid_589091 = query.getOrDefault("prettyPrint")
  valid_589091 = validateParameter(valid_589091, JBool, required = false,
                                 default = newJBool(true))
  if valid_589091 != nil:
    section.add "prettyPrint", valid_589091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589092: Call_IdentitytoolkitRelyingpartyGetPublicKeys_589082;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get token signing public key.
  ## 
  let valid = call_589092.validator(path, query, header, formData, body)
  let scheme = call_589092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589092.url(scheme.get, call_589092.host, call_589092.base,
                         call_589092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589092, url, valid)

proc call*(call_589093: Call_IdentitytoolkitRelyingpartyGetPublicKeys_589082;
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
  var query_589094 = newJObject()
  add(query_589094, "fields", newJString(fields))
  add(query_589094, "quotaUser", newJString(quotaUser))
  add(query_589094, "alt", newJString(alt))
  add(query_589094, "oauth_token", newJString(oauthToken))
  add(query_589094, "userIp", newJString(userIp))
  add(query_589094, "key", newJString(key))
  add(query_589094, "prettyPrint", newJBool(prettyPrint))
  result = call_589093.call(nil, query_589094, nil, nil, nil)

var identitytoolkitRelyingpartyGetPublicKeys* = Call_IdentitytoolkitRelyingpartyGetPublicKeys_589082(
    name: "identitytoolkitRelyingpartyGetPublicKeys", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/publicKeys",
    validator: validate_IdentitytoolkitRelyingpartyGetPublicKeys_589083,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyGetPublicKeys_589084,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyResetPassword_589095 = ref object of OpenApiRestCall_588441
proc url_IdentitytoolkitRelyingpartyResetPassword_589097(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyResetPassword_589096(path: JsonNode;
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
  var valid_589098 = query.getOrDefault("fields")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "fields", valid_589098
  var valid_589099 = query.getOrDefault("quotaUser")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "quotaUser", valid_589099
  var valid_589100 = query.getOrDefault("alt")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = newJString("json"))
  if valid_589100 != nil:
    section.add "alt", valid_589100
  var valid_589101 = query.getOrDefault("oauth_token")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "oauth_token", valid_589101
  var valid_589102 = query.getOrDefault("userIp")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "userIp", valid_589102
  var valid_589103 = query.getOrDefault("key")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "key", valid_589103
  var valid_589104 = query.getOrDefault("prettyPrint")
  valid_589104 = validateParameter(valid_589104, JBool, required = false,
                                 default = newJBool(true))
  if valid_589104 != nil:
    section.add "prettyPrint", valid_589104
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

proc call*(call_589106: Call_IdentitytoolkitRelyingpartyResetPassword_589095;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reset password for a user.
  ## 
  let valid = call_589106.validator(path, query, header, formData, body)
  let scheme = call_589106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589106.url(scheme.get, call_589106.host, call_589106.base,
                         call_589106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589106, url, valid)

proc call*(call_589107: Call_IdentitytoolkitRelyingpartyResetPassword_589095;
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
  var query_589108 = newJObject()
  var body_589109 = newJObject()
  add(query_589108, "fields", newJString(fields))
  add(query_589108, "quotaUser", newJString(quotaUser))
  add(query_589108, "alt", newJString(alt))
  add(query_589108, "oauth_token", newJString(oauthToken))
  add(query_589108, "userIp", newJString(userIp))
  add(query_589108, "key", newJString(key))
  if body != nil:
    body_589109 = body
  add(query_589108, "prettyPrint", newJBool(prettyPrint))
  result = call_589107.call(nil, query_589108, nil, nil, body_589109)

var identitytoolkitRelyingpartyResetPassword* = Call_IdentitytoolkitRelyingpartyResetPassword_589095(
    name: "identitytoolkitRelyingpartyResetPassword", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/resetPassword",
    validator: validate_IdentitytoolkitRelyingpartyResetPassword_589096,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyResetPassword_589097,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartySendVerificationCode_589110 = ref object of OpenApiRestCall_588441
proc url_IdentitytoolkitRelyingpartySendVerificationCode_589112(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartySendVerificationCode_589111(
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
  var valid_589113 = query.getOrDefault("fields")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "fields", valid_589113
  var valid_589114 = query.getOrDefault("quotaUser")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "quotaUser", valid_589114
  var valid_589115 = query.getOrDefault("alt")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = newJString("json"))
  if valid_589115 != nil:
    section.add "alt", valid_589115
  var valid_589116 = query.getOrDefault("oauth_token")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "oauth_token", valid_589116
  var valid_589117 = query.getOrDefault("userIp")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "userIp", valid_589117
  var valid_589118 = query.getOrDefault("key")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "key", valid_589118
  var valid_589119 = query.getOrDefault("prettyPrint")
  valid_589119 = validateParameter(valid_589119, JBool, required = false,
                                 default = newJBool(true))
  if valid_589119 != nil:
    section.add "prettyPrint", valid_589119
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

proc call*(call_589121: Call_IdentitytoolkitRelyingpartySendVerificationCode_589110;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Send SMS verification code.
  ## 
  let valid = call_589121.validator(path, query, header, formData, body)
  let scheme = call_589121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589121.url(scheme.get, call_589121.host, call_589121.base,
                         call_589121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589121, url, valid)

proc call*(call_589122: Call_IdentitytoolkitRelyingpartySendVerificationCode_589110;
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
  var query_589123 = newJObject()
  var body_589124 = newJObject()
  add(query_589123, "fields", newJString(fields))
  add(query_589123, "quotaUser", newJString(quotaUser))
  add(query_589123, "alt", newJString(alt))
  add(query_589123, "oauth_token", newJString(oauthToken))
  add(query_589123, "userIp", newJString(userIp))
  add(query_589123, "key", newJString(key))
  if body != nil:
    body_589124 = body
  add(query_589123, "prettyPrint", newJBool(prettyPrint))
  result = call_589122.call(nil, query_589123, nil, nil, body_589124)

var identitytoolkitRelyingpartySendVerificationCode* = Call_IdentitytoolkitRelyingpartySendVerificationCode_589110(
    name: "identitytoolkitRelyingpartySendVerificationCode",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/sendVerificationCode",
    validator: validate_IdentitytoolkitRelyingpartySendVerificationCode_589111,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartySendVerificationCode_589112,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartySetAccountInfo_589125 = ref object of OpenApiRestCall_588441
proc url_IdentitytoolkitRelyingpartySetAccountInfo_589127(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartySetAccountInfo_589126(path: JsonNode;
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
  var valid_589128 = query.getOrDefault("fields")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "fields", valid_589128
  var valid_589129 = query.getOrDefault("quotaUser")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "quotaUser", valid_589129
  var valid_589130 = query.getOrDefault("alt")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = newJString("json"))
  if valid_589130 != nil:
    section.add "alt", valid_589130
  var valid_589131 = query.getOrDefault("oauth_token")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "oauth_token", valid_589131
  var valid_589132 = query.getOrDefault("userIp")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "userIp", valid_589132
  var valid_589133 = query.getOrDefault("key")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "key", valid_589133
  var valid_589134 = query.getOrDefault("prettyPrint")
  valid_589134 = validateParameter(valid_589134, JBool, required = false,
                                 default = newJBool(true))
  if valid_589134 != nil:
    section.add "prettyPrint", valid_589134
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

proc call*(call_589136: Call_IdentitytoolkitRelyingpartySetAccountInfo_589125;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Set account info for a user.
  ## 
  let valid = call_589136.validator(path, query, header, formData, body)
  let scheme = call_589136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589136.url(scheme.get, call_589136.host, call_589136.base,
                         call_589136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589136, url, valid)

proc call*(call_589137: Call_IdentitytoolkitRelyingpartySetAccountInfo_589125;
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
  var query_589138 = newJObject()
  var body_589139 = newJObject()
  add(query_589138, "fields", newJString(fields))
  add(query_589138, "quotaUser", newJString(quotaUser))
  add(query_589138, "alt", newJString(alt))
  add(query_589138, "oauth_token", newJString(oauthToken))
  add(query_589138, "userIp", newJString(userIp))
  add(query_589138, "key", newJString(key))
  if body != nil:
    body_589139 = body
  add(query_589138, "prettyPrint", newJBool(prettyPrint))
  result = call_589137.call(nil, query_589138, nil, nil, body_589139)

var identitytoolkitRelyingpartySetAccountInfo* = Call_IdentitytoolkitRelyingpartySetAccountInfo_589125(
    name: "identitytoolkitRelyingpartySetAccountInfo", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/setAccountInfo",
    validator: validate_IdentitytoolkitRelyingpartySetAccountInfo_589126,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartySetAccountInfo_589127,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartySetProjectConfig_589140 = ref object of OpenApiRestCall_588441
proc url_IdentitytoolkitRelyingpartySetProjectConfig_589142(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartySetProjectConfig_589141(path: JsonNode;
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
  var valid_589143 = query.getOrDefault("fields")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "fields", valid_589143
  var valid_589144 = query.getOrDefault("quotaUser")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "quotaUser", valid_589144
  var valid_589145 = query.getOrDefault("alt")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = newJString("json"))
  if valid_589145 != nil:
    section.add "alt", valid_589145
  var valid_589146 = query.getOrDefault("oauth_token")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "oauth_token", valid_589146
  var valid_589147 = query.getOrDefault("userIp")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "userIp", valid_589147
  var valid_589148 = query.getOrDefault("key")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "key", valid_589148
  var valid_589149 = query.getOrDefault("prettyPrint")
  valid_589149 = validateParameter(valid_589149, JBool, required = false,
                                 default = newJBool(true))
  if valid_589149 != nil:
    section.add "prettyPrint", valid_589149
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

proc call*(call_589151: Call_IdentitytoolkitRelyingpartySetProjectConfig_589140;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Set project configuration.
  ## 
  let valid = call_589151.validator(path, query, header, formData, body)
  let scheme = call_589151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589151.url(scheme.get, call_589151.host, call_589151.base,
                         call_589151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589151, url, valid)

proc call*(call_589152: Call_IdentitytoolkitRelyingpartySetProjectConfig_589140;
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
  var query_589153 = newJObject()
  var body_589154 = newJObject()
  add(query_589153, "fields", newJString(fields))
  add(query_589153, "quotaUser", newJString(quotaUser))
  add(query_589153, "alt", newJString(alt))
  add(query_589153, "oauth_token", newJString(oauthToken))
  add(query_589153, "userIp", newJString(userIp))
  add(query_589153, "key", newJString(key))
  if body != nil:
    body_589154 = body
  add(query_589153, "prettyPrint", newJBool(prettyPrint))
  result = call_589152.call(nil, query_589153, nil, nil, body_589154)

var identitytoolkitRelyingpartySetProjectConfig* = Call_IdentitytoolkitRelyingpartySetProjectConfig_589140(
    name: "identitytoolkitRelyingpartySetProjectConfig",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/setProjectConfig",
    validator: validate_IdentitytoolkitRelyingpartySetProjectConfig_589141,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartySetProjectConfig_589142,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartySignOutUser_589155 = ref object of OpenApiRestCall_588441
proc url_IdentitytoolkitRelyingpartySignOutUser_589157(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartySignOutUser_589156(path: JsonNode;
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
  var valid_589158 = query.getOrDefault("fields")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "fields", valid_589158
  var valid_589159 = query.getOrDefault("quotaUser")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "quotaUser", valid_589159
  var valid_589160 = query.getOrDefault("alt")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = newJString("json"))
  if valid_589160 != nil:
    section.add "alt", valid_589160
  var valid_589161 = query.getOrDefault("oauth_token")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "oauth_token", valid_589161
  var valid_589162 = query.getOrDefault("userIp")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "userIp", valid_589162
  var valid_589163 = query.getOrDefault("key")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "key", valid_589163
  var valid_589164 = query.getOrDefault("prettyPrint")
  valid_589164 = validateParameter(valid_589164, JBool, required = false,
                                 default = newJBool(true))
  if valid_589164 != nil:
    section.add "prettyPrint", valid_589164
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

proc call*(call_589166: Call_IdentitytoolkitRelyingpartySignOutUser_589155;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sign out user.
  ## 
  let valid = call_589166.validator(path, query, header, formData, body)
  let scheme = call_589166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589166.url(scheme.get, call_589166.host, call_589166.base,
                         call_589166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589166, url, valid)

proc call*(call_589167: Call_IdentitytoolkitRelyingpartySignOutUser_589155;
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
  var query_589168 = newJObject()
  var body_589169 = newJObject()
  add(query_589168, "fields", newJString(fields))
  add(query_589168, "quotaUser", newJString(quotaUser))
  add(query_589168, "alt", newJString(alt))
  add(query_589168, "oauth_token", newJString(oauthToken))
  add(query_589168, "userIp", newJString(userIp))
  add(query_589168, "key", newJString(key))
  if body != nil:
    body_589169 = body
  add(query_589168, "prettyPrint", newJBool(prettyPrint))
  result = call_589167.call(nil, query_589168, nil, nil, body_589169)

var identitytoolkitRelyingpartySignOutUser* = Call_IdentitytoolkitRelyingpartySignOutUser_589155(
    name: "identitytoolkitRelyingpartySignOutUser", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/signOutUser",
    validator: validate_IdentitytoolkitRelyingpartySignOutUser_589156,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartySignOutUser_589157,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartySignupNewUser_589170 = ref object of OpenApiRestCall_588441
proc url_IdentitytoolkitRelyingpartySignupNewUser_589172(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartySignupNewUser_589171(path: JsonNode;
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
  var valid_589173 = query.getOrDefault("fields")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "fields", valid_589173
  var valid_589174 = query.getOrDefault("quotaUser")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "quotaUser", valid_589174
  var valid_589175 = query.getOrDefault("alt")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = newJString("json"))
  if valid_589175 != nil:
    section.add "alt", valid_589175
  var valid_589176 = query.getOrDefault("oauth_token")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "oauth_token", valid_589176
  var valid_589177 = query.getOrDefault("userIp")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "userIp", valid_589177
  var valid_589178 = query.getOrDefault("key")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "key", valid_589178
  var valid_589179 = query.getOrDefault("prettyPrint")
  valid_589179 = validateParameter(valid_589179, JBool, required = false,
                                 default = newJBool(true))
  if valid_589179 != nil:
    section.add "prettyPrint", valid_589179
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

proc call*(call_589181: Call_IdentitytoolkitRelyingpartySignupNewUser_589170;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Signup new user.
  ## 
  let valid = call_589181.validator(path, query, header, formData, body)
  let scheme = call_589181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589181.url(scheme.get, call_589181.host, call_589181.base,
                         call_589181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589181, url, valid)

proc call*(call_589182: Call_IdentitytoolkitRelyingpartySignupNewUser_589170;
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
  var query_589183 = newJObject()
  var body_589184 = newJObject()
  add(query_589183, "fields", newJString(fields))
  add(query_589183, "quotaUser", newJString(quotaUser))
  add(query_589183, "alt", newJString(alt))
  add(query_589183, "oauth_token", newJString(oauthToken))
  add(query_589183, "userIp", newJString(userIp))
  add(query_589183, "key", newJString(key))
  if body != nil:
    body_589184 = body
  add(query_589183, "prettyPrint", newJBool(prettyPrint))
  result = call_589182.call(nil, query_589183, nil, nil, body_589184)

var identitytoolkitRelyingpartySignupNewUser* = Call_IdentitytoolkitRelyingpartySignupNewUser_589170(
    name: "identitytoolkitRelyingpartySignupNewUser", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/signupNewUser",
    validator: validate_IdentitytoolkitRelyingpartySignupNewUser_589171,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartySignupNewUser_589172,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyUploadAccount_589185 = ref object of OpenApiRestCall_588441
proc url_IdentitytoolkitRelyingpartyUploadAccount_589187(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyUploadAccount_589186(path: JsonNode;
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
  var valid_589188 = query.getOrDefault("fields")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "fields", valid_589188
  var valid_589189 = query.getOrDefault("quotaUser")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "quotaUser", valid_589189
  var valid_589190 = query.getOrDefault("alt")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = newJString("json"))
  if valid_589190 != nil:
    section.add "alt", valid_589190
  var valid_589191 = query.getOrDefault("oauth_token")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "oauth_token", valid_589191
  var valid_589192 = query.getOrDefault("userIp")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "userIp", valid_589192
  var valid_589193 = query.getOrDefault("key")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "key", valid_589193
  var valid_589194 = query.getOrDefault("prettyPrint")
  valid_589194 = validateParameter(valid_589194, JBool, required = false,
                                 default = newJBool(true))
  if valid_589194 != nil:
    section.add "prettyPrint", valid_589194
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

proc call*(call_589196: Call_IdentitytoolkitRelyingpartyUploadAccount_589185;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Batch upload existing user accounts.
  ## 
  let valid = call_589196.validator(path, query, header, formData, body)
  let scheme = call_589196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589196.url(scheme.get, call_589196.host, call_589196.base,
                         call_589196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589196, url, valid)

proc call*(call_589197: Call_IdentitytoolkitRelyingpartyUploadAccount_589185;
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
  var query_589198 = newJObject()
  var body_589199 = newJObject()
  add(query_589198, "fields", newJString(fields))
  add(query_589198, "quotaUser", newJString(quotaUser))
  add(query_589198, "alt", newJString(alt))
  add(query_589198, "oauth_token", newJString(oauthToken))
  add(query_589198, "userIp", newJString(userIp))
  add(query_589198, "key", newJString(key))
  if body != nil:
    body_589199 = body
  add(query_589198, "prettyPrint", newJBool(prettyPrint))
  result = call_589197.call(nil, query_589198, nil, nil, body_589199)

var identitytoolkitRelyingpartyUploadAccount* = Call_IdentitytoolkitRelyingpartyUploadAccount_589185(
    name: "identitytoolkitRelyingpartyUploadAccount", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/uploadAccount",
    validator: validate_IdentitytoolkitRelyingpartyUploadAccount_589186,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyUploadAccount_589187,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyVerifyAssertion_589200 = ref object of OpenApiRestCall_588441
proc url_IdentitytoolkitRelyingpartyVerifyAssertion_589202(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyVerifyAssertion_589201(path: JsonNode;
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
  var valid_589203 = query.getOrDefault("fields")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "fields", valid_589203
  var valid_589204 = query.getOrDefault("quotaUser")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "quotaUser", valid_589204
  var valid_589205 = query.getOrDefault("alt")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = newJString("json"))
  if valid_589205 != nil:
    section.add "alt", valid_589205
  var valid_589206 = query.getOrDefault("oauth_token")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "oauth_token", valid_589206
  var valid_589207 = query.getOrDefault("userIp")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "userIp", valid_589207
  var valid_589208 = query.getOrDefault("key")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "key", valid_589208
  var valid_589209 = query.getOrDefault("prettyPrint")
  valid_589209 = validateParameter(valid_589209, JBool, required = false,
                                 default = newJBool(true))
  if valid_589209 != nil:
    section.add "prettyPrint", valid_589209
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

proc call*(call_589211: Call_IdentitytoolkitRelyingpartyVerifyAssertion_589200;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verifies the assertion returned by the IdP.
  ## 
  let valid = call_589211.validator(path, query, header, formData, body)
  let scheme = call_589211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589211.url(scheme.get, call_589211.host, call_589211.base,
                         call_589211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589211, url, valid)

proc call*(call_589212: Call_IdentitytoolkitRelyingpartyVerifyAssertion_589200;
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
  var query_589213 = newJObject()
  var body_589214 = newJObject()
  add(query_589213, "fields", newJString(fields))
  add(query_589213, "quotaUser", newJString(quotaUser))
  add(query_589213, "alt", newJString(alt))
  add(query_589213, "oauth_token", newJString(oauthToken))
  add(query_589213, "userIp", newJString(userIp))
  add(query_589213, "key", newJString(key))
  if body != nil:
    body_589214 = body
  add(query_589213, "prettyPrint", newJBool(prettyPrint))
  result = call_589212.call(nil, query_589213, nil, nil, body_589214)

var identitytoolkitRelyingpartyVerifyAssertion* = Call_IdentitytoolkitRelyingpartyVerifyAssertion_589200(
    name: "identitytoolkitRelyingpartyVerifyAssertion", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/verifyAssertion",
    validator: validate_IdentitytoolkitRelyingpartyVerifyAssertion_589201,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyVerifyAssertion_589202,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyVerifyCustomToken_589215 = ref object of OpenApiRestCall_588441
proc url_IdentitytoolkitRelyingpartyVerifyCustomToken_589217(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyVerifyCustomToken_589216(path: JsonNode;
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
  var valid_589218 = query.getOrDefault("fields")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "fields", valid_589218
  var valid_589219 = query.getOrDefault("quotaUser")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "quotaUser", valid_589219
  var valid_589220 = query.getOrDefault("alt")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = newJString("json"))
  if valid_589220 != nil:
    section.add "alt", valid_589220
  var valid_589221 = query.getOrDefault("oauth_token")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "oauth_token", valid_589221
  var valid_589222 = query.getOrDefault("userIp")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "userIp", valid_589222
  var valid_589223 = query.getOrDefault("key")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "key", valid_589223
  var valid_589224 = query.getOrDefault("prettyPrint")
  valid_589224 = validateParameter(valid_589224, JBool, required = false,
                                 default = newJBool(true))
  if valid_589224 != nil:
    section.add "prettyPrint", valid_589224
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

proc call*(call_589226: Call_IdentitytoolkitRelyingpartyVerifyCustomToken_589215;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verifies the developer asserted ID token.
  ## 
  let valid = call_589226.validator(path, query, header, formData, body)
  let scheme = call_589226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589226.url(scheme.get, call_589226.host, call_589226.base,
                         call_589226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589226, url, valid)

proc call*(call_589227: Call_IdentitytoolkitRelyingpartyVerifyCustomToken_589215;
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
  var query_589228 = newJObject()
  var body_589229 = newJObject()
  add(query_589228, "fields", newJString(fields))
  add(query_589228, "quotaUser", newJString(quotaUser))
  add(query_589228, "alt", newJString(alt))
  add(query_589228, "oauth_token", newJString(oauthToken))
  add(query_589228, "userIp", newJString(userIp))
  add(query_589228, "key", newJString(key))
  if body != nil:
    body_589229 = body
  add(query_589228, "prettyPrint", newJBool(prettyPrint))
  result = call_589227.call(nil, query_589228, nil, nil, body_589229)

var identitytoolkitRelyingpartyVerifyCustomToken* = Call_IdentitytoolkitRelyingpartyVerifyCustomToken_589215(
    name: "identitytoolkitRelyingpartyVerifyCustomToken",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/verifyCustomToken",
    validator: validate_IdentitytoolkitRelyingpartyVerifyCustomToken_589216,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyVerifyCustomToken_589217,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyVerifyPassword_589230 = ref object of OpenApiRestCall_588441
proc url_IdentitytoolkitRelyingpartyVerifyPassword_589232(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyVerifyPassword_589231(path: JsonNode;
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
  var valid_589233 = query.getOrDefault("fields")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = nil)
  if valid_589233 != nil:
    section.add "fields", valid_589233
  var valid_589234 = query.getOrDefault("quotaUser")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "quotaUser", valid_589234
  var valid_589235 = query.getOrDefault("alt")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = newJString("json"))
  if valid_589235 != nil:
    section.add "alt", valid_589235
  var valid_589236 = query.getOrDefault("oauth_token")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "oauth_token", valid_589236
  var valid_589237 = query.getOrDefault("userIp")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "userIp", valid_589237
  var valid_589238 = query.getOrDefault("key")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "key", valid_589238
  var valid_589239 = query.getOrDefault("prettyPrint")
  valid_589239 = validateParameter(valid_589239, JBool, required = false,
                                 default = newJBool(true))
  if valid_589239 != nil:
    section.add "prettyPrint", valid_589239
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

proc call*(call_589241: Call_IdentitytoolkitRelyingpartyVerifyPassword_589230;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verifies the user entered password.
  ## 
  let valid = call_589241.validator(path, query, header, formData, body)
  let scheme = call_589241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589241.url(scheme.get, call_589241.host, call_589241.base,
                         call_589241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589241, url, valid)

proc call*(call_589242: Call_IdentitytoolkitRelyingpartyVerifyPassword_589230;
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
  var query_589243 = newJObject()
  var body_589244 = newJObject()
  add(query_589243, "fields", newJString(fields))
  add(query_589243, "quotaUser", newJString(quotaUser))
  add(query_589243, "alt", newJString(alt))
  add(query_589243, "oauth_token", newJString(oauthToken))
  add(query_589243, "userIp", newJString(userIp))
  add(query_589243, "key", newJString(key))
  if body != nil:
    body_589244 = body
  add(query_589243, "prettyPrint", newJBool(prettyPrint))
  result = call_589242.call(nil, query_589243, nil, nil, body_589244)

var identitytoolkitRelyingpartyVerifyPassword* = Call_IdentitytoolkitRelyingpartyVerifyPassword_589230(
    name: "identitytoolkitRelyingpartyVerifyPassword", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/verifyPassword",
    validator: validate_IdentitytoolkitRelyingpartyVerifyPassword_589231,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyVerifyPassword_589232,
    schemes: {Scheme.Https})
type
  Call_IdentitytoolkitRelyingpartyVerifyPhoneNumber_589245 = ref object of OpenApiRestCall_588441
proc url_IdentitytoolkitRelyingpartyVerifyPhoneNumber_589247(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IdentitytoolkitRelyingpartyVerifyPhoneNumber_589246(path: JsonNode;
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
  var valid_589248 = query.getOrDefault("fields")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "fields", valid_589248
  var valid_589249 = query.getOrDefault("quotaUser")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "quotaUser", valid_589249
  var valid_589250 = query.getOrDefault("alt")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = newJString("json"))
  if valid_589250 != nil:
    section.add "alt", valid_589250
  var valid_589251 = query.getOrDefault("oauth_token")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "oauth_token", valid_589251
  var valid_589252 = query.getOrDefault("userIp")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "userIp", valid_589252
  var valid_589253 = query.getOrDefault("key")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = nil)
  if valid_589253 != nil:
    section.add "key", valid_589253
  var valid_589254 = query.getOrDefault("prettyPrint")
  valid_589254 = validateParameter(valid_589254, JBool, required = false,
                                 default = newJBool(true))
  if valid_589254 != nil:
    section.add "prettyPrint", valid_589254
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

proc call*(call_589256: Call_IdentitytoolkitRelyingpartyVerifyPhoneNumber_589245;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verifies ownership of a phone number and creates/updates the user account accordingly.
  ## 
  let valid = call_589256.validator(path, query, header, formData, body)
  let scheme = call_589256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589256.url(scheme.get, call_589256.host, call_589256.base,
                         call_589256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589256, url, valid)

proc call*(call_589257: Call_IdentitytoolkitRelyingpartyVerifyPhoneNumber_589245;
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
  var query_589258 = newJObject()
  var body_589259 = newJObject()
  add(query_589258, "fields", newJString(fields))
  add(query_589258, "quotaUser", newJString(quotaUser))
  add(query_589258, "alt", newJString(alt))
  add(query_589258, "oauth_token", newJString(oauthToken))
  add(query_589258, "userIp", newJString(userIp))
  add(query_589258, "key", newJString(key))
  if body != nil:
    body_589259 = body
  add(query_589258, "prettyPrint", newJBool(prettyPrint))
  result = call_589257.call(nil, query_589258, nil, nil, body_589259)

var identitytoolkitRelyingpartyVerifyPhoneNumber* = Call_IdentitytoolkitRelyingpartyVerifyPhoneNumber_589245(
    name: "identitytoolkitRelyingpartyVerifyPhoneNumber",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/verifyPhoneNumber",
    validator: validate_IdentitytoolkitRelyingpartyVerifyPhoneNumber_589246,
    base: "/identitytoolkit/v3/relyingparty",
    url: url_IdentitytoolkitRelyingpartyVerifyPhoneNumber_589247,
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

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
