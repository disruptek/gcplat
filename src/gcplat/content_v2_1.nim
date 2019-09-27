
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593421): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ContentAccountsAuthinfo_593690 = ref object of OpenApiRestCall_593421
proc url_ContentAccountsAuthinfo_593692(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ContentAccountsAuthinfo_593691(path: JsonNode; query: JsonNode;
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
  var valid_593804 = query.getOrDefault("fields")
  valid_593804 = validateParameter(valid_593804, JString, required = false,
                                 default = nil)
  if valid_593804 != nil:
    section.add "fields", valid_593804
  var valid_593805 = query.getOrDefault("quotaUser")
  valid_593805 = validateParameter(valid_593805, JString, required = false,
                                 default = nil)
  if valid_593805 != nil:
    section.add "quotaUser", valid_593805
  var valid_593819 = query.getOrDefault("alt")
  valid_593819 = validateParameter(valid_593819, JString, required = false,
                                 default = newJString("json"))
  if valid_593819 != nil:
    section.add "alt", valid_593819
  var valid_593820 = query.getOrDefault("oauth_token")
  valid_593820 = validateParameter(valid_593820, JString, required = false,
                                 default = nil)
  if valid_593820 != nil:
    section.add "oauth_token", valid_593820
  var valid_593821 = query.getOrDefault("userIp")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = nil)
  if valid_593821 != nil:
    section.add "userIp", valid_593821
  var valid_593822 = query.getOrDefault("key")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "key", valid_593822
  var valid_593823 = query.getOrDefault("prettyPrint")
  valid_593823 = validateParameter(valid_593823, JBool, required = false,
                                 default = newJBool(true))
  if valid_593823 != nil:
    section.add "prettyPrint", valid_593823
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593846: Call_ContentAccountsAuthinfo_593690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about the authenticated user.
  ## 
  let valid = call_593846.validator(path, query, header, formData, body)
  let scheme = call_593846.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593846.url(scheme.get, call_593846.host, call_593846.base,
                         call_593846.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593846, url, valid)

proc call*(call_593917: Call_ContentAccountsAuthinfo_593690; fields: string = "";
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
  var query_593918 = newJObject()
  add(query_593918, "fields", newJString(fields))
  add(query_593918, "quotaUser", newJString(quotaUser))
  add(query_593918, "alt", newJString(alt))
  add(query_593918, "oauth_token", newJString(oauthToken))
  add(query_593918, "userIp", newJString(userIp))
  add(query_593918, "key", newJString(key))
  add(query_593918, "prettyPrint", newJBool(prettyPrint))
  result = call_593917.call(nil, query_593918, nil, nil, nil)

var contentAccountsAuthinfo* = Call_ContentAccountsAuthinfo_593690(
    name: "contentAccountsAuthinfo", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/authinfo",
    validator: validate_ContentAccountsAuthinfo_593691, base: "/content/v2.1",
    url: url_ContentAccountsAuthinfo_593692, schemes: {Scheme.Https})
type
  Call_ContentAccountsCustombatch_593958 = ref object of OpenApiRestCall_593421
proc url_ContentAccountsCustombatch_593960(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ContentAccountsCustombatch_593959(path: JsonNode; query: JsonNode;
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
  var valid_593961 = query.getOrDefault("fields")
  valid_593961 = validateParameter(valid_593961, JString, required = false,
                                 default = nil)
  if valid_593961 != nil:
    section.add "fields", valid_593961
  var valid_593962 = query.getOrDefault("quotaUser")
  valid_593962 = validateParameter(valid_593962, JString, required = false,
                                 default = nil)
  if valid_593962 != nil:
    section.add "quotaUser", valid_593962
  var valid_593963 = query.getOrDefault("alt")
  valid_593963 = validateParameter(valid_593963, JString, required = false,
                                 default = newJString("json"))
  if valid_593963 != nil:
    section.add "alt", valid_593963
  var valid_593964 = query.getOrDefault("oauth_token")
  valid_593964 = validateParameter(valid_593964, JString, required = false,
                                 default = nil)
  if valid_593964 != nil:
    section.add "oauth_token", valid_593964
  var valid_593965 = query.getOrDefault("userIp")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = nil)
  if valid_593965 != nil:
    section.add "userIp", valid_593965
  var valid_593966 = query.getOrDefault("key")
  valid_593966 = validateParameter(valid_593966, JString, required = false,
                                 default = nil)
  if valid_593966 != nil:
    section.add "key", valid_593966
  var valid_593967 = query.getOrDefault("prettyPrint")
  valid_593967 = validateParameter(valid_593967, JBool, required = false,
                                 default = newJBool(true))
  if valid_593967 != nil:
    section.add "prettyPrint", valid_593967
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

proc call*(call_593969: Call_ContentAccountsCustombatch_593958; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves, inserts, updates, and deletes multiple Merchant Center (sub-)accounts in a single request.
  ## 
  let valid = call_593969.validator(path, query, header, formData, body)
  let scheme = call_593969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593969.url(scheme.get, call_593969.host, call_593969.base,
                         call_593969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593969, url, valid)

proc call*(call_593970: Call_ContentAccountsCustombatch_593958;
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
  var query_593971 = newJObject()
  var body_593972 = newJObject()
  add(query_593971, "fields", newJString(fields))
  add(query_593971, "quotaUser", newJString(quotaUser))
  add(query_593971, "alt", newJString(alt))
  add(query_593971, "oauth_token", newJString(oauthToken))
  add(query_593971, "userIp", newJString(userIp))
  add(query_593971, "key", newJString(key))
  if body != nil:
    body_593972 = body
  add(query_593971, "prettyPrint", newJBool(prettyPrint))
  result = call_593970.call(nil, query_593971, nil, nil, body_593972)

var contentAccountsCustombatch* = Call_ContentAccountsCustombatch_593958(
    name: "contentAccountsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accounts/batch",
    validator: validate_ContentAccountsCustombatch_593959, base: "/content/v2.1",
    url: url_ContentAccountsCustombatch_593960, schemes: {Scheme.Https})
type
  Call_ContentAccountstatusesCustombatch_593973 = ref object of OpenApiRestCall_593421
proc url_ContentAccountstatusesCustombatch_593975(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ContentAccountstatusesCustombatch_593974(path: JsonNode;
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
  var valid_593976 = query.getOrDefault("fields")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "fields", valid_593976
  var valid_593977 = query.getOrDefault("quotaUser")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "quotaUser", valid_593977
  var valid_593978 = query.getOrDefault("alt")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = newJString("json"))
  if valid_593978 != nil:
    section.add "alt", valid_593978
  var valid_593979 = query.getOrDefault("oauth_token")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = nil)
  if valid_593979 != nil:
    section.add "oauth_token", valid_593979
  var valid_593980 = query.getOrDefault("userIp")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = nil)
  if valid_593980 != nil:
    section.add "userIp", valid_593980
  var valid_593981 = query.getOrDefault("key")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = nil)
  if valid_593981 != nil:
    section.add "key", valid_593981
  var valid_593982 = query.getOrDefault("prettyPrint")
  valid_593982 = validateParameter(valid_593982, JBool, required = false,
                                 default = newJBool(true))
  if valid_593982 != nil:
    section.add "prettyPrint", valid_593982
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

proc call*(call_593984: Call_ContentAccountstatusesCustombatch_593973;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves multiple Merchant Center account statuses in a single request.
  ## 
  let valid = call_593984.validator(path, query, header, formData, body)
  let scheme = call_593984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593984.url(scheme.get, call_593984.host, call_593984.base,
                         call_593984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593984, url, valid)

proc call*(call_593985: Call_ContentAccountstatusesCustombatch_593973;
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
  var query_593986 = newJObject()
  var body_593987 = newJObject()
  add(query_593986, "fields", newJString(fields))
  add(query_593986, "quotaUser", newJString(quotaUser))
  add(query_593986, "alt", newJString(alt))
  add(query_593986, "oauth_token", newJString(oauthToken))
  add(query_593986, "userIp", newJString(userIp))
  add(query_593986, "key", newJString(key))
  if body != nil:
    body_593987 = body
  add(query_593986, "prettyPrint", newJBool(prettyPrint))
  result = call_593985.call(nil, query_593986, nil, nil, body_593987)

var contentAccountstatusesCustombatch* = Call_ContentAccountstatusesCustombatch_593973(
    name: "contentAccountstatusesCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accountstatuses/batch",
    validator: validate_ContentAccountstatusesCustombatch_593974,
    base: "/content/v2.1", url: url_ContentAccountstatusesCustombatch_593975,
    schemes: {Scheme.Https})
type
  Call_ContentAccounttaxCustombatch_593988 = ref object of OpenApiRestCall_593421
proc url_ContentAccounttaxCustombatch_593990(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ContentAccounttaxCustombatch_593989(path: JsonNode; query: JsonNode;
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
  var valid_593991 = query.getOrDefault("fields")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "fields", valid_593991
  var valid_593992 = query.getOrDefault("quotaUser")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "quotaUser", valid_593992
  var valid_593993 = query.getOrDefault("alt")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = newJString("json"))
  if valid_593993 != nil:
    section.add "alt", valid_593993
  var valid_593994 = query.getOrDefault("oauth_token")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "oauth_token", valid_593994
  var valid_593995 = query.getOrDefault("userIp")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "userIp", valid_593995
  var valid_593996 = query.getOrDefault("key")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "key", valid_593996
  var valid_593997 = query.getOrDefault("prettyPrint")
  valid_593997 = validateParameter(valid_593997, JBool, required = false,
                                 default = newJBool(true))
  if valid_593997 != nil:
    section.add "prettyPrint", valid_593997
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

proc call*(call_593999: Call_ContentAccounttaxCustombatch_593988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves and updates tax settings of multiple accounts in a single request.
  ## 
  let valid = call_593999.validator(path, query, header, formData, body)
  let scheme = call_593999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593999.url(scheme.get, call_593999.host, call_593999.base,
                         call_593999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593999, url, valid)

proc call*(call_594000: Call_ContentAccounttaxCustombatch_593988;
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
  var query_594001 = newJObject()
  var body_594002 = newJObject()
  add(query_594001, "fields", newJString(fields))
  add(query_594001, "quotaUser", newJString(quotaUser))
  add(query_594001, "alt", newJString(alt))
  add(query_594001, "oauth_token", newJString(oauthToken))
  add(query_594001, "userIp", newJString(userIp))
  add(query_594001, "key", newJString(key))
  if body != nil:
    body_594002 = body
  add(query_594001, "prettyPrint", newJBool(prettyPrint))
  result = call_594000.call(nil, query_594001, nil, nil, body_594002)

var contentAccounttaxCustombatch* = Call_ContentAccounttaxCustombatch_593988(
    name: "contentAccounttaxCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accounttax/batch",
    validator: validate_ContentAccounttaxCustombatch_593989,
    base: "/content/v2.1", url: url_ContentAccounttaxCustombatch_593990,
    schemes: {Scheme.Https})
type
  Call_ContentDatafeedsCustombatch_594003 = ref object of OpenApiRestCall_593421
proc url_ContentDatafeedsCustombatch_594005(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ContentDatafeedsCustombatch_594004(path: JsonNode; query: JsonNode;
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
  var valid_594006 = query.getOrDefault("fields")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "fields", valid_594006
  var valid_594007 = query.getOrDefault("quotaUser")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "quotaUser", valid_594007
  var valid_594008 = query.getOrDefault("alt")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = newJString("json"))
  if valid_594008 != nil:
    section.add "alt", valid_594008
  var valid_594009 = query.getOrDefault("oauth_token")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "oauth_token", valid_594009
  var valid_594010 = query.getOrDefault("userIp")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "userIp", valid_594010
  var valid_594011 = query.getOrDefault("key")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "key", valid_594011
  var valid_594012 = query.getOrDefault("prettyPrint")
  valid_594012 = validateParameter(valid_594012, JBool, required = false,
                                 default = newJBool(true))
  if valid_594012 != nil:
    section.add "prettyPrint", valid_594012
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

proc call*(call_594014: Call_ContentDatafeedsCustombatch_594003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes, fetches, gets, inserts and updates multiple datafeeds in a single request.
  ## 
  let valid = call_594014.validator(path, query, header, formData, body)
  let scheme = call_594014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594014.url(scheme.get, call_594014.host, call_594014.base,
                         call_594014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594014, url, valid)

proc call*(call_594015: Call_ContentDatafeedsCustombatch_594003;
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
  var query_594016 = newJObject()
  var body_594017 = newJObject()
  add(query_594016, "fields", newJString(fields))
  add(query_594016, "quotaUser", newJString(quotaUser))
  add(query_594016, "alt", newJString(alt))
  add(query_594016, "oauth_token", newJString(oauthToken))
  add(query_594016, "userIp", newJString(userIp))
  add(query_594016, "key", newJString(key))
  if body != nil:
    body_594017 = body
  add(query_594016, "prettyPrint", newJBool(prettyPrint))
  result = call_594015.call(nil, query_594016, nil, nil, body_594017)

var contentDatafeedsCustombatch* = Call_ContentDatafeedsCustombatch_594003(
    name: "contentDatafeedsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/datafeeds/batch",
    validator: validate_ContentDatafeedsCustombatch_594004, base: "/content/v2.1",
    url: url_ContentDatafeedsCustombatch_594005, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesCustombatch_594018 = ref object of OpenApiRestCall_593421
proc url_ContentDatafeedstatusesCustombatch_594020(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ContentDatafeedstatusesCustombatch_594019(path: JsonNode;
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
  var valid_594021 = query.getOrDefault("fields")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = nil)
  if valid_594021 != nil:
    section.add "fields", valid_594021
  var valid_594022 = query.getOrDefault("quotaUser")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "quotaUser", valid_594022
  var valid_594023 = query.getOrDefault("alt")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = newJString("json"))
  if valid_594023 != nil:
    section.add "alt", valid_594023
  var valid_594024 = query.getOrDefault("oauth_token")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "oauth_token", valid_594024
  var valid_594025 = query.getOrDefault("userIp")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "userIp", valid_594025
  var valid_594026 = query.getOrDefault("key")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "key", valid_594026
  var valid_594027 = query.getOrDefault("prettyPrint")
  valid_594027 = validateParameter(valid_594027, JBool, required = false,
                                 default = newJBool(true))
  if valid_594027 != nil:
    section.add "prettyPrint", valid_594027
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

proc call*(call_594029: Call_ContentDatafeedstatusesCustombatch_594018;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets multiple Merchant Center datafeed statuses in a single request.
  ## 
  let valid = call_594029.validator(path, query, header, formData, body)
  let scheme = call_594029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594029.url(scheme.get, call_594029.host, call_594029.base,
                         call_594029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594029, url, valid)

proc call*(call_594030: Call_ContentDatafeedstatusesCustombatch_594018;
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
  var query_594031 = newJObject()
  var body_594032 = newJObject()
  add(query_594031, "fields", newJString(fields))
  add(query_594031, "quotaUser", newJString(quotaUser))
  add(query_594031, "alt", newJString(alt))
  add(query_594031, "oauth_token", newJString(oauthToken))
  add(query_594031, "userIp", newJString(userIp))
  add(query_594031, "key", newJString(key))
  if body != nil:
    body_594032 = body
  add(query_594031, "prettyPrint", newJBool(prettyPrint))
  result = call_594030.call(nil, query_594031, nil, nil, body_594032)

var contentDatafeedstatusesCustombatch* = Call_ContentDatafeedstatusesCustombatch_594018(
    name: "contentDatafeedstatusesCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/datafeedstatuses/batch",
    validator: validate_ContentDatafeedstatusesCustombatch_594019,
    base: "/content/v2.1", url: url_ContentDatafeedstatusesCustombatch_594020,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsCustombatch_594033 = ref object of OpenApiRestCall_593421
proc url_ContentLiasettingsCustombatch_594035(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ContentLiasettingsCustombatch_594034(path: JsonNode; query: JsonNode;
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
  var valid_594036 = query.getOrDefault("fields")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "fields", valid_594036
  var valid_594037 = query.getOrDefault("quotaUser")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "quotaUser", valid_594037
  var valid_594038 = query.getOrDefault("alt")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = newJString("json"))
  if valid_594038 != nil:
    section.add "alt", valid_594038
  var valid_594039 = query.getOrDefault("oauth_token")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "oauth_token", valid_594039
  var valid_594040 = query.getOrDefault("userIp")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "userIp", valid_594040
  var valid_594041 = query.getOrDefault("key")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "key", valid_594041
  var valid_594042 = query.getOrDefault("prettyPrint")
  valid_594042 = validateParameter(valid_594042, JBool, required = false,
                                 default = newJBool(true))
  if valid_594042 != nil:
    section.add "prettyPrint", valid_594042
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

proc call*(call_594044: Call_ContentLiasettingsCustombatch_594033; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves and/or updates the LIA settings of multiple accounts in a single request.
  ## 
  let valid = call_594044.validator(path, query, header, formData, body)
  let scheme = call_594044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594044.url(scheme.get, call_594044.host, call_594044.base,
                         call_594044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594044, url, valid)

proc call*(call_594045: Call_ContentLiasettingsCustombatch_594033;
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
  var query_594046 = newJObject()
  var body_594047 = newJObject()
  add(query_594046, "fields", newJString(fields))
  add(query_594046, "quotaUser", newJString(quotaUser))
  add(query_594046, "alt", newJString(alt))
  add(query_594046, "oauth_token", newJString(oauthToken))
  add(query_594046, "userIp", newJString(userIp))
  add(query_594046, "key", newJString(key))
  if body != nil:
    body_594047 = body
  add(query_594046, "prettyPrint", newJBool(prettyPrint))
  result = call_594045.call(nil, query_594046, nil, nil, body_594047)

var contentLiasettingsCustombatch* = Call_ContentLiasettingsCustombatch_594033(
    name: "contentLiasettingsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liasettings/batch",
    validator: validate_ContentLiasettingsCustombatch_594034,
    base: "/content/v2.1", url: url_ContentLiasettingsCustombatch_594035,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsListposdataproviders_594048 = ref object of OpenApiRestCall_593421
proc url_ContentLiasettingsListposdataproviders_594050(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ContentLiasettingsListposdataproviders_594049(path: JsonNode;
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
  var valid_594051 = query.getOrDefault("fields")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "fields", valid_594051
  var valid_594052 = query.getOrDefault("quotaUser")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "quotaUser", valid_594052
  var valid_594053 = query.getOrDefault("alt")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = newJString("json"))
  if valid_594053 != nil:
    section.add "alt", valid_594053
  var valid_594054 = query.getOrDefault("oauth_token")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "oauth_token", valid_594054
  var valid_594055 = query.getOrDefault("userIp")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "userIp", valid_594055
  var valid_594056 = query.getOrDefault("key")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "key", valid_594056
  var valid_594057 = query.getOrDefault("prettyPrint")
  valid_594057 = validateParameter(valid_594057, JBool, required = false,
                                 default = newJBool(true))
  if valid_594057 != nil:
    section.add "prettyPrint", valid_594057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594058: Call_ContentLiasettingsListposdataproviders_594048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of POS data providers that have active settings for the all eiligible countries.
  ## 
  let valid = call_594058.validator(path, query, header, formData, body)
  let scheme = call_594058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594058.url(scheme.get, call_594058.host, call_594058.base,
                         call_594058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594058, url, valid)

proc call*(call_594059: Call_ContentLiasettingsListposdataproviders_594048;
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
  var query_594060 = newJObject()
  add(query_594060, "fields", newJString(fields))
  add(query_594060, "quotaUser", newJString(quotaUser))
  add(query_594060, "alt", newJString(alt))
  add(query_594060, "oauth_token", newJString(oauthToken))
  add(query_594060, "userIp", newJString(userIp))
  add(query_594060, "key", newJString(key))
  add(query_594060, "prettyPrint", newJBool(prettyPrint))
  result = call_594059.call(nil, query_594060, nil, nil, nil)

var contentLiasettingsListposdataproviders* = Call_ContentLiasettingsListposdataproviders_594048(
    name: "contentLiasettingsListposdataproviders", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/liasettings/posdataproviders",
    validator: validate_ContentLiasettingsListposdataproviders_594049,
    base: "/content/v2.1", url: url_ContentLiasettingsListposdataproviders_594050,
    schemes: {Scheme.Https})
type
  Call_ContentPosCustombatch_594061 = ref object of OpenApiRestCall_593421
proc url_ContentPosCustombatch_594063(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ContentPosCustombatch_594062(path: JsonNode; query: JsonNode;
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
  var valid_594064 = query.getOrDefault("fields")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "fields", valid_594064
  var valid_594065 = query.getOrDefault("quotaUser")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "quotaUser", valid_594065
  var valid_594066 = query.getOrDefault("alt")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = newJString("json"))
  if valid_594066 != nil:
    section.add "alt", valid_594066
  var valid_594067 = query.getOrDefault("oauth_token")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = nil)
  if valid_594067 != nil:
    section.add "oauth_token", valid_594067
  var valid_594068 = query.getOrDefault("userIp")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "userIp", valid_594068
  var valid_594069 = query.getOrDefault("key")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "key", valid_594069
  var valid_594070 = query.getOrDefault("prettyPrint")
  valid_594070 = validateParameter(valid_594070, JBool, required = false,
                                 default = newJBool(true))
  if valid_594070 != nil:
    section.add "prettyPrint", valid_594070
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

proc call*(call_594072: Call_ContentPosCustombatch_594061; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Batches multiple POS-related calls in a single request.
  ## 
  let valid = call_594072.validator(path, query, header, formData, body)
  let scheme = call_594072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594072.url(scheme.get, call_594072.host, call_594072.base,
                         call_594072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594072, url, valid)

proc call*(call_594073: Call_ContentPosCustombatch_594061; fields: string = "";
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
  var query_594074 = newJObject()
  var body_594075 = newJObject()
  add(query_594074, "fields", newJString(fields))
  add(query_594074, "quotaUser", newJString(quotaUser))
  add(query_594074, "alt", newJString(alt))
  add(query_594074, "oauth_token", newJString(oauthToken))
  add(query_594074, "userIp", newJString(userIp))
  add(query_594074, "key", newJString(key))
  if body != nil:
    body_594075 = body
  add(query_594074, "prettyPrint", newJBool(prettyPrint))
  result = call_594073.call(nil, query_594074, nil, nil, body_594075)

var contentPosCustombatch* = Call_ContentPosCustombatch_594061(
    name: "contentPosCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/pos/batch",
    validator: validate_ContentPosCustombatch_594062, base: "/content/v2.1",
    url: url_ContentPosCustombatch_594063, schemes: {Scheme.Https})
type
  Call_ContentProductsCustombatch_594076 = ref object of OpenApiRestCall_593421
proc url_ContentProductsCustombatch_594078(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ContentProductsCustombatch_594077(path: JsonNode; query: JsonNode;
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
  var valid_594079 = query.getOrDefault("fields")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "fields", valid_594079
  var valid_594080 = query.getOrDefault("quotaUser")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "quotaUser", valid_594080
  var valid_594081 = query.getOrDefault("alt")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = newJString("json"))
  if valid_594081 != nil:
    section.add "alt", valid_594081
  var valid_594082 = query.getOrDefault("oauth_token")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "oauth_token", valid_594082
  var valid_594083 = query.getOrDefault("userIp")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "userIp", valid_594083
  var valid_594084 = query.getOrDefault("key")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "key", valid_594084
  var valid_594085 = query.getOrDefault("prettyPrint")
  valid_594085 = validateParameter(valid_594085, JBool, required = false,
                                 default = newJBool(true))
  if valid_594085 != nil:
    section.add "prettyPrint", valid_594085
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

proc call*(call_594087: Call_ContentProductsCustombatch_594076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves, inserts, and deletes multiple products in a single request.
  ## 
  let valid = call_594087.validator(path, query, header, formData, body)
  let scheme = call_594087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594087.url(scheme.get, call_594087.host, call_594087.base,
                         call_594087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594087, url, valid)

proc call*(call_594088: Call_ContentProductsCustombatch_594076;
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
  var query_594089 = newJObject()
  var body_594090 = newJObject()
  add(query_594089, "fields", newJString(fields))
  add(query_594089, "quotaUser", newJString(quotaUser))
  add(query_594089, "alt", newJString(alt))
  add(query_594089, "oauth_token", newJString(oauthToken))
  add(query_594089, "userIp", newJString(userIp))
  add(query_594089, "key", newJString(key))
  if body != nil:
    body_594090 = body
  add(query_594089, "prettyPrint", newJBool(prettyPrint))
  result = call_594088.call(nil, query_594089, nil, nil, body_594090)

var contentProductsCustombatch* = Call_ContentProductsCustombatch_594076(
    name: "contentProductsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/products/batch",
    validator: validate_ContentProductsCustombatch_594077, base: "/content/v2.1",
    url: url_ContentProductsCustombatch_594078, schemes: {Scheme.Https})
type
  Call_ContentProductstatusesCustombatch_594091 = ref object of OpenApiRestCall_593421
proc url_ContentProductstatusesCustombatch_594093(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ContentProductstatusesCustombatch_594092(path: JsonNode;
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
  var valid_594094 = query.getOrDefault("fields")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "fields", valid_594094
  var valid_594095 = query.getOrDefault("quotaUser")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "quotaUser", valid_594095
  var valid_594096 = query.getOrDefault("alt")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = newJString("json"))
  if valid_594096 != nil:
    section.add "alt", valid_594096
  var valid_594097 = query.getOrDefault("oauth_token")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "oauth_token", valid_594097
  var valid_594098 = query.getOrDefault("userIp")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "userIp", valid_594098
  var valid_594099 = query.getOrDefault("key")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "key", valid_594099
  var valid_594100 = query.getOrDefault("prettyPrint")
  valid_594100 = validateParameter(valid_594100, JBool, required = false,
                                 default = newJBool(true))
  if valid_594100 != nil:
    section.add "prettyPrint", valid_594100
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

proc call*(call_594102: Call_ContentProductstatusesCustombatch_594091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the statuses of multiple products in a single request.
  ## 
  let valid = call_594102.validator(path, query, header, formData, body)
  let scheme = call_594102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594102.url(scheme.get, call_594102.host, call_594102.base,
                         call_594102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594102, url, valid)

proc call*(call_594103: Call_ContentProductstatusesCustombatch_594091;
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
  var query_594104 = newJObject()
  var body_594105 = newJObject()
  add(query_594104, "fields", newJString(fields))
  add(query_594104, "quotaUser", newJString(quotaUser))
  add(query_594104, "alt", newJString(alt))
  add(query_594104, "oauth_token", newJString(oauthToken))
  add(query_594104, "userIp", newJString(userIp))
  add(query_594104, "key", newJString(key))
  if body != nil:
    body_594105 = body
  add(query_594104, "prettyPrint", newJBool(prettyPrint))
  result = call_594103.call(nil, query_594104, nil, nil, body_594105)

var contentProductstatusesCustombatch* = Call_ContentProductstatusesCustombatch_594091(
    name: "contentProductstatusesCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/productstatuses/batch",
    validator: validate_ContentProductstatusesCustombatch_594092,
    base: "/content/v2.1", url: url_ContentProductstatusesCustombatch_594093,
    schemes: {Scheme.Https})
type
  Call_ContentRegionalinventoryCustombatch_594106 = ref object of OpenApiRestCall_593421
proc url_ContentRegionalinventoryCustombatch_594108(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ContentRegionalinventoryCustombatch_594107(path: JsonNode;
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
  var valid_594109 = query.getOrDefault("fields")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = nil)
  if valid_594109 != nil:
    section.add "fields", valid_594109
  var valid_594110 = query.getOrDefault("quotaUser")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = nil)
  if valid_594110 != nil:
    section.add "quotaUser", valid_594110
  var valid_594111 = query.getOrDefault("alt")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = newJString("json"))
  if valid_594111 != nil:
    section.add "alt", valid_594111
  var valid_594112 = query.getOrDefault("oauth_token")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "oauth_token", valid_594112
  var valid_594113 = query.getOrDefault("userIp")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = nil)
  if valid_594113 != nil:
    section.add "userIp", valid_594113
  var valid_594114 = query.getOrDefault("key")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "key", valid_594114
  var valid_594115 = query.getOrDefault("prettyPrint")
  valid_594115 = validateParameter(valid_594115, JBool, required = false,
                                 default = newJBool(true))
  if valid_594115 != nil:
    section.add "prettyPrint", valid_594115
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

proc call*(call_594117: Call_ContentRegionalinventoryCustombatch_594106;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates regional inventory for multiple products or regions in a single request.
  ## 
  let valid = call_594117.validator(path, query, header, formData, body)
  let scheme = call_594117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594117.url(scheme.get, call_594117.host, call_594117.base,
                         call_594117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594117, url, valid)

proc call*(call_594118: Call_ContentRegionalinventoryCustombatch_594106;
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
  var query_594119 = newJObject()
  var body_594120 = newJObject()
  add(query_594119, "fields", newJString(fields))
  add(query_594119, "quotaUser", newJString(quotaUser))
  add(query_594119, "alt", newJString(alt))
  add(query_594119, "oauth_token", newJString(oauthToken))
  add(query_594119, "userIp", newJString(userIp))
  add(query_594119, "key", newJString(key))
  if body != nil:
    body_594120 = body
  add(query_594119, "prettyPrint", newJBool(prettyPrint))
  result = call_594118.call(nil, query_594119, nil, nil, body_594120)

var contentRegionalinventoryCustombatch* = Call_ContentRegionalinventoryCustombatch_594106(
    name: "contentRegionalinventoryCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/regionalinventory/batch",
    validator: validate_ContentRegionalinventoryCustombatch_594107,
    base: "/content/v2.1", url: url_ContentRegionalinventoryCustombatch_594108,
    schemes: {Scheme.Https})
type
  Call_ContentReturnaddressCustombatch_594121 = ref object of OpenApiRestCall_593421
proc url_ContentReturnaddressCustombatch_594123(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ContentReturnaddressCustombatch_594122(path: JsonNode;
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
  var valid_594124 = query.getOrDefault("fields")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "fields", valid_594124
  var valid_594125 = query.getOrDefault("quotaUser")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = nil)
  if valid_594125 != nil:
    section.add "quotaUser", valid_594125
  var valid_594126 = query.getOrDefault("alt")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = newJString("json"))
  if valid_594126 != nil:
    section.add "alt", valid_594126
  var valid_594127 = query.getOrDefault("oauth_token")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "oauth_token", valid_594127
  var valid_594128 = query.getOrDefault("userIp")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "userIp", valid_594128
  var valid_594129 = query.getOrDefault("key")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = nil)
  if valid_594129 != nil:
    section.add "key", valid_594129
  var valid_594130 = query.getOrDefault("prettyPrint")
  valid_594130 = validateParameter(valid_594130, JBool, required = false,
                                 default = newJBool(true))
  if valid_594130 != nil:
    section.add "prettyPrint", valid_594130
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

proc call*(call_594132: Call_ContentReturnaddressCustombatch_594121;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Batches multiple return address related calls in a single request.
  ## 
  let valid = call_594132.validator(path, query, header, formData, body)
  let scheme = call_594132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594132.url(scheme.get, call_594132.host, call_594132.base,
                         call_594132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594132, url, valid)

proc call*(call_594133: Call_ContentReturnaddressCustombatch_594121;
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
  var query_594134 = newJObject()
  var body_594135 = newJObject()
  add(query_594134, "fields", newJString(fields))
  add(query_594134, "quotaUser", newJString(quotaUser))
  add(query_594134, "alt", newJString(alt))
  add(query_594134, "oauth_token", newJString(oauthToken))
  add(query_594134, "userIp", newJString(userIp))
  add(query_594134, "key", newJString(key))
  if body != nil:
    body_594135 = body
  add(query_594134, "prettyPrint", newJBool(prettyPrint))
  result = call_594133.call(nil, query_594134, nil, nil, body_594135)

var contentReturnaddressCustombatch* = Call_ContentReturnaddressCustombatch_594121(
    name: "contentReturnaddressCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/returnaddress/batch",
    validator: validate_ContentReturnaddressCustombatch_594122,
    base: "/content/v2.1", url: url_ContentReturnaddressCustombatch_594123,
    schemes: {Scheme.Https})
type
  Call_ContentReturnpolicyCustombatch_594136 = ref object of OpenApiRestCall_593421
proc url_ContentReturnpolicyCustombatch_594138(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ContentReturnpolicyCustombatch_594137(path: JsonNode;
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
  var valid_594139 = query.getOrDefault("fields")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = nil)
  if valid_594139 != nil:
    section.add "fields", valid_594139
  var valid_594140 = query.getOrDefault("quotaUser")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "quotaUser", valid_594140
  var valid_594141 = query.getOrDefault("alt")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = newJString("json"))
  if valid_594141 != nil:
    section.add "alt", valid_594141
  var valid_594142 = query.getOrDefault("oauth_token")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = nil)
  if valid_594142 != nil:
    section.add "oauth_token", valid_594142
  var valid_594143 = query.getOrDefault("userIp")
  valid_594143 = validateParameter(valid_594143, JString, required = false,
                                 default = nil)
  if valid_594143 != nil:
    section.add "userIp", valid_594143
  var valid_594144 = query.getOrDefault("key")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = nil)
  if valid_594144 != nil:
    section.add "key", valid_594144
  var valid_594145 = query.getOrDefault("prettyPrint")
  valid_594145 = validateParameter(valid_594145, JBool, required = false,
                                 default = newJBool(true))
  if valid_594145 != nil:
    section.add "prettyPrint", valid_594145
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

proc call*(call_594147: Call_ContentReturnpolicyCustombatch_594136; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Batches multiple return policy related calls in a single request.
  ## 
  let valid = call_594147.validator(path, query, header, formData, body)
  let scheme = call_594147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594147.url(scheme.get, call_594147.host, call_594147.base,
                         call_594147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594147, url, valid)

proc call*(call_594148: Call_ContentReturnpolicyCustombatch_594136;
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
  var query_594149 = newJObject()
  var body_594150 = newJObject()
  add(query_594149, "fields", newJString(fields))
  add(query_594149, "quotaUser", newJString(quotaUser))
  add(query_594149, "alt", newJString(alt))
  add(query_594149, "oauth_token", newJString(oauthToken))
  add(query_594149, "userIp", newJString(userIp))
  add(query_594149, "key", newJString(key))
  if body != nil:
    body_594150 = body
  add(query_594149, "prettyPrint", newJBool(prettyPrint))
  result = call_594148.call(nil, query_594149, nil, nil, body_594150)

var contentReturnpolicyCustombatch* = Call_ContentReturnpolicyCustombatch_594136(
    name: "contentReturnpolicyCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/returnpolicy/batch",
    validator: validate_ContentReturnpolicyCustombatch_594137,
    base: "/content/v2.1", url: url_ContentReturnpolicyCustombatch_594138,
    schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsCustombatch_594151 = ref object of OpenApiRestCall_593421
proc url_ContentShippingsettingsCustombatch_594153(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ContentShippingsettingsCustombatch_594152(path: JsonNode;
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
  var valid_594154 = query.getOrDefault("fields")
  valid_594154 = validateParameter(valid_594154, JString, required = false,
                                 default = nil)
  if valid_594154 != nil:
    section.add "fields", valid_594154
  var valid_594155 = query.getOrDefault("quotaUser")
  valid_594155 = validateParameter(valid_594155, JString, required = false,
                                 default = nil)
  if valid_594155 != nil:
    section.add "quotaUser", valid_594155
  var valid_594156 = query.getOrDefault("alt")
  valid_594156 = validateParameter(valid_594156, JString, required = false,
                                 default = newJString("json"))
  if valid_594156 != nil:
    section.add "alt", valid_594156
  var valid_594157 = query.getOrDefault("oauth_token")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = nil)
  if valid_594157 != nil:
    section.add "oauth_token", valid_594157
  var valid_594158 = query.getOrDefault("userIp")
  valid_594158 = validateParameter(valid_594158, JString, required = false,
                                 default = nil)
  if valid_594158 != nil:
    section.add "userIp", valid_594158
  var valid_594159 = query.getOrDefault("key")
  valid_594159 = validateParameter(valid_594159, JString, required = false,
                                 default = nil)
  if valid_594159 != nil:
    section.add "key", valid_594159
  var valid_594160 = query.getOrDefault("prettyPrint")
  valid_594160 = validateParameter(valid_594160, JBool, required = false,
                                 default = newJBool(true))
  if valid_594160 != nil:
    section.add "prettyPrint", valid_594160
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

proc call*(call_594162: Call_ContentShippingsettingsCustombatch_594151;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves and updates the shipping settings of multiple accounts in a single request.
  ## 
  let valid = call_594162.validator(path, query, header, formData, body)
  let scheme = call_594162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594162.url(scheme.get, call_594162.host, call_594162.base,
                         call_594162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594162, url, valid)

proc call*(call_594163: Call_ContentShippingsettingsCustombatch_594151;
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
  var query_594164 = newJObject()
  var body_594165 = newJObject()
  add(query_594164, "fields", newJString(fields))
  add(query_594164, "quotaUser", newJString(quotaUser))
  add(query_594164, "alt", newJString(alt))
  add(query_594164, "oauth_token", newJString(oauthToken))
  add(query_594164, "userIp", newJString(userIp))
  add(query_594164, "key", newJString(key))
  if body != nil:
    body_594165 = body
  add(query_594164, "prettyPrint", newJBool(prettyPrint))
  result = call_594163.call(nil, query_594164, nil, nil, body_594165)

var contentShippingsettingsCustombatch* = Call_ContentShippingsettingsCustombatch_594151(
    name: "contentShippingsettingsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/shippingsettings/batch",
    validator: validate_ContentShippingsettingsCustombatch_594152,
    base: "/content/v2.1", url: url_ContentShippingsettingsCustombatch_594153,
    schemes: {Scheme.Https})
type
  Call_ContentAccountsInsert_594197 = ref object of OpenApiRestCall_593421
proc url_ContentAccountsInsert_594199(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentAccountsInsert_594198(path: JsonNode; query: JsonNode;
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
  var valid_594200 = path.getOrDefault("merchantId")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "merchantId", valid_594200
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
  var valid_594201 = query.getOrDefault("fields")
  valid_594201 = validateParameter(valid_594201, JString, required = false,
                                 default = nil)
  if valid_594201 != nil:
    section.add "fields", valid_594201
  var valid_594202 = query.getOrDefault("quotaUser")
  valid_594202 = validateParameter(valid_594202, JString, required = false,
                                 default = nil)
  if valid_594202 != nil:
    section.add "quotaUser", valid_594202
  var valid_594203 = query.getOrDefault("alt")
  valid_594203 = validateParameter(valid_594203, JString, required = false,
                                 default = newJString("json"))
  if valid_594203 != nil:
    section.add "alt", valid_594203
  var valid_594204 = query.getOrDefault("oauth_token")
  valid_594204 = validateParameter(valid_594204, JString, required = false,
                                 default = nil)
  if valid_594204 != nil:
    section.add "oauth_token", valid_594204
  var valid_594205 = query.getOrDefault("userIp")
  valid_594205 = validateParameter(valid_594205, JString, required = false,
                                 default = nil)
  if valid_594205 != nil:
    section.add "userIp", valid_594205
  var valid_594206 = query.getOrDefault("key")
  valid_594206 = validateParameter(valid_594206, JString, required = false,
                                 default = nil)
  if valid_594206 != nil:
    section.add "key", valid_594206
  var valid_594207 = query.getOrDefault("prettyPrint")
  valid_594207 = validateParameter(valid_594207, JBool, required = false,
                                 default = newJBool(true))
  if valid_594207 != nil:
    section.add "prettyPrint", valid_594207
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

proc call*(call_594209: Call_ContentAccountsInsert_594197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Merchant Center sub-account.
  ## 
  let valid = call_594209.validator(path, query, header, formData, body)
  let scheme = call_594209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594209.url(scheme.get, call_594209.host, call_594209.base,
                         call_594209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594209, url, valid)

proc call*(call_594210: Call_ContentAccountsInsert_594197; merchantId: string;
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
  var path_594211 = newJObject()
  var query_594212 = newJObject()
  var body_594213 = newJObject()
  add(query_594212, "fields", newJString(fields))
  add(query_594212, "quotaUser", newJString(quotaUser))
  add(query_594212, "alt", newJString(alt))
  add(query_594212, "oauth_token", newJString(oauthToken))
  add(query_594212, "userIp", newJString(userIp))
  add(query_594212, "key", newJString(key))
  add(path_594211, "merchantId", newJString(merchantId))
  if body != nil:
    body_594213 = body
  add(query_594212, "prettyPrint", newJBool(prettyPrint))
  result = call_594210.call(path_594211, query_594212, nil, nil, body_594213)

var contentAccountsInsert* = Call_ContentAccountsInsert_594197(
    name: "contentAccountsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/accounts",
    validator: validate_ContentAccountsInsert_594198, base: "/content/v2.1",
    url: url_ContentAccountsInsert_594199, schemes: {Scheme.Https})
type
  Call_ContentAccountsList_594166 = ref object of OpenApiRestCall_593421
proc url_ContentAccountsList_594168(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentAccountsList_594167(path: JsonNode; query: JsonNode;
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
  var valid_594183 = path.getOrDefault("merchantId")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "merchantId", valid_594183
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
  var valid_594184 = query.getOrDefault("fields")
  valid_594184 = validateParameter(valid_594184, JString, required = false,
                                 default = nil)
  if valid_594184 != nil:
    section.add "fields", valid_594184
  var valid_594185 = query.getOrDefault("pageToken")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = nil)
  if valid_594185 != nil:
    section.add "pageToken", valid_594185
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
  var valid_594190 = query.getOrDefault("maxResults")
  valid_594190 = validateParameter(valid_594190, JInt, required = false, default = nil)
  if valid_594190 != nil:
    section.add "maxResults", valid_594190
  var valid_594191 = query.getOrDefault("key")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = nil)
  if valid_594191 != nil:
    section.add "key", valid_594191
  var valid_594192 = query.getOrDefault("prettyPrint")
  valid_594192 = validateParameter(valid_594192, JBool, required = false,
                                 default = newJBool(true))
  if valid_594192 != nil:
    section.add "prettyPrint", valid_594192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594193: Call_ContentAccountsList_594166; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_594193.validator(path, query, header, formData, body)
  let scheme = call_594193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594193.url(scheme.get, call_594193.host, call_594193.base,
                         call_594193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594193, url, valid)

proc call*(call_594194: Call_ContentAccountsList_594166; merchantId: string;
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
  var path_594195 = newJObject()
  var query_594196 = newJObject()
  add(query_594196, "fields", newJString(fields))
  add(query_594196, "pageToken", newJString(pageToken))
  add(query_594196, "quotaUser", newJString(quotaUser))
  add(query_594196, "alt", newJString(alt))
  add(query_594196, "oauth_token", newJString(oauthToken))
  add(query_594196, "userIp", newJString(userIp))
  add(query_594196, "maxResults", newJInt(maxResults))
  add(query_594196, "key", newJString(key))
  add(path_594195, "merchantId", newJString(merchantId))
  add(query_594196, "prettyPrint", newJBool(prettyPrint))
  result = call_594194.call(path_594195, query_594196, nil, nil, nil)

var contentAccountsList* = Call_ContentAccountsList_594166(
    name: "contentAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounts",
    validator: validate_ContentAccountsList_594167, base: "/content/v2.1",
    url: url_ContentAccountsList_594168, schemes: {Scheme.Https})
type
  Call_ContentAccountsUpdate_594230 = ref object of OpenApiRestCall_593421
proc url_ContentAccountsUpdate_594232(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentAccountsUpdate_594231(path: JsonNode; query: JsonNode;
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
  var valid_594233 = path.getOrDefault("accountId")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = nil)
  if valid_594233 != nil:
    section.add "accountId", valid_594233
  var valid_594234 = path.getOrDefault("merchantId")
  valid_594234 = validateParameter(valid_594234, JString, required = true,
                                 default = nil)
  if valid_594234 != nil:
    section.add "merchantId", valid_594234
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
  var valid_594235 = query.getOrDefault("fields")
  valid_594235 = validateParameter(valid_594235, JString, required = false,
                                 default = nil)
  if valid_594235 != nil:
    section.add "fields", valid_594235
  var valid_594236 = query.getOrDefault("quotaUser")
  valid_594236 = validateParameter(valid_594236, JString, required = false,
                                 default = nil)
  if valid_594236 != nil:
    section.add "quotaUser", valid_594236
  var valid_594237 = query.getOrDefault("alt")
  valid_594237 = validateParameter(valid_594237, JString, required = false,
                                 default = newJString("json"))
  if valid_594237 != nil:
    section.add "alt", valid_594237
  var valid_594238 = query.getOrDefault("oauth_token")
  valid_594238 = validateParameter(valid_594238, JString, required = false,
                                 default = nil)
  if valid_594238 != nil:
    section.add "oauth_token", valid_594238
  var valid_594239 = query.getOrDefault("userIp")
  valid_594239 = validateParameter(valid_594239, JString, required = false,
                                 default = nil)
  if valid_594239 != nil:
    section.add "userIp", valid_594239
  var valid_594240 = query.getOrDefault("key")
  valid_594240 = validateParameter(valid_594240, JString, required = false,
                                 default = nil)
  if valid_594240 != nil:
    section.add "key", valid_594240
  var valid_594241 = query.getOrDefault("prettyPrint")
  valid_594241 = validateParameter(valid_594241, JBool, required = false,
                                 default = newJBool(true))
  if valid_594241 != nil:
    section.add "prettyPrint", valid_594241
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

proc call*(call_594243: Call_ContentAccountsUpdate_594230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Merchant Center account.
  ## 
  let valid = call_594243.validator(path, query, header, formData, body)
  let scheme = call_594243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594243.url(scheme.get, call_594243.host, call_594243.base,
                         call_594243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594243, url, valid)

proc call*(call_594244: Call_ContentAccountsUpdate_594230; accountId: string;
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
  var path_594245 = newJObject()
  var query_594246 = newJObject()
  var body_594247 = newJObject()
  add(query_594246, "fields", newJString(fields))
  add(query_594246, "quotaUser", newJString(quotaUser))
  add(query_594246, "alt", newJString(alt))
  add(query_594246, "oauth_token", newJString(oauthToken))
  add(path_594245, "accountId", newJString(accountId))
  add(query_594246, "userIp", newJString(userIp))
  add(query_594246, "key", newJString(key))
  add(path_594245, "merchantId", newJString(merchantId))
  if body != nil:
    body_594247 = body
  add(query_594246, "prettyPrint", newJBool(prettyPrint))
  result = call_594244.call(path_594245, query_594246, nil, nil, body_594247)

var contentAccountsUpdate* = Call_ContentAccountsUpdate_594230(
    name: "contentAccountsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsUpdate_594231, base: "/content/v2.1",
    url: url_ContentAccountsUpdate_594232, schemes: {Scheme.Https})
type
  Call_ContentAccountsGet_594214 = ref object of OpenApiRestCall_593421
proc url_ContentAccountsGet_594216(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentAccountsGet_594215(path: JsonNode; query: JsonNode;
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
  var valid_594217 = path.getOrDefault("accountId")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "accountId", valid_594217
  var valid_594218 = path.getOrDefault("merchantId")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "merchantId", valid_594218
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
  var valid_594219 = query.getOrDefault("fields")
  valid_594219 = validateParameter(valid_594219, JString, required = false,
                                 default = nil)
  if valid_594219 != nil:
    section.add "fields", valid_594219
  var valid_594220 = query.getOrDefault("quotaUser")
  valid_594220 = validateParameter(valid_594220, JString, required = false,
                                 default = nil)
  if valid_594220 != nil:
    section.add "quotaUser", valid_594220
  var valid_594221 = query.getOrDefault("alt")
  valid_594221 = validateParameter(valid_594221, JString, required = false,
                                 default = newJString("json"))
  if valid_594221 != nil:
    section.add "alt", valid_594221
  var valid_594222 = query.getOrDefault("oauth_token")
  valid_594222 = validateParameter(valid_594222, JString, required = false,
                                 default = nil)
  if valid_594222 != nil:
    section.add "oauth_token", valid_594222
  var valid_594223 = query.getOrDefault("userIp")
  valid_594223 = validateParameter(valid_594223, JString, required = false,
                                 default = nil)
  if valid_594223 != nil:
    section.add "userIp", valid_594223
  var valid_594224 = query.getOrDefault("key")
  valid_594224 = validateParameter(valid_594224, JString, required = false,
                                 default = nil)
  if valid_594224 != nil:
    section.add "key", valid_594224
  var valid_594225 = query.getOrDefault("prettyPrint")
  valid_594225 = validateParameter(valid_594225, JBool, required = false,
                                 default = newJBool(true))
  if valid_594225 != nil:
    section.add "prettyPrint", valid_594225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594226: Call_ContentAccountsGet_594214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a Merchant Center account.
  ## 
  let valid = call_594226.validator(path, query, header, formData, body)
  let scheme = call_594226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594226.url(scheme.get, call_594226.host, call_594226.base,
                         call_594226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594226, url, valid)

proc call*(call_594227: Call_ContentAccountsGet_594214; accountId: string;
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
  var path_594228 = newJObject()
  var query_594229 = newJObject()
  add(query_594229, "fields", newJString(fields))
  add(query_594229, "quotaUser", newJString(quotaUser))
  add(query_594229, "alt", newJString(alt))
  add(query_594229, "oauth_token", newJString(oauthToken))
  add(path_594228, "accountId", newJString(accountId))
  add(query_594229, "userIp", newJString(userIp))
  add(query_594229, "key", newJString(key))
  add(path_594228, "merchantId", newJString(merchantId))
  add(query_594229, "prettyPrint", newJBool(prettyPrint))
  result = call_594227.call(path_594228, query_594229, nil, nil, nil)

var contentAccountsGet* = Call_ContentAccountsGet_594214(
    name: "contentAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsGet_594215, base: "/content/v2.1",
    url: url_ContentAccountsGet_594216, schemes: {Scheme.Https})
type
  Call_ContentAccountsDelete_594248 = ref object of OpenApiRestCall_593421
proc url_ContentAccountsDelete_594250(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentAccountsDelete_594249(path: JsonNode; query: JsonNode;
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
  var valid_594251 = path.getOrDefault("accountId")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "accountId", valid_594251
  var valid_594252 = path.getOrDefault("merchantId")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "merchantId", valid_594252
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
  var valid_594253 = query.getOrDefault("fields")
  valid_594253 = validateParameter(valid_594253, JString, required = false,
                                 default = nil)
  if valid_594253 != nil:
    section.add "fields", valid_594253
  var valid_594254 = query.getOrDefault("force")
  valid_594254 = validateParameter(valid_594254, JBool, required = false,
                                 default = newJBool(false))
  if valid_594254 != nil:
    section.add "force", valid_594254
  var valid_594255 = query.getOrDefault("quotaUser")
  valid_594255 = validateParameter(valid_594255, JString, required = false,
                                 default = nil)
  if valid_594255 != nil:
    section.add "quotaUser", valid_594255
  var valid_594256 = query.getOrDefault("alt")
  valid_594256 = validateParameter(valid_594256, JString, required = false,
                                 default = newJString("json"))
  if valid_594256 != nil:
    section.add "alt", valid_594256
  var valid_594257 = query.getOrDefault("oauth_token")
  valid_594257 = validateParameter(valid_594257, JString, required = false,
                                 default = nil)
  if valid_594257 != nil:
    section.add "oauth_token", valid_594257
  var valid_594258 = query.getOrDefault("userIp")
  valid_594258 = validateParameter(valid_594258, JString, required = false,
                                 default = nil)
  if valid_594258 != nil:
    section.add "userIp", valid_594258
  var valid_594259 = query.getOrDefault("key")
  valid_594259 = validateParameter(valid_594259, JString, required = false,
                                 default = nil)
  if valid_594259 != nil:
    section.add "key", valid_594259
  var valid_594260 = query.getOrDefault("prettyPrint")
  valid_594260 = validateParameter(valid_594260, JBool, required = false,
                                 default = newJBool(true))
  if valid_594260 != nil:
    section.add "prettyPrint", valid_594260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594261: Call_ContentAccountsDelete_594248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Merchant Center sub-account.
  ## 
  let valid = call_594261.validator(path, query, header, formData, body)
  let scheme = call_594261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594261.url(scheme.get, call_594261.host, call_594261.base,
                         call_594261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594261, url, valid)

proc call*(call_594262: Call_ContentAccountsDelete_594248; accountId: string;
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
  var path_594263 = newJObject()
  var query_594264 = newJObject()
  add(query_594264, "fields", newJString(fields))
  add(query_594264, "force", newJBool(force))
  add(query_594264, "quotaUser", newJString(quotaUser))
  add(query_594264, "alt", newJString(alt))
  add(query_594264, "oauth_token", newJString(oauthToken))
  add(path_594263, "accountId", newJString(accountId))
  add(query_594264, "userIp", newJString(userIp))
  add(query_594264, "key", newJString(key))
  add(path_594263, "merchantId", newJString(merchantId))
  add(query_594264, "prettyPrint", newJBool(prettyPrint))
  result = call_594262.call(path_594263, query_594264, nil, nil, nil)

var contentAccountsDelete* = Call_ContentAccountsDelete_594248(
    name: "contentAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsDelete_594249, base: "/content/v2.1",
    url: url_ContentAccountsDelete_594250, schemes: {Scheme.Https})
type
  Call_ContentAccountsClaimwebsite_594265 = ref object of OpenApiRestCall_593421
proc url_ContentAccountsClaimwebsite_594267(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentAccountsClaimwebsite_594266(path: JsonNode; query: JsonNode;
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
  var valid_594268 = path.getOrDefault("accountId")
  valid_594268 = validateParameter(valid_594268, JString, required = true,
                                 default = nil)
  if valid_594268 != nil:
    section.add "accountId", valid_594268
  var valid_594269 = path.getOrDefault("merchantId")
  valid_594269 = validateParameter(valid_594269, JString, required = true,
                                 default = nil)
  if valid_594269 != nil:
    section.add "merchantId", valid_594269
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
  var valid_594270 = query.getOrDefault("fields")
  valid_594270 = validateParameter(valid_594270, JString, required = false,
                                 default = nil)
  if valid_594270 != nil:
    section.add "fields", valid_594270
  var valid_594271 = query.getOrDefault("quotaUser")
  valid_594271 = validateParameter(valid_594271, JString, required = false,
                                 default = nil)
  if valid_594271 != nil:
    section.add "quotaUser", valid_594271
  var valid_594272 = query.getOrDefault("alt")
  valid_594272 = validateParameter(valid_594272, JString, required = false,
                                 default = newJString("json"))
  if valid_594272 != nil:
    section.add "alt", valid_594272
  var valid_594273 = query.getOrDefault("oauth_token")
  valid_594273 = validateParameter(valid_594273, JString, required = false,
                                 default = nil)
  if valid_594273 != nil:
    section.add "oauth_token", valid_594273
  var valid_594274 = query.getOrDefault("userIp")
  valid_594274 = validateParameter(valid_594274, JString, required = false,
                                 default = nil)
  if valid_594274 != nil:
    section.add "userIp", valid_594274
  var valid_594275 = query.getOrDefault("overwrite")
  valid_594275 = validateParameter(valid_594275, JBool, required = false, default = nil)
  if valid_594275 != nil:
    section.add "overwrite", valid_594275
  var valid_594276 = query.getOrDefault("key")
  valid_594276 = validateParameter(valid_594276, JString, required = false,
                                 default = nil)
  if valid_594276 != nil:
    section.add "key", valid_594276
  var valid_594277 = query.getOrDefault("prettyPrint")
  valid_594277 = validateParameter(valid_594277, JBool, required = false,
                                 default = newJBool(true))
  if valid_594277 != nil:
    section.add "prettyPrint", valid_594277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594278: Call_ContentAccountsClaimwebsite_594265; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Claims the website of a Merchant Center sub-account.
  ## 
  let valid = call_594278.validator(path, query, header, formData, body)
  let scheme = call_594278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594278.url(scheme.get, call_594278.host, call_594278.base,
                         call_594278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594278, url, valid)

proc call*(call_594279: Call_ContentAccountsClaimwebsite_594265; accountId: string;
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
  var path_594280 = newJObject()
  var query_594281 = newJObject()
  add(query_594281, "fields", newJString(fields))
  add(query_594281, "quotaUser", newJString(quotaUser))
  add(query_594281, "alt", newJString(alt))
  add(query_594281, "oauth_token", newJString(oauthToken))
  add(path_594280, "accountId", newJString(accountId))
  add(query_594281, "userIp", newJString(userIp))
  add(query_594281, "overwrite", newJBool(overwrite))
  add(query_594281, "key", newJString(key))
  add(path_594280, "merchantId", newJString(merchantId))
  add(query_594281, "prettyPrint", newJBool(prettyPrint))
  result = call_594279.call(path_594280, query_594281, nil, nil, nil)

var contentAccountsClaimwebsite* = Call_ContentAccountsClaimwebsite_594265(
    name: "contentAccountsClaimwebsite", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/accounts/{accountId}/claimwebsite",
    validator: validate_ContentAccountsClaimwebsite_594266, base: "/content/v2.1",
    url: url_ContentAccountsClaimwebsite_594267, schemes: {Scheme.Https})
type
  Call_ContentAccountsLink_594282 = ref object of OpenApiRestCall_593421
proc url_ContentAccountsLink_594284(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentAccountsLink_594283(path: JsonNode; query: JsonNode;
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
  var valid_594285 = path.getOrDefault("accountId")
  valid_594285 = validateParameter(valid_594285, JString, required = true,
                                 default = nil)
  if valid_594285 != nil:
    section.add "accountId", valid_594285
  var valid_594286 = path.getOrDefault("merchantId")
  valid_594286 = validateParameter(valid_594286, JString, required = true,
                                 default = nil)
  if valid_594286 != nil:
    section.add "merchantId", valid_594286
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
  var valid_594287 = query.getOrDefault("fields")
  valid_594287 = validateParameter(valid_594287, JString, required = false,
                                 default = nil)
  if valid_594287 != nil:
    section.add "fields", valid_594287
  var valid_594288 = query.getOrDefault("quotaUser")
  valid_594288 = validateParameter(valid_594288, JString, required = false,
                                 default = nil)
  if valid_594288 != nil:
    section.add "quotaUser", valid_594288
  var valid_594289 = query.getOrDefault("alt")
  valid_594289 = validateParameter(valid_594289, JString, required = false,
                                 default = newJString("json"))
  if valid_594289 != nil:
    section.add "alt", valid_594289
  var valid_594290 = query.getOrDefault("oauth_token")
  valid_594290 = validateParameter(valid_594290, JString, required = false,
                                 default = nil)
  if valid_594290 != nil:
    section.add "oauth_token", valid_594290
  var valid_594291 = query.getOrDefault("userIp")
  valid_594291 = validateParameter(valid_594291, JString, required = false,
                                 default = nil)
  if valid_594291 != nil:
    section.add "userIp", valid_594291
  var valid_594292 = query.getOrDefault("key")
  valid_594292 = validateParameter(valid_594292, JString, required = false,
                                 default = nil)
  if valid_594292 != nil:
    section.add "key", valid_594292
  var valid_594293 = query.getOrDefault("prettyPrint")
  valid_594293 = validateParameter(valid_594293, JBool, required = false,
                                 default = newJBool(true))
  if valid_594293 != nil:
    section.add "prettyPrint", valid_594293
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

proc call*(call_594295: Call_ContentAccountsLink_594282; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs an action on a link between two Merchant Center accounts, namely accountId and linkedAccountId.
  ## 
  let valid = call_594295.validator(path, query, header, formData, body)
  let scheme = call_594295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594295.url(scheme.get, call_594295.host, call_594295.base,
                         call_594295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594295, url, valid)

proc call*(call_594296: Call_ContentAccountsLink_594282; accountId: string;
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
  var path_594297 = newJObject()
  var query_594298 = newJObject()
  var body_594299 = newJObject()
  add(query_594298, "fields", newJString(fields))
  add(query_594298, "quotaUser", newJString(quotaUser))
  add(query_594298, "alt", newJString(alt))
  add(query_594298, "oauth_token", newJString(oauthToken))
  add(path_594297, "accountId", newJString(accountId))
  add(query_594298, "userIp", newJString(userIp))
  add(query_594298, "key", newJString(key))
  add(path_594297, "merchantId", newJString(merchantId))
  if body != nil:
    body_594299 = body
  add(query_594298, "prettyPrint", newJBool(prettyPrint))
  result = call_594296.call(path_594297, query_594298, nil, nil, body_594299)

var contentAccountsLink* = Call_ContentAccountsLink_594282(
    name: "contentAccountsLink", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}/link",
    validator: validate_ContentAccountsLink_594283, base: "/content/v2.1",
    url: url_ContentAccountsLink_594284, schemes: {Scheme.Https})
type
  Call_ContentAccountstatusesList_594300 = ref object of OpenApiRestCall_593421
proc url_ContentAccountstatusesList_594302(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentAccountstatusesList_594301(path: JsonNode; query: JsonNode;
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
  var valid_594303 = path.getOrDefault("merchantId")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "merchantId", valid_594303
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
  var valid_594304 = query.getOrDefault("fields")
  valid_594304 = validateParameter(valid_594304, JString, required = false,
                                 default = nil)
  if valid_594304 != nil:
    section.add "fields", valid_594304
  var valid_594305 = query.getOrDefault("pageToken")
  valid_594305 = validateParameter(valid_594305, JString, required = false,
                                 default = nil)
  if valid_594305 != nil:
    section.add "pageToken", valid_594305
  var valid_594306 = query.getOrDefault("quotaUser")
  valid_594306 = validateParameter(valid_594306, JString, required = false,
                                 default = nil)
  if valid_594306 != nil:
    section.add "quotaUser", valid_594306
  var valid_594307 = query.getOrDefault("alt")
  valid_594307 = validateParameter(valid_594307, JString, required = false,
                                 default = newJString("json"))
  if valid_594307 != nil:
    section.add "alt", valid_594307
  var valid_594308 = query.getOrDefault("oauth_token")
  valid_594308 = validateParameter(valid_594308, JString, required = false,
                                 default = nil)
  if valid_594308 != nil:
    section.add "oauth_token", valid_594308
  var valid_594309 = query.getOrDefault("userIp")
  valid_594309 = validateParameter(valid_594309, JString, required = false,
                                 default = nil)
  if valid_594309 != nil:
    section.add "userIp", valid_594309
  var valid_594310 = query.getOrDefault("maxResults")
  valid_594310 = validateParameter(valid_594310, JInt, required = false, default = nil)
  if valid_594310 != nil:
    section.add "maxResults", valid_594310
  var valid_594311 = query.getOrDefault("key")
  valid_594311 = validateParameter(valid_594311, JString, required = false,
                                 default = nil)
  if valid_594311 != nil:
    section.add "key", valid_594311
  var valid_594312 = query.getOrDefault("prettyPrint")
  valid_594312 = validateParameter(valid_594312, JBool, required = false,
                                 default = newJBool(true))
  if valid_594312 != nil:
    section.add "prettyPrint", valid_594312
  var valid_594313 = query.getOrDefault("destinations")
  valid_594313 = validateParameter(valid_594313, JArray, required = false,
                                 default = nil)
  if valid_594313 != nil:
    section.add "destinations", valid_594313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594314: Call_ContentAccountstatusesList_594300; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_594314.validator(path, query, header, formData, body)
  let scheme = call_594314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594314.url(scheme.get, call_594314.host, call_594314.base,
                         call_594314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594314, url, valid)

proc call*(call_594315: Call_ContentAccountstatusesList_594300; merchantId: string;
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
  var path_594316 = newJObject()
  var query_594317 = newJObject()
  add(query_594317, "fields", newJString(fields))
  add(query_594317, "pageToken", newJString(pageToken))
  add(query_594317, "quotaUser", newJString(quotaUser))
  add(query_594317, "alt", newJString(alt))
  add(query_594317, "oauth_token", newJString(oauthToken))
  add(query_594317, "userIp", newJString(userIp))
  add(query_594317, "maxResults", newJInt(maxResults))
  add(query_594317, "key", newJString(key))
  add(path_594316, "merchantId", newJString(merchantId))
  add(query_594317, "prettyPrint", newJBool(prettyPrint))
  if destinations != nil:
    query_594317.add "destinations", destinations
  result = call_594315.call(path_594316, query_594317, nil, nil, nil)

var contentAccountstatusesList* = Call_ContentAccountstatusesList_594300(
    name: "contentAccountstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accountstatuses",
    validator: validate_ContentAccountstatusesList_594301, base: "/content/v2.1",
    url: url_ContentAccountstatusesList_594302, schemes: {Scheme.Https})
type
  Call_ContentAccountstatusesGet_594318 = ref object of OpenApiRestCall_593421
proc url_ContentAccountstatusesGet_594320(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentAccountstatusesGet_594319(path: JsonNode; query: JsonNode;
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
  var valid_594321 = path.getOrDefault("accountId")
  valid_594321 = validateParameter(valid_594321, JString, required = true,
                                 default = nil)
  if valid_594321 != nil:
    section.add "accountId", valid_594321
  var valid_594322 = path.getOrDefault("merchantId")
  valid_594322 = validateParameter(valid_594322, JString, required = true,
                                 default = nil)
  if valid_594322 != nil:
    section.add "merchantId", valid_594322
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
  var valid_594323 = query.getOrDefault("fields")
  valid_594323 = validateParameter(valid_594323, JString, required = false,
                                 default = nil)
  if valid_594323 != nil:
    section.add "fields", valid_594323
  var valid_594324 = query.getOrDefault("quotaUser")
  valid_594324 = validateParameter(valid_594324, JString, required = false,
                                 default = nil)
  if valid_594324 != nil:
    section.add "quotaUser", valid_594324
  var valid_594325 = query.getOrDefault("alt")
  valid_594325 = validateParameter(valid_594325, JString, required = false,
                                 default = newJString("json"))
  if valid_594325 != nil:
    section.add "alt", valid_594325
  var valid_594326 = query.getOrDefault("oauth_token")
  valid_594326 = validateParameter(valid_594326, JString, required = false,
                                 default = nil)
  if valid_594326 != nil:
    section.add "oauth_token", valid_594326
  var valid_594327 = query.getOrDefault("userIp")
  valid_594327 = validateParameter(valid_594327, JString, required = false,
                                 default = nil)
  if valid_594327 != nil:
    section.add "userIp", valid_594327
  var valid_594328 = query.getOrDefault("key")
  valid_594328 = validateParameter(valid_594328, JString, required = false,
                                 default = nil)
  if valid_594328 != nil:
    section.add "key", valid_594328
  var valid_594329 = query.getOrDefault("prettyPrint")
  valid_594329 = validateParameter(valid_594329, JBool, required = false,
                                 default = newJBool(true))
  if valid_594329 != nil:
    section.add "prettyPrint", valid_594329
  var valid_594330 = query.getOrDefault("destinations")
  valid_594330 = validateParameter(valid_594330, JArray, required = false,
                                 default = nil)
  if valid_594330 != nil:
    section.add "destinations", valid_594330
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594331: Call_ContentAccountstatusesGet_594318; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the status of a Merchant Center account. No itemLevelIssues are returned for multi-client accounts.
  ## 
  let valid = call_594331.validator(path, query, header, formData, body)
  let scheme = call_594331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594331.url(scheme.get, call_594331.host, call_594331.base,
                         call_594331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594331, url, valid)

proc call*(call_594332: Call_ContentAccountstatusesGet_594318; accountId: string;
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
  var path_594333 = newJObject()
  var query_594334 = newJObject()
  add(query_594334, "fields", newJString(fields))
  add(query_594334, "quotaUser", newJString(quotaUser))
  add(query_594334, "alt", newJString(alt))
  add(query_594334, "oauth_token", newJString(oauthToken))
  add(path_594333, "accountId", newJString(accountId))
  add(query_594334, "userIp", newJString(userIp))
  add(query_594334, "key", newJString(key))
  add(path_594333, "merchantId", newJString(merchantId))
  add(query_594334, "prettyPrint", newJBool(prettyPrint))
  if destinations != nil:
    query_594334.add "destinations", destinations
  result = call_594332.call(path_594333, query_594334, nil, nil, nil)

var contentAccountstatusesGet* = Call_ContentAccountstatusesGet_594318(
    name: "contentAccountstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/accountstatuses/{accountId}",
    validator: validate_ContentAccountstatusesGet_594319, base: "/content/v2.1",
    url: url_ContentAccountstatusesGet_594320, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxList_594335 = ref object of OpenApiRestCall_593421
proc url_ContentAccounttaxList_594337(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentAccounttaxList_594336(path: JsonNode; query: JsonNode;
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
  var valid_594338 = path.getOrDefault("merchantId")
  valid_594338 = validateParameter(valid_594338, JString, required = true,
                                 default = nil)
  if valid_594338 != nil:
    section.add "merchantId", valid_594338
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
  var valid_594339 = query.getOrDefault("fields")
  valid_594339 = validateParameter(valid_594339, JString, required = false,
                                 default = nil)
  if valid_594339 != nil:
    section.add "fields", valid_594339
  var valid_594340 = query.getOrDefault("pageToken")
  valid_594340 = validateParameter(valid_594340, JString, required = false,
                                 default = nil)
  if valid_594340 != nil:
    section.add "pageToken", valid_594340
  var valid_594341 = query.getOrDefault("quotaUser")
  valid_594341 = validateParameter(valid_594341, JString, required = false,
                                 default = nil)
  if valid_594341 != nil:
    section.add "quotaUser", valid_594341
  var valid_594342 = query.getOrDefault("alt")
  valid_594342 = validateParameter(valid_594342, JString, required = false,
                                 default = newJString("json"))
  if valid_594342 != nil:
    section.add "alt", valid_594342
  var valid_594343 = query.getOrDefault("oauth_token")
  valid_594343 = validateParameter(valid_594343, JString, required = false,
                                 default = nil)
  if valid_594343 != nil:
    section.add "oauth_token", valid_594343
  var valid_594344 = query.getOrDefault("userIp")
  valid_594344 = validateParameter(valid_594344, JString, required = false,
                                 default = nil)
  if valid_594344 != nil:
    section.add "userIp", valid_594344
  var valid_594345 = query.getOrDefault("maxResults")
  valid_594345 = validateParameter(valid_594345, JInt, required = false, default = nil)
  if valid_594345 != nil:
    section.add "maxResults", valid_594345
  var valid_594346 = query.getOrDefault("key")
  valid_594346 = validateParameter(valid_594346, JString, required = false,
                                 default = nil)
  if valid_594346 != nil:
    section.add "key", valid_594346
  var valid_594347 = query.getOrDefault("prettyPrint")
  valid_594347 = validateParameter(valid_594347, JBool, required = false,
                                 default = newJBool(true))
  if valid_594347 != nil:
    section.add "prettyPrint", valid_594347
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594348: Call_ContentAccounttaxList_594335; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the tax settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_594348.validator(path, query, header, formData, body)
  let scheme = call_594348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594348.url(scheme.get, call_594348.host, call_594348.base,
                         call_594348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594348, url, valid)

proc call*(call_594349: Call_ContentAccounttaxList_594335; merchantId: string;
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
  var path_594350 = newJObject()
  var query_594351 = newJObject()
  add(query_594351, "fields", newJString(fields))
  add(query_594351, "pageToken", newJString(pageToken))
  add(query_594351, "quotaUser", newJString(quotaUser))
  add(query_594351, "alt", newJString(alt))
  add(query_594351, "oauth_token", newJString(oauthToken))
  add(query_594351, "userIp", newJString(userIp))
  add(query_594351, "maxResults", newJInt(maxResults))
  add(query_594351, "key", newJString(key))
  add(path_594350, "merchantId", newJString(merchantId))
  add(query_594351, "prettyPrint", newJBool(prettyPrint))
  result = call_594349.call(path_594350, query_594351, nil, nil, nil)

var contentAccounttaxList* = Call_ContentAccounttaxList_594335(
    name: "contentAccounttaxList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax",
    validator: validate_ContentAccounttaxList_594336, base: "/content/v2.1",
    url: url_ContentAccounttaxList_594337, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxUpdate_594368 = ref object of OpenApiRestCall_593421
proc url_ContentAccounttaxUpdate_594370(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentAccounttaxUpdate_594369(path: JsonNode; query: JsonNode;
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
  var valid_594371 = path.getOrDefault("accountId")
  valid_594371 = validateParameter(valid_594371, JString, required = true,
                                 default = nil)
  if valid_594371 != nil:
    section.add "accountId", valid_594371
  var valid_594372 = path.getOrDefault("merchantId")
  valid_594372 = validateParameter(valid_594372, JString, required = true,
                                 default = nil)
  if valid_594372 != nil:
    section.add "merchantId", valid_594372
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
  var valid_594373 = query.getOrDefault("fields")
  valid_594373 = validateParameter(valid_594373, JString, required = false,
                                 default = nil)
  if valid_594373 != nil:
    section.add "fields", valid_594373
  var valid_594374 = query.getOrDefault("quotaUser")
  valid_594374 = validateParameter(valid_594374, JString, required = false,
                                 default = nil)
  if valid_594374 != nil:
    section.add "quotaUser", valid_594374
  var valid_594375 = query.getOrDefault("alt")
  valid_594375 = validateParameter(valid_594375, JString, required = false,
                                 default = newJString("json"))
  if valid_594375 != nil:
    section.add "alt", valid_594375
  var valid_594376 = query.getOrDefault("oauth_token")
  valid_594376 = validateParameter(valid_594376, JString, required = false,
                                 default = nil)
  if valid_594376 != nil:
    section.add "oauth_token", valid_594376
  var valid_594377 = query.getOrDefault("userIp")
  valid_594377 = validateParameter(valid_594377, JString, required = false,
                                 default = nil)
  if valid_594377 != nil:
    section.add "userIp", valid_594377
  var valid_594378 = query.getOrDefault("key")
  valid_594378 = validateParameter(valid_594378, JString, required = false,
                                 default = nil)
  if valid_594378 != nil:
    section.add "key", valid_594378
  var valid_594379 = query.getOrDefault("prettyPrint")
  valid_594379 = validateParameter(valid_594379, JBool, required = false,
                                 default = newJBool(true))
  if valid_594379 != nil:
    section.add "prettyPrint", valid_594379
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

proc call*(call_594381: Call_ContentAccounttaxUpdate_594368; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the tax settings of the account.
  ## 
  let valid = call_594381.validator(path, query, header, formData, body)
  let scheme = call_594381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594381.url(scheme.get, call_594381.host, call_594381.base,
                         call_594381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594381, url, valid)

proc call*(call_594382: Call_ContentAccounttaxUpdate_594368; accountId: string;
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
  var path_594383 = newJObject()
  var query_594384 = newJObject()
  var body_594385 = newJObject()
  add(query_594384, "fields", newJString(fields))
  add(query_594384, "quotaUser", newJString(quotaUser))
  add(query_594384, "alt", newJString(alt))
  add(query_594384, "oauth_token", newJString(oauthToken))
  add(path_594383, "accountId", newJString(accountId))
  add(query_594384, "userIp", newJString(userIp))
  add(query_594384, "key", newJString(key))
  add(path_594383, "merchantId", newJString(merchantId))
  if body != nil:
    body_594385 = body
  add(query_594384, "prettyPrint", newJBool(prettyPrint))
  result = call_594382.call(path_594383, query_594384, nil, nil, body_594385)

var contentAccounttaxUpdate* = Call_ContentAccounttaxUpdate_594368(
    name: "contentAccounttaxUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax/{accountId}",
    validator: validate_ContentAccounttaxUpdate_594369, base: "/content/v2.1",
    url: url_ContentAccounttaxUpdate_594370, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxGet_594352 = ref object of OpenApiRestCall_593421
proc url_ContentAccounttaxGet_594354(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentAccounttaxGet_594353(path: JsonNode; query: JsonNode;
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
  var valid_594355 = path.getOrDefault("accountId")
  valid_594355 = validateParameter(valid_594355, JString, required = true,
                                 default = nil)
  if valid_594355 != nil:
    section.add "accountId", valid_594355
  var valid_594356 = path.getOrDefault("merchantId")
  valid_594356 = validateParameter(valid_594356, JString, required = true,
                                 default = nil)
  if valid_594356 != nil:
    section.add "merchantId", valid_594356
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
  var valid_594357 = query.getOrDefault("fields")
  valid_594357 = validateParameter(valid_594357, JString, required = false,
                                 default = nil)
  if valid_594357 != nil:
    section.add "fields", valid_594357
  var valid_594358 = query.getOrDefault("quotaUser")
  valid_594358 = validateParameter(valid_594358, JString, required = false,
                                 default = nil)
  if valid_594358 != nil:
    section.add "quotaUser", valid_594358
  var valid_594359 = query.getOrDefault("alt")
  valid_594359 = validateParameter(valid_594359, JString, required = false,
                                 default = newJString("json"))
  if valid_594359 != nil:
    section.add "alt", valid_594359
  var valid_594360 = query.getOrDefault("oauth_token")
  valid_594360 = validateParameter(valid_594360, JString, required = false,
                                 default = nil)
  if valid_594360 != nil:
    section.add "oauth_token", valid_594360
  var valid_594361 = query.getOrDefault("userIp")
  valid_594361 = validateParameter(valid_594361, JString, required = false,
                                 default = nil)
  if valid_594361 != nil:
    section.add "userIp", valid_594361
  var valid_594362 = query.getOrDefault("key")
  valid_594362 = validateParameter(valid_594362, JString, required = false,
                                 default = nil)
  if valid_594362 != nil:
    section.add "key", valid_594362
  var valid_594363 = query.getOrDefault("prettyPrint")
  valid_594363 = validateParameter(valid_594363, JBool, required = false,
                                 default = newJBool(true))
  if valid_594363 != nil:
    section.add "prettyPrint", valid_594363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594364: Call_ContentAccounttaxGet_594352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the tax settings of the account.
  ## 
  let valid = call_594364.validator(path, query, header, formData, body)
  let scheme = call_594364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594364.url(scheme.get, call_594364.host, call_594364.base,
                         call_594364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594364, url, valid)

proc call*(call_594365: Call_ContentAccounttaxGet_594352; accountId: string;
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
  var path_594366 = newJObject()
  var query_594367 = newJObject()
  add(query_594367, "fields", newJString(fields))
  add(query_594367, "quotaUser", newJString(quotaUser))
  add(query_594367, "alt", newJString(alt))
  add(query_594367, "oauth_token", newJString(oauthToken))
  add(path_594366, "accountId", newJString(accountId))
  add(query_594367, "userIp", newJString(userIp))
  add(query_594367, "key", newJString(key))
  add(path_594366, "merchantId", newJString(merchantId))
  add(query_594367, "prettyPrint", newJBool(prettyPrint))
  result = call_594365.call(path_594366, query_594367, nil, nil, nil)

var contentAccounttaxGet* = Call_ContentAccounttaxGet_594352(
    name: "contentAccounttaxGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax/{accountId}",
    validator: validate_ContentAccounttaxGet_594353, base: "/content/v2.1",
    url: url_ContentAccounttaxGet_594354, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsInsert_594403 = ref object of OpenApiRestCall_593421
proc url_ContentDatafeedsInsert_594405(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentDatafeedsInsert_594404(path: JsonNode; query: JsonNode;
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
  var valid_594406 = path.getOrDefault("merchantId")
  valid_594406 = validateParameter(valid_594406, JString, required = true,
                                 default = nil)
  if valid_594406 != nil:
    section.add "merchantId", valid_594406
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
  var valid_594407 = query.getOrDefault("fields")
  valid_594407 = validateParameter(valid_594407, JString, required = false,
                                 default = nil)
  if valid_594407 != nil:
    section.add "fields", valid_594407
  var valid_594408 = query.getOrDefault("quotaUser")
  valid_594408 = validateParameter(valid_594408, JString, required = false,
                                 default = nil)
  if valid_594408 != nil:
    section.add "quotaUser", valid_594408
  var valid_594409 = query.getOrDefault("alt")
  valid_594409 = validateParameter(valid_594409, JString, required = false,
                                 default = newJString("json"))
  if valid_594409 != nil:
    section.add "alt", valid_594409
  var valid_594410 = query.getOrDefault("oauth_token")
  valid_594410 = validateParameter(valid_594410, JString, required = false,
                                 default = nil)
  if valid_594410 != nil:
    section.add "oauth_token", valid_594410
  var valid_594411 = query.getOrDefault("userIp")
  valid_594411 = validateParameter(valid_594411, JString, required = false,
                                 default = nil)
  if valid_594411 != nil:
    section.add "userIp", valid_594411
  var valid_594412 = query.getOrDefault("key")
  valid_594412 = validateParameter(valid_594412, JString, required = false,
                                 default = nil)
  if valid_594412 != nil:
    section.add "key", valid_594412
  var valid_594413 = query.getOrDefault("prettyPrint")
  valid_594413 = validateParameter(valid_594413, JBool, required = false,
                                 default = newJBool(true))
  if valid_594413 != nil:
    section.add "prettyPrint", valid_594413
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

proc call*(call_594415: Call_ContentDatafeedsInsert_594403; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers a datafeed configuration with your Merchant Center account.
  ## 
  let valid = call_594415.validator(path, query, header, formData, body)
  let scheme = call_594415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594415.url(scheme.get, call_594415.host, call_594415.base,
                         call_594415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594415, url, valid)

proc call*(call_594416: Call_ContentDatafeedsInsert_594403; merchantId: string;
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
  var path_594417 = newJObject()
  var query_594418 = newJObject()
  var body_594419 = newJObject()
  add(query_594418, "fields", newJString(fields))
  add(query_594418, "quotaUser", newJString(quotaUser))
  add(query_594418, "alt", newJString(alt))
  add(query_594418, "oauth_token", newJString(oauthToken))
  add(query_594418, "userIp", newJString(userIp))
  add(query_594418, "key", newJString(key))
  add(path_594417, "merchantId", newJString(merchantId))
  if body != nil:
    body_594419 = body
  add(query_594418, "prettyPrint", newJBool(prettyPrint))
  result = call_594416.call(path_594417, query_594418, nil, nil, body_594419)

var contentDatafeedsInsert* = Call_ContentDatafeedsInsert_594403(
    name: "contentDatafeedsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds",
    validator: validate_ContentDatafeedsInsert_594404, base: "/content/v2.1",
    url: url_ContentDatafeedsInsert_594405, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsList_594386 = ref object of OpenApiRestCall_593421
proc url_ContentDatafeedsList_594388(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentDatafeedsList_594387(path: JsonNode; query: JsonNode;
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
  var valid_594389 = path.getOrDefault("merchantId")
  valid_594389 = validateParameter(valid_594389, JString, required = true,
                                 default = nil)
  if valid_594389 != nil:
    section.add "merchantId", valid_594389
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
  var valid_594390 = query.getOrDefault("fields")
  valid_594390 = validateParameter(valid_594390, JString, required = false,
                                 default = nil)
  if valid_594390 != nil:
    section.add "fields", valid_594390
  var valid_594391 = query.getOrDefault("pageToken")
  valid_594391 = validateParameter(valid_594391, JString, required = false,
                                 default = nil)
  if valid_594391 != nil:
    section.add "pageToken", valid_594391
  var valid_594392 = query.getOrDefault("quotaUser")
  valid_594392 = validateParameter(valid_594392, JString, required = false,
                                 default = nil)
  if valid_594392 != nil:
    section.add "quotaUser", valid_594392
  var valid_594393 = query.getOrDefault("alt")
  valid_594393 = validateParameter(valid_594393, JString, required = false,
                                 default = newJString("json"))
  if valid_594393 != nil:
    section.add "alt", valid_594393
  var valid_594394 = query.getOrDefault("oauth_token")
  valid_594394 = validateParameter(valid_594394, JString, required = false,
                                 default = nil)
  if valid_594394 != nil:
    section.add "oauth_token", valid_594394
  var valid_594395 = query.getOrDefault("userIp")
  valid_594395 = validateParameter(valid_594395, JString, required = false,
                                 default = nil)
  if valid_594395 != nil:
    section.add "userIp", valid_594395
  var valid_594396 = query.getOrDefault("maxResults")
  valid_594396 = validateParameter(valid_594396, JInt, required = false, default = nil)
  if valid_594396 != nil:
    section.add "maxResults", valid_594396
  var valid_594397 = query.getOrDefault("key")
  valid_594397 = validateParameter(valid_594397, JString, required = false,
                                 default = nil)
  if valid_594397 != nil:
    section.add "key", valid_594397
  var valid_594398 = query.getOrDefault("prettyPrint")
  valid_594398 = validateParameter(valid_594398, JBool, required = false,
                                 default = newJBool(true))
  if valid_594398 != nil:
    section.add "prettyPrint", valid_594398
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594399: Call_ContentDatafeedsList_594386; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the configurations for datafeeds in your Merchant Center account.
  ## 
  let valid = call_594399.validator(path, query, header, formData, body)
  let scheme = call_594399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594399.url(scheme.get, call_594399.host, call_594399.base,
                         call_594399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594399, url, valid)

proc call*(call_594400: Call_ContentDatafeedsList_594386; merchantId: string;
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
  var path_594401 = newJObject()
  var query_594402 = newJObject()
  add(query_594402, "fields", newJString(fields))
  add(query_594402, "pageToken", newJString(pageToken))
  add(query_594402, "quotaUser", newJString(quotaUser))
  add(query_594402, "alt", newJString(alt))
  add(query_594402, "oauth_token", newJString(oauthToken))
  add(query_594402, "userIp", newJString(userIp))
  add(query_594402, "maxResults", newJInt(maxResults))
  add(query_594402, "key", newJString(key))
  add(path_594401, "merchantId", newJString(merchantId))
  add(query_594402, "prettyPrint", newJBool(prettyPrint))
  result = call_594400.call(path_594401, query_594402, nil, nil, nil)

var contentDatafeedsList* = Call_ContentDatafeedsList_594386(
    name: "contentDatafeedsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds",
    validator: validate_ContentDatafeedsList_594387, base: "/content/v2.1",
    url: url_ContentDatafeedsList_594388, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsUpdate_594436 = ref object of OpenApiRestCall_593421
proc url_ContentDatafeedsUpdate_594438(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentDatafeedsUpdate_594437(path: JsonNode; query: JsonNode;
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
  var valid_594439 = path.getOrDefault("merchantId")
  valid_594439 = validateParameter(valid_594439, JString, required = true,
                                 default = nil)
  if valid_594439 != nil:
    section.add "merchantId", valid_594439
  var valid_594440 = path.getOrDefault("datafeedId")
  valid_594440 = validateParameter(valid_594440, JString, required = true,
                                 default = nil)
  if valid_594440 != nil:
    section.add "datafeedId", valid_594440
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
  var valid_594441 = query.getOrDefault("fields")
  valid_594441 = validateParameter(valid_594441, JString, required = false,
                                 default = nil)
  if valid_594441 != nil:
    section.add "fields", valid_594441
  var valid_594442 = query.getOrDefault("quotaUser")
  valid_594442 = validateParameter(valid_594442, JString, required = false,
                                 default = nil)
  if valid_594442 != nil:
    section.add "quotaUser", valid_594442
  var valid_594443 = query.getOrDefault("alt")
  valid_594443 = validateParameter(valid_594443, JString, required = false,
                                 default = newJString("json"))
  if valid_594443 != nil:
    section.add "alt", valid_594443
  var valid_594444 = query.getOrDefault("oauth_token")
  valid_594444 = validateParameter(valid_594444, JString, required = false,
                                 default = nil)
  if valid_594444 != nil:
    section.add "oauth_token", valid_594444
  var valid_594445 = query.getOrDefault("userIp")
  valid_594445 = validateParameter(valid_594445, JString, required = false,
                                 default = nil)
  if valid_594445 != nil:
    section.add "userIp", valid_594445
  var valid_594446 = query.getOrDefault("key")
  valid_594446 = validateParameter(valid_594446, JString, required = false,
                                 default = nil)
  if valid_594446 != nil:
    section.add "key", valid_594446
  var valid_594447 = query.getOrDefault("prettyPrint")
  valid_594447 = validateParameter(valid_594447, JBool, required = false,
                                 default = newJBool(true))
  if valid_594447 != nil:
    section.add "prettyPrint", valid_594447
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

proc call*(call_594449: Call_ContentDatafeedsUpdate_594436; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a datafeed configuration of your Merchant Center account.
  ## 
  let valid = call_594449.validator(path, query, header, formData, body)
  let scheme = call_594449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594449.url(scheme.get, call_594449.host, call_594449.base,
                         call_594449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594449, url, valid)

proc call*(call_594450: Call_ContentDatafeedsUpdate_594436; merchantId: string;
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
  var path_594451 = newJObject()
  var query_594452 = newJObject()
  var body_594453 = newJObject()
  add(query_594452, "fields", newJString(fields))
  add(query_594452, "quotaUser", newJString(quotaUser))
  add(query_594452, "alt", newJString(alt))
  add(query_594452, "oauth_token", newJString(oauthToken))
  add(query_594452, "userIp", newJString(userIp))
  add(query_594452, "key", newJString(key))
  add(path_594451, "merchantId", newJString(merchantId))
  if body != nil:
    body_594453 = body
  add(query_594452, "prettyPrint", newJBool(prettyPrint))
  add(path_594451, "datafeedId", newJString(datafeedId))
  result = call_594450.call(path_594451, query_594452, nil, nil, body_594453)

var contentDatafeedsUpdate* = Call_ContentDatafeedsUpdate_594436(
    name: "contentDatafeedsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsUpdate_594437, base: "/content/v2.1",
    url: url_ContentDatafeedsUpdate_594438, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsGet_594420 = ref object of OpenApiRestCall_593421
proc url_ContentDatafeedsGet_594422(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentDatafeedsGet_594421(path: JsonNode; query: JsonNode;
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
  var valid_594423 = path.getOrDefault("merchantId")
  valid_594423 = validateParameter(valid_594423, JString, required = true,
                                 default = nil)
  if valid_594423 != nil:
    section.add "merchantId", valid_594423
  var valid_594424 = path.getOrDefault("datafeedId")
  valid_594424 = validateParameter(valid_594424, JString, required = true,
                                 default = nil)
  if valid_594424 != nil:
    section.add "datafeedId", valid_594424
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
  var valid_594425 = query.getOrDefault("fields")
  valid_594425 = validateParameter(valid_594425, JString, required = false,
                                 default = nil)
  if valid_594425 != nil:
    section.add "fields", valid_594425
  var valid_594426 = query.getOrDefault("quotaUser")
  valid_594426 = validateParameter(valid_594426, JString, required = false,
                                 default = nil)
  if valid_594426 != nil:
    section.add "quotaUser", valid_594426
  var valid_594427 = query.getOrDefault("alt")
  valid_594427 = validateParameter(valid_594427, JString, required = false,
                                 default = newJString("json"))
  if valid_594427 != nil:
    section.add "alt", valid_594427
  var valid_594428 = query.getOrDefault("oauth_token")
  valid_594428 = validateParameter(valid_594428, JString, required = false,
                                 default = nil)
  if valid_594428 != nil:
    section.add "oauth_token", valid_594428
  var valid_594429 = query.getOrDefault("userIp")
  valid_594429 = validateParameter(valid_594429, JString, required = false,
                                 default = nil)
  if valid_594429 != nil:
    section.add "userIp", valid_594429
  var valid_594430 = query.getOrDefault("key")
  valid_594430 = validateParameter(valid_594430, JString, required = false,
                                 default = nil)
  if valid_594430 != nil:
    section.add "key", valid_594430
  var valid_594431 = query.getOrDefault("prettyPrint")
  valid_594431 = validateParameter(valid_594431, JBool, required = false,
                                 default = newJBool(true))
  if valid_594431 != nil:
    section.add "prettyPrint", valid_594431
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594432: Call_ContentDatafeedsGet_594420; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a datafeed configuration from your Merchant Center account.
  ## 
  let valid = call_594432.validator(path, query, header, formData, body)
  let scheme = call_594432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594432.url(scheme.get, call_594432.host, call_594432.base,
                         call_594432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594432, url, valid)

proc call*(call_594433: Call_ContentDatafeedsGet_594420; merchantId: string;
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
  var path_594434 = newJObject()
  var query_594435 = newJObject()
  add(query_594435, "fields", newJString(fields))
  add(query_594435, "quotaUser", newJString(quotaUser))
  add(query_594435, "alt", newJString(alt))
  add(query_594435, "oauth_token", newJString(oauthToken))
  add(query_594435, "userIp", newJString(userIp))
  add(query_594435, "key", newJString(key))
  add(path_594434, "merchantId", newJString(merchantId))
  add(query_594435, "prettyPrint", newJBool(prettyPrint))
  add(path_594434, "datafeedId", newJString(datafeedId))
  result = call_594433.call(path_594434, query_594435, nil, nil, nil)

var contentDatafeedsGet* = Call_ContentDatafeedsGet_594420(
    name: "contentDatafeedsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsGet_594421, base: "/content/v2.1",
    url: url_ContentDatafeedsGet_594422, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsDelete_594454 = ref object of OpenApiRestCall_593421
proc url_ContentDatafeedsDelete_594456(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentDatafeedsDelete_594455(path: JsonNode; query: JsonNode;
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
  var valid_594457 = path.getOrDefault("merchantId")
  valid_594457 = validateParameter(valid_594457, JString, required = true,
                                 default = nil)
  if valid_594457 != nil:
    section.add "merchantId", valid_594457
  var valid_594458 = path.getOrDefault("datafeedId")
  valid_594458 = validateParameter(valid_594458, JString, required = true,
                                 default = nil)
  if valid_594458 != nil:
    section.add "datafeedId", valid_594458
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
  var valid_594459 = query.getOrDefault("fields")
  valid_594459 = validateParameter(valid_594459, JString, required = false,
                                 default = nil)
  if valid_594459 != nil:
    section.add "fields", valid_594459
  var valid_594460 = query.getOrDefault("quotaUser")
  valid_594460 = validateParameter(valid_594460, JString, required = false,
                                 default = nil)
  if valid_594460 != nil:
    section.add "quotaUser", valid_594460
  var valid_594461 = query.getOrDefault("alt")
  valid_594461 = validateParameter(valid_594461, JString, required = false,
                                 default = newJString("json"))
  if valid_594461 != nil:
    section.add "alt", valid_594461
  var valid_594462 = query.getOrDefault("oauth_token")
  valid_594462 = validateParameter(valid_594462, JString, required = false,
                                 default = nil)
  if valid_594462 != nil:
    section.add "oauth_token", valid_594462
  var valid_594463 = query.getOrDefault("userIp")
  valid_594463 = validateParameter(valid_594463, JString, required = false,
                                 default = nil)
  if valid_594463 != nil:
    section.add "userIp", valid_594463
  var valid_594464 = query.getOrDefault("key")
  valid_594464 = validateParameter(valid_594464, JString, required = false,
                                 default = nil)
  if valid_594464 != nil:
    section.add "key", valid_594464
  var valid_594465 = query.getOrDefault("prettyPrint")
  valid_594465 = validateParameter(valid_594465, JBool, required = false,
                                 default = newJBool(true))
  if valid_594465 != nil:
    section.add "prettyPrint", valid_594465
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594466: Call_ContentDatafeedsDelete_594454; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a datafeed configuration from your Merchant Center account.
  ## 
  let valid = call_594466.validator(path, query, header, formData, body)
  let scheme = call_594466.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594466.url(scheme.get, call_594466.host, call_594466.base,
                         call_594466.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594466, url, valid)

proc call*(call_594467: Call_ContentDatafeedsDelete_594454; merchantId: string;
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
  var path_594468 = newJObject()
  var query_594469 = newJObject()
  add(query_594469, "fields", newJString(fields))
  add(query_594469, "quotaUser", newJString(quotaUser))
  add(query_594469, "alt", newJString(alt))
  add(query_594469, "oauth_token", newJString(oauthToken))
  add(query_594469, "userIp", newJString(userIp))
  add(query_594469, "key", newJString(key))
  add(path_594468, "merchantId", newJString(merchantId))
  add(query_594469, "prettyPrint", newJBool(prettyPrint))
  add(path_594468, "datafeedId", newJString(datafeedId))
  result = call_594467.call(path_594468, query_594469, nil, nil, nil)

var contentDatafeedsDelete* = Call_ContentDatafeedsDelete_594454(
    name: "contentDatafeedsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsDelete_594455, base: "/content/v2.1",
    url: url_ContentDatafeedsDelete_594456, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsFetchnow_594470 = ref object of OpenApiRestCall_593421
proc url_ContentDatafeedsFetchnow_594472(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentDatafeedsFetchnow_594471(path: JsonNode; query: JsonNode;
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
  var valid_594473 = path.getOrDefault("merchantId")
  valid_594473 = validateParameter(valid_594473, JString, required = true,
                                 default = nil)
  if valid_594473 != nil:
    section.add "merchantId", valid_594473
  var valid_594474 = path.getOrDefault("datafeedId")
  valid_594474 = validateParameter(valid_594474, JString, required = true,
                                 default = nil)
  if valid_594474 != nil:
    section.add "datafeedId", valid_594474
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
  var valid_594475 = query.getOrDefault("fields")
  valid_594475 = validateParameter(valid_594475, JString, required = false,
                                 default = nil)
  if valid_594475 != nil:
    section.add "fields", valid_594475
  var valid_594476 = query.getOrDefault("quotaUser")
  valid_594476 = validateParameter(valid_594476, JString, required = false,
                                 default = nil)
  if valid_594476 != nil:
    section.add "quotaUser", valid_594476
  var valid_594477 = query.getOrDefault("alt")
  valid_594477 = validateParameter(valid_594477, JString, required = false,
                                 default = newJString("json"))
  if valid_594477 != nil:
    section.add "alt", valid_594477
  var valid_594478 = query.getOrDefault("oauth_token")
  valid_594478 = validateParameter(valid_594478, JString, required = false,
                                 default = nil)
  if valid_594478 != nil:
    section.add "oauth_token", valid_594478
  var valid_594479 = query.getOrDefault("userIp")
  valid_594479 = validateParameter(valid_594479, JString, required = false,
                                 default = nil)
  if valid_594479 != nil:
    section.add "userIp", valid_594479
  var valid_594480 = query.getOrDefault("key")
  valid_594480 = validateParameter(valid_594480, JString, required = false,
                                 default = nil)
  if valid_594480 != nil:
    section.add "key", valid_594480
  var valid_594481 = query.getOrDefault("prettyPrint")
  valid_594481 = validateParameter(valid_594481, JBool, required = false,
                                 default = newJBool(true))
  if valid_594481 != nil:
    section.add "prettyPrint", valid_594481
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594482: Call_ContentDatafeedsFetchnow_594470; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Invokes a fetch for the datafeed in your Merchant Center account.
  ## 
  let valid = call_594482.validator(path, query, header, formData, body)
  let scheme = call_594482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594482.url(scheme.get, call_594482.host, call_594482.base,
                         call_594482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594482, url, valid)

proc call*(call_594483: Call_ContentDatafeedsFetchnow_594470; merchantId: string;
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
  var path_594484 = newJObject()
  var query_594485 = newJObject()
  add(query_594485, "fields", newJString(fields))
  add(query_594485, "quotaUser", newJString(quotaUser))
  add(query_594485, "alt", newJString(alt))
  add(query_594485, "oauth_token", newJString(oauthToken))
  add(query_594485, "userIp", newJString(userIp))
  add(query_594485, "key", newJString(key))
  add(path_594484, "merchantId", newJString(merchantId))
  add(query_594485, "prettyPrint", newJBool(prettyPrint))
  add(path_594484, "datafeedId", newJString(datafeedId))
  result = call_594483.call(path_594484, query_594485, nil, nil, nil)

var contentDatafeedsFetchnow* = Call_ContentDatafeedsFetchnow_594470(
    name: "contentDatafeedsFetchnow", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/datafeeds/{datafeedId}/fetchNow",
    validator: validate_ContentDatafeedsFetchnow_594471, base: "/content/v2.1",
    url: url_ContentDatafeedsFetchnow_594472, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesList_594486 = ref object of OpenApiRestCall_593421
proc url_ContentDatafeedstatusesList_594488(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentDatafeedstatusesList_594487(path: JsonNode; query: JsonNode;
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
  var valid_594489 = path.getOrDefault("merchantId")
  valid_594489 = validateParameter(valid_594489, JString, required = true,
                                 default = nil)
  if valid_594489 != nil:
    section.add "merchantId", valid_594489
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
  var valid_594490 = query.getOrDefault("fields")
  valid_594490 = validateParameter(valid_594490, JString, required = false,
                                 default = nil)
  if valid_594490 != nil:
    section.add "fields", valid_594490
  var valid_594491 = query.getOrDefault("pageToken")
  valid_594491 = validateParameter(valid_594491, JString, required = false,
                                 default = nil)
  if valid_594491 != nil:
    section.add "pageToken", valid_594491
  var valid_594492 = query.getOrDefault("quotaUser")
  valid_594492 = validateParameter(valid_594492, JString, required = false,
                                 default = nil)
  if valid_594492 != nil:
    section.add "quotaUser", valid_594492
  var valid_594493 = query.getOrDefault("alt")
  valid_594493 = validateParameter(valid_594493, JString, required = false,
                                 default = newJString("json"))
  if valid_594493 != nil:
    section.add "alt", valid_594493
  var valid_594494 = query.getOrDefault("oauth_token")
  valid_594494 = validateParameter(valid_594494, JString, required = false,
                                 default = nil)
  if valid_594494 != nil:
    section.add "oauth_token", valid_594494
  var valid_594495 = query.getOrDefault("userIp")
  valid_594495 = validateParameter(valid_594495, JString, required = false,
                                 default = nil)
  if valid_594495 != nil:
    section.add "userIp", valid_594495
  var valid_594496 = query.getOrDefault("maxResults")
  valid_594496 = validateParameter(valid_594496, JInt, required = false, default = nil)
  if valid_594496 != nil:
    section.add "maxResults", valid_594496
  var valid_594497 = query.getOrDefault("key")
  valid_594497 = validateParameter(valid_594497, JString, required = false,
                                 default = nil)
  if valid_594497 != nil:
    section.add "key", valid_594497
  var valid_594498 = query.getOrDefault("prettyPrint")
  valid_594498 = validateParameter(valid_594498, JBool, required = false,
                                 default = newJBool(true))
  if valid_594498 != nil:
    section.add "prettyPrint", valid_594498
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594499: Call_ContentDatafeedstatusesList_594486; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the datafeeds in your Merchant Center account.
  ## 
  let valid = call_594499.validator(path, query, header, formData, body)
  let scheme = call_594499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594499.url(scheme.get, call_594499.host, call_594499.base,
                         call_594499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594499, url, valid)

proc call*(call_594500: Call_ContentDatafeedstatusesList_594486;
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
  var path_594501 = newJObject()
  var query_594502 = newJObject()
  add(query_594502, "fields", newJString(fields))
  add(query_594502, "pageToken", newJString(pageToken))
  add(query_594502, "quotaUser", newJString(quotaUser))
  add(query_594502, "alt", newJString(alt))
  add(query_594502, "oauth_token", newJString(oauthToken))
  add(query_594502, "userIp", newJString(userIp))
  add(query_594502, "maxResults", newJInt(maxResults))
  add(query_594502, "key", newJString(key))
  add(path_594501, "merchantId", newJString(merchantId))
  add(query_594502, "prettyPrint", newJBool(prettyPrint))
  result = call_594500.call(path_594501, query_594502, nil, nil, nil)

var contentDatafeedstatusesList* = Call_ContentDatafeedstatusesList_594486(
    name: "contentDatafeedstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeedstatuses",
    validator: validate_ContentDatafeedstatusesList_594487, base: "/content/v2.1",
    url: url_ContentDatafeedstatusesList_594488, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesGet_594503 = ref object of OpenApiRestCall_593421
proc url_ContentDatafeedstatusesGet_594505(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentDatafeedstatusesGet_594504(path: JsonNode; query: JsonNode;
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
  var valid_594506 = path.getOrDefault("merchantId")
  valid_594506 = validateParameter(valid_594506, JString, required = true,
                                 default = nil)
  if valid_594506 != nil:
    section.add "merchantId", valid_594506
  var valid_594507 = path.getOrDefault("datafeedId")
  valid_594507 = validateParameter(valid_594507, JString, required = true,
                                 default = nil)
  if valid_594507 != nil:
    section.add "datafeedId", valid_594507
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
  var valid_594508 = query.getOrDefault("fields")
  valid_594508 = validateParameter(valid_594508, JString, required = false,
                                 default = nil)
  if valid_594508 != nil:
    section.add "fields", valid_594508
  var valid_594509 = query.getOrDefault("country")
  valid_594509 = validateParameter(valid_594509, JString, required = false,
                                 default = nil)
  if valid_594509 != nil:
    section.add "country", valid_594509
  var valid_594510 = query.getOrDefault("quotaUser")
  valid_594510 = validateParameter(valid_594510, JString, required = false,
                                 default = nil)
  if valid_594510 != nil:
    section.add "quotaUser", valid_594510
  var valid_594511 = query.getOrDefault("alt")
  valid_594511 = validateParameter(valid_594511, JString, required = false,
                                 default = newJString("json"))
  if valid_594511 != nil:
    section.add "alt", valid_594511
  var valid_594512 = query.getOrDefault("language")
  valid_594512 = validateParameter(valid_594512, JString, required = false,
                                 default = nil)
  if valid_594512 != nil:
    section.add "language", valid_594512
  var valid_594513 = query.getOrDefault("oauth_token")
  valid_594513 = validateParameter(valid_594513, JString, required = false,
                                 default = nil)
  if valid_594513 != nil:
    section.add "oauth_token", valid_594513
  var valid_594514 = query.getOrDefault("userIp")
  valid_594514 = validateParameter(valid_594514, JString, required = false,
                                 default = nil)
  if valid_594514 != nil:
    section.add "userIp", valid_594514
  var valid_594515 = query.getOrDefault("key")
  valid_594515 = validateParameter(valid_594515, JString, required = false,
                                 default = nil)
  if valid_594515 != nil:
    section.add "key", valid_594515
  var valid_594516 = query.getOrDefault("prettyPrint")
  valid_594516 = validateParameter(valid_594516, JBool, required = false,
                                 default = newJBool(true))
  if valid_594516 != nil:
    section.add "prettyPrint", valid_594516
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594517: Call_ContentDatafeedstatusesGet_594503; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the status of a datafeed from your Merchant Center account.
  ## 
  let valid = call_594517.validator(path, query, header, formData, body)
  let scheme = call_594517.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594517.url(scheme.get, call_594517.host, call_594517.base,
                         call_594517.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594517, url, valid)

proc call*(call_594518: Call_ContentDatafeedstatusesGet_594503; merchantId: string;
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
  var path_594519 = newJObject()
  var query_594520 = newJObject()
  add(query_594520, "fields", newJString(fields))
  add(query_594520, "country", newJString(country))
  add(query_594520, "quotaUser", newJString(quotaUser))
  add(query_594520, "alt", newJString(alt))
  add(query_594520, "language", newJString(language))
  add(query_594520, "oauth_token", newJString(oauthToken))
  add(query_594520, "userIp", newJString(userIp))
  add(query_594520, "key", newJString(key))
  add(path_594519, "merchantId", newJString(merchantId))
  add(query_594520, "prettyPrint", newJBool(prettyPrint))
  add(path_594519, "datafeedId", newJString(datafeedId))
  result = call_594518.call(path_594519, query_594520, nil, nil, nil)

var contentDatafeedstatusesGet* = Call_ContentDatafeedstatusesGet_594503(
    name: "contentDatafeedstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/datafeedstatuses/{datafeedId}",
    validator: validate_ContentDatafeedstatusesGet_594504, base: "/content/v2.1",
    url: url_ContentDatafeedstatusesGet_594505, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsList_594521 = ref object of OpenApiRestCall_593421
proc url_ContentLiasettingsList_594523(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentLiasettingsList_594522(path: JsonNode; query: JsonNode;
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
  var valid_594524 = path.getOrDefault("merchantId")
  valid_594524 = validateParameter(valid_594524, JString, required = true,
                                 default = nil)
  if valid_594524 != nil:
    section.add "merchantId", valid_594524
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
  var valid_594525 = query.getOrDefault("fields")
  valid_594525 = validateParameter(valid_594525, JString, required = false,
                                 default = nil)
  if valid_594525 != nil:
    section.add "fields", valid_594525
  var valid_594526 = query.getOrDefault("pageToken")
  valid_594526 = validateParameter(valid_594526, JString, required = false,
                                 default = nil)
  if valid_594526 != nil:
    section.add "pageToken", valid_594526
  var valid_594527 = query.getOrDefault("quotaUser")
  valid_594527 = validateParameter(valid_594527, JString, required = false,
                                 default = nil)
  if valid_594527 != nil:
    section.add "quotaUser", valid_594527
  var valid_594528 = query.getOrDefault("alt")
  valid_594528 = validateParameter(valid_594528, JString, required = false,
                                 default = newJString("json"))
  if valid_594528 != nil:
    section.add "alt", valid_594528
  var valid_594529 = query.getOrDefault("oauth_token")
  valid_594529 = validateParameter(valid_594529, JString, required = false,
                                 default = nil)
  if valid_594529 != nil:
    section.add "oauth_token", valid_594529
  var valid_594530 = query.getOrDefault("userIp")
  valid_594530 = validateParameter(valid_594530, JString, required = false,
                                 default = nil)
  if valid_594530 != nil:
    section.add "userIp", valid_594530
  var valid_594531 = query.getOrDefault("maxResults")
  valid_594531 = validateParameter(valid_594531, JInt, required = false, default = nil)
  if valid_594531 != nil:
    section.add "maxResults", valid_594531
  var valid_594532 = query.getOrDefault("key")
  valid_594532 = validateParameter(valid_594532, JString, required = false,
                                 default = nil)
  if valid_594532 != nil:
    section.add "key", valid_594532
  var valid_594533 = query.getOrDefault("prettyPrint")
  valid_594533 = validateParameter(valid_594533, JBool, required = false,
                                 default = newJBool(true))
  if valid_594533 != nil:
    section.add "prettyPrint", valid_594533
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594534: Call_ContentLiasettingsList_594521; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the LIA settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_594534.validator(path, query, header, formData, body)
  let scheme = call_594534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594534.url(scheme.get, call_594534.host, call_594534.base,
                         call_594534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594534, url, valid)

proc call*(call_594535: Call_ContentLiasettingsList_594521; merchantId: string;
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
  var path_594536 = newJObject()
  var query_594537 = newJObject()
  add(query_594537, "fields", newJString(fields))
  add(query_594537, "pageToken", newJString(pageToken))
  add(query_594537, "quotaUser", newJString(quotaUser))
  add(query_594537, "alt", newJString(alt))
  add(query_594537, "oauth_token", newJString(oauthToken))
  add(query_594537, "userIp", newJString(userIp))
  add(query_594537, "maxResults", newJInt(maxResults))
  add(query_594537, "key", newJString(key))
  add(path_594536, "merchantId", newJString(merchantId))
  add(query_594537, "prettyPrint", newJBool(prettyPrint))
  result = call_594535.call(path_594536, query_594537, nil, nil, nil)

var contentLiasettingsList* = Call_ContentLiasettingsList_594521(
    name: "contentLiasettingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings",
    validator: validate_ContentLiasettingsList_594522, base: "/content/v2.1",
    url: url_ContentLiasettingsList_594523, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsUpdate_594554 = ref object of OpenApiRestCall_593421
proc url_ContentLiasettingsUpdate_594556(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentLiasettingsUpdate_594555(path: JsonNode; query: JsonNode;
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
  var valid_594557 = path.getOrDefault("accountId")
  valid_594557 = validateParameter(valid_594557, JString, required = true,
                                 default = nil)
  if valid_594557 != nil:
    section.add "accountId", valid_594557
  var valid_594558 = path.getOrDefault("merchantId")
  valid_594558 = validateParameter(valid_594558, JString, required = true,
                                 default = nil)
  if valid_594558 != nil:
    section.add "merchantId", valid_594558
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
  var valid_594559 = query.getOrDefault("fields")
  valid_594559 = validateParameter(valid_594559, JString, required = false,
                                 default = nil)
  if valid_594559 != nil:
    section.add "fields", valid_594559
  var valid_594560 = query.getOrDefault("quotaUser")
  valid_594560 = validateParameter(valid_594560, JString, required = false,
                                 default = nil)
  if valid_594560 != nil:
    section.add "quotaUser", valid_594560
  var valid_594561 = query.getOrDefault("alt")
  valid_594561 = validateParameter(valid_594561, JString, required = false,
                                 default = newJString("json"))
  if valid_594561 != nil:
    section.add "alt", valid_594561
  var valid_594562 = query.getOrDefault("oauth_token")
  valid_594562 = validateParameter(valid_594562, JString, required = false,
                                 default = nil)
  if valid_594562 != nil:
    section.add "oauth_token", valid_594562
  var valid_594563 = query.getOrDefault("userIp")
  valid_594563 = validateParameter(valid_594563, JString, required = false,
                                 default = nil)
  if valid_594563 != nil:
    section.add "userIp", valid_594563
  var valid_594564 = query.getOrDefault("key")
  valid_594564 = validateParameter(valid_594564, JString, required = false,
                                 default = nil)
  if valid_594564 != nil:
    section.add "key", valid_594564
  var valid_594565 = query.getOrDefault("prettyPrint")
  valid_594565 = validateParameter(valid_594565, JBool, required = false,
                                 default = newJBool(true))
  if valid_594565 != nil:
    section.add "prettyPrint", valid_594565
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

proc call*(call_594567: Call_ContentLiasettingsUpdate_594554; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the LIA settings of the account.
  ## 
  let valid = call_594567.validator(path, query, header, formData, body)
  let scheme = call_594567.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594567.url(scheme.get, call_594567.host, call_594567.base,
                         call_594567.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594567, url, valid)

proc call*(call_594568: Call_ContentLiasettingsUpdate_594554; accountId: string;
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
  var path_594569 = newJObject()
  var query_594570 = newJObject()
  var body_594571 = newJObject()
  add(query_594570, "fields", newJString(fields))
  add(query_594570, "quotaUser", newJString(quotaUser))
  add(query_594570, "alt", newJString(alt))
  add(query_594570, "oauth_token", newJString(oauthToken))
  add(path_594569, "accountId", newJString(accountId))
  add(query_594570, "userIp", newJString(userIp))
  add(query_594570, "key", newJString(key))
  add(path_594569, "merchantId", newJString(merchantId))
  if body != nil:
    body_594571 = body
  add(query_594570, "prettyPrint", newJBool(prettyPrint))
  result = call_594568.call(path_594569, query_594570, nil, nil, body_594571)

var contentLiasettingsUpdate* = Call_ContentLiasettingsUpdate_594554(
    name: "contentLiasettingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}",
    validator: validate_ContentLiasettingsUpdate_594555, base: "/content/v2.1",
    url: url_ContentLiasettingsUpdate_594556, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsGet_594538 = ref object of OpenApiRestCall_593421
proc url_ContentLiasettingsGet_594540(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentLiasettingsGet_594539(path: JsonNode; query: JsonNode;
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
  var valid_594541 = path.getOrDefault("accountId")
  valid_594541 = validateParameter(valid_594541, JString, required = true,
                                 default = nil)
  if valid_594541 != nil:
    section.add "accountId", valid_594541
  var valid_594542 = path.getOrDefault("merchantId")
  valid_594542 = validateParameter(valid_594542, JString, required = true,
                                 default = nil)
  if valid_594542 != nil:
    section.add "merchantId", valid_594542
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
  var valid_594543 = query.getOrDefault("fields")
  valid_594543 = validateParameter(valid_594543, JString, required = false,
                                 default = nil)
  if valid_594543 != nil:
    section.add "fields", valid_594543
  var valid_594544 = query.getOrDefault("quotaUser")
  valid_594544 = validateParameter(valid_594544, JString, required = false,
                                 default = nil)
  if valid_594544 != nil:
    section.add "quotaUser", valid_594544
  var valid_594545 = query.getOrDefault("alt")
  valid_594545 = validateParameter(valid_594545, JString, required = false,
                                 default = newJString("json"))
  if valid_594545 != nil:
    section.add "alt", valid_594545
  var valid_594546 = query.getOrDefault("oauth_token")
  valid_594546 = validateParameter(valid_594546, JString, required = false,
                                 default = nil)
  if valid_594546 != nil:
    section.add "oauth_token", valid_594546
  var valid_594547 = query.getOrDefault("userIp")
  valid_594547 = validateParameter(valid_594547, JString, required = false,
                                 default = nil)
  if valid_594547 != nil:
    section.add "userIp", valid_594547
  var valid_594548 = query.getOrDefault("key")
  valid_594548 = validateParameter(valid_594548, JString, required = false,
                                 default = nil)
  if valid_594548 != nil:
    section.add "key", valid_594548
  var valid_594549 = query.getOrDefault("prettyPrint")
  valid_594549 = validateParameter(valid_594549, JBool, required = false,
                                 default = newJBool(true))
  if valid_594549 != nil:
    section.add "prettyPrint", valid_594549
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594550: Call_ContentLiasettingsGet_594538; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the LIA settings of the account.
  ## 
  let valid = call_594550.validator(path, query, header, formData, body)
  let scheme = call_594550.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594550.url(scheme.get, call_594550.host, call_594550.base,
                         call_594550.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594550, url, valid)

proc call*(call_594551: Call_ContentLiasettingsGet_594538; accountId: string;
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
  var path_594552 = newJObject()
  var query_594553 = newJObject()
  add(query_594553, "fields", newJString(fields))
  add(query_594553, "quotaUser", newJString(quotaUser))
  add(query_594553, "alt", newJString(alt))
  add(query_594553, "oauth_token", newJString(oauthToken))
  add(path_594552, "accountId", newJString(accountId))
  add(query_594553, "userIp", newJString(userIp))
  add(query_594553, "key", newJString(key))
  add(path_594552, "merchantId", newJString(merchantId))
  add(query_594553, "prettyPrint", newJBool(prettyPrint))
  result = call_594551.call(path_594552, query_594553, nil, nil, nil)

var contentLiasettingsGet* = Call_ContentLiasettingsGet_594538(
    name: "contentLiasettingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}",
    validator: validate_ContentLiasettingsGet_594539, base: "/content/v2.1",
    url: url_ContentLiasettingsGet_594540, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsGetaccessiblegmbaccounts_594572 = ref object of OpenApiRestCall_593421
proc url_ContentLiasettingsGetaccessiblegmbaccounts_594574(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentLiasettingsGetaccessiblegmbaccounts_594573(path: JsonNode;
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
  var valid_594575 = path.getOrDefault("accountId")
  valid_594575 = validateParameter(valid_594575, JString, required = true,
                                 default = nil)
  if valid_594575 != nil:
    section.add "accountId", valid_594575
  var valid_594576 = path.getOrDefault("merchantId")
  valid_594576 = validateParameter(valid_594576, JString, required = true,
                                 default = nil)
  if valid_594576 != nil:
    section.add "merchantId", valid_594576
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
  var valid_594577 = query.getOrDefault("fields")
  valid_594577 = validateParameter(valid_594577, JString, required = false,
                                 default = nil)
  if valid_594577 != nil:
    section.add "fields", valid_594577
  var valid_594578 = query.getOrDefault("quotaUser")
  valid_594578 = validateParameter(valid_594578, JString, required = false,
                                 default = nil)
  if valid_594578 != nil:
    section.add "quotaUser", valid_594578
  var valid_594579 = query.getOrDefault("alt")
  valid_594579 = validateParameter(valid_594579, JString, required = false,
                                 default = newJString("json"))
  if valid_594579 != nil:
    section.add "alt", valid_594579
  var valid_594580 = query.getOrDefault("oauth_token")
  valid_594580 = validateParameter(valid_594580, JString, required = false,
                                 default = nil)
  if valid_594580 != nil:
    section.add "oauth_token", valid_594580
  var valid_594581 = query.getOrDefault("userIp")
  valid_594581 = validateParameter(valid_594581, JString, required = false,
                                 default = nil)
  if valid_594581 != nil:
    section.add "userIp", valid_594581
  var valid_594582 = query.getOrDefault("key")
  valid_594582 = validateParameter(valid_594582, JString, required = false,
                                 default = nil)
  if valid_594582 != nil:
    section.add "key", valid_594582
  var valid_594583 = query.getOrDefault("prettyPrint")
  valid_594583 = validateParameter(valid_594583, JBool, required = false,
                                 default = newJBool(true))
  if valid_594583 != nil:
    section.add "prettyPrint", valid_594583
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594584: Call_ContentLiasettingsGetaccessiblegmbaccounts_594572;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of accessible Google My Business accounts.
  ## 
  let valid = call_594584.validator(path, query, header, formData, body)
  let scheme = call_594584.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594584.url(scheme.get, call_594584.host, call_594584.base,
                         call_594584.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594584, url, valid)

proc call*(call_594585: Call_ContentLiasettingsGetaccessiblegmbaccounts_594572;
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
  var path_594586 = newJObject()
  var query_594587 = newJObject()
  add(query_594587, "fields", newJString(fields))
  add(query_594587, "quotaUser", newJString(quotaUser))
  add(query_594587, "alt", newJString(alt))
  add(query_594587, "oauth_token", newJString(oauthToken))
  add(path_594586, "accountId", newJString(accountId))
  add(query_594587, "userIp", newJString(userIp))
  add(query_594587, "key", newJString(key))
  add(path_594586, "merchantId", newJString(merchantId))
  add(query_594587, "prettyPrint", newJBool(prettyPrint))
  result = call_594585.call(path_594586, query_594587, nil, nil, nil)

var contentLiasettingsGetaccessiblegmbaccounts* = Call_ContentLiasettingsGetaccessiblegmbaccounts_594572(
    name: "contentLiasettingsGetaccessiblegmbaccounts", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/accessiblegmbaccounts",
    validator: validate_ContentLiasettingsGetaccessiblegmbaccounts_594573,
    base: "/content/v2.1", url: url_ContentLiasettingsGetaccessiblegmbaccounts_594574,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsRequestgmbaccess_594588 = ref object of OpenApiRestCall_593421
proc url_ContentLiasettingsRequestgmbaccess_594590(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentLiasettingsRequestgmbaccess_594589(path: JsonNode;
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
  var valid_594591 = path.getOrDefault("accountId")
  valid_594591 = validateParameter(valid_594591, JString, required = true,
                                 default = nil)
  if valid_594591 != nil:
    section.add "accountId", valid_594591
  var valid_594592 = path.getOrDefault("merchantId")
  valid_594592 = validateParameter(valid_594592, JString, required = true,
                                 default = nil)
  if valid_594592 != nil:
    section.add "merchantId", valid_594592
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
  var valid_594593 = query.getOrDefault("fields")
  valid_594593 = validateParameter(valid_594593, JString, required = false,
                                 default = nil)
  if valid_594593 != nil:
    section.add "fields", valid_594593
  var valid_594594 = query.getOrDefault("quotaUser")
  valid_594594 = validateParameter(valid_594594, JString, required = false,
                                 default = nil)
  if valid_594594 != nil:
    section.add "quotaUser", valid_594594
  var valid_594595 = query.getOrDefault("alt")
  valid_594595 = validateParameter(valid_594595, JString, required = false,
                                 default = newJString("json"))
  if valid_594595 != nil:
    section.add "alt", valid_594595
  var valid_594596 = query.getOrDefault("oauth_token")
  valid_594596 = validateParameter(valid_594596, JString, required = false,
                                 default = nil)
  if valid_594596 != nil:
    section.add "oauth_token", valid_594596
  var valid_594597 = query.getOrDefault("userIp")
  valid_594597 = validateParameter(valid_594597, JString, required = false,
                                 default = nil)
  if valid_594597 != nil:
    section.add "userIp", valid_594597
  var valid_594598 = query.getOrDefault("key")
  valid_594598 = validateParameter(valid_594598, JString, required = false,
                                 default = nil)
  if valid_594598 != nil:
    section.add "key", valid_594598
  assert query != nil,
        "query argument is necessary due to required `gmbEmail` field"
  var valid_594599 = query.getOrDefault("gmbEmail")
  valid_594599 = validateParameter(valid_594599, JString, required = true,
                                 default = nil)
  if valid_594599 != nil:
    section.add "gmbEmail", valid_594599
  var valid_594600 = query.getOrDefault("prettyPrint")
  valid_594600 = validateParameter(valid_594600, JBool, required = false,
                                 default = newJBool(true))
  if valid_594600 != nil:
    section.add "prettyPrint", valid_594600
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594601: Call_ContentLiasettingsRequestgmbaccess_594588;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests access to a specified Google My Business account.
  ## 
  let valid = call_594601.validator(path, query, header, formData, body)
  let scheme = call_594601.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594601.url(scheme.get, call_594601.host, call_594601.base,
                         call_594601.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594601, url, valid)

proc call*(call_594602: Call_ContentLiasettingsRequestgmbaccess_594588;
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
  var path_594603 = newJObject()
  var query_594604 = newJObject()
  add(query_594604, "fields", newJString(fields))
  add(query_594604, "quotaUser", newJString(quotaUser))
  add(query_594604, "alt", newJString(alt))
  add(query_594604, "oauth_token", newJString(oauthToken))
  add(path_594603, "accountId", newJString(accountId))
  add(query_594604, "userIp", newJString(userIp))
  add(query_594604, "key", newJString(key))
  add(query_594604, "gmbEmail", newJString(gmbEmail))
  add(path_594603, "merchantId", newJString(merchantId))
  add(query_594604, "prettyPrint", newJBool(prettyPrint))
  result = call_594602.call(path_594603, query_594604, nil, nil, nil)

var contentLiasettingsRequestgmbaccess* = Call_ContentLiasettingsRequestgmbaccess_594588(
    name: "contentLiasettingsRequestgmbaccess", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/requestgmbaccess",
    validator: validate_ContentLiasettingsRequestgmbaccess_594589,
    base: "/content/v2.1", url: url_ContentLiasettingsRequestgmbaccess_594590,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsRequestinventoryverification_594605 = ref object of OpenApiRestCall_593421
proc url_ContentLiasettingsRequestinventoryverification_594607(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentLiasettingsRequestinventoryverification_594606(
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
  var valid_594608 = path.getOrDefault("country")
  valid_594608 = validateParameter(valid_594608, JString, required = true,
                                 default = nil)
  if valid_594608 != nil:
    section.add "country", valid_594608
  var valid_594609 = path.getOrDefault("accountId")
  valid_594609 = validateParameter(valid_594609, JString, required = true,
                                 default = nil)
  if valid_594609 != nil:
    section.add "accountId", valid_594609
  var valid_594610 = path.getOrDefault("merchantId")
  valid_594610 = validateParameter(valid_594610, JString, required = true,
                                 default = nil)
  if valid_594610 != nil:
    section.add "merchantId", valid_594610
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
  var valid_594611 = query.getOrDefault("fields")
  valid_594611 = validateParameter(valid_594611, JString, required = false,
                                 default = nil)
  if valid_594611 != nil:
    section.add "fields", valid_594611
  var valid_594612 = query.getOrDefault("quotaUser")
  valid_594612 = validateParameter(valid_594612, JString, required = false,
                                 default = nil)
  if valid_594612 != nil:
    section.add "quotaUser", valid_594612
  var valid_594613 = query.getOrDefault("alt")
  valid_594613 = validateParameter(valid_594613, JString, required = false,
                                 default = newJString("json"))
  if valid_594613 != nil:
    section.add "alt", valid_594613
  var valid_594614 = query.getOrDefault("oauth_token")
  valid_594614 = validateParameter(valid_594614, JString, required = false,
                                 default = nil)
  if valid_594614 != nil:
    section.add "oauth_token", valid_594614
  var valid_594615 = query.getOrDefault("userIp")
  valid_594615 = validateParameter(valid_594615, JString, required = false,
                                 default = nil)
  if valid_594615 != nil:
    section.add "userIp", valid_594615
  var valid_594616 = query.getOrDefault("key")
  valid_594616 = validateParameter(valid_594616, JString, required = false,
                                 default = nil)
  if valid_594616 != nil:
    section.add "key", valid_594616
  var valid_594617 = query.getOrDefault("prettyPrint")
  valid_594617 = validateParameter(valid_594617, JBool, required = false,
                                 default = newJBool(true))
  if valid_594617 != nil:
    section.add "prettyPrint", valid_594617
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594618: Call_ContentLiasettingsRequestinventoryverification_594605;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests inventory validation for the specified country.
  ## 
  let valid = call_594618.validator(path, query, header, formData, body)
  let scheme = call_594618.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594618.url(scheme.get, call_594618.host, call_594618.base,
                         call_594618.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594618, url, valid)

proc call*(call_594619: Call_ContentLiasettingsRequestinventoryverification_594605;
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
  var path_594620 = newJObject()
  var query_594621 = newJObject()
  add(query_594621, "fields", newJString(fields))
  add(query_594621, "quotaUser", newJString(quotaUser))
  add(query_594621, "alt", newJString(alt))
  add(path_594620, "country", newJString(country))
  add(query_594621, "oauth_token", newJString(oauthToken))
  add(path_594620, "accountId", newJString(accountId))
  add(query_594621, "userIp", newJString(userIp))
  add(query_594621, "key", newJString(key))
  add(path_594620, "merchantId", newJString(merchantId))
  add(query_594621, "prettyPrint", newJBool(prettyPrint))
  result = call_594619.call(path_594620, query_594621, nil, nil, nil)

var contentLiasettingsRequestinventoryverification* = Call_ContentLiasettingsRequestinventoryverification_594605(
    name: "contentLiasettingsRequestinventoryverification",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}/requestinventoryverification/{country}",
    validator: validate_ContentLiasettingsRequestinventoryverification_594606,
    base: "/content/v2.1",
    url: url_ContentLiasettingsRequestinventoryverification_594607,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsSetinventoryverificationcontact_594622 = ref object of OpenApiRestCall_593421
proc url_ContentLiasettingsSetinventoryverificationcontact_594624(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentLiasettingsSetinventoryverificationcontact_594623(
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
  var valid_594625 = path.getOrDefault("accountId")
  valid_594625 = validateParameter(valid_594625, JString, required = true,
                                 default = nil)
  if valid_594625 != nil:
    section.add "accountId", valid_594625
  var valid_594626 = path.getOrDefault("merchantId")
  valid_594626 = validateParameter(valid_594626, JString, required = true,
                                 default = nil)
  if valid_594626 != nil:
    section.add "merchantId", valid_594626
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
  var valid_594627 = query.getOrDefault("fields")
  valid_594627 = validateParameter(valid_594627, JString, required = false,
                                 default = nil)
  if valid_594627 != nil:
    section.add "fields", valid_594627
  assert query != nil, "query argument is necessary due to required `country` field"
  var valid_594628 = query.getOrDefault("country")
  valid_594628 = validateParameter(valid_594628, JString, required = true,
                                 default = nil)
  if valid_594628 != nil:
    section.add "country", valid_594628
  var valid_594629 = query.getOrDefault("quotaUser")
  valid_594629 = validateParameter(valid_594629, JString, required = false,
                                 default = nil)
  if valid_594629 != nil:
    section.add "quotaUser", valid_594629
  var valid_594630 = query.getOrDefault("alt")
  valid_594630 = validateParameter(valid_594630, JString, required = false,
                                 default = newJString("json"))
  if valid_594630 != nil:
    section.add "alt", valid_594630
  var valid_594631 = query.getOrDefault("contactName")
  valid_594631 = validateParameter(valid_594631, JString, required = true,
                                 default = nil)
  if valid_594631 != nil:
    section.add "contactName", valid_594631
  var valid_594632 = query.getOrDefault("language")
  valid_594632 = validateParameter(valid_594632, JString, required = true,
                                 default = nil)
  if valid_594632 != nil:
    section.add "language", valid_594632
  var valid_594633 = query.getOrDefault("oauth_token")
  valid_594633 = validateParameter(valid_594633, JString, required = false,
                                 default = nil)
  if valid_594633 != nil:
    section.add "oauth_token", valid_594633
  var valid_594634 = query.getOrDefault("userIp")
  valid_594634 = validateParameter(valid_594634, JString, required = false,
                                 default = nil)
  if valid_594634 != nil:
    section.add "userIp", valid_594634
  var valid_594635 = query.getOrDefault("key")
  valid_594635 = validateParameter(valid_594635, JString, required = false,
                                 default = nil)
  if valid_594635 != nil:
    section.add "key", valid_594635
  var valid_594636 = query.getOrDefault("prettyPrint")
  valid_594636 = validateParameter(valid_594636, JBool, required = false,
                                 default = newJBool(true))
  if valid_594636 != nil:
    section.add "prettyPrint", valid_594636
  var valid_594637 = query.getOrDefault("contactEmail")
  valid_594637 = validateParameter(valid_594637, JString, required = true,
                                 default = nil)
  if valid_594637 != nil:
    section.add "contactEmail", valid_594637
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594638: Call_ContentLiasettingsSetinventoryverificationcontact_594622;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the inventory verification contract for the specified country.
  ## 
  let valid = call_594638.validator(path, query, header, formData, body)
  let scheme = call_594638.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594638.url(scheme.get, call_594638.host, call_594638.base,
                         call_594638.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594638, url, valid)

proc call*(call_594639: Call_ContentLiasettingsSetinventoryverificationcontact_594622;
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
  var path_594640 = newJObject()
  var query_594641 = newJObject()
  add(query_594641, "fields", newJString(fields))
  add(query_594641, "country", newJString(country))
  add(query_594641, "quotaUser", newJString(quotaUser))
  add(query_594641, "alt", newJString(alt))
  add(query_594641, "contactName", newJString(contactName))
  add(query_594641, "language", newJString(language))
  add(query_594641, "oauth_token", newJString(oauthToken))
  add(path_594640, "accountId", newJString(accountId))
  add(query_594641, "userIp", newJString(userIp))
  add(query_594641, "key", newJString(key))
  add(path_594640, "merchantId", newJString(merchantId))
  add(query_594641, "prettyPrint", newJBool(prettyPrint))
  add(query_594641, "contactEmail", newJString(contactEmail))
  result = call_594639.call(path_594640, query_594641, nil, nil, nil)

var contentLiasettingsSetinventoryverificationcontact* = Call_ContentLiasettingsSetinventoryverificationcontact_594622(
    name: "contentLiasettingsSetinventoryverificationcontact",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}/setinventoryverificationcontact",
    validator: validate_ContentLiasettingsSetinventoryverificationcontact_594623,
    base: "/content/v2.1",
    url: url_ContentLiasettingsSetinventoryverificationcontact_594624,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsSetposdataprovider_594642 = ref object of OpenApiRestCall_593421
proc url_ContentLiasettingsSetposdataprovider_594644(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentLiasettingsSetposdataprovider_594643(path: JsonNode;
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
  var valid_594645 = path.getOrDefault("accountId")
  valid_594645 = validateParameter(valid_594645, JString, required = true,
                                 default = nil)
  if valid_594645 != nil:
    section.add "accountId", valid_594645
  var valid_594646 = path.getOrDefault("merchantId")
  valid_594646 = validateParameter(valid_594646, JString, required = true,
                                 default = nil)
  if valid_594646 != nil:
    section.add "merchantId", valid_594646
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
  var valid_594647 = query.getOrDefault("fields")
  valid_594647 = validateParameter(valid_594647, JString, required = false,
                                 default = nil)
  if valid_594647 != nil:
    section.add "fields", valid_594647
  assert query != nil, "query argument is necessary due to required `country` field"
  var valid_594648 = query.getOrDefault("country")
  valid_594648 = validateParameter(valid_594648, JString, required = true,
                                 default = nil)
  if valid_594648 != nil:
    section.add "country", valid_594648
  var valid_594649 = query.getOrDefault("quotaUser")
  valid_594649 = validateParameter(valid_594649, JString, required = false,
                                 default = nil)
  if valid_594649 != nil:
    section.add "quotaUser", valid_594649
  var valid_594650 = query.getOrDefault("alt")
  valid_594650 = validateParameter(valid_594650, JString, required = false,
                                 default = newJString("json"))
  if valid_594650 != nil:
    section.add "alt", valid_594650
  var valid_594651 = query.getOrDefault("oauth_token")
  valid_594651 = validateParameter(valid_594651, JString, required = false,
                                 default = nil)
  if valid_594651 != nil:
    section.add "oauth_token", valid_594651
  var valid_594652 = query.getOrDefault("userIp")
  valid_594652 = validateParameter(valid_594652, JString, required = false,
                                 default = nil)
  if valid_594652 != nil:
    section.add "userIp", valid_594652
  var valid_594653 = query.getOrDefault("posExternalAccountId")
  valid_594653 = validateParameter(valid_594653, JString, required = false,
                                 default = nil)
  if valid_594653 != nil:
    section.add "posExternalAccountId", valid_594653
  var valid_594654 = query.getOrDefault("key")
  valid_594654 = validateParameter(valid_594654, JString, required = false,
                                 default = nil)
  if valid_594654 != nil:
    section.add "key", valid_594654
  var valid_594655 = query.getOrDefault("posDataProviderId")
  valid_594655 = validateParameter(valid_594655, JString, required = false,
                                 default = nil)
  if valid_594655 != nil:
    section.add "posDataProviderId", valid_594655
  var valid_594656 = query.getOrDefault("prettyPrint")
  valid_594656 = validateParameter(valid_594656, JBool, required = false,
                                 default = newJBool(true))
  if valid_594656 != nil:
    section.add "prettyPrint", valid_594656
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594657: Call_ContentLiasettingsSetposdataprovider_594642;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the POS data provider for the specified country.
  ## 
  let valid = call_594657.validator(path, query, header, formData, body)
  let scheme = call_594657.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594657.url(scheme.get, call_594657.host, call_594657.base,
                         call_594657.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594657, url, valid)

proc call*(call_594658: Call_ContentLiasettingsSetposdataprovider_594642;
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
  var path_594659 = newJObject()
  var query_594660 = newJObject()
  add(query_594660, "fields", newJString(fields))
  add(query_594660, "country", newJString(country))
  add(query_594660, "quotaUser", newJString(quotaUser))
  add(query_594660, "alt", newJString(alt))
  add(query_594660, "oauth_token", newJString(oauthToken))
  add(path_594659, "accountId", newJString(accountId))
  add(query_594660, "userIp", newJString(userIp))
  add(query_594660, "posExternalAccountId", newJString(posExternalAccountId))
  add(query_594660, "key", newJString(key))
  add(query_594660, "posDataProviderId", newJString(posDataProviderId))
  add(path_594659, "merchantId", newJString(merchantId))
  add(query_594660, "prettyPrint", newJBool(prettyPrint))
  result = call_594658.call(path_594659, query_594660, nil, nil, nil)

var contentLiasettingsSetposdataprovider* = Call_ContentLiasettingsSetposdataprovider_594642(
    name: "contentLiasettingsSetposdataprovider", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/setposdataprovider",
    validator: validate_ContentLiasettingsSetposdataprovider_594643,
    base: "/content/v2.1", url: url_ContentLiasettingsSetposdataprovider_594644,
    schemes: {Scheme.Https})
type
  Call_ContentOrderinvoicesCreatechargeinvoice_594661 = ref object of OpenApiRestCall_593421
proc url_ContentOrderinvoicesCreatechargeinvoice_594663(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentOrderinvoicesCreatechargeinvoice_594662(path: JsonNode;
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
  var valid_594664 = path.getOrDefault("orderId")
  valid_594664 = validateParameter(valid_594664, JString, required = true,
                                 default = nil)
  if valid_594664 != nil:
    section.add "orderId", valid_594664
  var valid_594665 = path.getOrDefault("merchantId")
  valid_594665 = validateParameter(valid_594665, JString, required = true,
                                 default = nil)
  if valid_594665 != nil:
    section.add "merchantId", valid_594665
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
  var valid_594666 = query.getOrDefault("fields")
  valid_594666 = validateParameter(valid_594666, JString, required = false,
                                 default = nil)
  if valid_594666 != nil:
    section.add "fields", valid_594666
  var valid_594667 = query.getOrDefault("quotaUser")
  valid_594667 = validateParameter(valid_594667, JString, required = false,
                                 default = nil)
  if valid_594667 != nil:
    section.add "quotaUser", valid_594667
  var valid_594668 = query.getOrDefault("alt")
  valid_594668 = validateParameter(valid_594668, JString, required = false,
                                 default = newJString("json"))
  if valid_594668 != nil:
    section.add "alt", valid_594668
  var valid_594669 = query.getOrDefault("oauth_token")
  valid_594669 = validateParameter(valid_594669, JString, required = false,
                                 default = nil)
  if valid_594669 != nil:
    section.add "oauth_token", valid_594669
  var valid_594670 = query.getOrDefault("userIp")
  valid_594670 = validateParameter(valid_594670, JString, required = false,
                                 default = nil)
  if valid_594670 != nil:
    section.add "userIp", valid_594670
  var valid_594671 = query.getOrDefault("key")
  valid_594671 = validateParameter(valid_594671, JString, required = false,
                                 default = nil)
  if valid_594671 != nil:
    section.add "key", valid_594671
  var valid_594672 = query.getOrDefault("prettyPrint")
  valid_594672 = validateParameter(valid_594672, JBool, required = false,
                                 default = newJBool(true))
  if valid_594672 != nil:
    section.add "prettyPrint", valid_594672
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

proc call*(call_594674: Call_ContentOrderinvoicesCreatechargeinvoice_594661;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a charge invoice for a shipment group, and triggers a charge capture for orderinvoice enabled orders.
  ## 
  let valid = call_594674.validator(path, query, header, formData, body)
  let scheme = call_594674.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594674.url(scheme.get, call_594674.host, call_594674.base,
                         call_594674.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594674, url, valid)

proc call*(call_594675: Call_ContentOrderinvoicesCreatechargeinvoice_594661;
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
  var path_594676 = newJObject()
  var query_594677 = newJObject()
  var body_594678 = newJObject()
  add(query_594677, "fields", newJString(fields))
  add(query_594677, "quotaUser", newJString(quotaUser))
  add(query_594677, "alt", newJString(alt))
  add(query_594677, "oauth_token", newJString(oauthToken))
  add(query_594677, "userIp", newJString(userIp))
  add(path_594676, "orderId", newJString(orderId))
  add(query_594677, "key", newJString(key))
  add(path_594676, "merchantId", newJString(merchantId))
  if body != nil:
    body_594678 = body
  add(query_594677, "prettyPrint", newJBool(prettyPrint))
  result = call_594675.call(path_594676, query_594677, nil, nil, body_594678)

var contentOrderinvoicesCreatechargeinvoice* = Call_ContentOrderinvoicesCreatechargeinvoice_594661(
    name: "contentOrderinvoicesCreatechargeinvoice", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderinvoices/{orderId}/createChargeInvoice",
    validator: validate_ContentOrderinvoicesCreatechargeinvoice_594662,
    base: "/content/v2.1", url: url_ContentOrderinvoicesCreatechargeinvoice_594663,
    schemes: {Scheme.Https})
type
  Call_ContentOrderinvoicesCreaterefundinvoice_594679 = ref object of OpenApiRestCall_593421
proc url_ContentOrderinvoicesCreaterefundinvoice_594681(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentOrderinvoicesCreaterefundinvoice_594680(path: JsonNode;
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
  var valid_594682 = path.getOrDefault("orderId")
  valid_594682 = validateParameter(valid_594682, JString, required = true,
                                 default = nil)
  if valid_594682 != nil:
    section.add "orderId", valid_594682
  var valid_594683 = path.getOrDefault("merchantId")
  valid_594683 = validateParameter(valid_594683, JString, required = true,
                                 default = nil)
  if valid_594683 != nil:
    section.add "merchantId", valid_594683
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
  var valid_594684 = query.getOrDefault("fields")
  valid_594684 = validateParameter(valid_594684, JString, required = false,
                                 default = nil)
  if valid_594684 != nil:
    section.add "fields", valid_594684
  var valid_594685 = query.getOrDefault("quotaUser")
  valid_594685 = validateParameter(valid_594685, JString, required = false,
                                 default = nil)
  if valid_594685 != nil:
    section.add "quotaUser", valid_594685
  var valid_594686 = query.getOrDefault("alt")
  valid_594686 = validateParameter(valid_594686, JString, required = false,
                                 default = newJString("json"))
  if valid_594686 != nil:
    section.add "alt", valid_594686
  var valid_594687 = query.getOrDefault("oauth_token")
  valid_594687 = validateParameter(valid_594687, JString, required = false,
                                 default = nil)
  if valid_594687 != nil:
    section.add "oauth_token", valid_594687
  var valid_594688 = query.getOrDefault("userIp")
  valid_594688 = validateParameter(valid_594688, JString, required = false,
                                 default = nil)
  if valid_594688 != nil:
    section.add "userIp", valid_594688
  var valid_594689 = query.getOrDefault("key")
  valid_594689 = validateParameter(valid_594689, JString, required = false,
                                 default = nil)
  if valid_594689 != nil:
    section.add "key", valid_594689
  var valid_594690 = query.getOrDefault("prettyPrint")
  valid_594690 = validateParameter(valid_594690, JBool, required = false,
                                 default = newJBool(true))
  if valid_594690 != nil:
    section.add "prettyPrint", valid_594690
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

proc call*(call_594692: Call_ContentOrderinvoicesCreaterefundinvoice_594679;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a refund invoice for one or more shipment groups, and triggers a refund for orderinvoice enabled orders. This can only be used for line items that have previously been charged using createChargeInvoice. All amounts (except for the summary) are incremental with respect to the previous invoice.
  ## 
  let valid = call_594692.validator(path, query, header, formData, body)
  let scheme = call_594692.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594692.url(scheme.get, call_594692.host, call_594692.base,
                         call_594692.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594692, url, valid)

proc call*(call_594693: Call_ContentOrderinvoicesCreaterefundinvoice_594679;
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
  var path_594694 = newJObject()
  var query_594695 = newJObject()
  var body_594696 = newJObject()
  add(query_594695, "fields", newJString(fields))
  add(query_594695, "quotaUser", newJString(quotaUser))
  add(query_594695, "alt", newJString(alt))
  add(query_594695, "oauth_token", newJString(oauthToken))
  add(query_594695, "userIp", newJString(userIp))
  add(path_594694, "orderId", newJString(orderId))
  add(query_594695, "key", newJString(key))
  add(path_594694, "merchantId", newJString(merchantId))
  if body != nil:
    body_594696 = body
  add(query_594695, "prettyPrint", newJBool(prettyPrint))
  result = call_594693.call(path_594694, query_594695, nil, nil, body_594696)

var contentOrderinvoicesCreaterefundinvoice* = Call_ContentOrderinvoicesCreaterefundinvoice_594679(
    name: "contentOrderinvoicesCreaterefundinvoice", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderinvoices/{orderId}/createRefundInvoice",
    validator: validate_ContentOrderinvoicesCreaterefundinvoice_594680,
    base: "/content/v2.1", url: url_ContentOrderinvoicesCreaterefundinvoice_594681,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreportsListdisbursements_594697 = ref object of OpenApiRestCall_593421
proc url_ContentOrderreportsListdisbursements_594699(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentOrderreportsListdisbursements_594698(path: JsonNode;
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
  var valid_594700 = path.getOrDefault("merchantId")
  valid_594700 = validateParameter(valid_594700, JString, required = true,
                                 default = nil)
  if valid_594700 != nil:
    section.add "merchantId", valid_594700
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
  var valid_594701 = query.getOrDefault("fields")
  valid_594701 = validateParameter(valid_594701, JString, required = false,
                                 default = nil)
  if valid_594701 != nil:
    section.add "fields", valid_594701
  var valid_594702 = query.getOrDefault("pageToken")
  valid_594702 = validateParameter(valid_594702, JString, required = false,
                                 default = nil)
  if valid_594702 != nil:
    section.add "pageToken", valid_594702
  var valid_594703 = query.getOrDefault("quotaUser")
  valid_594703 = validateParameter(valid_594703, JString, required = false,
                                 default = nil)
  if valid_594703 != nil:
    section.add "quotaUser", valid_594703
  var valid_594704 = query.getOrDefault("alt")
  valid_594704 = validateParameter(valid_594704, JString, required = false,
                                 default = newJString("json"))
  if valid_594704 != nil:
    section.add "alt", valid_594704
  var valid_594705 = query.getOrDefault("oauth_token")
  valid_594705 = validateParameter(valid_594705, JString, required = false,
                                 default = nil)
  if valid_594705 != nil:
    section.add "oauth_token", valid_594705
  var valid_594706 = query.getOrDefault("userIp")
  valid_594706 = validateParameter(valid_594706, JString, required = false,
                                 default = nil)
  if valid_594706 != nil:
    section.add "userIp", valid_594706
  var valid_594707 = query.getOrDefault("maxResults")
  valid_594707 = validateParameter(valid_594707, JInt, required = false, default = nil)
  if valid_594707 != nil:
    section.add "maxResults", valid_594707
  var valid_594708 = query.getOrDefault("key")
  valid_594708 = validateParameter(valid_594708, JString, required = false,
                                 default = nil)
  if valid_594708 != nil:
    section.add "key", valid_594708
  var valid_594709 = query.getOrDefault("prettyPrint")
  valid_594709 = validateParameter(valid_594709, JBool, required = false,
                                 default = newJBool(true))
  if valid_594709 != nil:
    section.add "prettyPrint", valid_594709
  assert query != nil, "query argument is necessary due to required `disbursementStartDate` field"
  var valid_594710 = query.getOrDefault("disbursementStartDate")
  valid_594710 = validateParameter(valid_594710, JString, required = true,
                                 default = nil)
  if valid_594710 != nil:
    section.add "disbursementStartDate", valid_594710
  var valid_594711 = query.getOrDefault("disbursementEndDate")
  valid_594711 = validateParameter(valid_594711, JString, required = false,
                                 default = nil)
  if valid_594711 != nil:
    section.add "disbursementEndDate", valid_594711
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594712: Call_ContentOrderreportsListdisbursements_594697;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a report for disbursements from your Merchant Center account.
  ## 
  let valid = call_594712.validator(path, query, header, formData, body)
  let scheme = call_594712.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594712.url(scheme.get, call_594712.host, call_594712.base,
                         call_594712.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594712, url, valid)

proc call*(call_594713: Call_ContentOrderreportsListdisbursements_594697;
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
  var path_594714 = newJObject()
  var query_594715 = newJObject()
  add(query_594715, "fields", newJString(fields))
  add(query_594715, "pageToken", newJString(pageToken))
  add(query_594715, "quotaUser", newJString(quotaUser))
  add(query_594715, "alt", newJString(alt))
  add(query_594715, "oauth_token", newJString(oauthToken))
  add(query_594715, "userIp", newJString(userIp))
  add(query_594715, "maxResults", newJInt(maxResults))
  add(query_594715, "key", newJString(key))
  add(path_594714, "merchantId", newJString(merchantId))
  add(query_594715, "prettyPrint", newJBool(prettyPrint))
  add(query_594715, "disbursementStartDate", newJString(disbursementStartDate))
  add(query_594715, "disbursementEndDate", newJString(disbursementEndDate))
  result = call_594713.call(path_594714, query_594715, nil, nil, nil)

var contentOrderreportsListdisbursements* = Call_ContentOrderreportsListdisbursements_594697(
    name: "contentOrderreportsListdisbursements", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreports/disbursements",
    validator: validate_ContentOrderreportsListdisbursements_594698,
    base: "/content/v2.1", url: url_ContentOrderreportsListdisbursements_594699,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreportsListtransactions_594716 = ref object of OpenApiRestCall_593421
proc url_ContentOrderreportsListtransactions_594718(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentOrderreportsListtransactions_594717(path: JsonNode;
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
  var valid_594719 = path.getOrDefault("merchantId")
  valid_594719 = validateParameter(valid_594719, JString, required = true,
                                 default = nil)
  if valid_594719 != nil:
    section.add "merchantId", valid_594719
  var valid_594720 = path.getOrDefault("disbursementId")
  valid_594720 = validateParameter(valid_594720, JString, required = true,
                                 default = nil)
  if valid_594720 != nil:
    section.add "disbursementId", valid_594720
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
  var valid_594721 = query.getOrDefault("fields")
  valid_594721 = validateParameter(valid_594721, JString, required = false,
                                 default = nil)
  if valid_594721 != nil:
    section.add "fields", valid_594721
  var valid_594722 = query.getOrDefault("pageToken")
  valid_594722 = validateParameter(valid_594722, JString, required = false,
                                 default = nil)
  if valid_594722 != nil:
    section.add "pageToken", valid_594722
  var valid_594723 = query.getOrDefault("quotaUser")
  valid_594723 = validateParameter(valid_594723, JString, required = false,
                                 default = nil)
  if valid_594723 != nil:
    section.add "quotaUser", valid_594723
  var valid_594724 = query.getOrDefault("alt")
  valid_594724 = validateParameter(valid_594724, JString, required = false,
                                 default = newJString("json"))
  if valid_594724 != nil:
    section.add "alt", valid_594724
  var valid_594725 = query.getOrDefault("transactionEndDate")
  valid_594725 = validateParameter(valid_594725, JString, required = false,
                                 default = nil)
  if valid_594725 != nil:
    section.add "transactionEndDate", valid_594725
  var valid_594726 = query.getOrDefault("oauth_token")
  valid_594726 = validateParameter(valid_594726, JString, required = false,
                                 default = nil)
  if valid_594726 != nil:
    section.add "oauth_token", valid_594726
  var valid_594727 = query.getOrDefault("userIp")
  valid_594727 = validateParameter(valid_594727, JString, required = false,
                                 default = nil)
  if valid_594727 != nil:
    section.add "userIp", valid_594727
  var valid_594728 = query.getOrDefault("maxResults")
  valid_594728 = validateParameter(valid_594728, JInt, required = false, default = nil)
  if valid_594728 != nil:
    section.add "maxResults", valid_594728
  assert query != nil, "query argument is necessary due to required `transactionStartDate` field"
  var valid_594729 = query.getOrDefault("transactionStartDate")
  valid_594729 = validateParameter(valid_594729, JString, required = true,
                                 default = nil)
  if valid_594729 != nil:
    section.add "transactionStartDate", valid_594729
  var valid_594730 = query.getOrDefault("key")
  valid_594730 = validateParameter(valid_594730, JString, required = false,
                                 default = nil)
  if valid_594730 != nil:
    section.add "key", valid_594730
  var valid_594731 = query.getOrDefault("prettyPrint")
  valid_594731 = validateParameter(valid_594731, JBool, required = false,
                                 default = newJBool(true))
  if valid_594731 != nil:
    section.add "prettyPrint", valid_594731
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594732: Call_ContentOrderreportsListtransactions_594716;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of transactions for a disbursement from your Merchant Center account.
  ## 
  let valid = call_594732.validator(path, query, header, formData, body)
  let scheme = call_594732.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594732.url(scheme.get, call_594732.host, call_594732.base,
                         call_594732.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594732, url, valid)

proc call*(call_594733: Call_ContentOrderreportsListtransactions_594716;
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
  var path_594734 = newJObject()
  var query_594735 = newJObject()
  add(query_594735, "fields", newJString(fields))
  add(query_594735, "pageToken", newJString(pageToken))
  add(query_594735, "quotaUser", newJString(quotaUser))
  add(query_594735, "alt", newJString(alt))
  add(query_594735, "transactionEndDate", newJString(transactionEndDate))
  add(query_594735, "oauth_token", newJString(oauthToken))
  add(query_594735, "userIp", newJString(userIp))
  add(query_594735, "maxResults", newJInt(maxResults))
  add(query_594735, "transactionStartDate", newJString(transactionStartDate))
  add(query_594735, "key", newJString(key))
  add(path_594734, "merchantId", newJString(merchantId))
  add(path_594734, "disbursementId", newJString(disbursementId))
  add(query_594735, "prettyPrint", newJBool(prettyPrint))
  result = call_594733.call(path_594734, query_594735, nil, nil, nil)

var contentOrderreportsListtransactions* = Call_ContentOrderreportsListtransactions_594716(
    name: "contentOrderreportsListtransactions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreports/disbursements/{disbursementId}/transactions",
    validator: validate_ContentOrderreportsListtransactions_594717,
    base: "/content/v2.1", url: url_ContentOrderreportsListtransactions_594718,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreturnsList_594736 = ref object of OpenApiRestCall_593421
proc url_ContentOrderreturnsList_594738(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentOrderreturnsList_594737(path: JsonNode; query: JsonNode;
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
  var valid_594739 = path.getOrDefault("merchantId")
  valid_594739 = validateParameter(valid_594739, JString, required = true,
                                 default = nil)
  if valid_594739 != nil:
    section.add "merchantId", valid_594739
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
  var valid_594740 = query.getOrDefault("fields")
  valid_594740 = validateParameter(valid_594740, JString, required = false,
                                 default = nil)
  if valid_594740 != nil:
    section.add "fields", valid_594740
  var valid_594741 = query.getOrDefault("pageToken")
  valid_594741 = validateParameter(valid_594741, JString, required = false,
                                 default = nil)
  if valid_594741 != nil:
    section.add "pageToken", valid_594741
  var valid_594742 = query.getOrDefault("quotaUser")
  valid_594742 = validateParameter(valid_594742, JString, required = false,
                                 default = nil)
  if valid_594742 != nil:
    section.add "quotaUser", valid_594742
  var valid_594743 = query.getOrDefault("alt")
  valid_594743 = validateParameter(valid_594743, JString, required = false,
                                 default = newJString("json"))
  if valid_594743 != nil:
    section.add "alt", valid_594743
  var valid_594744 = query.getOrDefault("oauth_token")
  valid_594744 = validateParameter(valid_594744, JString, required = false,
                                 default = nil)
  if valid_594744 != nil:
    section.add "oauth_token", valid_594744
  var valid_594745 = query.getOrDefault("userIp")
  valid_594745 = validateParameter(valid_594745, JString, required = false,
                                 default = nil)
  if valid_594745 != nil:
    section.add "userIp", valid_594745
  var valid_594746 = query.getOrDefault("maxResults")
  valid_594746 = validateParameter(valid_594746, JInt, required = false, default = nil)
  if valid_594746 != nil:
    section.add "maxResults", valid_594746
  var valid_594747 = query.getOrDefault("orderBy")
  valid_594747 = validateParameter(valid_594747, JString, required = false,
                                 default = newJString("returnCreationTimeAsc"))
  if valid_594747 != nil:
    section.add "orderBy", valid_594747
  var valid_594748 = query.getOrDefault("key")
  valid_594748 = validateParameter(valid_594748, JString, required = false,
                                 default = nil)
  if valid_594748 != nil:
    section.add "key", valid_594748
  var valid_594749 = query.getOrDefault("createdEndDate")
  valid_594749 = validateParameter(valid_594749, JString, required = false,
                                 default = nil)
  if valid_594749 != nil:
    section.add "createdEndDate", valid_594749
  var valid_594750 = query.getOrDefault("prettyPrint")
  valid_594750 = validateParameter(valid_594750, JBool, required = false,
                                 default = newJBool(true))
  if valid_594750 != nil:
    section.add "prettyPrint", valid_594750
  var valid_594751 = query.getOrDefault("createdStartDate")
  valid_594751 = validateParameter(valid_594751, JString, required = false,
                                 default = nil)
  if valid_594751 != nil:
    section.add "createdStartDate", valid_594751
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594752: Call_ContentOrderreturnsList_594736; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists order returns in your Merchant Center account.
  ## 
  let valid = call_594752.validator(path, query, header, formData, body)
  let scheme = call_594752.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594752.url(scheme.get, call_594752.host, call_594752.base,
                         call_594752.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594752, url, valid)

proc call*(call_594753: Call_ContentOrderreturnsList_594736; merchantId: string;
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
  var path_594754 = newJObject()
  var query_594755 = newJObject()
  add(query_594755, "fields", newJString(fields))
  add(query_594755, "pageToken", newJString(pageToken))
  add(query_594755, "quotaUser", newJString(quotaUser))
  add(query_594755, "alt", newJString(alt))
  add(query_594755, "oauth_token", newJString(oauthToken))
  add(query_594755, "userIp", newJString(userIp))
  add(query_594755, "maxResults", newJInt(maxResults))
  add(query_594755, "orderBy", newJString(orderBy))
  add(query_594755, "key", newJString(key))
  add(query_594755, "createdEndDate", newJString(createdEndDate))
  add(path_594754, "merchantId", newJString(merchantId))
  add(query_594755, "prettyPrint", newJBool(prettyPrint))
  add(query_594755, "createdStartDate", newJString(createdStartDate))
  result = call_594753.call(path_594754, query_594755, nil, nil, nil)

var contentOrderreturnsList* = Call_ContentOrderreturnsList_594736(
    name: "contentOrderreturnsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreturns",
    validator: validate_ContentOrderreturnsList_594737, base: "/content/v2.1",
    url: url_ContentOrderreturnsList_594738, schemes: {Scheme.Https})
type
  Call_ContentOrderreturnsGet_594756 = ref object of OpenApiRestCall_593421
proc url_ContentOrderreturnsGet_594758(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentOrderreturnsGet_594757(path: JsonNode; query: JsonNode;
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
  var valid_594759 = path.getOrDefault("returnId")
  valid_594759 = validateParameter(valid_594759, JString, required = true,
                                 default = nil)
  if valid_594759 != nil:
    section.add "returnId", valid_594759
  var valid_594760 = path.getOrDefault("merchantId")
  valid_594760 = validateParameter(valid_594760, JString, required = true,
                                 default = nil)
  if valid_594760 != nil:
    section.add "merchantId", valid_594760
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
  var valid_594761 = query.getOrDefault("fields")
  valid_594761 = validateParameter(valid_594761, JString, required = false,
                                 default = nil)
  if valid_594761 != nil:
    section.add "fields", valid_594761
  var valid_594762 = query.getOrDefault("quotaUser")
  valid_594762 = validateParameter(valid_594762, JString, required = false,
                                 default = nil)
  if valid_594762 != nil:
    section.add "quotaUser", valid_594762
  var valid_594763 = query.getOrDefault("alt")
  valid_594763 = validateParameter(valid_594763, JString, required = false,
                                 default = newJString("json"))
  if valid_594763 != nil:
    section.add "alt", valid_594763
  var valid_594764 = query.getOrDefault("oauth_token")
  valid_594764 = validateParameter(valid_594764, JString, required = false,
                                 default = nil)
  if valid_594764 != nil:
    section.add "oauth_token", valid_594764
  var valid_594765 = query.getOrDefault("userIp")
  valid_594765 = validateParameter(valid_594765, JString, required = false,
                                 default = nil)
  if valid_594765 != nil:
    section.add "userIp", valid_594765
  var valid_594766 = query.getOrDefault("key")
  valid_594766 = validateParameter(valid_594766, JString, required = false,
                                 default = nil)
  if valid_594766 != nil:
    section.add "key", valid_594766
  var valid_594767 = query.getOrDefault("prettyPrint")
  valid_594767 = validateParameter(valid_594767, JBool, required = false,
                                 default = newJBool(true))
  if valid_594767 != nil:
    section.add "prettyPrint", valid_594767
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594768: Call_ContentOrderreturnsGet_594756; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an order return from your Merchant Center account.
  ## 
  let valid = call_594768.validator(path, query, header, formData, body)
  let scheme = call_594768.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594768.url(scheme.get, call_594768.host, call_594768.base,
                         call_594768.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594768, url, valid)

proc call*(call_594769: Call_ContentOrderreturnsGet_594756; returnId: string;
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
  var path_594770 = newJObject()
  var query_594771 = newJObject()
  add(query_594771, "fields", newJString(fields))
  add(query_594771, "quotaUser", newJString(quotaUser))
  add(path_594770, "returnId", newJString(returnId))
  add(query_594771, "alt", newJString(alt))
  add(query_594771, "oauth_token", newJString(oauthToken))
  add(query_594771, "userIp", newJString(userIp))
  add(query_594771, "key", newJString(key))
  add(path_594770, "merchantId", newJString(merchantId))
  add(query_594771, "prettyPrint", newJBool(prettyPrint))
  result = call_594769.call(path_594770, query_594771, nil, nil, nil)

var contentOrderreturnsGet* = Call_ContentOrderreturnsGet_594756(
    name: "contentOrderreturnsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreturns/{returnId}",
    validator: validate_ContentOrderreturnsGet_594757, base: "/content/v2.1",
    url: url_ContentOrderreturnsGet_594758, schemes: {Scheme.Https})
type
  Call_ContentOrdersList_594772 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersList_594774(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentOrdersList_594773(path: JsonNode; query: JsonNode;
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
  var valid_594775 = path.getOrDefault("merchantId")
  valid_594775 = validateParameter(valid_594775, JString, required = true,
                                 default = nil)
  if valid_594775 != nil:
    section.add "merchantId", valid_594775
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
  var valid_594776 = query.getOrDefault("fields")
  valid_594776 = validateParameter(valid_594776, JString, required = false,
                                 default = nil)
  if valid_594776 != nil:
    section.add "fields", valid_594776
  var valid_594777 = query.getOrDefault("pageToken")
  valid_594777 = validateParameter(valid_594777, JString, required = false,
                                 default = nil)
  if valid_594777 != nil:
    section.add "pageToken", valid_594777
  var valid_594778 = query.getOrDefault("quotaUser")
  valid_594778 = validateParameter(valid_594778, JString, required = false,
                                 default = nil)
  if valid_594778 != nil:
    section.add "quotaUser", valid_594778
  var valid_594779 = query.getOrDefault("alt")
  valid_594779 = validateParameter(valid_594779, JString, required = false,
                                 default = newJString("json"))
  if valid_594779 != nil:
    section.add "alt", valid_594779
  var valid_594780 = query.getOrDefault("placedDateStart")
  valid_594780 = validateParameter(valid_594780, JString, required = false,
                                 default = nil)
  if valid_594780 != nil:
    section.add "placedDateStart", valid_594780
  var valid_594781 = query.getOrDefault("oauth_token")
  valid_594781 = validateParameter(valid_594781, JString, required = false,
                                 default = nil)
  if valid_594781 != nil:
    section.add "oauth_token", valid_594781
  var valid_594782 = query.getOrDefault("userIp")
  valid_594782 = validateParameter(valid_594782, JString, required = false,
                                 default = nil)
  if valid_594782 != nil:
    section.add "userIp", valid_594782
  var valid_594783 = query.getOrDefault("maxResults")
  valid_594783 = validateParameter(valid_594783, JInt, required = false, default = nil)
  if valid_594783 != nil:
    section.add "maxResults", valid_594783
  var valid_594784 = query.getOrDefault("orderBy")
  valid_594784 = validateParameter(valid_594784, JString, required = false,
                                 default = nil)
  if valid_594784 != nil:
    section.add "orderBy", valid_594784
  var valid_594785 = query.getOrDefault("placedDateEnd")
  valid_594785 = validateParameter(valid_594785, JString, required = false,
                                 default = nil)
  if valid_594785 != nil:
    section.add "placedDateEnd", valid_594785
  var valid_594786 = query.getOrDefault("key")
  valid_594786 = validateParameter(valid_594786, JString, required = false,
                                 default = nil)
  if valid_594786 != nil:
    section.add "key", valid_594786
  var valid_594787 = query.getOrDefault("acknowledged")
  valid_594787 = validateParameter(valid_594787, JBool, required = false, default = nil)
  if valid_594787 != nil:
    section.add "acknowledged", valid_594787
  var valid_594788 = query.getOrDefault("prettyPrint")
  valid_594788 = validateParameter(valid_594788, JBool, required = false,
                                 default = newJBool(true))
  if valid_594788 != nil:
    section.add "prettyPrint", valid_594788
  var valid_594789 = query.getOrDefault("statuses")
  valid_594789 = validateParameter(valid_594789, JArray, required = false,
                                 default = nil)
  if valid_594789 != nil:
    section.add "statuses", valid_594789
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594790: Call_ContentOrdersList_594772; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the orders in your Merchant Center account.
  ## 
  let valid = call_594790.validator(path, query, header, formData, body)
  let scheme = call_594790.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594790.url(scheme.get, call_594790.host, call_594790.base,
                         call_594790.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594790, url, valid)

proc call*(call_594791: Call_ContentOrdersList_594772; merchantId: string;
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
  var path_594792 = newJObject()
  var query_594793 = newJObject()
  add(query_594793, "fields", newJString(fields))
  add(query_594793, "pageToken", newJString(pageToken))
  add(query_594793, "quotaUser", newJString(quotaUser))
  add(query_594793, "alt", newJString(alt))
  add(query_594793, "placedDateStart", newJString(placedDateStart))
  add(query_594793, "oauth_token", newJString(oauthToken))
  add(query_594793, "userIp", newJString(userIp))
  add(query_594793, "maxResults", newJInt(maxResults))
  add(query_594793, "orderBy", newJString(orderBy))
  add(query_594793, "placedDateEnd", newJString(placedDateEnd))
  add(query_594793, "key", newJString(key))
  add(path_594792, "merchantId", newJString(merchantId))
  add(query_594793, "acknowledged", newJBool(acknowledged))
  add(query_594793, "prettyPrint", newJBool(prettyPrint))
  if statuses != nil:
    query_594793.add "statuses", statuses
  result = call_594791.call(path_594792, query_594793, nil, nil, nil)

var contentOrdersList* = Call_ContentOrdersList_594772(name: "contentOrdersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/orders", validator: validate_ContentOrdersList_594773,
    base: "/content/v2.1", url: url_ContentOrdersList_594774,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersGet_594794 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersGet_594796(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentOrdersGet_594795(path: JsonNode; query: JsonNode;
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
  var valid_594797 = path.getOrDefault("orderId")
  valid_594797 = validateParameter(valid_594797, JString, required = true,
                                 default = nil)
  if valid_594797 != nil:
    section.add "orderId", valid_594797
  var valid_594798 = path.getOrDefault("merchantId")
  valid_594798 = validateParameter(valid_594798, JString, required = true,
                                 default = nil)
  if valid_594798 != nil:
    section.add "merchantId", valid_594798
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
  var valid_594799 = query.getOrDefault("fields")
  valid_594799 = validateParameter(valid_594799, JString, required = false,
                                 default = nil)
  if valid_594799 != nil:
    section.add "fields", valid_594799
  var valid_594800 = query.getOrDefault("quotaUser")
  valid_594800 = validateParameter(valid_594800, JString, required = false,
                                 default = nil)
  if valid_594800 != nil:
    section.add "quotaUser", valid_594800
  var valid_594801 = query.getOrDefault("alt")
  valid_594801 = validateParameter(valid_594801, JString, required = false,
                                 default = newJString("json"))
  if valid_594801 != nil:
    section.add "alt", valid_594801
  var valid_594802 = query.getOrDefault("oauth_token")
  valid_594802 = validateParameter(valid_594802, JString, required = false,
                                 default = nil)
  if valid_594802 != nil:
    section.add "oauth_token", valid_594802
  var valid_594803 = query.getOrDefault("userIp")
  valid_594803 = validateParameter(valid_594803, JString, required = false,
                                 default = nil)
  if valid_594803 != nil:
    section.add "userIp", valid_594803
  var valid_594804 = query.getOrDefault("key")
  valid_594804 = validateParameter(valid_594804, JString, required = false,
                                 default = nil)
  if valid_594804 != nil:
    section.add "key", valid_594804
  var valid_594805 = query.getOrDefault("prettyPrint")
  valid_594805 = validateParameter(valid_594805, JBool, required = false,
                                 default = newJBool(true))
  if valid_594805 != nil:
    section.add "prettyPrint", valid_594805
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594806: Call_ContentOrdersGet_594794; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an order from your Merchant Center account.
  ## 
  let valid = call_594806.validator(path, query, header, formData, body)
  let scheme = call_594806.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594806.url(scheme.get, call_594806.host, call_594806.base,
                         call_594806.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594806, url, valid)

proc call*(call_594807: Call_ContentOrdersGet_594794; orderId: string;
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
  var path_594808 = newJObject()
  var query_594809 = newJObject()
  add(query_594809, "fields", newJString(fields))
  add(query_594809, "quotaUser", newJString(quotaUser))
  add(query_594809, "alt", newJString(alt))
  add(query_594809, "oauth_token", newJString(oauthToken))
  add(query_594809, "userIp", newJString(userIp))
  add(path_594808, "orderId", newJString(orderId))
  add(query_594809, "key", newJString(key))
  add(path_594808, "merchantId", newJString(merchantId))
  add(query_594809, "prettyPrint", newJBool(prettyPrint))
  result = call_594807.call(path_594808, query_594809, nil, nil, nil)

var contentOrdersGet* = Call_ContentOrdersGet_594794(name: "contentOrdersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}", validator: validate_ContentOrdersGet_594795,
    base: "/content/v2.1", url: url_ContentOrdersGet_594796, schemes: {Scheme.Https})
type
  Call_ContentOrdersAcknowledge_594810 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersAcknowledge_594812(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentOrdersAcknowledge_594811(path: JsonNode; query: JsonNode;
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
  var valid_594813 = path.getOrDefault("orderId")
  valid_594813 = validateParameter(valid_594813, JString, required = true,
                                 default = nil)
  if valid_594813 != nil:
    section.add "orderId", valid_594813
  var valid_594814 = path.getOrDefault("merchantId")
  valid_594814 = validateParameter(valid_594814, JString, required = true,
                                 default = nil)
  if valid_594814 != nil:
    section.add "merchantId", valid_594814
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
  var valid_594815 = query.getOrDefault("fields")
  valid_594815 = validateParameter(valid_594815, JString, required = false,
                                 default = nil)
  if valid_594815 != nil:
    section.add "fields", valid_594815
  var valid_594816 = query.getOrDefault("quotaUser")
  valid_594816 = validateParameter(valid_594816, JString, required = false,
                                 default = nil)
  if valid_594816 != nil:
    section.add "quotaUser", valid_594816
  var valid_594817 = query.getOrDefault("alt")
  valid_594817 = validateParameter(valid_594817, JString, required = false,
                                 default = newJString("json"))
  if valid_594817 != nil:
    section.add "alt", valid_594817
  var valid_594818 = query.getOrDefault("oauth_token")
  valid_594818 = validateParameter(valid_594818, JString, required = false,
                                 default = nil)
  if valid_594818 != nil:
    section.add "oauth_token", valid_594818
  var valid_594819 = query.getOrDefault("userIp")
  valid_594819 = validateParameter(valid_594819, JString, required = false,
                                 default = nil)
  if valid_594819 != nil:
    section.add "userIp", valid_594819
  var valid_594820 = query.getOrDefault("key")
  valid_594820 = validateParameter(valid_594820, JString, required = false,
                                 default = nil)
  if valid_594820 != nil:
    section.add "key", valid_594820
  var valid_594821 = query.getOrDefault("prettyPrint")
  valid_594821 = validateParameter(valid_594821, JBool, required = false,
                                 default = newJBool(true))
  if valid_594821 != nil:
    section.add "prettyPrint", valid_594821
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

proc call*(call_594823: Call_ContentOrdersAcknowledge_594810; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks an order as acknowledged.
  ## 
  let valid = call_594823.validator(path, query, header, formData, body)
  let scheme = call_594823.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594823.url(scheme.get, call_594823.host, call_594823.base,
                         call_594823.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594823, url, valid)

proc call*(call_594824: Call_ContentOrdersAcknowledge_594810; orderId: string;
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
  var path_594825 = newJObject()
  var query_594826 = newJObject()
  var body_594827 = newJObject()
  add(query_594826, "fields", newJString(fields))
  add(query_594826, "quotaUser", newJString(quotaUser))
  add(query_594826, "alt", newJString(alt))
  add(query_594826, "oauth_token", newJString(oauthToken))
  add(query_594826, "userIp", newJString(userIp))
  add(path_594825, "orderId", newJString(orderId))
  add(query_594826, "key", newJString(key))
  add(path_594825, "merchantId", newJString(merchantId))
  if body != nil:
    body_594827 = body
  add(query_594826, "prettyPrint", newJBool(prettyPrint))
  result = call_594824.call(path_594825, query_594826, nil, nil, body_594827)

var contentOrdersAcknowledge* = Call_ContentOrdersAcknowledge_594810(
    name: "contentOrdersAcknowledge", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/acknowledge",
    validator: validate_ContentOrdersAcknowledge_594811, base: "/content/v2.1",
    url: url_ContentOrdersAcknowledge_594812, schemes: {Scheme.Https})
type
  Call_ContentOrdersCancel_594828 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersCancel_594830(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentOrdersCancel_594829(path: JsonNode; query: JsonNode;
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
  var valid_594831 = path.getOrDefault("orderId")
  valid_594831 = validateParameter(valid_594831, JString, required = true,
                                 default = nil)
  if valid_594831 != nil:
    section.add "orderId", valid_594831
  var valid_594832 = path.getOrDefault("merchantId")
  valid_594832 = validateParameter(valid_594832, JString, required = true,
                                 default = nil)
  if valid_594832 != nil:
    section.add "merchantId", valid_594832
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
  var valid_594833 = query.getOrDefault("fields")
  valid_594833 = validateParameter(valid_594833, JString, required = false,
                                 default = nil)
  if valid_594833 != nil:
    section.add "fields", valid_594833
  var valid_594834 = query.getOrDefault("quotaUser")
  valid_594834 = validateParameter(valid_594834, JString, required = false,
                                 default = nil)
  if valid_594834 != nil:
    section.add "quotaUser", valid_594834
  var valid_594835 = query.getOrDefault("alt")
  valid_594835 = validateParameter(valid_594835, JString, required = false,
                                 default = newJString("json"))
  if valid_594835 != nil:
    section.add "alt", valid_594835
  var valid_594836 = query.getOrDefault("oauth_token")
  valid_594836 = validateParameter(valid_594836, JString, required = false,
                                 default = nil)
  if valid_594836 != nil:
    section.add "oauth_token", valid_594836
  var valid_594837 = query.getOrDefault("userIp")
  valid_594837 = validateParameter(valid_594837, JString, required = false,
                                 default = nil)
  if valid_594837 != nil:
    section.add "userIp", valid_594837
  var valid_594838 = query.getOrDefault("key")
  valid_594838 = validateParameter(valid_594838, JString, required = false,
                                 default = nil)
  if valid_594838 != nil:
    section.add "key", valid_594838
  var valid_594839 = query.getOrDefault("prettyPrint")
  valid_594839 = validateParameter(valid_594839, JBool, required = false,
                                 default = newJBool(true))
  if valid_594839 != nil:
    section.add "prettyPrint", valid_594839
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

proc call*(call_594841: Call_ContentOrdersCancel_594828; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels all line items in an order, making a full refund.
  ## 
  let valid = call_594841.validator(path, query, header, formData, body)
  let scheme = call_594841.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594841.url(scheme.get, call_594841.host, call_594841.base,
                         call_594841.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594841, url, valid)

proc call*(call_594842: Call_ContentOrdersCancel_594828; orderId: string;
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
  var path_594843 = newJObject()
  var query_594844 = newJObject()
  var body_594845 = newJObject()
  add(query_594844, "fields", newJString(fields))
  add(query_594844, "quotaUser", newJString(quotaUser))
  add(query_594844, "alt", newJString(alt))
  add(query_594844, "oauth_token", newJString(oauthToken))
  add(query_594844, "userIp", newJString(userIp))
  add(path_594843, "orderId", newJString(orderId))
  add(query_594844, "key", newJString(key))
  add(path_594843, "merchantId", newJString(merchantId))
  if body != nil:
    body_594845 = body
  add(query_594844, "prettyPrint", newJBool(prettyPrint))
  result = call_594842.call(path_594843, query_594844, nil, nil, body_594845)

var contentOrdersCancel* = Call_ContentOrdersCancel_594828(
    name: "contentOrdersCancel", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/orders/{orderId}/cancel",
    validator: validate_ContentOrdersCancel_594829, base: "/content/v2.1",
    url: url_ContentOrdersCancel_594830, schemes: {Scheme.Https})
type
  Call_ContentOrdersCancellineitem_594846 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersCancellineitem_594848(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentOrdersCancellineitem_594847(path: JsonNode; query: JsonNode;
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
  var valid_594849 = path.getOrDefault("orderId")
  valid_594849 = validateParameter(valid_594849, JString, required = true,
                                 default = nil)
  if valid_594849 != nil:
    section.add "orderId", valid_594849
  var valid_594850 = path.getOrDefault("merchantId")
  valid_594850 = validateParameter(valid_594850, JString, required = true,
                                 default = nil)
  if valid_594850 != nil:
    section.add "merchantId", valid_594850
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
  var valid_594851 = query.getOrDefault("fields")
  valid_594851 = validateParameter(valid_594851, JString, required = false,
                                 default = nil)
  if valid_594851 != nil:
    section.add "fields", valid_594851
  var valid_594852 = query.getOrDefault("quotaUser")
  valid_594852 = validateParameter(valid_594852, JString, required = false,
                                 default = nil)
  if valid_594852 != nil:
    section.add "quotaUser", valid_594852
  var valid_594853 = query.getOrDefault("alt")
  valid_594853 = validateParameter(valid_594853, JString, required = false,
                                 default = newJString("json"))
  if valid_594853 != nil:
    section.add "alt", valid_594853
  var valid_594854 = query.getOrDefault("oauth_token")
  valid_594854 = validateParameter(valid_594854, JString, required = false,
                                 default = nil)
  if valid_594854 != nil:
    section.add "oauth_token", valid_594854
  var valid_594855 = query.getOrDefault("userIp")
  valid_594855 = validateParameter(valid_594855, JString, required = false,
                                 default = nil)
  if valid_594855 != nil:
    section.add "userIp", valid_594855
  var valid_594856 = query.getOrDefault("key")
  valid_594856 = validateParameter(valid_594856, JString, required = false,
                                 default = nil)
  if valid_594856 != nil:
    section.add "key", valid_594856
  var valid_594857 = query.getOrDefault("prettyPrint")
  valid_594857 = validateParameter(valid_594857, JBool, required = false,
                                 default = newJBool(true))
  if valid_594857 != nil:
    section.add "prettyPrint", valid_594857
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

proc call*(call_594859: Call_ContentOrdersCancellineitem_594846; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a line item, making a full refund.
  ## 
  let valid = call_594859.validator(path, query, header, formData, body)
  let scheme = call_594859.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594859.url(scheme.get, call_594859.host, call_594859.base,
                         call_594859.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594859, url, valid)

proc call*(call_594860: Call_ContentOrdersCancellineitem_594846; orderId: string;
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
  var path_594861 = newJObject()
  var query_594862 = newJObject()
  var body_594863 = newJObject()
  add(query_594862, "fields", newJString(fields))
  add(query_594862, "quotaUser", newJString(quotaUser))
  add(query_594862, "alt", newJString(alt))
  add(query_594862, "oauth_token", newJString(oauthToken))
  add(query_594862, "userIp", newJString(userIp))
  add(path_594861, "orderId", newJString(orderId))
  add(query_594862, "key", newJString(key))
  add(path_594861, "merchantId", newJString(merchantId))
  if body != nil:
    body_594863 = body
  add(query_594862, "prettyPrint", newJBool(prettyPrint))
  result = call_594860.call(path_594861, query_594862, nil, nil, body_594863)

var contentOrdersCancellineitem* = Call_ContentOrdersCancellineitem_594846(
    name: "contentOrdersCancellineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/cancelLineItem",
    validator: validate_ContentOrdersCancellineitem_594847, base: "/content/v2.1",
    url: url_ContentOrdersCancellineitem_594848, schemes: {Scheme.Https})
type
  Call_ContentOrdersInstorerefundlineitem_594864 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersInstorerefundlineitem_594866(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentOrdersInstorerefundlineitem_594865(path: JsonNode;
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
  var valid_594867 = path.getOrDefault("orderId")
  valid_594867 = validateParameter(valid_594867, JString, required = true,
                                 default = nil)
  if valid_594867 != nil:
    section.add "orderId", valid_594867
  var valid_594868 = path.getOrDefault("merchantId")
  valid_594868 = validateParameter(valid_594868, JString, required = true,
                                 default = nil)
  if valid_594868 != nil:
    section.add "merchantId", valid_594868
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
  var valid_594869 = query.getOrDefault("fields")
  valid_594869 = validateParameter(valid_594869, JString, required = false,
                                 default = nil)
  if valid_594869 != nil:
    section.add "fields", valid_594869
  var valid_594870 = query.getOrDefault("quotaUser")
  valid_594870 = validateParameter(valid_594870, JString, required = false,
                                 default = nil)
  if valid_594870 != nil:
    section.add "quotaUser", valid_594870
  var valid_594871 = query.getOrDefault("alt")
  valid_594871 = validateParameter(valid_594871, JString, required = false,
                                 default = newJString("json"))
  if valid_594871 != nil:
    section.add "alt", valid_594871
  var valid_594872 = query.getOrDefault("oauth_token")
  valid_594872 = validateParameter(valid_594872, JString, required = false,
                                 default = nil)
  if valid_594872 != nil:
    section.add "oauth_token", valid_594872
  var valid_594873 = query.getOrDefault("userIp")
  valid_594873 = validateParameter(valid_594873, JString, required = false,
                                 default = nil)
  if valid_594873 != nil:
    section.add "userIp", valid_594873
  var valid_594874 = query.getOrDefault("key")
  valid_594874 = validateParameter(valid_594874, JString, required = false,
                                 default = nil)
  if valid_594874 != nil:
    section.add "key", valid_594874
  var valid_594875 = query.getOrDefault("prettyPrint")
  valid_594875 = validateParameter(valid_594875, JBool, required = false,
                                 default = newJBool(true))
  if valid_594875 != nil:
    section.add "prettyPrint", valid_594875
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

proc call*(call_594877: Call_ContentOrdersInstorerefundlineitem_594864;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deprecated. Notifies that item return and refund was handled directly by merchant outside of Google payments processing (e.g. cash refund done in store).
  ## Note: We recommend calling the returnrefundlineitem method to refund in-store returns. We will issue the refund directly to the customer. This helps to prevent possible differences arising between merchant and Google transaction records. We also recommend having the point of sale system communicate with Google to ensure that customers do not receive a double refund by first refunding via Google then via an in-store return.
  ## 
  let valid = call_594877.validator(path, query, header, formData, body)
  let scheme = call_594877.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594877.url(scheme.get, call_594877.host, call_594877.base,
                         call_594877.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594877, url, valid)

proc call*(call_594878: Call_ContentOrdersInstorerefundlineitem_594864;
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
  var path_594879 = newJObject()
  var query_594880 = newJObject()
  var body_594881 = newJObject()
  add(query_594880, "fields", newJString(fields))
  add(query_594880, "quotaUser", newJString(quotaUser))
  add(query_594880, "alt", newJString(alt))
  add(query_594880, "oauth_token", newJString(oauthToken))
  add(query_594880, "userIp", newJString(userIp))
  add(path_594879, "orderId", newJString(orderId))
  add(query_594880, "key", newJString(key))
  add(path_594879, "merchantId", newJString(merchantId))
  if body != nil:
    body_594881 = body
  add(query_594880, "prettyPrint", newJBool(prettyPrint))
  result = call_594878.call(path_594879, query_594880, nil, nil, body_594881)

var contentOrdersInstorerefundlineitem* = Call_ContentOrdersInstorerefundlineitem_594864(
    name: "contentOrdersInstorerefundlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/inStoreRefundLineItem",
    validator: validate_ContentOrdersInstorerefundlineitem_594865,
    base: "/content/v2.1", url: url_ContentOrdersInstorerefundlineitem_594866,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersRejectreturnlineitem_594882 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersRejectreturnlineitem_594884(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentOrdersRejectreturnlineitem_594883(path: JsonNode;
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
  var valid_594885 = path.getOrDefault("orderId")
  valid_594885 = validateParameter(valid_594885, JString, required = true,
                                 default = nil)
  if valid_594885 != nil:
    section.add "orderId", valid_594885
  var valid_594886 = path.getOrDefault("merchantId")
  valid_594886 = validateParameter(valid_594886, JString, required = true,
                                 default = nil)
  if valid_594886 != nil:
    section.add "merchantId", valid_594886
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
  var valid_594887 = query.getOrDefault("fields")
  valid_594887 = validateParameter(valid_594887, JString, required = false,
                                 default = nil)
  if valid_594887 != nil:
    section.add "fields", valid_594887
  var valid_594888 = query.getOrDefault("quotaUser")
  valid_594888 = validateParameter(valid_594888, JString, required = false,
                                 default = nil)
  if valid_594888 != nil:
    section.add "quotaUser", valid_594888
  var valid_594889 = query.getOrDefault("alt")
  valid_594889 = validateParameter(valid_594889, JString, required = false,
                                 default = newJString("json"))
  if valid_594889 != nil:
    section.add "alt", valid_594889
  var valid_594890 = query.getOrDefault("oauth_token")
  valid_594890 = validateParameter(valid_594890, JString, required = false,
                                 default = nil)
  if valid_594890 != nil:
    section.add "oauth_token", valid_594890
  var valid_594891 = query.getOrDefault("userIp")
  valid_594891 = validateParameter(valid_594891, JString, required = false,
                                 default = nil)
  if valid_594891 != nil:
    section.add "userIp", valid_594891
  var valid_594892 = query.getOrDefault("key")
  valid_594892 = validateParameter(valid_594892, JString, required = false,
                                 default = nil)
  if valid_594892 != nil:
    section.add "key", valid_594892
  var valid_594893 = query.getOrDefault("prettyPrint")
  valid_594893 = validateParameter(valid_594893, JBool, required = false,
                                 default = newJBool(true))
  if valid_594893 != nil:
    section.add "prettyPrint", valid_594893
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

proc call*(call_594895: Call_ContentOrdersRejectreturnlineitem_594882;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rejects return on an line item.
  ## 
  let valid = call_594895.validator(path, query, header, formData, body)
  let scheme = call_594895.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594895.url(scheme.get, call_594895.host, call_594895.base,
                         call_594895.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594895, url, valid)

proc call*(call_594896: Call_ContentOrdersRejectreturnlineitem_594882;
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
  var path_594897 = newJObject()
  var query_594898 = newJObject()
  var body_594899 = newJObject()
  add(query_594898, "fields", newJString(fields))
  add(query_594898, "quotaUser", newJString(quotaUser))
  add(query_594898, "alt", newJString(alt))
  add(query_594898, "oauth_token", newJString(oauthToken))
  add(query_594898, "userIp", newJString(userIp))
  add(path_594897, "orderId", newJString(orderId))
  add(query_594898, "key", newJString(key))
  add(path_594897, "merchantId", newJString(merchantId))
  if body != nil:
    body_594899 = body
  add(query_594898, "prettyPrint", newJBool(prettyPrint))
  result = call_594896.call(path_594897, query_594898, nil, nil, body_594899)

var contentOrdersRejectreturnlineitem* = Call_ContentOrdersRejectreturnlineitem_594882(
    name: "contentOrdersRejectreturnlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/rejectReturnLineItem",
    validator: validate_ContentOrdersRejectreturnlineitem_594883,
    base: "/content/v2.1", url: url_ContentOrdersRejectreturnlineitem_594884,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersReturnrefundlineitem_594900 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersReturnrefundlineitem_594902(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentOrdersReturnrefundlineitem_594901(path: JsonNode;
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
  var valid_594903 = path.getOrDefault("orderId")
  valid_594903 = validateParameter(valid_594903, JString, required = true,
                                 default = nil)
  if valid_594903 != nil:
    section.add "orderId", valid_594903
  var valid_594904 = path.getOrDefault("merchantId")
  valid_594904 = validateParameter(valid_594904, JString, required = true,
                                 default = nil)
  if valid_594904 != nil:
    section.add "merchantId", valid_594904
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
  var valid_594905 = query.getOrDefault("fields")
  valid_594905 = validateParameter(valid_594905, JString, required = false,
                                 default = nil)
  if valid_594905 != nil:
    section.add "fields", valid_594905
  var valid_594906 = query.getOrDefault("quotaUser")
  valid_594906 = validateParameter(valid_594906, JString, required = false,
                                 default = nil)
  if valid_594906 != nil:
    section.add "quotaUser", valid_594906
  var valid_594907 = query.getOrDefault("alt")
  valid_594907 = validateParameter(valid_594907, JString, required = false,
                                 default = newJString("json"))
  if valid_594907 != nil:
    section.add "alt", valid_594907
  var valid_594908 = query.getOrDefault("oauth_token")
  valid_594908 = validateParameter(valid_594908, JString, required = false,
                                 default = nil)
  if valid_594908 != nil:
    section.add "oauth_token", valid_594908
  var valid_594909 = query.getOrDefault("userIp")
  valid_594909 = validateParameter(valid_594909, JString, required = false,
                                 default = nil)
  if valid_594909 != nil:
    section.add "userIp", valid_594909
  var valid_594910 = query.getOrDefault("key")
  valid_594910 = validateParameter(valid_594910, JString, required = false,
                                 default = nil)
  if valid_594910 != nil:
    section.add "key", valid_594910
  var valid_594911 = query.getOrDefault("prettyPrint")
  valid_594911 = validateParameter(valid_594911, JBool, required = false,
                                 default = newJBool(true))
  if valid_594911 != nil:
    section.add "prettyPrint", valid_594911
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

proc call*(call_594913: Call_ContentOrdersReturnrefundlineitem_594900;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns and refunds a line item. Note that this method can only be called on fully shipped orders.
  ## 
  let valid = call_594913.validator(path, query, header, formData, body)
  let scheme = call_594913.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594913.url(scheme.get, call_594913.host, call_594913.base,
                         call_594913.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594913, url, valid)

proc call*(call_594914: Call_ContentOrdersReturnrefundlineitem_594900;
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
  var path_594915 = newJObject()
  var query_594916 = newJObject()
  var body_594917 = newJObject()
  add(query_594916, "fields", newJString(fields))
  add(query_594916, "quotaUser", newJString(quotaUser))
  add(query_594916, "alt", newJString(alt))
  add(query_594916, "oauth_token", newJString(oauthToken))
  add(query_594916, "userIp", newJString(userIp))
  add(path_594915, "orderId", newJString(orderId))
  add(query_594916, "key", newJString(key))
  add(path_594915, "merchantId", newJString(merchantId))
  if body != nil:
    body_594917 = body
  add(query_594916, "prettyPrint", newJBool(prettyPrint))
  result = call_594914.call(path_594915, query_594916, nil, nil, body_594917)

var contentOrdersReturnrefundlineitem* = Call_ContentOrdersReturnrefundlineitem_594900(
    name: "contentOrdersReturnrefundlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/returnRefundLineItem",
    validator: validate_ContentOrdersReturnrefundlineitem_594901,
    base: "/content/v2.1", url: url_ContentOrdersReturnrefundlineitem_594902,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersSetlineitemmetadata_594918 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersSetlineitemmetadata_594920(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentOrdersSetlineitemmetadata_594919(path: JsonNode;
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
  var valid_594921 = path.getOrDefault("orderId")
  valid_594921 = validateParameter(valid_594921, JString, required = true,
                                 default = nil)
  if valid_594921 != nil:
    section.add "orderId", valid_594921
  var valid_594922 = path.getOrDefault("merchantId")
  valid_594922 = validateParameter(valid_594922, JString, required = true,
                                 default = nil)
  if valid_594922 != nil:
    section.add "merchantId", valid_594922
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
  var valid_594923 = query.getOrDefault("fields")
  valid_594923 = validateParameter(valid_594923, JString, required = false,
                                 default = nil)
  if valid_594923 != nil:
    section.add "fields", valid_594923
  var valid_594924 = query.getOrDefault("quotaUser")
  valid_594924 = validateParameter(valid_594924, JString, required = false,
                                 default = nil)
  if valid_594924 != nil:
    section.add "quotaUser", valid_594924
  var valid_594925 = query.getOrDefault("alt")
  valid_594925 = validateParameter(valid_594925, JString, required = false,
                                 default = newJString("json"))
  if valid_594925 != nil:
    section.add "alt", valid_594925
  var valid_594926 = query.getOrDefault("oauth_token")
  valid_594926 = validateParameter(valid_594926, JString, required = false,
                                 default = nil)
  if valid_594926 != nil:
    section.add "oauth_token", valid_594926
  var valid_594927 = query.getOrDefault("userIp")
  valid_594927 = validateParameter(valid_594927, JString, required = false,
                                 default = nil)
  if valid_594927 != nil:
    section.add "userIp", valid_594927
  var valid_594928 = query.getOrDefault("key")
  valid_594928 = validateParameter(valid_594928, JString, required = false,
                                 default = nil)
  if valid_594928 != nil:
    section.add "key", valid_594928
  var valid_594929 = query.getOrDefault("prettyPrint")
  valid_594929 = validateParameter(valid_594929, JBool, required = false,
                                 default = newJBool(true))
  if valid_594929 != nil:
    section.add "prettyPrint", valid_594929
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

proc call*(call_594931: Call_ContentOrdersSetlineitemmetadata_594918;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets (or overrides if it already exists) merchant provided annotations in the form of key-value pairs. A common use case would be to supply us with additional structured information about a line item that cannot be provided via other methods. Submitted key-value pairs can be retrieved as part of the orders resource.
  ## 
  let valid = call_594931.validator(path, query, header, formData, body)
  let scheme = call_594931.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594931.url(scheme.get, call_594931.host, call_594931.base,
                         call_594931.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594931, url, valid)

proc call*(call_594932: Call_ContentOrdersSetlineitemmetadata_594918;
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
  var path_594933 = newJObject()
  var query_594934 = newJObject()
  var body_594935 = newJObject()
  add(query_594934, "fields", newJString(fields))
  add(query_594934, "quotaUser", newJString(quotaUser))
  add(query_594934, "alt", newJString(alt))
  add(query_594934, "oauth_token", newJString(oauthToken))
  add(query_594934, "userIp", newJString(userIp))
  add(path_594933, "orderId", newJString(orderId))
  add(query_594934, "key", newJString(key))
  add(path_594933, "merchantId", newJString(merchantId))
  if body != nil:
    body_594935 = body
  add(query_594934, "prettyPrint", newJBool(prettyPrint))
  result = call_594932.call(path_594933, query_594934, nil, nil, body_594935)

var contentOrdersSetlineitemmetadata* = Call_ContentOrdersSetlineitemmetadata_594918(
    name: "contentOrdersSetlineitemmetadata", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/setLineItemMetadata",
    validator: validate_ContentOrdersSetlineitemmetadata_594919,
    base: "/content/v2.1", url: url_ContentOrdersSetlineitemmetadata_594920,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersShiplineitems_594936 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersShiplineitems_594938(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentOrdersShiplineitems_594937(path: JsonNode; query: JsonNode;
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
  var valid_594939 = path.getOrDefault("orderId")
  valid_594939 = validateParameter(valid_594939, JString, required = true,
                                 default = nil)
  if valid_594939 != nil:
    section.add "orderId", valid_594939
  var valid_594940 = path.getOrDefault("merchantId")
  valid_594940 = validateParameter(valid_594940, JString, required = true,
                                 default = nil)
  if valid_594940 != nil:
    section.add "merchantId", valid_594940
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
  var valid_594941 = query.getOrDefault("fields")
  valid_594941 = validateParameter(valid_594941, JString, required = false,
                                 default = nil)
  if valid_594941 != nil:
    section.add "fields", valid_594941
  var valid_594942 = query.getOrDefault("quotaUser")
  valid_594942 = validateParameter(valid_594942, JString, required = false,
                                 default = nil)
  if valid_594942 != nil:
    section.add "quotaUser", valid_594942
  var valid_594943 = query.getOrDefault("alt")
  valid_594943 = validateParameter(valid_594943, JString, required = false,
                                 default = newJString("json"))
  if valid_594943 != nil:
    section.add "alt", valid_594943
  var valid_594944 = query.getOrDefault("oauth_token")
  valid_594944 = validateParameter(valid_594944, JString, required = false,
                                 default = nil)
  if valid_594944 != nil:
    section.add "oauth_token", valid_594944
  var valid_594945 = query.getOrDefault("userIp")
  valid_594945 = validateParameter(valid_594945, JString, required = false,
                                 default = nil)
  if valid_594945 != nil:
    section.add "userIp", valid_594945
  var valid_594946 = query.getOrDefault("key")
  valid_594946 = validateParameter(valid_594946, JString, required = false,
                                 default = nil)
  if valid_594946 != nil:
    section.add "key", valid_594946
  var valid_594947 = query.getOrDefault("prettyPrint")
  valid_594947 = validateParameter(valid_594947, JBool, required = false,
                                 default = newJBool(true))
  if valid_594947 != nil:
    section.add "prettyPrint", valid_594947
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

proc call*(call_594949: Call_ContentOrdersShiplineitems_594936; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks line item(s) as shipped.
  ## 
  let valid = call_594949.validator(path, query, header, formData, body)
  let scheme = call_594949.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594949.url(scheme.get, call_594949.host, call_594949.base,
                         call_594949.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594949, url, valid)

proc call*(call_594950: Call_ContentOrdersShiplineitems_594936; orderId: string;
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
  var path_594951 = newJObject()
  var query_594952 = newJObject()
  var body_594953 = newJObject()
  add(query_594952, "fields", newJString(fields))
  add(query_594952, "quotaUser", newJString(quotaUser))
  add(query_594952, "alt", newJString(alt))
  add(query_594952, "oauth_token", newJString(oauthToken))
  add(query_594952, "userIp", newJString(userIp))
  add(path_594951, "orderId", newJString(orderId))
  add(query_594952, "key", newJString(key))
  add(path_594951, "merchantId", newJString(merchantId))
  if body != nil:
    body_594953 = body
  add(query_594952, "prettyPrint", newJBool(prettyPrint))
  result = call_594950.call(path_594951, query_594952, nil, nil, body_594953)

var contentOrdersShiplineitems* = Call_ContentOrdersShiplineitems_594936(
    name: "contentOrdersShiplineitems", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/shipLineItems",
    validator: validate_ContentOrdersShiplineitems_594937, base: "/content/v2.1",
    url: url_ContentOrdersShiplineitems_594938, schemes: {Scheme.Https})
type
  Call_ContentOrdersCreatetestreturn_594954 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersCreatetestreturn_594956(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentOrdersCreatetestreturn_594955(path: JsonNode; query: JsonNode;
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
  var valid_594957 = path.getOrDefault("orderId")
  valid_594957 = validateParameter(valid_594957, JString, required = true,
                                 default = nil)
  if valid_594957 != nil:
    section.add "orderId", valid_594957
  var valid_594958 = path.getOrDefault("merchantId")
  valid_594958 = validateParameter(valid_594958, JString, required = true,
                                 default = nil)
  if valid_594958 != nil:
    section.add "merchantId", valid_594958
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
  var valid_594959 = query.getOrDefault("fields")
  valid_594959 = validateParameter(valid_594959, JString, required = false,
                                 default = nil)
  if valid_594959 != nil:
    section.add "fields", valid_594959
  var valid_594960 = query.getOrDefault("quotaUser")
  valid_594960 = validateParameter(valid_594960, JString, required = false,
                                 default = nil)
  if valid_594960 != nil:
    section.add "quotaUser", valid_594960
  var valid_594961 = query.getOrDefault("alt")
  valid_594961 = validateParameter(valid_594961, JString, required = false,
                                 default = newJString("json"))
  if valid_594961 != nil:
    section.add "alt", valid_594961
  var valid_594962 = query.getOrDefault("oauth_token")
  valid_594962 = validateParameter(valid_594962, JString, required = false,
                                 default = nil)
  if valid_594962 != nil:
    section.add "oauth_token", valid_594962
  var valid_594963 = query.getOrDefault("userIp")
  valid_594963 = validateParameter(valid_594963, JString, required = false,
                                 default = nil)
  if valid_594963 != nil:
    section.add "userIp", valid_594963
  var valid_594964 = query.getOrDefault("key")
  valid_594964 = validateParameter(valid_594964, JString, required = false,
                                 default = nil)
  if valid_594964 != nil:
    section.add "key", valid_594964
  var valid_594965 = query.getOrDefault("prettyPrint")
  valid_594965 = validateParameter(valid_594965, JBool, required = false,
                                 default = newJBool(true))
  if valid_594965 != nil:
    section.add "prettyPrint", valid_594965
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

proc call*(call_594967: Call_ContentOrdersCreatetestreturn_594954; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Creates a test return.
  ## 
  let valid = call_594967.validator(path, query, header, formData, body)
  let scheme = call_594967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594967.url(scheme.get, call_594967.host, call_594967.base,
                         call_594967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594967, url, valid)

proc call*(call_594968: Call_ContentOrdersCreatetestreturn_594954; orderId: string;
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
  var path_594969 = newJObject()
  var query_594970 = newJObject()
  var body_594971 = newJObject()
  add(query_594970, "fields", newJString(fields))
  add(query_594970, "quotaUser", newJString(quotaUser))
  add(query_594970, "alt", newJString(alt))
  add(query_594970, "oauth_token", newJString(oauthToken))
  add(query_594970, "userIp", newJString(userIp))
  add(path_594969, "orderId", newJString(orderId))
  add(query_594970, "key", newJString(key))
  add(path_594969, "merchantId", newJString(merchantId))
  if body != nil:
    body_594971 = body
  add(query_594970, "prettyPrint", newJBool(prettyPrint))
  result = call_594968.call(path_594969, query_594970, nil, nil, body_594971)

var contentOrdersCreatetestreturn* = Call_ContentOrdersCreatetestreturn_594954(
    name: "contentOrdersCreatetestreturn", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/testreturn",
    validator: validate_ContentOrdersCreatetestreturn_594955,
    base: "/content/v2.1", url: url_ContentOrdersCreatetestreturn_594956,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdatelineitemshippingdetails_594972 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersUpdatelineitemshippingdetails_594974(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentOrdersUpdatelineitemshippingdetails_594973(path: JsonNode;
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
  var valid_594975 = path.getOrDefault("orderId")
  valid_594975 = validateParameter(valid_594975, JString, required = true,
                                 default = nil)
  if valid_594975 != nil:
    section.add "orderId", valid_594975
  var valid_594976 = path.getOrDefault("merchantId")
  valid_594976 = validateParameter(valid_594976, JString, required = true,
                                 default = nil)
  if valid_594976 != nil:
    section.add "merchantId", valid_594976
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
  var valid_594977 = query.getOrDefault("fields")
  valid_594977 = validateParameter(valid_594977, JString, required = false,
                                 default = nil)
  if valid_594977 != nil:
    section.add "fields", valid_594977
  var valid_594978 = query.getOrDefault("quotaUser")
  valid_594978 = validateParameter(valid_594978, JString, required = false,
                                 default = nil)
  if valid_594978 != nil:
    section.add "quotaUser", valid_594978
  var valid_594979 = query.getOrDefault("alt")
  valid_594979 = validateParameter(valid_594979, JString, required = false,
                                 default = newJString("json"))
  if valid_594979 != nil:
    section.add "alt", valid_594979
  var valid_594980 = query.getOrDefault("oauth_token")
  valid_594980 = validateParameter(valid_594980, JString, required = false,
                                 default = nil)
  if valid_594980 != nil:
    section.add "oauth_token", valid_594980
  var valid_594981 = query.getOrDefault("userIp")
  valid_594981 = validateParameter(valid_594981, JString, required = false,
                                 default = nil)
  if valid_594981 != nil:
    section.add "userIp", valid_594981
  var valid_594982 = query.getOrDefault("key")
  valid_594982 = validateParameter(valid_594982, JString, required = false,
                                 default = nil)
  if valid_594982 != nil:
    section.add "key", valid_594982
  var valid_594983 = query.getOrDefault("prettyPrint")
  valid_594983 = validateParameter(valid_594983, JBool, required = false,
                                 default = newJBool(true))
  if valid_594983 != nil:
    section.add "prettyPrint", valid_594983
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

proc call*(call_594985: Call_ContentOrdersUpdatelineitemshippingdetails_594972;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates ship by and delivery by dates for a line item.
  ## 
  let valid = call_594985.validator(path, query, header, formData, body)
  let scheme = call_594985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594985.url(scheme.get, call_594985.host, call_594985.base,
                         call_594985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594985, url, valid)

proc call*(call_594986: Call_ContentOrdersUpdatelineitemshippingdetails_594972;
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
  var path_594987 = newJObject()
  var query_594988 = newJObject()
  var body_594989 = newJObject()
  add(query_594988, "fields", newJString(fields))
  add(query_594988, "quotaUser", newJString(quotaUser))
  add(query_594988, "alt", newJString(alt))
  add(query_594988, "oauth_token", newJString(oauthToken))
  add(query_594988, "userIp", newJString(userIp))
  add(path_594987, "orderId", newJString(orderId))
  add(query_594988, "key", newJString(key))
  add(path_594987, "merchantId", newJString(merchantId))
  if body != nil:
    body_594989 = body
  add(query_594988, "prettyPrint", newJBool(prettyPrint))
  result = call_594986.call(path_594987, query_594988, nil, nil, body_594989)

var contentOrdersUpdatelineitemshippingdetails* = Call_ContentOrdersUpdatelineitemshippingdetails_594972(
    name: "contentOrdersUpdatelineitemshippingdetails", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateLineItemShippingDetails",
    validator: validate_ContentOrdersUpdatelineitemshippingdetails_594973,
    base: "/content/v2.1", url: url_ContentOrdersUpdatelineitemshippingdetails_594974,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdatemerchantorderid_594990 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersUpdatemerchantorderid_594992(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentOrdersUpdatemerchantorderid_594991(path: JsonNode;
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
  var valid_594993 = path.getOrDefault("orderId")
  valid_594993 = validateParameter(valid_594993, JString, required = true,
                                 default = nil)
  if valid_594993 != nil:
    section.add "orderId", valid_594993
  var valid_594994 = path.getOrDefault("merchantId")
  valid_594994 = validateParameter(valid_594994, JString, required = true,
                                 default = nil)
  if valid_594994 != nil:
    section.add "merchantId", valid_594994
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
  var valid_594995 = query.getOrDefault("fields")
  valid_594995 = validateParameter(valid_594995, JString, required = false,
                                 default = nil)
  if valid_594995 != nil:
    section.add "fields", valid_594995
  var valid_594996 = query.getOrDefault("quotaUser")
  valid_594996 = validateParameter(valid_594996, JString, required = false,
                                 default = nil)
  if valid_594996 != nil:
    section.add "quotaUser", valid_594996
  var valid_594997 = query.getOrDefault("alt")
  valid_594997 = validateParameter(valid_594997, JString, required = false,
                                 default = newJString("json"))
  if valid_594997 != nil:
    section.add "alt", valid_594997
  var valid_594998 = query.getOrDefault("oauth_token")
  valid_594998 = validateParameter(valid_594998, JString, required = false,
                                 default = nil)
  if valid_594998 != nil:
    section.add "oauth_token", valid_594998
  var valid_594999 = query.getOrDefault("userIp")
  valid_594999 = validateParameter(valid_594999, JString, required = false,
                                 default = nil)
  if valid_594999 != nil:
    section.add "userIp", valid_594999
  var valid_595000 = query.getOrDefault("key")
  valid_595000 = validateParameter(valid_595000, JString, required = false,
                                 default = nil)
  if valid_595000 != nil:
    section.add "key", valid_595000
  var valid_595001 = query.getOrDefault("prettyPrint")
  valid_595001 = validateParameter(valid_595001, JBool, required = false,
                                 default = newJBool(true))
  if valid_595001 != nil:
    section.add "prettyPrint", valid_595001
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

proc call*(call_595003: Call_ContentOrdersUpdatemerchantorderid_594990;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the merchant order ID for a given order.
  ## 
  let valid = call_595003.validator(path, query, header, formData, body)
  let scheme = call_595003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595003.url(scheme.get, call_595003.host, call_595003.base,
                         call_595003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595003, url, valid)

proc call*(call_595004: Call_ContentOrdersUpdatemerchantorderid_594990;
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
  var path_595005 = newJObject()
  var query_595006 = newJObject()
  var body_595007 = newJObject()
  add(query_595006, "fields", newJString(fields))
  add(query_595006, "quotaUser", newJString(quotaUser))
  add(query_595006, "alt", newJString(alt))
  add(query_595006, "oauth_token", newJString(oauthToken))
  add(query_595006, "userIp", newJString(userIp))
  add(path_595005, "orderId", newJString(orderId))
  add(query_595006, "key", newJString(key))
  add(path_595005, "merchantId", newJString(merchantId))
  if body != nil:
    body_595007 = body
  add(query_595006, "prettyPrint", newJBool(prettyPrint))
  result = call_595004.call(path_595005, query_595006, nil, nil, body_595007)

var contentOrdersUpdatemerchantorderid* = Call_ContentOrdersUpdatemerchantorderid_594990(
    name: "contentOrdersUpdatemerchantorderid", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateMerchantOrderId",
    validator: validate_ContentOrdersUpdatemerchantorderid_594991,
    base: "/content/v2.1", url: url_ContentOrdersUpdatemerchantorderid_594992,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdateshipment_595008 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersUpdateshipment_595010(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentOrdersUpdateshipment_595009(path: JsonNode; query: JsonNode;
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
  var valid_595011 = path.getOrDefault("orderId")
  valid_595011 = validateParameter(valid_595011, JString, required = true,
                                 default = nil)
  if valid_595011 != nil:
    section.add "orderId", valid_595011
  var valid_595012 = path.getOrDefault("merchantId")
  valid_595012 = validateParameter(valid_595012, JString, required = true,
                                 default = nil)
  if valid_595012 != nil:
    section.add "merchantId", valid_595012
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
  var valid_595013 = query.getOrDefault("fields")
  valid_595013 = validateParameter(valid_595013, JString, required = false,
                                 default = nil)
  if valid_595013 != nil:
    section.add "fields", valid_595013
  var valid_595014 = query.getOrDefault("quotaUser")
  valid_595014 = validateParameter(valid_595014, JString, required = false,
                                 default = nil)
  if valid_595014 != nil:
    section.add "quotaUser", valid_595014
  var valid_595015 = query.getOrDefault("alt")
  valid_595015 = validateParameter(valid_595015, JString, required = false,
                                 default = newJString("json"))
  if valid_595015 != nil:
    section.add "alt", valid_595015
  var valid_595016 = query.getOrDefault("oauth_token")
  valid_595016 = validateParameter(valid_595016, JString, required = false,
                                 default = nil)
  if valid_595016 != nil:
    section.add "oauth_token", valid_595016
  var valid_595017 = query.getOrDefault("userIp")
  valid_595017 = validateParameter(valid_595017, JString, required = false,
                                 default = nil)
  if valid_595017 != nil:
    section.add "userIp", valid_595017
  var valid_595018 = query.getOrDefault("key")
  valid_595018 = validateParameter(valid_595018, JString, required = false,
                                 default = nil)
  if valid_595018 != nil:
    section.add "key", valid_595018
  var valid_595019 = query.getOrDefault("prettyPrint")
  valid_595019 = validateParameter(valid_595019, JBool, required = false,
                                 default = newJBool(true))
  if valid_595019 != nil:
    section.add "prettyPrint", valid_595019
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

proc call*(call_595021: Call_ContentOrdersUpdateshipment_595008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a shipment's status, carrier, and/or tracking ID.
  ## 
  let valid = call_595021.validator(path, query, header, formData, body)
  let scheme = call_595021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595021.url(scheme.get, call_595021.host, call_595021.base,
                         call_595021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595021, url, valid)

proc call*(call_595022: Call_ContentOrdersUpdateshipment_595008; orderId: string;
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
  var path_595023 = newJObject()
  var query_595024 = newJObject()
  var body_595025 = newJObject()
  add(query_595024, "fields", newJString(fields))
  add(query_595024, "quotaUser", newJString(quotaUser))
  add(query_595024, "alt", newJString(alt))
  add(query_595024, "oauth_token", newJString(oauthToken))
  add(query_595024, "userIp", newJString(userIp))
  add(path_595023, "orderId", newJString(orderId))
  add(query_595024, "key", newJString(key))
  add(path_595023, "merchantId", newJString(merchantId))
  if body != nil:
    body_595025 = body
  add(query_595024, "prettyPrint", newJBool(prettyPrint))
  result = call_595022.call(path_595023, query_595024, nil, nil, body_595025)

var contentOrdersUpdateshipment* = Call_ContentOrdersUpdateshipment_595008(
    name: "contentOrdersUpdateshipment", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateShipment",
    validator: validate_ContentOrdersUpdateshipment_595009, base: "/content/v2.1",
    url: url_ContentOrdersUpdateshipment_595010, schemes: {Scheme.Https})
type
  Call_ContentOrdersGetbymerchantorderid_595026 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersGetbymerchantorderid_595028(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentOrdersGetbymerchantorderid_595027(path: JsonNode;
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
  var valid_595029 = path.getOrDefault("merchantOrderId")
  valid_595029 = validateParameter(valid_595029, JString, required = true,
                                 default = nil)
  if valid_595029 != nil:
    section.add "merchantOrderId", valid_595029
  var valid_595030 = path.getOrDefault("merchantId")
  valid_595030 = validateParameter(valid_595030, JString, required = true,
                                 default = nil)
  if valid_595030 != nil:
    section.add "merchantId", valid_595030
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
  var valid_595031 = query.getOrDefault("fields")
  valid_595031 = validateParameter(valid_595031, JString, required = false,
                                 default = nil)
  if valid_595031 != nil:
    section.add "fields", valid_595031
  var valid_595032 = query.getOrDefault("quotaUser")
  valid_595032 = validateParameter(valid_595032, JString, required = false,
                                 default = nil)
  if valid_595032 != nil:
    section.add "quotaUser", valid_595032
  var valid_595033 = query.getOrDefault("alt")
  valid_595033 = validateParameter(valid_595033, JString, required = false,
                                 default = newJString("json"))
  if valid_595033 != nil:
    section.add "alt", valid_595033
  var valid_595034 = query.getOrDefault("oauth_token")
  valid_595034 = validateParameter(valid_595034, JString, required = false,
                                 default = nil)
  if valid_595034 != nil:
    section.add "oauth_token", valid_595034
  var valid_595035 = query.getOrDefault("userIp")
  valid_595035 = validateParameter(valid_595035, JString, required = false,
                                 default = nil)
  if valid_595035 != nil:
    section.add "userIp", valid_595035
  var valid_595036 = query.getOrDefault("key")
  valid_595036 = validateParameter(valid_595036, JString, required = false,
                                 default = nil)
  if valid_595036 != nil:
    section.add "key", valid_595036
  var valid_595037 = query.getOrDefault("prettyPrint")
  valid_595037 = validateParameter(valid_595037, JBool, required = false,
                                 default = newJBool(true))
  if valid_595037 != nil:
    section.add "prettyPrint", valid_595037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595038: Call_ContentOrdersGetbymerchantorderid_595026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves an order using merchant order ID.
  ## 
  let valid = call_595038.validator(path, query, header, formData, body)
  let scheme = call_595038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595038.url(scheme.get, call_595038.host, call_595038.base,
                         call_595038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595038, url, valid)

proc call*(call_595039: Call_ContentOrdersGetbymerchantorderid_595026;
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
  var path_595040 = newJObject()
  var query_595041 = newJObject()
  add(query_595041, "fields", newJString(fields))
  add(query_595041, "quotaUser", newJString(quotaUser))
  add(query_595041, "alt", newJString(alt))
  add(query_595041, "oauth_token", newJString(oauthToken))
  add(query_595041, "userIp", newJString(userIp))
  add(query_595041, "key", newJString(key))
  add(path_595040, "merchantOrderId", newJString(merchantOrderId))
  add(path_595040, "merchantId", newJString(merchantId))
  add(query_595041, "prettyPrint", newJBool(prettyPrint))
  result = call_595039.call(path_595040, query_595041, nil, nil, nil)

var contentOrdersGetbymerchantorderid* = Call_ContentOrdersGetbymerchantorderid_595026(
    name: "contentOrdersGetbymerchantorderid", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/ordersbymerchantid/{merchantOrderId}",
    validator: validate_ContentOrdersGetbymerchantorderid_595027,
    base: "/content/v2.1", url: url_ContentOrdersGetbymerchantorderid_595028,
    schemes: {Scheme.Https})
type
  Call_ContentPosInventory_595042 = ref object of OpenApiRestCall_593421
proc url_ContentPosInventory_595044(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentPosInventory_595043(path: JsonNode; query: JsonNode;
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
  var valid_595045 = path.getOrDefault("targetMerchantId")
  valid_595045 = validateParameter(valid_595045, JString, required = true,
                                 default = nil)
  if valid_595045 != nil:
    section.add "targetMerchantId", valid_595045
  var valid_595046 = path.getOrDefault("merchantId")
  valid_595046 = validateParameter(valid_595046, JString, required = true,
                                 default = nil)
  if valid_595046 != nil:
    section.add "merchantId", valid_595046
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
  var valid_595047 = query.getOrDefault("fields")
  valid_595047 = validateParameter(valid_595047, JString, required = false,
                                 default = nil)
  if valid_595047 != nil:
    section.add "fields", valid_595047
  var valid_595048 = query.getOrDefault("quotaUser")
  valid_595048 = validateParameter(valid_595048, JString, required = false,
                                 default = nil)
  if valid_595048 != nil:
    section.add "quotaUser", valid_595048
  var valid_595049 = query.getOrDefault("alt")
  valid_595049 = validateParameter(valid_595049, JString, required = false,
                                 default = newJString("json"))
  if valid_595049 != nil:
    section.add "alt", valid_595049
  var valid_595050 = query.getOrDefault("oauth_token")
  valid_595050 = validateParameter(valid_595050, JString, required = false,
                                 default = nil)
  if valid_595050 != nil:
    section.add "oauth_token", valid_595050
  var valid_595051 = query.getOrDefault("userIp")
  valid_595051 = validateParameter(valid_595051, JString, required = false,
                                 default = nil)
  if valid_595051 != nil:
    section.add "userIp", valid_595051
  var valid_595052 = query.getOrDefault("key")
  valid_595052 = validateParameter(valid_595052, JString, required = false,
                                 default = nil)
  if valid_595052 != nil:
    section.add "key", valid_595052
  var valid_595053 = query.getOrDefault("prettyPrint")
  valid_595053 = validateParameter(valid_595053, JBool, required = false,
                                 default = newJBool(true))
  if valid_595053 != nil:
    section.add "prettyPrint", valid_595053
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

proc call*(call_595055: Call_ContentPosInventory_595042; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit inventory for the given merchant.
  ## 
  let valid = call_595055.validator(path, query, header, formData, body)
  let scheme = call_595055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595055.url(scheme.get, call_595055.host, call_595055.base,
                         call_595055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595055, url, valid)

proc call*(call_595056: Call_ContentPosInventory_595042; targetMerchantId: string;
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
  var path_595057 = newJObject()
  var query_595058 = newJObject()
  var body_595059 = newJObject()
  add(query_595058, "fields", newJString(fields))
  add(query_595058, "quotaUser", newJString(quotaUser))
  add(query_595058, "alt", newJString(alt))
  add(path_595057, "targetMerchantId", newJString(targetMerchantId))
  add(query_595058, "oauth_token", newJString(oauthToken))
  add(query_595058, "userIp", newJString(userIp))
  add(query_595058, "key", newJString(key))
  add(path_595057, "merchantId", newJString(merchantId))
  if body != nil:
    body_595059 = body
  add(query_595058, "prettyPrint", newJBool(prettyPrint))
  result = call_595056.call(path_595057, query_595058, nil, nil, body_595059)

var contentPosInventory* = Call_ContentPosInventory_595042(
    name: "contentPosInventory", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/inventory",
    validator: validate_ContentPosInventory_595043, base: "/content/v2.1",
    url: url_ContentPosInventory_595044, schemes: {Scheme.Https})
type
  Call_ContentPosSale_595060 = ref object of OpenApiRestCall_593421
proc url_ContentPosSale_595062(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentPosSale_595061(path: JsonNode; query: JsonNode;
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
  var valid_595063 = path.getOrDefault("targetMerchantId")
  valid_595063 = validateParameter(valid_595063, JString, required = true,
                                 default = nil)
  if valid_595063 != nil:
    section.add "targetMerchantId", valid_595063
  var valid_595064 = path.getOrDefault("merchantId")
  valid_595064 = validateParameter(valid_595064, JString, required = true,
                                 default = nil)
  if valid_595064 != nil:
    section.add "merchantId", valid_595064
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
  var valid_595065 = query.getOrDefault("fields")
  valid_595065 = validateParameter(valid_595065, JString, required = false,
                                 default = nil)
  if valid_595065 != nil:
    section.add "fields", valid_595065
  var valid_595066 = query.getOrDefault("quotaUser")
  valid_595066 = validateParameter(valid_595066, JString, required = false,
                                 default = nil)
  if valid_595066 != nil:
    section.add "quotaUser", valid_595066
  var valid_595067 = query.getOrDefault("alt")
  valid_595067 = validateParameter(valid_595067, JString, required = false,
                                 default = newJString("json"))
  if valid_595067 != nil:
    section.add "alt", valid_595067
  var valid_595068 = query.getOrDefault("oauth_token")
  valid_595068 = validateParameter(valid_595068, JString, required = false,
                                 default = nil)
  if valid_595068 != nil:
    section.add "oauth_token", valid_595068
  var valid_595069 = query.getOrDefault("userIp")
  valid_595069 = validateParameter(valid_595069, JString, required = false,
                                 default = nil)
  if valid_595069 != nil:
    section.add "userIp", valid_595069
  var valid_595070 = query.getOrDefault("key")
  valid_595070 = validateParameter(valid_595070, JString, required = false,
                                 default = nil)
  if valid_595070 != nil:
    section.add "key", valid_595070
  var valid_595071 = query.getOrDefault("prettyPrint")
  valid_595071 = validateParameter(valid_595071, JBool, required = false,
                                 default = newJBool(true))
  if valid_595071 != nil:
    section.add "prettyPrint", valid_595071
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

proc call*(call_595073: Call_ContentPosSale_595060; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit a sale event for the given merchant.
  ## 
  let valid = call_595073.validator(path, query, header, formData, body)
  let scheme = call_595073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595073.url(scheme.get, call_595073.host, call_595073.base,
                         call_595073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595073, url, valid)

proc call*(call_595074: Call_ContentPosSale_595060; targetMerchantId: string;
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
  var path_595075 = newJObject()
  var query_595076 = newJObject()
  var body_595077 = newJObject()
  add(query_595076, "fields", newJString(fields))
  add(query_595076, "quotaUser", newJString(quotaUser))
  add(query_595076, "alt", newJString(alt))
  add(path_595075, "targetMerchantId", newJString(targetMerchantId))
  add(query_595076, "oauth_token", newJString(oauthToken))
  add(query_595076, "userIp", newJString(userIp))
  add(query_595076, "key", newJString(key))
  add(path_595075, "merchantId", newJString(merchantId))
  if body != nil:
    body_595077 = body
  add(query_595076, "prettyPrint", newJBool(prettyPrint))
  result = call_595074.call(path_595075, query_595076, nil, nil, body_595077)

var contentPosSale* = Call_ContentPosSale_595060(name: "contentPosSale",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/sale",
    validator: validate_ContentPosSale_595061, base: "/content/v2.1",
    url: url_ContentPosSale_595062, schemes: {Scheme.Https})
type
  Call_ContentPosInsert_595094 = ref object of OpenApiRestCall_593421
proc url_ContentPosInsert_595096(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentPosInsert_595095(path: JsonNode; query: JsonNode;
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
  var valid_595097 = path.getOrDefault("targetMerchantId")
  valid_595097 = validateParameter(valid_595097, JString, required = true,
                                 default = nil)
  if valid_595097 != nil:
    section.add "targetMerchantId", valid_595097
  var valid_595098 = path.getOrDefault("merchantId")
  valid_595098 = validateParameter(valid_595098, JString, required = true,
                                 default = nil)
  if valid_595098 != nil:
    section.add "merchantId", valid_595098
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
  var valid_595099 = query.getOrDefault("fields")
  valid_595099 = validateParameter(valid_595099, JString, required = false,
                                 default = nil)
  if valid_595099 != nil:
    section.add "fields", valid_595099
  var valid_595100 = query.getOrDefault("quotaUser")
  valid_595100 = validateParameter(valid_595100, JString, required = false,
                                 default = nil)
  if valid_595100 != nil:
    section.add "quotaUser", valid_595100
  var valid_595101 = query.getOrDefault("alt")
  valid_595101 = validateParameter(valid_595101, JString, required = false,
                                 default = newJString("json"))
  if valid_595101 != nil:
    section.add "alt", valid_595101
  var valid_595102 = query.getOrDefault("oauth_token")
  valid_595102 = validateParameter(valid_595102, JString, required = false,
                                 default = nil)
  if valid_595102 != nil:
    section.add "oauth_token", valid_595102
  var valid_595103 = query.getOrDefault("userIp")
  valid_595103 = validateParameter(valid_595103, JString, required = false,
                                 default = nil)
  if valid_595103 != nil:
    section.add "userIp", valid_595103
  var valid_595104 = query.getOrDefault("key")
  valid_595104 = validateParameter(valid_595104, JString, required = false,
                                 default = nil)
  if valid_595104 != nil:
    section.add "key", valid_595104
  var valid_595105 = query.getOrDefault("prettyPrint")
  valid_595105 = validateParameter(valid_595105, JBool, required = false,
                                 default = newJBool(true))
  if valid_595105 != nil:
    section.add "prettyPrint", valid_595105
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

proc call*(call_595107: Call_ContentPosInsert_595094; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a store for the given merchant.
  ## 
  let valid = call_595107.validator(path, query, header, formData, body)
  let scheme = call_595107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595107.url(scheme.get, call_595107.host, call_595107.base,
                         call_595107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595107, url, valid)

proc call*(call_595108: Call_ContentPosInsert_595094; targetMerchantId: string;
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
  var path_595109 = newJObject()
  var query_595110 = newJObject()
  var body_595111 = newJObject()
  add(query_595110, "fields", newJString(fields))
  add(query_595110, "quotaUser", newJString(quotaUser))
  add(query_595110, "alt", newJString(alt))
  add(path_595109, "targetMerchantId", newJString(targetMerchantId))
  add(query_595110, "oauth_token", newJString(oauthToken))
  add(query_595110, "userIp", newJString(userIp))
  add(query_595110, "key", newJString(key))
  add(path_595109, "merchantId", newJString(merchantId))
  if body != nil:
    body_595111 = body
  add(query_595110, "prettyPrint", newJBool(prettyPrint))
  result = call_595108.call(path_595109, query_595110, nil, nil, body_595111)

var contentPosInsert* = Call_ContentPosInsert_595094(name: "contentPosInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store",
    validator: validate_ContentPosInsert_595095, base: "/content/v2.1",
    url: url_ContentPosInsert_595096, schemes: {Scheme.Https})
type
  Call_ContentPosList_595078 = ref object of OpenApiRestCall_593421
proc url_ContentPosList_595080(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentPosList_595079(path: JsonNode; query: JsonNode;
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
  var valid_595081 = path.getOrDefault("targetMerchantId")
  valid_595081 = validateParameter(valid_595081, JString, required = true,
                                 default = nil)
  if valid_595081 != nil:
    section.add "targetMerchantId", valid_595081
  var valid_595082 = path.getOrDefault("merchantId")
  valid_595082 = validateParameter(valid_595082, JString, required = true,
                                 default = nil)
  if valid_595082 != nil:
    section.add "merchantId", valid_595082
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
  var valid_595083 = query.getOrDefault("fields")
  valid_595083 = validateParameter(valid_595083, JString, required = false,
                                 default = nil)
  if valid_595083 != nil:
    section.add "fields", valid_595083
  var valid_595084 = query.getOrDefault("quotaUser")
  valid_595084 = validateParameter(valid_595084, JString, required = false,
                                 default = nil)
  if valid_595084 != nil:
    section.add "quotaUser", valid_595084
  var valid_595085 = query.getOrDefault("alt")
  valid_595085 = validateParameter(valid_595085, JString, required = false,
                                 default = newJString("json"))
  if valid_595085 != nil:
    section.add "alt", valid_595085
  var valid_595086 = query.getOrDefault("oauth_token")
  valid_595086 = validateParameter(valid_595086, JString, required = false,
                                 default = nil)
  if valid_595086 != nil:
    section.add "oauth_token", valid_595086
  var valid_595087 = query.getOrDefault("userIp")
  valid_595087 = validateParameter(valid_595087, JString, required = false,
                                 default = nil)
  if valid_595087 != nil:
    section.add "userIp", valid_595087
  var valid_595088 = query.getOrDefault("key")
  valid_595088 = validateParameter(valid_595088, JString, required = false,
                                 default = nil)
  if valid_595088 != nil:
    section.add "key", valid_595088
  var valid_595089 = query.getOrDefault("prettyPrint")
  valid_595089 = validateParameter(valid_595089, JBool, required = false,
                                 default = newJBool(true))
  if valid_595089 != nil:
    section.add "prettyPrint", valid_595089
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595090: Call_ContentPosList_595078; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the stores of the target merchant.
  ## 
  let valid = call_595090.validator(path, query, header, formData, body)
  let scheme = call_595090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595090.url(scheme.get, call_595090.host, call_595090.base,
                         call_595090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595090, url, valid)

proc call*(call_595091: Call_ContentPosList_595078; targetMerchantId: string;
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
  var path_595092 = newJObject()
  var query_595093 = newJObject()
  add(query_595093, "fields", newJString(fields))
  add(query_595093, "quotaUser", newJString(quotaUser))
  add(query_595093, "alt", newJString(alt))
  add(path_595092, "targetMerchantId", newJString(targetMerchantId))
  add(query_595093, "oauth_token", newJString(oauthToken))
  add(query_595093, "userIp", newJString(userIp))
  add(query_595093, "key", newJString(key))
  add(path_595092, "merchantId", newJString(merchantId))
  add(query_595093, "prettyPrint", newJBool(prettyPrint))
  result = call_595091.call(path_595092, query_595093, nil, nil, nil)

var contentPosList* = Call_ContentPosList_595078(name: "contentPosList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store",
    validator: validate_ContentPosList_595079, base: "/content/v2.1",
    url: url_ContentPosList_595080, schemes: {Scheme.Https})
type
  Call_ContentPosGet_595112 = ref object of OpenApiRestCall_593421
proc url_ContentPosGet_595114(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentPosGet_595113(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_595115 = path.getOrDefault("targetMerchantId")
  valid_595115 = validateParameter(valid_595115, JString, required = true,
                                 default = nil)
  if valid_595115 != nil:
    section.add "targetMerchantId", valid_595115
  var valid_595116 = path.getOrDefault("storeCode")
  valid_595116 = validateParameter(valid_595116, JString, required = true,
                                 default = nil)
  if valid_595116 != nil:
    section.add "storeCode", valid_595116
  var valid_595117 = path.getOrDefault("merchantId")
  valid_595117 = validateParameter(valid_595117, JString, required = true,
                                 default = nil)
  if valid_595117 != nil:
    section.add "merchantId", valid_595117
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
  var valid_595118 = query.getOrDefault("fields")
  valid_595118 = validateParameter(valid_595118, JString, required = false,
                                 default = nil)
  if valid_595118 != nil:
    section.add "fields", valid_595118
  var valid_595119 = query.getOrDefault("quotaUser")
  valid_595119 = validateParameter(valid_595119, JString, required = false,
                                 default = nil)
  if valid_595119 != nil:
    section.add "quotaUser", valid_595119
  var valid_595120 = query.getOrDefault("alt")
  valid_595120 = validateParameter(valid_595120, JString, required = false,
                                 default = newJString("json"))
  if valid_595120 != nil:
    section.add "alt", valid_595120
  var valid_595121 = query.getOrDefault("oauth_token")
  valid_595121 = validateParameter(valid_595121, JString, required = false,
                                 default = nil)
  if valid_595121 != nil:
    section.add "oauth_token", valid_595121
  var valid_595122 = query.getOrDefault("userIp")
  valid_595122 = validateParameter(valid_595122, JString, required = false,
                                 default = nil)
  if valid_595122 != nil:
    section.add "userIp", valid_595122
  var valid_595123 = query.getOrDefault("key")
  valid_595123 = validateParameter(valid_595123, JString, required = false,
                                 default = nil)
  if valid_595123 != nil:
    section.add "key", valid_595123
  var valid_595124 = query.getOrDefault("prettyPrint")
  valid_595124 = validateParameter(valid_595124, JBool, required = false,
                                 default = newJBool(true))
  if valid_595124 != nil:
    section.add "prettyPrint", valid_595124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595125: Call_ContentPosGet_595112; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about the given store.
  ## 
  let valid = call_595125.validator(path, query, header, formData, body)
  let scheme = call_595125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595125.url(scheme.get, call_595125.host, call_595125.base,
                         call_595125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595125, url, valid)

proc call*(call_595126: Call_ContentPosGet_595112; targetMerchantId: string;
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
  var path_595127 = newJObject()
  var query_595128 = newJObject()
  add(query_595128, "fields", newJString(fields))
  add(query_595128, "quotaUser", newJString(quotaUser))
  add(query_595128, "alt", newJString(alt))
  add(path_595127, "targetMerchantId", newJString(targetMerchantId))
  add(query_595128, "oauth_token", newJString(oauthToken))
  add(path_595127, "storeCode", newJString(storeCode))
  add(query_595128, "userIp", newJString(userIp))
  add(query_595128, "key", newJString(key))
  add(path_595127, "merchantId", newJString(merchantId))
  add(query_595128, "prettyPrint", newJBool(prettyPrint))
  result = call_595126.call(path_595127, query_595128, nil, nil, nil)

var contentPosGet* = Call_ContentPosGet_595112(name: "contentPosGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store/{storeCode}",
    validator: validate_ContentPosGet_595113, base: "/content/v2.1",
    url: url_ContentPosGet_595114, schemes: {Scheme.Https})
type
  Call_ContentPosDelete_595129 = ref object of OpenApiRestCall_593421
proc url_ContentPosDelete_595131(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentPosDelete_595130(path: JsonNode; query: JsonNode;
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
  var valid_595132 = path.getOrDefault("targetMerchantId")
  valid_595132 = validateParameter(valid_595132, JString, required = true,
                                 default = nil)
  if valid_595132 != nil:
    section.add "targetMerchantId", valid_595132
  var valid_595133 = path.getOrDefault("storeCode")
  valid_595133 = validateParameter(valid_595133, JString, required = true,
                                 default = nil)
  if valid_595133 != nil:
    section.add "storeCode", valid_595133
  var valid_595134 = path.getOrDefault("merchantId")
  valid_595134 = validateParameter(valid_595134, JString, required = true,
                                 default = nil)
  if valid_595134 != nil:
    section.add "merchantId", valid_595134
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
  var valid_595135 = query.getOrDefault("fields")
  valid_595135 = validateParameter(valid_595135, JString, required = false,
                                 default = nil)
  if valid_595135 != nil:
    section.add "fields", valid_595135
  var valid_595136 = query.getOrDefault("quotaUser")
  valid_595136 = validateParameter(valid_595136, JString, required = false,
                                 default = nil)
  if valid_595136 != nil:
    section.add "quotaUser", valid_595136
  var valid_595137 = query.getOrDefault("alt")
  valid_595137 = validateParameter(valid_595137, JString, required = false,
                                 default = newJString("json"))
  if valid_595137 != nil:
    section.add "alt", valid_595137
  var valid_595138 = query.getOrDefault("oauth_token")
  valid_595138 = validateParameter(valid_595138, JString, required = false,
                                 default = nil)
  if valid_595138 != nil:
    section.add "oauth_token", valid_595138
  var valid_595139 = query.getOrDefault("userIp")
  valid_595139 = validateParameter(valid_595139, JString, required = false,
                                 default = nil)
  if valid_595139 != nil:
    section.add "userIp", valid_595139
  var valid_595140 = query.getOrDefault("key")
  valid_595140 = validateParameter(valid_595140, JString, required = false,
                                 default = nil)
  if valid_595140 != nil:
    section.add "key", valid_595140
  var valid_595141 = query.getOrDefault("prettyPrint")
  valid_595141 = validateParameter(valid_595141, JBool, required = false,
                                 default = newJBool(true))
  if valid_595141 != nil:
    section.add "prettyPrint", valid_595141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595142: Call_ContentPosDelete_595129; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a store for the given merchant.
  ## 
  let valid = call_595142.validator(path, query, header, formData, body)
  let scheme = call_595142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595142.url(scheme.get, call_595142.host, call_595142.base,
                         call_595142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595142, url, valid)

proc call*(call_595143: Call_ContentPosDelete_595129; targetMerchantId: string;
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
  var path_595144 = newJObject()
  var query_595145 = newJObject()
  add(query_595145, "fields", newJString(fields))
  add(query_595145, "quotaUser", newJString(quotaUser))
  add(query_595145, "alt", newJString(alt))
  add(path_595144, "targetMerchantId", newJString(targetMerchantId))
  add(query_595145, "oauth_token", newJString(oauthToken))
  add(path_595144, "storeCode", newJString(storeCode))
  add(query_595145, "userIp", newJString(userIp))
  add(query_595145, "key", newJString(key))
  add(path_595144, "merchantId", newJString(merchantId))
  add(query_595145, "prettyPrint", newJBool(prettyPrint))
  result = call_595143.call(path_595144, query_595145, nil, nil, nil)

var contentPosDelete* = Call_ContentPosDelete_595129(name: "contentPosDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store/{storeCode}",
    validator: validate_ContentPosDelete_595130, base: "/content/v2.1",
    url: url_ContentPosDelete_595131, schemes: {Scheme.Https})
type
  Call_ContentProductsInsert_595163 = ref object of OpenApiRestCall_593421
proc url_ContentProductsInsert_595165(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentProductsInsert_595164(path: JsonNode; query: JsonNode;
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
  var valid_595166 = path.getOrDefault("merchantId")
  valid_595166 = validateParameter(valid_595166, JString, required = true,
                                 default = nil)
  if valid_595166 != nil:
    section.add "merchantId", valid_595166
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
  var valid_595167 = query.getOrDefault("fields")
  valid_595167 = validateParameter(valid_595167, JString, required = false,
                                 default = nil)
  if valid_595167 != nil:
    section.add "fields", valid_595167
  var valid_595168 = query.getOrDefault("quotaUser")
  valid_595168 = validateParameter(valid_595168, JString, required = false,
                                 default = nil)
  if valid_595168 != nil:
    section.add "quotaUser", valid_595168
  var valid_595169 = query.getOrDefault("alt")
  valid_595169 = validateParameter(valid_595169, JString, required = false,
                                 default = newJString("json"))
  if valid_595169 != nil:
    section.add "alt", valid_595169
  var valid_595170 = query.getOrDefault("feedId")
  valid_595170 = validateParameter(valid_595170, JString, required = false,
                                 default = nil)
  if valid_595170 != nil:
    section.add "feedId", valid_595170
  var valid_595171 = query.getOrDefault("oauth_token")
  valid_595171 = validateParameter(valid_595171, JString, required = false,
                                 default = nil)
  if valid_595171 != nil:
    section.add "oauth_token", valid_595171
  var valid_595172 = query.getOrDefault("userIp")
  valid_595172 = validateParameter(valid_595172, JString, required = false,
                                 default = nil)
  if valid_595172 != nil:
    section.add "userIp", valid_595172
  var valid_595173 = query.getOrDefault("key")
  valid_595173 = validateParameter(valid_595173, JString, required = false,
                                 default = nil)
  if valid_595173 != nil:
    section.add "key", valid_595173
  var valid_595174 = query.getOrDefault("prettyPrint")
  valid_595174 = validateParameter(valid_595174, JBool, required = false,
                                 default = newJBool(true))
  if valid_595174 != nil:
    section.add "prettyPrint", valid_595174
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

proc call*(call_595176: Call_ContentProductsInsert_595163; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a product to your Merchant Center account. If an item with the same channel, contentLanguage, offerId, and targetCountry already exists, this method updates that entry.
  ## 
  let valid = call_595176.validator(path, query, header, formData, body)
  let scheme = call_595176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595176.url(scheme.get, call_595176.host, call_595176.base,
                         call_595176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595176, url, valid)

proc call*(call_595177: Call_ContentProductsInsert_595163; merchantId: string;
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
  var path_595178 = newJObject()
  var query_595179 = newJObject()
  var body_595180 = newJObject()
  add(query_595179, "fields", newJString(fields))
  add(query_595179, "quotaUser", newJString(quotaUser))
  add(query_595179, "alt", newJString(alt))
  add(query_595179, "feedId", newJString(feedId))
  add(query_595179, "oauth_token", newJString(oauthToken))
  add(query_595179, "userIp", newJString(userIp))
  add(query_595179, "key", newJString(key))
  add(path_595178, "merchantId", newJString(merchantId))
  if body != nil:
    body_595180 = body
  add(query_595179, "prettyPrint", newJBool(prettyPrint))
  result = call_595177.call(path_595178, query_595179, nil, nil, body_595180)

var contentProductsInsert* = Call_ContentProductsInsert_595163(
    name: "contentProductsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/products",
    validator: validate_ContentProductsInsert_595164, base: "/content/v2.1",
    url: url_ContentProductsInsert_595165, schemes: {Scheme.Https})
type
  Call_ContentProductsList_595146 = ref object of OpenApiRestCall_593421
proc url_ContentProductsList_595148(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentProductsList_595147(path: JsonNode; query: JsonNode;
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
  var valid_595149 = path.getOrDefault("merchantId")
  valid_595149 = validateParameter(valid_595149, JString, required = true,
                                 default = nil)
  if valid_595149 != nil:
    section.add "merchantId", valid_595149
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
  var valid_595150 = query.getOrDefault("fields")
  valid_595150 = validateParameter(valid_595150, JString, required = false,
                                 default = nil)
  if valid_595150 != nil:
    section.add "fields", valid_595150
  var valid_595151 = query.getOrDefault("pageToken")
  valid_595151 = validateParameter(valid_595151, JString, required = false,
                                 default = nil)
  if valid_595151 != nil:
    section.add "pageToken", valid_595151
  var valid_595152 = query.getOrDefault("quotaUser")
  valid_595152 = validateParameter(valid_595152, JString, required = false,
                                 default = nil)
  if valid_595152 != nil:
    section.add "quotaUser", valid_595152
  var valid_595153 = query.getOrDefault("alt")
  valid_595153 = validateParameter(valid_595153, JString, required = false,
                                 default = newJString("json"))
  if valid_595153 != nil:
    section.add "alt", valid_595153
  var valid_595154 = query.getOrDefault("oauth_token")
  valid_595154 = validateParameter(valid_595154, JString, required = false,
                                 default = nil)
  if valid_595154 != nil:
    section.add "oauth_token", valid_595154
  var valid_595155 = query.getOrDefault("userIp")
  valid_595155 = validateParameter(valid_595155, JString, required = false,
                                 default = nil)
  if valid_595155 != nil:
    section.add "userIp", valid_595155
  var valid_595156 = query.getOrDefault("maxResults")
  valid_595156 = validateParameter(valid_595156, JInt, required = false, default = nil)
  if valid_595156 != nil:
    section.add "maxResults", valid_595156
  var valid_595157 = query.getOrDefault("key")
  valid_595157 = validateParameter(valid_595157, JString, required = false,
                                 default = nil)
  if valid_595157 != nil:
    section.add "key", valid_595157
  var valid_595158 = query.getOrDefault("prettyPrint")
  valid_595158 = validateParameter(valid_595158, JBool, required = false,
                                 default = newJBool(true))
  if valid_595158 != nil:
    section.add "prettyPrint", valid_595158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595159: Call_ContentProductsList_595146; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the products in your Merchant Center account.
  ## 
  let valid = call_595159.validator(path, query, header, formData, body)
  let scheme = call_595159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595159.url(scheme.get, call_595159.host, call_595159.base,
                         call_595159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595159, url, valid)

proc call*(call_595160: Call_ContentProductsList_595146; merchantId: string;
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
  var path_595161 = newJObject()
  var query_595162 = newJObject()
  add(query_595162, "fields", newJString(fields))
  add(query_595162, "pageToken", newJString(pageToken))
  add(query_595162, "quotaUser", newJString(quotaUser))
  add(query_595162, "alt", newJString(alt))
  add(query_595162, "oauth_token", newJString(oauthToken))
  add(query_595162, "userIp", newJString(userIp))
  add(query_595162, "maxResults", newJInt(maxResults))
  add(query_595162, "key", newJString(key))
  add(path_595161, "merchantId", newJString(merchantId))
  add(query_595162, "prettyPrint", newJBool(prettyPrint))
  result = call_595160.call(path_595161, query_595162, nil, nil, nil)

var contentProductsList* = Call_ContentProductsList_595146(
    name: "contentProductsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/products",
    validator: validate_ContentProductsList_595147, base: "/content/v2.1",
    url: url_ContentProductsList_595148, schemes: {Scheme.Https})
type
  Call_ContentProductsGet_595181 = ref object of OpenApiRestCall_593421
proc url_ContentProductsGet_595183(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentProductsGet_595182(path: JsonNode; query: JsonNode;
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
  var valid_595184 = path.getOrDefault("merchantId")
  valid_595184 = validateParameter(valid_595184, JString, required = true,
                                 default = nil)
  if valid_595184 != nil:
    section.add "merchantId", valid_595184
  var valid_595185 = path.getOrDefault("productId")
  valid_595185 = validateParameter(valid_595185, JString, required = true,
                                 default = nil)
  if valid_595185 != nil:
    section.add "productId", valid_595185
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
  var valid_595186 = query.getOrDefault("fields")
  valid_595186 = validateParameter(valid_595186, JString, required = false,
                                 default = nil)
  if valid_595186 != nil:
    section.add "fields", valid_595186
  var valid_595187 = query.getOrDefault("quotaUser")
  valid_595187 = validateParameter(valid_595187, JString, required = false,
                                 default = nil)
  if valid_595187 != nil:
    section.add "quotaUser", valid_595187
  var valid_595188 = query.getOrDefault("alt")
  valid_595188 = validateParameter(valid_595188, JString, required = false,
                                 default = newJString("json"))
  if valid_595188 != nil:
    section.add "alt", valid_595188
  var valid_595189 = query.getOrDefault("oauth_token")
  valid_595189 = validateParameter(valid_595189, JString, required = false,
                                 default = nil)
  if valid_595189 != nil:
    section.add "oauth_token", valid_595189
  var valid_595190 = query.getOrDefault("userIp")
  valid_595190 = validateParameter(valid_595190, JString, required = false,
                                 default = nil)
  if valid_595190 != nil:
    section.add "userIp", valid_595190
  var valid_595191 = query.getOrDefault("key")
  valid_595191 = validateParameter(valid_595191, JString, required = false,
                                 default = nil)
  if valid_595191 != nil:
    section.add "key", valid_595191
  var valid_595192 = query.getOrDefault("prettyPrint")
  valid_595192 = validateParameter(valid_595192, JBool, required = false,
                                 default = newJBool(true))
  if valid_595192 != nil:
    section.add "prettyPrint", valid_595192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595193: Call_ContentProductsGet_595181; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a product from your Merchant Center account.
  ## 
  let valid = call_595193.validator(path, query, header, formData, body)
  let scheme = call_595193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595193.url(scheme.get, call_595193.host, call_595193.base,
                         call_595193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595193, url, valid)

proc call*(call_595194: Call_ContentProductsGet_595181; merchantId: string;
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
  var path_595195 = newJObject()
  var query_595196 = newJObject()
  add(query_595196, "fields", newJString(fields))
  add(query_595196, "quotaUser", newJString(quotaUser))
  add(query_595196, "alt", newJString(alt))
  add(query_595196, "oauth_token", newJString(oauthToken))
  add(query_595196, "userIp", newJString(userIp))
  add(query_595196, "key", newJString(key))
  add(path_595195, "merchantId", newJString(merchantId))
  add(path_595195, "productId", newJString(productId))
  add(query_595196, "prettyPrint", newJBool(prettyPrint))
  result = call_595194.call(path_595195, query_595196, nil, nil, nil)

var contentProductsGet* = Call_ContentProductsGet_595181(
    name: "contentProductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/products/{productId}",
    validator: validate_ContentProductsGet_595182, base: "/content/v2.1",
    url: url_ContentProductsGet_595183, schemes: {Scheme.Https})
type
  Call_ContentProductsDelete_595197 = ref object of OpenApiRestCall_593421
proc url_ContentProductsDelete_595199(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentProductsDelete_595198(path: JsonNode; query: JsonNode;
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
  var valid_595200 = path.getOrDefault("merchantId")
  valid_595200 = validateParameter(valid_595200, JString, required = true,
                                 default = nil)
  if valid_595200 != nil:
    section.add "merchantId", valid_595200
  var valid_595201 = path.getOrDefault("productId")
  valid_595201 = validateParameter(valid_595201, JString, required = true,
                                 default = nil)
  if valid_595201 != nil:
    section.add "productId", valid_595201
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
  var valid_595202 = query.getOrDefault("fields")
  valid_595202 = validateParameter(valid_595202, JString, required = false,
                                 default = nil)
  if valid_595202 != nil:
    section.add "fields", valid_595202
  var valid_595203 = query.getOrDefault("quotaUser")
  valid_595203 = validateParameter(valid_595203, JString, required = false,
                                 default = nil)
  if valid_595203 != nil:
    section.add "quotaUser", valid_595203
  var valid_595204 = query.getOrDefault("alt")
  valid_595204 = validateParameter(valid_595204, JString, required = false,
                                 default = newJString("json"))
  if valid_595204 != nil:
    section.add "alt", valid_595204
  var valid_595205 = query.getOrDefault("feedId")
  valid_595205 = validateParameter(valid_595205, JString, required = false,
                                 default = nil)
  if valid_595205 != nil:
    section.add "feedId", valid_595205
  var valid_595206 = query.getOrDefault("oauth_token")
  valid_595206 = validateParameter(valid_595206, JString, required = false,
                                 default = nil)
  if valid_595206 != nil:
    section.add "oauth_token", valid_595206
  var valid_595207 = query.getOrDefault("userIp")
  valid_595207 = validateParameter(valid_595207, JString, required = false,
                                 default = nil)
  if valid_595207 != nil:
    section.add "userIp", valid_595207
  var valid_595208 = query.getOrDefault("key")
  valid_595208 = validateParameter(valid_595208, JString, required = false,
                                 default = nil)
  if valid_595208 != nil:
    section.add "key", valid_595208
  var valid_595209 = query.getOrDefault("prettyPrint")
  valid_595209 = validateParameter(valid_595209, JBool, required = false,
                                 default = newJBool(true))
  if valid_595209 != nil:
    section.add "prettyPrint", valid_595209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595210: Call_ContentProductsDelete_595197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a product from your Merchant Center account.
  ## 
  let valid = call_595210.validator(path, query, header, formData, body)
  let scheme = call_595210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595210.url(scheme.get, call_595210.host, call_595210.base,
                         call_595210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595210, url, valid)

proc call*(call_595211: Call_ContentProductsDelete_595197; merchantId: string;
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
  var path_595212 = newJObject()
  var query_595213 = newJObject()
  add(query_595213, "fields", newJString(fields))
  add(query_595213, "quotaUser", newJString(quotaUser))
  add(query_595213, "alt", newJString(alt))
  add(query_595213, "feedId", newJString(feedId))
  add(query_595213, "oauth_token", newJString(oauthToken))
  add(query_595213, "userIp", newJString(userIp))
  add(query_595213, "key", newJString(key))
  add(path_595212, "merchantId", newJString(merchantId))
  add(path_595212, "productId", newJString(productId))
  add(query_595213, "prettyPrint", newJBool(prettyPrint))
  result = call_595211.call(path_595212, query_595213, nil, nil, nil)

var contentProductsDelete* = Call_ContentProductsDelete_595197(
    name: "contentProductsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/products/{productId}",
    validator: validate_ContentProductsDelete_595198, base: "/content/v2.1",
    url: url_ContentProductsDelete_595199, schemes: {Scheme.Https})
type
  Call_ContentRegionalinventoryInsert_595214 = ref object of OpenApiRestCall_593421
proc url_ContentRegionalinventoryInsert_595216(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentRegionalinventoryInsert_595215(path: JsonNode;
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
  var valid_595217 = path.getOrDefault("merchantId")
  valid_595217 = validateParameter(valid_595217, JString, required = true,
                                 default = nil)
  if valid_595217 != nil:
    section.add "merchantId", valid_595217
  var valid_595218 = path.getOrDefault("productId")
  valid_595218 = validateParameter(valid_595218, JString, required = true,
                                 default = nil)
  if valid_595218 != nil:
    section.add "productId", valid_595218
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
  var valid_595219 = query.getOrDefault("fields")
  valid_595219 = validateParameter(valid_595219, JString, required = false,
                                 default = nil)
  if valid_595219 != nil:
    section.add "fields", valid_595219
  var valid_595220 = query.getOrDefault("quotaUser")
  valid_595220 = validateParameter(valid_595220, JString, required = false,
                                 default = nil)
  if valid_595220 != nil:
    section.add "quotaUser", valid_595220
  var valid_595221 = query.getOrDefault("alt")
  valid_595221 = validateParameter(valid_595221, JString, required = false,
                                 default = newJString("json"))
  if valid_595221 != nil:
    section.add "alt", valid_595221
  var valid_595222 = query.getOrDefault("oauth_token")
  valid_595222 = validateParameter(valid_595222, JString, required = false,
                                 default = nil)
  if valid_595222 != nil:
    section.add "oauth_token", valid_595222
  var valid_595223 = query.getOrDefault("userIp")
  valid_595223 = validateParameter(valid_595223, JString, required = false,
                                 default = nil)
  if valid_595223 != nil:
    section.add "userIp", valid_595223
  var valid_595224 = query.getOrDefault("key")
  valid_595224 = validateParameter(valid_595224, JString, required = false,
                                 default = nil)
  if valid_595224 != nil:
    section.add "key", valid_595224
  var valid_595225 = query.getOrDefault("prettyPrint")
  valid_595225 = validateParameter(valid_595225, JBool, required = false,
                                 default = newJBool(true))
  if valid_595225 != nil:
    section.add "prettyPrint", valid_595225
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

proc call*(call_595227: Call_ContentRegionalinventoryInsert_595214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the regional inventory of a product in your Merchant Center account. If a regional inventory with the same region ID already exists, this method updates that entry.
  ## 
  let valid = call_595227.validator(path, query, header, formData, body)
  let scheme = call_595227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595227.url(scheme.get, call_595227.host, call_595227.base,
                         call_595227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595227, url, valid)

proc call*(call_595228: Call_ContentRegionalinventoryInsert_595214;
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
  var path_595229 = newJObject()
  var query_595230 = newJObject()
  var body_595231 = newJObject()
  add(query_595230, "fields", newJString(fields))
  add(query_595230, "quotaUser", newJString(quotaUser))
  add(query_595230, "alt", newJString(alt))
  add(query_595230, "oauth_token", newJString(oauthToken))
  add(query_595230, "userIp", newJString(userIp))
  add(query_595230, "key", newJString(key))
  add(path_595229, "merchantId", newJString(merchantId))
  if body != nil:
    body_595231 = body
  add(query_595230, "prettyPrint", newJBool(prettyPrint))
  add(path_595229, "productId", newJString(productId))
  result = call_595228.call(path_595229, query_595230, nil, nil, body_595231)

var contentRegionalinventoryInsert* = Call_ContentRegionalinventoryInsert_595214(
    name: "contentRegionalinventoryInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/products/{productId}/regionalinventory",
    validator: validate_ContentRegionalinventoryInsert_595215,
    base: "/content/v2.1", url: url_ContentRegionalinventoryInsert_595216,
    schemes: {Scheme.Https})
type
  Call_ContentProductstatusesList_595232 = ref object of OpenApiRestCall_593421
proc url_ContentProductstatusesList_595234(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentProductstatusesList_595233(path: JsonNode; query: JsonNode;
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
  var valid_595235 = path.getOrDefault("merchantId")
  valid_595235 = validateParameter(valid_595235, JString, required = true,
                                 default = nil)
  if valid_595235 != nil:
    section.add "merchantId", valid_595235
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
  var valid_595236 = query.getOrDefault("fields")
  valid_595236 = validateParameter(valid_595236, JString, required = false,
                                 default = nil)
  if valid_595236 != nil:
    section.add "fields", valid_595236
  var valid_595237 = query.getOrDefault("pageToken")
  valid_595237 = validateParameter(valid_595237, JString, required = false,
                                 default = nil)
  if valid_595237 != nil:
    section.add "pageToken", valid_595237
  var valid_595238 = query.getOrDefault("quotaUser")
  valid_595238 = validateParameter(valid_595238, JString, required = false,
                                 default = nil)
  if valid_595238 != nil:
    section.add "quotaUser", valid_595238
  var valid_595239 = query.getOrDefault("alt")
  valid_595239 = validateParameter(valid_595239, JString, required = false,
                                 default = newJString("json"))
  if valid_595239 != nil:
    section.add "alt", valid_595239
  var valid_595240 = query.getOrDefault("oauth_token")
  valid_595240 = validateParameter(valid_595240, JString, required = false,
                                 default = nil)
  if valid_595240 != nil:
    section.add "oauth_token", valid_595240
  var valid_595241 = query.getOrDefault("userIp")
  valid_595241 = validateParameter(valid_595241, JString, required = false,
                                 default = nil)
  if valid_595241 != nil:
    section.add "userIp", valid_595241
  var valid_595242 = query.getOrDefault("maxResults")
  valid_595242 = validateParameter(valid_595242, JInt, required = false, default = nil)
  if valid_595242 != nil:
    section.add "maxResults", valid_595242
  var valid_595243 = query.getOrDefault("key")
  valid_595243 = validateParameter(valid_595243, JString, required = false,
                                 default = nil)
  if valid_595243 != nil:
    section.add "key", valid_595243
  var valid_595244 = query.getOrDefault("prettyPrint")
  valid_595244 = validateParameter(valid_595244, JBool, required = false,
                                 default = newJBool(true))
  if valid_595244 != nil:
    section.add "prettyPrint", valid_595244
  var valid_595245 = query.getOrDefault("destinations")
  valid_595245 = validateParameter(valid_595245, JArray, required = false,
                                 default = nil)
  if valid_595245 != nil:
    section.add "destinations", valid_595245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595246: Call_ContentProductstatusesList_595232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the products in your Merchant Center account.
  ## 
  let valid = call_595246.validator(path, query, header, formData, body)
  let scheme = call_595246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595246.url(scheme.get, call_595246.host, call_595246.base,
                         call_595246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595246, url, valid)

proc call*(call_595247: Call_ContentProductstatusesList_595232; merchantId: string;
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
  var path_595248 = newJObject()
  var query_595249 = newJObject()
  add(query_595249, "fields", newJString(fields))
  add(query_595249, "pageToken", newJString(pageToken))
  add(query_595249, "quotaUser", newJString(quotaUser))
  add(query_595249, "alt", newJString(alt))
  add(query_595249, "oauth_token", newJString(oauthToken))
  add(query_595249, "userIp", newJString(userIp))
  add(query_595249, "maxResults", newJInt(maxResults))
  add(query_595249, "key", newJString(key))
  add(path_595248, "merchantId", newJString(merchantId))
  add(query_595249, "prettyPrint", newJBool(prettyPrint))
  if destinations != nil:
    query_595249.add "destinations", destinations
  result = call_595247.call(path_595248, query_595249, nil, nil, nil)

var contentProductstatusesList* = Call_ContentProductstatusesList_595232(
    name: "contentProductstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/productstatuses",
    validator: validate_ContentProductstatusesList_595233, base: "/content/v2.1",
    url: url_ContentProductstatusesList_595234, schemes: {Scheme.Https})
type
  Call_ContentProductstatusesGet_595250 = ref object of OpenApiRestCall_593421
proc url_ContentProductstatusesGet_595252(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentProductstatusesGet_595251(path: JsonNode; query: JsonNode;
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
  var valid_595253 = path.getOrDefault("merchantId")
  valid_595253 = validateParameter(valid_595253, JString, required = true,
                                 default = nil)
  if valid_595253 != nil:
    section.add "merchantId", valid_595253
  var valid_595254 = path.getOrDefault("productId")
  valid_595254 = validateParameter(valid_595254, JString, required = true,
                                 default = nil)
  if valid_595254 != nil:
    section.add "productId", valid_595254
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
  var valid_595255 = query.getOrDefault("fields")
  valid_595255 = validateParameter(valid_595255, JString, required = false,
                                 default = nil)
  if valid_595255 != nil:
    section.add "fields", valid_595255
  var valid_595256 = query.getOrDefault("quotaUser")
  valid_595256 = validateParameter(valid_595256, JString, required = false,
                                 default = nil)
  if valid_595256 != nil:
    section.add "quotaUser", valid_595256
  var valid_595257 = query.getOrDefault("alt")
  valid_595257 = validateParameter(valid_595257, JString, required = false,
                                 default = newJString("json"))
  if valid_595257 != nil:
    section.add "alt", valid_595257
  var valid_595258 = query.getOrDefault("oauth_token")
  valid_595258 = validateParameter(valid_595258, JString, required = false,
                                 default = nil)
  if valid_595258 != nil:
    section.add "oauth_token", valid_595258
  var valid_595259 = query.getOrDefault("userIp")
  valid_595259 = validateParameter(valid_595259, JString, required = false,
                                 default = nil)
  if valid_595259 != nil:
    section.add "userIp", valid_595259
  var valid_595260 = query.getOrDefault("key")
  valid_595260 = validateParameter(valid_595260, JString, required = false,
                                 default = nil)
  if valid_595260 != nil:
    section.add "key", valid_595260
  var valid_595261 = query.getOrDefault("prettyPrint")
  valid_595261 = validateParameter(valid_595261, JBool, required = false,
                                 default = newJBool(true))
  if valid_595261 != nil:
    section.add "prettyPrint", valid_595261
  var valid_595262 = query.getOrDefault("destinations")
  valid_595262 = validateParameter(valid_595262, JArray, required = false,
                                 default = nil)
  if valid_595262 != nil:
    section.add "destinations", valid_595262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595263: Call_ContentProductstatusesGet_595250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the status of a product from your Merchant Center account.
  ## 
  let valid = call_595263.validator(path, query, header, formData, body)
  let scheme = call_595263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595263.url(scheme.get, call_595263.host, call_595263.base,
                         call_595263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595263, url, valid)

proc call*(call_595264: Call_ContentProductstatusesGet_595250; merchantId: string;
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
  var path_595265 = newJObject()
  var query_595266 = newJObject()
  add(query_595266, "fields", newJString(fields))
  add(query_595266, "quotaUser", newJString(quotaUser))
  add(query_595266, "alt", newJString(alt))
  add(query_595266, "oauth_token", newJString(oauthToken))
  add(query_595266, "userIp", newJString(userIp))
  add(query_595266, "key", newJString(key))
  add(path_595265, "merchantId", newJString(merchantId))
  add(path_595265, "productId", newJString(productId))
  add(query_595266, "prettyPrint", newJBool(prettyPrint))
  if destinations != nil:
    query_595266.add "destinations", destinations
  result = call_595264.call(path_595265, query_595266, nil, nil, nil)

var contentProductstatusesGet* = Call_ContentProductstatusesGet_595250(
    name: "contentProductstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/productstatuses/{productId}",
    validator: validate_ContentProductstatusesGet_595251, base: "/content/v2.1",
    url: url_ContentProductstatusesGet_595252, schemes: {Scheme.Https})
type
  Call_ContentReturnaddressInsert_595285 = ref object of OpenApiRestCall_593421
proc url_ContentReturnaddressInsert_595287(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentReturnaddressInsert_595286(path: JsonNode; query: JsonNode;
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
  var valid_595288 = path.getOrDefault("merchantId")
  valid_595288 = validateParameter(valid_595288, JString, required = true,
                                 default = nil)
  if valid_595288 != nil:
    section.add "merchantId", valid_595288
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
  var valid_595289 = query.getOrDefault("fields")
  valid_595289 = validateParameter(valid_595289, JString, required = false,
                                 default = nil)
  if valid_595289 != nil:
    section.add "fields", valid_595289
  var valid_595290 = query.getOrDefault("quotaUser")
  valid_595290 = validateParameter(valid_595290, JString, required = false,
                                 default = nil)
  if valid_595290 != nil:
    section.add "quotaUser", valid_595290
  var valid_595291 = query.getOrDefault("alt")
  valid_595291 = validateParameter(valid_595291, JString, required = false,
                                 default = newJString("json"))
  if valid_595291 != nil:
    section.add "alt", valid_595291
  var valid_595292 = query.getOrDefault("oauth_token")
  valid_595292 = validateParameter(valid_595292, JString, required = false,
                                 default = nil)
  if valid_595292 != nil:
    section.add "oauth_token", valid_595292
  var valid_595293 = query.getOrDefault("userIp")
  valid_595293 = validateParameter(valid_595293, JString, required = false,
                                 default = nil)
  if valid_595293 != nil:
    section.add "userIp", valid_595293
  var valid_595294 = query.getOrDefault("key")
  valid_595294 = validateParameter(valid_595294, JString, required = false,
                                 default = nil)
  if valid_595294 != nil:
    section.add "key", valid_595294
  var valid_595295 = query.getOrDefault("prettyPrint")
  valid_595295 = validateParameter(valid_595295, JBool, required = false,
                                 default = newJBool(true))
  if valid_595295 != nil:
    section.add "prettyPrint", valid_595295
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

proc call*(call_595297: Call_ContentReturnaddressInsert_595285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a return address for the Merchant Center account.
  ## 
  let valid = call_595297.validator(path, query, header, formData, body)
  let scheme = call_595297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595297.url(scheme.get, call_595297.host, call_595297.base,
                         call_595297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595297, url, valid)

proc call*(call_595298: Call_ContentReturnaddressInsert_595285; merchantId: string;
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
  var path_595299 = newJObject()
  var query_595300 = newJObject()
  var body_595301 = newJObject()
  add(query_595300, "fields", newJString(fields))
  add(query_595300, "quotaUser", newJString(quotaUser))
  add(query_595300, "alt", newJString(alt))
  add(query_595300, "oauth_token", newJString(oauthToken))
  add(query_595300, "userIp", newJString(userIp))
  add(query_595300, "key", newJString(key))
  add(path_595299, "merchantId", newJString(merchantId))
  if body != nil:
    body_595301 = body
  add(query_595300, "prettyPrint", newJBool(prettyPrint))
  result = call_595298.call(path_595299, query_595300, nil, nil, body_595301)

var contentReturnaddressInsert* = Call_ContentReturnaddressInsert_595285(
    name: "contentReturnaddressInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/returnaddress",
    validator: validate_ContentReturnaddressInsert_595286, base: "/content/v2.1",
    url: url_ContentReturnaddressInsert_595287, schemes: {Scheme.Https})
type
  Call_ContentReturnaddressList_595267 = ref object of OpenApiRestCall_593421
proc url_ContentReturnaddressList_595269(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentReturnaddressList_595268(path: JsonNode; query: JsonNode;
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
  var valid_595270 = path.getOrDefault("merchantId")
  valid_595270 = validateParameter(valid_595270, JString, required = true,
                                 default = nil)
  if valid_595270 != nil:
    section.add "merchantId", valid_595270
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
  var valid_595271 = query.getOrDefault("fields")
  valid_595271 = validateParameter(valid_595271, JString, required = false,
                                 default = nil)
  if valid_595271 != nil:
    section.add "fields", valid_595271
  var valid_595272 = query.getOrDefault("country")
  valid_595272 = validateParameter(valid_595272, JString, required = false,
                                 default = nil)
  if valid_595272 != nil:
    section.add "country", valid_595272
  var valid_595273 = query.getOrDefault("quotaUser")
  valid_595273 = validateParameter(valid_595273, JString, required = false,
                                 default = nil)
  if valid_595273 != nil:
    section.add "quotaUser", valid_595273
  var valid_595274 = query.getOrDefault("pageToken")
  valid_595274 = validateParameter(valid_595274, JString, required = false,
                                 default = nil)
  if valid_595274 != nil:
    section.add "pageToken", valid_595274
  var valid_595275 = query.getOrDefault("alt")
  valid_595275 = validateParameter(valid_595275, JString, required = false,
                                 default = newJString("json"))
  if valid_595275 != nil:
    section.add "alt", valid_595275
  var valid_595276 = query.getOrDefault("oauth_token")
  valid_595276 = validateParameter(valid_595276, JString, required = false,
                                 default = nil)
  if valid_595276 != nil:
    section.add "oauth_token", valid_595276
  var valid_595277 = query.getOrDefault("userIp")
  valid_595277 = validateParameter(valid_595277, JString, required = false,
                                 default = nil)
  if valid_595277 != nil:
    section.add "userIp", valid_595277
  var valid_595278 = query.getOrDefault("maxResults")
  valid_595278 = validateParameter(valid_595278, JInt, required = false, default = nil)
  if valid_595278 != nil:
    section.add "maxResults", valid_595278
  var valid_595279 = query.getOrDefault("key")
  valid_595279 = validateParameter(valid_595279, JString, required = false,
                                 default = nil)
  if valid_595279 != nil:
    section.add "key", valid_595279
  var valid_595280 = query.getOrDefault("prettyPrint")
  valid_595280 = validateParameter(valid_595280, JBool, required = false,
                                 default = newJBool(true))
  if valid_595280 != nil:
    section.add "prettyPrint", valid_595280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595281: Call_ContentReturnaddressList_595267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the return addresses of the Merchant Center account.
  ## 
  let valid = call_595281.validator(path, query, header, formData, body)
  let scheme = call_595281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595281.url(scheme.get, call_595281.host, call_595281.base,
                         call_595281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595281, url, valid)

proc call*(call_595282: Call_ContentReturnaddressList_595267; merchantId: string;
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
  var path_595283 = newJObject()
  var query_595284 = newJObject()
  add(query_595284, "fields", newJString(fields))
  add(query_595284, "country", newJString(country))
  add(query_595284, "quotaUser", newJString(quotaUser))
  add(query_595284, "pageToken", newJString(pageToken))
  add(query_595284, "alt", newJString(alt))
  add(query_595284, "oauth_token", newJString(oauthToken))
  add(query_595284, "userIp", newJString(userIp))
  add(query_595284, "maxResults", newJInt(maxResults))
  add(query_595284, "key", newJString(key))
  add(path_595283, "merchantId", newJString(merchantId))
  add(query_595284, "prettyPrint", newJBool(prettyPrint))
  result = call_595282.call(path_595283, query_595284, nil, nil, nil)

var contentReturnaddressList* = Call_ContentReturnaddressList_595267(
    name: "contentReturnaddressList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/returnaddress",
    validator: validate_ContentReturnaddressList_595268, base: "/content/v2.1",
    url: url_ContentReturnaddressList_595269, schemes: {Scheme.Https})
type
  Call_ContentReturnaddressGet_595302 = ref object of OpenApiRestCall_593421
proc url_ContentReturnaddressGet_595304(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentReturnaddressGet_595303(path: JsonNode; query: JsonNode;
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
  var valid_595305 = path.getOrDefault("returnAddressId")
  valid_595305 = validateParameter(valid_595305, JString, required = true,
                                 default = nil)
  if valid_595305 != nil:
    section.add "returnAddressId", valid_595305
  var valid_595306 = path.getOrDefault("merchantId")
  valid_595306 = validateParameter(valid_595306, JString, required = true,
                                 default = nil)
  if valid_595306 != nil:
    section.add "merchantId", valid_595306
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
  var valid_595307 = query.getOrDefault("fields")
  valid_595307 = validateParameter(valid_595307, JString, required = false,
                                 default = nil)
  if valid_595307 != nil:
    section.add "fields", valid_595307
  var valid_595308 = query.getOrDefault("quotaUser")
  valid_595308 = validateParameter(valid_595308, JString, required = false,
                                 default = nil)
  if valid_595308 != nil:
    section.add "quotaUser", valid_595308
  var valid_595309 = query.getOrDefault("alt")
  valid_595309 = validateParameter(valid_595309, JString, required = false,
                                 default = newJString("json"))
  if valid_595309 != nil:
    section.add "alt", valid_595309
  var valid_595310 = query.getOrDefault("oauth_token")
  valid_595310 = validateParameter(valid_595310, JString, required = false,
                                 default = nil)
  if valid_595310 != nil:
    section.add "oauth_token", valid_595310
  var valid_595311 = query.getOrDefault("userIp")
  valid_595311 = validateParameter(valid_595311, JString, required = false,
                                 default = nil)
  if valid_595311 != nil:
    section.add "userIp", valid_595311
  var valid_595312 = query.getOrDefault("key")
  valid_595312 = validateParameter(valid_595312, JString, required = false,
                                 default = nil)
  if valid_595312 != nil:
    section.add "key", valid_595312
  var valid_595313 = query.getOrDefault("prettyPrint")
  valid_595313 = validateParameter(valid_595313, JBool, required = false,
                                 default = newJBool(true))
  if valid_595313 != nil:
    section.add "prettyPrint", valid_595313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595314: Call_ContentReturnaddressGet_595302; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a return address of the Merchant Center account.
  ## 
  let valid = call_595314.validator(path, query, header, formData, body)
  let scheme = call_595314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595314.url(scheme.get, call_595314.host, call_595314.base,
                         call_595314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595314, url, valid)

proc call*(call_595315: Call_ContentReturnaddressGet_595302;
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
  var path_595316 = newJObject()
  var query_595317 = newJObject()
  add(query_595317, "fields", newJString(fields))
  add(query_595317, "quotaUser", newJString(quotaUser))
  add(query_595317, "alt", newJString(alt))
  add(query_595317, "oauth_token", newJString(oauthToken))
  add(query_595317, "userIp", newJString(userIp))
  add(path_595316, "returnAddressId", newJString(returnAddressId))
  add(query_595317, "key", newJString(key))
  add(path_595316, "merchantId", newJString(merchantId))
  add(query_595317, "prettyPrint", newJBool(prettyPrint))
  result = call_595315.call(path_595316, query_595317, nil, nil, nil)

var contentReturnaddressGet* = Call_ContentReturnaddressGet_595302(
    name: "contentReturnaddressGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/returnaddress/{returnAddressId}",
    validator: validate_ContentReturnaddressGet_595303, base: "/content/v2.1",
    url: url_ContentReturnaddressGet_595304, schemes: {Scheme.Https})
type
  Call_ContentReturnaddressDelete_595318 = ref object of OpenApiRestCall_593421
proc url_ContentReturnaddressDelete_595320(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentReturnaddressDelete_595319(path: JsonNode; query: JsonNode;
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
  var valid_595321 = path.getOrDefault("returnAddressId")
  valid_595321 = validateParameter(valid_595321, JString, required = true,
                                 default = nil)
  if valid_595321 != nil:
    section.add "returnAddressId", valid_595321
  var valid_595322 = path.getOrDefault("merchantId")
  valid_595322 = validateParameter(valid_595322, JString, required = true,
                                 default = nil)
  if valid_595322 != nil:
    section.add "merchantId", valid_595322
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
  var valid_595323 = query.getOrDefault("fields")
  valid_595323 = validateParameter(valid_595323, JString, required = false,
                                 default = nil)
  if valid_595323 != nil:
    section.add "fields", valid_595323
  var valid_595324 = query.getOrDefault("quotaUser")
  valid_595324 = validateParameter(valid_595324, JString, required = false,
                                 default = nil)
  if valid_595324 != nil:
    section.add "quotaUser", valid_595324
  var valid_595325 = query.getOrDefault("alt")
  valid_595325 = validateParameter(valid_595325, JString, required = false,
                                 default = newJString("json"))
  if valid_595325 != nil:
    section.add "alt", valid_595325
  var valid_595326 = query.getOrDefault("oauth_token")
  valid_595326 = validateParameter(valid_595326, JString, required = false,
                                 default = nil)
  if valid_595326 != nil:
    section.add "oauth_token", valid_595326
  var valid_595327 = query.getOrDefault("userIp")
  valid_595327 = validateParameter(valid_595327, JString, required = false,
                                 default = nil)
  if valid_595327 != nil:
    section.add "userIp", valid_595327
  var valid_595328 = query.getOrDefault("key")
  valid_595328 = validateParameter(valid_595328, JString, required = false,
                                 default = nil)
  if valid_595328 != nil:
    section.add "key", valid_595328
  var valid_595329 = query.getOrDefault("prettyPrint")
  valid_595329 = validateParameter(valid_595329, JBool, required = false,
                                 default = newJBool(true))
  if valid_595329 != nil:
    section.add "prettyPrint", valid_595329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595330: Call_ContentReturnaddressDelete_595318; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a return address for the given Merchant Center account.
  ## 
  let valid = call_595330.validator(path, query, header, formData, body)
  let scheme = call_595330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595330.url(scheme.get, call_595330.host, call_595330.base,
                         call_595330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595330, url, valid)

proc call*(call_595331: Call_ContentReturnaddressDelete_595318;
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
  var path_595332 = newJObject()
  var query_595333 = newJObject()
  add(query_595333, "fields", newJString(fields))
  add(query_595333, "quotaUser", newJString(quotaUser))
  add(query_595333, "alt", newJString(alt))
  add(query_595333, "oauth_token", newJString(oauthToken))
  add(query_595333, "userIp", newJString(userIp))
  add(path_595332, "returnAddressId", newJString(returnAddressId))
  add(query_595333, "key", newJString(key))
  add(path_595332, "merchantId", newJString(merchantId))
  add(query_595333, "prettyPrint", newJBool(prettyPrint))
  result = call_595331.call(path_595332, query_595333, nil, nil, nil)

var contentReturnaddressDelete* = Call_ContentReturnaddressDelete_595318(
    name: "contentReturnaddressDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{merchantId}/returnaddress/{returnAddressId}",
    validator: validate_ContentReturnaddressDelete_595319, base: "/content/v2.1",
    url: url_ContentReturnaddressDelete_595320, schemes: {Scheme.Https})
type
  Call_ContentReturnpolicyInsert_595349 = ref object of OpenApiRestCall_593421
proc url_ContentReturnpolicyInsert_595351(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentReturnpolicyInsert_595350(path: JsonNode; query: JsonNode;
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
  var valid_595352 = path.getOrDefault("merchantId")
  valid_595352 = validateParameter(valid_595352, JString, required = true,
                                 default = nil)
  if valid_595352 != nil:
    section.add "merchantId", valid_595352
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
  var valid_595353 = query.getOrDefault("fields")
  valid_595353 = validateParameter(valid_595353, JString, required = false,
                                 default = nil)
  if valid_595353 != nil:
    section.add "fields", valid_595353
  var valid_595354 = query.getOrDefault("quotaUser")
  valid_595354 = validateParameter(valid_595354, JString, required = false,
                                 default = nil)
  if valid_595354 != nil:
    section.add "quotaUser", valid_595354
  var valid_595355 = query.getOrDefault("alt")
  valid_595355 = validateParameter(valid_595355, JString, required = false,
                                 default = newJString("json"))
  if valid_595355 != nil:
    section.add "alt", valid_595355
  var valid_595356 = query.getOrDefault("oauth_token")
  valid_595356 = validateParameter(valid_595356, JString, required = false,
                                 default = nil)
  if valid_595356 != nil:
    section.add "oauth_token", valid_595356
  var valid_595357 = query.getOrDefault("userIp")
  valid_595357 = validateParameter(valid_595357, JString, required = false,
                                 default = nil)
  if valid_595357 != nil:
    section.add "userIp", valid_595357
  var valid_595358 = query.getOrDefault("key")
  valid_595358 = validateParameter(valid_595358, JString, required = false,
                                 default = nil)
  if valid_595358 != nil:
    section.add "key", valid_595358
  var valid_595359 = query.getOrDefault("prettyPrint")
  valid_595359 = validateParameter(valid_595359, JBool, required = false,
                                 default = newJBool(true))
  if valid_595359 != nil:
    section.add "prettyPrint", valid_595359
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

proc call*(call_595361: Call_ContentReturnpolicyInsert_595349; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a return policy for the Merchant Center account.
  ## 
  let valid = call_595361.validator(path, query, header, formData, body)
  let scheme = call_595361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595361.url(scheme.get, call_595361.host, call_595361.base,
                         call_595361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595361, url, valid)

proc call*(call_595362: Call_ContentReturnpolicyInsert_595349; merchantId: string;
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
  var path_595363 = newJObject()
  var query_595364 = newJObject()
  var body_595365 = newJObject()
  add(query_595364, "fields", newJString(fields))
  add(query_595364, "quotaUser", newJString(quotaUser))
  add(query_595364, "alt", newJString(alt))
  add(query_595364, "oauth_token", newJString(oauthToken))
  add(query_595364, "userIp", newJString(userIp))
  add(query_595364, "key", newJString(key))
  add(path_595363, "merchantId", newJString(merchantId))
  if body != nil:
    body_595365 = body
  add(query_595364, "prettyPrint", newJBool(prettyPrint))
  result = call_595362.call(path_595363, query_595364, nil, nil, body_595365)

var contentReturnpolicyInsert* = Call_ContentReturnpolicyInsert_595349(
    name: "contentReturnpolicyInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/returnpolicy",
    validator: validate_ContentReturnpolicyInsert_595350, base: "/content/v2.1",
    url: url_ContentReturnpolicyInsert_595351, schemes: {Scheme.Https})
type
  Call_ContentReturnpolicyList_595334 = ref object of OpenApiRestCall_593421
proc url_ContentReturnpolicyList_595336(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentReturnpolicyList_595335(path: JsonNode; query: JsonNode;
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
  var valid_595337 = path.getOrDefault("merchantId")
  valid_595337 = validateParameter(valid_595337, JString, required = true,
                                 default = nil)
  if valid_595337 != nil:
    section.add "merchantId", valid_595337
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
  var valid_595338 = query.getOrDefault("fields")
  valid_595338 = validateParameter(valid_595338, JString, required = false,
                                 default = nil)
  if valid_595338 != nil:
    section.add "fields", valid_595338
  var valid_595339 = query.getOrDefault("quotaUser")
  valid_595339 = validateParameter(valid_595339, JString, required = false,
                                 default = nil)
  if valid_595339 != nil:
    section.add "quotaUser", valid_595339
  var valid_595340 = query.getOrDefault("alt")
  valid_595340 = validateParameter(valid_595340, JString, required = false,
                                 default = newJString("json"))
  if valid_595340 != nil:
    section.add "alt", valid_595340
  var valid_595341 = query.getOrDefault("oauth_token")
  valid_595341 = validateParameter(valid_595341, JString, required = false,
                                 default = nil)
  if valid_595341 != nil:
    section.add "oauth_token", valid_595341
  var valid_595342 = query.getOrDefault("userIp")
  valid_595342 = validateParameter(valid_595342, JString, required = false,
                                 default = nil)
  if valid_595342 != nil:
    section.add "userIp", valid_595342
  var valid_595343 = query.getOrDefault("key")
  valid_595343 = validateParameter(valid_595343, JString, required = false,
                                 default = nil)
  if valid_595343 != nil:
    section.add "key", valid_595343
  var valid_595344 = query.getOrDefault("prettyPrint")
  valid_595344 = validateParameter(valid_595344, JBool, required = false,
                                 default = newJBool(true))
  if valid_595344 != nil:
    section.add "prettyPrint", valid_595344
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595345: Call_ContentReturnpolicyList_595334; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the return policies of the Merchant Center account.
  ## 
  let valid = call_595345.validator(path, query, header, formData, body)
  let scheme = call_595345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595345.url(scheme.get, call_595345.host, call_595345.base,
                         call_595345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595345, url, valid)

proc call*(call_595346: Call_ContentReturnpolicyList_595334; merchantId: string;
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
  var path_595347 = newJObject()
  var query_595348 = newJObject()
  add(query_595348, "fields", newJString(fields))
  add(query_595348, "quotaUser", newJString(quotaUser))
  add(query_595348, "alt", newJString(alt))
  add(query_595348, "oauth_token", newJString(oauthToken))
  add(query_595348, "userIp", newJString(userIp))
  add(query_595348, "key", newJString(key))
  add(path_595347, "merchantId", newJString(merchantId))
  add(query_595348, "prettyPrint", newJBool(prettyPrint))
  result = call_595346.call(path_595347, query_595348, nil, nil, nil)

var contentReturnpolicyList* = Call_ContentReturnpolicyList_595334(
    name: "contentReturnpolicyList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/returnpolicy",
    validator: validate_ContentReturnpolicyList_595335, base: "/content/v2.1",
    url: url_ContentReturnpolicyList_595336, schemes: {Scheme.Https})
type
  Call_ContentReturnpolicyGet_595366 = ref object of OpenApiRestCall_593421
proc url_ContentReturnpolicyGet_595368(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentReturnpolicyGet_595367(path: JsonNode; query: JsonNode;
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
  var valid_595369 = path.getOrDefault("returnPolicyId")
  valid_595369 = validateParameter(valid_595369, JString, required = true,
                                 default = nil)
  if valid_595369 != nil:
    section.add "returnPolicyId", valid_595369
  var valid_595370 = path.getOrDefault("merchantId")
  valid_595370 = validateParameter(valid_595370, JString, required = true,
                                 default = nil)
  if valid_595370 != nil:
    section.add "merchantId", valid_595370
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
  var valid_595371 = query.getOrDefault("fields")
  valid_595371 = validateParameter(valid_595371, JString, required = false,
                                 default = nil)
  if valid_595371 != nil:
    section.add "fields", valid_595371
  var valid_595372 = query.getOrDefault("quotaUser")
  valid_595372 = validateParameter(valid_595372, JString, required = false,
                                 default = nil)
  if valid_595372 != nil:
    section.add "quotaUser", valid_595372
  var valid_595373 = query.getOrDefault("alt")
  valid_595373 = validateParameter(valid_595373, JString, required = false,
                                 default = newJString("json"))
  if valid_595373 != nil:
    section.add "alt", valid_595373
  var valid_595374 = query.getOrDefault("oauth_token")
  valid_595374 = validateParameter(valid_595374, JString, required = false,
                                 default = nil)
  if valid_595374 != nil:
    section.add "oauth_token", valid_595374
  var valid_595375 = query.getOrDefault("userIp")
  valid_595375 = validateParameter(valid_595375, JString, required = false,
                                 default = nil)
  if valid_595375 != nil:
    section.add "userIp", valid_595375
  var valid_595376 = query.getOrDefault("key")
  valid_595376 = validateParameter(valid_595376, JString, required = false,
                                 default = nil)
  if valid_595376 != nil:
    section.add "key", valid_595376
  var valid_595377 = query.getOrDefault("prettyPrint")
  valid_595377 = validateParameter(valid_595377, JBool, required = false,
                                 default = newJBool(true))
  if valid_595377 != nil:
    section.add "prettyPrint", valid_595377
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595378: Call_ContentReturnpolicyGet_595366; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a return policy of the Merchant Center account.
  ## 
  let valid = call_595378.validator(path, query, header, formData, body)
  let scheme = call_595378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595378.url(scheme.get, call_595378.host, call_595378.base,
                         call_595378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595378, url, valid)

proc call*(call_595379: Call_ContentReturnpolicyGet_595366; returnPolicyId: string;
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
  var path_595380 = newJObject()
  var query_595381 = newJObject()
  add(query_595381, "fields", newJString(fields))
  add(query_595381, "quotaUser", newJString(quotaUser))
  add(query_595381, "alt", newJString(alt))
  add(path_595380, "returnPolicyId", newJString(returnPolicyId))
  add(query_595381, "oauth_token", newJString(oauthToken))
  add(query_595381, "userIp", newJString(userIp))
  add(query_595381, "key", newJString(key))
  add(path_595380, "merchantId", newJString(merchantId))
  add(query_595381, "prettyPrint", newJBool(prettyPrint))
  result = call_595379.call(path_595380, query_595381, nil, nil, nil)

var contentReturnpolicyGet* = Call_ContentReturnpolicyGet_595366(
    name: "contentReturnpolicyGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/returnpolicy/{returnPolicyId}",
    validator: validate_ContentReturnpolicyGet_595367, base: "/content/v2.1",
    url: url_ContentReturnpolicyGet_595368, schemes: {Scheme.Https})
type
  Call_ContentReturnpolicyDelete_595382 = ref object of OpenApiRestCall_593421
proc url_ContentReturnpolicyDelete_595384(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentReturnpolicyDelete_595383(path: JsonNode; query: JsonNode;
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
  var valid_595385 = path.getOrDefault("returnPolicyId")
  valid_595385 = validateParameter(valid_595385, JString, required = true,
                                 default = nil)
  if valid_595385 != nil:
    section.add "returnPolicyId", valid_595385
  var valid_595386 = path.getOrDefault("merchantId")
  valid_595386 = validateParameter(valid_595386, JString, required = true,
                                 default = nil)
  if valid_595386 != nil:
    section.add "merchantId", valid_595386
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
  var valid_595387 = query.getOrDefault("fields")
  valid_595387 = validateParameter(valid_595387, JString, required = false,
                                 default = nil)
  if valid_595387 != nil:
    section.add "fields", valid_595387
  var valid_595388 = query.getOrDefault("quotaUser")
  valid_595388 = validateParameter(valid_595388, JString, required = false,
                                 default = nil)
  if valid_595388 != nil:
    section.add "quotaUser", valid_595388
  var valid_595389 = query.getOrDefault("alt")
  valid_595389 = validateParameter(valid_595389, JString, required = false,
                                 default = newJString("json"))
  if valid_595389 != nil:
    section.add "alt", valid_595389
  var valid_595390 = query.getOrDefault("oauth_token")
  valid_595390 = validateParameter(valid_595390, JString, required = false,
                                 default = nil)
  if valid_595390 != nil:
    section.add "oauth_token", valid_595390
  var valid_595391 = query.getOrDefault("userIp")
  valid_595391 = validateParameter(valid_595391, JString, required = false,
                                 default = nil)
  if valid_595391 != nil:
    section.add "userIp", valid_595391
  var valid_595392 = query.getOrDefault("key")
  valid_595392 = validateParameter(valid_595392, JString, required = false,
                                 default = nil)
  if valid_595392 != nil:
    section.add "key", valid_595392
  var valid_595393 = query.getOrDefault("prettyPrint")
  valid_595393 = validateParameter(valid_595393, JBool, required = false,
                                 default = newJBool(true))
  if valid_595393 != nil:
    section.add "prettyPrint", valid_595393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595394: Call_ContentReturnpolicyDelete_595382; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a return policy for the given Merchant Center account.
  ## 
  let valid = call_595394.validator(path, query, header, formData, body)
  let scheme = call_595394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595394.url(scheme.get, call_595394.host, call_595394.base,
                         call_595394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595394, url, valid)

proc call*(call_595395: Call_ContentReturnpolicyDelete_595382;
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
  var path_595396 = newJObject()
  var query_595397 = newJObject()
  add(query_595397, "fields", newJString(fields))
  add(query_595397, "quotaUser", newJString(quotaUser))
  add(query_595397, "alt", newJString(alt))
  add(path_595396, "returnPolicyId", newJString(returnPolicyId))
  add(query_595397, "oauth_token", newJString(oauthToken))
  add(query_595397, "userIp", newJString(userIp))
  add(query_595397, "key", newJString(key))
  add(path_595396, "merchantId", newJString(merchantId))
  add(query_595397, "prettyPrint", newJBool(prettyPrint))
  result = call_595395.call(path_595396, query_595397, nil, nil, nil)

var contentReturnpolicyDelete* = Call_ContentReturnpolicyDelete_595382(
    name: "contentReturnpolicyDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{merchantId}/returnpolicy/{returnPolicyId}",
    validator: validate_ContentReturnpolicyDelete_595383, base: "/content/v2.1",
    url: url_ContentReturnpolicyDelete_595384, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsList_595398 = ref object of OpenApiRestCall_593421
proc url_ContentShippingsettingsList_595400(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentShippingsettingsList_595399(path: JsonNode; query: JsonNode;
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
  var valid_595401 = path.getOrDefault("merchantId")
  valid_595401 = validateParameter(valid_595401, JString, required = true,
                                 default = nil)
  if valid_595401 != nil:
    section.add "merchantId", valid_595401
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
  var valid_595402 = query.getOrDefault("fields")
  valid_595402 = validateParameter(valid_595402, JString, required = false,
                                 default = nil)
  if valid_595402 != nil:
    section.add "fields", valid_595402
  var valid_595403 = query.getOrDefault("pageToken")
  valid_595403 = validateParameter(valid_595403, JString, required = false,
                                 default = nil)
  if valid_595403 != nil:
    section.add "pageToken", valid_595403
  var valid_595404 = query.getOrDefault("quotaUser")
  valid_595404 = validateParameter(valid_595404, JString, required = false,
                                 default = nil)
  if valid_595404 != nil:
    section.add "quotaUser", valid_595404
  var valid_595405 = query.getOrDefault("alt")
  valid_595405 = validateParameter(valid_595405, JString, required = false,
                                 default = newJString("json"))
  if valid_595405 != nil:
    section.add "alt", valid_595405
  var valid_595406 = query.getOrDefault("oauth_token")
  valid_595406 = validateParameter(valid_595406, JString, required = false,
                                 default = nil)
  if valid_595406 != nil:
    section.add "oauth_token", valid_595406
  var valid_595407 = query.getOrDefault("userIp")
  valid_595407 = validateParameter(valid_595407, JString, required = false,
                                 default = nil)
  if valid_595407 != nil:
    section.add "userIp", valid_595407
  var valid_595408 = query.getOrDefault("maxResults")
  valid_595408 = validateParameter(valid_595408, JInt, required = false, default = nil)
  if valid_595408 != nil:
    section.add "maxResults", valid_595408
  var valid_595409 = query.getOrDefault("key")
  valid_595409 = validateParameter(valid_595409, JString, required = false,
                                 default = nil)
  if valid_595409 != nil:
    section.add "key", valid_595409
  var valid_595410 = query.getOrDefault("prettyPrint")
  valid_595410 = validateParameter(valid_595410, JBool, required = false,
                                 default = newJBool(true))
  if valid_595410 != nil:
    section.add "prettyPrint", valid_595410
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595411: Call_ContentShippingsettingsList_595398; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the shipping settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_595411.validator(path, query, header, formData, body)
  let scheme = call_595411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595411.url(scheme.get, call_595411.host, call_595411.base,
                         call_595411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595411, url, valid)

proc call*(call_595412: Call_ContentShippingsettingsList_595398;
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
  var path_595413 = newJObject()
  var query_595414 = newJObject()
  add(query_595414, "fields", newJString(fields))
  add(query_595414, "pageToken", newJString(pageToken))
  add(query_595414, "quotaUser", newJString(quotaUser))
  add(query_595414, "alt", newJString(alt))
  add(query_595414, "oauth_token", newJString(oauthToken))
  add(query_595414, "userIp", newJString(userIp))
  add(query_595414, "maxResults", newJInt(maxResults))
  add(query_595414, "key", newJString(key))
  add(path_595413, "merchantId", newJString(merchantId))
  add(query_595414, "prettyPrint", newJBool(prettyPrint))
  result = call_595412.call(path_595413, query_595414, nil, nil, nil)

var contentShippingsettingsList* = Call_ContentShippingsettingsList_595398(
    name: "contentShippingsettingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/shippingsettings",
    validator: validate_ContentShippingsettingsList_595399, base: "/content/v2.1",
    url: url_ContentShippingsettingsList_595400, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsUpdate_595431 = ref object of OpenApiRestCall_593421
proc url_ContentShippingsettingsUpdate_595433(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentShippingsettingsUpdate_595432(path: JsonNode; query: JsonNode;
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
  var valid_595434 = path.getOrDefault("accountId")
  valid_595434 = validateParameter(valid_595434, JString, required = true,
                                 default = nil)
  if valid_595434 != nil:
    section.add "accountId", valid_595434
  var valid_595435 = path.getOrDefault("merchantId")
  valid_595435 = validateParameter(valid_595435, JString, required = true,
                                 default = nil)
  if valid_595435 != nil:
    section.add "merchantId", valid_595435
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
  var valid_595436 = query.getOrDefault("fields")
  valid_595436 = validateParameter(valid_595436, JString, required = false,
                                 default = nil)
  if valid_595436 != nil:
    section.add "fields", valid_595436
  var valid_595437 = query.getOrDefault("quotaUser")
  valid_595437 = validateParameter(valid_595437, JString, required = false,
                                 default = nil)
  if valid_595437 != nil:
    section.add "quotaUser", valid_595437
  var valid_595438 = query.getOrDefault("alt")
  valid_595438 = validateParameter(valid_595438, JString, required = false,
                                 default = newJString("json"))
  if valid_595438 != nil:
    section.add "alt", valid_595438
  var valid_595439 = query.getOrDefault("oauth_token")
  valid_595439 = validateParameter(valid_595439, JString, required = false,
                                 default = nil)
  if valid_595439 != nil:
    section.add "oauth_token", valid_595439
  var valid_595440 = query.getOrDefault("userIp")
  valid_595440 = validateParameter(valid_595440, JString, required = false,
                                 default = nil)
  if valid_595440 != nil:
    section.add "userIp", valid_595440
  var valid_595441 = query.getOrDefault("key")
  valid_595441 = validateParameter(valid_595441, JString, required = false,
                                 default = nil)
  if valid_595441 != nil:
    section.add "key", valid_595441
  var valid_595442 = query.getOrDefault("prettyPrint")
  valid_595442 = validateParameter(valid_595442, JBool, required = false,
                                 default = newJBool(true))
  if valid_595442 != nil:
    section.add "prettyPrint", valid_595442
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

proc call*(call_595444: Call_ContentShippingsettingsUpdate_595431; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the shipping settings of the account.
  ## 
  let valid = call_595444.validator(path, query, header, formData, body)
  let scheme = call_595444.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595444.url(scheme.get, call_595444.host, call_595444.base,
                         call_595444.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595444, url, valid)

proc call*(call_595445: Call_ContentShippingsettingsUpdate_595431;
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
  var path_595446 = newJObject()
  var query_595447 = newJObject()
  var body_595448 = newJObject()
  add(query_595447, "fields", newJString(fields))
  add(query_595447, "quotaUser", newJString(quotaUser))
  add(query_595447, "alt", newJString(alt))
  add(query_595447, "oauth_token", newJString(oauthToken))
  add(path_595446, "accountId", newJString(accountId))
  add(query_595447, "userIp", newJString(userIp))
  add(query_595447, "key", newJString(key))
  add(path_595446, "merchantId", newJString(merchantId))
  if body != nil:
    body_595448 = body
  add(query_595447, "prettyPrint", newJBool(prettyPrint))
  result = call_595445.call(path_595446, query_595447, nil, nil, body_595448)

var contentShippingsettingsUpdate* = Call_ContentShippingsettingsUpdate_595431(
    name: "contentShippingsettingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{merchantId}/shippingsettings/{accountId}",
    validator: validate_ContentShippingsettingsUpdate_595432,
    base: "/content/v2.1", url: url_ContentShippingsettingsUpdate_595433,
    schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGet_595415 = ref object of OpenApiRestCall_593421
proc url_ContentShippingsettingsGet_595417(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentShippingsettingsGet_595416(path: JsonNode; query: JsonNode;
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
  var valid_595418 = path.getOrDefault("accountId")
  valid_595418 = validateParameter(valid_595418, JString, required = true,
                                 default = nil)
  if valid_595418 != nil:
    section.add "accountId", valid_595418
  var valid_595419 = path.getOrDefault("merchantId")
  valid_595419 = validateParameter(valid_595419, JString, required = true,
                                 default = nil)
  if valid_595419 != nil:
    section.add "merchantId", valid_595419
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
  var valid_595420 = query.getOrDefault("fields")
  valid_595420 = validateParameter(valid_595420, JString, required = false,
                                 default = nil)
  if valid_595420 != nil:
    section.add "fields", valid_595420
  var valid_595421 = query.getOrDefault("quotaUser")
  valid_595421 = validateParameter(valid_595421, JString, required = false,
                                 default = nil)
  if valid_595421 != nil:
    section.add "quotaUser", valid_595421
  var valid_595422 = query.getOrDefault("alt")
  valid_595422 = validateParameter(valid_595422, JString, required = false,
                                 default = newJString("json"))
  if valid_595422 != nil:
    section.add "alt", valid_595422
  var valid_595423 = query.getOrDefault("oauth_token")
  valid_595423 = validateParameter(valid_595423, JString, required = false,
                                 default = nil)
  if valid_595423 != nil:
    section.add "oauth_token", valid_595423
  var valid_595424 = query.getOrDefault("userIp")
  valid_595424 = validateParameter(valid_595424, JString, required = false,
                                 default = nil)
  if valid_595424 != nil:
    section.add "userIp", valid_595424
  var valid_595425 = query.getOrDefault("key")
  valid_595425 = validateParameter(valid_595425, JString, required = false,
                                 default = nil)
  if valid_595425 != nil:
    section.add "key", valid_595425
  var valid_595426 = query.getOrDefault("prettyPrint")
  valid_595426 = validateParameter(valid_595426, JBool, required = false,
                                 default = newJBool(true))
  if valid_595426 != nil:
    section.add "prettyPrint", valid_595426
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595427: Call_ContentShippingsettingsGet_595415; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the shipping settings of the account.
  ## 
  let valid = call_595427.validator(path, query, header, formData, body)
  let scheme = call_595427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595427.url(scheme.get, call_595427.host, call_595427.base,
                         call_595427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595427, url, valid)

proc call*(call_595428: Call_ContentShippingsettingsGet_595415; accountId: string;
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
  var path_595429 = newJObject()
  var query_595430 = newJObject()
  add(query_595430, "fields", newJString(fields))
  add(query_595430, "quotaUser", newJString(quotaUser))
  add(query_595430, "alt", newJString(alt))
  add(query_595430, "oauth_token", newJString(oauthToken))
  add(path_595429, "accountId", newJString(accountId))
  add(query_595430, "userIp", newJString(userIp))
  add(query_595430, "key", newJString(key))
  add(path_595429, "merchantId", newJString(merchantId))
  add(query_595430, "prettyPrint", newJBool(prettyPrint))
  result = call_595428.call(path_595429, query_595430, nil, nil, nil)

var contentShippingsettingsGet* = Call_ContentShippingsettingsGet_595415(
    name: "contentShippingsettingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/shippingsettings/{accountId}",
    validator: validate_ContentShippingsettingsGet_595416, base: "/content/v2.1",
    url: url_ContentShippingsettingsGet_595417, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGetsupportedcarriers_595449 = ref object of OpenApiRestCall_593421
proc url_ContentShippingsettingsGetsupportedcarriers_595451(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentShippingsettingsGetsupportedcarriers_595450(path: JsonNode;
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
  var valid_595452 = path.getOrDefault("merchantId")
  valid_595452 = validateParameter(valid_595452, JString, required = true,
                                 default = nil)
  if valid_595452 != nil:
    section.add "merchantId", valid_595452
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
  var valid_595453 = query.getOrDefault("fields")
  valid_595453 = validateParameter(valid_595453, JString, required = false,
                                 default = nil)
  if valid_595453 != nil:
    section.add "fields", valid_595453
  var valid_595454 = query.getOrDefault("quotaUser")
  valid_595454 = validateParameter(valid_595454, JString, required = false,
                                 default = nil)
  if valid_595454 != nil:
    section.add "quotaUser", valid_595454
  var valid_595455 = query.getOrDefault("alt")
  valid_595455 = validateParameter(valid_595455, JString, required = false,
                                 default = newJString("json"))
  if valid_595455 != nil:
    section.add "alt", valid_595455
  var valid_595456 = query.getOrDefault("oauth_token")
  valid_595456 = validateParameter(valid_595456, JString, required = false,
                                 default = nil)
  if valid_595456 != nil:
    section.add "oauth_token", valid_595456
  var valid_595457 = query.getOrDefault("userIp")
  valid_595457 = validateParameter(valid_595457, JString, required = false,
                                 default = nil)
  if valid_595457 != nil:
    section.add "userIp", valid_595457
  var valid_595458 = query.getOrDefault("key")
  valid_595458 = validateParameter(valid_595458, JString, required = false,
                                 default = nil)
  if valid_595458 != nil:
    section.add "key", valid_595458
  var valid_595459 = query.getOrDefault("prettyPrint")
  valid_595459 = validateParameter(valid_595459, JBool, required = false,
                                 default = newJBool(true))
  if valid_595459 != nil:
    section.add "prettyPrint", valid_595459
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595460: Call_ContentShippingsettingsGetsupportedcarriers_595449;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves supported carriers and carrier services for an account.
  ## 
  let valid = call_595460.validator(path, query, header, formData, body)
  let scheme = call_595460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595460.url(scheme.get, call_595460.host, call_595460.base,
                         call_595460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595460, url, valid)

proc call*(call_595461: Call_ContentShippingsettingsGetsupportedcarriers_595449;
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
  var path_595462 = newJObject()
  var query_595463 = newJObject()
  add(query_595463, "fields", newJString(fields))
  add(query_595463, "quotaUser", newJString(quotaUser))
  add(query_595463, "alt", newJString(alt))
  add(query_595463, "oauth_token", newJString(oauthToken))
  add(query_595463, "userIp", newJString(userIp))
  add(query_595463, "key", newJString(key))
  add(path_595462, "merchantId", newJString(merchantId))
  add(query_595463, "prettyPrint", newJBool(prettyPrint))
  result = call_595461.call(path_595462, query_595463, nil, nil, nil)

var contentShippingsettingsGetsupportedcarriers* = Call_ContentShippingsettingsGetsupportedcarriers_595449(
    name: "contentShippingsettingsGetsupportedcarriers", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/supportedCarriers",
    validator: validate_ContentShippingsettingsGetsupportedcarriers_595450,
    base: "/content/v2.1", url: url_ContentShippingsettingsGetsupportedcarriers_595451,
    schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGetsupportedholidays_595464 = ref object of OpenApiRestCall_593421
proc url_ContentShippingsettingsGetsupportedholidays_595466(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentShippingsettingsGetsupportedholidays_595465(path: JsonNode;
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
  var valid_595467 = path.getOrDefault("merchantId")
  valid_595467 = validateParameter(valid_595467, JString, required = true,
                                 default = nil)
  if valid_595467 != nil:
    section.add "merchantId", valid_595467
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
  var valid_595468 = query.getOrDefault("fields")
  valid_595468 = validateParameter(valid_595468, JString, required = false,
                                 default = nil)
  if valid_595468 != nil:
    section.add "fields", valid_595468
  var valid_595469 = query.getOrDefault("quotaUser")
  valid_595469 = validateParameter(valid_595469, JString, required = false,
                                 default = nil)
  if valid_595469 != nil:
    section.add "quotaUser", valid_595469
  var valid_595470 = query.getOrDefault("alt")
  valid_595470 = validateParameter(valid_595470, JString, required = false,
                                 default = newJString("json"))
  if valid_595470 != nil:
    section.add "alt", valid_595470
  var valid_595471 = query.getOrDefault("oauth_token")
  valid_595471 = validateParameter(valid_595471, JString, required = false,
                                 default = nil)
  if valid_595471 != nil:
    section.add "oauth_token", valid_595471
  var valid_595472 = query.getOrDefault("userIp")
  valid_595472 = validateParameter(valid_595472, JString, required = false,
                                 default = nil)
  if valid_595472 != nil:
    section.add "userIp", valid_595472
  var valid_595473 = query.getOrDefault("key")
  valid_595473 = validateParameter(valid_595473, JString, required = false,
                                 default = nil)
  if valid_595473 != nil:
    section.add "key", valid_595473
  var valid_595474 = query.getOrDefault("prettyPrint")
  valid_595474 = validateParameter(valid_595474, JBool, required = false,
                                 default = newJBool(true))
  if valid_595474 != nil:
    section.add "prettyPrint", valid_595474
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595475: Call_ContentShippingsettingsGetsupportedholidays_595464;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves supported holidays for an account.
  ## 
  let valid = call_595475.validator(path, query, header, formData, body)
  let scheme = call_595475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595475.url(scheme.get, call_595475.host, call_595475.base,
                         call_595475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595475, url, valid)

proc call*(call_595476: Call_ContentShippingsettingsGetsupportedholidays_595464;
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
  var path_595477 = newJObject()
  var query_595478 = newJObject()
  add(query_595478, "fields", newJString(fields))
  add(query_595478, "quotaUser", newJString(quotaUser))
  add(query_595478, "alt", newJString(alt))
  add(query_595478, "oauth_token", newJString(oauthToken))
  add(query_595478, "userIp", newJString(userIp))
  add(query_595478, "key", newJString(key))
  add(path_595477, "merchantId", newJString(merchantId))
  add(query_595478, "prettyPrint", newJBool(prettyPrint))
  result = call_595476.call(path_595477, query_595478, nil, nil, nil)

var contentShippingsettingsGetsupportedholidays* = Call_ContentShippingsettingsGetsupportedholidays_595464(
    name: "contentShippingsettingsGetsupportedholidays", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/supportedHolidays",
    validator: validate_ContentShippingsettingsGetsupportedholidays_595465,
    base: "/content/v2.1", url: url_ContentShippingsettingsGetsupportedholidays_595466,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersCreatetestorder_595479 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersCreatetestorder_595481(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentOrdersCreatetestorder_595480(path: JsonNode; query: JsonNode;
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
  var valid_595482 = path.getOrDefault("merchantId")
  valid_595482 = validateParameter(valid_595482, JString, required = true,
                                 default = nil)
  if valid_595482 != nil:
    section.add "merchantId", valid_595482
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
  var valid_595483 = query.getOrDefault("fields")
  valid_595483 = validateParameter(valid_595483, JString, required = false,
                                 default = nil)
  if valid_595483 != nil:
    section.add "fields", valid_595483
  var valid_595484 = query.getOrDefault("quotaUser")
  valid_595484 = validateParameter(valid_595484, JString, required = false,
                                 default = nil)
  if valid_595484 != nil:
    section.add "quotaUser", valid_595484
  var valid_595485 = query.getOrDefault("alt")
  valid_595485 = validateParameter(valid_595485, JString, required = false,
                                 default = newJString("json"))
  if valid_595485 != nil:
    section.add "alt", valid_595485
  var valid_595486 = query.getOrDefault("oauth_token")
  valid_595486 = validateParameter(valid_595486, JString, required = false,
                                 default = nil)
  if valid_595486 != nil:
    section.add "oauth_token", valid_595486
  var valid_595487 = query.getOrDefault("userIp")
  valid_595487 = validateParameter(valid_595487, JString, required = false,
                                 default = nil)
  if valid_595487 != nil:
    section.add "userIp", valid_595487
  var valid_595488 = query.getOrDefault("key")
  valid_595488 = validateParameter(valid_595488, JString, required = false,
                                 default = nil)
  if valid_595488 != nil:
    section.add "key", valid_595488
  var valid_595489 = query.getOrDefault("prettyPrint")
  valid_595489 = validateParameter(valid_595489, JBool, required = false,
                                 default = newJBool(true))
  if valid_595489 != nil:
    section.add "prettyPrint", valid_595489
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

proc call*(call_595491: Call_ContentOrdersCreatetestorder_595479; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Creates a test order.
  ## 
  let valid = call_595491.validator(path, query, header, formData, body)
  let scheme = call_595491.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595491.url(scheme.get, call_595491.host, call_595491.base,
                         call_595491.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595491, url, valid)

proc call*(call_595492: Call_ContentOrdersCreatetestorder_595479;
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
  var path_595493 = newJObject()
  var query_595494 = newJObject()
  var body_595495 = newJObject()
  add(query_595494, "fields", newJString(fields))
  add(query_595494, "quotaUser", newJString(quotaUser))
  add(query_595494, "alt", newJString(alt))
  add(query_595494, "oauth_token", newJString(oauthToken))
  add(query_595494, "userIp", newJString(userIp))
  add(query_595494, "key", newJString(key))
  add(path_595493, "merchantId", newJString(merchantId))
  if body != nil:
    body_595495 = body
  add(query_595494, "prettyPrint", newJBool(prettyPrint))
  result = call_595492.call(path_595493, query_595494, nil, nil, body_595495)

var contentOrdersCreatetestorder* = Call_ContentOrdersCreatetestorder_595479(
    name: "contentOrdersCreatetestorder", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/testorders",
    validator: validate_ContentOrdersCreatetestorder_595480,
    base: "/content/v2.1", url: url_ContentOrdersCreatetestorder_595481,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersAdvancetestorder_595496 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersAdvancetestorder_595498(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentOrdersAdvancetestorder_595497(path: JsonNode; query: JsonNode;
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
  var valid_595499 = path.getOrDefault("orderId")
  valid_595499 = validateParameter(valid_595499, JString, required = true,
                                 default = nil)
  if valid_595499 != nil:
    section.add "orderId", valid_595499
  var valid_595500 = path.getOrDefault("merchantId")
  valid_595500 = validateParameter(valid_595500, JString, required = true,
                                 default = nil)
  if valid_595500 != nil:
    section.add "merchantId", valid_595500
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
  var valid_595501 = query.getOrDefault("fields")
  valid_595501 = validateParameter(valid_595501, JString, required = false,
                                 default = nil)
  if valid_595501 != nil:
    section.add "fields", valid_595501
  var valid_595502 = query.getOrDefault("quotaUser")
  valid_595502 = validateParameter(valid_595502, JString, required = false,
                                 default = nil)
  if valid_595502 != nil:
    section.add "quotaUser", valid_595502
  var valid_595503 = query.getOrDefault("alt")
  valid_595503 = validateParameter(valid_595503, JString, required = false,
                                 default = newJString("json"))
  if valid_595503 != nil:
    section.add "alt", valid_595503
  var valid_595504 = query.getOrDefault("oauth_token")
  valid_595504 = validateParameter(valid_595504, JString, required = false,
                                 default = nil)
  if valid_595504 != nil:
    section.add "oauth_token", valid_595504
  var valid_595505 = query.getOrDefault("userIp")
  valid_595505 = validateParameter(valid_595505, JString, required = false,
                                 default = nil)
  if valid_595505 != nil:
    section.add "userIp", valid_595505
  var valid_595506 = query.getOrDefault("key")
  valid_595506 = validateParameter(valid_595506, JString, required = false,
                                 default = nil)
  if valid_595506 != nil:
    section.add "key", valid_595506
  var valid_595507 = query.getOrDefault("prettyPrint")
  valid_595507 = validateParameter(valid_595507, JBool, required = false,
                                 default = newJBool(true))
  if valid_595507 != nil:
    section.add "prettyPrint", valid_595507
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595508: Call_ContentOrdersAdvancetestorder_595496; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Moves a test order from state "inProgress" to state "pendingShipment".
  ## 
  let valid = call_595508.validator(path, query, header, formData, body)
  let scheme = call_595508.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595508.url(scheme.get, call_595508.host, call_595508.base,
                         call_595508.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595508, url, valid)

proc call*(call_595509: Call_ContentOrdersAdvancetestorder_595496; orderId: string;
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
  var path_595510 = newJObject()
  var query_595511 = newJObject()
  add(query_595511, "fields", newJString(fields))
  add(query_595511, "quotaUser", newJString(quotaUser))
  add(query_595511, "alt", newJString(alt))
  add(query_595511, "oauth_token", newJString(oauthToken))
  add(query_595511, "userIp", newJString(userIp))
  add(path_595510, "orderId", newJString(orderId))
  add(query_595511, "key", newJString(key))
  add(path_595510, "merchantId", newJString(merchantId))
  add(query_595511, "prettyPrint", newJBool(prettyPrint))
  result = call_595509.call(path_595510, query_595511, nil, nil, nil)

var contentOrdersAdvancetestorder* = Call_ContentOrdersAdvancetestorder_595496(
    name: "contentOrdersAdvancetestorder", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/testorders/{orderId}/advance",
    validator: validate_ContentOrdersAdvancetestorder_595497,
    base: "/content/v2.1", url: url_ContentOrdersAdvancetestorder_595498,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersCanceltestorderbycustomer_595512 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersCanceltestorderbycustomer_595514(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentOrdersCanceltestorderbycustomer_595513(path: JsonNode;
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
  var valid_595515 = path.getOrDefault("orderId")
  valid_595515 = validateParameter(valid_595515, JString, required = true,
                                 default = nil)
  if valid_595515 != nil:
    section.add "orderId", valid_595515
  var valid_595516 = path.getOrDefault("merchantId")
  valid_595516 = validateParameter(valid_595516, JString, required = true,
                                 default = nil)
  if valid_595516 != nil:
    section.add "merchantId", valid_595516
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
  var valid_595517 = query.getOrDefault("fields")
  valid_595517 = validateParameter(valid_595517, JString, required = false,
                                 default = nil)
  if valid_595517 != nil:
    section.add "fields", valid_595517
  var valid_595518 = query.getOrDefault("quotaUser")
  valid_595518 = validateParameter(valid_595518, JString, required = false,
                                 default = nil)
  if valid_595518 != nil:
    section.add "quotaUser", valid_595518
  var valid_595519 = query.getOrDefault("alt")
  valid_595519 = validateParameter(valid_595519, JString, required = false,
                                 default = newJString("json"))
  if valid_595519 != nil:
    section.add "alt", valid_595519
  var valid_595520 = query.getOrDefault("oauth_token")
  valid_595520 = validateParameter(valid_595520, JString, required = false,
                                 default = nil)
  if valid_595520 != nil:
    section.add "oauth_token", valid_595520
  var valid_595521 = query.getOrDefault("userIp")
  valid_595521 = validateParameter(valid_595521, JString, required = false,
                                 default = nil)
  if valid_595521 != nil:
    section.add "userIp", valid_595521
  var valid_595522 = query.getOrDefault("key")
  valid_595522 = validateParameter(valid_595522, JString, required = false,
                                 default = nil)
  if valid_595522 != nil:
    section.add "key", valid_595522
  var valid_595523 = query.getOrDefault("prettyPrint")
  valid_595523 = validateParameter(valid_595523, JBool, required = false,
                                 default = newJBool(true))
  if valid_595523 != nil:
    section.add "prettyPrint", valid_595523
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

proc call*(call_595525: Call_ContentOrdersCanceltestorderbycustomer_595512;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sandbox only. Cancels a test order for customer-initiated cancellation.
  ## 
  let valid = call_595525.validator(path, query, header, formData, body)
  let scheme = call_595525.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595525.url(scheme.get, call_595525.host, call_595525.base,
                         call_595525.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595525, url, valid)

proc call*(call_595526: Call_ContentOrdersCanceltestorderbycustomer_595512;
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
  var path_595527 = newJObject()
  var query_595528 = newJObject()
  var body_595529 = newJObject()
  add(query_595528, "fields", newJString(fields))
  add(query_595528, "quotaUser", newJString(quotaUser))
  add(query_595528, "alt", newJString(alt))
  add(query_595528, "oauth_token", newJString(oauthToken))
  add(query_595528, "userIp", newJString(userIp))
  add(path_595527, "orderId", newJString(orderId))
  add(query_595528, "key", newJString(key))
  add(path_595527, "merchantId", newJString(merchantId))
  if body != nil:
    body_595529 = body
  add(query_595528, "prettyPrint", newJBool(prettyPrint))
  result = call_595526.call(path_595527, query_595528, nil, nil, body_595529)

var contentOrdersCanceltestorderbycustomer* = Call_ContentOrdersCanceltestorderbycustomer_595512(
    name: "contentOrdersCanceltestorderbycustomer", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/testorders/{orderId}/cancelByCustomer",
    validator: validate_ContentOrdersCanceltestorderbycustomer_595513,
    base: "/content/v2.1", url: url_ContentOrdersCanceltestorderbycustomer_595514,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersGettestordertemplate_595530 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersGettestordertemplate_595532(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentOrdersGettestordertemplate_595531(path: JsonNode;
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
  var valid_595533 = path.getOrDefault("templateName")
  valid_595533 = validateParameter(valid_595533, JString, required = true,
                                 default = newJString("template1"))
  if valid_595533 != nil:
    section.add "templateName", valid_595533
  var valid_595534 = path.getOrDefault("merchantId")
  valid_595534 = validateParameter(valid_595534, JString, required = true,
                                 default = nil)
  if valid_595534 != nil:
    section.add "merchantId", valid_595534
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
  var valid_595535 = query.getOrDefault("fields")
  valid_595535 = validateParameter(valid_595535, JString, required = false,
                                 default = nil)
  if valid_595535 != nil:
    section.add "fields", valid_595535
  var valid_595536 = query.getOrDefault("country")
  valid_595536 = validateParameter(valid_595536, JString, required = false,
                                 default = nil)
  if valid_595536 != nil:
    section.add "country", valid_595536
  var valid_595537 = query.getOrDefault("quotaUser")
  valid_595537 = validateParameter(valid_595537, JString, required = false,
                                 default = nil)
  if valid_595537 != nil:
    section.add "quotaUser", valid_595537
  var valid_595538 = query.getOrDefault("alt")
  valid_595538 = validateParameter(valid_595538, JString, required = false,
                                 default = newJString("json"))
  if valid_595538 != nil:
    section.add "alt", valid_595538
  var valid_595539 = query.getOrDefault("oauth_token")
  valid_595539 = validateParameter(valid_595539, JString, required = false,
                                 default = nil)
  if valid_595539 != nil:
    section.add "oauth_token", valid_595539
  var valid_595540 = query.getOrDefault("userIp")
  valid_595540 = validateParameter(valid_595540, JString, required = false,
                                 default = nil)
  if valid_595540 != nil:
    section.add "userIp", valid_595540
  var valid_595541 = query.getOrDefault("key")
  valid_595541 = validateParameter(valid_595541, JString, required = false,
                                 default = nil)
  if valid_595541 != nil:
    section.add "key", valid_595541
  var valid_595542 = query.getOrDefault("prettyPrint")
  valid_595542 = validateParameter(valid_595542, JBool, required = false,
                                 default = newJBool(true))
  if valid_595542 != nil:
    section.add "prettyPrint", valid_595542
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595543: Call_ContentOrdersGettestordertemplate_595530;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sandbox only. Retrieves an order template that can be used to quickly create a new order in sandbox.
  ## 
  let valid = call_595543.validator(path, query, header, formData, body)
  let scheme = call_595543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595543.url(scheme.get, call_595543.host, call_595543.base,
                         call_595543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595543, url, valid)

proc call*(call_595544: Call_ContentOrdersGettestordertemplate_595530;
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
  var path_595545 = newJObject()
  var query_595546 = newJObject()
  add(query_595546, "fields", newJString(fields))
  add(query_595546, "country", newJString(country))
  add(query_595546, "quotaUser", newJString(quotaUser))
  add(query_595546, "alt", newJString(alt))
  add(query_595546, "oauth_token", newJString(oauthToken))
  add(query_595546, "userIp", newJString(userIp))
  add(path_595545, "templateName", newJString(templateName))
  add(query_595546, "key", newJString(key))
  add(path_595545, "merchantId", newJString(merchantId))
  add(query_595546, "prettyPrint", newJBool(prettyPrint))
  result = call_595544.call(path_595545, query_595546, nil, nil, nil)

var contentOrdersGettestordertemplate* = Call_ContentOrdersGettestordertemplate_595530(
    name: "contentOrdersGettestordertemplate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/testordertemplates/{templateName}",
    validator: validate_ContentOrdersGettestordertemplate_595531,
    base: "/content/v2.1", url: url_ContentOrdersGettestordertemplate_595532,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
