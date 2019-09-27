
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  Call_ContentAccountsAuthinfo_593689 = ref object of OpenApiRestCall_593421
proc url_ContentAccountsAuthinfo_593691(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ContentAccountsAuthinfo_593690(path: JsonNode; query: JsonNode;
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
  var valid_593803 = query.getOrDefault("fields")
  valid_593803 = validateParameter(valid_593803, JString, required = false,
                                 default = nil)
  if valid_593803 != nil:
    section.add "fields", valid_593803
  var valid_593804 = query.getOrDefault("quotaUser")
  valid_593804 = validateParameter(valid_593804, JString, required = false,
                                 default = nil)
  if valid_593804 != nil:
    section.add "quotaUser", valid_593804
  var valid_593818 = query.getOrDefault("alt")
  valid_593818 = validateParameter(valid_593818, JString, required = false,
                                 default = newJString("json"))
  if valid_593818 != nil:
    section.add "alt", valid_593818
  var valid_593819 = query.getOrDefault("oauth_token")
  valid_593819 = validateParameter(valid_593819, JString, required = false,
                                 default = nil)
  if valid_593819 != nil:
    section.add "oauth_token", valid_593819
  var valid_593820 = query.getOrDefault("userIp")
  valid_593820 = validateParameter(valid_593820, JString, required = false,
                                 default = nil)
  if valid_593820 != nil:
    section.add "userIp", valid_593820
  var valid_593821 = query.getOrDefault("key")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = nil)
  if valid_593821 != nil:
    section.add "key", valid_593821
  var valid_593822 = query.getOrDefault("prettyPrint")
  valid_593822 = validateParameter(valid_593822, JBool, required = false,
                                 default = newJBool(true))
  if valid_593822 != nil:
    section.add "prettyPrint", valid_593822
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593845: Call_ContentAccountsAuthinfo_593689; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about the authenticated user.
  ## 
  let valid = call_593845.validator(path, query, header, formData, body)
  let scheme = call_593845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593845.url(scheme.get, call_593845.host, call_593845.base,
                         call_593845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593845, url, valid)

proc call*(call_593916: Call_ContentAccountsAuthinfo_593689; fields: string = "";
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
  var query_593917 = newJObject()
  add(query_593917, "fields", newJString(fields))
  add(query_593917, "quotaUser", newJString(quotaUser))
  add(query_593917, "alt", newJString(alt))
  add(query_593917, "oauth_token", newJString(oauthToken))
  add(query_593917, "userIp", newJString(userIp))
  add(query_593917, "key", newJString(key))
  add(query_593917, "prettyPrint", newJBool(prettyPrint))
  result = call_593916.call(nil, query_593917, nil, nil, nil)

var contentAccountsAuthinfo* = Call_ContentAccountsAuthinfo_593689(
    name: "contentAccountsAuthinfo", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/authinfo",
    validator: validate_ContentAccountsAuthinfo_593690, base: "/content/v2",
    url: url_ContentAccountsAuthinfo_593691, schemes: {Scheme.Https})
type
  Call_ContentAccountsCustombatch_593957 = ref object of OpenApiRestCall_593421
proc url_ContentAccountsCustombatch_593959(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ContentAccountsCustombatch_593958(path: JsonNode; query: JsonNode;
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
  var valid_593960 = query.getOrDefault("fields")
  valid_593960 = validateParameter(valid_593960, JString, required = false,
                                 default = nil)
  if valid_593960 != nil:
    section.add "fields", valid_593960
  var valid_593961 = query.getOrDefault("quotaUser")
  valid_593961 = validateParameter(valid_593961, JString, required = false,
                                 default = nil)
  if valid_593961 != nil:
    section.add "quotaUser", valid_593961
  var valid_593962 = query.getOrDefault("alt")
  valid_593962 = validateParameter(valid_593962, JString, required = false,
                                 default = newJString("json"))
  if valid_593962 != nil:
    section.add "alt", valid_593962
  var valid_593963 = query.getOrDefault("dryRun")
  valid_593963 = validateParameter(valid_593963, JBool, required = false, default = nil)
  if valid_593963 != nil:
    section.add "dryRun", valid_593963
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

proc call*(call_593969: Call_ContentAccountsCustombatch_593957; path: JsonNode;
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

proc call*(call_593970: Call_ContentAccountsCustombatch_593957;
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
  var query_593971 = newJObject()
  var body_593972 = newJObject()
  add(query_593971, "fields", newJString(fields))
  add(query_593971, "quotaUser", newJString(quotaUser))
  add(query_593971, "alt", newJString(alt))
  add(query_593971, "dryRun", newJBool(dryRun))
  add(query_593971, "oauth_token", newJString(oauthToken))
  add(query_593971, "userIp", newJString(userIp))
  add(query_593971, "key", newJString(key))
  if body != nil:
    body_593972 = body
  add(query_593971, "prettyPrint", newJBool(prettyPrint))
  result = call_593970.call(nil, query_593971, nil, nil, body_593972)

var contentAccountsCustombatch* = Call_ContentAccountsCustombatch_593957(
    name: "contentAccountsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accounts/batch",
    validator: validate_ContentAccountsCustombatch_593958, base: "/content/v2",
    url: url_ContentAccountsCustombatch_593959, schemes: {Scheme.Https})
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
    base: "/content/v2", url: url_ContentAccountstatusesCustombatch_593975,
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
  var valid_593994 = query.getOrDefault("dryRun")
  valid_593994 = validateParameter(valid_593994, JBool, required = false, default = nil)
  if valid_593994 != nil:
    section.add "dryRun", valid_593994
  var valid_593995 = query.getOrDefault("oauth_token")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "oauth_token", valid_593995
  var valid_593996 = query.getOrDefault("userIp")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "userIp", valid_593996
  var valid_593997 = query.getOrDefault("key")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "key", valid_593997
  var valid_593998 = query.getOrDefault("prettyPrint")
  valid_593998 = validateParameter(valid_593998, JBool, required = false,
                                 default = newJBool(true))
  if valid_593998 != nil:
    section.add "prettyPrint", valid_593998
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

proc call*(call_594000: Call_ContentAccounttaxCustombatch_593988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves and updates tax settings of multiple accounts in a single request.
  ## 
  let valid = call_594000.validator(path, query, header, formData, body)
  let scheme = call_594000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594000.url(scheme.get, call_594000.host, call_594000.base,
                         call_594000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594000, url, valid)

proc call*(call_594001: Call_ContentAccounttaxCustombatch_593988;
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
  var query_594002 = newJObject()
  var body_594003 = newJObject()
  add(query_594002, "fields", newJString(fields))
  add(query_594002, "quotaUser", newJString(quotaUser))
  add(query_594002, "alt", newJString(alt))
  add(query_594002, "dryRun", newJBool(dryRun))
  add(query_594002, "oauth_token", newJString(oauthToken))
  add(query_594002, "userIp", newJString(userIp))
  add(query_594002, "key", newJString(key))
  if body != nil:
    body_594003 = body
  add(query_594002, "prettyPrint", newJBool(prettyPrint))
  result = call_594001.call(nil, query_594002, nil, nil, body_594003)

var contentAccounttaxCustombatch* = Call_ContentAccounttaxCustombatch_593988(
    name: "contentAccounttaxCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accounttax/batch",
    validator: validate_ContentAccounttaxCustombatch_593989, base: "/content/v2",
    url: url_ContentAccounttaxCustombatch_593990, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsCustombatch_594004 = ref object of OpenApiRestCall_593421
proc url_ContentDatafeedsCustombatch_594006(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ContentDatafeedsCustombatch_594005(path: JsonNode; query: JsonNode;
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
  var valid_594007 = query.getOrDefault("fields")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "fields", valid_594007
  var valid_594008 = query.getOrDefault("quotaUser")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "quotaUser", valid_594008
  var valid_594009 = query.getOrDefault("alt")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = newJString("json"))
  if valid_594009 != nil:
    section.add "alt", valid_594009
  var valid_594010 = query.getOrDefault("dryRun")
  valid_594010 = validateParameter(valid_594010, JBool, required = false, default = nil)
  if valid_594010 != nil:
    section.add "dryRun", valid_594010
  var valid_594011 = query.getOrDefault("oauth_token")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "oauth_token", valid_594011
  var valid_594012 = query.getOrDefault("userIp")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "userIp", valid_594012
  var valid_594013 = query.getOrDefault("key")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "key", valid_594013
  var valid_594014 = query.getOrDefault("prettyPrint")
  valid_594014 = validateParameter(valid_594014, JBool, required = false,
                                 default = newJBool(true))
  if valid_594014 != nil:
    section.add "prettyPrint", valid_594014
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

proc call*(call_594016: Call_ContentDatafeedsCustombatch_594004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes, fetches, gets, inserts and updates multiple datafeeds in a single request.
  ## 
  let valid = call_594016.validator(path, query, header, formData, body)
  let scheme = call_594016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594016.url(scheme.get, call_594016.host, call_594016.base,
                         call_594016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594016, url, valid)

proc call*(call_594017: Call_ContentDatafeedsCustombatch_594004;
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
  var query_594018 = newJObject()
  var body_594019 = newJObject()
  add(query_594018, "fields", newJString(fields))
  add(query_594018, "quotaUser", newJString(quotaUser))
  add(query_594018, "alt", newJString(alt))
  add(query_594018, "dryRun", newJBool(dryRun))
  add(query_594018, "oauth_token", newJString(oauthToken))
  add(query_594018, "userIp", newJString(userIp))
  add(query_594018, "key", newJString(key))
  if body != nil:
    body_594019 = body
  add(query_594018, "prettyPrint", newJBool(prettyPrint))
  result = call_594017.call(nil, query_594018, nil, nil, body_594019)

var contentDatafeedsCustombatch* = Call_ContentDatafeedsCustombatch_594004(
    name: "contentDatafeedsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/datafeeds/batch",
    validator: validate_ContentDatafeedsCustombatch_594005, base: "/content/v2",
    url: url_ContentDatafeedsCustombatch_594006, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesCustombatch_594020 = ref object of OpenApiRestCall_593421
proc url_ContentDatafeedstatusesCustombatch_594022(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ContentDatafeedstatusesCustombatch_594021(path: JsonNode;
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
  var valid_594023 = query.getOrDefault("fields")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "fields", valid_594023
  var valid_594024 = query.getOrDefault("quotaUser")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "quotaUser", valid_594024
  var valid_594025 = query.getOrDefault("alt")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = newJString("json"))
  if valid_594025 != nil:
    section.add "alt", valid_594025
  var valid_594026 = query.getOrDefault("oauth_token")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "oauth_token", valid_594026
  var valid_594027 = query.getOrDefault("userIp")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "userIp", valid_594027
  var valid_594028 = query.getOrDefault("key")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "key", valid_594028
  var valid_594029 = query.getOrDefault("prettyPrint")
  valid_594029 = validateParameter(valid_594029, JBool, required = false,
                                 default = newJBool(true))
  if valid_594029 != nil:
    section.add "prettyPrint", valid_594029
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

proc call*(call_594031: Call_ContentDatafeedstatusesCustombatch_594020;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets multiple Merchant Center datafeed statuses in a single request.
  ## 
  let valid = call_594031.validator(path, query, header, formData, body)
  let scheme = call_594031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594031.url(scheme.get, call_594031.host, call_594031.base,
                         call_594031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594031, url, valid)

proc call*(call_594032: Call_ContentDatafeedstatusesCustombatch_594020;
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
  var query_594033 = newJObject()
  var body_594034 = newJObject()
  add(query_594033, "fields", newJString(fields))
  add(query_594033, "quotaUser", newJString(quotaUser))
  add(query_594033, "alt", newJString(alt))
  add(query_594033, "oauth_token", newJString(oauthToken))
  add(query_594033, "userIp", newJString(userIp))
  add(query_594033, "key", newJString(key))
  if body != nil:
    body_594034 = body
  add(query_594033, "prettyPrint", newJBool(prettyPrint))
  result = call_594032.call(nil, query_594033, nil, nil, body_594034)

var contentDatafeedstatusesCustombatch* = Call_ContentDatafeedstatusesCustombatch_594020(
    name: "contentDatafeedstatusesCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/datafeedstatuses/batch",
    validator: validate_ContentDatafeedstatusesCustombatch_594021,
    base: "/content/v2", url: url_ContentDatafeedstatusesCustombatch_594022,
    schemes: {Scheme.Https})
type
  Call_ContentInventoryCustombatch_594035 = ref object of OpenApiRestCall_593421
proc url_ContentInventoryCustombatch_594037(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ContentInventoryCustombatch_594036(path: JsonNode; query: JsonNode;
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
  var valid_594038 = query.getOrDefault("fields")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "fields", valid_594038
  var valid_594039 = query.getOrDefault("quotaUser")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "quotaUser", valid_594039
  var valid_594040 = query.getOrDefault("alt")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = newJString("json"))
  if valid_594040 != nil:
    section.add "alt", valid_594040
  var valid_594041 = query.getOrDefault("dryRun")
  valid_594041 = validateParameter(valid_594041, JBool, required = false, default = nil)
  if valid_594041 != nil:
    section.add "dryRun", valid_594041
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594047: Call_ContentInventoryCustombatch_594035; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates price and availability for multiple products or stores in a single request. This operation does not update the expiration date of the products.
  ## 
  let valid = call_594047.validator(path, query, header, formData, body)
  let scheme = call_594047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594047.url(scheme.get, call_594047.host, call_594047.base,
                         call_594047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594047, url, valid)

proc call*(call_594048: Call_ContentInventoryCustombatch_594035;
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
  var query_594049 = newJObject()
  var body_594050 = newJObject()
  add(query_594049, "fields", newJString(fields))
  add(query_594049, "quotaUser", newJString(quotaUser))
  add(query_594049, "alt", newJString(alt))
  add(query_594049, "dryRun", newJBool(dryRun))
  add(query_594049, "oauth_token", newJString(oauthToken))
  add(query_594049, "userIp", newJString(userIp))
  add(query_594049, "key", newJString(key))
  if body != nil:
    body_594050 = body
  add(query_594049, "prettyPrint", newJBool(prettyPrint))
  result = call_594048.call(nil, query_594049, nil, nil, body_594050)

var contentInventoryCustombatch* = Call_ContentInventoryCustombatch_594035(
    name: "contentInventoryCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/inventory/batch",
    validator: validate_ContentInventoryCustombatch_594036, base: "/content/v2",
    url: url_ContentInventoryCustombatch_594037, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsCustombatch_594051 = ref object of OpenApiRestCall_593421
proc url_ContentLiasettingsCustombatch_594053(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ContentLiasettingsCustombatch_594052(path: JsonNode; query: JsonNode;
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
  var valid_594054 = query.getOrDefault("fields")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "fields", valid_594054
  var valid_594055 = query.getOrDefault("quotaUser")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "quotaUser", valid_594055
  var valid_594056 = query.getOrDefault("alt")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = newJString("json"))
  if valid_594056 != nil:
    section.add "alt", valid_594056
  var valid_594057 = query.getOrDefault("dryRun")
  valid_594057 = validateParameter(valid_594057, JBool, required = false, default = nil)
  if valid_594057 != nil:
    section.add "dryRun", valid_594057
  var valid_594058 = query.getOrDefault("oauth_token")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "oauth_token", valid_594058
  var valid_594059 = query.getOrDefault("userIp")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "userIp", valid_594059
  var valid_594060 = query.getOrDefault("key")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "key", valid_594060
  var valid_594061 = query.getOrDefault("prettyPrint")
  valid_594061 = validateParameter(valid_594061, JBool, required = false,
                                 default = newJBool(true))
  if valid_594061 != nil:
    section.add "prettyPrint", valid_594061
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

proc call*(call_594063: Call_ContentLiasettingsCustombatch_594051; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves and/or updates the LIA settings of multiple accounts in a single request.
  ## 
  let valid = call_594063.validator(path, query, header, formData, body)
  let scheme = call_594063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594063.url(scheme.get, call_594063.host, call_594063.base,
                         call_594063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594063, url, valid)

proc call*(call_594064: Call_ContentLiasettingsCustombatch_594051;
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
  var query_594065 = newJObject()
  var body_594066 = newJObject()
  add(query_594065, "fields", newJString(fields))
  add(query_594065, "quotaUser", newJString(quotaUser))
  add(query_594065, "alt", newJString(alt))
  add(query_594065, "dryRun", newJBool(dryRun))
  add(query_594065, "oauth_token", newJString(oauthToken))
  add(query_594065, "userIp", newJString(userIp))
  add(query_594065, "key", newJString(key))
  if body != nil:
    body_594066 = body
  add(query_594065, "prettyPrint", newJBool(prettyPrint))
  result = call_594064.call(nil, query_594065, nil, nil, body_594066)

var contentLiasettingsCustombatch* = Call_ContentLiasettingsCustombatch_594051(
    name: "contentLiasettingsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liasettings/batch",
    validator: validate_ContentLiasettingsCustombatch_594052, base: "/content/v2",
    url: url_ContentLiasettingsCustombatch_594053, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsListposdataproviders_594067 = ref object of OpenApiRestCall_593421
proc url_ContentLiasettingsListposdataproviders_594069(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ContentLiasettingsListposdataproviders_594068(path: JsonNode;
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
  var valid_594070 = query.getOrDefault("fields")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "fields", valid_594070
  var valid_594071 = query.getOrDefault("quotaUser")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "quotaUser", valid_594071
  var valid_594072 = query.getOrDefault("alt")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = newJString("json"))
  if valid_594072 != nil:
    section.add "alt", valid_594072
  var valid_594073 = query.getOrDefault("oauth_token")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "oauth_token", valid_594073
  var valid_594074 = query.getOrDefault("userIp")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "userIp", valid_594074
  var valid_594075 = query.getOrDefault("key")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "key", valid_594075
  var valid_594076 = query.getOrDefault("prettyPrint")
  valid_594076 = validateParameter(valid_594076, JBool, required = false,
                                 default = newJBool(true))
  if valid_594076 != nil:
    section.add "prettyPrint", valid_594076
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594077: Call_ContentLiasettingsListposdataproviders_594067;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of POS data providers that have active settings for the all eiligible countries.
  ## 
  let valid = call_594077.validator(path, query, header, formData, body)
  let scheme = call_594077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594077.url(scheme.get, call_594077.host, call_594077.base,
                         call_594077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594077, url, valid)

proc call*(call_594078: Call_ContentLiasettingsListposdataproviders_594067;
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
  var query_594079 = newJObject()
  add(query_594079, "fields", newJString(fields))
  add(query_594079, "quotaUser", newJString(quotaUser))
  add(query_594079, "alt", newJString(alt))
  add(query_594079, "oauth_token", newJString(oauthToken))
  add(query_594079, "userIp", newJString(userIp))
  add(query_594079, "key", newJString(key))
  add(query_594079, "prettyPrint", newJBool(prettyPrint))
  result = call_594078.call(nil, query_594079, nil, nil, nil)

var contentLiasettingsListposdataproviders* = Call_ContentLiasettingsListposdataproviders_594067(
    name: "contentLiasettingsListposdataproviders", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/liasettings/posdataproviders",
    validator: validate_ContentLiasettingsListposdataproviders_594068,
    base: "/content/v2", url: url_ContentLiasettingsListposdataproviders_594069,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersCustombatch_594080 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersCustombatch_594082(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ContentOrdersCustombatch_594081(path: JsonNode; query: JsonNode;
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
  var valid_594083 = query.getOrDefault("fields")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "fields", valid_594083
  var valid_594084 = query.getOrDefault("quotaUser")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "quotaUser", valid_594084
  var valid_594085 = query.getOrDefault("alt")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = newJString("json"))
  if valid_594085 != nil:
    section.add "alt", valid_594085
  var valid_594086 = query.getOrDefault("oauth_token")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "oauth_token", valid_594086
  var valid_594087 = query.getOrDefault("userIp")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "userIp", valid_594087
  var valid_594088 = query.getOrDefault("key")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = nil)
  if valid_594088 != nil:
    section.add "key", valid_594088
  var valid_594089 = query.getOrDefault("prettyPrint")
  valid_594089 = validateParameter(valid_594089, JBool, required = false,
                                 default = newJBool(true))
  if valid_594089 != nil:
    section.add "prettyPrint", valid_594089
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

proc call*(call_594091: Call_ContentOrdersCustombatch_594080; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves or modifies multiple orders in a single request.
  ## 
  let valid = call_594091.validator(path, query, header, formData, body)
  let scheme = call_594091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594091.url(scheme.get, call_594091.host, call_594091.base,
                         call_594091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594091, url, valid)

proc call*(call_594092: Call_ContentOrdersCustombatch_594080; fields: string = "";
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
  var query_594093 = newJObject()
  var body_594094 = newJObject()
  add(query_594093, "fields", newJString(fields))
  add(query_594093, "quotaUser", newJString(quotaUser))
  add(query_594093, "alt", newJString(alt))
  add(query_594093, "oauth_token", newJString(oauthToken))
  add(query_594093, "userIp", newJString(userIp))
  add(query_594093, "key", newJString(key))
  if body != nil:
    body_594094 = body
  add(query_594093, "prettyPrint", newJBool(prettyPrint))
  result = call_594092.call(nil, query_594093, nil, nil, body_594094)

var contentOrdersCustombatch* = Call_ContentOrdersCustombatch_594080(
    name: "contentOrdersCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/orders/batch",
    validator: validate_ContentOrdersCustombatch_594081, base: "/content/v2",
    url: url_ContentOrdersCustombatch_594082, schemes: {Scheme.Https})
type
  Call_ContentPosCustombatch_594095 = ref object of OpenApiRestCall_593421
proc url_ContentPosCustombatch_594097(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ContentPosCustombatch_594096(path: JsonNode; query: JsonNode;
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
  var valid_594098 = query.getOrDefault("fields")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "fields", valid_594098
  var valid_594099 = query.getOrDefault("quotaUser")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "quotaUser", valid_594099
  var valid_594100 = query.getOrDefault("alt")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = newJString("json"))
  if valid_594100 != nil:
    section.add "alt", valid_594100
  var valid_594101 = query.getOrDefault("dryRun")
  valid_594101 = validateParameter(valid_594101, JBool, required = false, default = nil)
  if valid_594101 != nil:
    section.add "dryRun", valid_594101
  var valid_594102 = query.getOrDefault("oauth_token")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = nil)
  if valid_594102 != nil:
    section.add "oauth_token", valid_594102
  var valid_594103 = query.getOrDefault("userIp")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "userIp", valid_594103
  var valid_594104 = query.getOrDefault("key")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "key", valid_594104
  var valid_594105 = query.getOrDefault("prettyPrint")
  valid_594105 = validateParameter(valid_594105, JBool, required = false,
                                 default = newJBool(true))
  if valid_594105 != nil:
    section.add "prettyPrint", valid_594105
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

proc call*(call_594107: Call_ContentPosCustombatch_594095; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Batches multiple POS-related calls in a single request.
  ## 
  let valid = call_594107.validator(path, query, header, formData, body)
  let scheme = call_594107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594107.url(scheme.get, call_594107.host, call_594107.base,
                         call_594107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594107, url, valid)

proc call*(call_594108: Call_ContentPosCustombatch_594095; fields: string = "";
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
  var query_594109 = newJObject()
  var body_594110 = newJObject()
  add(query_594109, "fields", newJString(fields))
  add(query_594109, "quotaUser", newJString(quotaUser))
  add(query_594109, "alt", newJString(alt))
  add(query_594109, "dryRun", newJBool(dryRun))
  add(query_594109, "oauth_token", newJString(oauthToken))
  add(query_594109, "userIp", newJString(userIp))
  add(query_594109, "key", newJString(key))
  if body != nil:
    body_594110 = body
  add(query_594109, "prettyPrint", newJBool(prettyPrint))
  result = call_594108.call(nil, query_594109, nil, nil, body_594110)

var contentPosCustombatch* = Call_ContentPosCustombatch_594095(
    name: "contentPosCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/pos/batch",
    validator: validate_ContentPosCustombatch_594096, base: "/content/v2",
    url: url_ContentPosCustombatch_594097, schemes: {Scheme.Https})
type
  Call_ContentProductsCustombatch_594111 = ref object of OpenApiRestCall_593421
proc url_ContentProductsCustombatch_594113(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ContentProductsCustombatch_594112(path: JsonNode; query: JsonNode;
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
  var valid_594114 = query.getOrDefault("fields")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "fields", valid_594114
  var valid_594115 = query.getOrDefault("quotaUser")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "quotaUser", valid_594115
  var valid_594116 = query.getOrDefault("alt")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = newJString("json"))
  if valid_594116 != nil:
    section.add "alt", valid_594116
  var valid_594117 = query.getOrDefault("dryRun")
  valid_594117 = validateParameter(valid_594117, JBool, required = false, default = nil)
  if valid_594117 != nil:
    section.add "dryRun", valid_594117
  var valid_594118 = query.getOrDefault("oauth_token")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = nil)
  if valid_594118 != nil:
    section.add "oauth_token", valid_594118
  var valid_594119 = query.getOrDefault("userIp")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "userIp", valid_594119
  var valid_594120 = query.getOrDefault("key")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = nil)
  if valid_594120 != nil:
    section.add "key", valid_594120
  var valid_594121 = query.getOrDefault("prettyPrint")
  valid_594121 = validateParameter(valid_594121, JBool, required = false,
                                 default = newJBool(true))
  if valid_594121 != nil:
    section.add "prettyPrint", valid_594121
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

proc call*(call_594123: Call_ContentProductsCustombatch_594111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves, inserts, and deletes multiple products in a single request.
  ## 
  let valid = call_594123.validator(path, query, header, formData, body)
  let scheme = call_594123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594123.url(scheme.get, call_594123.host, call_594123.base,
                         call_594123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594123, url, valid)

proc call*(call_594124: Call_ContentProductsCustombatch_594111;
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
  var query_594125 = newJObject()
  var body_594126 = newJObject()
  add(query_594125, "fields", newJString(fields))
  add(query_594125, "quotaUser", newJString(quotaUser))
  add(query_594125, "alt", newJString(alt))
  add(query_594125, "dryRun", newJBool(dryRun))
  add(query_594125, "oauth_token", newJString(oauthToken))
  add(query_594125, "userIp", newJString(userIp))
  add(query_594125, "key", newJString(key))
  if body != nil:
    body_594126 = body
  add(query_594125, "prettyPrint", newJBool(prettyPrint))
  result = call_594124.call(nil, query_594125, nil, nil, body_594126)

var contentProductsCustombatch* = Call_ContentProductsCustombatch_594111(
    name: "contentProductsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/products/batch",
    validator: validate_ContentProductsCustombatch_594112, base: "/content/v2",
    url: url_ContentProductsCustombatch_594113, schemes: {Scheme.Https})
type
  Call_ContentProductstatusesCustombatch_594127 = ref object of OpenApiRestCall_593421
proc url_ContentProductstatusesCustombatch_594129(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ContentProductstatusesCustombatch_594128(path: JsonNode;
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
  var valid_594130 = query.getOrDefault("fields")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = nil)
  if valid_594130 != nil:
    section.add "fields", valid_594130
  var valid_594131 = query.getOrDefault("quotaUser")
  valid_594131 = validateParameter(valid_594131, JString, required = false,
                                 default = nil)
  if valid_594131 != nil:
    section.add "quotaUser", valid_594131
  var valid_594132 = query.getOrDefault("alt")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = newJString("json"))
  if valid_594132 != nil:
    section.add "alt", valid_594132
  var valid_594133 = query.getOrDefault("oauth_token")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = nil)
  if valid_594133 != nil:
    section.add "oauth_token", valid_594133
  var valid_594134 = query.getOrDefault("userIp")
  valid_594134 = validateParameter(valid_594134, JString, required = false,
                                 default = nil)
  if valid_594134 != nil:
    section.add "userIp", valid_594134
  var valid_594135 = query.getOrDefault("includeAttributes")
  valid_594135 = validateParameter(valid_594135, JBool, required = false, default = nil)
  if valid_594135 != nil:
    section.add "includeAttributes", valid_594135
  var valid_594136 = query.getOrDefault("key")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = nil)
  if valid_594136 != nil:
    section.add "key", valid_594136
  var valid_594137 = query.getOrDefault("prettyPrint")
  valid_594137 = validateParameter(valid_594137, JBool, required = false,
                                 default = newJBool(true))
  if valid_594137 != nil:
    section.add "prettyPrint", valid_594137
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

proc call*(call_594139: Call_ContentProductstatusesCustombatch_594127;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the statuses of multiple products in a single request.
  ## 
  let valid = call_594139.validator(path, query, header, formData, body)
  let scheme = call_594139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594139.url(scheme.get, call_594139.host, call_594139.base,
                         call_594139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594139, url, valid)

proc call*(call_594140: Call_ContentProductstatusesCustombatch_594127;
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
  var query_594141 = newJObject()
  var body_594142 = newJObject()
  add(query_594141, "fields", newJString(fields))
  add(query_594141, "quotaUser", newJString(quotaUser))
  add(query_594141, "alt", newJString(alt))
  add(query_594141, "oauth_token", newJString(oauthToken))
  add(query_594141, "userIp", newJString(userIp))
  add(query_594141, "includeAttributes", newJBool(includeAttributes))
  add(query_594141, "key", newJString(key))
  if body != nil:
    body_594142 = body
  add(query_594141, "prettyPrint", newJBool(prettyPrint))
  result = call_594140.call(nil, query_594141, nil, nil, body_594142)

var contentProductstatusesCustombatch* = Call_ContentProductstatusesCustombatch_594127(
    name: "contentProductstatusesCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/productstatuses/batch",
    validator: validate_ContentProductstatusesCustombatch_594128,
    base: "/content/v2", url: url_ContentProductstatusesCustombatch_594129,
    schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsCustombatch_594143 = ref object of OpenApiRestCall_593421
proc url_ContentShippingsettingsCustombatch_594145(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ContentShippingsettingsCustombatch_594144(path: JsonNode;
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
  var valid_594146 = query.getOrDefault("fields")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "fields", valid_594146
  var valid_594147 = query.getOrDefault("quotaUser")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = nil)
  if valid_594147 != nil:
    section.add "quotaUser", valid_594147
  var valid_594148 = query.getOrDefault("alt")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = newJString("json"))
  if valid_594148 != nil:
    section.add "alt", valid_594148
  var valid_594149 = query.getOrDefault("dryRun")
  valid_594149 = validateParameter(valid_594149, JBool, required = false, default = nil)
  if valid_594149 != nil:
    section.add "dryRun", valid_594149
  var valid_594150 = query.getOrDefault("oauth_token")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = nil)
  if valid_594150 != nil:
    section.add "oauth_token", valid_594150
  var valid_594151 = query.getOrDefault("userIp")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = nil)
  if valid_594151 != nil:
    section.add "userIp", valid_594151
  var valid_594152 = query.getOrDefault("key")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = nil)
  if valid_594152 != nil:
    section.add "key", valid_594152
  var valid_594153 = query.getOrDefault("prettyPrint")
  valid_594153 = validateParameter(valid_594153, JBool, required = false,
                                 default = newJBool(true))
  if valid_594153 != nil:
    section.add "prettyPrint", valid_594153
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

proc call*(call_594155: Call_ContentShippingsettingsCustombatch_594143;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves and updates the shipping settings of multiple accounts in a single request.
  ## 
  let valid = call_594155.validator(path, query, header, formData, body)
  let scheme = call_594155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594155.url(scheme.get, call_594155.host, call_594155.base,
                         call_594155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594155, url, valid)

proc call*(call_594156: Call_ContentShippingsettingsCustombatch_594143;
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
  var query_594157 = newJObject()
  var body_594158 = newJObject()
  add(query_594157, "fields", newJString(fields))
  add(query_594157, "quotaUser", newJString(quotaUser))
  add(query_594157, "alt", newJString(alt))
  add(query_594157, "dryRun", newJBool(dryRun))
  add(query_594157, "oauth_token", newJString(oauthToken))
  add(query_594157, "userIp", newJString(userIp))
  add(query_594157, "key", newJString(key))
  if body != nil:
    body_594158 = body
  add(query_594157, "prettyPrint", newJBool(prettyPrint))
  result = call_594156.call(nil, query_594157, nil, nil, body_594158)

var contentShippingsettingsCustombatch* = Call_ContentShippingsettingsCustombatch_594143(
    name: "contentShippingsettingsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/shippingsettings/batch",
    validator: validate_ContentShippingsettingsCustombatch_594144,
    base: "/content/v2", url: url_ContentShippingsettingsCustombatch_594145,
    schemes: {Scheme.Https})
type
  Call_ContentAccountsInsert_594190 = ref object of OpenApiRestCall_593421
proc url_ContentAccountsInsert_594192(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsInsert_594191(path: JsonNode; query: JsonNode;
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
  var valid_594193 = path.getOrDefault("merchantId")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "merchantId", valid_594193
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
  var valid_594194 = query.getOrDefault("fields")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = nil)
  if valid_594194 != nil:
    section.add "fields", valid_594194
  var valid_594195 = query.getOrDefault("quotaUser")
  valid_594195 = validateParameter(valid_594195, JString, required = false,
                                 default = nil)
  if valid_594195 != nil:
    section.add "quotaUser", valid_594195
  var valid_594196 = query.getOrDefault("alt")
  valid_594196 = validateParameter(valid_594196, JString, required = false,
                                 default = newJString("json"))
  if valid_594196 != nil:
    section.add "alt", valid_594196
  var valid_594197 = query.getOrDefault("dryRun")
  valid_594197 = validateParameter(valid_594197, JBool, required = false, default = nil)
  if valid_594197 != nil:
    section.add "dryRun", valid_594197
  var valid_594198 = query.getOrDefault("oauth_token")
  valid_594198 = validateParameter(valid_594198, JString, required = false,
                                 default = nil)
  if valid_594198 != nil:
    section.add "oauth_token", valid_594198
  var valid_594199 = query.getOrDefault("userIp")
  valid_594199 = validateParameter(valid_594199, JString, required = false,
                                 default = nil)
  if valid_594199 != nil:
    section.add "userIp", valid_594199
  var valid_594200 = query.getOrDefault("key")
  valid_594200 = validateParameter(valid_594200, JString, required = false,
                                 default = nil)
  if valid_594200 != nil:
    section.add "key", valid_594200
  var valid_594201 = query.getOrDefault("prettyPrint")
  valid_594201 = validateParameter(valid_594201, JBool, required = false,
                                 default = newJBool(true))
  if valid_594201 != nil:
    section.add "prettyPrint", valid_594201
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

proc call*(call_594203: Call_ContentAccountsInsert_594190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Merchant Center sub-account.
  ## 
  let valid = call_594203.validator(path, query, header, formData, body)
  let scheme = call_594203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594203.url(scheme.get, call_594203.host, call_594203.base,
                         call_594203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594203, url, valid)

proc call*(call_594204: Call_ContentAccountsInsert_594190; merchantId: string;
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
  var path_594205 = newJObject()
  var query_594206 = newJObject()
  var body_594207 = newJObject()
  add(query_594206, "fields", newJString(fields))
  add(query_594206, "quotaUser", newJString(quotaUser))
  add(query_594206, "alt", newJString(alt))
  add(query_594206, "dryRun", newJBool(dryRun))
  add(query_594206, "oauth_token", newJString(oauthToken))
  add(query_594206, "userIp", newJString(userIp))
  add(query_594206, "key", newJString(key))
  add(path_594205, "merchantId", newJString(merchantId))
  if body != nil:
    body_594207 = body
  add(query_594206, "prettyPrint", newJBool(prettyPrint))
  result = call_594204.call(path_594205, query_594206, nil, nil, body_594207)

var contentAccountsInsert* = Call_ContentAccountsInsert_594190(
    name: "contentAccountsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/accounts",
    validator: validate_ContentAccountsInsert_594191, base: "/content/v2",
    url: url_ContentAccountsInsert_594192, schemes: {Scheme.Https})
type
  Call_ContentAccountsList_594159 = ref object of OpenApiRestCall_593421
proc url_ContentAccountsList_594161(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsList_594160(path: JsonNode; query: JsonNode;
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
  var valid_594176 = path.getOrDefault("merchantId")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "merchantId", valid_594176
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
  var valid_594177 = query.getOrDefault("fields")
  valid_594177 = validateParameter(valid_594177, JString, required = false,
                                 default = nil)
  if valid_594177 != nil:
    section.add "fields", valid_594177
  var valid_594178 = query.getOrDefault("pageToken")
  valid_594178 = validateParameter(valid_594178, JString, required = false,
                                 default = nil)
  if valid_594178 != nil:
    section.add "pageToken", valid_594178
  var valid_594179 = query.getOrDefault("quotaUser")
  valid_594179 = validateParameter(valid_594179, JString, required = false,
                                 default = nil)
  if valid_594179 != nil:
    section.add "quotaUser", valid_594179
  var valid_594180 = query.getOrDefault("alt")
  valid_594180 = validateParameter(valid_594180, JString, required = false,
                                 default = newJString("json"))
  if valid_594180 != nil:
    section.add "alt", valid_594180
  var valid_594181 = query.getOrDefault("oauth_token")
  valid_594181 = validateParameter(valid_594181, JString, required = false,
                                 default = nil)
  if valid_594181 != nil:
    section.add "oauth_token", valid_594181
  var valid_594182 = query.getOrDefault("userIp")
  valid_594182 = validateParameter(valid_594182, JString, required = false,
                                 default = nil)
  if valid_594182 != nil:
    section.add "userIp", valid_594182
  var valid_594183 = query.getOrDefault("maxResults")
  valid_594183 = validateParameter(valid_594183, JInt, required = false, default = nil)
  if valid_594183 != nil:
    section.add "maxResults", valid_594183
  var valid_594184 = query.getOrDefault("key")
  valid_594184 = validateParameter(valid_594184, JString, required = false,
                                 default = nil)
  if valid_594184 != nil:
    section.add "key", valid_594184
  var valid_594185 = query.getOrDefault("prettyPrint")
  valid_594185 = validateParameter(valid_594185, JBool, required = false,
                                 default = newJBool(true))
  if valid_594185 != nil:
    section.add "prettyPrint", valid_594185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594186: Call_ContentAccountsList_594159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_594186.validator(path, query, header, formData, body)
  let scheme = call_594186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594186.url(scheme.get, call_594186.host, call_594186.base,
                         call_594186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594186, url, valid)

proc call*(call_594187: Call_ContentAccountsList_594159; merchantId: string;
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
  var path_594188 = newJObject()
  var query_594189 = newJObject()
  add(query_594189, "fields", newJString(fields))
  add(query_594189, "pageToken", newJString(pageToken))
  add(query_594189, "quotaUser", newJString(quotaUser))
  add(query_594189, "alt", newJString(alt))
  add(query_594189, "oauth_token", newJString(oauthToken))
  add(query_594189, "userIp", newJString(userIp))
  add(query_594189, "maxResults", newJInt(maxResults))
  add(query_594189, "key", newJString(key))
  add(path_594188, "merchantId", newJString(merchantId))
  add(query_594189, "prettyPrint", newJBool(prettyPrint))
  result = call_594187.call(path_594188, query_594189, nil, nil, nil)

var contentAccountsList* = Call_ContentAccountsList_594159(
    name: "contentAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounts",
    validator: validate_ContentAccountsList_594160, base: "/content/v2",
    url: url_ContentAccountsList_594161, schemes: {Scheme.Https})
type
  Call_ContentAccountsUpdate_594224 = ref object of OpenApiRestCall_593421
proc url_ContentAccountsUpdate_594226(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsUpdate_594225(path: JsonNode; query: JsonNode;
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
  var valid_594227 = path.getOrDefault("accountId")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "accountId", valid_594227
  var valid_594228 = path.getOrDefault("merchantId")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "merchantId", valid_594228
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
  var valid_594229 = query.getOrDefault("fields")
  valid_594229 = validateParameter(valid_594229, JString, required = false,
                                 default = nil)
  if valid_594229 != nil:
    section.add "fields", valid_594229
  var valid_594230 = query.getOrDefault("quotaUser")
  valid_594230 = validateParameter(valid_594230, JString, required = false,
                                 default = nil)
  if valid_594230 != nil:
    section.add "quotaUser", valid_594230
  var valid_594231 = query.getOrDefault("alt")
  valid_594231 = validateParameter(valid_594231, JString, required = false,
                                 default = newJString("json"))
  if valid_594231 != nil:
    section.add "alt", valid_594231
  var valid_594232 = query.getOrDefault("dryRun")
  valid_594232 = validateParameter(valid_594232, JBool, required = false, default = nil)
  if valid_594232 != nil:
    section.add "dryRun", valid_594232
  var valid_594233 = query.getOrDefault("oauth_token")
  valid_594233 = validateParameter(valid_594233, JString, required = false,
                                 default = nil)
  if valid_594233 != nil:
    section.add "oauth_token", valid_594233
  var valid_594234 = query.getOrDefault("userIp")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = nil)
  if valid_594234 != nil:
    section.add "userIp", valid_594234
  var valid_594235 = query.getOrDefault("key")
  valid_594235 = validateParameter(valid_594235, JString, required = false,
                                 default = nil)
  if valid_594235 != nil:
    section.add "key", valid_594235
  var valid_594236 = query.getOrDefault("prettyPrint")
  valid_594236 = validateParameter(valid_594236, JBool, required = false,
                                 default = newJBool(true))
  if valid_594236 != nil:
    section.add "prettyPrint", valid_594236
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

proc call*(call_594238: Call_ContentAccountsUpdate_594224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Merchant Center account.
  ## 
  let valid = call_594238.validator(path, query, header, formData, body)
  let scheme = call_594238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594238.url(scheme.get, call_594238.host, call_594238.base,
                         call_594238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594238, url, valid)

proc call*(call_594239: Call_ContentAccountsUpdate_594224; accountId: string;
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
  var path_594240 = newJObject()
  var query_594241 = newJObject()
  var body_594242 = newJObject()
  add(query_594241, "fields", newJString(fields))
  add(query_594241, "quotaUser", newJString(quotaUser))
  add(query_594241, "alt", newJString(alt))
  add(query_594241, "dryRun", newJBool(dryRun))
  add(query_594241, "oauth_token", newJString(oauthToken))
  add(path_594240, "accountId", newJString(accountId))
  add(query_594241, "userIp", newJString(userIp))
  add(query_594241, "key", newJString(key))
  add(path_594240, "merchantId", newJString(merchantId))
  if body != nil:
    body_594242 = body
  add(query_594241, "prettyPrint", newJBool(prettyPrint))
  result = call_594239.call(path_594240, query_594241, nil, nil, body_594242)

var contentAccountsUpdate* = Call_ContentAccountsUpdate_594224(
    name: "contentAccountsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsUpdate_594225, base: "/content/v2",
    url: url_ContentAccountsUpdate_594226, schemes: {Scheme.Https})
type
  Call_ContentAccountsGet_594208 = ref object of OpenApiRestCall_593421
proc url_ContentAccountsGet_594210(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsGet_594209(path: JsonNode; query: JsonNode;
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
  var valid_594211 = path.getOrDefault("accountId")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = nil)
  if valid_594211 != nil:
    section.add "accountId", valid_594211
  var valid_594212 = path.getOrDefault("merchantId")
  valid_594212 = validateParameter(valid_594212, JString, required = true,
                                 default = nil)
  if valid_594212 != nil:
    section.add "merchantId", valid_594212
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
  var valid_594213 = query.getOrDefault("fields")
  valid_594213 = validateParameter(valid_594213, JString, required = false,
                                 default = nil)
  if valid_594213 != nil:
    section.add "fields", valid_594213
  var valid_594214 = query.getOrDefault("quotaUser")
  valid_594214 = validateParameter(valid_594214, JString, required = false,
                                 default = nil)
  if valid_594214 != nil:
    section.add "quotaUser", valid_594214
  var valid_594215 = query.getOrDefault("alt")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = newJString("json"))
  if valid_594215 != nil:
    section.add "alt", valid_594215
  var valid_594216 = query.getOrDefault("oauth_token")
  valid_594216 = validateParameter(valid_594216, JString, required = false,
                                 default = nil)
  if valid_594216 != nil:
    section.add "oauth_token", valid_594216
  var valid_594217 = query.getOrDefault("userIp")
  valid_594217 = validateParameter(valid_594217, JString, required = false,
                                 default = nil)
  if valid_594217 != nil:
    section.add "userIp", valid_594217
  var valid_594218 = query.getOrDefault("key")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = nil)
  if valid_594218 != nil:
    section.add "key", valid_594218
  var valid_594219 = query.getOrDefault("prettyPrint")
  valid_594219 = validateParameter(valid_594219, JBool, required = false,
                                 default = newJBool(true))
  if valid_594219 != nil:
    section.add "prettyPrint", valid_594219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594220: Call_ContentAccountsGet_594208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a Merchant Center account.
  ## 
  let valid = call_594220.validator(path, query, header, formData, body)
  let scheme = call_594220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594220.url(scheme.get, call_594220.host, call_594220.base,
                         call_594220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594220, url, valid)

proc call*(call_594221: Call_ContentAccountsGet_594208; accountId: string;
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
  var path_594222 = newJObject()
  var query_594223 = newJObject()
  add(query_594223, "fields", newJString(fields))
  add(query_594223, "quotaUser", newJString(quotaUser))
  add(query_594223, "alt", newJString(alt))
  add(query_594223, "oauth_token", newJString(oauthToken))
  add(path_594222, "accountId", newJString(accountId))
  add(query_594223, "userIp", newJString(userIp))
  add(query_594223, "key", newJString(key))
  add(path_594222, "merchantId", newJString(merchantId))
  add(query_594223, "prettyPrint", newJBool(prettyPrint))
  result = call_594221.call(path_594222, query_594223, nil, nil, nil)

var contentAccountsGet* = Call_ContentAccountsGet_594208(
    name: "contentAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsGet_594209, base: "/content/v2",
    url: url_ContentAccountsGet_594210, schemes: {Scheme.Https})
type
  Call_ContentAccountsPatch_594261 = ref object of OpenApiRestCall_593421
proc url_ContentAccountsPatch_594263(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsPatch_594262(path: JsonNode; query: JsonNode;
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
  var valid_594264 = path.getOrDefault("accountId")
  valid_594264 = validateParameter(valid_594264, JString, required = true,
                                 default = nil)
  if valid_594264 != nil:
    section.add "accountId", valid_594264
  var valid_594265 = path.getOrDefault("merchantId")
  valid_594265 = validateParameter(valid_594265, JString, required = true,
                                 default = nil)
  if valid_594265 != nil:
    section.add "merchantId", valid_594265
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
  var valid_594266 = query.getOrDefault("fields")
  valid_594266 = validateParameter(valid_594266, JString, required = false,
                                 default = nil)
  if valid_594266 != nil:
    section.add "fields", valid_594266
  var valid_594267 = query.getOrDefault("quotaUser")
  valid_594267 = validateParameter(valid_594267, JString, required = false,
                                 default = nil)
  if valid_594267 != nil:
    section.add "quotaUser", valid_594267
  var valid_594268 = query.getOrDefault("alt")
  valid_594268 = validateParameter(valid_594268, JString, required = false,
                                 default = newJString("json"))
  if valid_594268 != nil:
    section.add "alt", valid_594268
  var valid_594269 = query.getOrDefault("dryRun")
  valid_594269 = validateParameter(valid_594269, JBool, required = false, default = nil)
  if valid_594269 != nil:
    section.add "dryRun", valid_594269
  var valid_594270 = query.getOrDefault("oauth_token")
  valid_594270 = validateParameter(valid_594270, JString, required = false,
                                 default = nil)
  if valid_594270 != nil:
    section.add "oauth_token", valid_594270
  var valid_594271 = query.getOrDefault("userIp")
  valid_594271 = validateParameter(valid_594271, JString, required = false,
                                 default = nil)
  if valid_594271 != nil:
    section.add "userIp", valid_594271
  var valid_594272 = query.getOrDefault("key")
  valid_594272 = validateParameter(valid_594272, JString, required = false,
                                 default = nil)
  if valid_594272 != nil:
    section.add "key", valid_594272
  var valid_594273 = query.getOrDefault("prettyPrint")
  valid_594273 = validateParameter(valid_594273, JBool, required = false,
                                 default = newJBool(true))
  if valid_594273 != nil:
    section.add "prettyPrint", valid_594273
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

proc call*(call_594275: Call_ContentAccountsPatch_594261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Merchant Center account. This method supports patch semantics.
  ## 
  let valid = call_594275.validator(path, query, header, formData, body)
  let scheme = call_594275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594275.url(scheme.get, call_594275.host, call_594275.base,
                         call_594275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594275, url, valid)

proc call*(call_594276: Call_ContentAccountsPatch_594261; accountId: string;
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
  var path_594277 = newJObject()
  var query_594278 = newJObject()
  var body_594279 = newJObject()
  add(query_594278, "fields", newJString(fields))
  add(query_594278, "quotaUser", newJString(quotaUser))
  add(query_594278, "alt", newJString(alt))
  add(query_594278, "dryRun", newJBool(dryRun))
  add(query_594278, "oauth_token", newJString(oauthToken))
  add(path_594277, "accountId", newJString(accountId))
  add(query_594278, "userIp", newJString(userIp))
  add(query_594278, "key", newJString(key))
  add(path_594277, "merchantId", newJString(merchantId))
  if body != nil:
    body_594279 = body
  add(query_594278, "prettyPrint", newJBool(prettyPrint))
  result = call_594276.call(path_594277, query_594278, nil, nil, body_594279)

var contentAccountsPatch* = Call_ContentAccountsPatch_594261(
    name: "contentAccountsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsPatch_594262, base: "/content/v2",
    url: url_ContentAccountsPatch_594263, schemes: {Scheme.Https})
type
  Call_ContentAccountsDelete_594243 = ref object of OpenApiRestCall_593421
proc url_ContentAccountsDelete_594245(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsDelete_594244(path: JsonNode; query: JsonNode;
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
  var valid_594246 = path.getOrDefault("accountId")
  valid_594246 = validateParameter(valid_594246, JString, required = true,
                                 default = nil)
  if valid_594246 != nil:
    section.add "accountId", valid_594246
  var valid_594247 = path.getOrDefault("merchantId")
  valid_594247 = validateParameter(valid_594247, JString, required = true,
                                 default = nil)
  if valid_594247 != nil:
    section.add "merchantId", valid_594247
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
  var valid_594248 = query.getOrDefault("fields")
  valid_594248 = validateParameter(valid_594248, JString, required = false,
                                 default = nil)
  if valid_594248 != nil:
    section.add "fields", valid_594248
  var valid_594249 = query.getOrDefault("force")
  valid_594249 = validateParameter(valid_594249, JBool, required = false,
                                 default = newJBool(false))
  if valid_594249 != nil:
    section.add "force", valid_594249
  var valid_594250 = query.getOrDefault("quotaUser")
  valid_594250 = validateParameter(valid_594250, JString, required = false,
                                 default = nil)
  if valid_594250 != nil:
    section.add "quotaUser", valid_594250
  var valid_594251 = query.getOrDefault("alt")
  valid_594251 = validateParameter(valid_594251, JString, required = false,
                                 default = newJString("json"))
  if valid_594251 != nil:
    section.add "alt", valid_594251
  var valid_594252 = query.getOrDefault("dryRun")
  valid_594252 = validateParameter(valid_594252, JBool, required = false, default = nil)
  if valid_594252 != nil:
    section.add "dryRun", valid_594252
  var valid_594253 = query.getOrDefault("oauth_token")
  valid_594253 = validateParameter(valid_594253, JString, required = false,
                                 default = nil)
  if valid_594253 != nil:
    section.add "oauth_token", valid_594253
  var valid_594254 = query.getOrDefault("userIp")
  valid_594254 = validateParameter(valid_594254, JString, required = false,
                                 default = nil)
  if valid_594254 != nil:
    section.add "userIp", valid_594254
  var valid_594255 = query.getOrDefault("key")
  valid_594255 = validateParameter(valid_594255, JString, required = false,
                                 default = nil)
  if valid_594255 != nil:
    section.add "key", valid_594255
  var valid_594256 = query.getOrDefault("prettyPrint")
  valid_594256 = validateParameter(valid_594256, JBool, required = false,
                                 default = newJBool(true))
  if valid_594256 != nil:
    section.add "prettyPrint", valid_594256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594257: Call_ContentAccountsDelete_594243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Merchant Center sub-account.
  ## 
  let valid = call_594257.validator(path, query, header, formData, body)
  let scheme = call_594257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594257.url(scheme.get, call_594257.host, call_594257.base,
                         call_594257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594257, url, valid)

proc call*(call_594258: Call_ContentAccountsDelete_594243; accountId: string;
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
  var path_594259 = newJObject()
  var query_594260 = newJObject()
  add(query_594260, "fields", newJString(fields))
  add(query_594260, "force", newJBool(force))
  add(query_594260, "quotaUser", newJString(quotaUser))
  add(query_594260, "alt", newJString(alt))
  add(query_594260, "dryRun", newJBool(dryRun))
  add(query_594260, "oauth_token", newJString(oauthToken))
  add(path_594259, "accountId", newJString(accountId))
  add(query_594260, "userIp", newJString(userIp))
  add(query_594260, "key", newJString(key))
  add(path_594259, "merchantId", newJString(merchantId))
  add(query_594260, "prettyPrint", newJBool(prettyPrint))
  result = call_594258.call(path_594259, query_594260, nil, nil, nil)

var contentAccountsDelete* = Call_ContentAccountsDelete_594243(
    name: "contentAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsDelete_594244, base: "/content/v2",
    url: url_ContentAccountsDelete_594245, schemes: {Scheme.Https})
type
  Call_ContentAccountsClaimwebsite_594280 = ref object of OpenApiRestCall_593421
proc url_ContentAccountsClaimwebsite_594282(protocol: Scheme; host: string;
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

proc validate_ContentAccountsClaimwebsite_594281(path: JsonNode; query: JsonNode;
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
  var valid_594283 = path.getOrDefault("accountId")
  valid_594283 = validateParameter(valid_594283, JString, required = true,
                                 default = nil)
  if valid_594283 != nil:
    section.add "accountId", valid_594283
  var valid_594284 = path.getOrDefault("merchantId")
  valid_594284 = validateParameter(valid_594284, JString, required = true,
                                 default = nil)
  if valid_594284 != nil:
    section.add "merchantId", valid_594284
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
  var valid_594285 = query.getOrDefault("fields")
  valid_594285 = validateParameter(valid_594285, JString, required = false,
                                 default = nil)
  if valid_594285 != nil:
    section.add "fields", valid_594285
  var valid_594286 = query.getOrDefault("quotaUser")
  valid_594286 = validateParameter(valid_594286, JString, required = false,
                                 default = nil)
  if valid_594286 != nil:
    section.add "quotaUser", valid_594286
  var valid_594287 = query.getOrDefault("alt")
  valid_594287 = validateParameter(valid_594287, JString, required = false,
                                 default = newJString("json"))
  if valid_594287 != nil:
    section.add "alt", valid_594287
  var valid_594288 = query.getOrDefault("oauth_token")
  valid_594288 = validateParameter(valid_594288, JString, required = false,
                                 default = nil)
  if valid_594288 != nil:
    section.add "oauth_token", valid_594288
  var valid_594289 = query.getOrDefault("userIp")
  valid_594289 = validateParameter(valid_594289, JString, required = false,
                                 default = nil)
  if valid_594289 != nil:
    section.add "userIp", valid_594289
  var valid_594290 = query.getOrDefault("overwrite")
  valid_594290 = validateParameter(valid_594290, JBool, required = false, default = nil)
  if valid_594290 != nil:
    section.add "overwrite", valid_594290
  var valid_594291 = query.getOrDefault("key")
  valid_594291 = validateParameter(valid_594291, JString, required = false,
                                 default = nil)
  if valid_594291 != nil:
    section.add "key", valid_594291
  var valid_594292 = query.getOrDefault("prettyPrint")
  valid_594292 = validateParameter(valid_594292, JBool, required = false,
                                 default = newJBool(true))
  if valid_594292 != nil:
    section.add "prettyPrint", valid_594292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594293: Call_ContentAccountsClaimwebsite_594280; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Claims the website of a Merchant Center sub-account.
  ## 
  let valid = call_594293.validator(path, query, header, formData, body)
  let scheme = call_594293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594293.url(scheme.get, call_594293.host, call_594293.base,
                         call_594293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594293, url, valid)

proc call*(call_594294: Call_ContentAccountsClaimwebsite_594280; accountId: string;
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
  var path_594295 = newJObject()
  var query_594296 = newJObject()
  add(query_594296, "fields", newJString(fields))
  add(query_594296, "quotaUser", newJString(quotaUser))
  add(query_594296, "alt", newJString(alt))
  add(query_594296, "oauth_token", newJString(oauthToken))
  add(path_594295, "accountId", newJString(accountId))
  add(query_594296, "userIp", newJString(userIp))
  add(query_594296, "overwrite", newJBool(overwrite))
  add(query_594296, "key", newJString(key))
  add(path_594295, "merchantId", newJString(merchantId))
  add(query_594296, "prettyPrint", newJBool(prettyPrint))
  result = call_594294.call(path_594295, query_594296, nil, nil, nil)

var contentAccountsClaimwebsite* = Call_ContentAccountsClaimwebsite_594280(
    name: "contentAccountsClaimwebsite", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/accounts/{accountId}/claimwebsite",
    validator: validate_ContentAccountsClaimwebsite_594281, base: "/content/v2",
    url: url_ContentAccountsClaimwebsite_594282, schemes: {Scheme.Https})
type
  Call_ContentAccountsLink_594297 = ref object of OpenApiRestCall_593421
proc url_ContentAccountsLink_594299(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsLink_594298(path: JsonNode; query: JsonNode;
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
  var valid_594300 = path.getOrDefault("accountId")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "accountId", valid_594300
  var valid_594301 = path.getOrDefault("merchantId")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "merchantId", valid_594301
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
  var valid_594302 = query.getOrDefault("fields")
  valid_594302 = validateParameter(valid_594302, JString, required = false,
                                 default = nil)
  if valid_594302 != nil:
    section.add "fields", valid_594302
  var valid_594303 = query.getOrDefault("quotaUser")
  valid_594303 = validateParameter(valid_594303, JString, required = false,
                                 default = nil)
  if valid_594303 != nil:
    section.add "quotaUser", valid_594303
  var valid_594304 = query.getOrDefault("alt")
  valid_594304 = validateParameter(valid_594304, JString, required = false,
                                 default = newJString("json"))
  if valid_594304 != nil:
    section.add "alt", valid_594304
  var valid_594305 = query.getOrDefault("oauth_token")
  valid_594305 = validateParameter(valid_594305, JString, required = false,
                                 default = nil)
  if valid_594305 != nil:
    section.add "oauth_token", valid_594305
  var valid_594306 = query.getOrDefault("userIp")
  valid_594306 = validateParameter(valid_594306, JString, required = false,
                                 default = nil)
  if valid_594306 != nil:
    section.add "userIp", valid_594306
  var valid_594307 = query.getOrDefault("key")
  valid_594307 = validateParameter(valid_594307, JString, required = false,
                                 default = nil)
  if valid_594307 != nil:
    section.add "key", valid_594307
  var valid_594308 = query.getOrDefault("prettyPrint")
  valid_594308 = validateParameter(valid_594308, JBool, required = false,
                                 default = newJBool(true))
  if valid_594308 != nil:
    section.add "prettyPrint", valid_594308
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

proc call*(call_594310: Call_ContentAccountsLink_594297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs an action on a link between two Merchant Center accounts, namely accountId and linkedAccountId.
  ## 
  let valid = call_594310.validator(path, query, header, formData, body)
  let scheme = call_594310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594310.url(scheme.get, call_594310.host, call_594310.base,
                         call_594310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594310, url, valid)

proc call*(call_594311: Call_ContentAccountsLink_594297; accountId: string;
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
  var path_594312 = newJObject()
  var query_594313 = newJObject()
  var body_594314 = newJObject()
  add(query_594313, "fields", newJString(fields))
  add(query_594313, "quotaUser", newJString(quotaUser))
  add(query_594313, "alt", newJString(alt))
  add(query_594313, "oauth_token", newJString(oauthToken))
  add(path_594312, "accountId", newJString(accountId))
  add(query_594313, "userIp", newJString(userIp))
  add(query_594313, "key", newJString(key))
  add(path_594312, "merchantId", newJString(merchantId))
  if body != nil:
    body_594314 = body
  add(query_594313, "prettyPrint", newJBool(prettyPrint))
  result = call_594311.call(path_594312, query_594313, nil, nil, body_594314)

var contentAccountsLink* = Call_ContentAccountsLink_594297(
    name: "contentAccountsLink", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}/link",
    validator: validate_ContentAccountsLink_594298, base: "/content/v2",
    url: url_ContentAccountsLink_594299, schemes: {Scheme.Https})
type
  Call_ContentAccountstatusesList_594315 = ref object of OpenApiRestCall_593421
proc url_ContentAccountstatusesList_594317(protocol: Scheme; host: string;
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

proc validate_ContentAccountstatusesList_594316(path: JsonNode; query: JsonNode;
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
  var valid_594318 = path.getOrDefault("merchantId")
  valid_594318 = validateParameter(valid_594318, JString, required = true,
                                 default = nil)
  if valid_594318 != nil:
    section.add "merchantId", valid_594318
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
  var valid_594319 = query.getOrDefault("fields")
  valid_594319 = validateParameter(valid_594319, JString, required = false,
                                 default = nil)
  if valid_594319 != nil:
    section.add "fields", valid_594319
  var valid_594320 = query.getOrDefault("pageToken")
  valid_594320 = validateParameter(valid_594320, JString, required = false,
                                 default = nil)
  if valid_594320 != nil:
    section.add "pageToken", valid_594320
  var valid_594321 = query.getOrDefault("quotaUser")
  valid_594321 = validateParameter(valid_594321, JString, required = false,
                                 default = nil)
  if valid_594321 != nil:
    section.add "quotaUser", valid_594321
  var valid_594322 = query.getOrDefault("alt")
  valid_594322 = validateParameter(valid_594322, JString, required = false,
                                 default = newJString("json"))
  if valid_594322 != nil:
    section.add "alt", valid_594322
  var valid_594323 = query.getOrDefault("oauth_token")
  valid_594323 = validateParameter(valid_594323, JString, required = false,
                                 default = nil)
  if valid_594323 != nil:
    section.add "oauth_token", valid_594323
  var valid_594324 = query.getOrDefault("userIp")
  valid_594324 = validateParameter(valid_594324, JString, required = false,
                                 default = nil)
  if valid_594324 != nil:
    section.add "userIp", valid_594324
  var valid_594325 = query.getOrDefault("maxResults")
  valid_594325 = validateParameter(valid_594325, JInt, required = false, default = nil)
  if valid_594325 != nil:
    section.add "maxResults", valid_594325
  var valid_594326 = query.getOrDefault("key")
  valid_594326 = validateParameter(valid_594326, JString, required = false,
                                 default = nil)
  if valid_594326 != nil:
    section.add "key", valid_594326
  var valid_594327 = query.getOrDefault("prettyPrint")
  valid_594327 = validateParameter(valid_594327, JBool, required = false,
                                 default = newJBool(true))
  if valid_594327 != nil:
    section.add "prettyPrint", valid_594327
  var valid_594328 = query.getOrDefault("destinations")
  valid_594328 = validateParameter(valid_594328, JArray, required = false,
                                 default = nil)
  if valid_594328 != nil:
    section.add "destinations", valid_594328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594329: Call_ContentAccountstatusesList_594315; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_594329.validator(path, query, header, formData, body)
  let scheme = call_594329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594329.url(scheme.get, call_594329.host, call_594329.base,
                         call_594329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594329, url, valid)

proc call*(call_594330: Call_ContentAccountstatusesList_594315; merchantId: string;
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
  var path_594331 = newJObject()
  var query_594332 = newJObject()
  add(query_594332, "fields", newJString(fields))
  add(query_594332, "pageToken", newJString(pageToken))
  add(query_594332, "quotaUser", newJString(quotaUser))
  add(query_594332, "alt", newJString(alt))
  add(query_594332, "oauth_token", newJString(oauthToken))
  add(query_594332, "userIp", newJString(userIp))
  add(query_594332, "maxResults", newJInt(maxResults))
  add(query_594332, "key", newJString(key))
  add(path_594331, "merchantId", newJString(merchantId))
  add(query_594332, "prettyPrint", newJBool(prettyPrint))
  if destinations != nil:
    query_594332.add "destinations", destinations
  result = call_594330.call(path_594331, query_594332, nil, nil, nil)

var contentAccountstatusesList* = Call_ContentAccountstatusesList_594315(
    name: "contentAccountstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accountstatuses",
    validator: validate_ContentAccountstatusesList_594316, base: "/content/v2",
    url: url_ContentAccountstatusesList_594317, schemes: {Scheme.Https})
type
  Call_ContentAccountstatusesGet_594333 = ref object of OpenApiRestCall_593421
proc url_ContentAccountstatusesGet_594335(protocol: Scheme; host: string;
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

proc validate_ContentAccountstatusesGet_594334(path: JsonNode; query: JsonNode;
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
  var valid_594336 = path.getOrDefault("accountId")
  valid_594336 = validateParameter(valid_594336, JString, required = true,
                                 default = nil)
  if valid_594336 != nil:
    section.add "accountId", valid_594336
  var valid_594337 = path.getOrDefault("merchantId")
  valid_594337 = validateParameter(valid_594337, JString, required = true,
                                 default = nil)
  if valid_594337 != nil:
    section.add "merchantId", valid_594337
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
  var valid_594338 = query.getOrDefault("fields")
  valid_594338 = validateParameter(valid_594338, JString, required = false,
                                 default = nil)
  if valid_594338 != nil:
    section.add "fields", valid_594338
  var valid_594339 = query.getOrDefault("quotaUser")
  valid_594339 = validateParameter(valid_594339, JString, required = false,
                                 default = nil)
  if valid_594339 != nil:
    section.add "quotaUser", valid_594339
  var valid_594340 = query.getOrDefault("alt")
  valid_594340 = validateParameter(valid_594340, JString, required = false,
                                 default = newJString("json"))
  if valid_594340 != nil:
    section.add "alt", valid_594340
  var valid_594341 = query.getOrDefault("oauth_token")
  valid_594341 = validateParameter(valid_594341, JString, required = false,
                                 default = nil)
  if valid_594341 != nil:
    section.add "oauth_token", valid_594341
  var valid_594342 = query.getOrDefault("userIp")
  valid_594342 = validateParameter(valid_594342, JString, required = false,
                                 default = nil)
  if valid_594342 != nil:
    section.add "userIp", valid_594342
  var valid_594343 = query.getOrDefault("key")
  valid_594343 = validateParameter(valid_594343, JString, required = false,
                                 default = nil)
  if valid_594343 != nil:
    section.add "key", valid_594343
  var valid_594344 = query.getOrDefault("prettyPrint")
  valid_594344 = validateParameter(valid_594344, JBool, required = false,
                                 default = newJBool(true))
  if valid_594344 != nil:
    section.add "prettyPrint", valid_594344
  var valid_594345 = query.getOrDefault("destinations")
  valid_594345 = validateParameter(valid_594345, JArray, required = false,
                                 default = nil)
  if valid_594345 != nil:
    section.add "destinations", valid_594345
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594346: Call_ContentAccountstatusesGet_594333; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the status of a Merchant Center account. No itemLevelIssues are returned for multi-client accounts.
  ## 
  let valid = call_594346.validator(path, query, header, formData, body)
  let scheme = call_594346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594346.url(scheme.get, call_594346.host, call_594346.base,
                         call_594346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594346, url, valid)

proc call*(call_594347: Call_ContentAccountstatusesGet_594333; accountId: string;
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
  var path_594348 = newJObject()
  var query_594349 = newJObject()
  add(query_594349, "fields", newJString(fields))
  add(query_594349, "quotaUser", newJString(quotaUser))
  add(query_594349, "alt", newJString(alt))
  add(query_594349, "oauth_token", newJString(oauthToken))
  add(path_594348, "accountId", newJString(accountId))
  add(query_594349, "userIp", newJString(userIp))
  add(query_594349, "key", newJString(key))
  add(path_594348, "merchantId", newJString(merchantId))
  add(query_594349, "prettyPrint", newJBool(prettyPrint))
  if destinations != nil:
    query_594349.add "destinations", destinations
  result = call_594347.call(path_594348, query_594349, nil, nil, nil)

var contentAccountstatusesGet* = Call_ContentAccountstatusesGet_594333(
    name: "contentAccountstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/accountstatuses/{accountId}",
    validator: validate_ContentAccountstatusesGet_594334, base: "/content/v2",
    url: url_ContentAccountstatusesGet_594335, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxList_594350 = ref object of OpenApiRestCall_593421
proc url_ContentAccounttaxList_594352(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccounttaxList_594351(path: JsonNode; query: JsonNode;
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
  var valid_594353 = path.getOrDefault("merchantId")
  valid_594353 = validateParameter(valid_594353, JString, required = true,
                                 default = nil)
  if valid_594353 != nil:
    section.add "merchantId", valid_594353
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
  var valid_594354 = query.getOrDefault("fields")
  valid_594354 = validateParameter(valid_594354, JString, required = false,
                                 default = nil)
  if valid_594354 != nil:
    section.add "fields", valid_594354
  var valid_594355 = query.getOrDefault("pageToken")
  valid_594355 = validateParameter(valid_594355, JString, required = false,
                                 default = nil)
  if valid_594355 != nil:
    section.add "pageToken", valid_594355
  var valid_594356 = query.getOrDefault("quotaUser")
  valid_594356 = validateParameter(valid_594356, JString, required = false,
                                 default = nil)
  if valid_594356 != nil:
    section.add "quotaUser", valid_594356
  var valid_594357 = query.getOrDefault("alt")
  valid_594357 = validateParameter(valid_594357, JString, required = false,
                                 default = newJString("json"))
  if valid_594357 != nil:
    section.add "alt", valid_594357
  var valid_594358 = query.getOrDefault("oauth_token")
  valid_594358 = validateParameter(valid_594358, JString, required = false,
                                 default = nil)
  if valid_594358 != nil:
    section.add "oauth_token", valid_594358
  var valid_594359 = query.getOrDefault("userIp")
  valid_594359 = validateParameter(valid_594359, JString, required = false,
                                 default = nil)
  if valid_594359 != nil:
    section.add "userIp", valid_594359
  var valid_594360 = query.getOrDefault("maxResults")
  valid_594360 = validateParameter(valid_594360, JInt, required = false, default = nil)
  if valid_594360 != nil:
    section.add "maxResults", valid_594360
  var valid_594361 = query.getOrDefault("key")
  valid_594361 = validateParameter(valid_594361, JString, required = false,
                                 default = nil)
  if valid_594361 != nil:
    section.add "key", valid_594361
  var valid_594362 = query.getOrDefault("prettyPrint")
  valid_594362 = validateParameter(valid_594362, JBool, required = false,
                                 default = newJBool(true))
  if valid_594362 != nil:
    section.add "prettyPrint", valid_594362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594363: Call_ContentAccounttaxList_594350; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the tax settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_594363.validator(path, query, header, formData, body)
  let scheme = call_594363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594363.url(scheme.get, call_594363.host, call_594363.base,
                         call_594363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594363, url, valid)

proc call*(call_594364: Call_ContentAccounttaxList_594350; merchantId: string;
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
  var path_594365 = newJObject()
  var query_594366 = newJObject()
  add(query_594366, "fields", newJString(fields))
  add(query_594366, "pageToken", newJString(pageToken))
  add(query_594366, "quotaUser", newJString(quotaUser))
  add(query_594366, "alt", newJString(alt))
  add(query_594366, "oauth_token", newJString(oauthToken))
  add(query_594366, "userIp", newJString(userIp))
  add(query_594366, "maxResults", newJInt(maxResults))
  add(query_594366, "key", newJString(key))
  add(path_594365, "merchantId", newJString(merchantId))
  add(query_594366, "prettyPrint", newJBool(prettyPrint))
  result = call_594364.call(path_594365, query_594366, nil, nil, nil)

var contentAccounttaxList* = Call_ContentAccounttaxList_594350(
    name: "contentAccounttaxList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax",
    validator: validate_ContentAccounttaxList_594351, base: "/content/v2",
    url: url_ContentAccounttaxList_594352, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxUpdate_594383 = ref object of OpenApiRestCall_593421
proc url_ContentAccounttaxUpdate_594385(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccounttaxUpdate_594384(path: JsonNode; query: JsonNode;
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
  var valid_594386 = path.getOrDefault("accountId")
  valid_594386 = validateParameter(valid_594386, JString, required = true,
                                 default = nil)
  if valid_594386 != nil:
    section.add "accountId", valid_594386
  var valid_594387 = path.getOrDefault("merchantId")
  valid_594387 = validateParameter(valid_594387, JString, required = true,
                                 default = nil)
  if valid_594387 != nil:
    section.add "merchantId", valid_594387
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
  var valid_594388 = query.getOrDefault("fields")
  valid_594388 = validateParameter(valid_594388, JString, required = false,
                                 default = nil)
  if valid_594388 != nil:
    section.add "fields", valid_594388
  var valid_594389 = query.getOrDefault("quotaUser")
  valid_594389 = validateParameter(valid_594389, JString, required = false,
                                 default = nil)
  if valid_594389 != nil:
    section.add "quotaUser", valid_594389
  var valid_594390 = query.getOrDefault("alt")
  valid_594390 = validateParameter(valid_594390, JString, required = false,
                                 default = newJString("json"))
  if valid_594390 != nil:
    section.add "alt", valid_594390
  var valid_594391 = query.getOrDefault("dryRun")
  valid_594391 = validateParameter(valid_594391, JBool, required = false, default = nil)
  if valid_594391 != nil:
    section.add "dryRun", valid_594391
  var valid_594392 = query.getOrDefault("oauth_token")
  valid_594392 = validateParameter(valid_594392, JString, required = false,
                                 default = nil)
  if valid_594392 != nil:
    section.add "oauth_token", valid_594392
  var valid_594393 = query.getOrDefault("userIp")
  valid_594393 = validateParameter(valid_594393, JString, required = false,
                                 default = nil)
  if valid_594393 != nil:
    section.add "userIp", valid_594393
  var valid_594394 = query.getOrDefault("key")
  valid_594394 = validateParameter(valid_594394, JString, required = false,
                                 default = nil)
  if valid_594394 != nil:
    section.add "key", valid_594394
  var valid_594395 = query.getOrDefault("prettyPrint")
  valid_594395 = validateParameter(valid_594395, JBool, required = false,
                                 default = newJBool(true))
  if valid_594395 != nil:
    section.add "prettyPrint", valid_594395
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

proc call*(call_594397: Call_ContentAccounttaxUpdate_594383; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the tax settings of the account.
  ## 
  let valid = call_594397.validator(path, query, header, formData, body)
  let scheme = call_594397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594397.url(scheme.get, call_594397.host, call_594397.base,
                         call_594397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594397, url, valid)

proc call*(call_594398: Call_ContentAccounttaxUpdate_594383; accountId: string;
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
  var path_594399 = newJObject()
  var query_594400 = newJObject()
  var body_594401 = newJObject()
  add(query_594400, "fields", newJString(fields))
  add(query_594400, "quotaUser", newJString(quotaUser))
  add(query_594400, "alt", newJString(alt))
  add(query_594400, "dryRun", newJBool(dryRun))
  add(query_594400, "oauth_token", newJString(oauthToken))
  add(path_594399, "accountId", newJString(accountId))
  add(query_594400, "userIp", newJString(userIp))
  add(query_594400, "key", newJString(key))
  add(path_594399, "merchantId", newJString(merchantId))
  if body != nil:
    body_594401 = body
  add(query_594400, "prettyPrint", newJBool(prettyPrint))
  result = call_594398.call(path_594399, query_594400, nil, nil, body_594401)

var contentAccounttaxUpdate* = Call_ContentAccounttaxUpdate_594383(
    name: "contentAccounttaxUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax/{accountId}",
    validator: validate_ContentAccounttaxUpdate_594384, base: "/content/v2",
    url: url_ContentAccounttaxUpdate_594385, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxGet_594367 = ref object of OpenApiRestCall_593421
proc url_ContentAccounttaxGet_594369(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccounttaxGet_594368(path: JsonNode; query: JsonNode;
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
  var valid_594370 = path.getOrDefault("accountId")
  valid_594370 = validateParameter(valid_594370, JString, required = true,
                                 default = nil)
  if valid_594370 != nil:
    section.add "accountId", valid_594370
  var valid_594371 = path.getOrDefault("merchantId")
  valid_594371 = validateParameter(valid_594371, JString, required = true,
                                 default = nil)
  if valid_594371 != nil:
    section.add "merchantId", valid_594371
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
  var valid_594372 = query.getOrDefault("fields")
  valid_594372 = validateParameter(valid_594372, JString, required = false,
                                 default = nil)
  if valid_594372 != nil:
    section.add "fields", valid_594372
  var valid_594373 = query.getOrDefault("quotaUser")
  valid_594373 = validateParameter(valid_594373, JString, required = false,
                                 default = nil)
  if valid_594373 != nil:
    section.add "quotaUser", valid_594373
  var valid_594374 = query.getOrDefault("alt")
  valid_594374 = validateParameter(valid_594374, JString, required = false,
                                 default = newJString("json"))
  if valid_594374 != nil:
    section.add "alt", valid_594374
  var valid_594375 = query.getOrDefault("oauth_token")
  valid_594375 = validateParameter(valid_594375, JString, required = false,
                                 default = nil)
  if valid_594375 != nil:
    section.add "oauth_token", valid_594375
  var valid_594376 = query.getOrDefault("userIp")
  valid_594376 = validateParameter(valid_594376, JString, required = false,
                                 default = nil)
  if valid_594376 != nil:
    section.add "userIp", valid_594376
  var valid_594377 = query.getOrDefault("key")
  valid_594377 = validateParameter(valid_594377, JString, required = false,
                                 default = nil)
  if valid_594377 != nil:
    section.add "key", valid_594377
  var valid_594378 = query.getOrDefault("prettyPrint")
  valid_594378 = validateParameter(valid_594378, JBool, required = false,
                                 default = newJBool(true))
  if valid_594378 != nil:
    section.add "prettyPrint", valid_594378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594379: Call_ContentAccounttaxGet_594367; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the tax settings of the account.
  ## 
  let valid = call_594379.validator(path, query, header, formData, body)
  let scheme = call_594379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594379.url(scheme.get, call_594379.host, call_594379.base,
                         call_594379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594379, url, valid)

proc call*(call_594380: Call_ContentAccounttaxGet_594367; accountId: string;
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
  var path_594381 = newJObject()
  var query_594382 = newJObject()
  add(query_594382, "fields", newJString(fields))
  add(query_594382, "quotaUser", newJString(quotaUser))
  add(query_594382, "alt", newJString(alt))
  add(query_594382, "oauth_token", newJString(oauthToken))
  add(path_594381, "accountId", newJString(accountId))
  add(query_594382, "userIp", newJString(userIp))
  add(query_594382, "key", newJString(key))
  add(path_594381, "merchantId", newJString(merchantId))
  add(query_594382, "prettyPrint", newJBool(prettyPrint))
  result = call_594380.call(path_594381, query_594382, nil, nil, nil)

var contentAccounttaxGet* = Call_ContentAccounttaxGet_594367(
    name: "contentAccounttaxGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax/{accountId}",
    validator: validate_ContentAccounttaxGet_594368, base: "/content/v2",
    url: url_ContentAccounttaxGet_594369, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxPatch_594402 = ref object of OpenApiRestCall_593421
proc url_ContentAccounttaxPatch_594404(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccounttaxPatch_594403(path: JsonNode; query: JsonNode;
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
  var valid_594405 = path.getOrDefault("accountId")
  valid_594405 = validateParameter(valid_594405, JString, required = true,
                                 default = nil)
  if valid_594405 != nil:
    section.add "accountId", valid_594405
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
  var valid_594410 = query.getOrDefault("dryRun")
  valid_594410 = validateParameter(valid_594410, JBool, required = false, default = nil)
  if valid_594410 != nil:
    section.add "dryRun", valid_594410
  var valid_594411 = query.getOrDefault("oauth_token")
  valid_594411 = validateParameter(valid_594411, JString, required = false,
                                 default = nil)
  if valid_594411 != nil:
    section.add "oauth_token", valid_594411
  var valid_594412 = query.getOrDefault("userIp")
  valid_594412 = validateParameter(valid_594412, JString, required = false,
                                 default = nil)
  if valid_594412 != nil:
    section.add "userIp", valid_594412
  var valid_594413 = query.getOrDefault("key")
  valid_594413 = validateParameter(valid_594413, JString, required = false,
                                 default = nil)
  if valid_594413 != nil:
    section.add "key", valid_594413
  var valid_594414 = query.getOrDefault("prettyPrint")
  valid_594414 = validateParameter(valid_594414, JBool, required = false,
                                 default = newJBool(true))
  if valid_594414 != nil:
    section.add "prettyPrint", valid_594414
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

proc call*(call_594416: Call_ContentAccounttaxPatch_594402; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the tax settings of the account. This method supports patch semantics.
  ## 
  let valid = call_594416.validator(path, query, header, formData, body)
  let scheme = call_594416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594416.url(scheme.get, call_594416.host, call_594416.base,
                         call_594416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594416, url, valid)

proc call*(call_594417: Call_ContentAccounttaxPatch_594402; accountId: string;
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
  var path_594418 = newJObject()
  var query_594419 = newJObject()
  var body_594420 = newJObject()
  add(query_594419, "fields", newJString(fields))
  add(query_594419, "quotaUser", newJString(quotaUser))
  add(query_594419, "alt", newJString(alt))
  add(query_594419, "dryRun", newJBool(dryRun))
  add(query_594419, "oauth_token", newJString(oauthToken))
  add(path_594418, "accountId", newJString(accountId))
  add(query_594419, "userIp", newJString(userIp))
  add(query_594419, "key", newJString(key))
  add(path_594418, "merchantId", newJString(merchantId))
  if body != nil:
    body_594420 = body
  add(query_594419, "prettyPrint", newJBool(prettyPrint))
  result = call_594417.call(path_594418, query_594419, nil, nil, body_594420)

var contentAccounttaxPatch* = Call_ContentAccounttaxPatch_594402(
    name: "contentAccounttaxPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax/{accountId}",
    validator: validate_ContentAccounttaxPatch_594403, base: "/content/v2",
    url: url_ContentAccounttaxPatch_594404, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsInsert_594438 = ref object of OpenApiRestCall_593421
proc url_ContentDatafeedsInsert_594440(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsInsert_594439(path: JsonNode; query: JsonNode;
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
  var valid_594441 = path.getOrDefault("merchantId")
  valid_594441 = validateParameter(valid_594441, JString, required = true,
                                 default = nil)
  if valid_594441 != nil:
    section.add "merchantId", valid_594441
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
  var valid_594442 = query.getOrDefault("fields")
  valid_594442 = validateParameter(valid_594442, JString, required = false,
                                 default = nil)
  if valid_594442 != nil:
    section.add "fields", valid_594442
  var valid_594443 = query.getOrDefault("quotaUser")
  valid_594443 = validateParameter(valid_594443, JString, required = false,
                                 default = nil)
  if valid_594443 != nil:
    section.add "quotaUser", valid_594443
  var valid_594444 = query.getOrDefault("alt")
  valid_594444 = validateParameter(valid_594444, JString, required = false,
                                 default = newJString("json"))
  if valid_594444 != nil:
    section.add "alt", valid_594444
  var valid_594445 = query.getOrDefault("dryRun")
  valid_594445 = validateParameter(valid_594445, JBool, required = false, default = nil)
  if valid_594445 != nil:
    section.add "dryRun", valid_594445
  var valid_594446 = query.getOrDefault("oauth_token")
  valid_594446 = validateParameter(valid_594446, JString, required = false,
                                 default = nil)
  if valid_594446 != nil:
    section.add "oauth_token", valid_594446
  var valid_594447 = query.getOrDefault("userIp")
  valid_594447 = validateParameter(valid_594447, JString, required = false,
                                 default = nil)
  if valid_594447 != nil:
    section.add "userIp", valid_594447
  var valid_594448 = query.getOrDefault("key")
  valid_594448 = validateParameter(valid_594448, JString, required = false,
                                 default = nil)
  if valid_594448 != nil:
    section.add "key", valid_594448
  var valid_594449 = query.getOrDefault("prettyPrint")
  valid_594449 = validateParameter(valid_594449, JBool, required = false,
                                 default = newJBool(true))
  if valid_594449 != nil:
    section.add "prettyPrint", valid_594449
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

proc call*(call_594451: Call_ContentDatafeedsInsert_594438; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers a datafeed configuration with your Merchant Center account.
  ## 
  let valid = call_594451.validator(path, query, header, formData, body)
  let scheme = call_594451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594451.url(scheme.get, call_594451.host, call_594451.base,
                         call_594451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594451, url, valid)

proc call*(call_594452: Call_ContentDatafeedsInsert_594438; merchantId: string;
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
  var path_594453 = newJObject()
  var query_594454 = newJObject()
  var body_594455 = newJObject()
  add(query_594454, "fields", newJString(fields))
  add(query_594454, "quotaUser", newJString(quotaUser))
  add(query_594454, "alt", newJString(alt))
  add(query_594454, "dryRun", newJBool(dryRun))
  add(query_594454, "oauth_token", newJString(oauthToken))
  add(query_594454, "userIp", newJString(userIp))
  add(query_594454, "key", newJString(key))
  add(path_594453, "merchantId", newJString(merchantId))
  if body != nil:
    body_594455 = body
  add(query_594454, "prettyPrint", newJBool(prettyPrint))
  result = call_594452.call(path_594453, query_594454, nil, nil, body_594455)

var contentDatafeedsInsert* = Call_ContentDatafeedsInsert_594438(
    name: "contentDatafeedsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds",
    validator: validate_ContentDatafeedsInsert_594439, base: "/content/v2",
    url: url_ContentDatafeedsInsert_594440, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsList_594421 = ref object of OpenApiRestCall_593421
proc url_ContentDatafeedsList_594423(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsList_594422(path: JsonNode; query: JsonNode;
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
  var valid_594424 = path.getOrDefault("merchantId")
  valid_594424 = validateParameter(valid_594424, JString, required = true,
                                 default = nil)
  if valid_594424 != nil:
    section.add "merchantId", valid_594424
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
  var valid_594425 = query.getOrDefault("fields")
  valid_594425 = validateParameter(valid_594425, JString, required = false,
                                 default = nil)
  if valid_594425 != nil:
    section.add "fields", valid_594425
  var valid_594426 = query.getOrDefault("pageToken")
  valid_594426 = validateParameter(valid_594426, JString, required = false,
                                 default = nil)
  if valid_594426 != nil:
    section.add "pageToken", valid_594426
  var valid_594427 = query.getOrDefault("quotaUser")
  valid_594427 = validateParameter(valid_594427, JString, required = false,
                                 default = nil)
  if valid_594427 != nil:
    section.add "quotaUser", valid_594427
  var valid_594428 = query.getOrDefault("alt")
  valid_594428 = validateParameter(valid_594428, JString, required = false,
                                 default = newJString("json"))
  if valid_594428 != nil:
    section.add "alt", valid_594428
  var valid_594429 = query.getOrDefault("oauth_token")
  valid_594429 = validateParameter(valid_594429, JString, required = false,
                                 default = nil)
  if valid_594429 != nil:
    section.add "oauth_token", valid_594429
  var valid_594430 = query.getOrDefault("userIp")
  valid_594430 = validateParameter(valid_594430, JString, required = false,
                                 default = nil)
  if valid_594430 != nil:
    section.add "userIp", valid_594430
  var valid_594431 = query.getOrDefault("maxResults")
  valid_594431 = validateParameter(valid_594431, JInt, required = false, default = nil)
  if valid_594431 != nil:
    section.add "maxResults", valid_594431
  var valid_594432 = query.getOrDefault("key")
  valid_594432 = validateParameter(valid_594432, JString, required = false,
                                 default = nil)
  if valid_594432 != nil:
    section.add "key", valid_594432
  var valid_594433 = query.getOrDefault("prettyPrint")
  valid_594433 = validateParameter(valid_594433, JBool, required = false,
                                 default = newJBool(true))
  if valid_594433 != nil:
    section.add "prettyPrint", valid_594433
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594434: Call_ContentDatafeedsList_594421; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the configurations for datafeeds in your Merchant Center account.
  ## 
  let valid = call_594434.validator(path, query, header, formData, body)
  let scheme = call_594434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594434.url(scheme.get, call_594434.host, call_594434.base,
                         call_594434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594434, url, valid)

proc call*(call_594435: Call_ContentDatafeedsList_594421; merchantId: string;
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
  var path_594436 = newJObject()
  var query_594437 = newJObject()
  add(query_594437, "fields", newJString(fields))
  add(query_594437, "pageToken", newJString(pageToken))
  add(query_594437, "quotaUser", newJString(quotaUser))
  add(query_594437, "alt", newJString(alt))
  add(query_594437, "oauth_token", newJString(oauthToken))
  add(query_594437, "userIp", newJString(userIp))
  add(query_594437, "maxResults", newJInt(maxResults))
  add(query_594437, "key", newJString(key))
  add(path_594436, "merchantId", newJString(merchantId))
  add(query_594437, "prettyPrint", newJBool(prettyPrint))
  result = call_594435.call(path_594436, query_594437, nil, nil, nil)

var contentDatafeedsList* = Call_ContentDatafeedsList_594421(
    name: "contentDatafeedsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds",
    validator: validate_ContentDatafeedsList_594422, base: "/content/v2",
    url: url_ContentDatafeedsList_594423, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsUpdate_594472 = ref object of OpenApiRestCall_593421
proc url_ContentDatafeedsUpdate_594474(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsUpdate_594473(path: JsonNode; query: JsonNode;
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
  var valid_594475 = path.getOrDefault("merchantId")
  valid_594475 = validateParameter(valid_594475, JString, required = true,
                                 default = nil)
  if valid_594475 != nil:
    section.add "merchantId", valid_594475
  var valid_594476 = path.getOrDefault("datafeedId")
  valid_594476 = validateParameter(valid_594476, JString, required = true,
                                 default = nil)
  if valid_594476 != nil:
    section.add "datafeedId", valid_594476
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
  var valid_594477 = query.getOrDefault("fields")
  valid_594477 = validateParameter(valid_594477, JString, required = false,
                                 default = nil)
  if valid_594477 != nil:
    section.add "fields", valid_594477
  var valid_594478 = query.getOrDefault("quotaUser")
  valid_594478 = validateParameter(valid_594478, JString, required = false,
                                 default = nil)
  if valid_594478 != nil:
    section.add "quotaUser", valid_594478
  var valid_594479 = query.getOrDefault("alt")
  valid_594479 = validateParameter(valid_594479, JString, required = false,
                                 default = newJString("json"))
  if valid_594479 != nil:
    section.add "alt", valid_594479
  var valid_594480 = query.getOrDefault("dryRun")
  valid_594480 = validateParameter(valid_594480, JBool, required = false, default = nil)
  if valid_594480 != nil:
    section.add "dryRun", valid_594480
  var valid_594481 = query.getOrDefault("oauth_token")
  valid_594481 = validateParameter(valid_594481, JString, required = false,
                                 default = nil)
  if valid_594481 != nil:
    section.add "oauth_token", valid_594481
  var valid_594482 = query.getOrDefault("userIp")
  valid_594482 = validateParameter(valid_594482, JString, required = false,
                                 default = nil)
  if valid_594482 != nil:
    section.add "userIp", valid_594482
  var valid_594483 = query.getOrDefault("key")
  valid_594483 = validateParameter(valid_594483, JString, required = false,
                                 default = nil)
  if valid_594483 != nil:
    section.add "key", valid_594483
  var valid_594484 = query.getOrDefault("prettyPrint")
  valid_594484 = validateParameter(valid_594484, JBool, required = false,
                                 default = newJBool(true))
  if valid_594484 != nil:
    section.add "prettyPrint", valid_594484
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

proc call*(call_594486: Call_ContentDatafeedsUpdate_594472; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a datafeed configuration of your Merchant Center account.
  ## 
  let valid = call_594486.validator(path, query, header, formData, body)
  let scheme = call_594486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594486.url(scheme.get, call_594486.host, call_594486.base,
                         call_594486.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594486, url, valid)

proc call*(call_594487: Call_ContentDatafeedsUpdate_594472; merchantId: string;
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
  var path_594488 = newJObject()
  var query_594489 = newJObject()
  var body_594490 = newJObject()
  add(query_594489, "fields", newJString(fields))
  add(query_594489, "quotaUser", newJString(quotaUser))
  add(query_594489, "alt", newJString(alt))
  add(query_594489, "dryRun", newJBool(dryRun))
  add(query_594489, "oauth_token", newJString(oauthToken))
  add(query_594489, "userIp", newJString(userIp))
  add(query_594489, "key", newJString(key))
  add(path_594488, "merchantId", newJString(merchantId))
  if body != nil:
    body_594490 = body
  add(query_594489, "prettyPrint", newJBool(prettyPrint))
  add(path_594488, "datafeedId", newJString(datafeedId))
  result = call_594487.call(path_594488, query_594489, nil, nil, body_594490)

var contentDatafeedsUpdate* = Call_ContentDatafeedsUpdate_594472(
    name: "contentDatafeedsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsUpdate_594473, base: "/content/v2",
    url: url_ContentDatafeedsUpdate_594474, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsGet_594456 = ref object of OpenApiRestCall_593421
proc url_ContentDatafeedsGet_594458(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsGet_594457(path: JsonNode; query: JsonNode;
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
  var valid_594459 = path.getOrDefault("merchantId")
  valid_594459 = validateParameter(valid_594459, JString, required = true,
                                 default = nil)
  if valid_594459 != nil:
    section.add "merchantId", valid_594459
  var valid_594460 = path.getOrDefault("datafeedId")
  valid_594460 = validateParameter(valid_594460, JString, required = true,
                                 default = nil)
  if valid_594460 != nil:
    section.add "datafeedId", valid_594460
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
  var valid_594461 = query.getOrDefault("fields")
  valid_594461 = validateParameter(valid_594461, JString, required = false,
                                 default = nil)
  if valid_594461 != nil:
    section.add "fields", valid_594461
  var valid_594462 = query.getOrDefault("quotaUser")
  valid_594462 = validateParameter(valid_594462, JString, required = false,
                                 default = nil)
  if valid_594462 != nil:
    section.add "quotaUser", valid_594462
  var valid_594463 = query.getOrDefault("alt")
  valid_594463 = validateParameter(valid_594463, JString, required = false,
                                 default = newJString("json"))
  if valid_594463 != nil:
    section.add "alt", valid_594463
  var valid_594464 = query.getOrDefault("oauth_token")
  valid_594464 = validateParameter(valid_594464, JString, required = false,
                                 default = nil)
  if valid_594464 != nil:
    section.add "oauth_token", valid_594464
  var valid_594465 = query.getOrDefault("userIp")
  valid_594465 = validateParameter(valid_594465, JString, required = false,
                                 default = nil)
  if valid_594465 != nil:
    section.add "userIp", valid_594465
  var valid_594466 = query.getOrDefault("key")
  valid_594466 = validateParameter(valid_594466, JString, required = false,
                                 default = nil)
  if valid_594466 != nil:
    section.add "key", valid_594466
  var valid_594467 = query.getOrDefault("prettyPrint")
  valid_594467 = validateParameter(valid_594467, JBool, required = false,
                                 default = newJBool(true))
  if valid_594467 != nil:
    section.add "prettyPrint", valid_594467
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594468: Call_ContentDatafeedsGet_594456; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a datafeed configuration from your Merchant Center account.
  ## 
  let valid = call_594468.validator(path, query, header, formData, body)
  let scheme = call_594468.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594468.url(scheme.get, call_594468.host, call_594468.base,
                         call_594468.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594468, url, valid)

proc call*(call_594469: Call_ContentDatafeedsGet_594456; merchantId: string;
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
  var path_594470 = newJObject()
  var query_594471 = newJObject()
  add(query_594471, "fields", newJString(fields))
  add(query_594471, "quotaUser", newJString(quotaUser))
  add(query_594471, "alt", newJString(alt))
  add(query_594471, "oauth_token", newJString(oauthToken))
  add(query_594471, "userIp", newJString(userIp))
  add(query_594471, "key", newJString(key))
  add(path_594470, "merchantId", newJString(merchantId))
  add(query_594471, "prettyPrint", newJBool(prettyPrint))
  add(path_594470, "datafeedId", newJString(datafeedId))
  result = call_594469.call(path_594470, query_594471, nil, nil, nil)

var contentDatafeedsGet* = Call_ContentDatafeedsGet_594456(
    name: "contentDatafeedsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsGet_594457, base: "/content/v2",
    url: url_ContentDatafeedsGet_594458, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsPatch_594508 = ref object of OpenApiRestCall_593421
proc url_ContentDatafeedsPatch_594510(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsPatch_594509(path: JsonNode; query: JsonNode;
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
  var valid_594511 = path.getOrDefault("merchantId")
  valid_594511 = validateParameter(valid_594511, JString, required = true,
                                 default = nil)
  if valid_594511 != nil:
    section.add "merchantId", valid_594511
  var valid_594512 = path.getOrDefault("datafeedId")
  valid_594512 = validateParameter(valid_594512, JString, required = true,
                                 default = nil)
  if valid_594512 != nil:
    section.add "datafeedId", valid_594512
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
  var valid_594513 = query.getOrDefault("fields")
  valid_594513 = validateParameter(valid_594513, JString, required = false,
                                 default = nil)
  if valid_594513 != nil:
    section.add "fields", valid_594513
  var valid_594514 = query.getOrDefault("quotaUser")
  valid_594514 = validateParameter(valid_594514, JString, required = false,
                                 default = nil)
  if valid_594514 != nil:
    section.add "quotaUser", valid_594514
  var valid_594515 = query.getOrDefault("alt")
  valid_594515 = validateParameter(valid_594515, JString, required = false,
                                 default = newJString("json"))
  if valid_594515 != nil:
    section.add "alt", valid_594515
  var valid_594516 = query.getOrDefault("dryRun")
  valid_594516 = validateParameter(valid_594516, JBool, required = false, default = nil)
  if valid_594516 != nil:
    section.add "dryRun", valid_594516
  var valid_594517 = query.getOrDefault("oauth_token")
  valid_594517 = validateParameter(valid_594517, JString, required = false,
                                 default = nil)
  if valid_594517 != nil:
    section.add "oauth_token", valid_594517
  var valid_594518 = query.getOrDefault("userIp")
  valid_594518 = validateParameter(valid_594518, JString, required = false,
                                 default = nil)
  if valid_594518 != nil:
    section.add "userIp", valid_594518
  var valid_594519 = query.getOrDefault("key")
  valid_594519 = validateParameter(valid_594519, JString, required = false,
                                 default = nil)
  if valid_594519 != nil:
    section.add "key", valid_594519
  var valid_594520 = query.getOrDefault("prettyPrint")
  valid_594520 = validateParameter(valid_594520, JBool, required = false,
                                 default = newJBool(true))
  if valid_594520 != nil:
    section.add "prettyPrint", valid_594520
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

proc call*(call_594522: Call_ContentDatafeedsPatch_594508; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a datafeed configuration of your Merchant Center account. This method supports patch semantics.
  ## 
  let valid = call_594522.validator(path, query, header, formData, body)
  let scheme = call_594522.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594522.url(scheme.get, call_594522.host, call_594522.base,
                         call_594522.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594522, url, valid)

proc call*(call_594523: Call_ContentDatafeedsPatch_594508; merchantId: string;
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
  var path_594524 = newJObject()
  var query_594525 = newJObject()
  var body_594526 = newJObject()
  add(query_594525, "fields", newJString(fields))
  add(query_594525, "quotaUser", newJString(quotaUser))
  add(query_594525, "alt", newJString(alt))
  add(query_594525, "dryRun", newJBool(dryRun))
  add(query_594525, "oauth_token", newJString(oauthToken))
  add(query_594525, "userIp", newJString(userIp))
  add(query_594525, "key", newJString(key))
  add(path_594524, "merchantId", newJString(merchantId))
  if body != nil:
    body_594526 = body
  add(query_594525, "prettyPrint", newJBool(prettyPrint))
  add(path_594524, "datafeedId", newJString(datafeedId))
  result = call_594523.call(path_594524, query_594525, nil, nil, body_594526)

var contentDatafeedsPatch* = Call_ContentDatafeedsPatch_594508(
    name: "contentDatafeedsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsPatch_594509, base: "/content/v2",
    url: url_ContentDatafeedsPatch_594510, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsDelete_594491 = ref object of OpenApiRestCall_593421
proc url_ContentDatafeedsDelete_594493(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsDelete_594492(path: JsonNode; query: JsonNode;
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
  var valid_594494 = path.getOrDefault("merchantId")
  valid_594494 = validateParameter(valid_594494, JString, required = true,
                                 default = nil)
  if valid_594494 != nil:
    section.add "merchantId", valid_594494
  var valid_594495 = path.getOrDefault("datafeedId")
  valid_594495 = validateParameter(valid_594495, JString, required = true,
                                 default = nil)
  if valid_594495 != nil:
    section.add "datafeedId", valid_594495
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
  var valid_594496 = query.getOrDefault("fields")
  valid_594496 = validateParameter(valid_594496, JString, required = false,
                                 default = nil)
  if valid_594496 != nil:
    section.add "fields", valid_594496
  var valid_594497 = query.getOrDefault("quotaUser")
  valid_594497 = validateParameter(valid_594497, JString, required = false,
                                 default = nil)
  if valid_594497 != nil:
    section.add "quotaUser", valid_594497
  var valid_594498 = query.getOrDefault("alt")
  valid_594498 = validateParameter(valid_594498, JString, required = false,
                                 default = newJString("json"))
  if valid_594498 != nil:
    section.add "alt", valid_594498
  var valid_594499 = query.getOrDefault("dryRun")
  valid_594499 = validateParameter(valid_594499, JBool, required = false, default = nil)
  if valid_594499 != nil:
    section.add "dryRun", valid_594499
  var valid_594500 = query.getOrDefault("oauth_token")
  valid_594500 = validateParameter(valid_594500, JString, required = false,
                                 default = nil)
  if valid_594500 != nil:
    section.add "oauth_token", valid_594500
  var valid_594501 = query.getOrDefault("userIp")
  valid_594501 = validateParameter(valid_594501, JString, required = false,
                                 default = nil)
  if valid_594501 != nil:
    section.add "userIp", valid_594501
  var valid_594502 = query.getOrDefault("key")
  valid_594502 = validateParameter(valid_594502, JString, required = false,
                                 default = nil)
  if valid_594502 != nil:
    section.add "key", valid_594502
  var valid_594503 = query.getOrDefault("prettyPrint")
  valid_594503 = validateParameter(valid_594503, JBool, required = false,
                                 default = newJBool(true))
  if valid_594503 != nil:
    section.add "prettyPrint", valid_594503
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594504: Call_ContentDatafeedsDelete_594491; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a datafeed configuration from your Merchant Center account.
  ## 
  let valid = call_594504.validator(path, query, header, formData, body)
  let scheme = call_594504.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594504.url(scheme.get, call_594504.host, call_594504.base,
                         call_594504.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594504, url, valid)

proc call*(call_594505: Call_ContentDatafeedsDelete_594491; merchantId: string;
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
  var path_594506 = newJObject()
  var query_594507 = newJObject()
  add(query_594507, "fields", newJString(fields))
  add(query_594507, "quotaUser", newJString(quotaUser))
  add(query_594507, "alt", newJString(alt))
  add(query_594507, "dryRun", newJBool(dryRun))
  add(query_594507, "oauth_token", newJString(oauthToken))
  add(query_594507, "userIp", newJString(userIp))
  add(query_594507, "key", newJString(key))
  add(path_594506, "merchantId", newJString(merchantId))
  add(query_594507, "prettyPrint", newJBool(prettyPrint))
  add(path_594506, "datafeedId", newJString(datafeedId))
  result = call_594505.call(path_594506, query_594507, nil, nil, nil)

var contentDatafeedsDelete* = Call_ContentDatafeedsDelete_594491(
    name: "contentDatafeedsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsDelete_594492, base: "/content/v2",
    url: url_ContentDatafeedsDelete_594493, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsFetchnow_594527 = ref object of OpenApiRestCall_593421
proc url_ContentDatafeedsFetchnow_594529(protocol: Scheme; host: string;
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

proc validate_ContentDatafeedsFetchnow_594528(path: JsonNode; query: JsonNode;
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
  var valid_594530 = path.getOrDefault("merchantId")
  valid_594530 = validateParameter(valid_594530, JString, required = true,
                                 default = nil)
  if valid_594530 != nil:
    section.add "merchantId", valid_594530
  var valid_594531 = path.getOrDefault("datafeedId")
  valid_594531 = validateParameter(valid_594531, JString, required = true,
                                 default = nil)
  if valid_594531 != nil:
    section.add "datafeedId", valid_594531
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
  var valid_594532 = query.getOrDefault("fields")
  valid_594532 = validateParameter(valid_594532, JString, required = false,
                                 default = nil)
  if valid_594532 != nil:
    section.add "fields", valid_594532
  var valid_594533 = query.getOrDefault("quotaUser")
  valid_594533 = validateParameter(valid_594533, JString, required = false,
                                 default = nil)
  if valid_594533 != nil:
    section.add "quotaUser", valid_594533
  var valid_594534 = query.getOrDefault("alt")
  valid_594534 = validateParameter(valid_594534, JString, required = false,
                                 default = newJString("json"))
  if valid_594534 != nil:
    section.add "alt", valid_594534
  var valid_594535 = query.getOrDefault("dryRun")
  valid_594535 = validateParameter(valid_594535, JBool, required = false, default = nil)
  if valid_594535 != nil:
    section.add "dryRun", valid_594535
  var valid_594536 = query.getOrDefault("oauth_token")
  valid_594536 = validateParameter(valid_594536, JString, required = false,
                                 default = nil)
  if valid_594536 != nil:
    section.add "oauth_token", valid_594536
  var valid_594537 = query.getOrDefault("userIp")
  valid_594537 = validateParameter(valid_594537, JString, required = false,
                                 default = nil)
  if valid_594537 != nil:
    section.add "userIp", valid_594537
  var valid_594538 = query.getOrDefault("key")
  valid_594538 = validateParameter(valid_594538, JString, required = false,
                                 default = nil)
  if valid_594538 != nil:
    section.add "key", valid_594538
  var valid_594539 = query.getOrDefault("prettyPrint")
  valid_594539 = validateParameter(valid_594539, JBool, required = false,
                                 default = newJBool(true))
  if valid_594539 != nil:
    section.add "prettyPrint", valid_594539
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594540: Call_ContentDatafeedsFetchnow_594527; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Invokes a fetch for the datafeed in your Merchant Center account.
  ## 
  let valid = call_594540.validator(path, query, header, formData, body)
  let scheme = call_594540.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594540.url(scheme.get, call_594540.host, call_594540.base,
                         call_594540.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594540, url, valid)

proc call*(call_594541: Call_ContentDatafeedsFetchnow_594527; merchantId: string;
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
  var path_594542 = newJObject()
  var query_594543 = newJObject()
  add(query_594543, "fields", newJString(fields))
  add(query_594543, "quotaUser", newJString(quotaUser))
  add(query_594543, "alt", newJString(alt))
  add(query_594543, "dryRun", newJBool(dryRun))
  add(query_594543, "oauth_token", newJString(oauthToken))
  add(query_594543, "userIp", newJString(userIp))
  add(query_594543, "key", newJString(key))
  add(path_594542, "merchantId", newJString(merchantId))
  add(query_594543, "prettyPrint", newJBool(prettyPrint))
  add(path_594542, "datafeedId", newJString(datafeedId))
  result = call_594541.call(path_594542, query_594543, nil, nil, nil)

var contentDatafeedsFetchnow* = Call_ContentDatafeedsFetchnow_594527(
    name: "contentDatafeedsFetchnow", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/datafeeds/{datafeedId}/fetchNow",
    validator: validate_ContentDatafeedsFetchnow_594528, base: "/content/v2",
    url: url_ContentDatafeedsFetchnow_594529, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesList_594544 = ref object of OpenApiRestCall_593421
proc url_ContentDatafeedstatusesList_594546(protocol: Scheme; host: string;
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

proc validate_ContentDatafeedstatusesList_594545(path: JsonNode; query: JsonNode;
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
  var valid_594547 = path.getOrDefault("merchantId")
  valid_594547 = validateParameter(valid_594547, JString, required = true,
                                 default = nil)
  if valid_594547 != nil:
    section.add "merchantId", valid_594547
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
  var valid_594548 = query.getOrDefault("fields")
  valid_594548 = validateParameter(valid_594548, JString, required = false,
                                 default = nil)
  if valid_594548 != nil:
    section.add "fields", valid_594548
  var valid_594549 = query.getOrDefault("pageToken")
  valid_594549 = validateParameter(valid_594549, JString, required = false,
                                 default = nil)
  if valid_594549 != nil:
    section.add "pageToken", valid_594549
  var valid_594550 = query.getOrDefault("quotaUser")
  valid_594550 = validateParameter(valid_594550, JString, required = false,
                                 default = nil)
  if valid_594550 != nil:
    section.add "quotaUser", valid_594550
  var valid_594551 = query.getOrDefault("alt")
  valid_594551 = validateParameter(valid_594551, JString, required = false,
                                 default = newJString("json"))
  if valid_594551 != nil:
    section.add "alt", valid_594551
  var valid_594552 = query.getOrDefault("oauth_token")
  valid_594552 = validateParameter(valid_594552, JString, required = false,
                                 default = nil)
  if valid_594552 != nil:
    section.add "oauth_token", valid_594552
  var valid_594553 = query.getOrDefault("userIp")
  valid_594553 = validateParameter(valid_594553, JString, required = false,
                                 default = nil)
  if valid_594553 != nil:
    section.add "userIp", valid_594553
  var valid_594554 = query.getOrDefault("maxResults")
  valid_594554 = validateParameter(valid_594554, JInt, required = false, default = nil)
  if valid_594554 != nil:
    section.add "maxResults", valid_594554
  var valid_594555 = query.getOrDefault("key")
  valid_594555 = validateParameter(valid_594555, JString, required = false,
                                 default = nil)
  if valid_594555 != nil:
    section.add "key", valid_594555
  var valid_594556 = query.getOrDefault("prettyPrint")
  valid_594556 = validateParameter(valid_594556, JBool, required = false,
                                 default = newJBool(true))
  if valid_594556 != nil:
    section.add "prettyPrint", valid_594556
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594557: Call_ContentDatafeedstatusesList_594544; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the datafeeds in your Merchant Center account.
  ## 
  let valid = call_594557.validator(path, query, header, formData, body)
  let scheme = call_594557.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594557.url(scheme.get, call_594557.host, call_594557.base,
                         call_594557.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594557, url, valid)

proc call*(call_594558: Call_ContentDatafeedstatusesList_594544;
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
  var path_594559 = newJObject()
  var query_594560 = newJObject()
  add(query_594560, "fields", newJString(fields))
  add(query_594560, "pageToken", newJString(pageToken))
  add(query_594560, "quotaUser", newJString(quotaUser))
  add(query_594560, "alt", newJString(alt))
  add(query_594560, "oauth_token", newJString(oauthToken))
  add(query_594560, "userIp", newJString(userIp))
  add(query_594560, "maxResults", newJInt(maxResults))
  add(query_594560, "key", newJString(key))
  add(path_594559, "merchantId", newJString(merchantId))
  add(query_594560, "prettyPrint", newJBool(prettyPrint))
  result = call_594558.call(path_594559, query_594560, nil, nil, nil)

var contentDatafeedstatusesList* = Call_ContentDatafeedstatusesList_594544(
    name: "contentDatafeedstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeedstatuses",
    validator: validate_ContentDatafeedstatusesList_594545, base: "/content/v2",
    url: url_ContentDatafeedstatusesList_594546, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesGet_594561 = ref object of OpenApiRestCall_593421
proc url_ContentDatafeedstatusesGet_594563(protocol: Scheme; host: string;
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

proc validate_ContentDatafeedstatusesGet_594562(path: JsonNode; query: JsonNode;
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
  var valid_594564 = path.getOrDefault("merchantId")
  valid_594564 = validateParameter(valid_594564, JString, required = true,
                                 default = nil)
  if valid_594564 != nil:
    section.add "merchantId", valid_594564
  var valid_594565 = path.getOrDefault("datafeedId")
  valid_594565 = validateParameter(valid_594565, JString, required = true,
                                 default = nil)
  if valid_594565 != nil:
    section.add "datafeedId", valid_594565
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
  var valid_594566 = query.getOrDefault("fields")
  valid_594566 = validateParameter(valid_594566, JString, required = false,
                                 default = nil)
  if valid_594566 != nil:
    section.add "fields", valid_594566
  var valid_594567 = query.getOrDefault("country")
  valid_594567 = validateParameter(valid_594567, JString, required = false,
                                 default = nil)
  if valid_594567 != nil:
    section.add "country", valid_594567
  var valid_594568 = query.getOrDefault("quotaUser")
  valid_594568 = validateParameter(valid_594568, JString, required = false,
                                 default = nil)
  if valid_594568 != nil:
    section.add "quotaUser", valid_594568
  var valid_594569 = query.getOrDefault("alt")
  valid_594569 = validateParameter(valid_594569, JString, required = false,
                                 default = newJString("json"))
  if valid_594569 != nil:
    section.add "alt", valid_594569
  var valid_594570 = query.getOrDefault("language")
  valid_594570 = validateParameter(valid_594570, JString, required = false,
                                 default = nil)
  if valid_594570 != nil:
    section.add "language", valid_594570
  var valid_594571 = query.getOrDefault("oauth_token")
  valid_594571 = validateParameter(valid_594571, JString, required = false,
                                 default = nil)
  if valid_594571 != nil:
    section.add "oauth_token", valid_594571
  var valid_594572 = query.getOrDefault("userIp")
  valid_594572 = validateParameter(valid_594572, JString, required = false,
                                 default = nil)
  if valid_594572 != nil:
    section.add "userIp", valid_594572
  var valid_594573 = query.getOrDefault("key")
  valid_594573 = validateParameter(valid_594573, JString, required = false,
                                 default = nil)
  if valid_594573 != nil:
    section.add "key", valid_594573
  var valid_594574 = query.getOrDefault("prettyPrint")
  valid_594574 = validateParameter(valid_594574, JBool, required = false,
                                 default = newJBool(true))
  if valid_594574 != nil:
    section.add "prettyPrint", valid_594574
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594575: Call_ContentDatafeedstatusesGet_594561; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the status of a datafeed from your Merchant Center account.
  ## 
  let valid = call_594575.validator(path, query, header, formData, body)
  let scheme = call_594575.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594575.url(scheme.get, call_594575.host, call_594575.base,
                         call_594575.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594575, url, valid)

proc call*(call_594576: Call_ContentDatafeedstatusesGet_594561; merchantId: string;
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
  var path_594577 = newJObject()
  var query_594578 = newJObject()
  add(query_594578, "fields", newJString(fields))
  add(query_594578, "country", newJString(country))
  add(query_594578, "quotaUser", newJString(quotaUser))
  add(query_594578, "alt", newJString(alt))
  add(query_594578, "language", newJString(language))
  add(query_594578, "oauth_token", newJString(oauthToken))
  add(query_594578, "userIp", newJString(userIp))
  add(query_594578, "key", newJString(key))
  add(path_594577, "merchantId", newJString(merchantId))
  add(query_594578, "prettyPrint", newJBool(prettyPrint))
  add(path_594577, "datafeedId", newJString(datafeedId))
  result = call_594576.call(path_594577, query_594578, nil, nil, nil)

var contentDatafeedstatusesGet* = Call_ContentDatafeedstatusesGet_594561(
    name: "contentDatafeedstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/datafeedstatuses/{datafeedId}",
    validator: validate_ContentDatafeedstatusesGet_594562, base: "/content/v2",
    url: url_ContentDatafeedstatusesGet_594563, schemes: {Scheme.Https})
type
  Call_ContentInventorySet_594579 = ref object of OpenApiRestCall_593421
proc url_ContentInventorySet_594581(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContentInventorySet_594580(path: JsonNode; query: JsonNode;
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
  var valid_594582 = path.getOrDefault("storeCode")
  valid_594582 = validateParameter(valid_594582, JString, required = true,
                                 default = nil)
  if valid_594582 != nil:
    section.add "storeCode", valid_594582
  var valid_594583 = path.getOrDefault("merchantId")
  valid_594583 = validateParameter(valid_594583, JString, required = true,
                                 default = nil)
  if valid_594583 != nil:
    section.add "merchantId", valid_594583
  var valid_594584 = path.getOrDefault("productId")
  valid_594584 = validateParameter(valid_594584, JString, required = true,
                                 default = nil)
  if valid_594584 != nil:
    section.add "productId", valid_594584
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
  var valid_594585 = query.getOrDefault("fields")
  valid_594585 = validateParameter(valid_594585, JString, required = false,
                                 default = nil)
  if valid_594585 != nil:
    section.add "fields", valid_594585
  var valid_594586 = query.getOrDefault("quotaUser")
  valid_594586 = validateParameter(valid_594586, JString, required = false,
                                 default = nil)
  if valid_594586 != nil:
    section.add "quotaUser", valid_594586
  var valid_594587 = query.getOrDefault("alt")
  valid_594587 = validateParameter(valid_594587, JString, required = false,
                                 default = newJString("json"))
  if valid_594587 != nil:
    section.add "alt", valid_594587
  var valid_594588 = query.getOrDefault("dryRun")
  valid_594588 = validateParameter(valid_594588, JBool, required = false, default = nil)
  if valid_594588 != nil:
    section.add "dryRun", valid_594588
  var valid_594589 = query.getOrDefault("oauth_token")
  valid_594589 = validateParameter(valid_594589, JString, required = false,
                                 default = nil)
  if valid_594589 != nil:
    section.add "oauth_token", valid_594589
  var valid_594590 = query.getOrDefault("userIp")
  valid_594590 = validateParameter(valid_594590, JString, required = false,
                                 default = nil)
  if valid_594590 != nil:
    section.add "userIp", valid_594590
  var valid_594591 = query.getOrDefault("key")
  valid_594591 = validateParameter(valid_594591, JString, required = false,
                                 default = nil)
  if valid_594591 != nil:
    section.add "key", valid_594591
  var valid_594592 = query.getOrDefault("prettyPrint")
  valid_594592 = validateParameter(valid_594592, JBool, required = false,
                                 default = newJBool(true))
  if valid_594592 != nil:
    section.add "prettyPrint", valid_594592
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

proc call*(call_594594: Call_ContentInventorySet_594579; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates price and availability of a product in your Merchant Center account.
  ## 
  let valid = call_594594.validator(path, query, header, formData, body)
  let scheme = call_594594.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594594.url(scheme.get, call_594594.host, call_594594.base,
                         call_594594.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594594, url, valid)

proc call*(call_594595: Call_ContentInventorySet_594579; storeCode: string;
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
  var path_594596 = newJObject()
  var query_594597 = newJObject()
  var body_594598 = newJObject()
  add(query_594597, "fields", newJString(fields))
  add(query_594597, "quotaUser", newJString(quotaUser))
  add(query_594597, "alt", newJString(alt))
  add(query_594597, "dryRun", newJBool(dryRun))
  add(query_594597, "oauth_token", newJString(oauthToken))
  add(path_594596, "storeCode", newJString(storeCode))
  add(query_594597, "userIp", newJString(userIp))
  add(query_594597, "key", newJString(key))
  add(path_594596, "merchantId", newJString(merchantId))
  if body != nil:
    body_594598 = body
  add(query_594597, "prettyPrint", newJBool(prettyPrint))
  add(path_594596, "productId", newJString(productId))
  result = call_594595.call(path_594596, query_594597, nil, nil, body_594598)

var contentInventorySet* = Call_ContentInventorySet_594579(
    name: "contentInventorySet", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/inventory/{storeCode}/products/{productId}",
    validator: validate_ContentInventorySet_594580, base: "/content/v2",
    url: url_ContentInventorySet_594581, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsList_594599 = ref object of OpenApiRestCall_593421
proc url_ContentLiasettingsList_594601(protocol: Scheme; host: string; base: string;
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

proc validate_ContentLiasettingsList_594600(path: JsonNode; query: JsonNode;
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
  var valid_594602 = path.getOrDefault("merchantId")
  valid_594602 = validateParameter(valid_594602, JString, required = true,
                                 default = nil)
  if valid_594602 != nil:
    section.add "merchantId", valid_594602
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
  var valid_594603 = query.getOrDefault("fields")
  valid_594603 = validateParameter(valid_594603, JString, required = false,
                                 default = nil)
  if valid_594603 != nil:
    section.add "fields", valid_594603
  var valid_594604 = query.getOrDefault("pageToken")
  valid_594604 = validateParameter(valid_594604, JString, required = false,
                                 default = nil)
  if valid_594604 != nil:
    section.add "pageToken", valid_594604
  var valid_594605 = query.getOrDefault("quotaUser")
  valid_594605 = validateParameter(valid_594605, JString, required = false,
                                 default = nil)
  if valid_594605 != nil:
    section.add "quotaUser", valid_594605
  var valid_594606 = query.getOrDefault("alt")
  valid_594606 = validateParameter(valid_594606, JString, required = false,
                                 default = newJString("json"))
  if valid_594606 != nil:
    section.add "alt", valid_594606
  var valid_594607 = query.getOrDefault("oauth_token")
  valid_594607 = validateParameter(valid_594607, JString, required = false,
                                 default = nil)
  if valid_594607 != nil:
    section.add "oauth_token", valid_594607
  var valid_594608 = query.getOrDefault("userIp")
  valid_594608 = validateParameter(valid_594608, JString, required = false,
                                 default = nil)
  if valid_594608 != nil:
    section.add "userIp", valid_594608
  var valid_594609 = query.getOrDefault("maxResults")
  valid_594609 = validateParameter(valid_594609, JInt, required = false, default = nil)
  if valid_594609 != nil:
    section.add "maxResults", valid_594609
  var valid_594610 = query.getOrDefault("key")
  valid_594610 = validateParameter(valid_594610, JString, required = false,
                                 default = nil)
  if valid_594610 != nil:
    section.add "key", valid_594610
  var valid_594611 = query.getOrDefault("prettyPrint")
  valid_594611 = validateParameter(valid_594611, JBool, required = false,
                                 default = newJBool(true))
  if valid_594611 != nil:
    section.add "prettyPrint", valid_594611
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594612: Call_ContentLiasettingsList_594599; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the LIA settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_594612.validator(path, query, header, formData, body)
  let scheme = call_594612.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594612.url(scheme.get, call_594612.host, call_594612.base,
                         call_594612.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594612, url, valid)

proc call*(call_594613: Call_ContentLiasettingsList_594599; merchantId: string;
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
  var path_594614 = newJObject()
  var query_594615 = newJObject()
  add(query_594615, "fields", newJString(fields))
  add(query_594615, "pageToken", newJString(pageToken))
  add(query_594615, "quotaUser", newJString(quotaUser))
  add(query_594615, "alt", newJString(alt))
  add(query_594615, "oauth_token", newJString(oauthToken))
  add(query_594615, "userIp", newJString(userIp))
  add(query_594615, "maxResults", newJInt(maxResults))
  add(query_594615, "key", newJString(key))
  add(path_594614, "merchantId", newJString(merchantId))
  add(query_594615, "prettyPrint", newJBool(prettyPrint))
  result = call_594613.call(path_594614, query_594615, nil, nil, nil)

var contentLiasettingsList* = Call_ContentLiasettingsList_594599(
    name: "contentLiasettingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings",
    validator: validate_ContentLiasettingsList_594600, base: "/content/v2",
    url: url_ContentLiasettingsList_594601, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsUpdate_594632 = ref object of OpenApiRestCall_593421
proc url_ContentLiasettingsUpdate_594634(protocol: Scheme; host: string;
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

proc validate_ContentLiasettingsUpdate_594633(path: JsonNode; query: JsonNode;
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
  var valid_594635 = path.getOrDefault("accountId")
  valid_594635 = validateParameter(valid_594635, JString, required = true,
                                 default = nil)
  if valid_594635 != nil:
    section.add "accountId", valid_594635
  var valid_594636 = path.getOrDefault("merchantId")
  valid_594636 = validateParameter(valid_594636, JString, required = true,
                                 default = nil)
  if valid_594636 != nil:
    section.add "merchantId", valid_594636
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
  var valid_594637 = query.getOrDefault("fields")
  valid_594637 = validateParameter(valid_594637, JString, required = false,
                                 default = nil)
  if valid_594637 != nil:
    section.add "fields", valid_594637
  var valid_594638 = query.getOrDefault("quotaUser")
  valid_594638 = validateParameter(valid_594638, JString, required = false,
                                 default = nil)
  if valid_594638 != nil:
    section.add "quotaUser", valid_594638
  var valid_594639 = query.getOrDefault("alt")
  valid_594639 = validateParameter(valid_594639, JString, required = false,
                                 default = newJString("json"))
  if valid_594639 != nil:
    section.add "alt", valid_594639
  var valid_594640 = query.getOrDefault("dryRun")
  valid_594640 = validateParameter(valid_594640, JBool, required = false, default = nil)
  if valid_594640 != nil:
    section.add "dryRun", valid_594640
  var valid_594641 = query.getOrDefault("oauth_token")
  valid_594641 = validateParameter(valid_594641, JString, required = false,
                                 default = nil)
  if valid_594641 != nil:
    section.add "oauth_token", valid_594641
  var valid_594642 = query.getOrDefault("userIp")
  valid_594642 = validateParameter(valid_594642, JString, required = false,
                                 default = nil)
  if valid_594642 != nil:
    section.add "userIp", valid_594642
  var valid_594643 = query.getOrDefault("key")
  valid_594643 = validateParameter(valid_594643, JString, required = false,
                                 default = nil)
  if valid_594643 != nil:
    section.add "key", valid_594643
  var valid_594644 = query.getOrDefault("prettyPrint")
  valid_594644 = validateParameter(valid_594644, JBool, required = false,
                                 default = newJBool(true))
  if valid_594644 != nil:
    section.add "prettyPrint", valid_594644
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

proc call*(call_594646: Call_ContentLiasettingsUpdate_594632; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the LIA settings of the account.
  ## 
  let valid = call_594646.validator(path, query, header, formData, body)
  let scheme = call_594646.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594646.url(scheme.get, call_594646.host, call_594646.base,
                         call_594646.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594646, url, valid)

proc call*(call_594647: Call_ContentLiasettingsUpdate_594632; accountId: string;
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
  var path_594648 = newJObject()
  var query_594649 = newJObject()
  var body_594650 = newJObject()
  add(query_594649, "fields", newJString(fields))
  add(query_594649, "quotaUser", newJString(quotaUser))
  add(query_594649, "alt", newJString(alt))
  add(query_594649, "dryRun", newJBool(dryRun))
  add(query_594649, "oauth_token", newJString(oauthToken))
  add(path_594648, "accountId", newJString(accountId))
  add(query_594649, "userIp", newJString(userIp))
  add(query_594649, "key", newJString(key))
  add(path_594648, "merchantId", newJString(merchantId))
  if body != nil:
    body_594650 = body
  add(query_594649, "prettyPrint", newJBool(prettyPrint))
  result = call_594647.call(path_594648, query_594649, nil, nil, body_594650)

var contentLiasettingsUpdate* = Call_ContentLiasettingsUpdate_594632(
    name: "contentLiasettingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}",
    validator: validate_ContentLiasettingsUpdate_594633, base: "/content/v2",
    url: url_ContentLiasettingsUpdate_594634, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsGet_594616 = ref object of OpenApiRestCall_593421
proc url_ContentLiasettingsGet_594618(protocol: Scheme; host: string; base: string;
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

proc validate_ContentLiasettingsGet_594617(path: JsonNode; query: JsonNode;
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
  var valid_594619 = path.getOrDefault("accountId")
  valid_594619 = validateParameter(valid_594619, JString, required = true,
                                 default = nil)
  if valid_594619 != nil:
    section.add "accountId", valid_594619
  var valid_594620 = path.getOrDefault("merchantId")
  valid_594620 = validateParameter(valid_594620, JString, required = true,
                                 default = nil)
  if valid_594620 != nil:
    section.add "merchantId", valid_594620
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
  var valid_594621 = query.getOrDefault("fields")
  valid_594621 = validateParameter(valid_594621, JString, required = false,
                                 default = nil)
  if valid_594621 != nil:
    section.add "fields", valid_594621
  var valid_594622 = query.getOrDefault("quotaUser")
  valid_594622 = validateParameter(valid_594622, JString, required = false,
                                 default = nil)
  if valid_594622 != nil:
    section.add "quotaUser", valid_594622
  var valid_594623 = query.getOrDefault("alt")
  valid_594623 = validateParameter(valid_594623, JString, required = false,
                                 default = newJString("json"))
  if valid_594623 != nil:
    section.add "alt", valid_594623
  var valid_594624 = query.getOrDefault("oauth_token")
  valid_594624 = validateParameter(valid_594624, JString, required = false,
                                 default = nil)
  if valid_594624 != nil:
    section.add "oauth_token", valid_594624
  var valid_594625 = query.getOrDefault("userIp")
  valid_594625 = validateParameter(valid_594625, JString, required = false,
                                 default = nil)
  if valid_594625 != nil:
    section.add "userIp", valid_594625
  var valid_594626 = query.getOrDefault("key")
  valid_594626 = validateParameter(valid_594626, JString, required = false,
                                 default = nil)
  if valid_594626 != nil:
    section.add "key", valid_594626
  var valid_594627 = query.getOrDefault("prettyPrint")
  valid_594627 = validateParameter(valid_594627, JBool, required = false,
                                 default = newJBool(true))
  if valid_594627 != nil:
    section.add "prettyPrint", valid_594627
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594628: Call_ContentLiasettingsGet_594616; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the LIA settings of the account.
  ## 
  let valid = call_594628.validator(path, query, header, formData, body)
  let scheme = call_594628.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594628.url(scheme.get, call_594628.host, call_594628.base,
                         call_594628.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594628, url, valid)

proc call*(call_594629: Call_ContentLiasettingsGet_594616; accountId: string;
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
  var path_594630 = newJObject()
  var query_594631 = newJObject()
  add(query_594631, "fields", newJString(fields))
  add(query_594631, "quotaUser", newJString(quotaUser))
  add(query_594631, "alt", newJString(alt))
  add(query_594631, "oauth_token", newJString(oauthToken))
  add(path_594630, "accountId", newJString(accountId))
  add(query_594631, "userIp", newJString(userIp))
  add(query_594631, "key", newJString(key))
  add(path_594630, "merchantId", newJString(merchantId))
  add(query_594631, "prettyPrint", newJBool(prettyPrint))
  result = call_594629.call(path_594630, query_594631, nil, nil, nil)

var contentLiasettingsGet* = Call_ContentLiasettingsGet_594616(
    name: "contentLiasettingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}",
    validator: validate_ContentLiasettingsGet_594617, base: "/content/v2",
    url: url_ContentLiasettingsGet_594618, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsPatch_594651 = ref object of OpenApiRestCall_593421
proc url_ContentLiasettingsPatch_594653(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/liasettings/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentLiasettingsPatch_594652(path: JsonNode; query: JsonNode;
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
  var valid_594654 = path.getOrDefault("accountId")
  valid_594654 = validateParameter(valid_594654, JString, required = true,
                                 default = nil)
  if valid_594654 != nil:
    section.add "accountId", valid_594654
  var valid_594655 = path.getOrDefault("merchantId")
  valid_594655 = validateParameter(valid_594655, JString, required = true,
                                 default = nil)
  if valid_594655 != nil:
    section.add "merchantId", valid_594655
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
  var valid_594656 = query.getOrDefault("fields")
  valid_594656 = validateParameter(valid_594656, JString, required = false,
                                 default = nil)
  if valid_594656 != nil:
    section.add "fields", valid_594656
  var valid_594657 = query.getOrDefault("quotaUser")
  valid_594657 = validateParameter(valid_594657, JString, required = false,
                                 default = nil)
  if valid_594657 != nil:
    section.add "quotaUser", valid_594657
  var valid_594658 = query.getOrDefault("alt")
  valid_594658 = validateParameter(valid_594658, JString, required = false,
                                 default = newJString("json"))
  if valid_594658 != nil:
    section.add "alt", valid_594658
  var valid_594659 = query.getOrDefault("dryRun")
  valid_594659 = validateParameter(valid_594659, JBool, required = false, default = nil)
  if valid_594659 != nil:
    section.add "dryRun", valid_594659
  var valid_594660 = query.getOrDefault("oauth_token")
  valid_594660 = validateParameter(valid_594660, JString, required = false,
                                 default = nil)
  if valid_594660 != nil:
    section.add "oauth_token", valid_594660
  var valid_594661 = query.getOrDefault("userIp")
  valid_594661 = validateParameter(valid_594661, JString, required = false,
                                 default = nil)
  if valid_594661 != nil:
    section.add "userIp", valid_594661
  var valid_594662 = query.getOrDefault("key")
  valid_594662 = validateParameter(valid_594662, JString, required = false,
                                 default = nil)
  if valid_594662 != nil:
    section.add "key", valid_594662
  var valid_594663 = query.getOrDefault("prettyPrint")
  valid_594663 = validateParameter(valid_594663, JBool, required = false,
                                 default = newJBool(true))
  if valid_594663 != nil:
    section.add "prettyPrint", valid_594663
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

proc call*(call_594665: Call_ContentLiasettingsPatch_594651; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the LIA settings of the account. This method supports patch semantics.
  ## 
  let valid = call_594665.validator(path, query, header, formData, body)
  let scheme = call_594665.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594665.url(scheme.get, call_594665.host, call_594665.base,
                         call_594665.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594665, url, valid)

proc call*(call_594666: Call_ContentLiasettingsPatch_594651; accountId: string;
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
  var path_594667 = newJObject()
  var query_594668 = newJObject()
  var body_594669 = newJObject()
  add(query_594668, "fields", newJString(fields))
  add(query_594668, "quotaUser", newJString(quotaUser))
  add(query_594668, "alt", newJString(alt))
  add(query_594668, "dryRun", newJBool(dryRun))
  add(query_594668, "oauth_token", newJString(oauthToken))
  add(path_594667, "accountId", newJString(accountId))
  add(query_594668, "userIp", newJString(userIp))
  add(query_594668, "key", newJString(key))
  add(path_594667, "merchantId", newJString(merchantId))
  if body != nil:
    body_594669 = body
  add(query_594668, "prettyPrint", newJBool(prettyPrint))
  result = call_594666.call(path_594667, query_594668, nil, nil, body_594669)

var contentLiasettingsPatch* = Call_ContentLiasettingsPatch_594651(
    name: "contentLiasettingsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}",
    validator: validate_ContentLiasettingsPatch_594652, base: "/content/v2",
    url: url_ContentLiasettingsPatch_594653, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsGetaccessiblegmbaccounts_594670 = ref object of OpenApiRestCall_593421
proc url_ContentLiasettingsGetaccessiblegmbaccounts_594672(protocol: Scheme;
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

proc validate_ContentLiasettingsGetaccessiblegmbaccounts_594671(path: JsonNode;
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
  var valid_594673 = path.getOrDefault("accountId")
  valid_594673 = validateParameter(valid_594673, JString, required = true,
                                 default = nil)
  if valid_594673 != nil:
    section.add "accountId", valid_594673
  var valid_594674 = path.getOrDefault("merchantId")
  valid_594674 = validateParameter(valid_594674, JString, required = true,
                                 default = nil)
  if valid_594674 != nil:
    section.add "merchantId", valid_594674
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
  var valid_594675 = query.getOrDefault("fields")
  valid_594675 = validateParameter(valid_594675, JString, required = false,
                                 default = nil)
  if valid_594675 != nil:
    section.add "fields", valid_594675
  var valid_594676 = query.getOrDefault("quotaUser")
  valid_594676 = validateParameter(valid_594676, JString, required = false,
                                 default = nil)
  if valid_594676 != nil:
    section.add "quotaUser", valid_594676
  var valid_594677 = query.getOrDefault("alt")
  valid_594677 = validateParameter(valid_594677, JString, required = false,
                                 default = newJString("json"))
  if valid_594677 != nil:
    section.add "alt", valid_594677
  var valid_594678 = query.getOrDefault("oauth_token")
  valid_594678 = validateParameter(valid_594678, JString, required = false,
                                 default = nil)
  if valid_594678 != nil:
    section.add "oauth_token", valid_594678
  var valid_594679 = query.getOrDefault("userIp")
  valid_594679 = validateParameter(valid_594679, JString, required = false,
                                 default = nil)
  if valid_594679 != nil:
    section.add "userIp", valid_594679
  var valid_594680 = query.getOrDefault("key")
  valid_594680 = validateParameter(valid_594680, JString, required = false,
                                 default = nil)
  if valid_594680 != nil:
    section.add "key", valid_594680
  var valid_594681 = query.getOrDefault("prettyPrint")
  valid_594681 = validateParameter(valid_594681, JBool, required = false,
                                 default = newJBool(true))
  if valid_594681 != nil:
    section.add "prettyPrint", valid_594681
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594682: Call_ContentLiasettingsGetaccessiblegmbaccounts_594670;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of accessible Google My Business accounts.
  ## 
  let valid = call_594682.validator(path, query, header, formData, body)
  let scheme = call_594682.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594682.url(scheme.get, call_594682.host, call_594682.base,
                         call_594682.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594682, url, valid)

proc call*(call_594683: Call_ContentLiasettingsGetaccessiblegmbaccounts_594670;
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
  var path_594684 = newJObject()
  var query_594685 = newJObject()
  add(query_594685, "fields", newJString(fields))
  add(query_594685, "quotaUser", newJString(quotaUser))
  add(query_594685, "alt", newJString(alt))
  add(query_594685, "oauth_token", newJString(oauthToken))
  add(path_594684, "accountId", newJString(accountId))
  add(query_594685, "userIp", newJString(userIp))
  add(query_594685, "key", newJString(key))
  add(path_594684, "merchantId", newJString(merchantId))
  add(query_594685, "prettyPrint", newJBool(prettyPrint))
  result = call_594683.call(path_594684, query_594685, nil, nil, nil)

var contentLiasettingsGetaccessiblegmbaccounts* = Call_ContentLiasettingsGetaccessiblegmbaccounts_594670(
    name: "contentLiasettingsGetaccessiblegmbaccounts", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/accessiblegmbaccounts",
    validator: validate_ContentLiasettingsGetaccessiblegmbaccounts_594671,
    base: "/content/v2", url: url_ContentLiasettingsGetaccessiblegmbaccounts_594672,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsRequestgmbaccess_594686 = ref object of OpenApiRestCall_593421
proc url_ContentLiasettingsRequestgmbaccess_594688(protocol: Scheme; host: string;
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

proc validate_ContentLiasettingsRequestgmbaccess_594687(path: JsonNode;
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
  var valid_594689 = path.getOrDefault("accountId")
  valid_594689 = validateParameter(valid_594689, JString, required = true,
                                 default = nil)
  if valid_594689 != nil:
    section.add "accountId", valid_594689
  var valid_594690 = path.getOrDefault("merchantId")
  valid_594690 = validateParameter(valid_594690, JString, required = true,
                                 default = nil)
  if valid_594690 != nil:
    section.add "merchantId", valid_594690
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
  var valid_594691 = query.getOrDefault("fields")
  valid_594691 = validateParameter(valid_594691, JString, required = false,
                                 default = nil)
  if valid_594691 != nil:
    section.add "fields", valid_594691
  var valid_594692 = query.getOrDefault("quotaUser")
  valid_594692 = validateParameter(valid_594692, JString, required = false,
                                 default = nil)
  if valid_594692 != nil:
    section.add "quotaUser", valid_594692
  var valid_594693 = query.getOrDefault("alt")
  valid_594693 = validateParameter(valid_594693, JString, required = false,
                                 default = newJString("json"))
  if valid_594693 != nil:
    section.add "alt", valid_594693
  var valid_594694 = query.getOrDefault("oauth_token")
  valid_594694 = validateParameter(valid_594694, JString, required = false,
                                 default = nil)
  if valid_594694 != nil:
    section.add "oauth_token", valid_594694
  var valid_594695 = query.getOrDefault("userIp")
  valid_594695 = validateParameter(valid_594695, JString, required = false,
                                 default = nil)
  if valid_594695 != nil:
    section.add "userIp", valid_594695
  var valid_594696 = query.getOrDefault("key")
  valid_594696 = validateParameter(valid_594696, JString, required = false,
                                 default = nil)
  if valid_594696 != nil:
    section.add "key", valid_594696
  assert query != nil,
        "query argument is necessary due to required `gmbEmail` field"
  var valid_594697 = query.getOrDefault("gmbEmail")
  valid_594697 = validateParameter(valid_594697, JString, required = true,
                                 default = nil)
  if valid_594697 != nil:
    section.add "gmbEmail", valid_594697
  var valid_594698 = query.getOrDefault("prettyPrint")
  valid_594698 = validateParameter(valid_594698, JBool, required = false,
                                 default = newJBool(true))
  if valid_594698 != nil:
    section.add "prettyPrint", valid_594698
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594699: Call_ContentLiasettingsRequestgmbaccess_594686;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests access to a specified Google My Business account.
  ## 
  let valid = call_594699.validator(path, query, header, formData, body)
  let scheme = call_594699.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594699.url(scheme.get, call_594699.host, call_594699.base,
                         call_594699.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594699, url, valid)

proc call*(call_594700: Call_ContentLiasettingsRequestgmbaccess_594686;
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
  var path_594701 = newJObject()
  var query_594702 = newJObject()
  add(query_594702, "fields", newJString(fields))
  add(query_594702, "quotaUser", newJString(quotaUser))
  add(query_594702, "alt", newJString(alt))
  add(query_594702, "oauth_token", newJString(oauthToken))
  add(path_594701, "accountId", newJString(accountId))
  add(query_594702, "userIp", newJString(userIp))
  add(query_594702, "key", newJString(key))
  add(query_594702, "gmbEmail", newJString(gmbEmail))
  add(path_594701, "merchantId", newJString(merchantId))
  add(query_594702, "prettyPrint", newJBool(prettyPrint))
  result = call_594700.call(path_594701, query_594702, nil, nil, nil)

var contentLiasettingsRequestgmbaccess* = Call_ContentLiasettingsRequestgmbaccess_594686(
    name: "contentLiasettingsRequestgmbaccess", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/requestgmbaccess",
    validator: validate_ContentLiasettingsRequestgmbaccess_594687,
    base: "/content/v2", url: url_ContentLiasettingsRequestgmbaccess_594688,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsRequestinventoryverification_594703 = ref object of OpenApiRestCall_593421
proc url_ContentLiasettingsRequestinventoryverification_594705(protocol: Scheme;
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

proc validate_ContentLiasettingsRequestinventoryverification_594704(
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
  var valid_594706 = path.getOrDefault("country")
  valid_594706 = validateParameter(valid_594706, JString, required = true,
                                 default = nil)
  if valid_594706 != nil:
    section.add "country", valid_594706
  var valid_594707 = path.getOrDefault("accountId")
  valid_594707 = validateParameter(valid_594707, JString, required = true,
                                 default = nil)
  if valid_594707 != nil:
    section.add "accountId", valid_594707
  var valid_594708 = path.getOrDefault("merchantId")
  valid_594708 = validateParameter(valid_594708, JString, required = true,
                                 default = nil)
  if valid_594708 != nil:
    section.add "merchantId", valid_594708
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
  var valid_594709 = query.getOrDefault("fields")
  valid_594709 = validateParameter(valid_594709, JString, required = false,
                                 default = nil)
  if valid_594709 != nil:
    section.add "fields", valid_594709
  var valid_594710 = query.getOrDefault("quotaUser")
  valid_594710 = validateParameter(valid_594710, JString, required = false,
                                 default = nil)
  if valid_594710 != nil:
    section.add "quotaUser", valid_594710
  var valid_594711 = query.getOrDefault("alt")
  valid_594711 = validateParameter(valid_594711, JString, required = false,
                                 default = newJString("json"))
  if valid_594711 != nil:
    section.add "alt", valid_594711
  var valid_594712 = query.getOrDefault("oauth_token")
  valid_594712 = validateParameter(valid_594712, JString, required = false,
                                 default = nil)
  if valid_594712 != nil:
    section.add "oauth_token", valid_594712
  var valid_594713 = query.getOrDefault("userIp")
  valid_594713 = validateParameter(valid_594713, JString, required = false,
                                 default = nil)
  if valid_594713 != nil:
    section.add "userIp", valid_594713
  var valid_594714 = query.getOrDefault("key")
  valid_594714 = validateParameter(valid_594714, JString, required = false,
                                 default = nil)
  if valid_594714 != nil:
    section.add "key", valid_594714
  var valid_594715 = query.getOrDefault("prettyPrint")
  valid_594715 = validateParameter(valid_594715, JBool, required = false,
                                 default = newJBool(true))
  if valid_594715 != nil:
    section.add "prettyPrint", valid_594715
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594716: Call_ContentLiasettingsRequestinventoryverification_594703;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests inventory validation for the specified country.
  ## 
  let valid = call_594716.validator(path, query, header, formData, body)
  let scheme = call_594716.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594716.url(scheme.get, call_594716.host, call_594716.base,
                         call_594716.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594716, url, valid)

proc call*(call_594717: Call_ContentLiasettingsRequestinventoryverification_594703;
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
  var path_594718 = newJObject()
  var query_594719 = newJObject()
  add(query_594719, "fields", newJString(fields))
  add(query_594719, "quotaUser", newJString(quotaUser))
  add(query_594719, "alt", newJString(alt))
  add(path_594718, "country", newJString(country))
  add(query_594719, "oauth_token", newJString(oauthToken))
  add(path_594718, "accountId", newJString(accountId))
  add(query_594719, "userIp", newJString(userIp))
  add(query_594719, "key", newJString(key))
  add(path_594718, "merchantId", newJString(merchantId))
  add(query_594719, "prettyPrint", newJBool(prettyPrint))
  result = call_594717.call(path_594718, query_594719, nil, nil, nil)

var contentLiasettingsRequestinventoryverification* = Call_ContentLiasettingsRequestinventoryverification_594703(
    name: "contentLiasettingsRequestinventoryverification",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}/requestinventoryverification/{country}",
    validator: validate_ContentLiasettingsRequestinventoryverification_594704,
    base: "/content/v2", url: url_ContentLiasettingsRequestinventoryverification_594705,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsSetinventoryverificationcontact_594720 = ref object of OpenApiRestCall_593421
proc url_ContentLiasettingsSetinventoryverificationcontact_594722(
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

proc validate_ContentLiasettingsSetinventoryverificationcontact_594721(
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
  var valid_594723 = path.getOrDefault("accountId")
  valid_594723 = validateParameter(valid_594723, JString, required = true,
                                 default = nil)
  if valid_594723 != nil:
    section.add "accountId", valid_594723
  var valid_594724 = path.getOrDefault("merchantId")
  valid_594724 = validateParameter(valid_594724, JString, required = true,
                                 default = nil)
  if valid_594724 != nil:
    section.add "merchantId", valid_594724
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
  var valid_594725 = query.getOrDefault("fields")
  valid_594725 = validateParameter(valid_594725, JString, required = false,
                                 default = nil)
  if valid_594725 != nil:
    section.add "fields", valid_594725
  assert query != nil, "query argument is necessary due to required `country` field"
  var valid_594726 = query.getOrDefault("country")
  valid_594726 = validateParameter(valid_594726, JString, required = true,
                                 default = nil)
  if valid_594726 != nil:
    section.add "country", valid_594726
  var valid_594727 = query.getOrDefault("quotaUser")
  valid_594727 = validateParameter(valid_594727, JString, required = false,
                                 default = nil)
  if valid_594727 != nil:
    section.add "quotaUser", valid_594727
  var valid_594728 = query.getOrDefault("alt")
  valid_594728 = validateParameter(valid_594728, JString, required = false,
                                 default = newJString("json"))
  if valid_594728 != nil:
    section.add "alt", valid_594728
  var valid_594729 = query.getOrDefault("contactName")
  valid_594729 = validateParameter(valid_594729, JString, required = true,
                                 default = nil)
  if valid_594729 != nil:
    section.add "contactName", valid_594729
  var valid_594730 = query.getOrDefault("language")
  valid_594730 = validateParameter(valid_594730, JString, required = true,
                                 default = nil)
  if valid_594730 != nil:
    section.add "language", valid_594730
  var valid_594731 = query.getOrDefault("oauth_token")
  valid_594731 = validateParameter(valid_594731, JString, required = false,
                                 default = nil)
  if valid_594731 != nil:
    section.add "oauth_token", valid_594731
  var valid_594732 = query.getOrDefault("userIp")
  valid_594732 = validateParameter(valid_594732, JString, required = false,
                                 default = nil)
  if valid_594732 != nil:
    section.add "userIp", valid_594732
  var valid_594733 = query.getOrDefault("key")
  valid_594733 = validateParameter(valid_594733, JString, required = false,
                                 default = nil)
  if valid_594733 != nil:
    section.add "key", valid_594733
  var valid_594734 = query.getOrDefault("prettyPrint")
  valid_594734 = validateParameter(valid_594734, JBool, required = false,
                                 default = newJBool(true))
  if valid_594734 != nil:
    section.add "prettyPrint", valid_594734
  var valid_594735 = query.getOrDefault("contactEmail")
  valid_594735 = validateParameter(valid_594735, JString, required = true,
                                 default = nil)
  if valid_594735 != nil:
    section.add "contactEmail", valid_594735
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594736: Call_ContentLiasettingsSetinventoryverificationcontact_594720;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the inventory verification contract for the specified country.
  ## 
  let valid = call_594736.validator(path, query, header, formData, body)
  let scheme = call_594736.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594736.url(scheme.get, call_594736.host, call_594736.base,
                         call_594736.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594736, url, valid)

proc call*(call_594737: Call_ContentLiasettingsSetinventoryverificationcontact_594720;
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
  var path_594738 = newJObject()
  var query_594739 = newJObject()
  add(query_594739, "fields", newJString(fields))
  add(query_594739, "country", newJString(country))
  add(query_594739, "quotaUser", newJString(quotaUser))
  add(query_594739, "alt", newJString(alt))
  add(query_594739, "contactName", newJString(contactName))
  add(query_594739, "language", newJString(language))
  add(query_594739, "oauth_token", newJString(oauthToken))
  add(path_594738, "accountId", newJString(accountId))
  add(query_594739, "userIp", newJString(userIp))
  add(query_594739, "key", newJString(key))
  add(path_594738, "merchantId", newJString(merchantId))
  add(query_594739, "prettyPrint", newJBool(prettyPrint))
  add(query_594739, "contactEmail", newJString(contactEmail))
  result = call_594737.call(path_594738, query_594739, nil, nil, nil)

var contentLiasettingsSetinventoryverificationcontact* = Call_ContentLiasettingsSetinventoryverificationcontact_594720(
    name: "contentLiasettingsSetinventoryverificationcontact",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}/setinventoryverificationcontact",
    validator: validate_ContentLiasettingsSetinventoryverificationcontact_594721,
    base: "/content/v2",
    url: url_ContentLiasettingsSetinventoryverificationcontact_594722,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsSetposdataprovider_594740 = ref object of OpenApiRestCall_593421
proc url_ContentLiasettingsSetposdataprovider_594742(protocol: Scheme;
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

proc validate_ContentLiasettingsSetposdataprovider_594741(path: JsonNode;
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
  var valid_594743 = path.getOrDefault("accountId")
  valid_594743 = validateParameter(valid_594743, JString, required = true,
                                 default = nil)
  if valid_594743 != nil:
    section.add "accountId", valid_594743
  var valid_594744 = path.getOrDefault("merchantId")
  valid_594744 = validateParameter(valid_594744, JString, required = true,
                                 default = nil)
  if valid_594744 != nil:
    section.add "merchantId", valid_594744
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
  var valid_594745 = query.getOrDefault("fields")
  valid_594745 = validateParameter(valid_594745, JString, required = false,
                                 default = nil)
  if valid_594745 != nil:
    section.add "fields", valid_594745
  assert query != nil, "query argument is necessary due to required `country` field"
  var valid_594746 = query.getOrDefault("country")
  valid_594746 = validateParameter(valid_594746, JString, required = true,
                                 default = nil)
  if valid_594746 != nil:
    section.add "country", valid_594746
  var valid_594747 = query.getOrDefault("quotaUser")
  valid_594747 = validateParameter(valid_594747, JString, required = false,
                                 default = nil)
  if valid_594747 != nil:
    section.add "quotaUser", valid_594747
  var valid_594748 = query.getOrDefault("alt")
  valid_594748 = validateParameter(valid_594748, JString, required = false,
                                 default = newJString("json"))
  if valid_594748 != nil:
    section.add "alt", valid_594748
  var valid_594749 = query.getOrDefault("oauth_token")
  valid_594749 = validateParameter(valid_594749, JString, required = false,
                                 default = nil)
  if valid_594749 != nil:
    section.add "oauth_token", valid_594749
  var valid_594750 = query.getOrDefault("userIp")
  valid_594750 = validateParameter(valid_594750, JString, required = false,
                                 default = nil)
  if valid_594750 != nil:
    section.add "userIp", valid_594750
  var valid_594751 = query.getOrDefault("posExternalAccountId")
  valid_594751 = validateParameter(valid_594751, JString, required = false,
                                 default = nil)
  if valid_594751 != nil:
    section.add "posExternalAccountId", valid_594751
  var valid_594752 = query.getOrDefault("key")
  valid_594752 = validateParameter(valid_594752, JString, required = false,
                                 default = nil)
  if valid_594752 != nil:
    section.add "key", valid_594752
  var valid_594753 = query.getOrDefault("posDataProviderId")
  valid_594753 = validateParameter(valid_594753, JString, required = false,
                                 default = nil)
  if valid_594753 != nil:
    section.add "posDataProviderId", valid_594753
  var valid_594754 = query.getOrDefault("prettyPrint")
  valid_594754 = validateParameter(valid_594754, JBool, required = false,
                                 default = newJBool(true))
  if valid_594754 != nil:
    section.add "prettyPrint", valid_594754
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594755: Call_ContentLiasettingsSetposdataprovider_594740;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the POS data provider for the specified country.
  ## 
  let valid = call_594755.validator(path, query, header, formData, body)
  let scheme = call_594755.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594755.url(scheme.get, call_594755.host, call_594755.base,
                         call_594755.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594755, url, valid)

proc call*(call_594756: Call_ContentLiasettingsSetposdataprovider_594740;
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
  var path_594757 = newJObject()
  var query_594758 = newJObject()
  add(query_594758, "fields", newJString(fields))
  add(query_594758, "country", newJString(country))
  add(query_594758, "quotaUser", newJString(quotaUser))
  add(query_594758, "alt", newJString(alt))
  add(query_594758, "oauth_token", newJString(oauthToken))
  add(path_594757, "accountId", newJString(accountId))
  add(query_594758, "userIp", newJString(userIp))
  add(query_594758, "posExternalAccountId", newJString(posExternalAccountId))
  add(query_594758, "key", newJString(key))
  add(query_594758, "posDataProviderId", newJString(posDataProviderId))
  add(path_594757, "merchantId", newJString(merchantId))
  add(query_594758, "prettyPrint", newJBool(prettyPrint))
  result = call_594756.call(path_594757, query_594758, nil, nil, nil)

var contentLiasettingsSetposdataprovider* = Call_ContentLiasettingsSetposdataprovider_594740(
    name: "contentLiasettingsSetposdataprovider", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/setposdataprovider",
    validator: validate_ContentLiasettingsSetposdataprovider_594741,
    base: "/content/v2", url: url_ContentLiasettingsSetposdataprovider_594742,
    schemes: {Scheme.Https})
type
  Call_ContentOrderinvoicesCreatechargeinvoice_594759 = ref object of OpenApiRestCall_593421
proc url_ContentOrderinvoicesCreatechargeinvoice_594761(protocol: Scheme;
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

proc validate_ContentOrderinvoicesCreatechargeinvoice_594760(path: JsonNode;
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
  var valid_594762 = path.getOrDefault("orderId")
  valid_594762 = validateParameter(valid_594762, JString, required = true,
                                 default = nil)
  if valid_594762 != nil:
    section.add "orderId", valid_594762
  var valid_594763 = path.getOrDefault("merchantId")
  valid_594763 = validateParameter(valid_594763, JString, required = true,
                                 default = nil)
  if valid_594763 != nil:
    section.add "merchantId", valid_594763
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
  var valid_594764 = query.getOrDefault("fields")
  valid_594764 = validateParameter(valid_594764, JString, required = false,
                                 default = nil)
  if valid_594764 != nil:
    section.add "fields", valid_594764
  var valid_594765 = query.getOrDefault("quotaUser")
  valid_594765 = validateParameter(valid_594765, JString, required = false,
                                 default = nil)
  if valid_594765 != nil:
    section.add "quotaUser", valid_594765
  var valid_594766 = query.getOrDefault("alt")
  valid_594766 = validateParameter(valid_594766, JString, required = false,
                                 default = newJString("json"))
  if valid_594766 != nil:
    section.add "alt", valid_594766
  var valid_594767 = query.getOrDefault("oauth_token")
  valid_594767 = validateParameter(valid_594767, JString, required = false,
                                 default = nil)
  if valid_594767 != nil:
    section.add "oauth_token", valid_594767
  var valid_594768 = query.getOrDefault("userIp")
  valid_594768 = validateParameter(valid_594768, JString, required = false,
                                 default = nil)
  if valid_594768 != nil:
    section.add "userIp", valid_594768
  var valid_594769 = query.getOrDefault("key")
  valid_594769 = validateParameter(valid_594769, JString, required = false,
                                 default = nil)
  if valid_594769 != nil:
    section.add "key", valid_594769
  var valid_594770 = query.getOrDefault("prettyPrint")
  valid_594770 = validateParameter(valid_594770, JBool, required = false,
                                 default = newJBool(true))
  if valid_594770 != nil:
    section.add "prettyPrint", valid_594770
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

proc call*(call_594772: Call_ContentOrderinvoicesCreatechargeinvoice_594759;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a charge invoice for a shipment group, and triggers a charge capture for orderinvoice enabled orders.
  ## 
  let valid = call_594772.validator(path, query, header, formData, body)
  let scheme = call_594772.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594772.url(scheme.get, call_594772.host, call_594772.base,
                         call_594772.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594772, url, valid)

proc call*(call_594773: Call_ContentOrderinvoicesCreatechargeinvoice_594759;
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
  var path_594774 = newJObject()
  var query_594775 = newJObject()
  var body_594776 = newJObject()
  add(query_594775, "fields", newJString(fields))
  add(query_594775, "quotaUser", newJString(quotaUser))
  add(query_594775, "alt", newJString(alt))
  add(query_594775, "oauth_token", newJString(oauthToken))
  add(query_594775, "userIp", newJString(userIp))
  add(path_594774, "orderId", newJString(orderId))
  add(query_594775, "key", newJString(key))
  add(path_594774, "merchantId", newJString(merchantId))
  if body != nil:
    body_594776 = body
  add(query_594775, "prettyPrint", newJBool(prettyPrint))
  result = call_594773.call(path_594774, query_594775, nil, nil, body_594776)

var contentOrderinvoicesCreatechargeinvoice* = Call_ContentOrderinvoicesCreatechargeinvoice_594759(
    name: "contentOrderinvoicesCreatechargeinvoice", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderinvoices/{orderId}/createChargeInvoice",
    validator: validate_ContentOrderinvoicesCreatechargeinvoice_594760,
    base: "/content/v2", url: url_ContentOrderinvoicesCreatechargeinvoice_594761,
    schemes: {Scheme.Https})
type
  Call_ContentOrderinvoicesCreaterefundinvoice_594777 = ref object of OpenApiRestCall_593421
proc url_ContentOrderinvoicesCreaterefundinvoice_594779(protocol: Scheme;
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

proc validate_ContentOrderinvoicesCreaterefundinvoice_594778(path: JsonNode;
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
  var valid_594780 = path.getOrDefault("orderId")
  valid_594780 = validateParameter(valid_594780, JString, required = true,
                                 default = nil)
  if valid_594780 != nil:
    section.add "orderId", valid_594780
  var valid_594781 = path.getOrDefault("merchantId")
  valid_594781 = validateParameter(valid_594781, JString, required = true,
                                 default = nil)
  if valid_594781 != nil:
    section.add "merchantId", valid_594781
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
  var valid_594782 = query.getOrDefault("fields")
  valid_594782 = validateParameter(valid_594782, JString, required = false,
                                 default = nil)
  if valid_594782 != nil:
    section.add "fields", valid_594782
  var valid_594783 = query.getOrDefault("quotaUser")
  valid_594783 = validateParameter(valid_594783, JString, required = false,
                                 default = nil)
  if valid_594783 != nil:
    section.add "quotaUser", valid_594783
  var valid_594784 = query.getOrDefault("alt")
  valid_594784 = validateParameter(valid_594784, JString, required = false,
                                 default = newJString("json"))
  if valid_594784 != nil:
    section.add "alt", valid_594784
  var valid_594785 = query.getOrDefault("oauth_token")
  valid_594785 = validateParameter(valid_594785, JString, required = false,
                                 default = nil)
  if valid_594785 != nil:
    section.add "oauth_token", valid_594785
  var valid_594786 = query.getOrDefault("userIp")
  valid_594786 = validateParameter(valid_594786, JString, required = false,
                                 default = nil)
  if valid_594786 != nil:
    section.add "userIp", valid_594786
  var valid_594787 = query.getOrDefault("key")
  valid_594787 = validateParameter(valid_594787, JString, required = false,
                                 default = nil)
  if valid_594787 != nil:
    section.add "key", valid_594787
  var valid_594788 = query.getOrDefault("prettyPrint")
  valid_594788 = validateParameter(valid_594788, JBool, required = false,
                                 default = newJBool(true))
  if valid_594788 != nil:
    section.add "prettyPrint", valid_594788
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

proc call*(call_594790: Call_ContentOrderinvoicesCreaterefundinvoice_594777;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a refund invoice for one or more shipment groups, and triggers a refund for orderinvoice enabled orders. This can only be used for line items that have previously been charged using createChargeInvoice. All amounts (except for the summary) are incremental with respect to the previous invoice.
  ## 
  let valid = call_594790.validator(path, query, header, formData, body)
  let scheme = call_594790.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594790.url(scheme.get, call_594790.host, call_594790.base,
                         call_594790.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594790, url, valid)

proc call*(call_594791: Call_ContentOrderinvoicesCreaterefundinvoice_594777;
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
  var path_594792 = newJObject()
  var query_594793 = newJObject()
  var body_594794 = newJObject()
  add(query_594793, "fields", newJString(fields))
  add(query_594793, "quotaUser", newJString(quotaUser))
  add(query_594793, "alt", newJString(alt))
  add(query_594793, "oauth_token", newJString(oauthToken))
  add(query_594793, "userIp", newJString(userIp))
  add(path_594792, "orderId", newJString(orderId))
  add(query_594793, "key", newJString(key))
  add(path_594792, "merchantId", newJString(merchantId))
  if body != nil:
    body_594794 = body
  add(query_594793, "prettyPrint", newJBool(prettyPrint))
  result = call_594791.call(path_594792, query_594793, nil, nil, body_594794)

var contentOrderinvoicesCreaterefundinvoice* = Call_ContentOrderinvoicesCreaterefundinvoice_594777(
    name: "contentOrderinvoicesCreaterefundinvoice", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderinvoices/{orderId}/createRefundInvoice",
    validator: validate_ContentOrderinvoicesCreaterefundinvoice_594778,
    base: "/content/v2", url: url_ContentOrderinvoicesCreaterefundinvoice_594779,
    schemes: {Scheme.Https})
type
  Call_ContentOrderpaymentsNotifyauthapproved_594795 = ref object of OpenApiRestCall_593421
proc url_ContentOrderpaymentsNotifyauthapproved_594797(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/orderpayments/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/notifyAuthApproved")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrderpaymentsNotifyauthapproved_594796(path: JsonNode;
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
  var valid_594798 = path.getOrDefault("orderId")
  valid_594798 = validateParameter(valid_594798, JString, required = true,
                                 default = nil)
  if valid_594798 != nil:
    section.add "orderId", valid_594798
  var valid_594799 = path.getOrDefault("merchantId")
  valid_594799 = validateParameter(valid_594799, JString, required = true,
                                 default = nil)
  if valid_594799 != nil:
    section.add "merchantId", valid_594799
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
  var valid_594800 = query.getOrDefault("fields")
  valid_594800 = validateParameter(valid_594800, JString, required = false,
                                 default = nil)
  if valid_594800 != nil:
    section.add "fields", valid_594800
  var valid_594801 = query.getOrDefault("quotaUser")
  valid_594801 = validateParameter(valid_594801, JString, required = false,
                                 default = nil)
  if valid_594801 != nil:
    section.add "quotaUser", valid_594801
  var valid_594802 = query.getOrDefault("alt")
  valid_594802 = validateParameter(valid_594802, JString, required = false,
                                 default = newJString("json"))
  if valid_594802 != nil:
    section.add "alt", valid_594802
  var valid_594803 = query.getOrDefault("oauth_token")
  valid_594803 = validateParameter(valid_594803, JString, required = false,
                                 default = nil)
  if valid_594803 != nil:
    section.add "oauth_token", valid_594803
  var valid_594804 = query.getOrDefault("userIp")
  valid_594804 = validateParameter(valid_594804, JString, required = false,
                                 default = nil)
  if valid_594804 != nil:
    section.add "userIp", valid_594804
  var valid_594805 = query.getOrDefault("key")
  valid_594805 = validateParameter(valid_594805, JString, required = false,
                                 default = nil)
  if valid_594805 != nil:
    section.add "key", valid_594805
  var valid_594806 = query.getOrDefault("prettyPrint")
  valid_594806 = validateParameter(valid_594806, JBool, required = false,
                                 default = newJBool(true))
  if valid_594806 != nil:
    section.add "prettyPrint", valid_594806
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

proc call*(call_594808: Call_ContentOrderpaymentsNotifyauthapproved_594795;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Notify about successfully authorizing user's payment method for a given amount.
  ## 
  let valid = call_594808.validator(path, query, header, formData, body)
  let scheme = call_594808.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594808.url(scheme.get, call_594808.host, call_594808.base,
                         call_594808.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594808, url, valid)

proc call*(call_594809: Call_ContentOrderpaymentsNotifyauthapproved_594795;
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
  var path_594810 = newJObject()
  var query_594811 = newJObject()
  var body_594812 = newJObject()
  add(query_594811, "fields", newJString(fields))
  add(query_594811, "quotaUser", newJString(quotaUser))
  add(query_594811, "alt", newJString(alt))
  add(query_594811, "oauth_token", newJString(oauthToken))
  add(query_594811, "userIp", newJString(userIp))
  add(path_594810, "orderId", newJString(orderId))
  add(query_594811, "key", newJString(key))
  add(path_594810, "merchantId", newJString(merchantId))
  if body != nil:
    body_594812 = body
  add(query_594811, "prettyPrint", newJBool(prettyPrint))
  result = call_594809.call(path_594810, query_594811, nil, nil, body_594812)

var contentOrderpaymentsNotifyauthapproved* = Call_ContentOrderpaymentsNotifyauthapproved_594795(
    name: "contentOrderpaymentsNotifyauthapproved", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderpayments/{orderId}/notifyAuthApproved",
    validator: validate_ContentOrderpaymentsNotifyauthapproved_594796,
    base: "/content/v2", url: url_ContentOrderpaymentsNotifyauthapproved_594797,
    schemes: {Scheme.Https})
type
  Call_ContentOrderpaymentsNotifyauthdeclined_594813 = ref object of OpenApiRestCall_593421
proc url_ContentOrderpaymentsNotifyauthdeclined_594815(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/orderpayments/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/notifyAuthDeclined")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrderpaymentsNotifyauthdeclined_594814(path: JsonNode;
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
  var valid_594816 = path.getOrDefault("orderId")
  valid_594816 = validateParameter(valid_594816, JString, required = true,
                                 default = nil)
  if valid_594816 != nil:
    section.add "orderId", valid_594816
  var valid_594817 = path.getOrDefault("merchantId")
  valid_594817 = validateParameter(valid_594817, JString, required = true,
                                 default = nil)
  if valid_594817 != nil:
    section.add "merchantId", valid_594817
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
  var valid_594818 = query.getOrDefault("fields")
  valid_594818 = validateParameter(valid_594818, JString, required = false,
                                 default = nil)
  if valid_594818 != nil:
    section.add "fields", valid_594818
  var valid_594819 = query.getOrDefault("quotaUser")
  valid_594819 = validateParameter(valid_594819, JString, required = false,
                                 default = nil)
  if valid_594819 != nil:
    section.add "quotaUser", valid_594819
  var valid_594820 = query.getOrDefault("alt")
  valid_594820 = validateParameter(valid_594820, JString, required = false,
                                 default = newJString("json"))
  if valid_594820 != nil:
    section.add "alt", valid_594820
  var valid_594821 = query.getOrDefault("oauth_token")
  valid_594821 = validateParameter(valid_594821, JString, required = false,
                                 default = nil)
  if valid_594821 != nil:
    section.add "oauth_token", valid_594821
  var valid_594822 = query.getOrDefault("userIp")
  valid_594822 = validateParameter(valid_594822, JString, required = false,
                                 default = nil)
  if valid_594822 != nil:
    section.add "userIp", valid_594822
  var valid_594823 = query.getOrDefault("key")
  valid_594823 = validateParameter(valid_594823, JString, required = false,
                                 default = nil)
  if valid_594823 != nil:
    section.add "key", valid_594823
  var valid_594824 = query.getOrDefault("prettyPrint")
  valid_594824 = validateParameter(valid_594824, JBool, required = false,
                                 default = newJBool(true))
  if valid_594824 != nil:
    section.add "prettyPrint", valid_594824
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

proc call*(call_594826: Call_ContentOrderpaymentsNotifyauthdeclined_594813;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Notify about failure to authorize user's payment method.
  ## 
  let valid = call_594826.validator(path, query, header, formData, body)
  let scheme = call_594826.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594826.url(scheme.get, call_594826.host, call_594826.base,
                         call_594826.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594826, url, valid)

proc call*(call_594827: Call_ContentOrderpaymentsNotifyauthdeclined_594813;
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
  var path_594828 = newJObject()
  var query_594829 = newJObject()
  var body_594830 = newJObject()
  add(query_594829, "fields", newJString(fields))
  add(query_594829, "quotaUser", newJString(quotaUser))
  add(query_594829, "alt", newJString(alt))
  add(query_594829, "oauth_token", newJString(oauthToken))
  add(query_594829, "userIp", newJString(userIp))
  add(path_594828, "orderId", newJString(orderId))
  add(query_594829, "key", newJString(key))
  add(path_594828, "merchantId", newJString(merchantId))
  if body != nil:
    body_594830 = body
  add(query_594829, "prettyPrint", newJBool(prettyPrint))
  result = call_594827.call(path_594828, query_594829, nil, nil, body_594830)

var contentOrderpaymentsNotifyauthdeclined* = Call_ContentOrderpaymentsNotifyauthdeclined_594813(
    name: "contentOrderpaymentsNotifyauthdeclined", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderpayments/{orderId}/notifyAuthDeclined",
    validator: validate_ContentOrderpaymentsNotifyauthdeclined_594814,
    base: "/content/v2", url: url_ContentOrderpaymentsNotifyauthdeclined_594815,
    schemes: {Scheme.Https})
type
  Call_ContentOrderpaymentsNotifycharge_594831 = ref object of OpenApiRestCall_593421
proc url_ContentOrderpaymentsNotifycharge_594833(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/orderpayments/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/notifyCharge")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrderpaymentsNotifycharge_594832(path: JsonNode;
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
  var valid_594834 = path.getOrDefault("orderId")
  valid_594834 = validateParameter(valid_594834, JString, required = true,
                                 default = nil)
  if valid_594834 != nil:
    section.add "orderId", valid_594834
  var valid_594835 = path.getOrDefault("merchantId")
  valid_594835 = validateParameter(valid_594835, JString, required = true,
                                 default = nil)
  if valid_594835 != nil:
    section.add "merchantId", valid_594835
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
  var valid_594836 = query.getOrDefault("fields")
  valid_594836 = validateParameter(valid_594836, JString, required = false,
                                 default = nil)
  if valid_594836 != nil:
    section.add "fields", valid_594836
  var valid_594837 = query.getOrDefault("quotaUser")
  valid_594837 = validateParameter(valid_594837, JString, required = false,
                                 default = nil)
  if valid_594837 != nil:
    section.add "quotaUser", valid_594837
  var valid_594838 = query.getOrDefault("alt")
  valid_594838 = validateParameter(valid_594838, JString, required = false,
                                 default = newJString("json"))
  if valid_594838 != nil:
    section.add "alt", valid_594838
  var valid_594839 = query.getOrDefault("oauth_token")
  valid_594839 = validateParameter(valid_594839, JString, required = false,
                                 default = nil)
  if valid_594839 != nil:
    section.add "oauth_token", valid_594839
  var valid_594840 = query.getOrDefault("userIp")
  valid_594840 = validateParameter(valid_594840, JString, required = false,
                                 default = nil)
  if valid_594840 != nil:
    section.add "userIp", valid_594840
  var valid_594841 = query.getOrDefault("key")
  valid_594841 = validateParameter(valid_594841, JString, required = false,
                                 default = nil)
  if valid_594841 != nil:
    section.add "key", valid_594841
  var valid_594842 = query.getOrDefault("prettyPrint")
  valid_594842 = validateParameter(valid_594842, JBool, required = false,
                                 default = newJBool(true))
  if valid_594842 != nil:
    section.add "prettyPrint", valid_594842
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

proc call*(call_594844: Call_ContentOrderpaymentsNotifycharge_594831;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Notify about charge on user's selected payments method.
  ## 
  let valid = call_594844.validator(path, query, header, formData, body)
  let scheme = call_594844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594844.url(scheme.get, call_594844.host, call_594844.base,
                         call_594844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594844, url, valid)

proc call*(call_594845: Call_ContentOrderpaymentsNotifycharge_594831;
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
  var path_594846 = newJObject()
  var query_594847 = newJObject()
  var body_594848 = newJObject()
  add(query_594847, "fields", newJString(fields))
  add(query_594847, "quotaUser", newJString(quotaUser))
  add(query_594847, "alt", newJString(alt))
  add(query_594847, "oauth_token", newJString(oauthToken))
  add(query_594847, "userIp", newJString(userIp))
  add(path_594846, "orderId", newJString(orderId))
  add(query_594847, "key", newJString(key))
  add(path_594846, "merchantId", newJString(merchantId))
  if body != nil:
    body_594848 = body
  add(query_594847, "prettyPrint", newJBool(prettyPrint))
  result = call_594845.call(path_594846, query_594847, nil, nil, body_594848)

var contentOrderpaymentsNotifycharge* = Call_ContentOrderpaymentsNotifycharge_594831(
    name: "contentOrderpaymentsNotifycharge", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderpayments/{orderId}/notifyCharge",
    validator: validate_ContentOrderpaymentsNotifycharge_594832,
    base: "/content/v2", url: url_ContentOrderpaymentsNotifycharge_594833,
    schemes: {Scheme.Https})
type
  Call_ContentOrderpaymentsNotifyrefund_594849 = ref object of OpenApiRestCall_593421
proc url_ContentOrderpaymentsNotifyrefund_594851(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/orderpayments/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: "/notifyRefund")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrderpaymentsNotifyrefund_594850(path: JsonNode;
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
  var valid_594852 = path.getOrDefault("orderId")
  valid_594852 = validateParameter(valid_594852, JString, required = true,
                                 default = nil)
  if valid_594852 != nil:
    section.add "orderId", valid_594852
  var valid_594853 = path.getOrDefault("merchantId")
  valid_594853 = validateParameter(valid_594853, JString, required = true,
                                 default = nil)
  if valid_594853 != nil:
    section.add "merchantId", valid_594853
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
  var valid_594854 = query.getOrDefault("fields")
  valid_594854 = validateParameter(valid_594854, JString, required = false,
                                 default = nil)
  if valid_594854 != nil:
    section.add "fields", valid_594854
  var valid_594855 = query.getOrDefault("quotaUser")
  valid_594855 = validateParameter(valid_594855, JString, required = false,
                                 default = nil)
  if valid_594855 != nil:
    section.add "quotaUser", valid_594855
  var valid_594856 = query.getOrDefault("alt")
  valid_594856 = validateParameter(valid_594856, JString, required = false,
                                 default = newJString("json"))
  if valid_594856 != nil:
    section.add "alt", valid_594856
  var valid_594857 = query.getOrDefault("oauth_token")
  valid_594857 = validateParameter(valid_594857, JString, required = false,
                                 default = nil)
  if valid_594857 != nil:
    section.add "oauth_token", valid_594857
  var valid_594858 = query.getOrDefault("userIp")
  valid_594858 = validateParameter(valid_594858, JString, required = false,
                                 default = nil)
  if valid_594858 != nil:
    section.add "userIp", valid_594858
  var valid_594859 = query.getOrDefault("key")
  valid_594859 = validateParameter(valid_594859, JString, required = false,
                                 default = nil)
  if valid_594859 != nil:
    section.add "key", valid_594859
  var valid_594860 = query.getOrDefault("prettyPrint")
  valid_594860 = validateParameter(valid_594860, JBool, required = false,
                                 default = newJBool(true))
  if valid_594860 != nil:
    section.add "prettyPrint", valid_594860
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

proc call*(call_594862: Call_ContentOrderpaymentsNotifyrefund_594849;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Notify about refund on user's selected payments method.
  ## 
  let valid = call_594862.validator(path, query, header, formData, body)
  let scheme = call_594862.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594862.url(scheme.get, call_594862.host, call_594862.base,
                         call_594862.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594862, url, valid)

proc call*(call_594863: Call_ContentOrderpaymentsNotifyrefund_594849;
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
  var path_594864 = newJObject()
  var query_594865 = newJObject()
  var body_594866 = newJObject()
  add(query_594865, "fields", newJString(fields))
  add(query_594865, "quotaUser", newJString(quotaUser))
  add(query_594865, "alt", newJString(alt))
  add(query_594865, "oauth_token", newJString(oauthToken))
  add(query_594865, "userIp", newJString(userIp))
  add(path_594864, "orderId", newJString(orderId))
  add(query_594865, "key", newJString(key))
  add(path_594864, "merchantId", newJString(merchantId))
  if body != nil:
    body_594866 = body
  add(query_594865, "prettyPrint", newJBool(prettyPrint))
  result = call_594863.call(path_594864, query_594865, nil, nil, body_594866)

var contentOrderpaymentsNotifyrefund* = Call_ContentOrderpaymentsNotifyrefund_594849(
    name: "contentOrderpaymentsNotifyrefund", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderpayments/{orderId}/notifyRefund",
    validator: validate_ContentOrderpaymentsNotifyrefund_594850,
    base: "/content/v2", url: url_ContentOrderpaymentsNotifyrefund_594851,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreportsListdisbursements_594867 = ref object of OpenApiRestCall_593421
proc url_ContentOrderreportsListdisbursements_594869(protocol: Scheme;
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

proc validate_ContentOrderreportsListdisbursements_594868(path: JsonNode;
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
  var valid_594870 = path.getOrDefault("merchantId")
  valid_594870 = validateParameter(valid_594870, JString, required = true,
                                 default = nil)
  if valid_594870 != nil:
    section.add "merchantId", valid_594870
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
  var valid_594871 = query.getOrDefault("fields")
  valid_594871 = validateParameter(valid_594871, JString, required = false,
                                 default = nil)
  if valid_594871 != nil:
    section.add "fields", valid_594871
  var valid_594872 = query.getOrDefault("pageToken")
  valid_594872 = validateParameter(valid_594872, JString, required = false,
                                 default = nil)
  if valid_594872 != nil:
    section.add "pageToken", valid_594872
  var valid_594873 = query.getOrDefault("quotaUser")
  valid_594873 = validateParameter(valid_594873, JString, required = false,
                                 default = nil)
  if valid_594873 != nil:
    section.add "quotaUser", valid_594873
  var valid_594874 = query.getOrDefault("alt")
  valid_594874 = validateParameter(valid_594874, JString, required = false,
                                 default = newJString("json"))
  if valid_594874 != nil:
    section.add "alt", valid_594874
  var valid_594875 = query.getOrDefault("oauth_token")
  valid_594875 = validateParameter(valid_594875, JString, required = false,
                                 default = nil)
  if valid_594875 != nil:
    section.add "oauth_token", valid_594875
  var valid_594876 = query.getOrDefault("userIp")
  valid_594876 = validateParameter(valid_594876, JString, required = false,
                                 default = nil)
  if valid_594876 != nil:
    section.add "userIp", valid_594876
  var valid_594877 = query.getOrDefault("maxResults")
  valid_594877 = validateParameter(valid_594877, JInt, required = false, default = nil)
  if valid_594877 != nil:
    section.add "maxResults", valid_594877
  var valid_594878 = query.getOrDefault("key")
  valid_594878 = validateParameter(valid_594878, JString, required = false,
                                 default = nil)
  if valid_594878 != nil:
    section.add "key", valid_594878
  var valid_594879 = query.getOrDefault("prettyPrint")
  valid_594879 = validateParameter(valid_594879, JBool, required = false,
                                 default = newJBool(true))
  if valid_594879 != nil:
    section.add "prettyPrint", valid_594879
  assert query != nil, "query argument is necessary due to required `disbursementStartDate` field"
  var valid_594880 = query.getOrDefault("disbursementStartDate")
  valid_594880 = validateParameter(valid_594880, JString, required = true,
                                 default = nil)
  if valid_594880 != nil:
    section.add "disbursementStartDate", valid_594880
  var valid_594881 = query.getOrDefault("disbursementEndDate")
  valid_594881 = validateParameter(valid_594881, JString, required = false,
                                 default = nil)
  if valid_594881 != nil:
    section.add "disbursementEndDate", valid_594881
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594882: Call_ContentOrderreportsListdisbursements_594867;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a report for disbursements from your Merchant Center account.
  ## 
  let valid = call_594882.validator(path, query, header, formData, body)
  let scheme = call_594882.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594882.url(scheme.get, call_594882.host, call_594882.base,
                         call_594882.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594882, url, valid)

proc call*(call_594883: Call_ContentOrderreportsListdisbursements_594867;
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
  var path_594884 = newJObject()
  var query_594885 = newJObject()
  add(query_594885, "fields", newJString(fields))
  add(query_594885, "pageToken", newJString(pageToken))
  add(query_594885, "quotaUser", newJString(quotaUser))
  add(query_594885, "alt", newJString(alt))
  add(query_594885, "oauth_token", newJString(oauthToken))
  add(query_594885, "userIp", newJString(userIp))
  add(query_594885, "maxResults", newJInt(maxResults))
  add(query_594885, "key", newJString(key))
  add(path_594884, "merchantId", newJString(merchantId))
  add(query_594885, "prettyPrint", newJBool(prettyPrint))
  add(query_594885, "disbursementStartDate", newJString(disbursementStartDate))
  add(query_594885, "disbursementEndDate", newJString(disbursementEndDate))
  result = call_594883.call(path_594884, query_594885, nil, nil, nil)

var contentOrderreportsListdisbursements* = Call_ContentOrderreportsListdisbursements_594867(
    name: "contentOrderreportsListdisbursements", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreports/disbursements",
    validator: validate_ContentOrderreportsListdisbursements_594868,
    base: "/content/v2", url: url_ContentOrderreportsListdisbursements_594869,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreportsListtransactions_594886 = ref object of OpenApiRestCall_593421
proc url_ContentOrderreportsListtransactions_594888(protocol: Scheme; host: string;
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

proc validate_ContentOrderreportsListtransactions_594887(path: JsonNode;
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
  var valid_594889 = path.getOrDefault("merchantId")
  valid_594889 = validateParameter(valid_594889, JString, required = true,
                                 default = nil)
  if valid_594889 != nil:
    section.add "merchantId", valid_594889
  var valid_594890 = path.getOrDefault("disbursementId")
  valid_594890 = validateParameter(valid_594890, JString, required = true,
                                 default = nil)
  if valid_594890 != nil:
    section.add "disbursementId", valid_594890
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
  var valid_594891 = query.getOrDefault("fields")
  valid_594891 = validateParameter(valid_594891, JString, required = false,
                                 default = nil)
  if valid_594891 != nil:
    section.add "fields", valid_594891
  var valid_594892 = query.getOrDefault("pageToken")
  valid_594892 = validateParameter(valid_594892, JString, required = false,
                                 default = nil)
  if valid_594892 != nil:
    section.add "pageToken", valid_594892
  var valid_594893 = query.getOrDefault("quotaUser")
  valid_594893 = validateParameter(valid_594893, JString, required = false,
                                 default = nil)
  if valid_594893 != nil:
    section.add "quotaUser", valid_594893
  var valid_594894 = query.getOrDefault("alt")
  valid_594894 = validateParameter(valid_594894, JString, required = false,
                                 default = newJString("json"))
  if valid_594894 != nil:
    section.add "alt", valid_594894
  var valid_594895 = query.getOrDefault("transactionEndDate")
  valid_594895 = validateParameter(valid_594895, JString, required = false,
                                 default = nil)
  if valid_594895 != nil:
    section.add "transactionEndDate", valid_594895
  var valid_594896 = query.getOrDefault("oauth_token")
  valid_594896 = validateParameter(valid_594896, JString, required = false,
                                 default = nil)
  if valid_594896 != nil:
    section.add "oauth_token", valid_594896
  var valid_594897 = query.getOrDefault("userIp")
  valid_594897 = validateParameter(valid_594897, JString, required = false,
                                 default = nil)
  if valid_594897 != nil:
    section.add "userIp", valid_594897
  var valid_594898 = query.getOrDefault("maxResults")
  valid_594898 = validateParameter(valid_594898, JInt, required = false, default = nil)
  if valid_594898 != nil:
    section.add "maxResults", valid_594898
  assert query != nil, "query argument is necessary due to required `transactionStartDate` field"
  var valid_594899 = query.getOrDefault("transactionStartDate")
  valid_594899 = validateParameter(valid_594899, JString, required = true,
                                 default = nil)
  if valid_594899 != nil:
    section.add "transactionStartDate", valid_594899
  var valid_594900 = query.getOrDefault("key")
  valid_594900 = validateParameter(valid_594900, JString, required = false,
                                 default = nil)
  if valid_594900 != nil:
    section.add "key", valid_594900
  var valid_594901 = query.getOrDefault("prettyPrint")
  valid_594901 = validateParameter(valid_594901, JBool, required = false,
                                 default = newJBool(true))
  if valid_594901 != nil:
    section.add "prettyPrint", valid_594901
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594902: Call_ContentOrderreportsListtransactions_594886;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of transactions for a disbursement from your Merchant Center account.
  ## 
  let valid = call_594902.validator(path, query, header, formData, body)
  let scheme = call_594902.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594902.url(scheme.get, call_594902.host, call_594902.base,
                         call_594902.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594902, url, valid)

proc call*(call_594903: Call_ContentOrderreportsListtransactions_594886;
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
  var path_594904 = newJObject()
  var query_594905 = newJObject()
  add(query_594905, "fields", newJString(fields))
  add(query_594905, "pageToken", newJString(pageToken))
  add(query_594905, "quotaUser", newJString(quotaUser))
  add(query_594905, "alt", newJString(alt))
  add(query_594905, "transactionEndDate", newJString(transactionEndDate))
  add(query_594905, "oauth_token", newJString(oauthToken))
  add(query_594905, "userIp", newJString(userIp))
  add(query_594905, "maxResults", newJInt(maxResults))
  add(query_594905, "transactionStartDate", newJString(transactionStartDate))
  add(query_594905, "key", newJString(key))
  add(path_594904, "merchantId", newJString(merchantId))
  add(path_594904, "disbursementId", newJString(disbursementId))
  add(query_594905, "prettyPrint", newJBool(prettyPrint))
  result = call_594903.call(path_594904, query_594905, nil, nil, nil)

var contentOrderreportsListtransactions* = Call_ContentOrderreportsListtransactions_594886(
    name: "contentOrderreportsListtransactions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreports/disbursements/{disbursementId}/transactions",
    validator: validate_ContentOrderreportsListtransactions_594887,
    base: "/content/v2", url: url_ContentOrderreportsListtransactions_594888,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreturnsList_594906 = ref object of OpenApiRestCall_593421
proc url_ContentOrderreturnsList_594908(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrderreturnsList_594907(path: JsonNode; query: JsonNode;
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
  var valid_594909 = path.getOrDefault("merchantId")
  valid_594909 = validateParameter(valid_594909, JString, required = true,
                                 default = nil)
  if valid_594909 != nil:
    section.add "merchantId", valid_594909
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
  var valid_594910 = query.getOrDefault("fields")
  valid_594910 = validateParameter(valid_594910, JString, required = false,
                                 default = nil)
  if valid_594910 != nil:
    section.add "fields", valid_594910
  var valid_594911 = query.getOrDefault("pageToken")
  valid_594911 = validateParameter(valid_594911, JString, required = false,
                                 default = nil)
  if valid_594911 != nil:
    section.add "pageToken", valid_594911
  var valid_594912 = query.getOrDefault("quotaUser")
  valid_594912 = validateParameter(valid_594912, JString, required = false,
                                 default = nil)
  if valid_594912 != nil:
    section.add "quotaUser", valid_594912
  var valid_594913 = query.getOrDefault("alt")
  valid_594913 = validateParameter(valid_594913, JString, required = false,
                                 default = newJString("json"))
  if valid_594913 != nil:
    section.add "alt", valid_594913
  var valid_594914 = query.getOrDefault("oauth_token")
  valid_594914 = validateParameter(valid_594914, JString, required = false,
                                 default = nil)
  if valid_594914 != nil:
    section.add "oauth_token", valid_594914
  var valid_594915 = query.getOrDefault("userIp")
  valid_594915 = validateParameter(valid_594915, JString, required = false,
                                 default = nil)
  if valid_594915 != nil:
    section.add "userIp", valid_594915
  var valid_594916 = query.getOrDefault("maxResults")
  valid_594916 = validateParameter(valid_594916, JInt, required = false, default = nil)
  if valid_594916 != nil:
    section.add "maxResults", valid_594916
  var valid_594917 = query.getOrDefault("orderBy")
  valid_594917 = validateParameter(valid_594917, JString, required = false,
                                 default = newJString("returnCreationTimeAsc"))
  if valid_594917 != nil:
    section.add "orderBy", valid_594917
  var valid_594918 = query.getOrDefault("key")
  valid_594918 = validateParameter(valid_594918, JString, required = false,
                                 default = nil)
  if valid_594918 != nil:
    section.add "key", valid_594918
  var valid_594919 = query.getOrDefault("createdEndDate")
  valid_594919 = validateParameter(valid_594919, JString, required = false,
                                 default = nil)
  if valid_594919 != nil:
    section.add "createdEndDate", valid_594919
  var valid_594920 = query.getOrDefault("prettyPrint")
  valid_594920 = validateParameter(valid_594920, JBool, required = false,
                                 default = newJBool(true))
  if valid_594920 != nil:
    section.add "prettyPrint", valid_594920
  var valid_594921 = query.getOrDefault("createdStartDate")
  valid_594921 = validateParameter(valid_594921, JString, required = false,
                                 default = nil)
  if valid_594921 != nil:
    section.add "createdStartDate", valid_594921
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594922: Call_ContentOrderreturnsList_594906; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists order returns in your Merchant Center account.
  ## 
  let valid = call_594922.validator(path, query, header, formData, body)
  let scheme = call_594922.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594922.url(scheme.get, call_594922.host, call_594922.base,
                         call_594922.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594922, url, valid)

proc call*(call_594923: Call_ContentOrderreturnsList_594906; merchantId: string;
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
  var path_594924 = newJObject()
  var query_594925 = newJObject()
  add(query_594925, "fields", newJString(fields))
  add(query_594925, "pageToken", newJString(pageToken))
  add(query_594925, "quotaUser", newJString(quotaUser))
  add(query_594925, "alt", newJString(alt))
  add(query_594925, "oauth_token", newJString(oauthToken))
  add(query_594925, "userIp", newJString(userIp))
  add(query_594925, "maxResults", newJInt(maxResults))
  add(query_594925, "orderBy", newJString(orderBy))
  add(query_594925, "key", newJString(key))
  add(query_594925, "createdEndDate", newJString(createdEndDate))
  add(path_594924, "merchantId", newJString(merchantId))
  add(query_594925, "prettyPrint", newJBool(prettyPrint))
  add(query_594925, "createdStartDate", newJString(createdStartDate))
  result = call_594923.call(path_594924, query_594925, nil, nil, nil)

var contentOrderreturnsList* = Call_ContentOrderreturnsList_594906(
    name: "contentOrderreturnsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreturns",
    validator: validate_ContentOrderreturnsList_594907, base: "/content/v2",
    url: url_ContentOrderreturnsList_594908, schemes: {Scheme.Https})
type
  Call_ContentOrderreturnsGet_594926 = ref object of OpenApiRestCall_593421
proc url_ContentOrderreturnsGet_594928(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrderreturnsGet_594927(path: JsonNode; query: JsonNode;
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
  var valid_594929 = path.getOrDefault("returnId")
  valid_594929 = validateParameter(valid_594929, JString, required = true,
                                 default = nil)
  if valid_594929 != nil:
    section.add "returnId", valid_594929
  var valid_594930 = path.getOrDefault("merchantId")
  valid_594930 = validateParameter(valid_594930, JString, required = true,
                                 default = nil)
  if valid_594930 != nil:
    section.add "merchantId", valid_594930
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
  var valid_594931 = query.getOrDefault("fields")
  valid_594931 = validateParameter(valid_594931, JString, required = false,
                                 default = nil)
  if valid_594931 != nil:
    section.add "fields", valid_594931
  var valid_594932 = query.getOrDefault("quotaUser")
  valid_594932 = validateParameter(valid_594932, JString, required = false,
                                 default = nil)
  if valid_594932 != nil:
    section.add "quotaUser", valid_594932
  var valid_594933 = query.getOrDefault("alt")
  valid_594933 = validateParameter(valid_594933, JString, required = false,
                                 default = newJString("json"))
  if valid_594933 != nil:
    section.add "alt", valid_594933
  var valid_594934 = query.getOrDefault("oauth_token")
  valid_594934 = validateParameter(valid_594934, JString, required = false,
                                 default = nil)
  if valid_594934 != nil:
    section.add "oauth_token", valid_594934
  var valid_594935 = query.getOrDefault("userIp")
  valid_594935 = validateParameter(valid_594935, JString, required = false,
                                 default = nil)
  if valid_594935 != nil:
    section.add "userIp", valid_594935
  var valid_594936 = query.getOrDefault("key")
  valid_594936 = validateParameter(valid_594936, JString, required = false,
                                 default = nil)
  if valid_594936 != nil:
    section.add "key", valid_594936
  var valid_594937 = query.getOrDefault("prettyPrint")
  valid_594937 = validateParameter(valid_594937, JBool, required = false,
                                 default = newJBool(true))
  if valid_594937 != nil:
    section.add "prettyPrint", valid_594937
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594938: Call_ContentOrderreturnsGet_594926; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an order return from your Merchant Center account.
  ## 
  let valid = call_594938.validator(path, query, header, formData, body)
  let scheme = call_594938.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594938.url(scheme.get, call_594938.host, call_594938.base,
                         call_594938.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594938, url, valid)

proc call*(call_594939: Call_ContentOrderreturnsGet_594926; returnId: string;
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
  var path_594940 = newJObject()
  var query_594941 = newJObject()
  add(query_594941, "fields", newJString(fields))
  add(query_594941, "quotaUser", newJString(quotaUser))
  add(path_594940, "returnId", newJString(returnId))
  add(query_594941, "alt", newJString(alt))
  add(query_594941, "oauth_token", newJString(oauthToken))
  add(query_594941, "userIp", newJString(userIp))
  add(query_594941, "key", newJString(key))
  add(path_594940, "merchantId", newJString(merchantId))
  add(query_594941, "prettyPrint", newJBool(prettyPrint))
  result = call_594939.call(path_594940, query_594941, nil, nil, nil)

var contentOrderreturnsGet* = Call_ContentOrderreturnsGet_594926(
    name: "contentOrderreturnsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreturns/{returnId}",
    validator: validate_ContentOrderreturnsGet_594927, base: "/content/v2",
    url: url_ContentOrderreturnsGet_594928, schemes: {Scheme.Https})
type
  Call_ContentOrdersList_594942 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersList_594944(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrdersList_594943(path: JsonNode; query: JsonNode;
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
  var valid_594945 = path.getOrDefault("merchantId")
  valid_594945 = validateParameter(valid_594945, JString, required = true,
                                 default = nil)
  if valid_594945 != nil:
    section.add "merchantId", valid_594945
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
  var valid_594946 = query.getOrDefault("fields")
  valid_594946 = validateParameter(valid_594946, JString, required = false,
                                 default = nil)
  if valid_594946 != nil:
    section.add "fields", valid_594946
  var valid_594947 = query.getOrDefault("pageToken")
  valid_594947 = validateParameter(valid_594947, JString, required = false,
                                 default = nil)
  if valid_594947 != nil:
    section.add "pageToken", valid_594947
  var valid_594948 = query.getOrDefault("quotaUser")
  valid_594948 = validateParameter(valid_594948, JString, required = false,
                                 default = nil)
  if valid_594948 != nil:
    section.add "quotaUser", valid_594948
  var valid_594949 = query.getOrDefault("alt")
  valid_594949 = validateParameter(valid_594949, JString, required = false,
                                 default = newJString("json"))
  if valid_594949 != nil:
    section.add "alt", valid_594949
  var valid_594950 = query.getOrDefault("placedDateStart")
  valid_594950 = validateParameter(valid_594950, JString, required = false,
                                 default = nil)
  if valid_594950 != nil:
    section.add "placedDateStart", valid_594950
  var valid_594951 = query.getOrDefault("oauth_token")
  valid_594951 = validateParameter(valid_594951, JString, required = false,
                                 default = nil)
  if valid_594951 != nil:
    section.add "oauth_token", valid_594951
  var valid_594952 = query.getOrDefault("userIp")
  valid_594952 = validateParameter(valid_594952, JString, required = false,
                                 default = nil)
  if valid_594952 != nil:
    section.add "userIp", valid_594952
  var valid_594953 = query.getOrDefault("maxResults")
  valid_594953 = validateParameter(valid_594953, JInt, required = false, default = nil)
  if valid_594953 != nil:
    section.add "maxResults", valid_594953
  var valid_594954 = query.getOrDefault("orderBy")
  valid_594954 = validateParameter(valid_594954, JString, required = false,
                                 default = nil)
  if valid_594954 != nil:
    section.add "orderBy", valid_594954
  var valid_594955 = query.getOrDefault("placedDateEnd")
  valid_594955 = validateParameter(valid_594955, JString, required = false,
                                 default = nil)
  if valid_594955 != nil:
    section.add "placedDateEnd", valid_594955
  var valid_594956 = query.getOrDefault("key")
  valid_594956 = validateParameter(valid_594956, JString, required = false,
                                 default = nil)
  if valid_594956 != nil:
    section.add "key", valid_594956
  var valid_594957 = query.getOrDefault("acknowledged")
  valid_594957 = validateParameter(valid_594957, JBool, required = false, default = nil)
  if valid_594957 != nil:
    section.add "acknowledged", valid_594957
  var valid_594958 = query.getOrDefault("prettyPrint")
  valid_594958 = validateParameter(valid_594958, JBool, required = false,
                                 default = newJBool(true))
  if valid_594958 != nil:
    section.add "prettyPrint", valid_594958
  var valid_594959 = query.getOrDefault("statuses")
  valid_594959 = validateParameter(valid_594959, JArray, required = false,
                                 default = nil)
  if valid_594959 != nil:
    section.add "statuses", valid_594959
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594960: Call_ContentOrdersList_594942; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the orders in your Merchant Center account.
  ## 
  let valid = call_594960.validator(path, query, header, formData, body)
  let scheme = call_594960.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594960.url(scheme.get, call_594960.host, call_594960.base,
                         call_594960.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594960, url, valid)

proc call*(call_594961: Call_ContentOrdersList_594942; merchantId: string;
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
  var path_594962 = newJObject()
  var query_594963 = newJObject()
  add(query_594963, "fields", newJString(fields))
  add(query_594963, "pageToken", newJString(pageToken))
  add(query_594963, "quotaUser", newJString(quotaUser))
  add(query_594963, "alt", newJString(alt))
  add(query_594963, "placedDateStart", newJString(placedDateStart))
  add(query_594963, "oauth_token", newJString(oauthToken))
  add(query_594963, "userIp", newJString(userIp))
  add(query_594963, "maxResults", newJInt(maxResults))
  add(query_594963, "orderBy", newJString(orderBy))
  add(query_594963, "placedDateEnd", newJString(placedDateEnd))
  add(query_594963, "key", newJString(key))
  add(path_594962, "merchantId", newJString(merchantId))
  add(query_594963, "acknowledged", newJBool(acknowledged))
  add(query_594963, "prettyPrint", newJBool(prettyPrint))
  if statuses != nil:
    query_594963.add "statuses", statuses
  result = call_594961.call(path_594962, query_594963, nil, nil, nil)

var contentOrdersList* = Call_ContentOrdersList_594942(name: "contentOrdersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/orders", validator: validate_ContentOrdersList_594943,
    base: "/content/v2", url: url_ContentOrdersList_594944, schemes: {Scheme.Https})
type
  Call_ContentOrdersGet_594964 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersGet_594966(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrdersGet_594965(path: JsonNode; query: JsonNode;
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
  var valid_594967 = path.getOrDefault("orderId")
  valid_594967 = validateParameter(valid_594967, JString, required = true,
                                 default = nil)
  if valid_594967 != nil:
    section.add "orderId", valid_594967
  var valid_594968 = path.getOrDefault("merchantId")
  valid_594968 = validateParameter(valid_594968, JString, required = true,
                                 default = nil)
  if valid_594968 != nil:
    section.add "merchantId", valid_594968
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
  var valid_594969 = query.getOrDefault("fields")
  valid_594969 = validateParameter(valid_594969, JString, required = false,
                                 default = nil)
  if valid_594969 != nil:
    section.add "fields", valid_594969
  var valid_594970 = query.getOrDefault("quotaUser")
  valid_594970 = validateParameter(valid_594970, JString, required = false,
                                 default = nil)
  if valid_594970 != nil:
    section.add "quotaUser", valid_594970
  var valid_594971 = query.getOrDefault("alt")
  valid_594971 = validateParameter(valid_594971, JString, required = false,
                                 default = newJString("json"))
  if valid_594971 != nil:
    section.add "alt", valid_594971
  var valid_594972 = query.getOrDefault("oauth_token")
  valid_594972 = validateParameter(valid_594972, JString, required = false,
                                 default = nil)
  if valid_594972 != nil:
    section.add "oauth_token", valid_594972
  var valid_594973 = query.getOrDefault("userIp")
  valid_594973 = validateParameter(valid_594973, JString, required = false,
                                 default = nil)
  if valid_594973 != nil:
    section.add "userIp", valid_594973
  var valid_594974 = query.getOrDefault("key")
  valid_594974 = validateParameter(valid_594974, JString, required = false,
                                 default = nil)
  if valid_594974 != nil:
    section.add "key", valid_594974
  var valid_594975 = query.getOrDefault("prettyPrint")
  valid_594975 = validateParameter(valid_594975, JBool, required = false,
                                 default = newJBool(true))
  if valid_594975 != nil:
    section.add "prettyPrint", valid_594975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594976: Call_ContentOrdersGet_594964; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an order from your Merchant Center account.
  ## 
  let valid = call_594976.validator(path, query, header, formData, body)
  let scheme = call_594976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594976.url(scheme.get, call_594976.host, call_594976.base,
                         call_594976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594976, url, valid)

proc call*(call_594977: Call_ContentOrdersGet_594964; orderId: string;
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
  var path_594978 = newJObject()
  var query_594979 = newJObject()
  add(query_594979, "fields", newJString(fields))
  add(query_594979, "quotaUser", newJString(quotaUser))
  add(query_594979, "alt", newJString(alt))
  add(query_594979, "oauth_token", newJString(oauthToken))
  add(query_594979, "userIp", newJString(userIp))
  add(path_594978, "orderId", newJString(orderId))
  add(query_594979, "key", newJString(key))
  add(path_594978, "merchantId", newJString(merchantId))
  add(query_594979, "prettyPrint", newJBool(prettyPrint))
  result = call_594977.call(path_594978, query_594979, nil, nil, nil)

var contentOrdersGet* = Call_ContentOrdersGet_594964(name: "contentOrdersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}", validator: validate_ContentOrdersGet_594965,
    base: "/content/v2", url: url_ContentOrdersGet_594966, schemes: {Scheme.Https})
type
  Call_ContentOrdersAcknowledge_594980 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersAcknowledge_594982(protocol: Scheme; host: string;
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

proc validate_ContentOrdersAcknowledge_594981(path: JsonNode; query: JsonNode;
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
  var valid_594983 = path.getOrDefault("orderId")
  valid_594983 = validateParameter(valid_594983, JString, required = true,
                                 default = nil)
  if valid_594983 != nil:
    section.add "orderId", valid_594983
  var valid_594984 = path.getOrDefault("merchantId")
  valid_594984 = validateParameter(valid_594984, JString, required = true,
                                 default = nil)
  if valid_594984 != nil:
    section.add "merchantId", valid_594984
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
  var valid_594985 = query.getOrDefault("fields")
  valid_594985 = validateParameter(valid_594985, JString, required = false,
                                 default = nil)
  if valid_594985 != nil:
    section.add "fields", valid_594985
  var valid_594986 = query.getOrDefault("quotaUser")
  valid_594986 = validateParameter(valid_594986, JString, required = false,
                                 default = nil)
  if valid_594986 != nil:
    section.add "quotaUser", valid_594986
  var valid_594987 = query.getOrDefault("alt")
  valid_594987 = validateParameter(valid_594987, JString, required = false,
                                 default = newJString("json"))
  if valid_594987 != nil:
    section.add "alt", valid_594987
  var valid_594988 = query.getOrDefault("oauth_token")
  valid_594988 = validateParameter(valid_594988, JString, required = false,
                                 default = nil)
  if valid_594988 != nil:
    section.add "oauth_token", valid_594988
  var valid_594989 = query.getOrDefault("userIp")
  valid_594989 = validateParameter(valid_594989, JString, required = false,
                                 default = nil)
  if valid_594989 != nil:
    section.add "userIp", valid_594989
  var valid_594990 = query.getOrDefault("key")
  valid_594990 = validateParameter(valid_594990, JString, required = false,
                                 default = nil)
  if valid_594990 != nil:
    section.add "key", valid_594990
  var valid_594991 = query.getOrDefault("prettyPrint")
  valid_594991 = validateParameter(valid_594991, JBool, required = false,
                                 default = newJBool(true))
  if valid_594991 != nil:
    section.add "prettyPrint", valid_594991
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

proc call*(call_594993: Call_ContentOrdersAcknowledge_594980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks an order as acknowledged.
  ## 
  let valid = call_594993.validator(path, query, header, formData, body)
  let scheme = call_594993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594993.url(scheme.get, call_594993.host, call_594993.base,
                         call_594993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594993, url, valid)

proc call*(call_594994: Call_ContentOrdersAcknowledge_594980; orderId: string;
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
  var path_594995 = newJObject()
  var query_594996 = newJObject()
  var body_594997 = newJObject()
  add(query_594996, "fields", newJString(fields))
  add(query_594996, "quotaUser", newJString(quotaUser))
  add(query_594996, "alt", newJString(alt))
  add(query_594996, "oauth_token", newJString(oauthToken))
  add(query_594996, "userIp", newJString(userIp))
  add(path_594995, "orderId", newJString(orderId))
  add(query_594996, "key", newJString(key))
  add(path_594995, "merchantId", newJString(merchantId))
  if body != nil:
    body_594997 = body
  add(query_594996, "prettyPrint", newJBool(prettyPrint))
  result = call_594994.call(path_594995, query_594996, nil, nil, body_594997)

var contentOrdersAcknowledge* = Call_ContentOrdersAcknowledge_594980(
    name: "contentOrdersAcknowledge", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/acknowledge",
    validator: validate_ContentOrdersAcknowledge_594981, base: "/content/v2",
    url: url_ContentOrdersAcknowledge_594982, schemes: {Scheme.Https})
type
  Call_ContentOrdersCancel_594998 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersCancel_595000(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrdersCancel_594999(path: JsonNode; query: JsonNode;
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
  var valid_595001 = path.getOrDefault("orderId")
  valid_595001 = validateParameter(valid_595001, JString, required = true,
                                 default = nil)
  if valid_595001 != nil:
    section.add "orderId", valid_595001
  var valid_595002 = path.getOrDefault("merchantId")
  valid_595002 = validateParameter(valid_595002, JString, required = true,
                                 default = nil)
  if valid_595002 != nil:
    section.add "merchantId", valid_595002
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
  var valid_595003 = query.getOrDefault("fields")
  valid_595003 = validateParameter(valid_595003, JString, required = false,
                                 default = nil)
  if valid_595003 != nil:
    section.add "fields", valid_595003
  var valid_595004 = query.getOrDefault("quotaUser")
  valid_595004 = validateParameter(valid_595004, JString, required = false,
                                 default = nil)
  if valid_595004 != nil:
    section.add "quotaUser", valid_595004
  var valid_595005 = query.getOrDefault("alt")
  valid_595005 = validateParameter(valid_595005, JString, required = false,
                                 default = newJString("json"))
  if valid_595005 != nil:
    section.add "alt", valid_595005
  var valid_595006 = query.getOrDefault("oauth_token")
  valid_595006 = validateParameter(valid_595006, JString, required = false,
                                 default = nil)
  if valid_595006 != nil:
    section.add "oauth_token", valid_595006
  var valid_595007 = query.getOrDefault("userIp")
  valid_595007 = validateParameter(valid_595007, JString, required = false,
                                 default = nil)
  if valid_595007 != nil:
    section.add "userIp", valid_595007
  var valid_595008 = query.getOrDefault("key")
  valid_595008 = validateParameter(valid_595008, JString, required = false,
                                 default = nil)
  if valid_595008 != nil:
    section.add "key", valid_595008
  var valid_595009 = query.getOrDefault("prettyPrint")
  valid_595009 = validateParameter(valid_595009, JBool, required = false,
                                 default = newJBool(true))
  if valid_595009 != nil:
    section.add "prettyPrint", valid_595009
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

proc call*(call_595011: Call_ContentOrdersCancel_594998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels all line items in an order, making a full refund.
  ## 
  let valid = call_595011.validator(path, query, header, formData, body)
  let scheme = call_595011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595011.url(scheme.get, call_595011.host, call_595011.base,
                         call_595011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595011, url, valid)

proc call*(call_595012: Call_ContentOrdersCancel_594998; orderId: string;
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
  var path_595013 = newJObject()
  var query_595014 = newJObject()
  var body_595015 = newJObject()
  add(query_595014, "fields", newJString(fields))
  add(query_595014, "quotaUser", newJString(quotaUser))
  add(query_595014, "alt", newJString(alt))
  add(query_595014, "oauth_token", newJString(oauthToken))
  add(query_595014, "userIp", newJString(userIp))
  add(path_595013, "orderId", newJString(orderId))
  add(query_595014, "key", newJString(key))
  add(path_595013, "merchantId", newJString(merchantId))
  if body != nil:
    body_595015 = body
  add(query_595014, "prettyPrint", newJBool(prettyPrint))
  result = call_595012.call(path_595013, query_595014, nil, nil, body_595015)

var contentOrdersCancel* = Call_ContentOrdersCancel_594998(
    name: "contentOrdersCancel", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/orders/{orderId}/cancel",
    validator: validate_ContentOrdersCancel_594999, base: "/content/v2",
    url: url_ContentOrdersCancel_595000, schemes: {Scheme.Https})
type
  Call_ContentOrdersCancellineitem_595016 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersCancellineitem_595018(protocol: Scheme; host: string;
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

proc validate_ContentOrdersCancellineitem_595017(path: JsonNode; query: JsonNode;
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
  var valid_595019 = path.getOrDefault("orderId")
  valid_595019 = validateParameter(valid_595019, JString, required = true,
                                 default = nil)
  if valid_595019 != nil:
    section.add "orderId", valid_595019
  var valid_595020 = path.getOrDefault("merchantId")
  valid_595020 = validateParameter(valid_595020, JString, required = true,
                                 default = nil)
  if valid_595020 != nil:
    section.add "merchantId", valid_595020
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
  var valid_595021 = query.getOrDefault("fields")
  valid_595021 = validateParameter(valid_595021, JString, required = false,
                                 default = nil)
  if valid_595021 != nil:
    section.add "fields", valid_595021
  var valid_595022 = query.getOrDefault("quotaUser")
  valid_595022 = validateParameter(valid_595022, JString, required = false,
                                 default = nil)
  if valid_595022 != nil:
    section.add "quotaUser", valid_595022
  var valid_595023 = query.getOrDefault("alt")
  valid_595023 = validateParameter(valid_595023, JString, required = false,
                                 default = newJString("json"))
  if valid_595023 != nil:
    section.add "alt", valid_595023
  var valid_595024 = query.getOrDefault("oauth_token")
  valid_595024 = validateParameter(valid_595024, JString, required = false,
                                 default = nil)
  if valid_595024 != nil:
    section.add "oauth_token", valid_595024
  var valid_595025 = query.getOrDefault("userIp")
  valid_595025 = validateParameter(valid_595025, JString, required = false,
                                 default = nil)
  if valid_595025 != nil:
    section.add "userIp", valid_595025
  var valid_595026 = query.getOrDefault("key")
  valid_595026 = validateParameter(valid_595026, JString, required = false,
                                 default = nil)
  if valid_595026 != nil:
    section.add "key", valid_595026
  var valid_595027 = query.getOrDefault("prettyPrint")
  valid_595027 = validateParameter(valid_595027, JBool, required = false,
                                 default = newJBool(true))
  if valid_595027 != nil:
    section.add "prettyPrint", valid_595027
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

proc call*(call_595029: Call_ContentOrdersCancellineitem_595016; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a line item, making a full refund.
  ## 
  let valid = call_595029.validator(path, query, header, formData, body)
  let scheme = call_595029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595029.url(scheme.get, call_595029.host, call_595029.base,
                         call_595029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595029, url, valid)

proc call*(call_595030: Call_ContentOrdersCancellineitem_595016; orderId: string;
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
  var path_595031 = newJObject()
  var query_595032 = newJObject()
  var body_595033 = newJObject()
  add(query_595032, "fields", newJString(fields))
  add(query_595032, "quotaUser", newJString(quotaUser))
  add(query_595032, "alt", newJString(alt))
  add(query_595032, "oauth_token", newJString(oauthToken))
  add(query_595032, "userIp", newJString(userIp))
  add(path_595031, "orderId", newJString(orderId))
  add(query_595032, "key", newJString(key))
  add(path_595031, "merchantId", newJString(merchantId))
  if body != nil:
    body_595033 = body
  add(query_595032, "prettyPrint", newJBool(prettyPrint))
  result = call_595030.call(path_595031, query_595032, nil, nil, body_595033)

var contentOrdersCancellineitem* = Call_ContentOrdersCancellineitem_595016(
    name: "contentOrdersCancellineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/cancelLineItem",
    validator: validate_ContentOrdersCancellineitem_595017, base: "/content/v2",
    url: url_ContentOrdersCancellineitem_595018, schemes: {Scheme.Https})
type
  Call_ContentOrdersInstorerefundlineitem_595034 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersInstorerefundlineitem_595036(protocol: Scheme; host: string;
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

proc validate_ContentOrdersInstorerefundlineitem_595035(path: JsonNode;
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
  var valid_595037 = path.getOrDefault("orderId")
  valid_595037 = validateParameter(valid_595037, JString, required = true,
                                 default = nil)
  if valid_595037 != nil:
    section.add "orderId", valid_595037
  var valid_595038 = path.getOrDefault("merchantId")
  valid_595038 = validateParameter(valid_595038, JString, required = true,
                                 default = nil)
  if valid_595038 != nil:
    section.add "merchantId", valid_595038
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
  var valid_595039 = query.getOrDefault("fields")
  valid_595039 = validateParameter(valid_595039, JString, required = false,
                                 default = nil)
  if valid_595039 != nil:
    section.add "fields", valid_595039
  var valid_595040 = query.getOrDefault("quotaUser")
  valid_595040 = validateParameter(valid_595040, JString, required = false,
                                 default = nil)
  if valid_595040 != nil:
    section.add "quotaUser", valid_595040
  var valid_595041 = query.getOrDefault("alt")
  valid_595041 = validateParameter(valid_595041, JString, required = false,
                                 default = newJString("json"))
  if valid_595041 != nil:
    section.add "alt", valid_595041
  var valid_595042 = query.getOrDefault("oauth_token")
  valid_595042 = validateParameter(valid_595042, JString, required = false,
                                 default = nil)
  if valid_595042 != nil:
    section.add "oauth_token", valid_595042
  var valid_595043 = query.getOrDefault("userIp")
  valid_595043 = validateParameter(valid_595043, JString, required = false,
                                 default = nil)
  if valid_595043 != nil:
    section.add "userIp", valid_595043
  var valid_595044 = query.getOrDefault("key")
  valid_595044 = validateParameter(valid_595044, JString, required = false,
                                 default = nil)
  if valid_595044 != nil:
    section.add "key", valid_595044
  var valid_595045 = query.getOrDefault("prettyPrint")
  valid_595045 = validateParameter(valid_595045, JBool, required = false,
                                 default = newJBool(true))
  if valid_595045 != nil:
    section.add "prettyPrint", valid_595045
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

proc call*(call_595047: Call_ContentOrdersInstorerefundlineitem_595034;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deprecated. Notifies that item return and refund was handled directly by merchant outside of Google payments processing (e.g. cash refund done in store).
  ## Note: We recommend calling the returnrefundlineitem method to refund in-store returns. We will issue the refund directly to the customer. This helps to prevent possible differences arising between merchant and Google transaction records. We also recommend having the point of sale system communicate with Google to ensure that customers do not receive a double refund by first refunding via Google then via an in-store return.
  ## 
  let valid = call_595047.validator(path, query, header, formData, body)
  let scheme = call_595047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595047.url(scheme.get, call_595047.host, call_595047.base,
                         call_595047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595047, url, valid)

proc call*(call_595048: Call_ContentOrdersInstorerefundlineitem_595034;
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
  var path_595049 = newJObject()
  var query_595050 = newJObject()
  var body_595051 = newJObject()
  add(query_595050, "fields", newJString(fields))
  add(query_595050, "quotaUser", newJString(quotaUser))
  add(query_595050, "alt", newJString(alt))
  add(query_595050, "oauth_token", newJString(oauthToken))
  add(query_595050, "userIp", newJString(userIp))
  add(path_595049, "orderId", newJString(orderId))
  add(query_595050, "key", newJString(key))
  add(path_595049, "merchantId", newJString(merchantId))
  if body != nil:
    body_595051 = body
  add(query_595050, "prettyPrint", newJBool(prettyPrint))
  result = call_595048.call(path_595049, query_595050, nil, nil, body_595051)

var contentOrdersInstorerefundlineitem* = Call_ContentOrdersInstorerefundlineitem_595034(
    name: "contentOrdersInstorerefundlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/inStoreRefundLineItem",
    validator: validate_ContentOrdersInstorerefundlineitem_595035,
    base: "/content/v2", url: url_ContentOrdersInstorerefundlineitem_595036,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersRefund_595052 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersRefund_595054(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/refund")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersRefund_595053(path: JsonNode; query: JsonNode;
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
  var valid_595055 = path.getOrDefault("orderId")
  valid_595055 = validateParameter(valid_595055, JString, required = true,
                                 default = nil)
  if valid_595055 != nil:
    section.add "orderId", valid_595055
  var valid_595056 = path.getOrDefault("merchantId")
  valid_595056 = validateParameter(valid_595056, JString, required = true,
                                 default = nil)
  if valid_595056 != nil:
    section.add "merchantId", valid_595056
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
  var valid_595057 = query.getOrDefault("fields")
  valid_595057 = validateParameter(valid_595057, JString, required = false,
                                 default = nil)
  if valid_595057 != nil:
    section.add "fields", valid_595057
  var valid_595058 = query.getOrDefault("quotaUser")
  valid_595058 = validateParameter(valid_595058, JString, required = false,
                                 default = nil)
  if valid_595058 != nil:
    section.add "quotaUser", valid_595058
  var valid_595059 = query.getOrDefault("alt")
  valid_595059 = validateParameter(valid_595059, JString, required = false,
                                 default = newJString("json"))
  if valid_595059 != nil:
    section.add "alt", valid_595059
  var valid_595060 = query.getOrDefault("oauth_token")
  valid_595060 = validateParameter(valid_595060, JString, required = false,
                                 default = nil)
  if valid_595060 != nil:
    section.add "oauth_token", valid_595060
  var valid_595061 = query.getOrDefault("userIp")
  valid_595061 = validateParameter(valid_595061, JString, required = false,
                                 default = nil)
  if valid_595061 != nil:
    section.add "userIp", valid_595061
  var valid_595062 = query.getOrDefault("key")
  valid_595062 = validateParameter(valid_595062, JString, required = false,
                                 default = nil)
  if valid_595062 != nil:
    section.add "key", valid_595062
  var valid_595063 = query.getOrDefault("prettyPrint")
  valid_595063 = validateParameter(valid_595063, JBool, required = false,
                                 default = newJBool(true))
  if valid_595063 != nil:
    section.add "prettyPrint", valid_595063
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

proc call*(call_595065: Call_ContentOrdersRefund_595052; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated, please use returnRefundLineItem instead.
  ## 
  let valid = call_595065.validator(path, query, header, formData, body)
  let scheme = call_595065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595065.url(scheme.get, call_595065.host, call_595065.base,
                         call_595065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595065, url, valid)

proc call*(call_595066: Call_ContentOrdersRefund_595052; orderId: string;
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
  var path_595067 = newJObject()
  var query_595068 = newJObject()
  var body_595069 = newJObject()
  add(query_595068, "fields", newJString(fields))
  add(query_595068, "quotaUser", newJString(quotaUser))
  add(query_595068, "alt", newJString(alt))
  add(query_595068, "oauth_token", newJString(oauthToken))
  add(query_595068, "userIp", newJString(userIp))
  add(path_595067, "orderId", newJString(orderId))
  add(query_595068, "key", newJString(key))
  add(path_595067, "merchantId", newJString(merchantId))
  if body != nil:
    body_595069 = body
  add(query_595068, "prettyPrint", newJBool(prettyPrint))
  result = call_595066.call(path_595067, query_595068, nil, nil, body_595069)

var contentOrdersRefund* = Call_ContentOrdersRefund_595052(
    name: "contentOrdersRefund", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/orders/{orderId}/refund",
    validator: validate_ContentOrdersRefund_595053, base: "/content/v2",
    url: url_ContentOrdersRefund_595054, schemes: {Scheme.Https})
type
  Call_ContentOrdersRejectreturnlineitem_595070 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersRejectreturnlineitem_595072(protocol: Scheme; host: string;
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

proc validate_ContentOrdersRejectreturnlineitem_595071(path: JsonNode;
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
  var valid_595073 = path.getOrDefault("orderId")
  valid_595073 = validateParameter(valid_595073, JString, required = true,
                                 default = nil)
  if valid_595073 != nil:
    section.add "orderId", valid_595073
  var valid_595074 = path.getOrDefault("merchantId")
  valid_595074 = validateParameter(valid_595074, JString, required = true,
                                 default = nil)
  if valid_595074 != nil:
    section.add "merchantId", valid_595074
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
  var valid_595075 = query.getOrDefault("fields")
  valid_595075 = validateParameter(valid_595075, JString, required = false,
                                 default = nil)
  if valid_595075 != nil:
    section.add "fields", valid_595075
  var valid_595076 = query.getOrDefault("quotaUser")
  valid_595076 = validateParameter(valid_595076, JString, required = false,
                                 default = nil)
  if valid_595076 != nil:
    section.add "quotaUser", valid_595076
  var valid_595077 = query.getOrDefault("alt")
  valid_595077 = validateParameter(valid_595077, JString, required = false,
                                 default = newJString("json"))
  if valid_595077 != nil:
    section.add "alt", valid_595077
  var valid_595078 = query.getOrDefault("oauth_token")
  valid_595078 = validateParameter(valid_595078, JString, required = false,
                                 default = nil)
  if valid_595078 != nil:
    section.add "oauth_token", valid_595078
  var valid_595079 = query.getOrDefault("userIp")
  valid_595079 = validateParameter(valid_595079, JString, required = false,
                                 default = nil)
  if valid_595079 != nil:
    section.add "userIp", valid_595079
  var valid_595080 = query.getOrDefault("key")
  valid_595080 = validateParameter(valid_595080, JString, required = false,
                                 default = nil)
  if valid_595080 != nil:
    section.add "key", valid_595080
  var valid_595081 = query.getOrDefault("prettyPrint")
  valid_595081 = validateParameter(valid_595081, JBool, required = false,
                                 default = newJBool(true))
  if valid_595081 != nil:
    section.add "prettyPrint", valid_595081
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

proc call*(call_595083: Call_ContentOrdersRejectreturnlineitem_595070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rejects return on an line item.
  ## 
  let valid = call_595083.validator(path, query, header, formData, body)
  let scheme = call_595083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595083.url(scheme.get, call_595083.host, call_595083.base,
                         call_595083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595083, url, valid)

proc call*(call_595084: Call_ContentOrdersRejectreturnlineitem_595070;
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
  var path_595085 = newJObject()
  var query_595086 = newJObject()
  var body_595087 = newJObject()
  add(query_595086, "fields", newJString(fields))
  add(query_595086, "quotaUser", newJString(quotaUser))
  add(query_595086, "alt", newJString(alt))
  add(query_595086, "oauth_token", newJString(oauthToken))
  add(query_595086, "userIp", newJString(userIp))
  add(path_595085, "orderId", newJString(orderId))
  add(query_595086, "key", newJString(key))
  add(path_595085, "merchantId", newJString(merchantId))
  if body != nil:
    body_595087 = body
  add(query_595086, "prettyPrint", newJBool(prettyPrint))
  result = call_595084.call(path_595085, query_595086, nil, nil, body_595087)

var contentOrdersRejectreturnlineitem* = Call_ContentOrdersRejectreturnlineitem_595070(
    name: "contentOrdersRejectreturnlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/rejectReturnLineItem",
    validator: validate_ContentOrdersRejectreturnlineitem_595071,
    base: "/content/v2", url: url_ContentOrdersRejectreturnlineitem_595072,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersReturnlineitem_595088 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersReturnlineitem_595090(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/returnLineItem")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContentOrdersReturnlineitem_595089(path: JsonNode; query: JsonNode;
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
  var valid_595091 = path.getOrDefault("orderId")
  valid_595091 = validateParameter(valid_595091, JString, required = true,
                                 default = nil)
  if valid_595091 != nil:
    section.add "orderId", valid_595091
  var valid_595092 = path.getOrDefault("merchantId")
  valid_595092 = validateParameter(valid_595092, JString, required = true,
                                 default = nil)
  if valid_595092 != nil:
    section.add "merchantId", valid_595092
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
  var valid_595093 = query.getOrDefault("fields")
  valid_595093 = validateParameter(valid_595093, JString, required = false,
                                 default = nil)
  if valid_595093 != nil:
    section.add "fields", valid_595093
  var valid_595094 = query.getOrDefault("quotaUser")
  valid_595094 = validateParameter(valid_595094, JString, required = false,
                                 default = nil)
  if valid_595094 != nil:
    section.add "quotaUser", valid_595094
  var valid_595095 = query.getOrDefault("alt")
  valid_595095 = validateParameter(valid_595095, JString, required = false,
                                 default = newJString("json"))
  if valid_595095 != nil:
    section.add "alt", valid_595095
  var valid_595096 = query.getOrDefault("oauth_token")
  valid_595096 = validateParameter(valid_595096, JString, required = false,
                                 default = nil)
  if valid_595096 != nil:
    section.add "oauth_token", valid_595096
  var valid_595097 = query.getOrDefault("userIp")
  valid_595097 = validateParameter(valid_595097, JString, required = false,
                                 default = nil)
  if valid_595097 != nil:
    section.add "userIp", valid_595097
  var valid_595098 = query.getOrDefault("key")
  valid_595098 = validateParameter(valid_595098, JString, required = false,
                                 default = nil)
  if valid_595098 != nil:
    section.add "key", valid_595098
  var valid_595099 = query.getOrDefault("prettyPrint")
  valid_595099 = validateParameter(valid_595099, JBool, required = false,
                                 default = newJBool(true))
  if valid_595099 != nil:
    section.add "prettyPrint", valid_595099
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

proc call*(call_595101: Call_ContentOrdersReturnlineitem_595088; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a line item.
  ## 
  let valid = call_595101.validator(path, query, header, formData, body)
  let scheme = call_595101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595101.url(scheme.get, call_595101.host, call_595101.base,
                         call_595101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595101, url, valid)

proc call*(call_595102: Call_ContentOrdersReturnlineitem_595088; orderId: string;
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
  var path_595103 = newJObject()
  var query_595104 = newJObject()
  var body_595105 = newJObject()
  add(query_595104, "fields", newJString(fields))
  add(query_595104, "quotaUser", newJString(quotaUser))
  add(query_595104, "alt", newJString(alt))
  add(query_595104, "oauth_token", newJString(oauthToken))
  add(query_595104, "userIp", newJString(userIp))
  add(path_595103, "orderId", newJString(orderId))
  add(query_595104, "key", newJString(key))
  add(path_595103, "merchantId", newJString(merchantId))
  if body != nil:
    body_595105 = body
  add(query_595104, "prettyPrint", newJBool(prettyPrint))
  result = call_595102.call(path_595103, query_595104, nil, nil, body_595105)

var contentOrdersReturnlineitem* = Call_ContentOrdersReturnlineitem_595088(
    name: "contentOrdersReturnlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/returnLineItem",
    validator: validate_ContentOrdersReturnlineitem_595089, base: "/content/v2",
    url: url_ContentOrdersReturnlineitem_595090, schemes: {Scheme.Https})
type
  Call_ContentOrdersReturnrefundlineitem_595106 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersReturnrefundlineitem_595108(protocol: Scheme; host: string;
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

proc validate_ContentOrdersReturnrefundlineitem_595107(path: JsonNode;
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
  var valid_595109 = path.getOrDefault("orderId")
  valid_595109 = validateParameter(valid_595109, JString, required = true,
                                 default = nil)
  if valid_595109 != nil:
    section.add "orderId", valid_595109
  var valid_595110 = path.getOrDefault("merchantId")
  valid_595110 = validateParameter(valid_595110, JString, required = true,
                                 default = nil)
  if valid_595110 != nil:
    section.add "merchantId", valid_595110
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
  var valid_595111 = query.getOrDefault("fields")
  valid_595111 = validateParameter(valid_595111, JString, required = false,
                                 default = nil)
  if valid_595111 != nil:
    section.add "fields", valid_595111
  var valid_595112 = query.getOrDefault("quotaUser")
  valid_595112 = validateParameter(valid_595112, JString, required = false,
                                 default = nil)
  if valid_595112 != nil:
    section.add "quotaUser", valid_595112
  var valid_595113 = query.getOrDefault("alt")
  valid_595113 = validateParameter(valid_595113, JString, required = false,
                                 default = newJString("json"))
  if valid_595113 != nil:
    section.add "alt", valid_595113
  var valid_595114 = query.getOrDefault("oauth_token")
  valid_595114 = validateParameter(valid_595114, JString, required = false,
                                 default = nil)
  if valid_595114 != nil:
    section.add "oauth_token", valid_595114
  var valid_595115 = query.getOrDefault("userIp")
  valid_595115 = validateParameter(valid_595115, JString, required = false,
                                 default = nil)
  if valid_595115 != nil:
    section.add "userIp", valid_595115
  var valid_595116 = query.getOrDefault("key")
  valid_595116 = validateParameter(valid_595116, JString, required = false,
                                 default = nil)
  if valid_595116 != nil:
    section.add "key", valid_595116
  var valid_595117 = query.getOrDefault("prettyPrint")
  valid_595117 = validateParameter(valid_595117, JBool, required = false,
                                 default = newJBool(true))
  if valid_595117 != nil:
    section.add "prettyPrint", valid_595117
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

proc call*(call_595119: Call_ContentOrdersReturnrefundlineitem_595106;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns and refunds a line item. Note that this method can only be called on fully shipped orders.
  ## 
  let valid = call_595119.validator(path, query, header, formData, body)
  let scheme = call_595119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595119.url(scheme.get, call_595119.host, call_595119.base,
                         call_595119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595119, url, valid)

proc call*(call_595120: Call_ContentOrdersReturnrefundlineitem_595106;
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
  var path_595121 = newJObject()
  var query_595122 = newJObject()
  var body_595123 = newJObject()
  add(query_595122, "fields", newJString(fields))
  add(query_595122, "quotaUser", newJString(quotaUser))
  add(query_595122, "alt", newJString(alt))
  add(query_595122, "oauth_token", newJString(oauthToken))
  add(query_595122, "userIp", newJString(userIp))
  add(path_595121, "orderId", newJString(orderId))
  add(query_595122, "key", newJString(key))
  add(path_595121, "merchantId", newJString(merchantId))
  if body != nil:
    body_595123 = body
  add(query_595122, "prettyPrint", newJBool(prettyPrint))
  result = call_595120.call(path_595121, query_595122, nil, nil, body_595123)

var contentOrdersReturnrefundlineitem* = Call_ContentOrdersReturnrefundlineitem_595106(
    name: "contentOrdersReturnrefundlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/returnRefundLineItem",
    validator: validate_ContentOrdersReturnrefundlineitem_595107,
    base: "/content/v2", url: url_ContentOrdersReturnrefundlineitem_595108,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersSetlineitemmetadata_595124 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersSetlineitemmetadata_595126(protocol: Scheme; host: string;
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

proc validate_ContentOrdersSetlineitemmetadata_595125(path: JsonNode;
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
  var valid_595127 = path.getOrDefault("orderId")
  valid_595127 = validateParameter(valid_595127, JString, required = true,
                                 default = nil)
  if valid_595127 != nil:
    section.add "orderId", valid_595127
  var valid_595128 = path.getOrDefault("merchantId")
  valid_595128 = validateParameter(valid_595128, JString, required = true,
                                 default = nil)
  if valid_595128 != nil:
    section.add "merchantId", valid_595128
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
  var valid_595129 = query.getOrDefault("fields")
  valid_595129 = validateParameter(valid_595129, JString, required = false,
                                 default = nil)
  if valid_595129 != nil:
    section.add "fields", valid_595129
  var valid_595130 = query.getOrDefault("quotaUser")
  valid_595130 = validateParameter(valid_595130, JString, required = false,
                                 default = nil)
  if valid_595130 != nil:
    section.add "quotaUser", valid_595130
  var valid_595131 = query.getOrDefault("alt")
  valid_595131 = validateParameter(valid_595131, JString, required = false,
                                 default = newJString("json"))
  if valid_595131 != nil:
    section.add "alt", valid_595131
  var valid_595132 = query.getOrDefault("oauth_token")
  valid_595132 = validateParameter(valid_595132, JString, required = false,
                                 default = nil)
  if valid_595132 != nil:
    section.add "oauth_token", valid_595132
  var valid_595133 = query.getOrDefault("userIp")
  valid_595133 = validateParameter(valid_595133, JString, required = false,
                                 default = nil)
  if valid_595133 != nil:
    section.add "userIp", valid_595133
  var valid_595134 = query.getOrDefault("key")
  valid_595134 = validateParameter(valid_595134, JString, required = false,
                                 default = nil)
  if valid_595134 != nil:
    section.add "key", valid_595134
  var valid_595135 = query.getOrDefault("prettyPrint")
  valid_595135 = validateParameter(valid_595135, JBool, required = false,
                                 default = newJBool(true))
  if valid_595135 != nil:
    section.add "prettyPrint", valid_595135
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

proc call*(call_595137: Call_ContentOrdersSetlineitemmetadata_595124;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets (or overrides if it already exists) merchant provided annotations in the form of key-value pairs. A common use case would be to supply us with additional structured information about a line item that cannot be provided via other methods. Submitted key-value pairs can be retrieved as part of the orders resource.
  ## 
  let valid = call_595137.validator(path, query, header, formData, body)
  let scheme = call_595137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595137.url(scheme.get, call_595137.host, call_595137.base,
                         call_595137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595137, url, valid)

proc call*(call_595138: Call_ContentOrdersSetlineitemmetadata_595124;
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
  var path_595139 = newJObject()
  var query_595140 = newJObject()
  var body_595141 = newJObject()
  add(query_595140, "fields", newJString(fields))
  add(query_595140, "quotaUser", newJString(quotaUser))
  add(query_595140, "alt", newJString(alt))
  add(query_595140, "oauth_token", newJString(oauthToken))
  add(query_595140, "userIp", newJString(userIp))
  add(path_595139, "orderId", newJString(orderId))
  add(query_595140, "key", newJString(key))
  add(path_595139, "merchantId", newJString(merchantId))
  if body != nil:
    body_595141 = body
  add(query_595140, "prettyPrint", newJBool(prettyPrint))
  result = call_595138.call(path_595139, query_595140, nil, nil, body_595141)

var contentOrdersSetlineitemmetadata* = Call_ContentOrdersSetlineitemmetadata_595124(
    name: "contentOrdersSetlineitemmetadata", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/setLineItemMetadata",
    validator: validate_ContentOrdersSetlineitemmetadata_595125,
    base: "/content/v2", url: url_ContentOrdersSetlineitemmetadata_595126,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersShiplineitems_595142 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersShiplineitems_595144(protocol: Scheme; host: string;
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

proc validate_ContentOrdersShiplineitems_595143(path: JsonNode; query: JsonNode;
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
  var valid_595145 = path.getOrDefault("orderId")
  valid_595145 = validateParameter(valid_595145, JString, required = true,
                                 default = nil)
  if valid_595145 != nil:
    section.add "orderId", valid_595145
  var valid_595146 = path.getOrDefault("merchantId")
  valid_595146 = validateParameter(valid_595146, JString, required = true,
                                 default = nil)
  if valid_595146 != nil:
    section.add "merchantId", valid_595146
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
  var valid_595147 = query.getOrDefault("fields")
  valid_595147 = validateParameter(valid_595147, JString, required = false,
                                 default = nil)
  if valid_595147 != nil:
    section.add "fields", valid_595147
  var valid_595148 = query.getOrDefault("quotaUser")
  valid_595148 = validateParameter(valid_595148, JString, required = false,
                                 default = nil)
  if valid_595148 != nil:
    section.add "quotaUser", valid_595148
  var valid_595149 = query.getOrDefault("alt")
  valid_595149 = validateParameter(valid_595149, JString, required = false,
                                 default = newJString("json"))
  if valid_595149 != nil:
    section.add "alt", valid_595149
  var valid_595150 = query.getOrDefault("oauth_token")
  valid_595150 = validateParameter(valid_595150, JString, required = false,
                                 default = nil)
  if valid_595150 != nil:
    section.add "oauth_token", valid_595150
  var valid_595151 = query.getOrDefault("userIp")
  valid_595151 = validateParameter(valid_595151, JString, required = false,
                                 default = nil)
  if valid_595151 != nil:
    section.add "userIp", valid_595151
  var valid_595152 = query.getOrDefault("key")
  valid_595152 = validateParameter(valid_595152, JString, required = false,
                                 default = nil)
  if valid_595152 != nil:
    section.add "key", valid_595152
  var valid_595153 = query.getOrDefault("prettyPrint")
  valid_595153 = validateParameter(valid_595153, JBool, required = false,
                                 default = newJBool(true))
  if valid_595153 != nil:
    section.add "prettyPrint", valid_595153
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

proc call*(call_595155: Call_ContentOrdersShiplineitems_595142; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks line item(s) as shipped.
  ## 
  let valid = call_595155.validator(path, query, header, formData, body)
  let scheme = call_595155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595155.url(scheme.get, call_595155.host, call_595155.base,
                         call_595155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595155, url, valid)

proc call*(call_595156: Call_ContentOrdersShiplineitems_595142; orderId: string;
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
  var path_595157 = newJObject()
  var query_595158 = newJObject()
  var body_595159 = newJObject()
  add(query_595158, "fields", newJString(fields))
  add(query_595158, "quotaUser", newJString(quotaUser))
  add(query_595158, "alt", newJString(alt))
  add(query_595158, "oauth_token", newJString(oauthToken))
  add(query_595158, "userIp", newJString(userIp))
  add(path_595157, "orderId", newJString(orderId))
  add(query_595158, "key", newJString(key))
  add(path_595157, "merchantId", newJString(merchantId))
  if body != nil:
    body_595159 = body
  add(query_595158, "prettyPrint", newJBool(prettyPrint))
  result = call_595156.call(path_595157, query_595158, nil, nil, body_595159)

var contentOrdersShiplineitems* = Call_ContentOrdersShiplineitems_595142(
    name: "contentOrdersShiplineitems", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/shipLineItems",
    validator: validate_ContentOrdersShiplineitems_595143, base: "/content/v2",
    url: url_ContentOrdersShiplineitems_595144, schemes: {Scheme.Https})
type
  Call_ContentOrdersCreatetestreturn_595160 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersCreatetestreturn_595162(protocol: Scheme; host: string;
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

proc validate_ContentOrdersCreatetestreturn_595161(path: JsonNode; query: JsonNode;
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
  var valid_595163 = path.getOrDefault("orderId")
  valid_595163 = validateParameter(valid_595163, JString, required = true,
                                 default = nil)
  if valid_595163 != nil:
    section.add "orderId", valid_595163
  var valid_595164 = path.getOrDefault("merchantId")
  valid_595164 = validateParameter(valid_595164, JString, required = true,
                                 default = nil)
  if valid_595164 != nil:
    section.add "merchantId", valid_595164
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
  var valid_595165 = query.getOrDefault("fields")
  valid_595165 = validateParameter(valid_595165, JString, required = false,
                                 default = nil)
  if valid_595165 != nil:
    section.add "fields", valid_595165
  var valid_595166 = query.getOrDefault("quotaUser")
  valid_595166 = validateParameter(valid_595166, JString, required = false,
                                 default = nil)
  if valid_595166 != nil:
    section.add "quotaUser", valid_595166
  var valid_595167 = query.getOrDefault("alt")
  valid_595167 = validateParameter(valid_595167, JString, required = false,
                                 default = newJString("json"))
  if valid_595167 != nil:
    section.add "alt", valid_595167
  var valid_595168 = query.getOrDefault("oauth_token")
  valid_595168 = validateParameter(valid_595168, JString, required = false,
                                 default = nil)
  if valid_595168 != nil:
    section.add "oauth_token", valid_595168
  var valid_595169 = query.getOrDefault("userIp")
  valid_595169 = validateParameter(valid_595169, JString, required = false,
                                 default = nil)
  if valid_595169 != nil:
    section.add "userIp", valid_595169
  var valid_595170 = query.getOrDefault("key")
  valid_595170 = validateParameter(valid_595170, JString, required = false,
                                 default = nil)
  if valid_595170 != nil:
    section.add "key", valid_595170
  var valid_595171 = query.getOrDefault("prettyPrint")
  valid_595171 = validateParameter(valid_595171, JBool, required = false,
                                 default = newJBool(true))
  if valid_595171 != nil:
    section.add "prettyPrint", valid_595171
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

proc call*(call_595173: Call_ContentOrdersCreatetestreturn_595160; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Creates a test return.
  ## 
  let valid = call_595173.validator(path, query, header, formData, body)
  let scheme = call_595173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595173.url(scheme.get, call_595173.host, call_595173.base,
                         call_595173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595173, url, valid)

proc call*(call_595174: Call_ContentOrdersCreatetestreturn_595160; orderId: string;
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
  var path_595175 = newJObject()
  var query_595176 = newJObject()
  var body_595177 = newJObject()
  add(query_595176, "fields", newJString(fields))
  add(query_595176, "quotaUser", newJString(quotaUser))
  add(query_595176, "alt", newJString(alt))
  add(query_595176, "oauth_token", newJString(oauthToken))
  add(query_595176, "userIp", newJString(userIp))
  add(path_595175, "orderId", newJString(orderId))
  add(query_595176, "key", newJString(key))
  add(path_595175, "merchantId", newJString(merchantId))
  if body != nil:
    body_595177 = body
  add(query_595176, "prettyPrint", newJBool(prettyPrint))
  result = call_595174.call(path_595175, query_595176, nil, nil, body_595177)

var contentOrdersCreatetestreturn* = Call_ContentOrdersCreatetestreturn_595160(
    name: "contentOrdersCreatetestreturn", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/testreturn",
    validator: validate_ContentOrdersCreatetestreturn_595161, base: "/content/v2",
    url: url_ContentOrdersCreatetestreturn_595162, schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdatelineitemshippingdetails_595178 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersUpdatelineitemshippingdetails_595180(protocol: Scheme;
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

proc validate_ContentOrdersUpdatelineitemshippingdetails_595179(path: JsonNode;
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
  var valid_595181 = path.getOrDefault("orderId")
  valid_595181 = validateParameter(valid_595181, JString, required = true,
                                 default = nil)
  if valid_595181 != nil:
    section.add "orderId", valid_595181
  var valid_595182 = path.getOrDefault("merchantId")
  valid_595182 = validateParameter(valid_595182, JString, required = true,
                                 default = nil)
  if valid_595182 != nil:
    section.add "merchantId", valid_595182
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
  var valid_595183 = query.getOrDefault("fields")
  valid_595183 = validateParameter(valid_595183, JString, required = false,
                                 default = nil)
  if valid_595183 != nil:
    section.add "fields", valid_595183
  var valid_595184 = query.getOrDefault("quotaUser")
  valid_595184 = validateParameter(valid_595184, JString, required = false,
                                 default = nil)
  if valid_595184 != nil:
    section.add "quotaUser", valid_595184
  var valid_595185 = query.getOrDefault("alt")
  valid_595185 = validateParameter(valid_595185, JString, required = false,
                                 default = newJString("json"))
  if valid_595185 != nil:
    section.add "alt", valid_595185
  var valid_595186 = query.getOrDefault("oauth_token")
  valid_595186 = validateParameter(valid_595186, JString, required = false,
                                 default = nil)
  if valid_595186 != nil:
    section.add "oauth_token", valid_595186
  var valid_595187 = query.getOrDefault("userIp")
  valid_595187 = validateParameter(valid_595187, JString, required = false,
                                 default = nil)
  if valid_595187 != nil:
    section.add "userIp", valid_595187
  var valid_595188 = query.getOrDefault("key")
  valid_595188 = validateParameter(valid_595188, JString, required = false,
                                 default = nil)
  if valid_595188 != nil:
    section.add "key", valid_595188
  var valid_595189 = query.getOrDefault("prettyPrint")
  valid_595189 = validateParameter(valid_595189, JBool, required = false,
                                 default = newJBool(true))
  if valid_595189 != nil:
    section.add "prettyPrint", valid_595189
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

proc call*(call_595191: Call_ContentOrdersUpdatelineitemshippingdetails_595178;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates ship by and delivery by dates for a line item.
  ## 
  let valid = call_595191.validator(path, query, header, formData, body)
  let scheme = call_595191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595191.url(scheme.get, call_595191.host, call_595191.base,
                         call_595191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595191, url, valid)

proc call*(call_595192: Call_ContentOrdersUpdatelineitemshippingdetails_595178;
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
  var path_595193 = newJObject()
  var query_595194 = newJObject()
  var body_595195 = newJObject()
  add(query_595194, "fields", newJString(fields))
  add(query_595194, "quotaUser", newJString(quotaUser))
  add(query_595194, "alt", newJString(alt))
  add(query_595194, "oauth_token", newJString(oauthToken))
  add(query_595194, "userIp", newJString(userIp))
  add(path_595193, "orderId", newJString(orderId))
  add(query_595194, "key", newJString(key))
  add(path_595193, "merchantId", newJString(merchantId))
  if body != nil:
    body_595195 = body
  add(query_595194, "prettyPrint", newJBool(prettyPrint))
  result = call_595192.call(path_595193, query_595194, nil, nil, body_595195)

var contentOrdersUpdatelineitemshippingdetails* = Call_ContentOrdersUpdatelineitemshippingdetails_595178(
    name: "contentOrdersUpdatelineitemshippingdetails", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateLineItemShippingDetails",
    validator: validate_ContentOrdersUpdatelineitemshippingdetails_595179,
    base: "/content/v2", url: url_ContentOrdersUpdatelineitemshippingdetails_595180,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdatemerchantorderid_595196 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersUpdatemerchantorderid_595198(protocol: Scheme; host: string;
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

proc validate_ContentOrdersUpdatemerchantorderid_595197(path: JsonNode;
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
  var valid_595199 = path.getOrDefault("orderId")
  valid_595199 = validateParameter(valid_595199, JString, required = true,
                                 default = nil)
  if valid_595199 != nil:
    section.add "orderId", valid_595199
  var valid_595200 = path.getOrDefault("merchantId")
  valid_595200 = validateParameter(valid_595200, JString, required = true,
                                 default = nil)
  if valid_595200 != nil:
    section.add "merchantId", valid_595200
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
  var valid_595201 = query.getOrDefault("fields")
  valid_595201 = validateParameter(valid_595201, JString, required = false,
                                 default = nil)
  if valid_595201 != nil:
    section.add "fields", valid_595201
  var valid_595202 = query.getOrDefault("quotaUser")
  valid_595202 = validateParameter(valid_595202, JString, required = false,
                                 default = nil)
  if valid_595202 != nil:
    section.add "quotaUser", valid_595202
  var valid_595203 = query.getOrDefault("alt")
  valid_595203 = validateParameter(valid_595203, JString, required = false,
                                 default = newJString("json"))
  if valid_595203 != nil:
    section.add "alt", valid_595203
  var valid_595204 = query.getOrDefault("oauth_token")
  valid_595204 = validateParameter(valid_595204, JString, required = false,
                                 default = nil)
  if valid_595204 != nil:
    section.add "oauth_token", valid_595204
  var valid_595205 = query.getOrDefault("userIp")
  valid_595205 = validateParameter(valid_595205, JString, required = false,
                                 default = nil)
  if valid_595205 != nil:
    section.add "userIp", valid_595205
  var valid_595206 = query.getOrDefault("key")
  valid_595206 = validateParameter(valid_595206, JString, required = false,
                                 default = nil)
  if valid_595206 != nil:
    section.add "key", valid_595206
  var valid_595207 = query.getOrDefault("prettyPrint")
  valid_595207 = validateParameter(valid_595207, JBool, required = false,
                                 default = newJBool(true))
  if valid_595207 != nil:
    section.add "prettyPrint", valid_595207
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

proc call*(call_595209: Call_ContentOrdersUpdatemerchantorderid_595196;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the merchant order ID for a given order.
  ## 
  let valid = call_595209.validator(path, query, header, formData, body)
  let scheme = call_595209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595209.url(scheme.get, call_595209.host, call_595209.base,
                         call_595209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595209, url, valid)

proc call*(call_595210: Call_ContentOrdersUpdatemerchantorderid_595196;
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
  var path_595211 = newJObject()
  var query_595212 = newJObject()
  var body_595213 = newJObject()
  add(query_595212, "fields", newJString(fields))
  add(query_595212, "quotaUser", newJString(quotaUser))
  add(query_595212, "alt", newJString(alt))
  add(query_595212, "oauth_token", newJString(oauthToken))
  add(query_595212, "userIp", newJString(userIp))
  add(path_595211, "orderId", newJString(orderId))
  add(query_595212, "key", newJString(key))
  add(path_595211, "merchantId", newJString(merchantId))
  if body != nil:
    body_595213 = body
  add(query_595212, "prettyPrint", newJBool(prettyPrint))
  result = call_595210.call(path_595211, query_595212, nil, nil, body_595213)

var contentOrdersUpdatemerchantorderid* = Call_ContentOrdersUpdatemerchantorderid_595196(
    name: "contentOrdersUpdatemerchantorderid", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateMerchantOrderId",
    validator: validate_ContentOrdersUpdatemerchantorderid_595197,
    base: "/content/v2", url: url_ContentOrdersUpdatemerchantorderid_595198,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdateshipment_595214 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersUpdateshipment_595216(protocol: Scheme; host: string;
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

proc validate_ContentOrdersUpdateshipment_595215(path: JsonNode; query: JsonNode;
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
  var valid_595217 = path.getOrDefault("orderId")
  valid_595217 = validateParameter(valid_595217, JString, required = true,
                                 default = nil)
  if valid_595217 != nil:
    section.add "orderId", valid_595217
  var valid_595218 = path.getOrDefault("merchantId")
  valid_595218 = validateParameter(valid_595218, JString, required = true,
                                 default = nil)
  if valid_595218 != nil:
    section.add "merchantId", valid_595218
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

proc call*(call_595227: Call_ContentOrdersUpdateshipment_595214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a shipment's status, carrier, and/or tracking ID.
  ## 
  let valid = call_595227.validator(path, query, header, formData, body)
  let scheme = call_595227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595227.url(scheme.get, call_595227.host, call_595227.base,
                         call_595227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595227, url, valid)

proc call*(call_595228: Call_ContentOrdersUpdateshipment_595214; orderId: string;
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
  var path_595229 = newJObject()
  var query_595230 = newJObject()
  var body_595231 = newJObject()
  add(query_595230, "fields", newJString(fields))
  add(query_595230, "quotaUser", newJString(quotaUser))
  add(query_595230, "alt", newJString(alt))
  add(query_595230, "oauth_token", newJString(oauthToken))
  add(query_595230, "userIp", newJString(userIp))
  add(path_595229, "orderId", newJString(orderId))
  add(query_595230, "key", newJString(key))
  add(path_595229, "merchantId", newJString(merchantId))
  if body != nil:
    body_595231 = body
  add(query_595230, "prettyPrint", newJBool(prettyPrint))
  result = call_595228.call(path_595229, query_595230, nil, nil, body_595231)

var contentOrdersUpdateshipment* = Call_ContentOrdersUpdateshipment_595214(
    name: "contentOrdersUpdateshipment", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateShipment",
    validator: validate_ContentOrdersUpdateshipment_595215, base: "/content/v2",
    url: url_ContentOrdersUpdateshipment_595216, schemes: {Scheme.Https})
type
  Call_ContentOrdersGetbymerchantorderid_595232 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersGetbymerchantorderid_595234(protocol: Scheme; host: string;
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

proc validate_ContentOrdersGetbymerchantorderid_595233(path: JsonNode;
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
  var valid_595235 = path.getOrDefault("merchantOrderId")
  valid_595235 = validateParameter(valid_595235, JString, required = true,
                                 default = nil)
  if valid_595235 != nil:
    section.add "merchantOrderId", valid_595235
  var valid_595236 = path.getOrDefault("merchantId")
  valid_595236 = validateParameter(valid_595236, JString, required = true,
                                 default = nil)
  if valid_595236 != nil:
    section.add "merchantId", valid_595236
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
  var valid_595237 = query.getOrDefault("fields")
  valid_595237 = validateParameter(valid_595237, JString, required = false,
                                 default = nil)
  if valid_595237 != nil:
    section.add "fields", valid_595237
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
  var valid_595242 = query.getOrDefault("key")
  valid_595242 = validateParameter(valid_595242, JString, required = false,
                                 default = nil)
  if valid_595242 != nil:
    section.add "key", valid_595242
  var valid_595243 = query.getOrDefault("prettyPrint")
  valid_595243 = validateParameter(valid_595243, JBool, required = false,
                                 default = newJBool(true))
  if valid_595243 != nil:
    section.add "prettyPrint", valid_595243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595244: Call_ContentOrdersGetbymerchantorderid_595232;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves an order using merchant order ID.
  ## 
  let valid = call_595244.validator(path, query, header, formData, body)
  let scheme = call_595244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595244.url(scheme.get, call_595244.host, call_595244.base,
                         call_595244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595244, url, valid)

proc call*(call_595245: Call_ContentOrdersGetbymerchantorderid_595232;
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
  var path_595246 = newJObject()
  var query_595247 = newJObject()
  add(query_595247, "fields", newJString(fields))
  add(query_595247, "quotaUser", newJString(quotaUser))
  add(query_595247, "alt", newJString(alt))
  add(query_595247, "oauth_token", newJString(oauthToken))
  add(query_595247, "userIp", newJString(userIp))
  add(query_595247, "key", newJString(key))
  add(path_595246, "merchantOrderId", newJString(merchantOrderId))
  add(path_595246, "merchantId", newJString(merchantId))
  add(query_595247, "prettyPrint", newJBool(prettyPrint))
  result = call_595245.call(path_595246, query_595247, nil, nil, nil)

var contentOrdersGetbymerchantorderid* = Call_ContentOrdersGetbymerchantorderid_595232(
    name: "contentOrdersGetbymerchantorderid", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/ordersbymerchantid/{merchantOrderId}",
    validator: validate_ContentOrdersGetbymerchantorderid_595233,
    base: "/content/v2", url: url_ContentOrdersGetbymerchantorderid_595234,
    schemes: {Scheme.Https})
type
  Call_ContentPosInventory_595248 = ref object of OpenApiRestCall_593421
proc url_ContentPosInventory_595250(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosInventory_595249(path: JsonNode; query: JsonNode;
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
  var valid_595251 = path.getOrDefault("targetMerchantId")
  valid_595251 = validateParameter(valid_595251, JString, required = true,
                                 default = nil)
  if valid_595251 != nil:
    section.add "targetMerchantId", valid_595251
  var valid_595252 = path.getOrDefault("merchantId")
  valid_595252 = validateParameter(valid_595252, JString, required = true,
                                 default = nil)
  if valid_595252 != nil:
    section.add "merchantId", valid_595252
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
  var valid_595253 = query.getOrDefault("fields")
  valid_595253 = validateParameter(valid_595253, JString, required = false,
                                 default = nil)
  if valid_595253 != nil:
    section.add "fields", valid_595253
  var valid_595254 = query.getOrDefault("quotaUser")
  valid_595254 = validateParameter(valid_595254, JString, required = false,
                                 default = nil)
  if valid_595254 != nil:
    section.add "quotaUser", valid_595254
  var valid_595255 = query.getOrDefault("alt")
  valid_595255 = validateParameter(valid_595255, JString, required = false,
                                 default = newJString("json"))
  if valid_595255 != nil:
    section.add "alt", valid_595255
  var valid_595256 = query.getOrDefault("dryRun")
  valid_595256 = validateParameter(valid_595256, JBool, required = false, default = nil)
  if valid_595256 != nil:
    section.add "dryRun", valid_595256
  var valid_595257 = query.getOrDefault("oauth_token")
  valid_595257 = validateParameter(valid_595257, JString, required = false,
                                 default = nil)
  if valid_595257 != nil:
    section.add "oauth_token", valid_595257
  var valid_595258 = query.getOrDefault("userIp")
  valid_595258 = validateParameter(valid_595258, JString, required = false,
                                 default = nil)
  if valid_595258 != nil:
    section.add "userIp", valid_595258
  var valid_595259 = query.getOrDefault("key")
  valid_595259 = validateParameter(valid_595259, JString, required = false,
                                 default = nil)
  if valid_595259 != nil:
    section.add "key", valid_595259
  var valid_595260 = query.getOrDefault("prettyPrint")
  valid_595260 = validateParameter(valid_595260, JBool, required = false,
                                 default = newJBool(true))
  if valid_595260 != nil:
    section.add "prettyPrint", valid_595260
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

proc call*(call_595262: Call_ContentPosInventory_595248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit inventory for the given merchant.
  ## 
  let valid = call_595262.validator(path, query, header, formData, body)
  let scheme = call_595262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595262.url(scheme.get, call_595262.host, call_595262.base,
                         call_595262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595262, url, valid)

proc call*(call_595263: Call_ContentPosInventory_595248; targetMerchantId: string;
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
  var path_595264 = newJObject()
  var query_595265 = newJObject()
  var body_595266 = newJObject()
  add(query_595265, "fields", newJString(fields))
  add(query_595265, "quotaUser", newJString(quotaUser))
  add(query_595265, "alt", newJString(alt))
  add(query_595265, "dryRun", newJBool(dryRun))
  add(path_595264, "targetMerchantId", newJString(targetMerchantId))
  add(query_595265, "oauth_token", newJString(oauthToken))
  add(query_595265, "userIp", newJString(userIp))
  add(query_595265, "key", newJString(key))
  add(path_595264, "merchantId", newJString(merchantId))
  if body != nil:
    body_595266 = body
  add(query_595265, "prettyPrint", newJBool(prettyPrint))
  result = call_595263.call(path_595264, query_595265, nil, nil, body_595266)

var contentPosInventory* = Call_ContentPosInventory_595248(
    name: "contentPosInventory", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/inventory",
    validator: validate_ContentPosInventory_595249, base: "/content/v2",
    url: url_ContentPosInventory_595250, schemes: {Scheme.Https})
type
  Call_ContentPosSale_595267 = ref object of OpenApiRestCall_593421
proc url_ContentPosSale_595269(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosSale_595268(path: JsonNode; query: JsonNode;
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
  var valid_595270 = path.getOrDefault("targetMerchantId")
  valid_595270 = validateParameter(valid_595270, JString, required = true,
                                 default = nil)
  if valid_595270 != nil:
    section.add "targetMerchantId", valid_595270
  var valid_595271 = path.getOrDefault("merchantId")
  valid_595271 = validateParameter(valid_595271, JString, required = true,
                                 default = nil)
  if valid_595271 != nil:
    section.add "merchantId", valid_595271
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
  var valid_595272 = query.getOrDefault("fields")
  valid_595272 = validateParameter(valid_595272, JString, required = false,
                                 default = nil)
  if valid_595272 != nil:
    section.add "fields", valid_595272
  var valid_595273 = query.getOrDefault("quotaUser")
  valid_595273 = validateParameter(valid_595273, JString, required = false,
                                 default = nil)
  if valid_595273 != nil:
    section.add "quotaUser", valid_595273
  var valid_595274 = query.getOrDefault("alt")
  valid_595274 = validateParameter(valid_595274, JString, required = false,
                                 default = newJString("json"))
  if valid_595274 != nil:
    section.add "alt", valid_595274
  var valid_595275 = query.getOrDefault("dryRun")
  valid_595275 = validateParameter(valid_595275, JBool, required = false, default = nil)
  if valid_595275 != nil:
    section.add "dryRun", valid_595275
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
  var valid_595278 = query.getOrDefault("key")
  valid_595278 = validateParameter(valid_595278, JString, required = false,
                                 default = nil)
  if valid_595278 != nil:
    section.add "key", valid_595278
  var valid_595279 = query.getOrDefault("prettyPrint")
  valid_595279 = validateParameter(valid_595279, JBool, required = false,
                                 default = newJBool(true))
  if valid_595279 != nil:
    section.add "prettyPrint", valid_595279
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

proc call*(call_595281: Call_ContentPosSale_595267; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit a sale event for the given merchant.
  ## 
  let valid = call_595281.validator(path, query, header, formData, body)
  let scheme = call_595281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595281.url(scheme.get, call_595281.host, call_595281.base,
                         call_595281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595281, url, valid)

proc call*(call_595282: Call_ContentPosSale_595267; targetMerchantId: string;
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
  var path_595283 = newJObject()
  var query_595284 = newJObject()
  var body_595285 = newJObject()
  add(query_595284, "fields", newJString(fields))
  add(query_595284, "quotaUser", newJString(quotaUser))
  add(query_595284, "alt", newJString(alt))
  add(query_595284, "dryRun", newJBool(dryRun))
  add(path_595283, "targetMerchantId", newJString(targetMerchantId))
  add(query_595284, "oauth_token", newJString(oauthToken))
  add(query_595284, "userIp", newJString(userIp))
  add(query_595284, "key", newJString(key))
  add(path_595283, "merchantId", newJString(merchantId))
  if body != nil:
    body_595285 = body
  add(query_595284, "prettyPrint", newJBool(prettyPrint))
  result = call_595282.call(path_595283, query_595284, nil, nil, body_595285)

var contentPosSale* = Call_ContentPosSale_595267(name: "contentPosSale",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/sale",
    validator: validate_ContentPosSale_595268, base: "/content/v2",
    url: url_ContentPosSale_595269, schemes: {Scheme.Https})
type
  Call_ContentPosInsert_595302 = ref object of OpenApiRestCall_593421
proc url_ContentPosInsert_595304(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosInsert_595303(path: JsonNode; query: JsonNode;
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
  var valid_595305 = path.getOrDefault("targetMerchantId")
  valid_595305 = validateParameter(valid_595305, JString, required = true,
                                 default = nil)
  if valid_595305 != nil:
    section.add "targetMerchantId", valid_595305
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
  var valid_595310 = query.getOrDefault("dryRun")
  valid_595310 = validateParameter(valid_595310, JBool, required = false, default = nil)
  if valid_595310 != nil:
    section.add "dryRun", valid_595310
  var valid_595311 = query.getOrDefault("oauth_token")
  valid_595311 = validateParameter(valid_595311, JString, required = false,
                                 default = nil)
  if valid_595311 != nil:
    section.add "oauth_token", valid_595311
  var valid_595312 = query.getOrDefault("userIp")
  valid_595312 = validateParameter(valid_595312, JString, required = false,
                                 default = nil)
  if valid_595312 != nil:
    section.add "userIp", valid_595312
  var valid_595313 = query.getOrDefault("key")
  valid_595313 = validateParameter(valid_595313, JString, required = false,
                                 default = nil)
  if valid_595313 != nil:
    section.add "key", valid_595313
  var valid_595314 = query.getOrDefault("prettyPrint")
  valid_595314 = validateParameter(valid_595314, JBool, required = false,
                                 default = newJBool(true))
  if valid_595314 != nil:
    section.add "prettyPrint", valid_595314
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

proc call*(call_595316: Call_ContentPosInsert_595302; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a store for the given merchant.
  ## 
  let valid = call_595316.validator(path, query, header, formData, body)
  let scheme = call_595316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595316.url(scheme.get, call_595316.host, call_595316.base,
                         call_595316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595316, url, valid)

proc call*(call_595317: Call_ContentPosInsert_595302; targetMerchantId: string;
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
  var path_595318 = newJObject()
  var query_595319 = newJObject()
  var body_595320 = newJObject()
  add(query_595319, "fields", newJString(fields))
  add(query_595319, "quotaUser", newJString(quotaUser))
  add(query_595319, "alt", newJString(alt))
  add(query_595319, "dryRun", newJBool(dryRun))
  add(path_595318, "targetMerchantId", newJString(targetMerchantId))
  add(query_595319, "oauth_token", newJString(oauthToken))
  add(query_595319, "userIp", newJString(userIp))
  add(query_595319, "key", newJString(key))
  add(path_595318, "merchantId", newJString(merchantId))
  if body != nil:
    body_595320 = body
  add(query_595319, "prettyPrint", newJBool(prettyPrint))
  result = call_595317.call(path_595318, query_595319, nil, nil, body_595320)

var contentPosInsert* = Call_ContentPosInsert_595302(name: "contentPosInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store",
    validator: validate_ContentPosInsert_595303, base: "/content/v2",
    url: url_ContentPosInsert_595304, schemes: {Scheme.Https})
type
  Call_ContentPosList_595286 = ref object of OpenApiRestCall_593421
proc url_ContentPosList_595288(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosList_595287(path: JsonNode; query: JsonNode;
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
  var valid_595289 = path.getOrDefault("targetMerchantId")
  valid_595289 = validateParameter(valid_595289, JString, required = true,
                                 default = nil)
  if valid_595289 != nil:
    section.add "targetMerchantId", valid_595289
  var valid_595290 = path.getOrDefault("merchantId")
  valid_595290 = validateParameter(valid_595290, JString, required = true,
                                 default = nil)
  if valid_595290 != nil:
    section.add "merchantId", valid_595290
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
  var valid_595291 = query.getOrDefault("fields")
  valid_595291 = validateParameter(valid_595291, JString, required = false,
                                 default = nil)
  if valid_595291 != nil:
    section.add "fields", valid_595291
  var valid_595292 = query.getOrDefault("quotaUser")
  valid_595292 = validateParameter(valid_595292, JString, required = false,
                                 default = nil)
  if valid_595292 != nil:
    section.add "quotaUser", valid_595292
  var valid_595293 = query.getOrDefault("alt")
  valid_595293 = validateParameter(valid_595293, JString, required = false,
                                 default = newJString("json"))
  if valid_595293 != nil:
    section.add "alt", valid_595293
  var valid_595294 = query.getOrDefault("oauth_token")
  valid_595294 = validateParameter(valid_595294, JString, required = false,
                                 default = nil)
  if valid_595294 != nil:
    section.add "oauth_token", valid_595294
  var valid_595295 = query.getOrDefault("userIp")
  valid_595295 = validateParameter(valid_595295, JString, required = false,
                                 default = nil)
  if valid_595295 != nil:
    section.add "userIp", valid_595295
  var valid_595296 = query.getOrDefault("key")
  valid_595296 = validateParameter(valid_595296, JString, required = false,
                                 default = nil)
  if valid_595296 != nil:
    section.add "key", valid_595296
  var valid_595297 = query.getOrDefault("prettyPrint")
  valid_595297 = validateParameter(valid_595297, JBool, required = false,
                                 default = newJBool(true))
  if valid_595297 != nil:
    section.add "prettyPrint", valid_595297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595298: Call_ContentPosList_595286; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the stores of the target merchant.
  ## 
  let valid = call_595298.validator(path, query, header, formData, body)
  let scheme = call_595298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595298.url(scheme.get, call_595298.host, call_595298.base,
                         call_595298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595298, url, valid)

proc call*(call_595299: Call_ContentPosList_595286; targetMerchantId: string;
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
  var path_595300 = newJObject()
  var query_595301 = newJObject()
  add(query_595301, "fields", newJString(fields))
  add(query_595301, "quotaUser", newJString(quotaUser))
  add(query_595301, "alt", newJString(alt))
  add(path_595300, "targetMerchantId", newJString(targetMerchantId))
  add(query_595301, "oauth_token", newJString(oauthToken))
  add(query_595301, "userIp", newJString(userIp))
  add(query_595301, "key", newJString(key))
  add(path_595300, "merchantId", newJString(merchantId))
  add(query_595301, "prettyPrint", newJBool(prettyPrint))
  result = call_595299.call(path_595300, query_595301, nil, nil, nil)

var contentPosList* = Call_ContentPosList_595286(name: "contentPosList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store",
    validator: validate_ContentPosList_595287, base: "/content/v2",
    url: url_ContentPosList_595288, schemes: {Scheme.Https})
type
  Call_ContentPosGet_595321 = ref object of OpenApiRestCall_593421
proc url_ContentPosGet_595323(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosGet_595322(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_595324 = path.getOrDefault("targetMerchantId")
  valid_595324 = validateParameter(valid_595324, JString, required = true,
                                 default = nil)
  if valid_595324 != nil:
    section.add "targetMerchantId", valid_595324
  var valid_595325 = path.getOrDefault("storeCode")
  valid_595325 = validateParameter(valid_595325, JString, required = true,
                                 default = nil)
  if valid_595325 != nil:
    section.add "storeCode", valid_595325
  var valid_595326 = path.getOrDefault("merchantId")
  valid_595326 = validateParameter(valid_595326, JString, required = true,
                                 default = nil)
  if valid_595326 != nil:
    section.add "merchantId", valid_595326
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
  var valid_595327 = query.getOrDefault("fields")
  valid_595327 = validateParameter(valid_595327, JString, required = false,
                                 default = nil)
  if valid_595327 != nil:
    section.add "fields", valid_595327
  var valid_595328 = query.getOrDefault("quotaUser")
  valid_595328 = validateParameter(valid_595328, JString, required = false,
                                 default = nil)
  if valid_595328 != nil:
    section.add "quotaUser", valid_595328
  var valid_595329 = query.getOrDefault("alt")
  valid_595329 = validateParameter(valid_595329, JString, required = false,
                                 default = newJString("json"))
  if valid_595329 != nil:
    section.add "alt", valid_595329
  var valid_595330 = query.getOrDefault("oauth_token")
  valid_595330 = validateParameter(valid_595330, JString, required = false,
                                 default = nil)
  if valid_595330 != nil:
    section.add "oauth_token", valid_595330
  var valid_595331 = query.getOrDefault("userIp")
  valid_595331 = validateParameter(valid_595331, JString, required = false,
                                 default = nil)
  if valid_595331 != nil:
    section.add "userIp", valid_595331
  var valid_595332 = query.getOrDefault("key")
  valid_595332 = validateParameter(valid_595332, JString, required = false,
                                 default = nil)
  if valid_595332 != nil:
    section.add "key", valid_595332
  var valid_595333 = query.getOrDefault("prettyPrint")
  valid_595333 = validateParameter(valid_595333, JBool, required = false,
                                 default = newJBool(true))
  if valid_595333 != nil:
    section.add "prettyPrint", valid_595333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595334: Call_ContentPosGet_595321; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about the given store.
  ## 
  let valid = call_595334.validator(path, query, header, formData, body)
  let scheme = call_595334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595334.url(scheme.get, call_595334.host, call_595334.base,
                         call_595334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595334, url, valid)

proc call*(call_595335: Call_ContentPosGet_595321; targetMerchantId: string;
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
  var path_595336 = newJObject()
  var query_595337 = newJObject()
  add(query_595337, "fields", newJString(fields))
  add(query_595337, "quotaUser", newJString(quotaUser))
  add(query_595337, "alt", newJString(alt))
  add(path_595336, "targetMerchantId", newJString(targetMerchantId))
  add(query_595337, "oauth_token", newJString(oauthToken))
  add(path_595336, "storeCode", newJString(storeCode))
  add(query_595337, "userIp", newJString(userIp))
  add(query_595337, "key", newJString(key))
  add(path_595336, "merchantId", newJString(merchantId))
  add(query_595337, "prettyPrint", newJBool(prettyPrint))
  result = call_595335.call(path_595336, query_595337, nil, nil, nil)

var contentPosGet* = Call_ContentPosGet_595321(name: "contentPosGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store/{storeCode}",
    validator: validate_ContentPosGet_595322, base: "/content/v2",
    url: url_ContentPosGet_595323, schemes: {Scheme.Https})
type
  Call_ContentPosDelete_595338 = ref object of OpenApiRestCall_593421
proc url_ContentPosDelete_595340(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosDelete_595339(path: JsonNode; query: JsonNode;
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
  var valid_595341 = path.getOrDefault("targetMerchantId")
  valid_595341 = validateParameter(valid_595341, JString, required = true,
                                 default = nil)
  if valid_595341 != nil:
    section.add "targetMerchantId", valid_595341
  var valid_595342 = path.getOrDefault("storeCode")
  valid_595342 = validateParameter(valid_595342, JString, required = true,
                                 default = nil)
  if valid_595342 != nil:
    section.add "storeCode", valid_595342
  var valid_595343 = path.getOrDefault("merchantId")
  valid_595343 = validateParameter(valid_595343, JString, required = true,
                                 default = nil)
  if valid_595343 != nil:
    section.add "merchantId", valid_595343
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
  var valid_595344 = query.getOrDefault("fields")
  valid_595344 = validateParameter(valid_595344, JString, required = false,
                                 default = nil)
  if valid_595344 != nil:
    section.add "fields", valid_595344
  var valid_595345 = query.getOrDefault("quotaUser")
  valid_595345 = validateParameter(valid_595345, JString, required = false,
                                 default = nil)
  if valid_595345 != nil:
    section.add "quotaUser", valid_595345
  var valid_595346 = query.getOrDefault("alt")
  valid_595346 = validateParameter(valid_595346, JString, required = false,
                                 default = newJString("json"))
  if valid_595346 != nil:
    section.add "alt", valid_595346
  var valid_595347 = query.getOrDefault("dryRun")
  valid_595347 = validateParameter(valid_595347, JBool, required = false, default = nil)
  if valid_595347 != nil:
    section.add "dryRun", valid_595347
  var valid_595348 = query.getOrDefault("oauth_token")
  valid_595348 = validateParameter(valid_595348, JString, required = false,
                                 default = nil)
  if valid_595348 != nil:
    section.add "oauth_token", valid_595348
  var valid_595349 = query.getOrDefault("userIp")
  valid_595349 = validateParameter(valid_595349, JString, required = false,
                                 default = nil)
  if valid_595349 != nil:
    section.add "userIp", valid_595349
  var valid_595350 = query.getOrDefault("key")
  valid_595350 = validateParameter(valid_595350, JString, required = false,
                                 default = nil)
  if valid_595350 != nil:
    section.add "key", valid_595350
  var valid_595351 = query.getOrDefault("prettyPrint")
  valid_595351 = validateParameter(valid_595351, JBool, required = false,
                                 default = newJBool(true))
  if valid_595351 != nil:
    section.add "prettyPrint", valid_595351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595352: Call_ContentPosDelete_595338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a store for the given merchant.
  ## 
  let valid = call_595352.validator(path, query, header, formData, body)
  let scheme = call_595352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595352.url(scheme.get, call_595352.host, call_595352.base,
                         call_595352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595352, url, valid)

proc call*(call_595353: Call_ContentPosDelete_595338; targetMerchantId: string;
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
  var path_595354 = newJObject()
  var query_595355 = newJObject()
  add(query_595355, "fields", newJString(fields))
  add(query_595355, "quotaUser", newJString(quotaUser))
  add(query_595355, "alt", newJString(alt))
  add(query_595355, "dryRun", newJBool(dryRun))
  add(path_595354, "targetMerchantId", newJString(targetMerchantId))
  add(query_595355, "oauth_token", newJString(oauthToken))
  add(path_595354, "storeCode", newJString(storeCode))
  add(query_595355, "userIp", newJString(userIp))
  add(query_595355, "key", newJString(key))
  add(path_595354, "merchantId", newJString(merchantId))
  add(query_595355, "prettyPrint", newJBool(prettyPrint))
  result = call_595353.call(path_595354, query_595355, nil, nil, nil)

var contentPosDelete* = Call_ContentPosDelete_595338(name: "contentPosDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store/{storeCode}",
    validator: validate_ContentPosDelete_595339, base: "/content/v2",
    url: url_ContentPosDelete_595340, schemes: {Scheme.Https})
type
  Call_ContentProductsInsert_595374 = ref object of OpenApiRestCall_593421
proc url_ContentProductsInsert_595376(protocol: Scheme; host: string; base: string;
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

proc validate_ContentProductsInsert_595375(path: JsonNode; query: JsonNode;
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
  var valid_595377 = path.getOrDefault("merchantId")
  valid_595377 = validateParameter(valid_595377, JString, required = true,
                                 default = nil)
  if valid_595377 != nil:
    section.add "merchantId", valid_595377
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
  var valid_595378 = query.getOrDefault("fields")
  valid_595378 = validateParameter(valid_595378, JString, required = false,
                                 default = nil)
  if valid_595378 != nil:
    section.add "fields", valid_595378
  var valid_595379 = query.getOrDefault("quotaUser")
  valid_595379 = validateParameter(valid_595379, JString, required = false,
                                 default = nil)
  if valid_595379 != nil:
    section.add "quotaUser", valid_595379
  var valid_595380 = query.getOrDefault("alt")
  valid_595380 = validateParameter(valid_595380, JString, required = false,
                                 default = newJString("json"))
  if valid_595380 != nil:
    section.add "alt", valid_595380
  var valid_595381 = query.getOrDefault("dryRun")
  valid_595381 = validateParameter(valid_595381, JBool, required = false, default = nil)
  if valid_595381 != nil:
    section.add "dryRun", valid_595381
  var valid_595382 = query.getOrDefault("oauth_token")
  valid_595382 = validateParameter(valid_595382, JString, required = false,
                                 default = nil)
  if valid_595382 != nil:
    section.add "oauth_token", valid_595382
  var valid_595383 = query.getOrDefault("userIp")
  valid_595383 = validateParameter(valid_595383, JString, required = false,
                                 default = nil)
  if valid_595383 != nil:
    section.add "userIp", valid_595383
  var valid_595384 = query.getOrDefault("key")
  valid_595384 = validateParameter(valid_595384, JString, required = false,
                                 default = nil)
  if valid_595384 != nil:
    section.add "key", valid_595384
  var valid_595385 = query.getOrDefault("prettyPrint")
  valid_595385 = validateParameter(valid_595385, JBool, required = false,
                                 default = newJBool(true))
  if valid_595385 != nil:
    section.add "prettyPrint", valid_595385
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

proc call*(call_595387: Call_ContentProductsInsert_595374; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a product to your Merchant Center account. If an item with the same channel, contentLanguage, offerId, and targetCountry already exists, this method updates that entry.
  ## 
  let valid = call_595387.validator(path, query, header, formData, body)
  let scheme = call_595387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595387.url(scheme.get, call_595387.host, call_595387.base,
                         call_595387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595387, url, valid)

proc call*(call_595388: Call_ContentProductsInsert_595374; merchantId: string;
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
  var path_595389 = newJObject()
  var query_595390 = newJObject()
  var body_595391 = newJObject()
  add(query_595390, "fields", newJString(fields))
  add(query_595390, "quotaUser", newJString(quotaUser))
  add(query_595390, "alt", newJString(alt))
  add(query_595390, "dryRun", newJBool(dryRun))
  add(query_595390, "oauth_token", newJString(oauthToken))
  add(query_595390, "userIp", newJString(userIp))
  add(query_595390, "key", newJString(key))
  add(path_595389, "merchantId", newJString(merchantId))
  if body != nil:
    body_595391 = body
  add(query_595390, "prettyPrint", newJBool(prettyPrint))
  result = call_595388.call(path_595389, query_595390, nil, nil, body_595391)

var contentProductsInsert* = Call_ContentProductsInsert_595374(
    name: "contentProductsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/products",
    validator: validate_ContentProductsInsert_595375, base: "/content/v2",
    url: url_ContentProductsInsert_595376, schemes: {Scheme.Https})
type
  Call_ContentProductsList_595356 = ref object of OpenApiRestCall_593421
proc url_ContentProductsList_595358(protocol: Scheme; host: string; base: string;
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

proc validate_ContentProductsList_595357(path: JsonNode; query: JsonNode;
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
  var valid_595359 = path.getOrDefault("merchantId")
  valid_595359 = validateParameter(valid_595359, JString, required = true,
                                 default = nil)
  if valid_595359 != nil:
    section.add "merchantId", valid_595359
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
  var valid_595360 = query.getOrDefault("fields")
  valid_595360 = validateParameter(valid_595360, JString, required = false,
                                 default = nil)
  if valid_595360 != nil:
    section.add "fields", valid_595360
  var valid_595361 = query.getOrDefault("pageToken")
  valid_595361 = validateParameter(valid_595361, JString, required = false,
                                 default = nil)
  if valid_595361 != nil:
    section.add "pageToken", valid_595361
  var valid_595362 = query.getOrDefault("quotaUser")
  valid_595362 = validateParameter(valid_595362, JString, required = false,
                                 default = nil)
  if valid_595362 != nil:
    section.add "quotaUser", valid_595362
  var valid_595363 = query.getOrDefault("alt")
  valid_595363 = validateParameter(valid_595363, JString, required = false,
                                 default = newJString("json"))
  if valid_595363 != nil:
    section.add "alt", valid_595363
  var valid_595364 = query.getOrDefault("oauth_token")
  valid_595364 = validateParameter(valid_595364, JString, required = false,
                                 default = nil)
  if valid_595364 != nil:
    section.add "oauth_token", valid_595364
  var valid_595365 = query.getOrDefault("userIp")
  valid_595365 = validateParameter(valid_595365, JString, required = false,
                                 default = nil)
  if valid_595365 != nil:
    section.add "userIp", valid_595365
  var valid_595366 = query.getOrDefault("maxResults")
  valid_595366 = validateParameter(valid_595366, JInt, required = false, default = nil)
  if valid_595366 != nil:
    section.add "maxResults", valid_595366
  var valid_595367 = query.getOrDefault("key")
  valid_595367 = validateParameter(valid_595367, JString, required = false,
                                 default = nil)
  if valid_595367 != nil:
    section.add "key", valid_595367
  var valid_595368 = query.getOrDefault("prettyPrint")
  valid_595368 = validateParameter(valid_595368, JBool, required = false,
                                 default = newJBool(true))
  if valid_595368 != nil:
    section.add "prettyPrint", valid_595368
  var valid_595369 = query.getOrDefault("includeInvalidInsertedItems")
  valid_595369 = validateParameter(valid_595369, JBool, required = false, default = nil)
  if valid_595369 != nil:
    section.add "includeInvalidInsertedItems", valid_595369
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595370: Call_ContentProductsList_595356; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the products in your Merchant Center account.
  ## 
  let valid = call_595370.validator(path, query, header, formData, body)
  let scheme = call_595370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595370.url(scheme.get, call_595370.host, call_595370.base,
                         call_595370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595370, url, valid)

proc call*(call_595371: Call_ContentProductsList_595356; merchantId: string;
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
  var path_595372 = newJObject()
  var query_595373 = newJObject()
  add(query_595373, "fields", newJString(fields))
  add(query_595373, "pageToken", newJString(pageToken))
  add(query_595373, "quotaUser", newJString(quotaUser))
  add(query_595373, "alt", newJString(alt))
  add(query_595373, "oauth_token", newJString(oauthToken))
  add(query_595373, "userIp", newJString(userIp))
  add(query_595373, "maxResults", newJInt(maxResults))
  add(query_595373, "key", newJString(key))
  add(path_595372, "merchantId", newJString(merchantId))
  add(query_595373, "prettyPrint", newJBool(prettyPrint))
  add(query_595373, "includeInvalidInsertedItems",
      newJBool(includeInvalidInsertedItems))
  result = call_595371.call(path_595372, query_595373, nil, nil, nil)

var contentProductsList* = Call_ContentProductsList_595356(
    name: "contentProductsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/products",
    validator: validate_ContentProductsList_595357, base: "/content/v2",
    url: url_ContentProductsList_595358, schemes: {Scheme.Https})
type
  Call_ContentProductsGet_595392 = ref object of OpenApiRestCall_593421
proc url_ContentProductsGet_595394(protocol: Scheme; host: string; base: string;
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

proc validate_ContentProductsGet_595393(path: JsonNode; query: JsonNode;
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
  var valid_595395 = path.getOrDefault("merchantId")
  valid_595395 = validateParameter(valid_595395, JString, required = true,
                                 default = nil)
  if valid_595395 != nil:
    section.add "merchantId", valid_595395
  var valid_595396 = path.getOrDefault("productId")
  valid_595396 = validateParameter(valid_595396, JString, required = true,
                                 default = nil)
  if valid_595396 != nil:
    section.add "productId", valid_595396
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
  var valid_595397 = query.getOrDefault("fields")
  valid_595397 = validateParameter(valid_595397, JString, required = false,
                                 default = nil)
  if valid_595397 != nil:
    section.add "fields", valid_595397
  var valid_595398 = query.getOrDefault("quotaUser")
  valid_595398 = validateParameter(valid_595398, JString, required = false,
                                 default = nil)
  if valid_595398 != nil:
    section.add "quotaUser", valid_595398
  var valid_595399 = query.getOrDefault("alt")
  valid_595399 = validateParameter(valid_595399, JString, required = false,
                                 default = newJString("json"))
  if valid_595399 != nil:
    section.add "alt", valid_595399
  var valid_595400 = query.getOrDefault("oauth_token")
  valid_595400 = validateParameter(valid_595400, JString, required = false,
                                 default = nil)
  if valid_595400 != nil:
    section.add "oauth_token", valid_595400
  var valid_595401 = query.getOrDefault("userIp")
  valid_595401 = validateParameter(valid_595401, JString, required = false,
                                 default = nil)
  if valid_595401 != nil:
    section.add "userIp", valid_595401
  var valid_595402 = query.getOrDefault("key")
  valid_595402 = validateParameter(valid_595402, JString, required = false,
                                 default = nil)
  if valid_595402 != nil:
    section.add "key", valid_595402
  var valid_595403 = query.getOrDefault("prettyPrint")
  valid_595403 = validateParameter(valid_595403, JBool, required = false,
                                 default = newJBool(true))
  if valid_595403 != nil:
    section.add "prettyPrint", valid_595403
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595404: Call_ContentProductsGet_595392; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a product from your Merchant Center account.
  ## 
  let valid = call_595404.validator(path, query, header, formData, body)
  let scheme = call_595404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595404.url(scheme.get, call_595404.host, call_595404.base,
                         call_595404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595404, url, valid)

proc call*(call_595405: Call_ContentProductsGet_595392; merchantId: string;
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
  var path_595406 = newJObject()
  var query_595407 = newJObject()
  add(query_595407, "fields", newJString(fields))
  add(query_595407, "quotaUser", newJString(quotaUser))
  add(query_595407, "alt", newJString(alt))
  add(query_595407, "oauth_token", newJString(oauthToken))
  add(query_595407, "userIp", newJString(userIp))
  add(query_595407, "key", newJString(key))
  add(path_595406, "merchantId", newJString(merchantId))
  add(path_595406, "productId", newJString(productId))
  add(query_595407, "prettyPrint", newJBool(prettyPrint))
  result = call_595405.call(path_595406, query_595407, nil, nil, nil)

var contentProductsGet* = Call_ContentProductsGet_595392(
    name: "contentProductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/products/{productId}",
    validator: validate_ContentProductsGet_595393, base: "/content/v2",
    url: url_ContentProductsGet_595394, schemes: {Scheme.Https})
type
  Call_ContentProductsDelete_595408 = ref object of OpenApiRestCall_593421
proc url_ContentProductsDelete_595410(protocol: Scheme; host: string; base: string;
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

proc validate_ContentProductsDelete_595409(path: JsonNode; query: JsonNode;
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
  var valid_595411 = path.getOrDefault("merchantId")
  valid_595411 = validateParameter(valid_595411, JString, required = true,
                                 default = nil)
  if valid_595411 != nil:
    section.add "merchantId", valid_595411
  var valid_595412 = path.getOrDefault("productId")
  valid_595412 = validateParameter(valid_595412, JString, required = true,
                                 default = nil)
  if valid_595412 != nil:
    section.add "productId", valid_595412
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
  var valid_595413 = query.getOrDefault("fields")
  valid_595413 = validateParameter(valid_595413, JString, required = false,
                                 default = nil)
  if valid_595413 != nil:
    section.add "fields", valid_595413
  var valid_595414 = query.getOrDefault("quotaUser")
  valid_595414 = validateParameter(valid_595414, JString, required = false,
                                 default = nil)
  if valid_595414 != nil:
    section.add "quotaUser", valid_595414
  var valid_595415 = query.getOrDefault("alt")
  valid_595415 = validateParameter(valid_595415, JString, required = false,
                                 default = newJString("json"))
  if valid_595415 != nil:
    section.add "alt", valid_595415
  var valid_595416 = query.getOrDefault("dryRun")
  valid_595416 = validateParameter(valid_595416, JBool, required = false, default = nil)
  if valid_595416 != nil:
    section.add "dryRun", valid_595416
  var valid_595417 = query.getOrDefault("oauth_token")
  valid_595417 = validateParameter(valid_595417, JString, required = false,
                                 default = nil)
  if valid_595417 != nil:
    section.add "oauth_token", valid_595417
  var valid_595418 = query.getOrDefault("userIp")
  valid_595418 = validateParameter(valid_595418, JString, required = false,
                                 default = nil)
  if valid_595418 != nil:
    section.add "userIp", valid_595418
  var valid_595419 = query.getOrDefault("key")
  valid_595419 = validateParameter(valid_595419, JString, required = false,
                                 default = nil)
  if valid_595419 != nil:
    section.add "key", valid_595419
  var valid_595420 = query.getOrDefault("prettyPrint")
  valid_595420 = validateParameter(valid_595420, JBool, required = false,
                                 default = newJBool(true))
  if valid_595420 != nil:
    section.add "prettyPrint", valid_595420
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595421: Call_ContentProductsDelete_595408; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a product from your Merchant Center account.
  ## 
  let valid = call_595421.validator(path, query, header, formData, body)
  let scheme = call_595421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595421.url(scheme.get, call_595421.host, call_595421.base,
                         call_595421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595421, url, valid)

proc call*(call_595422: Call_ContentProductsDelete_595408; merchantId: string;
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
  var path_595423 = newJObject()
  var query_595424 = newJObject()
  add(query_595424, "fields", newJString(fields))
  add(query_595424, "quotaUser", newJString(quotaUser))
  add(query_595424, "alt", newJString(alt))
  add(query_595424, "dryRun", newJBool(dryRun))
  add(query_595424, "oauth_token", newJString(oauthToken))
  add(query_595424, "userIp", newJString(userIp))
  add(query_595424, "key", newJString(key))
  add(path_595423, "merchantId", newJString(merchantId))
  add(path_595423, "productId", newJString(productId))
  add(query_595424, "prettyPrint", newJBool(prettyPrint))
  result = call_595422.call(path_595423, query_595424, nil, nil, nil)

var contentProductsDelete* = Call_ContentProductsDelete_595408(
    name: "contentProductsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/products/{productId}",
    validator: validate_ContentProductsDelete_595409, base: "/content/v2",
    url: url_ContentProductsDelete_595410, schemes: {Scheme.Https})
type
  Call_ContentProductstatusesList_595425 = ref object of OpenApiRestCall_593421
proc url_ContentProductstatusesList_595427(protocol: Scheme; host: string;
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

proc validate_ContentProductstatusesList_595426(path: JsonNode; query: JsonNode;
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
  var valid_595428 = path.getOrDefault("merchantId")
  valid_595428 = validateParameter(valid_595428, JString, required = true,
                                 default = nil)
  if valid_595428 != nil:
    section.add "merchantId", valid_595428
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
  var valid_595429 = query.getOrDefault("fields")
  valid_595429 = validateParameter(valid_595429, JString, required = false,
                                 default = nil)
  if valid_595429 != nil:
    section.add "fields", valid_595429
  var valid_595430 = query.getOrDefault("pageToken")
  valid_595430 = validateParameter(valid_595430, JString, required = false,
                                 default = nil)
  if valid_595430 != nil:
    section.add "pageToken", valid_595430
  var valid_595431 = query.getOrDefault("quotaUser")
  valid_595431 = validateParameter(valid_595431, JString, required = false,
                                 default = nil)
  if valid_595431 != nil:
    section.add "quotaUser", valid_595431
  var valid_595432 = query.getOrDefault("alt")
  valid_595432 = validateParameter(valid_595432, JString, required = false,
                                 default = newJString("json"))
  if valid_595432 != nil:
    section.add "alt", valid_595432
  var valid_595433 = query.getOrDefault("oauth_token")
  valid_595433 = validateParameter(valid_595433, JString, required = false,
                                 default = nil)
  if valid_595433 != nil:
    section.add "oauth_token", valid_595433
  var valid_595434 = query.getOrDefault("userIp")
  valid_595434 = validateParameter(valid_595434, JString, required = false,
                                 default = nil)
  if valid_595434 != nil:
    section.add "userIp", valid_595434
  var valid_595435 = query.getOrDefault("maxResults")
  valid_595435 = validateParameter(valid_595435, JInt, required = false, default = nil)
  if valid_595435 != nil:
    section.add "maxResults", valid_595435
  var valid_595436 = query.getOrDefault("includeAttributes")
  valid_595436 = validateParameter(valid_595436, JBool, required = false, default = nil)
  if valid_595436 != nil:
    section.add "includeAttributes", valid_595436
  var valid_595437 = query.getOrDefault("key")
  valid_595437 = validateParameter(valid_595437, JString, required = false,
                                 default = nil)
  if valid_595437 != nil:
    section.add "key", valid_595437
  var valid_595438 = query.getOrDefault("prettyPrint")
  valid_595438 = validateParameter(valid_595438, JBool, required = false,
                                 default = newJBool(true))
  if valid_595438 != nil:
    section.add "prettyPrint", valid_595438
  var valid_595439 = query.getOrDefault("destinations")
  valid_595439 = validateParameter(valid_595439, JArray, required = false,
                                 default = nil)
  if valid_595439 != nil:
    section.add "destinations", valid_595439
  var valid_595440 = query.getOrDefault("includeInvalidInsertedItems")
  valid_595440 = validateParameter(valid_595440, JBool, required = false, default = nil)
  if valid_595440 != nil:
    section.add "includeInvalidInsertedItems", valid_595440
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595441: Call_ContentProductstatusesList_595425; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the products in your Merchant Center account.
  ## 
  let valid = call_595441.validator(path, query, header, formData, body)
  let scheme = call_595441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595441.url(scheme.get, call_595441.host, call_595441.base,
                         call_595441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595441, url, valid)

proc call*(call_595442: Call_ContentProductstatusesList_595425; merchantId: string;
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
  var path_595443 = newJObject()
  var query_595444 = newJObject()
  add(query_595444, "fields", newJString(fields))
  add(query_595444, "pageToken", newJString(pageToken))
  add(query_595444, "quotaUser", newJString(quotaUser))
  add(query_595444, "alt", newJString(alt))
  add(query_595444, "oauth_token", newJString(oauthToken))
  add(query_595444, "userIp", newJString(userIp))
  add(query_595444, "maxResults", newJInt(maxResults))
  add(query_595444, "includeAttributes", newJBool(includeAttributes))
  add(query_595444, "key", newJString(key))
  add(path_595443, "merchantId", newJString(merchantId))
  add(query_595444, "prettyPrint", newJBool(prettyPrint))
  if destinations != nil:
    query_595444.add "destinations", destinations
  add(query_595444, "includeInvalidInsertedItems",
      newJBool(includeInvalidInsertedItems))
  result = call_595442.call(path_595443, query_595444, nil, nil, nil)

var contentProductstatusesList* = Call_ContentProductstatusesList_595425(
    name: "contentProductstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/productstatuses",
    validator: validate_ContentProductstatusesList_595426, base: "/content/v2",
    url: url_ContentProductstatusesList_595427, schemes: {Scheme.Https})
type
  Call_ContentProductstatusesGet_595445 = ref object of OpenApiRestCall_593421
proc url_ContentProductstatusesGet_595447(protocol: Scheme; host: string;
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

proc validate_ContentProductstatusesGet_595446(path: JsonNode; query: JsonNode;
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
  var valid_595448 = path.getOrDefault("merchantId")
  valid_595448 = validateParameter(valid_595448, JString, required = true,
                                 default = nil)
  if valid_595448 != nil:
    section.add "merchantId", valid_595448
  var valid_595449 = path.getOrDefault("productId")
  valid_595449 = validateParameter(valid_595449, JString, required = true,
                                 default = nil)
  if valid_595449 != nil:
    section.add "productId", valid_595449
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
  var valid_595450 = query.getOrDefault("fields")
  valid_595450 = validateParameter(valid_595450, JString, required = false,
                                 default = nil)
  if valid_595450 != nil:
    section.add "fields", valid_595450
  var valid_595451 = query.getOrDefault("quotaUser")
  valid_595451 = validateParameter(valid_595451, JString, required = false,
                                 default = nil)
  if valid_595451 != nil:
    section.add "quotaUser", valid_595451
  var valid_595452 = query.getOrDefault("alt")
  valid_595452 = validateParameter(valid_595452, JString, required = false,
                                 default = newJString("json"))
  if valid_595452 != nil:
    section.add "alt", valid_595452
  var valid_595453 = query.getOrDefault("oauth_token")
  valid_595453 = validateParameter(valid_595453, JString, required = false,
                                 default = nil)
  if valid_595453 != nil:
    section.add "oauth_token", valid_595453
  var valid_595454 = query.getOrDefault("userIp")
  valid_595454 = validateParameter(valid_595454, JString, required = false,
                                 default = nil)
  if valid_595454 != nil:
    section.add "userIp", valid_595454
  var valid_595455 = query.getOrDefault("includeAttributes")
  valid_595455 = validateParameter(valid_595455, JBool, required = false, default = nil)
  if valid_595455 != nil:
    section.add "includeAttributes", valid_595455
  var valid_595456 = query.getOrDefault("key")
  valid_595456 = validateParameter(valid_595456, JString, required = false,
                                 default = nil)
  if valid_595456 != nil:
    section.add "key", valid_595456
  var valid_595457 = query.getOrDefault("prettyPrint")
  valid_595457 = validateParameter(valid_595457, JBool, required = false,
                                 default = newJBool(true))
  if valid_595457 != nil:
    section.add "prettyPrint", valid_595457
  var valid_595458 = query.getOrDefault("destinations")
  valid_595458 = validateParameter(valid_595458, JArray, required = false,
                                 default = nil)
  if valid_595458 != nil:
    section.add "destinations", valid_595458
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595459: Call_ContentProductstatusesGet_595445; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the status of a product from your Merchant Center account.
  ## 
  let valid = call_595459.validator(path, query, header, formData, body)
  let scheme = call_595459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595459.url(scheme.get, call_595459.host, call_595459.base,
                         call_595459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595459, url, valid)

proc call*(call_595460: Call_ContentProductstatusesGet_595445; merchantId: string;
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
  var path_595461 = newJObject()
  var query_595462 = newJObject()
  add(query_595462, "fields", newJString(fields))
  add(query_595462, "quotaUser", newJString(quotaUser))
  add(query_595462, "alt", newJString(alt))
  add(query_595462, "oauth_token", newJString(oauthToken))
  add(query_595462, "userIp", newJString(userIp))
  add(query_595462, "includeAttributes", newJBool(includeAttributes))
  add(query_595462, "key", newJString(key))
  add(path_595461, "merchantId", newJString(merchantId))
  add(path_595461, "productId", newJString(productId))
  add(query_595462, "prettyPrint", newJBool(prettyPrint))
  if destinations != nil:
    query_595462.add "destinations", destinations
  result = call_595460.call(path_595461, query_595462, nil, nil, nil)

var contentProductstatusesGet* = Call_ContentProductstatusesGet_595445(
    name: "contentProductstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/productstatuses/{productId}",
    validator: validate_ContentProductstatusesGet_595446, base: "/content/v2",
    url: url_ContentProductstatusesGet_595447, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsList_595463 = ref object of OpenApiRestCall_593421
proc url_ContentShippingsettingsList_595465(protocol: Scheme; host: string;
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

proc validate_ContentShippingsettingsList_595464(path: JsonNode; query: JsonNode;
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
  var valid_595466 = path.getOrDefault("merchantId")
  valid_595466 = validateParameter(valid_595466, JString, required = true,
                                 default = nil)
  if valid_595466 != nil:
    section.add "merchantId", valid_595466
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
  var valid_595467 = query.getOrDefault("fields")
  valid_595467 = validateParameter(valid_595467, JString, required = false,
                                 default = nil)
  if valid_595467 != nil:
    section.add "fields", valid_595467
  var valid_595468 = query.getOrDefault("pageToken")
  valid_595468 = validateParameter(valid_595468, JString, required = false,
                                 default = nil)
  if valid_595468 != nil:
    section.add "pageToken", valid_595468
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
  var valid_595473 = query.getOrDefault("maxResults")
  valid_595473 = validateParameter(valid_595473, JInt, required = false, default = nil)
  if valid_595473 != nil:
    section.add "maxResults", valid_595473
  var valid_595474 = query.getOrDefault("key")
  valid_595474 = validateParameter(valid_595474, JString, required = false,
                                 default = nil)
  if valid_595474 != nil:
    section.add "key", valid_595474
  var valid_595475 = query.getOrDefault("prettyPrint")
  valid_595475 = validateParameter(valid_595475, JBool, required = false,
                                 default = newJBool(true))
  if valid_595475 != nil:
    section.add "prettyPrint", valid_595475
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595476: Call_ContentShippingsettingsList_595463; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the shipping settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_595476.validator(path, query, header, formData, body)
  let scheme = call_595476.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595476.url(scheme.get, call_595476.host, call_595476.base,
                         call_595476.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595476, url, valid)

proc call*(call_595477: Call_ContentShippingsettingsList_595463;
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
  var path_595478 = newJObject()
  var query_595479 = newJObject()
  add(query_595479, "fields", newJString(fields))
  add(query_595479, "pageToken", newJString(pageToken))
  add(query_595479, "quotaUser", newJString(quotaUser))
  add(query_595479, "alt", newJString(alt))
  add(query_595479, "oauth_token", newJString(oauthToken))
  add(query_595479, "userIp", newJString(userIp))
  add(query_595479, "maxResults", newJInt(maxResults))
  add(query_595479, "key", newJString(key))
  add(path_595478, "merchantId", newJString(merchantId))
  add(query_595479, "prettyPrint", newJBool(prettyPrint))
  result = call_595477.call(path_595478, query_595479, nil, nil, nil)

var contentShippingsettingsList* = Call_ContentShippingsettingsList_595463(
    name: "contentShippingsettingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/shippingsettings",
    validator: validate_ContentShippingsettingsList_595464, base: "/content/v2",
    url: url_ContentShippingsettingsList_595465, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsUpdate_595496 = ref object of OpenApiRestCall_593421
proc url_ContentShippingsettingsUpdate_595498(protocol: Scheme; host: string;
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

proc validate_ContentShippingsettingsUpdate_595497(path: JsonNode; query: JsonNode;
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
  var valid_595499 = path.getOrDefault("accountId")
  valid_595499 = validateParameter(valid_595499, JString, required = true,
                                 default = nil)
  if valid_595499 != nil:
    section.add "accountId", valid_595499
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
  var valid_595504 = query.getOrDefault("dryRun")
  valid_595504 = validateParameter(valid_595504, JBool, required = false, default = nil)
  if valid_595504 != nil:
    section.add "dryRun", valid_595504
  var valid_595505 = query.getOrDefault("oauth_token")
  valid_595505 = validateParameter(valid_595505, JString, required = false,
                                 default = nil)
  if valid_595505 != nil:
    section.add "oauth_token", valid_595505
  var valid_595506 = query.getOrDefault("userIp")
  valid_595506 = validateParameter(valid_595506, JString, required = false,
                                 default = nil)
  if valid_595506 != nil:
    section.add "userIp", valid_595506
  var valid_595507 = query.getOrDefault("key")
  valid_595507 = validateParameter(valid_595507, JString, required = false,
                                 default = nil)
  if valid_595507 != nil:
    section.add "key", valid_595507
  var valid_595508 = query.getOrDefault("prettyPrint")
  valid_595508 = validateParameter(valid_595508, JBool, required = false,
                                 default = newJBool(true))
  if valid_595508 != nil:
    section.add "prettyPrint", valid_595508
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

proc call*(call_595510: Call_ContentShippingsettingsUpdate_595496; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the shipping settings of the account.
  ## 
  let valid = call_595510.validator(path, query, header, formData, body)
  let scheme = call_595510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595510.url(scheme.get, call_595510.host, call_595510.base,
                         call_595510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595510, url, valid)

proc call*(call_595511: Call_ContentShippingsettingsUpdate_595496;
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
  var path_595512 = newJObject()
  var query_595513 = newJObject()
  var body_595514 = newJObject()
  add(query_595513, "fields", newJString(fields))
  add(query_595513, "quotaUser", newJString(quotaUser))
  add(query_595513, "alt", newJString(alt))
  add(query_595513, "dryRun", newJBool(dryRun))
  add(query_595513, "oauth_token", newJString(oauthToken))
  add(path_595512, "accountId", newJString(accountId))
  add(query_595513, "userIp", newJString(userIp))
  add(query_595513, "key", newJString(key))
  add(path_595512, "merchantId", newJString(merchantId))
  if body != nil:
    body_595514 = body
  add(query_595513, "prettyPrint", newJBool(prettyPrint))
  result = call_595511.call(path_595512, query_595513, nil, nil, body_595514)

var contentShippingsettingsUpdate* = Call_ContentShippingsettingsUpdate_595496(
    name: "contentShippingsettingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{merchantId}/shippingsettings/{accountId}",
    validator: validate_ContentShippingsettingsUpdate_595497, base: "/content/v2",
    url: url_ContentShippingsettingsUpdate_595498, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGet_595480 = ref object of OpenApiRestCall_593421
proc url_ContentShippingsettingsGet_595482(protocol: Scheme; host: string;
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

proc validate_ContentShippingsettingsGet_595481(path: JsonNode; query: JsonNode;
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
  var valid_595483 = path.getOrDefault("accountId")
  valid_595483 = validateParameter(valid_595483, JString, required = true,
                                 default = nil)
  if valid_595483 != nil:
    section.add "accountId", valid_595483
  var valid_595484 = path.getOrDefault("merchantId")
  valid_595484 = validateParameter(valid_595484, JString, required = true,
                                 default = nil)
  if valid_595484 != nil:
    section.add "merchantId", valid_595484
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
  var valid_595485 = query.getOrDefault("fields")
  valid_595485 = validateParameter(valid_595485, JString, required = false,
                                 default = nil)
  if valid_595485 != nil:
    section.add "fields", valid_595485
  var valid_595486 = query.getOrDefault("quotaUser")
  valid_595486 = validateParameter(valid_595486, JString, required = false,
                                 default = nil)
  if valid_595486 != nil:
    section.add "quotaUser", valid_595486
  var valid_595487 = query.getOrDefault("alt")
  valid_595487 = validateParameter(valid_595487, JString, required = false,
                                 default = newJString("json"))
  if valid_595487 != nil:
    section.add "alt", valid_595487
  var valid_595488 = query.getOrDefault("oauth_token")
  valid_595488 = validateParameter(valid_595488, JString, required = false,
                                 default = nil)
  if valid_595488 != nil:
    section.add "oauth_token", valid_595488
  var valid_595489 = query.getOrDefault("userIp")
  valid_595489 = validateParameter(valid_595489, JString, required = false,
                                 default = nil)
  if valid_595489 != nil:
    section.add "userIp", valid_595489
  var valid_595490 = query.getOrDefault("key")
  valid_595490 = validateParameter(valid_595490, JString, required = false,
                                 default = nil)
  if valid_595490 != nil:
    section.add "key", valid_595490
  var valid_595491 = query.getOrDefault("prettyPrint")
  valid_595491 = validateParameter(valid_595491, JBool, required = false,
                                 default = newJBool(true))
  if valid_595491 != nil:
    section.add "prettyPrint", valid_595491
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595492: Call_ContentShippingsettingsGet_595480; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the shipping settings of the account.
  ## 
  let valid = call_595492.validator(path, query, header, formData, body)
  let scheme = call_595492.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595492.url(scheme.get, call_595492.host, call_595492.base,
                         call_595492.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595492, url, valid)

proc call*(call_595493: Call_ContentShippingsettingsGet_595480; accountId: string;
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
  var path_595494 = newJObject()
  var query_595495 = newJObject()
  add(query_595495, "fields", newJString(fields))
  add(query_595495, "quotaUser", newJString(quotaUser))
  add(query_595495, "alt", newJString(alt))
  add(query_595495, "oauth_token", newJString(oauthToken))
  add(path_595494, "accountId", newJString(accountId))
  add(query_595495, "userIp", newJString(userIp))
  add(query_595495, "key", newJString(key))
  add(path_595494, "merchantId", newJString(merchantId))
  add(query_595495, "prettyPrint", newJBool(prettyPrint))
  result = call_595493.call(path_595494, query_595495, nil, nil, nil)

var contentShippingsettingsGet* = Call_ContentShippingsettingsGet_595480(
    name: "contentShippingsettingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/shippingsettings/{accountId}",
    validator: validate_ContentShippingsettingsGet_595481, base: "/content/v2",
    url: url_ContentShippingsettingsGet_595482, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsPatch_595515 = ref object of OpenApiRestCall_593421
proc url_ContentShippingsettingsPatch_595517(protocol: Scheme; host: string;
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

proc validate_ContentShippingsettingsPatch_595516(path: JsonNode; query: JsonNode;
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
  var valid_595518 = path.getOrDefault("accountId")
  valid_595518 = validateParameter(valid_595518, JString, required = true,
                                 default = nil)
  if valid_595518 != nil:
    section.add "accountId", valid_595518
  var valid_595519 = path.getOrDefault("merchantId")
  valid_595519 = validateParameter(valid_595519, JString, required = true,
                                 default = nil)
  if valid_595519 != nil:
    section.add "merchantId", valid_595519
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
  var valid_595520 = query.getOrDefault("fields")
  valid_595520 = validateParameter(valid_595520, JString, required = false,
                                 default = nil)
  if valid_595520 != nil:
    section.add "fields", valid_595520
  var valid_595521 = query.getOrDefault("quotaUser")
  valid_595521 = validateParameter(valid_595521, JString, required = false,
                                 default = nil)
  if valid_595521 != nil:
    section.add "quotaUser", valid_595521
  var valid_595522 = query.getOrDefault("alt")
  valid_595522 = validateParameter(valid_595522, JString, required = false,
                                 default = newJString("json"))
  if valid_595522 != nil:
    section.add "alt", valid_595522
  var valid_595523 = query.getOrDefault("dryRun")
  valid_595523 = validateParameter(valid_595523, JBool, required = false, default = nil)
  if valid_595523 != nil:
    section.add "dryRun", valid_595523
  var valid_595524 = query.getOrDefault("oauth_token")
  valid_595524 = validateParameter(valid_595524, JString, required = false,
                                 default = nil)
  if valid_595524 != nil:
    section.add "oauth_token", valid_595524
  var valid_595525 = query.getOrDefault("userIp")
  valid_595525 = validateParameter(valid_595525, JString, required = false,
                                 default = nil)
  if valid_595525 != nil:
    section.add "userIp", valid_595525
  var valid_595526 = query.getOrDefault("key")
  valid_595526 = validateParameter(valid_595526, JString, required = false,
                                 default = nil)
  if valid_595526 != nil:
    section.add "key", valid_595526
  var valid_595527 = query.getOrDefault("prettyPrint")
  valid_595527 = validateParameter(valid_595527, JBool, required = false,
                                 default = newJBool(true))
  if valid_595527 != nil:
    section.add "prettyPrint", valid_595527
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

proc call*(call_595529: Call_ContentShippingsettingsPatch_595515; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the shipping settings of the account. This method supports patch semantics.
  ## 
  let valid = call_595529.validator(path, query, header, formData, body)
  let scheme = call_595529.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595529.url(scheme.get, call_595529.host, call_595529.base,
                         call_595529.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595529, url, valid)

proc call*(call_595530: Call_ContentShippingsettingsPatch_595515;
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
  var path_595531 = newJObject()
  var query_595532 = newJObject()
  var body_595533 = newJObject()
  add(query_595532, "fields", newJString(fields))
  add(query_595532, "quotaUser", newJString(quotaUser))
  add(query_595532, "alt", newJString(alt))
  add(query_595532, "dryRun", newJBool(dryRun))
  add(query_595532, "oauth_token", newJString(oauthToken))
  add(path_595531, "accountId", newJString(accountId))
  add(query_595532, "userIp", newJString(userIp))
  add(query_595532, "key", newJString(key))
  add(path_595531, "merchantId", newJString(merchantId))
  if body != nil:
    body_595533 = body
  add(query_595532, "prettyPrint", newJBool(prettyPrint))
  result = call_595530.call(path_595531, query_595532, nil, nil, body_595533)

var contentShippingsettingsPatch* = Call_ContentShippingsettingsPatch_595515(
    name: "contentShippingsettingsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{merchantId}/shippingsettings/{accountId}",
    validator: validate_ContentShippingsettingsPatch_595516, base: "/content/v2",
    url: url_ContentShippingsettingsPatch_595517, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGetsupportedcarriers_595534 = ref object of OpenApiRestCall_593421
proc url_ContentShippingsettingsGetsupportedcarriers_595536(protocol: Scheme;
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

proc validate_ContentShippingsettingsGetsupportedcarriers_595535(path: JsonNode;
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
  var valid_595537 = path.getOrDefault("merchantId")
  valid_595537 = validateParameter(valid_595537, JString, required = true,
                                 default = nil)
  if valid_595537 != nil:
    section.add "merchantId", valid_595537
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
  var valid_595538 = query.getOrDefault("fields")
  valid_595538 = validateParameter(valid_595538, JString, required = false,
                                 default = nil)
  if valid_595538 != nil:
    section.add "fields", valid_595538
  var valid_595539 = query.getOrDefault("quotaUser")
  valid_595539 = validateParameter(valid_595539, JString, required = false,
                                 default = nil)
  if valid_595539 != nil:
    section.add "quotaUser", valid_595539
  var valid_595540 = query.getOrDefault("alt")
  valid_595540 = validateParameter(valid_595540, JString, required = false,
                                 default = newJString("json"))
  if valid_595540 != nil:
    section.add "alt", valid_595540
  var valid_595541 = query.getOrDefault("oauth_token")
  valid_595541 = validateParameter(valid_595541, JString, required = false,
                                 default = nil)
  if valid_595541 != nil:
    section.add "oauth_token", valid_595541
  var valid_595542 = query.getOrDefault("userIp")
  valid_595542 = validateParameter(valid_595542, JString, required = false,
                                 default = nil)
  if valid_595542 != nil:
    section.add "userIp", valid_595542
  var valid_595543 = query.getOrDefault("key")
  valid_595543 = validateParameter(valid_595543, JString, required = false,
                                 default = nil)
  if valid_595543 != nil:
    section.add "key", valid_595543
  var valid_595544 = query.getOrDefault("prettyPrint")
  valid_595544 = validateParameter(valid_595544, JBool, required = false,
                                 default = newJBool(true))
  if valid_595544 != nil:
    section.add "prettyPrint", valid_595544
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595545: Call_ContentShippingsettingsGetsupportedcarriers_595534;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves supported carriers and carrier services for an account.
  ## 
  let valid = call_595545.validator(path, query, header, formData, body)
  let scheme = call_595545.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595545.url(scheme.get, call_595545.host, call_595545.base,
                         call_595545.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595545, url, valid)

proc call*(call_595546: Call_ContentShippingsettingsGetsupportedcarriers_595534;
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
  var path_595547 = newJObject()
  var query_595548 = newJObject()
  add(query_595548, "fields", newJString(fields))
  add(query_595548, "quotaUser", newJString(quotaUser))
  add(query_595548, "alt", newJString(alt))
  add(query_595548, "oauth_token", newJString(oauthToken))
  add(query_595548, "userIp", newJString(userIp))
  add(query_595548, "key", newJString(key))
  add(path_595547, "merchantId", newJString(merchantId))
  add(query_595548, "prettyPrint", newJBool(prettyPrint))
  result = call_595546.call(path_595547, query_595548, nil, nil, nil)

var contentShippingsettingsGetsupportedcarriers* = Call_ContentShippingsettingsGetsupportedcarriers_595534(
    name: "contentShippingsettingsGetsupportedcarriers", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/supportedCarriers",
    validator: validate_ContentShippingsettingsGetsupportedcarriers_595535,
    base: "/content/v2", url: url_ContentShippingsettingsGetsupportedcarriers_595536,
    schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGetsupportedholidays_595549 = ref object of OpenApiRestCall_593421
proc url_ContentShippingsettingsGetsupportedholidays_595551(protocol: Scheme;
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

proc validate_ContentShippingsettingsGetsupportedholidays_595550(path: JsonNode;
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
  var valid_595552 = path.getOrDefault("merchantId")
  valid_595552 = validateParameter(valid_595552, JString, required = true,
                                 default = nil)
  if valid_595552 != nil:
    section.add "merchantId", valid_595552
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
  var valid_595553 = query.getOrDefault("fields")
  valid_595553 = validateParameter(valid_595553, JString, required = false,
                                 default = nil)
  if valid_595553 != nil:
    section.add "fields", valid_595553
  var valid_595554 = query.getOrDefault("quotaUser")
  valid_595554 = validateParameter(valid_595554, JString, required = false,
                                 default = nil)
  if valid_595554 != nil:
    section.add "quotaUser", valid_595554
  var valid_595555 = query.getOrDefault("alt")
  valid_595555 = validateParameter(valid_595555, JString, required = false,
                                 default = newJString("json"))
  if valid_595555 != nil:
    section.add "alt", valid_595555
  var valid_595556 = query.getOrDefault("oauth_token")
  valid_595556 = validateParameter(valid_595556, JString, required = false,
                                 default = nil)
  if valid_595556 != nil:
    section.add "oauth_token", valid_595556
  var valid_595557 = query.getOrDefault("userIp")
  valid_595557 = validateParameter(valid_595557, JString, required = false,
                                 default = nil)
  if valid_595557 != nil:
    section.add "userIp", valid_595557
  var valid_595558 = query.getOrDefault("key")
  valid_595558 = validateParameter(valid_595558, JString, required = false,
                                 default = nil)
  if valid_595558 != nil:
    section.add "key", valid_595558
  var valid_595559 = query.getOrDefault("prettyPrint")
  valid_595559 = validateParameter(valid_595559, JBool, required = false,
                                 default = newJBool(true))
  if valid_595559 != nil:
    section.add "prettyPrint", valid_595559
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595560: Call_ContentShippingsettingsGetsupportedholidays_595549;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves supported holidays for an account.
  ## 
  let valid = call_595560.validator(path, query, header, formData, body)
  let scheme = call_595560.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595560.url(scheme.get, call_595560.host, call_595560.base,
                         call_595560.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595560, url, valid)

proc call*(call_595561: Call_ContentShippingsettingsGetsupportedholidays_595549;
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
  var path_595562 = newJObject()
  var query_595563 = newJObject()
  add(query_595563, "fields", newJString(fields))
  add(query_595563, "quotaUser", newJString(quotaUser))
  add(query_595563, "alt", newJString(alt))
  add(query_595563, "oauth_token", newJString(oauthToken))
  add(query_595563, "userIp", newJString(userIp))
  add(query_595563, "key", newJString(key))
  add(path_595562, "merchantId", newJString(merchantId))
  add(query_595563, "prettyPrint", newJBool(prettyPrint))
  result = call_595561.call(path_595562, query_595563, nil, nil, nil)

var contentShippingsettingsGetsupportedholidays* = Call_ContentShippingsettingsGetsupportedholidays_595549(
    name: "contentShippingsettingsGetsupportedholidays", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/supportedHolidays",
    validator: validate_ContentShippingsettingsGetsupportedholidays_595550,
    base: "/content/v2", url: url_ContentShippingsettingsGetsupportedholidays_595551,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersCreatetestorder_595564 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersCreatetestorder_595566(protocol: Scheme; host: string;
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

proc validate_ContentOrdersCreatetestorder_595565(path: JsonNode; query: JsonNode;
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
  var valid_595567 = path.getOrDefault("merchantId")
  valid_595567 = validateParameter(valid_595567, JString, required = true,
                                 default = nil)
  if valid_595567 != nil:
    section.add "merchantId", valid_595567
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
  var valid_595568 = query.getOrDefault("fields")
  valid_595568 = validateParameter(valid_595568, JString, required = false,
                                 default = nil)
  if valid_595568 != nil:
    section.add "fields", valid_595568
  var valid_595569 = query.getOrDefault("quotaUser")
  valid_595569 = validateParameter(valid_595569, JString, required = false,
                                 default = nil)
  if valid_595569 != nil:
    section.add "quotaUser", valid_595569
  var valid_595570 = query.getOrDefault("alt")
  valid_595570 = validateParameter(valid_595570, JString, required = false,
                                 default = newJString("json"))
  if valid_595570 != nil:
    section.add "alt", valid_595570
  var valid_595571 = query.getOrDefault("oauth_token")
  valid_595571 = validateParameter(valid_595571, JString, required = false,
                                 default = nil)
  if valid_595571 != nil:
    section.add "oauth_token", valid_595571
  var valid_595572 = query.getOrDefault("userIp")
  valid_595572 = validateParameter(valid_595572, JString, required = false,
                                 default = nil)
  if valid_595572 != nil:
    section.add "userIp", valid_595572
  var valid_595573 = query.getOrDefault("key")
  valid_595573 = validateParameter(valid_595573, JString, required = false,
                                 default = nil)
  if valid_595573 != nil:
    section.add "key", valid_595573
  var valid_595574 = query.getOrDefault("prettyPrint")
  valid_595574 = validateParameter(valid_595574, JBool, required = false,
                                 default = newJBool(true))
  if valid_595574 != nil:
    section.add "prettyPrint", valid_595574
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

proc call*(call_595576: Call_ContentOrdersCreatetestorder_595564; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Creates a test order.
  ## 
  let valid = call_595576.validator(path, query, header, formData, body)
  let scheme = call_595576.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595576.url(scheme.get, call_595576.host, call_595576.base,
                         call_595576.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595576, url, valid)

proc call*(call_595577: Call_ContentOrdersCreatetestorder_595564;
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
  var path_595578 = newJObject()
  var query_595579 = newJObject()
  var body_595580 = newJObject()
  add(query_595579, "fields", newJString(fields))
  add(query_595579, "quotaUser", newJString(quotaUser))
  add(query_595579, "alt", newJString(alt))
  add(query_595579, "oauth_token", newJString(oauthToken))
  add(query_595579, "userIp", newJString(userIp))
  add(query_595579, "key", newJString(key))
  add(path_595578, "merchantId", newJString(merchantId))
  if body != nil:
    body_595580 = body
  add(query_595579, "prettyPrint", newJBool(prettyPrint))
  result = call_595577.call(path_595578, query_595579, nil, nil, body_595580)

var contentOrdersCreatetestorder* = Call_ContentOrdersCreatetestorder_595564(
    name: "contentOrdersCreatetestorder", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/testorders",
    validator: validate_ContentOrdersCreatetestorder_595565, base: "/content/v2",
    url: url_ContentOrdersCreatetestorder_595566, schemes: {Scheme.Https})
type
  Call_ContentOrdersAdvancetestorder_595581 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersAdvancetestorder_595583(protocol: Scheme; host: string;
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

proc validate_ContentOrdersAdvancetestorder_595582(path: JsonNode; query: JsonNode;
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
  var valid_595584 = path.getOrDefault("orderId")
  valid_595584 = validateParameter(valid_595584, JString, required = true,
                                 default = nil)
  if valid_595584 != nil:
    section.add "orderId", valid_595584
  var valid_595585 = path.getOrDefault("merchantId")
  valid_595585 = validateParameter(valid_595585, JString, required = true,
                                 default = nil)
  if valid_595585 != nil:
    section.add "merchantId", valid_595585
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
  var valid_595586 = query.getOrDefault("fields")
  valid_595586 = validateParameter(valid_595586, JString, required = false,
                                 default = nil)
  if valid_595586 != nil:
    section.add "fields", valid_595586
  var valid_595587 = query.getOrDefault("quotaUser")
  valid_595587 = validateParameter(valid_595587, JString, required = false,
                                 default = nil)
  if valid_595587 != nil:
    section.add "quotaUser", valid_595587
  var valid_595588 = query.getOrDefault("alt")
  valid_595588 = validateParameter(valid_595588, JString, required = false,
                                 default = newJString("json"))
  if valid_595588 != nil:
    section.add "alt", valid_595588
  var valid_595589 = query.getOrDefault("oauth_token")
  valid_595589 = validateParameter(valid_595589, JString, required = false,
                                 default = nil)
  if valid_595589 != nil:
    section.add "oauth_token", valid_595589
  var valid_595590 = query.getOrDefault("userIp")
  valid_595590 = validateParameter(valid_595590, JString, required = false,
                                 default = nil)
  if valid_595590 != nil:
    section.add "userIp", valid_595590
  var valid_595591 = query.getOrDefault("key")
  valid_595591 = validateParameter(valid_595591, JString, required = false,
                                 default = nil)
  if valid_595591 != nil:
    section.add "key", valid_595591
  var valid_595592 = query.getOrDefault("prettyPrint")
  valid_595592 = validateParameter(valid_595592, JBool, required = false,
                                 default = newJBool(true))
  if valid_595592 != nil:
    section.add "prettyPrint", valid_595592
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595593: Call_ContentOrdersAdvancetestorder_595581; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Moves a test order from state "inProgress" to state "pendingShipment".
  ## 
  let valid = call_595593.validator(path, query, header, formData, body)
  let scheme = call_595593.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595593.url(scheme.get, call_595593.host, call_595593.base,
                         call_595593.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595593, url, valid)

proc call*(call_595594: Call_ContentOrdersAdvancetestorder_595581; orderId: string;
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
  var path_595595 = newJObject()
  var query_595596 = newJObject()
  add(query_595596, "fields", newJString(fields))
  add(query_595596, "quotaUser", newJString(quotaUser))
  add(query_595596, "alt", newJString(alt))
  add(query_595596, "oauth_token", newJString(oauthToken))
  add(query_595596, "userIp", newJString(userIp))
  add(path_595595, "orderId", newJString(orderId))
  add(query_595596, "key", newJString(key))
  add(path_595595, "merchantId", newJString(merchantId))
  add(query_595596, "prettyPrint", newJBool(prettyPrint))
  result = call_595594.call(path_595595, query_595596, nil, nil, nil)

var contentOrdersAdvancetestorder* = Call_ContentOrdersAdvancetestorder_595581(
    name: "contentOrdersAdvancetestorder", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/testorders/{orderId}/advance",
    validator: validate_ContentOrdersAdvancetestorder_595582, base: "/content/v2",
    url: url_ContentOrdersAdvancetestorder_595583, schemes: {Scheme.Https})
type
  Call_ContentOrdersCanceltestorderbycustomer_595597 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersCanceltestorderbycustomer_595599(protocol: Scheme;
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

proc validate_ContentOrdersCanceltestorderbycustomer_595598(path: JsonNode;
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
  var valid_595600 = path.getOrDefault("orderId")
  valid_595600 = validateParameter(valid_595600, JString, required = true,
                                 default = nil)
  if valid_595600 != nil:
    section.add "orderId", valid_595600
  var valid_595601 = path.getOrDefault("merchantId")
  valid_595601 = validateParameter(valid_595601, JString, required = true,
                                 default = nil)
  if valid_595601 != nil:
    section.add "merchantId", valid_595601
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
  var valid_595602 = query.getOrDefault("fields")
  valid_595602 = validateParameter(valid_595602, JString, required = false,
                                 default = nil)
  if valid_595602 != nil:
    section.add "fields", valid_595602
  var valid_595603 = query.getOrDefault("quotaUser")
  valid_595603 = validateParameter(valid_595603, JString, required = false,
                                 default = nil)
  if valid_595603 != nil:
    section.add "quotaUser", valid_595603
  var valid_595604 = query.getOrDefault("alt")
  valid_595604 = validateParameter(valid_595604, JString, required = false,
                                 default = newJString("json"))
  if valid_595604 != nil:
    section.add "alt", valid_595604
  var valid_595605 = query.getOrDefault("oauth_token")
  valid_595605 = validateParameter(valid_595605, JString, required = false,
                                 default = nil)
  if valid_595605 != nil:
    section.add "oauth_token", valid_595605
  var valid_595606 = query.getOrDefault("userIp")
  valid_595606 = validateParameter(valid_595606, JString, required = false,
                                 default = nil)
  if valid_595606 != nil:
    section.add "userIp", valid_595606
  var valid_595607 = query.getOrDefault("key")
  valid_595607 = validateParameter(valid_595607, JString, required = false,
                                 default = nil)
  if valid_595607 != nil:
    section.add "key", valid_595607
  var valid_595608 = query.getOrDefault("prettyPrint")
  valid_595608 = validateParameter(valid_595608, JBool, required = false,
                                 default = newJBool(true))
  if valid_595608 != nil:
    section.add "prettyPrint", valid_595608
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

proc call*(call_595610: Call_ContentOrdersCanceltestorderbycustomer_595597;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sandbox only. Cancels a test order for customer-initiated cancellation.
  ## 
  let valid = call_595610.validator(path, query, header, formData, body)
  let scheme = call_595610.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595610.url(scheme.get, call_595610.host, call_595610.base,
                         call_595610.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595610, url, valid)

proc call*(call_595611: Call_ContentOrdersCanceltestorderbycustomer_595597;
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
  var path_595612 = newJObject()
  var query_595613 = newJObject()
  var body_595614 = newJObject()
  add(query_595613, "fields", newJString(fields))
  add(query_595613, "quotaUser", newJString(quotaUser))
  add(query_595613, "alt", newJString(alt))
  add(query_595613, "oauth_token", newJString(oauthToken))
  add(query_595613, "userIp", newJString(userIp))
  add(path_595612, "orderId", newJString(orderId))
  add(query_595613, "key", newJString(key))
  add(path_595612, "merchantId", newJString(merchantId))
  if body != nil:
    body_595614 = body
  add(query_595613, "prettyPrint", newJBool(prettyPrint))
  result = call_595611.call(path_595612, query_595613, nil, nil, body_595614)

var contentOrdersCanceltestorderbycustomer* = Call_ContentOrdersCanceltestorderbycustomer_595597(
    name: "contentOrdersCanceltestorderbycustomer", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/testorders/{orderId}/cancelByCustomer",
    validator: validate_ContentOrdersCanceltestorderbycustomer_595598,
    base: "/content/v2", url: url_ContentOrdersCanceltestorderbycustomer_595599,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersGettestordertemplate_595615 = ref object of OpenApiRestCall_593421
proc url_ContentOrdersGettestordertemplate_595617(protocol: Scheme; host: string;
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

proc validate_ContentOrdersGettestordertemplate_595616(path: JsonNode;
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
  var valid_595618 = path.getOrDefault("templateName")
  valid_595618 = validateParameter(valid_595618, JString, required = true,
                                 default = newJString("template1"))
  if valid_595618 != nil:
    section.add "templateName", valid_595618
  var valid_595619 = path.getOrDefault("merchantId")
  valid_595619 = validateParameter(valid_595619, JString, required = true,
                                 default = nil)
  if valid_595619 != nil:
    section.add "merchantId", valid_595619
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
  var valid_595620 = query.getOrDefault("fields")
  valid_595620 = validateParameter(valid_595620, JString, required = false,
                                 default = nil)
  if valid_595620 != nil:
    section.add "fields", valid_595620
  var valid_595621 = query.getOrDefault("country")
  valid_595621 = validateParameter(valid_595621, JString, required = false,
                                 default = nil)
  if valid_595621 != nil:
    section.add "country", valid_595621
  var valid_595622 = query.getOrDefault("quotaUser")
  valid_595622 = validateParameter(valid_595622, JString, required = false,
                                 default = nil)
  if valid_595622 != nil:
    section.add "quotaUser", valid_595622
  var valid_595623 = query.getOrDefault("alt")
  valid_595623 = validateParameter(valid_595623, JString, required = false,
                                 default = newJString("json"))
  if valid_595623 != nil:
    section.add "alt", valid_595623
  var valid_595624 = query.getOrDefault("oauth_token")
  valid_595624 = validateParameter(valid_595624, JString, required = false,
                                 default = nil)
  if valid_595624 != nil:
    section.add "oauth_token", valid_595624
  var valid_595625 = query.getOrDefault("userIp")
  valid_595625 = validateParameter(valid_595625, JString, required = false,
                                 default = nil)
  if valid_595625 != nil:
    section.add "userIp", valid_595625
  var valid_595626 = query.getOrDefault("key")
  valid_595626 = validateParameter(valid_595626, JString, required = false,
                                 default = nil)
  if valid_595626 != nil:
    section.add "key", valid_595626
  var valid_595627 = query.getOrDefault("prettyPrint")
  valid_595627 = validateParameter(valid_595627, JBool, required = false,
                                 default = newJBool(true))
  if valid_595627 != nil:
    section.add "prettyPrint", valid_595627
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595628: Call_ContentOrdersGettestordertemplate_595615;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sandbox only. Retrieves an order template that can be used to quickly create a new order in sandbox.
  ## 
  let valid = call_595628.validator(path, query, header, formData, body)
  let scheme = call_595628.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595628.url(scheme.get, call_595628.host, call_595628.base,
                         call_595628.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595628, url, valid)

proc call*(call_595629: Call_ContentOrdersGettestordertemplate_595615;
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
  var path_595630 = newJObject()
  var query_595631 = newJObject()
  add(query_595631, "fields", newJString(fields))
  add(query_595631, "country", newJString(country))
  add(query_595631, "quotaUser", newJString(quotaUser))
  add(query_595631, "alt", newJString(alt))
  add(query_595631, "oauth_token", newJString(oauthToken))
  add(query_595631, "userIp", newJString(userIp))
  add(path_595630, "templateName", newJString(templateName))
  add(query_595631, "key", newJString(key))
  add(path_595630, "merchantId", newJString(merchantId))
  add(query_595631, "prettyPrint", newJBool(prettyPrint))
  result = call_595629.call(path_595630, query_595631, nil, nil, nil)

var contentOrdersGettestordertemplate* = Call_ContentOrdersGettestordertemplate_595615(
    name: "contentOrdersGettestordertemplate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/testordertemplates/{templateName}",
    validator: validate_ContentOrdersGettestordertemplate_595616,
    base: "/content/v2", url: url_ContentOrdersGettestordertemplate_595617,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
