
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Content API for Shopping
## version: v2.1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Manages product items, inventory, and Merchant Center accounts for Google Shopping.
## 
## https://developers.google.com/shopping-content
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

  OpenApiRestCall_579421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579421): Option[Scheme] {.used.} =
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
  gcpServiceName = "content"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ContentAccountsAuthinfo_579690 = ref object of OpenApiRestCall_579421
proc url_ContentAccountsAuthinfo_579692(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentAccountsAuthinfo_579691(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns information about the authenticated user.
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
  var valid_579804 = query.getOrDefault("fields")
  valid_579804 = validateParameter(valid_579804, JString, required = false,
                                 default = nil)
  if valid_579804 != nil:
    section.add "fields", valid_579804
  var valid_579805 = query.getOrDefault("quotaUser")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = nil)
  if valid_579805 != nil:
    section.add "quotaUser", valid_579805
  var valid_579819 = query.getOrDefault("alt")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = newJString("json"))
  if valid_579819 != nil:
    section.add "alt", valid_579819
  var valid_579820 = query.getOrDefault("oauth_token")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "oauth_token", valid_579820
  var valid_579821 = query.getOrDefault("userIp")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "userIp", valid_579821
  var valid_579822 = query.getOrDefault("key")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "key", valid_579822
  var valid_579823 = query.getOrDefault("prettyPrint")
  valid_579823 = validateParameter(valid_579823, JBool, required = false,
                                 default = newJBool(true))
  if valid_579823 != nil:
    section.add "prettyPrint", valid_579823
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579846: Call_ContentAccountsAuthinfo_579690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about the authenticated user.
  ## 
  let valid = call_579846.validator(path, query, header, formData, body)
  let scheme = call_579846.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579846.url(scheme.get, call_579846.host, call_579846.base,
                         call_579846.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579846, url, valid)

proc call*(call_579917: Call_ContentAccountsAuthinfo_579690; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentAccountsAuthinfo
  ## Returns information about the authenticated user.
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
  var query_579918 = newJObject()
  add(query_579918, "fields", newJString(fields))
  add(query_579918, "quotaUser", newJString(quotaUser))
  add(query_579918, "alt", newJString(alt))
  add(query_579918, "oauth_token", newJString(oauthToken))
  add(query_579918, "userIp", newJString(userIp))
  add(query_579918, "key", newJString(key))
  add(query_579918, "prettyPrint", newJBool(prettyPrint))
  result = call_579917.call(nil, query_579918, nil, nil, nil)

var contentAccountsAuthinfo* = Call_ContentAccountsAuthinfo_579690(
    name: "contentAccountsAuthinfo", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/authinfo",
    validator: validate_ContentAccountsAuthinfo_579691, base: "/content/v2.1",
    url: url_ContentAccountsAuthinfo_579692, schemes: {Scheme.Https})
type
  Call_ContentAccountsCustombatch_579958 = ref object of OpenApiRestCall_579421
proc url_ContentAccountsCustombatch_579960(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentAccountsCustombatch_579959(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves, inserts, updates, and deletes multiple Merchant Center (sub-)accounts in a single request.
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
  var valid_579961 = query.getOrDefault("fields")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "fields", valid_579961
  var valid_579962 = query.getOrDefault("quotaUser")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "quotaUser", valid_579962
  var valid_579963 = query.getOrDefault("alt")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = newJString("json"))
  if valid_579963 != nil:
    section.add "alt", valid_579963
  var valid_579964 = query.getOrDefault("oauth_token")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "oauth_token", valid_579964
  var valid_579965 = query.getOrDefault("userIp")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "userIp", valid_579965
  var valid_579966 = query.getOrDefault("key")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "key", valid_579966
  var valid_579967 = query.getOrDefault("prettyPrint")
  valid_579967 = validateParameter(valid_579967, JBool, required = false,
                                 default = newJBool(true))
  if valid_579967 != nil:
    section.add "prettyPrint", valid_579967
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

proc call*(call_579969: Call_ContentAccountsCustombatch_579958; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves, inserts, updates, and deletes multiple Merchant Center (sub-)accounts in a single request.
  ## 
  let valid = call_579969.validator(path, query, header, formData, body)
  let scheme = call_579969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579969.url(scheme.get, call_579969.host, call_579969.base,
                         call_579969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579969, url, valid)

proc call*(call_579970: Call_ContentAccountsCustombatch_579958;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentAccountsCustombatch
  ## Retrieves, inserts, updates, and deletes multiple Merchant Center (sub-)accounts in a single request.
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
  var query_579971 = newJObject()
  var body_579972 = newJObject()
  add(query_579971, "fields", newJString(fields))
  add(query_579971, "quotaUser", newJString(quotaUser))
  add(query_579971, "alt", newJString(alt))
  add(query_579971, "oauth_token", newJString(oauthToken))
  add(query_579971, "userIp", newJString(userIp))
  add(query_579971, "key", newJString(key))
  if body != nil:
    body_579972 = body
  add(query_579971, "prettyPrint", newJBool(prettyPrint))
  result = call_579970.call(nil, query_579971, nil, nil, body_579972)

var contentAccountsCustombatch* = Call_ContentAccountsCustombatch_579958(
    name: "contentAccountsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accounts/batch",
    validator: validate_ContentAccountsCustombatch_579959, base: "/content/v2.1",
    url: url_ContentAccountsCustombatch_579960, schemes: {Scheme.Https})
type
  Call_ContentAccountstatusesCustombatch_579973 = ref object of OpenApiRestCall_579421
proc url_ContentAccountstatusesCustombatch_579975(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentAccountstatusesCustombatch_579974(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves multiple Merchant Center account statuses in a single request.
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
  var valid_579976 = query.getOrDefault("fields")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "fields", valid_579976
  var valid_579977 = query.getOrDefault("quotaUser")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "quotaUser", valid_579977
  var valid_579978 = query.getOrDefault("alt")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = newJString("json"))
  if valid_579978 != nil:
    section.add "alt", valid_579978
  var valid_579979 = query.getOrDefault("oauth_token")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "oauth_token", valid_579979
  var valid_579980 = query.getOrDefault("userIp")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "userIp", valid_579980
  var valid_579981 = query.getOrDefault("key")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "key", valid_579981
  var valid_579982 = query.getOrDefault("prettyPrint")
  valid_579982 = validateParameter(valid_579982, JBool, required = false,
                                 default = newJBool(true))
  if valid_579982 != nil:
    section.add "prettyPrint", valid_579982
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

proc call*(call_579984: Call_ContentAccountstatusesCustombatch_579973;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves multiple Merchant Center account statuses in a single request.
  ## 
  let valid = call_579984.validator(path, query, header, formData, body)
  let scheme = call_579984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579984.url(scheme.get, call_579984.host, call_579984.base,
                         call_579984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579984, url, valid)

proc call*(call_579985: Call_ContentAccountstatusesCustombatch_579973;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentAccountstatusesCustombatch
  ## Retrieves multiple Merchant Center account statuses in a single request.
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
  var query_579986 = newJObject()
  var body_579987 = newJObject()
  add(query_579986, "fields", newJString(fields))
  add(query_579986, "quotaUser", newJString(quotaUser))
  add(query_579986, "alt", newJString(alt))
  add(query_579986, "oauth_token", newJString(oauthToken))
  add(query_579986, "userIp", newJString(userIp))
  add(query_579986, "key", newJString(key))
  if body != nil:
    body_579987 = body
  add(query_579986, "prettyPrint", newJBool(prettyPrint))
  result = call_579985.call(nil, query_579986, nil, nil, body_579987)

var contentAccountstatusesCustombatch* = Call_ContentAccountstatusesCustombatch_579973(
    name: "contentAccountstatusesCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accountstatuses/batch",
    validator: validate_ContentAccountstatusesCustombatch_579974,
    base: "/content/v2.1", url: url_ContentAccountstatusesCustombatch_579975,
    schemes: {Scheme.Https})
type
  Call_ContentAccounttaxCustombatch_579988 = ref object of OpenApiRestCall_579421
proc url_ContentAccounttaxCustombatch_579990(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentAccounttaxCustombatch_579989(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves and updates tax settings of multiple accounts in a single request.
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
  var valid_579991 = query.getOrDefault("fields")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "fields", valid_579991
  var valid_579992 = query.getOrDefault("quotaUser")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "quotaUser", valid_579992
  var valid_579993 = query.getOrDefault("alt")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = newJString("json"))
  if valid_579993 != nil:
    section.add "alt", valid_579993
  var valid_579994 = query.getOrDefault("oauth_token")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "oauth_token", valid_579994
  var valid_579995 = query.getOrDefault("userIp")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "userIp", valid_579995
  var valid_579996 = query.getOrDefault("key")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "key", valid_579996
  var valid_579997 = query.getOrDefault("prettyPrint")
  valid_579997 = validateParameter(valid_579997, JBool, required = false,
                                 default = newJBool(true))
  if valid_579997 != nil:
    section.add "prettyPrint", valid_579997
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

proc call*(call_579999: Call_ContentAccounttaxCustombatch_579988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves and updates tax settings of multiple accounts in a single request.
  ## 
  let valid = call_579999.validator(path, query, header, formData, body)
  let scheme = call_579999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579999.url(scheme.get, call_579999.host, call_579999.base,
                         call_579999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579999, url, valid)

proc call*(call_580000: Call_ContentAccounttaxCustombatch_579988;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentAccounttaxCustombatch
  ## Retrieves and updates tax settings of multiple accounts in a single request.
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
  var query_580001 = newJObject()
  var body_580002 = newJObject()
  add(query_580001, "fields", newJString(fields))
  add(query_580001, "quotaUser", newJString(quotaUser))
  add(query_580001, "alt", newJString(alt))
  add(query_580001, "oauth_token", newJString(oauthToken))
  add(query_580001, "userIp", newJString(userIp))
  add(query_580001, "key", newJString(key))
  if body != nil:
    body_580002 = body
  add(query_580001, "prettyPrint", newJBool(prettyPrint))
  result = call_580000.call(nil, query_580001, nil, nil, body_580002)

var contentAccounttaxCustombatch* = Call_ContentAccounttaxCustombatch_579988(
    name: "contentAccounttaxCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accounttax/batch",
    validator: validate_ContentAccounttaxCustombatch_579989,
    base: "/content/v2.1", url: url_ContentAccounttaxCustombatch_579990,
    schemes: {Scheme.Https})
type
  Call_ContentDatafeedsCustombatch_580003 = ref object of OpenApiRestCall_579421
proc url_ContentDatafeedsCustombatch_580005(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentDatafeedsCustombatch_580004(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes, fetches, gets, inserts and updates multiple datafeeds in a single request.
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
  var valid_580006 = query.getOrDefault("fields")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "fields", valid_580006
  var valid_580007 = query.getOrDefault("quotaUser")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "quotaUser", valid_580007
  var valid_580008 = query.getOrDefault("alt")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = newJString("json"))
  if valid_580008 != nil:
    section.add "alt", valid_580008
  var valid_580009 = query.getOrDefault("oauth_token")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "oauth_token", valid_580009
  var valid_580010 = query.getOrDefault("userIp")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "userIp", valid_580010
  var valid_580011 = query.getOrDefault("key")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "key", valid_580011
  var valid_580012 = query.getOrDefault("prettyPrint")
  valid_580012 = validateParameter(valid_580012, JBool, required = false,
                                 default = newJBool(true))
  if valid_580012 != nil:
    section.add "prettyPrint", valid_580012
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

proc call*(call_580014: Call_ContentDatafeedsCustombatch_580003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes, fetches, gets, inserts and updates multiple datafeeds in a single request.
  ## 
  let valid = call_580014.validator(path, query, header, formData, body)
  let scheme = call_580014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580014.url(scheme.get, call_580014.host, call_580014.base,
                         call_580014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580014, url, valid)

proc call*(call_580015: Call_ContentDatafeedsCustombatch_580003;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentDatafeedsCustombatch
  ## Deletes, fetches, gets, inserts and updates multiple datafeeds in a single request.
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
  var query_580016 = newJObject()
  var body_580017 = newJObject()
  add(query_580016, "fields", newJString(fields))
  add(query_580016, "quotaUser", newJString(quotaUser))
  add(query_580016, "alt", newJString(alt))
  add(query_580016, "oauth_token", newJString(oauthToken))
  add(query_580016, "userIp", newJString(userIp))
  add(query_580016, "key", newJString(key))
  if body != nil:
    body_580017 = body
  add(query_580016, "prettyPrint", newJBool(prettyPrint))
  result = call_580015.call(nil, query_580016, nil, nil, body_580017)

var contentDatafeedsCustombatch* = Call_ContentDatafeedsCustombatch_580003(
    name: "contentDatafeedsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/datafeeds/batch",
    validator: validate_ContentDatafeedsCustombatch_580004, base: "/content/v2.1",
    url: url_ContentDatafeedsCustombatch_580005, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesCustombatch_580018 = ref object of OpenApiRestCall_579421
proc url_ContentDatafeedstatusesCustombatch_580020(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentDatafeedstatusesCustombatch_580019(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets multiple Merchant Center datafeed statuses in a single request.
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
  var valid_580021 = query.getOrDefault("fields")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "fields", valid_580021
  var valid_580022 = query.getOrDefault("quotaUser")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "quotaUser", valid_580022
  var valid_580023 = query.getOrDefault("alt")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = newJString("json"))
  if valid_580023 != nil:
    section.add "alt", valid_580023
  var valid_580024 = query.getOrDefault("oauth_token")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "oauth_token", valid_580024
  var valid_580025 = query.getOrDefault("userIp")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "userIp", valid_580025
  var valid_580026 = query.getOrDefault("key")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "key", valid_580026
  var valid_580027 = query.getOrDefault("prettyPrint")
  valid_580027 = validateParameter(valid_580027, JBool, required = false,
                                 default = newJBool(true))
  if valid_580027 != nil:
    section.add "prettyPrint", valid_580027
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

proc call*(call_580029: Call_ContentDatafeedstatusesCustombatch_580018;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets multiple Merchant Center datafeed statuses in a single request.
  ## 
  let valid = call_580029.validator(path, query, header, formData, body)
  let scheme = call_580029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580029.url(scheme.get, call_580029.host, call_580029.base,
                         call_580029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580029, url, valid)

proc call*(call_580030: Call_ContentDatafeedstatusesCustombatch_580018;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentDatafeedstatusesCustombatch
  ## Gets multiple Merchant Center datafeed statuses in a single request.
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
  var query_580031 = newJObject()
  var body_580032 = newJObject()
  add(query_580031, "fields", newJString(fields))
  add(query_580031, "quotaUser", newJString(quotaUser))
  add(query_580031, "alt", newJString(alt))
  add(query_580031, "oauth_token", newJString(oauthToken))
  add(query_580031, "userIp", newJString(userIp))
  add(query_580031, "key", newJString(key))
  if body != nil:
    body_580032 = body
  add(query_580031, "prettyPrint", newJBool(prettyPrint))
  result = call_580030.call(nil, query_580031, nil, nil, body_580032)

var contentDatafeedstatusesCustombatch* = Call_ContentDatafeedstatusesCustombatch_580018(
    name: "contentDatafeedstatusesCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/datafeedstatuses/batch",
    validator: validate_ContentDatafeedstatusesCustombatch_580019,
    base: "/content/v2.1", url: url_ContentDatafeedstatusesCustombatch_580020,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsCustombatch_580033 = ref object of OpenApiRestCall_579421
proc url_ContentLiasettingsCustombatch_580035(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentLiasettingsCustombatch_580034(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves and/or updates the LIA settings of multiple accounts in a single request.
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
  var valid_580036 = query.getOrDefault("fields")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "fields", valid_580036
  var valid_580037 = query.getOrDefault("quotaUser")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "quotaUser", valid_580037
  var valid_580038 = query.getOrDefault("alt")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = newJString("json"))
  if valid_580038 != nil:
    section.add "alt", valid_580038
  var valid_580039 = query.getOrDefault("oauth_token")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "oauth_token", valid_580039
  var valid_580040 = query.getOrDefault("userIp")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "userIp", valid_580040
  var valid_580041 = query.getOrDefault("key")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "key", valid_580041
  var valid_580042 = query.getOrDefault("prettyPrint")
  valid_580042 = validateParameter(valid_580042, JBool, required = false,
                                 default = newJBool(true))
  if valid_580042 != nil:
    section.add "prettyPrint", valid_580042
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

proc call*(call_580044: Call_ContentLiasettingsCustombatch_580033; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves and/or updates the LIA settings of multiple accounts in a single request.
  ## 
  let valid = call_580044.validator(path, query, header, formData, body)
  let scheme = call_580044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580044.url(scheme.get, call_580044.host, call_580044.base,
                         call_580044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580044, url, valid)

proc call*(call_580045: Call_ContentLiasettingsCustombatch_580033;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentLiasettingsCustombatch
  ## Retrieves and/or updates the LIA settings of multiple accounts in a single request.
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
  var query_580046 = newJObject()
  var body_580047 = newJObject()
  add(query_580046, "fields", newJString(fields))
  add(query_580046, "quotaUser", newJString(quotaUser))
  add(query_580046, "alt", newJString(alt))
  add(query_580046, "oauth_token", newJString(oauthToken))
  add(query_580046, "userIp", newJString(userIp))
  add(query_580046, "key", newJString(key))
  if body != nil:
    body_580047 = body
  add(query_580046, "prettyPrint", newJBool(prettyPrint))
  result = call_580045.call(nil, query_580046, nil, nil, body_580047)

var contentLiasettingsCustombatch* = Call_ContentLiasettingsCustombatch_580033(
    name: "contentLiasettingsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liasettings/batch",
    validator: validate_ContentLiasettingsCustombatch_580034,
    base: "/content/v2.1", url: url_ContentLiasettingsCustombatch_580035,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsListposdataproviders_580048 = ref object of OpenApiRestCall_579421
proc url_ContentLiasettingsListposdataproviders_580050(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentLiasettingsListposdataproviders_580049(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of POS data providers that have active settings for the all eiligible countries.
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
  var valid_580051 = query.getOrDefault("fields")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "fields", valid_580051
  var valid_580052 = query.getOrDefault("quotaUser")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "quotaUser", valid_580052
  var valid_580053 = query.getOrDefault("alt")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = newJString("json"))
  if valid_580053 != nil:
    section.add "alt", valid_580053
  var valid_580054 = query.getOrDefault("oauth_token")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "oauth_token", valid_580054
  var valid_580055 = query.getOrDefault("userIp")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "userIp", valid_580055
  var valid_580056 = query.getOrDefault("key")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "key", valid_580056
  var valid_580057 = query.getOrDefault("prettyPrint")
  valid_580057 = validateParameter(valid_580057, JBool, required = false,
                                 default = newJBool(true))
  if valid_580057 != nil:
    section.add "prettyPrint", valid_580057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580058: Call_ContentLiasettingsListposdataproviders_580048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of POS data providers that have active settings for the all eiligible countries.
  ## 
  let valid = call_580058.validator(path, query, header, formData, body)
  let scheme = call_580058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580058.url(scheme.get, call_580058.host, call_580058.base,
                         call_580058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580058, url, valid)

proc call*(call_580059: Call_ContentLiasettingsListposdataproviders_580048;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## contentLiasettingsListposdataproviders
  ## Retrieves the list of POS data providers that have active settings for the all eiligible countries.
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
  var query_580060 = newJObject()
  add(query_580060, "fields", newJString(fields))
  add(query_580060, "quotaUser", newJString(quotaUser))
  add(query_580060, "alt", newJString(alt))
  add(query_580060, "oauth_token", newJString(oauthToken))
  add(query_580060, "userIp", newJString(userIp))
  add(query_580060, "key", newJString(key))
  add(query_580060, "prettyPrint", newJBool(prettyPrint))
  result = call_580059.call(nil, query_580060, nil, nil, nil)

var contentLiasettingsListposdataproviders* = Call_ContentLiasettingsListposdataproviders_580048(
    name: "contentLiasettingsListposdataproviders", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/liasettings/posdataproviders",
    validator: validate_ContentLiasettingsListposdataproviders_580049,
    base: "/content/v2.1", url: url_ContentLiasettingsListposdataproviders_580050,
    schemes: {Scheme.Https})
type
  Call_ContentPosCustombatch_580061 = ref object of OpenApiRestCall_579421
proc url_ContentPosCustombatch_580063(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentPosCustombatch_580062(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Batches multiple POS-related calls in a single request.
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
  var valid_580064 = query.getOrDefault("fields")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "fields", valid_580064
  var valid_580065 = query.getOrDefault("quotaUser")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "quotaUser", valid_580065
  var valid_580066 = query.getOrDefault("alt")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = newJString("json"))
  if valid_580066 != nil:
    section.add "alt", valid_580066
  var valid_580067 = query.getOrDefault("oauth_token")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "oauth_token", valid_580067
  var valid_580068 = query.getOrDefault("userIp")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "userIp", valid_580068
  var valid_580069 = query.getOrDefault("key")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "key", valid_580069
  var valid_580070 = query.getOrDefault("prettyPrint")
  valid_580070 = validateParameter(valid_580070, JBool, required = false,
                                 default = newJBool(true))
  if valid_580070 != nil:
    section.add "prettyPrint", valid_580070
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

proc call*(call_580072: Call_ContentPosCustombatch_580061; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Batches multiple POS-related calls in a single request.
  ## 
  let valid = call_580072.validator(path, query, header, formData, body)
  let scheme = call_580072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580072.url(scheme.get, call_580072.host, call_580072.base,
                         call_580072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580072, url, valid)

proc call*(call_580073: Call_ContentPosCustombatch_580061; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## contentPosCustombatch
  ## Batches multiple POS-related calls in a single request.
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
  var query_580074 = newJObject()
  var body_580075 = newJObject()
  add(query_580074, "fields", newJString(fields))
  add(query_580074, "quotaUser", newJString(quotaUser))
  add(query_580074, "alt", newJString(alt))
  add(query_580074, "oauth_token", newJString(oauthToken))
  add(query_580074, "userIp", newJString(userIp))
  add(query_580074, "key", newJString(key))
  if body != nil:
    body_580075 = body
  add(query_580074, "prettyPrint", newJBool(prettyPrint))
  result = call_580073.call(nil, query_580074, nil, nil, body_580075)

var contentPosCustombatch* = Call_ContentPosCustombatch_580061(
    name: "contentPosCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/pos/batch",
    validator: validate_ContentPosCustombatch_580062, base: "/content/v2.1",
    url: url_ContentPosCustombatch_580063, schemes: {Scheme.Https})
type
  Call_ContentProductsCustombatch_580076 = ref object of OpenApiRestCall_579421
proc url_ContentProductsCustombatch_580078(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentProductsCustombatch_580077(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves, inserts, and deletes multiple products in a single request.
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
  var valid_580079 = query.getOrDefault("fields")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "fields", valid_580079
  var valid_580080 = query.getOrDefault("quotaUser")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "quotaUser", valid_580080
  var valid_580081 = query.getOrDefault("alt")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = newJString("json"))
  if valid_580081 != nil:
    section.add "alt", valid_580081
  var valid_580082 = query.getOrDefault("oauth_token")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "oauth_token", valid_580082
  var valid_580083 = query.getOrDefault("userIp")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "userIp", valid_580083
  var valid_580084 = query.getOrDefault("key")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "key", valid_580084
  var valid_580085 = query.getOrDefault("prettyPrint")
  valid_580085 = validateParameter(valid_580085, JBool, required = false,
                                 default = newJBool(true))
  if valid_580085 != nil:
    section.add "prettyPrint", valid_580085
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

proc call*(call_580087: Call_ContentProductsCustombatch_580076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves, inserts, and deletes multiple products in a single request.
  ## 
  let valid = call_580087.validator(path, query, header, formData, body)
  let scheme = call_580087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580087.url(scheme.get, call_580087.host, call_580087.base,
                         call_580087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580087, url, valid)

proc call*(call_580088: Call_ContentProductsCustombatch_580076;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentProductsCustombatch
  ## Retrieves, inserts, and deletes multiple products in a single request.
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
  var query_580089 = newJObject()
  var body_580090 = newJObject()
  add(query_580089, "fields", newJString(fields))
  add(query_580089, "quotaUser", newJString(quotaUser))
  add(query_580089, "alt", newJString(alt))
  add(query_580089, "oauth_token", newJString(oauthToken))
  add(query_580089, "userIp", newJString(userIp))
  add(query_580089, "key", newJString(key))
  if body != nil:
    body_580090 = body
  add(query_580089, "prettyPrint", newJBool(prettyPrint))
  result = call_580088.call(nil, query_580089, nil, nil, body_580090)

var contentProductsCustombatch* = Call_ContentProductsCustombatch_580076(
    name: "contentProductsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/products/batch",
    validator: validate_ContentProductsCustombatch_580077, base: "/content/v2.1",
    url: url_ContentProductsCustombatch_580078, schemes: {Scheme.Https})
type
  Call_ContentProductstatusesCustombatch_580091 = ref object of OpenApiRestCall_579421
proc url_ContentProductstatusesCustombatch_580093(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentProductstatusesCustombatch_580092(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the statuses of multiple products in a single request.
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
  var valid_580094 = query.getOrDefault("fields")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "fields", valid_580094
  var valid_580095 = query.getOrDefault("quotaUser")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "quotaUser", valid_580095
  var valid_580096 = query.getOrDefault("alt")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = newJString("json"))
  if valid_580096 != nil:
    section.add "alt", valid_580096
  var valid_580097 = query.getOrDefault("oauth_token")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "oauth_token", valid_580097
  var valid_580098 = query.getOrDefault("userIp")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "userIp", valid_580098
  var valid_580099 = query.getOrDefault("key")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "key", valid_580099
  var valid_580100 = query.getOrDefault("prettyPrint")
  valid_580100 = validateParameter(valid_580100, JBool, required = false,
                                 default = newJBool(true))
  if valid_580100 != nil:
    section.add "prettyPrint", valid_580100
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

proc call*(call_580102: Call_ContentProductstatusesCustombatch_580091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the statuses of multiple products in a single request.
  ## 
  let valid = call_580102.validator(path, query, header, formData, body)
  let scheme = call_580102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580102.url(scheme.get, call_580102.host, call_580102.base,
                         call_580102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580102, url, valid)

proc call*(call_580103: Call_ContentProductstatusesCustombatch_580091;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentProductstatusesCustombatch
  ## Gets the statuses of multiple products in a single request.
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
  var query_580104 = newJObject()
  var body_580105 = newJObject()
  add(query_580104, "fields", newJString(fields))
  add(query_580104, "quotaUser", newJString(quotaUser))
  add(query_580104, "alt", newJString(alt))
  add(query_580104, "oauth_token", newJString(oauthToken))
  add(query_580104, "userIp", newJString(userIp))
  add(query_580104, "key", newJString(key))
  if body != nil:
    body_580105 = body
  add(query_580104, "prettyPrint", newJBool(prettyPrint))
  result = call_580103.call(nil, query_580104, nil, nil, body_580105)

var contentProductstatusesCustombatch* = Call_ContentProductstatusesCustombatch_580091(
    name: "contentProductstatusesCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/productstatuses/batch",
    validator: validate_ContentProductstatusesCustombatch_580092,
    base: "/content/v2.1", url: url_ContentProductstatusesCustombatch_580093,
    schemes: {Scheme.Https})
type
  Call_ContentRegionalinventoryCustombatch_580106 = ref object of OpenApiRestCall_579421
proc url_ContentRegionalinventoryCustombatch_580108(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentRegionalinventoryCustombatch_580107(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates regional inventory for multiple products or regions in a single request.
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
  var valid_580109 = query.getOrDefault("fields")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "fields", valid_580109
  var valid_580110 = query.getOrDefault("quotaUser")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "quotaUser", valid_580110
  var valid_580111 = query.getOrDefault("alt")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = newJString("json"))
  if valid_580111 != nil:
    section.add "alt", valid_580111
  var valid_580112 = query.getOrDefault("oauth_token")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "oauth_token", valid_580112
  var valid_580113 = query.getOrDefault("userIp")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "userIp", valid_580113
  var valid_580114 = query.getOrDefault("key")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "key", valid_580114
  var valid_580115 = query.getOrDefault("prettyPrint")
  valid_580115 = validateParameter(valid_580115, JBool, required = false,
                                 default = newJBool(true))
  if valid_580115 != nil:
    section.add "prettyPrint", valid_580115
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

proc call*(call_580117: Call_ContentRegionalinventoryCustombatch_580106;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates regional inventory for multiple products or regions in a single request.
  ## 
  let valid = call_580117.validator(path, query, header, formData, body)
  let scheme = call_580117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580117.url(scheme.get, call_580117.host, call_580117.base,
                         call_580117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580117, url, valid)

proc call*(call_580118: Call_ContentRegionalinventoryCustombatch_580106;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentRegionalinventoryCustombatch
  ## Updates regional inventory for multiple products or regions in a single request.
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
  var query_580119 = newJObject()
  var body_580120 = newJObject()
  add(query_580119, "fields", newJString(fields))
  add(query_580119, "quotaUser", newJString(quotaUser))
  add(query_580119, "alt", newJString(alt))
  add(query_580119, "oauth_token", newJString(oauthToken))
  add(query_580119, "userIp", newJString(userIp))
  add(query_580119, "key", newJString(key))
  if body != nil:
    body_580120 = body
  add(query_580119, "prettyPrint", newJBool(prettyPrint))
  result = call_580118.call(nil, query_580119, nil, nil, body_580120)

var contentRegionalinventoryCustombatch* = Call_ContentRegionalinventoryCustombatch_580106(
    name: "contentRegionalinventoryCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/regionalinventory/batch",
    validator: validate_ContentRegionalinventoryCustombatch_580107,
    base: "/content/v2.1", url: url_ContentRegionalinventoryCustombatch_580108,
    schemes: {Scheme.Https})
type
  Call_ContentReturnaddressCustombatch_580121 = ref object of OpenApiRestCall_579421
proc url_ContentReturnaddressCustombatch_580123(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentReturnaddressCustombatch_580122(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Batches multiple return address related calls in a single request.
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
  var valid_580124 = query.getOrDefault("fields")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "fields", valid_580124
  var valid_580125 = query.getOrDefault("quotaUser")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "quotaUser", valid_580125
  var valid_580126 = query.getOrDefault("alt")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = newJString("json"))
  if valid_580126 != nil:
    section.add "alt", valid_580126
  var valid_580127 = query.getOrDefault("oauth_token")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "oauth_token", valid_580127
  var valid_580128 = query.getOrDefault("userIp")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "userIp", valid_580128
  var valid_580129 = query.getOrDefault("key")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "key", valid_580129
  var valid_580130 = query.getOrDefault("prettyPrint")
  valid_580130 = validateParameter(valid_580130, JBool, required = false,
                                 default = newJBool(true))
  if valid_580130 != nil:
    section.add "prettyPrint", valid_580130
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

proc call*(call_580132: Call_ContentReturnaddressCustombatch_580121;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Batches multiple return address related calls in a single request.
  ## 
  let valid = call_580132.validator(path, query, header, formData, body)
  let scheme = call_580132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580132.url(scheme.get, call_580132.host, call_580132.base,
                         call_580132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580132, url, valid)

proc call*(call_580133: Call_ContentReturnaddressCustombatch_580121;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentReturnaddressCustombatch
  ## Batches multiple return address related calls in a single request.
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
  var query_580134 = newJObject()
  var body_580135 = newJObject()
  add(query_580134, "fields", newJString(fields))
  add(query_580134, "quotaUser", newJString(quotaUser))
  add(query_580134, "alt", newJString(alt))
  add(query_580134, "oauth_token", newJString(oauthToken))
  add(query_580134, "userIp", newJString(userIp))
  add(query_580134, "key", newJString(key))
  if body != nil:
    body_580135 = body
  add(query_580134, "prettyPrint", newJBool(prettyPrint))
  result = call_580133.call(nil, query_580134, nil, nil, body_580135)

var contentReturnaddressCustombatch* = Call_ContentReturnaddressCustombatch_580121(
    name: "contentReturnaddressCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/returnaddress/batch",
    validator: validate_ContentReturnaddressCustombatch_580122,
    base: "/content/v2.1", url: url_ContentReturnaddressCustombatch_580123,
    schemes: {Scheme.Https})
type
  Call_ContentReturnpolicyCustombatch_580136 = ref object of OpenApiRestCall_579421
proc url_ContentReturnpolicyCustombatch_580138(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentReturnpolicyCustombatch_580137(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Batches multiple return policy related calls in a single request.
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
  var valid_580139 = query.getOrDefault("fields")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "fields", valid_580139
  var valid_580140 = query.getOrDefault("quotaUser")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "quotaUser", valid_580140
  var valid_580141 = query.getOrDefault("alt")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = newJString("json"))
  if valid_580141 != nil:
    section.add "alt", valid_580141
  var valid_580142 = query.getOrDefault("oauth_token")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "oauth_token", valid_580142
  var valid_580143 = query.getOrDefault("userIp")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "userIp", valid_580143
  var valid_580144 = query.getOrDefault("key")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "key", valid_580144
  var valid_580145 = query.getOrDefault("prettyPrint")
  valid_580145 = validateParameter(valid_580145, JBool, required = false,
                                 default = newJBool(true))
  if valid_580145 != nil:
    section.add "prettyPrint", valid_580145
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

proc call*(call_580147: Call_ContentReturnpolicyCustombatch_580136; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Batches multiple return policy related calls in a single request.
  ## 
  let valid = call_580147.validator(path, query, header, formData, body)
  let scheme = call_580147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580147.url(scheme.get, call_580147.host, call_580147.base,
                         call_580147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580147, url, valid)

proc call*(call_580148: Call_ContentReturnpolicyCustombatch_580136;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentReturnpolicyCustombatch
  ## Batches multiple return policy related calls in a single request.
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
  var query_580149 = newJObject()
  var body_580150 = newJObject()
  add(query_580149, "fields", newJString(fields))
  add(query_580149, "quotaUser", newJString(quotaUser))
  add(query_580149, "alt", newJString(alt))
  add(query_580149, "oauth_token", newJString(oauthToken))
  add(query_580149, "userIp", newJString(userIp))
  add(query_580149, "key", newJString(key))
  if body != nil:
    body_580150 = body
  add(query_580149, "prettyPrint", newJBool(prettyPrint))
  result = call_580148.call(nil, query_580149, nil, nil, body_580150)

var contentReturnpolicyCustombatch* = Call_ContentReturnpolicyCustombatch_580136(
    name: "contentReturnpolicyCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/returnpolicy/batch",
    validator: validate_ContentReturnpolicyCustombatch_580137,
    base: "/content/v2.1", url: url_ContentReturnpolicyCustombatch_580138,
    schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsCustombatch_580151 = ref object of OpenApiRestCall_579421
proc url_ContentShippingsettingsCustombatch_580153(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentShippingsettingsCustombatch_580152(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves and updates the shipping settings of multiple accounts in a single request.
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
  var valid_580154 = query.getOrDefault("fields")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "fields", valid_580154
  var valid_580155 = query.getOrDefault("quotaUser")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "quotaUser", valid_580155
  var valid_580156 = query.getOrDefault("alt")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = newJString("json"))
  if valid_580156 != nil:
    section.add "alt", valid_580156
  var valid_580157 = query.getOrDefault("oauth_token")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "oauth_token", valid_580157
  var valid_580158 = query.getOrDefault("userIp")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "userIp", valid_580158
  var valid_580159 = query.getOrDefault("key")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "key", valid_580159
  var valid_580160 = query.getOrDefault("prettyPrint")
  valid_580160 = validateParameter(valid_580160, JBool, required = false,
                                 default = newJBool(true))
  if valid_580160 != nil:
    section.add "prettyPrint", valid_580160
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

proc call*(call_580162: Call_ContentShippingsettingsCustombatch_580151;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves and updates the shipping settings of multiple accounts in a single request.
  ## 
  let valid = call_580162.validator(path, query, header, formData, body)
  let scheme = call_580162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580162.url(scheme.get, call_580162.host, call_580162.base,
                         call_580162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580162, url, valid)

proc call*(call_580163: Call_ContentShippingsettingsCustombatch_580151;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentShippingsettingsCustombatch
  ## Retrieves and updates the shipping settings of multiple accounts in a single request.
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
  var query_580164 = newJObject()
  var body_580165 = newJObject()
  add(query_580164, "fields", newJString(fields))
  add(query_580164, "quotaUser", newJString(quotaUser))
  add(query_580164, "alt", newJString(alt))
  add(query_580164, "oauth_token", newJString(oauthToken))
  add(query_580164, "userIp", newJString(userIp))
  add(query_580164, "key", newJString(key))
  if body != nil:
    body_580165 = body
  add(query_580164, "prettyPrint", newJBool(prettyPrint))
  result = call_580163.call(nil, query_580164, nil, nil, body_580165)

var contentShippingsettingsCustombatch* = Call_ContentShippingsettingsCustombatch_580151(
    name: "contentShippingsettingsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/shippingsettings/batch",
    validator: validate_ContentShippingsettingsCustombatch_580152,
    base: "/content/v2.1", url: url_ContentShippingsettingsCustombatch_580153,
    schemes: {Scheme.Https})
type
  Call_ContentAccountsInsert_580197 = ref object of OpenApiRestCall_579421
proc url_ContentAccountsInsert_580199(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/accounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentAccountsInsert_580198(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a Merchant Center sub-account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. This must be a multi-client account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580200 = path.getOrDefault("merchantId")
  valid_580200 = validateParameter(valid_580200, JString, required = true,
                                 default = nil)
  if valid_580200 != nil:
    section.add "merchantId", valid_580200
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
  var valid_580201 = query.getOrDefault("fields")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "fields", valid_580201
  var valid_580202 = query.getOrDefault("quotaUser")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "quotaUser", valid_580202
  var valid_580203 = query.getOrDefault("alt")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = newJString("json"))
  if valid_580203 != nil:
    section.add "alt", valid_580203
  var valid_580204 = query.getOrDefault("oauth_token")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "oauth_token", valid_580204
  var valid_580205 = query.getOrDefault("userIp")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "userIp", valid_580205
  var valid_580206 = query.getOrDefault("key")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "key", valid_580206
  var valid_580207 = query.getOrDefault("prettyPrint")
  valid_580207 = validateParameter(valid_580207, JBool, required = false,
                                 default = newJBool(true))
  if valid_580207 != nil:
    section.add "prettyPrint", valid_580207
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

proc call*(call_580209: Call_ContentAccountsInsert_580197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Merchant Center sub-account.
  ## 
  let valid = call_580209.validator(path, query, header, formData, body)
  let scheme = call_580209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580209.url(scheme.get, call_580209.host, call_580209.base,
                         call_580209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580209, url, valid)

proc call*(call_580210: Call_ContentAccountsInsert_580197; merchantId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentAccountsInsert
  ## Creates a Merchant Center sub-account.
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
  ##   merchantId: string (required)
  ##             : The ID of the managing account. This must be a multi-client account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580211 = newJObject()
  var query_580212 = newJObject()
  var body_580213 = newJObject()
  add(query_580212, "fields", newJString(fields))
  add(query_580212, "quotaUser", newJString(quotaUser))
  add(query_580212, "alt", newJString(alt))
  add(query_580212, "oauth_token", newJString(oauthToken))
  add(query_580212, "userIp", newJString(userIp))
  add(query_580212, "key", newJString(key))
  add(path_580211, "merchantId", newJString(merchantId))
  if body != nil:
    body_580213 = body
  add(query_580212, "prettyPrint", newJBool(prettyPrint))
  result = call_580210.call(path_580211, query_580212, nil, nil, body_580213)

var contentAccountsInsert* = Call_ContentAccountsInsert_580197(
    name: "contentAccountsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/accounts",
    validator: validate_ContentAccountsInsert_580198, base: "/content/v2.1",
    url: url_ContentAccountsInsert_580199, schemes: {Scheme.Https})
type
  Call_ContentAccountsList_580166 = ref object of OpenApiRestCall_579421
proc url_ContentAccountsList_580168(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/accounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentAccountsList_580167(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists the sub-accounts in your Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. This must be a multi-client account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580183 = path.getOrDefault("merchantId")
  valid_580183 = validateParameter(valid_580183, JString, required = true,
                                 default = nil)
  if valid_580183 != nil:
    section.add "merchantId", valid_580183
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of accounts to return in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580184 = query.getOrDefault("fields")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "fields", valid_580184
  var valid_580185 = query.getOrDefault("pageToken")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "pageToken", valid_580185
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
  var valid_580190 = query.getOrDefault("maxResults")
  valid_580190 = validateParameter(valid_580190, JInt, required = false, default = nil)
  if valid_580190 != nil:
    section.add "maxResults", valid_580190
  var valid_580191 = query.getOrDefault("key")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "key", valid_580191
  var valid_580192 = query.getOrDefault("prettyPrint")
  valid_580192 = validateParameter(valid_580192, JBool, required = false,
                                 default = newJBool(true))
  if valid_580192 != nil:
    section.add "prettyPrint", valid_580192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580193: Call_ContentAccountsList_580166; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_580193.validator(path, query, header, formData, body)
  let scheme = call_580193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580193.url(scheme.get, call_580193.host, call_580193.base,
                         call_580193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580193, url, valid)

proc call*(call_580194: Call_ContentAccountsList_580166; merchantId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentAccountsList
  ## Lists the sub-accounts in your Merchant Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of accounts to return in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. This must be a multi-client account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580195 = newJObject()
  var query_580196 = newJObject()
  add(query_580196, "fields", newJString(fields))
  add(query_580196, "pageToken", newJString(pageToken))
  add(query_580196, "quotaUser", newJString(quotaUser))
  add(query_580196, "alt", newJString(alt))
  add(query_580196, "oauth_token", newJString(oauthToken))
  add(query_580196, "userIp", newJString(userIp))
  add(query_580196, "maxResults", newJInt(maxResults))
  add(query_580196, "key", newJString(key))
  add(path_580195, "merchantId", newJString(merchantId))
  add(query_580196, "prettyPrint", newJBool(prettyPrint))
  result = call_580194.call(path_580195, query_580196, nil, nil, nil)

var contentAccountsList* = Call_ContentAccountsList_580166(
    name: "contentAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounts",
    validator: validate_ContentAccountsList_580167, base: "/content/v2.1",
    url: url_ContentAccountsList_580168, schemes: {Scheme.Https})
type
  Call_ContentAccountsUpdate_580230 = ref object of OpenApiRestCall_579421
proc url_ContentAccountsUpdate_580232(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentAccountsUpdate_580231(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The ID of the account.
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580233 = path.getOrDefault("accountId")
  valid_580233 = validateParameter(valid_580233, JString, required = true,
                                 default = nil)
  if valid_580233 != nil:
    section.add "accountId", valid_580233
  var valid_580234 = path.getOrDefault("merchantId")
  valid_580234 = validateParameter(valid_580234, JString, required = true,
                                 default = nil)
  if valid_580234 != nil:
    section.add "merchantId", valid_580234
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
  var valid_580235 = query.getOrDefault("fields")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "fields", valid_580235
  var valid_580236 = query.getOrDefault("quotaUser")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "quotaUser", valid_580236
  var valid_580237 = query.getOrDefault("alt")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = newJString("json"))
  if valid_580237 != nil:
    section.add "alt", valid_580237
  var valid_580238 = query.getOrDefault("oauth_token")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "oauth_token", valid_580238
  var valid_580239 = query.getOrDefault("userIp")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "userIp", valid_580239
  var valid_580240 = query.getOrDefault("key")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "key", valid_580240
  var valid_580241 = query.getOrDefault("prettyPrint")
  valid_580241 = validateParameter(valid_580241, JBool, required = false,
                                 default = newJBool(true))
  if valid_580241 != nil:
    section.add "prettyPrint", valid_580241
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

proc call*(call_580243: Call_ContentAccountsUpdate_580230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Merchant Center account.
  ## 
  let valid = call_580243.validator(path, query, header, formData, body)
  let scheme = call_580243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580243.url(scheme.get, call_580243.host, call_580243.base,
                         call_580243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580243, url, valid)

proc call*(call_580244: Call_ContentAccountsUpdate_580230; accountId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentAccountsUpdate
  ## Updates a Merchant Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The ID of the account.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580245 = newJObject()
  var query_580246 = newJObject()
  var body_580247 = newJObject()
  add(query_580246, "fields", newJString(fields))
  add(query_580246, "quotaUser", newJString(quotaUser))
  add(query_580246, "alt", newJString(alt))
  add(query_580246, "oauth_token", newJString(oauthToken))
  add(path_580245, "accountId", newJString(accountId))
  add(query_580246, "userIp", newJString(userIp))
  add(query_580246, "key", newJString(key))
  add(path_580245, "merchantId", newJString(merchantId))
  if body != nil:
    body_580247 = body
  add(query_580246, "prettyPrint", newJBool(prettyPrint))
  result = call_580244.call(path_580245, query_580246, nil, nil, body_580247)

var contentAccountsUpdate* = Call_ContentAccountsUpdate_580230(
    name: "contentAccountsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsUpdate_580231, base: "/content/v2.1",
    url: url_ContentAccountsUpdate_580232, schemes: {Scheme.Https})
type
  Call_ContentAccountsGet_580214 = ref object of OpenApiRestCall_579421
proc url_ContentAccountsGet_580216(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentAccountsGet_580215(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves a Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The ID of the account.
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580217 = path.getOrDefault("accountId")
  valid_580217 = validateParameter(valid_580217, JString, required = true,
                                 default = nil)
  if valid_580217 != nil:
    section.add "accountId", valid_580217
  var valid_580218 = path.getOrDefault("merchantId")
  valid_580218 = validateParameter(valid_580218, JString, required = true,
                                 default = nil)
  if valid_580218 != nil:
    section.add "merchantId", valid_580218
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
  var valid_580219 = query.getOrDefault("fields")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "fields", valid_580219
  var valid_580220 = query.getOrDefault("quotaUser")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "quotaUser", valid_580220
  var valid_580221 = query.getOrDefault("alt")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = newJString("json"))
  if valid_580221 != nil:
    section.add "alt", valid_580221
  var valid_580222 = query.getOrDefault("oauth_token")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "oauth_token", valid_580222
  var valid_580223 = query.getOrDefault("userIp")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "userIp", valid_580223
  var valid_580224 = query.getOrDefault("key")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "key", valid_580224
  var valid_580225 = query.getOrDefault("prettyPrint")
  valid_580225 = validateParameter(valid_580225, JBool, required = false,
                                 default = newJBool(true))
  if valid_580225 != nil:
    section.add "prettyPrint", valid_580225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580226: Call_ContentAccountsGet_580214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a Merchant Center account.
  ## 
  let valid = call_580226.validator(path, query, header, formData, body)
  let scheme = call_580226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580226.url(scheme.get, call_580226.host, call_580226.base,
                         call_580226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580226, url, valid)

proc call*(call_580227: Call_ContentAccountsGet_580214; accountId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentAccountsGet
  ## Retrieves a Merchant Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The ID of the account.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580228 = newJObject()
  var query_580229 = newJObject()
  add(query_580229, "fields", newJString(fields))
  add(query_580229, "quotaUser", newJString(quotaUser))
  add(query_580229, "alt", newJString(alt))
  add(query_580229, "oauth_token", newJString(oauthToken))
  add(path_580228, "accountId", newJString(accountId))
  add(query_580229, "userIp", newJString(userIp))
  add(query_580229, "key", newJString(key))
  add(path_580228, "merchantId", newJString(merchantId))
  add(query_580229, "prettyPrint", newJBool(prettyPrint))
  result = call_580227.call(path_580228, query_580229, nil, nil, nil)

var contentAccountsGet* = Call_ContentAccountsGet_580214(
    name: "contentAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsGet_580215, base: "/content/v2.1",
    url: url_ContentAccountsGet_580216, schemes: {Scheme.Https})
type
  Call_ContentAccountsDelete_580248 = ref object of OpenApiRestCall_579421
proc url_ContentAccountsDelete_580250(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentAccountsDelete_580249(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a Merchant Center sub-account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The ID of the account.
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. This must be a multi-client account, and accountId must be the ID of a sub-account of this account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580251 = path.getOrDefault("accountId")
  valid_580251 = validateParameter(valid_580251, JString, required = true,
                                 default = nil)
  if valid_580251 != nil:
    section.add "accountId", valid_580251
  var valid_580252 = path.getOrDefault("merchantId")
  valid_580252 = validateParameter(valid_580252, JString, required = true,
                                 default = nil)
  if valid_580252 != nil:
    section.add "merchantId", valid_580252
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   force: JBool
  ##        : Flag to delete sub-accounts with products. The default value is false.
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
  var valid_580253 = query.getOrDefault("fields")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "fields", valid_580253
  var valid_580254 = query.getOrDefault("force")
  valid_580254 = validateParameter(valid_580254, JBool, required = false,
                                 default = newJBool(false))
  if valid_580254 != nil:
    section.add "force", valid_580254
  var valid_580255 = query.getOrDefault("quotaUser")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "quotaUser", valid_580255
  var valid_580256 = query.getOrDefault("alt")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = newJString("json"))
  if valid_580256 != nil:
    section.add "alt", valid_580256
  var valid_580257 = query.getOrDefault("oauth_token")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "oauth_token", valid_580257
  var valid_580258 = query.getOrDefault("userIp")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "userIp", valid_580258
  var valid_580259 = query.getOrDefault("key")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "key", valid_580259
  var valid_580260 = query.getOrDefault("prettyPrint")
  valid_580260 = validateParameter(valid_580260, JBool, required = false,
                                 default = newJBool(true))
  if valid_580260 != nil:
    section.add "prettyPrint", valid_580260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580261: Call_ContentAccountsDelete_580248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Merchant Center sub-account.
  ## 
  let valid = call_580261.validator(path, query, header, formData, body)
  let scheme = call_580261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580261.url(scheme.get, call_580261.host, call_580261.base,
                         call_580261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580261, url, valid)

proc call*(call_580262: Call_ContentAccountsDelete_580248; accountId: string;
          merchantId: string; fields: string = ""; force: bool = false;
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentAccountsDelete
  ## Deletes a Merchant Center sub-account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   force: bool
  ##        : Flag to delete sub-accounts with products. The default value is false.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The ID of the account.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. This must be a multi-client account, and accountId must be the ID of a sub-account of this account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580263 = newJObject()
  var query_580264 = newJObject()
  add(query_580264, "fields", newJString(fields))
  add(query_580264, "force", newJBool(force))
  add(query_580264, "quotaUser", newJString(quotaUser))
  add(query_580264, "alt", newJString(alt))
  add(query_580264, "oauth_token", newJString(oauthToken))
  add(path_580263, "accountId", newJString(accountId))
  add(query_580264, "userIp", newJString(userIp))
  add(query_580264, "key", newJString(key))
  add(path_580263, "merchantId", newJString(merchantId))
  add(query_580264, "prettyPrint", newJBool(prettyPrint))
  result = call_580262.call(path_580263, query_580264, nil, nil, nil)

var contentAccountsDelete* = Call_ContentAccountsDelete_580248(
    name: "contentAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsDelete_580249, base: "/content/v2.1",
    url: url_ContentAccountsDelete_580250, schemes: {Scheme.Https})
type
  Call_ContentAccountsClaimwebsite_580265 = ref object of OpenApiRestCall_579421
proc url_ContentAccountsClaimwebsite_580267(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/claimwebsite")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentAccountsClaimwebsite_580266(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Claims the website of a Merchant Center sub-account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The ID of the account whose website is claimed.
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580268 = path.getOrDefault("accountId")
  valid_580268 = validateParameter(valid_580268, JString, required = true,
                                 default = nil)
  if valid_580268 != nil:
    section.add "accountId", valid_580268
  var valid_580269 = path.getOrDefault("merchantId")
  valid_580269 = validateParameter(valid_580269, JString, required = true,
                                 default = nil)
  if valid_580269 != nil:
    section.add "merchantId", valid_580269
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
  ##   overwrite: JBool
  ##            : Only available to selected merchants. When set to True, this flag removes any existing claim on the requested website by another account and replaces it with a claim from this account.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580270 = query.getOrDefault("fields")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "fields", valid_580270
  var valid_580271 = query.getOrDefault("quotaUser")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "quotaUser", valid_580271
  var valid_580272 = query.getOrDefault("alt")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = newJString("json"))
  if valid_580272 != nil:
    section.add "alt", valid_580272
  var valid_580273 = query.getOrDefault("oauth_token")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "oauth_token", valid_580273
  var valid_580274 = query.getOrDefault("userIp")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "userIp", valid_580274
  var valid_580275 = query.getOrDefault("overwrite")
  valid_580275 = validateParameter(valid_580275, JBool, required = false, default = nil)
  if valid_580275 != nil:
    section.add "overwrite", valid_580275
  var valid_580276 = query.getOrDefault("key")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "key", valid_580276
  var valid_580277 = query.getOrDefault("prettyPrint")
  valid_580277 = validateParameter(valid_580277, JBool, required = false,
                                 default = newJBool(true))
  if valid_580277 != nil:
    section.add "prettyPrint", valid_580277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580278: Call_ContentAccountsClaimwebsite_580265; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Claims the website of a Merchant Center sub-account.
  ## 
  let valid = call_580278.validator(path, query, header, formData, body)
  let scheme = call_580278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580278.url(scheme.get, call_580278.host, call_580278.base,
                         call_580278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580278, url, valid)

proc call*(call_580279: Call_ContentAccountsClaimwebsite_580265; accountId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          overwrite: bool = false; key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentAccountsClaimwebsite
  ## Claims the website of a Merchant Center sub-account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The ID of the account whose website is claimed.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   overwrite: bool
  ##            : Only available to selected merchants. When set to True, this flag removes any existing claim on the requested website by another account and replaces it with a claim from this account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580280 = newJObject()
  var query_580281 = newJObject()
  add(query_580281, "fields", newJString(fields))
  add(query_580281, "quotaUser", newJString(quotaUser))
  add(query_580281, "alt", newJString(alt))
  add(query_580281, "oauth_token", newJString(oauthToken))
  add(path_580280, "accountId", newJString(accountId))
  add(query_580281, "userIp", newJString(userIp))
  add(query_580281, "overwrite", newJBool(overwrite))
  add(query_580281, "key", newJString(key))
  add(path_580280, "merchantId", newJString(merchantId))
  add(query_580281, "prettyPrint", newJBool(prettyPrint))
  result = call_580279.call(path_580280, query_580281, nil, nil, nil)

var contentAccountsClaimwebsite* = Call_ContentAccountsClaimwebsite_580265(
    name: "contentAccountsClaimwebsite", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/accounts/{accountId}/claimwebsite",
    validator: validate_ContentAccountsClaimwebsite_580266, base: "/content/v2.1",
    url: url_ContentAccountsClaimwebsite_580267, schemes: {Scheme.Https})
type
  Call_ContentAccountsLink_580282 = ref object of OpenApiRestCall_579421
proc url_ContentAccountsLink_580284(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/link")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentAccountsLink_580283(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Performs an action on a link between two Merchant Center accounts, namely accountId and linkedAccountId.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The ID of the account that should be linked.
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580285 = path.getOrDefault("accountId")
  valid_580285 = validateParameter(valid_580285, JString, required = true,
                                 default = nil)
  if valid_580285 != nil:
    section.add "accountId", valid_580285
  var valid_580286 = path.getOrDefault("merchantId")
  valid_580286 = validateParameter(valid_580286, JString, required = true,
                                 default = nil)
  if valid_580286 != nil:
    section.add "merchantId", valid_580286
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
  var valid_580287 = query.getOrDefault("fields")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "fields", valid_580287
  var valid_580288 = query.getOrDefault("quotaUser")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "quotaUser", valid_580288
  var valid_580289 = query.getOrDefault("alt")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = newJString("json"))
  if valid_580289 != nil:
    section.add "alt", valid_580289
  var valid_580290 = query.getOrDefault("oauth_token")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "oauth_token", valid_580290
  var valid_580291 = query.getOrDefault("userIp")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "userIp", valid_580291
  var valid_580292 = query.getOrDefault("key")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "key", valid_580292
  var valid_580293 = query.getOrDefault("prettyPrint")
  valid_580293 = validateParameter(valid_580293, JBool, required = false,
                                 default = newJBool(true))
  if valid_580293 != nil:
    section.add "prettyPrint", valid_580293
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

proc call*(call_580295: Call_ContentAccountsLink_580282; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs an action on a link between two Merchant Center accounts, namely accountId and linkedAccountId.
  ## 
  let valid = call_580295.validator(path, query, header, formData, body)
  let scheme = call_580295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580295.url(scheme.get, call_580295.host, call_580295.base,
                         call_580295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580295, url, valid)

proc call*(call_580296: Call_ContentAccountsLink_580282; accountId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentAccountsLink
  ## Performs an action on a link between two Merchant Center accounts, namely accountId and linkedAccountId.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The ID of the account that should be linked.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580297 = newJObject()
  var query_580298 = newJObject()
  var body_580299 = newJObject()
  add(query_580298, "fields", newJString(fields))
  add(query_580298, "quotaUser", newJString(quotaUser))
  add(query_580298, "alt", newJString(alt))
  add(query_580298, "oauth_token", newJString(oauthToken))
  add(path_580297, "accountId", newJString(accountId))
  add(query_580298, "userIp", newJString(userIp))
  add(query_580298, "key", newJString(key))
  add(path_580297, "merchantId", newJString(merchantId))
  if body != nil:
    body_580299 = body
  add(query_580298, "prettyPrint", newJBool(prettyPrint))
  result = call_580296.call(path_580297, query_580298, nil, nil, body_580299)

var contentAccountsLink* = Call_ContentAccountsLink_580282(
    name: "contentAccountsLink", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}/link",
    validator: validate_ContentAccountsLink_580283, base: "/content/v2.1",
    url: url_ContentAccountsLink_580284, schemes: {Scheme.Https})
type
  Call_ContentAccountstatusesList_580300 = ref object of OpenApiRestCall_579421
proc url_ContentAccountstatusesList_580302(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/accountstatuses")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentAccountstatusesList_580301(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the statuses of the sub-accounts in your Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. This must be a multi-client account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580303 = path.getOrDefault("merchantId")
  valid_580303 = validateParameter(valid_580303, JString, required = true,
                                 default = nil)
  if valid_580303 != nil:
    section.add "merchantId", valid_580303
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of account statuses to return in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   destinations: JArray
  ##               : If set, only issues for the specified destinations are returned, otherwise only issues for the Shopping destination.
  section = newJObject()
  var valid_580304 = query.getOrDefault("fields")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "fields", valid_580304
  var valid_580305 = query.getOrDefault("pageToken")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "pageToken", valid_580305
  var valid_580306 = query.getOrDefault("quotaUser")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "quotaUser", valid_580306
  var valid_580307 = query.getOrDefault("alt")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = newJString("json"))
  if valid_580307 != nil:
    section.add "alt", valid_580307
  var valid_580308 = query.getOrDefault("oauth_token")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "oauth_token", valid_580308
  var valid_580309 = query.getOrDefault("userIp")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "userIp", valid_580309
  var valid_580310 = query.getOrDefault("maxResults")
  valid_580310 = validateParameter(valid_580310, JInt, required = false, default = nil)
  if valid_580310 != nil:
    section.add "maxResults", valid_580310
  var valid_580311 = query.getOrDefault("key")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "key", valid_580311
  var valid_580312 = query.getOrDefault("prettyPrint")
  valid_580312 = validateParameter(valid_580312, JBool, required = false,
                                 default = newJBool(true))
  if valid_580312 != nil:
    section.add "prettyPrint", valid_580312
  var valid_580313 = query.getOrDefault("destinations")
  valid_580313 = validateParameter(valid_580313, JArray, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "destinations", valid_580313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580314: Call_ContentAccountstatusesList_580300; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_580314.validator(path, query, header, formData, body)
  let scheme = call_580314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580314.url(scheme.get, call_580314.host, call_580314.base,
                         call_580314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580314, url, valid)

proc call*(call_580315: Call_ContentAccountstatusesList_580300; merchantId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true;
          destinations: JsonNode = nil): Recallable =
  ## contentAccountstatusesList
  ## Lists the statuses of the sub-accounts in your Merchant Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of account statuses to return in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. This must be a multi-client account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   destinations: JArray
  ##               : If set, only issues for the specified destinations are returned, otherwise only issues for the Shopping destination.
  var path_580316 = newJObject()
  var query_580317 = newJObject()
  add(query_580317, "fields", newJString(fields))
  add(query_580317, "pageToken", newJString(pageToken))
  add(query_580317, "quotaUser", newJString(quotaUser))
  add(query_580317, "alt", newJString(alt))
  add(query_580317, "oauth_token", newJString(oauthToken))
  add(query_580317, "userIp", newJString(userIp))
  add(query_580317, "maxResults", newJInt(maxResults))
  add(query_580317, "key", newJString(key))
  add(path_580316, "merchantId", newJString(merchantId))
  add(query_580317, "prettyPrint", newJBool(prettyPrint))
  if destinations != nil:
    query_580317.add "destinations", destinations
  result = call_580315.call(path_580316, query_580317, nil, nil, nil)

var contentAccountstatusesList* = Call_ContentAccountstatusesList_580300(
    name: "contentAccountstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accountstatuses",
    validator: validate_ContentAccountstatusesList_580301, base: "/content/v2.1",
    url: url_ContentAccountstatusesList_580302, schemes: {Scheme.Https})
type
  Call_ContentAccountstatusesGet_580318 = ref object of OpenApiRestCall_579421
proc url_ContentAccountstatusesGet_580320(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/accountstatuses/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentAccountstatusesGet_580319(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the status of a Merchant Center account. No itemLevelIssues are returned for multi-client accounts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The ID of the account.
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580321 = path.getOrDefault("accountId")
  valid_580321 = validateParameter(valid_580321, JString, required = true,
                                 default = nil)
  if valid_580321 != nil:
    section.add "accountId", valid_580321
  var valid_580322 = path.getOrDefault("merchantId")
  valid_580322 = validateParameter(valid_580322, JString, required = true,
                                 default = nil)
  if valid_580322 != nil:
    section.add "merchantId", valid_580322
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
  ##   destinations: JArray
  ##               : If set, only issues for the specified destinations are returned, otherwise only issues for the Shopping destination.
  section = newJObject()
  var valid_580323 = query.getOrDefault("fields")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "fields", valid_580323
  var valid_580324 = query.getOrDefault("quotaUser")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "quotaUser", valid_580324
  var valid_580325 = query.getOrDefault("alt")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = newJString("json"))
  if valid_580325 != nil:
    section.add "alt", valid_580325
  var valid_580326 = query.getOrDefault("oauth_token")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = nil)
  if valid_580326 != nil:
    section.add "oauth_token", valid_580326
  var valid_580327 = query.getOrDefault("userIp")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "userIp", valid_580327
  var valid_580328 = query.getOrDefault("key")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "key", valid_580328
  var valid_580329 = query.getOrDefault("prettyPrint")
  valid_580329 = validateParameter(valid_580329, JBool, required = false,
                                 default = newJBool(true))
  if valid_580329 != nil:
    section.add "prettyPrint", valid_580329
  var valid_580330 = query.getOrDefault("destinations")
  valid_580330 = validateParameter(valid_580330, JArray, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "destinations", valid_580330
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580331: Call_ContentAccountstatusesGet_580318; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the status of a Merchant Center account. No itemLevelIssues are returned for multi-client accounts.
  ## 
  let valid = call_580331.validator(path, query, header, formData, body)
  let scheme = call_580331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580331.url(scheme.get, call_580331.host, call_580331.base,
                         call_580331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580331, url, valid)

proc call*(call_580332: Call_ContentAccountstatusesGet_580318; accountId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true; destinations: JsonNode = nil): Recallable =
  ## contentAccountstatusesGet
  ## Retrieves the status of a Merchant Center account. No itemLevelIssues are returned for multi-client accounts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The ID of the account.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   destinations: JArray
  ##               : If set, only issues for the specified destinations are returned, otherwise only issues for the Shopping destination.
  var path_580333 = newJObject()
  var query_580334 = newJObject()
  add(query_580334, "fields", newJString(fields))
  add(query_580334, "quotaUser", newJString(quotaUser))
  add(query_580334, "alt", newJString(alt))
  add(query_580334, "oauth_token", newJString(oauthToken))
  add(path_580333, "accountId", newJString(accountId))
  add(query_580334, "userIp", newJString(userIp))
  add(query_580334, "key", newJString(key))
  add(path_580333, "merchantId", newJString(merchantId))
  add(query_580334, "prettyPrint", newJBool(prettyPrint))
  if destinations != nil:
    query_580334.add "destinations", destinations
  result = call_580332.call(path_580333, query_580334, nil, nil, nil)

var contentAccountstatusesGet* = Call_ContentAccountstatusesGet_580318(
    name: "contentAccountstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/accountstatuses/{accountId}",
    validator: validate_ContentAccountstatusesGet_580319, base: "/content/v2.1",
    url: url_ContentAccountstatusesGet_580320, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxList_580335 = ref object of OpenApiRestCall_579421
proc url_ContentAccounttaxList_580337(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/accounttax")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentAccounttaxList_580336(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the tax settings of the sub-accounts in your Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. This must be a multi-client account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580338 = path.getOrDefault("merchantId")
  valid_580338 = validateParameter(valid_580338, JString, required = true,
                                 default = nil)
  if valid_580338 != nil:
    section.add "merchantId", valid_580338
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of tax settings to return in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580339 = query.getOrDefault("fields")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "fields", valid_580339
  var valid_580340 = query.getOrDefault("pageToken")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = nil)
  if valid_580340 != nil:
    section.add "pageToken", valid_580340
  var valid_580341 = query.getOrDefault("quotaUser")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "quotaUser", valid_580341
  var valid_580342 = query.getOrDefault("alt")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = newJString("json"))
  if valid_580342 != nil:
    section.add "alt", valid_580342
  var valid_580343 = query.getOrDefault("oauth_token")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "oauth_token", valid_580343
  var valid_580344 = query.getOrDefault("userIp")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "userIp", valid_580344
  var valid_580345 = query.getOrDefault("maxResults")
  valid_580345 = validateParameter(valid_580345, JInt, required = false, default = nil)
  if valid_580345 != nil:
    section.add "maxResults", valid_580345
  var valid_580346 = query.getOrDefault("key")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = nil)
  if valid_580346 != nil:
    section.add "key", valid_580346
  var valid_580347 = query.getOrDefault("prettyPrint")
  valid_580347 = validateParameter(valid_580347, JBool, required = false,
                                 default = newJBool(true))
  if valid_580347 != nil:
    section.add "prettyPrint", valid_580347
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580348: Call_ContentAccounttaxList_580335; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the tax settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_580348.validator(path, query, header, formData, body)
  let scheme = call_580348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580348.url(scheme.get, call_580348.host, call_580348.base,
                         call_580348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580348, url, valid)

proc call*(call_580349: Call_ContentAccounttaxList_580335; merchantId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentAccounttaxList
  ## Lists the tax settings of the sub-accounts in your Merchant Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of tax settings to return in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. This must be a multi-client account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580350 = newJObject()
  var query_580351 = newJObject()
  add(query_580351, "fields", newJString(fields))
  add(query_580351, "pageToken", newJString(pageToken))
  add(query_580351, "quotaUser", newJString(quotaUser))
  add(query_580351, "alt", newJString(alt))
  add(query_580351, "oauth_token", newJString(oauthToken))
  add(query_580351, "userIp", newJString(userIp))
  add(query_580351, "maxResults", newJInt(maxResults))
  add(query_580351, "key", newJString(key))
  add(path_580350, "merchantId", newJString(merchantId))
  add(query_580351, "prettyPrint", newJBool(prettyPrint))
  result = call_580349.call(path_580350, query_580351, nil, nil, nil)

var contentAccounttaxList* = Call_ContentAccounttaxList_580335(
    name: "contentAccounttaxList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax",
    validator: validate_ContentAccounttaxList_580336, base: "/content/v2.1",
    url: url_ContentAccounttaxList_580337, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxUpdate_580368 = ref object of OpenApiRestCall_579421
proc url_ContentAccounttaxUpdate_580370(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/accounttax/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentAccounttaxUpdate_580369(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the tax settings of the account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The ID of the account for which to get/update account tax settings.
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580371 = path.getOrDefault("accountId")
  valid_580371 = validateParameter(valid_580371, JString, required = true,
                                 default = nil)
  if valid_580371 != nil:
    section.add "accountId", valid_580371
  var valid_580372 = path.getOrDefault("merchantId")
  valid_580372 = validateParameter(valid_580372, JString, required = true,
                                 default = nil)
  if valid_580372 != nil:
    section.add "merchantId", valid_580372
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
  var valid_580373 = query.getOrDefault("fields")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = nil)
  if valid_580373 != nil:
    section.add "fields", valid_580373
  var valid_580374 = query.getOrDefault("quotaUser")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = nil)
  if valid_580374 != nil:
    section.add "quotaUser", valid_580374
  var valid_580375 = query.getOrDefault("alt")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = newJString("json"))
  if valid_580375 != nil:
    section.add "alt", valid_580375
  var valid_580376 = query.getOrDefault("oauth_token")
  valid_580376 = validateParameter(valid_580376, JString, required = false,
                                 default = nil)
  if valid_580376 != nil:
    section.add "oauth_token", valid_580376
  var valid_580377 = query.getOrDefault("userIp")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = nil)
  if valid_580377 != nil:
    section.add "userIp", valid_580377
  var valid_580378 = query.getOrDefault("key")
  valid_580378 = validateParameter(valid_580378, JString, required = false,
                                 default = nil)
  if valid_580378 != nil:
    section.add "key", valid_580378
  var valid_580379 = query.getOrDefault("prettyPrint")
  valid_580379 = validateParameter(valid_580379, JBool, required = false,
                                 default = newJBool(true))
  if valid_580379 != nil:
    section.add "prettyPrint", valid_580379
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

proc call*(call_580381: Call_ContentAccounttaxUpdate_580368; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the tax settings of the account.
  ## 
  let valid = call_580381.validator(path, query, header, formData, body)
  let scheme = call_580381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580381.url(scheme.get, call_580381.host, call_580381.base,
                         call_580381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580381, url, valid)

proc call*(call_580382: Call_ContentAccounttaxUpdate_580368; accountId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentAccounttaxUpdate
  ## Updates the tax settings of the account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The ID of the account for which to get/update account tax settings.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580383 = newJObject()
  var query_580384 = newJObject()
  var body_580385 = newJObject()
  add(query_580384, "fields", newJString(fields))
  add(query_580384, "quotaUser", newJString(quotaUser))
  add(query_580384, "alt", newJString(alt))
  add(query_580384, "oauth_token", newJString(oauthToken))
  add(path_580383, "accountId", newJString(accountId))
  add(query_580384, "userIp", newJString(userIp))
  add(query_580384, "key", newJString(key))
  add(path_580383, "merchantId", newJString(merchantId))
  if body != nil:
    body_580385 = body
  add(query_580384, "prettyPrint", newJBool(prettyPrint))
  result = call_580382.call(path_580383, query_580384, nil, nil, body_580385)

var contentAccounttaxUpdate* = Call_ContentAccounttaxUpdate_580368(
    name: "contentAccounttaxUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax/{accountId}",
    validator: validate_ContentAccounttaxUpdate_580369, base: "/content/v2.1",
    url: url_ContentAccounttaxUpdate_580370, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxGet_580352 = ref object of OpenApiRestCall_579421
proc url_ContentAccounttaxGet_580354(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/accounttax/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentAccounttaxGet_580353(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the tax settings of the account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The ID of the account for which to get/update account tax settings.
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580355 = path.getOrDefault("accountId")
  valid_580355 = validateParameter(valid_580355, JString, required = true,
                                 default = nil)
  if valid_580355 != nil:
    section.add "accountId", valid_580355
  var valid_580356 = path.getOrDefault("merchantId")
  valid_580356 = validateParameter(valid_580356, JString, required = true,
                                 default = nil)
  if valid_580356 != nil:
    section.add "merchantId", valid_580356
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
  var valid_580357 = query.getOrDefault("fields")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "fields", valid_580357
  var valid_580358 = query.getOrDefault("quotaUser")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "quotaUser", valid_580358
  var valid_580359 = query.getOrDefault("alt")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = newJString("json"))
  if valid_580359 != nil:
    section.add "alt", valid_580359
  var valid_580360 = query.getOrDefault("oauth_token")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "oauth_token", valid_580360
  var valid_580361 = query.getOrDefault("userIp")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "userIp", valid_580361
  var valid_580362 = query.getOrDefault("key")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "key", valid_580362
  var valid_580363 = query.getOrDefault("prettyPrint")
  valid_580363 = validateParameter(valid_580363, JBool, required = false,
                                 default = newJBool(true))
  if valid_580363 != nil:
    section.add "prettyPrint", valid_580363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580364: Call_ContentAccounttaxGet_580352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the tax settings of the account.
  ## 
  let valid = call_580364.validator(path, query, header, formData, body)
  let scheme = call_580364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580364.url(scheme.get, call_580364.host, call_580364.base,
                         call_580364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580364, url, valid)

proc call*(call_580365: Call_ContentAccounttaxGet_580352; accountId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentAccounttaxGet
  ## Retrieves the tax settings of the account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The ID of the account for which to get/update account tax settings.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580366 = newJObject()
  var query_580367 = newJObject()
  add(query_580367, "fields", newJString(fields))
  add(query_580367, "quotaUser", newJString(quotaUser))
  add(query_580367, "alt", newJString(alt))
  add(query_580367, "oauth_token", newJString(oauthToken))
  add(path_580366, "accountId", newJString(accountId))
  add(query_580367, "userIp", newJString(userIp))
  add(query_580367, "key", newJString(key))
  add(path_580366, "merchantId", newJString(merchantId))
  add(query_580367, "prettyPrint", newJBool(prettyPrint))
  result = call_580365.call(path_580366, query_580367, nil, nil, nil)

var contentAccounttaxGet* = Call_ContentAccounttaxGet_580352(
    name: "contentAccounttaxGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax/{accountId}",
    validator: validate_ContentAccounttaxGet_580353, base: "/content/v2.1",
    url: url_ContentAccounttaxGet_580354, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsInsert_580403 = ref object of OpenApiRestCall_579421
proc url_ContentDatafeedsInsert_580405(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/datafeeds")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentDatafeedsInsert_580404(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Registers a datafeed configuration with your Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the datafeed. This account cannot be a multi-client account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580406 = path.getOrDefault("merchantId")
  valid_580406 = validateParameter(valid_580406, JString, required = true,
                                 default = nil)
  if valid_580406 != nil:
    section.add "merchantId", valid_580406
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
  var valid_580407 = query.getOrDefault("fields")
  valid_580407 = validateParameter(valid_580407, JString, required = false,
                                 default = nil)
  if valid_580407 != nil:
    section.add "fields", valid_580407
  var valid_580408 = query.getOrDefault("quotaUser")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "quotaUser", valid_580408
  var valid_580409 = query.getOrDefault("alt")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = newJString("json"))
  if valid_580409 != nil:
    section.add "alt", valid_580409
  var valid_580410 = query.getOrDefault("oauth_token")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = nil)
  if valid_580410 != nil:
    section.add "oauth_token", valid_580410
  var valid_580411 = query.getOrDefault("userIp")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = nil)
  if valid_580411 != nil:
    section.add "userIp", valid_580411
  var valid_580412 = query.getOrDefault("key")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = nil)
  if valid_580412 != nil:
    section.add "key", valid_580412
  var valid_580413 = query.getOrDefault("prettyPrint")
  valid_580413 = validateParameter(valid_580413, JBool, required = false,
                                 default = newJBool(true))
  if valid_580413 != nil:
    section.add "prettyPrint", valid_580413
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

proc call*(call_580415: Call_ContentDatafeedsInsert_580403; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers a datafeed configuration with your Merchant Center account.
  ## 
  let valid = call_580415.validator(path, query, header, formData, body)
  let scheme = call_580415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580415.url(scheme.get, call_580415.host, call_580415.base,
                         call_580415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580415, url, valid)

proc call*(call_580416: Call_ContentDatafeedsInsert_580403; merchantId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentDatafeedsInsert
  ## Registers a datafeed configuration with your Merchant Center account.
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
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the datafeed. This account cannot be a multi-client account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580417 = newJObject()
  var query_580418 = newJObject()
  var body_580419 = newJObject()
  add(query_580418, "fields", newJString(fields))
  add(query_580418, "quotaUser", newJString(quotaUser))
  add(query_580418, "alt", newJString(alt))
  add(query_580418, "oauth_token", newJString(oauthToken))
  add(query_580418, "userIp", newJString(userIp))
  add(query_580418, "key", newJString(key))
  add(path_580417, "merchantId", newJString(merchantId))
  if body != nil:
    body_580419 = body
  add(query_580418, "prettyPrint", newJBool(prettyPrint))
  result = call_580416.call(path_580417, query_580418, nil, nil, body_580419)

var contentDatafeedsInsert* = Call_ContentDatafeedsInsert_580403(
    name: "contentDatafeedsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds",
    validator: validate_ContentDatafeedsInsert_580404, base: "/content/v2.1",
    url: url_ContentDatafeedsInsert_580405, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsList_580386 = ref object of OpenApiRestCall_579421
proc url_ContentDatafeedsList_580388(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/datafeeds")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentDatafeedsList_580387(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the configurations for datafeeds in your Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the datafeeds. This account cannot be a multi-client account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580389 = path.getOrDefault("merchantId")
  valid_580389 = validateParameter(valid_580389, JString, required = true,
                                 default = nil)
  if valid_580389 != nil:
    section.add "merchantId", valid_580389
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of products to return in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580390 = query.getOrDefault("fields")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "fields", valid_580390
  var valid_580391 = query.getOrDefault("pageToken")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "pageToken", valid_580391
  var valid_580392 = query.getOrDefault("quotaUser")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = nil)
  if valid_580392 != nil:
    section.add "quotaUser", valid_580392
  var valid_580393 = query.getOrDefault("alt")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = newJString("json"))
  if valid_580393 != nil:
    section.add "alt", valid_580393
  var valid_580394 = query.getOrDefault("oauth_token")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = nil)
  if valid_580394 != nil:
    section.add "oauth_token", valid_580394
  var valid_580395 = query.getOrDefault("userIp")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = nil)
  if valid_580395 != nil:
    section.add "userIp", valid_580395
  var valid_580396 = query.getOrDefault("maxResults")
  valid_580396 = validateParameter(valid_580396, JInt, required = false, default = nil)
  if valid_580396 != nil:
    section.add "maxResults", valid_580396
  var valid_580397 = query.getOrDefault("key")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = nil)
  if valid_580397 != nil:
    section.add "key", valid_580397
  var valid_580398 = query.getOrDefault("prettyPrint")
  valid_580398 = validateParameter(valid_580398, JBool, required = false,
                                 default = newJBool(true))
  if valid_580398 != nil:
    section.add "prettyPrint", valid_580398
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580399: Call_ContentDatafeedsList_580386; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the configurations for datafeeds in your Merchant Center account.
  ## 
  let valid = call_580399.validator(path, query, header, formData, body)
  let scheme = call_580399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580399.url(scheme.get, call_580399.host, call_580399.base,
                         call_580399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580399, url, valid)

proc call*(call_580400: Call_ContentDatafeedsList_580386; merchantId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentDatafeedsList
  ## Lists the configurations for datafeeds in your Merchant Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of products to return in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the datafeeds. This account cannot be a multi-client account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580401 = newJObject()
  var query_580402 = newJObject()
  add(query_580402, "fields", newJString(fields))
  add(query_580402, "pageToken", newJString(pageToken))
  add(query_580402, "quotaUser", newJString(quotaUser))
  add(query_580402, "alt", newJString(alt))
  add(query_580402, "oauth_token", newJString(oauthToken))
  add(query_580402, "userIp", newJString(userIp))
  add(query_580402, "maxResults", newJInt(maxResults))
  add(query_580402, "key", newJString(key))
  add(path_580401, "merchantId", newJString(merchantId))
  add(query_580402, "prettyPrint", newJBool(prettyPrint))
  result = call_580400.call(path_580401, query_580402, nil, nil, nil)

var contentDatafeedsList* = Call_ContentDatafeedsList_580386(
    name: "contentDatafeedsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds",
    validator: validate_ContentDatafeedsList_580387, base: "/content/v2.1",
    url: url_ContentDatafeedsList_580388, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsUpdate_580436 = ref object of OpenApiRestCall_579421
proc url_ContentDatafeedsUpdate_580438(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "datafeedId" in path, "`datafeedId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/datafeeds/"),
               (kind: VariableSegment, value: "datafeedId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentDatafeedsUpdate_580437(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a datafeed configuration of your Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the datafeed. This account cannot be a multi-client account.
  ##   datafeedId: JString (required)
  ##             : The ID of the datafeed.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580439 = path.getOrDefault("merchantId")
  valid_580439 = validateParameter(valid_580439, JString, required = true,
                                 default = nil)
  if valid_580439 != nil:
    section.add "merchantId", valid_580439
  var valid_580440 = path.getOrDefault("datafeedId")
  valid_580440 = validateParameter(valid_580440, JString, required = true,
                                 default = nil)
  if valid_580440 != nil:
    section.add "datafeedId", valid_580440
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
  var valid_580441 = query.getOrDefault("fields")
  valid_580441 = validateParameter(valid_580441, JString, required = false,
                                 default = nil)
  if valid_580441 != nil:
    section.add "fields", valid_580441
  var valid_580442 = query.getOrDefault("quotaUser")
  valid_580442 = validateParameter(valid_580442, JString, required = false,
                                 default = nil)
  if valid_580442 != nil:
    section.add "quotaUser", valid_580442
  var valid_580443 = query.getOrDefault("alt")
  valid_580443 = validateParameter(valid_580443, JString, required = false,
                                 default = newJString("json"))
  if valid_580443 != nil:
    section.add "alt", valid_580443
  var valid_580444 = query.getOrDefault("oauth_token")
  valid_580444 = validateParameter(valid_580444, JString, required = false,
                                 default = nil)
  if valid_580444 != nil:
    section.add "oauth_token", valid_580444
  var valid_580445 = query.getOrDefault("userIp")
  valid_580445 = validateParameter(valid_580445, JString, required = false,
                                 default = nil)
  if valid_580445 != nil:
    section.add "userIp", valid_580445
  var valid_580446 = query.getOrDefault("key")
  valid_580446 = validateParameter(valid_580446, JString, required = false,
                                 default = nil)
  if valid_580446 != nil:
    section.add "key", valid_580446
  var valid_580447 = query.getOrDefault("prettyPrint")
  valid_580447 = validateParameter(valid_580447, JBool, required = false,
                                 default = newJBool(true))
  if valid_580447 != nil:
    section.add "prettyPrint", valid_580447
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

proc call*(call_580449: Call_ContentDatafeedsUpdate_580436; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a datafeed configuration of your Merchant Center account.
  ## 
  let valid = call_580449.validator(path, query, header, formData, body)
  let scheme = call_580449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580449.url(scheme.get, call_580449.host, call_580449.base,
                         call_580449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580449, url, valid)

proc call*(call_580450: Call_ContentDatafeedsUpdate_580436; merchantId: string;
          datafeedId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentDatafeedsUpdate
  ## Updates a datafeed configuration of your Merchant Center account.
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
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the datafeed. This account cannot be a multi-client account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   datafeedId: string (required)
  ##             : The ID of the datafeed.
  var path_580451 = newJObject()
  var query_580452 = newJObject()
  var body_580453 = newJObject()
  add(query_580452, "fields", newJString(fields))
  add(query_580452, "quotaUser", newJString(quotaUser))
  add(query_580452, "alt", newJString(alt))
  add(query_580452, "oauth_token", newJString(oauthToken))
  add(query_580452, "userIp", newJString(userIp))
  add(query_580452, "key", newJString(key))
  add(path_580451, "merchantId", newJString(merchantId))
  if body != nil:
    body_580453 = body
  add(query_580452, "prettyPrint", newJBool(prettyPrint))
  add(path_580451, "datafeedId", newJString(datafeedId))
  result = call_580450.call(path_580451, query_580452, nil, nil, body_580453)

var contentDatafeedsUpdate* = Call_ContentDatafeedsUpdate_580436(
    name: "contentDatafeedsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsUpdate_580437, base: "/content/v2.1",
    url: url_ContentDatafeedsUpdate_580438, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsGet_580420 = ref object of OpenApiRestCall_579421
proc url_ContentDatafeedsGet_580422(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "datafeedId" in path, "`datafeedId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/datafeeds/"),
               (kind: VariableSegment, value: "datafeedId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentDatafeedsGet_580421(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves a datafeed configuration from your Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the datafeed. This account cannot be a multi-client account.
  ##   datafeedId: JString (required)
  ##             : The ID of the datafeed.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580423 = path.getOrDefault("merchantId")
  valid_580423 = validateParameter(valid_580423, JString, required = true,
                                 default = nil)
  if valid_580423 != nil:
    section.add "merchantId", valid_580423
  var valid_580424 = path.getOrDefault("datafeedId")
  valid_580424 = validateParameter(valid_580424, JString, required = true,
                                 default = nil)
  if valid_580424 != nil:
    section.add "datafeedId", valid_580424
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
  var valid_580425 = query.getOrDefault("fields")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = nil)
  if valid_580425 != nil:
    section.add "fields", valid_580425
  var valid_580426 = query.getOrDefault("quotaUser")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = nil)
  if valid_580426 != nil:
    section.add "quotaUser", valid_580426
  var valid_580427 = query.getOrDefault("alt")
  valid_580427 = validateParameter(valid_580427, JString, required = false,
                                 default = newJString("json"))
  if valid_580427 != nil:
    section.add "alt", valid_580427
  var valid_580428 = query.getOrDefault("oauth_token")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = nil)
  if valid_580428 != nil:
    section.add "oauth_token", valid_580428
  var valid_580429 = query.getOrDefault("userIp")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = nil)
  if valid_580429 != nil:
    section.add "userIp", valid_580429
  var valid_580430 = query.getOrDefault("key")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "key", valid_580430
  var valid_580431 = query.getOrDefault("prettyPrint")
  valid_580431 = validateParameter(valid_580431, JBool, required = false,
                                 default = newJBool(true))
  if valid_580431 != nil:
    section.add "prettyPrint", valid_580431
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580432: Call_ContentDatafeedsGet_580420; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a datafeed configuration from your Merchant Center account.
  ## 
  let valid = call_580432.validator(path, query, header, formData, body)
  let scheme = call_580432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580432.url(scheme.get, call_580432.host, call_580432.base,
                         call_580432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580432, url, valid)

proc call*(call_580433: Call_ContentDatafeedsGet_580420; merchantId: string;
          datafeedId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentDatafeedsGet
  ## Retrieves a datafeed configuration from your Merchant Center account.
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
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the datafeed. This account cannot be a multi-client account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   datafeedId: string (required)
  ##             : The ID of the datafeed.
  var path_580434 = newJObject()
  var query_580435 = newJObject()
  add(query_580435, "fields", newJString(fields))
  add(query_580435, "quotaUser", newJString(quotaUser))
  add(query_580435, "alt", newJString(alt))
  add(query_580435, "oauth_token", newJString(oauthToken))
  add(query_580435, "userIp", newJString(userIp))
  add(query_580435, "key", newJString(key))
  add(path_580434, "merchantId", newJString(merchantId))
  add(query_580435, "prettyPrint", newJBool(prettyPrint))
  add(path_580434, "datafeedId", newJString(datafeedId))
  result = call_580433.call(path_580434, query_580435, nil, nil, nil)

var contentDatafeedsGet* = Call_ContentDatafeedsGet_580420(
    name: "contentDatafeedsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsGet_580421, base: "/content/v2.1",
    url: url_ContentDatafeedsGet_580422, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsDelete_580454 = ref object of OpenApiRestCall_579421
proc url_ContentDatafeedsDelete_580456(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "datafeedId" in path, "`datafeedId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/datafeeds/"),
               (kind: VariableSegment, value: "datafeedId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentDatafeedsDelete_580455(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a datafeed configuration from your Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the datafeed. This account cannot be a multi-client account.
  ##   datafeedId: JString (required)
  ##             : The ID of the datafeed.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580457 = path.getOrDefault("merchantId")
  valid_580457 = validateParameter(valid_580457, JString, required = true,
                                 default = nil)
  if valid_580457 != nil:
    section.add "merchantId", valid_580457
  var valid_580458 = path.getOrDefault("datafeedId")
  valid_580458 = validateParameter(valid_580458, JString, required = true,
                                 default = nil)
  if valid_580458 != nil:
    section.add "datafeedId", valid_580458
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
  var valid_580459 = query.getOrDefault("fields")
  valid_580459 = validateParameter(valid_580459, JString, required = false,
                                 default = nil)
  if valid_580459 != nil:
    section.add "fields", valid_580459
  var valid_580460 = query.getOrDefault("quotaUser")
  valid_580460 = validateParameter(valid_580460, JString, required = false,
                                 default = nil)
  if valid_580460 != nil:
    section.add "quotaUser", valid_580460
  var valid_580461 = query.getOrDefault("alt")
  valid_580461 = validateParameter(valid_580461, JString, required = false,
                                 default = newJString("json"))
  if valid_580461 != nil:
    section.add "alt", valid_580461
  var valid_580462 = query.getOrDefault("oauth_token")
  valid_580462 = validateParameter(valid_580462, JString, required = false,
                                 default = nil)
  if valid_580462 != nil:
    section.add "oauth_token", valid_580462
  var valid_580463 = query.getOrDefault("userIp")
  valid_580463 = validateParameter(valid_580463, JString, required = false,
                                 default = nil)
  if valid_580463 != nil:
    section.add "userIp", valid_580463
  var valid_580464 = query.getOrDefault("key")
  valid_580464 = validateParameter(valid_580464, JString, required = false,
                                 default = nil)
  if valid_580464 != nil:
    section.add "key", valid_580464
  var valid_580465 = query.getOrDefault("prettyPrint")
  valid_580465 = validateParameter(valid_580465, JBool, required = false,
                                 default = newJBool(true))
  if valid_580465 != nil:
    section.add "prettyPrint", valid_580465
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580466: Call_ContentDatafeedsDelete_580454; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a datafeed configuration from your Merchant Center account.
  ## 
  let valid = call_580466.validator(path, query, header, formData, body)
  let scheme = call_580466.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580466.url(scheme.get, call_580466.host, call_580466.base,
                         call_580466.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580466, url, valid)

proc call*(call_580467: Call_ContentDatafeedsDelete_580454; merchantId: string;
          datafeedId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentDatafeedsDelete
  ## Deletes a datafeed configuration from your Merchant Center account.
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
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the datafeed. This account cannot be a multi-client account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   datafeedId: string (required)
  ##             : The ID of the datafeed.
  var path_580468 = newJObject()
  var query_580469 = newJObject()
  add(query_580469, "fields", newJString(fields))
  add(query_580469, "quotaUser", newJString(quotaUser))
  add(query_580469, "alt", newJString(alt))
  add(query_580469, "oauth_token", newJString(oauthToken))
  add(query_580469, "userIp", newJString(userIp))
  add(query_580469, "key", newJString(key))
  add(path_580468, "merchantId", newJString(merchantId))
  add(query_580469, "prettyPrint", newJBool(prettyPrint))
  add(path_580468, "datafeedId", newJString(datafeedId))
  result = call_580467.call(path_580468, query_580469, nil, nil, nil)

var contentDatafeedsDelete* = Call_ContentDatafeedsDelete_580454(
    name: "contentDatafeedsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsDelete_580455, base: "/content/v2.1",
    url: url_ContentDatafeedsDelete_580456, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsFetchnow_580470 = ref object of OpenApiRestCall_579421
proc url_ContentDatafeedsFetchnow_580472(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "datafeedId" in path, "`datafeedId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/datafeeds/"),
               (kind: VariableSegment, value: "datafeedId"),
               (kind: ConstantSegment, value: "/fetchNow")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentDatafeedsFetchnow_580471(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Invokes a fetch for the datafeed in your Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the datafeed. This account cannot be a multi-client account.
  ##   datafeedId: JString (required)
  ##             : The ID of the datafeed to be fetched.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580473 = path.getOrDefault("merchantId")
  valid_580473 = validateParameter(valid_580473, JString, required = true,
                                 default = nil)
  if valid_580473 != nil:
    section.add "merchantId", valid_580473
  var valid_580474 = path.getOrDefault("datafeedId")
  valid_580474 = validateParameter(valid_580474, JString, required = true,
                                 default = nil)
  if valid_580474 != nil:
    section.add "datafeedId", valid_580474
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
  var valid_580475 = query.getOrDefault("fields")
  valid_580475 = validateParameter(valid_580475, JString, required = false,
                                 default = nil)
  if valid_580475 != nil:
    section.add "fields", valid_580475
  var valid_580476 = query.getOrDefault("quotaUser")
  valid_580476 = validateParameter(valid_580476, JString, required = false,
                                 default = nil)
  if valid_580476 != nil:
    section.add "quotaUser", valid_580476
  var valid_580477 = query.getOrDefault("alt")
  valid_580477 = validateParameter(valid_580477, JString, required = false,
                                 default = newJString("json"))
  if valid_580477 != nil:
    section.add "alt", valid_580477
  var valid_580478 = query.getOrDefault("oauth_token")
  valid_580478 = validateParameter(valid_580478, JString, required = false,
                                 default = nil)
  if valid_580478 != nil:
    section.add "oauth_token", valid_580478
  var valid_580479 = query.getOrDefault("userIp")
  valid_580479 = validateParameter(valid_580479, JString, required = false,
                                 default = nil)
  if valid_580479 != nil:
    section.add "userIp", valid_580479
  var valid_580480 = query.getOrDefault("key")
  valid_580480 = validateParameter(valid_580480, JString, required = false,
                                 default = nil)
  if valid_580480 != nil:
    section.add "key", valid_580480
  var valid_580481 = query.getOrDefault("prettyPrint")
  valid_580481 = validateParameter(valid_580481, JBool, required = false,
                                 default = newJBool(true))
  if valid_580481 != nil:
    section.add "prettyPrint", valid_580481
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580482: Call_ContentDatafeedsFetchnow_580470; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Invokes a fetch for the datafeed in your Merchant Center account.
  ## 
  let valid = call_580482.validator(path, query, header, formData, body)
  let scheme = call_580482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580482.url(scheme.get, call_580482.host, call_580482.base,
                         call_580482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580482, url, valid)

proc call*(call_580483: Call_ContentDatafeedsFetchnow_580470; merchantId: string;
          datafeedId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentDatafeedsFetchnow
  ## Invokes a fetch for the datafeed in your Merchant Center account.
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
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the datafeed. This account cannot be a multi-client account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   datafeedId: string (required)
  ##             : The ID of the datafeed to be fetched.
  var path_580484 = newJObject()
  var query_580485 = newJObject()
  add(query_580485, "fields", newJString(fields))
  add(query_580485, "quotaUser", newJString(quotaUser))
  add(query_580485, "alt", newJString(alt))
  add(query_580485, "oauth_token", newJString(oauthToken))
  add(query_580485, "userIp", newJString(userIp))
  add(query_580485, "key", newJString(key))
  add(path_580484, "merchantId", newJString(merchantId))
  add(query_580485, "prettyPrint", newJBool(prettyPrint))
  add(path_580484, "datafeedId", newJString(datafeedId))
  result = call_580483.call(path_580484, query_580485, nil, nil, nil)

var contentDatafeedsFetchnow* = Call_ContentDatafeedsFetchnow_580470(
    name: "contentDatafeedsFetchnow", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/datafeeds/{datafeedId}/fetchNow",
    validator: validate_ContentDatafeedsFetchnow_580471, base: "/content/v2.1",
    url: url_ContentDatafeedsFetchnow_580472, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesList_580486 = ref object of OpenApiRestCall_579421
proc url_ContentDatafeedstatusesList_580488(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/datafeedstatuses")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentDatafeedstatusesList_580487(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the statuses of the datafeeds in your Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the datafeeds. This account cannot be a multi-client account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580489 = path.getOrDefault("merchantId")
  valid_580489 = validateParameter(valid_580489, JString, required = true,
                                 default = nil)
  if valid_580489 != nil:
    section.add "merchantId", valid_580489
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of products to return in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580490 = query.getOrDefault("fields")
  valid_580490 = validateParameter(valid_580490, JString, required = false,
                                 default = nil)
  if valid_580490 != nil:
    section.add "fields", valid_580490
  var valid_580491 = query.getOrDefault("pageToken")
  valid_580491 = validateParameter(valid_580491, JString, required = false,
                                 default = nil)
  if valid_580491 != nil:
    section.add "pageToken", valid_580491
  var valid_580492 = query.getOrDefault("quotaUser")
  valid_580492 = validateParameter(valid_580492, JString, required = false,
                                 default = nil)
  if valid_580492 != nil:
    section.add "quotaUser", valid_580492
  var valid_580493 = query.getOrDefault("alt")
  valid_580493 = validateParameter(valid_580493, JString, required = false,
                                 default = newJString("json"))
  if valid_580493 != nil:
    section.add "alt", valid_580493
  var valid_580494 = query.getOrDefault("oauth_token")
  valid_580494 = validateParameter(valid_580494, JString, required = false,
                                 default = nil)
  if valid_580494 != nil:
    section.add "oauth_token", valid_580494
  var valid_580495 = query.getOrDefault("userIp")
  valid_580495 = validateParameter(valid_580495, JString, required = false,
                                 default = nil)
  if valid_580495 != nil:
    section.add "userIp", valid_580495
  var valid_580496 = query.getOrDefault("maxResults")
  valid_580496 = validateParameter(valid_580496, JInt, required = false, default = nil)
  if valid_580496 != nil:
    section.add "maxResults", valid_580496
  var valid_580497 = query.getOrDefault("key")
  valid_580497 = validateParameter(valid_580497, JString, required = false,
                                 default = nil)
  if valid_580497 != nil:
    section.add "key", valid_580497
  var valid_580498 = query.getOrDefault("prettyPrint")
  valid_580498 = validateParameter(valid_580498, JBool, required = false,
                                 default = newJBool(true))
  if valid_580498 != nil:
    section.add "prettyPrint", valid_580498
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580499: Call_ContentDatafeedstatusesList_580486; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the datafeeds in your Merchant Center account.
  ## 
  let valid = call_580499.validator(path, query, header, formData, body)
  let scheme = call_580499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580499.url(scheme.get, call_580499.host, call_580499.base,
                         call_580499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580499, url, valid)

proc call*(call_580500: Call_ContentDatafeedstatusesList_580486;
          merchantId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## contentDatafeedstatusesList
  ## Lists the statuses of the datafeeds in your Merchant Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of products to return in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the datafeeds. This account cannot be a multi-client account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580501 = newJObject()
  var query_580502 = newJObject()
  add(query_580502, "fields", newJString(fields))
  add(query_580502, "pageToken", newJString(pageToken))
  add(query_580502, "quotaUser", newJString(quotaUser))
  add(query_580502, "alt", newJString(alt))
  add(query_580502, "oauth_token", newJString(oauthToken))
  add(query_580502, "userIp", newJString(userIp))
  add(query_580502, "maxResults", newJInt(maxResults))
  add(query_580502, "key", newJString(key))
  add(path_580501, "merchantId", newJString(merchantId))
  add(query_580502, "prettyPrint", newJBool(prettyPrint))
  result = call_580500.call(path_580501, query_580502, nil, nil, nil)

var contentDatafeedstatusesList* = Call_ContentDatafeedstatusesList_580486(
    name: "contentDatafeedstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeedstatuses",
    validator: validate_ContentDatafeedstatusesList_580487, base: "/content/v2.1",
    url: url_ContentDatafeedstatusesList_580488, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesGet_580503 = ref object of OpenApiRestCall_579421
proc url_ContentDatafeedstatusesGet_580505(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "datafeedId" in path, "`datafeedId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/datafeedstatuses/"),
               (kind: VariableSegment, value: "datafeedId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentDatafeedstatusesGet_580504(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the status of a datafeed from your Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the datafeed. This account cannot be a multi-client account.
  ##   datafeedId: JString (required)
  ##             : The ID of the datafeed.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580506 = path.getOrDefault("merchantId")
  valid_580506 = validateParameter(valid_580506, JString, required = true,
                                 default = nil)
  if valid_580506 != nil:
    section.add "merchantId", valid_580506
  var valid_580507 = path.getOrDefault("datafeedId")
  valid_580507 = validateParameter(valid_580507, JString, required = true,
                                 default = nil)
  if valid_580507 != nil:
    section.add "datafeedId", valid_580507
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   country: JString
  ##          : The country for which to get the datafeed status. If this parameter is provided then language must also be provided. Note that this parameter is required for feeds targeting multiple countries and languages, since a feed may have a different status for each target.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The language for which to get the datafeed status. If this parameter is provided then country must also be provided. Note that this parameter is required for feeds targeting multiple countries and languages, since a feed may have a different status for each target.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580508 = query.getOrDefault("fields")
  valid_580508 = validateParameter(valid_580508, JString, required = false,
                                 default = nil)
  if valid_580508 != nil:
    section.add "fields", valid_580508
  var valid_580509 = query.getOrDefault("country")
  valid_580509 = validateParameter(valid_580509, JString, required = false,
                                 default = nil)
  if valid_580509 != nil:
    section.add "country", valid_580509
  var valid_580510 = query.getOrDefault("quotaUser")
  valid_580510 = validateParameter(valid_580510, JString, required = false,
                                 default = nil)
  if valid_580510 != nil:
    section.add "quotaUser", valid_580510
  var valid_580511 = query.getOrDefault("alt")
  valid_580511 = validateParameter(valid_580511, JString, required = false,
                                 default = newJString("json"))
  if valid_580511 != nil:
    section.add "alt", valid_580511
  var valid_580512 = query.getOrDefault("language")
  valid_580512 = validateParameter(valid_580512, JString, required = false,
                                 default = nil)
  if valid_580512 != nil:
    section.add "language", valid_580512
  var valid_580513 = query.getOrDefault("oauth_token")
  valid_580513 = validateParameter(valid_580513, JString, required = false,
                                 default = nil)
  if valid_580513 != nil:
    section.add "oauth_token", valid_580513
  var valid_580514 = query.getOrDefault("userIp")
  valid_580514 = validateParameter(valid_580514, JString, required = false,
                                 default = nil)
  if valid_580514 != nil:
    section.add "userIp", valid_580514
  var valid_580515 = query.getOrDefault("key")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = nil)
  if valid_580515 != nil:
    section.add "key", valid_580515
  var valid_580516 = query.getOrDefault("prettyPrint")
  valid_580516 = validateParameter(valid_580516, JBool, required = false,
                                 default = newJBool(true))
  if valid_580516 != nil:
    section.add "prettyPrint", valid_580516
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580517: Call_ContentDatafeedstatusesGet_580503; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the status of a datafeed from your Merchant Center account.
  ## 
  let valid = call_580517.validator(path, query, header, formData, body)
  let scheme = call_580517.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580517.url(scheme.get, call_580517.host, call_580517.base,
                         call_580517.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580517, url, valid)

proc call*(call_580518: Call_ContentDatafeedstatusesGet_580503; merchantId: string;
          datafeedId: string; fields: string = ""; country: string = "";
          quotaUser: string = ""; alt: string = "json"; language: string = "";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## contentDatafeedstatusesGet
  ## Retrieves the status of a datafeed from your Merchant Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   country: string
  ##          : The country for which to get the datafeed status. If this parameter is provided then language must also be provided. Note that this parameter is required for feeds targeting multiple countries and languages, since a feed may have a different status for each target.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The language for which to get the datafeed status. If this parameter is provided then country must also be provided. Note that this parameter is required for feeds targeting multiple countries and languages, since a feed may have a different status for each target.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the datafeed. This account cannot be a multi-client account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   datafeedId: string (required)
  ##             : The ID of the datafeed.
  var path_580519 = newJObject()
  var query_580520 = newJObject()
  add(query_580520, "fields", newJString(fields))
  add(query_580520, "country", newJString(country))
  add(query_580520, "quotaUser", newJString(quotaUser))
  add(query_580520, "alt", newJString(alt))
  add(query_580520, "language", newJString(language))
  add(query_580520, "oauth_token", newJString(oauthToken))
  add(query_580520, "userIp", newJString(userIp))
  add(query_580520, "key", newJString(key))
  add(path_580519, "merchantId", newJString(merchantId))
  add(query_580520, "prettyPrint", newJBool(prettyPrint))
  add(path_580519, "datafeedId", newJString(datafeedId))
  result = call_580518.call(path_580519, query_580520, nil, nil, nil)

var contentDatafeedstatusesGet* = Call_ContentDatafeedstatusesGet_580503(
    name: "contentDatafeedstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/datafeedstatuses/{datafeedId}",
    validator: validate_ContentDatafeedstatusesGet_580504, base: "/content/v2.1",
    url: url_ContentDatafeedstatusesGet_580505, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsList_580521 = ref object of OpenApiRestCall_579421
proc url_ContentLiasettingsList_580523(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/liasettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentLiasettingsList_580522(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the LIA settings of the sub-accounts in your Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. This must be a multi-client account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580524 = path.getOrDefault("merchantId")
  valid_580524 = validateParameter(valid_580524, JString, required = true,
                                 default = nil)
  if valid_580524 != nil:
    section.add "merchantId", valid_580524
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of LIA settings to return in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580525 = query.getOrDefault("fields")
  valid_580525 = validateParameter(valid_580525, JString, required = false,
                                 default = nil)
  if valid_580525 != nil:
    section.add "fields", valid_580525
  var valid_580526 = query.getOrDefault("pageToken")
  valid_580526 = validateParameter(valid_580526, JString, required = false,
                                 default = nil)
  if valid_580526 != nil:
    section.add "pageToken", valid_580526
  var valid_580527 = query.getOrDefault("quotaUser")
  valid_580527 = validateParameter(valid_580527, JString, required = false,
                                 default = nil)
  if valid_580527 != nil:
    section.add "quotaUser", valid_580527
  var valid_580528 = query.getOrDefault("alt")
  valid_580528 = validateParameter(valid_580528, JString, required = false,
                                 default = newJString("json"))
  if valid_580528 != nil:
    section.add "alt", valid_580528
  var valid_580529 = query.getOrDefault("oauth_token")
  valid_580529 = validateParameter(valid_580529, JString, required = false,
                                 default = nil)
  if valid_580529 != nil:
    section.add "oauth_token", valid_580529
  var valid_580530 = query.getOrDefault("userIp")
  valid_580530 = validateParameter(valid_580530, JString, required = false,
                                 default = nil)
  if valid_580530 != nil:
    section.add "userIp", valid_580530
  var valid_580531 = query.getOrDefault("maxResults")
  valid_580531 = validateParameter(valid_580531, JInt, required = false, default = nil)
  if valid_580531 != nil:
    section.add "maxResults", valid_580531
  var valid_580532 = query.getOrDefault("key")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = nil)
  if valid_580532 != nil:
    section.add "key", valid_580532
  var valid_580533 = query.getOrDefault("prettyPrint")
  valid_580533 = validateParameter(valid_580533, JBool, required = false,
                                 default = newJBool(true))
  if valid_580533 != nil:
    section.add "prettyPrint", valid_580533
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580534: Call_ContentLiasettingsList_580521; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the LIA settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_580534.validator(path, query, header, formData, body)
  let scheme = call_580534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580534.url(scheme.get, call_580534.host, call_580534.base,
                         call_580534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580534, url, valid)

proc call*(call_580535: Call_ContentLiasettingsList_580521; merchantId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentLiasettingsList
  ## Lists the LIA settings of the sub-accounts in your Merchant Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of LIA settings to return in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. This must be a multi-client account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580536 = newJObject()
  var query_580537 = newJObject()
  add(query_580537, "fields", newJString(fields))
  add(query_580537, "pageToken", newJString(pageToken))
  add(query_580537, "quotaUser", newJString(quotaUser))
  add(query_580537, "alt", newJString(alt))
  add(query_580537, "oauth_token", newJString(oauthToken))
  add(query_580537, "userIp", newJString(userIp))
  add(query_580537, "maxResults", newJInt(maxResults))
  add(query_580537, "key", newJString(key))
  add(path_580536, "merchantId", newJString(merchantId))
  add(query_580537, "prettyPrint", newJBool(prettyPrint))
  result = call_580535.call(path_580536, query_580537, nil, nil, nil)

var contentLiasettingsList* = Call_ContentLiasettingsList_580521(
    name: "contentLiasettingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings",
    validator: validate_ContentLiasettingsList_580522, base: "/content/v2.1",
    url: url_ContentLiasettingsList_580523, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsUpdate_580554 = ref object of OpenApiRestCall_579421
proc url_ContentLiasettingsUpdate_580556(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/liasettings/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentLiasettingsUpdate_580555(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the LIA settings of the account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The ID of the account for which to get or update LIA settings.
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580557 = path.getOrDefault("accountId")
  valid_580557 = validateParameter(valid_580557, JString, required = true,
                                 default = nil)
  if valid_580557 != nil:
    section.add "accountId", valid_580557
  var valid_580558 = path.getOrDefault("merchantId")
  valid_580558 = validateParameter(valid_580558, JString, required = true,
                                 default = nil)
  if valid_580558 != nil:
    section.add "merchantId", valid_580558
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
  var valid_580559 = query.getOrDefault("fields")
  valid_580559 = validateParameter(valid_580559, JString, required = false,
                                 default = nil)
  if valid_580559 != nil:
    section.add "fields", valid_580559
  var valid_580560 = query.getOrDefault("quotaUser")
  valid_580560 = validateParameter(valid_580560, JString, required = false,
                                 default = nil)
  if valid_580560 != nil:
    section.add "quotaUser", valid_580560
  var valid_580561 = query.getOrDefault("alt")
  valid_580561 = validateParameter(valid_580561, JString, required = false,
                                 default = newJString("json"))
  if valid_580561 != nil:
    section.add "alt", valid_580561
  var valid_580562 = query.getOrDefault("oauth_token")
  valid_580562 = validateParameter(valid_580562, JString, required = false,
                                 default = nil)
  if valid_580562 != nil:
    section.add "oauth_token", valid_580562
  var valid_580563 = query.getOrDefault("userIp")
  valid_580563 = validateParameter(valid_580563, JString, required = false,
                                 default = nil)
  if valid_580563 != nil:
    section.add "userIp", valid_580563
  var valid_580564 = query.getOrDefault("key")
  valid_580564 = validateParameter(valid_580564, JString, required = false,
                                 default = nil)
  if valid_580564 != nil:
    section.add "key", valid_580564
  var valid_580565 = query.getOrDefault("prettyPrint")
  valid_580565 = validateParameter(valid_580565, JBool, required = false,
                                 default = newJBool(true))
  if valid_580565 != nil:
    section.add "prettyPrint", valid_580565
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

proc call*(call_580567: Call_ContentLiasettingsUpdate_580554; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the LIA settings of the account.
  ## 
  let valid = call_580567.validator(path, query, header, formData, body)
  let scheme = call_580567.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580567.url(scheme.get, call_580567.host, call_580567.base,
                         call_580567.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580567, url, valid)

proc call*(call_580568: Call_ContentLiasettingsUpdate_580554; accountId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentLiasettingsUpdate
  ## Updates the LIA settings of the account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The ID of the account for which to get or update LIA settings.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580569 = newJObject()
  var query_580570 = newJObject()
  var body_580571 = newJObject()
  add(query_580570, "fields", newJString(fields))
  add(query_580570, "quotaUser", newJString(quotaUser))
  add(query_580570, "alt", newJString(alt))
  add(query_580570, "oauth_token", newJString(oauthToken))
  add(path_580569, "accountId", newJString(accountId))
  add(query_580570, "userIp", newJString(userIp))
  add(query_580570, "key", newJString(key))
  add(path_580569, "merchantId", newJString(merchantId))
  if body != nil:
    body_580571 = body
  add(query_580570, "prettyPrint", newJBool(prettyPrint))
  result = call_580568.call(path_580569, query_580570, nil, nil, body_580571)

var contentLiasettingsUpdate* = Call_ContentLiasettingsUpdate_580554(
    name: "contentLiasettingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}",
    validator: validate_ContentLiasettingsUpdate_580555, base: "/content/v2.1",
    url: url_ContentLiasettingsUpdate_580556, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsGet_580538 = ref object of OpenApiRestCall_579421
proc url_ContentLiasettingsGet_580540(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/liasettings/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentLiasettingsGet_580539(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the LIA settings of the account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The ID of the account for which to get or update LIA settings.
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580541 = path.getOrDefault("accountId")
  valid_580541 = validateParameter(valid_580541, JString, required = true,
                                 default = nil)
  if valid_580541 != nil:
    section.add "accountId", valid_580541
  var valid_580542 = path.getOrDefault("merchantId")
  valid_580542 = validateParameter(valid_580542, JString, required = true,
                                 default = nil)
  if valid_580542 != nil:
    section.add "merchantId", valid_580542
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
  var valid_580543 = query.getOrDefault("fields")
  valid_580543 = validateParameter(valid_580543, JString, required = false,
                                 default = nil)
  if valid_580543 != nil:
    section.add "fields", valid_580543
  var valid_580544 = query.getOrDefault("quotaUser")
  valid_580544 = validateParameter(valid_580544, JString, required = false,
                                 default = nil)
  if valid_580544 != nil:
    section.add "quotaUser", valid_580544
  var valid_580545 = query.getOrDefault("alt")
  valid_580545 = validateParameter(valid_580545, JString, required = false,
                                 default = newJString("json"))
  if valid_580545 != nil:
    section.add "alt", valid_580545
  var valid_580546 = query.getOrDefault("oauth_token")
  valid_580546 = validateParameter(valid_580546, JString, required = false,
                                 default = nil)
  if valid_580546 != nil:
    section.add "oauth_token", valid_580546
  var valid_580547 = query.getOrDefault("userIp")
  valid_580547 = validateParameter(valid_580547, JString, required = false,
                                 default = nil)
  if valid_580547 != nil:
    section.add "userIp", valid_580547
  var valid_580548 = query.getOrDefault("key")
  valid_580548 = validateParameter(valid_580548, JString, required = false,
                                 default = nil)
  if valid_580548 != nil:
    section.add "key", valid_580548
  var valid_580549 = query.getOrDefault("prettyPrint")
  valid_580549 = validateParameter(valid_580549, JBool, required = false,
                                 default = newJBool(true))
  if valid_580549 != nil:
    section.add "prettyPrint", valid_580549
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580550: Call_ContentLiasettingsGet_580538; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the LIA settings of the account.
  ## 
  let valid = call_580550.validator(path, query, header, formData, body)
  let scheme = call_580550.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580550.url(scheme.get, call_580550.host, call_580550.base,
                         call_580550.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580550, url, valid)

proc call*(call_580551: Call_ContentLiasettingsGet_580538; accountId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentLiasettingsGet
  ## Retrieves the LIA settings of the account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The ID of the account for which to get or update LIA settings.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580552 = newJObject()
  var query_580553 = newJObject()
  add(query_580553, "fields", newJString(fields))
  add(query_580553, "quotaUser", newJString(quotaUser))
  add(query_580553, "alt", newJString(alt))
  add(query_580553, "oauth_token", newJString(oauthToken))
  add(path_580552, "accountId", newJString(accountId))
  add(query_580553, "userIp", newJString(userIp))
  add(query_580553, "key", newJString(key))
  add(path_580552, "merchantId", newJString(merchantId))
  add(query_580553, "prettyPrint", newJBool(prettyPrint))
  result = call_580551.call(path_580552, query_580553, nil, nil, nil)

var contentLiasettingsGet* = Call_ContentLiasettingsGet_580538(
    name: "contentLiasettingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}",
    validator: validate_ContentLiasettingsGet_580539, base: "/content/v2.1",
    url: url_ContentLiasettingsGet_580540, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsGetaccessiblegmbaccounts_580572 = ref object of OpenApiRestCall_579421
proc url_ContentLiasettingsGetaccessiblegmbaccounts_580574(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/liasettings/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/accessiblegmbaccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentLiasettingsGetaccessiblegmbaccounts_580573(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of accessible Google My Business accounts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The ID of the account for which to retrieve accessible Google My Business accounts.
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580575 = path.getOrDefault("accountId")
  valid_580575 = validateParameter(valid_580575, JString, required = true,
                                 default = nil)
  if valid_580575 != nil:
    section.add "accountId", valid_580575
  var valid_580576 = path.getOrDefault("merchantId")
  valid_580576 = validateParameter(valid_580576, JString, required = true,
                                 default = nil)
  if valid_580576 != nil:
    section.add "merchantId", valid_580576
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
  var valid_580577 = query.getOrDefault("fields")
  valid_580577 = validateParameter(valid_580577, JString, required = false,
                                 default = nil)
  if valid_580577 != nil:
    section.add "fields", valid_580577
  var valid_580578 = query.getOrDefault("quotaUser")
  valid_580578 = validateParameter(valid_580578, JString, required = false,
                                 default = nil)
  if valid_580578 != nil:
    section.add "quotaUser", valid_580578
  var valid_580579 = query.getOrDefault("alt")
  valid_580579 = validateParameter(valid_580579, JString, required = false,
                                 default = newJString("json"))
  if valid_580579 != nil:
    section.add "alt", valid_580579
  var valid_580580 = query.getOrDefault("oauth_token")
  valid_580580 = validateParameter(valid_580580, JString, required = false,
                                 default = nil)
  if valid_580580 != nil:
    section.add "oauth_token", valid_580580
  var valid_580581 = query.getOrDefault("userIp")
  valid_580581 = validateParameter(valid_580581, JString, required = false,
                                 default = nil)
  if valid_580581 != nil:
    section.add "userIp", valid_580581
  var valid_580582 = query.getOrDefault("key")
  valid_580582 = validateParameter(valid_580582, JString, required = false,
                                 default = nil)
  if valid_580582 != nil:
    section.add "key", valid_580582
  var valid_580583 = query.getOrDefault("prettyPrint")
  valid_580583 = validateParameter(valid_580583, JBool, required = false,
                                 default = newJBool(true))
  if valid_580583 != nil:
    section.add "prettyPrint", valid_580583
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580584: Call_ContentLiasettingsGetaccessiblegmbaccounts_580572;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of accessible Google My Business accounts.
  ## 
  let valid = call_580584.validator(path, query, header, formData, body)
  let scheme = call_580584.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580584.url(scheme.get, call_580584.host, call_580584.base,
                         call_580584.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580584, url, valid)

proc call*(call_580585: Call_ContentLiasettingsGetaccessiblegmbaccounts_580572;
          accountId: string; merchantId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentLiasettingsGetaccessiblegmbaccounts
  ## Retrieves the list of accessible Google My Business accounts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The ID of the account for which to retrieve accessible Google My Business accounts.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580586 = newJObject()
  var query_580587 = newJObject()
  add(query_580587, "fields", newJString(fields))
  add(query_580587, "quotaUser", newJString(quotaUser))
  add(query_580587, "alt", newJString(alt))
  add(query_580587, "oauth_token", newJString(oauthToken))
  add(path_580586, "accountId", newJString(accountId))
  add(query_580587, "userIp", newJString(userIp))
  add(query_580587, "key", newJString(key))
  add(path_580586, "merchantId", newJString(merchantId))
  add(query_580587, "prettyPrint", newJBool(prettyPrint))
  result = call_580585.call(path_580586, query_580587, nil, nil, nil)

var contentLiasettingsGetaccessiblegmbaccounts* = Call_ContentLiasettingsGetaccessiblegmbaccounts_580572(
    name: "contentLiasettingsGetaccessiblegmbaccounts", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/accessiblegmbaccounts",
    validator: validate_ContentLiasettingsGetaccessiblegmbaccounts_580573,
    base: "/content/v2.1", url: url_ContentLiasettingsGetaccessiblegmbaccounts_580574,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsRequestgmbaccess_580588 = ref object of OpenApiRestCall_579421
proc url_ContentLiasettingsRequestgmbaccess_580590(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/liasettings/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/requestgmbaccess")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentLiasettingsRequestgmbaccess_580589(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Requests access to a specified Google My Business account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The ID of the account for which GMB access is requested.
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580591 = path.getOrDefault("accountId")
  valid_580591 = validateParameter(valid_580591, JString, required = true,
                                 default = nil)
  if valid_580591 != nil:
    section.add "accountId", valid_580591
  var valid_580592 = path.getOrDefault("merchantId")
  valid_580592 = validateParameter(valid_580592, JString, required = true,
                                 default = nil)
  if valid_580592 != nil:
    section.add "merchantId", valid_580592
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
  ##   gmbEmail: JString (required)
  ##           : The email of the Google My Business account.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580593 = query.getOrDefault("fields")
  valid_580593 = validateParameter(valid_580593, JString, required = false,
                                 default = nil)
  if valid_580593 != nil:
    section.add "fields", valid_580593
  var valid_580594 = query.getOrDefault("quotaUser")
  valid_580594 = validateParameter(valid_580594, JString, required = false,
                                 default = nil)
  if valid_580594 != nil:
    section.add "quotaUser", valid_580594
  var valid_580595 = query.getOrDefault("alt")
  valid_580595 = validateParameter(valid_580595, JString, required = false,
                                 default = newJString("json"))
  if valid_580595 != nil:
    section.add "alt", valid_580595
  var valid_580596 = query.getOrDefault("oauth_token")
  valid_580596 = validateParameter(valid_580596, JString, required = false,
                                 default = nil)
  if valid_580596 != nil:
    section.add "oauth_token", valid_580596
  var valid_580597 = query.getOrDefault("userIp")
  valid_580597 = validateParameter(valid_580597, JString, required = false,
                                 default = nil)
  if valid_580597 != nil:
    section.add "userIp", valid_580597
  var valid_580598 = query.getOrDefault("key")
  valid_580598 = validateParameter(valid_580598, JString, required = false,
                                 default = nil)
  if valid_580598 != nil:
    section.add "key", valid_580598
  assert query != nil,
        "query argument is necessary due to required `gmbEmail` field"
  var valid_580599 = query.getOrDefault("gmbEmail")
  valid_580599 = validateParameter(valid_580599, JString, required = true,
                                 default = nil)
  if valid_580599 != nil:
    section.add "gmbEmail", valid_580599
  var valid_580600 = query.getOrDefault("prettyPrint")
  valid_580600 = validateParameter(valid_580600, JBool, required = false,
                                 default = newJBool(true))
  if valid_580600 != nil:
    section.add "prettyPrint", valid_580600
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580601: Call_ContentLiasettingsRequestgmbaccess_580588;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests access to a specified Google My Business account.
  ## 
  let valid = call_580601.validator(path, query, header, formData, body)
  let scheme = call_580601.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580601.url(scheme.get, call_580601.host, call_580601.base,
                         call_580601.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580601, url, valid)

proc call*(call_580602: Call_ContentLiasettingsRequestgmbaccess_580588;
          accountId: string; gmbEmail: string; merchantId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## contentLiasettingsRequestgmbaccess
  ## Requests access to a specified Google My Business account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The ID of the account for which GMB access is requested.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   gmbEmail: string (required)
  ##           : The email of the Google My Business account.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580603 = newJObject()
  var query_580604 = newJObject()
  add(query_580604, "fields", newJString(fields))
  add(query_580604, "quotaUser", newJString(quotaUser))
  add(query_580604, "alt", newJString(alt))
  add(query_580604, "oauth_token", newJString(oauthToken))
  add(path_580603, "accountId", newJString(accountId))
  add(query_580604, "userIp", newJString(userIp))
  add(query_580604, "key", newJString(key))
  add(query_580604, "gmbEmail", newJString(gmbEmail))
  add(path_580603, "merchantId", newJString(merchantId))
  add(query_580604, "prettyPrint", newJBool(prettyPrint))
  result = call_580602.call(path_580603, query_580604, nil, nil, nil)

var contentLiasettingsRequestgmbaccess* = Call_ContentLiasettingsRequestgmbaccess_580588(
    name: "contentLiasettingsRequestgmbaccess", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/requestgmbaccess",
    validator: validate_ContentLiasettingsRequestgmbaccess_580589,
    base: "/content/v2.1", url: url_ContentLiasettingsRequestgmbaccess_580590,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsRequestinventoryverification_580605 = ref object of OpenApiRestCall_579421
proc url_ContentLiasettingsRequestinventoryverification_580607(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "country" in path, "`country` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/liasettings/"),
               (kind: VariableSegment, value: "accountId"), (kind: ConstantSegment,
        value: "/requestinventoryverification/"),
               (kind: VariableSegment, value: "country")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentLiasettingsRequestinventoryverification_580606(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Requests inventory validation for the specified country.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   country: JString (required)
  ##          : The country for which inventory validation is requested.
  ##   accountId: JString (required)
  ##            : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `country` field"
  var valid_580608 = path.getOrDefault("country")
  valid_580608 = validateParameter(valid_580608, JString, required = true,
                                 default = nil)
  if valid_580608 != nil:
    section.add "country", valid_580608
  var valid_580609 = path.getOrDefault("accountId")
  valid_580609 = validateParameter(valid_580609, JString, required = true,
                                 default = nil)
  if valid_580609 != nil:
    section.add "accountId", valid_580609
  var valid_580610 = path.getOrDefault("merchantId")
  valid_580610 = validateParameter(valid_580610, JString, required = true,
                                 default = nil)
  if valid_580610 != nil:
    section.add "merchantId", valid_580610
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
  var valid_580611 = query.getOrDefault("fields")
  valid_580611 = validateParameter(valid_580611, JString, required = false,
                                 default = nil)
  if valid_580611 != nil:
    section.add "fields", valid_580611
  var valid_580612 = query.getOrDefault("quotaUser")
  valid_580612 = validateParameter(valid_580612, JString, required = false,
                                 default = nil)
  if valid_580612 != nil:
    section.add "quotaUser", valid_580612
  var valid_580613 = query.getOrDefault("alt")
  valid_580613 = validateParameter(valid_580613, JString, required = false,
                                 default = newJString("json"))
  if valid_580613 != nil:
    section.add "alt", valid_580613
  var valid_580614 = query.getOrDefault("oauth_token")
  valid_580614 = validateParameter(valid_580614, JString, required = false,
                                 default = nil)
  if valid_580614 != nil:
    section.add "oauth_token", valid_580614
  var valid_580615 = query.getOrDefault("userIp")
  valid_580615 = validateParameter(valid_580615, JString, required = false,
                                 default = nil)
  if valid_580615 != nil:
    section.add "userIp", valid_580615
  var valid_580616 = query.getOrDefault("key")
  valid_580616 = validateParameter(valid_580616, JString, required = false,
                                 default = nil)
  if valid_580616 != nil:
    section.add "key", valid_580616
  var valid_580617 = query.getOrDefault("prettyPrint")
  valid_580617 = validateParameter(valid_580617, JBool, required = false,
                                 default = newJBool(true))
  if valid_580617 != nil:
    section.add "prettyPrint", valid_580617
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580618: Call_ContentLiasettingsRequestinventoryverification_580605;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests inventory validation for the specified country.
  ## 
  let valid = call_580618.validator(path, query, header, formData, body)
  let scheme = call_580618.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580618.url(scheme.get, call_580618.host, call_580618.base,
                         call_580618.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580618, url, valid)

proc call*(call_580619: Call_ContentLiasettingsRequestinventoryverification_580605;
          country: string; accountId: string; merchantId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentLiasettingsRequestinventoryverification
  ## Requests inventory validation for the specified country.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   country: string (required)
  ##          : The country for which inventory validation is requested.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580620 = newJObject()
  var query_580621 = newJObject()
  add(query_580621, "fields", newJString(fields))
  add(query_580621, "quotaUser", newJString(quotaUser))
  add(query_580621, "alt", newJString(alt))
  add(path_580620, "country", newJString(country))
  add(query_580621, "oauth_token", newJString(oauthToken))
  add(path_580620, "accountId", newJString(accountId))
  add(query_580621, "userIp", newJString(userIp))
  add(query_580621, "key", newJString(key))
  add(path_580620, "merchantId", newJString(merchantId))
  add(query_580621, "prettyPrint", newJBool(prettyPrint))
  result = call_580619.call(path_580620, query_580621, nil, nil, nil)

var contentLiasettingsRequestinventoryverification* = Call_ContentLiasettingsRequestinventoryverification_580605(
    name: "contentLiasettingsRequestinventoryverification",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}/requestinventoryverification/{country}",
    validator: validate_ContentLiasettingsRequestinventoryverification_580606,
    base: "/content/v2.1",
    url: url_ContentLiasettingsRequestinventoryverification_580607,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsSetinventoryverificationcontact_580622 = ref object of OpenApiRestCall_579421
proc url_ContentLiasettingsSetinventoryverificationcontact_580624(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/liasettings/"),
               (kind: VariableSegment, value: "accountId"), (kind: ConstantSegment,
        value: "/setinventoryverificationcontact")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentLiasettingsSetinventoryverificationcontact_580623(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the inventory verification contract for the specified country.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580625 = path.getOrDefault("accountId")
  valid_580625 = validateParameter(valid_580625, JString, required = true,
                                 default = nil)
  if valid_580625 != nil:
    section.add "accountId", valid_580625
  var valid_580626 = path.getOrDefault("merchantId")
  valid_580626 = validateParameter(valid_580626, JString, required = true,
                                 default = nil)
  if valid_580626 != nil:
    section.add "merchantId", valid_580626
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   country: JString (required)
  ##          : The country for which inventory verification is requested.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   contactName: JString (required)
  ##              : The name of the inventory verification contact.
  ##   language: JString (required)
  ##           : The language for which inventory verification is requested.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   contactEmail: JString (required)
  ##               : The email of the inventory verification contact.
  section = newJObject()
  var valid_580627 = query.getOrDefault("fields")
  valid_580627 = validateParameter(valid_580627, JString, required = false,
                                 default = nil)
  if valid_580627 != nil:
    section.add "fields", valid_580627
  assert query != nil, "query argument is necessary due to required `country` field"
  var valid_580628 = query.getOrDefault("country")
  valid_580628 = validateParameter(valid_580628, JString, required = true,
                                 default = nil)
  if valid_580628 != nil:
    section.add "country", valid_580628
  var valid_580629 = query.getOrDefault("quotaUser")
  valid_580629 = validateParameter(valid_580629, JString, required = false,
                                 default = nil)
  if valid_580629 != nil:
    section.add "quotaUser", valid_580629
  var valid_580630 = query.getOrDefault("alt")
  valid_580630 = validateParameter(valid_580630, JString, required = false,
                                 default = newJString("json"))
  if valid_580630 != nil:
    section.add "alt", valid_580630
  var valid_580631 = query.getOrDefault("contactName")
  valid_580631 = validateParameter(valid_580631, JString, required = true,
                                 default = nil)
  if valid_580631 != nil:
    section.add "contactName", valid_580631
  var valid_580632 = query.getOrDefault("language")
  valid_580632 = validateParameter(valid_580632, JString, required = true,
                                 default = nil)
  if valid_580632 != nil:
    section.add "language", valid_580632
  var valid_580633 = query.getOrDefault("oauth_token")
  valid_580633 = validateParameter(valid_580633, JString, required = false,
                                 default = nil)
  if valid_580633 != nil:
    section.add "oauth_token", valid_580633
  var valid_580634 = query.getOrDefault("userIp")
  valid_580634 = validateParameter(valid_580634, JString, required = false,
                                 default = nil)
  if valid_580634 != nil:
    section.add "userIp", valid_580634
  var valid_580635 = query.getOrDefault("key")
  valid_580635 = validateParameter(valid_580635, JString, required = false,
                                 default = nil)
  if valid_580635 != nil:
    section.add "key", valid_580635
  var valid_580636 = query.getOrDefault("prettyPrint")
  valid_580636 = validateParameter(valid_580636, JBool, required = false,
                                 default = newJBool(true))
  if valid_580636 != nil:
    section.add "prettyPrint", valid_580636
  var valid_580637 = query.getOrDefault("contactEmail")
  valid_580637 = validateParameter(valid_580637, JString, required = true,
                                 default = nil)
  if valid_580637 != nil:
    section.add "contactEmail", valid_580637
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580638: Call_ContentLiasettingsSetinventoryverificationcontact_580622;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the inventory verification contract for the specified country.
  ## 
  let valid = call_580638.validator(path, query, header, formData, body)
  let scheme = call_580638.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580638.url(scheme.get, call_580638.host, call_580638.base,
                         call_580638.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580638, url, valid)

proc call*(call_580639: Call_ContentLiasettingsSetinventoryverificationcontact_580622;
          country: string; contactName: string; language: string; accountId: string;
          merchantId: string; contactEmail: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentLiasettingsSetinventoryverificationcontact
  ## Sets the inventory verification contract for the specified country.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   country: string (required)
  ##          : The country for which inventory verification is requested.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   contactName: string (required)
  ##              : The name of the inventory verification contact.
  ##   language: string (required)
  ##           : The language for which inventory verification is requested.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   contactEmail: string (required)
  ##               : The email of the inventory verification contact.
  var path_580640 = newJObject()
  var query_580641 = newJObject()
  add(query_580641, "fields", newJString(fields))
  add(query_580641, "country", newJString(country))
  add(query_580641, "quotaUser", newJString(quotaUser))
  add(query_580641, "alt", newJString(alt))
  add(query_580641, "contactName", newJString(contactName))
  add(query_580641, "language", newJString(language))
  add(query_580641, "oauth_token", newJString(oauthToken))
  add(path_580640, "accountId", newJString(accountId))
  add(query_580641, "userIp", newJString(userIp))
  add(query_580641, "key", newJString(key))
  add(path_580640, "merchantId", newJString(merchantId))
  add(query_580641, "prettyPrint", newJBool(prettyPrint))
  add(query_580641, "contactEmail", newJString(contactEmail))
  result = call_580639.call(path_580640, query_580641, nil, nil, nil)

var contentLiasettingsSetinventoryverificationcontact* = Call_ContentLiasettingsSetinventoryverificationcontact_580622(
    name: "contentLiasettingsSetinventoryverificationcontact",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}/setinventoryverificationcontact",
    validator: validate_ContentLiasettingsSetinventoryverificationcontact_580623,
    base: "/content/v2.1",
    url: url_ContentLiasettingsSetinventoryverificationcontact_580624,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsSetposdataprovider_580642 = ref object of OpenApiRestCall_579421
proc url_ContentLiasettingsSetposdataprovider_580644(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/liasettings/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/setposdataprovider")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentLiasettingsSetposdataprovider_580643(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the POS data provider for the specified country.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The ID of the account for which to retrieve accessible Google My Business accounts.
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580645 = path.getOrDefault("accountId")
  valid_580645 = validateParameter(valid_580645, JString, required = true,
                                 default = nil)
  if valid_580645 != nil:
    section.add "accountId", valid_580645
  var valid_580646 = path.getOrDefault("merchantId")
  valid_580646 = validateParameter(valid_580646, JString, required = true,
                                 default = nil)
  if valid_580646 != nil:
    section.add "merchantId", valid_580646
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   country: JString (required)
  ##          : The country for which the POS data provider is selected.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   posExternalAccountId: JString
  ##                       : The account ID by which this merchant is known to the POS data provider.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   posDataProviderId: JString
  ##                    : The ID of POS data provider.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580647 = query.getOrDefault("fields")
  valid_580647 = validateParameter(valid_580647, JString, required = false,
                                 default = nil)
  if valid_580647 != nil:
    section.add "fields", valid_580647
  assert query != nil, "query argument is necessary due to required `country` field"
  var valid_580648 = query.getOrDefault("country")
  valid_580648 = validateParameter(valid_580648, JString, required = true,
                                 default = nil)
  if valid_580648 != nil:
    section.add "country", valid_580648
  var valid_580649 = query.getOrDefault("quotaUser")
  valid_580649 = validateParameter(valid_580649, JString, required = false,
                                 default = nil)
  if valid_580649 != nil:
    section.add "quotaUser", valid_580649
  var valid_580650 = query.getOrDefault("alt")
  valid_580650 = validateParameter(valid_580650, JString, required = false,
                                 default = newJString("json"))
  if valid_580650 != nil:
    section.add "alt", valid_580650
  var valid_580651 = query.getOrDefault("oauth_token")
  valid_580651 = validateParameter(valid_580651, JString, required = false,
                                 default = nil)
  if valid_580651 != nil:
    section.add "oauth_token", valid_580651
  var valid_580652 = query.getOrDefault("userIp")
  valid_580652 = validateParameter(valid_580652, JString, required = false,
                                 default = nil)
  if valid_580652 != nil:
    section.add "userIp", valid_580652
  var valid_580653 = query.getOrDefault("posExternalAccountId")
  valid_580653 = validateParameter(valid_580653, JString, required = false,
                                 default = nil)
  if valid_580653 != nil:
    section.add "posExternalAccountId", valid_580653
  var valid_580654 = query.getOrDefault("key")
  valid_580654 = validateParameter(valid_580654, JString, required = false,
                                 default = nil)
  if valid_580654 != nil:
    section.add "key", valid_580654
  var valid_580655 = query.getOrDefault("posDataProviderId")
  valid_580655 = validateParameter(valid_580655, JString, required = false,
                                 default = nil)
  if valid_580655 != nil:
    section.add "posDataProviderId", valid_580655
  var valid_580656 = query.getOrDefault("prettyPrint")
  valid_580656 = validateParameter(valid_580656, JBool, required = false,
                                 default = newJBool(true))
  if valid_580656 != nil:
    section.add "prettyPrint", valid_580656
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580657: Call_ContentLiasettingsSetposdataprovider_580642;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the POS data provider for the specified country.
  ## 
  let valid = call_580657.validator(path, query, header, formData, body)
  let scheme = call_580657.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580657.url(scheme.get, call_580657.host, call_580657.base,
                         call_580657.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580657, url, valid)

proc call*(call_580658: Call_ContentLiasettingsSetposdataprovider_580642;
          country: string; accountId: string; merchantId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; posExternalAccountId: string = ""; key: string = "";
          posDataProviderId: string = ""; prettyPrint: bool = true): Recallable =
  ## contentLiasettingsSetposdataprovider
  ## Sets the POS data provider for the specified country.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   country: string (required)
  ##          : The country for which the POS data provider is selected.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The ID of the account for which to retrieve accessible Google My Business accounts.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   posExternalAccountId: string
  ##                       : The account ID by which this merchant is known to the POS data provider.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   posDataProviderId: string
  ##                    : The ID of POS data provider.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580659 = newJObject()
  var query_580660 = newJObject()
  add(query_580660, "fields", newJString(fields))
  add(query_580660, "country", newJString(country))
  add(query_580660, "quotaUser", newJString(quotaUser))
  add(query_580660, "alt", newJString(alt))
  add(query_580660, "oauth_token", newJString(oauthToken))
  add(path_580659, "accountId", newJString(accountId))
  add(query_580660, "userIp", newJString(userIp))
  add(query_580660, "posExternalAccountId", newJString(posExternalAccountId))
  add(query_580660, "key", newJString(key))
  add(query_580660, "posDataProviderId", newJString(posDataProviderId))
  add(path_580659, "merchantId", newJString(merchantId))
  add(query_580660, "prettyPrint", newJBool(prettyPrint))
  result = call_580658.call(path_580659, query_580660, nil, nil, nil)

var contentLiasettingsSetposdataprovider* = Call_ContentLiasettingsSetposdataprovider_580642(
    name: "contentLiasettingsSetposdataprovider", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/setposdataprovider",
    validator: validate_ContentLiasettingsSetposdataprovider_580643,
    base: "/content/v2.1", url: url_ContentLiasettingsSetposdataprovider_580644,
    schemes: {Scheme.Https})
type
  Call_ContentOrderinvoicesCreatechargeinvoice_580661 = ref object of OpenApiRestCall_579421
proc url_ContentOrderinvoicesCreatechargeinvoice_580663(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orderinvoices/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/createChargeInvoice")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrderinvoicesCreatechargeinvoice_580662(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a charge invoice for a shipment group, and triggers a charge capture for orderinvoice enabled orders.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   orderId: JString (required)
  ##          : The ID of the order.
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `orderId` field"
  var valid_580664 = path.getOrDefault("orderId")
  valid_580664 = validateParameter(valid_580664, JString, required = true,
                                 default = nil)
  if valid_580664 != nil:
    section.add "orderId", valid_580664
  var valid_580665 = path.getOrDefault("merchantId")
  valid_580665 = validateParameter(valid_580665, JString, required = true,
                                 default = nil)
  if valid_580665 != nil:
    section.add "merchantId", valid_580665
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
  var valid_580666 = query.getOrDefault("fields")
  valid_580666 = validateParameter(valid_580666, JString, required = false,
                                 default = nil)
  if valid_580666 != nil:
    section.add "fields", valid_580666
  var valid_580667 = query.getOrDefault("quotaUser")
  valid_580667 = validateParameter(valid_580667, JString, required = false,
                                 default = nil)
  if valid_580667 != nil:
    section.add "quotaUser", valid_580667
  var valid_580668 = query.getOrDefault("alt")
  valid_580668 = validateParameter(valid_580668, JString, required = false,
                                 default = newJString("json"))
  if valid_580668 != nil:
    section.add "alt", valid_580668
  var valid_580669 = query.getOrDefault("oauth_token")
  valid_580669 = validateParameter(valid_580669, JString, required = false,
                                 default = nil)
  if valid_580669 != nil:
    section.add "oauth_token", valid_580669
  var valid_580670 = query.getOrDefault("userIp")
  valid_580670 = validateParameter(valid_580670, JString, required = false,
                                 default = nil)
  if valid_580670 != nil:
    section.add "userIp", valid_580670
  var valid_580671 = query.getOrDefault("key")
  valid_580671 = validateParameter(valid_580671, JString, required = false,
                                 default = nil)
  if valid_580671 != nil:
    section.add "key", valid_580671
  var valid_580672 = query.getOrDefault("prettyPrint")
  valid_580672 = validateParameter(valid_580672, JBool, required = false,
                                 default = newJBool(true))
  if valid_580672 != nil:
    section.add "prettyPrint", valid_580672
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

proc call*(call_580674: Call_ContentOrderinvoicesCreatechargeinvoice_580661;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a charge invoice for a shipment group, and triggers a charge capture for orderinvoice enabled orders.
  ## 
  let valid = call_580674.validator(path, query, header, formData, body)
  let scheme = call_580674.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580674.url(scheme.get, call_580674.host, call_580674.base,
                         call_580674.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580674, url, valid)

proc call*(call_580675: Call_ContentOrderinvoicesCreatechargeinvoice_580661;
          orderId: string; merchantId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## contentOrderinvoicesCreatechargeinvoice
  ## Creates a charge invoice for a shipment group, and triggers a charge capture for orderinvoice enabled orders.
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
  ##   orderId: string (required)
  ##          : The ID of the order.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580676 = newJObject()
  var query_580677 = newJObject()
  var body_580678 = newJObject()
  add(query_580677, "fields", newJString(fields))
  add(query_580677, "quotaUser", newJString(quotaUser))
  add(query_580677, "alt", newJString(alt))
  add(query_580677, "oauth_token", newJString(oauthToken))
  add(query_580677, "userIp", newJString(userIp))
  add(path_580676, "orderId", newJString(orderId))
  add(query_580677, "key", newJString(key))
  add(path_580676, "merchantId", newJString(merchantId))
  if body != nil:
    body_580678 = body
  add(query_580677, "prettyPrint", newJBool(prettyPrint))
  result = call_580675.call(path_580676, query_580677, nil, nil, body_580678)

var contentOrderinvoicesCreatechargeinvoice* = Call_ContentOrderinvoicesCreatechargeinvoice_580661(
    name: "contentOrderinvoicesCreatechargeinvoice", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderinvoices/{orderId}/createChargeInvoice",
    validator: validate_ContentOrderinvoicesCreatechargeinvoice_580662,
    base: "/content/v2.1", url: url_ContentOrderinvoicesCreatechargeinvoice_580663,
    schemes: {Scheme.Https})
type
  Call_ContentOrderinvoicesCreaterefundinvoice_580679 = ref object of OpenApiRestCall_579421
proc url_ContentOrderinvoicesCreaterefundinvoice_580681(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orderinvoices/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/createRefundInvoice")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrderinvoicesCreaterefundinvoice_580680(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a refund invoice for one or more shipment groups, and triggers a refund for orderinvoice enabled orders. This can only be used for line items that have previously been charged using createChargeInvoice. All amounts (except for the summary) are incremental with respect to the previous invoice.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   orderId: JString (required)
  ##          : The ID of the order.
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `orderId` field"
  var valid_580682 = path.getOrDefault("orderId")
  valid_580682 = validateParameter(valid_580682, JString, required = true,
                                 default = nil)
  if valid_580682 != nil:
    section.add "orderId", valid_580682
  var valid_580683 = path.getOrDefault("merchantId")
  valid_580683 = validateParameter(valid_580683, JString, required = true,
                                 default = nil)
  if valid_580683 != nil:
    section.add "merchantId", valid_580683
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
  var valid_580684 = query.getOrDefault("fields")
  valid_580684 = validateParameter(valid_580684, JString, required = false,
                                 default = nil)
  if valid_580684 != nil:
    section.add "fields", valid_580684
  var valid_580685 = query.getOrDefault("quotaUser")
  valid_580685 = validateParameter(valid_580685, JString, required = false,
                                 default = nil)
  if valid_580685 != nil:
    section.add "quotaUser", valid_580685
  var valid_580686 = query.getOrDefault("alt")
  valid_580686 = validateParameter(valid_580686, JString, required = false,
                                 default = newJString("json"))
  if valid_580686 != nil:
    section.add "alt", valid_580686
  var valid_580687 = query.getOrDefault("oauth_token")
  valid_580687 = validateParameter(valid_580687, JString, required = false,
                                 default = nil)
  if valid_580687 != nil:
    section.add "oauth_token", valid_580687
  var valid_580688 = query.getOrDefault("userIp")
  valid_580688 = validateParameter(valid_580688, JString, required = false,
                                 default = nil)
  if valid_580688 != nil:
    section.add "userIp", valid_580688
  var valid_580689 = query.getOrDefault("key")
  valid_580689 = validateParameter(valid_580689, JString, required = false,
                                 default = nil)
  if valid_580689 != nil:
    section.add "key", valid_580689
  var valid_580690 = query.getOrDefault("prettyPrint")
  valid_580690 = validateParameter(valid_580690, JBool, required = false,
                                 default = newJBool(true))
  if valid_580690 != nil:
    section.add "prettyPrint", valid_580690
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

proc call*(call_580692: Call_ContentOrderinvoicesCreaterefundinvoice_580679;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a refund invoice for one or more shipment groups, and triggers a refund for orderinvoice enabled orders. This can only be used for line items that have previously been charged using createChargeInvoice. All amounts (except for the summary) are incremental with respect to the previous invoice.
  ## 
  let valid = call_580692.validator(path, query, header, formData, body)
  let scheme = call_580692.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580692.url(scheme.get, call_580692.host, call_580692.base,
                         call_580692.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580692, url, valid)

proc call*(call_580693: Call_ContentOrderinvoicesCreaterefundinvoice_580679;
          orderId: string; merchantId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## contentOrderinvoicesCreaterefundinvoice
  ## Creates a refund invoice for one or more shipment groups, and triggers a refund for orderinvoice enabled orders. This can only be used for line items that have previously been charged using createChargeInvoice. All amounts (except for the summary) are incremental with respect to the previous invoice.
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
  ##   orderId: string (required)
  ##          : The ID of the order.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580694 = newJObject()
  var query_580695 = newJObject()
  var body_580696 = newJObject()
  add(query_580695, "fields", newJString(fields))
  add(query_580695, "quotaUser", newJString(quotaUser))
  add(query_580695, "alt", newJString(alt))
  add(query_580695, "oauth_token", newJString(oauthToken))
  add(query_580695, "userIp", newJString(userIp))
  add(path_580694, "orderId", newJString(orderId))
  add(query_580695, "key", newJString(key))
  add(path_580694, "merchantId", newJString(merchantId))
  if body != nil:
    body_580696 = body
  add(query_580695, "prettyPrint", newJBool(prettyPrint))
  result = call_580693.call(path_580694, query_580695, nil, nil, body_580696)

var contentOrderinvoicesCreaterefundinvoice* = Call_ContentOrderinvoicesCreaterefundinvoice_580679(
    name: "contentOrderinvoicesCreaterefundinvoice", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderinvoices/{orderId}/createRefundInvoice",
    validator: validate_ContentOrderinvoicesCreaterefundinvoice_580680,
    base: "/content/v2.1", url: url_ContentOrderinvoicesCreaterefundinvoice_580681,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreportsListdisbursements_580697 = ref object of OpenApiRestCall_579421
proc url_ContentOrderreportsListdisbursements_580699(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orderreports/disbursements")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrderreportsListdisbursements_580698(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a report for disbursements from your Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580700 = path.getOrDefault("merchantId")
  valid_580700 = validateParameter(valid_580700, JString, required = true,
                                 default = nil)
  if valid_580700 != nil:
    section.add "merchantId", valid_580700
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of disbursements to return in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   disbursementStartDate: JString (required)
  ##                        : The first date which disbursements occurred. In ISO 8601 format.
  ##   disbursementEndDate: JString
  ##                      : The last date which disbursements occurred. In ISO 8601 format. Default: current date.
  section = newJObject()
  var valid_580701 = query.getOrDefault("fields")
  valid_580701 = validateParameter(valid_580701, JString, required = false,
                                 default = nil)
  if valid_580701 != nil:
    section.add "fields", valid_580701
  var valid_580702 = query.getOrDefault("pageToken")
  valid_580702 = validateParameter(valid_580702, JString, required = false,
                                 default = nil)
  if valid_580702 != nil:
    section.add "pageToken", valid_580702
  var valid_580703 = query.getOrDefault("quotaUser")
  valid_580703 = validateParameter(valid_580703, JString, required = false,
                                 default = nil)
  if valid_580703 != nil:
    section.add "quotaUser", valid_580703
  var valid_580704 = query.getOrDefault("alt")
  valid_580704 = validateParameter(valid_580704, JString, required = false,
                                 default = newJString("json"))
  if valid_580704 != nil:
    section.add "alt", valid_580704
  var valid_580705 = query.getOrDefault("oauth_token")
  valid_580705 = validateParameter(valid_580705, JString, required = false,
                                 default = nil)
  if valid_580705 != nil:
    section.add "oauth_token", valid_580705
  var valid_580706 = query.getOrDefault("userIp")
  valid_580706 = validateParameter(valid_580706, JString, required = false,
                                 default = nil)
  if valid_580706 != nil:
    section.add "userIp", valid_580706
  var valid_580707 = query.getOrDefault("maxResults")
  valid_580707 = validateParameter(valid_580707, JInt, required = false, default = nil)
  if valid_580707 != nil:
    section.add "maxResults", valid_580707
  var valid_580708 = query.getOrDefault("key")
  valid_580708 = validateParameter(valid_580708, JString, required = false,
                                 default = nil)
  if valid_580708 != nil:
    section.add "key", valid_580708
  var valid_580709 = query.getOrDefault("prettyPrint")
  valid_580709 = validateParameter(valid_580709, JBool, required = false,
                                 default = newJBool(true))
  if valid_580709 != nil:
    section.add "prettyPrint", valid_580709
  assert query != nil, "query argument is necessary due to required `disbursementStartDate` field"
  var valid_580710 = query.getOrDefault("disbursementStartDate")
  valid_580710 = validateParameter(valid_580710, JString, required = true,
                                 default = nil)
  if valid_580710 != nil:
    section.add "disbursementStartDate", valid_580710
  var valid_580711 = query.getOrDefault("disbursementEndDate")
  valid_580711 = validateParameter(valid_580711, JString, required = false,
                                 default = nil)
  if valid_580711 != nil:
    section.add "disbursementEndDate", valid_580711
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580712: Call_ContentOrderreportsListdisbursements_580697;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a report for disbursements from your Merchant Center account.
  ## 
  let valid = call_580712.validator(path, query, header, formData, body)
  let scheme = call_580712.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580712.url(scheme.get, call_580712.host, call_580712.base,
                         call_580712.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580712, url, valid)

proc call*(call_580713: Call_ContentOrderreportsListdisbursements_580697;
          merchantId: string; disbursementStartDate: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true; disbursementEndDate: string = ""): Recallable =
  ## contentOrderreportsListdisbursements
  ## Retrieves a report for disbursements from your Merchant Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of disbursements to return in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   disbursementStartDate: string (required)
  ##                        : The first date which disbursements occurred. In ISO 8601 format.
  ##   disbursementEndDate: string
  ##                      : The last date which disbursements occurred. In ISO 8601 format. Default: current date.
  var path_580714 = newJObject()
  var query_580715 = newJObject()
  add(query_580715, "fields", newJString(fields))
  add(query_580715, "pageToken", newJString(pageToken))
  add(query_580715, "quotaUser", newJString(quotaUser))
  add(query_580715, "alt", newJString(alt))
  add(query_580715, "oauth_token", newJString(oauthToken))
  add(query_580715, "userIp", newJString(userIp))
  add(query_580715, "maxResults", newJInt(maxResults))
  add(query_580715, "key", newJString(key))
  add(path_580714, "merchantId", newJString(merchantId))
  add(query_580715, "prettyPrint", newJBool(prettyPrint))
  add(query_580715, "disbursementStartDate", newJString(disbursementStartDate))
  add(query_580715, "disbursementEndDate", newJString(disbursementEndDate))
  result = call_580713.call(path_580714, query_580715, nil, nil, nil)

var contentOrderreportsListdisbursements* = Call_ContentOrderreportsListdisbursements_580697(
    name: "contentOrderreportsListdisbursements", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreports/disbursements",
    validator: validate_ContentOrderreportsListdisbursements_580698,
    base: "/content/v2.1", url: url_ContentOrderreportsListdisbursements_580699,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreportsListtransactions_580716 = ref object of OpenApiRestCall_579421
proc url_ContentOrderreportsListtransactions_580718(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "disbursementId" in path, "`disbursementId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orderreports/disbursements/"),
               (kind: VariableSegment, value: "disbursementId"),
               (kind: ConstantSegment, value: "/transactions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrderreportsListtransactions_580717(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of transactions for a disbursement from your Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   disbursementId: JString (required)
  ##                 : The Google-provided ID of the disbursement (found in Wallet).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580719 = path.getOrDefault("merchantId")
  valid_580719 = validateParameter(valid_580719, JString, required = true,
                                 default = nil)
  if valid_580719 != nil:
    section.add "merchantId", valid_580719
  var valid_580720 = path.getOrDefault("disbursementId")
  valid_580720 = validateParameter(valid_580720, JString, required = true,
                                 default = nil)
  if valid_580720 != nil:
    section.add "disbursementId", valid_580720
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   transactionEndDate: JString
  ##                     : The last date in which transaction occurred. In ISO 8601 format. Default: current date.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of disbursements to return in the response, used for paging.
  ##   transactionStartDate: JString (required)
  ##                       : The first date in which transaction occurred. In ISO 8601 format.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580721 = query.getOrDefault("fields")
  valid_580721 = validateParameter(valid_580721, JString, required = false,
                                 default = nil)
  if valid_580721 != nil:
    section.add "fields", valid_580721
  var valid_580722 = query.getOrDefault("pageToken")
  valid_580722 = validateParameter(valid_580722, JString, required = false,
                                 default = nil)
  if valid_580722 != nil:
    section.add "pageToken", valid_580722
  var valid_580723 = query.getOrDefault("quotaUser")
  valid_580723 = validateParameter(valid_580723, JString, required = false,
                                 default = nil)
  if valid_580723 != nil:
    section.add "quotaUser", valid_580723
  var valid_580724 = query.getOrDefault("alt")
  valid_580724 = validateParameter(valid_580724, JString, required = false,
                                 default = newJString("json"))
  if valid_580724 != nil:
    section.add "alt", valid_580724
  var valid_580725 = query.getOrDefault("transactionEndDate")
  valid_580725 = validateParameter(valid_580725, JString, required = false,
                                 default = nil)
  if valid_580725 != nil:
    section.add "transactionEndDate", valid_580725
  var valid_580726 = query.getOrDefault("oauth_token")
  valid_580726 = validateParameter(valid_580726, JString, required = false,
                                 default = nil)
  if valid_580726 != nil:
    section.add "oauth_token", valid_580726
  var valid_580727 = query.getOrDefault("userIp")
  valid_580727 = validateParameter(valid_580727, JString, required = false,
                                 default = nil)
  if valid_580727 != nil:
    section.add "userIp", valid_580727
  var valid_580728 = query.getOrDefault("maxResults")
  valid_580728 = validateParameter(valid_580728, JInt, required = false, default = nil)
  if valid_580728 != nil:
    section.add "maxResults", valid_580728
  assert query != nil, "query argument is necessary due to required `transactionStartDate` field"
  var valid_580729 = query.getOrDefault("transactionStartDate")
  valid_580729 = validateParameter(valid_580729, JString, required = true,
                                 default = nil)
  if valid_580729 != nil:
    section.add "transactionStartDate", valid_580729
  var valid_580730 = query.getOrDefault("key")
  valid_580730 = validateParameter(valid_580730, JString, required = false,
                                 default = nil)
  if valid_580730 != nil:
    section.add "key", valid_580730
  var valid_580731 = query.getOrDefault("prettyPrint")
  valid_580731 = validateParameter(valid_580731, JBool, required = false,
                                 default = newJBool(true))
  if valid_580731 != nil:
    section.add "prettyPrint", valid_580731
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580732: Call_ContentOrderreportsListtransactions_580716;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of transactions for a disbursement from your Merchant Center account.
  ## 
  let valid = call_580732.validator(path, query, header, formData, body)
  let scheme = call_580732.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580732.url(scheme.get, call_580732.host, call_580732.base,
                         call_580732.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580732, url, valid)

proc call*(call_580733: Call_ContentOrderreportsListtransactions_580716;
          transactionStartDate: string; merchantId: string; disbursementId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; transactionEndDate: string = "";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentOrderreportsListtransactions
  ## Retrieves a list of transactions for a disbursement from your Merchant Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   transactionEndDate: string
  ##                     : The last date in which transaction occurred. In ISO 8601 format. Default: current date.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of disbursements to return in the response, used for paging.
  ##   transactionStartDate: string (required)
  ##                       : The first date in which transaction occurred. In ISO 8601 format.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   disbursementId: string (required)
  ##                 : The Google-provided ID of the disbursement (found in Wallet).
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580734 = newJObject()
  var query_580735 = newJObject()
  add(query_580735, "fields", newJString(fields))
  add(query_580735, "pageToken", newJString(pageToken))
  add(query_580735, "quotaUser", newJString(quotaUser))
  add(query_580735, "alt", newJString(alt))
  add(query_580735, "transactionEndDate", newJString(transactionEndDate))
  add(query_580735, "oauth_token", newJString(oauthToken))
  add(query_580735, "userIp", newJString(userIp))
  add(query_580735, "maxResults", newJInt(maxResults))
  add(query_580735, "transactionStartDate", newJString(transactionStartDate))
  add(query_580735, "key", newJString(key))
  add(path_580734, "merchantId", newJString(merchantId))
  add(path_580734, "disbursementId", newJString(disbursementId))
  add(query_580735, "prettyPrint", newJBool(prettyPrint))
  result = call_580733.call(path_580734, query_580735, nil, nil, nil)

var contentOrderreportsListtransactions* = Call_ContentOrderreportsListtransactions_580716(
    name: "contentOrderreportsListtransactions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreports/disbursements/{disbursementId}/transactions",
    validator: validate_ContentOrderreportsListtransactions_580717,
    base: "/content/v2.1", url: url_ContentOrderreportsListtransactions_580718,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreturnsList_580736 = ref object of OpenApiRestCall_579421
proc url_ContentOrderreturnsList_580738(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orderreturns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrderreturnsList_580737(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists order returns in your Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580739 = path.getOrDefault("merchantId")
  valid_580739 = validateParameter(valid_580739, JString, required = true,
                                 default = nil)
  if valid_580739 != nil:
    section.add "merchantId", valid_580739
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of order returns to return in the response, used for paging. The default value is 25 returns per page, and the maximum allowed value is 250 returns per page.
  ##   orderBy: JString
  ##          : Return the results in the specified order.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   createdEndDate: JString
  ##                 : Obtains order returns created before this date (inclusively), in ISO 8601 format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   createdStartDate: JString
  ##                   : Obtains order returns created after this date (inclusively), in ISO 8601 format.
  section = newJObject()
  var valid_580740 = query.getOrDefault("fields")
  valid_580740 = validateParameter(valid_580740, JString, required = false,
                                 default = nil)
  if valid_580740 != nil:
    section.add "fields", valid_580740
  var valid_580741 = query.getOrDefault("pageToken")
  valid_580741 = validateParameter(valid_580741, JString, required = false,
                                 default = nil)
  if valid_580741 != nil:
    section.add "pageToken", valid_580741
  var valid_580742 = query.getOrDefault("quotaUser")
  valid_580742 = validateParameter(valid_580742, JString, required = false,
                                 default = nil)
  if valid_580742 != nil:
    section.add "quotaUser", valid_580742
  var valid_580743 = query.getOrDefault("alt")
  valid_580743 = validateParameter(valid_580743, JString, required = false,
                                 default = newJString("json"))
  if valid_580743 != nil:
    section.add "alt", valid_580743
  var valid_580744 = query.getOrDefault("oauth_token")
  valid_580744 = validateParameter(valid_580744, JString, required = false,
                                 default = nil)
  if valid_580744 != nil:
    section.add "oauth_token", valid_580744
  var valid_580745 = query.getOrDefault("userIp")
  valid_580745 = validateParameter(valid_580745, JString, required = false,
                                 default = nil)
  if valid_580745 != nil:
    section.add "userIp", valid_580745
  var valid_580746 = query.getOrDefault("maxResults")
  valid_580746 = validateParameter(valid_580746, JInt, required = false, default = nil)
  if valid_580746 != nil:
    section.add "maxResults", valid_580746
  var valid_580747 = query.getOrDefault("orderBy")
  valid_580747 = validateParameter(valid_580747, JString, required = false,
                                 default = newJString("returnCreationTimeAsc"))
  if valid_580747 != nil:
    section.add "orderBy", valid_580747
  var valid_580748 = query.getOrDefault("key")
  valid_580748 = validateParameter(valid_580748, JString, required = false,
                                 default = nil)
  if valid_580748 != nil:
    section.add "key", valid_580748
  var valid_580749 = query.getOrDefault("createdEndDate")
  valid_580749 = validateParameter(valid_580749, JString, required = false,
                                 default = nil)
  if valid_580749 != nil:
    section.add "createdEndDate", valid_580749
  var valid_580750 = query.getOrDefault("prettyPrint")
  valid_580750 = validateParameter(valid_580750, JBool, required = false,
                                 default = newJBool(true))
  if valid_580750 != nil:
    section.add "prettyPrint", valid_580750
  var valid_580751 = query.getOrDefault("createdStartDate")
  valid_580751 = validateParameter(valid_580751, JString, required = false,
                                 default = nil)
  if valid_580751 != nil:
    section.add "createdStartDate", valid_580751
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580752: Call_ContentOrderreturnsList_580736; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists order returns in your Merchant Center account.
  ## 
  let valid = call_580752.validator(path, query, header, formData, body)
  let scheme = call_580752.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580752.url(scheme.get, call_580752.host, call_580752.base,
                         call_580752.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580752, url, valid)

proc call*(call_580753: Call_ContentOrderreturnsList_580736; merchantId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; orderBy: string = "returnCreationTimeAsc";
          key: string = ""; createdEndDate: string = ""; prettyPrint: bool = true;
          createdStartDate: string = ""): Recallable =
  ## contentOrderreturnsList
  ## Lists order returns in your Merchant Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of order returns to return in the response, used for paging. The default value is 25 returns per page, and the maximum allowed value is 250 returns per page.
  ##   orderBy: string
  ##          : Return the results in the specified order.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   createdEndDate: string
  ##                 : Obtains order returns created before this date (inclusively), in ISO 8601 format.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   createdStartDate: string
  ##                   : Obtains order returns created after this date (inclusively), in ISO 8601 format.
  var path_580754 = newJObject()
  var query_580755 = newJObject()
  add(query_580755, "fields", newJString(fields))
  add(query_580755, "pageToken", newJString(pageToken))
  add(query_580755, "quotaUser", newJString(quotaUser))
  add(query_580755, "alt", newJString(alt))
  add(query_580755, "oauth_token", newJString(oauthToken))
  add(query_580755, "userIp", newJString(userIp))
  add(query_580755, "maxResults", newJInt(maxResults))
  add(query_580755, "orderBy", newJString(orderBy))
  add(query_580755, "key", newJString(key))
  add(query_580755, "createdEndDate", newJString(createdEndDate))
  add(path_580754, "merchantId", newJString(merchantId))
  add(query_580755, "prettyPrint", newJBool(prettyPrint))
  add(query_580755, "createdStartDate", newJString(createdStartDate))
  result = call_580753.call(path_580754, query_580755, nil, nil, nil)

var contentOrderreturnsList* = Call_ContentOrderreturnsList_580736(
    name: "contentOrderreturnsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreturns",
    validator: validate_ContentOrderreturnsList_580737, base: "/content/v2.1",
    url: url_ContentOrderreturnsList_580738, schemes: {Scheme.Https})
type
  Call_ContentOrderreturnsGet_580756 = ref object of OpenApiRestCall_579421
proc url_ContentOrderreturnsGet_580758(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "returnId" in path, "`returnId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orderreturns/"),
               (kind: VariableSegment, value: "returnId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrderreturnsGet_580757(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves an order return from your Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   returnId: JString (required)
  ##           : Merchant order return ID generated by Google.
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `returnId` field"
  var valid_580759 = path.getOrDefault("returnId")
  valid_580759 = validateParameter(valid_580759, JString, required = true,
                                 default = nil)
  if valid_580759 != nil:
    section.add "returnId", valid_580759
  var valid_580760 = path.getOrDefault("merchantId")
  valid_580760 = validateParameter(valid_580760, JString, required = true,
                                 default = nil)
  if valid_580760 != nil:
    section.add "merchantId", valid_580760
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
  var valid_580761 = query.getOrDefault("fields")
  valid_580761 = validateParameter(valid_580761, JString, required = false,
                                 default = nil)
  if valid_580761 != nil:
    section.add "fields", valid_580761
  var valid_580762 = query.getOrDefault("quotaUser")
  valid_580762 = validateParameter(valid_580762, JString, required = false,
                                 default = nil)
  if valid_580762 != nil:
    section.add "quotaUser", valid_580762
  var valid_580763 = query.getOrDefault("alt")
  valid_580763 = validateParameter(valid_580763, JString, required = false,
                                 default = newJString("json"))
  if valid_580763 != nil:
    section.add "alt", valid_580763
  var valid_580764 = query.getOrDefault("oauth_token")
  valid_580764 = validateParameter(valid_580764, JString, required = false,
                                 default = nil)
  if valid_580764 != nil:
    section.add "oauth_token", valid_580764
  var valid_580765 = query.getOrDefault("userIp")
  valid_580765 = validateParameter(valid_580765, JString, required = false,
                                 default = nil)
  if valid_580765 != nil:
    section.add "userIp", valid_580765
  var valid_580766 = query.getOrDefault("key")
  valid_580766 = validateParameter(valid_580766, JString, required = false,
                                 default = nil)
  if valid_580766 != nil:
    section.add "key", valid_580766
  var valid_580767 = query.getOrDefault("prettyPrint")
  valid_580767 = validateParameter(valid_580767, JBool, required = false,
                                 default = newJBool(true))
  if valid_580767 != nil:
    section.add "prettyPrint", valid_580767
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580768: Call_ContentOrderreturnsGet_580756; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an order return from your Merchant Center account.
  ## 
  let valid = call_580768.validator(path, query, header, formData, body)
  let scheme = call_580768.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580768.url(scheme.get, call_580768.host, call_580768.base,
                         call_580768.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580768, url, valid)

proc call*(call_580769: Call_ContentOrderreturnsGet_580756; returnId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentOrderreturnsGet
  ## Retrieves an order return from your Merchant Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   returnId: string (required)
  ##           : Merchant order return ID generated by Google.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580770 = newJObject()
  var query_580771 = newJObject()
  add(query_580771, "fields", newJString(fields))
  add(query_580771, "quotaUser", newJString(quotaUser))
  add(path_580770, "returnId", newJString(returnId))
  add(query_580771, "alt", newJString(alt))
  add(query_580771, "oauth_token", newJString(oauthToken))
  add(query_580771, "userIp", newJString(userIp))
  add(query_580771, "key", newJString(key))
  add(path_580770, "merchantId", newJString(merchantId))
  add(query_580771, "prettyPrint", newJBool(prettyPrint))
  result = call_580769.call(path_580770, query_580771, nil, nil, nil)

var contentOrderreturnsGet* = Call_ContentOrderreturnsGet_580756(
    name: "contentOrderreturnsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreturns/{returnId}",
    validator: validate_ContentOrderreturnsGet_580757, base: "/content/v2.1",
    url: url_ContentOrderreturnsGet_580758, schemes: {Scheme.Https})
type
  Call_ContentOrdersList_580772 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersList_580774(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersList_580773(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists the orders in your Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580775 = path.getOrDefault("merchantId")
  valid_580775 = validateParameter(valid_580775, JString, required = true,
                                 default = nil)
  if valid_580775 != nil:
    section.add "merchantId", valid_580775
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   placedDateStart: JString
  ##                  : Obtains orders placed after this date (inclusively), in ISO 8601 format.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of orders to return in the response, used for paging. The default value is 25 orders per page, and the maximum allowed value is 250 orders per page.
  ##   orderBy: JString
  ##          : Order results by placement date in descending or ascending order.
  ## 
  ## Acceptable values are:
  ## - placedDateAsc
  ## - placedDateDesc
  ##   placedDateEnd: JString
  ##                : Obtains orders placed before this date (exclusively), in ISO 8601 format.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   acknowledged: JBool
  ##               : Obtains orders that match the acknowledgement status. When set to true, obtains orders that have been acknowledged. When false, obtains orders that have not been acknowledged.
  ## We recommend using this filter set to false, in conjunction with the acknowledge call, such that only un-acknowledged orders are returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   statuses: JArray
  ##           : Obtains orders that match any of the specified statuses. Please note that active is a shortcut for pendingShipment and partiallyShipped, and completed is a shortcut for shipped, partiallyDelivered, delivered, partiallyReturned, returned, and canceled.
  section = newJObject()
  var valid_580776 = query.getOrDefault("fields")
  valid_580776 = validateParameter(valid_580776, JString, required = false,
                                 default = nil)
  if valid_580776 != nil:
    section.add "fields", valid_580776
  var valid_580777 = query.getOrDefault("pageToken")
  valid_580777 = validateParameter(valid_580777, JString, required = false,
                                 default = nil)
  if valid_580777 != nil:
    section.add "pageToken", valid_580777
  var valid_580778 = query.getOrDefault("quotaUser")
  valid_580778 = validateParameter(valid_580778, JString, required = false,
                                 default = nil)
  if valid_580778 != nil:
    section.add "quotaUser", valid_580778
  var valid_580779 = query.getOrDefault("alt")
  valid_580779 = validateParameter(valid_580779, JString, required = false,
                                 default = newJString("json"))
  if valid_580779 != nil:
    section.add "alt", valid_580779
  var valid_580780 = query.getOrDefault("placedDateStart")
  valid_580780 = validateParameter(valid_580780, JString, required = false,
                                 default = nil)
  if valid_580780 != nil:
    section.add "placedDateStart", valid_580780
  var valid_580781 = query.getOrDefault("oauth_token")
  valid_580781 = validateParameter(valid_580781, JString, required = false,
                                 default = nil)
  if valid_580781 != nil:
    section.add "oauth_token", valid_580781
  var valid_580782 = query.getOrDefault("userIp")
  valid_580782 = validateParameter(valid_580782, JString, required = false,
                                 default = nil)
  if valid_580782 != nil:
    section.add "userIp", valid_580782
  var valid_580783 = query.getOrDefault("maxResults")
  valid_580783 = validateParameter(valid_580783, JInt, required = false, default = nil)
  if valid_580783 != nil:
    section.add "maxResults", valid_580783
  var valid_580784 = query.getOrDefault("orderBy")
  valid_580784 = validateParameter(valid_580784, JString, required = false,
                                 default = nil)
  if valid_580784 != nil:
    section.add "orderBy", valid_580784
  var valid_580785 = query.getOrDefault("placedDateEnd")
  valid_580785 = validateParameter(valid_580785, JString, required = false,
                                 default = nil)
  if valid_580785 != nil:
    section.add "placedDateEnd", valid_580785
  var valid_580786 = query.getOrDefault("key")
  valid_580786 = validateParameter(valid_580786, JString, required = false,
                                 default = nil)
  if valid_580786 != nil:
    section.add "key", valid_580786
  var valid_580787 = query.getOrDefault("acknowledged")
  valid_580787 = validateParameter(valid_580787, JBool, required = false, default = nil)
  if valid_580787 != nil:
    section.add "acknowledged", valid_580787
  var valid_580788 = query.getOrDefault("prettyPrint")
  valid_580788 = validateParameter(valid_580788, JBool, required = false,
                                 default = newJBool(true))
  if valid_580788 != nil:
    section.add "prettyPrint", valid_580788
  var valid_580789 = query.getOrDefault("statuses")
  valid_580789 = validateParameter(valid_580789, JArray, required = false,
                                 default = nil)
  if valid_580789 != nil:
    section.add "statuses", valid_580789
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580790: Call_ContentOrdersList_580772; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the orders in your Merchant Center account.
  ## 
  let valid = call_580790.validator(path, query, header, formData, body)
  let scheme = call_580790.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580790.url(scheme.get, call_580790.host, call_580790.base,
                         call_580790.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580790, url, valid)

proc call*(call_580791: Call_ContentOrdersList_580772; merchantId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; placedDateStart: string = ""; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; orderBy: string = "";
          placedDateEnd: string = ""; key: string = ""; acknowledged: bool = false;
          prettyPrint: bool = true; statuses: JsonNode = nil): Recallable =
  ## contentOrdersList
  ## Lists the orders in your Merchant Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   placedDateStart: string
  ##                  : Obtains orders placed after this date (inclusively), in ISO 8601 format.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of orders to return in the response, used for paging. The default value is 25 orders per page, and the maximum allowed value is 250 orders per page.
  ##   orderBy: string
  ##          : Order results by placement date in descending or ascending order.
  ## 
  ## Acceptable values are:
  ## - placedDateAsc
  ## - placedDateDesc
  ##   placedDateEnd: string
  ##                : Obtains orders placed before this date (exclusively), in ISO 8601 format.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   acknowledged: bool
  ##               : Obtains orders that match the acknowledgement status. When set to true, obtains orders that have been acknowledged. When false, obtains orders that have not been acknowledged.
  ## We recommend using this filter set to false, in conjunction with the acknowledge call, such that only un-acknowledged orders are returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   statuses: JArray
  ##           : Obtains orders that match any of the specified statuses. Please note that active is a shortcut for pendingShipment and partiallyShipped, and completed is a shortcut for shipped, partiallyDelivered, delivered, partiallyReturned, returned, and canceled.
  var path_580792 = newJObject()
  var query_580793 = newJObject()
  add(query_580793, "fields", newJString(fields))
  add(query_580793, "pageToken", newJString(pageToken))
  add(query_580793, "quotaUser", newJString(quotaUser))
  add(query_580793, "alt", newJString(alt))
  add(query_580793, "placedDateStart", newJString(placedDateStart))
  add(query_580793, "oauth_token", newJString(oauthToken))
  add(query_580793, "userIp", newJString(userIp))
  add(query_580793, "maxResults", newJInt(maxResults))
  add(query_580793, "orderBy", newJString(orderBy))
  add(query_580793, "placedDateEnd", newJString(placedDateEnd))
  add(query_580793, "key", newJString(key))
  add(path_580792, "merchantId", newJString(merchantId))
  add(query_580793, "acknowledged", newJBool(acknowledged))
  add(query_580793, "prettyPrint", newJBool(prettyPrint))
  if statuses != nil:
    query_580793.add "statuses", statuses
  result = call_580791.call(path_580792, query_580793, nil, nil, nil)

var contentOrdersList* = Call_ContentOrdersList_580772(name: "contentOrdersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/orders", validator: validate_ContentOrdersList_580773,
    base: "/content/v2.1", url: url_ContentOrdersList_580774,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersGet_580794 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersGet_580796(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersGet_580795(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieves an order from your Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   orderId: JString (required)
  ##          : The ID of the order.
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `orderId` field"
  var valid_580797 = path.getOrDefault("orderId")
  valid_580797 = validateParameter(valid_580797, JString, required = true,
                                 default = nil)
  if valid_580797 != nil:
    section.add "orderId", valid_580797
  var valid_580798 = path.getOrDefault("merchantId")
  valid_580798 = validateParameter(valid_580798, JString, required = true,
                                 default = nil)
  if valid_580798 != nil:
    section.add "merchantId", valid_580798
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
  var valid_580799 = query.getOrDefault("fields")
  valid_580799 = validateParameter(valid_580799, JString, required = false,
                                 default = nil)
  if valid_580799 != nil:
    section.add "fields", valid_580799
  var valid_580800 = query.getOrDefault("quotaUser")
  valid_580800 = validateParameter(valid_580800, JString, required = false,
                                 default = nil)
  if valid_580800 != nil:
    section.add "quotaUser", valid_580800
  var valid_580801 = query.getOrDefault("alt")
  valid_580801 = validateParameter(valid_580801, JString, required = false,
                                 default = newJString("json"))
  if valid_580801 != nil:
    section.add "alt", valid_580801
  var valid_580802 = query.getOrDefault("oauth_token")
  valid_580802 = validateParameter(valid_580802, JString, required = false,
                                 default = nil)
  if valid_580802 != nil:
    section.add "oauth_token", valid_580802
  var valid_580803 = query.getOrDefault("userIp")
  valid_580803 = validateParameter(valid_580803, JString, required = false,
                                 default = nil)
  if valid_580803 != nil:
    section.add "userIp", valid_580803
  var valid_580804 = query.getOrDefault("key")
  valid_580804 = validateParameter(valid_580804, JString, required = false,
                                 default = nil)
  if valid_580804 != nil:
    section.add "key", valid_580804
  var valid_580805 = query.getOrDefault("prettyPrint")
  valid_580805 = validateParameter(valid_580805, JBool, required = false,
                                 default = newJBool(true))
  if valid_580805 != nil:
    section.add "prettyPrint", valid_580805
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580806: Call_ContentOrdersGet_580794; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an order from your Merchant Center account.
  ## 
  let valid = call_580806.validator(path, query, header, formData, body)
  let scheme = call_580806.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580806.url(scheme.get, call_580806.host, call_580806.base,
                         call_580806.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580806, url, valid)

proc call*(call_580807: Call_ContentOrdersGet_580794; orderId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentOrdersGet
  ## Retrieves an order from your Merchant Center account.
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
  ##   orderId: string (required)
  ##          : The ID of the order.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580808 = newJObject()
  var query_580809 = newJObject()
  add(query_580809, "fields", newJString(fields))
  add(query_580809, "quotaUser", newJString(quotaUser))
  add(query_580809, "alt", newJString(alt))
  add(query_580809, "oauth_token", newJString(oauthToken))
  add(query_580809, "userIp", newJString(userIp))
  add(path_580808, "orderId", newJString(orderId))
  add(query_580809, "key", newJString(key))
  add(path_580808, "merchantId", newJString(merchantId))
  add(query_580809, "prettyPrint", newJBool(prettyPrint))
  result = call_580807.call(path_580808, query_580809, nil, nil, nil)

var contentOrdersGet* = Call_ContentOrdersGet_580794(name: "contentOrdersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}", validator: validate_ContentOrdersGet_580795,
    base: "/content/v2.1", url: url_ContentOrdersGet_580796, schemes: {Scheme.Https})
type
  Call_ContentOrdersAcknowledge_580810 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersAcknowledge_580812(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/acknowledge")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersAcknowledge_580811(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Marks an order as acknowledged.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   orderId: JString (required)
  ##          : The ID of the order.
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `orderId` field"
  var valid_580813 = path.getOrDefault("orderId")
  valid_580813 = validateParameter(valid_580813, JString, required = true,
                                 default = nil)
  if valid_580813 != nil:
    section.add "orderId", valid_580813
  var valid_580814 = path.getOrDefault("merchantId")
  valid_580814 = validateParameter(valid_580814, JString, required = true,
                                 default = nil)
  if valid_580814 != nil:
    section.add "merchantId", valid_580814
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
  var valid_580815 = query.getOrDefault("fields")
  valid_580815 = validateParameter(valid_580815, JString, required = false,
                                 default = nil)
  if valid_580815 != nil:
    section.add "fields", valid_580815
  var valid_580816 = query.getOrDefault("quotaUser")
  valid_580816 = validateParameter(valid_580816, JString, required = false,
                                 default = nil)
  if valid_580816 != nil:
    section.add "quotaUser", valid_580816
  var valid_580817 = query.getOrDefault("alt")
  valid_580817 = validateParameter(valid_580817, JString, required = false,
                                 default = newJString("json"))
  if valid_580817 != nil:
    section.add "alt", valid_580817
  var valid_580818 = query.getOrDefault("oauth_token")
  valid_580818 = validateParameter(valid_580818, JString, required = false,
                                 default = nil)
  if valid_580818 != nil:
    section.add "oauth_token", valid_580818
  var valid_580819 = query.getOrDefault("userIp")
  valid_580819 = validateParameter(valid_580819, JString, required = false,
                                 default = nil)
  if valid_580819 != nil:
    section.add "userIp", valid_580819
  var valid_580820 = query.getOrDefault("key")
  valid_580820 = validateParameter(valid_580820, JString, required = false,
                                 default = nil)
  if valid_580820 != nil:
    section.add "key", valid_580820
  var valid_580821 = query.getOrDefault("prettyPrint")
  valid_580821 = validateParameter(valid_580821, JBool, required = false,
                                 default = newJBool(true))
  if valid_580821 != nil:
    section.add "prettyPrint", valid_580821
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

proc call*(call_580823: Call_ContentOrdersAcknowledge_580810; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks an order as acknowledged.
  ## 
  let valid = call_580823.validator(path, query, header, formData, body)
  let scheme = call_580823.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580823.url(scheme.get, call_580823.host, call_580823.base,
                         call_580823.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580823, url, valid)

proc call*(call_580824: Call_ContentOrdersAcknowledge_580810; orderId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentOrdersAcknowledge
  ## Marks an order as acknowledged.
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
  ##   orderId: string (required)
  ##          : The ID of the order.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580825 = newJObject()
  var query_580826 = newJObject()
  var body_580827 = newJObject()
  add(query_580826, "fields", newJString(fields))
  add(query_580826, "quotaUser", newJString(quotaUser))
  add(query_580826, "alt", newJString(alt))
  add(query_580826, "oauth_token", newJString(oauthToken))
  add(query_580826, "userIp", newJString(userIp))
  add(path_580825, "orderId", newJString(orderId))
  add(query_580826, "key", newJString(key))
  add(path_580825, "merchantId", newJString(merchantId))
  if body != nil:
    body_580827 = body
  add(query_580826, "prettyPrint", newJBool(prettyPrint))
  result = call_580824.call(path_580825, query_580826, nil, nil, body_580827)

var contentOrdersAcknowledge* = Call_ContentOrdersAcknowledge_580810(
    name: "contentOrdersAcknowledge", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/acknowledge",
    validator: validate_ContentOrdersAcknowledge_580811, base: "/content/v2.1",
    url: url_ContentOrdersAcknowledge_580812, schemes: {Scheme.Https})
type
  Call_ContentOrdersCancel_580828 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersCancel_580830(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersCancel_580829(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Cancels all line items in an order, making a full refund.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   orderId: JString (required)
  ##          : The ID of the order to cancel.
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `orderId` field"
  var valid_580831 = path.getOrDefault("orderId")
  valid_580831 = validateParameter(valid_580831, JString, required = true,
                                 default = nil)
  if valid_580831 != nil:
    section.add "orderId", valid_580831
  var valid_580832 = path.getOrDefault("merchantId")
  valid_580832 = validateParameter(valid_580832, JString, required = true,
                                 default = nil)
  if valid_580832 != nil:
    section.add "merchantId", valid_580832
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
  var valid_580833 = query.getOrDefault("fields")
  valid_580833 = validateParameter(valid_580833, JString, required = false,
                                 default = nil)
  if valid_580833 != nil:
    section.add "fields", valid_580833
  var valid_580834 = query.getOrDefault("quotaUser")
  valid_580834 = validateParameter(valid_580834, JString, required = false,
                                 default = nil)
  if valid_580834 != nil:
    section.add "quotaUser", valid_580834
  var valid_580835 = query.getOrDefault("alt")
  valid_580835 = validateParameter(valid_580835, JString, required = false,
                                 default = newJString("json"))
  if valid_580835 != nil:
    section.add "alt", valid_580835
  var valid_580836 = query.getOrDefault("oauth_token")
  valid_580836 = validateParameter(valid_580836, JString, required = false,
                                 default = nil)
  if valid_580836 != nil:
    section.add "oauth_token", valid_580836
  var valid_580837 = query.getOrDefault("userIp")
  valid_580837 = validateParameter(valid_580837, JString, required = false,
                                 default = nil)
  if valid_580837 != nil:
    section.add "userIp", valid_580837
  var valid_580838 = query.getOrDefault("key")
  valid_580838 = validateParameter(valid_580838, JString, required = false,
                                 default = nil)
  if valid_580838 != nil:
    section.add "key", valid_580838
  var valid_580839 = query.getOrDefault("prettyPrint")
  valid_580839 = validateParameter(valid_580839, JBool, required = false,
                                 default = newJBool(true))
  if valid_580839 != nil:
    section.add "prettyPrint", valid_580839
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

proc call*(call_580841: Call_ContentOrdersCancel_580828; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels all line items in an order, making a full refund.
  ## 
  let valid = call_580841.validator(path, query, header, formData, body)
  let scheme = call_580841.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580841.url(scheme.get, call_580841.host, call_580841.base,
                         call_580841.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580841, url, valid)

proc call*(call_580842: Call_ContentOrdersCancel_580828; orderId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentOrdersCancel
  ## Cancels all line items in an order, making a full refund.
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
  ##   orderId: string (required)
  ##          : The ID of the order to cancel.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580843 = newJObject()
  var query_580844 = newJObject()
  var body_580845 = newJObject()
  add(query_580844, "fields", newJString(fields))
  add(query_580844, "quotaUser", newJString(quotaUser))
  add(query_580844, "alt", newJString(alt))
  add(query_580844, "oauth_token", newJString(oauthToken))
  add(query_580844, "userIp", newJString(userIp))
  add(path_580843, "orderId", newJString(orderId))
  add(query_580844, "key", newJString(key))
  add(path_580843, "merchantId", newJString(merchantId))
  if body != nil:
    body_580845 = body
  add(query_580844, "prettyPrint", newJBool(prettyPrint))
  result = call_580842.call(path_580843, query_580844, nil, nil, body_580845)

var contentOrdersCancel* = Call_ContentOrdersCancel_580828(
    name: "contentOrdersCancel", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/orders/{orderId}/cancel",
    validator: validate_ContentOrdersCancel_580829, base: "/content/v2.1",
    url: url_ContentOrdersCancel_580830, schemes: {Scheme.Https})
type
  Call_ContentOrdersCancellineitem_580846 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersCancellineitem_580848(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/cancelLineItem")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersCancellineitem_580847(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels a line item, making a full refund.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   orderId: JString (required)
  ##          : The ID of the order.
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `orderId` field"
  var valid_580849 = path.getOrDefault("orderId")
  valid_580849 = validateParameter(valid_580849, JString, required = true,
                                 default = nil)
  if valid_580849 != nil:
    section.add "orderId", valid_580849
  var valid_580850 = path.getOrDefault("merchantId")
  valid_580850 = validateParameter(valid_580850, JString, required = true,
                                 default = nil)
  if valid_580850 != nil:
    section.add "merchantId", valid_580850
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
  var valid_580851 = query.getOrDefault("fields")
  valid_580851 = validateParameter(valid_580851, JString, required = false,
                                 default = nil)
  if valid_580851 != nil:
    section.add "fields", valid_580851
  var valid_580852 = query.getOrDefault("quotaUser")
  valid_580852 = validateParameter(valid_580852, JString, required = false,
                                 default = nil)
  if valid_580852 != nil:
    section.add "quotaUser", valid_580852
  var valid_580853 = query.getOrDefault("alt")
  valid_580853 = validateParameter(valid_580853, JString, required = false,
                                 default = newJString("json"))
  if valid_580853 != nil:
    section.add "alt", valid_580853
  var valid_580854 = query.getOrDefault("oauth_token")
  valid_580854 = validateParameter(valid_580854, JString, required = false,
                                 default = nil)
  if valid_580854 != nil:
    section.add "oauth_token", valid_580854
  var valid_580855 = query.getOrDefault("userIp")
  valid_580855 = validateParameter(valid_580855, JString, required = false,
                                 default = nil)
  if valid_580855 != nil:
    section.add "userIp", valid_580855
  var valid_580856 = query.getOrDefault("key")
  valid_580856 = validateParameter(valid_580856, JString, required = false,
                                 default = nil)
  if valid_580856 != nil:
    section.add "key", valid_580856
  var valid_580857 = query.getOrDefault("prettyPrint")
  valid_580857 = validateParameter(valid_580857, JBool, required = false,
                                 default = newJBool(true))
  if valid_580857 != nil:
    section.add "prettyPrint", valid_580857
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

proc call*(call_580859: Call_ContentOrdersCancellineitem_580846; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a line item, making a full refund.
  ## 
  let valid = call_580859.validator(path, query, header, formData, body)
  let scheme = call_580859.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580859.url(scheme.get, call_580859.host, call_580859.base,
                         call_580859.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580859, url, valid)

proc call*(call_580860: Call_ContentOrdersCancellineitem_580846; orderId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentOrdersCancellineitem
  ## Cancels a line item, making a full refund.
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
  ##   orderId: string (required)
  ##          : The ID of the order.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580861 = newJObject()
  var query_580862 = newJObject()
  var body_580863 = newJObject()
  add(query_580862, "fields", newJString(fields))
  add(query_580862, "quotaUser", newJString(quotaUser))
  add(query_580862, "alt", newJString(alt))
  add(query_580862, "oauth_token", newJString(oauthToken))
  add(query_580862, "userIp", newJString(userIp))
  add(path_580861, "orderId", newJString(orderId))
  add(query_580862, "key", newJString(key))
  add(path_580861, "merchantId", newJString(merchantId))
  if body != nil:
    body_580863 = body
  add(query_580862, "prettyPrint", newJBool(prettyPrint))
  result = call_580860.call(path_580861, query_580862, nil, nil, body_580863)

var contentOrdersCancellineitem* = Call_ContentOrdersCancellineitem_580846(
    name: "contentOrdersCancellineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/cancelLineItem",
    validator: validate_ContentOrdersCancellineitem_580847, base: "/content/v2.1",
    url: url_ContentOrdersCancellineitem_580848, schemes: {Scheme.Https})
type
  Call_ContentOrdersInstorerefundlineitem_580864 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersInstorerefundlineitem_580866(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/inStoreRefundLineItem")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersInstorerefundlineitem_580865(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deprecated. Notifies that item return and refund was handled directly by merchant outside of Google payments processing (e.g. cash refund done in store).
  ## Note: We recommend calling the returnrefundlineitem method to refund in-store returns. We will issue the refund directly to the customer. This helps to prevent possible differences arising between merchant and Google transaction records. We also recommend having the point of sale system communicate with Google to ensure that customers do not receive a double refund by first refunding via Google then via an in-store return.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   orderId: JString (required)
  ##          : The ID of the order.
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `orderId` field"
  var valid_580867 = path.getOrDefault("orderId")
  valid_580867 = validateParameter(valid_580867, JString, required = true,
                                 default = nil)
  if valid_580867 != nil:
    section.add "orderId", valid_580867
  var valid_580868 = path.getOrDefault("merchantId")
  valid_580868 = validateParameter(valid_580868, JString, required = true,
                                 default = nil)
  if valid_580868 != nil:
    section.add "merchantId", valid_580868
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
  var valid_580869 = query.getOrDefault("fields")
  valid_580869 = validateParameter(valid_580869, JString, required = false,
                                 default = nil)
  if valid_580869 != nil:
    section.add "fields", valid_580869
  var valid_580870 = query.getOrDefault("quotaUser")
  valid_580870 = validateParameter(valid_580870, JString, required = false,
                                 default = nil)
  if valid_580870 != nil:
    section.add "quotaUser", valid_580870
  var valid_580871 = query.getOrDefault("alt")
  valid_580871 = validateParameter(valid_580871, JString, required = false,
                                 default = newJString("json"))
  if valid_580871 != nil:
    section.add "alt", valid_580871
  var valid_580872 = query.getOrDefault("oauth_token")
  valid_580872 = validateParameter(valid_580872, JString, required = false,
                                 default = nil)
  if valid_580872 != nil:
    section.add "oauth_token", valid_580872
  var valid_580873 = query.getOrDefault("userIp")
  valid_580873 = validateParameter(valid_580873, JString, required = false,
                                 default = nil)
  if valid_580873 != nil:
    section.add "userIp", valid_580873
  var valid_580874 = query.getOrDefault("key")
  valid_580874 = validateParameter(valid_580874, JString, required = false,
                                 default = nil)
  if valid_580874 != nil:
    section.add "key", valid_580874
  var valid_580875 = query.getOrDefault("prettyPrint")
  valid_580875 = validateParameter(valid_580875, JBool, required = false,
                                 default = newJBool(true))
  if valid_580875 != nil:
    section.add "prettyPrint", valid_580875
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

proc call*(call_580877: Call_ContentOrdersInstorerefundlineitem_580864;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deprecated. Notifies that item return and refund was handled directly by merchant outside of Google payments processing (e.g. cash refund done in store).
  ## Note: We recommend calling the returnrefundlineitem method to refund in-store returns. We will issue the refund directly to the customer. This helps to prevent possible differences arising between merchant and Google transaction records. We also recommend having the point of sale system communicate with Google to ensure that customers do not receive a double refund by first refunding via Google then via an in-store return.
  ## 
  let valid = call_580877.validator(path, query, header, formData, body)
  let scheme = call_580877.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580877.url(scheme.get, call_580877.host, call_580877.base,
                         call_580877.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580877, url, valid)

proc call*(call_580878: Call_ContentOrdersInstorerefundlineitem_580864;
          orderId: string; merchantId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## contentOrdersInstorerefundlineitem
  ## Deprecated. Notifies that item return and refund was handled directly by merchant outside of Google payments processing (e.g. cash refund done in store).
  ## Note: We recommend calling the returnrefundlineitem method to refund in-store returns. We will issue the refund directly to the customer. This helps to prevent possible differences arising between merchant and Google transaction records. We also recommend having the point of sale system communicate with Google to ensure that customers do not receive a double refund by first refunding via Google then via an in-store return.
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
  ##   orderId: string (required)
  ##          : The ID of the order.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580879 = newJObject()
  var query_580880 = newJObject()
  var body_580881 = newJObject()
  add(query_580880, "fields", newJString(fields))
  add(query_580880, "quotaUser", newJString(quotaUser))
  add(query_580880, "alt", newJString(alt))
  add(query_580880, "oauth_token", newJString(oauthToken))
  add(query_580880, "userIp", newJString(userIp))
  add(path_580879, "orderId", newJString(orderId))
  add(query_580880, "key", newJString(key))
  add(path_580879, "merchantId", newJString(merchantId))
  if body != nil:
    body_580881 = body
  add(query_580880, "prettyPrint", newJBool(prettyPrint))
  result = call_580878.call(path_580879, query_580880, nil, nil, body_580881)

var contentOrdersInstorerefundlineitem* = Call_ContentOrdersInstorerefundlineitem_580864(
    name: "contentOrdersInstorerefundlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/inStoreRefundLineItem",
    validator: validate_ContentOrdersInstorerefundlineitem_580865,
    base: "/content/v2.1", url: url_ContentOrdersInstorerefundlineitem_580866,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersRejectreturnlineitem_580882 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersRejectreturnlineitem_580884(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/rejectReturnLineItem")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersRejectreturnlineitem_580883(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rejects return on an line item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   orderId: JString (required)
  ##          : The ID of the order.
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `orderId` field"
  var valid_580885 = path.getOrDefault("orderId")
  valid_580885 = validateParameter(valid_580885, JString, required = true,
                                 default = nil)
  if valid_580885 != nil:
    section.add "orderId", valid_580885
  var valid_580886 = path.getOrDefault("merchantId")
  valid_580886 = validateParameter(valid_580886, JString, required = true,
                                 default = nil)
  if valid_580886 != nil:
    section.add "merchantId", valid_580886
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
  var valid_580887 = query.getOrDefault("fields")
  valid_580887 = validateParameter(valid_580887, JString, required = false,
                                 default = nil)
  if valid_580887 != nil:
    section.add "fields", valid_580887
  var valid_580888 = query.getOrDefault("quotaUser")
  valid_580888 = validateParameter(valid_580888, JString, required = false,
                                 default = nil)
  if valid_580888 != nil:
    section.add "quotaUser", valid_580888
  var valid_580889 = query.getOrDefault("alt")
  valid_580889 = validateParameter(valid_580889, JString, required = false,
                                 default = newJString("json"))
  if valid_580889 != nil:
    section.add "alt", valid_580889
  var valid_580890 = query.getOrDefault("oauth_token")
  valid_580890 = validateParameter(valid_580890, JString, required = false,
                                 default = nil)
  if valid_580890 != nil:
    section.add "oauth_token", valid_580890
  var valid_580891 = query.getOrDefault("userIp")
  valid_580891 = validateParameter(valid_580891, JString, required = false,
                                 default = nil)
  if valid_580891 != nil:
    section.add "userIp", valid_580891
  var valid_580892 = query.getOrDefault("key")
  valid_580892 = validateParameter(valid_580892, JString, required = false,
                                 default = nil)
  if valid_580892 != nil:
    section.add "key", valid_580892
  var valid_580893 = query.getOrDefault("prettyPrint")
  valid_580893 = validateParameter(valid_580893, JBool, required = false,
                                 default = newJBool(true))
  if valid_580893 != nil:
    section.add "prettyPrint", valid_580893
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

proc call*(call_580895: Call_ContentOrdersRejectreturnlineitem_580882;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rejects return on an line item.
  ## 
  let valid = call_580895.validator(path, query, header, formData, body)
  let scheme = call_580895.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580895.url(scheme.get, call_580895.host, call_580895.base,
                         call_580895.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580895, url, valid)

proc call*(call_580896: Call_ContentOrdersRejectreturnlineitem_580882;
          orderId: string; merchantId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## contentOrdersRejectreturnlineitem
  ## Rejects return on an line item.
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
  ##   orderId: string (required)
  ##          : The ID of the order.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580897 = newJObject()
  var query_580898 = newJObject()
  var body_580899 = newJObject()
  add(query_580898, "fields", newJString(fields))
  add(query_580898, "quotaUser", newJString(quotaUser))
  add(query_580898, "alt", newJString(alt))
  add(query_580898, "oauth_token", newJString(oauthToken))
  add(query_580898, "userIp", newJString(userIp))
  add(path_580897, "orderId", newJString(orderId))
  add(query_580898, "key", newJString(key))
  add(path_580897, "merchantId", newJString(merchantId))
  if body != nil:
    body_580899 = body
  add(query_580898, "prettyPrint", newJBool(prettyPrint))
  result = call_580896.call(path_580897, query_580898, nil, nil, body_580899)

var contentOrdersRejectreturnlineitem* = Call_ContentOrdersRejectreturnlineitem_580882(
    name: "contentOrdersRejectreturnlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/rejectReturnLineItem",
    validator: validate_ContentOrdersRejectreturnlineitem_580883,
    base: "/content/v2.1", url: url_ContentOrdersRejectreturnlineitem_580884,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersReturnrefundlineitem_580900 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersReturnrefundlineitem_580902(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/returnRefundLineItem")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersReturnrefundlineitem_580901(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns and refunds a line item. Note that this method can only be called on fully shipped orders.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   orderId: JString (required)
  ##          : The ID of the order.
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `orderId` field"
  var valid_580903 = path.getOrDefault("orderId")
  valid_580903 = validateParameter(valid_580903, JString, required = true,
                                 default = nil)
  if valid_580903 != nil:
    section.add "orderId", valid_580903
  var valid_580904 = path.getOrDefault("merchantId")
  valid_580904 = validateParameter(valid_580904, JString, required = true,
                                 default = nil)
  if valid_580904 != nil:
    section.add "merchantId", valid_580904
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
  var valid_580905 = query.getOrDefault("fields")
  valid_580905 = validateParameter(valid_580905, JString, required = false,
                                 default = nil)
  if valid_580905 != nil:
    section.add "fields", valid_580905
  var valid_580906 = query.getOrDefault("quotaUser")
  valid_580906 = validateParameter(valid_580906, JString, required = false,
                                 default = nil)
  if valid_580906 != nil:
    section.add "quotaUser", valid_580906
  var valid_580907 = query.getOrDefault("alt")
  valid_580907 = validateParameter(valid_580907, JString, required = false,
                                 default = newJString("json"))
  if valid_580907 != nil:
    section.add "alt", valid_580907
  var valid_580908 = query.getOrDefault("oauth_token")
  valid_580908 = validateParameter(valid_580908, JString, required = false,
                                 default = nil)
  if valid_580908 != nil:
    section.add "oauth_token", valid_580908
  var valid_580909 = query.getOrDefault("userIp")
  valid_580909 = validateParameter(valid_580909, JString, required = false,
                                 default = nil)
  if valid_580909 != nil:
    section.add "userIp", valid_580909
  var valid_580910 = query.getOrDefault("key")
  valid_580910 = validateParameter(valid_580910, JString, required = false,
                                 default = nil)
  if valid_580910 != nil:
    section.add "key", valid_580910
  var valid_580911 = query.getOrDefault("prettyPrint")
  valid_580911 = validateParameter(valid_580911, JBool, required = false,
                                 default = newJBool(true))
  if valid_580911 != nil:
    section.add "prettyPrint", valid_580911
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

proc call*(call_580913: Call_ContentOrdersReturnrefundlineitem_580900;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns and refunds a line item. Note that this method can only be called on fully shipped orders.
  ## 
  let valid = call_580913.validator(path, query, header, formData, body)
  let scheme = call_580913.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580913.url(scheme.get, call_580913.host, call_580913.base,
                         call_580913.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580913, url, valid)

proc call*(call_580914: Call_ContentOrdersReturnrefundlineitem_580900;
          orderId: string; merchantId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## contentOrdersReturnrefundlineitem
  ## Returns and refunds a line item. Note that this method can only be called on fully shipped orders.
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
  ##   orderId: string (required)
  ##          : The ID of the order.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580915 = newJObject()
  var query_580916 = newJObject()
  var body_580917 = newJObject()
  add(query_580916, "fields", newJString(fields))
  add(query_580916, "quotaUser", newJString(quotaUser))
  add(query_580916, "alt", newJString(alt))
  add(query_580916, "oauth_token", newJString(oauthToken))
  add(query_580916, "userIp", newJString(userIp))
  add(path_580915, "orderId", newJString(orderId))
  add(query_580916, "key", newJString(key))
  add(path_580915, "merchantId", newJString(merchantId))
  if body != nil:
    body_580917 = body
  add(query_580916, "prettyPrint", newJBool(prettyPrint))
  result = call_580914.call(path_580915, query_580916, nil, nil, body_580917)

var contentOrdersReturnrefundlineitem* = Call_ContentOrdersReturnrefundlineitem_580900(
    name: "contentOrdersReturnrefundlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/returnRefundLineItem",
    validator: validate_ContentOrdersReturnrefundlineitem_580901,
    base: "/content/v2.1", url: url_ContentOrdersReturnrefundlineitem_580902,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersSetlineitemmetadata_580918 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersSetlineitemmetadata_580920(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/setLineItemMetadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersSetlineitemmetadata_580919(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets (or overrides if it already exists) merchant provided annotations in the form of key-value pairs. A common use case would be to supply us with additional structured information about a line item that cannot be provided via other methods. Submitted key-value pairs can be retrieved as part of the orders resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   orderId: JString (required)
  ##          : The ID of the order.
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `orderId` field"
  var valid_580921 = path.getOrDefault("orderId")
  valid_580921 = validateParameter(valid_580921, JString, required = true,
                                 default = nil)
  if valid_580921 != nil:
    section.add "orderId", valid_580921
  var valid_580922 = path.getOrDefault("merchantId")
  valid_580922 = validateParameter(valid_580922, JString, required = true,
                                 default = nil)
  if valid_580922 != nil:
    section.add "merchantId", valid_580922
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
  var valid_580923 = query.getOrDefault("fields")
  valid_580923 = validateParameter(valid_580923, JString, required = false,
                                 default = nil)
  if valid_580923 != nil:
    section.add "fields", valid_580923
  var valid_580924 = query.getOrDefault("quotaUser")
  valid_580924 = validateParameter(valid_580924, JString, required = false,
                                 default = nil)
  if valid_580924 != nil:
    section.add "quotaUser", valid_580924
  var valid_580925 = query.getOrDefault("alt")
  valid_580925 = validateParameter(valid_580925, JString, required = false,
                                 default = newJString("json"))
  if valid_580925 != nil:
    section.add "alt", valid_580925
  var valid_580926 = query.getOrDefault("oauth_token")
  valid_580926 = validateParameter(valid_580926, JString, required = false,
                                 default = nil)
  if valid_580926 != nil:
    section.add "oauth_token", valid_580926
  var valid_580927 = query.getOrDefault("userIp")
  valid_580927 = validateParameter(valid_580927, JString, required = false,
                                 default = nil)
  if valid_580927 != nil:
    section.add "userIp", valid_580927
  var valid_580928 = query.getOrDefault("key")
  valid_580928 = validateParameter(valid_580928, JString, required = false,
                                 default = nil)
  if valid_580928 != nil:
    section.add "key", valid_580928
  var valid_580929 = query.getOrDefault("prettyPrint")
  valid_580929 = validateParameter(valid_580929, JBool, required = false,
                                 default = newJBool(true))
  if valid_580929 != nil:
    section.add "prettyPrint", valid_580929
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

proc call*(call_580931: Call_ContentOrdersSetlineitemmetadata_580918;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets (or overrides if it already exists) merchant provided annotations in the form of key-value pairs. A common use case would be to supply us with additional structured information about a line item that cannot be provided via other methods. Submitted key-value pairs can be retrieved as part of the orders resource.
  ## 
  let valid = call_580931.validator(path, query, header, formData, body)
  let scheme = call_580931.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580931.url(scheme.get, call_580931.host, call_580931.base,
                         call_580931.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580931, url, valid)

proc call*(call_580932: Call_ContentOrdersSetlineitemmetadata_580918;
          orderId: string; merchantId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## contentOrdersSetlineitemmetadata
  ## Sets (or overrides if it already exists) merchant provided annotations in the form of key-value pairs. A common use case would be to supply us with additional structured information about a line item that cannot be provided via other methods. Submitted key-value pairs can be retrieved as part of the orders resource.
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
  ##   orderId: string (required)
  ##          : The ID of the order.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580933 = newJObject()
  var query_580934 = newJObject()
  var body_580935 = newJObject()
  add(query_580934, "fields", newJString(fields))
  add(query_580934, "quotaUser", newJString(quotaUser))
  add(query_580934, "alt", newJString(alt))
  add(query_580934, "oauth_token", newJString(oauthToken))
  add(query_580934, "userIp", newJString(userIp))
  add(path_580933, "orderId", newJString(orderId))
  add(query_580934, "key", newJString(key))
  add(path_580933, "merchantId", newJString(merchantId))
  if body != nil:
    body_580935 = body
  add(query_580934, "prettyPrint", newJBool(prettyPrint))
  result = call_580932.call(path_580933, query_580934, nil, nil, body_580935)

var contentOrdersSetlineitemmetadata* = Call_ContentOrdersSetlineitemmetadata_580918(
    name: "contentOrdersSetlineitemmetadata", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/setLineItemMetadata",
    validator: validate_ContentOrdersSetlineitemmetadata_580919,
    base: "/content/v2.1", url: url_ContentOrdersSetlineitemmetadata_580920,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersShiplineitems_580936 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersShiplineitems_580938(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/shipLineItems")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersShiplineitems_580937(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Marks line item(s) as shipped.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   orderId: JString (required)
  ##          : The ID of the order.
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `orderId` field"
  var valid_580939 = path.getOrDefault("orderId")
  valid_580939 = validateParameter(valid_580939, JString, required = true,
                                 default = nil)
  if valid_580939 != nil:
    section.add "orderId", valid_580939
  var valid_580940 = path.getOrDefault("merchantId")
  valid_580940 = validateParameter(valid_580940, JString, required = true,
                                 default = nil)
  if valid_580940 != nil:
    section.add "merchantId", valid_580940
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
  var valid_580941 = query.getOrDefault("fields")
  valid_580941 = validateParameter(valid_580941, JString, required = false,
                                 default = nil)
  if valid_580941 != nil:
    section.add "fields", valid_580941
  var valid_580942 = query.getOrDefault("quotaUser")
  valid_580942 = validateParameter(valid_580942, JString, required = false,
                                 default = nil)
  if valid_580942 != nil:
    section.add "quotaUser", valid_580942
  var valid_580943 = query.getOrDefault("alt")
  valid_580943 = validateParameter(valid_580943, JString, required = false,
                                 default = newJString("json"))
  if valid_580943 != nil:
    section.add "alt", valid_580943
  var valid_580944 = query.getOrDefault("oauth_token")
  valid_580944 = validateParameter(valid_580944, JString, required = false,
                                 default = nil)
  if valid_580944 != nil:
    section.add "oauth_token", valid_580944
  var valid_580945 = query.getOrDefault("userIp")
  valid_580945 = validateParameter(valid_580945, JString, required = false,
                                 default = nil)
  if valid_580945 != nil:
    section.add "userIp", valid_580945
  var valid_580946 = query.getOrDefault("key")
  valid_580946 = validateParameter(valid_580946, JString, required = false,
                                 default = nil)
  if valid_580946 != nil:
    section.add "key", valid_580946
  var valid_580947 = query.getOrDefault("prettyPrint")
  valid_580947 = validateParameter(valid_580947, JBool, required = false,
                                 default = newJBool(true))
  if valid_580947 != nil:
    section.add "prettyPrint", valid_580947
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

proc call*(call_580949: Call_ContentOrdersShiplineitems_580936; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks line item(s) as shipped.
  ## 
  let valid = call_580949.validator(path, query, header, formData, body)
  let scheme = call_580949.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580949.url(scheme.get, call_580949.host, call_580949.base,
                         call_580949.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580949, url, valid)

proc call*(call_580950: Call_ContentOrdersShiplineitems_580936; orderId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentOrdersShiplineitems
  ## Marks line item(s) as shipped.
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
  ##   orderId: string (required)
  ##          : The ID of the order.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580951 = newJObject()
  var query_580952 = newJObject()
  var body_580953 = newJObject()
  add(query_580952, "fields", newJString(fields))
  add(query_580952, "quotaUser", newJString(quotaUser))
  add(query_580952, "alt", newJString(alt))
  add(query_580952, "oauth_token", newJString(oauthToken))
  add(query_580952, "userIp", newJString(userIp))
  add(path_580951, "orderId", newJString(orderId))
  add(query_580952, "key", newJString(key))
  add(path_580951, "merchantId", newJString(merchantId))
  if body != nil:
    body_580953 = body
  add(query_580952, "prettyPrint", newJBool(prettyPrint))
  result = call_580950.call(path_580951, query_580952, nil, nil, body_580953)

var contentOrdersShiplineitems* = Call_ContentOrdersShiplineitems_580936(
    name: "contentOrdersShiplineitems", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/shipLineItems",
    validator: validate_ContentOrdersShiplineitems_580937, base: "/content/v2.1",
    url: url_ContentOrdersShiplineitems_580938, schemes: {Scheme.Https})
type
  Call_ContentOrdersCreatetestreturn_580954 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersCreatetestreturn_580956(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/testreturn")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersCreatetestreturn_580955(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sandbox only. Creates a test return.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   orderId: JString (required)
  ##          : The ID of the order.
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `orderId` field"
  var valid_580957 = path.getOrDefault("orderId")
  valid_580957 = validateParameter(valid_580957, JString, required = true,
                                 default = nil)
  if valid_580957 != nil:
    section.add "orderId", valid_580957
  var valid_580958 = path.getOrDefault("merchantId")
  valid_580958 = validateParameter(valid_580958, JString, required = true,
                                 default = nil)
  if valid_580958 != nil:
    section.add "merchantId", valid_580958
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
  var valid_580959 = query.getOrDefault("fields")
  valid_580959 = validateParameter(valid_580959, JString, required = false,
                                 default = nil)
  if valid_580959 != nil:
    section.add "fields", valid_580959
  var valid_580960 = query.getOrDefault("quotaUser")
  valid_580960 = validateParameter(valid_580960, JString, required = false,
                                 default = nil)
  if valid_580960 != nil:
    section.add "quotaUser", valid_580960
  var valid_580961 = query.getOrDefault("alt")
  valid_580961 = validateParameter(valid_580961, JString, required = false,
                                 default = newJString("json"))
  if valid_580961 != nil:
    section.add "alt", valid_580961
  var valid_580962 = query.getOrDefault("oauth_token")
  valid_580962 = validateParameter(valid_580962, JString, required = false,
                                 default = nil)
  if valid_580962 != nil:
    section.add "oauth_token", valid_580962
  var valid_580963 = query.getOrDefault("userIp")
  valid_580963 = validateParameter(valid_580963, JString, required = false,
                                 default = nil)
  if valid_580963 != nil:
    section.add "userIp", valid_580963
  var valid_580964 = query.getOrDefault("key")
  valid_580964 = validateParameter(valid_580964, JString, required = false,
                                 default = nil)
  if valid_580964 != nil:
    section.add "key", valid_580964
  var valid_580965 = query.getOrDefault("prettyPrint")
  valid_580965 = validateParameter(valid_580965, JBool, required = false,
                                 default = newJBool(true))
  if valid_580965 != nil:
    section.add "prettyPrint", valid_580965
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

proc call*(call_580967: Call_ContentOrdersCreatetestreturn_580954; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Creates a test return.
  ## 
  let valid = call_580967.validator(path, query, header, formData, body)
  let scheme = call_580967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580967.url(scheme.get, call_580967.host, call_580967.base,
                         call_580967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580967, url, valid)

proc call*(call_580968: Call_ContentOrdersCreatetestreturn_580954; orderId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentOrdersCreatetestreturn
  ## Sandbox only. Creates a test return.
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
  ##   orderId: string (required)
  ##          : The ID of the order.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580969 = newJObject()
  var query_580970 = newJObject()
  var body_580971 = newJObject()
  add(query_580970, "fields", newJString(fields))
  add(query_580970, "quotaUser", newJString(quotaUser))
  add(query_580970, "alt", newJString(alt))
  add(query_580970, "oauth_token", newJString(oauthToken))
  add(query_580970, "userIp", newJString(userIp))
  add(path_580969, "orderId", newJString(orderId))
  add(query_580970, "key", newJString(key))
  add(path_580969, "merchantId", newJString(merchantId))
  if body != nil:
    body_580971 = body
  add(query_580970, "prettyPrint", newJBool(prettyPrint))
  result = call_580968.call(path_580969, query_580970, nil, nil, body_580971)

var contentOrdersCreatetestreturn* = Call_ContentOrdersCreatetestreturn_580954(
    name: "contentOrdersCreatetestreturn", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/testreturn",
    validator: validate_ContentOrdersCreatetestreturn_580955,
    base: "/content/v2.1", url: url_ContentOrdersCreatetestreturn_580956,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdatelineitemshippingdetails_580972 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersUpdatelineitemshippingdetails_580974(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/updateLineItemShippingDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersUpdatelineitemshippingdetails_580973(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates ship by and delivery by dates for a line item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   orderId: JString (required)
  ##          : The ID of the order.
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `orderId` field"
  var valid_580975 = path.getOrDefault("orderId")
  valid_580975 = validateParameter(valid_580975, JString, required = true,
                                 default = nil)
  if valid_580975 != nil:
    section.add "orderId", valid_580975
  var valid_580976 = path.getOrDefault("merchantId")
  valid_580976 = validateParameter(valid_580976, JString, required = true,
                                 default = nil)
  if valid_580976 != nil:
    section.add "merchantId", valid_580976
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
  var valid_580977 = query.getOrDefault("fields")
  valid_580977 = validateParameter(valid_580977, JString, required = false,
                                 default = nil)
  if valid_580977 != nil:
    section.add "fields", valid_580977
  var valid_580978 = query.getOrDefault("quotaUser")
  valid_580978 = validateParameter(valid_580978, JString, required = false,
                                 default = nil)
  if valid_580978 != nil:
    section.add "quotaUser", valid_580978
  var valid_580979 = query.getOrDefault("alt")
  valid_580979 = validateParameter(valid_580979, JString, required = false,
                                 default = newJString("json"))
  if valid_580979 != nil:
    section.add "alt", valid_580979
  var valid_580980 = query.getOrDefault("oauth_token")
  valid_580980 = validateParameter(valid_580980, JString, required = false,
                                 default = nil)
  if valid_580980 != nil:
    section.add "oauth_token", valid_580980
  var valid_580981 = query.getOrDefault("userIp")
  valid_580981 = validateParameter(valid_580981, JString, required = false,
                                 default = nil)
  if valid_580981 != nil:
    section.add "userIp", valid_580981
  var valid_580982 = query.getOrDefault("key")
  valid_580982 = validateParameter(valid_580982, JString, required = false,
                                 default = nil)
  if valid_580982 != nil:
    section.add "key", valid_580982
  var valid_580983 = query.getOrDefault("prettyPrint")
  valid_580983 = validateParameter(valid_580983, JBool, required = false,
                                 default = newJBool(true))
  if valid_580983 != nil:
    section.add "prettyPrint", valid_580983
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

proc call*(call_580985: Call_ContentOrdersUpdatelineitemshippingdetails_580972;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates ship by and delivery by dates for a line item.
  ## 
  let valid = call_580985.validator(path, query, header, formData, body)
  let scheme = call_580985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580985.url(scheme.get, call_580985.host, call_580985.base,
                         call_580985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580985, url, valid)

proc call*(call_580986: Call_ContentOrdersUpdatelineitemshippingdetails_580972;
          orderId: string; merchantId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## contentOrdersUpdatelineitemshippingdetails
  ## Updates ship by and delivery by dates for a line item.
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
  ##   orderId: string (required)
  ##          : The ID of the order.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580987 = newJObject()
  var query_580988 = newJObject()
  var body_580989 = newJObject()
  add(query_580988, "fields", newJString(fields))
  add(query_580988, "quotaUser", newJString(quotaUser))
  add(query_580988, "alt", newJString(alt))
  add(query_580988, "oauth_token", newJString(oauthToken))
  add(query_580988, "userIp", newJString(userIp))
  add(path_580987, "orderId", newJString(orderId))
  add(query_580988, "key", newJString(key))
  add(path_580987, "merchantId", newJString(merchantId))
  if body != nil:
    body_580989 = body
  add(query_580988, "prettyPrint", newJBool(prettyPrint))
  result = call_580986.call(path_580987, query_580988, nil, nil, body_580989)

var contentOrdersUpdatelineitemshippingdetails* = Call_ContentOrdersUpdatelineitemshippingdetails_580972(
    name: "contentOrdersUpdatelineitemshippingdetails", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateLineItemShippingDetails",
    validator: validate_ContentOrdersUpdatelineitemshippingdetails_580973,
    base: "/content/v2.1", url: url_ContentOrdersUpdatelineitemshippingdetails_580974,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdatemerchantorderid_580990 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersUpdatemerchantorderid_580992(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/updateMerchantOrderId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersUpdatemerchantorderid_580991(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the merchant order ID for a given order.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   orderId: JString (required)
  ##          : The ID of the order.
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `orderId` field"
  var valid_580993 = path.getOrDefault("orderId")
  valid_580993 = validateParameter(valid_580993, JString, required = true,
                                 default = nil)
  if valid_580993 != nil:
    section.add "orderId", valid_580993
  var valid_580994 = path.getOrDefault("merchantId")
  valid_580994 = validateParameter(valid_580994, JString, required = true,
                                 default = nil)
  if valid_580994 != nil:
    section.add "merchantId", valid_580994
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
  var valid_580995 = query.getOrDefault("fields")
  valid_580995 = validateParameter(valid_580995, JString, required = false,
                                 default = nil)
  if valid_580995 != nil:
    section.add "fields", valid_580995
  var valid_580996 = query.getOrDefault("quotaUser")
  valid_580996 = validateParameter(valid_580996, JString, required = false,
                                 default = nil)
  if valid_580996 != nil:
    section.add "quotaUser", valid_580996
  var valid_580997 = query.getOrDefault("alt")
  valid_580997 = validateParameter(valid_580997, JString, required = false,
                                 default = newJString("json"))
  if valid_580997 != nil:
    section.add "alt", valid_580997
  var valid_580998 = query.getOrDefault("oauth_token")
  valid_580998 = validateParameter(valid_580998, JString, required = false,
                                 default = nil)
  if valid_580998 != nil:
    section.add "oauth_token", valid_580998
  var valid_580999 = query.getOrDefault("userIp")
  valid_580999 = validateParameter(valid_580999, JString, required = false,
                                 default = nil)
  if valid_580999 != nil:
    section.add "userIp", valid_580999
  var valid_581000 = query.getOrDefault("key")
  valid_581000 = validateParameter(valid_581000, JString, required = false,
                                 default = nil)
  if valid_581000 != nil:
    section.add "key", valid_581000
  var valid_581001 = query.getOrDefault("prettyPrint")
  valid_581001 = validateParameter(valid_581001, JBool, required = false,
                                 default = newJBool(true))
  if valid_581001 != nil:
    section.add "prettyPrint", valid_581001
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

proc call*(call_581003: Call_ContentOrdersUpdatemerchantorderid_580990;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the merchant order ID for a given order.
  ## 
  let valid = call_581003.validator(path, query, header, formData, body)
  let scheme = call_581003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581003.url(scheme.get, call_581003.host, call_581003.base,
                         call_581003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581003, url, valid)

proc call*(call_581004: Call_ContentOrdersUpdatemerchantorderid_580990;
          orderId: string; merchantId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## contentOrdersUpdatemerchantorderid
  ## Updates the merchant order ID for a given order.
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
  ##   orderId: string (required)
  ##          : The ID of the order.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581005 = newJObject()
  var query_581006 = newJObject()
  var body_581007 = newJObject()
  add(query_581006, "fields", newJString(fields))
  add(query_581006, "quotaUser", newJString(quotaUser))
  add(query_581006, "alt", newJString(alt))
  add(query_581006, "oauth_token", newJString(oauthToken))
  add(query_581006, "userIp", newJString(userIp))
  add(path_581005, "orderId", newJString(orderId))
  add(query_581006, "key", newJString(key))
  add(path_581005, "merchantId", newJString(merchantId))
  if body != nil:
    body_581007 = body
  add(query_581006, "prettyPrint", newJBool(prettyPrint))
  result = call_581004.call(path_581005, query_581006, nil, nil, body_581007)

var contentOrdersUpdatemerchantorderid* = Call_ContentOrdersUpdatemerchantorderid_580990(
    name: "contentOrdersUpdatemerchantorderid", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateMerchantOrderId",
    validator: validate_ContentOrdersUpdatemerchantorderid_580991,
    base: "/content/v2.1", url: url_ContentOrdersUpdatemerchantorderid_580992,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdateshipment_581008 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersUpdateshipment_581010(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/updateShipment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersUpdateshipment_581009(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a shipment's status, carrier, and/or tracking ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   orderId: JString (required)
  ##          : The ID of the order.
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `orderId` field"
  var valid_581011 = path.getOrDefault("orderId")
  valid_581011 = validateParameter(valid_581011, JString, required = true,
                                 default = nil)
  if valid_581011 != nil:
    section.add "orderId", valid_581011
  var valid_581012 = path.getOrDefault("merchantId")
  valid_581012 = validateParameter(valid_581012, JString, required = true,
                                 default = nil)
  if valid_581012 != nil:
    section.add "merchantId", valid_581012
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
  var valid_581013 = query.getOrDefault("fields")
  valid_581013 = validateParameter(valid_581013, JString, required = false,
                                 default = nil)
  if valid_581013 != nil:
    section.add "fields", valid_581013
  var valid_581014 = query.getOrDefault("quotaUser")
  valid_581014 = validateParameter(valid_581014, JString, required = false,
                                 default = nil)
  if valid_581014 != nil:
    section.add "quotaUser", valid_581014
  var valid_581015 = query.getOrDefault("alt")
  valid_581015 = validateParameter(valid_581015, JString, required = false,
                                 default = newJString("json"))
  if valid_581015 != nil:
    section.add "alt", valid_581015
  var valid_581016 = query.getOrDefault("oauth_token")
  valid_581016 = validateParameter(valid_581016, JString, required = false,
                                 default = nil)
  if valid_581016 != nil:
    section.add "oauth_token", valid_581016
  var valid_581017 = query.getOrDefault("userIp")
  valid_581017 = validateParameter(valid_581017, JString, required = false,
                                 default = nil)
  if valid_581017 != nil:
    section.add "userIp", valid_581017
  var valid_581018 = query.getOrDefault("key")
  valid_581018 = validateParameter(valid_581018, JString, required = false,
                                 default = nil)
  if valid_581018 != nil:
    section.add "key", valid_581018
  var valid_581019 = query.getOrDefault("prettyPrint")
  valid_581019 = validateParameter(valid_581019, JBool, required = false,
                                 default = newJBool(true))
  if valid_581019 != nil:
    section.add "prettyPrint", valid_581019
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

proc call*(call_581021: Call_ContentOrdersUpdateshipment_581008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a shipment's status, carrier, and/or tracking ID.
  ## 
  let valid = call_581021.validator(path, query, header, formData, body)
  let scheme = call_581021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581021.url(scheme.get, call_581021.host, call_581021.base,
                         call_581021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581021, url, valid)

proc call*(call_581022: Call_ContentOrdersUpdateshipment_581008; orderId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentOrdersUpdateshipment
  ## Updates a shipment's status, carrier, and/or tracking ID.
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
  ##   orderId: string (required)
  ##          : The ID of the order.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581023 = newJObject()
  var query_581024 = newJObject()
  var body_581025 = newJObject()
  add(query_581024, "fields", newJString(fields))
  add(query_581024, "quotaUser", newJString(quotaUser))
  add(query_581024, "alt", newJString(alt))
  add(query_581024, "oauth_token", newJString(oauthToken))
  add(query_581024, "userIp", newJString(userIp))
  add(path_581023, "orderId", newJString(orderId))
  add(query_581024, "key", newJString(key))
  add(path_581023, "merchantId", newJString(merchantId))
  if body != nil:
    body_581025 = body
  add(query_581024, "prettyPrint", newJBool(prettyPrint))
  result = call_581022.call(path_581023, query_581024, nil, nil, body_581025)

var contentOrdersUpdateshipment* = Call_ContentOrdersUpdateshipment_581008(
    name: "contentOrdersUpdateshipment", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateShipment",
    validator: validate_ContentOrdersUpdateshipment_581009, base: "/content/v2.1",
    url: url_ContentOrdersUpdateshipment_581010, schemes: {Scheme.Https})
type
  Call_ContentOrdersGetbymerchantorderid_581026 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersGetbymerchantorderid_581028(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "merchantOrderId" in path, "`merchantOrderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/ordersbymerchantid/"),
               (kind: VariableSegment, value: "merchantOrderId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersGetbymerchantorderid_581027(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves an order using merchant order ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantOrderId: JString (required)
  ##                  : The merchant order ID to be looked for.
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantOrderId` field"
  var valid_581029 = path.getOrDefault("merchantOrderId")
  valid_581029 = validateParameter(valid_581029, JString, required = true,
                                 default = nil)
  if valid_581029 != nil:
    section.add "merchantOrderId", valid_581029
  var valid_581030 = path.getOrDefault("merchantId")
  valid_581030 = validateParameter(valid_581030, JString, required = true,
                                 default = nil)
  if valid_581030 != nil:
    section.add "merchantId", valid_581030
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
  var valid_581031 = query.getOrDefault("fields")
  valid_581031 = validateParameter(valid_581031, JString, required = false,
                                 default = nil)
  if valid_581031 != nil:
    section.add "fields", valid_581031
  var valid_581032 = query.getOrDefault("quotaUser")
  valid_581032 = validateParameter(valid_581032, JString, required = false,
                                 default = nil)
  if valid_581032 != nil:
    section.add "quotaUser", valid_581032
  var valid_581033 = query.getOrDefault("alt")
  valid_581033 = validateParameter(valid_581033, JString, required = false,
                                 default = newJString("json"))
  if valid_581033 != nil:
    section.add "alt", valid_581033
  var valid_581034 = query.getOrDefault("oauth_token")
  valid_581034 = validateParameter(valid_581034, JString, required = false,
                                 default = nil)
  if valid_581034 != nil:
    section.add "oauth_token", valid_581034
  var valid_581035 = query.getOrDefault("userIp")
  valid_581035 = validateParameter(valid_581035, JString, required = false,
                                 default = nil)
  if valid_581035 != nil:
    section.add "userIp", valid_581035
  var valid_581036 = query.getOrDefault("key")
  valid_581036 = validateParameter(valid_581036, JString, required = false,
                                 default = nil)
  if valid_581036 != nil:
    section.add "key", valid_581036
  var valid_581037 = query.getOrDefault("prettyPrint")
  valid_581037 = validateParameter(valid_581037, JBool, required = false,
                                 default = newJBool(true))
  if valid_581037 != nil:
    section.add "prettyPrint", valid_581037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581038: Call_ContentOrdersGetbymerchantorderid_581026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves an order using merchant order ID.
  ## 
  let valid = call_581038.validator(path, query, header, formData, body)
  let scheme = call_581038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581038.url(scheme.get, call_581038.host, call_581038.base,
                         call_581038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581038, url, valid)

proc call*(call_581039: Call_ContentOrdersGetbymerchantorderid_581026;
          merchantOrderId: string; merchantId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentOrdersGetbymerchantorderid
  ## Retrieves an order using merchant order ID.
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
  ##   merchantOrderId: string (required)
  ##                  : The merchant order ID to be looked for.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581040 = newJObject()
  var query_581041 = newJObject()
  add(query_581041, "fields", newJString(fields))
  add(query_581041, "quotaUser", newJString(quotaUser))
  add(query_581041, "alt", newJString(alt))
  add(query_581041, "oauth_token", newJString(oauthToken))
  add(query_581041, "userIp", newJString(userIp))
  add(query_581041, "key", newJString(key))
  add(path_581040, "merchantOrderId", newJString(merchantOrderId))
  add(path_581040, "merchantId", newJString(merchantId))
  add(query_581041, "prettyPrint", newJBool(prettyPrint))
  result = call_581039.call(path_581040, query_581041, nil, nil, nil)

var contentOrdersGetbymerchantorderid* = Call_ContentOrdersGetbymerchantorderid_581026(
    name: "contentOrdersGetbymerchantorderid", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/ordersbymerchantid/{merchantOrderId}",
    validator: validate_ContentOrdersGetbymerchantorderid_581027,
    base: "/content/v2.1", url: url_ContentOrdersGetbymerchantorderid_581028,
    schemes: {Scheme.Https})
type
  Call_ContentPosInventory_581042 = ref object of OpenApiRestCall_579421
proc url_ContentPosInventory_581044(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "targetMerchantId" in path,
        "`targetMerchantId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/pos/"),
               (kind: VariableSegment, value: "targetMerchantId"),
               (kind: ConstantSegment, value: "/inventory")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentPosInventory_581043(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Submit inventory for the given merchant.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   targetMerchantId: JString (required)
  ##                   : The ID of the target merchant.
  ##   merchantId: JString (required)
  ##             : The ID of the POS or inventory data provider.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `targetMerchantId` field"
  var valid_581045 = path.getOrDefault("targetMerchantId")
  valid_581045 = validateParameter(valid_581045, JString, required = true,
                                 default = nil)
  if valid_581045 != nil:
    section.add "targetMerchantId", valid_581045
  var valid_581046 = path.getOrDefault("merchantId")
  valid_581046 = validateParameter(valid_581046, JString, required = true,
                                 default = nil)
  if valid_581046 != nil:
    section.add "merchantId", valid_581046
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
  var valid_581047 = query.getOrDefault("fields")
  valid_581047 = validateParameter(valid_581047, JString, required = false,
                                 default = nil)
  if valid_581047 != nil:
    section.add "fields", valid_581047
  var valid_581048 = query.getOrDefault("quotaUser")
  valid_581048 = validateParameter(valid_581048, JString, required = false,
                                 default = nil)
  if valid_581048 != nil:
    section.add "quotaUser", valid_581048
  var valid_581049 = query.getOrDefault("alt")
  valid_581049 = validateParameter(valid_581049, JString, required = false,
                                 default = newJString("json"))
  if valid_581049 != nil:
    section.add "alt", valid_581049
  var valid_581050 = query.getOrDefault("oauth_token")
  valid_581050 = validateParameter(valid_581050, JString, required = false,
                                 default = nil)
  if valid_581050 != nil:
    section.add "oauth_token", valid_581050
  var valid_581051 = query.getOrDefault("userIp")
  valid_581051 = validateParameter(valid_581051, JString, required = false,
                                 default = nil)
  if valid_581051 != nil:
    section.add "userIp", valid_581051
  var valid_581052 = query.getOrDefault("key")
  valid_581052 = validateParameter(valid_581052, JString, required = false,
                                 default = nil)
  if valid_581052 != nil:
    section.add "key", valid_581052
  var valid_581053 = query.getOrDefault("prettyPrint")
  valid_581053 = validateParameter(valid_581053, JBool, required = false,
                                 default = newJBool(true))
  if valid_581053 != nil:
    section.add "prettyPrint", valid_581053
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

proc call*(call_581055: Call_ContentPosInventory_581042; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit inventory for the given merchant.
  ## 
  let valid = call_581055.validator(path, query, header, formData, body)
  let scheme = call_581055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581055.url(scheme.get, call_581055.host, call_581055.base,
                         call_581055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581055, url, valid)

proc call*(call_581056: Call_ContentPosInventory_581042; targetMerchantId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentPosInventory
  ## Submit inventory for the given merchant.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   targetMerchantId: string (required)
  ##                   : The ID of the target merchant.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the POS or inventory data provider.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581057 = newJObject()
  var query_581058 = newJObject()
  var body_581059 = newJObject()
  add(query_581058, "fields", newJString(fields))
  add(query_581058, "quotaUser", newJString(quotaUser))
  add(query_581058, "alt", newJString(alt))
  add(path_581057, "targetMerchantId", newJString(targetMerchantId))
  add(query_581058, "oauth_token", newJString(oauthToken))
  add(query_581058, "userIp", newJString(userIp))
  add(query_581058, "key", newJString(key))
  add(path_581057, "merchantId", newJString(merchantId))
  if body != nil:
    body_581059 = body
  add(query_581058, "prettyPrint", newJBool(prettyPrint))
  result = call_581056.call(path_581057, query_581058, nil, nil, body_581059)

var contentPosInventory* = Call_ContentPosInventory_581042(
    name: "contentPosInventory", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/inventory",
    validator: validate_ContentPosInventory_581043, base: "/content/v2.1",
    url: url_ContentPosInventory_581044, schemes: {Scheme.Https})
type
  Call_ContentPosSale_581060 = ref object of OpenApiRestCall_579421
proc url_ContentPosSale_581062(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "targetMerchantId" in path,
        "`targetMerchantId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/pos/"),
               (kind: VariableSegment, value: "targetMerchantId"),
               (kind: ConstantSegment, value: "/sale")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentPosSale_581061(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Submit a sale event for the given merchant.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   targetMerchantId: JString (required)
  ##                   : The ID of the target merchant.
  ##   merchantId: JString (required)
  ##             : The ID of the POS or inventory data provider.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `targetMerchantId` field"
  var valid_581063 = path.getOrDefault("targetMerchantId")
  valid_581063 = validateParameter(valid_581063, JString, required = true,
                                 default = nil)
  if valid_581063 != nil:
    section.add "targetMerchantId", valid_581063
  var valid_581064 = path.getOrDefault("merchantId")
  valid_581064 = validateParameter(valid_581064, JString, required = true,
                                 default = nil)
  if valid_581064 != nil:
    section.add "merchantId", valid_581064
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
  var valid_581065 = query.getOrDefault("fields")
  valid_581065 = validateParameter(valid_581065, JString, required = false,
                                 default = nil)
  if valid_581065 != nil:
    section.add "fields", valid_581065
  var valid_581066 = query.getOrDefault("quotaUser")
  valid_581066 = validateParameter(valid_581066, JString, required = false,
                                 default = nil)
  if valid_581066 != nil:
    section.add "quotaUser", valid_581066
  var valid_581067 = query.getOrDefault("alt")
  valid_581067 = validateParameter(valid_581067, JString, required = false,
                                 default = newJString("json"))
  if valid_581067 != nil:
    section.add "alt", valid_581067
  var valid_581068 = query.getOrDefault("oauth_token")
  valid_581068 = validateParameter(valid_581068, JString, required = false,
                                 default = nil)
  if valid_581068 != nil:
    section.add "oauth_token", valid_581068
  var valid_581069 = query.getOrDefault("userIp")
  valid_581069 = validateParameter(valid_581069, JString, required = false,
                                 default = nil)
  if valid_581069 != nil:
    section.add "userIp", valid_581069
  var valid_581070 = query.getOrDefault("key")
  valid_581070 = validateParameter(valid_581070, JString, required = false,
                                 default = nil)
  if valid_581070 != nil:
    section.add "key", valid_581070
  var valid_581071 = query.getOrDefault("prettyPrint")
  valid_581071 = validateParameter(valid_581071, JBool, required = false,
                                 default = newJBool(true))
  if valid_581071 != nil:
    section.add "prettyPrint", valid_581071
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

proc call*(call_581073: Call_ContentPosSale_581060; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit a sale event for the given merchant.
  ## 
  let valid = call_581073.validator(path, query, header, formData, body)
  let scheme = call_581073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581073.url(scheme.get, call_581073.host, call_581073.base,
                         call_581073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581073, url, valid)

proc call*(call_581074: Call_ContentPosSale_581060; targetMerchantId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentPosSale
  ## Submit a sale event for the given merchant.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   targetMerchantId: string (required)
  ##                   : The ID of the target merchant.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the POS or inventory data provider.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581075 = newJObject()
  var query_581076 = newJObject()
  var body_581077 = newJObject()
  add(query_581076, "fields", newJString(fields))
  add(query_581076, "quotaUser", newJString(quotaUser))
  add(query_581076, "alt", newJString(alt))
  add(path_581075, "targetMerchantId", newJString(targetMerchantId))
  add(query_581076, "oauth_token", newJString(oauthToken))
  add(query_581076, "userIp", newJString(userIp))
  add(query_581076, "key", newJString(key))
  add(path_581075, "merchantId", newJString(merchantId))
  if body != nil:
    body_581077 = body
  add(query_581076, "prettyPrint", newJBool(prettyPrint))
  result = call_581074.call(path_581075, query_581076, nil, nil, body_581077)

var contentPosSale* = Call_ContentPosSale_581060(name: "contentPosSale",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/sale",
    validator: validate_ContentPosSale_581061, base: "/content/v2.1",
    url: url_ContentPosSale_581062, schemes: {Scheme.Https})
type
  Call_ContentPosInsert_581094 = ref object of OpenApiRestCall_579421
proc url_ContentPosInsert_581096(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "targetMerchantId" in path,
        "`targetMerchantId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/pos/"),
               (kind: VariableSegment, value: "targetMerchantId"),
               (kind: ConstantSegment, value: "/store")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentPosInsert_581095(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Creates a store for the given merchant.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   targetMerchantId: JString (required)
  ##                   : The ID of the target merchant.
  ##   merchantId: JString (required)
  ##             : The ID of the POS or inventory data provider.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `targetMerchantId` field"
  var valid_581097 = path.getOrDefault("targetMerchantId")
  valid_581097 = validateParameter(valid_581097, JString, required = true,
                                 default = nil)
  if valid_581097 != nil:
    section.add "targetMerchantId", valid_581097
  var valid_581098 = path.getOrDefault("merchantId")
  valid_581098 = validateParameter(valid_581098, JString, required = true,
                                 default = nil)
  if valid_581098 != nil:
    section.add "merchantId", valid_581098
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
  var valid_581099 = query.getOrDefault("fields")
  valid_581099 = validateParameter(valid_581099, JString, required = false,
                                 default = nil)
  if valid_581099 != nil:
    section.add "fields", valid_581099
  var valid_581100 = query.getOrDefault("quotaUser")
  valid_581100 = validateParameter(valid_581100, JString, required = false,
                                 default = nil)
  if valid_581100 != nil:
    section.add "quotaUser", valid_581100
  var valid_581101 = query.getOrDefault("alt")
  valid_581101 = validateParameter(valid_581101, JString, required = false,
                                 default = newJString("json"))
  if valid_581101 != nil:
    section.add "alt", valid_581101
  var valid_581102 = query.getOrDefault("oauth_token")
  valid_581102 = validateParameter(valid_581102, JString, required = false,
                                 default = nil)
  if valid_581102 != nil:
    section.add "oauth_token", valid_581102
  var valid_581103 = query.getOrDefault("userIp")
  valid_581103 = validateParameter(valid_581103, JString, required = false,
                                 default = nil)
  if valid_581103 != nil:
    section.add "userIp", valid_581103
  var valid_581104 = query.getOrDefault("key")
  valid_581104 = validateParameter(valid_581104, JString, required = false,
                                 default = nil)
  if valid_581104 != nil:
    section.add "key", valid_581104
  var valid_581105 = query.getOrDefault("prettyPrint")
  valid_581105 = validateParameter(valid_581105, JBool, required = false,
                                 default = newJBool(true))
  if valid_581105 != nil:
    section.add "prettyPrint", valid_581105
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

proc call*(call_581107: Call_ContentPosInsert_581094; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a store for the given merchant.
  ## 
  let valid = call_581107.validator(path, query, header, formData, body)
  let scheme = call_581107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581107.url(scheme.get, call_581107.host, call_581107.base,
                         call_581107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581107, url, valid)

proc call*(call_581108: Call_ContentPosInsert_581094; targetMerchantId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentPosInsert
  ## Creates a store for the given merchant.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   targetMerchantId: string (required)
  ##                   : The ID of the target merchant.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the POS or inventory data provider.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581109 = newJObject()
  var query_581110 = newJObject()
  var body_581111 = newJObject()
  add(query_581110, "fields", newJString(fields))
  add(query_581110, "quotaUser", newJString(quotaUser))
  add(query_581110, "alt", newJString(alt))
  add(path_581109, "targetMerchantId", newJString(targetMerchantId))
  add(query_581110, "oauth_token", newJString(oauthToken))
  add(query_581110, "userIp", newJString(userIp))
  add(query_581110, "key", newJString(key))
  add(path_581109, "merchantId", newJString(merchantId))
  if body != nil:
    body_581111 = body
  add(query_581110, "prettyPrint", newJBool(prettyPrint))
  result = call_581108.call(path_581109, query_581110, nil, nil, body_581111)

var contentPosInsert* = Call_ContentPosInsert_581094(name: "contentPosInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store",
    validator: validate_ContentPosInsert_581095, base: "/content/v2.1",
    url: url_ContentPosInsert_581096, schemes: {Scheme.Https})
type
  Call_ContentPosList_581078 = ref object of OpenApiRestCall_579421
proc url_ContentPosList_581080(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "targetMerchantId" in path,
        "`targetMerchantId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/pos/"),
               (kind: VariableSegment, value: "targetMerchantId"),
               (kind: ConstantSegment, value: "/store")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentPosList_581079(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists the stores of the target merchant.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   targetMerchantId: JString (required)
  ##                   : The ID of the target merchant.
  ##   merchantId: JString (required)
  ##             : The ID of the POS or inventory data provider.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `targetMerchantId` field"
  var valid_581081 = path.getOrDefault("targetMerchantId")
  valid_581081 = validateParameter(valid_581081, JString, required = true,
                                 default = nil)
  if valid_581081 != nil:
    section.add "targetMerchantId", valid_581081
  var valid_581082 = path.getOrDefault("merchantId")
  valid_581082 = validateParameter(valid_581082, JString, required = true,
                                 default = nil)
  if valid_581082 != nil:
    section.add "merchantId", valid_581082
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
  var valid_581083 = query.getOrDefault("fields")
  valid_581083 = validateParameter(valid_581083, JString, required = false,
                                 default = nil)
  if valid_581083 != nil:
    section.add "fields", valid_581083
  var valid_581084 = query.getOrDefault("quotaUser")
  valid_581084 = validateParameter(valid_581084, JString, required = false,
                                 default = nil)
  if valid_581084 != nil:
    section.add "quotaUser", valid_581084
  var valid_581085 = query.getOrDefault("alt")
  valid_581085 = validateParameter(valid_581085, JString, required = false,
                                 default = newJString("json"))
  if valid_581085 != nil:
    section.add "alt", valid_581085
  var valid_581086 = query.getOrDefault("oauth_token")
  valid_581086 = validateParameter(valid_581086, JString, required = false,
                                 default = nil)
  if valid_581086 != nil:
    section.add "oauth_token", valid_581086
  var valid_581087 = query.getOrDefault("userIp")
  valid_581087 = validateParameter(valid_581087, JString, required = false,
                                 default = nil)
  if valid_581087 != nil:
    section.add "userIp", valid_581087
  var valid_581088 = query.getOrDefault("key")
  valid_581088 = validateParameter(valid_581088, JString, required = false,
                                 default = nil)
  if valid_581088 != nil:
    section.add "key", valid_581088
  var valid_581089 = query.getOrDefault("prettyPrint")
  valid_581089 = validateParameter(valid_581089, JBool, required = false,
                                 default = newJBool(true))
  if valid_581089 != nil:
    section.add "prettyPrint", valid_581089
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581090: Call_ContentPosList_581078; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the stores of the target merchant.
  ## 
  let valid = call_581090.validator(path, query, header, formData, body)
  let scheme = call_581090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581090.url(scheme.get, call_581090.host, call_581090.base,
                         call_581090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581090, url, valid)

proc call*(call_581091: Call_ContentPosList_581078; targetMerchantId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentPosList
  ## Lists the stores of the target merchant.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   targetMerchantId: string (required)
  ##                   : The ID of the target merchant.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the POS or inventory data provider.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581092 = newJObject()
  var query_581093 = newJObject()
  add(query_581093, "fields", newJString(fields))
  add(query_581093, "quotaUser", newJString(quotaUser))
  add(query_581093, "alt", newJString(alt))
  add(path_581092, "targetMerchantId", newJString(targetMerchantId))
  add(query_581093, "oauth_token", newJString(oauthToken))
  add(query_581093, "userIp", newJString(userIp))
  add(query_581093, "key", newJString(key))
  add(path_581092, "merchantId", newJString(merchantId))
  add(query_581093, "prettyPrint", newJBool(prettyPrint))
  result = call_581091.call(path_581092, query_581093, nil, nil, nil)

var contentPosList* = Call_ContentPosList_581078(name: "contentPosList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store",
    validator: validate_ContentPosList_581079, base: "/content/v2.1",
    url: url_ContentPosList_581080, schemes: {Scheme.Https})
type
  Call_ContentPosGet_581112 = ref object of OpenApiRestCall_579421
proc url_ContentPosGet_581114(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "targetMerchantId" in path,
        "`targetMerchantId` is a required path parameter"
  assert "storeCode" in path, "`storeCode` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/pos/"),
               (kind: VariableSegment, value: "targetMerchantId"),
               (kind: ConstantSegment, value: "/store/"),
               (kind: VariableSegment, value: "storeCode")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentPosGet_581113(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves information about the given store.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   targetMerchantId: JString (required)
  ##                   : The ID of the target merchant.
  ##   storeCode: JString (required)
  ##            : A store code that is unique per merchant.
  ##   merchantId: JString (required)
  ##             : The ID of the POS or inventory data provider.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `targetMerchantId` field"
  var valid_581115 = path.getOrDefault("targetMerchantId")
  valid_581115 = validateParameter(valid_581115, JString, required = true,
                                 default = nil)
  if valid_581115 != nil:
    section.add "targetMerchantId", valid_581115
  var valid_581116 = path.getOrDefault("storeCode")
  valid_581116 = validateParameter(valid_581116, JString, required = true,
                                 default = nil)
  if valid_581116 != nil:
    section.add "storeCode", valid_581116
  var valid_581117 = path.getOrDefault("merchantId")
  valid_581117 = validateParameter(valid_581117, JString, required = true,
                                 default = nil)
  if valid_581117 != nil:
    section.add "merchantId", valid_581117
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
  var valid_581118 = query.getOrDefault("fields")
  valid_581118 = validateParameter(valid_581118, JString, required = false,
                                 default = nil)
  if valid_581118 != nil:
    section.add "fields", valid_581118
  var valid_581119 = query.getOrDefault("quotaUser")
  valid_581119 = validateParameter(valid_581119, JString, required = false,
                                 default = nil)
  if valid_581119 != nil:
    section.add "quotaUser", valid_581119
  var valid_581120 = query.getOrDefault("alt")
  valid_581120 = validateParameter(valid_581120, JString, required = false,
                                 default = newJString("json"))
  if valid_581120 != nil:
    section.add "alt", valid_581120
  var valid_581121 = query.getOrDefault("oauth_token")
  valid_581121 = validateParameter(valid_581121, JString, required = false,
                                 default = nil)
  if valid_581121 != nil:
    section.add "oauth_token", valid_581121
  var valid_581122 = query.getOrDefault("userIp")
  valid_581122 = validateParameter(valid_581122, JString, required = false,
                                 default = nil)
  if valid_581122 != nil:
    section.add "userIp", valid_581122
  var valid_581123 = query.getOrDefault("key")
  valid_581123 = validateParameter(valid_581123, JString, required = false,
                                 default = nil)
  if valid_581123 != nil:
    section.add "key", valid_581123
  var valid_581124 = query.getOrDefault("prettyPrint")
  valid_581124 = validateParameter(valid_581124, JBool, required = false,
                                 default = newJBool(true))
  if valid_581124 != nil:
    section.add "prettyPrint", valid_581124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581125: Call_ContentPosGet_581112; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about the given store.
  ## 
  let valid = call_581125.validator(path, query, header, formData, body)
  let scheme = call_581125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581125.url(scheme.get, call_581125.host, call_581125.base,
                         call_581125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581125, url, valid)

proc call*(call_581126: Call_ContentPosGet_581112; targetMerchantId: string;
          storeCode: string; merchantId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentPosGet
  ## Retrieves information about the given store.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   targetMerchantId: string (required)
  ##                   : The ID of the target merchant.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   storeCode: string (required)
  ##            : A store code that is unique per merchant.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the POS or inventory data provider.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581127 = newJObject()
  var query_581128 = newJObject()
  add(query_581128, "fields", newJString(fields))
  add(query_581128, "quotaUser", newJString(quotaUser))
  add(query_581128, "alt", newJString(alt))
  add(path_581127, "targetMerchantId", newJString(targetMerchantId))
  add(query_581128, "oauth_token", newJString(oauthToken))
  add(path_581127, "storeCode", newJString(storeCode))
  add(query_581128, "userIp", newJString(userIp))
  add(query_581128, "key", newJString(key))
  add(path_581127, "merchantId", newJString(merchantId))
  add(query_581128, "prettyPrint", newJBool(prettyPrint))
  result = call_581126.call(path_581127, query_581128, nil, nil, nil)

var contentPosGet* = Call_ContentPosGet_581112(name: "contentPosGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store/{storeCode}",
    validator: validate_ContentPosGet_581113, base: "/content/v2.1",
    url: url_ContentPosGet_581114, schemes: {Scheme.Https})
type
  Call_ContentPosDelete_581129 = ref object of OpenApiRestCall_579421
proc url_ContentPosDelete_581131(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "targetMerchantId" in path,
        "`targetMerchantId` is a required path parameter"
  assert "storeCode" in path, "`storeCode` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/pos/"),
               (kind: VariableSegment, value: "targetMerchantId"),
               (kind: ConstantSegment, value: "/store/"),
               (kind: VariableSegment, value: "storeCode")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentPosDelete_581130(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes a store for the given merchant.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   targetMerchantId: JString (required)
  ##                   : The ID of the target merchant.
  ##   storeCode: JString (required)
  ##            : A store code that is unique per merchant.
  ##   merchantId: JString (required)
  ##             : The ID of the POS or inventory data provider.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `targetMerchantId` field"
  var valid_581132 = path.getOrDefault("targetMerchantId")
  valid_581132 = validateParameter(valid_581132, JString, required = true,
                                 default = nil)
  if valid_581132 != nil:
    section.add "targetMerchantId", valid_581132
  var valid_581133 = path.getOrDefault("storeCode")
  valid_581133 = validateParameter(valid_581133, JString, required = true,
                                 default = nil)
  if valid_581133 != nil:
    section.add "storeCode", valid_581133
  var valid_581134 = path.getOrDefault("merchantId")
  valid_581134 = validateParameter(valid_581134, JString, required = true,
                                 default = nil)
  if valid_581134 != nil:
    section.add "merchantId", valid_581134
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
  var valid_581135 = query.getOrDefault("fields")
  valid_581135 = validateParameter(valid_581135, JString, required = false,
                                 default = nil)
  if valid_581135 != nil:
    section.add "fields", valid_581135
  var valid_581136 = query.getOrDefault("quotaUser")
  valid_581136 = validateParameter(valid_581136, JString, required = false,
                                 default = nil)
  if valid_581136 != nil:
    section.add "quotaUser", valid_581136
  var valid_581137 = query.getOrDefault("alt")
  valid_581137 = validateParameter(valid_581137, JString, required = false,
                                 default = newJString("json"))
  if valid_581137 != nil:
    section.add "alt", valid_581137
  var valid_581138 = query.getOrDefault("oauth_token")
  valid_581138 = validateParameter(valid_581138, JString, required = false,
                                 default = nil)
  if valid_581138 != nil:
    section.add "oauth_token", valid_581138
  var valid_581139 = query.getOrDefault("userIp")
  valid_581139 = validateParameter(valid_581139, JString, required = false,
                                 default = nil)
  if valid_581139 != nil:
    section.add "userIp", valid_581139
  var valid_581140 = query.getOrDefault("key")
  valid_581140 = validateParameter(valid_581140, JString, required = false,
                                 default = nil)
  if valid_581140 != nil:
    section.add "key", valid_581140
  var valid_581141 = query.getOrDefault("prettyPrint")
  valid_581141 = validateParameter(valid_581141, JBool, required = false,
                                 default = newJBool(true))
  if valid_581141 != nil:
    section.add "prettyPrint", valid_581141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581142: Call_ContentPosDelete_581129; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a store for the given merchant.
  ## 
  let valid = call_581142.validator(path, query, header, formData, body)
  let scheme = call_581142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581142.url(scheme.get, call_581142.host, call_581142.base,
                         call_581142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581142, url, valid)

proc call*(call_581143: Call_ContentPosDelete_581129; targetMerchantId: string;
          storeCode: string; merchantId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentPosDelete
  ## Deletes a store for the given merchant.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   targetMerchantId: string (required)
  ##                   : The ID of the target merchant.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   storeCode: string (required)
  ##            : A store code that is unique per merchant.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the POS or inventory data provider.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581144 = newJObject()
  var query_581145 = newJObject()
  add(query_581145, "fields", newJString(fields))
  add(query_581145, "quotaUser", newJString(quotaUser))
  add(query_581145, "alt", newJString(alt))
  add(path_581144, "targetMerchantId", newJString(targetMerchantId))
  add(query_581145, "oauth_token", newJString(oauthToken))
  add(path_581144, "storeCode", newJString(storeCode))
  add(query_581145, "userIp", newJString(userIp))
  add(query_581145, "key", newJString(key))
  add(path_581144, "merchantId", newJString(merchantId))
  add(query_581145, "prettyPrint", newJBool(prettyPrint))
  result = call_581143.call(path_581144, query_581145, nil, nil, nil)

var contentPosDelete* = Call_ContentPosDelete_581129(name: "contentPosDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store/{storeCode}",
    validator: validate_ContentPosDelete_581130, base: "/content/v2.1",
    url: url_ContentPosDelete_581131, schemes: {Scheme.Https})
type
  Call_ContentProductsInsert_581163 = ref object of OpenApiRestCall_579421
proc url_ContentProductsInsert_581165(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/products")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentProductsInsert_581164(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads a product to your Merchant Center account. If an item with the same channel, contentLanguage, offerId, and targetCountry already exists, this method updates that entry.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that contains the product. This account cannot be a multi-client account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_581166 = path.getOrDefault("merchantId")
  valid_581166 = validateParameter(valid_581166, JString, required = true,
                                 default = nil)
  if valid_581166 != nil:
    section.add "merchantId", valid_581166
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   feedId: JString
  ##         : The Content API Supplemental Feed ID.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_581167 = query.getOrDefault("fields")
  valid_581167 = validateParameter(valid_581167, JString, required = false,
                                 default = nil)
  if valid_581167 != nil:
    section.add "fields", valid_581167
  var valid_581168 = query.getOrDefault("quotaUser")
  valid_581168 = validateParameter(valid_581168, JString, required = false,
                                 default = nil)
  if valid_581168 != nil:
    section.add "quotaUser", valid_581168
  var valid_581169 = query.getOrDefault("alt")
  valid_581169 = validateParameter(valid_581169, JString, required = false,
                                 default = newJString("json"))
  if valid_581169 != nil:
    section.add "alt", valid_581169
  var valid_581170 = query.getOrDefault("feedId")
  valid_581170 = validateParameter(valid_581170, JString, required = false,
                                 default = nil)
  if valid_581170 != nil:
    section.add "feedId", valid_581170
  var valid_581171 = query.getOrDefault("oauth_token")
  valid_581171 = validateParameter(valid_581171, JString, required = false,
                                 default = nil)
  if valid_581171 != nil:
    section.add "oauth_token", valid_581171
  var valid_581172 = query.getOrDefault("userIp")
  valid_581172 = validateParameter(valid_581172, JString, required = false,
                                 default = nil)
  if valid_581172 != nil:
    section.add "userIp", valid_581172
  var valid_581173 = query.getOrDefault("key")
  valid_581173 = validateParameter(valid_581173, JString, required = false,
                                 default = nil)
  if valid_581173 != nil:
    section.add "key", valid_581173
  var valid_581174 = query.getOrDefault("prettyPrint")
  valid_581174 = validateParameter(valid_581174, JBool, required = false,
                                 default = newJBool(true))
  if valid_581174 != nil:
    section.add "prettyPrint", valid_581174
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

proc call*(call_581176: Call_ContentProductsInsert_581163; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a product to your Merchant Center account. If an item with the same channel, contentLanguage, offerId, and targetCountry already exists, this method updates that entry.
  ## 
  let valid = call_581176.validator(path, query, header, formData, body)
  let scheme = call_581176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581176.url(scheme.get, call_581176.host, call_581176.base,
                         call_581176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581176, url, valid)

proc call*(call_581177: Call_ContentProductsInsert_581163; merchantId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          feedId: string = ""; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentProductsInsert
  ## Uploads a product to your Merchant Center account. If an item with the same channel, contentLanguage, offerId, and targetCountry already exists, this method updates that entry.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   feedId: string
  ##         : The Content API Supplemental Feed ID.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that contains the product. This account cannot be a multi-client account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581178 = newJObject()
  var query_581179 = newJObject()
  var body_581180 = newJObject()
  add(query_581179, "fields", newJString(fields))
  add(query_581179, "quotaUser", newJString(quotaUser))
  add(query_581179, "alt", newJString(alt))
  add(query_581179, "feedId", newJString(feedId))
  add(query_581179, "oauth_token", newJString(oauthToken))
  add(query_581179, "userIp", newJString(userIp))
  add(query_581179, "key", newJString(key))
  add(path_581178, "merchantId", newJString(merchantId))
  if body != nil:
    body_581180 = body
  add(query_581179, "prettyPrint", newJBool(prettyPrint))
  result = call_581177.call(path_581178, query_581179, nil, nil, body_581180)

var contentProductsInsert* = Call_ContentProductsInsert_581163(
    name: "contentProductsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/products",
    validator: validate_ContentProductsInsert_581164, base: "/content/v2.1",
    url: url_ContentProductsInsert_581165, schemes: {Scheme.Https})
type
  Call_ContentProductsList_581146 = ref object of OpenApiRestCall_579421
proc url_ContentProductsList_581148(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/products")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentProductsList_581147(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists the products in your Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that contains the products. This account cannot be a multi-client account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_581149 = path.getOrDefault("merchantId")
  valid_581149 = validateParameter(valid_581149, JString, required = true,
                                 default = nil)
  if valid_581149 != nil:
    section.add "merchantId", valid_581149
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of products to return in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_581150 = query.getOrDefault("fields")
  valid_581150 = validateParameter(valid_581150, JString, required = false,
                                 default = nil)
  if valid_581150 != nil:
    section.add "fields", valid_581150
  var valid_581151 = query.getOrDefault("pageToken")
  valid_581151 = validateParameter(valid_581151, JString, required = false,
                                 default = nil)
  if valid_581151 != nil:
    section.add "pageToken", valid_581151
  var valid_581152 = query.getOrDefault("quotaUser")
  valid_581152 = validateParameter(valid_581152, JString, required = false,
                                 default = nil)
  if valid_581152 != nil:
    section.add "quotaUser", valid_581152
  var valid_581153 = query.getOrDefault("alt")
  valid_581153 = validateParameter(valid_581153, JString, required = false,
                                 default = newJString("json"))
  if valid_581153 != nil:
    section.add "alt", valid_581153
  var valid_581154 = query.getOrDefault("oauth_token")
  valid_581154 = validateParameter(valid_581154, JString, required = false,
                                 default = nil)
  if valid_581154 != nil:
    section.add "oauth_token", valid_581154
  var valid_581155 = query.getOrDefault("userIp")
  valid_581155 = validateParameter(valid_581155, JString, required = false,
                                 default = nil)
  if valid_581155 != nil:
    section.add "userIp", valid_581155
  var valid_581156 = query.getOrDefault("maxResults")
  valid_581156 = validateParameter(valid_581156, JInt, required = false, default = nil)
  if valid_581156 != nil:
    section.add "maxResults", valid_581156
  var valid_581157 = query.getOrDefault("key")
  valid_581157 = validateParameter(valid_581157, JString, required = false,
                                 default = nil)
  if valid_581157 != nil:
    section.add "key", valid_581157
  var valid_581158 = query.getOrDefault("prettyPrint")
  valid_581158 = validateParameter(valid_581158, JBool, required = false,
                                 default = newJBool(true))
  if valid_581158 != nil:
    section.add "prettyPrint", valid_581158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581159: Call_ContentProductsList_581146; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the products in your Merchant Center account.
  ## 
  let valid = call_581159.validator(path, query, header, formData, body)
  let scheme = call_581159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581159.url(scheme.get, call_581159.host, call_581159.base,
                         call_581159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581159, url, valid)

proc call*(call_581160: Call_ContentProductsList_581146; merchantId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentProductsList
  ## Lists the products in your Merchant Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of products to return in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that contains the products. This account cannot be a multi-client account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581161 = newJObject()
  var query_581162 = newJObject()
  add(query_581162, "fields", newJString(fields))
  add(query_581162, "pageToken", newJString(pageToken))
  add(query_581162, "quotaUser", newJString(quotaUser))
  add(query_581162, "alt", newJString(alt))
  add(query_581162, "oauth_token", newJString(oauthToken))
  add(query_581162, "userIp", newJString(userIp))
  add(query_581162, "maxResults", newJInt(maxResults))
  add(query_581162, "key", newJString(key))
  add(path_581161, "merchantId", newJString(merchantId))
  add(query_581162, "prettyPrint", newJBool(prettyPrint))
  result = call_581160.call(path_581161, query_581162, nil, nil, nil)

var contentProductsList* = Call_ContentProductsList_581146(
    name: "contentProductsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/products",
    validator: validate_ContentProductsList_581147, base: "/content/v2.1",
    url: url_ContentProductsList_581148, schemes: {Scheme.Https})
type
  Call_ContentProductsGet_581181 = ref object of OpenApiRestCall_579421
proc url_ContentProductsGet_581183(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentProductsGet_581182(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves a product from your Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that contains the product. This account cannot be a multi-client account.
  ##   productId: JString (required)
  ##            : The REST ID of the product.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_581184 = path.getOrDefault("merchantId")
  valid_581184 = validateParameter(valid_581184, JString, required = true,
                                 default = nil)
  if valid_581184 != nil:
    section.add "merchantId", valid_581184
  var valid_581185 = path.getOrDefault("productId")
  valid_581185 = validateParameter(valid_581185, JString, required = true,
                                 default = nil)
  if valid_581185 != nil:
    section.add "productId", valid_581185
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
  var valid_581186 = query.getOrDefault("fields")
  valid_581186 = validateParameter(valid_581186, JString, required = false,
                                 default = nil)
  if valid_581186 != nil:
    section.add "fields", valid_581186
  var valid_581187 = query.getOrDefault("quotaUser")
  valid_581187 = validateParameter(valid_581187, JString, required = false,
                                 default = nil)
  if valid_581187 != nil:
    section.add "quotaUser", valid_581187
  var valid_581188 = query.getOrDefault("alt")
  valid_581188 = validateParameter(valid_581188, JString, required = false,
                                 default = newJString("json"))
  if valid_581188 != nil:
    section.add "alt", valid_581188
  var valid_581189 = query.getOrDefault("oauth_token")
  valid_581189 = validateParameter(valid_581189, JString, required = false,
                                 default = nil)
  if valid_581189 != nil:
    section.add "oauth_token", valid_581189
  var valid_581190 = query.getOrDefault("userIp")
  valid_581190 = validateParameter(valid_581190, JString, required = false,
                                 default = nil)
  if valid_581190 != nil:
    section.add "userIp", valid_581190
  var valid_581191 = query.getOrDefault("key")
  valid_581191 = validateParameter(valid_581191, JString, required = false,
                                 default = nil)
  if valid_581191 != nil:
    section.add "key", valid_581191
  var valid_581192 = query.getOrDefault("prettyPrint")
  valid_581192 = validateParameter(valid_581192, JBool, required = false,
                                 default = newJBool(true))
  if valid_581192 != nil:
    section.add "prettyPrint", valid_581192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581193: Call_ContentProductsGet_581181; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a product from your Merchant Center account.
  ## 
  let valid = call_581193.validator(path, query, header, formData, body)
  let scheme = call_581193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581193.url(scheme.get, call_581193.host, call_581193.base,
                         call_581193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581193, url, valid)

proc call*(call_581194: Call_ContentProductsGet_581181; merchantId: string;
          productId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentProductsGet
  ## Retrieves a product from your Merchant Center account.
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
  ##   merchantId: string (required)
  ##             : The ID of the account that contains the product. This account cannot be a multi-client account.
  ##   productId: string (required)
  ##            : The REST ID of the product.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581195 = newJObject()
  var query_581196 = newJObject()
  add(query_581196, "fields", newJString(fields))
  add(query_581196, "quotaUser", newJString(quotaUser))
  add(query_581196, "alt", newJString(alt))
  add(query_581196, "oauth_token", newJString(oauthToken))
  add(query_581196, "userIp", newJString(userIp))
  add(query_581196, "key", newJString(key))
  add(path_581195, "merchantId", newJString(merchantId))
  add(path_581195, "productId", newJString(productId))
  add(query_581196, "prettyPrint", newJBool(prettyPrint))
  result = call_581194.call(path_581195, query_581196, nil, nil, nil)

var contentProductsGet* = Call_ContentProductsGet_581181(
    name: "contentProductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/products/{productId}",
    validator: validate_ContentProductsGet_581182, base: "/content/v2.1",
    url: url_ContentProductsGet_581183, schemes: {Scheme.Https})
type
  Call_ContentProductsDelete_581197 = ref object of OpenApiRestCall_579421
proc url_ContentProductsDelete_581199(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentProductsDelete_581198(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a product from your Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that contains the product. This account cannot be a multi-client account.
  ##   productId: JString (required)
  ##            : The REST ID of the product.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_581200 = path.getOrDefault("merchantId")
  valid_581200 = validateParameter(valid_581200, JString, required = true,
                                 default = nil)
  if valid_581200 != nil:
    section.add "merchantId", valid_581200
  var valid_581201 = path.getOrDefault("productId")
  valid_581201 = validateParameter(valid_581201, JString, required = true,
                                 default = nil)
  if valid_581201 != nil:
    section.add "productId", valid_581201
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   feedId: JString
  ##         : The Content API Supplemental Feed ID.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_581202 = query.getOrDefault("fields")
  valid_581202 = validateParameter(valid_581202, JString, required = false,
                                 default = nil)
  if valid_581202 != nil:
    section.add "fields", valid_581202
  var valid_581203 = query.getOrDefault("quotaUser")
  valid_581203 = validateParameter(valid_581203, JString, required = false,
                                 default = nil)
  if valid_581203 != nil:
    section.add "quotaUser", valid_581203
  var valid_581204 = query.getOrDefault("alt")
  valid_581204 = validateParameter(valid_581204, JString, required = false,
                                 default = newJString("json"))
  if valid_581204 != nil:
    section.add "alt", valid_581204
  var valid_581205 = query.getOrDefault("feedId")
  valid_581205 = validateParameter(valid_581205, JString, required = false,
                                 default = nil)
  if valid_581205 != nil:
    section.add "feedId", valid_581205
  var valid_581206 = query.getOrDefault("oauth_token")
  valid_581206 = validateParameter(valid_581206, JString, required = false,
                                 default = nil)
  if valid_581206 != nil:
    section.add "oauth_token", valid_581206
  var valid_581207 = query.getOrDefault("userIp")
  valid_581207 = validateParameter(valid_581207, JString, required = false,
                                 default = nil)
  if valid_581207 != nil:
    section.add "userIp", valid_581207
  var valid_581208 = query.getOrDefault("key")
  valid_581208 = validateParameter(valid_581208, JString, required = false,
                                 default = nil)
  if valid_581208 != nil:
    section.add "key", valid_581208
  var valid_581209 = query.getOrDefault("prettyPrint")
  valid_581209 = validateParameter(valid_581209, JBool, required = false,
                                 default = newJBool(true))
  if valid_581209 != nil:
    section.add "prettyPrint", valid_581209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581210: Call_ContentProductsDelete_581197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a product from your Merchant Center account.
  ## 
  let valid = call_581210.validator(path, query, header, formData, body)
  let scheme = call_581210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581210.url(scheme.get, call_581210.host, call_581210.base,
                         call_581210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581210, url, valid)

proc call*(call_581211: Call_ContentProductsDelete_581197; merchantId: string;
          productId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; feedId: string = ""; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentProductsDelete
  ## Deletes a product from your Merchant Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   feedId: string
  ##         : The Content API Supplemental Feed ID.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that contains the product. This account cannot be a multi-client account.
  ##   productId: string (required)
  ##            : The REST ID of the product.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581212 = newJObject()
  var query_581213 = newJObject()
  add(query_581213, "fields", newJString(fields))
  add(query_581213, "quotaUser", newJString(quotaUser))
  add(query_581213, "alt", newJString(alt))
  add(query_581213, "feedId", newJString(feedId))
  add(query_581213, "oauth_token", newJString(oauthToken))
  add(query_581213, "userIp", newJString(userIp))
  add(query_581213, "key", newJString(key))
  add(path_581212, "merchantId", newJString(merchantId))
  add(path_581212, "productId", newJString(productId))
  add(query_581213, "prettyPrint", newJBool(prettyPrint))
  result = call_581211.call(path_581212, query_581213, nil, nil, nil)

var contentProductsDelete* = Call_ContentProductsDelete_581197(
    name: "contentProductsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/products/{productId}",
    validator: validate_ContentProductsDelete_581198, base: "/content/v2.1",
    url: url_ContentProductsDelete_581199, schemes: {Scheme.Https})
type
  Call_ContentRegionalinventoryInsert_581214 = ref object of OpenApiRestCall_579421
proc url_ContentRegionalinventoryInsert_581216(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/regionalinventory")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentRegionalinventoryInsert_581215(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the regional inventory of a product in your Merchant Center account. If a regional inventory with the same region ID already exists, this method updates that entry.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that contains the product. This account cannot be a multi-client account.
  ##   productId: JString (required)
  ##            : The REST ID of the product for which to update the regional inventory.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_581217 = path.getOrDefault("merchantId")
  valid_581217 = validateParameter(valid_581217, JString, required = true,
                                 default = nil)
  if valid_581217 != nil:
    section.add "merchantId", valid_581217
  var valid_581218 = path.getOrDefault("productId")
  valid_581218 = validateParameter(valid_581218, JString, required = true,
                                 default = nil)
  if valid_581218 != nil:
    section.add "productId", valid_581218
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
  var valid_581219 = query.getOrDefault("fields")
  valid_581219 = validateParameter(valid_581219, JString, required = false,
                                 default = nil)
  if valid_581219 != nil:
    section.add "fields", valid_581219
  var valid_581220 = query.getOrDefault("quotaUser")
  valid_581220 = validateParameter(valid_581220, JString, required = false,
                                 default = nil)
  if valid_581220 != nil:
    section.add "quotaUser", valid_581220
  var valid_581221 = query.getOrDefault("alt")
  valid_581221 = validateParameter(valid_581221, JString, required = false,
                                 default = newJString("json"))
  if valid_581221 != nil:
    section.add "alt", valid_581221
  var valid_581222 = query.getOrDefault("oauth_token")
  valid_581222 = validateParameter(valid_581222, JString, required = false,
                                 default = nil)
  if valid_581222 != nil:
    section.add "oauth_token", valid_581222
  var valid_581223 = query.getOrDefault("userIp")
  valid_581223 = validateParameter(valid_581223, JString, required = false,
                                 default = nil)
  if valid_581223 != nil:
    section.add "userIp", valid_581223
  var valid_581224 = query.getOrDefault("key")
  valid_581224 = validateParameter(valid_581224, JString, required = false,
                                 default = nil)
  if valid_581224 != nil:
    section.add "key", valid_581224
  var valid_581225 = query.getOrDefault("prettyPrint")
  valid_581225 = validateParameter(valid_581225, JBool, required = false,
                                 default = newJBool(true))
  if valid_581225 != nil:
    section.add "prettyPrint", valid_581225
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

proc call*(call_581227: Call_ContentRegionalinventoryInsert_581214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the regional inventory of a product in your Merchant Center account. If a regional inventory with the same region ID already exists, this method updates that entry.
  ## 
  let valid = call_581227.validator(path, query, header, formData, body)
  let scheme = call_581227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581227.url(scheme.get, call_581227.host, call_581227.base,
                         call_581227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581227, url, valid)

proc call*(call_581228: Call_ContentRegionalinventoryInsert_581214;
          merchantId: string; productId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## contentRegionalinventoryInsert
  ## Update the regional inventory of a product in your Merchant Center account. If a regional inventory with the same region ID already exists, this method updates that entry.
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
  ##   merchantId: string (required)
  ##             : The ID of the account that contains the product. This account cannot be a multi-client account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   productId: string (required)
  ##            : The REST ID of the product for which to update the regional inventory.
  var path_581229 = newJObject()
  var query_581230 = newJObject()
  var body_581231 = newJObject()
  add(query_581230, "fields", newJString(fields))
  add(query_581230, "quotaUser", newJString(quotaUser))
  add(query_581230, "alt", newJString(alt))
  add(query_581230, "oauth_token", newJString(oauthToken))
  add(query_581230, "userIp", newJString(userIp))
  add(query_581230, "key", newJString(key))
  add(path_581229, "merchantId", newJString(merchantId))
  if body != nil:
    body_581231 = body
  add(query_581230, "prettyPrint", newJBool(prettyPrint))
  add(path_581229, "productId", newJString(productId))
  result = call_581228.call(path_581229, query_581230, nil, nil, body_581231)

var contentRegionalinventoryInsert* = Call_ContentRegionalinventoryInsert_581214(
    name: "contentRegionalinventoryInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/products/{productId}/regionalinventory",
    validator: validate_ContentRegionalinventoryInsert_581215,
    base: "/content/v2.1", url: url_ContentRegionalinventoryInsert_581216,
    schemes: {Scheme.Https})
type
  Call_ContentProductstatusesList_581232 = ref object of OpenApiRestCall_579421
proc url_ContentProductstatusesList_581234(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/productstatuses")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentProductstatusesList_581233(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the statuses of the products in your Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that contains the products. This account cannot be a multi-client account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_581235 = path.getOrDefault("merchantId")
  valid_581235 = validateParameter(valid_581235, JString, required = true,
                                 default = nil)
  if valid_581235 != nil:
    section.add "merchantId", valid_581235
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of product statuses to return in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   destinations: JArray
  ##               : If set, only issues for the specified destinations are returned, otherwise only issues for the Shopping destination.
  section = newJObject()
  var valid_581236 = query.getOrDefault("fields")
  valid_581236 = validateParameter(valid_581236, JString, required = false,
                                 default = nil)
  if valid_581236 != nil:
    section.add "fields", valid_581236
  var valid_581237 = query.getOrDefault("pageToken")
  valid_581237 = validateParameter(valid_581237, JString, required = false,
                                 default = nil)
  if valid_581237 != nil:
    section.add "pageToken", valid_581237
  var valid_581238 = query.getOrDefault("quotaUser")
  valid_581238 = validateParameter(valid_581238, JString, required = false,
                                 default = nil)
  if valid_581238 != nil:
    section.add "quotaUser", valid_581238
  var valid_581239 = query.getOrDefault("alt")
  valid_581239 = validateParameter(valid_581239, JString, required = false,
                                 default = newJString("json"))
  if valid_581239 != nil:
    section.add "alt", valid_581239
  var valid_581240 = query.getOrDefault("oauth_token")
  valid_581240 = validateParameter(valid_581240, JString, required = false,
                                 default = nil)
  if valid_581240 != nil:
    section.add "oauth_token", valid_581240
  var valid_581241 = query.getOrDefault("userIp")
  valid_581241 = validateParameter(valid_581241, JString, required = false,
                                 default = nil)
  if valid_581241 != nil:
    section.add "userIp", valid_581241
  var valid_581242 = query.getOrDefault("maxResults")
  valid_581242 = validateParameter(valid_581242, JInt, required = false, default = nil)
  if valid_581242 != nil:
    section.add "maxResults", valid_581242
  var valid_581243 = query.getOrDefault("key")
  valid_581243 = validateParameter(valid_581243, JString, required = false,
                                 default = nil)
  if valid_581243 != nil:
    section.add "key", valid_581243
  var valid_581244 = query.getOrDefault("prettyPrint")
  valid_581244 = validateParameter(valid_581244, JBool, required = false,
                                 default = newJBool(true))
  if valid_581244 != nil:
    section.add "prettyPrint", valid_581244
  var valid_581245 = query.getOrDefault("destinations")
  valid_581245 = validateParameter(valid_581245, JArray, required = false,
                                 default = nil)
  if valid_581245 != nil:
    section.add "destinations", valid_581245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581246: Call_ContentProductstatusesList_581232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the products in your Merchant Center account.
  ## 
  let valid = call_581246.validator(path, query, header, formData, body)
  let scheme = call_581246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581246.url(scheme.get, call_581246.host, call_581246.base,
                         call_581246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581246, url, valid)

proc call*(call_581247: Call_ContentProductstatusesList_581232; merchantId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true;
          destinations: JsonNode = nil): Recallable =
  ## contentProductstatusesList
  ## Lists the statuses of the products in your Merchant Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of product statuses to return in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that contains the products. This account cannot be a multi-client account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   destinations: JArray
  ##               : If set, only issues for the specified destinations are returned, otherwise only issues for the Shopping destination.
  var path_581248 = newJObject()
  var query_581249 = newJObject()
  add(query_581249, "fields", newJString(fields))
  add(query_581249, "pageToken", newJString(pageToken))
  add(query_581249, "quotaUser", newJString(quotaUser))
  add(query_581249, "alt", newJString(alt))
  add(query_581249, "oauth_token", newJString(oauthToken))
  add(query_581249, "userIp", newJString(userIp))
  add(query_581249, "maxResults", newJInt(maxResults))
  add(query_581249, "key", newJString(key))
  add(path_581248, "merchantId", newJString(merchantId))
  add(query_581249, "prettyPrint", newJBool(prettyPrint))
  if destinations != nil:
    query_581249.add "destinations", destinations
  result = call_581247.call(path_581248, query_581249, nil, nil, nil)

var contentProductstatusesList* = Call_ContentProductstatusesList_581232(
    name: "contentProductstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/productstatuses",
    validator: validate_ContentProductstatusesList_581233, base: "/content/v2.1",
    url: url_ContentProductstatusesList_581234, schemes: {Scheme.Https})
type
  Call_ContentProductstatusesGet_581250 = ref object of OpenApiRestCall_579421
proc url_ContentProductstatusesGet_581252(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/productstatuses/"),
               (kind: VariableSegment, value: "productId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentProductstatusesGet_581251(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the status of a product from your Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that contains the product. This account cannot be a multi-client account.
  ##   productId: JString (required)
  ##            : The REST ID of the product.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_581253 = path.getOrDefault("merchantId")
  valid_581253 = validateParameter(valid_581253, JString, required = true,
                                 default = nil)
  if valid_581253 != nil:
    section.add "merchantId", valid_581253
  var valid_581254 = path.getOrDefault("productId")
  valid_581254 = validateParameter(valid_581254, JString, required = true,
                                 default = nil)
  if valid_581254 != nil:
    section.add "productId", valid_581254
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
  ##   destinations: JArray
  ##               : If set, only issues for the specified destinations are returned, otherwise only issues for the Shopping destination.
  section = newJObject()
  var valid_581255 = query.getOrDefault("fields")
  valid_581255 = validateParameter(valid_581255, JString, required = false,
                                 default = nil)
  if valid_581255 != nil:
    section.add "fields", valid_581255
  var valid_581256 = query.getOrDefault("quotaUser")
  valid_581256 = validateParameter(valid_581256, JString, required = false,
                                 default = nil)
  if valid_581256 != nil:
    section.add "quotaUser", valid_581256
  var valid_581257 = query.getOrDefault("alt")
  valid_581257 = validateParameter(valid_581257, JString, required = false,
                                 default = newJString("json"))
  if valid_581257 != nil:
    section.add "alt", valid_581257
  var valid_581258 = query.getOrDefault("oauth_token")
  valid_581258 = validateParameter(valid_581258, JString, required = false,
                                 default = nil)
  if valid_581258 != nil:
    section.add "oauth_token", valid_581258
  var valid_581259 = query.getOrDefault("userIp")
  valid_581259 = validateParameter(valid_581259, JString, required = false,
                                 default = nil)
  if valid_581259 != nil:
    section.add "userIp", valid_581259
  var valid_581260 = query.getOrDefault("key")
  valid_581260 = validateParameter(valid_581260, JString, required = false,
                                 default = nil)
  if valid_581260 != nil:
    section.add "key", valid_581260
  var valid_581261 = query.getOrDefault("prettyPrint")
  valid_581261 = validateParameter(valid_581261, JBool, required = false,
                                 default = newJBool(true))
  if valid_581261 != nil:
    section.add "prettyPrint", valid_581261
  var valid_581262 = query.getOrDefault("destinations")
  valid_581262 = validateParameter(valid_581262, JArray, required = false,
                                 default = nil)
  if valid_581262 != nil:
    section.add "destinations", valid_581262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581263: Call_ContentProductstatusesGet_581250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the status of a product from your Merchant Center account.
  ## 
  let valid = call_581263.validator(path, query, header, formData, body)
  let scheme = call_581263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581263.url(scheme.get, call_581263.host, call_581263.base,
                         call_581263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581263, url, valid)

proc call*(call_581264: Call_ContentProductstatusesGet_581250; merchantId: string;
          productId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true; destinations: JsonNode = nil): Recallable =
  ## contentProductstatusesGet
  ## Gets the status of a product from your Merchant Center account.
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
  ##   merchantId: string (required)
  ##             : The ID of the account that contains the product. This account cannot be a multi-client account.
  ##   productId: string (required)
  ##            : The REST ID of the product.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   destinations: JArray
  ##               : If set, only issues for the specified destinations are returned, otherwise only issues for the Shopping destination.
  var path_581265 = newJObject()
  var query_581266 = newJObject()
  add(query_581266, "fields", newJString(fields))
  add(query_581266, "quotaUser", newJString(quotaUser))
  add(query_581266, "alt", newJString(alt))
  add(query_581266, "oauth_token", newJString(oauthToken))
  add(query_581266, "userIp", newJString(userIp))
  add(query_581266, "key", newJString(key))
  add(path_581265, "merchantId", newJString(merchantId))
  add(path_581265, "productId", newJString(productId))
  add(query_581266, "prettyPrint", newJBool(prettyPrint))
  if destinations != nil:
    query_581266.add "destinations", destinations
  result = call_581264.call(path_581265, query_581266, nil, nil, nil)

var contentProductstatusesGet* = Call_ContentProductstatusesGet_581250(
    name: "contentProductstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/productstatuses/{productId}",
    validator: validate_ContentProductstatusesGet_581251, base: "/content/v2.1",
    url: url_ContentProductstatusesGet_581252, schemes: {Scheme.Https})
type
  Call_ContentReturnaddressInsert_581285 = ref object of OpenApiRestCall_579421
proc url_ContentReturnaddressInsert_581287(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/returnaddress")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentReturnaddressInsert_581286(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a return address for the Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The Merchant Center account to insert a return address for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_581288 = path.getOrDefault("merchantId")
  valid_581288 = validateParameter(valid_581288, JString, required = true,
                                 default = nil)
  if valid_581288 != nil:
    section.add "merchantId", valid_581288
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
  var valid_581289 = query.getOrDefault("fields")
  valid_581289 = validateParameter(valid_581289, JString, required = false,
                                 default = nil)
  if valid_581289 != nil:
    section.add "fields", valid_581289
  var valid_581290 = query.getOrDefault("quotaUser")
  valid_581290 = validateParameter(valid_581290, JString, required = false,
                                 default = nil)
  if valid_581290 != nil:
    section.add "quotaUser", valid_581290
  var valid_581291 = query.getOrDefault("alt")
  valid_581291 = validateParameter(valid_581291, JString, required = false,
                                 default = newJString("json"))
  if valid_581291 != nil:
    section.add "alt", valid_581291
  var valid_581292 = query.getOrDefault("oauth_token")
  valid_581292 = validateParameter(valid_581292, JString, required = false,
                                 default = nil)
  if valid_581292 != nil:
    section.add "oauth_token", valid_581292
  var valid_581293 = query.getOrDefault("userIp")
  valid_581293 = validateParameter(valid_581293, JString, required = false,
                                 default = nil)
  if valid_581293 != nil:
    section.add "userIp", valid_581293
  var valid_581294 = query.getOrDefault("key")
  valid_581294 = validateParameter(valid_581294, JString, required = false,
                                 default = nil)
  if valid_581294 != nil:
    section.add "key", valid_581294
  var valid_581295 = query.getOrDefault("prettyPrint")
  valid_581295 = validateParameter(valid_581295, JBool, required = false,
                                 default = newJBool(true))
  if valid_581295 != nil:
    section.add "prettyPrint", valid_581295
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

proc call*(call_581297: Call_ContentReturnaddressInsert_581285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a return address for the Merchant Center account.
  ## 
  let valid = call_581297.validator(path, query, header, formData, body)
  let scheme = call_581297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581297.url(scheme.get, call_581297.host, call_581297.base,
                         call_581297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581297, url, valid)

proc call*(call_581298: Call_ContentReturnaddressInsert_581285; merchantId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentReturnaddressInsert
  ## Inserts a return address for the Merchant Center account.
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
  ##   merchantId: string (required)
  ##             : The Merchant Center account to insert a return address for.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581299 = newJObject()
  var query_581300 = newJObject()
  var body_581301 = newJObject()
  add(query_581300, "fields", newJString(fields))
  add(query_581300, "quotaUser", newJString(quotaUser))
  add(query_581300, "alt", newJString(alt))
  add(query_581300, "oauth_token", newJString(oauthToken))
  add(query_581300, "userIp", newJString(userIp))
  add(query_581300, "key", newJString(key))
  add(path_581299, "merchantId", newJString(merchantId))
  if body != nil:
    body_581301 = body
  add(query_581300, "prettyPrint", newJBool(prettyPrint))
  result = call_581298.call(path_581299, query_581300, nil, nil, body_581301)

var contentReturnaddressInsert* = Call_ContentReturnaddressInsert_581285(
    name: "contentReturnaddressInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/returnaddress",
    validator: validate_ContentReturnaddressInsert_581286, base: "/content/v2.1",
    url: url_ContentReturnaddressInsert_581287, schemes: {Scheme.Https})
type
  Call_ContentReturnaddressList_581267 = ref object of OpenApiRestCall_579421
proc url_ContentReturnaddressList_581269(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/returnaddress")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentReturnaddressList_581268(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the return addresses of the Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The Merchant Center account to list return addresses for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_581270 = path.getOrDefault("merchantId")
  valid_581270 = validateParameter(valid_581270, JString, required = true,
                                 default = nil)
  if valid_581270 != nil:
    section.add "merchantId", valid_581270
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   country: JString
  ##          : List only return addresses applicable to the given country of sale. When omitted, all return addresses are listed.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of addresses in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_581271 = query.getOrDefault("fields")
  valid_581271 = validateParameter(valid_581271, JString, required = false,
                                 default = nil)
  if valid_581271 != nil:
    section.add "fields", valid_581271
  var valid_581272 = query.getOrDefault("country")
  valid_581272 = validateParameter(valid_581272, JString, required = false,
                                 default = nil)
  if valid_581272 != nil:
    section.add "country", valid_581272
  var valid_581273 = query.getOrDefault("quotaUser")
  valid_581273 = validateParameter(valid_581273, JString, required = false,
                                 default = nil)
  if valid_581273 != nil:
    section.add "quotaUser", valid_581273
  var valid_581274 = query.getOrDefault("pageToken")
  valid_581274 = validateParameter(valid_581274, JString, required = false,
                                 default = nil)
  if valid_581274 != nil:
    section.add "pageToken", valid_581274
  var valid_581275 = query.getOrDefault("alt")
  valid_581275 = validateParameter(valid_581275, JString, required = false,
                                 default = newJString("json"))
  if valid_581275 != nil:
    section.add "alt", valid_581275
  var valid_581276 = query.getOrDefault("oauth_token")
  valid_581276 = validateParameter(valid_581276, JString, required = false,
                                 default = nil)
  if valid_581276 != nil:
    section.add "oauth_token", valid_581276
  var valid_581277 = query.getOrDefault("userIp")
  valid_581277 = validateParameter(valid_581277, JString, required = false,
                                 default = nil)
  if valid_581277 != nil:
    section.add "userIp", valid_581277
  var valid_581278 = query.getOrDefault("maxResults")
  valid_581278 = validateParameter(valid_581278, JInt, required = false, default = nil)
  if valid_581278 != nil:
    section.add "maxResults", valid_581278
  var valid_581279 = query.getOrDefault("key")
  valid_581279 = validateParameter(valid_581279, JString, required = false,
                                 default = nil)
  if valid_581279 != nil:
    section.add "key", valid_581279
  var valid_581280 = query.getOrDefault("prettyPrint")
  valid_581280 = validateParameter(valid_581280, JBool, required = false,
                                 default = newJBool(true))
  if valid_581280 != nil:
    section.add "prettyPrint", valid_581280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581281: Call_ContentReturnaddressList_581267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the return addresses of the Merchant Center account.
  ## 
  let valid = call_581281.validator(path, query, header, formData, body)
  let scheme = call_581281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581281.url(scheme.get, call_581281.host, call_581281.base,
                         call_581281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581281, url, valid)

proc call*(call_581282: Call_ContentReturnaddressList_581267; merchantId: string;
          fields: string = ""; country: string = ""; quotaUser: string = "";
          pageToken: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## contentReturnaddressList
  ## Lists the return addresses of the Merchant Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   country: string
  ##          : List only return addresses applicable to the given country of sale. When omitted, all return addresses are listed.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of addresses in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The Merchant Center account to list return addresses for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581283 = newJObject()
  var query_581284 = newJObject()
  add(query_581284, "fields", newJString(fields))
  add(query_581284, "country", newJString(country))
  add(query_581284, "quotaUser", newJString(quotaUser))
  add(query_581284, "pageToken", newJString(pageToken))
  add(query_581284, "alt", newJString(alt))
  add(query_581284, "oauth_token", newJString(oauthToken))
  add(query_581284, "userIp", newJString(userIp))
  add(query_581284, "maxResults", newJInt(maxResults))
  add(query_581284, "key", newJString(key))
  add(path_581283, "merchantId", newJString(merchantId))
  add(query_581284, "prettyPrint", newJBool(prettyPrint))
  result = call_581282.call(path_581283, query_581284, nil, nil, nil)

var contentReturnaddressList* = Call_ContentReturnaddressList_581267(
    name: "contentReturnaddressList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/returnaddress",
    validator: validate_ContentReturnaddressList_581268, base: "/content/v2.1",
    url: url_ContentReturnaddressList_581269, schemes: {Scheme.Https})
type
  Call_ContentReturnaddressGet_581302 = ref object of OpenApiRestCall_579421
proc url_ContentReturnaddressGet_581304(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "returnAddressId" in path, "`returnAddressId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/returnaddress/"),
               (kind: VariableSegment, value: "returnAddressId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentReturnaddressGet_581303(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a return address of the Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   returnAddressId: JString (required)
  ##                  : Return address ID generated by Google.
  ##   merchantId: JString (required)
  ##             : The Merchant Center account to get a return address for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `returnAddressId` field"
  var valid_581305 = path.getOrDefault("returnAddressId")
  valid_581305 = validateParameter(valid_581305, JString, required = true,
                                 default = nil)
  if valid_581305 != nil:
    section.add "returnAddressId", valid_581305
  var valid_581306 = path.getOrDefault("merchantId")
  valid_581306 = validateParameter(valid_581306, JString, required = true,
                                 default = nil)
  if valid_581306 != nil:
    section.add "merchantId", valid_581306
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
  var valid_581307 = query.getOrDefault("fields")
  valid_581307 = validateParameter(valid_581307, JString, required = false,
                                 default = nil)
  if valid_581307 != nil:
    section.add "fields", valid_581307
  var valid_581308 = query.getOrDefault("quotaUser")
  valid_581308 = validateParameter(valid_581308, JString, required = false,
                                 default = nil)
  if valid_581308 != nil:
    section.add "quotaUser", valid_581308
  var valid_581309 = query.getOrDefault("alt")
  valid_581309 = validateParameter(valid_581309, JString, required = false,
                                 default = newJString("json"))
  if valid_581309 != nil:
    section.add "alt", valid_581309
  var valid_581310 = query.getOrDefault("oauth_token")
  valid_581310 = validateParameter(valid_581310, JString, required = false,
                                 default = nil)
  if valid_581310 != nil:
    section.add "oauth_token", valid_581310
  var valid_581311 = query.getOrDefault("userIp")
  valid_581311 = validateParameter(valid_581311, JString, required = false,
                                 default = nil)
  if valid_581311 != nil:
    section.add "userIp", valid_581311
  var valid_581312 = query.getOrDefault("key")
  valid_581312 = validateParameter(valid_581312, JString, required = false,
                                 default = nil)
  if valid_581312 != nil:
    section.add "key", valid_581312
  var valid_581313 = query.getOrDefault("prettyPrint")
  valid_581313 = validateParameter(valid_581313, JBool, required = false,
                                 default = newJBool(true))
  if valid_581313 != nil:
    section.add "prettyPrint", valid_581313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581314: Call_ContentReturnaddressGet_581302; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a return address of the Merchant Center account.
  ## 
  let valid = call_581314.validator(path, query, header, formData, body)
  let scheme = call_581314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581314.url(scheme.get, call_581314.host, call_581314.base,
                         call_581314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581314, url, valid)

proc call*(call_581315: Call_ContentReturnaddressGet_581302;
          returnAddressId: string; merchantId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentReturnaddressGet
  ## Gets a return address of the Merchant Center account.
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
  ##   returnAddressId: string (required)
  ##                  : Return address ID generated by Google.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The Merchant Center account to get a return address for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581316 = newJObject()
  var query_581317 = newJObject()
  add(query_581317, "fields", newJString(fields))
  add(query_581317, "quotaUser", newJString(quotaUser))
  add(query_581317, "alt", newJString(alt))
  add(query_581317, "oauth_token", newJString(oauthToken))
  add(query_581317, "userIp", newJString(userIp))
  add(path_581316, "returnAddressId", newJString(returnAddressId))
  add(query_581317, "key", newJString(key))
  add(path_581316, "merchantId", newJString(merchantId))
  add(query_581317, "prettyPrint", newJBool(prettyPrint))
  result = call_581315.call(path_581316, query_581317, nil, nil, nil)

var contentReturnaddressGet* = Call_ContentReturnaddressGet_581302(
    name: "contentReturnaddressGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/returnaddress/{returnAddressId}",
    validator: validate_ContentReturnaddressGet_581303, base: "/content/v2.1",
    url: url_ContentReturnaddressGet_581304, schemes: {Scheme.Https})
type
  Call_ContentReturnaddressDelete_581318 = ref object of OpenApiRestCall_579421
proc url_ContentReturnaddressDelete_581320(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "returnAddressId" in path, "`returnAddressId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/returnaddress/"),
               (kind: VariableSegment, value: "returnAddressId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentReturnaddressDelete_581319(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a return address for the given Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   returnAddressId: JString (required)
  ##                  : Return address ID generated by Google.
  ##   merchantId: JString (required)
  ##             : The Merchant Center account from which to delete the given return address.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `returnAddressId` field"
  var valid_581321 = path.getOrDefault("returnAddressId")
  valid_581321 = validateParameter(valid_581321, JString, required = true,
                                 default = nil)
  if valid_581321 != nil:
    section.add "returnAddressId", valid_581321
  var valid_581322 = path.getOrDefault("merchantId")
  valid_581322 = validateParameter(valid_581322, JString, required = true,
                                 default = nil)
  if valid_581322 != nil:
    section.add "merchantId", valid_581322
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
  var valid_581323 = query.getOrDefault("fields")
  valid_581323 = validateParameter(valid_581323, JString, required = false,
                                 default = nil)
  if valid_581323 != nil:
    section.add "fields", valid_581323
  var valid_581324 = query.getOrDefault("quotaUser")
  valid_581324 = validateParameter(valid_581324, JString, required = false,
                                 default = nil)
  if valid_581324 != nil:
    section.add "quotaUser", valid_581324
  var valid_581325 = query.getOrDefault("alt")
  valid_581325 = validateParameter(valid_581325, JString, required = false,
                                 default = newJString("json"))
  if valid_581325 != nil:
    section.add "alt", valid_581325
  var valid_581326 = query.getOrDefault("oauth_token")
  valid_581326 = validateParameter(valid_581326, JString, required = false,
                                 default = nil)
  if valid_581326 != nil:
    section.add "oauth_token", valid_581326
  var valid_581327 = query.getOrDefault("userIp")
  valid_581327 = validateParameter(valid_581327, JString, required = false,
                                 default = nil)
  if valid_581327 != nil:
    section.add "userIp", valid_581327
  var valid_581328 = query.getOrDefault("key")
  valid_581328 = validateParameter(valid_581328, JString, required = false,
                                 default = nil)
  if valid_581328 != nil:
    section.add "key", valid_581328
  var valid_581329 = query.getOrDefault("prettyPrint")
  valid_581329 = validateParameter(valid_581329, JBool, required = false,
                                 default = newJBool(true))
  if valid_581329 != nil:
    section.add "prettyPrint", valid_581329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581330: Call_ContentReturnaddressDelete_581318; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a return address for the given Merchant Center account.
  ## 
  let valid = call_581330.validator(path, query, header, formData, body)
  let scheme = call_581330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581330.url(scheme.get, call_581330.host, call_581330.base,
                         call_581330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581330, url, valid)

proc call*(call_581331: Call_ContentReturnaddressDelete_581318;
          returnAddressId: string; merchantId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentReturnaddressDelete
  ## Deletes a return address for the given Merchant Center account.
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
  ##   returnAddressId: string (required)
  ##                  : Return address ID generated by Google.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The Merchant Center account from which to delete the given return address.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581332 = newJObject()
  var query_581333 = newJObject()
  add(query_581333, "fields", newJString(fields))
  add(query_581333, "quotaUser", newJString(quotaUser))
  add(query_581333, "alt", newJString(alt))
  add(query_581333, "oauth_token", newJString(oauthToken))
  add(query_581333, "userIp", newJString(userIp))
  add(path_581332, "returnAddressId", newJString(returnAddressId))
  add(query_581333, "key", newJString(key))
  add(path_581332, "merchantId", newJString(merchantId))
  add(query_581333, "prettyPrint", newJBool(prettyPrint))
  result = call_581331.call(path_581332, query_581333, nil, nil, nil)

var contentReturnaddressDelete* = Call_ContentReturnaddressDelete_581318(
    name: "contentReturnaddressDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{merchantId}/returnaddress/{returnAddressId}",
    validator: validate_ContentReturnaddressDelete_581319, base: "/content/v2.1",
    url: url_ContentReturnaddressDelete_581320, schemes: {Scheme.Https})
type
  Call_ContentReturnpolicyInsert_581349 = ref object of OpenApiRestCall_579421
proc url_ContentReturnpolicyInsert_581351(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/returnpolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentReturnpolicyInsert_581350(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a return policy for the Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The Merchant Center account to insert a return policy for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_581352 = path.getOrDefault("merchantId")
  valid_581352 = validateParameter(valid_581352, JString, required = true,
                                 default = nil)
  if valid_581352 != nil:
    section.add "merchantId", valid_581352
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
  var valid_581353 = query.getOrDefault("fields")
  valid_581353 = validateParameter(valid_581353, JString, required = false,
                                 default = nil)
  if valid_581353 != nil:
    section.add "fields", valid_581353
  var valid_581354 = query.getOrDefault("quotaUser")
  valid_581354 = validateParameter(valid_581354, JString, required = false,
                                 default = nil)
  if valid_581354 != nil:
    section.add "quotaUser", valid_581354
  var valid_581355 = query.getOrDefault("alt")
  valid_581355 = validateParameter(valid_581355, JString, required = false,
                                 default = newJString("json"))
  if valid_581355 != nil:
    section.add "alt", valid_581355
  var valid_581356 = query.getOrDefault("oauth_token")
  valid_581356 = validateParameter(valid_581356, JString, required = false,
                                 default = nil)
  if valid_581356 != nil:
    section.add "oauth_token", valid_581356
  var valid_581357 = query.getOrDefault("userIp")
  valid_581357 = validateParameter(valid_581357, JString, required = false,
                                 default = nil)
  if valid_581357 != nil:
    section.add "userIp", valid_581357
  var valid_581358 = query.getOrDefault("key")
  valid_581358 = validateParameter(valid_581358, JString, required = false,
                                 default = nil)
  if valid_581358 != nil:
    section.add "key", valid_581358
  var valid_581359 = query.getOrDefault("prettyPrint")
  valid_581359 = validateParameter(valid_581359, JBool, required = false,
                                 default = newJBool(true))
  if valid_581359 != nil:
    section.add "prettyPrint", valid_581359
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

proc call*(call_581361: Call_ContentReturnpolicyInsert_581349; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a return policy for the Merchant Center account.
  ## 
  let valid = call_581361.validator(path, query, header, formData, body)
  let scheme = call_581361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581361.url(scheme.get, call_581361.host, call_581361.base,
                         call_581361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581361, url, valid)

proc call*(call_581362: Call_ContentReturnpolicyInsert_581349; merchantId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentReturnpolicyInsert
  ## Inserts a return policy for the Merchant Center account.
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
  ##   merchantId: string (required)
  ##             : The Merchant Center account to insert a return policy for.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581363 = newJObject()
  var query_581364 = newJObject()
  var body_581365 = newJObject()
  add(query_581364, "fields", newJString(fields))
  add(query_581364, "quotaUser", newJString(quotaUser))
  add(query_581364, "alt", newJString(alt))
  add(query_581364, "oauth_token", newJString(oauthToken))
  add(query_581364, "userIp", newJString(userIp))
  add(query_581364, "key", newJString(key))
  add(path_581363, "merchantId", newJString(merchantId))
  if body != nil:
    body_581365 = body
  add(query_581364, "prettyPrint", newJBool(prettyPrint))
  result = call_581362.call(path_581363, query_581364, nil, nil, body_581365)

var contentReturnpolicyInsert* = Call_ContentReturnpolicyInsert_581349(
    name: "contentReturnpolicyInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/returnpolicy",
    validator: validate_ContentReturnpolicyInsert_581350, base: "/content/v2.1",
    url: url_ContentReturnpolicyInsert_581351, schemes: {Scheme.Https})
type
  Call_ContentReturnpolicyList_581334 = ref object of OpenApiRestCall_579421
proc url_ContentReturnpolicyList_581336(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/returnpolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentReturnpolicyList_581335(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the return policies of the Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The Merchant Center account to list return policies for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_581337 = path.getOrDefault("merchantId")
  valid_581337 = validateParameter(valid_581337, JString, required = true,
                                 default = nil)
  if valid_581337 != nil:
    section.add "merchantId", valid_581337
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
  var valid_581338 = query.getOrDefault("fields")
  valid_581338 = validateParameter(valid_581338, JString, required = false,
                                 default = nil)
  if valid_581338 != nil:
    section.add "fields", valid_581338
  var valid_581339 = query.getOrDefault("quotaUser")
  valid_581339 = validateParameter(valid_581339, JString, required = false,
                                 default = nil)
  if valid_581339 != nil:
    section.add "quotaUser", valid_581339
  var valid_581340 = query.getOrDefault("alt")
  valid_581340 = validateParameter(valid_581340, JString, required = false,
                                 default = newJString("json"))
  if valid_581340 != nil:
    section.add "alt", valid_581340
  var valid_581341 = query.getOrDefault("oauth_token")
  valid_581341 = validateParameter(valid_581341, JString, required = false,
                                 default = nil)
  if valid_581341 != nil:
    section.add "oauth_token", valid_581341
  var valid_581342 = query.getOrDefault("userIp")
  valid_581342 = validateParameter(valid_581342, JString, required = false,
                                 default = nil)
  if valid_581342 != nil:
    section.add "userIp", valid_581342
  var valid_581343 = query.getOrDefault("key")
  valid_581343 = validateParameter(valid_581343, JString, required = false,
                                 default = nil)
  if valid_581343 != nil:
    section.add "key", valid_581343
  var valid_581344 = query.getOrDefault("prettyPrint")
  valid_581344 = validateParameter(valid_581344, JBool, required = false,
                                 default = newJBool(true))
  if valid_581344 != nil:
    section.add "prettyPrint", valid_581344
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581345: Call_ContentReturnpolicyList_581334; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the return policies of the Merchant Center account.
  ## 
  let valid = call_581345.validator(path, query, header, formData, body)
  let scheme = call_581345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581345.url(scheme.get, call_581345.host, call_581345.base,
                         call_581345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581345, url, valid)

proc call*(call_581346: Call_ContentReturnpolicyList_581334; merchantId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## contentReturnpolicyList
  ## Lists the return policies of the Merchant Center account.
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
  ##   merchantId: string (required)
  ##             : The Merchant Center account to list return policies for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581347 = newJObject()
  var query_581348 = newJObject()
  add(query_581348, "fields", newJString(fields))
  add(query_581348, "quotaUser", newJString(quotaUser))
  add(query_581348, "alt", newJString(alt))
  add(query_581348, "oauth_token", newJString(oauthToken))
  add(query_581348, "userIp", newJString(userIp))
  add(query_581348, "key", newJString(key))
  add(path_581347, "merchantId", newJString(merchantId))
  add(query_581348, "prettyPrint", newJBool(prettyPrint))
  result = call_581346.call(path_581347, query_581348, nil, nil, nil)

var contentReturnpolicyList* = Call_ContentReturnpolicyList_581334(
    name: "contentReturnpolicyList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/returnpolicy",
    validator: validate_ContentReturnpolicyList_581335, base: "/content/v2.1",
    url: url_ContentReturnpolicyList_581336, schemes: {Scheme.Https})
type
  Call_ContentReturnpolicyGet_581366 = ref object of OpenApiRestCall_579421
proc url_ContentReturnpolicyGet_581368(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "returnPolicyId" in path, "`returnPolicyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/returnpolicy/"),
               (kind: VariableSegment, value: "returnPolicyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentReturnpolicyGet_581367(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a return policy of the Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   returnPolicyId: JString (required)
  ##                 : Return policy ID generated by Google.
  ##   merchantId: JString (required)
  ##             : The Merchant Center account to get a return policy for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `returnPolicyId` field"
  var valid_581369 = path.getOrDefault("returnPolicyId")
  valid_581369 = validateParameter(valid_581369, JString, required = true,
                                 default = nil)
  if valid_581369 != nil:
    section.add "returnPolicyId", valid_581369
  var valid_581370 = path.getOrDefault("merchantId")
  valid_581370 = validateParameter(valid_581370, JString, required = true,
                                 default = nil)
  if valid_581370 != nil:
    section.add "merchantId", valid_581370
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
  var valid_581371 = query.getOrDefault("fields")
  valid_581371 = validateParameter(valid_581371, JString, required = false,
                                 default = nil)
  if valid_581371 != nil:
    section.add "fields", valid_581371
  var valid_581372 = query.getOrDefault("quotaUser")
  valid_581372 = validateParameter(valid_581372, JString, required = false,
                                 default = nil)
  if valid_581372 != nil:
    section.add "quotaUser", valid_581372
  var valid_581373 = query.getOrDefault("alt")
  valid_581373 = validateParameter(valid_581373, JString, required = false,
                                 default = newJString("json"))
  if valid_581373 != nil:
    section.add "alt", valid_581373
  var valid_581374 = query.getOrDefault("oauth_token")
  valid_581374 = validateParameter(valid_581374, JString, required = false,
                                 default = nil)
  if valid_581374 != nil:
    section.add "oauth_token", valid_581374
  var valid_581375 = query.getOrDefault("userIp")
  valid_581375 = validateParameter(valid_581375, JString, required = false,
                                 default = nil)
  if valid_581375 != nil:
    section.add "userIp", valid_581375
  var valid_581376 = query.getOrDefault("key")
  valid_581376 = validateParameter(valid_581376, JString, required = false,
                                 default = nil)
  if valid_581376 != nil:
    section.add "key", valid_581376
  var valid_581377 = query.getOrDefault("prettyPrint")
  valid_581377 = validateParameter(valid_581377, JBool, required = false,
                                 default = newJBool(true))
  if valid_581377 != nil:
    section.add "prettyPrint", valid_581377
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581378: Call_ContentReturnpolicyGet_581366; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a return policy of the Merchant Center account.
  ## 
  let valid = call_581378.validator(path, query, header, formData, body)
  let scheme = call_581378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581378.url(scheme.get, call_581378.host, call_581378.base,
                         call_581378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581378, url, valid)

proc call*(call_581379: Call_ContentReturnpolicyGet_581366; returnPolicyId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentReturnpolicyGet
  ## Gets a return policy of the Merchant Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   returnPolicyId: string (required)
  ##                 : Return policy ID generated by Google.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The Merchant Center account to get a return policy for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581380 = newJObject()
  var query_581381 = newJObject()
  add(query_581381, "fields", newJString(fields))
  add(query_581381, "quotaUser", newJString(quotaUser))
  add(query_581381, "alt", newJString(alt))
  add(path_581380, "returnPolicyId", newJString(returnPolicyId))
  add(query_581381, "oauth_token", newJString(oauthToken))
  add(query_581381, "userIp", newJString(userIp))
  add(query_581381, "key", newJString(key))
  add(path_581380, "merchantId", newJString(merchantId))
  add(query_581381, "prettyPrint", newJBool(prettyPrint))
  result = call_581379.call(path_581380, query_581381, nil, nil, nil)

var contentReturnpolicyGet* = Call_ContentReturnpolicyGet_581366(
    name: "contentReturnpolicyGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/returnpolicy/{returnPolicyId}",
    validator: validate_ContentReturnpolicyGet_581367, base: "/content/v2.1",
    url: url_ContentReturnpolicyGet_581368, schemes: {Scheme.Https})
type
  Call_ContentReturnpolicyDelete_581382 = ref object of OpenApiRestCall_579421
proc url_ContentReturnpolicyDelete_581384(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "returnPolicyId" in path, "`returnPolicyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/returnpolicy/"),
               (kind: VariableSegment, value: "returnPolicyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentReturnpolicyDelete_581383(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a return policy for the given Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   returnPolicyId: JString (required)
  ##                 : Return policy ID generated by Google.
  ##   merchantId: JString (required)
  ##             : The Merchant Center account from which to delete the given return policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `returnPolicyId` field"
  var valid_581385 = path.getOrDefault("returnPolicyId")
  valid_581385 = validateParameter(valid_581385, JString, required = true,
                                 default = nil)
  if valid_581385 != nil:
    section.add "returnPolicyId", valid_581385
  var valid_581386 = path.getOrDefault("merchantId")
  valid_581386 = validateParameter(valid_581386, JString, required = true,
                                 default = nil)
  if valid_581386 != nil:
    section.add "merchantId", valid_581386
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
  var valid_581387 = query.getOrDefault("fields")
  valid_581387 = validateParameter(valid_581387, JString, required = false,
                                 default = nil)
  if valid_581387 != nil:
    section.add "fields", valid_581387
  var valid_581388 = query.getOrDefault("quotaUser")
  valid_581388 = validateParameter(valid_581388, JString, required = false,
                                 default = nil)
  if valid_581388 != nil:
    section.add "quotaUser", valid_581388
  var valid_581389 = query.getOrDefault("alt")
  valid_581389 = validateParameter(valid_581389, JString, required = false,
                                 default = newJString("json"))
  if valid_581389 != nil:
    section.add "alt", valid_581389
  var valid_581390 = query.getOrDefault("oauth_token")
  valid_581390 = validateParameter(valid_581390, JString, required = false,
                                 default = nil)
  if valid_581390 != nil:
    section.add "oauth_token", valid_581390
  var valid_581391 = query.getOrDefault("userIp")
  valid_581391 = validateParameter(valid_581391, JString, required = false,
                                 default = nil)
  if valid_581391 != nil:
    section.add "userIp", valid_581391
  var valid_581392 = query.getOrDefault("key")
  valid_581392 = validateParameter(valid_581392, JString, required = false,
                                 default = nil)
  if valid_581392 != nil:
    section.add "key", valid_581392
  var valid_581393 = query.getOrDefault("prettyPrint")
  valid_581393 = validateParameter(valid_581393, JBool, required = false,
                                 default = newJBool(true))
  if valid_581393 != nil:
    section.add "prettyPrint", valid_581393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581394: Call_ContentReturnpolicyDelete_581382; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a return policy for the given Merchant Center account.
  ## 
  let valid = call_581394.validator(path, query, header, formData, body)
  let scheme = call_581394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581394.url(scheme.get, call_581394.host, call_581394.base,
                         call_581394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581394, url, valid)

proc call*(call_581395: Call_ContentReturnpolicyDelete_581382;
          returnPolicyId: string; merchantId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentReturnpolicyDelete
  ## Deletes a return policy for the given Merchant Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   returnPolicyId: string (required)
  ##                 : Return policy ID generated by Google.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The Merchant Center account from which to delete the given return policy.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581396 = newJObject()
  var query_581397 = newJObject()
  add(query_581397, "fields", newJString(fields))
  add(query_581397, "quotaUser", newJString(quotaUser))
  add(query_581397, "alt", newJString(alt))
  add(path_581396, "returnPolicyId", newJString(returnPolicyId))
  add(query_581397, "oauth_token", newJString(oauthToken))
  add(query_581397, "userIp", newJString(userIp))
  add(query_581397, "key", newJString(key))
  add(path_581396, "merchantId", newJString(merchantId))
  add(query_581397, "prettyPrint", newJBool(prettyPrint))
  result = call_581395.call(path_581396, query_581397, nil, nil, nil)

var contentReturnpolicyDelete* = Call_ContentReturnpolicyDelete_581382(
    name: "contentReturnpolicyDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{merchantId}/returnpolicy/{returnPolicyId}",
    validator: validate_ContentReturnpolicyDelete_581383, base: "/content/v2.1",
    url: url_ContentReturnpolicyDelete_581384, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsList_581398 = ref object of OpenApiRestCall_579421
proc url_ContentShippingsettingsList_581400(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/shippingsettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentShippingsettingsList_581399(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the shipping settings of the sub-accounts in your Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. This must be a multi-client account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_581401 = path.getOrDefault("merchantId")
  valid_581401 = validateParameter(valid_581401, JString, required = true,
                                 default = nil)
  if valid_581401 != nil:
    section.add "merchantId", valid_581401
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of shipping settings to return in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_581402 = query.getOrDefault("fields")
  valid_581402 = validateParameter(valid_581402, JString, required = false,
                                 default = nil)
  if valid_581402 != nil:
    section.add "fields", valid_581402
  var valid_581403 = query.getOrDefault("pageToken")
  valid_581403 = validateParameter(valid_581403, JString, required = false,
                                 default = nil)
  if valid_581403 != nil:
    section.add "pageToken", valid_581403
  var valid_581404 = query.getOrDefault("quotaUser")
  valid_581404 = validateParameter(valid_581404, JString, required = false,
                                 default = nil)
  if valid_581404 != nil:
    section.add "quotaUser", valid_581404
  var valid_581405 = query.getOrDefault("alt")
  valid_581405 = validateParameter(valid_581405, JString, required = false,
                                 default = newJString("json"))
  if valid_581405 != nil:
    section.add "alt", valid_581405
  var valid_581406 = query.getOrDefault("oauth_token")
  valid_581406 = validateParameter(valid_581406, JString, required = false,
                                 default = nil)
  if valid_581406 != nil:
    section.add "oauth_token", valid_581406
  var valid_581407 = query.getOrDefault("userIp")
  valid_581407 = validateParameter(valid_581407, JString, required = false,
                                 default = nil)
  if valid_581407 != nil:
    section.add "userIp", valid_581407
  var valid_581408 = query.getOrDefault("maxResults")
  valid_581408 = validateParameter(valid_581408, JInt, required = false, default = nil)
  if valid_581408 != nil:
    section.add "maxResults", valid_581408
  var valid_581409 = query.getOrDefault("key")
  valid_581409 = validateParameter(valid_581409, JString, required = false,
                                 default = nil)
  if valid_581409 != nil:
    section.add "key", valid_581409
  var valid_581410 = query.getOrDefault("prettyPrint")
  valid_581410 = validateParameter(valid_581410, JBool, required = false,
                                 default = newJBool(true))
  if valid_581410 != nil:
    section.add "prettyPrint", valid_581410
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581411: Call_ContentShippingsettingsList_581398; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the shipping settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_581411.validator(path, query, header, formData, body)
  let scheme = call_581411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581411.url(scheme.get, call_581411.host, call_581411.base,
                         call_581411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581411, url, valid)

proc call*(call_581412: Call_ContentShippingsettingsList_581398;
          merchantId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## contentShippingsettingsList
  ## Lists the shipping settings of the sub-accounts in your Merchant Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of shipping settings to return in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. This must be a multi-client account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581413 = newJObject()
  var query_581414 = newJObject()
  add(query_581414, "fields", newJString(fields))
  add(query_581414, "pageToken", newJString(pageToken))
  add(query_581414, "quotaUser", newJString(quotaUser))
  add(query_581414, "alt", newJString(alt))
  add(query_581414, "oauth_token", newJString(oauthToken))
  add(query_581414, "userIp", newJString(userIp))
  add(query_581414, "maxResults", newJInt(maxResults))
  add(query_581414, "key", newJString(key))
  add(path_581413, "merchantId", newJString(merchantId))
  add(query_581414, "prettyPrint", newJBool(prettyPrint))
  result = call_581412.call(path_581413, query_581414, nil, nil, nil)

var contentShippingsettingsList* = Call_ContentShippingsettingsList_581398(
    name: "contentShippingsettingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/shippingsettings",
    validator: validate_ContentShippingsettingsList_581399, base: "/content/v2.1",
    url: url_ContentShippingsettingsList_581400, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsUpdate_581431 = ref object of OpenApiRestCall_579421
proc url_ContentShippingsettingsUpdate_581433(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/shippingsettings/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentShippingsettingsUpdate_581432(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the shipping settings of the account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The ID of the account for which to get/update shipping settings.
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_581434 = path.getOrDefault("accountId")
  valid_581434 = validateParameter(valid_581434, JString, required = true,
                                 default = nil)
  if valid_581434 != nil:
    section.add "accountId", valid_581434
  var valid_581435 = path.getOrDefault("merchantId")
  valid_581435 = validateParameter(valid_581435, JString, required = true,
                                 default = nil)
  if valid_581435 != nil:
    section.add "merchantId", valid_581435
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
  var valid_581436 = query.getOrDefault("fields")
  valid_581436 = validateParameter(valid_581436, JString, required = false,
                                 default = nil)
  if valid_581436 != nil:
    section.add "fields", valid_581436
  var valid_581437 = query.getOrDefault("quotaUser")
  valid_581437 = validateParameter(valid_581437, JString, required = false,
                                 default = nil)
  if valid_581437 != nil:
    section.add "quotaUser", valid_581437
  var valid_581438 = query.getOrDefault("alt")
  valid_581438 = validateParameter(valid_581438, JString, required = false,
                                 default = newJString("json"))
  if valid_581438 != nil:
    section.add "alt", valid_581438
  var valid_581439 = query.getOrDefault("oauth_token")
  valid_581439 = validateParameter(valid_581439, JString, required = false,
                                 default = nil)
  if valid_581439 != nil:
    section.add "oauth_token", valid_581439
  var valid_581440 = query.getOrDefault("userIp")
  valid_581440 = validateParameter(valid_581440, JString, required = false,
                                 default = nil)
  if valid_581440 != nil:
    section.add "userIp", valid_581440
  var valid_581441 = query.getOrDefault("key")
  valid_581441 = validateParameter(valid_581441, JString, required = false,
                                 default = nil)
  if valid_581441 != nil:
    section.add "key", valid_581441
  var valid_581442 = query.getOrDefault("prettyPrint")
  valid_581442 = validateParameter(valid_581442, JBool, required = false,
                                 default = newJBool(true))
  if valid_581442 != nil:
    section.add "prettyPrint", valid_581442
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

proc call*(call_581444: Call_ContentShippingsettingsUpdate_581431; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the shipping settings of the account.
  ## 
  let valid = call_581444.validator(path, query, header, formData, body)
  let scheme = call_581444.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581444.url(scheme.get, call_581444.host, call_581444.base,
                         call_581444.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581444, url, valid)

proc call*(call_581445: Call_ContentShippingsettingsUpdate_581431;
          accountId: string; merchantId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## contentShippingsettingsUpdate
  ## Updates the shipping settings of the account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The ID of the account for which to get/update shipping settings.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581446 = newJObject()
  var query_581447 = newJObject()
  var body_581448 = newJObject()
  add(query_581447, "fields", newJString(fields))
  add(query_581447, "quotaUser", newJString(quotaUser))
  add(query_581447, "alt", newJString(alt))
  add(query_581447, "oauth_token", newJString(oauthToken))
  add(path_581446, "accountId", newJString(accountId))
  add(query_581447, "userIp", newJString(userIp))
  add(query_581447, "key", newJString(key))
  add(path_581446, "merchantId", newJString(merchantId))
  if body != nil:
    body_581448 = body
  add(query_581447, "prettyPrint", newJBool(prettyPrint))
  result = call_581445.call(path_581446, query_581447, nil, nil, body_581448)

var contentShippingsettingsUpdate* = Call_ContentShippingsettingsUpdate_581431(
    name: "contentShippingsettingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{merchantId}/shippingsettings/{accountId}",
    validator: validate_ContentShippingsettingsUpdate_581432,
    base: "/content/v2.1", url: url_ContentShippingsettingsUpdate_581433,
    schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGet_581415 = ref object of OpenApiRestCall_579421
proc url_ContentShippingsettingsGet_581417(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/shippingsettings/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentShippingsettingsGet_581416(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the shipping settings of the account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The ID of the account for which to get/update shipping settings.
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_581418 = path.getOrDefault("accountId")
  valid_581418 = validateParameter(valid_581418, JString, required = true,
                                 default = nil)
  if valid_581418 != nil:
    section.add "accountId", valid_581418
  var valid_581419 = path.getOrDefault("merchantId")
  valid_581419 = validateParameter(valid_581419, JString, required = true,
                                 default = nil)
  if valid_581419 != nil:
    section.add "merchantId", valid_581419
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
  var valid_581420 = query.getOrDefault("fields")
  valid_581420 = validateParameter(valid_581420, JString, required = false,
                                 default = nil)
  if valid_581420 != nil:
    section.add "fields", valid_581420
  var valid_581421 = query.getOrDefault("quotaUser")
  valid_581421 = validateParameter(valid_581421, JString, required = false,
                                 default = nil)
  if valid_581421 != nil:
    section.add "quotaUser", valid_581421
  var valid_581422 = query.getOrDefault("alt")
  valid_581422 = validateParameter(valid_581422, JString, required = false,
                                 default = newJString("json"))
  if valid_581422 != nil:
    section.add "alt", valid_581422
  var valid_581423 = query.getOrDefault("oauth_token")
  valid_581423 = validateParameter(valid_581423, JString, required = false,
                                 default = nil)
  if valid_581423 != nil:
    section.add "oauth_token", valid_581423
  var valid_581424 = query.getOrDefault("userIp")
  valid_581424 = validateParameter(valid_581424, JString, required = false,
                                 default = nil)
  if valid_581424 != nil:
    section.add "userIp", valid_581424
  var valid_581425 = query.getOrDefault("key")
  valid_581425 = validateParameter(valid_581425, JString, required = false,
                                 default = nil)
  if valid_581425 != nil:
    section.add "key", valid_581425
  var valid_581426 = query.getOrDefault("prettyPrint")
  valid_581426 = validateParameter(valid_581426, JBool, required = false,
                                 default = newJBool(true))
  if valid_581426 != nil:
    section.add "prettyPrint", valid_581426
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581427: Call_ContentShippingsettingsGet_581415; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the shipping settings of the account.
  ## 
  let valid = call_581427.validator(path, query, header, formData, body)
  let scheme = call_581427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581427.url(scheme.get, call_581427.host, call_581427.base,
                         call_581427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581427, url, valid)

proc call*(call_581428: Call_ContentShippingsettingsGet_581415; accountId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentShippingsettingsGet
  ## Retrieves the shipping settings of the account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The ID of the account for which to get/update shipping settings.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581429 = newJObject()
  var query_581430 = newJObject()
  add(query_581430, "fields", newJString(fields))
  add(query_581430, "quotaUser", newJString(quotaUser))
  add(query_581430, "alt", newJString(alt))
  add(query_581430, "oauth_token", newJString(oauthToken))
  add(path_581429, "accountId", newJString(accountId))
  add(query_581430, "userIp", newJString(userIp))
  add(query_581430, "key", newJString(key))
  add(path_581429, "merchantId", newJString(merchantId))
  add(query_581430, "prettyPrint", newJBool(prettyPrint))
  result = call_581428.call(path_581429, query_581430, nil, nil, nil)

var contentShippingsettingsGet* = Call_ContentShippingsettingsGet_581415(
    name: "contentShippingsettingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/shippingsettings/{accountId}",
    validator: validate_ContentShippingsettingsGet_581416, base: "/content/v2.1",
    url: url_ContentShippingsettingsGet_581417, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGetsupportedcarriers_581449 = ref object of OpenApiRestCall_579421
proc url_ContentShippingsettingsGetsupportedcarriers_581451(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/supportedCarriers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentShippingsettingsGetsupportedcarriers_581450(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves supported carriers and carrier services for an account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account for which to retrieve the supported carriers.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_581452 = path.getOrDefault("merchantId")
  valid_581452 = validateParameter(valid_581452, JString, required = true,
                                 default = nil)
  if valid_581452 != nil:
    section.add "merchantId", valid_581452
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
  var valid_581453 = query.getOrDefault("fields")
  valid_581453 = validateParameter(valid_581453, JString, required = false,
                                 default = nil)
  if valid_581453 != nil:
    section.add "fields", valid_581453
  var valid_581454 = query.getOrDefault("quotaUser")
  valid_581454 = validateParameter(valid_581454, JString, required = false,
                                 default = nil)
  if valid_581454 != nil:
    section.add "quotaUser", valid_581454
  var valid_581455 = query.getOrDefault("alt")
  valid_581455 = validateParameter(valid_581455, JString, required = false,
                                 default = newJString("json"))
  if valid_581455 != nil:
    section.add "alt", valid_581455
  var valid_581456 = query.getOrDefault("oauth_token")
  valid_581456 = validateParameter(valid_581456, JString, required = false,
                                 default = nil)
  if valid_581456 != nil:
    section.add "oauth_token", valid_581456
  var valid_581457 = query.getOrDefault("userIp")
  valid_581457 = validateParameter(valid_581457, JString, required = false,
                                 default = nil)
  if valid_581457 != nil:
    section.add "userIp", valid_581457
  var valid_581458 = query.getOrDefault("key")
  valid_581458 = validateParameter(valid_581458, JString, required = false,
                                 default = nil)
  if valid_581458 != nil:
    section.add "key", valid_581458
  var valid_581459 = query.getOrDefault("prettyPrint")
  valid_581459 = validateParameter(valid_581459, JBool, required = false,
                                 default = newJBool(true))
  if valid_581459 != nil:
    section.add "prettyPrint", valid_581459
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581460: Call_ContentShippingsettingsGetsupportedcarriers_581449;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves supported carriers and carrier services for an account.
  ## 
  let valid = call_581460.validator(path, query, header, formData, body)
  let scheme = call_581460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581460.url(scheme.get, call_581460.host, call_581460.base,
                         call_581460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581460, url, valid)

proc call*(call_581461: Call_ContentShippingsettingsGetsupportedcarriers_581449;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentShippingsettingsGetsupportedcarriers
  ## Retrieves supported carriers and carrier services for an account.
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
  ##   merchantId: string (required)
  ##             : The ID of the account for which to retrieve the supported carriers.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581462 = newJObject()
  var query_581463 = newJObject()
  add(query_581463, "fields", newJString(fields))
  add(query_581463, "quotaUser", newJString(quotaUser))
  add(query_581463, "alt", newJString(alt))
  add(query_581463, "oauth_token", newJString(oauthToken))
  add(query_581463, "userIp", newJString(userIp))
  add(query_581463, "key", newJString(key))
  add(path_581462, "merchantId", newJString(merchantId))
  add(query_581463, "prettyPrint", newJBool(prettyPrint))
  result = call_581461.call(path_581462, query_581463, nil, nil, nil)

var contentShippingsettingsGetsupportedcarriers* = Call_ContentShippingsettingsGetsupportedcarriers_581449(
    name: "contentShippingsettingsGetsupportedcarriers", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/supportedCarriers",
    validator: validate_ContentShippingsettingsGetsupportedcarriers_581450,
    base: "/content/v2.1", url: url_ContentShippingsettingsGetsupportedcarriers_581451,
    schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGetsupportedholidays_581464 = ref object of OpenApiRestCall_579421
proc url_ContentShippingsettingsGetsupportedholidays_581466(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/supportedHolidays")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentShippingsettingsGetsupportedholidays_581465(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves supported holidays for an account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account for which to retrieve the supported holidays.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_581467 = path.getOrDefault("merchantId")
  valid_581467 = validateParameter(valid_581467, JString, required = true,
                                 default = nil)
  if valid_581467 != nil:
    section.add "merchantId", valid_581467
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
  var valid_581468 = query.getOrDefault("fields")
  valid_581468 = validateParameter(valid_581468, JString, required = false,
                                 default = nil)
  if valid_581468 != nil:
    section.add "fields", valid_581468
  var valid_581469 = query.getOrDefault("quotaUser")
  valid_581469 = validateParameter(valid_581469, JString, required = false,
                                 default = nil)
  if valid_581469 != nil:
    section.add "quotaUser", valid_581469
  var valid_581470 = query.getOrDefault("alt")
  valid_581470 = validateParameter(valid_581470, JString, required = false,
                                 default = newJString("json"))
  if valid_581470 != nil:
    section.add "alt", valid_581470
  var valid_581471 = query.getOrDefault("oauth_token")
  valid_581471 = validateParameter(valid_581471, JString, required = false,
                                 default = nil)
  if valid_581471 != nil:
    section.add "oauth_token", valid_581471
  var valid_581472 = query.getOrDefault("userIp")
  valid_581472 = validateParameter(valid_581472, JString, required = false,
                                 default = nil)
  if valid_581472 != nil:
    section.add "userIp", valid_581472
  var valid_581473 = query.getOrDefault("key")
  valid_581473 = validateParameter(valid_581473, JString, required = false,
                                 default = nil)
  if valid_581473 != nil:
    section.add "key", valid_581473
  var valid_581474 = query.getOrDefault("prettyPrint")
  valid_581474 = validateParameter(valid_581474, JBool, required = false,
                                 default = newJBool(true))
  if valid_581474 != nil:
    section.add "prettyPrint", valid_581474
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581475: Call_ContentShippingsettingsGetsupportedholidays_581464;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves supported holidays for an account.
  ## 
  let valid = call_581475.validator(path, query, header, formData, body)
  let scheme = call_581475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581475.url(scheme.get, call_581475.host, call_581475.base,
                         call_581475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581475, url, valid)

proc call*(call_581476: Call_ContentShippingsettingsGetsupportedholidays_581464;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentShippingsettingsGetsupportedholidays
  ## Retrieves supported holidays for an account.
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
  ##   merchantId: string (required)
  ##             : The ID of the account for which to retrieve the supported holidays.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581477 = newJObject()
  var query_581478 = newJObject()
  add(query_581478, "fields", newJString(fields))
  add(query_581478, "quotaUser", newJString(quotaUser))
  add(query_581478, "alt", newJString(alt))
  add(query_581478, "oauth_token", newJString(oauthToken))
  add(query_581478, "userIp", newJString(userIp))
  add(query_581478, "key", newJString(key))
  add(path_581477, "merchantId", newJString(merchantId))
  add(query_581478, "prettyPrint", newJBool(prettyPrint))
  result = call_581476.call(path_581477, query_581478, nil, nil, nil)

var contentShippingsettingsGetsupportedholidays* = Call_ContentShippingsettingsGetsupportedholidays_581464(
    name: "contentShippingsettingsGetsupportedholidays", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/supportedHolidays",
    validator: validate_ContentShippingsettingsGetsupportedholidays_581465,
    base: "/content/v2.1", url: url_ContentShippingsettingsGetsupportedholidays_581466,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersCreatetestorder_581479 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersCreatetestorder_581481(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/testorders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersCreatetestorder_581480(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sandbox only. Creates a test order.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that should manage the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_581482 = path.getOrDefault("merchantId")
  valid_581482 = validateParameter(valid_581482, JString, required = true,
                                 default = nil)
  if valid_581482 != nil:
    section.add "merchantId", valid_581482
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
  var valid_581483 = query.getOrDefault("fields")
  valid_581483 = validateParameter(valid_581483, JString, required = false,
                                 default = nil)
  if valid_581483 != nil:
    section.add "fields", valid_581483
  var valid_581484 = query.getOrDefault("quotaUser")
  valid_581484 = validateParameter(valid_581484, JString, required = false,
                                 default = nil)
  if valid_581484 != nil:
    section.add "quotaUser", valid_581484
  var valid_581485 = query.getOrDefault("alt")
  valid_581485 = validateParameter(valid_581485, JString, required = false,
                                 default = newJString("json"))
  if valid_581485 != nil:
    section.add "alt", valid_581485
  var valid_581486 = query.getOrDefault("oauth_token")
  valid_581486 = validateParameter(valid_581486, JString, required = false,
                                 default = nil)
  if valid_581486 != nil:
    section.add "oauth_token", valid_581486
  var valid_581487 = query.getOrDefault("userIp")
  valid_581487 = validateParameter(valid_581487, JString, required = false,
                                 default = nil)
  if valid_581487 != nil:
    section.add "userIp", valid_581487
  var valid_581488 = query.getOrDefault("key")
  valid_581488 = validateParameter(valid_581488, JString, required = false,
                                 default = nil)
  if valid_581488 != nil:
    section.add "key", valid_581488
  var valid_581489 = query.getOrDefault("prettyPrint")
  valid_581489 = validateParameter(valid_581489, JBool, required = false,
                                 default = newJBool(true))
  if valid_581489 != nil:
    section.add "prettyPrint", valid_581489
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

proc call*(call_581491: Call_ContentOrdersCreatetestorder_581479; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Creates a test order.
  ## 
  let valid = call_581491.validator(path, query, header, formData, body)
  let scheme = call_581491.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581491.url(scheme.get, call_581491.host, call_581491.base,
                         call_581491.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581491, url, valid)

proc call*(call_581492: Call_ContentOrdersCreatetestorder_581479;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentOrdersCreatetestorder
  ## Sandbox only. Creates a test order.
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
  ##   merchantId: string (required)
  ##             : The ID of the account that should manage the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581493 = newJObject()
  var query_581494 = newJObject()
  var body_581495 = newJObject()
  add(query_581494, "fields", newJString(fields))
  add(query_581494, "quotaUser", newJString(quotaUser))
  add(query_581494, "alt", newJString(alt))
  add(query_581494, "oauth_token", newJString(oauthToken))
  add(query_581494, "userIp", newJString(userIp))
  add(query_581494, "key", newJString(key))
  add(path_581493, "merchantId", newJString(merchantId))
  if body != nil:
    body_581495 = body
  add(query_581494, "prettyPrint", newJBool(prettyPrint))
  result = call_581492.call(path_581493, query_581494, nil, nil, body_581495)

var contentOrdersCreatetestorder* = Call_ContentOrdersCreatetestorder_581479(
    name: "contentOrdersCreatetestorder", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/testorders",
    validator: validate_ContentOrdersCreatetestorder_581480,
    base: "/content/v2.1", url: url_ContentOrdersCreatetestorder_581481,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersAdvancetestorder_581496 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersAdvancetestorder_581498(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/testorders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/advance")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersAdvancetestorder_581497(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sandbox only. Moves a test order from state "inProgress" to state "pendingShipment".
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   orderId: JString (required)
  ##          : The ID of the test order to modify.
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `orderId` field"
  var valid_581499 = path.getOrDefault("orderId")
  valid_581499 = validateParameter(valid_581499, JString, required = true,
                                 default = nil)
  if valid_581499 != nil:
    section.add "orderId", valid_581499
  var valid_581500 = path.getOrDefault("merchantId")
  valid_581500 = validateParameter(valid_581500, JString, required = true,
                                 default = nil)
  if valid_581500 != nil:
    section.add "merchantId", valid_581500
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
  var valid_581501 = query.getOrDefault("fields")
  valid_581501 = validateParameter(valid_581501, JString, required = false,
                                 default = nil)
  if valid_581501 != nil:
    section.add "fields", valid_581501
  var valid_581502 = query.getOrDefault("quotaUser")
  valid_581502 = validateParameter(valid_581502, JString, required = false,
                                 default = nil)
  if valid_581502 != nil:
    section.add "quotaUser", valid_581502
  var valid_581503 = query.getOrDefault("alt")
  valid_581503 = validateParameter(valid_581503, JString, required = false,
                                 default = newJString("json"))
  if valid_581503 != nil:
    section.add "alt", valid_581503
  var valid_581504 = query.getOrDefault("oauth_token")
  valid_581504 = validateParameter(valid_581504, JString, required = false,
                                 default = nil)
  if valid_581504 != nil:
    section.add "oauth_token", valid_581504
  var valid_581505 = query.getOrDefault("userIp")
  valid_581505 = validateParameter(valid_581505, JString, required = false,
                                 default = nil)
  if valid_581505 != nil:
    section.add "userIp", valid_581505
  var valid_581506 = query.getOrDefault("key")
  valid_581506 = validateParameter(valid_581506, JString, required = false,
                                 default = nil)
  if valid_581506 != nil:
    section.add "key", valid_581506
  var valid_581507 = query.getOrDefault("prettyPrint")
  valid_581507 = validateParameter(valid_581507, JBool, required = false,
                                 default = newJBool(true))
  if valid_581507 != nil:
    section.add "prettyPrint", valid_581507
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581508: Call_ContentOrdersAdvancetestorder_581496; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Moves a test order from state "inProgress" to state "pendingShipment".
  ## 
  let valid = call_581508.validator(path, query, header, formData, body)
  let scheme = call_581508.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581508.url(scheme.get, call_581508.host, call_581508.base,
                         call_581508.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581508, url, valid)

proc call*(call_581509: Call_ContentOrdersAdvancetestorder_581496; orderId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentOrdersAdvancetestorder
  ## Sandbox only. Moves a test order from state "inProgress" to state "pendingShipment".
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
  ##   orderId: string (required)
  ##          : The ID of the test order to modify.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581510 = newJObject()
  var query_581511 = newJObject()
  add(query_581511, "fields", newJString(fields))
  add(query_581511, "quotaUser", newJString(quotaUser))
  add(query_581511, "alt", newJString(alt))
  add(query_581511, "oauth_token", newJString(oauthToken))
  add(query_581511, "userIp", newJString(userIp))
  add(path_581510, "orderId", newJString(orderId))
  add(query_581511, "key", newJString(key))
  add(path_581510, "merchantId", newJString(merchantId))
  add(query_581511, "prettyPrint", newJBool(prettyPrint))
  result = call_581509.call(path_581510, query_581511, nil, nil, nil)

var contentOrdersAdvancetestorder* = Call_ContentOrdersAdvancetestorder_581496(
    name: "contentOrdersAdvancetestorder", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/testorders/{orderId}/advance",
    validator: validate_ContentOrdersAdvancetestorder_581497,
    base: "/content/v2.1", url: url_ContentOrdersAdvancetestorder_581498,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersCanceltestorderbycustomer_581512 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersCanceltestorderbycustomer_581514(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/testorders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/cancelByCustomer")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersCanceltestorderbycustomer_581513(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sandbox only. Cancels a test order for customer-initiated cancellation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   orderId: JString (required)
  ##          : The ID of the test order to cancel.
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `orderId` field"
  var valid_581515 = path.getOrDefault("orderId")
  valid_581515 = validateParameter(valid_581515, JString, required = true,
                                 default = nil)
  if valid_581515 != nil:
    section.add "orderId", valid_581515
  var valid_581516 = path.getOrDefault("merchantId")
  valid_581516 = validateParameter(valid_581516, JString, required = true,
                                 default = nil)
  if valid_581516 != nil:
    section.add "merchantId", valid_581516
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
  var valid_581517 = query.getOrDefault("fields")
  valid_581517 = validateParameter(valid_581517, JString, required = false,
                                 default = nil)
  if valid_581517 != nil:
    section.add "fields", valid_581517
  var valid_581518 = query.getOrDefault("quotaUser")
  valid_581518 = validateParameter(valid_581518, JString, required = false,
                                 default = nil)
  if valid_581518 != nil:
    section.add "quotaUser", valid_581518
  var valid_581519 = query.getOrDefault("alt")
  valid_581519 = validateParameter(valid_581519, JString, required = false,
                                 default = newJString("json"))
  if valid_581519 != nil:
    section.add "alt", valid_581519
  var valid_581520 = query.getOrDefault("oauth_token")
  valid_581520 = validateParameter(valid_581520, JString, required = false,
                                 default = nil)
  if valid_581520 != nil:
    section.add "oauth_token", valid_581520
  var valid_581521 = query.getOrDefault("userIp")
  valid_581521 = validateParameter(valid_581521, JString, required = false,
                                 default = nil)
  if valid_581521 != nil:
    section.add "userIp", valid_581521
  var valid_581522 = query.getOrDefault("key")
  valid_581522 = validateParameter(valid_581522, JString, required = false,
                                 default = nil)
  if valid_581522 != nil:
    section.add "key", valid_581522
  var valid_581523 = query.getOrDefault("prettyPrint")
  valid_581523 = validateParameter(valid_581523, JBool, required = false,
                                 default = newJBool(true))
  if valid_581523 != nil:
    section.add "prettyPrint", valid_581523
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

proc call*(call_581525: Call_ContentOrdersCanceltestorderbycustomer_581512;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sandbox only. Cancels a test order for customer-initiated cancellation.
  ## 
  let valid = call_581525.validator(path, query, header, formData, body)
  let scheme = call_581525.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581525.url(scheme.get, call_581525.host, call_581525.base,
                         call_581525.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581525, url, valid)

proc call*(call_581526: Call_ContentOrdersCanceltestorderbycustomer_581512;
          orderId: string; merchantId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## contentOrdersCanceltestorderbycustomer
  ## Sandbox only. Cancels a test order for customer-initiated cancellation.
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
  ##   orderId: string (required)
  ##          : The ID of the test order to cancel.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581527 = newJObject()
  var query_581528 = newJObject()
  var body_581529 = newJObject()
  add(query_581528, "fields", newJString(fields))
  add(query_581528, "quotaUser", newJString(quotaUser))
  add(query_581528, "alt", newJString(alt))
  add(query_581528, "oauth_token", newJString(oauthToken))
  add(query_581528, "userIp", newJString(userIp))
  add(path_581527, "orderId", newJString(orderId))
  add(query_581528, "key", newJString(key))
  add(path_581527, "merchantId", newJString(merchantId))
  if body != nil:
    body_581529 = body
  add(query_581528, "prettyPrint", newJBool(prettyPrint))
  result = call_581526.call(path_581527, query_581528, nil, nil, body_581529)

var contentOrdersCanceltestorderbycustomer* = Call_ContentOrdersCanceltestorderbycustomer_581512(
    name: "contentOrdersCanceltestorderbycustomer", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/testorders/{orderId}/cancelByCustomer",
    validator: validate_ContentOrdersCanceltestorderbycustomer_581513,
    base: "/content/v2.1", url: url_ContentOrdersCanceltestorderbycustomer_581514,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersGettestordertemplate_581530 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersGettestordertemplate_581532(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "templateName" in path, "`templateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/testordertemplates/"),
               (kind: VariableSegment, value: "templateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersGettestordertemplate_581531(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sandbox only. Retrieves an order template that can be used to quickly create a new order in sandbox.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   templateName: JString (required)
  ##               : The name of the template to retrieve.
  ##   merchantId: JString (required)
  ##             : The ID of the account that should manage the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `templateName` field"
  var valid_581533 = path.getOrDefault("templateName")
  valid_581533 = validateParameter(valid_581533, JString, required = true,
                                 default = newJString("template1"))
  if valid_581533 != nil:
    section.add "templateName", valid_581533
  var valid_581534 = path.getOrDefault("merchantId")
  valid_581534 = validateParameter(valid_581534, JString, required = true,
                                 default = nil)
  if valid_581534 != nil:
    section.add "merchantId", valid_581534
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   country: JString
  ##          : The country of the template to retrieve. Defaults to US.
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
  var valid_581535 = query.getOrDefault("fields")
  valid_581535 = validateParameter(valid_581535, JString, required = false,
                                 default = nil)
  if valid_581535 != nil:
    section.add "fields", valid_581535
  var valid_581536 = query.getOrDefault("country")
  valid_581536 = validateParameter(valid_581536, JString, required = false,
                                 default = nil)
  if valid_581536 != nil:
    section.add "country", valid_581536
  var valid_581537 = query.getOrDefault("quotaUser")
  valid_581537 = validateParameter(valid_581537, JString, required = false,
                                 default = nil)
  if valid_581537 != nil:
    section.add "quotaUser", valid_581537
  var valid_581538 = query.getOrDefault("alt")
  valid_581538 = validateParameter(valid_581538, JString, required = false,
                                 default = newJString("json"))
  if valid_581538 != nil:
    section.add "alt", valid_581538
  var valid_581539 = query.getOrDefault("oauth_token")
  valid_581539 = validateParameter(valid_581539, JString, required = false,
                                 default = nil)
  if valid_581539 != nil:
    section.add "oauth_token", valid_581539
  var valid_581540 = query.getOrDefault("userIp")
  valid_581540 = validateParameter(valid_581540, JString, required = false,
                                 default = nil)
  if valid_581540 != nil:
    section.add "userIp", valid_581540
  var valid_581541 = query.getOrDefault("key")
  valid_581541 = validateParameter(valid_581541, JString, required = false,
                                 default = nil)
  if valid_581541 != nil:
    section.add "key", valid_581541
  var valid_581542 = query.getOrDefault("prettyPrint")
  valid_581542 = validateParameter(valid_581542, JBool, required = false,
                                 default = newJBool(true))
  if valid_581542 != nil:
    section.add "prettyPrint", valid_581542
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581543: Call_ContentOrdersGettestordertemplate_581530;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sandbox only. Retrieves an order template that can be used to quickly create a new order in sandbox.
  ## 
  let valid = call_581543.validator(path, query, header, formData, body)
  let scheme = call_581543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581543.url(scheme.get, call_581543.host, call_581543.base,
                         call_581543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581543, url, valid)

proc call*(call_581544: Call_ContentOrdersGettestordertemplate_581530;
          merchantId: string; fields: string = ""; country: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; templateName: string = "template1"; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## contentOrdersGettestordertemplate
  ## Sandbox only. Retrieves an order template that can be used to quickly create a new order in sandbox.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   country: string
  ##          : The country of the template to retrieve. Defaults to US.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   templateName: string (required)
  ##               : The name of the template to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that should manage the order. This cannot be a multi-client account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581545 = newJObject()
  var query_581546 = newJObject()
  add(query_581546, "fields", newJString(fields))
  add(query_581546, "country", newJString(country))
  add(query_581546, "quotaUser", newJString(quotaUser))
  add(query_581546, "alt", newJString(alt))
  add(query_581546, "oauth_token", newJString(oauthToken))
  add(query_581546, "userIp", newJString(userIp))
  add(path_581545, "templateName", newJString(templateName))
  add(query_581546, "key", newJString(key))
  add(path_581545, "merchantId", newJString(merchantId))
  add(query_581546, "prettyPrint", newJBool(prettyPrint))
  result = call_581544.call(path_581545, query_581546, nil, nil, nil)

var contentOrdersGettestordertemplate* = Call_ContentOrdersGettestordertemplate_581530(
    name: "contentOrdersGettestordertemplate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/testordertemplates/{templateName}",
    validator: validate_ContentOrdersGettestordertemplate_581531,
    base: "/content/v2.1", url: url_ContentOrdersGettestordertemplate_581532,
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
