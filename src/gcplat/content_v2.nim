
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Content API for Shopping
## version: v2
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
  Call_ContentAccountsAuthinfo_579689 = ref object of OpenApiRestCall_579421
proc url_ContentAccountsAuthinfo_579691(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentAccountsAuthinfo_579690(path: JsonNode; query: JsonNode;
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
  var valid_579803 = query.getOrDefault("fields")
  valid_579803 = validateParameter(valid_579803, JString, required = false,
                                 default = nil)
  if valid_579803 != nil:
    section.add "fields", valid_579803
  var valid_579804 = query.getOrDefault("quotaUser")
  valid_579804 = validateParameter(valid_579804, JString, required = false,
                                 default = nil)
  if valid_579804 != nil:
    section.add "quotaUser", valid_579804
  var valid_579818 = query.getOrDefault("alt")
  valid_579818 = validateParameter(valid_579818, JString, required = false,
                                 default = newJString("json"))
  if valid_579818 != nil:
    section.add "alt", valid_579818
  var valid_579819 = query.getOrDefault("oauth_token")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = nil)
  if valid_579819 != nil:
    section.add "oauth_token", valid_579819
  var valid_579820 = query.getOrDefault("userIp")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "userIp", valid_579820
  var valid_579821 = query.getOrDefault("key")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "key", valid_579821
  var valid_579822 = query.getOrDefault("prettyPrint")
  valid_579822 = validateParameter(valid_579822, JBool, required = false,
                                 default = newJBool(true))
  if valid_579822 != nil:
    section.add "prettyPrint", valid_579822
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579845: Call_ContentAccountsAuthinfo_579689; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about the authenticated user.
  ## 
  let valid = call_579845.validator(path, query, header, formData, body)
  let scheme = call_579845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579845.url(scheme.get, call_579845.host, call_579845.base,
                         call_579845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579845, url, valid)

proc call*(call_579916: Call_ContentAccountsAuthinfo_579689; fields: string = "";
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
  var query_579917 = newJObject()
  add(query_579917, "fields", newJString(fields))
  add(query_579917, "quotaUser", newJString(quotaUser))
  add(query_579917, "alt", newJString(alt))
  add(query_579917, "oauth_token", newJString(oauthToken))
  add(query_579917, "userIp", newJString(userIp))
  add(query_579917, "key", newJString(key))
  add(query_579917, "prettyPrint", newJBool(prettyPrint))
  result = call_579916.call(nil, query_579917, nil, nil, nil)

var contentAccountsAuthinfo* = Call_ContentAccountsAuthinfo_579689(
    name: "contentAccountsAuthinfo", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/authinfo",
    validator: validate_ContentAccountsAuthinfo_579690, base: "/content/v2",
    url: url_ContentAccountsAuthinfo_579691, schemes: {Scheme.Https})
type
  Call_ContentAccountsCustombatch_579957 = ref object of OpenApiRestCall_579421
proc url_ContentAccountsCustombatch_579959(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentAccountsCustombatch_579958(path: JsonNode; query: JsonNode;
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
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579960 = query.getOrDefault("fields")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "fields", valid_579960
  var valid_579961 = query.getOrDefault("quotaUser")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "quotaUser", valid_579961
  var valid_579962 = query.getOrDefault("alt")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = newJString("json"))
  if valid_579962 != nil:
    section.add "alt", valid_579962
  var valid_579963 = query.getOrDefault("dryRun")
  valid_579963 = validateParameter(valid_579963, JBool, required = false, default = nil)
  if valid_579963 != nil:
    section.add "dryRun", valid_579963
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

proc call*(call_579969: Call_ContentAccountsCustombatch_579957; path: JsonNode;
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

proc call*(call_579970: Call_ContentAccountsCustombatch_579957;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          dryRun: bool = false; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentAccountsCustombatch
  ## Retrieves, inserts, updates, and deletes multiple Merchant Center (sub-)accounts in a single request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
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
  add(query_579971, "dryRun", newJBool(dryRun))
  add(query_579971, "oauth_token", newJString(oauthToken))
  add(query_579971, "userIp", newJString(userIp))
  add(query_579971, "key", newJString(key))
  if body != nil:
    body_579972 = body
  add(query_579971, "prettyPrint", newJBool(prettyPrint))
  result = call_579970.call(nil, query_579971, nil, nil, body_579972)

var contentAccountsCustombatch* = Call_ContentAccountsCustombatch_579957(
    name: "contentAccountsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accounts/batch",
    validator: validate_ContentAccountsCustombatch_579958, base: "/content/v2",
    url: url_ContentAccountsCustombatch_579959, schemes: {Scheme.Https})
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
    base: "/content/v2", url: url_ContentAccountstatusesCustombatch_579975,
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
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
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
  var valid_579994 = query.getOrDefault("dryRun")
  valid_579994 = validateParameter(valid_579994, JBool, required = false, default = nil)
  if valid_579994 != nil:
    section.add "dryRun", valid_579994
  var valid_579995 = query.getOrDefault("oauth_token")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "oauth_token", valid_579995
  var valid_579996 = query.getOrDefault("userIp")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "userIp", valid_579996
  var valid_579997 = query.getOrDefault("key")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "key", valid_579997
  var valid_579998 = query.getOrDefault("prettyPrint")
  valid_579998 = validateParameter(valid_579998, JBool, required = false,
                                 default = newJBool(true))
  if valid_579998 != nil:
    section.add "prettyPrint", valid_579998
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

proc call*(call_580000: Call_ContentAccounttaxCustombatch_579988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves and updates tax settings of multiple accounts in a single request.
  ## 
  let valid = call_580000.validator(path, query, header, formData, body)
  let scheme = call_580000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580000.url(scheme.get, call_580000.host, call_580000.base,
                         call_580000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580000, url, valid)

proc call*(call_580001: Call_ContentAccounttaxCustombatch_579988;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          dryRun: bool = false; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentAccounttaxCustombatch
  ## Retrieves and updates tax settings of multiple accounts in a single request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580002 = newJObject()
  var body_580003 = newJObject()
  add(query_580002, "fields", newJString(fields))
  add(query_580002, "quotaUser", newJString(quotaUser))
  add(query_580002, "alt", newJString(alt))
  add(query_580002, "dryRun", newJBool(dryRun))
  add(query_580002, "oauth_token", newJString(oauthToken))
  add(query_580002, "userIp", newJString(userIp))
  add(query_580002, "key", newJString(key))
  if body != nil:
    body_580003 = body
  add(query_580002, "prettyPrint", newJBool(prettyPrint))
  result = call_580001.call(nil, query_580002, nil, nil, body_580003)

var contentAccounttaxCustombatch* = Call_ContentAccounttaxCustombatch_579988(
    name: "contentAccounttaxCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accounttax/batch",
    validator: validate_ContentAccounttaxCustombatch_579989, base: "/content/v2",
    url: url_ContentAccounttaxCustombatch_579990, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsCustombatch_580004 = ref object of OpenApiRestCall_579421
proc url_ContentDatafeedsCustombatch_580006(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentDatafeedsCustombatch_580005(path: JsonNode; query: JsonNode;
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
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580007 = query.getOrDefault("fields")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "fields", valid_580007
  var valid_580008 = query.getOrDefault("quotaUser")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "quotaUser", valid_580008
  var valid_580009 = query.getOrDefault("alt")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = newJString("json"))
  if valid_580009 != nil:
    section.add "alt", valid_580009
  var valid_580010 = query.getOrDefault("dryRun")
  valid_580010 = validateParameter(valid_580010, JBool, required = false, default = nil)
  if valid_580010 != nil:
    section.add "dryRun", valid_580010
  var valid_580011 = query.getOrDefault("oauth_token")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "oauth_token", valid_580011
  var valid_580012 = query.getOrDefault("userIp")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "userIp", valid_580012
  var valid_580013 = query.getOrDefault("key")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "key", valid_580013
  var valid_580014 = query.getOrDefault("prettyPrint")
  valid_580014 = validateParameter(valid_580014, JBool, required = false,
                                 default = newJBool(true))
  if valid_580014 != nil:
    section.add "prettyPrint", valid_580014
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

proc call*(call_580016: Call_ContentDatafeedsCustombatch_580004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes, fetches, gets, inserts and updates multiple datafeeds in a single request.
  ## 
  let valid = call_580016.validator(path, query, header, formData, body)
  let scheme = call_580016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580016.url(scheme.get, call_580016.host, call_580016.base,
                         call_580016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580016, url, valid)

proc call*(call_580017: Call_ContentDatafeedsCustombatch_580004;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          dryRun: bool = false; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentDatafeedsCustombatch
  ## Deletes, fetches, gets, inserts and updates multiple datafeeds in a single request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580018 = newJObject()
  var body_580019 = newJObject()
  add(query_580018, "fields", newJString(fields))
  add(query_580018, "quotaUser", newJString(quotaUser))
  add(query_580018, "alt", newJString(alt))
  add(query_580018, "dryRun", newJBool(dryRun))
  add(query_580018, "oauth_token", newJString(oauthToken))
  add(query_580018, "userIp", newJString(userIp))
  add(query_580018, "key", newJString(key))
  if body != nil:
    body_580019 = body
  add(query_580018, "prettyPrint", newJBool(prettyPrint))
  result = call_580017.call(nil, query_580018, nil, nil, body_580019)

var contentDatafeedsCustombatch* = Call_ContentDatafeedsCustombatch_580004(
    name: "contentDatafeedsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/datafeeds/batch",
    validator: validate_ContentDatafeedsCustombatch_580005, base: "/content/v2",
    url: url_ContentDatafeedsCustombatch_580006, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesCustombatch_580020 = ref object of OpenApiRestCall_579421
proc url_ContentDatafeedstatusesCustombatch_580022(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentDatafeedstatusesCustombatch_580021(path: JsonNode;
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
  var valid_580023 = query.getOrDefault("fields")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "fields", valid_580023
  var valid_580024 = query.getOrDefault("quotaUser")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "quotaUser", valid_580024
  var valid_580025 = query.getOrDefault("alt")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = newJString("json"))
  if valid_580025 != nil:
    section.add "alt", valid_580025
  var valid_580026 = query.getOrDefault("oauth_token")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "oauth_token", valid_580026
  var valid_580027 = query.getOrDefault("userIp")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "userIp", valid_580027
  var valid_580028 = query.getOrDefault("key")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "key", valid_580028
  var valid_580029 = query.getOrDefault("prettyPrint")
  valid_580029 = validateParameter(valid_580029, JBool, required = false,
                                 default = newJBool(true))
  if valid_580029 != nil:
    section.add "prettyPrint", valid_580029
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

proc call*(call_580031: Call_ContentDatafeedstatusesCustombatch_580020;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets multiple Merchant Center datafeed statuses in a single request.
  ## 
  let valid = call_580031.validator(path, query, header, formData, body)
  let scheme = call_580031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580031.url(scheme.get, call_580031.host, call_580031.base,
                         call_580031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580031, url, valid)

proc call*(call_580032: Call_ContentDatafeedstatusesCustombatch_580020;
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
  var query_580033 = newJObject()
  var body_580034 = newJObject()
  add(query_580033, "fields", newJString(fields))
  add(query_580033, "quotaUser", newJString(quotaUser))
  add(query_580033, "alt", newJString(alt))
  add(query_580033, "oauth_token", newJString(oauthToken))
  add(query_580033, "userIp", newJString(userIp))
  add(query_580033, "key", newJString(key))
  if body != nil:
    body_580034 = body
  add(query_580033, "prettyPrint", newJBool(prettyPrint))
  result = call_580032.call(nil, query_580033, nil, nil, body_580034)

var contentDatafeedstatusesCustombatch* = Call_ContentDatafeedstatusesCustombatch_580020(
    name: "contentDatafeedstatusesCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/datafeedstatuses/batch",
    validator: validate_ContentDatafeedstatusesCustombatch_580021,
    base: "/content/v2", url: url_ContentDatafeedstatusesCustombatch_580022,
    schemes: {Scheme.Https})
type
  Call_ContentInventoryCustombatch_580035 = ref object of OpenApiRestCall_579421
proc url_ContentInventoryCustombatch_580037(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentInventoryCustombatch_580036(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates price and availability for multiple products or stores in a single request. This operation does not update the expiration date of the products.
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
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580038 = query.getOrDefault("fields")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "fields", valid_580038
  var valid_580039 = query.getOrDefault("quotaUser")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "quotaUser", valid_580039
  var valid_580040 = query.getOrDefault("alt")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = newJString("json"))
  if valid_580040 != nil:
    section.add "alt", valid_580040
  var valid_580041 = query.getOrDefault("dryRun")
  valid_580041 = validateParameter(valid_580041, JBool, required = false, default = nil)
  if valid_580041 != nil:
    section.add "dryRun", valid_580041
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580047: Call_ContentInventoryCustombatch_580035; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates price and availability for multiple products or stores in a single request. This operation does not update the expiration date of the products.
  ## 
  let valid = call_580047.validator(path, query, header, formData, body)
  let scheme = call_580047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580047.url(scheme.get, call_580047.host, call_580047.base,
                         call_580047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580047, url, valid)

proc call*(call_580048: Call_ContentInventoryCustombatch_580035;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          dryRun: bool = false; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentInventoryCustombatch
  ## Updates price and availability for multiple products or stores in a single request. This operation does not update the expiration date of the products.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580049 = newJObject()
  var body_580050 = newJObject()
  add(query_580049, "fields", newJString(fields))
  add(query_580049, "quotaUser", newJString(quotaUser))
  add(query_580049, "alt", newJString(alt))
  add(query_580049, "dryRun", newJBool(dryRun))
  add(query_580049, "oauth_token", newJString(oauthToken))
  add(query_580049, "userIp", newJString(userIp))
  add(query_580049, "key", newJString(key))
  if body != nil:
    body_580050 = body
  add(query_580049, "prettyPrint", newJBool(prettyPrint))
  result = call_580048.call(nil, query_580049, nil, nil, body_580050)

var contentInventoryCustombatch* = Call_ContentInventoryCustombatch_580035(
    name: "contentInventoryCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/inventory/batch",
    validator: validate_ContentInventoryCustombatch_580036, base: "/content/v2",
    url: url_ContentInventoryCustombatch_580037, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsCustombatch_580051 = ref object of OpenApiRestCall_579421
proc url_ContentLiasettingsCustombatch_580053(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentLiasettingsCustombatch_580052(path: JsonNode; query: JsonNode;
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
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580054 = query.getOrDefault("fields")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "fields", valid_580054
  var valid_580055 = query.getOrDefault("quotaUser")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "quotaUser", valid_580055
  var valid_580056 = query.getOrDefault("alt")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = newJString("json"))
  if valid_580056 != nil:
    section.add "alt", valid_580056
  var valid_580057 = query.getOrDefault("dryRun")
  valid_580057 = validateParameter(valid_580057, JBool, required = false, default = nil)
  if valid_580057 != nil:
    section.add "dryRun", valid_580057
  var valid_580058 = query.getOrDefault("oauth_token")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "oauth_token", valid_580058
  var valid_580059 = query.getOrDefault("userIp")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "userIp", valid_580059
  var valid_580060 = query.getOrDefault("key")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "key", valid_580060
  var valid_580061 = query.getOrDefault("prettyPrint")
  valid_580061 = validateParameter(valid_580061, JBool, required = false,
                                 default = newJBool(true))
  if valid_580061 != nil:
    section.add "prettyPrint", valid_580061
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

proc call*(call_580063: Call_ContentLiasettingsCustombatch_580051; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves and/or updates the LIA settings of multiple accounts in a single request.
  ## 
  let valid = call_580063.validator(path, query, header, formData, body)
  let scheme = call_580063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580063.url(scheme.get, call_580063.host, call_580063.base,
                         call_580063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580063, url, valid)

proc call*(call_580064: Call_ContentLiasettingsCustombatch_580051;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          dryRun: bool = false; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentLiasettingsCustombatch
  ## Retrieves and/or updates the LIA settings of multiple accounts in a single request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580065 = newJObject()
  var body_580066 = newJObject()
  add(query_580065, "fields", newJString(fields))
  add(query_580065, "quotaUser", newJString(quotaUser))
  add(query_580065, "alt", newJString(alt))
  add(query_580065, "dryRun", newJBool(dryRun))
  add(query_580065, "oauth_token", newJString(oauthToken))
  add(query_580065, "userIp", newJString(userIp))
  add(query_580065, "key", newJString(key))
  if body != nil:
    body_580066 = body
  add(query_580065, "prettyPrint", newJBool(prettyPrint))
  result = call_580064.call(nil, query_580065, nil, nil, body_580066)

var contentLiasettingsCustombatch* = Call_ContentLiasettingsCustombatch_580051(
    name: "contentLiasettingsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liasettings/batch",
    validator: validate_ContentLiasettingsCustombatch_580052, base: "/content/v2",
    url: url_ContentLiasettingsCustombatch_580053, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsListposdataproviders_580067 = ref object of OpenApiRestCall_579421
proc url_ContentLiasettingsListposdataproviders_580069(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentLiasettingsListposdataproviders_580068(path: JsonNode;
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
  var valid_580070 = query.getOrDefault("fields")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "fields", valid_580070
  var valid_580071 = query.getOrDefault("quotaUser")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "quotaUser", valid_580071
  var valid_580072 = query.getOrDefault("alt")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = newJString("json"))
  if valid_580072 != nil:
    section.add "alt", valid_580072
  var valid_580073 = query.getOrDefault("oauth_token")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "oauth_token", valid_580073
  var valid_580074 = query.getOrDefault("userIp")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "userIp", valid_580074
  var valid_580075 = query.getOrDefault("key")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "key", valid_580075
  var valid_580076 = query.getOrDefault("prettyPrint")
  valid_580076 = validateParameter(valid_580076, JBool, required = false,
                                 default = newJBool(true))
  if valid_580076 != nil:
    section.add "prettyPrint", valid_580076
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580077: Call_ContentLiasettingsListposdataproviders_580067;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of POS data providers that have active settings for the all eiligible countries.
  ## 
  let valid = call_580077.validator(path, query, header, formData, body)
  let scheme = call_580077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580077.url(scheme.get, call_580077.host, call_580077.base,
                         call_580077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580077, url, valid)

proc call*(call_580078: Call_ContentLiasettingsListposdataproviders_580067;
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
  var query_580079 = newJObject()
  add(query_580079, "fields", newJString(fields))
  add(query_580079, "quotaUser", newJString(quotaUser))
  add(query_580079, "alt", newJString(alt))
  add(query_580079, "oauth_token", newJString(oauthToken))
  add(query_580079, "userIp", newJString(userIp))
  add(query_580079, "key", newJString(key))
  add(query_580079, "prettyPrint", newJBool(prettyPrint))
  result = call_580078.call(nil, query_580079, nil, nil, nil)

var contentLiasettingsListposdataproviders* = Call_ContentLiasettingsListposdataproviders_580067(
    name: "contentLiasettingsListposdataproviders", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/liasettings/posdataproviders",
    validator: validate_ContentLiasettingsListposdataproviders_580068,
    base: "/content/v2", url: url_ContentLiasettingsListposdataproviders_580069,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersCustombatch_580080 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersCustombatch_580082(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentOrdersCustombatch_580081(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves or modifies multiple orders in a single request.
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
  var valid_580083 = query.getOrDefault("fields")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "fields", valid_580083
  var valid_580084 = query.getOrDefault("quotaUser")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "quotaUser", valid_580084
  var valid_580085 = query.getOrDefault("alt")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = newJString("json"))
  if valid_580085 != nil:
    section.add "alt", valid_580085
  var valid_580086 = query.getOrDefault("oauth_token")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "oauth_token", valid_580086
  var valid_580087 = query.getOrDefault("userIp")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "userIp", valid_580087
  var valid_580088 = query.getOrDefault("key")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "key", valid_580088
  var valid_580089 = query.getOrDefault("prettyPrint")
  valid_580089 = validateParameter(valid_580089, JBool, required = false,
                                 default = newJBool(true))
  if valid_580089 != nil:
    section.add "prettyPrint", valid_580089
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

proc call*(call_580091: Call_ContentOrdersCustombatch_580080; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves or modifies multiple orders in a single request.
  ## 
  let valid = call_580091.validator(path, query, header, formData, body)
  let scheme = call_580091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580091.url(scheme.get, call_580091.host, call_580091.base,
                         call_580091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580091, url, valid)

proc call*(call_580092: Call_ContentOrdersCustombatch_580080; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## contentOrdersCustombatch
  ## Retrieves or modifies multiple orders in a single request.
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
  var query_580093 = newJObject()
  var body_580094 = newJObject()
  add(query_580093, "fields", newJString(fields))
  add(query_580093, "quotaUser", newJString(quotaUser))
  add(query_580093, "alt", newJString(alt))
  add(query_580093, "oauth_token", newJString(oauthToken))
  add(query_580093, "userIp", newJString(userIp))
  add(query_580093, "key", newJString(key))
  if body != nil:
    body_580094 = body
  add(query_580093, "prettyPrint", newJBool(prettyPrint))
  result = call_580092.call(nil, query_580093, nil, nil, body_580094)

var contentOrdersCustombatch* = Call_ContentOrdersCustombatch_580080(
    name: "contentOrdersCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/orders/batch",
    validator: validate_ContentOrdersCustombatch_580081, base: "/content/v2",
    url: url_ContentOrdersCustombatch_580082, schemes: {Scheme.Https})
type
  Call_ContentPosCustombatch_580095 = ref object of OpenApiRestCall_579421
proc url_ContentPosCustombatch_580097(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentPosCustombatch_580096(path: JsonNode; query: JsonNode;
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
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580098 = query.getOrDefault("fields")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "fields", valid_580098
  var valid_580099 = query.getOrDefault("quotaUser")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "quotaUser", valid_580099
  var valid_580100 = query.getOrDefault("alt")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = newJString("json"))
  if valid_580100 != nil:
    section.add "alt", valid_580100
  var valid_580101 = query.getOrDefault("dryRun")
  valid_580101 = validateParameter(valid_580101, JBool, required = false, default = nil)
  if valid_580101 != nil:
    section.add "dryRun", valid_580101
  var valid_580102 = query.getOrDefault("oauth_token")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "oauth_token", valid_580102
  var valid_580103 = query.getOrDefault("userIp")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "userIp", valid_580103
  var valid_580104 = query.getOrDefault("key")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "key", valid_580104
  var valid_580105 = query.getOrDefault("prettyPrint")
  valid_580105 = validateParameter(valid_580105, JBool, required = false,
                                 default = newJBool(true))
  if valid_580105 != nil:
    section.add "prettyPrint", valid_580105
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

proc call*(call_580107: Call_ContentPosCustombatch_580095; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Batches multiple POS-related calls in a single request.
  ## 
  let valid = call_580107.validator(path, query, header, formData, body)
  let scheme = call_580107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580107.url(scheme.get, call_580107.host, call_580107.base,
                         call_580107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580107, url, valid)

proc call*(call_580108: Call_ContentPosCustombatch_580095; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; dryRun: bool = false;
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentPosCustombatch
  ## Batches multiple POS-related calls in a single request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580109 = newJObject()
  var body_580110 = newJObject()
  add(query_580109, "fields", newJString(fields))
  add(query_580109, "quotaUser", newJString(quotaUser))
  add(query_580109, "alt", newJString(alt))
  add(query_580109, "dryRun", newJBool(dryRun))
  add(query_580109, "oauth_token", newJString(oauthToken))
  add(query_580109, "userIp", newJString(userIp))
  add(query_580109, "key", newJString(key))
  if body != nil:
    body_580110 = body
  add(query_580109, "prettyPrint", newJBool(prettyPrint))
  result = call_580108.call(nil, query_580109, nil, nil, body_580110)

var contentPosCustombatch* = Call_ContentPosCustombatch_580095(
    name: "contentPosCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/pos/batch",
    validator: validate_ContentPosCustombatch_580096, base: "/content/v2",
    url: url_ContentPosCustombatch_580097, schemes: {Scheme.Https})
type
  Call_ContentProductsCustombatch_580111 = ref object of OpenApiRestCall_579421
proc url_ContentProductsCustombatch_580113(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentProductsCustombatch_580112(path: JsonNode; query: JsonNode;
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
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580114 = query.getOrDefault("fields")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "fields", valid_580114
  var valid_580115 = query.getOrDefault("quotaUser")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "quotaUser", valid_580115
  var valid_580116 = query.getOrDefault("alt")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = newJString("json"))
  if valid_580116 != nil:
    section.add "alt", valid_580116
  var valid_580117 = query.getOrDefault("dryRun")
  valid_580117 = validateParameter(valid_580117, JBool, required = false, default = nil)
  if valid_580117 != nil:
    section.add "dryRun", valid_580117
  var valid_580118 = query.getOrDefault("oauth_token")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "oauth_token", valid_580118
  var valid_580119 = query.getOrDefault("userIp")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "userIp", valid_580119
  var valid_580120 = query.getOrDefault("key")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "key", valid_580120
  var valid_580121 = query.getOrDefault("prettyPrint")
  valid_580121 = validateParameter(valid_580121, JBool, required = false,
                                 default = newJBool(true))
  if valid_580121 != nil:
    section.add "prettyPrint", valid_580121
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

proc call*(call_580123: Call_ContentProductsCustombatch_580111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves, inserts, and deletes multiple products in a single request.
  ## 
  let valid = call_580123.validator(path, query, header, formData, body)
  let scheme = call_580123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580123.url(scheme.get, call_580123.host, call_580123.base,
                         call_580123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580123, url, valid)

proc call*(call_580124: Call_ContentProductsCustombatch_580111;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          dryRun: bool = false; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentProductsCustombatch
  ## Retrieves, inserts, and deletes multiple products in a single request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580125 = newJObject()
  var body_580126 = newJObject()
  add(query_580125, "fields", newJString(fields))
  add(query_580125, "quotaUser", newJString(quotaUser))
  add(query_580125, "alt", newJString(alt))
  add(query_580125, "dryRun", newJBool(dryRun))
  add(query_580125, "oauth_token", newJString(oauthToken))
  add(query_580125, "userIp", newJString(userIp))
  add(query_580125, "key", newJString(key))
  if body != nil:
    body_580126 = body
  add(query_580125, "prettyPrint", newJBool(prettyPrint))
  result = call_580124.call(nil, query_580125, nil, nil, body_580126)

var contentProductsCustombatch* = Call_ContentProductsCustombatch_580111(
    name: "contentProductsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/products/batch",
    validator: validate_ContentProductsCustombatch_580112, base: "/content/v2",
    url: url_ContentProductsCustombatch_580113, schemes: {Scheme.Https})
type
  Call_ContentProductstatusesCustombatch_580127 = ref object of OpenApiRestCall_579421
proc url_ContentProductstatusesCustombatch_580129(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentProductstatusesCustombatch_580128(path: JsonNode;
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
  ##   includeAttributes: JBool
  ##                    : Flag to include full product data in the results of this request. The default value is false.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580130 = query.getOrDefault("fields")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "fields", valid_580130
  var valid_580131 = query.getOrDefault("quotaUser")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "quotaUser", valid_580131
  var valid_580132 = query.getOrDefault("alt")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = newJString("json"))
  if valid_580132 != nil:
    section.add "alt", valid_580132
  var valid_580133 = query.getOrDefault("oauth_token")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "oauth_token", valid_580133
  var valid_580134 = query.getOrDefault("userIp")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "userIp", valid_580134
  var valid_580135 = query.getOrDefault("includeAttributes")
  valid_580135 = validateParameter(valid_580135, JBool, required = false, default = nil)
  if valid_580135 != nil:
    section.add "includeAttributes", valid_580135
  var valid_580136 = query.getOrDefault("key")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "key", valid_580136
  var valid_580137 = query.getOrDefault("prettyPrint")
  valid_580137 = validateParameter(valid_580137, JBool, required = false,
                                 default = newJBool(true))
  if valid_580137 != nil:
    section.add "prettyPrint", valid_580137
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

proc call*(call_580139: Call_ContentProductstatusesCustombatch_580127;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the statuses of multiple products in a single request.
  ## 
  let valid = call_580139.validator(path, query, header, formData, body)
  let scheme = call_580139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580139.url(scheme.get, call_580139.host, call_580139.base,
                         call_580139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580139, url, valid)

proc call*(call_580140: Call_ContentProductstatusesCustombatch_580127;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; includeAttributes: bool = false;
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
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
  ##   includeAttributes: bool
  ##                    : Flag to include full product data in the results of this request. The default value is false.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580141 = newJObject()
  var body_580142 = newJObject()
  add(query_580141, "fields", newJString(fields))
  add(query_580141, "quotaUser", newJString(quotaUser))
  add(query_580141, "alt", newJString(alt))
  add(query_580141, "oauth_token", newJString(oauthToken))
  add(query_580141, "userIp", newJString(userIp))
  add(query_580141, "includeAttributes", newJBool(includeAttributes))
  add(query_580141, "key", newJString(key))
  if body != nil:
    body_580142 = body
  add(query_580141, "prettyPrint", newJBool(prettyPrint))
  result = call_580140.call(nil, query_580141, nil, nil, body_580142)

var contentProductstatusesCustombatch* = Call_ContentProductstatusesCustombatch_580127(
    name: "contentProductstatusesCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/productstatuses/batch",
    validator: validate_ContentProductstatusesCustombatch_580128,
    base: "/content/v2", url: url_ContentProductstatusesCustombatch_580129,
    schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsCustombatch_580143 = ref object of OpenApiRestCall_579421
proc url_ContentShippingsettingsCustombatch_580145(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentShippingsettingsCustombatch_580144(path: JsonNode;
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
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580146 = query.getOrDefault("fields")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "fields", valid_580146
  var valid_580147 = query.getOrDefault("quotaUser")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "quotaUser", valid_580147
  var valid_580148 = query.getOrDefault("alt")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = newJString("json"))
  if valid_580148 != nil:
    section.add "alt", valid_580148
  var valid_580149 = query.getOrDefault("dryRun")
  valid_580149 = validateParameter(valid_580149, JBool, required = false, default = nil)
  if valid_580149 != nil:
    section.add "dryRun", valid_580149
  var valid_580150 = query.getOrDefault("oauth_token")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "oauth_token", valid_580150
  var valid_580151 = query.getOrDefault("userIp")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "userIp", valid_580151
  var valid_580152 = query.getOrDefault("key")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "key", valid_580152
  var valid_580153 = query.getOrDefault("prettyPrint")
  valid_580153 = validateParameter(valid_580153, JBool, required = false,
                                 default = newJBool(true))
  if valid_580153 != nil:
    section.add "prettyPrint", valid_580153
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

proc call*(call_580155: Call_ContentShippingsettingsCustombatch_580143;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves and updates the shipping settings of multiple accounts in a single request.
  ## 
  let valid = call_580155.validator(path, query, header, formData, body)
  let scheme = call_580155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580155.url(scheme.get, call_580155.host, call_580155.base,
                         call_580155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580155, url, valid)

proc call*(call_580156: Call_ContentShippingsettingsCustombatch_580143;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          dryRun: bool = false; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentShippingsettingsCustombatch
  ## Retrieves and updates the shipping settings of multiple accounts in a single request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580157 = newJObject()
  var body_580158 = newJObject()
  add(query_580157, "fields", newJString(fields))
  add(query_580157, "quotaUser", newJString(quotaUser))
  add(query_580157, "alt", newJString(alt))
  add(query_580157, "dryRun", newJBool(dryRun))
  add(query_580157, "oauth_token", newJString(oauthToken))
  add(query_580157, "userIp", newJString(userIp))
  add(query_580157, "key", newJString(key))
  if body != nil:
    body_580158 = body
  add(query_580157, "prettyPrint", newJBool(prettyPrint))
  result = call_580156.call(nil, query_580157, nil, nil, body_580158)

var contentShippingsettingsCustombatch* = Call_ContentShippingsettingsCustombatch_580143(
    name: "contentShippingsettingsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/shippingsettings/batch",
    validator: validate_ContentShippingsettingsCustombatch_580144,
    base: "/content/v2", url: url_ContentShippingsettingsCustombatch_580145,
    schemes: {Scheme.Https})
type
  Call_ContentAccountsInsert_580190 = ref object of OpenApiRestCall_579421
proc url_ContentAccountsInsert_580192(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsInsert_580191(path: JsonNode; query: JsonNode;
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
  var valid_580193 = path.getOrDefault("merchantId")
  valid_580193 = validateParameter(valid_580193, JString, required = true,
                                 default = nil)
  if valid_580193 != nil:
    section.add "merchantId", valid_580193
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580194 = query.getOrDefault("fields")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "fields", valid_580194
  var valid_580195 = query.getOrDefault("quotaUser")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "quotaUser", valid_580195
  var valid_580196 = query.getOrDefault("alt")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = newJString("json"))
  if valid_580196 != nil:
    section.add "alt", valid_580196
  var valid_580197 = query.getOrDefault("dryRun")
  valid_580197 = validateParameter(valid_580197, JBool, required = false, default = nil)
  if valid_580197 != nil:
    section.add "dryRun", valid_580197
  var valid_580198 = query.getOrDefault("oauth_token")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "oauth_token", valid_580198
  var valid_580199 = query.getOrDefault("userIp")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "userIp", valid_580199
  var valid_580200 = query.getOrDefault("key")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "key", valid_580200
  var valid_580201 = query.getOrDefault("prettyPrint")
  valid_580201 = validateParameter(valid_580201, JBool, required = false,
                                 default = newJBool(true))
  if valid_580201 != nil:
    section.add "prettyPrint", valid_580201
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

proc call*(call_580203: Call_ContentAccountsInsert_580190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Merchant Center sub-account.
  ## 
  let valid = call_580203.validator(path, query, header, formData, body)
  let scheme = call_580203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580203.url(scheme.get, call_580203.host, call_580203.base,
                         call_580203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580203, url, valid)

proc call*(call_580204: Call_ContentAccountsInsert_580190; merchantId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          dryRun: bool = false; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentAccountsInsert
  ## Creates a Merchant Center sub-account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
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
  var path_580205 = newJObject()
  var query_580206 = newJObject()
  var body_580207 = newJObject()
  add(query_580206, "fields", newJString(fields))
  add(query_580206, "quotaUser", newJString(quotaUser))
  add(query_580206, "alt", newJString(alt))
  add(query_580206, "dryRun", newJBool(dryRun))
  add(query_580206, "oauth_token", newJString(oauthToken))
  add(query_580206, "userIp", newJString(userIp))
  add(query_580206, "key", newJString(key))
  add(path_580205, "merchantId", newJString(merchantId))
  if body != nil:
    body_580207 = body
  add(query_580206, "prettyPrint", newJBool(prettyPrint))
  result = call_580204.call(path_580205, query_580206, nil, nil, body_580207)

var contentAccountsInsert* = Call_ContentAccountsInsert_580190(
    name: "contentAccountsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/accounts",
    validator: validate_ContentAccountsInsert_580191, base: "/content/v2",
    url: url_ContentAccountsInsert_580192, schemes: {Scheme.Https})
type
  Call_ContentAccountsList_580159 = ref object of OpenApiRestCall_579421
proc url_ContentAccountsList_580161(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsList_580160(path: JsonNode; query: JsonNode;
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
  var valid_580176 = path.getOrDefault("merchantId")
  valid_580176 = validateParameter(valid_580176, JString, required = true,
                                 default = nil)
  if valid_580176 != nil:
    section.add "merchantId", valid_580176
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
  var valid_580177 = query.getOrDefault("fields")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "fields", valid_580177
  var valid_580178 = query.getOrDefault("pageToken")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "pageToken", valid_580178
  var valid_580179 = query.getOrDefault("quotaUser")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "quotaUser", valid_580179
  var valid_580180 = query.getOrDefault("alt")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = newJString("json"))
  if valid_580180 != nil:
    section.add "alt", valid_580180
  var valid_580181 = query.getOrDefault("oauth_token")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "oauth_token", valid_580181
  var valid_580182 = query.getOrDefault("userIp")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "userIp", valid_580182
  var valid_580183 = query.getOrDefault("maxResults")
  valid_580183 = validateParameter(valid_580183, JInt, required = false, default = nil)
  if valid_580183 != nil:
    section.add "maxResults", valid_580183
  var valid_580184 = query.getOrDefault("key")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "key", valid_580184
  var valid_580185 = query.getOrDefault("prettyPrint")
  valid_580185 = validateParameter(valid_580185, JBool, required = false,
                                 default = newJBool(true))
  if valid_580185 != nil:
    section.add "prettyPrint", valid_580185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580186: Call_ContentAccountsList_580159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_580186.validator(path, query, header, formData, body)
  let scheme = call_580186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580186.url(scheme.get, call_580186.host, call_580186.base,
                         call_580186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580186, url, valid)

proc call*(call_580187: Call_ContentAccountsList_580159; merchantId: string;
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
  var path_580188 = newJObject()
  var query_580189 = newJObject()
  add(query_580189, "fields", newJString(fields))
  add(query_580189, "pageToken", newJString(pageToken))
  add(query_580189, "quotaUser", newJString(quotaUser))
  add(query_580189, "alt", newJString(alt))
  add(query_580189, "oauth_token", newJString(oauthToken))
  add(query_580189, "userIp", newJString(userIp))
  add(query_580189, "maxResults", newJInt(maxResults))
  add(query_580189, "key", newJString(key))
  add(path_580188, "merchantId", newJString(merchantId))
  add(query_580189, "prettyPrint", newJBool(prettyPrint))
  result = call_580187.call(path_580188, query_580189, nil, nil, nil)

var contentAccountsList* = Call_ContentAccountsList_580159(
    name: "contentAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounts",
    validator: validate_ContentAccountsList_580160, base: "/content/v2",
    url: url_ContentAccountsList_580161, schemes: {Scheme.Https})
type
  Call_ContentAccountsUpdate_580224 = ref object of OpenApiRestCall_579421
proc url_ContentAccountsUpdate_580226(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsUpdate_580225(path: JsonNode; query: JsonNode;
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
  var valid_580227 = path.getOrDefault("accountId")
  valid_580227 = validateParameter(valid_580227, JString, required = true,
                                 default = nil)
  if valid_580227 != nil:
    section.add "accountId", valid_580227
  var valid_580228 = path.getOrDefault("merchantId")
  valid_580228 = validateParameter(valid_580228, JString, required = true,
                                 default = nil)
  if valid_580228 != nil:
    section.add "merchantId", valid_580228
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580229 = query.getOrDefault("fields")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "fields", valid_580229
  var valid_580230 = query.getOrDefault("quotaUser")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "quotaUser", valid_580230
  var valid_580231 = query.getOrDefault("alt")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = newJString("json"))
  if valid_580231 != nil:
    section.add "alt", valid_580231
  var valid_580232 = query.getOrDefault("dryRun")
  valid_580232 = validateParameter(valid_580232, JBool, required = false, default = nil)
  if valid_580232 != nil:
    section.add "dryRun", valid_580232
  var valid_580233 = query.getOrDefault("oauth_token")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "oauth_token", valid_580233
  var valid_580234 = query.getOrDefault("userIp")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "userIp", valid_580234
  var valid_580235 = query.getOrDefault("key")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "key", valid_580235
  var valid_580236 = query.getOrDefault("prettyPrint")
  valid_580236 = validateParameter(valid_580236, JBool, required = false,
                                 default = newJBool(true))
  if valid_580236 != nil:
    section.add "prettyPrint", valid_580236
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

proc call*(call_580238: Call_ContentAccountsUpdate_580224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Merchant Center account.
  ## 
  let valid = call_580238.validator(path, query, header, formData, body)
  let scheme = call_580238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580238.url(scheme.get, call_580238.host, call_580238.base,
                         call_580238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580238, url, valid)

proc call*(call_580239: Call_ContentAccountsUpdate_580224; accountId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; dryRun: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## contentAccountsUpdate
  ## Updates a Merchant Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
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
  var path_580240 = newJObject()
  var query_580241 = newJObject()
  var body_580242 = newJObject()
  add(query_580241, "fields", newJString(fields))
  add(query_580241, "quotaUser", newJString(quotaUser))
  add(query_580241, "alt", newJString(alt))
  add(query_580241, "dryRun", newJBool(dryRun))
  add(query_580241, "oauth_token", newJString(oauthToken))
  add(path_580240, "accountId", newJString(accountId))
  add(query_580241, "userIp", newJString(userIp))
  add(query_580241, "key", newJString(key))
  add(path_580240, "merchantId", newJString(merchantId))
  if body != nil:
    body_580242 = body
  add(query_580241, "prettyPrint", newJBool(prettyPrint))
  result = call_580239.call(path_580240, query_580241, nil, nil, body_580242)

var contentAccountsUpdate* = Call_ContentAccountsUpdate_580224(
    name: "contentAccountsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsUpdate_580225, base: "/content/v2",
    url: url_ContentAccountsUpdate_580226, schemes: {Scheme.Https})
type
  Call_ContentAccountsGet_580208 = ref object of OpenApiRestCall_579421
proc url_ContentAccountsGet_580210(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsGet_580209(path: JsonNode; query: JsonNode;
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
  var valid_580211 = path.getOrDefault("accountId")
  valid_580211 = validateParameter(valid_580211, JString, required = true,
                                 default = nil)
  if valid_580211 != nil:
    section.add "accountId", valid_580211
  var valid_580212 = path.getOrDefault("merchantId")
  valid_580212 = validateParameter(valid_580212, JString, required = true,
                                 default = nil)
  if valid_580212 != nil:
    section.add "merchantId", valid_580212
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
  var valid_580213 = query.getOrDefault("fields")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "fields", valid_580213
  var valid_580214 = query.getOrDefault("quotaUser")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "quotaUser", valid_580214
  var valid_580215 = query.getOrDefault("alt")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = newJString("json"))
  if valid_580215 != nil:
    section.add "alt", valid_580215
  var valid_580216 = query.getOrDefault("oauth_token")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "oauth_token", valid_580216
  var valid_580217 = query.getOrDefault("userIp")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "userIp", valid_580217
  var valid_580218 = query.getOrDefault("key")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "key", valid_580218
  var valid_580219 = query.getOrDefault("prettyPrint")
  valid_580219 = validateParameter(valid_580219, JBool, required = false,
                                 default = newJBool(true))
  if valid_580219 != nil:
    section.add "prettyPrint", valid_580219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580220: Call_ContentAccountsGet_580208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a Merchant Center account.
  ## 
  let valid = call_580220.validator(path, query, header, formData, body)
  let scheme = call_580220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580220.url(scheme.get, call_580220.host, call_580220.base,
                         call_580220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580220, url, valid)

proc call*(call_580221: Call_ContentAccountsGet_580208; accountId: string;
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
  var path_580222 = newJObject()
  var query_580223 = newJObject()
  add(query_580223, "fields", newJString(fields))
  add(query_580223, "quotaUser", newJString(quotaUser))
  add(query_580223, "alt", newJString(alt))
  add(query_580223, "oauth_token", newJString(oauthToken))
  add(path_580222, "accountId", newJString(accountId))
  add(query_580223, "userIp", newJString(userIp))
  add(query_580223, "key", newJString(key))
  add(path_580222, "merchantId", newJString(merchantId))
  add(query_580223, "prettyPrint", newJBool(prettyPrint))
  result = call_580221.call(path_580222, query_580223, nil, nil, nil)

var contentAccountsGet* = Call_ContentAccountsGet_580208(
    name: "contentAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsGet_580209, base: "/content/v2",
    url: url_ContentAccountsGet_580210, schemes: {Scheme.Https})
type
  Call_ContentAccountsPatch_580261 = ref object of OpenApiRestCall_579421
proc url_ContentAccountsPatch_580263(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsPatch_580262(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a Merchant Center account. This method supports patch semantics.
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
  var valid_580264 = path.getOrDefault("accountId")
  valid_580264 = validateParameter(valid_580264, JString, required = true,
                                 default = nil)
  if valid_580264 != nil:
    section.add "accountId", valid_580264
  var valid_580265 = path.getOrDefault("merchantId")
  valid_580265 = validateParameter(valid_580265, JString, required = true,
                                 default = nil)
  if valid_580265 != nil:
    section.add "merchantId", valid_580265
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580266 = query.getOrDefault("fields")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "fields", valid_580266
  var valid_580267 = query.getOrDefault("quotaUser")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "quotaUser", valid_580267
  var valid_580268 = query.getOrDefault("alt")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = newJString("json"))
  if valid_580268 != nil:
    section.add "alt", valid_580268
  var valid_580269 = query.getOrDefault("dryRun")
  valid_580269 = validateParameter(valid_580269, JBool, required = false, default = nil)
  if valid_580269 != nil:
    section.add "dryRun", valid_580269
  var valid_580270 = query.getOrDefault("oauth_token")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "oauth_token", valid_580270
  var valid_580271 = query.getOrDefault("userIp")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "userIp", valid_580271
  var valid_580272 = query.getOrDefault("key")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "key", valid_580272
  var valid_580273 = query.getOrDefault("prettyPrint")
  valid_580273 = validateParameter(valid_580273, JBool, required = false,
                                 default = newJBool(true))
  if valid_580273 != nil:
    section.add "prettyPrint", valid_580273
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

proc call*(call_580275: Call_ContentAccountsPatch_580261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Merchant Center account. This method supports patch semantics.
  ## 
  let valid = call_580275.validator(path, query, header, formData, body)
  let scheme = call_580275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580275.url(scheme.get, call_580275.host, call_580275.base,
                         call_580275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580275, url, valid)

proc call*(call_580276: Call_ContentAccountsPatch_580261; accountId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; dryRun: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## contentAccountsPatch
  ## Updates a Merchant Center account. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
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
  var path_580277 = newJObject()
  var query_580278 = newJObject()
  var body_580279 = newJObject()
  add(query_580278, "fields", newJString(fields))
  add(query_580278, "quotaUser", newJString(quotaUser))
  add(query_580278, "alt", newJString(alt))
  add(query_580278, "dryRun", newJBool(dryRun))
  add(query_580278, "oauth_token", newJString(oauthToken))
  add(path_580277, "accountId", newJString(accountId))
  add(query_580278, "userIp", newJString(userIp))
  add(query_580278, "key", newJString(key))
  add(path_580277, "merchantId", newJString(merchantId))
  if body != nil:
    body_580279 = body
  add(query_580278, "prettyPrint", newJBool(prettyPrint))
  result = call_580276.call(path_580277, query_580278, nil, nil, body_580279)

var contentAccountsPatch* = Call_ContentAccountsPatch_580261(
    name: "contentAccountsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsPatch_580262, base: "/content/v2",
    url: url_ContentAccountsPatch_580263, schemes: {Scheme.Https})
type
  Call_ContentAccountsDelete_580243 = ref object of OpenApiRestCall_579421
proc url_ContentAccountsDelete_580245(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsDelete_580244(path: JsonNode; query: JsonNode;
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
  var valid_580246 = path.getOrDefault("accountId")
  valid_580246 = validateParameter(valid_580246, JString, required = true,
                                 default = nil)
  if valid_580246 != nil:
    section.add "accountId", valid_580246
  var valid_580247 = path.getOrDefault("merchantId")
  valid_580247 = validateParameter(valid_580247, JString, required = true,
                                 default = nil)
  if valid_580247 != nil:
    section.add "merchantId", valid_580247
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
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580248 = query.getOrDefault("fields")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "fields", valid_580248
  var valid_580249 = query.getOrDefault("force")
  valid_580249 = validateParameter(valid_580249, JBool, required = false,
                                 default = newJBool(false))
  if valid_580249 != nil:
    section.add "force", valid_580249
  var valid_580250 = query.getOrDefault("quotaUser")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "quotaUser", valid_580250
  var valid_580251 = query.getOrDefault("alt")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = newJString("json"))
  if valid_580251 != nil:
    section.add "alt", valid_580251
  var valid_580252 = query.getOrDefault("dryRun")
  valid_580252 = validateParameter(valid_580252, JBool, required = false, default = nil)
  if valid_580252 != nil:
    section.add "dryRun", valid_580252
  var valid_580253 = query.getOrDefault("oauth_token")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "oauth_token", valid_580253
  var valid_580254 = query.getOrDefault("userIp")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "userIp", valid_580254
  var valid_580255 = query.getOrDefault("key")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "key", valid_580255
  var valid_580256 = query.getOrDefault("prettyPrint")
  valid_580256 = validateParameter(valid_580256, JBool, required = false,
                                 default = newJBool(true))
  if valid_580256 != nil:
    section.add "prettyPrint", valid_580256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580257: Call_ContentAccountsDelete_580243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Merchant Center sub-account.
  ## 
  let valid = call_580257.validator(path, query, header, formData, body)
  let scheme = call_580257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580257.url(scheme.get, call_580257.host, call_580257.base,
                         call_580257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580257, url, valid)

proc call*(call_580258: Call_ContentAccountsDelete_580243; accountId: string;
          merchantId: string; fields: string = ""; force: bool = false;
          quotaUser: string = ""; alt: string = "json"; dryRun: bool = false;
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
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
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
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
  var path_580259 = newJObject()
  var query_580260 = newJObject()
  add(query_580260, "fields", newJString(fields))
  add(query_580260, "force", newJBool(force))
  add(query_580260, "quotaUser", newJString(quotaUser))
  add(query_580260, "alt", newJString(alt))
  add(query_580260, "dryRun", newJBool(dryRun))
  add(query_580260, "oauth_token", newJString(oauthToken))
  add(path_580259, "accountId", newJString(accountId))
  add(query_580260, "userIp", newJString(userIp))
  add(query_580260, "key", newJString(key))
  add(path_580259, "merchantId", newJString(merchantId))
  add(query_580260, "prettyPrint", newJBool(prettyPrint))
  result = call_580258.call(path_580259, query_580260, nil, nil, nil)

var contentAccountsDelete* = Call_ContentAccountsDelete_580243(
    name: "contentAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsDelete_580244, base: "/content/v2",
    url: url_ContentAccountsDelete_580245, schemes: {Scheme.Https})
type
  Call_ContentAccountsClaimwebsite_580280 = ref object of OpenApiRestCall_579421
proc url_ContentAccountsClaimwebsite_580282(protocol: Scheme; host: string;
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

proc validate_ContentAccountsClaimwebsite_580281(path: JsonNode; query: JsonNode;
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
  var valid_580283 = path.getOrDefault("accountId")
  valid_580283 = validateParameter(valid_580283, JString, required = true,
                                 default = nil)
  if valid_580283 != nil:
    section.add "accountId", valid_580283
  var valid_580284 = path.getOrDefault("merchantId")
  valid_580284 = validateParameter(valid_580284, JString, required = true,
                                 default = nil)
  if valid_580284 != nil:
    section.add "merchantId", valid_580284
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
  var valid_580285 = query.getOrDefault("fields")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "fields", valid_580285
  var valid_580286 = query.getOrDefault("quotaUser")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "quotaUser", valid_580286
  var valid_580287 = query.getOrDefault("alt")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = newJString("json"))
  if valid_580287 != nil:
    section.add "alt", valid_580287
  var valid_580288 = query.getOrDefault("oauth_token")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "oauth_token", valid_580288
  var valid_580289 = query.getOrDefault("userIp")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "userIp", valid_580289
  var valid_580290 = query.getOrDefault("overwrite")
  valid_580290 = validateParameter(valid_580290, JBool, required = false, default = nil)
  if valid_580290 != nil:
    section.add "overwrite", valid_580290
  var valid_580291 = query.getOrDefault("key")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "key", valid_580291
  var valid_580292 = query.getOrDefault("prettyPrint")
  valid_580292 = validateParameter(valid_580292, JBool, required = false,
                                 default = newJBool(true))
  if valid_580292 != nil:
    section.add "prettyPrint", valid_580292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580293: Call_ContentAccountsClaimwebsite_580280; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Claims the website of a Merchant Center sub-account.
  ## 
  let valid = call_580293.validator(path, query, header, formData, body)
  let scheme = call_580293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580293.url(scheme.get, call_580293.host, call_580293.base,
                         call_580293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580293, url, valid)

proc call*(call_580294: Call_ContentAccountsClaimwebsite_580280; accountId: string;
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
  var path_580295 = newJObject()
  var query_580296 = newJObject()
  add(query_580296, "fields", newJString(fields))
  add(query_580296, "quotaUser", newJString(quotaUser))
  add(query_580296, "alt", newJString(alt))
  add(query_580296, "oauth_token", newJString(oauthToken))
  add(path_580295, "accountId", newJString(accountId))
  add(query_580296, "userIp", newJString(userIp))
  add(query_580296, "overwrite", newJBool(overwrite))
  add(query_580296, "key", newJString(key))
  add(path_580295, "merchantId", newJString(merchantId))
  add(query_580296, "prettyPrint", newJBool(prettyPrint))
  result = call_580294.call(path_580295, query_580296, nil, nil, nil)

var contentAccountsClaimwebsite* = Call_ContentAccountsClaimwebsite_580280(
    name: "contentAccountsClaimwebsite", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/accounts/{accountId}/claimwebsite",
    validator: validate_ContentAccountsClaimwebsite_580281, base: "/content/v2",
    url: url_ContentAccountsClaimwebsite_580282, schemes: {Scheme.Https})
type
  Call_ContentAccountsLink_580297 = ref object of OpenApiRestCall_579421
proc url_ContentAccountsLink_580299(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsLink_580298(path: JsonNode; query: JsonNode;
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
  var valid_580300 = path.getOrDefault("accountId")
  valid_580300 = validateParameter(valid_580300, JString, required = true,
                                 default = nil)
  if valid_580300 != nil:
    section.add "accountId", valid_580300
  var valid_580301 = path.getOrDefault("merchantId")
  valid_580301 = validateParameter(valid_580301, JString, required = true,
                                 default = nil)
  if valid_580301 != nil:
    section.add "merchantId", valid_580301
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
  var valid_580302 = query.getOrDefault("fields")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "fields", valid_580302
  var valid_580303 = query.getOrDefault("quotaUser")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "quotaUser", valid_580303
  var valid_580304 = query.getOrDefault("alt")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = newJString("json"))
  if valid_580304 != nil:
    section.add "alt", valid_580304
  var valid_580305 = query.getOrDefault("oauth_token")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "oauth_token", valid_580305
  var valid_580306 = query.getOrDefault("userIp")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "userIp", valid_580306
  var valid_580307 = query.getOrDefault("key")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "key", valid_580307
  var valid_580308 = query.getOrDefault("prettyPrint")
  valid_580308 = validateParameter(valid_580308, JBool, required = false,
                                 default = newJBool(true))
  if valid_580308 != nil:
    section.add "prettyPrint", valid_580308
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

proc call*(call_580310: Call_ContentAccountsLink_580297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs an action on a link between two Merchant Center accounts, namely accountId and linkedAccountId.
  ## 
  let valid = call_580310.validator(path, query, header, formData, body)
  let scheme = call_580310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580310.url(scheme.get, call_580310.host, call_580310.base,
                         call_580310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580310, url, valid)

proc call*(call_580311: Call_ContentAccountsLink_580297; accountId: string;
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
  var path_580312 = newJObject()
  var query_580313 = newJObject()
  var body_580314 = newJObject()
  add(query_580313, "fields", newJString(fields))
  add(query_580313, "quotaUser", newJString(quotaUser))
  add(query_580313, "alt", newJString(alt))
  add(query_580313, "oauth_token", newJString(oauthToken))
  add(path_580312, "accountId", newJString(accountId))
  add(query_580313, "userIp", newJString(userIp))
  add(query_580313, "key", newJString(key))
  add(path_580312, "merchantId", newJString(merchantId))
  if body != nil:
    body_580314 = body
  add(query_580313, "prettyPrint", newJBool(prettyPrint))
  result = call_580311.call(path_580312, query_580313, nil, nil, body_580314)

var contentAccountsLink* = Call_ContentAccountsLink_580297(
    name: "contentAccountsLink", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}/link",
    validator: validate_ContentAccountsLink_580298, base: "/content/v2",
    url: url_ContentAccountsLink_580299, schemes: {Scheme.Https})
type
  Call_ContentAccountstatusesList_580315 = ref object of OpenApiRestCall_579421
proc url_ContentAccountstatusesList_580317(protocol: Scheme; host: string;
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

proc validate_ContentAccountstatusesList_580316(path: JsonNode; query: JsonNode;
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
  var valid_580318 = path.getOrDefault("merchantId")
  valid_580318 = validateParameter(valid_580318, JString, required = true,
                                 default = nil)
  if valid_580318 != nil:
    section.add "merchantId", valid_580318
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
  var valid_580319 = query.getOrDefault("fields")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = nil)
  if valid_580319 != nil:
    section.add "fields", valid_580319
  var valid_580320 = query.getOrDefault("pageToken")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "pageToken", valid_580320
  var valid_580321 = query.getOrDefault("quotaUser")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "quotaUser", valid_580321
  var valid_580322 = query.getOrDefault("alt")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = newJString("json"))
  if valid_580322 != nil:
    section.add "alt", valid_580322
  var valid_580323 = query.getOrDefault("oauth_token")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "oauth_token", valid_580323
  var valid_580324 = query.getOrDefault("userIp")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "userIp", valid_580324
  var valid_580325 = query.getOrDefault("maxResults")
  valid_580325 = validateParameter(valid_580325, JInt, required = false, default = nil)
  if valid_580325 != nil:
    section.add "maxResults", valid_580325
  var valid_580326 = query.getOrDefault("key")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = nil)
  if valid_580326 != nil:
    section.add "key", valid_580326
  var valid_580327 = query.getOrDefault("prettyPrint")
  valid_580327 = validateParameter(valid_580327, JBool, required = false,
                                 default = newJBool(true))
  if valid_580327 != nil:
    section.add "prettyPrint", valid_580327
  var valid_580328 = query.getOrDefault("destinations")
  valid_580328 = validateParameter(valid_580328, JArray, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "destinations", valid_580328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580329: Call_ContentAccountstatusesList_580315; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_580329.validator(path, query, header, formData, body)
  let scheme = call_580329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580329.url(scheme.get, call_580329.host, call_580329.base,
                         call_580329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580329, url, valid)

proc call*(call_580330: Call_ContentAccountstatusesList_580315; merchantId: string;
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
  var path_580331 = newJObject()
  var query_580332 = newJObject()
  add(query_580332, "fields", newJString(fields))
  add(query_580332, "pageToken", newJString(pageToken))
  add(query_580332, "quotaUser", newJString(quotaUser))
  add(query_580332, "alt", newJString(alt))
  add(query_580332, "oauth_token", newJString(oauthToken))
  add(query_580332, "userIp", newJString(userIp))
  add(query_580332, "maxResults", newJInt(maxResults))
  add(query_580332, "key", newJString(key))
  add(path_580331, "merchantId", newJString(merchantId))
  add(query_580332, "prettyPrint", newJBool(prettyPrint))
  if destinations != nil:
    query_580332.add "destinations", destinations
  result = call_580330.call(path_580331, query_580332, nil, nil, nil)

var contentAccountstatusesList* = Call_ContentAccountstatusesList_580315(
    name: "contentAccountstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accountstatuses",
    validator: validate_ContentAccountstatusesList_580316, base: "/content/v2",
    url: url_ContentAccountstatusesList_580317, schemes: {Scheme.Https})
type
  Call_ContentAccountstatusesGet_580333 = ref object of OpenApiRestCall_579421
proc url_ContentAccountstatusesGet_580335(protocol: Scheme; host: string;
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

proc validate_ContentAccountstatusesGet_580334(path: JsonNode; query: JsonNode;
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
  var valid_580336 = path.getOrDefault("accountId")
  valid_580336 = validateParameter(valid_580336, JString, required = true,
                                 default = nil)
  if valid_580336 != nil:
    section.add "accountId", valid_580336
  var valid_580337 = path.getOrDefault("merchantId")
  valid_580337 = validateParameter(valid_580337, JString, required = true,
                                 default = nil)
  if valid_580337 != nil:
    section.add "merchantId", valid_580337
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
  var valid_580338 = query.getOrDefault("fields")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "fields", valid_580338
  var valid_580339 = query.getOrDefault("quotaUser")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "quotaUser", valid_580339
  var valid_580340 = query.getOrDefault("alt")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = newJString("json"))
  if valid_580340 != nil:
    section.add "alt", valid_580340
  var valid_580341 = query.getOrDefault("oauth_token")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "oauth_token", valid_580341
  var valid_580342 = query.getOrDefault("userIp")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "userIp", valid_580342
  var valid_580343 = query.getOrDefault("key")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "key", valid_580343
  var valid_580344 = query.getOrDefault("prettyPrint")
  valid_580344 = validateParameter(valid_580344, JBool, required = false,
                                 default = newJBool(true))
  if valid_580344 != nil:
    section.add "prettyPrint", valid_580344
  var valid_580345 = query.getOrDefault("destinations")
  valid_580345 = validateParameter(valid_580345, JArray, required = false,
                                 default = nil)
  if valid_580345 != nil:
    section.add "destinations", valid_580345
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580346: Call_ContentAccountstatusesGet_580333; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the status of a Merchant Center account. No itemLevelIssues are returned for multi-client accounts.
  ## 
  let valid = call_580346.validator(path, query, header, formData, body)
  let scheme = call_580346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580346.url(scheme.get, call_580346.host, call_580346.base,
                         call_580346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580346, url, valid)

proc call*(call_580347: Call_ContentAccountstatusesGet_580333; accountId: string;
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
  var path_580348 = newJObject()
  var query_580349 = newJObject()
  add(query_580349, "fields", newJString(fields))
  add(query_580349, "quotaUser", newJString(quotaUser))
  add(query_580349, "alt", newJString(alt))
  add(query_580349, "oauth_token", newJString(oauthToken))
  add(path_580348, "accountId", newJString(accountId))
  add(query_580349, "userIp", newJString(userIp))
  add(query_580349, "key", newJString(key))
  add(path_580348, "merchantId", newJString(merchantId))
  add(query_580349, "prettyPrint", newJBool(prettyPrint))
  if destinations != nil:
    query_580349.add "destinations", destinations
  result = call_580347.call(path_580348, query_580349, nil, nil, nil)

var contentAccountstatusesGet* = Call_ContentAccountstatusesGet_580333(
    name: "contentAccountstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/accountstatuses/{accountId}",
    validator: validate_ContentAccountstatusesGet_580334, base: "/content/v2",
    url: url_ContentAccountstatusesGet_580335, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxList_580350 = ref object of OpenApiRestCall_579421
proc url_ContentAccounttaxList_580352(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccounttaxList_580351(path: JsonNode; query: JsonNode;
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
  var valid_580353 = path.getOrDefault("merchantId")
  valid_580353 = validateParameter(valid_580353, JString, required = true,
                                 default = nil)
  if valid_580353 != nil:
    section.add "merchantId", valid_580353
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
  var valid_580354 = query.getOrDefault("fields")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = nil)
  if valid_580354 != nil:
    section.add "fields", valid_580354
  var valid_580355 = query.getOrDefault("pageToken")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "pageToken", valid_580355
  var valid_580356 = query.getOrDefault("quotaUser")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "quotaUser", valid_580356
  var valid_580357 = query.getOrDefault("alt")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = newJString("json"))
  if valid_580357 != nil:
    section.add "alt", valid_580357
  var valid_580358 = query.getOrDefault("oauth_token")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "oauth_token", valid_580358
  var valid_580359 = query.getOrDefault("userIp")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = nil)
  if valid_580359 != nil:
    section.add "userIp", valid_580359
  var valid_580360 = query.getOrDefault("maxResults")
  valid_580360 = validateParameter(valid_580360, JInt, required = false, default = nil)
  if valid_580360 != nil:
    section.add "maxResults", valid_580360
  var valid_580361 = query.getOrDefault("key")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "key", valid_580361
  var valid_580362 = query.getOrDefault("prettyPrint")
  valid_580362 = validateParameter(valid_580362, JBool, required = false,
                                 default = newJBool(true))
  if valid_580362 != nil:
    section.add "prettyPrint", valid_580362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580363: Call_ContentAccounttaxList_580350; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the tax settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_580363.validator(path, query, header, formData, body)
  let scheme = call_580363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580363.url(scheme.get, call_580363.host, call_580363.base,
                         call_580363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580363, url, valid)

proc call*(call_580364: Call_ContentAccounttaxList_580350; merchantId: string;
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
  var path_580365 = newJObject()
  var query_580366 = newJObject()
  add(query_580366, "fields", newJString(fields))
  add(query_580366, "pageToken", newJString(pageToken))
  add(query_580366, "quotaUser", newJString(quotaUser))
  add(query_580366, "alt", newJString(alt))
  add(query_580366, "oauth_token", newJString(oauthToken))
  add(query_580366, "userIp", newJString(userIp))
  add(query_580366, "maxResults", newJInt(maxResults))
  add(query_580366, "key", newJString(key))
  add(path_580365, "merchantId", newJString(merchantId))
  add(query_580366, "prettyPrint", newJBool(prettyPrint))
  result = call_580364.call(path_580365, query_580366, nil, nil, nil)

var contentAccounttaxList* = Call_ContentAccounttaxList_580350(
    name: "contentAccounttaxList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax",
    validator: validate_ContentAccounttaxList_580351, base: "/content/v2",
    url: url_ContentAccounttaxList_580352, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxUpdate_580383 = ref object of OpenApiRestCall_579421
proc url_ContentAccounttaxUpdate_580385(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccounttaxUpdate_580384(path: JsonNode; query: JsonNode;
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
  var valid_580386 = path.getOrDefault("accountId")
  valid_580386 = validateParameter(valid_580386, JString, required = true,
                                 default = nil)
  if valid_580386 != nil:
    section.add "accountId", valid_580386
  var valid_580387 = path.getOrDefault("merchantId")
  valid_580387 = validateParameter(valid_580387, JString, required = true,
                                 default = nil)
  if valid_580387 != nil:
    section.add "merchantId", valid_580387
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580388 = query.getOrDefault("fields")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "fields", valid_580388
  var valid_580389 = query.getOrDefault("quotaUser")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "quotaUser", valid_580389
  var valid_580390 = query.getOrDefault("alt")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = newJString("json"))
  if valid_580390 != nil:
    section.add "alt", valid_580390
  var valid_580391 = query.getOrDefault("dryRun")
  valid_580391 = validateParameter(valid_580391, JBool, required = false, default = nil)
  if valid_580391 != nil:
    section.add "dryRun", valid_580391
  var valid_580392 = query.getOrDefault("oauth_token")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = nil)
  if valid_580392 != nil:
    section.add "oauth_token", valid_580392
  var valid_580393 = query.getOrDefault("userIp")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = nil)
  if valid_580393 != nil:
    section.add "userIp", valid_580393
  var valid_580394 = query.getOrDefault("key")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = nil)
  if valid_580394 != nil:
    section.add "key", valid_580394
  var valid_580395 = query.getOrDefault("prettyPrint")
  valid_580395 = validateParameter(valid_580395, JBool, required = false,
                                 default = newJBool(true))
  if valid_580395 != nil:
    section.add "prettyPrint", valid_580395
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

proc call*(call_580397: Call_ContentAccounttaxUpdate_580383; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the tax settings of the account.
  ## 
  let valid = call_580397.validator(path, query, header, formData, body)
  let scheme = call_580397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580397.url(scheme.get, call_580397.host, call_580397.base,
                         call_580397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580397, url, valid)

proc call*(call_580398: Call_ContentAccounttaxUpdate_580383; accountId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; dryRun: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## contentAccounttaxUpdate
  ## Updates the tax settings of the account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
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
  var path_580399 = newJObject()
  var query_580400 = newJObject()
  var body_580401 = newJObject()
  add(query_580400, "fields", newJString(fields))
  add(query_580400, "quotaUser", newJString(quotaUser))
  add(query_580400, "alt", newJString(alt))
  add(query_580400, "dryRun", newJBool(dryRun))
  add(query_580400, "oauth_token", newJString(oauthToken))
  add(path_580399, "accountId", newJString(accountId))
  add(query_580400, "userIp", newJString(userIp))
  add(query_580400, "key", newJString(key))
  add(path_580399, "merchantId", newJString(merchantId))
  if body != nil:
    body_580401 = body
  add(query_580400, "prettyPrint", newJBool(prettyPrint))
  result = call_580398.call(path_580399, query_580400, nil, nil, body_580401)

var contentAccounttaxUpdate* = Call_ContentAccounttaxUpdate_580383(
    name: "contentAccounttaxUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax/{accountId}",
    validator: validate_ContentAccounttaxUpdate_580384, base: "/content/v2",
    url: url_ContentAccounttaxUpdate_580385, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxGet_580367 = ref object of OpenApiRestCall_579421
proc url_ContentAccounttaxGet_580369(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccounttaxGet_580368(path: JsonNode; query: JsonNode;
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
  var valid_580370 = path.getOrDefault("accountId")
  valid_580370 = validateParameter(valid_580370, JString, required = true,
                                 default = nil)
  if valid_580370 != nil:
    section.add "accountId", valid_580370
  var valid_580371 = path.getOrDefault("merchantId")
  valid_580371 = validateParameter(valid_580371, JString, required = true,
                                 default = nil)
  if valid_580371 != nil:
    section.add "merchantId", valid_580371
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
  var valid_580372 = query.getOrDefault("fields")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "fields", valid_580372
  var valid_580373 = query.getOrDefault("quotaUser")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = nil)
  if valid_580373 != nil:
    section.add "quotaUser", valid_580373
  var valid_580374 = query.getOrDefault("alt")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = newJString("json"))
  if valid_580374 != nil:
    section.add "alt", valid_580374
  var valid_580375 = query.getOrDefault("oauth_token")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = nil)
  if valid_580375 != nil:
    section.add "oauth_token", valid_580375
  var valid_580376 = query.getOrDefault("userIp")
  valid_580376 = validateParameter(valid_580376, JString, required = false,
                                 default = nil)
  if valid_580376 != nil:
    section.add "userIp", valid_580376
  var valid_580377 = query.getOrDefault("key")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = nil)
  if valid_580377 != nil:
    section.add "key", valid_580377
  var valid_580378 = query.getOrDefault("prettyPrint")
  valid_580378 = validateParameter(valid_580378, JBool, required = false,
                                 default = newJBool(true))
  if valid_580378 != nil:
    section.add "prettyPrint", valid_580378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580379: Call_ContentAccounttaxGet_580367; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the tax settings of the account.
  ## 
  let valid = call_580379.validator(path, query, header, formData, body)
  let scheme = call_580379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580379.url(scheme.get, call_580379.host, call_580379.base,
                         call_580379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580379, url, valid)

proc call*(call_580380: Call_ContentAccounttaxGet_580367; accountId: string;
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
  var path_580381 = newJObject()
  var query_580382 = newJObject()
  add(query_580382, "fields", newJString(fields))
  add(query_580382, "quotaUser", newJString(quotaUser))
  add(query_580382, "alt", newJString(alt))
  add(query_580382, "oauth_token", newJString(oauthToken))
  add(path_580381, "accountId", newJString(accountId))
  add(query_580382, "userIp", newJString(userIp))
  add(query_580382, "key", newJString(key))
  add(path_580381, "merchantId", newJString(merchantId))
  add(query_580382, "prettyPrint", newJBool(prettyPrint))
  result = call_580380.call(path_580381, query_580382, nil, nil, nil)

var contentAccounttaxGet* = Call_ContentAccounttaxGet_580367(
    name: "contentAccounttaxGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax/{accountId}",
    validator: validate_ContentAccounttaxGet_580368, base: "/content/v2",
    url: url_ContentAccounttaxGet_580369, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxPatch_580402 = ref object of OpenApiRestCall_579421
proc url_ContentAccounttaxPatch_580404(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccounttaxPatch_580403(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the tax settings of the account. This method supports patch semantics.
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
  var valid_580405 = path.getOrDefault("accountId")
  valid_580405 = validateParameter(valid_580405, JString, required = true,
                                 default = nil)
  if valid_580405 != nil:
    section.add "accountId", valid_580405
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
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
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
  var valid_580410 = query.getOrDefault("dryRun")
  valid_580410 = validateParameter(valid_580410, JBool, required = false, default = nil)
  if valid_580410 != nil:
    section.add "dryRun", valid_580410
  var valid_580411 = query.getOrDefault("oauth_token")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = nil)
  if valid_580411 != nil:
    section.add "oauth_token", valid_580411
  var valid_580412 = query.getOrDefault("userIp")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = nil)
  if valid_580412 != nil:
    section.add "userIp", valid_580412
  var valid_580413 = query.getOrDefault("key")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = nil)
  if valid_580413 != nil:
    section.add "key", valid_580413
  var valid_580414 = query.getOrDefault("prettyPrint")
  valid_580414 = validateParameter(valid_580414, JBool, required = false,
                                 default = newJBool(true))
  if valid_580414 != nil:
    section.add "prettyPrint", valid_580414
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

proc call*(call_580416: Call_ContentAccounttaxPatch_580402; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the tax settings of the account. This method supports patch semantics.
  ## 
  let valid = call_580416.validator(path, query, header, formData, body)
  let scheme = call_580416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580416.url(scheme.get, call_580416.host, call_580416.base,
                         call_580416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580416, url, valid)

proc call*(call_580417: Call_ContentAccounttaxPatch_580402; accountId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; dryRun: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## contentAccounttaxPatch
  ## Updates the tax settings of the account. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
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
  var path_580418 = newJObject()
  var query_580419 = newJObject()
  var body_580420 = newJObject()
  add(query_580419, "fields", newJString(fields))
  add(query_580419, "quotaUser", newJString(quotaUser))
  add(query_580419, "alt", newJString(alt))
  add(query_580419, "dryRun", newJBool(dryRun))
  add(query_580419, "oauth_token", newJString(oauthToken))
  add(path_580418, "accountId", newJString(accountId))
  add(query_580419, "userIp", newJString(userIp))
  add(query_580419, "key", newJString(key))
  add(path_580418, "merchantId", newJString(merchantId))
  if body != nil:
    body_580420 = body
  add(query_580419, "prettyPrint", newJBool(prettyPrint))
  result = call_580417.call(path_580418, query_580419, nil, nil, body_580420)

var contentAccounttaxPatch* = Call_ContentAccounttaxPatch_580402(
    name: "contentAccounttaxPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax/{accountId}",
    validator: validate_ContentAccounttaxPatch_580403, base: "/content/v2",
    url: url_ContentAccounttaxPatch_580404, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsInsert_580438 = ref object of OpenApiRestCall_579421
proc url_ContentDatafeedsInsert_580440(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsInsert_580439(path: JsonNode; query: JsonNode;
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
  var valid_580441 = path.getOrDefault("merchantId")
  valid_580441 = validateParameter(valid_580441, JString, required = true,
                                 default = nil)
  if valid_580441 != nil:
    section.add "merchantId", valid_580441
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580442 = query.getOrDefault("fields")
  valid_580442 = validateParameter(valid_580442, JString, required = false,
                                 default = nil)
  if valid_580442 != nil:
    section.add "fields", valid_580442
  var valid_580443 = query.getOrDefault("quotaUser")
  valid_580443 = validateParameter(valid_580443, JString, required = false,
                                 default = nil)
  if valid_580443 != nil:
    section.add "quotaUser", valid_580443
  var valid_580444 = query.getOrDefault("alt")
  valid_580444 = validateParameter(valid_580444, JString, required = false,
                                 default = newJString("json"))
  if valid_580444 != nil:
    section.add "alt", valid_580444
  var valid_580445 = query.getOrDefault("dryRun")
  valid_580445 = validateParameter(valid_580445, JBool, required = false, default = nil)
  if valid_580445 != nil:
    section.add "dryRun", valid_580445
  var valid_580446 = query.getOrDefault("oauth_token")
  valid_580446 = validateParameter(valid_580446, JString, required = false,
                                 default = nil)
  if valid_580446 != nil:
    section.add "oauth_token", valid_580446
  var valid_580447 = query.getOrDefault("userIp")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = nil)
  if valid_580447 != nil:
    section.add "userIp", valid_580447
  var valid_580448 = query.getOrDefault("key")
  valid_580448 = validateParameter(valid_580448, JString, required = false,
                                 default = nil)
  if valid_580448 != nil:
    section.add "key", valid_580448
  var valid_580449 = query.getOrDefault("prettyPrint")
  valid_580449 = validateParameter(valid_580449, JBool, required = false,
                                 default = newJBool(true))
  if valid_580449 != nil:
    section.add "prettyPrint", valid_580449
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

proc call*(call_580451: Call_ContentDatafeedsInsert_580438; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers a datafeed configuration with your Merchant Center account.
  ## 
  let valid = call_580451.validator(path, query, header, formData, body)
  let scheme = call_580451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580451.url(scheme.get, call_580451.host, call_580451.base,
                         call_580451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580451, url, valid)

proc call*(call_580452: Call_ContentDatafeedsInsert_580438; merchantId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          dryRun: bool = false; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentDatafeedsInsert
  ## Registers a datafeed configuration with your Merchant Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
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
  var path_580453 = newJObject()
  var query_580454 = newJObject()
  var body_580455 = newJObject()
  add(query_580454, "fields", newJString(fields))
  add(query_580454, "quotaUser", newJString(quotaUser))
  add(query_580454, "alt", newJString(alt))
  add(query_580454, "dryRun", newJBool(dryRun))
  add(query_580454, "oauth_token", newJString(oauthToken))
  add(query_580454, "userIp", newJString(userIp))
  add(query_580454, "key", newJString(key))
  add(path_580453, "merchantId", newJString(merchantId))
  if body != nil:
    body_580455 = body
  add(query_580454, "prettyPrint", newJBool(prettyPrint))
  result = call_580452.call(path_580453, query_580454, nil, nil, body_580455)

var contentDatafeedsInsert* = Call_ContentDatafeedsInsert_580438(
    name: "contentDatafeedsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds",
    validator: validate_ContentDatafeedsInsert_580439, base: "/content/v2",
    url: url_ContentDatafeedsInsert_580440, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsList_580421 = ref object of OpenApiRestCall_579421
proc url_ContentDatafeedsList_580423(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsList_580422(path: JsonNode; query: JsonNode;
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
  var valid_580424 = path.getOrDefault("merchantId")
  valid_580424 = validateParameter(valid_580424, JString, required = true,
                                 default = nil)
  if valid_580424 != nil:
    section.add "merchantId", valid_580424
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
  var valid_580425 = query.getOrDefault("fields")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = nil)
  if valid_580425 != nil:
    section.add "fields", valid_580425
  var valid_580426 = query.getOrDefault("pageToken")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = nil)
  if valid_580426 != nil:
    section.add "pageToken", valid_580426
  var valid_580427 = query.getOrDefault("quotaUser")
  valid_580427 = validateParameter(valid_580427, JString, required = false,
                                 default = nil)
  if valid_580427 != nil:
    section.add "quotaUser", valid_580427
  var valid_580428 = query.getOrDefault("alt")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = newJString("json"))
  if valid_580428 != nil:
    section.add "alt", valid_580428
  var valid_580429 = query.getOrDefault("oauth_token")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = nil)
  if valid_580429 != nil:
    section.add "oauth_token", valid_580429
  var valid_580430 = query.getOrDefault("userIp")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "userIp", valid_580430
  var valid_580431 = query.getOrDefault("maxResults")
  valid_580431 = validateParameter(valid_580431, JInt, required = false, default = nil)
  if valid_580431 != nil:
    section.add "maxResults", valid_580431
  var valid_580432 = query.getOrDefault("key")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "key", valid_580432
  var valid_580433 = query.getOrDefault("prettyPrint")
  valid_580433 = validateParameter(valid_580433, JBool, required = false,
                                 default = newJBool(true))
  if valid_580433 != nil:
    section.add "prettyPrint", valid_580433
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580434: Call_ContentDatafeedsList_580421; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the configurations for datafeeds in your Merchant Center account.
  ## 
  let valid = call_580434.validator(path, query, header, formData, body)
  let scheme = call_580434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580434.url(scheme.get, call_580434.host, call_580434.base,
                         call_580434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580434, url, valid)

proc call*(call_580435: Call_ContentDatafeedsList_580421; merchantId: string;
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
  var path_580436 = newJObject()
  var query_580437 = newJObject()
  add(query_580437, "fields", newJString(fields))
  add(query_580437, "pageToken", newJString(pageToken))
  add(query_580437, "quotaUser", newJString(quotaUser))
  add(query_580437, "alt", newJString(alt))
  add(query_580437, "oauth_token", newJString(oauthToken))
  add(query_580437, "userIp", newJString(userIp))
  add(query_580437, "maxResults", newJInt(maxResults))
  add(query_580437, "key", newJString(key))
  add(path_580436, "merchantId", newJString(merchantId))
  add(query_580437, "prettyPrint", newJBool(prettyPrint))
  result = call_580435.call(path_580436, query_580437, nil, nil, nil)

var contentDatafeedsList* = Call_ContentDatafeedsList_580421(
    name: "contentDatafeedsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds",
    validator: validate_ContentDatafeedsList_580422, base: "/content/v2",
    url: url_ContentDatafeedsList_580423, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsUpdate_580472 = ref object of OpenApiRestCall_579421
proc url_ContentDatafeedsUpdate_580474(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsUpdate_580473(path: JsonNode; query: JsonNode;
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
  var valid_580475 = path.getOrDefault("merchantId")
  valid_580475 = validateParameter(valid_580475, JString, required = true,
                                 default = nil)
  if valid_580475 != nil:
    section.add "merchantId", valid_580475
  var valid_580476 = path.getOrDefault("datafeedId")
  valid_580476 = validateParameter(valid_580476, JString, required = true,
                                 default = nil)
  if valid_580476 != nil:
    section.add "datafeedId", valid_580476
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580477 = query.getOrDefault("fields")
  valid_580477 = validateParameter(valid_580477, JString, required = false,
                                 default = nil)
  if valid_580477 != nil:
    section.add "fields", valid_580477
  var valid_580478 = query.getOrDefault("quotaUser")
  valid_580478 = validateParameter(valid_580478, JString, required = false,
                                 default = nil)
  if valid_580478 != nil:
    section.add "quotaUser", valid_580478
  var valid_580479 = query.getOrDefault("alt")
  valid_580479 = validateParameter(valid_580479, JString, required = false,
                                 default = newJString("json"))
  if valid_580479 != nil:
    section.add "alt", valid_580479
  var valid_580480 = query.getOrDefault("dryRun")
  valid_580480 = validateParameter(valid_580480, JBool, required = false, default = nil)
  if valid_580480 != nil:
    section.add "dryRun", valid_580480
  var valid_580481 = query.getOrDefault("oauth_token")
  valid_580481 = validateParameter(valid_580481, JString, required = false,
                                 default = nil)
  if valid_580481 != nil:
    section.add "oauth_token", valid_580481
  var valid_580482 = query.getOrDefault("userIp")
  valid_580482 = validateParameter(valid_580482, JString, required = false,
                                 default = nil)
  if valid_580482 != nil:
    section.add "userIp", valid_580482
  var valid_580483 = query.getOrDefault("key")
  valid_580483 = validateParameter(valid_580483, JString, required = false,
                                 default = nil)
  if valid_580483 != nil:
    section.add "key", valid_580483
  var valid_580484 = query.getOrDefault("prettyPrint")
  valid_580484 = validateParameter(valid_580484, JBool, required = false,
                                 default = newJBool(true))
  if valid_580484 != nil:
    section.add "prettyPrint", valid_580484
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

proc call*(call_580486: Call_ContentDatafeedsUpdate_580472; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a datafeed configuration of your Merchant Center account.
  ## 
  let valid = call_580486.validator(path, query, header, formData, body)
  let scheme = call_580486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580486.url(scheme.get, call_580486.host, call_580486.base,
                         call_580486.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580486, url, valid)

proc call*(call_580487: Call_ContentDatafeedsUpdate_580472; merchantId: string;
          datafeedId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; dryRun: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## contentDatafeedsUpdate
  ## Updates a datafeed configuration of your Merchant Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
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
  var path_580488 = newJObject()
  var query_580489 = newJObject()
  var body_580490 = newJObject()
  add(query_580489, "fields", newJString(fields))
  add(query_580489, "quotaUser", newJString(quotaUser))
  add(query_580489, "alt", newJString(alt))
  add(query_580489, "dryRun", newJBool(dryRun))
  add(query_580489, "oauth_token", newJString(oauthToken))
  add(query_580489, "userIp", newJString(userIp))
  add(query_580489, "key", newJString(key))
  add(path_580488, "merchantId", newJString(merchantId))
  if body != nil:
    body_580490 = body
  add(query_580489, "prettyPrint", newJBool(prettyPrint))
  add(path_580488, "datafeedId", newJString(datafeedId))
  result = call_580487.call(path_580488, query_580489, nil, nil, body_580490)

var contentDatafeedsUpdate* = Call_ContentDatafeedsUpdate_580472(
    name: "contentDatafeedsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsUpdate_580473, base: "/content/v2",
    url: url_ContentDatafeedsUpdate_580474, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsGet_580456 = ref object of OpenApiRestCall_579421
proc url_ContentDatafeedsGet_580458(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsGet_580457(path: JsonNode; query: JsonNode;
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
  var valid_580459 = path.getOrDefault("merchantId")
  valid_580459 = validateParameter(valid_580459, JString, required = true,
                                 default = nil)
  if valid_580459 != nil:
    section.add "merchantId", valid_580459
  var valid_580460 = path.getOrDefault("datafeedId")
  valid_580460 = validateParameter(valid_580460, JString, required = true,
                                 default = nil)
  if valid_580460 != nil:
    section.add "datafeedId", valid_580460
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
  var valid_580461 = query.getOrDefault("fields")
  valid_580461 = validateParameter(valid_580461, JString, required = false,
                                 default = nil)
  if valid_580461 != nil:
    section.add "fields", valid_580461
  var valid_580462 = query.getOrDefault("quotaUser")
  valid_580462 = validateParameter(valid_580462, JString, required = false,
                                 default = nil)
  if valid_580462 != nil:
    section.add "quotaUser", valid_580462
  var valid_580463 = query.getOrDefault("alt")
  valid_580463 = validateParameter(valid_580463, JString, required = false,
                                 default = newJString("json"))
  if valid_580463 != nil:
    section.add "alt", valid_580463
  var valid_580464 = query.getOrDefault("oauth_token")
  valid_580464 = validateParameter(valid_580464, JString, required = false,
                                 default = nil)
  if valid_580464 != nil:
    section.add "oauth_token", valid_580464
  var valid_580465 = query.getOrDefault("userIp")
  valid_580465 = validateParameter(valid_580465, JString, required = false,
                                 default = nil)
  if valid_580465 != nil:
    section.add "userIp", valid_580465
  var valid_580466 = query.getOrDefault("key")
  valid_580466 = validateParameter(valid_580466, JString, required = false,
                                 default = nil)
  if valid_580466 != nil:
    section.add "key", valid_580466
  var valid_580467 = query.getOrDefault("prettyPrint")
  valid_580467 = validateParameter(valid_580467, JBool, required = false,
                                 default = newJBool(true))
  if valid_580467 != nil:
    section.add "prettyPrint", valid_580467
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580468: Call_ContentDatafeedsGet_580456; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a datafeed configuration from your Merchant Center account.
  ## 
  let valid = call_580468.validator(path, query, header, formData, body)
  let scheme = call_580468.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580468.url(scheme.get, call_580468.host, call_580468.base,
                         call_580468.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580468, url, valid)

proc call*(call_580469: Call_ContentDatafeedsGet_580456; merchantId: string;
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
  var path_580470 = newJObject()
  var query_580471 = newJObject()
  add(query_580471, "fields", newJString(fields))
  add(query_580471, "quotaUser", newJString(quotaUser))
  add(query_580471, "alt", newJString(alt))
  add(query_580471, "oauth_token", newJString(oauthToken))
  add(query_580471, "userIp", newJString(userIp))
  add(query_580471, "key", newJString(key))
  add(path_580470, "merchantId", newJString(merchantId))
  add(query_580471, "prettyPrint", newJBool(prettyPrint))
  add(path_580470, "datafeedId", newJString(datafeedId))
  result = call_580469.call(path_580470, query_580471, nil, nil, nil)

var contentDatafeedsGet* = Call_ContentDatafeedsGet_580456(
    name: "contentDatafeedsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsGet_580457, base: "/content/v2",
    url: url_ContentDatafeedsGet_580458, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsPatch_580508 = ref object of OpenApiRestCall_579421
proc url_ContentDatafeedsPatch_580510(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsPatch_580509(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a datafeed configuration of your Merchant Center account. This method supports patch semantics.
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
  var valid_580511 = path.getOrDefault("merchantId")
  valid_580511 = validateParameter(valid_580511, JString, required = true,
                                 default = nil)
  if valid_580511 != nil:
    section.add "merchantId", valid_580511
  var valid_580512 = path.getOrDefault("datafeedId")
  valid_580512 = validateParameter(valid_580512, JString, required = true,
                                 default = nil)
  if valid_580512 != nil:
    section.add "datafeedId", valid_580512
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580513 = query.getOrDefault("fields")
  valid_580513 = validateParameter(valid_580513, JString, required = false,
                                 default = nil)
  if valid_580513 != nil:
    section.add "fields", valid_580513
  var valid_580514 = query.getOrDefault("quotaUser")
  valid_580514 = validateParameter(valid_580514, JString, required = false,
                                 default = nil)
  if valid_580514 != nil:
    section.add "quotaUser", valid_580514
  var valid_580515 = query.getOrDefault("alt")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = newJString("json"))
  if valid_580515 != nil:
    section.add "alt", valid_580515
  var valid_580516 = query.getOrDefault("dryRun")
  valid_580516 = validateParameter(valid_580516, JBool, required = false, default = nil)
  if valid_580516 != nil:
    section.add "dryRun", valid_580516
  var valid_580517 = query.getOrDefault("oauth_token")
  valid_580517 = validateParameter(valid_580517, JString, required = false,
                                 default = nil)
  if valid_580517 != nil:
    section.add "oauth_token", valid_580517
  var valid_580518 = query.getOrDefault("userIp")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = nil)
  if valid_580518 != nil:
    section.add "userIp", valid_580518
  var valid_580519 = query.getOrDefault("key")
  valid_580519 = validateParameter(valid_580519, JString, required = false,
                                 default = nil)
  if valid_580519 != nil:
    section.add "key", valid_580519
  var valid_580520 = query.getOrDefault("prettyPrint")
  valid_580520 = validateParameter(valid_580520, JBool, required = false,
                                 default = newJBool(true))
  if valid_580520 != nil:
    section.add "prettyPrint", valid_580520
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

proc call*(call_580522: Call_ContentDatafeedsPatch_580508; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a datafeed configuration of your Merchant Center account. This method supports patch semantics.
  ## 
  let valid = call_580522.validator(path, query, header, formData, body)
  let scheme = call_580522.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580522.url(scheme.get, call_580522.host, call_580522.base,
                         call_580522.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580522, url, valid)

proc call*(call_580523: Call_ContentDatafeedsPatch_580508; merchantId: string;
          datafeedId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; dryRun: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## contentDatafeedsPatch
  ## Updates a datafeed configuration of your Merchant Center account. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
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
  var path_580524 = newJObject()
  var query_580525 = newJObject()
  var body_580526 = newJObject()
  add(query_580525, "fields", newJString(fields))
  add(query_580525, "quotaUser", newJString(quotaUser))
  add(query_580525, "alt", newJString(alt))
  add(query_580525, "dryRun", newJBool(dryRun))
  add(query_580525, "oauth_token", newJString(oauthToken))
  add(query_580525, "userIp", newJString(userIp))
  add(query_580525, "key", newJString(key))
  add(path_580524, "merchantId", newJString(merchantId))
  if body != nil:
    body_580526 = body
  add(query_580525, "prettyPrint", newJBool(prettyPrint))
  add(path_580524, "datafeedId", newJString(datafeedId))
  result = call_580523.call(path_580524, query_580525, nil, nil, body_580526)

var contentDatafeedsPatch* = Call_ContentDatafeedsPatch_580508(
    name: "contentDatafeedsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsPatch_580509, base: "/content/v2",
    url: url_ContentDatafeedsPatch_580510, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsDelete_580491 = ref object of OpenApiRestCall_579421
proc url_ContentDatafeedsDelete_580493(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsDelete_580492(path: JsonNode; query: JsonNode;
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
  var valid_580494 = path.getOrDefault("merchantId")
  valid_580494 = validateParameter(valid_580494, JString, required = true,
                                 default = nil)
  if valid_580494 != nil:
    section.add "merchantId", valid_580494
  var valid_580495 = path.getOrDefault("datafeedId")
  valid_580495 = validateParameter(valid_580495, JString, required = true,
                                 default = nil)
  if valid_580495 != nil:
    section.add "datafeedId", valid_580495
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580496 = query.getOrDefault("fields")
  valid_580496 = validateParameter(valid_580496, JString, required = false,
                                 default = nil)
  if valid_580496 != nil:
    section.add "fields", valid_580496
  var valid_580497 = query.getOrDefault("quotaUser")
  valid_580497 = validateParameter(valid_580497, JString, required = false,
                                 default = nil)
  if valid_580497 != nil:
    section.add "quotaUser", valid_580497
  var valid_580498 = query.getOrDefault("alt")
  valid_580498 = validateParameter(valid_580498, JString, required = false,
                                 default = newJString("json"))
  if valid_580498 != nil:
    section.add "alt", valid_580498
  var valid_580499 = query.getOrDefault("dryRun")
  valid_580499 = validateParameter(valid_580499, JBool, required = false, default = nil)
  if valid_580499 != nil:
    section.add "dryRun", valid_580499
  var valid_580500 = query.getOrDefault("oauth_token")
  valid_580500 = validateParameter(valid_580500, JString, required = false,
                                 default = nil)
  if valid_580500 != nil:
    section.add "oauth_token", valid_580500
  var valid_580501 = query.getOrDefault("userIp")
  valid_580501 = validateParameter(valid_580501, JString, required = false,
                                 default = nil)
  if valid_580501 != nil:
    section.add "userIp", valid_580501
  var valid_580502 = query.getOrDefault("key")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = nil)
  if valid_580502 != nil:
    section.add "key", valid_580502
  var valid_580503 = query.getOrDefault("prettyPrint")
  valid_580503 = validateParameter(valid_580503, JBool, required = false,
                                 default = newJBool(true))
  if valid_580503 != nil:
    section.add "prettyPrint", valid_580503
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580504: Call_ContentDatafeedsDelete_580491; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a datafeed configuration from your Merchant Center account.
  ## 
  let valid = call_580504.validator(path, query, header, formData, body)
  let scheme = call_580504.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580504.url(scheme.get, call_580504.host, call_580504.base,
                         call_580504.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580504, url, valid)

proc call*(call_580505: Call_ContentDatafeedsDelete_580491; merchantId: string;
          datafeedId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; dryRun: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentDatafeedsDelete
  ## Deletes a datafeed configuration from your Merchant Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
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
  var path_580506 = newJObject()
  var query_580507 = newJObject()
  add(query_580507, "fields", newJString(fields))
  add(query_580507, "quotaUser", newJString(quotaUser))
  add(query_580507, "alt", newJString(alt))
  add(query_580507, "dryRun", newJBool(dryRun))
  add(query_580507, "oauth_token", newJString(oauthToken))
  add(query_580507, "userIp", newJString(userIp))
  add(query_580507, "key", newJString(key))
  add(path_580506, "merchantId", newJString(merchantId))
  add(query_580507, "prettyPrint", newJBool(prettyPrint))
  add(path_580506, "datafeedId", newJString(datafeedId))
  result = call_580505.call(path_580506, query_580507, nil, nil, nil)

var contentDatafeedsDelete* = Call_ContentDatafeedsDelete_580491(
    name: "contentDatafeedsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsDelete_580492, base: "/content/v2",
    url: url_ContentDatafeedsDelete_580493, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsFetchnow_580527 = ref object of OpenApiRestCall_579421
proc url_ContentDatafeedsFetchnow_580529(protocol: Scheme; host: string;
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

proc validate_ContentDatafeedsFetchnow_580528(path: JsonNode; query: JsonNode;
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
  var valid_580530 = path.getOrDefault("merchantId")
  valid_580530 = validateParameter(valid_580530, JString, required = true,
                                 default = nil)
  if valid_580530 != nil:
    section.add "merchantId", valid_580530
  var valid_580531 = path.getOrDefault("datafeedId")
  valid_580531 = validateParameter(valid_580531, JString, required = true,
                                 default = nil)
  if valid_580531 != nil:
    section.add "datafeedId", valid_580531
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580532 = query.getOrDefault("fields")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = nil)
  if valid_580532 != nil:
    section.add "fields", valid_580532
  var valid_580533 = query.getOrDefault("quotaUser")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = nil)
  if valid_580533 != nil:
    section.add "quotaUser", valid_580533
  var valid_580534 = query.getOrDefault("alt")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = newJString("json"))
  if valid_580534 != nil:
    section.add "alt", valid_580534
  var valid_580535 = query.getOrDefault("dryRun")
  valid_580535 = validateParameter(valid_580535, JBool, required = false, default = nil)
  if valid_580535 != nil:
    section.add "dryRun", valid_580535
  var valid_580536 = query.getOrDefault("oauth_token")
  valid_580536 = validateParameter(valid_580536, JString, required = false,
                                 default = nil)
  if valid_580536 != nil:
    section.add "oauth_token", valid_580536
  var valid_580537 = query.getOrDefault("userIp")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = nil)
  if valid_580537 != nil:
    section.add "userIp", valid_580537
  var valid_580538 = query.getOrDefault("key")
  valid_580538 = validateParameter(valid_580538, JString, required = false,
                                 default = nil)
  if valid_580538 != nil:
    section.add "key", valid_580538
  var valid_580539 = query.getOrDefault("prettyPrint")
  valid_580539 = validateParameter(valid_580539, JBool, required = false,
                                 default = newJBool(true))
  if valid_580539 != nil:
    section.add "prettyPrint", valid_580539
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580540: Call_ContentDatafeedsFetchnow_580527; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Invokes a fetch for the datafeed in your Merchant Center account.
  ## 
  let valid = call_580540.validator(path, query, header, formData, body)
  let scheme = call_580540.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580540.url(scheme.get, call_580540.host, call_580540.base,
                         call_580540.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580540, url, valid)

proc call*(call_580541: Call_ContentDatafeedsFetchnow_580527; merchantId: string;
          datafeedId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; dryRun: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentDatafeedsFetchnow
  ## Invokes a fetch for the datafeed in your Merchant Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
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
  var path_580542 = newJObject()
  var query_580543 = newJObject()
  add(query_580543, "fields", newJString(fields))
  add(query_580543, "quotaUser", newJString(quotaUser))
  add(query_580543, "alt", newJString(alt))
  add(query_580543, "dryRun", newJBool(dryRun))
  add(query_580543, "oauth_token", newJString(oauthToken))
  add(query_580543, "userIp", newJString(userIp))
  add(query_580543, "key", newJString(key))
  add(path_580542, "merchantId", newJString(merchantId))
  add(query_580543, "prettyPrint", newJBool(prettyPrint))
  add(path_580542, "datafeedId", newJString(datafeedId))
  result = call_580541.call(path_580542, query_580543, nil, nil, nil)

var contentDatafeedsFetchnow* = Call_ContentDatafeedsFetchnow_580527(
    name: "contentDatafeedsFetchnow", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/datafeeds/{datafeedId}/fetchNow",
    validator: validate_ContentDatafeedsFetchnow_580528, base: "/content/v2",
    url: url_ContentDatafeedsFetchnow_580529, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesList_580544 = ref object of OpenApiRestCall_579421
proc url_ContentDatafeedstatusesList_580546(protocol: Scheme; host: string;
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

proc validate_ContentDatafeedstatusesList_580545(path: JsonNode; query: JsonNode;
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
  var valid_580547 = path.getOrDefault("merchantId")
  valid_580547 = validateParameter(valid_580547, JString, required = true,
                                 default = nil)
  if valid_580547 != nil:
    section.add "merchantId", valid_580547
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
  var valid_580548 = query.getOrDefault("fields")
  valid_580548 = validateParameter(valid_580548, JString, required = false,
                                 default = nil)
  if valid_580548 != nil:
    section.add "fields", valid_580548
  var valid_580549 = query.getOrDefault("pageToken")
  valid_580549 = validateParameter(valid_580549, JString, required = false,
                                 default = nil)
  if valid_580549 != nil:
    section.add "pageToken", valid_580549
  var valid_580550 = query.getOrDefault("quotaUser")
  valid_580550 = validateParameter(valid_580550, JString, required = false,
                                 default = nil)
  if valid_580550 != nil:
    section.add "quotaUser", valid_580550
  var valid_580551 = query.getOrDefault("alt")
  valid_580551 = validateParameter(valid_580551, JString, required = false,
                                 default = newJString("json"))
  if valid_580551 != nil:
    section.add "alt", valid_580551
  var valid_580552 = query.getOrDefault("oauth_token")
  valid_580552 = validateParameter(valid_580552, JString, required = false,
                                 default = nil)
  if valid_580552 != nil:
    section.add "oauth_token", valid_580552
  var valid_580553 = query.getOrDefault("userIp")
  valid_580553 = validateParameter(valid_580553, JString, required = false,
                                 default = nil)
  if valid_580553 != nil:
    section.add "userIp", valid_580553
  var valid_580554 = query.getOrDefault("maxResults")
  valid_580554 = validateParameter(valid_580554, JInt, required = false, default = nil)
  if valid_580554 != nil:
    section.add "maxResults", valid_580554
  var valid_580555 = query.getOrDefault("key")
  valid_580555 = validateParameter(valid_580555, JString, required = false,
                                 default = nil)
  if valid_580555 != nil:
    section.add "key", valid_580555
  var valid_580556 = query.getOrDefault("prettyPrint")
  valid_580556 = validateParameter(valid_580556, JBool, required = false,
                                 default = newJBool(true))
  if valid_580556 != nil:
    section.add "prettyPrint", valid_580556
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580557: Call_ContentDatafeedstatusesList_580544; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the datafeeds in your Merchant Center account.
  ## 
  let valid = call_580557.validator(path, query, header, formData, body)
  let scheme = call_580557.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580557.url(scheme.get, call_580557.host, call_580557.base,
                         call_580557.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580557, url, valid)

proc call*(call_580558: Call_ContentDatafeedstatusesList_580544;
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
  var path_580559 = newJObject()
  var query_580560 = newJObject()
  add(query_580560, "fields", newJString(fields))
  add(query_580560, "pageToken", newJString(pageToken))
  add(query_580560, "quotaUser", newJString(quotaUser))
  add(query_580560, "alt", newJString(alt))
  add(query_580560, "oauth_token", newJString(oauthToken))
  add(query_580560, "userIp", newJString(userIp))
  add(query_580560, "maxResults", newJInt(maxResults))
  add(query_580560, "key", newJString(key))
  add(path_580559, "merchantId", newJString(merchantId))
  add(query_580560, "prettyPrint", newJBool(prettyPrint))
  result = call_580558.call(path_580559, query_580560, nil, nil, nil)

var contentDatafeedstatusesList* = Call_ContentDatafeedstatusesList_580544(
    name: "contentDatafeedstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeedstatuses",
    validator: validate_ContentDatafeedstatusesList_580545, base: "/content/v2",
    url: url_ContentDatafeedstatusesList_580546, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesGet_580561 = ref object of OpenApiRestCall_579421
proc url_ContentDatafeedstatusesGet_580563(protocol: Scheme; host: string;
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

proc validate_ContentDatafeedstatusesGet_580562(path: JsonNode; query: JsonNode;
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
  var valid_580564 = path.getOrDefault("merchantId")
  valid_580564 = validateParameter(valid_580564, JString, required = true,
                                 default = nil)
  if valid_580564 != nil:
    section.add "merchantId", valid_580564
  var valid_580565 = path.getOrDefault("datafeedId")
  valid_580565 = validateParameter(valid_580565, JString, required = true,
                                 default = nil)
  if valid_580565 != nil:
    section.add "datafeedId", valid_580565
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
  var valid_580566 = query.getOrDefault("fields")
  valid_580566 = validateParameter(valid_580566, JString, required = false,
                                 default = nil)
  if valid_580566 != nil:
    section.add "fields", valid_580566
  var valid_580567 = query.getOrDefault("country")
  valid_580567 = validateParameter(valid_580567, JString, required = false,
                                 default = nil)
  if valid_580567 != nil:
    section.add "country", valid_580567
  var valid_580568 = query.getOrDefault("quotaUser")
  valid_580568 = validateParameter(valid_580568, JString, required = false,
                                 default = nil)
  if valid_580568 != nil:
    section.add "quotaUser", valid_580568
  var valid_580569 = query.getOrDefault("alt")
  valid_580569 = validateParameter(valid_580569, JString, required = false,
                                 default = newJString("json"))
  if valid_580569 != nil:
    section.add "alt", valid_580569
  var valid_580570 = query.getOrDefault("language")
  valid_580570 = validateParameter(valid_580570, JString, required = false,
                                 default = nil)
  if valid_580570 != nil:
    section.add "language", valid_580570
  var valid_580571 = query.getOrDefault("oauth_token")
  valid_580571 = validateParameter(valid_580571, JString, required = false,
                                 default = nil)
  if valid_580571 != nil:
    section.add "oauth_token", valid_580571
  var valid_580572 = query.getOrDefault("userIp")
  valid_580572 = validateParameter(valid_580572, JString, required = false,
                                 default = nil)
  if valid_580572 != nil:
    section.add "userIp", valid_580572
  var valid_580573 = query.getOrDefault("key")
  valid_580573 = validateParameter(valid_580573, JString, required = false,
                                 default = nil)
  if valid_580573 != nil:
    section.add "key", valid_580573
  var valid_580574 = query.getOrDefault("prettyPrint")
  valid_580574 = validateParameter(valid_580574, JBool, required = false,
                                 default = newJBool(true))
  if valid_580574 != nil:
    section.add "prettyPrint", valid_580574
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580575: Call_ContentDatafeedstatusesGet_580561; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the status of a datafeed from your Merchant Center account.
  ## 
  let valid = call_580575.validator(path, query, header, formData, body)
  let scheme = call_580575.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580575.url(scheme.get, call_580575.host, call_580575.base,
                         call_580575.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580575, url, valid)

proc call*(call_580576: Call_ContentDatafeedstatusesGet_580561; merchantId: string;
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
  var path_580577 = newJObject()
  var query_580578 = newJObject()
  add(query_580578, "fields", newJString(fields))
  add(query_580578, "country", newJString(country))
  add(query_580578, "quotaUser", newJString(quotaUser))
  add(query_580578, "alt", newJString(alt))
  add(query_580578, "language", newJString(language))
  add(query_580578, "oauth_token", newJString(oauthToken))
  add(query_580578, "userIp", newJString(userIp))
  add(query_580578, "key", newJString(key))
  add(path_580577, "merchantId", newJString(merchantId))
  add(query_580578, "prettyPrint", newJBool(prettyPrint))
  add(path_580577, "datafeedId", newJString(datafeedId))
  result = call_580576.call(path_580577, query_580578, nil, nil, nil)

var contentDatafeedstatusesGet* = Call_ContentDatafeedstatusesGet_580561(
    name: "contentDatafeedstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/datafeedstatuses/{datafeedId}",
    validator: validate_ContentDatafeedstatusesGet_580562, base: "/content/v2",
    url: url_ContentDatafeedstatusesGet_580563, schemes: {Scheme.Https})
type
  Call_ContentInventorySet_580579 = ref object of OpenApiRestCall_579421
proc url_ContentInventorySet_580581(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "merchantId" in path, "`merchantId` is a required path parameter"
  assert "storeCode" in path, "`storeCode` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "merchantId"),
               (kind: ConstantSegment, value: "/inventory/"),
               (kind: VariableSegment, value: "storeCode"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentInventorySet_580580(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates price and availability of a product in your Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   storeCode: JString (required)
  ##            : The code of the store for which to update price and availability. Use online to update price and availability of an online product.
  ##   merchantId: JString (required)
  ##             : The ID of the account that contains the product. This account cannot be a multi-client account.
  ##   productId: JString (required)
  ##            : The REST ID of the product for which to update price and availability.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `storeCode` field"
  var valid_580582 = path.getOrDefault("storeCode")
  valid_580582 = validateParameter(valid_580582, JString, required = true,
                                 default = nil)
  if valid_580582 != nil:
    section.add "storeCode", valid_580582
  var valid_580583 = path.getOrDefault("merchantId")
  valid_580583 = validateParameter(valid_580583, JString, required = true,
                                 default = nil)
  if valid_580583 != nil:
    section.add "merchantId", valid_580583
  var valid_580584 = path.getOrDefault("productId")
  valid_580584 = validateParameter(valid_580584, JString, required = true,
                                 default = nil)
  if valid_580584 != nil:
    section.add "productId", valid_580584
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580585 = query.getOrDefault("fields")
  valid_580585 = validateParameter(valid_580585, JString, required = false,
                                 default = nil)
  if valid_580585 != nil:
    section.add "fields", valid_580585
  var valid_580586 = query.getOrDefault("quotaUser")
  valid_580586 = validateParameter(valid_580586, JString, required = false,
                                 default = nil)
  if valid_580586 != nil:
    section.add "quotaUser", valid_580586
  var valid_580587 = query.getOrDefault("alt")
  valid_580587 = validateParameter(valid_580587, JString, required = false,
                                 default = newJString("json"))
  if valid_580587 != nil:
    section.add "alt", valid_580587
  var valid_580588 = query.getOrDefault("dryRun")
  valid_580588 = validateParameter(valid_580588, JBool, required = false, default = nil)
  if valid_580588 != nil:
    section.add "dryRun", valid_580588
  var valid_580589 = query.getOrDefault("oauth_token")
  valid_580589 = validateParameter(valid_580589, JString, required = false,
                                 default = nil)
  if valid_580589 != nil:
    section.add "oauth_token", valid_580589
  var valid_580590 = query.getOrDefault("userIp")
  valid_580590 = validateParameter(valid_580590, JString, required = false,
                                 default = nil)
  if valid_580590 != nil:
    section.add "userIp", valid_580590
  var valid_580591 = query.getOrDefault("key")
  valid_580591 = validateParameter(valid_580591, JString, required = false,
                                 default = nil)
  if valid_580591 != nil:
    section.add "key", valid_580591
  var valid_580592 = query.getOrDefault("prettyPrint")
  valid_580592 = validateParameter(valid_580592, JBool, required = false,
                                 default = newJBool(true))
  if valid_580592 != nil:
    section.add "prettyPrint", valid_580592
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

proc call*(call_580594: Call_ContentInventorySet_580579; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates price and availability of a product in your Merchant Center account.
  ## 
  let valid = call_580594.validator(path, query, header, formData, body)
  let scheme = call_580594.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580594.url(scheme.get, call_580594.host, call_580594.base,
                         call_580594.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580594, url, valid)

proc call*(call_580595: Call_ContentInventorySet_580579; storeCode: string;
          merchantId: string; productId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; dryRun: bool = false;
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentInventorySet
  ## Updates price and availability of a product in your Merchant Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   storeCode: string (required)
  ##            : The code of the store for which to update price and availability. Use online to update price and availability of an online product.
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
  ##            : The REST ID of the product for which to update price and availability.
  var path_580596 = newJObject()
  var query_580597 = newJObject()
  var body_580598 = newJObject()
  add(query_580597, "fields", newJString(fields))
  add(query_580597, "quotaUser", newJString(quotaUser))
  add(query_580597, "alt", newJString(alt))
  add(query_580597, "dryRun", newJBool(dryRun))
  add(query_580597, "oauth_token", newJString(oauthToken))
  add(path_580596, "storeCode", newJString(storeCode))
  add(query_580597, "userIp", newJString(userIp))
  add(query_580597, "key", newJString(key))
  add(path_580596, "merchantId", newJString(merchantId))
  if body != nil:
    body_580598 = body
  add(query_580597, "prettyPrint", newJBool(prettyPrint))
  add(path_580596, "productId", newJString(productId))
  result = call_580595.call(path_580596, query_580597, nil, nil, body_580598)

var contentInventorySet* = Call_ContentInventorySet_580579(
    name: "contentInventorySet", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/inventory/{storeCode}/products/{productId}",
    validator: validate_ContentInventorySet_580580, base: "/content/v2",
    url: url_ContentInventorySet_580581, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsList_580599 = ref object of OpenApiRestCall_579421
proc url_ContentLiasettingsList_580601(protocol: Scheme; host: string; base: string;
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

proc validate_ContentLiasettingsList_580600(path: JsonNode; query: JsonNode;
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
  var valid_580602 = path.getOrDefault("merchantId")
  valid_580602 = validateParameter(valid_580602, JString, required = true,
                                 default = nil)
  if valid_580602 != nil:
    section.add "merchantId", valid_580602
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
  var valid_580603 = query.getOrDefault("fields")
  valid_580603 = validateParameter(valid_580603, JString, required = false,
                                 default = nil)
  if valid_580603 != nil:
    section.add "fields", valid_580603
  var valid_580604 = query.getOrDefault("pageToken")
  valid_580604 = validateParameter(valid_580604, JString, required = false,
                                 default = nil)
  if valid_580604 != nil:
    section.add "pageToken", valid_580604
  var valid_580605 = query.getOrDefault("quotaUser")
  valid_580605 = validateParameter(valid_580605, JString, required = false,
                                 default = nil)
  if valid_580605 != nil:
    section.add "quotaUser", valid_580605
  var valid_580606 = query.getOrDefault("alt")
  valid_580606 = validateParameter(valid_580606, JString, required = false,
                                 default = newJString("json"))
  if valid_580606 != nil:
    section.add "alt", valid_580606
  var valid_580607 = query.getOrDefault("oauth_token")
  valid_580607 = validateParameter(valid_580607, JString, required = false,
                                 default = nil)
  if valid_580607 != nil:
    section.add "oauth_token", valid_580607
  var valid_580608 = query.getOrDefault("userIp")
  valid_580608 = validateParameter(valid_580608, JString, required = false,
                                 default = nil)
  if valid_580608 != nil:
    section.add "userIp", valid_580608
  var valid_580609 = query.getOrDefault("maxResults")
  valid_580609 = validateParameter(valid_580609, JInt, required = false, default = nil)
  if valid_580609 != nil:
    section.add "maxResults", valid_580609
  var valid_580610 = query.getOrDefault("key")
  valid_580610 = validateParameter(valid_580610, JString, required = false,
                                 default = nil)
  if valid_580610 != nil:
    section.add "key", valid_580610
  var valid_580611 = query.getOrDefault("prettyPrint")
  valid_580611 = validateParameter(valid_580611, JBool, required = false,
                                 default = newJBool(true))
  if valid_580611 != nil:
    section.add "prettyPrint", valid_580611
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580612: Call_ContentLiasettingsList_580599; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the LIA settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_580612.validator(path, query, header, formData, body)
  let scheme = call_580612.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580612.url(scheme.get, call_580612.host, call_580612.base,
                         call_580612.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580612, url, valid)

proc call*(call_580613: Call_ContentLiasettingsList_580599; merchantId: string;
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
  var path_580614 = newJObject()
  var query_580615 = newJObject()
  add(query_580615, "fields", newJString(fields))
  add(query_580615, "pageToken", newJString(pageToken))
  add(query_580615, "quotaUser", newJString(quotaUser))
  add(query_580615, "alt", newJString(alt))
  add(query_580615, "oauth_token", newJString(oauthToken))
  add(query_580615, "userIp", newJString(userIp))
  add(query_580615, "maxResults", newJInt(maxResults))
  add(query_580615, "key", newJString(key))
  add(path_580614, "merchantId", newJString(merchantId))
  add(query_580615, "prettyPrint", newJBool(prettyPrint))
  result = call_580613.call(path_580614, query_580615, nil, nil, nil)

var contentLiasettingsList* = Call_ContentLiasettingsList_580599(
    name: "contentLiasettingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings",
    validator: validate_ContentLiasettingsList_580600, base: "/content/v2",
    url: url_ContentLiasettingsList_580601, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsUpdate_580632 = ref object of OpenApiRestCall_579421
proc url_ContentLiasettingsUpdate_580634(protocol: Scheme; host: string;
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

proc validate_ContentLiasettingsUpdate_580633(path: JsonNode; query: JsonNode;
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
  var valid_580635 = path.getOrDefault("accountId")
  valid_580635 = validateParameter(valid_580635, JString, required = true,
                                 default = nil)
  if valid_580635 != nil:
    section.add "accountId", valid_580635
  var valid_580636 = path.getOrDefault("merchantId")
  valid_580636 = validateParameter(valid_580636, JString, required = true,
                                 default = nil)
  if valid_580636 != nil:
    section.add "merchantId", valid_580636
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580637 = query.getOrDefault("fields")
  valid_580637 = validateParameter(valid_580637, JString, required = false,
                                 default = nil)
  if valid_580637 != nil:
    section.add "fields", valid_580637
  var valid_580638 = query.getOrDefault("quotaUser")
  valid_580638 = validateParameter(valid_580638, JString, required = false,
                                 default = nil)
  if valid_580638 != nil:
    section.add "quotaUser", valid_580638
  var valid_580639 = query.getOrDefault("alt")
  valid_580639 = validateParameter(valid_580639, JString, required = false,
                                 default = newJString("json"))
  if valid_580639 != nil:
    section.add "alt", valid_580639
  var valid_580640 = query.getOrDefault("dryRun")
  valid_580640 = validateParameter(valid_580640, JBool, required = false, default = nil)
  if valid_580640 != nil:
    section.add "dryRun", valid_580640
  var valid_580641 = query.getOrDefault("oauth_token")
  valid_580641 = validateParameter(valid_580641, JString, required = false,
                                 default = nil)
  if valid_580641 != nil:
    section.add "oauth_token", valid_580641
  var valid_580642 = query.getOrDefault("userIp")
  valid_580642 = validateParameter(valid_580642, JString, required = false,
                                 default = nil)
  if valid_580642 != nil:
    section.add "userIp", valid_580642
  var valid_580643 = query.getOrDefault("key")
  valid_580643 = validateParameter(valid_580643, JString, required = false,
                                 default = nil)
  if valid_580643 != nil:
    section.add "key", valid_580643
  var valid_580644 = query.getOrDefault("prettyPrint")
  valid_580644 = validateParameter(valid_580644, JBool, required = false,
                                 default = newJBool(true))
  if valid_580644 != nil:
    section.add "prettyPrint", valid_580644
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

proc call*(call_580646: Call_ContentLiasettingsUpdate_580632; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the LIA settings of the account.
  ## 
  let valid = call_580646.validator(path, query, header, formData, body)
  let scheme = call_580646.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580646.url(scheme.get, call_580646.host, call_580646.base,
                         call_580646.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580646, url, valid)

proc call*(call_580647: Call_ContentLiasettingsUpdate_580632; accountId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; dryRun: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## contentLiasettingsUpdate
  ## Updates the LIA settings of the account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
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
  var path_580648 = newJObject()
  var query_580649 = newJObject()
  var body_580650 = newJObject()
  add(query_580649, "fields", newJString(fields))
  add(query_580649, "quotaUser", newJString(quotaUser))
  add(query_580649, "alt", newJString(alt))
  add(query_580649, "dryRun", newJBool(dryRun))
  add(query_580649, "oauth_token", newJString(oauthToken))
  add(path_580648, "accountId", newJString(accountId))
  add(query_580649, "userIp", newJString(userIp))
  add(query_580649, "key", newJString(key))
  add(path_580648, "merchantId", newJString(merchantId))
  if body != nil:
    body_580650 = body
  add(query_580649, "prettyPrint", newJBool(prettyPrint))
  result = call_580647.call(path_580648, query_580649, nil, nil, body_580650)

var contentLiasettingsUpdate* = Call_ContentLiasettingsUpdate_580632(
    name: "contentLiasettingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}",
    validator: validate_ContentLiasettingsUpdate_580633, base: "/content/v2",
    url: url_ContentLiasettingsUpdate_580634, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsGet_580616 = ref object of OpenApiRestCall_579421
proc url_ContentLiasettingsGet_580618(protocol: Scheme; host: string; base: string;
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

proc validate_ContentLiasettingsGet_580617(path: JsonNode; query: JsonNode;
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
  var valid_580619 = path.getOrDefault("accountId")
  valid_580619 = validateParameter(valid_580619, JString, required = true,
                                 default = nil)
  if valid_580619 != nil:
    section.add "accountId", valid_580619
  var valid_580620 = path.getOrDefault("merchantId")
  valid_580620 = validateParameter(valid_580620, JString, required = true,
                                 default = nil)
  if valid_580620 != nil:
    section.add "merchantId", valid_580620
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
  var valid_580621 = query.getOrDefault("fields")
  valid_580621 = validateParameter(valid_580621, JString, required = false,
                                 default = nil)
  if valid_580621 != nil:
    section.add "fields", valid_580621
  var valid_580622 = query.getOrDefault("quotaUser")
  valid_580622 = validateParameter(valid_580622, JString, required = false,
                                 default = nil)
  if valid_580622 != nil:
    section.add "quotaUser", valid_580622
  var valid_580623 = query.getOrDefault("alt")
  valid_580623 = validateParameter(valid_580623, JString, required = false,
                                 default = newJString("json"))
  if valid_580623 != nil:
    section.add "alt", valid_580623
  var valid_580624 = query.getOrDefault("oauth_token")
  valid_580624 = validateParameter(valid_580624, JString, required = false,
                                 default = nil)
  if valid_580624 != nil:
    section.add "oauth_token", valid_580624
  var valid_580625 = query.getOrDefault("userIp")
  valid_580625 = validateParameter(valid_580625, JString, required = false,
                                 default = nil)
  if valid_580625 != nil:
    section.add "userIp", valid_580625
  var valid_580626 = query.getOrDefault("key")
  valid_580626 = validateParameter(valid_580626, JString, required = false,
                                 default = nil)
  if valid_580626 != nil:
    section.add "key", valid_580626
  var valid_580627 = query.getOrDefault("prettyPrint")
  valid_580627 = validateParameter(valid_580627, JBool, required = false,
                                 default = newJBool(true))
  if valid_580627 != nil:
    section.add "prettyPrint", valid_580627
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580628: Call_ContentLiasettingsGet_580616; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the LIA settings of the account.
  ## 
  let valid = call_580628.validator(path, query, header, formData, body)
  let scheme = call_580628.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580628.url(scheme.get, call_580628.host, call_580628.base,
                         call_580628.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580628, url, valid)

proc call*(call_580629: Call_ContentLiasettingsGet_580616; accountId: string;
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
  var path_580630 = newJObject()
  var query_580631 = newJObject()
  add(query_580631, "fields", newJString(fields))
  add(query_580631, "quotaUser", newJString(quotaUser))
  add(query_580631, "alt", newJString(alt))
  add(query_580631, "oauth_token", newJString(oauthToken))
  add(path_580630, "accountId", newJString(accountId))
  add(query_580631, "userIp", newJString(userIp))
  add(query_580631, "key", newJString(key))
  add(path_580630, "merchantId", newJString(merchantId))
  add(query_580631, "prettyPrint", newJBool(prettyPrint))
  result = call_580629.call(path_580630, query_580631, nil, nil, nil)

var contentLiasettingsGet* = Call_ContentLiasettingsGet_580616(
    name: "contentLiasettingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}",
    validator: validate_ContentLiasettingsGet_580617, base: "/content/v2",
    url: url_ContentLiasettingsGet_580618, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsPatch_580651 = ref object of OpenApiRestCall_579421
proc url_ContentLiasettingsPatch_580653(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/liasettings/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentLiasettingsPatch_580652(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the LIA settings of the account. This method supports patch semantics.
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
  var valid_580654 = path.getOrDefault("accountId")
  valid_580654 = validateParameter(valid_580654, JString, required = true,
                                 default = nil)
  if valid_580654 != nil:
    section.add "accountId", valid_580654
  var valid_580655 = path.getOrDefault("merchantId")
  valid_580655 = validateParameter(valid_580655, JString, required = true,
                                 default = nil)
  if valid_580655 != nil:
    section.add "merchantId", valid_580655
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580656 = query.getOrDefault("fields")
  valid_580656 = validateParameter(valid_580656, JString, required = false,
                                 default = nil)
  if valid_580656 != nil:
    section.add "fields", valid_580656
  var valid_580657 = query.getOrDefault("quotaUser")
  valid_580657 = validateParameter(valid_580657, JString, required = false,
                                 default = nil)
  if valid_580657 != nil:
    section.add "quotaUser", valid_580657
  var valid_580658 = query.getOrDefault("alt")
  valid_580658 = validateParameter(valid_580658, JString, required = false,
                                 default = newJString("json"))
  if valid_580658 != nil:
    section.add "alt", valid_580658
  var valid_580659 = query.getOrDefault("dryRun")
  valid_580659 = validateParameter(valid_580659, JBool, required = false, default = nil)
  if valid_580659 != nil:
    section.add "dryRun", valid_580659
  var valid_580660 = query.getOrDefault("oauth_token")
  valid_580660 = validateParameter(valid_580660, JString, required = false,
                                 default = nil)
  if valid_580660 != nil:
    section.add "oauth_token", valid_580660
  var valid_580661 = query.getOrDefault("userIp")
  valid_580661 = validateParameter(valid_580661, JString, required = false,
                                 default = nil)
  if valid_580661 != nil:
    section.add "userIp", valid_580661
  var valid_580662 = query.getOrDefault("key")
  valid_580662 = validateParameter(valid_580662, JString, required = false,
                                 default = nil)
  if valid_580662 != nil:
    section.add "key", valid_580662
  var valid_580663 = query.getOrDefault("prettyPrint")
  valid_580663 = validateParameter(valid_580663, JBool, required = false,
                                 default = newJBool(true))
  if valid_580663 != nil:
    section.add "prettyPrint", valid_580663
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

proc call*(call_580665: Call_ContentLiasettingsPatch_580651; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the LIA settings of the account. This method supports patch semantics.
  ## 
  let valid = call_580665.validator(path, query, header, formData, body)
  let scheme = call_580665.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580665.url(scheme.get, call_580665.host, call_580665.base,
                         call_580665.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580665, url, valid)

proc call*(call_580666: Call_ContentLiasettingsPatch_580651; accountId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; dryRun: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## contentLiasettingsPatch
  ## Updates the LIA settings of the account. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
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
  var path_580667 = newJObject()
  var query_580668 = newJObject()
  var body_580669 = newJObject()
  add(query_580668, "fields", newJString(fields))
  add(query_580668, "quotaUser", newJString(quotaUser))
  add(query_580668, "alt", newJString(alt))
  add(query_580668, "dryRun", newJBool(dryRun))
  add(query_580668, "oauth_token", newJString(oauthToken))
  add(path_580667, "accountId", newJString(accountId))
  add(query_580668, "userIp", newJString(userIp))
  add(query_580668, "key", newJString(key))
  add(path_580667, "merchantId", newJString(merchantId))
  if body != nil:
    body_580669 = body
  add(query_580668, "prettyPrint", newJBool(prettyPrint))
  result = call_580666.call(path_580667, query_580668, nil, nil, body_580669)

var contentLiasettingsPatch* = Call_ContentLiasettingsPatch_580651(
    name: "contentLiasettingsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}",
    validator: validate_ContentLiasettingsPatch_580652, base: "/content/v2",
    url: url_ContentLiasettingsPatch_580653, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsGetaccessiblegmbaccounts_580670 = ref object of OpenApiRestCall_579421
proc url_ContentLiasettingsGetaccessiblegmbaccounts_580672(protocol: Scheme;
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

proc validate_ContentLiasettingsGetaccessiblegmbaccounts_580671(path: JsonNode;
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
  var valid_580673 = path.getOrDefault("accountId")
  valid_580673 = validateParameter(valid_580673, JString, required = true,
                                 default = nil)
  if valid_580673 != nil:
    section.add "accountId", valid_580673
  var valid_580674 = path.getOrDefault("merchantId")
  valid_580674 = validateParameter(valid_580674, JString, required = true,
                                 default = nil)
  if valid_580674 != nil:
    section.add "merchantId", valid_580674
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
  var valid_580675 = query.getOrDefault("fields")
  valid_580675 = validateParameter(valid_580675, JString, required = false,
                                 default = nil)
  if valid_580675 != nil:
    section.add "fields", valid_580675
  var valid_580676 = query.getOrDefault("quotaUser")
  valid_580676 = validateParameter(valid_580676, JString, required = false,
                                 default = nil)
  if valid_580676 != nil:
    section.add "quotaUser", valid_580676
  var valid_580677 = query.getOrDefault("alt")
  valid_580677 = validateParameter(valid_580677, JString, required = false,
                                 default = newJString("json"))
  if valid_580677 != nil:
    section.add "alt", valid_580677
  var valid_580678 = query.getOrDefault("oauth_token")
  valid_580678 = validateParameter(valid_580678, JString, required = false,
                                 default = nil)
  if valid_580678 != nil:
    section.add "oauth_token", valid_580678
  var valid_580679 = query.getOrDefault("userIp")
  valid_580679 = validateParameter(valid_580679, JString, required = false,
                                 default = nil)
  if valid_580679 != nil:
    section.add "userIp", valid_580679
  var valid_580680 = query.getOrDefault("key")
  valid_580680 = validateParameter(valid_580680, JString, required = false,
                                 default = nil)
  if valid_580680 != nil:
    section.add "key", valid_580680
  var valid_580681 = query.getOrDefault("prettyPrint")
  valid_580681 = validateParameter(valid_580681, JBool, required = false,
                                 default = newJBool(true))
  if valid_580681 != nil:
    section.add "prettyPrint", valid_580681
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580682: Call_ContentLiasettingsGetaccessiblegmbaccounts_580670;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of accessible Google My Business accounts.
  ## 
  let valid = call_580682.validator(path, query, header, formData, body)
  let scheme = call_580682.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580682.url(scheme.get, call_580682.host, call_580682.base,
                         call_580682.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580682, url, valid)

proc call*(call_580683: Call_ContentLiasettingsGetaccessiblegmbaccounts_580670;
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
  var path_580684 = newJObject()
  var query_580685 = newJObject()
  add(query_580685, "fields", newJString(fields))
  add(query_580685, "quotaUser", newJString(quotaUser))
  add(query_580685, "alt", newJString(alt))
  add(query_580685, "oauth_token", newJString(oauthToken))
  add(path_580684, "accountId", newJString(accountId))
  add(query_580685, "userIp", newJString(userIp))
  add(query_580685, "key", newJString(key))
  add(path_580684, "merchantId", newJString(merchantId))
  add(query_580685, "prettyPrint", newJBool(prettyPrint))
  result = call_580683.call(path_580684, query_580685, nil, nil, nil)

var contentLiasettingsGetaccessiblegmbaccounts* = Call_ContentLiasettingsGetaccessiblegmbaccounts_580670(
    name: "contentLiasettingsGetaccessiblegmbaccounts", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/accessiblegmbaccounts",
    validator: validate_ContentLiasettingsGetaccessiblegmbaccounts_580671,
    base: "/content/v2", url: url_ContentLiasettingsGetaccessiblegmbaccounts_580672,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsRequestgmbaccess_580686 = ref object of OpenApiRestCall_579421
proc url_ContentLiasettingsRequestgmbaccess_580688(protocol: Scheme; host: string;
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

proc validate_ContentLiasettingsRequestgmbaccess_580687(path: JsonNode;
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
  var valid_580689 = path.getOrDefault("accountId")
  valid_580689 = validateParameter(valid_580689, JString, required = true,
                                 default = nil)
  if valid_580689 != nil:
    section.add "accountId", valid_580689
  var valid_580690 = path.getOrDefault("merchantId")
  valid_580690 = validateParameter(valid_580690, JString, required = true,
                                 default = nil)
  if valid_580690 != nil:
    section.add "merchantId", valid_580690
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
  var valid_580691 = query.getOrDefault("fields")
  valid_580691 = validateParameter(valid_580691, JString, required = false,
                                 default = nil)
  if valid_580691 != nil:
    section.add "fields", valid_580691
  var valid_580692 = query.getOrDefault("quotaUser")
  valid_580692 = validateParameter(valid_580692, JString, required = false,
                                 default = nil)
  if valid_580692 != nil:
    section.add "quotaUser", valid_580692
  var valid_580693 = query.getOrDefault("alt")
  valid_580693 = validateParameter(valid_580693, JString, required = false,
                                 default = newJString("json"))
  if valid_580693 != nil:
    section.add "alt", valid_580693
  var valid_580694 = query.getOrDefault("oauth_token")
  valid_580694 = validateParameter(valid_580694, JString, required = false,
                                 default = nil)
  if valid_580694 != nil:
    section.add "oauth_token", valid_580694
  var valid_580695 = query.getOrDefault("userIp")
  valid_580695 = validateParameter(valid_580695, JString, required = false,
                                 default = nil)
  if valid_580695 != nil:
    section.add "userIp", valid_580695
  var valid_580696 = query.getOrDefault("key")
  valid_580696 = validateParameter(valid_580696, JString, required = false,
                                 default = nil)
  if valid_580696 != nil:
    section.add "key", valid_580696
  assert query != nil,
        "query argument is necessary due to required `gmbEmail` field"
  var valid_580697 = query.getOrDefault("gmbEmail")
  valid_580697 = validateParameter(valid_580697, JString, required = true,
                                 default = nil)
  if valid_580697 != nil:
    section.add "gmbEmail", valid_580697
  var valid_580698 = query.getOrDefault("prettyPrint")
  valid_580698 = validateParameter(valid_580698, JBool, required = false,
                                 default = newJBool(true))
  if valid_580698 != nil:
    section.add "prettyPrint", valid_580698
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580699: Call_ContentLiasettingsRequestgmbaccess_580686;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests access to a specified Google My Business account.
  ## 
  let valid = call_580699.validator(path, query, header, formData, body)
  let scheme = call_580699.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580699.url(scheme.get, call_580699.host, call_580699.base,
                         call_580699.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580699, url, valid)

proc call*(call_580700: Call_ContentLiasettingsRequestgmbaccess_580686;
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
  var path_580701 = newJObject()
  var query_580702 = newJObject()
  add(query_580702, "fields", newJString(fields))
  add(query_580702, "quotaUser", newJString(quotaUser))
  add(query_580702, "alt", newJString(alt))
  add(query_580702, "oauth_token", newJString(oauthToken))
  add(path_580701, "accountId", newJString(accountId))
  add(query_580702, "userIp", newJString(userIp))
  add(query_580702, "key", newJString(key))
  add(query_580702, "gmbEmail", newJString(gmbEmail))
  add(path_580701, "merchantId", newJString(merchantId))
  add(query_580702, "prettyPrint", newJBool(prettyPrint))
  result = call_580700.call(path_580701, query_580702, nil, nil, nil)

var contentLiasettingsRequestgmbaccess* = Call_ContentLiasettingsRequestgmbaccess_580686(
    name: "contentLiasettingsRequestgmbaccess", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/requestgmbaccess",
    validator: validate_ContentLiasettingsRequestgmbaccess_580687,
    base: "/content/v2", url: url_ContentLiasettingsRequestgmbaccess_580688,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsRequestinventoryverification_580703 = ref object of OpenApiRestCall_579421
proc url_ContentLiasettingsRequestinventoryverification_580705(protocol: Scheme;
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

proc validate_ContentLiasettingsRequestinventoryverification_580704(
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
  var valid_580706 = path.getOrDefault("country")
  valid_580706 = validateParameter(valid_580706, JString, required = true,
                                 default = nil)
  if valid_580706 != nil:
    section.add "country", valid_580706
  var valid_580707 = path.getOrDefault("accountId")
  valid_580707 = validateParameter(valid_580707, JString, required = true,
                                 default = nil)
  if valid_580707 != nil:
    section.add "accountId", valid_580707
  var valid_580708 = path.getOrDefault("merchantId")
  valid_580708 = validateParameter(valid_580708, JString, required = true,
                                 default = nil)
  if valid_580708 != nil:
    section.add "merchantId", valid_580708
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
  var valid_580709 = query.getOrDefault("fields")
  valid_580709 = validateParameter(valid_580709, JString, required = false,
                                 default = nil)
  if valid_580709 != nil:
    section.add "fields", valid_580709
  var valid_580710 = query.getOrDefault("quotaUser")
  valid_580710 = validateParameter(valid_580710, JString, required = false,
                                 default = nil)
  if valid_580710 != nil:
    section.add "quotaUser", valid_580710
  var valid_580711 = query.getOrDefault("alt")
  valid_580711 = validateParameter(valid_580711, JString, required = false,
                                 default = newJString("json"))
  if valid_580711 != nil:
    section.add "alt", valid_580711
  var valid_580712 = query.getOrDefault("oauth_token")
  valid_580712 = validateParameter(valid_580712, JString, required = false,
                                 default = nil)
  if valid_580712 != nil:
    section.add "oauth_token", valid_580712
  var valid_580713 = query.getOrDefault("userIp")
  valid_580713 = validateParameter(valid_580713, JString, required = false,
                                 default = nil)
  if valid_580713 != nil:
    section.add "userIp", valid_580713
  var valid_580714 = query.getOrDefault("key")
  valid_580714 = validateParameter(valid_580714, JString, required = false,
                                 default = nil)
  if valid_580714 != nil:
    section.add "key", valid_580714
  var valid_580715 = query.getOrDefault("prettyPrint")
  valid_580715 = validateParameter(valid_580715, JBool, required = false,
                                 default = newJBool(true))
  if valid_580715 != nil:
    section.add "prettyPrint", valid_580715
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580716: Call_ContentLiasettingsRequestinventoryverification_580703;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests inventory validation for the specified country.
  ## 
  let valid = call_580716.validator(path, query, header, formData, body)
  let scheme = call_580716.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580716.url(scheme.get, call_580716.host, call_580716.base,
                         call_580716.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580716, url, valid)

proc call*(call_580717: Call_ContentLiasettingsRequestinventoryverification_580703;
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
  var path_580718 = newJObject()
  var query_580719 = newJObject()
  add(query_580719, "fields", newJString(fields))
  add(query_580719, "quotaUser", newJString(quotaUser))
  add(query_580719, "alt", newJString(alt))
  add(path_580718, "country", newJString(country))
  add(query_580719, "oauth_token", newJString(oauthToken))
  add(path_580718, "accountId", newJString(accountId))
  add(query_580719, "userIp", newJString(userIp))
  add(query_580719, "key", newJString(key))
  add(path_580718, "merchantId", newJString(merchantId))
  add(query_580719, "prettyPrint", newJBool(prettyPrint))
  result = call_580717.call(path_580718, query_580719, nil, nil, nil)

var contentLiasettingsRequestinventoryverification* = Call_ContentLiasettingsRequestinventoryverification_580703(
    name: "contentLiasettingsRequestinventoryverification",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}/requestinventoryverification/{country}",
    validator: validate_ContentLiasettingsRequestinventoryverification_580704,
    base: "/content/v2", url: url_ContentLiasettingsRequestinventoryverification_580705,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsSetinventoryverificationcontact_580720 = ref object of OpenApiRestCall_579421
proc url_ContentLiasettingsSetinventoryverificationcontact_580722(
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

proc validate_ContentLiasettingsSetinventoryverificationcontact_580721(
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
  var valid_580723 = path.getOrDefault("accountId")
  valid_580723 = validateParameter(valid_580723, JString, required = true,
                                 default = nil)
  if valid_580723 != nil:
    section.add "accountId", valid_580723
  var valid_580724 = path.getOrDefault("merchantId")
  valid_580724 = validateParameter(valid_580724, JString, required = true,
                                 default = nil)
  if valid_580724 != nil:
    section.add "merchantId", valid_580724
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
  var valid_580725 = query.getOrDefault("fields")
  valid_580725 = validateParameter(valid_580725, JString, required = false,
                                 default = nil)
  if valid_580725 != nil:
    section.add "fields", valid_580725
  assert query != nil, "query argument is necessary due to required `country` field"
  var valid_580726 = query.getOrDefault("country")
  valid_580726 = validateParameter(valid_580726, JString, required = true,
                                 default = nil)
  if valid_580726 != nil:
    section.add "country", valid_580726
  var valid_580727 = query.getOrDefault("quotaUser")
  valid_580727 = validateParameter(valid_580727, JString, required = false,
                                 default = nil)
  if valid_580727 != nil:
    section.add "quotaUser", valid_580727
  var valid_580728 = query.getOrDefault("alt")
  valid_580728 = validateParameter(valid_580728, JString, required = false,
                                 default = newJString("json"))
  if valid_580728 != nil:
    section.add "alt", valid_580728
  var valid_580729 = query.getOrDefault("contactName")
  valid_580729 = validateParameter(valid_580729, JString, required = true,
                                 default = nil)
  if valid_580729 != nil:
    section.add "contactName", valid_580729
  var valid_580730 = query.getOrDefault("language")
  valid_580730 = validateParameter(valid_580730, JString, required = true,
                                 default = nil)
  if valid_580730 != nil:
    section.add "language", valid_580730
  var valid_580731 = query.getOrDefault("oauth_token")
  valid_580731 = validateParameter(valid_580731, JString, required = false,
                                 default = nil)
  if valid_580731 != nil:
    section.add "oauth_token", valid_580731
  var valid_580732 = query.getOrDefault("userIp")
  valid_580732 = validateParameter(valid_580732, JString, required = false,
                                 default = nil)
  if valid_580732 != nil:
    section.add "userIp", valid_580732
  var valid_580733 = query.getOrDefault("key")
  valid_580733 = validateParameter(valid_580733, JString, required = false,
                                 default = nil)
  if valid_580733 != nil:
    section.add "key", valid_580733
  var valid_580734 = query.getOrDefault("prettyPrint")
  valid_580734 = validateParameter(valid_580734, JBool, required = false,
                                 default = newJBool(true))
  if valid_580734 != nil:
    section.add "prettyPrint", valid_580734
  var valid_580735 = query.getOrDefault("contactEmail")
  valid_580735 = validateParameter(valid_580735, JString, required = true,
                                 default = nil)
  if valid_580735 != nil:
    section.add "contactEmail", valid_580735
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580736: Call_ContentLiasettingsSetinventoryverificationcontact_580720;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the inventory verification contract for the specified country.
  ## 
  let valid = call_580736.validator(path, query, header, formData, body)
  let scheme = call_580736.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580736.url(scheme.get, call_580736.host, call_580736.base,
                         call_580736.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580736, url, valid)

proc call*(call_580737: Call_ContentLiasettingsSetinventoryverificationcontact_580720;
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
  var path_580738 = newJObject()
  var query_580739 = newJObject()
  add(query_580739, "fields", newJString(fields))
  add(query_580739, "country", newJString(country))
  add(query_580739, "quotaUser", newJString(quotaUser))
  add(query_580739, "alt", newJString(alt))
  add(query_580739, "contactName", newJString(contactName))
  add(query_580739, "language", newJString(language))
  add(query_580739, "oauth_token", newJString(oauthToken))
  add(path_580738, "accountId", newJString(accountId))
  add(query_580739, "userIp", newJString(userIp))
  add(query_580739, "key", newJString(key))
  add(path_580738, "merchantId", newJString(merchantId))
  add(query_580739, "prettyPrint", newJBool(prettyPrint))
  add(query_580739, "contactEmail", newJString(contactEmail))
  result = call_580737.call(path_580738, query_580739, nil, nil, nil)

var contentLiasettingsSetinventoryverificationcontact* = Call_ContentLiasettingsSetinventoryverificationcontact_580720(
    name: "contentLiasettingsSetinventoryverificationcontact",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}/setinventoryverificationcontact",
    validator: validate_ContentLiasettingsSetinventoryverificationcontact_580721,
    base: "/content/v2",
    url: url_ContentLiasettingsSetinventoryverificationcontact_580722,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsSetposdataprovider_580740 = ref object of OpenApiRestCall_579421
proc url_ContentLiasettingsSetposdataprovider_580742(protocol: Scheme;
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

proc validate_ContentLiasettingsSetposdataprovider_580741(path: JsonNode;
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
  var valid_580743 = path.getOrDefault("accountId")
  valid_580743 = validateParameter(valid_580743, JString, required = true,
                                 default = nil)
  if valid_580743 != nil:
    section.add "accountId", valid_580743
  var valid_580744 = path.getOrDefault("merchantId")
  valid_580744 = validateParameter(valid_580744, JString, required = true,
                                 default = nil)
  if valid_580744 != nil:
    section.add "merchantId", valid_580744
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
  var valid_580745 = query.getOrDefault("fields")
  valid_580745 = validateParameter(valid_580745, JString, required = false,
                                 default = nil)
  if valid_580745 != nil:
    section.add "fields", valid_580745
  assert query != nil, "query argument is necessary due to required `country` field"
  var valid_580746 = query.getOrDefault("country")
  valid_580746 = validateParameter(valid_580746, JString, required = true,
                                 default = nil)
  if valid_580746 != nil:
    section.add "country", valid_580746
  var valid_580747 = query.getOrDefault("quotaUser")
  valid_580747 = validateParameter(valid_580747, JString, required = false,
                                 default = nil)
  if valid_580747 != nil:
    section.add "quotaUser", valid_580747
  var valid_580748 = query.getOrDefault("alt")
  valid_580748 = validateParameter(valid_580748, JString, required = false,
                                 default = newJString("json"))
  if valid_580748 != nil:
    section.add "alt", valid_580748
  var valid_580749 = query.getOrDefault("oauth_token")
  valid_580749 = validateParameter(valid_580749, JString, required = false,
                                 default = nil)
  if valid_580749 != nil:
    section.add "oauth_token", valid_580749
  var valid_580750 = query.getOrDefault("userIp")
  valid_580750 = validateParameter(valid_580750, JString, required = false,
                                 default = nil)
  if valid_580750 != nil:
    section.add "userIp", valid_580750
  var valid_580751 = query.getOrDefault("posExternalAccountId")
  valid_580751 = validateParameter(valid_580751, JString, required = false,
                                 default = nil)
  if valid_580751 != nil:
    section.add "posExternalAccountId", valid_580751
  var valid_580752 = query.getOrDefault("key")
  valid_580752 = validateParameter(valid_580752, JString, required = false,
                                 default = nil)
  if valid_580752 != nil:
    section.add "key", valid_580752
  var valid_580753 = query.getOrDefault("posDataProviderId")
  valid_580753 = validateParameter(valid_580753, JString, required = false,
                                 default = nil)
  if valid_580753 != nil:
    section.add "posDataProviderId", valid_580753
  var valid_580754 = query.getOrDefault("prettyPrint")
  valid_580754 = validateParameter(valid_580754, JBool, required = false,
                                 default = newJBool(true))
  if valid_580754 != nil:
    section.add "prettyPrint", valid_580754
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580755: Call_ContentLiasettingsSetposdataprovider_580740;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the POS data provider for the specified country.
  ## 
  let valid = call_580755.validator(path, query, header, formData, body)
  let scheme = call_580755.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580755.url(scheme.get, call_580755.host, call_580755.base,
                         call_580755.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580755, url, valid)

proc call*(call_580756: Call_ContentLiasettingsSetposdataprovider_580740;
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
  var path_580757 = newJObject()
  var query_580758 = newJObject()
  add(query_580758, "fields", newJString(fields))
  add(query_580758, "country", newJString(country))
  add(query_580758, "quotaUser", newJString(quotaUser))
  add(query_580758, "alt", newJString(alt))
  add(query_580758, "oauth_token", newJString(oauthToken))
  add(path_580757, "accountId", newJString(accountId))
  add(query_580758, "userIp", newJString(userIp))
  add(query_580758, "posExternalAccountId", newJString(posExternalAccountId))
  add(query_580758, "key", newJString(key))
  add(query_580758, "posDataProviderId", newJString(posDataProviderId))
  add(path_580757, "merchantId", newJString(merchantId))
  add(query_580758, "prettyPrint", newJBool(prettyPrint))
  result = call_580756.call(path_580757, query_580758, nil, nil, nil)

var contentLiasettingsSetposdataprovider* = Call_ContentLiasettingsSetposdataprovider_580740(
    name: "contentLiasettingsSetposdataprovider", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/setposdataprovider",
    validator: validate_ContentLiasettingsSetposdataprovider_580741,
    base: "/content/v2", url: url_ContentLiasettingsSetposdataprovider_580742,
    schemes: {Scheme.Https})
type
  Call_ContentOrderinvoicesCreatechargeinvoice_580759 = ref object of OpenApiRestCall_579421
proc url_ContentOrderinvoicesCreatechargeinvoice_580761(protocol: Scheme;
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

proc validate_ContentOrderinvoicesCreatechargeinvoice_580760(path: JsonNode;
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
  var valid_580762 = path.getOrDefault("orderId")
  valid_580762 = validateParameter(valid_580762, JString, required = true,
                                 default = nil)
  if valid_580762 != nil:
    section.add "orderId", valid_580762
  var valid_580763 = path.getOrDefault("merchantId")
  valid_580763 = validateParameter(valid_580763, JString, required = true,
                                 default = nil)
  if valid_580763 != nil:
    section.add "merchantId", valid_580763
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
  var valid_580764 = query.getOrDefault("fields")
  valid_580764 = validateParameter(valid_580764, JString, required = false,
                                 default = nil)
  if valid_580764 != nil:
    section.add "fields", valid_580764
  var valid_580765 = query.getOrDefault("quotaUser")
  valid_580765 = validateParameter(valid_580765, JString, required = false,
                                 default = nil)
  if valid_580765 != nil:
    section.add "quotaUser", valid_580765
  var valid_580766 = query.getOrDefault("alt")
  valid_580766 = validateParameter(valid_580766, JString, required = false,
                                 default = newJString("json"))
  if valid_580766 != nil:
    section.add "alt", valid_580766
  var valid_580767 = query.getOrDefault("oauth_token")
  valid_580767 = validateParameter(valid_580767, JString, required = false,
                                 default = nil)
  if valid_580767 != nil:
    section.add "oauth_token", valid_580767
  var valid_580768 = query.getOrDefault("userIp")
  valid_580768 = validateParameter(valid_580768, JString, required = false,
                                 default = nil)
  if valid_580768 != nil:
    section.add "userIp", valid_580768
  var valid_580769 = query.getOrDefault("key")
  valid_580769 = validateParameter(valid_580769, JString, required = false,
                                 default = nil)
  if valid_580769 != nil:
    section.add "key", valid_580769
  var valid_580770 = query.getOrDefault("prettyPrint")
  valid_580770 = validateParameter(valid_580770, JBool, required = false,
                                 default = newJBool(true))
  if valid_580770 != nil:
    section.add "prettyPrint", valid_580770
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

proc call*(call_580772: Call_ContentOrderinvoicesCreatechargeinvoice_580759;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a charge invoice for a shipment group, and triggers a charge capture for orderinvoice enabled orders.
  ## 
  let valid = call_580772.validator(path, query, header, formData, body)
  let scheme = call_580772.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580772.url(scheme.get, call_580772.host, call_580772.base,
                         call_580772.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580772, url, valid)

proc call*(call_580773: Call_ContentOrderinvoicesCreatechargeinvoice_580759;
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
  var path_580774 = newJObject()
  var query_580775 = newJObject()
  var body_580776 = newJObject()
  add(query_580775, "fields", newJString(fields))
  add(query_580775, "quotaUser", newJString(quotaUser))
  add(query_580775, "alt", newJString(alt))
  add(query_580775, "oauth_token", newJString(oauthToken))
  add(query_580775, "userIp", newJString(userIp))
  add(path_580774, "orderId", newJString(orderId))
  add(query_580775, "key", newJString(key))
  add(path_580774, "merchantId", newJString(merchantId))
  if body != nil:
    body_580776 = body
  add(query_580775, "prettyPrint", newJBool(prettyPrint))
  result = call_580773.call(path_580774, query_580775, nil, nil, body_580776)

var contentOrderinvoicesCreatechargeinvoice* = Call_ContentOrderinvoicesCreatechargeinvoice_580759(
    name: "contentOrderinvoicesCreatechargeinvoice", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderinvoices/{orderId}/createChargeInvoice",
    validator: validate_ContentOrderinvoicesCreatechargeinvoice_580760,
    base: "/content/v2", url: url_ContentOrderinvoicesCreatechargeinvoice_580761,
    schemes: {Scheme.Https})
type
  Call_ContentOrderinvoicesCreaterefundinvoice_580777 = ref object of OpenApiRestCall_579421
proc url_ContentOrderinvoicesCreaterefundinvoice_580779(protocol: Scheme;
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

proc validate_ContentOrderinvoicesCreaterefundinvoice_580778(path: JsonNode;
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
  var valid_580780 = path.getOrDefault("orderId")
  valid_580780 = validateParameter(valid_580780, JString, required = true,
                                 default = nil)
  if valid_580780 != nil:
    section.add "orderId", valid_580780
  var valid_580781 = path.getOrDefault("merchantId")
  valid_580781 = validateParameter(valid_580781, JString, required = true,
                                 default = nil)
  if valid_580781 != nil:
    section.add "merchantId", valid_580781
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
  var valid_580782 = query.getOrDefault("fields")
  valid_580782 = validateParameter(valid_580782, JString, required = false,
                                 default = nil)
  if valid_580782 != nil:
    section.add "fields", valid_580782
  var valid_580783 = query.getOrDefault("quotaUser")
  valid_580783 = validateParameter(valid_580783, JString, required = false,
                                 default = nil)
  if valid_580783 != nil:
    section.add "quotaUser", valid_580783
  var valid_580784 = query.getOrDefault("alt")
  valid_580784 = validateParameter(valid_580784, JString, required = false,
                                 default = newJString("json"))
  if valid_580784 != nil:
    section.add "alt", valid_580784
  var valid_580785 = query.getOrDefault("oauth_token")
  valid_580785 = validateParameter(valid_580785, JString, required = false,
                                 default = nil)
  if valid_580785 != nil:
    section.add "oauth_token", valid_580785
  var valid_580786 = query.getOrDefault("userIp")
  valid_580786 = validateParameter(valid_580786, JString, required = false,
                                 default = nil)
  if valid_580786 != nil:
    section.add "userIp", valid_580786
  var valid_580787 = query.getOrDefault("key")
  valid_580787 = validateParameter(valid_580787, JString, required = false,
                                 default = nil)
  if valid_580787 != nil:
    section.add "key", valid_580787
  var valid_580788 = query.getOrDefault("prettyPrint")
  valid_580788 = validateParameter(valid_580788, JBool, required = false,
                                 default = newJBool(true))
  if valid_580788 != nil:
    section.add "prettyPrint", valid_580788
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

proc call*(call_580790: Call_ContentOrderinvoicesCreaterefundinvoice_580777;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a refund invoice for one or more shipment groups, and triggers a refund for orderinvoice enabled orders. This can only be used for line items that have previously been charged using createChargeInvoice. All amounts (except for the summary) are incremental with respect to the previous invoice.
  ## 
  let valid = call_580790.validator(path, query, header, formData, body)
  let scheme = call_580790.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580790.url(scheme.get, call_580790.host, call_580790.base,
                         call_580790.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580790, url, valid)

proc call*(call_580791: Call_ContentOrderinvoicesCreaterefundinvoice_580777;
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
  var path_580792 = newJObject()
  var query_580793 = newJObject()
  var body_580794 = newJObject()
  add(query_580793, "fields", newJString(fields))
  add(query_580793, "quotaUser", newJString(quotaUser))
  add(query_580793, "alt", newJString(alt))
  add(query_580793, "oauth_token", newJString(oauthToken))
  add(query_580793, "userIp", newJString(userIp))
  add(path_580792, "orderId", newJString(orderId))
  add(query_580793, "key", newJString(key))
  add(path_580792, "merchantId", newJString(merchantId))
  if body != nil:
    body_580794 = body
  add(query_580793, "prettyPrint", newJBool(prettyPrint))
  result = call_580791.call(path_580792, query_580793, nil, nil, body_580794)

var contentOrderinvoicesCreaterefundinvoice* = Call_ContentOrderinvoicesCreaterefundinvoice_580777(
    name: "contentOrderinvoicesCreaterefundinvoice", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderinvoices/{orderId}/createRefundInvoice",
    validator: validate_ContentOrderinvoicesCreaterefundinvoice_580778,
    base: "/content/v2", url: url_ContentOrderinvoicesCreaterefundinvoice_580779,
    schemes: {Scheme.Https})
type
  Call_ContentOrderpaymentsNotifyauthapproved_580795 = ref object of OpenApiRestCall_579421
proc url_ContentOrderpaymentsNotifyauthapproved_580797(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/orderpayments/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/notifyAuthApproved")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrderpaymentsNotifyauthapproved_580796(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Notify about successfully authorizing user's payment method for a given amount.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   orderId: JString (required)
  ##          : The ID of the order for for which payment authorization is happening.
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `orderId` field"
  var valid_580798 = path.getOrDefault("orderId")
  valid_580798 = validateParameter(valid_580798, JString, required = true,
                                 default = nil)
  if valid_580798 != nil:
    section.add "orderId", valid_580798
  var valid_580799 = path.getOrDefault("merchantId")
  valid_580799 = validateParameter(valid_580799, JString, required = true,
                                 default = nil)
  if valid_580799 != nil:
    section.add "merchantId", valid_580799
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
  var valid_580800 = query.getOrDefault("fields")
  valid_580800 = validateParameter(valid_580800, JString, required = false,
                                 default = nil)
  if valid_580800 != nil:
    section.add "fields", valid_580800
  var valid_580801 = query.getOrDefault("quotaUser")
  valid_580801 = validateParameter(valid_580801, JString, required = false,
                                 default = nil)
  if valid_580801 != nil:
    section.add "quotaUser", valid_580801
  var valid_580802 = query.getOrDefault("alt")
  valid_580802 = validateParameter(valid_580802, JString, required = false,
                                 default = newJString("json"))
  if valid_580802 != nil:
    section.add "alt", valid_580802
  var valid_580803 = query.getOrDefault("oauth_token")
  valid_580803 = validateParameter(valid_580803, JString, required = false,
                                 default = nil)
  if valid_580803 != nil:
    section.add "oauth_token", valid_580803
  var valid_580804 = query.getOrDefault("userIp")
  valid_580804 = validateParameter(valid_580804, JString, required = false,
                                 default = nil)
  if valid_580804 != nil:
    section.add "userIp", valid_580804
  var valid_580805 = query.getOrDefault("key")
  valid_580805 = validateParameter(valid_580805, JString, required = false,
                                 default = nil)
  if valid_580805 != nil:
    section.add "key", valid_580805
  var valid_580806 = query.getOrDefault("prettyPrint")
  valid_580806 = validateParameter(valid_580806, JBool, required = false,
                                 default = newJBool(true))
  if valid_580806 != nil:
    section.add "prettyPrint", valid_580806
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

proc call*(call_580808: Call_ContentOrderpaymentsNotifyauthapproved_580795;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Notify about successfully authorizing user's payment method for a given amount.
  ## 
  let valid = call_580808.validator(path, query, header, formData, body)
  let scheme = call_580808.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580808.url(scheme.get, call_580808.host, call_580808.base,
                         call_580808.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580808, url, valid)

proc call*(call_580809: Call_ContentOrderpaymentsNotifyauthapproved_580795;
          orderId: string; merchantId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## contentOrderpaymentsNotifyauthapproved
  ## Notify about successfully authorizing user's payment method for a given amount.
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
  ##          : The ID of the order for for which payment authorization is happening.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580810 = newJObject()
  var query_580811 = newJObject()
  var body_580812 = newJObject()
  add(query_580811, "fields", newJString(fields))
  add(query_580811, "quotaUser", newJString(quotaUser))
  add(query_580811, "alt", newJString(alt))
  add(query_580811, "oauth_token", newJString(oauthToken))
  add(query_580811, "userIp", newJString(userIp))
  add(path_580810, "orderId", newJString(orderId))
  add(query_580811, "key", newJString(key))
  add(path_580810, "merchantId", newJString(merchantId))
  if body != nil:
    body_580812 = body
  add(query_580811, "prettyPrint", newJBool(prettyPrint))
  result = call_580809.call(path_580810, query_580811, nil, nil, body_580812)

var contentOrderpaymentsNotifyauthapproved* = Call_ContentOrderpaymentsNotifyauthapproved_580795(
    name: "contentOrderpaymentsNotifyauthapproved", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderpayments/{orderId}/notifyAuthApproved",
    validator: validate_ContentOrderpaymentsNotifyauthapproved_580796,
    base: "/content/v2", url: url_ContentOrderpaymentsNotifyauthapproved_580797,
    schemes: {Scheme.Https})
type
  Call_ContentOrderpaymentsNotifyauthdeclined_580813 = ref object of OpenApiRestCall_579421
proc url_ContentOrderpaymentsNotifyauthdeclined_580815(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/orderpayments/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/notifyAuthDeclined")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrderpaymentsNotifyauthdeclined_580814(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Notify about failure to authorize user's payment method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   orderId: JString (required)
  ##          : The ID of the order for which payment authorization was declined.
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `orderId` field"
  var valid_580816 = path.getOrDefault("orderId")
  valid_580816 = validateParameter(valid_580816, JString, required = true,
                                 default = nil)
  if valid_580816 != nil:
    section.add "orderId", valid_580816
  var valid_580817 = path.getOrDefault("merchantId")
  valid_580817 = validateParameter(valid_580817, JString, required = true,
                                 default = nil)
  if valid_580817 != nil:
    section.add "merchantId", valid_580817
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
  var valid_580818 = query.getOrDefault("fields")
  valid_580818 = validateParameter(valid_580818, JString, required = false,
                                 default = nil)
  if valid_580818 != nil:
    section.add "fields", valid_580818
  var valid_580819 = query.getOrDefault("quotaUser")
  valid_580819 = validateParameter(valid_580819, JString, required = false,
                                 default = nil)
  if valid_580819 != nil:
    section.add "quotaUser", valid_580819
  var valid_580820 = query.getOrDefault("alt")
  valid_580820 = validateParameter(valid_580820, JString, required = false,
                                 default = newJString("json"))
  if valid_580820 != nil:
    section.add "alt", valid_580820
  var valid_580821 = query.getOrDefault("oauth_token")
  valid_580821 = validateParameter(valid_580821, JString, required = false,
                                 default = nil)
  if valid_580821 != nil:
    section.add "oauth_token", valid_580821
  var valid_580822 = query.getOrDefault("userIp")
  valid_580822 = validateParameter(valid_580822, JString, required = false,
                                 default = nil)
  if valid_580822 != nil:
    section.add "userIp", valid_580822
  var valid_580823 = query.getOrDefault("key")
  valid_580823 = validateParameter(valid_580823, JString, required = false,
                                 default = nil)
  if valid_580823 != nil:
    section.add "key", valid_580823
  var valid_580824 = query.getOrDefault("prettyPrint")
  valid_580824 = validateParameter(valid_580824, JBool, required = false,
                                 default = newJBool(true))
  if valid_580824 != nil:
    section.add "prettyPrint", valid_580824
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

proc call*(call_580826: Call_ContentOrderpaymentsNotifyauthdeclined_580813;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Notify about failure to authorize user's payment method.
  ## 
  let valid = call_580826.validator(path, query, header, formData, body)
  let scheme = call_580826.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580826.url(scheme.get, call_580826.host, call_580826.base,
                         call_580826.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580826, url, valid)

proc call*(call_580827: Call_ContentOrderpaymentsNotifyauthdeclined_580813;
          orderId: string; merchantId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## contentOrderpaymentsNotifyauthdeclined
  ## Notify about failure to authorize user's payment method.
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
  ##          : The ID of the order for which payment authorization was declined.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580828 = newJObject()
  var query_580829 = newJObject()
  var body_580830 = newJObject()
  add(query_580829, "fields", newJString(fields))
  add(query_580829, "quotaUser", newJString(quotaUser))
  add(query_580829, "alt", newJString(alt))
  add(query_580829, "oauth_token", newJString(oauthToken))
  add(query_580829, "userIp", newJString(userIp))
  add(path_580828, "orderId", newJString(orderId))
  add(query_580829, "key", newJString(key))
  add(path_580828, "merchantId", newJString(merchantId))
  if body != nil:
    body_580830 = body
  add(query_580829, "prettyPrint", newJBool(prettyPrint))
  result = call_580827.call(path_580828, query_580829, nil, nil, body_580830)

var contentOrderpaymentsNotifyauthdeclined* = Call_ContentOrderpaymentsNotifyauthdeclined_580813(
    name: "contentOrderpaymentsNotifyauthdeclined", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderpayments/{orderId}/notifyAuthDeclined",
    validator: validate_ContentOrderpaymentsNotifyauthdeclined_580814,
    base: "/content/v2", url: url_ContentOrderpaymentsNotifyauthdeclined_580815,
    schemes: {Scheme.Https})
type
  Call_ContentOrderpaymentsNotifycharge_580831 = ref object of OpenApiRestCall_579421
proc url_ContentOrderpaymentsNotifycharge_580833(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/orderpayments/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/notifyCharge")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrderpaymentsNotifycharge_580832(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Notify about charge on user's selected payments method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   orderId: JString (required)
  ##          : The ID of the order for which charge is happening.
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `orderId` field"
  var valid_580834 = path.getOrDefault("orderId")
  valid_580834 = validateParameter(valid_580834, JString, required = true,
                                 default = nil)
  if valid_580834 != nil:
    section.add "orderId", valid_580834
  var valid_580835 = path.getOrDefault("merchantId")
  valid_580835 = validateParameter(valid_580835, JString, required = true,
                                 default = nil)
  if valid_580835 != nil:
    section.add "merchantId", valid_580835
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
  var valid_580836 = query.getOrDefault("fields")
  valid_580836 = validateParameter(valid_580836, JString, required = false,
                                 default = nil)
  if valid_580836 != nil:
    section.add "fields", valid_580836
  var valid_580837 = query.getOrDefault("quotaUser")
  valid_580837 = validateParameter(valid_580837, JString, required = false,
                                 default = nil)
  if valid_580837 != nil:
    section.add "quotaUser", valid_580837
  var valid_580838 = query.getOrDefault("alt")
  valid_580838 = validateParameter(valid_580838, JString, required = false,
                                 default = newJString("json"))
  if valid_580838 != nil:
    section.add "alt", valid_580838
  var valid_580839 = query.getOrDefault("oauth_token")
  valid_580839 = validateParameter(valid_580839, JString, required = false,
                                 default = nil)
  if valid_580839 != nil:
    section.add "oauth_token", valid_580839
  var valid_580840 = query.getOrDefault("userIp")
  valid_580840 = validateParameter(valid_580840, JString, required = false,
                                 default = nil)
  if valid_580840 != nil:
    section.add "userIp", valid_580840
  var valid_580841 = query.getOrDefault("key")
  valid_580841 = validateParameter(valid_580841, JString, required = false,
                                 default = nil)
  if valid_580841 != nil:
    section.add "key", valid_580841
  var valid_580842 = query.getOrDefault("prettyPrint")
  valid_580842 = validateParameter(valid_580842, JBool, required = false,
                                 default = newJBool(true))
  if valid_580842 != nil:
    section.add "prettyPrint", valid_580842
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

proc call*(call_580844: Call_ContentOrderpaymentsNotifycharge_580831;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Notify about charge on user's selected payments method.
  ## 
  let valid = call_580844.validator(path, query, header, formData, body)
  let scheme = call_580844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580844.url(scheme.get, call_580844.host, call_580844.base,
                         call_580844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580844, url, valid)

proc call*(call_580845: Call_ContentOrderpaymentsNotifycharge_580831;
          orderId: string; merchantId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## contentOrderpaymentsNotifycharge
  ## Notify about charge on user's selected payments method.
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
  ##          : The ID of the order for which charge is happening.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580846 = newJObject()
  var query_580847 = newJObject()
  var body_580848 = newJObject()
  add(query_580847, "fields", newJString(fields))
  add(query_580847, "quotaUser", newJString(quotaUser))
  add(query_580847, "alt", newJString(alt))
  add(query_580847, "oauth_token", newJString(oauthToken))
  add(query_580847, "userIp", newJString(userIp))
  add(path_580846, "orderId", newJString(orderId))
  add(query_580847, "key", newJString(key))
  add(path_580846, "merchantId", newJString(merchantId))
  if body != nil:
    body_580848 = body
  add(query_580847, "prettyPrint", newJBool(prettyPrint))
  result = call_580845.call(path_580846, query_580847, nil, nil, body_580848)

var contentOrderpaymentsNotifycharge* = Call_ContentOrderpaymentsNotifycharge_580831(
    name: "contentOrderpaymentsNotifycharge", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderpayments/{orderId}/notifyCharge",
    validator: validate_ContentOrderpaymentsNotifycharge_580832,
    base: "/content/v2", url: url_ContentOrderpaymentsNotifycharge_580833,
    schemes: {Scheme.Https})
type
  Call_ContentOrderpaymentsNotifyrefund_580849 = ref object of OpenApiRestCall_579421
proc url_ContentOrderpaymentsNotifyrefund_580851(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/orderpayments/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/notifyRefund")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrderpaymentsNotifyrefund_580850(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Notify about refund on user's selected payments method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   orderId: JString (required)
  ##          : The ID of the order for which charge is happening.
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `orderId` field"
  var valid_580852 = path.getOrDefault("orderId")
  valid_580852 = validateParameter(valid_580852, JString, required = true,
                                 default = nil)
  if valid_580852 != nil:
    section.add "orderId", valid_580852
  var valid_580853 = path.getOrDefault("merchantId")
  valid_580853 = validateParameter(valid_580853, JString, required = true,
                                 default = nil)
  if valid_580853 != nil:
    section.add "merchantId", valid_580853
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
  var valid_580854 = query.getOrDefault("fields")
  valid_580854 = validateParameter(valid_580854, JString, required = false,
                                 default = nil)
  if valid_580854 != nil:
    section.add "fields", valid_580854
  var valid_580855 = query.getOrDefault("quotaUser")
  valid_580855 = validateParameter(valid_580855, JString, required = false,
                                 default = nil)
  if valid_580855 != nil:
    section.add "quotaUser", valid_580855
  var valid_580856 = query.getOrDefault("alt")
  valid_580856 = validateParameter(valid_580856, JString, required = false,
                                 default = newJString("json"))
  if valid_580856 != nil:
    section.add "alt", valid_580856
  var valid_580857 = query.getOrDefault("oauth_token")
  valid_580857 = validateParameter(valid_580857, JString, required = false,
                                 default = nil)
  if valid_580857 != nil:
    section.add "oauth_token", valid_580857
  var valid_580858 = query.getOrDefault("userIp")
  valid_580858 = validateParameter(valid_580858, JString, required = false,
                                 default = nil)
  if valid_580858 != nil:
    section.add "userIp", valid_580858
  var valid_580859 = query.getOrDefault("key")
  valid_580859 = validateParameter(valid_580859, JString, required = false,
                                 default = nil)
  if valid_580859 != nil:
    section.add "key", valid_580859
  var valid_580860 = query.getOrDefault("prettyPrint")
  valid_580860 = validateParameter(valid_580860, JBool, required = false,
                                 default = newJBool(true))
  if valid_580860 != nil:
    section.add "prettyPrint", valid_580860
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

proc call*(call_580862: Call_ContentOrderpaymentsNotifyrefund_580849;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Notify about refund on user's selected payments method.
  ## 
  let valid = call_580862.validator(path, query, header, formData, body)
  let scheme = call_580862.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580862.url(scheme.get, call_580862.host, call_580862.base,
                         call_580862.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580862, url, valid)

proc call*(call_580863: Call_ContentOrderpaymentsNotifyrefund_580849;
          orderId: string; merchantId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## contentOrderpaymentsNotifyrefund
  ## Notify about refund on user's selected payments method.
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
  ##          : The ID of the order for which charge is happening.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580864 = newJObject()
  var query_580865 = newJObject()
  var body_580866 = newJObject()
  add(query_580865, "fields", newJString(fields))
  add(query_580865, "quotaUser", newJString(quotaUser))
  add(query_580865, "alt", newJString(alt))
  add(query_580865, "oauth_token", newJString(oauthToken))
  add(query_580865, "userIp", newJString(userIp))
  add(path_580864, "orderId", newJString(orderId))
  add(query_580865, "key", newJString(key))
  add(path_580864, "merchantId", newJString(merchantId))
  if body != nil:
    body_580866 = body
  add(query_580865, "prettyPrint", newJBool(prettyPrint))
  result = call_580863.call(path_580864, query_580865, nil, nil, body_580866)

var contentOrderpaymentsNotifyrefund* = Call_ContentOrderpaymentsNotifyrefund_580849(
    name: "contentOrderpaymentsNotifyrefund", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderpayments/{orderId}/notifyRefund",
    validator: validate_ContentOrderpaymentsNotifyrefund_580850,
    base: "/content/v2", url: url_ContentOrderpaymentsNotifyrefund_580851,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreportsListdisbursements_580867 = ref object of OpenApiRestCall_579421
proc url_ContentOrderreportsListdisbursements_580869(protocol: Scheme;
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

proc validate_ContentOrderreportsListdisbursements_580868(path: JsonNode;
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
  var valid_580870 = path.getOrDefault("merchantId")
  valid_580870 = validateParameter(valid_580870, JString, required = true,
                                 default = nil)
  if valid_580870 != nil:
    section.add "merchantId", valid_580870
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
  var valid_580871 = query.getOrDefault("fields")
  valid_580871 = validateParameter(valid_580871, JString, required = false,
                                 default = nil)
  if valid_580871 != nil:
    section.add "fields", valid_580871
  var valid_580872 = query.getOrDefault("pageToken")
  valid_580872 = validateParameter(valid_580872, JString, required = false,
                                 default = nil)
  if valid_580872 != nil:
    section.add "pageToken", valid_580872
  var valid_580873 = query.getOrDefault("quotaUser")
  valid_580873 = validateParameter(valid_580873, JString, required = false,
                                 default = nil)
  if valid_580873 != nil:
    section.add "quotaUser", valid_580873
  var valid_580874 = query.getOrDefault("alt")
  valid_580874 = validateParameter(valid_580874, JString, required = false,
                                 default = newJString("json"))
  if valid_580874 != nil:
    section.add "alt", valid_580874
  var valid_580875 = query.getOrDefault("oauth_token")
  valid_580875 = validateParameter(valid_580875, JString, required = false,
                                 default = nil)
  if valid_580875 != nil:
    section.add "oauth_token", valid_580875
  var valid_580876 = query.getOrDefault("userIp")
  valid_580876 = validateParameter(valid_580876, JString, required = false,
                                 default = nil)
  if valid_580876 != nil:
    section.add "userIp", valid_580876
  var valid_580877 = query.getOrDefault("maxResults")
  valid_580877 = validateParameter(valid_580877, JInt, required = false, default = nil)
  if valid_580877 != nil:
    section.add "maxResults", valid_580877
  var valid_580878 = query.getOrDefault("key")
  valid_580878 = validateParameter(valid_580878, JString, required = false,
                                 default = nil)
  if valid_580878 != nil:
    section.add "key", valid_580878
  var valid_580879 = query.getOrDefault("prettyPrint")
  valid_580879 = validateParameter(valid_580879, JBool, required = false,
                                 default = newJBool(true))
  if valid_580879 != nil:
    section.add "prettyPrint", valid_580879
  assert query != nil, "query argument is necessary due to required `disbursementStartDate` field"
  var valid_580880 = query.getOrDefault("disbursementStartDate")
  valid_580880 = validateParameter(valid_580880, JString, required = true,
                                 default = nil)
  if valid_580880 != nil:
    section.add "disbursementStartDate", valid_580880
  var valid_580881 = query.getOrDefault("disbursementEndDate")
  valid_580881 = validateParameter(valid_580881, JString, required = false,
                                 default = nil)
  if valid_580881 != nil:
    section.add "disbursementEndDate", valid_580881
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580882: Call_ContentOrderreportsListdisbursements_580867;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a report for disbursements from your Merchant Center account.
  ## 
  let valid = call_580882.validator(path, query, header, formData, body)
  let scheme = call_580882.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580882.url(scheme.get, call_580882.host, call_580882.base,
                         call_580882.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580882, url, valid)

proc call*(call_580883: Call_ContentOrderreportsListdisbursements_580867;
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
  var path_580884 = newJObject()
  var query_580885 = newJObject()
  add(query_580885, "fields", newJString(fields))
  add(query_580885, "pageToken", newJString(pageToken))
  add(query_580885, "quotaUser", newJString(quotaUser))
  add(query_580885, "alt", newJString(alt))
  add(query_580885, "oauth_token", newJString(oauthToken))
  add(query_580885, "userIp", newJString(userIp))
  add(query_580885, "maxResults", newJInt(maxResults))
  add(query_580885, "key", newJString(key))
  add(path_580884, "merchantId", newJString(merchantId))
  add(query_580885, "prettyPrint", newJBool(prettyPrint))
  add(query_580885, "disbursementStartDate", newJString(disbursementStartDate))
  add(query_580885, "disbursementEndDate", newJString(disbursementEndDate))
  result = call_580883.call(path_580884, query_580885, nil, nil, nil)

var contentOrderreportsListdisbursements* = Call_ContentOrderreportsListdisbursements_580867(
    name: "contentOrderreportsListdisbursements", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreports/disbursements",
    validator: validate_ContentOrderreportsListdisbursements_580868,
    base: "/content/v2", url: url_ContentOrderreportsListdisbursements_580869,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreportsListtransactions_580886 = ref object of OpenApiRestCall_579421
proc url_ContentOrderreportsListtransactions_580888(protocol: Scheme; host: string;
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

proc validate_ContentOrderreportsListtransactions_580887(path: JsonNode;
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
  var valid_580889 = path.getOrDefault("merchantId")
  valid_580889 = validateParameter(valid_580889, JString, required = true,
                                 default = nil)
  if valid_580889 != nil:
    section.add "merchantId", valid_580889
  var valid_580890 = path.getOrDefault("disbursementId")
  valid_580890 = validateParameter(valid_580890, JString, required = true,
                                 default = nil)
  if valid_580890 != nil:
    section.add "disbursementId", valid_580890
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
  var valid_580891 = query.getOrDefault("fields")
  valid_580891 = validateParameter(valid_580891, JString, required = false,
                                 default = nil)
  if valid_580891 != nil:
    section.add "fields", valid_580891
  var valid_580892 = query.getOrDefault("pageToken")
  valid_580892 = validateParameter(valid_580892, JString, required = false,
                                 default = nil)
  if valid_580892 != nil:
    section.add "pageToken", valid_580892
  var valid_580893 = query.getOrDefault("quotaUser")
  valid_580893 = validateParameter(valid_580893, JString, required = false,
                                 default = nil)
  if valid_580893 != nil:
    section.add "quotaUser", valid_580893
  var valid_580894 = query.getOrDefault("alt")
  valid_580894 = validateParameter(valid_580894, JString, required = false,
                                 default = newJString("json"))
  if valid_580894 != nil:
    section.add "alt", valid_580894
  var valid_580895 = query.getOrDefault("transactionEndDate")
  valid_580895 = validateParameter(valid_580895, JString, required = false,
                                 default = nil)
  if valid_580895 != nil:
    section.add "transactionEndDate", valid_580895
  var valid_580896 = query.getOrDefault("oauth_token")
  valid_580896 = validateParameter(valid_580896, JString, required = false,
                                 default = nil)
  if valid_580896 != nil:
    section.add "oauth_token", valid_580896
  var valid_580897 = query.getOrDefault("userIp")
  valid_580897 = validateParameter(valid_580897, JString, required = false,
                                 default = nil)
  if valid_580897 != nil:
    section.add "userIp", valid_580897
  var valid_580898 = query.getOrDefault("maxResults")
  valid_580898 = validateParameter(valid_580898, JInt, required = false, default = nil)
  if valid_580898 != nil:
    section.add "maxResults", valid_580898
  assert query != nil, "query argument is necessary due to required `transactionStartDate` field"
  var valid_580899 = query.getOrDefault("transactionStartDate")
  valid_580899 = validateParameter(valid_580899, JString, required = true,
                                 default = nil)
  if valid_580899 != nil:
    section.add "transactionStartDate", valid_580899
  var valid_580900 = query.getOrDefault("key")
  valid_580900 = validateParameter(valid_580900, JString, required = false,
                                 default = nil)
  if valid_580900 != nil:
    section.add "key", valid_580900
  var valid_580901 = query.getOrDefault("prettyPrint")
  valid_580901 = validateParameter(valid_580901, JBool, required = false,
                                 default = newJBool(true))
  if valid_580901 != nil:
    section.add "prettyPrint", valid_580901
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580902: Call_ContentOrderreportsListtransactions_580886;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of transactions for a disbursement from your Merchant Center account.
  ## 
  let valid = call_580902.validator(path, query, header, formData, body)
  let scheme = call_580902.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580902.url(scheme.get, call_580902.host, call_580902.base,
                         call_580902.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580902, url, valid)

proc call*(call_580903: Call_ContentOrderreportsListtransactions_580886;
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
  var path_580904 = newJObject()
  var query_580905 = newJObject()
  add(query_580905, "fields", newJString(fields))
  add(query_580905, "pageToken", newJString(pageToken))
  add(query_580905, "quotaUser", newJString(quotaUser))
  add(query_580905, "alt", newJString(alt))
  add(query_580905, "transactionEndDate", newJString(transactionEndDate))
  add(query_580905, "oauth_token", newJString(oauthToken))
  add(query_580905, "userIp", newJString(userIp))
  add(query_580905, "maxResults", newJInt(maxResults))
  add(query_580905, "transactionStartDate", newJString(transactionStartDate))
  add(query_580905, "key", newJString(key))
  add(path_580904, "merchantId", newJString(merchantId))
  add(path_580904, "disbursementId", newJString(disbursementId))
  add(query_580905, "prettyPrint", newJBool(prettyPrint))
  result = call_580903.call(path_580904, query_580905, nil, nil, nil)

var contentOrderreportsListtransactions* = Call_ContentOrderreportsListtransactions_580886(
    name: "contentOrderreportsListtransactions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreports/disbursements/{disbursementId}/transactions",
    validator: validate_ContentOrderreportsListtransactions_580887,
    base: "/content/v2", url: url_ContentOrderreportsListtransactions_580888,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreturnsList_580906 = ref object of OpenApiRestCall_579421
proc url_ContentOrderreturnsList_580908(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrderreturnsList_580907(path: JsonNode; query: JsonNode;
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
  var valid_580909 = path.getOrDefault("merchantId")
  valid_580909 = validateParameter(valid_580909, JString, required = true,
                                 default = nil)
  if valid_580909 != nil:
    section.add "merchantId", valid_580909
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
  var valid_580910 = query.getOrDefault("fields")
  valid_580910 = validateParameter(valid_580910, JString, required = false,
                                 default = nil)
  if valid_580910 != nil:
    section.add "fields", valid_580910
  var valid_580911 = query.getOrDefault("pageToken")
  valid_580911 = validateParameter(valid_580911, JString, required = false,
                                 default = nil)
  if valid_580911 != nil:
    section.add "pageToken", valid_580911
  var valid_580912 = query.getOrDefault("quotaUser")
  valid_580912 = validateParameter(valid_580912, JString, required = false,
                                 default = nil)
  if valid_580912 != nil:
    section.add "quotaUser", valid_580912
  var valid_580913 = query.getOrDefault("alt")
  valid_580913 = validateParameter(valid_580913, JString, required = false,
                                 default = newJString("json"))
  if valid_580913 != nil:
    section.add "alt", valid_580913
  var valid_580914 = query.getOrDefault("oauth_token")
  valid_580914 = validateParameter(valid_580914, JString, required = false,
                                 default = nil)
  if valid_580914 != nil:
    section.add "oauth_token", valid_580914
  var valid_580915 = query.getOrDefault("userIp")
  valid_580915 = validateParameter(valid_580915, JString, required = false,
                                 default = nil)
  if valid_580915 != nil:
    section.add "userIp", valid_580915
  var valid_580916 = query.getOrDefault("maxResults")
  valid_580916 = validateParameter(valid_580916, JInt, required = false, default = nil)
  if valid_580916 != nil:
    section.add "maxResults", valid_580916
  var valid_580917 = query.getOrDefault("orderBy")
  valid_580917 = validateParameter(valid_580917, JString, required = false,
                                 default = newJString("returnCreationTimeAsc"))
  if valid_580917 != nil:
    section.add "orderBy", valid_580917
  var valid_580918 = query.getOrDefault("key")
  valid_580918 = validateParameter(valid_580918, JString, required = false,
                                 default = nil)
  if valid_580918 != nil:
    section.add "key", valid_580918
  var valid_580919 = query.getOrDefault("createdEndDate")
  valid_580919 = validateParameter(valid_580919, JString, required = false,
                                 default = nil)
  if valid_580919 != nil:
    section.add "createdEndDate", valid_580919
  var valid_580920 = query.getOrDefault("prettyPrint")
  valid_580920 = validateParameter(valid_580920, JBool, required = false,
                                 default = newJBool(true))
  if valid_580920 != nil:
    section.add "prettyPrint", valid_580920
  var valid_580921 = query.getOrDefault("createdStartDate")
  valid_580921 = validateParameter(valid_580921, JString, required = false,
                                 default = nil)
  if valid_580921 != nil:
    section.add "createdStartDate", valid_580921
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580922: Call_ContentOrderreturnsList_580906; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists order returns in your Merchant Center account.
  ## 
  let valid = call_580922.validator(path, query, header, formData, body)
  let scheme = call_580922.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580922.url(scheme.get, call_580922.host, call_580922.base,
                         call_580922.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580922, url, valid)

proc call*(call_580923: Call_ContentOrderreturnsList_580906; merchantId: string;
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
  var path_580924 = newJObject()
  var query_580925 = newJObject()
  add(query_580925, "fields", newJString(fields))
  add(query_580925, "pageToken", newJString(pageToken))
  add(query_580925, "quotaUser", newJString(quotaUser))
  add(query_580925, "alt", newJString(alt))
  add(query_580925, "oauth_token", newJString(oauthToken))
  add(query_580925, "userIp", newJString(userIp))
  add(query_580925, "maxResults", newJInt(maxResults))
  add(query_580925, "orderBy", newJString(orderBy))
  add(query_580925, "key", newJString(key))
  add(query_580925, "createdEndDate", newJString(createdEndDate))
  add(path_580924, "merchantId", newJString(merchantId))
  add(query_580925, "prettyPrint", newJBool(prettyPrint))
  add(query_580925, "createdStartDate", newJString(createdStartDate))
  result = call_580923.call(path_580924, query_580925, nil, nil, nil)

var contentOrderreturnsList* = Call_ContentOrderreturnsList_580906(
    name: "contentOrderreturnsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreturns",
    validator: validate_ContentOrderreturnsList_580907, base: "/content/v2",
    url: url_ContentOrderreturnsList_580908, schemes: {Scheme.Https})
type
  Call_ContentOrderreturnsGet_580926 = ref object of OpenApiRestCall_579421
proc url_ContentOrderreturnsGet_580928(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrderreturnsGet_580927(path: JsonNode; query: JsonNode;
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
  var valid_580929 = path.getOrDefault("returnId")
  valid_580929 = validateParameter(valid_580929, JString, required = true,
                                 default = nil)
  if valid_580929 != nil:
    section.add "returnId", valid_580929
  var valid_580930 = path.getOrDefault("merchantId")
  valid_580930 = validateParameter(valid_580930, JString, required = true,
                                 default = nil)
  if valid_580930 != nil:
    section.add "merchantId", valid_580930
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
  var valid_580931 = query.getOrDefault("fields")
  valid_580931 = validateParameter(valid_580931, JString, required = false,
                                 default = nil)
  if valid_580931 != nil:
    section.add "fields", valid_580931
  var valid_580932 = query.getOrDefault("quotaUser")
  valid_580932 = validateParameter(valid_580932, JString, required = false,
                                 default = nil)
  if valid_580932 != nil:
    section.add "quotaUser", valid_580932
  var valid_580933 = query.getOrDefault("alt")
  valid_580933 = validateParameter(valid_580933, JString, required = false,
                                 default = newJString("json"))
  if valid_580933 != nil:
    section.add "alt", valid_580933
  var valid_580934 = query.getOrDefault("oauth_token")
  valid_580934 = validateParameter(valid_580934, JString, required = false,
                                 default = nil)
  if valid_580934 != nil:
    section.add "oauth_token", valid_580934
  var valid_580935 = query.getOrDefault("userIp")
  valid_580935 = validateParameter(valid_580935, JString, required = false,
                                 default = nil)
  if valid_580935 != nil:
    section.add "userIp", valid_580935
  var valid_580936 = query.getOrDefault("key")
  valid_580936 = validateParameter(valid_580936, JString, required = false,
                                 default = nil)
  if valid_580936 != nil:
    section.add "key", valid_580936
  var valid_580937 = query.getOrDefault("prettyPrint")
  valid_580937 = validateParameter(valid_580937, JBool, required = false,
                                 default = newJBool(true))
  if valid_580937 != nil:
    section.add "prettyPrint", valid_580937
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580938: Call_ContentOrderreturnsGet_580926; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an order return from your Merchant Center account.
  ## 
  let valid = call_580938.validator(path, query, header, formData, body)
  let scheme = call_580938.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580938.url(scheme.get, call_580938.host, call_580938.base,
                         call_580938.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580938, url, valid)

proc call*(call_580939: Call_ContentOrderreturnsGet_580926; returnId: string;
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
  var path_580940 = newJObject()
  var query_580941 = newJObject()
  add(query_580941, "fields", newJString(fields))
  add(query_580941, "quotaUser", newJString(quotaUser))
  add(path_580940, "returnId", newJString(returnId))
  add(query_580941, "alt", newJString(alt))
  add(query_580941, "oauth_token", newJString(oauthToken))
  add(query_580941, "userIp", newJString(userIp))
  add(query_580941, "key", newJString(key))
  add(path_580940, "merchantId", newJString(merchantId))
  add(query_580941, "prettyPrint", newJBool(prettyPrint))
  result = call_580939.call(path_580940, query_580941, nil, nil, nil)

var contentOrderreturnsGet* = Call_ContentOrderreturnsGet_580926(
    name: "contentOrderreturnsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreturns/{returnId}",
    validator: validate_ContentOrderreturnsGet_580927, base: "/content/v2",
    url: url_ContentOrderreturnsGet_580928, schemes: {Scheme.Https})
type
  Call_ContentOrdersList_580942 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersList_580944(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrdersList_580943(path: JsonNode; query: JsonNode;
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
  var valid_580945 = path.getOrDefault("merchantId")
  valid_580945 = validateParameter(valid_580945, JString, required = true,
                                 default = nil)
  if valid_580945 != nil:
    section.add "merchantId", valid_580945
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
  var valid_580946 = query.getOrDefault("fields")
  valid_580946 = validateParameter(valid_580946, JString, required = false,
                                 default = nil)
  if valid_580946 != nil:
    section.add "fields", valid_580946
  var valid_580947 = query.getOrDefault("pageToken")
  valid_580947 = validateParameter(valid_580947, JString, required = false,
                                 default = nil)
  if valid_580947 != nil:
    section.add "pageToken", valid_580947
  var valid_580948 = query.getOrDefault("quotaUser")
  valid_580948 = validateParameter(valid_580948, JString, required = false,
                                 default = nil)
  if valid_580948 != nil:
    section.add "quotaUser", valid_580948
  var valid_580949 = query.getOrDefault("alt")
  valid_580949 = validateParameter(valid_580949, JString, required = false,
                                 default = newJString("json"))
  if valid_580949 != nil:
    section.add "alt", valid_580949
  var valid_580950 = query.getOrDefault("placedDateStart")
  valid_580950 = validateParameter(valid_580950, JString, required = false,
                                 default = nil)
  if valid_580950 != nil:
    section.add "placedDateStart", valid_580950
  var valid_580951 = query.getOrDefault("oauth_token")
  valid_580951 = validateParameter(valid_580951, JString, required = false,
                                 default = nil)
  if valid_580951 != nil:
    section.add "oauth_token", valid_580951
  var valid_580952 = query.getOrDefault("userIp")
  valid_580952 = validateParameter(valid_580952, JString, required = false,
                                 default = nil)
  if valid_580952 != nil:
    section.add "userIp", valid_580952
  var valid_580953 = query.getOrDefault("maxResults")
  valid_580953 = validateParameter(valid_580953, JInt, required = false, default = nil)
  if valid_580953 != nil:
    section.add "maxResults", valid_580953
  var valid_580954 = query.getOrDefault("orderBy")
  valid_580954 = validateParameter(valid_580954, JString, required = false,
                                 default = nil)
  if valid_580954 != nil:
    section.add "orderBy", valid_580954
  var valid_580955 = query.getOrDefault("placedDateEnd")
  valid_580955 = validateParameter(valid_580955, JString, required = false,
                                 default = nil)
  if valid_580955 != nil:
    section.add "placedDateEnd", valid_580955
  var valid_580956 = query.getOrDefault("key")
  valid_580956 = validateParameter(valid_580956, JString, required = false,
                                 default = nil)
  if valid_580956 != nil:
    section.add "key", valid_580956
  var valid_580957 = query.getOrDefault("acknowledged")
  valid_580957 = validateParameter(valid_580957, JBool, required = false, default = nil)
  if valid_580957 != nil:
    section.add "acknowledged", valid_580957
  var valid_580958 = query.getOrDefault("prettyPrint")
  valid_580958 = validateParameter(valid_580958, JBool, required = false,
                                 default = newJBool(true))
  if valid_580958 != nil:
    section.add "prettyPrint", valid_580958
  var valid_580959 = query.getOrDefault("statuses")
  valid_580959 = validateParameter(valid_580959, JArray, required = false,
                                 default = nil)
  if valid_580959 != nil:
    section.add "statuses", valid_580959
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580960: Call_ContentOrdersList_580942; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the orders in your Merchant Center account.
  ## 
  let valid = call_580960.validator(path, query, header, formData, body)
  let scheme = call_580960.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580960.url(scheme.get, call_580960.host, call_580960.base,
                         call_580960.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580960, url, valid)

proc call*(call_580961: Call_ContentOrdersList_580942; merchantId: string;
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
  var path_580962 = newJObject()
  var query_580963 = newJObject()
  add(query_580963, "fields", newJString(fields))
  add(query_580963, "pageToken", newJString(pageToken))
  add(query_580963, "quotaUser", newJString(quotaUser))
  add(query_580963, "alt", newJString(alt))
  add(query_580963, "placedDateStart", newJString(placedDateStart))
  add(query_580963, "oauth_token", newJString(oauthToken))
  add(query_580963, "userIp", newJString(userIp))
  add(query_580963, "maxResults", newJInt(maxResults))
  add(query_580963, "orderBy", newJString(orderBy))
  add(query_580963, "placedDateEnd", newJString(placedDateEnd))
  add(query_580963, "key", newJString(key))
  add(path_580962, "merchantId", newJString(merchantId))
  add(query_580963, "acknowledged", newJBool(acknowledged))
  add(query_580963, "prettyPrint", newJBool(prettyPrint))
  if statuses != nil:
    query_580963.add "statuses", statuses
  result = call_580961.call(path_580962, query_580963, nil, nil, nil)

var contentOrdersList* = Call_ContentOrdersList_580942(name: "contentOrdersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/orders", validator: validate_ContentOrdersList_580943,
    base: "/content/v2", url: url_ContentOrdersList_580944, schemes: {Scheme.Https})
type
  Call_ContentOrdersGet_580964 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersGet_580966(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrdersGet_580965(path: JsonNode; query: JsonNode;
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
  var valid_580967 = path.getOrDefault("orderId")
  valid_580967 = validateParameter(valid_580967, JString, required = true,
                                 default = nil)
  if valid_580967 != nil:
    section.add "orderId", valid_580967
  var valid_580968 = path.getOrDefault("merchantId")
  valid_580968 = validateParameter(valid_580968, JString, required = true,
                                 default = nil)
  if valid_580968 != nil:
    section.add "merchantId", valid_580968
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
  var valid_580969 = query.getOrDefault("fields")
  valid_580969 = validateParameter(valid_580969, JString, required = false,
                                 default = nil)
  if valid_580969 != nil:
    section.add "fields", valid_580969
  var valid_580970 = query.getOrDefault("quotaUser")
  valid_580970 = validateParameter(valid_580970, JString, required = false,
                                 default = nil)
  if valid_580970 != nil:
    section.add "quotaUser", valid_580970
  var valid_580971 = query.getOrDefault("alt")
  valid_580971 = validateParameter(valid_580971, JString, required = false,
                                 default = newJString("json"))
  if valid_580971 != nil:
    section.add "alt", valid_580971
  var valid_580972 = query.getOrDefault("oauth_token")
  valid_580972 = validateParameter(valid_580972, JString, required = false,
                                 default = nil)
  if valid_580972 != nil:
    section.add "oauth_token", valid_580972
  var valid_580973 = query.getOrDefault("userIp")
  valid_580973 = validateParameter(valid_580973, JString, required = false,
                                 default = nil)
  if valid_580973 != nil:
    section.add "userIp", valid_580973
  var valid_580974 = query.getOrDefault("key")
  valid_580974 = validateParameter(valid_580974, JString, required = false,
                                 default = nil)
  if valid_580974 != nil:
    section.add "key", valid_580974
  var valid_580975 = query.getOrDefault("prettyPrint")
  valid_580975 = validateParameter(valid_580975, JBool, required = false,
                                 default = newJBool(true))
  if valid_580975 != nil:
    section.add "prettyPrint", valid_580975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580976: Call_ContentOrdersGet_580964; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an order from your Merchant Center account.
  ## 
  let valid = call_580976.validator(path, query, header, formData, body)
  let scheme = call_580976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580976.url(scheme.get, call_580976.host, call_580976.base,
                         call_580976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580976, url, valid)

proc call*(call_580977: Call_ContentOrdersGet_580964; orderId: string;
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
  var path_580978 = newJObject()
  var query_580979 = newJObject()
  add(query_580979, "fields", newJString(fields))
  add(query_580979, "quotaUser", newJString(quotaUser))
  add(query_580979, "alt", newJString(alt))
  add(query_580979, "oauth_token", newJString(oauthToken))
  add(query_580979, "userIp", newJString(userIp))
  add(path_580978, "orderId", newJString(orderId))
  add(query_580979, "key", newJString(key))
  add(path_580978, "merchantId", newJString(merchantId))
  add(query_580979, "prettyPrint", newJBool(prettyPrint))
  result = call_580977.call(path_580978, query_580979, nil, nil, nil)

var contentOrdersGet* = Call_ContentOrdersGet_580964(name: "contentOrdersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}", validator: validate_ContentOrdersGet_580965,
    base: "/content/v2", url: url_ContentOrdersGet_580966, schemes: {Scheme.Https})
type
  Call_ContentOrdersAcknowledge_580980 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersAcknowledge_580982(protocol: Scheme; host: string;
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

proc validate_ContentOrdersAcknowledge_580981(path: JsonNode; query: JsonNode;
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
  var valid_580983 = path.getOrDefault("orderId")
  valid_580983 = validateParameter(valid_580983, JString, required = true,
                                 default = nil)
  if valid_580983 != nil:
    section.add "orderId", valid_580983
  var valid_580984 = path.getOrDefault("merchantId")
  valid_580984 = validateParameter(valid_580984, JString, required = true,
                                 default = nil)
  if valid_580984 != nil:
    section.add "merchantId", valid_580984
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
  var valid_580985 = query.getOrDefault("fields")
  valid_580985 = validateParameter(valid_580985, JString, required = false,
                                 default = nil)
  if valid_580985 != nil:
    section.add "fields", valid_580985
  var valid_580986 = query.getOrDefault("quotaUser")
  valid_580986 = validateParameter(valid_580986, JString, required = false,
                                 default = nil)
  if valid_580986 != nil:
    section.add "quotaUser", valid_580986
  var valid_580987 = query.getOrDefault("alt")
  valid_580987 = validateParameter(valid_580987, JString, required = false,
                                 default = newJString("json"))
  if valid_580987 != nil:
    section.add "alt", valid_580987
  var valid_580988 = query.getOrDefault("oauth_token")
  valid_580988 = validateParameter(valid_580988, JString, required = false,
                                 default = nil)
  if valid_580988 != nil:
    section.add "oauth_token", valid_580988
  var valid_580989 = query.getOrDefault("userIp")
  valid_580989 = validateParameter(valid_580989, JString, required = false,
                                 default = nil)
  if valid_580989 != nil:
    section.add "userIp", valid_580989
  var valid_580990 = query.getOrDefault("key")
  valid_580990 = validateParameter(valid_580990, JString, required = false,
                                 default = nil)
  if valid_580990 != nil:
    section.add "key", valid_580990
  var valid_580991 = query.getOrDefault("prettyPrint")
  valid_580991 = validateParameter(valid_580991, JBool, required = false,
                                 default = newJBool(true))
  if valid_580991 != nil:
    section.add "prettyPrint", valid_580991
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

proc call*(call_580993: Call_ContentOrdersAcknowledge_580980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks an order as acknowledged.
  ## 
  let valid = call_580993.validator(path, query, header, formData, body)
  let scheme = call_580993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580993.url(scheme.get, call_580993.host, call_580993.base,
                         call_580993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580993, url, valid)

proc call*(call_580994: Call_ContentOrdersAcknowledge_580980; orderId: string;
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
  var path_580995 = newJObject()
  var query_580996 = newJObject()
  var body_580997 = newJObject()
  add(query_580996, "fields", newJString(fields))
  add(query_580996, "quotaUser", newJString(quotaUser))
  add(query_580996, "alt", newJString(alt))
  add(query_580996, "oauth_token", newJString(oauthToken))
  add(query_580996, "userIp", newJString(userIp))
  add(path_580995, "orderId", newJString(orderId))
  add(query_580996, "key", newJString(key))
  add(path_580995, "merchantId", newJString(merchantId))
  if body != nil:
    body_580997 = body
  add(query_580996, "prettyPrint", newJBool(prettyPrint))
  result = call_580994.call(path_580995, query_580996, nil, nil, body_580997)

var contentOrdersAcknowledge* = Call_ContentOrdersAcknowledge_580980(
    name: "contentOrdersAcknowledge", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/acknowledge",
    validator: validate_ContentOrdersAcknowledge_580981, base: "/content/v2",
    url: url_ContentOrdersAcknowledge_580982, schemes: {Scheme.Https})
type
  Call_ContentOrdersCancel_580998 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersCancel_581000(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrdersCancel_580999(path: JsonNode; query: JsonNode;
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
  var valid_581001 = path.getOrDefault("orderId")
  valid_581001 = validateParameter(valid_581001, JString, required = true,
                                 default = nil)
  if valid_581001 != nil:
    section.add "orderId", valid_581001
  var valid_581002 = path.getOrDefault("merchantId")
  valid_581002 = validateParameter(valid_581002, JString, required = true,
                                 default = nil)
  if valid_581002 != nil:
    section.add "merchantId", valid_581002
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
  var valid_581003 = query.getOrDefault("fields")
  valid_581003 = validateParameter(valid_581003, JString, required = false,
                                 default = nil)
  if valid_581003 != nil:
    section.add "fields", valid_581003
  var valid_581004 = query.getOrDefault("quotaUser")
  valid_581004 = validateParameter(valid_581004, JString, required = false,
                                 default = nil)
  if valid_581004 != nil:
    section.add "quotaUser", valid_581004
  var valid_581005 = query.getOrDefault("alt")
  valid_581005 = validateParameter(valid_581005, JString, required = false,
                                 default = newJString("json"))
  if valid_581005 != nil:
    section.add "alt", valid_581005
  var valid_581006 = query.getOrDefault("oauth_token")
  valid_581006 = validateParameter(valid_581006, JString, required = false,
                                 default = nil)
  if valid_581006 != nil:
    section.add "oauth_token", valid_581006
  var valid_581007 = query.getOrDefault("userIp")
  valid_581007 = validateParameter(valid_581007, JString, required = false,
                                 default = nil)
  if valid_581007 != nil:
    section.add "userIp", valid_581007
  var valid_581008 = query.getOrDefault("key")
  valid_581008 = validateParameter(valid_581008, JString, required = false,
                                 default = nil)
  if valid_581008 != nil:
    section.add "key", valid_581008
  var valid_581009 = query.getOrDefault("prettyPrint")
  valid_581009 = validateParameter(valid_581009, JBool, required = false,
                                 default = newJBool(true))
  if valid_581009 != nil:
    section.add "prettyPrint", valid_581009
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

proc call*(call_581011: Call_ContentOrdersCancel_580998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels all line items in an order, making a full refund.
  ## 
  let valid = call_581011.validator(path, query, header, formData, body)
  let scheme = call_581011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581011.url(scheme.get, call_581011.host, call_581011.base,
                         call_581011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581011, url, valid)

proc call*(call_581012: Call_ContentOrdersCancel_580998; orderId: string;
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
  var path_581013 = newJObject()
  var query_581014 = newJObject()
  var body_581015 = newJObject()
  add(query_581014, "fields", newJString(fields))
  add(query_581014, "quotaUser", newJString(quotaUser))
  add(query_581014, "alt", newJString(alt))
  add(query_581014, "oauth_token", newJString(oauthToken))
  add(query_581014, "userIp", newJString(userIp))
  add(path_581013, "orderId", newJString(orderId))
  add(query_581014, "key", newJString(key))
  add(path_581013, "merchantId", newJString(merchantId))
  if body != nil:
    body_581015 = body
  add(query_581014, "prettyPrint", newJBool(prettyPrint))
  result = call_581012.call(path_581013, query_581014, nil, nil, body_581015)

var contentOrdersCancel* = Call_ContentOrdersCancel_580998(
    name: "contentOrdersCancel", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/orders/{orderId}/cancel",
    validator: validate_ContentOrdersCancel_580999, base: "/content/v2",
    url: url_ContentOrdersCancel_581000, schemes: {Scheme.Https})
type
  Call_ContentOrdersCancellineitem_581016 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersCancellineitem_581018(protocol: Scheme; host: string;
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

proc validate_ContentOrdersCancellineitem_581017(path: JsonNode; query: JsonNode;
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
  var valid_581019 = path.getOrDefault("orderId")
  valid_581019 = validateParameter(valid_581019, JString, required = true,
                                 default = nil)
  if valid_581019 != nil:
    section.add "orderId", valid_581019
  var valid_581020 = path.getOrDefault("merchantId")
  valid_581020 = validateParameter(valid_581020, JString, required = true,
                                 default = nil)
  if valid_581020 != nil:
    section.add "merchantId", valid_581020
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
  var valid_581021 = query.getOrDefault("fields")
  valid_581021 = validateParameter(valid_581021, JString, required = false,
                                 default = nil)
  if valid_581021 != nil:
    section.add "fields", valid_581021
  var valid_581022 = query.getOrDefault("quotaUser")
  valid_581022 = validateParameter(valid_581022, JString, required = false,
                                 default = nil)
  if valid_581022 != nil:
    section.add "quotaUser", valid_581022
  var valid_581023 = query.getOrDefault("alt")
  valid_581023 = validateParameter(valid_581023, JString, required = false,
                                 default = newJString("json"))
  if valid_581023 != nil:
    section.add "alt", valid_581023
  var valid_581024 = query.getOrDefault("oauth_token")
  valid_581024 = validateParameter(valid_581024, JString, required = false,
                                 default = nil)
  if valid_581024 != nil:
    section.add "oauth_token", valid_581024
  var valid_581025 = query.getOrDefault("userIp")
  valid_581025 = validateParameter(valid_581025, JString, required = false,
                                 default = nil)
  if valid_581025 != nil:
    section.add "userIp", valid_581025
  var valid_581026 = query.getOrDefault("key")
  valid_581026 = validateParameter(valid_581026, JString, required = false,
                                 default = nil)
  if valid_581026 != nil:
    section.add "key", valid_581026
  var valid_581027 = query.getOrDefault("prettyPrint")
  valid_581027 = validateParameter(valid_581027, JBool, required = false,
                                 default = newJBool(true))
  if valid_581027 != nil:
    section.add "prettyPrint", valid_581027
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

proc call*(call_581029: Call_ContentOrdersCancellineitem_581016; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a line item, making a full refund.
  ## 
  let valid = call_581029.validator(path, query, header, formData, body)
  let scheme = call_581029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581029.url(scheme.get, call_581029.host, call_581029.base,
                         call_581029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581029, url, valid)

proc call*(call_581030: Call_ContentOrdersCancellineitem_581016; orderId: string;
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
  var path_581031 = newJObject()
  var query_581032 = newJObject()
  var body_581033 = newJObject()
  add(query_581032, "fields", newJString(fields))
  add(query_581032, "quotaUser", newJString(quotaUser))
  add(query_581032, "alt", newJString(alt))
  add(query_581032, "oauth_token", newJString(oauthToken))
  add(query_581032, "userIp", newJString(userIp))
  add(path_581031, "orderId", newJString(orderId))
  add(query_581032, "key", newJString(key))
  add(path_581031, "merchantId", newJString(merchantId))
  if body != nil:
    body_581033 = body
  add(query_581032, "prettyPrint", newJBool(prettyPrint))
  result = call_581030.call(path_581031, query_581032, nil, nil, body_581033)

var contentOrdersCancellineitem* = Call_ContentOrdersCancellineitem_581016(
    name: "contentOrdersCancellineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/cancelLineItem",
    validator: validate_ContentOrdersCancellineitem_581017, base: "/content/v2",
    url: url_ContentOrdersCancellineitem_581018, schemes: {Scheme.Https})
type
  Call_ContentOrdersInstorerefundlineitem_581034 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersInstorerefundlineitem_581036(protocol: Scheme; host: string;
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

proc validate_ContentOrdersInstorerefundlineitem_581035(path: JsonNode;
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
  var valid_581037 = path.getOrDefault("orderId")
  valid_581037 = validateParameter(valid_581037, JString, required = true,
                                 default = nil)
  if valid_581037 != nil:
    section.add "orderId", valid_581037
  var valid_581038 = path.getOrDefault("merchantId")
  valid_581038 = validateParameter(valid_581038, JString, required = true,
                                 default = nil)
  if valid_581038 != nil:
    section.add "merchantId", valid_581038
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
  var valid_581039 = query.getOrDefault("fields")
  valid_581039 = validateParameter(valid_581039, JString, required = false,
                                 default = nil)
  if valid_581039 != nil:
    section.add "fields", valid_581039
  var valid_581040 = query.getOrDefault("quotaUser")
  valid_581040 = validateParameter(valid_581040, JString, required = false,
                                 default = nil)
  if valid_581040 != nil:
    section.add "quotaUser", valid_581040
  var valid_581041 = query.getOrDefault("alt")
  valid_581041 = validateParameter(valid_581041, JString, required = false,
                                 default = newJString("json"))
  if valid_581041 != nil:
    section.add "alt", valid_581041
  var valid_581042 = query.getOrDefault("oauth_token")
  valid_581042 = validateParameter(valid_581042, JString, required = false,
                                 default = nil)
  if valid_581042 != nil:
    section.add "oauth_token", valid_581042
  var valid_581043 = query.getOrDefault("userIp")
  valid_581043 = validateParameter(valid_581043, JString, required = false,
                                 default = nil)
  if valid_581043 != nil:
    section.add "userIp", valid_581043
  var valid_581044 = query.getOrDefault("key")
  valid_581044 = validateParameter(valid_581044, JString, required = false,
                                 default = nil)
  if valid_581044 != nil:
    section.add "key", valid_581044
  var valid_581045 = query.getOrDefault("prettyPrint")
  valid_581045 = validateParameter(valid_581045, JBool, required = false,
                                 default = newJBool(true))
  if valid_581045 != nil:
    section.add "prettyPrint", valid_581045
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

proc call*(call_581047: Call_ContentOrdersInstorerefundlineitem_581034;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deprecated. Notifies that item return and refund was handled directly by merchant outside of Google payments processing (e.g. cash refund done in store).
  ## Note: We recommend calling the returnrefundlineitem method to refund in-store returns. We will issue the refund directly to the customer. This helps to prevent possible differences arising between merchant and Google transaction records. We also recommend having the point of sale system communicate with Google to ensure that customers do not receive a double refund by first refunding via Google then via an in-store return.
  ## 
  let valid = call_581047.validator(path, query, header, formData, body)
  let scheme = call_581047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581047.url(scheme.get, call_581047.host, call_581047.base,
                         call_581047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581047, url, valid)

proc call*(call_581048: Call_ContentOrdersInstorerefundlineitem_581034;
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
  var path_581049 = newJObject()
  var query_581050 = newJObject()
  var body_581051 = newJObject()
  add(query_581050, "fields", newJString(fields))
  add(query_581050, "quotaUser", newJString(quotaUser))
  add(query_581050, "alt", newJString(alt))
  add(query_581050, "oauth_token", newJString(oauthToken))
  add(query_581050, "userIp", newJString(userIp))
  add(path_581049, "orderId", newJString(orderId))
  add(query_581050, "key", newJString(key))
  add(path_581049, "merchantId", newJString(merchantId))
  if body != nil:
    body_581051 = body
  add(query_581050, "prettyPrint", newJBool(prettyPrint))
  result = call_581048.call(path_581049, query_581050, nil, nil, body_581051)

var contentOrdersInstorerefundlineitem* = Call_ContentOrdersInstorerefundlineitem_581034(
    name: "contentOrdersInstorerefundlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/inStoreRefundLineItem",
    validator: validate_ContentOrdersInstorerefundlineitem_581035,
    base: "/content/v2", url: url_ContentOrdersInstorerefundlineitem_581036,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersRefund_581052 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersRefund_581054(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/refund")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersRefund_581053(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deprecated, please use returnRefundLineItem instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   orderId: JString (required)
  ##          : The ID of the order to refund.
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `orderId` field"
  var valid_581055 = path.getOrDefault("orderId")
  valid_581055 = validateParameter(valid_581055, JString, required = true,
                                 default = nil)
  if valid_581055 != nil:
    section.add "orderId", valid_581055
  var valid_581056 = path.getOrDefault("merchantId")
  valid_581056 = validateParameter(valid_581056, JString, required = true,
                                 default = nil)
  if valid_581056 != nil:
    section.add "merchantId", valid_581056
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
  var valid_581057 = query.getOrDefault("fields")
  valid_581057 = validateParameter(valid_581057, JString, required = false,
                                 default = nil)
  if valid_581057 != nil:
    section.add "fields", valid_581057
  var valid_581058 = query.getOrDefault("quotaUser")
  valid_581058 = validateParameter(valid_581058, JString, required = false,
                                 default = nil)
  if valid_581058 != nil:
    section.add "quotaUser", valid_581058
  var valid_581059 = query.getOrDefault("alt")
  valid_581059 = validateParameter(valid_581059, JString, required = false,
                                 default = newJString("json"))
  if valid_581059 != nil:
    section.add "alt", valid_581059
  var valid_581060 = query.getOrDefault("oauth_token")
  valid_581060 = validateParameter(valid_581060, JString, required = false,
                                 default = nil)
  if valid_581060 != nil:
    section.add "oauth_token", valid_581060
  var valid_581061 = query.getOrDefault("userIp")
  valid_581061 = validateParameter(valid_581061, JString, required = false,
                                 default = nil)
  if valid_581061 != nil:
    section.add "userIp", valid_581061
  var valid_581062 = query.getOrDefault("key")
  valid_581062 = validateParameter(valid_581062, JString, required = false,
                                 default = nil)
  if valid_581062 != nil:
    section.add "key", valid_581062
  var valid_581063 = query.getOrDefault("prettyPrint")
  valid_581063 = validateParameter(valid_581063, JBool, required = false,
                                 default = newJBool(true))
  if valid_581063 != nil:
    section.add "prettyPrint", valid_581063
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

proc call*(call_581065: Call_ContentOrdersRefund_581052; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated, please use returnRefundLineItem instead.
  ## 
  let valid = call_581065.validator(path, query, header, formData, body)
  let scheme = call_581065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581065.url(scheme.get, call_581065.host, call_581065.base,
                         call_581065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581065, url, valid)

proc call*(call_581066: Call_ContentOrdersRefund_581052; orderId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentOrdersRefund
  ## Deprecated, please use returnRefundLineItem instead.
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
  ##          : The ID of the order to refund.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581067 = newJObject()
  var query_581068 = newJObject()
  var body_581069 = newJObject()
  add(query_581068, "fields", newJString(fields))
  add(query_581068, "quotaUser", newJString(quotaUser))
  add(query_581068, "alt", newJString(alt))
  add(query_581068, "oauth_token", newJString(oauthToken))
  add(query_581068, "userIp", newJString(userIp))
  add(path_581067, "orderId", newJString(orderId))
  add(query_581068, "key", newJString(key))
  add(path_581067, "merchantId", newJString(merchantId))
  if body != nil:
    body_581069 = body
  add(query_581068, "prettyPrint", newJBool(prettyPrint))
  result = call_581066.call(path_581067, query_581068, nil, nil, body_581069)

var contentOrdersRefund* = Call_ContentOrdersRefund_581052(
    name: "contentOrdersRefund", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/orders/{orderId}/refund",
    validator: validate_ContentOrdersRefund_581053, base: "/content/v2",
    url: url_ContentOrdersRefund_581054, schemes: {Scheme.Https})
type
  Call_ContentOrdersRejectreturnlineitem_581070 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersRejectreturnlineitem_581072(protocol: Scheme; host: string;
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

proc validate_ContentOrdersRejectreturnlineitem_581071(path: JsonNode;
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
  var valid_581073 = path.getOrDefault("orderId")
  valid_581073 = validateParameter(valid_581073, JString, required = true,
                                 default = nil)
  if valid_581073 != nil:
    section.add "orderId", valid_581073
  var valid_581074 = path.getOrDefault("merchantId")
  valid_581074 = validateParameter(valid_581074, JString, required = true,
                                 default = nil)
  if valid_581074 != nil:
    section.add "merchantId", valid_581074
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
  var valid_581075 = query.getOrDefault("fields")
  valid_581075 = validateParameter(valid_581075, JString, required = false,
                                 default = nil)
  if valid_581075 != nil:
    section.add "fields", valid_581075
  var valid_581076 = query.getOrDefault("quotaUser")
  valid_581076 = validateParameter(valid_581076, JString, required = false,
                                 default = nil)
  if valid_581076 != nil:
    section.add "quotaUser", valid_581076
  var valid_581077 = query.getOrDefault("alt")
  valid_581077 = validateParameter(valid_581077, JString, required = false,
                                 default = newJString("json"))
  if valid_581077 != nil:
    section.add "alt", valid_581077
  var valid_581078 = query.getOrDefault("oauth_token")
  valid_581078 = validateParameter(valid_581078, JString, required = false,
                                 default = nil)
  if valid_581078 != nil:
    section.add "oauth_token", valid_581078
  var valid_581079 = query.getOrDefault("userIp")
  valid_581079 = validateParameter(valid_581079, JString, required = false,
                                 default = nil)
  if valid_581079 != nil:
    section.add "userIp", valid_581079
  var valid_581080 = query.getOrDefault("key")
  valid_581080 = validateParameter(valid_581080, JString, required = false,
                                 default = nil)
  if valid_581080 != nil:
    section.add "key", valid_581080
  var valid_581081 = query.getOrDefault("prettyPrint")
  valid_581081 = validateParameter(valid_581081, JBool, required = false,
                                 default = newJBool(true))
  if valid_581081 != nil:
    section.add "prettyPrint", valid_581081
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

proc call*(call_581083: Call_ContentOrdersRejectreturnlineitem_581070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rejects return on an line item.
  ## 
  let valid = call_581083.validator(path, query, header, formData, body)
  let scheme = call_581083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581083.url(scheme.get, call_581083.host, call_581083.base,
                         call_581083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581083, url, valid)

proc call*(call_581084: Call_ContentOrdersRejectreturnlineitem_581070;
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
  var path_581085 = newJObject()
  var query_581086 = newJObject()
  var body_581087 = newJObject()
  add(query_581086, "fields", newJString(fields))
  add(query_581086, "quotaUser", newJString(quotaUser))
  add(query_581086, "alt", newJString(alt))
  add(query_581086, "oauth_token", newJString(oauthToken))
  add(query_581086, "userIp", newJString(userIp))
  add(path_581085, "orderId", newJString(orderId))
  add(query_581086, "key", newJString(key))
  add(path_581085, "merchantId", newJString(merchantId))
  if body != nil:
    body_581087 = body
  add(query_581086, "prettyPrint", newJBool(prettyPrint))
  result = call_581084.call(path_581085, query_581086, nil, nil, body_581087)

var contentOrdersRejectreturnlineitem* = Call_ContentOrdersRejectreturnlineitem_581070(
    name: "contentOrdersRejectreturnlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/rejectReturnLineItem",
    validator: validate_ContentOrdersRejectreturnlineitem_581071,
    base: "/content/v2", url: url_ContentOrdersRejectreturnlineitem_581072,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersReturnlineitem_581088 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersReturnlineitem_581090(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/returnLineItem")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersReturnlineitem_581089(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a line item.
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
  var valid_581091 = path.getOrDefault("orderId")
  valid_581091 = validateParameter(valid_581091, JString, required = true,
                                 default = nil)
  if valid_581091 != nil:
    section.add "orderId", valid_581091
  var valid_581092 = path.getOrDefault("merchantId")
  valid_581092 = validateParameter(valid_581092, JString, required = true,
                                 default = nil)
  if valid_581092 != nil:
    section.add "merchantId", valid_581092
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
  var valid_581093 = query.getOrDefault("fields")
  valid_581093 = validateParameter(valid_581093, JString, required = false,
                                 default = nil)
  if valid_581093 != nil:
    section.add "fields", valid_581093
  var valid_581094 = query.getOrDefault("quotaUser")
  valid_581094 = validateParameter(valid_581094, JString, required = false,
                                 default = nil)
  if valid_581094 != nil:
    section.add "quotaUser", valid_581094
  var valid_581095 = query.getOrDefault("alt")
  valid_581095 = validateParameter(valid_581095, JString, required = false,
                                 default = newJString("json"))
  if valid_581095 != nil:
    section.add "alt", valid_581095
  var valid_581096 = query.getOrDefault("oauth_token")
  valid_581096 = validateParameter(valid_581096, JString, required = false,
                                 default = nil)
  if valid_581096 != nil:
    section.add "oauth_token", valid_581096
  var valid_581097 = query.getOrDefault("userIp")
  valid_581097 = validateParameter(valid_581097, JString, required = false,
                                 default = nil)
  if valid_581097 != nil:
    section.add "userIp", valid_581097
  var valid_581098 = query.getOrDefault("key")
  valid_581098 = validateParameter(valid_581098, JString, required = false,
                                 default = nil)
  if valid_581098 != nil:
    section.add "key", valid_581098
  var valid_581099 = query.getOrDefault("prettyPrint")
  valid_581099 = validateParameter(valid_581099, JBool, required = false,
                                 default = newJBool(true))
  if valid_581099 != nil:
    section.add "prettyPrint", valid_581099
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

proc call*(call_581101: Call_ContentOrdersReturnlineitem_581088; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a line item.
  ## 
  let valid = call_581101.validator(path, query, header, formData, body)
  let scheme = call_581101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581101.url(scheme.get, call_581101.host, call_581101.base,
                         call_581101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581101, url, valid)

proc call*(call_581102: Call_ContentOrdersReturnlineitem_581088; orderId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentOrdersReturnlineitem
  ## Returns a line item.
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
  var path_581103 = newJObject()
  var query_581104 = newJObject()
  var body_581105 = newJObject()
  add(query_581104, "fields", newJString(fields))
  add(query_581104, "quotaUser", newJString(quotaUser))
  add(query_581104, "alt", newJString(alt))
  add(query_581104, "oauth_token", newJString(oauthToken))
  add(query_581104, "userIp", newJString(userIp))
  add(path_581103, "orderId", newJString(orderId))
  add(query_581104, "key", newJString(key))
  add(path_581103, "merchantId", newJString(merchantId))
  if body != nil:
    body_581105 = body
  add(query_581104, "prettyPrint", newJBool(prettyPrint))
  result = call_581102.call(path_581103, query_581104, nil, nil, body_581105)

var contentOrdersReturnlineitem* = Call_ContentOrdersReturnlineitem_581088(
    name: "contentOrdersReturnlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/returnLineItem",
    validator: validate_ContentOrdersReturnlineitem_581089, base: "/content/v2",
    url: url_ContentOrdersReturnlineitem_581090, schemes: {Scheme.Https})
type
  Call_ContentOrdersReturnrefundlineitem_581106 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersReturnrefundlineitem_581108(protocol: Scheme; host: string;
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

proc validate_ContentOrdersReturnrefundlineitem_581107(path: JsonNode;
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
  var valid_581109 = path.getOrDefault("orderId")
  valid_581109 = validateParameter(valid_581109, JString, required = true,
                                 default = nil)
  if valid_581109 != nil:
    section.add "orderId", valid_581109
  var valid_581110 = path.getOrDefault("merchantId")
  valid_581110 = validateParameter(valid_581110, JString, required = true,
                                 default = nil)
  if valid_581110 != nil:
    section.add "merchantId", valid_581110
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
  var valid_581111 = query.getOrDefault("fields")
  valid_581111 = validateParameter(valid_581111, JString, required = false,
                                 default = nil)
  if valid_581111 != nil:
    section.add "fields", valid_581111
  var valid_581112 = query.getOrDefault("quotaUser")
  valid_581112 = validateParameter(valid_581112, JString, required = false,
                                 default = nil)
  if valid_581112 != nil:
    section.add "quotaUser", valid_581112
  var valid_581113 = query.getOrDefault("alt")
  valid_581113 = validateParameter(valid_581113, JString, required = false,
                                 default = newJString("json"))
  if valid_581113 != nil:
    section.add "alt", valid_581113
  var valid_581114 = query.getOrDefault("oauth_token")
  valid_581114 = validateParameter(valid_581114, JString, required = false,
                                 default = nil)
  if valid_581114 != nil:
    section.add "oauth_token", valid_581114
  var valid_581115 = query.getOrDefault("userIp")
  valid_581115 = validateParameter(valid_581115, JString, required = false,
                                 default = nil)
  if valid_581115 != nil:
    section.add "userIp", valid_581115
  var valid_581116 = query.getOrDefault("key")
  valid_581116 = validateParameter(valid_581116, JString, required = false,
                                 default = nil)
  if valid_581116 != nil:
    section.add "key", valid_581116
  var valid_581117 = query.getOrDefault("prettyPrint")
  valid_581117 = validateParameter(valid_581117, JBool, required = false,
                                 default = newJBool(true))
  if valid_581117 != nil:
    section.add "prettyPrint", valid_581117
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

proc call*(call_581119: Call_ContentOrdersReturnrefundlineitem_581106;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns and refunds a line item. Note that this method can only be called on fully shipped orders.
  ## 
  let valid = call_581119.validator(path, query, header, formData, body)
  let scheme = call_581119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581119.url(scheme.get, call_581119.host, call_581119.base,
                         call_581119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581119, url, valid)

proc call*(call_581120: Call_ContentOrdersReturnrefundlineitem_581106;
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
  var path_581121 = newJObject()
  var query_581122 = newJObject()
  var body_581123 = newJObject()
  add(query_581122, "fields", newJString(fields))
  add(query_581122, "quotaUser", newJString(quotaUser))
  add(query_581122, "alt", newJString(alt))
  add(query_581122, "oauth_token", newJString(oauthToken))
  add(query_581122, "userIp", newJString(userIp))
  add(path_581121, "orderId", newJString(orderId))
  add(query_581122, "key", newJString(key))
  add(path_581121, "merchantId", newJString(merchantId))
  if body != nil:
    body_581123 = body
  add(query_581122, "prettyPrint", newJBool(prettyPrint))
  result = call_581120.call(path_581121, query_581122, nil, nil, body_581123)

var contentOrdersReturnrefundlineitem* = Call_ContentOrdersReturnrefundlineitem_581106(
    name: "contentOrdersReturnrefundlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/returnRefundLineItem",
    validator: validate_ContentOrdersReturnrefundlineitem_581107,
    base: "/content/v2", url: url_ContentOrdersReturnrefundlineitem_581108,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersSetlineitemmetadata_581124 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersSetlineitemmetadata_581126(protocol: Scheme; host: string;
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

proc validate_ContentOrdersSetlineitemmetadata_581125(path: JsonNode;
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
  var valid_581127 = path.getOrDefault("orderId")
  valid_581127 = validateParameter(valid_581127, JString, required = true,
                                 default = nil)
  if valid_581127 != nil:
    section.add "orderId", valid_581127
  var valid_581128 = path.getOrDefault("merchantId")
  valid_581128 = validateParameter(valid_581128, JString, required = true,
                                 default = nil)
  if valid_581128 != nil:
    section.add "merchantId", valid_581128
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
  var valid_581129 = query.getOrDefault("fields")
  valid_581129 = validateParameter(valid_581129, JString, required = false,
                                 default = nil)
  if valid_581129 != nil:
    section.add "fields", valid_581129
  var valid_581130 = query.getOrDefault("quotaUser")
  valid_581130 = validateParameter(valid_581130, JString, required = false,
                                 default = nil)
  if valid_581130 != nil:
    section.add "quotaUser", valid_581130
  var valid_581131 = query.getOrDefault("alt")
  valid_581131 = validateParameter(valid_581131, JString, required = false,
                                 default = newJString("json"))
  if valid_581131 != nil:
    section.add "alt", valid_581131
  var valid_581132 = query.getOrDefault("oauth_token")
  valid_581132 = validateParameter(valid_581132, JString, required = false,
                                 default = nil)
  if valid_581132 != nil:
    section.add "oauth_token", valid_581132
  var valid_581133 = query.getOrDefault("userIp")
  valid_581133 = validateParameter(valid_581133, JString, required = false,
                                 default = nil)
  if valid_581133 != nil:
    section.add "userIp", valid_581133
  var valid_581134 = query.getOrDefault("key")
  valid_581134 = validateParameter(valid_581134, JString, required = false,
                                 default = nil)
  if valid_581134 != nil:
    section.add "key", valid_581134
  var valid_581135 = query.getOrDefault("prettyPrint")
  valid_581135 = validateParameter(valid_581135, JBool, required = false,
                                 default = newJBool(true))
  if valid_581135 != nil:
    section.add "prettyPrint", valid_581135
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

proc call*(call_581137: Call_ContentOrdersSetlineitemmetadata_581124;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets (or overrides if it already exists) merchant provided annotations in the form of key-value pairs. A common use case would be to supply us with additional structured information about a line item that cannot be provided via other methods. Submitted key-value pairs can be retrieved as part of the orders resource.
  ## 
  let valid = call_581137.validator(path, query, header, formData, body)
  let scheme = call_581137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581137.url(scheme.get, call_581137.host, call_581137.base,
                         call_581137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581137, url, valid)

proc call*(call_581138: Call_ContentOrdersSetlineitemmetadata_581124;
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
  var path_581139 = newJObject()
  var query_581140 = newJObject()
  var body_581141 = newJObject()
  add(query_581140, "fields", newJString(fields))
  add(query_581140, "quotaUser", newJString(quotaUser))
  add(query_581140, "alt", newJString(alt))
  add(query_581140, "oauth_token", newJString(oauthToken))
  add(query_581140, "userIp", newJString(userIp))
  add(path_581139, "orderId", newJString(orderId))
  add(query_581140, "key", newJString(key))
  add(path_581139, "merchantId", newJString(merchantId))
  if body != nil:
    body_581141 = body
  add(query_581140, "prettyPrint", newJBool(prettyPrint))
  result = call_581138.call(path_581139, query_581140, nil, nil, body_581141)

var contentOrdersSetlineitemmetadata* = Call_ContentOrdersSetlineitemmetadata_581124(
    name: "contentOrdersSetlineitemmetadata", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/setLineItemMetadata",
    validator: validate_ContentOrdersSetlineitemmetadata_581125,
    base: "/content/v2", url: url_ContentOrdersSetlineitemmetadata_581126,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersShiplineitems_581142 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersShiplineitems_581144(protocol: Scheme; host: string;
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

proc validate_ContentOrdersShiplineitems_581143(path: JsonNode; query: JsonNode;
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
  var valid_581145 = path.getOrDefault("orderId")
  valid_581145 = validateParameter(valid_581145, JString, required = true,
                                 default = nil)
  if valid_581145 != nil:
    section.add "orderId", valid_581145
  var valid_581146 = path.getOrDefault("merchantId")
  valid_581146 = validateParameter(valid_581146, JString, required = true,
                                 default = nil)
  if valid_581146 != nil:
    section.add "merchantId", valid_581146
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
  var valid_581147 = query.getOrDefault("fields")
  valid_581147 = validateParameter(valid_581147, JString, required = false,
                                 default = nil)
  if valid_581147 != nil:
    section.add "fields", valid_581147
  var valid_581148 = query.getOrDefault("quotaUser")
  valid_581148 = validateParameter(valid_581148, JString, required = false,
                                 default = nil)
  if valid_581148 != nil:
    section.add "quotaUser", valid_581148
  var valid_581149 = query.getOrDefault("alt")
  valid_581149 = validateParameter(valid_581149, JString, required = false,
                                 default = newJString("json"))
  if valid_581149 != nil:
    section.add "alt", valid_581149
  var valid_581150 = query.getOrDefault("oauth_token")
  valid_581150 = validateParameter(valid_581150, JString, required = false,
                                 default = nil)
  if valid_581150 != nil:
    section.add "oauth_token", valid_581150
  var valid_581151 = query.getOrDefault("userIp")
  valid_581151 = validateParameter(valid_581151, JString, required = false,
                                 default = nil)
  if valid_581151 != nil:
    section.add "userIp", valid_581151
  var valid_581152 = query.getOrDefault("key")
  valid_581152 = validateParameter(valid_581152, JString, required = false,
                                 default = nil)
  if valid_581152 != nil:
    section.add "key", valid_581152
  var valid_581153 = query.getOrDefault("prettyPrint")
  valid_581153 = validateParameter(valid_581153, JBool, required = false,
                                 default = newJBool(true))
  if valid_581153 != nil:
    section.add "prettyPrint", valid_581153
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

proc call*(call_581155: Call_ContentOrdersShiplineitems_581142; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks line item(s) as shipped.
  ## 
  let valid = call_581155.validator(path, query, header, formData, body)
  let scheme = call_581155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581155.url(scheme.get, call_581155.host, call_581155.base,
                         call_581155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581155, url, valid)

proc call*(call_581156: Call_ContentOrdersShiplineitems_581142; orderId: string;
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
  var path_581157 = newJObject()
  var query_581158 = newJObject()
  var body_581159 = newJObject()
  add(query_581158, "fields", newJString(fields))
  add(query_581158, "quotaUser", newJString(quotaUser))
  add(query_581158, "alt", newJString(alt))
  add(query_581158, "oauth_token", newJString(oauthToken))
  add(query_581158, "userIp", newJString(userIp))
  add(path_581157, "orderId", newJString(orderId))
  add(query_581158, "key", newJString(key))
  add(path_581157, "merchantId", newJString(merchantId))
  if body != nil:
    body_581159 = body
  add(query_581158, "prettyPrint", newJBool(prettyPrint))
  result = call_581156.call(path_581157, query_581158, nil, nil, body_581159)

var contentOrdersShiplineitems* = Call_ContentOrdersShiplineitems_581142(
    name: "contentOrdersShiplineitems", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/shipLineItems",
    validator: validate_ContentOrdersShiplineitems_581143, base: "/content/v2",
    url: url_ContentOrdersShiplineitems_581144, schemes: {Scheme.Https})
type
  Call_ContentOrdersCreatetestreturn_581160 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersCreatetestreturn_581162(protocol: Scheme; host: string;
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

proc validate_ContentOrdersCreatetestreturn_581161(path: JsonNode; query: JsonNode;
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
  var valid_581163 = path.getOrDefault("orderId")
  valid_581163 = validateParameter(valid_581163, JString, required = true,
                                 default = nil)
  if valid_581163 != nil:
    section.add "orderId", valid_581163
  var valid_581164 = path.getOrDefault("merchantId")
  valid_581164 = validateParameter(valid_581164, JString, required = true,
                                 default = nil)
  if valid_581164 != nil:
    section.add "merchantId", valid_581164
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
  var valid_581165 = query.getOrDefault("fields")
  valid_581165 = validateParameter(valid_581165, JString, required = false,
                                 default = nil)
  if valid_581165 != nil:
    section.add "fields", valid_581165
  var valid_581166 = query.getOrDefault("quotaUser")
  valid_581166 = validateParameter(valid_581166, JString, required = false,
                                 default = nil)
  if valid_581166 != nil:
    section.add "quotaUser", valid_581166
  var valid_581167 = query.getOrDefault("alt")
  valid_581167 = validateParameter(valid_581167, JString, required = false,
                                 default = newJString("json"))
  if valid_581167 != nil:
    section.add "alt", valid_581167
  var valid_581168 = query.getOrDefault("oauth_token")
  valid_581168 = validateParameter(valid_581168, JString, required = false,
                                 default = nil)
  if valid_581168 != nil:
    section.add "oauth_token", valid_581168
  var valid_581169 = query.getOrDefault("userIp")
  valid_581169 = validateParameter(valid_581169, JString, required = false,
                                 default = nil)
  if valid_581169 != nil:
    section.add "userIp", valid_581169
  var valid_581170 = query.getOrDefault("key")
  valid_581170 = validateParameter(valid_581170, JString, required = false,
                                 default = nil)
  if valid_581170 != nil:
    section.add "key", valid_581170
  var valid_581171 = query.getOrDefault("prettyPrint")
  valid_581171 = validateParameter(valid_581171, JBool, required = false,
                                 default = newJBool(true))
  if valid_581171 != nil:
    section.add "prettyPrint", valid_581171
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

proc call*(call_581173: Call_ContentOrdersCreatetestreturn_581160; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Creates a test return.
  ## 
  let valid = call_581173.validator(path, query, header, formData, body)
  let scheme = call_581173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581173.url(scheme.get, call_581173.host, call_581173.base,
                         call_581173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581173, url, valid)

proc call*(call_581174: Call_ContentOrdersCreatetestreturn_581160; orderId: string;
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
  var path_581175 = newJObject()
  var query_581176 = newJObject()
  var body_581177 = newJObject()
  add(query_581176, "fields", newJString(fields))
  add(query_581176, "quotaUser", newJString(quotaUser))
  add(query_581176, "alt", newJString(alt))
  add(query_581176, "oauth_token", newJString(oauthToken))
  add(query_581176, "userIp", newJString(userIp))
  add(path_581175, "orderId", newJString(orderId))
  add(query_581176, "key", newJString(key))
  add(path_581175, "merchantId", newJString(merchantId))
  if body != nil:
    body_581177 = body
  add(query_581176, "prettyPrint", newJBool(prettyPrint))
  result = call_581174.call(path_581175, query_581176, nil, nil, body_581177)

var contentOrdersCreatetestreturn* = Call_ContentOrdersCreatetestreturn_581160(
    name: "contentOrdersCreatetestreturn", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/testreturn",
    validator: validate_ContentOrdersCreatetestreturn_581161, base: "/content/v2",
    url: url_ContentOrdersCreatetestreturn_581162, schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdatelineitemshippingdetails_581178 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersUpdatelineitemshippingdetails_581180(protocol: Scheme;
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

proc validate_ContentOrdersUpdatelineitemshippingdetails_581179(path: JsonNode;
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
  var valid_581181 = path.getOrDefault("orderId")
  valid_581181 = validateParameter(valid_581181, JString, required = true,
                                 default = nil)
  if valid_581181 != nil:
    section.add "orderId", valid_581181
  var valid_581182 = path.getOrDefault("merchantId")
  valid_581182 = validateParameter(valid_581182, JString, required = true,
                                 default = nil)
  if valid_581182 != nil:
    section.add "merchantId", valid_581182
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
  var valid_581183 = query.getOrDefault("fields")
  valid_581183 = validateParameter(valid_581183, JString, required = false,
                                 default = nil)
  if valid_581183 != nil:
    section.add "fields", valid_581183
  var valid_581184 = query.getOrDefault("quotaUser")
  valid_581184 = validateParameter(valid_581184, JString, required = false,
                                 default = nil)
  if valid_581184 != nil:
    section.add "quotaUser", valid_581184
  var valid_581185 = query.getOrDefault("alt")
  valid_581185 = validateParameter(valid_581185, JString, required = false,
                                 default = newJString("json"))
  if valid_581185 != nil:
    section.add "alt", valid_581185
  var valid_581186 = query.getOrDefault("oauth_token")
  valid_581186 = validateParameter(valid_581186, JString, required = false,
                                 default = nil)
  if valid_581186 != nil:
    section.add "oauth_token", valid_581186
  var valid_581187 = query.getOrDefault("userIp")
  valid_581187 = validateParameter(valid_581187, JString, required = false,
                                 default = nil)
  if valid_581187 != nil:
    section.add "userIp", valid_581187
  var valid_581188 = query.getOrDefault("key")
  valid_581188 = validateParameter(valid_581188, JString, required = false,
                                 default = nil)
  if valid_581188 != nil:
    section.add "key", valid_581188
  var valid_581189 = query.getOrDefault("prettyPrint")
  valid_581189 = validateParameter(valid_581189, JBool, required = false,
                                 default = newJBool(true))
  if valid_581189 != nil:
    section.add "prettyPrint", valid_581189
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

proc call*(call_581191: Call_ContentOrdersUpdatelineitemshippingdetails_581178;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates ship by and delivery by dates for a line item.
  ## 
  let valid = call_581191.validator(path, query, header, formData, body)
  let scheme = call_581191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581191.url(scheme.get, call_581191.host, call_581191.base,
                         call_581191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581191, url, valid)

proc call*(call_581192: Call_ContentOrdersUpdatelineitemshippingdetails_581178;
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
  var path_581193 = newJObject()
  var query_581194 = newJObject()
  var body_581195 = newJObject()
  add(query_581194, "fields", newJString(fields))
  add(query_581194, "quotaUser", newJString(quotaUser))
  add(query_581194, "alt", newJString(alt))
  add(query_581194, "oauth_token", newJString(oauthToken))
  add(query_581194, "userIp", newJString(userIp))
  add(path_581193, "orderId", newJString(orderId))
  add(query_581194, "key", newJString(key))
  add(path_581193, "merchantId", newJString(merchantId))
  if body != nil:
    body_581195 = body
  add(query_581194, "prettyPrint", newJBool(prettyPrint))
  result = call_581192.call(path_581193, query_581194, nil, nil, body_581195)

var contentOrdersUpdatelineitemshippingdetails* = Call_ContentOrdersUpdatelineitemshippingdetails_581178(
    name: "contentOrdersUpdatelineitemshippingdetails", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateLineItemShippingDetails",
    validator: validate_ContentOrdersUpdatelineitemshippingdetails_581179,
    base: "/content/v2", url: url_ContentOrdersUpdatelineitemshippingdetails_581180,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdatemerchantorderid_581196 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersUpdatemerchantorderid_581198(protocol: Scheme; host: string;
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

proc validate_ContentOrdersUpdatemerchantorderid_581197(path: JsonNode;
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
  var valid_581199 = path.getOrDefault("orderId")
  valid_581199 = validateParameter(valid_581199, JString, required = true,
                                 default = nil)
  if valid_581199 != nil:
    section.add "orderId", valid_581199
  var valid_581200 = path.getOrDefault("merchantId")
  valid_581200 = validateParameter(valid_581200, JString, required = true,
                                 default = nil)
  if valid_581200 != nil:
    section.add "merchantId", valid_581200
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
  var valid_581201 = query.getOrDefault("fields")
  valid_581201 = validateParameter(valid_581201, JString, required = false,
                                 default = nil)
  if valid_581201 != nil:
    section.add "fields", valid_581201
  var valid_581202 = query.getOrDefault("quotaUser")
  valid_581202 = validateParameter(valid_581202, JString, required = false,
                                 default = nil)
  if valid_581202 != nil:
    section.add "quotaUser", valid_581202
  var valid_581203 = query.getOrDefault("alt")
  valid_581203 = validateParameter(valid_581203, JString, required = false,
                                 default = newJString("json"))
  if valid_581203 != nil:
    section.add "alt", valid_581203
  var valid_581204 = query.getOrDefault("oauth_token")
  valid_581204 = validateParameter(valid_581204, JString, required = false,
                                 default = nil)
  if valid_581204 != nil:
    section.add "oauth_token", valid_581204
  var valid_581205 = query.getOrDefault("userIp")
  valid_581205 = validateParameter(valid_581205, JString, required = false,
                                 default = nil)
  if valid_581205 != nil:
    section.add "userIp", valid_581205
  var valid_581206 = query.getOrDefault("key")
  valid_581206 = validateParameter(valid_581206, JString, required = false,
                                 default = nil)
  if valid_581206 != nil:
    section.add "key", valid_581206
  var valid_581207 = query.getOrDefault("prettyPrint")
  valid_581207 = validateParameter(valid_581207, JBool, required = false,
                                 default = newJBool(true))
  if valid_581207 != nil:
    section.add "prettyPrint", valid_581207
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

proc call*(call_581209: Call_ContentOrdersUpdatemerchantorderid_581196;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the merchant order ID for a given order.
  ## 
  let valid = call_581209.validator(path, query, header, formData, body)
  let scheme = call_581209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581209.url(scheme.get, call_581209.host, call_581209.base,
                         call_581209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581209, url, valid)

proc call*(call_581210: Call_ContentOrdersUpdatemerchantorderid_581196;
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
  var path_581211 = newJObject()
  var query_581212 = newJObject()
  var body_581213 = newJObject()
  add(query_581212, "fields", newJString(fields))
  add(query_581212, "quotaUser", newJString(quotaUser))
  add(query_581212, "alt", newJString(alt))
  add(query_581212, "oauth_token", newJString(oauthToken))
  add(query_581212, "userIp", newJString(userIp))
  add(path_581211, "orderId", newJString(orderId))
  add(query_581212, "key", newJString(key))
  add(path_581211, "merchantId", newJString(merchantId))
  if body != nil:
    body_581213 = body
  add(query_581212, "prettyPrint", newJBool(prettyPrint))
  result = call_581210.call(path_581211, query_581212, nil, nil, body_581213)

var contentOrdersUpdatemerchantorderid* = Call_ContentOrdersUpdatemerchantorderid_581196(
    name: "contentOrdersUpdatemerchantorderid", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateMerchantOrderId",
    validator: validate_ContentOrdersUpdatemerchantorderid_581197,
    base: "/content/v2", url: url_ContentOrdersUpdatemerchantorderid_581198,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdateshipment_581214 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersUpdateshipment_581216(protocol: Scheme; host: string;
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

proc validate_ContentOrdersUpdateshipment_581215(path: JsonNode; query: JsonNode;
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
  var valid_581217 = path.getOrDefault("orderId")
  valid_581217 = validateParameter(valid_581217, JString, required = true,
                                 default = nil)
  if valid_581217 != nil:
    section.add "orderId", valid_581217
  var valid_581218 = path.getOrDefault("merchantId")
  valid_581218 = validateParameter(valid_581218, JString, required = true,
                                 default = nil)
  if valid_581218 != nil:
    section.add "merchantId", valid_581218
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

proc call*(call_581227: Call_ContentOrdersUpdateshipment_581214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a shipment's status, carrier, and/or tracking ID.
  ## 
  let valid = call_581227.validator(path, query, header, formData, body)
  let scheme = call_581227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581227.url(scheme.get, call_581227.host, call_581227.base,
                         call_581227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581227, url, valid)

proc call*(call_581228: Call_ContentOrdersUpdateshipment_581214; orderId: string;
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
  var path_581229 = newJObject()
  var query_581230 = newJObject()
  var body_581231 = newJObject()
  add(query_581230, "fields", newJString(fields))
  add(query_581230, "quotaUser", newJString(quotaUser))
  add(query_581230, "alt", newJString(alt))
  add(query_581230, "oauth_token", newJString(oauthToken))
  add(query_581230, "userIp", newJString(userIp))
  add(path_581229, "orderId", newJString(orderId))
  add(query_581230, "key", newJString(key))
  add(path_581229, "merchantId", newJString(merchantId))
  if body != nil:
    body_581231 = body
  add(query_581230, "prettyPrint", newJBool(prettyPrint))
  result = call_581228.call(path_581229, query_581230, nil, nil, body_581231)

var contentOrdersUpdateshipment* = Call_ContentOrdersUpdateshipment_581214(
    name: "contentOrdersUpdateshipment", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateShipment",
    validator: validate_ContentOrdersUpdateshipment_581215, base: "/content/v2",
    url: url_ContentOrdersUpdateshipment_581216, schemes: {Scheme.Https})
type
  Call_ContentOrdersGetbymerchantorderid_581232 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersGetbymerchantorderid_581234(protocol: Scheme; host: string;
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

proc validate_ContentOrdersGetbymerchantorderid_581233(path: JsonNode;
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
  var valid_581235 = path.getOrDefault("merchantOrderId")
  valid_581235 = validateParameter(valid_581235, JString, required = true,
                                 default = nil)
  if valid_581235 != nil:
    section.add "merchantOrderId", valid_581235
  var valid_581236 = path.getOrDefault("merchantId")
  valid_581236 = validateParameter(valid_581236, JString, required = true,
                                 default = nil)
  if valid_581236 != nil:
    section.add "merchantId", valid_581236
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
  var valid_581237 = query.getOrDefault("fields")
  valid_581237 = validateParameter(valid_581237, JString, required = false,
                                 default = nil)
  if valid_581237 != nil:
    section.add "fields", valid_581237
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
  var valid_581242 = query.getOrDefault("key")
  valid_581242 = validateParameter(valid_581242, JString, required = false,
                                 default = nil)
  if valid_581242 != nil:
    section.add "key", valid_581242
  var valid_581243 = query.getOrDefault("prettyPrint")
  valid_581243 = validateParameter(valid_581243, JBool, required = false,
                                 default = newJBool(true))
  if valid_581243 != nil:
    section.add "prettyPrint", valid_581243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581244: Call_ContentOrdersGetbymerchantorderid_581232;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves an order using merchant order ID.
  ## 
  let valid = call_581244.validator(path, query, header, formData, body)
  let scheme = call_581244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581244.url(scheme.get, call_581244.host, call_581244.base,
                         call_581244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581244, url, valid)

proc call*(call_581245: Call_ContentOrdersGetbymerchantorderid_581232;
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
  var path_581246 = newJObject()
  var query_581247 = newJObject()
  add(query_581247, "fields", newJString(fields))
  add(query_581247, "quotaUser", newJString(quotaUser))
  add(query_581247, "alt", newJString(alt))
  add(query_581247, "oauth_token", newJString(oauthToken))
  add(query_581247, "userIp", newJString(userIp))
  add(query_581247, "key", newJString(key))
  add(path_581246, "merchantOrderId", newJString(merchantOrderId))
  add(path_581246, "merchantId", newJString(merchantId))
  add(query_581247, "prettyPrint", newJBool(prettyPrint))
  result = call_581245.call(path_581246, query_581247, nil, nil, nil)

var contentOrdersGetbymerchantorderid* = Call_ContentOrdersGetbymerchantorderid_581232(
    name: "contentOrdersGetbymerchantorderid", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/ordersbymerchantid/{merchantOrderId}",
    validator: validate_ContentOrdersGetbymerchantorderid_581233,
    base: "/content/v2", url: url_ContentOrdersGetbymerchantorderid_581234,
    schemes: {Scheme.Https})
type
  Call_ContentPosInventory_581248 = ref object of OpenApiRestCall_579421
proc url_ContentPosInventory_581250(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosInventory_581249(path: JsonNode; query: JsonNode;
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
  var valid_581251 = path.getOrDefault("targetMerchantId")
  valid_581251 = validateParameter(valid_581251, JString, required = true,
                                 default = nil)
  if valid_581251 != nil:
    section.add "targetMerchantId", valid_581251
  var valid_581252 = path.getOrDefault("merchantId")
  valid_581252 = validateParameter(valid_581252, JString, required = true,
                                 default = nil)
  if valid_581252 != nil:
    section.add "merchantId", valid_581252
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_581253 = query.getOrDefault("fields")
  valid_581253 = validateParameter(valid_581253, JString, required = false,
                                 default = nil)
  if valid_581253 != nil:
    section.add "fields", valid_581253
  var valid_581254 = query.getOrDefault("quotaUser")
  valid_581254 = validateParameter(valid_581254, JString, required = false,
                                 default = nil)
  if valid_581254 != nil:
    section.add "quotaUser", valid_581254
  var valid_581255 = query.getOrDefault("alt")
  valid_581255 = validateParameter(valid_581255, JString, required = false,
                                 default = newJString("json"))
  if valid_581255 != nil:
    section.add "alt", valid_581255
  var valid_581256 = query.getOrDefault("dryRun")
  valid_581256 = validateParameter(valid_581256, JBool, required = false, default = nil)
  if valid_581256 != nil:
    section.add "dryRun", valid_581256
  var valid_581257 = query.getOrDefault("oauth_token")
  valid_581257 = validateParameter(valid_581257, JString, required = false,
                                 default = nil)
  if valid_581257 != nil:
    section.add "oauth_token", valid_581257
  var valid_581258 = query.getOrDefault("userIp")
  valid_581258 = validateParameter(valid_581258, JString, required = false,
                                 default = nil)
  if valid_581258 != nil:
    section.add "userIp", valid_581258
  var valid_581259 = query.getOrDefault("key")
  valid_581259 = validateParameter(valid_581259, JString, required = false,
                                 default = nil)
  if valid_581259 != nil:
    section.add "key", valid_581259
  var valid_581260 = query.getOrDefault("prettyPrint")
  valid_581260 = validateParameter(valid_581260, JBool, required = false,
                                 default = newJBool(true))
  if valid_581260 != nil:
    section.add "prettyPrint", valid_581260
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

proc call*(call_581262: Call_ContentPosInventory_581248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit inventory for the given merchant.
  ## 
  let valid = call_581262.validator(path, query, header, formData, body)
  let scheme = call_581262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581262.url(scheme.get, call_581262.host, call_581262.base,
                         call_581262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581262, url, valid)

proc call*(call_581263: Call_ContentPosInventory_581248; targetMerchantId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; dryRun: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## contentPosInventory
  ## Submit inventory for the given merchant.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
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
  var path_581264 = newJObject()
  var query_581265 = newJObject()
  var body_581266 = newJObject()
  add(query_581265, "fields", newJString(fields))
  add(query_581265, "quotaUser", newJString(quotaUser))
  add(query_581265, "alt", newJString(alt))
  add(query_581265, "dryRun", newJBool(dryRun))
  add(path_581264, "targetMerchantId", newJString(targetMerchantId))
  add(query_581265, "oauth_token", newJString(oauthToken))
  add(query_581265, "userIp", newJString(userIp))
  add(query_581265, "key", newJString(key))
  add(path_581264, "merchantId", newJString(merchantId))
  if body != nil:
    body_581266 = body
  add(query_581265, "prettyPrint", newJBool(prettyPrint))
  result = call_581263.call(path_581264, query_581265, nil, nil, body_581266)

var contentPosInventory* = Call_ContentPosInventory_581248(
    name: "contentPosInventory", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/inventory",
    validator: validate_ContentPosInventory_581249, base: "/content/v2",
    url: url_ContentPosInventory_581250, schemes: {Scheme.Https})
type
  Call_ContentPosSale_581267 = ref object of OpenApiRestCall_579421
proc url_ContentPosSale_581269(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosSale_581268(path: JsonNode; query: JsonNode;
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
  var valid_581270 = path.getOrDefault("targetMerchantId")
  valid_581270 = validateParameter(valid_581270, JString, required = true,
                                 default = nil)
  if valid_581270 != nil:
    section.add "targetMerchantId", valid_581270
  var valid_581271 = path.getOrDefault("merchantId")
  valid_581271 = validateParameter(valid_581271, JString, required = true,
                                 default = nil)
  if valid_581271 != nil:
    section.add "merchantId", valid_581271
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_581272 = query.getOrDefault("fields")
  valid_581272 = validateParameter(valid_581272, JString, required = false,
                                 default = nil)
  if valid_581272 != nil:
    section.add "fields", valid_581272
  var valid_581273 = query.getOrDefault("quotaUser")
  valid_581273 = validateParameter(valid_581273, JString, required = false,
                                 default = nil)
  if valid_581273 != nil:
    section.add "quotaUser", valid_581273
  var valid_581274 = query.getOrDefault("alt")
  valid_581274 = validateParameter(valid_581274, JString, required = false,
                                 default = newJString("json"))
  if valid_581274 != nil:
    section.add "alt", valid_581274
  var valid_581275 = query.getOrDefault("dryRun")
  valid_581275 = validateParameter(valid_581275, JBool, required = false, default = nil)
  if valid_581275 != nil:
    section.add "dryRun", valid_581275
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
  var valid_581278 = query.getOrDefault("key")
  valid_581278 = validateParameter(valid_581278, JString, required = false,
                                 default = nil)
  if valid_581278 != nil:
    section.add "key", valid_581278
  var valid_581279 = query.getOrDefault("prettyPrint")
  valid_581279 = validateParameter(valid_581279, JBool, required = false,
                                 default = newJBool(true))
  if valid_581279 != nil:
    section.add "prettyPrint", valid_581279
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

proc call*(call_581281: Call_ContentPosSale_581267; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit a sale event for the given merchant.
  ## 
  let valid = call_581281.validator(path, query, header, formData, body)
  let scheme = call_581281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581281.url(scheme.get, call_581281.host, call_581281.base,
                         call_581281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581281, url, valid)

proc call*(call_581282: Call_ContentPosSale_581267; targetMerchantId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; dryRun: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## contentPosSale
  ## Submit a sale event for the given merchant.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
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
  var path_581283 = newJObject()
  var query_581284 = newJObject()
  var body_581285 = newJObject()
  add(query_581284, "fields", newJString(fields))
  add(query_581284, "quotaUser", newJString(quotaUser))
  add(query_581284, "alt", newJString(alt))
  add(query_581284, "dryRun", newJBool(dryRun))
  add(path_581283, "targetMerchantId", newJString(targetMerchantId))
  add(query_581284, "oauth_token", newJString(oauthToken))
  add(query_581284, "userIp", newJString(userIp))
  add(query_581284, "key", newJString(key))
  add(path_581283, "merchantId", newJString(merchantId))
  if body != nil:
    body_581285 = body
  add(query_581284, "prettyPrint", newJBool(prettyPrint))
  result = call_581282.call(path_581283, query_581284, nil, nil, body_581285)

var contentPosSale* = Call_ContentPosSale_581267(name: "contentPosSale",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/sale",
    validator: validate_ContentPosSale_581268, base: "/content/v2",
    url: url_ContentPosSale_581269, schemes: {Scheme.Https})
type
  Call_ContentPosInsert_581302 = ref object of OpenApiRestCall_579421
proc url_ContentPosInsert_581304(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosInsert_581303(path: JsonNode; query: JsonNode;
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
  var valid_581305 = path.getOrDefault("targetMerchantId")
  valid_581305 = validateParameter(valid_581305, JString, required = true,
                                 default = nil)
  if valid_581305 != nil:
    section.add "targetMerchantId", valid_581305
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
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
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
  var valid_581310 = query.getOrDefault("dryRun")
  valid_581310 = validateParameter(valid_581310, JBool, required = false, default = nil)
  if valid_581310 != nil:
    section.add "dryRun", valid_581310
  var valid_581311 = query.getOrDefault("oauth_token")
  valid_581311 = validateParameter(valid_581311, JString, required = false,
                                 default = nil)
  if valid_581311 != nil:
    section.add "oauth_token", valid_581311
  var valid_581312 = query.getOrDefault("userIp")
  valid_581312 = validateParameter(valid_581312, JString, required = false,
                                 default = nil)
  if valid_581312 != nil:
    section.add "userIp", valid_581312
  var valid_581313 = query.getOrDefault("key")
  valid_581313 = validateParameter(valid_581313, JString, required = false,
                                 default = nil)
  if valid_581313 != nil:
    section.add "key", valid_581313
  var valid_581314 = query.getOrDefault("prettyPrint")
  valid_581314 = validateParameter(valid_581314, JBool, required = false,
                                 default = newJBool(true))
  if valid_581314 != nil:
    section.add "prettyPrint", valid_581314
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

proc call*(call_581316: Call_ContentPosInsert_581302; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a store for the given merchant.
  ## 
  let valid = call_581316.validator(path, query, header, formData, body)
  let scheme = call_581316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581316.url(scheme.get, call_581316.host, call_581316.base,
                         call_581316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581316, url, valid)

proc call*(call_581317: Call_ContentPosInsert_581302; targetMerchantId: string;
          merchantId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; dryRun: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## contentPosInsert
  ## Creates a store for the given merchant.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
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
  var path_581318 = newJObject()
  var query_581319 = newJObject()
  var body_581320 = newJObject()
  add(query_581319, "fields", newJString(fields))
  add(query_581319, "quotaUser", newJString(quotaUser))
  add(query_581319, "alt", newJString(alt))
  add(query_581319, "dryRun", newJBool(dryRun))
  add(path_581318, "targetMerchantId", newJString(targetMerchantId))
  add(query_581319, "oauth_token", newJString(oauthToken))
  add(query_581319, "userIp", newJString(userIp))
  add(query_581319, "key", newJString(key))
  add(path_581318, "merchantId", newJString(merchantId))
  if body != nil:
    body_581320 = body
  add(query_581319, "prettyPrint", newJBool(prettyPrint))
  result = call_581317.call(path_581318, query_581319, nil, nil, body_581320)

var contentPosInsert* = Call_ContentPosInsert_581302(name: "contentPosInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store",
    validator: validate_ContentPosInsert_581303, base: "/content/v2",
    url: url_ContentPosInsert_581304, schemes: {Scheme.Https})
type
  Call_ContentPosList_581286 = ref object of OpenApiRestCall_579421
proc url_ContentPosList_581288(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosList_581287(path: JsonNode; query: JsonNode;
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
  var valid_581289 = path.getOrDefault("targetMerchantId")
  valid_581289 = validateParameter(valid_581289, JString, required = true,
                                 default = nil)
  if valid_581289 != nil:
    section.add "targetMerchantId", valid_581289
  var valid_581290 = path.getOrDefault("merchantId")
  valid_581290 = validateParameter(valid_581290, JString, required = true,
                                 default = nil)
  if valid_581290 != nil:
    section.add "merchantId", valid_581290
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
  var valid_581291 = query.getOrDefault("fields")
  valid_581291 = validateParameter(valid_581291, JString, required = false,
                                 default = nil)
  if valid_581291 != nil:
    section.add "fields", valid_581291
  var valid_581292 = query.getOrDefault("quotaUser")
  valid_581292 = validateParameter(valid_581292, JString, required = false,
                                 default = nil)
  if valid_581292 != nil:
    section.add "quotaUser", valid_581292
  var valid_581293 = query.getOrDefault("alt")
  valid_581293 = validateParameter(valid_581293, JString, required = false,
                                 default = newJString("json"))
  if valid_581293 != nil:
    section.add "alt", valid_581293
  var valid_581294 = query.getOrDefault("oauth_token")
  valid_581294 = validateParameter(valid_581294, JString, required = false,
                                 default = nil)
  if valid_581294 != nil:
    section.add "oauth_token", valid_581294
  var valid_581295 = query.getOrDefault("userIp")
  valid_581295 = validateParameter(valid_581295, JString, required = false,
                                 default = nil)
  if valid_581295 != nil:
    section.add "userIp", valid_581295
  var valid_581296 = query.getOrDefault("key")
  valid_581296 = validateParameter(valid_581296, JString, required = false,
                                 default = nil)
  if valid_581296 != nil:
    section.add "key", valid_581296
  var valid_581297 = query.getOrDefault("prettyPrint")
  valid_581297 = validateParameter(valid_581297, JBool, required = false,
                                 default = newJBool(true))
  if valid_581297 != nil:
    section.add "prettyPrint", valid_581297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581298: Call_ContentPosList_581286; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the stores of the target merchant.
  ## 
  let valid = call_581298.validator(path, query, header, formData, body)
  let scheme = call_581298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581298.url(scheme.get, call_581298.host, call_581298.base,
                         call_581298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581298, url, valid)

proc call*(call_581299: Call_ContentPosList_581286; targetMerchantId: string;
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
  var path_581300 = newJObject()
  var query_581301 = newJObject()
  add(query_581301, "fields", newJString(fields))
  add(query_581301, "quotaUser", newJString(quotaUser))
  add(query_581301, "alt", newJString(alt))
  add(path_581300, "targetMerchantId", newJString(targetMerchantId))
  add(query_581301, "oauth_token", newJString(oauthToken))
  add(query_581301, "userIp", newJString(userIp))
  add(query_581301, "key", newJString(key))
  add(path_581300, "merchantId", newJString(merchantId))
  add(query_581301, "prettyPrint", newJBool(prettyPrint))
  result = call_581299.call(path_581300, query_581301, nil, nil, nil)

var contentPosList* = Call_ContentPosList_581286(name: "contentPosList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store",
    validator: validate_ContentPosList_581287, base: "/content/v2",
    url: url_ContentPosList_581288, schemes: {Scheme.Https})
type
  Call_ContentPosGet_581321 = ref object of OpenApiRestCall_579421
proc url_ContentPosGet_581323(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosGet_581322(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_581324 = path.getOrDefault("targetMerchantId")
  valid_581324 = validateParameter(valid_581324, JString, required = true,
                                 default = nil)
  if valid_581324 != nil:
    section.add "targetMerchantId", valid_581324
  var valid_581325 = path.getOrDefault("storeCode")
  valid_581325 = validateParameter(valid_581325, JString, required = true,
                                 default = nil)
  if valid_581325 != nil:
    section.add "storeCode", valid_581325
  var valid_581326 = path.getOrDefault("merchantId")
  valid_581326 = validateParameter(valid_581326, JString, required = true,
                                 default = nil)
  if valid_581326 != nil:
    section.add "merchantId", valid_581326
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
  var valid_581327 = query.getOrDefault("fields")
  valid_581327 = validateParameter(valid_581327, JString, required = false,
                                 default = nil)
  if valid_581327 != nil:
    section.add "fields", valid_581327
  var valid_581328 = query.getOrDefault("quotaUser")
  valid_581328 = validateParameter(valid_581328, JString, required = false,
                                 default = nil)
  if valid_581328 != nil:
    section.add "quotaUser", valid_581328
  var valid_581329 = query.getOrDefault("alt")
  valid_581329 = validateParameter(valid_581329, JString, required = false,
                                 default = newJString("json"))
  if valid_581329 != nil:
    section.add "alt", valid_581329
  var valid_581330 = query.getOrDefault("oauth_token")
  valid_581330 = validateParameter(valid_581330, JString, required = false,
                                 default = nil)
  if valid_581330 != nil:
    section.add "oauth_token", valid_581330
  var valid_581331 = query.getOrDefault("userIp")
  valid_581331 = validateParameter(valid_581331, JString, required = false,
                                 default = nil)
  if valid_581331 != nil:
    section.add "userIp", valid_581331
  var valid_581332 = query.getOrDefault("key")
  valid_581332 = validateParameter(valid_581332, JString, required = false,
                                 default = nil)
  if valid_581332 != nil:
    section.add "key", valid_581332
  var valid_581333 = query.getOrDefault("prettyPrint")
  valid_581333 = validateParameter(valid_581333, JBool, required = false,
                                 default = newJBool(true))
  if valid_581333 != nil:
    section.add "prettyPrint", valid_581333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581334: Call_ContentPosGet_581321; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about the given store.
  ## 
  let valid = call_581334.validator(path, query, header, formData, body)
  let scheme = call_581334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581334.url(scheme.get, call_581334.host, call_581334.base,
                         call_581334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581334, url, valid)

proc call*(call_581335: Call_ContentPosGet_581321; targetMerchantId: string;
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
  var path_581336 = newJObject()
  var query_581337 = newJObject()
  add(query_581337, "fields", newJString(fields))
  add(query_581337, "quotaUser", newJString(quotaUser))
  add(query_581337, "alt", newJString(alt))
  add(path_581336, "targetMerchantId", newJString(targetMerchantId))
  add(query_581337, "oauth_token", newJString(oauthToken))
  add(path_581336, "storeCode", newJString(storeCode))
  add(query_581337, "userIp", newJString(userIp))
  add(query_581337, "key", newJString(key))
  add(path_581336, "merchantId", newJString(merchantId))
  add(query_581337, "prettyPrint", newJBool(prettyPrint))
  result = call_581335.call(path_581336, query_581337, nil, nil, nil)

var contentPosGet* = Call_ContentPosGet_581321(name: "contentPosGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store/{storeCode}",
    validator: validate_ContentPosGet_581322, base: "/content/v2",
    url: url_ContentPosGet_581323, schemes: {Scheme.Https})
type
  Call_ContentPosDelete_581338 = ref object of OpenApiRestCall_579421
proc url_ContentPosDelete_581340(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosDelete_581339(path: JsonNode; query: JsonNode;
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
  var valid_581341 = path.getOrDefault("targetMerchantId")
  valid_581341 = validateParameter(valid_581341, JString, required = true,
                                 default = nil)
  if valid_581341 != nil:
    section.add "targetMerchantId", valid_581341
  var valid_581342 = path.getOrDefault("storeCode")
  valid_581342 = validateParameter(valid_581342, JString, required = true,
                                 default = nil)
  if valid_581342 != nil:
    section.add "storeCode", valid_581342
  var valid_581343 = path.getOrDefault("merchantId")
  valid_581343 = validateParameter(valid_581343, JString, required = true,
                                 default = nil)
  if valid_581343 != nil:
    section.add "merchantId", valid_581343
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_581344 = query.getOrDefault("fields")
  valid_581344 = validateParameter(valid_581344, JString, required = false,
                                 default = nil)
  if valid_581344 != nil:
    section.add "fields", valid_581344
  var valid_581345 = query.getOrDefault("quotaUser")
  valid_581345 = validateParameter(valid_581345, JString, required = false,
                                 default = nil)
  if valid_581345 != nil:
    section.add "quotaUser", valid_581345
  var valid_581346 = query.getOrDefault("alt")
  valid_581346 = validateParameter(valid_581346, JString, required = false,
                                 default = newJString("json"))
  if valid_581346 != nil:
    section.add "alt", valid_581346
  var valid_581347 = query.getOrDefault("dryRun")
  valid_581347 = validateParameter(valid_581347, JBool, required = false, default = nil)
  if valid_581347 != nil:
    section.add "dryRun", valid_581347
  var valid_581348 = query.getOrDefault("oauth_token")
  valid_581348 = validateParameter(valid_581348, JString, required = false,
                                 default = nil)
  if valid_581348 != nil:
    section.add "oauth_token", valid_581348
  var valid_581349 = query.getOrDefault("userIp")
  valid_581349 = validateParameter(valid_581349, JString, required = false,
                                 default = nil)
  if valid_581349 != nil:
    section.add "userIp", valid_581349
  var valid_581350 = query.getOrDefault("key")
  valid_581350 = validateParameter(valid_581350, JString, required = false,
                                 default = nil)
  if valid_581350 != nil:
    section.add "key", valid_581350
  var valid_581351 = query.getOrDefault("prettyPrint")
  valid_581351 = validateParameter(valid_581351, JBool, required = false,
                                 default = newJBool(true))
  if valid_581351 != nil:
    section.add "prettyPrint", valid_581351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581352: Call_ContentPosDelete_581338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a store for the given merchant.
  ## 
  let valid = call_581352.validator(path, query, header, formData, body)
  let scheme = call_581352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581352.url(scheme.get, call_581352.host, call_581352.base,
                         call_581352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581352, url, valid)

proc call*(call_581353: Call_ContentPosDelete_581338; targetMerchantId: string;
          storeCode: string; merchantId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; dryRun: bool = false;
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## contentPosDelete
  ## Deletes a store for the given merchant.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
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
  var path_581354 = newJObject()
  var query_581355 = newJObject()
  add(query_581355, "fields", newJString(fields))
  add(query_581355, "quotaUser", newJString(quotaUser))
  add(query_581355, "alt", newJString(alt))
  add(query_581355, "dryRun", newJBool(dryRun))
  add(path_581354, "targetMerchantId", newJString(targetMerchantId))
  add(query_581355, "oauth_token", newJString(oauthToken))
  add(path_581354, "storeCode", newJString(storeCode))
  add(query_581355, "userIp", newJString(userIp))
  add(query_581355, "key", newJString(key))
  add(path_581354, "merchantId", newJString(merchantId))
  add(query_581355, "prettyPrint", newJBool(prettyPrint))
  result = call_581353.call(path_581354, query_581355, nil, nil, nil)

var contentPosDelete* = Call_ContentPosDelete_581338(name: "contentPosDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store/{storeCode}",
    validator: validate_ContentPosDelete_581339, base: "/content/v2",
    url: url_ContentPosDelete_581340, schemes: {Scheme.Https})
type
  Call_ContentProductsInsert_581374 = ref object of OpenApiRestCall_579421
proc url_ContentProductsInsert_581376(protocol: Scheme; host: string; base: string;
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

proc validate_ContentProductsInsert_581375(path: JsonNode; query: JsonNode;
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
  var valid_581377 = path.getOrDefault("merchantId")
  valid_581377 = validateParameter(valid_581377, JString, required = true,
                                 default = nil)
  if valid_581377 != nil:
    section.add "merchantId", valid_581377
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_581378 = query.getOrDefault("fields")
  valid_581378 = validateParameter(valid_581378, JString, required = false,
                                 default = nil)
  if valid_581378 != nil:
    section.add "fields", valid_581378
  var valid_581379 = query.getOrDefault("quotaUser")
  valid_581379 = validateParameter(valid_581379, JString, required = false,
                                 default = nil)
  if valid_581379 != nil:
    section.add "quotaUser", valid_581379
  var valid_581380 = query.getOrDefault("alt")
  valid_581380 = validateParameter(valid_581380, JString, required = false,
                                 default = newJString("json"))
  if valid_581380 != nil:
    section.add "alt", valid_581380
  var valid_581381 = query.getOrDefault("dryRun")
  valid_581381 = validateParameter(valid_581381, JBool, required = false, default = nil)
  if valid_581381 != nil:
    section.add "dryRun", valid_581381
  var valid_581382 = query.getOrDefault("oauth_token")
  valid_581382 = validateParameter(valid_581382, JString, required = false,
                                 default = nil)
  if valid_581382 != nil:
    section.add "oauth_token", valid_581382
  var valid_581383 = query.getOrDefault("userIp")
  valid_581383 = validateParameter(valid_581383, JString, required = false,
                                 default = nil)
  if valid_581383 != nil:
    section.add "userIp", valid_581383
  var valid_581384 = query.getOrDefault("key")
  valid_581384 = validateParameter(valid_581384, JString, required = false,
                                 default = nil)
  if valid_581384 != nil:
    section.add "key", valid_581384
  var valid_581385 = query.getOrDefault("prettyPrint")
  valid_581385 = validateParameter(valid_581385, JBool, required = false,
                                 default = newJBool(true))
  if valid_581385 != nil:
    section.add "prettyPrint", valid_581385
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

proc call*(call_581387: Call_ContentProductsInsert_581374; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a product to your Merchant Center account. If an item with the same channel, contentLanguage, offerId, and targetCountry already exists, this method updates that entry.
  ## 
  let valid = call_581387.validator(path, query, header, formData, body)
  let scheme = call_581387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581387.url(scheme.get, call_581387.host, call_581387.base,
                         call_581387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581387, url, valid)

proc call*(call_581388: Call_ContentProductsInsert_581374; merchantId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          dryRun: bool = false; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentProductsInsert
  ## Uploads a product to your Merchant Center account. If an item with the same channel, contentLanguage, offerId, and targetCountry already exists, this method updates that entry.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
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
  var path_581389 = newJObject()
  var query_581390 = newJObject()
  var body_581391 = newJObject()
  add(query_581390, "fields", newJString(fields))
  add(query_581390, "quotaUser", newJString(quotaUser))
  add(query_581390, "alt", newJString(alt))
  add(query_581390, "dryRun", newJBool(dryRun))
  add(query_581390, "oauth_token", newJString(oauthToken))
  add(query_581390, "userIp", newJString(userIp))
  add(query_581390, "key", newJString(key))
  add(path_581389, "merchantId", newJString(merchantId))
  if body != nil:
    body_581391 = body
  add(query_581390, "prettyPrint", newJBool(prettyPrint))
  result = call_581388.call(path_581389, query_581390, nil, nil, body_581391)

var contentProductsInsert* = Call_ContentProductsInsert_581374(
    name: "contentProductsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/products",
    validator: validate_ContentProductsInsert_581375, base: "/content/v2",
    url: url_ContentProductsInsert_581376, schemes: {Scheme.Https})
type
  Call_ContentProductsList_581356 = ref object of OpenApiRestCall_579421
proc url_ContentProductsList_581358(protocol: Scheme; host: string; base: string;
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

proc validate_ContentProductsList_581357(path: JsonNode; query: JsonNode;
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
  var valid_581359 = path.getOrDefault("merchantId")
  valid_581359 = validateParameter(valid_581359, JString, required = true,
                                 default = nil)
  if valid_581359 != nil:
    section.add "merchantId", valid_581359
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
  ##   includeInvalidInsertedItems: JBool
  ##                              : Flag to include the invalid inserted items in the result of the list request. By default the invalid items are not shown (the default value is false).
  section = newJObject()
  var valid_581360 = query.getOrDefault("fields")
  valid_581360 = validateParameter(valid_581360, JString, required = false,
                                 default = nil)
  if valid_581360 != nil:
    section.add "fields", valid_581360
  var valid_581361 = query.getOrDefault("pageToken")
  valid_581361 = validateParameter(valid_581361, JString, required = false,
                                 default = nil)
  if valid_581361 != nil:
    section.add "pageToken", valid_581361
  var valid_581362 = query.getOrDefault("quotaUser")
  valid_581362 = validateParameter(valid_581362, JString, required = false,
                                 default = nil)
  if valid_581362 != nil:
    section.add "quotaUser", valid_581362
  var valid_581363 = query.getOrDefault("alt")
  valid_581363 = validateParameter(valid_581363, JString, required = false,
                                 default = newJString("json"))
  if valid_581363 != nil:
    section.add "alt", valid_581363
  var valid_581364 = query.getOrDefault("oauth_token")
  valid_581364 = validateParameter(valid_581364, JString, required = false,
                                 default = nil)
  if valid_581364 != nil:
    section.add "oauth_token", valid_581364
  var valid_581365 = query.getOrDefault("userIp")
  valid_581365 = validateParameter(valid_581365, JString, required = false,
                                 default = nil)
  if valid_581365 != nil:
    section.add "userIp", valid_581365
  var valid_581366 = query.getOrDefault("maxResults")
  valid_581366 = validateParameter(valid_581366, JInt, required = false, default = nil)
  if valid_581366 != nil:
    section.add "maxResults", valid_581366
  var valid_581367 = query.getOrDefault("key")
  valid_581367 = validateParameter(valid_581367, JString, required = false,
                                 default = nil)
  if valid_581367 != nil:
    section.add "key", valid_581367
  var valid_581368 = query.getOrDefault("prettyPrint")
  valid_581368 = validateParameter(valid_581368, JBool, required = false,
                                 default = newJBool(true))
  if valid_581368 != nil:
    section.add "prettyPrint", valid_581368
  var valid_581369 = query.getOrDefault("includeInvalidInsertedItems")
  valid_581369 = validateParameter(valid_581369, JBool, required = false, default = nil)
  if valid_581369 != nil:
    section.add "includeInvalidInsertedItems", valid_581369
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581370: Call_ContentProductsList_581356; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the products in your Merchant Center account.
  ## 
  let valid = call_581370.validator(path, query, header, formData, body)
  let scheme = call_581370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581370.url(scheme.get, call_581370.host, call_581370.base,
                         call_581370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581370, url, valid)

proc call*(call_581371: Call_ContentProductsList_581356; merchantId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true;
          includeInvalidInsertedItems: bool = false): Recallable =
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
  ##   includeInvalidInsertedItems: bool
  ##                              : Flag to include the invalid inserted items in the result of the list request. By default the invalid items are not shown (the default value is false).
  var path_581372 = newJObject()
  var query_581373 = newJObject()
  add(query_581373, "fields", newJString(fields))
  add(query_581373, "pageToken", newJString(pageToken))
  add(query_581373, "quotaUser", newJString(quotaUser))
  add(query_581373, "alt", newJString(alt))
  add(query_581373, "oauth_token", newJString(oauthToken))
  add(query_581373, "userIp", newJString(userIp))
  add(query_581373, "maxResults", newJInt(maxResults))
  add(query_581373, "key", newJString(key))
  add(path_581372, "merchantId", newJString(merchantId))
  add(query_581373, "prettyPrint", newJBool(prettyPrint))
  add(query_581373, "includeInvalidInsertedItems",
      newJBool(includeInvalidInsertedItems))
  result = call_581371.call(path_581372, query_581373, nil, nil, nil)

var contentProductsList* = Call_ContentProductsList_581356(
    name: "contentProductsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/products",
    validator: validate_ContentProductsList_581357, base: "/content/v2",
    url: url_ContentProductsList_581358, schemes: {Scheme.Https})
type
  Call_ContentProductsGet_581392 = ref object of OpenApiRestCall_579421
proc url_ContentProductsGet_581394(protocol: Scheme; host: string; base: string;
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

proc validate_ContentProductsGet_581393(path: JsonNode; query: JsonNode;
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
  var valid_581395 = path.getOrDefault("merchantId")
  valid_581395 = validateParameter(valid_581395, JString, required = true,
                                 default = nil)
  if valid_581395 != nil:
    section.add "merchantId", valid_581395
  var valid_581396 = path.getOrDefault("productId")
  valid_581396 = validateParameter(valid_581396, JString, required = true,
                                 default = nil)
  if valid_581396 != nil:
    section.add "productId", valid_581396
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
  var valid_581397 = query.getOrDefault("fields")
  valid_581397 = validateParameter(valid_581397, JString, required = false,
                                 default = nil)
  if valid_581397 != nil:
    section.add "fields", valid_581397
  var valid_581398 = query.getOrDefault("quotaUser")
  valid_581398 = validateParameter(valid_581398, JString, required = false,
                                 default = nil)
  if valid_581398 != nil:
    section.add "quotaUser", valid_581398
  var valid_581399 = query.getOrDefault("alt")
  valid_581399 = validateParameter(valid_581399, JString, required = false,
                                 default = newJString("json"))
  if valid_581399 != nil:
    section.add "alt", valid_581399
  var valid_581400 = query.getOrDefault("oauth_token")
  valid_581400 = validateParameter(valid_581400, JString, required = false,
                                 default = nil)
  if valid_581400 != nil:
    section.add "oauth_token", valid_581400
  var valid_581401 = query.getOrDefault("userIp")
  valid_581401 = validateParameter(valid_581401, JString, required = false,
                                 default = nil)
  if valid_581401 != nil:
    section.add "userIp", valid_581401
  var valid_581402 = query.getOrDefault("key")
  valid_581402 = validateParameter(valid_581402, JString, required = false,
                                 default = nil)
  if valid_581402 != nil:
    section.add "key", valid_581402
  var valid_581403 = query.getOrDefault("prettyPrint")
  valid_581403 = validateParameter(valid_581403, JBool, required = false,
                                 default = newJBool(true))
  if valid_581403 != nil:
    section.add "prettyPrint", valid_581403
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581404: Call_ContentProductsGet_581392; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a product from your Merchant Center account.
  ## 
  let valid = call_581404.validator(path, query, header, formData, body)
  let scheme = call_581404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581404.url(scheme.get, call_581404.host, call_581404.base,
                         call_581404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581404, url, valid)

proc call*(call_581405: Call_ContentProductsGet_581392; merchantId: string;
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
  var path_581406 = newJObject()
  var query_581407 = newJObject()
  add(query_581407, "fields", newJString(fields))
  add(query_581407, "quotaUser", newJString(quotaUser))
  add(query_581407, "alt", newJString(alt))
  add(query_581407, "oauth_token", newJString(oauthToken))
  add(query_581407, "userIp", newJString(userIp))
  add(query_581407, "key", newJString(key))
  add(path_581406, "merchantId", newJString(merchantId))
  add(path_581406, "productId", newJString(productId))
  add(query_581407, "prettyPrint", newJBool(prettyPrint))
  result = call_581405.call(path_581406, query_581407, nil, nil, nil)

var contentProductsGet* = Call_ContentProductsGet_581392(
    name: "contentProductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/products/{productId}",
    validator: validate_ContentProductsGet_581393, base: "/content/v2",
    url: url_ContentProductsGet_581394, schemes: {Scheme.Https})
type
  Call_ContentProductsDelete_581408 = ref object of OpenApiRestCall_579421
proc url_ContentProductsDelete_581410(protocol: Scheme; host: string; base: string;
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

proc validate_ContentProductsDelete_581409(path: JsonNode; query: JsonNode;
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
  var valid_581411 = path.getOrDefault("merchantId")
  valid_581411 = validateParameter(valid_581411, JString, required = true,
                                 default = nil)
  if valid_581411 != nil:
    section.add "merchantId", valid_581411
  var valid_581412 = path.getOrDefault("productId")
  valid_581412 = validateParameter(valid_581412, JString, required = true,
                                 default = nil)
  if valid_581412 != nil:
    section.add "productId", valid_581412
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_581413 = query.getOrDefault("fields")
  valid_581413 = validateParameter(valid_581413, JString, required = false,
                                 default = nil)
  if valid_581413 != nil:
    section.add "fields", valid_581413
  var valid_581414 = query.getOrDefault("quotaUser")
  valid_581414 = validateParameter(valid_581414, JString, required = false,
                                 default = nil)
  if valid_581414 != nil:
    section.add "quotaUser", valid_581414
  var valid_581415 = query.getOrDefault("alt")
  valid_581415 = validateParameter(valid_581415, JString, required = false,
                                 default = newJString("json"))
  if valid_581415 != nil:
    section.add "alt", valid_581415
  var valid_581416 = query.getOrDefault("dryRun")
  valid_581416 = validateParameter(valid_581416, JBool, required = false, default = nil)
  if valid_581416 != nil:
    section.add "dryRun", valid_581416
  var valid_581417 = query.getOrDefault("oauth_token")
  valid_581417 = validateParameter(valid_581417, JString, required = false,
                                 default = nil)
  if valid_581417 != nil:
    section.add "oauth_token", valid_581417
  var valid_581418 = query.getOrDefault("userIp")
  valid_581418 = validateParameter(valid_581418, JString, required = false,
                                 default = nil)
  if valid_581418 != nil:
    section.add "userIp", valid_581418
  var valid_581419 = query.getOrDefault("key")
  valid_581419 = validateParameter(valid_581419, JString, required = false,
                                 default = nil)
  if valid_581419 != nil:
    section.add "key", valid_581419
  var valid_581420 = query.getOrDefault("prettyPrint")
  valid_581420 = validateParameter(valid_581420, JBool, required = false,
                                 default = newJBool(true))
  if valid_581420 != nil:
    section.add "prettyPrint", valid_581420
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581421: Call_ContentProductsDelete_581408; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a product from your Merchant Center account.
  ## 
  let valid = call_581421.validator(path, query, header, formData, body)
  let scheme = call_581421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581421.url(scheme.get, call_581421.host, call_581421.base,
                         call_581421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581421, url, valid)

proc call*(call_581422: Call_ContentProductsDelete_581408; merchantId: string;
          productId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; dryRun: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## contentProductsDelete
  ## Deletes a product from your Merchant Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
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
  var path_581423 = newJObject()
  var query_581424 = newJObject()
  add(query_581424, "fields", newJString(fields))
  add(query_581424, "quotaUser", newJString(quotaUser))
  add(query_581424, "alt", newJString(alt))
  add(query_581424, "dryRun", newJBool(dryRun))
  add(query_581424, "oauth_token", newJString(oauthToken))
  add(query_581424, "userIp", newJString(userIp))
  add(query_581424, "key", newJString(key))
  add(path_581423, "merchantId", newJString(merchantId))
  add(path_581423, "productId", newJString(productId))
  add(query_581424, "prettyPrint", newJBool(prettyPrint))
  result = call_581422.call(path_581423, query_581424, nil, nil, nil)

var contentProductsDelete* = Call_ContentProductsDelete_581408(
    name: "contentProductsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/products/{productId}",
    validator: validate_ContentProductsDelete_581409, base: "/content/v2",
    url: url_ContentProductsDelete_581410, schemes: {Scheme.Https})
type
  Call_ContentProductstatusesList_581425 = ref object of OpenApiRestCall_579421
proc url_ContentProductstatusesList_581427(protocol: Scheme; host: string;
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

proc validate_ContentProductstatusesList_581426(path: JsonNode; query: JsonNode;
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
  var valid_581428 = path.getOrDefault("merchantId")
  valid_581428 = validateParameter(valid_581428, JString, required = true,
                                 default = nil)
  if valid_581428 != nil:
    section.add "merchantId", valid_581428
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
  ##   includeAttributes: JBool
  ##                    : Flag to include full product data in the results of the list request. The default value is false.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   destinations: JArray
  ##               : If set, only issues for the specified destinations are returned, otherwise only issues for the Shopping destination.
  ##   includeInvalidInsertedItems: JBool
  ##                              : Flag to include the invalid inserted items in the result of the list request. By default the invalid items are not shown (the default value is false).
  section = newJObject()
  var valid_581429 = query.getOrDefault("fields")
  valid_581429 = validateParameter(valid_581429, JString, required = false,
                                 default = nil)
  if valid_581429 != nil:
    section.add "fields", valid_581429
  var valid_581430 = query.getOrDefault("pageToken")
  valid_581430 = validateParameter(valid_581430, JString, required = false,
                                 default = nil)
  if valid_581430 != nil:
    section.add "pageToken", valid_581430
  var valid_581431 = query.getOrDefault("quotaUser")
  valid_581431 = validateParameter(valid_581431, JString, required = false,
                                 default = nil)
  if valid_581431 != nil:
    section.add "quotaUser", valid_581431
  var valid_581432 = query.getOrDefault("alt")
  valid_581432 = validateParameter(valid_581432, JString, required = false,
                                 default = newJString("json"))
  if valid_581432 != nil:
    section.add "alt", valid_581432
  var valid_581433 = query.getOrDefault("oauth_token")
  valid_581433 = validateParameter(valid_581433, JString, required = false,
                                 default = nil)
  if valid_581433 != nil:
    section.add "oauth_token", valid_581433
  var valid_581434 = query.getOrDefault("userIp")
  valid_581434 = validateParameter(valid_581434, JString, required = false,
                                 default = nil)
  if valid_581434 != nil:
    section.add "userIp", valid_581434
  var valid_581435 = query.getOrDefault("maxResults")
  valid_581435 = validateParameter(valid_581435, JInt, required = false, default = nil)
  if valid_581435 != nil:
    section.add "maxResults", valid_581435
  var valid_581436 = query.getOrDefault("includeAttributes")
  valid_581436 = validateParameter(valid_581436, JBool, required = false, default = nil)
  if valid_581436 != nil:
    section.add "includeAttributes", valid_581436
  var valid_581437 = query.getOrDefault("key")
  valid_581437 = validateParameter(valid_581437, JString, required = false,
                                 default = nil)
  if valid_581437 != nil:
    section.add "key", valid_581437
  var valid_581438 = query.getOrDefault("prettyPrint")
  valid_581438 = validateParameter(valid_581438, JBool, required = false,
                                 default = newJBool(true))
  if valid_581438 != nil:
    section.add "prettyPrint", valid_581438
  var valid_581439 = query.getOrDefault("destinations")
  valid_581439 = validateParameter(valid_581439, JArray, required = false,
                                 default = nil)
  if valid_581439 != nil:
    section.add "destinations", valid_581439
  var valid_581440 = query.getOrDefault("includeInvalidInsertedItems")
  valid_581440 = validateParameter(valid_581440, JBool, required = false, default = nil)
  if valid_581440 != nil:
    section.add "includeInvalidInsertedItems", valid_581440
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581441: Call_ContentProductstatusesList_581425; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the products in your Merchant Center account.
  ## 
  let valid = call_581441.validator(path, query, header, formData, body)
  let scheme = call_581441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581441.url(scheme.get, call_581441.host, call_581441.base,
                         call_581441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581441, url, valid)

proc call*(call_581442: Call_ContentProductstatusesList_581425; merchantId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; includeAttributes: bool = false; key: string = "";
          prettyPrint: bool = true; destinations: JsonNode = nil;
          includeInvalidInsertedItems: bool = false): Recallable =
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
  ##   includeAttributes: bool
  ##                    : Flag to include full product data in the results of the list request. The default value is false.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   merchantId: string (required)
  ##             : The ID of the account that contains the products. This account cannot be a multi-client account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   destinations: JArray
  ##               : If set, only issues for the specified destinations are returned, otherwise only issues for the Shopping destination.
  ##   includeInvalidInsertedItems: bool
  ##                              : Flag to include the invalid inserted items in the result of the list request. By default the invalid items are not shown (the default value is false).
  var path_581443 = newJObject()
  var query_581444 = newJObject()
  add(query_581444, "fields", newJString(fields))
  add(query_581444, "pageToken", newJString(pageToken))
  add(query_581444, "quotaUser", newJString(quotaUser))
  add(query_581444, "alt", newJString(alt))
  add(query_581444, "oauth_token", newJString(oauthToken))
  add(query_581444, "userIp", newJString(userIp))
  add(query_581444, "maxResults", newJInt(maxResults))
  add(query_581444, "includeAttributes", newJBool(includeAttributes))
  add(query_581444, "key", newJString(key))
  add(path_581443, "merchantId", newJString(merchantId))
  add(query_581444, "prettyPrint", newJBool(prettyPrint))
  if destinations != nil:
    query_581444.add "destinations", destinations
  add(query_581444, "includeInvalidInsertedItems",
      newJBool(includeInvalidInsertedItems))
  result = call_581442.call(path_581443, query_581444, nil, nil, nil)

var contentProductstatusesList* = Call_ContentProductstatusesList_581425(
    name: "contentProductstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/productstatuses",
    validator: validate_ContentProductstatusesList_581426, base: "/content/v2",
    url: url_ContentProductstatusesList_581427, schemes: {Scheme.Https})
type
  Call_ContentProductstatusesGet_581445 = ref object of OpenApiRestCall_579421
proc url_ContentProductstatusesGet_581447(protocol: Scheme; host: string;
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

proc validate_ContentProductstatusesGet_581446(path: JsonNode; query: JsonNode;
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
  var valid_581448 = path.getOrDefault("merchantId")
  valid_581448 = validateParameter(valid_581448, JString, required = true,
                                 default = nil)
  if valid_581448 != nil:
    section.add "merchantId", valid_581448
  var valid_581449 = path.getOrDefault("productId")
  valid_581449 = validateParameter(valid_581449, JString, required = true,
                                 default = nil)
  if valid_581449 != nil:
    section.add "productId", valid_581449
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
  ##   includeAttributes: JBool
  ##                    : Flag to include full product data in the result of this get request. The default value is false.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   destinations: JArray
  ##               : If set, only issues for the specified destinations are returned, otherwise only issues for the Shopping destination.
  section = newJObject()
  var valid_581450 = query.getOrDefault("fields")
  valid_581450 = validateParameter(valid_581450, JString, required = false,
                                 default = nil)
  if valid_581450 != nil:
    section.add "fields", valid_581450
  var valid_581451 = query.getOrDefault("quotaUser")
  valid_581451 = validateParameter(valid_581451, JString, required = false,
                                 default = nil)
  if valid_581451 != nil:
    section.add "quotaUser", valid_581451
  var valid_581452 = query.getOrDefault("alt")
  valid_581452 = validateParameter(valid_581452, JString, required = false,
                                 default = newJString("json"))
  if valid_581452 != nil:
    section.add "alt", valid_581452
  var valid_581453 = query.getOrDefault("oauth_token")
  valid_581453 = validateParameter(valid_581453, JString, required = false,
                                 default = nil)
  if valid_581453 != nil:
    section.add "oauth_token", valid_581453
  var valid_581454 = query.getOrDefault("userIp")
  valid_581454 = validateParameter(valid_581454, JString, required = false,
                                 default = nil)
  if valid_581454 != nil:
    section.add "userIp", valid_581454
  var valid_581455 = query.getOrDefault("includeAttributes")
  valid_581455 = validateParameter(valid_581455, JBool, required = false, default = nil)
  if valid_581455 != nil:
    section.add "includeAttributes", valid_581455
  var valid_581456 = query.getOrDefault("key")
  valid_581456 = validateParameter(valid_581456, JString, required = false,
                                 default = nil)
  if valid_581456 != nil:
    section.add "key", valid_581456
  var valid_581457 = query.getOrDefault("prettyPrint")
  valid_581457 = validateParameter(valid_581457, JBool, required = false,
                                 default = newJBool(true))
  if valid_581457 != nil:
    section.add "prettyPrint", valid_581457
  var valid_581458 = query.getOrDefault("destinations")
  valid_581458 = validateParameter(valid_581458, JArray, required = false,
                                 default = nil)
  if valid_581458 != nil:
    section.add "destinations", valid_581458
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581459: Call_ContentProductstatusesGet_581445; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the status of a product from your Merchant Center account.
  ## 
  let valid = call_581459.validator(path, query, header, formData, body)
  let scheme = call_581459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581459.url(scheme.get, call_581459.host, call_581459.base,
                         call_581459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581459, url, valid)

proc call*(call_581460: Call_ContentProductstatusesGet_581445; merchantId: string;
          productId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          includeAttributes: bool = false; key: string = ""; prettyPrint: bool = true;
          destinations: JsonNode = nil): Recallable =
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
  ##   includeAttributes: bool
  ##                    : Flag to include full product data in the result of this get request. The default value is false.
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
  var path_581461 = newJObject()
  var query_581462 = newJObject()
  add(query_581462, "fields", newJString(fields))
  add(query_581462, "quotaUser", newJString(quotaUser))
  add(query_581462, "alt", newJString(alt))
  add(query_581462, "oauth_token", newJString(oauthToken))
  add(query_581462, "userIp", newJString(userIp))
  add(query_581462, "includeAttributes", newJBool(includeAttributes))
  add(query_581462, "key", newJString(key))
  add(path_581461, "merchantId", newJString(merchantId))
  add(path_581461, "productId", newJString(productId))
  add(query_581462, "prettyPrint", newJBool(prettyPrint))
  if destinations != nil:
    query_581462.add "destinations", destinations
  result = call_581460.call(path_581461, query_581462, nil, nil, nil)

var contentProductstatusesGet* = Call_ContentProductstatusesGet_581445(
    name: "contentProductstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/productstatuses/{productId}",
    validator: validate_ContentProductstatusesGet_581446, base: "/content/v2",
    url: url_ContentProductstatusesGet_581447, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsList_581463 = ref object of OpenApiRestCall_579421
proc url_ContentShippingsettingsList_581465(protocol: Scheme; host: string;
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

proc validate_ContentShippingsettingsList_581464(path: JsonNode; query: JsonNode;
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
  var valid_581466 = path.getOrDefault("merchantId")
  valid_581466 = validateParameter(valid_581466, JString, required = true,
                                 default = nil)
  if valid_581466 != nil:
    section.add "merchantId", valid_581466
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
  var valid_581467 = query.getOrDefault("fields")
  valid_581467 = validateParameter(valid_581467, JString, required = false,
                                 default = nil)
  if valid_581467 != nil:
    section.add "fields", valid_581467
  var valid_581468 = query.getOrDefault("pageToken")
  valid_581468 = validateParameter(valid_581468, JString, required = false,
                                 default = nil)
  if valid_581468 != nil:
    section.add "pageToken", valid_581468
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
  var valid_581473 = query.getOrDefault("maxResults")
  valid_581473 = validateParameter(valid_581473, JInt, required = false, default = nil)
  if valid_581473 != nil:
    section.add "maxResults", valid_581473
  var valid_581474 = query.getOrDefault("key")
  valid_581474 = validateParameter(valid_581474, JString, required = false,
                                 default = nil)
  if valid_581474 != nil:
    section.add "key", valid_581474
  var valid_581475 = query.getOrDefault("prettyPrint")
  valid_581475 = validateParameter(valid_581475, JBool, required = false,
                                 default = newJBool(true))
  if valid_581475 != nil:
    section.add "prettyPrint", valid_581475
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581476: Call_ContentShippingsettingsList_581463; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the shipping settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_581476.validator(path, query, header, formData, body)
  let scheme = call_581476.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581476.url(scheme.get, call_581476.host, call_581476.base,
                         call_581476.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581476, url, valid)

proc call*(call_581477: Call_ContentShippingsettingsList_581463;
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
  var path_581478 = newJObject()
  var query_581479 = newJObject()
  add(query_581479, "fields", newJString(fields))
  add(query_581479, "pageToken", newJString(pageToken))
  add(query_581479, "quotaUser", newJString(quotaUser))
  add(query_581479, "alt", newJString(alt))
  add(query_581479, "oauth_token", newJString(oauthToken))
  add(query_581479, "userIp", newJString(userIp))
  add(query_581479, "maxResults", newJInt(maxResults))
  add(query_581479, "key", newJString(key))
  add(path_581478, "merchantId", newJString(merchantId))
  add(query_581479, "prettyPrint", newJBool(prettyPrint))
  result = call_581477.call(path_581478, query_581479, nil, nil, nil)

var contentShippingsettingsList* = Call_ContentShippingsettingsList_581463(
    name: "contentShippingsettingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/shippingsettings",
    validator: validate_ContentShippingsettingsList_581464, base: "/content/v2",
    url: url_ContentShippingsettingsList_581465, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsUpdate_581496 = ref object of OpenApiRestCall_579421
proc url_ContentShippingsettingsUpdate_581498(protocol: Scheme; host: string;
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

proc validate_ContentShippingsettingsUpdate_581497(path: JsonNode; query: JsonNode;
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
  var valid_581499 = path.getOrDefault("accountId")
  valid_581499 = validateParameter(valid_581499, JString, required = true,
                                 default = nil)
  if valid_581499 != nil:
    section.add "accountId", valid_581499
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
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
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
  var valid_581504 = query.getOrDefault("dryRun")
  valid_581504 = validateParameter(valid_581504, JBool, required = false, default = nil)
  if valid_581504 != nil:
    section.add "dryRun", valid_581504
  var valid_581505 = query.getOrDefault("oauth_token")
  valid_581505 = validateParameter(valid_581505, JString, required = false,
                                 default = nil)
  if valid_581505 != nil:
    section.add "oauth_token", valid_581505
  var valid_581506 = query.getOrDefault("userIp")
  valid_581506 = validateParameter(valid_581506, JString, required = false,
                                 default = nil)
  if valid_581506 != nil:
    section.add "userIp", valid_581506
  var valid_581507 = query.getOrDefault("key")
  valid_581507 = validateParameter(valid_581507, JString, required = false,
                                 default = nil)
  if valid_581507 != nil:
    section.add "key", valid_581507
  var valid_581508 = query.getOrDefault("prettyPrint")
  valid_581508 = validateParameter(valid_581508, JBool, required = false,
                                 default = newJBool(true))
  if valid_581508 != nil:
    section.add "prettyPrint", valid_581508
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

proc call*(call_581510: Call_ContentShippingsettingsUpdate_581496; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the shipping settings of the account.
  ## 
  let valid = call_581510.validator(path, query, header, formData, body)
  let scheme = call_581510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581510.url(scheme.get, call_581510.host, call_581510.base,
                         call_581510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581510, url, valid)

proc call*(call_581511: Call_ContentShippingsettingsUpdate_581496;
          accountId: string; merchantId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; dryRun: bool = false;
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentShippingsettingsUpdate
  ## Updates the shipping settings of the account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
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
  var path_581512 = newJObject()
  var query_581513 = newJObject()
  var body_581514 = newJObject()
  add(query_581513, "fields", newJString(fields))
  add(query_581513, "quotaUser", newJString(quotaUser))
  add(query_581513, "alt", newJString(alt))
  add(query_581513, "dryRun", newJBool(dryRun))
  add(query_581513, "oauth_token", newJString(oauthToken))
  add(path_581512, "accountId", newJString(accountId))
  add(query_581513, "userIp", newJString(userIp))
  add(query_581513, "key", newJString(key))
  add(path_581512, "merchantId", newJString(merchantId))
  if body != nil:
    body_581514 = body
  add(query_581513, "prettyPrint", newJBool(prettyPrint))
  result = call_581511.call(path_581512, query_581513, nil, nil, body_581514)

var contentShippingsettingsUpdate* = Call_ContentShippingsettingsUpdate_581496(
    name: "contentShippingsettingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{merchantId}/shippingsettings/{accountId}",
    validator: validate_ContentShippingsettingsUpdate_581497, base: "/content/v2",
    url: url_ContentShippingsettingsUpdate_581498, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGet_581480 = ref object of OpenApiRestCall_579421
proc url_ContentShippingsettingsGet_581482(protocol: Scheme; host: string;
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

proc validate_ContentShippingsettingsGet_581481(path: JsonNode; query: JsonNode;
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
  var valid_581483 = path.getOrDefault("accountId")
  valid_581483 = validateParameter(valid_581483, JString, required = true,
                                 default = nil)
  if valid_581483 != nil:
    section.add "accountId", valid_581483
  var valid_581484 = path.getOrDefault("merchantId")
  valid_581484 = validateParameter(valid_581484, JString, required = true,
                                 default = nil)
  if valid_581484 != nil:
    section.add "merchantId", valid_581484
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
  var valid_581485 = query.getOrDefault("fields")
  valid_581485 = validateParameter(valid_581485, JString, required = false,
                                 default = nil)
  if valid_581485 != nil:
    section.add "fields", valid_581485
  var valid_581486 = query.getOrDefault("quotaUser")
  valid_581486 = validateParameter(valid_581486, JString, required = false,
                                 default = nil)
  if valid_581486 != nil:
    section.add "quotaUser", valid_581486
  var valid_581487 = query.getOrDefault("alt")
  valid_581487 = validateParameter(valid_581487, JString, required = false,
                                 default = newJString("json"))
  if valid_581487 != nil:
    section.add "alt", valid_581487
  var valid_581488 = query.getOrDefault("oauth_token")
  valid_581488 = validateParameter(valid_581488, JString, required = false,
                                 default = nil)
  if valid_581488 != nil:
    section.add "oauth_token", valid_581488
  var valid_581489 = query.getOrDefault("userIp")
  valid_581489 = validateParameter(valid_581489, JString, required = false,
                                 default = nil)
  if valid_581489 != nil:
    section.add "userIp", valid_581489
  var valid_581490 = query.getOrDefault("key")
  valid_581490 = validateParameter(valid_581490, JString, required = false,
                                 default = nil)
  if valid_581490 != nil:
    section.add "key", valid_581490
  var valid_581491 = query.getOrDefault("prettyPrint")
  valid_581491 = validateParameter(valid_581491, JBool, required = false,
                                 default = newJBool(true))
  if valid_581491 != nil:
    section.add "prettyPrint", valid_581491
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581492: Call_ContentShippingsettingsGet_581480; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the shipping settings of the account.
  ## 
  let valid = call_581492.validator(path, query, header, formData, body)
  let scheme = call_581492.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581492.url(scheme.get, call_581492.host, call_581492.base,
                         call_581492.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581492, url, valid)

proc call*(call_581493: Call_ContentShippingsettingsGet_581480; accountId: string;
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
  var path_581494 = newJObject()
  var query_581495 = newJObject()
  add(query_581495, "fields", newJString(fields))
  add(query_581495, "quotaUser", newJString(quotaUser))
  add(query_581495, "alt", newJString(alt))
  add(query_581495, "oauth_token", newJString(oauthToken))
  add(path_581494, "accountId", newJString(accountId))
  add(query_581495, "userIp", newJString(userIp))
  add(query_581495, "key", newJString(key))
  add(path_581494, "merchantId", newJString(merchantId))
  add(query_581495, "prettyPrint", newJBool(prettyPrint))
  result = call_581493.call(path_581494, query_581495, nil, nil, nil)

var contentShippingsettingsGet* = Call_ContentShippingsettingsGet_581480(
    name: "contentShippingsettingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/shippingsettings/{accountId}",
    validator: validate_ContentShippingsettingsGet_581481, base: "/content/v2",
    url: url_ContentShippingsettingsGet_581482, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsPatch_581515 = ref object of OpenApiRestCall_579421
proc url_ContentShippingsettingsPatch_581517(protocol: Scheme; host: string;
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

proc validate_ContentShippingsettingsPatch_581516(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the shipping settings of the account. This method supports patch semantics.
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
  var valid_581518 = path.getOrDefault("accountId")
  valid_581518 = validateParameter(valid_581518, JString, required = true,
                                 default = nil)
  if valid_581518 != nil:
    section.add "accountId", valid_581518
  var valid_581519 = path.getOrDefault("merchantId")
  valid_581519 = validateParameter(valid_581519, JString, required = true,
                                 default = nil)
  if valid_581519 != nil:
    section.add "merchantId", valid_581519
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_581520 = query.getOrDefault("fields")
  valid_581520 = validateParameter(valid_581520, JString, required = false,
                                 default = nil)
  if valid_581520 != nil:
    section.add "fields", valid_581520
  var valid_581521 = query.getOrDefault("quotaUser")
  valid_581521 = validateParameter(valid_581521, JString, required = false,
                                 default = nil)
  if valid_581521 != nil:
    section.add "quotaUser", valid_581521
  var valid_581522 = query.getOrDefault("alt")
  valid_581522 = validateParameter(valid_581522, JString, required = false,
                                 default = newJString("json"))
  if valid_581522 != nil:
    section.add "alt", valid_581522
  var valid_581523 = query.getOrDefault("dryRun")
  valid_581523 = validateParameter(valid_581523, JBool, required = false, default = nil)
  if valid_581523 != nil:
    section.add "dryRun", valid_581523
  var valid_581524 = query.getOrDefault("oauth_token")
  valid_581524 = validateParameter(valid_581524, JString, required = false,
                                 default = nil)
  if valid_581524 != nil:
    section.add "oauth_token", valid_581524
  var valid_581525 = query.getOrDefault("userIp")
  valid_581525 = validateParameter(valid_581525, JString, required = false,
                                 default = nil)
  if valid_581525 != nil:
    section.add "userIp", valid_581525
  var valid_581526 = query.getOrDefault("key")
  valid_581526 = validateParameter(valid_581526, JString, required = false,
                                 default = nil)
  if valid_581526 != nil:
    section.add "key", valid_581526
  var valid_581527 = query.getOrDefault("prettyPrint")
  valid_581527 = validateParameter(valid_581527, JBool, required = false,
                                 default = newJBool(true))
  if valid_581527 != nil:
    section.add "prettyPrint", valid_581527
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

proc call*(call_581529: Call_ContentShippingsettingsPatch_581515; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the shipping settings of the account. This method supports patch semantics.
  ## 
  let valid = call_581529.validator(path, query, header, formData, body)
  let scheme = call_581529.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581529.url(scheme.get, call_581529.host, call_581529.base,
                         call_581529.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581529, url, valid)

proc call*(call_581530: Call_ContentShippingsettingsPatch_581515;
          accountId: string; merchantId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; dryRun: bool = false;
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## contentShippingsettingsPatch
  ## Updates the shipping settings of the account. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
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
  var path_581531 = newJObject()
  var query_581532 = newJObject()
  var body_581533 = newJObject()
  add(query_581532, "fields", newJString(fields))
  add(query_581532, "quotaUser", newJString(quotaUser))
  add(query_581532, "alt", newJString(alt))
  add(query_581532, "dryRun", newJBool(dryRun))
  add(query_581532, "oauth_token", newJString(oauthToken))
  add(path_581531, "accountId", newJString(accountId))
  add(query_581532, "userIp", newJString(userIp))
  add(query_581532, "key", newJString(key))
  add(path_581531, "merchantId", newJString(merchantId))
  if body != nil:
    body_581533 = body
  add(query_581532, "prettyPrint", newJBool(prettyPrint))
  result = call_581530.call(path_581531, query_581532, nil, nil, body_581533)

var contentShippingsettingsPatch* = Call_ContentShippingsettingsPatch_581515(
    name: "contentShippingsettingsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{merchantId}/shippingsettings/{accountId}",
    validator: validate_ContentShippingsettingsPatch_581516, base: "/content/v2",
    url: url_ContentShippingsettingsPatch_581517, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGetsupportedcarriers_581534 = ref object of OpenApiRestCall_579421
proc url_ContentShippingsettingsGetsupportedcarriers_581536(protocol: Scheme;
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

proc validate_ContentShippingsettingsGetsupportedcarriers_581535(path: JsonNode;
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
  var valid_581537 = path.getOrDefault("merchantId")
  valid_581537 = validateParameter(valid_581537, JString, required = true,
                                 default = nil)
  if valid_581537 != nil:
    section.add "merchantId", valid_581537
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
  var valid_581538 = query.getOrDefault("fields")
  valid_581538 = validateParameter(valid_581538, JString, required = false,
                                 default = nil)
  if valid_581538 != nil:
    section.add "fields", valid_581538
  var valid_581539 = query.getOrDefault("quotaUser")
  valid_581539 = validateParameter(valid_581539, JString, required = false,
                                 default = nil)
  if valid_581539 != nil:
    section.add "quotaUser", valid_581539
  var valid_581540 = query.getOrDefault("alt")
  valid_581540 = validateParameter(valid_581540, JString, required = false,
                                 default = newJString("json"))
  if valid_581540 != nil:
    section.add "alt", valid_581540
  var valid_581541 = query.getOrDefault("oauth_token")
  valid_581541 = validateParameter(valid_581541, JString, required = false,
                                 default = nil)
  if valid_581541 != nil:
    section.add "oauth_token", valid_581541
  var valid_581542 = query.getOrDefault("userIp")
  valid_581542 = validateParameter(valid_581542, JString, required = false,
                                 default = nil)
  if valid_581542 != nil:
    section.add "userIp", valid_581542
  var valid_581543 = query.getOrDefault("key")
  valid_581543 = validateParameter(valid_581543, JString, required = false,
                                 default = nil)
  if valid_581543 != nil:
    section.add "key", valid_581543
  var valid_581544 = query.getOrDefault("prettyPrint")
  valid_581544 = validateParameter(valid_581544, JBool, required = false,
                                 default = newJBool(true))
  if valid_581544 != nil:
    section.add "prettyPrint", valid_581544
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581545: Call_ContentShippingsettingsGetsupportedcarriers_581534;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves supported carriers and carrier services for an account.
  ## 
  let valid = call_581545.validator(path, query, header, formData, body)
  let scheme = call_581545.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581545.url(scheme.get, call_581545.host, call_581545.base,
                         call_581545.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581545, url, valid)

proc call*(call_581546: Call_ContentShippingsettingsGetsupportedcarriers_581534;
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
  var path_581547 = newJObject()
  var query_581548 = newJObject()
  add(query_581548, "fields", newJString(fields))
  add(query_581548, "quotaUser", newJString(quotaUser))
  add(query_581548, "alt", newJString(alt))
  add(query_581548, "oauth_token", newJString(oauthToken))
  add(query_581548, "userIp", newJString(userIp))
  add(query_581548, "key", newJString(key))
  add(path_581547, "merchantId", newJString(merchantId))
  add(query_581548, "prettyPrint", newJBool(prettyPrint))
  result = call_581546.call(path_581547, query_581548, nil, nil, nil)

var contentShippingsettingsGetsupportedcarriers* = Call_ContentShippingsettingsGetsupportedcarriers_581534(
    name: "contentShippingsettingsGetsupportedcarriers", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/supportedCarriers",
    validator: validate_ContentShippingsettingsGetsupportedcarriers_581535,
    base: "/content/v2", url: url_ContentShippingsettingsGetsupportedcarriers_581536,
    schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGetsupportedholidays_581549 = ref object of OpenApiRestCall_579421
proc url_ContentShippingsettingsGetsupportedholidays_581551(protocol: Scheme;
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

proc validate_ContentShippingsettingsGetsupportedholidays_581550(path: JsonNode;
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
  var valid_581552 = path.getOrDefault("merchantId")
  valid_581552 = validateParameter(valid_581552, JString, required = true,
                                 default = nil)
  if valid_581552 != nil:
    section.add "merchantId", valid_581552
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
  var valid_581553 = query.getOrDefault("fields")
  valid_581553 = validateParameter(valid_581553, JString, required = false,
                                 default = nil)
  if valid_581553 != nil:
    section.add "fields", valid_581553
  var valid_581554 = query.getOrDefault("quotaUser")
  valid_581554 = validateParameter(valid_581554, JString, required = false,
                                 default = nil)
  if valid_581554 != nil:
    section.add "quotaUser", valid_581554
  var valid_581555 = query.getOrDefault("alt")
  valid_581555 = validateParameter(valid_581555, JString, required = false,
                                 default = newJString("json"))
  if valid_581555 != nil:
    section.add "alt", valid_581555
  var valid_581556 = query.getOrDefault("oauth_token")
  valid_581556 = validateParameter(valid_581556, JString, required = false,
                                 default = nil)
  if valid_581556 != nil:
    section.add "oauth_token", valid_581556
  var valid_581557 = query.getOrDefault("userIp")
  valid_581557 = validateParameter(valid_581557, JString, required = false,
                                 default = nil)
  if valid_581557 != nil:
    section.add "userIp", valid_581557
  var valid_581558 = query.getOrDefault("key")
  valid_581558 = validateParameter(valid_581558, JString, required = false,
                                 default = nil)
  if valid_581558 != nil:
    section.add "key", valid_581558
  var valid_581559 = query.getOrDefault("prettyPrint")
  valid_581559 = validateParameter(valid_581559, JBool, required = false,
                                 default = newJBool(true))
  if valid_581559 != nil:
    section.add "prettyPrint", valid_581559
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581560: Call_ContentShippingsettingsGetsupportedholidays_581549;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves supported holidays for an account.
  ## 
  let valid = call_581560.validator(path, query, header, formData, body)
  let scheme = call_581560.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581560.url(scheme.get, call_581560.host, call_581560.base,
                         call_581560.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581560, url, valid)

proc call*(call_581561: Call_ContentShippingsettingsGetsupportedholidays_581549;
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
  var path_581562 = newJObject()
  var query_581563 = newJObject()
  add(query_581563, "fields", newJString(fields))
  add(query_581563, "quotaUser", newJString(quotaUser))
  add(query_581563, "alt", newJString(alt))
  add(query_581563, "oauth_token", newJString(oauthToken))
  add(query_581563, "userIp", newJString(userIp))
  add(query_581563, "key", newJString(key))
  add(path_581562, "merchantId", newJString(merchantId))
  add(query_581563, "prettyPrint", newJBool(prettyPrint))
  result = call_581561.call(path_581562, query_581563, nil, nil, nil)

var contentShippingsettingsGetsupportedholidays* = Call_ContentShippingsettingsGetsupportedholidays_581549(
    name: "contentShippingsettingsGetsupportedholidays", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/supportedHolidays",
    validator: validate_ContentShippingsettingsGetsupportedholidays_581550,
    base: "/content/v2", url: url_ContentShippingsettingsGetsupportedholidays_581551,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersCreatetestorder_581564 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersCreatetestorder_581566(protocol: Scheme; host: string;
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

proc validate_ContentOrdersCreatetestorder_581565(path: JsonNode; query: JsonNode;
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
  var valid_581567 = path.getOrDefault("merchantId")
  valid_581567 = validateParameter(valid_581567, JString, required = true,
                                 default = nil)
  if valid_581567 != nil:
    section.add "merchantId", valid_581567
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
  var valid_581568 = query.getOrDefault("fields")
  valid_581568 = validateParameter(valid_581568, JString, required = false,
                                 default = nil)
  if valid_581568 != nil:
    section.add "fields", valid_581568
  var valid_581569 = query.getOrDefault("quotaUser")
  valid_581569 = validateParameter(valid_581569, JString, required = false,
                                 default = nil)
  if valid_581569 != nil:
    section.add "quotaUser", valid_581569
  var valid_581570 = query.getOrDefault("alt")
  valid_581570 = validateParameter(valid_581570, JString, required = false,
                                 default = newJString("json"))
  if valid_581570 != nil:
    section.add "alt", valid_581570
  var valid_581571 = query.getOrDefault("oauth_token")
  valid_581571 = validateParameter(valid_581571, JString, required = false,
                                 default = nil)
  if valid_581571 != nil:
    section.add "oauth_token", valid_581571
  var valid_581572 = query.getOrDefault("userIp")
  valid_581572 = validateParameter(valid_581572, JString, required = false,
                                 default = nil)
  if valid_581572 != nil:
    section.add "userIp", valid_581572
  var valid_581573 = query.getOrDefault("key")
  valid_581573 = validateParameter(valid_581573, JString, required = false,
                                 default = nil)
  if valid_581573 != nil:
    section.add "key", valid_581573
  var valid_581574 = query.getOrDefault("prettyPrint")
  valid_581574 = validateParameter(valid_581574, JBool, required = false,
                                 default = newJBool(true))
  if valid_581574 != nil:
    section.add "prettyPrint", valid_581574
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

proc call*(call_581576: Call_ContentOrdersCreatetestorder_581564; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Creates a test order.
  ## 
  let valid = call_581576.validator(path, query, header, formData, body)
  let scheme = call_581576.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581576.url(scheme.get, call_581576.host, call_581576.base,
                         call_581576.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581576, url, valid)

proc call*(call_581577: Call_ContentOrdersCreatetestorder_581564;
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
  var path_581578 = newJObject()
  var query_581579 = newJObject()
  var body_581580 = newJObject()
  add(query_581579, "fields", newJString(fields))
  add(query_581579, "quotaUser", newJString(quotaUser))
  add(query_581579, "alt", newJString(alt))
  add(query_581579, "oauth_token", newJString(oauthToken))
  add(query_581579, "userIp", newJString(userIp))
  add(query_581579, "key", newJString(key))
  add(path_581578, "merchantId", newJString(merchantId))
  if body != nil:
    body_581580 = body
  add(query_581579, "prettyPrint", newJBool(prettyPrint))
  result = call_581577.call(path_581578, query_581579, nil, nil, body_581580)

var contentOrdersCreatetestorder* = Call_ContentOrdersCreatetestorder_581564(
    name: "contentOrdersCreatetestorder", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/testorders",
    validator: validate_ContentOrdersCreatetestorder_581565, base: "/content/v2",
    url: url_ContentOrdersCreatetestorder_581566, schemes: {Scheme.Https})
type
  Call_ContentOrdersAdvancetestorder_581581 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersAdvancetestorder_581583(protocol: Scheme; host: string;
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

proc validate_ContentOrdersAdvancetestorder_581582(path: JsonNode; query: JsonNode;
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
  var valid_581584 = path.getOrDefault("orderId")
  valid_581584 = validateParameter(valid_581584, JString, required = true,
                                 default = nil)
  if valid_581584 != nil:
    section.add "orderId", valid_581584
  var valid_581585 = path.getOrDefault("merchantId")
  valid_581585 = validateParameter(valid_581585, JString, required = true,
                                 default = nil)
  if valid_581585 != nil:
    section.add "merchantId", valid_581585
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
  var valid_581586 = query.getOrDefault("fields")
  valid_581586 = validateParameter(valid_581586, JString, required = false,
                                 default = nil)
  if valid_581586 != nil:
    section.add "fields", valid_581586
  var valid_581587 = query.getOrDefault("quotaUser")
  valid_581587 = validateParameter(valid_581587, JString, required = false,
                                 default = nil)
  if valid_581587 != nil:
    section.add "quotaUser", valid_581587
  var valid_581588 = query.getOrDefault("alt")
  valid_581588 = validateParameter(valid_581588, JString, required = false,
                                 default = newJString("json"))
  if valid_581588 != nil:
    section.add "alt", valid_581588
  var valid_581589 = query.getOrDefault("oauth_token")
  valid_581589 = validateParameter(valid_581589, JString, required = false,
                                 default = nil)
  if valid_581589 != nil:
    section.add "oauth_token", valid_581589
  var valid_581590 = query.getOrDefault("userIp")
  valid_581590 = validateParameter(valid_581590, JString, required = false,
                                 default = nil)
  if valid_581590 != nil:
    section.add "userIp", valid_581590
  var valid_581591 = query.getOrDefault("key")
  valid_581591 = validateParameter(valid_581591, JString, required = false,
                                 default = nil)
  if valid_581591 != nil:
    section.add "key", valid_581591
  var valid_581592 = query.getOrDefault("prettyPrint")
  valid_581592 = validateParameter(valid_581592, JBool, required = false,
                                 default = newJBool(true))
  if valid_581592 != nil:
    section.add "prettyPrint", valid_581592
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581593: Call_ContentOrdersAdvancetestorder_581581; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Moves a test order from state "inProgress" to state "pendingShipment".
  ## 
  let valid = call_581593.validator(path, query, header, formData, body)
  let scheme = call_581593.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581593.url(scheme.get, call_581593.host, call_581593.base,
                         call_581593.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581593, url, valid)

proc call*(call_581594: Call_ContentOrdersAdvancetestorder_581581; orderId: string;
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
  var path_581595 = newJObject()
  var query_581596 = newJObject()
  add(query_581596, "fields", newJString(fields))
  add(query_581596, "quotaUser", newJString(quotaUser))
  add(query_581596, "alt", newJString(alt))
  add(query_581596, "oauth_token", newJString(oauthToken))
  add(query_581596, "userIp", newJString(userIp))
  add(path_581595, "orderId", newJString(orderId))
  add(query_581596, "key", newJString(key))
  add(path_581595, "merchantId", newJString(merchantId))
  add(query_581596, "prettyPrint", newJBool(prettyPrint))
  result = call_581594.call(path_581595, query_581596, nil, nil, nil)

var contentOrdersAdvancetestorder* = Call_ContentOrdersAdvancetestorder_581581(
    name: "contentOrdersAdvancetestorder", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/testorders/{orderId}/advance",
    validator: validate_ContentOrdersAdvancetestorder_581582, base: "/content/v2",
    url: url_ContentOrdersAdvancetestorder_581583, schemes: {Scheme.Https})
type
  Call_ContentOrdersCanceltestorderbycustomer_581597 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersCanceltestorderbycustomer_581599(protocol: Scheme;
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

proc validate_ContentOrdersCanceltestorderbycustomer_581598(path: JsonNode;
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
  var valid_581600 = path.getOrDefault("orderId")
  valid_581600 = validateParameter(valid_581600, JString, required = true,
                                 default = nil)
  if valid_581600 != nil:
    section.add "orderId", valid_581600
  var valid_581601 = path.getOrDefault("merchantId")
  valid_581601 = validateParameter(valid_581601, JString, required = true,
                                 default = nil)
  if valid_581601 != nil:
    section.add "merchantId", valid_581601
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
  var valid_581602 = query.getOrDefault("fields")
  valid_581602 = validateParameter(valid_581602, JString, required = false,
                                 default = nil)
  if valid_581602 != nil:
    section.add "fields", valid_581602
  var valid_581603 = query.getOrDefault("quotaUser")
  valid_581603 = validateParameter(valid_581603, JString, required = false,
                                 default = nil)
  if valid_581603 != nil:
    section.add "quotaUser", valid_581603
  var valid_581604 = query.getOrDefault("alt")
  valid_581604 = validateParameter(valid_581604, JString, required = false,
                                 default = newJString("json"))
  if valid_581604 != nil:
    section.add "alt", valid_581604
  var valid_581605 = query.getOrDefault("oauth_token")
  valid_581605 = validateParameter(valid_581605, JString, required = false,
                                 default = nil)
  if valid_581605 != nil:
    section.add "oauth_token", valid_581605
  var valid_581606 = query.getOrDefault("userIp")
  valid_581606 = validateParameter(valid_581606, JString, required = false,
                                 default = nil)
  if valid_581606 != nil:
    section.add "userIp", valid_581606
  var valid_581607 = query.getOrDefault("key")
  valid_581607 = validateParameter(valid_581607, JString, required = false,
                                 default = nil)
  if valid_581607 != nil:
    section.add "key", valid_581607
  var valid_581608 = query.getOrDefault("prettyPrint")
  valid_581608 = validateParameter(valid_581608, JBool, required = false,
                                 default = newJBool(true))
  if valid_581608 != nil:
    section.add "prettyPrint", valid_581608
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

proc call*(call_581610: Call_ContentOrdersCanceltestorderbycustomer_581597;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sandbox only. Cancels a test order for customer-initiated cancellation.
  ## 
  let valid = call_581610.validator(path, query, header, formData, body)
  let scheme = call_581610.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581610.url(scheme.get, call_581610.host, call_581610.base,
                         call_581610.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581610, url, valid)

proc call*(call_581611: Call_ContentOrdersCanceltestorderbycustomer_581597;
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
  var path_581612 = newJObject()
  var query_581613 = newJObject()
  var body_581614 = newJObject()
  add(query_581613, "fields", newJString(fields))
  add(query_581613, "quotaUser", newJString(quotaUser))
  add(query_581613, "alt", newJString(alt))
  add(query_581613, "oauth_token", newJString(oauthToken))
  add(query_581613, "userIp", newJString(userIp))
  add(path_581612, "orderId", newJString(orderId))
  add(query_581613, "key", newJString(key))
  add(path_581612, "merchantId", newJString(merchantId))
  if body != nil:
    body_581614 = body
  add(query_581613, "prettyPrint", newJBool(prettyPrint))
  result = call_581611.call(path_581612, query_581613, nil, nil, body_581614)

var contentOrdersCanceltestorderbycustomer* = Call_ContentOrdersCanceltestorderbycustomer_581597(
    name: "contentOrdersCanceltestorderbycustomer", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/testorders/{orderId}/cancelByCustomer",
    validator: validate_ContentOrdersCanceltestorderbycustomer_581598,
    base: "/content/v2", url: url_ContentOrdersCanceltestorderbycustomer_581599,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersGettestordertemplate_581615 = ref object of OpenApiRestCall_579421
proc url_ContentOrdersGettestordertemplate_581617(protocol: Scheme; host: string;
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

proc validate_ContentOrdersGettestordertemplate_581616(path: JsonNode;
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
  var valid_581618 = path.getOrDefault("templateName")
  valid_581618 = validateParameter(valid_581618, JString, required = true,
                                 default = newJString("template1"))
  if valid_581618 != nil:
    section.add "templateName", valid_581618
  var valid_581619 = path.getOrDefault("merchantId")
  valid_581619 = validateParameter(valid_581619, JString, required = true,
                                 default = nil)
  if valid_581619 != nil:
    section.add "merchantId", valid_581619
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
  var valid_581620 = query.getOrDefault("fields")
  valid_581620 = validateParameter(valid_581620, JString, required = false,
                                 default = nil)
  if valid_581620 != nil:
    section.add "fields", valid_581620
  var valid_581621 = query.getOrDefault("country")
  valid_581621 = validateParameter(valid_581621, JString, required = false,
                                 default = nil)
  if valid_581621 != nil:
    section.add "country", valid_581621
  var valid_581622 = query.getOrDefault("quotaUser")
  valid_581622 = validateParameter(valid_581622, JString, required = false,
                                 default = nil)
  if valid_581622 != nil:
    section.add "quotaUser", valid_581622
  var valid_581623 = query.getOrDefault("alt")
  valid_581623 = validateParameter(valid_581623, JString, required = false,
                                 default = newJString("json"))
  if valid_581623 != nil:
    section.add "alt", valid_581623
  var valid_581624 = query.getOrDefault("oauth_token")
  valid_581624 = validateParameter(valid_581624, JString, required = false,
                                 default = nil)
  if valid_581624 != nil:
    section.add "oauth_token", valid_581624
  var valid_581625 = query.getOrDefault("userIp")
  valid_581625 = validateParameter(valid_581625, JString, required = false,
                                 default = nil)
  if valid_581625 != nil:
    section.add "userIp", valid_581625
  var valid_581626 = query.getOrDefault("key")
  valid_581626 = validateParameter(valid_581626, JString, required = false,
                                 default = nil)
  if valid_581626 != nil:
    section.add "key", valid_581626
  var valid_581627 = query.getOrDefault("prettyPrint")
  valid_581627 = validateParameter(valid_581627, JBool, required = false,
                                 default = newJBool(true))
  if valid_581627 != nil:
    section.add "prettyPrint", valid_581627
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581628: Call_ContentOrdersGettestordertemplate_581615;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sandbox only. Retrieves an order template that can be used to quickly create a new order in sandbox.
  ## 
  let valid = call_581628.validator(path, query, header, formData, body)
  let scheme = call_581628.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581628.url(scheme.get, call_581628.host, call_581628.base,
                         call_581628.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581628, url, valid)

proc call*(call_581629: Call_ContentOrdersGettestordertemplate_581615;
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
  var path_581630 = newJObject()
  var query_581631 = newJObject()
  add(query_581631, "fields", newJString(fields))
  add(query_581631, "country", newJString(country))
  add(query_581631, "quotaUser", newJString(quotaUser))
  add(query_581631, "alt", newJString(alt))
  add(query_581631, "oauth_token", newJString(oauthToken))
  add(query_581631, "userIp", newJString(userIp))
  add(path_581630, "templateName", newJString(templateName))
  add(query_581631, "key", newJString(key))
  add(path_581630, "merchantId", newJString(merchantId))
  add(query_581631, "prettyPrint", newJBool(prettyPrint))
  result = call_581629.call(path_581630, query_581631, nil, nil, nil)

var contentOrdersGettestordertemplate* = Call_ContentOrdersGettestordertemplate_581615(
    name: "contentOrdersGettestordertemplate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/testordertemplates/{templateName}",
    validator: validate_ContentOrdersGettestordertemplate_581616,
    base: "/content/v2", url: url_ContentOrdersGettestordertemplate_581617,
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
