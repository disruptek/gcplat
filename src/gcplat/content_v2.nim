
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

  OpenApiRestCall_588450 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588450](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588450): Option[Scheme] {.used.} =
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
  gcpServiceName = "content"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ContentAccountsAuthinfo_588718 = ref object of OpenApiRestCall_588450
proc url_ContentAccountsAuthinfo_588720(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentAccountsAuthinfo_588719(path: JsonNode; query: JsonNode;
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
  var valid_588832 = query.getOrDefault("fields")
  valid_588832 = validateParameter(valid_588832, JString, required = false,
                                 default = nil)
  if valid_588832 != nil:
    section.add "fields", valid_588832
  var valid_588833 = query.getOrDefault("quotaUser")
  valid_588833 = validateParameter(valid_588833, JString, required = false,
                                 default = nil)
  if valid_588833 != nil:
    section.add "quotaUser", valid_588833
  var valid_588847 = query.getOrDefault("alt")
  valid_588847 = validateParameter(valid_588847, JString, required = false,
                                 default = newJString("json"))
  if valid_588847 != nil:
    section.add "alt", valid_588847
  var valid_588848 = query.getOrDefault("oauth_token")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = nil)
  if valid_588848 != nil:
    section.add "oauth_token", valid_588848
  var valid_588849 = query.getOrDefault("userIp")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = nil)
  if valid_588849 != nil:
    section.add "userIp", valid_588849
  var valid_588850 = query.getOrDefault("key")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "key", valid_588850
  var valid_588851 = query.getOrDefault("prettyPrint")
  valid_588851 = validateParameter(valid_588851, JBool, required = false,
                                 default = newJBool(true))
  if valid_588851 != nil:
    section.add "prettyPrint", valid_588851
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588874: Call_ContentAccountsAuthinfo_588718; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about the authenticated user.
  ## 
  let valid = call_588874.validator(path, query, header, formData, body)
  let scheme = call_588874.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588874.url(scheme.get, call_588874.host, call_588874.base,
                         call_588874.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588874, url, valid)

proc call*(call_588945: Call_ContentAccountsAuthinfo_588718; fields: string = "";
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
  var query_588946 = newJObject()
  add(query_588946, "fields", newJString(fields))
  add(query_588946, "quotaUser", newJString(quotaUser))
  add(query_588946, "alt", newJString(alt))
  add(query_588946, "oauth_token", newJString(oauthToken))
  add(query_588946, "userIp", newJString(userIp))
  add(query_588946, "key", newJString(key))
  add(query_588946, "prettyPrint", newJBool(prettyPrint))
  result = call_588945.call(nil, query_588946, nil, nil, nil)

var contentAccountsAuthinfo* = Call_ContentAccountsAuthinfo_588718(
    name: "contentAccountsAuthinfo", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/authinfo",
    validator: validate_ContentAccountsAuthinfo_588719, base: "/content/v2",
    url: url_ContentAccountsAuthinfo_588720, schemes: {Scheme.Https})
type
  Call_ContentAccountsCustombatch_588986 = ref object of OpenApiRestCall_588450
proc url_ContentAccountsCustombatch_588988(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentAccountsCustombatch_588987(path: JsonNode; query: JsonNode;
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
  var valid_588989 = query.getOrDefault("fields")
  valid_588989 = validateParameter(valid_588989, JString, required = false,
                                 default = nil)
  if valid_588989 != nil:
    section.add "fields", valid_588989
  var valid_588990 = query.getOrDefault("quotaUser")
  valid_588990 = validateParameter(valid_588990, JString, required = false,
                                 default = nil)
  if valid_588990 != nil:
    section.add "quotaUser", valid_588990
  var valid_588991 = query.getOrDefault("alt")
  valid_588991 = validateParameter(valid_588991, JString, required = false,
                                 default = newJString("json"))
  if valid_588991 != nil:
    section.add "alt", valid_588991
  var valid_588992 = query.getOrDefault("dryRun")
  valid_588992 = validateParameter(valid_588992, JBool, required = false, default = nil)
  if valid_588992 != nil:
    section.add "dryRun", valid_588992
  var valid_588993 = query.getOrDefault("oauth_token")
  valid_588993 = validateParameter(valid_588993, JString, required = false,
                                 default = nil)
  if valid_588993 != nil:
    section.add "oauth_token", valid_588993
  var valid_588994 = query.getOrDefault("userIp")
  valid_588994 = validateParameter(valid_588994, JString, required = false,
                                 default = nil)
  if valid_588994 != nil:
    section.add "userIp", valid_588994
  var valid_588995 = query.getOrDefault("key")
  valid_588995 = validateParameter(valid_588995, JString, required = false,
                                 default = nil)
  if valid_588995 != nil:
    section.add "key", valid_588995
  var valid_588996 = query.getOrDefault("prettyPrint")
  valid_588996 = validateParameter(valid_588996, JBool, required = false,
                                 default = newJBool(true))
  if valid_588996 != nil:
    section.add "prettyPrint", valid_588996
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

proc call*(call_588998: Call_ContentAccountsCustombatch_588986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves, inserts, updates, and deletes multiple Merchant Center (sub-)accounts in a single request.
  ## 
  let valid = call_588998.validator(path, query, header, formData, body)
  let scheme = call_588998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588998.url(scheme.get, call_588998.host, call_588998.base,
                         call_588998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588998, url, valid)

proc call*(call_588999: Call_ContentAccountsCustombatch_588986;
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
  var query_589000 = newJObject()
  var body_589001 = newJObject()
  add(query_589000, "fields", newJString(fields))
  add(query_589000, "quotaUser", newJString(quotaUser))
  add(query_589000, "alt", newJString(alt))
  add(query_589000, "dryRun", newJBool(dryRun))
  add(query_589000, "oauth_token", newJString(oauthToken))
  add(query_589000, "userIp", newJString(userIp))
  add(query_589000, "key", newJString(key))
  if body != nil:
    body_589001 = body
  add(query_589000, "prettyPrint", newJBool(prettyPrint))
  result = call_588999.call(nil, query_589000, nil, nil, body_589001)

var contentAccountsCustombatch* = Call_ContentAccountsCustombatch_588986(
    name: "contentAccountsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accounts/batch",
    validator: validate_ContentAccountsCustombatch_588987, base: "/content/v2",
    url: url_ContentAccountsCustombatch_588988, schemes: {Scheme.Https})
type
  Call_ContentAccountstatusesCustombatch_589002 = ref object of OpenApiRestCall_588450
proc url_ContentAccountstatusesCustombatch_589004(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentAccountstatusesCustombatch_589003(path: JsonNode;
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
  var valid_589005 = query.getOrDefault("fields")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "fields", valid_589005
  var valid_589006 = query.getOrDefault("quotaUser")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "quotaUser", valid_589006
  var valid_589007 = query.getOrDefault("alt")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = newJString("json"))
  if valid_589007 != nil:
    section.add "alt", valid_589007
  var valid_589008 = query.getOrDefault("oauth_token")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "oauth_token", valid_589008
  var valid_589009 = query.getOrDefault("userIp")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "userIp", valid_589009
  var valid_589010 = query.getOrDefault("key")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "key", valid_589010
  var valid_589011 = query.getOrDefault("prettyPrint")
  valid_589011 = validateParameter(valid_589011, JBool, required = false,
                                 default = newJBool(true))
  if valid_589011 != nil:
    section.add "prettyPrint", valid_589011
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

proc call*(call_589013: Call_ContentAccountstatusesCustombatch_589002;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves multiple Merchant Center account statuses in a single request.
  ## 
  let valid = call_589013.validator(path, query, header, formData, body)
  let scheme = call_589013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589013.url(scheme.get, call_589013.host, call_589013.base,
                         call_589013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589013, url, valid)

proc call*(call_589014: Call_ContentAccountstatusesCustombatch_589002;
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
  var query_589015 = newJObject()
  var body_589016 = newJObject()
  add(query_589015, "fields", newJString(fields))
  add(query_589015, "quotaUser", newJString(quotaUser))
  add(query_589015, "alt", newJString(alt))
  add(query_589015, "oauth_token", newJString(oauthToken))
  add(query_589015, "userIp", newJString(userIp))
  add(query_589015, "key", newJString(key))
  if body != nil:
    body_589016 = body
  add(query_589015, "prettyPrint", newJBool(prettyPrint))
  result = call_589014.call(nil, query_589015, nil, nil, body_589016)

var contentAccountstatusesCustombatch* = Call_ContentAccountstatusesCustombatch_589002(
    name: "contentAccountstatusesCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accountstatuses/batch",
    validator: validate_ContentAccountstatusesCustombatch_589003,
    base: "/content/v2", url: url_ContentAccountstatusesCustombatch_589004,
    schemes: {Scheme.Https})
type
  Call_ContentAccounttaxCustombatch_589017 = ref object of OpenApiRestCall_588450
proc url_ContentAccounttaxCustombatch_589019(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentAccounttaxCustombatch_589018(path: JsonNode; query: JsonNode;
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
  var valid_589020 = query.getOrDefault("fields")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "fields", valid_589020
  var valid_589021 = query.getOrDefault("quotaUser")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "quotaUser", valid_589021
  var valid_589022 = query.getOrDefault("alt")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = newJString("json"))
  if valid_589022 != nil:
    section.add "alt", valid_589022
  var valid_589023 = query.getOrDefault("dryRun")
  valid_589023 = validateParameter(valid_589023, JBool, required = false, default = nil)
  if valid_589023 != nil:
    section.add "dryRun", valid_589023
  var valid_589024 = query.getOrDefault("oauth_token")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "oauth_token", valid_589024
  var valid_589025 = query.getOrDefault("userIp")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "userIp", valid_589025
  var valid_589026 = query.getOrDefault("key")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "key", valid_589026
  var valid_589027 = query.getOrDefault("prettyPrint")
  valid_589027 = validateParameter(valid_589027, JBool, required = false,
                                 default = newJBool(true))
  if valid_589027 != nil:
    section.add "prettyPrint", valid_589027
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

proc call*(call_589029: Call_ContentAccounttaxCustombatch_589017; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves and updates tax settings of multiple accounts in a single request.
  ## 
  let valid = call_589029.validator(path, query, header, formData, body)
  let scheme = call_589029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589029.url(scheme.get, call_589029.host, call_589029.base,
                         call_589029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589029, url, valid)

proc call*(call_589030: Call_ContentAccounttaxCustombatch_589017;
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
  var query_589031 = newJObject()
  var body_589032 = newJObject()
  add(query_589031, "fields", newJString(fields))
  add(query_589031, "quotaUser", newJString(quotaUser))
  add(query_589031, "alt", newJString(alt))
  add(query_589031, "dryRun", newJBool(dryRun))
  add(query_589031, "oauth_token", newJString(oauthToken))
  add(query_589031, "userIp", newJString(userIp))
  add(query_589031, "key", newJString(key))
  if body != nil:
    body_589032 = body
  add(query_589031, "prettyPrint", newJBool(prettyPrint))
  result = call_589030.call(nil, query_589031, nil, nil, body_589032)

var contentAccounttaxCustombatch* = Call_ContentAccounttaxCustombatch_589017(
    name: "contentAccounttaxCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accounttax/batch",
    validator: validate_ContentAccounttaxCustombatch_589018, base: "/content/v2",
    url: url_ContentAccounttaxCustombatch_589019, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsCustombatch_589033 = ref object of OpenApiRestCall_588450
proc url_ContentDatafeedsCustombatch_589035(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentDatafeedsCustombatch_589034(path: JsonNode; query: JsonNode;
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
  var valid_589036 = query.getOrDefault("fields")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "fields", valid_589036
  var valid_589037 = query.getOrDefault("quotaUser")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "quotaUser", valid_589037
  var valid_589038 = query.getOrDefault("alt")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = newJString("json"))
  if valid_589038 != nil:
    section.add "alt", valid_589038
  var valid_589039 = query.getOrDefault("dryRun")
  valid_589039 = validateParameter(valid_589039, JBool, required = false, default = nil)
  if valid_589039 != nil:
    section.add "dryRun", valid_589039
  var valid_589040 = query.getOrDefault("oauth_token")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "oauth_token", valid_589040
  var valid_589041 = query.getOrDefault("userIp")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "userIp", valid_589041
  var valid_589042 = query.getOrDefault("key")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "key", valid_589042
  var valid_589043 = query.getOrDefault("prettyPrint")
  valid_589043 = validateParameter(valid_589043, JBool, required = false,
                                 default = newJBool(true))
  if valid_589043 != nil:
    section.add "prettyPrint", valid_589043
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

proc call*(call_589045: Call_ContentDatafeedsCustombatch_589033; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes, fetches, gets, inserts and updates multiple datafeeds in a single request.
  ## 
  let valid = call_589045.validator(path, query, header, formData, body)
  let scheme = call_589045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589045.url(scheme.get, call_589045.host, call_589045.base,
                         call_589045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589045, url, valid)

proc call*(call_589046: Call_ContentDatafeedsCustombatch_589033;
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
  var query_589047 = newJObject()
  var body_589048 = newJObject()
  add(query_589047, "fields", newJString(fields))
  add(query_589047, "quotaUser", newJString(quotaUser))
  add(query_589047, "alt", newJString(alt))
  add(query_589047, "dryRun", newJBool(dryRun))
  add(query_589047, "oauth_token", newJString(oauthToken))
  add(query_589047, "userIp", newJString(userIp))
  add(query_589047, "key", newJString(key))
  if body != nil:
    body_589048 = body
  add(query_589047, "prettyPrint", newJBool(prettyPrint))
  result = call_589046.call(nil, query_589047, nil, nil, body_589048)

var contentDatafeedsCustombatch* = Call_ContentDatafeedsCustombatch_589033(
    name: "contentDatafeedsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/datafeeds/batch",
    validator: validate_ContentDatafeedsCustombatch_589034, base: "/content/v2",
    url: url_ContentDatafeedsCustombatch_589035, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesCustombatch_589049 = ref object of OpenApiRestCall_588450
proc url_ContentDatafeedstatusesCustombatch_589051(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentDatafeedstatusesCustombatch_589050(path: JsonNode;
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
  var valid_589052 = query.getOrDefault("fields")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "fields", valid_589052
  var valid_589053 = query.getOrDefault("quotaUser")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "quotaUser", valid_589053
  var valid_589054 = query.getOrDefault("alt")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = newJString("json"))
  if valid_589054 != nil:
    section.add "alt", valid_589054
  var valid_589055 = query.getOrDefault("oauth_token")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "oauth_token", valid_589055
  var valid_589056 = query.getOrDefault("userIp")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "userIp", valid_589056
  var valid_589057 = query.getOrDefault("key")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "key", valid_589057
  var valid_589058 = query.getOrDefault("prettyPrint")
  valid_589058 = validateParameter(valid_589058, JBool, required = false,
                                 default = newJBool(true))
  if valid_589058 != nil:
    section.add "prettyPrint", valid_589058
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

proc call*(call_589060: Call_ContentDatafeedstatusesCustombatch_589049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets multiple Merchant Center datafeed statuses in a single request.
  ## 
  let valid = call_589060.validator(path, query, header, formData, body)
  let scheme = call_589060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589060.url(scheme.get, call_589060.host, call_589060.base,
                         call_589060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589060, url, valid)

proc call*(call_589061: Call_ContentDatafeedstatusesCustombatch_589049;
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
  var query_589062 = newJObject()
  var body_589063 = newJObject()
  add(query_589062, "fields", newJString(fields))
  add(query_589062, "quotaUser", newJString(quotaUser))
  add(query_589062, "alt", newJString(alt))
  add(query_589062, "oauth_token", newJString(oauthToken))
  add(query_589062, "userIp", newJString(userIp))
  add(query_589062, "key", newJString(key))
  if body != nil:
    body_589063 = body
  add(query_589062, "prettyPrint", newJBool(prettyPrint))
  result = call_589061.call(nil, query_589062, nil, nil, body_589063)

var contentDatafeedstatusesCustombatch* = Call_ContentDatafeedstatusesCustombatch_589049(
    name: "contentDatafeedstatusesCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/datafeedstatuses/batch",
    validator: validate_ContentDatafeedstatusesCustombatch_589050,
    base: "/content/v2", url: url_ContentDatafeedstatusesCustombatch_589051,
    schemes: {Scheme.Https})
type
  Call_ContentInventoryCustombatch_589064 = ref object of OpenApiRestCall_588450
proc url_ContentInventoryCustombatch_589066(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentInventoryCustombatch_589065(path: JsonNode; query: JsonNode;
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
  var valid_589067 = query.getOrDefault("fields")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "fields", valid_589067
  var valid_589068 = query.getOrDefault("quotaUser")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "quotaUser", valid_589068
  var valid_589069 = query.getOrDefault("alt")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = newJString("json"))
  if valid_589069 != nil:
    section.add "alt", valid_589069
  var valid_589070 = query.getOrDefault("dryRun")
  valid_589070 = validateParameter(valid_589070, JBool, required = false, default = nil)
  if valid_589070 != nil:
    section.add "dryRun", valid_589070
  var valid_589071 = query.getOrDefault("oauth_token")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "oauth_token", valid_589071
  var valid_589072 = query.getOrDefault("userIp")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "userIp", valid_589072
  var valid_589073 = query.getOrDefault("key")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "key", valid_589073
  var valid_589074 = query.getOrDefault("prettyPrint")
  valid_589074 = validateParameter(valid_589074, JBool, required = false,
                                 default = newJBool(true))
  if valid_589074 != nil:
    section.add "prettyPrint", valid_589074
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

proc call*(call_589076: Call_ContentInventoryCustombatch_589064; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates price and availability for multiple products or stores in a single request. This operation does not update the expiration date of the products.
  ## 
  let valid = call_589076.validator(path, query, header, formData, body)
  let scheme = call_589076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589076.url(scheme.get, call_589076.host, call_589076.base,
                         call_589076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589076, url, valid)

proc call*(call_589077: Call_ContentInventoryCustombatch_589064;
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
  var query_589078 = newJObject()
  var body_589079 = newJObject()
  add(query_589078, "fields", newJString(fields))
  add(query_589078, "quotaUser", newJString(quotaUser))
  add(query_589078, "alt", newJString(alt))
  add(query_589078, "dryRun", newJBool(dryRun))
  add(query_589078, "oauth_token", newJString(oauthToken))
  add(query_589078, "userIp", newJString(userIp))
  add(query_589078, "key", newJString(key))
  if body != nil:
    body_589079 = body
  add(query_589078, "prettyPrint", newJBool(prettyPrint))
  result = call_589077.call(nil, query_589078, nil, nil, body_589079)

var contentInventoryCustombatch* = Call_ContentInventoryCustombatch_589064(
    name: "contentInventoryCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/inventory/batch",
    validator: validate_ContentInventoryCustombatch_589065, base: "/content/v2",
    url: url_ContentInventoryCustombatch_589066, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsCustombatch_589080 = ref object of OpenApiRestCall_588450
proc url_ContentLiasettingsCustombatch_589082(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentLiasettingsCustombatch_589081(path: JsonNode; query: JsonNode;
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
  var valid_589083 = query.getOrDefault("fields")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "fields", valid_589083
  var valid_589084 = query.getOrDefault("quotaUser")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "quotaUser", valid_589084
  var valid_589085 = query.getOrDefault("alt")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = newJString("json"))
  if valid_589085 != nil:
    section.add "alt", valid_589085
  var valid_589086 = query.getOrDefault("dryRun")
  valid_589086 = validateParameter(valid_589086, JBool, required = false, default = nil)
  if valid_589086 != nil:
    section.add "dryRun", valid_589086
  var valid_589087 = query.getOrDefault("oauth_token")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "oauth_token", valid_589087
  var valid_589088 = query.getOrDefault("userIp")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "userIp", valid_589088
  var valid_589089 = query.getOrDefault("key")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "key", valid_589089
  var valid_589090 = query.getOrDefault("prettyPrint")
  valid_589090 = validateParameter(valid_589090, JBool, required = false,
                                 default = newJBool(true))
  if valid_589090 != nil:
    section.add "prettyPrint", valid_589090
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

proc call*(call_589092: Call_ContentLiasettingsCustombatch_589080; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves and/or updates the LIA settings of multiple accounts in a single request.
  ## 
  let valid = call_589092.validator(path, query, header, formData, body)
  let scheme = call_589092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589092.url(scheme.get, call_589092.host, call_589092.base,
                         call_589092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589092, url, valid)

proc call*(call_589093: Call_ContentLiasettingsCustombatch_589080;
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
  var query_589094 = newJObject()
  var body_589095 = newJObject()
  add(query_589094, "fields", newJString(fields))
  add(query_589094, "quotaUser", newJString(quotaUser))
  add(query_589094, "alt", newJString(alt))
  add(query_589094, "dryRun", newJBool(dryRun))
  add(query_589094, "oauth_token", newJString(oauthToken))
  add(query_589094, "userIp", newJString(userIp))
  add(query_589094, "key", newJString(key))
  if body != nil:
    body_589095 = body
  add(query_589094, "prettyPrint", newJBool(prettyPrint))
  result = call_589093.call(nil, query_589094, nil, nil, body_589095)

var contentLiasettingsCustombatch* = Call_ContentLiasettingsCustombatch_589080(
    name: "contentLiasettingsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liasettings/batch",
    validator: validate_ContentLiasettingsCustombatch_589081, base: "/content/v2",
    url: url_ContentLiasettingsCustombatch_589082, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsListposdataproviders_589096 = ref object of OpenApiRestCall_588450
proc url_ContentLiasettingsListposdataproviders_589098(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentLiasettingsListposdataproviders_589097(path: JsonNode;
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
  var valid_589099 = query.getOrDefault("fields")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "fields", valid_589099
  var valid_589100 = query.getOrDefault("quotaUser")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "quotaUser", valid_589100
  var valid_589101 = query.getOrDefault("alt")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = newJString("json"))
  if valid_589101 != nil:
    section.add "alt", valid_589101
  var valid_589102 = query.getOrDefault("oauth_token")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "oauth_token", valid_589102
  var valid_589103 = query.getOrDefault("userIp")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "userIp", valid_589103
  var valid_589104 = query.getOrDefault("key")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "key", valid_589104
  var valid_589105 = query.getOrDefault("prettyPrint")
  valid_589105 = validateParameter(valid_589105, JBool, required = false,
                                 default = newJBool(true))
  if valid_589105 != nil:
    section.add "prettyPrint", valid_589105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589106: Call_ContentLiasettingsListposdataproviders_589096;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of POS data providers that have active settings for the all eiligible countries.
  ## 
  let valid = call_589106.validator(path, query, header, formData, body)
  let scheme = call_589106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589106.url(scheme.get, call_589106.host, call_589106.base,
                         call_589106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589106, url, valid)

proc call*(call_589107: Call_ContentLiasettingsListposdataproviders_589096;
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
  var query_589108 = newJObject()
  add(query_589108, "fields", newJString(fields))
  add(query_589108, "quotaUser", newJString(quotaUser))
  add(query_589108, "alt", newJString(alt))
  add(query_589108, "oauth_token", newJString(oauthToken))
  add(query_589108, "userIp", newJString(userIp))
  add(query_589108, "key", newJString(key))
  add(query_589108, "prettyPrint", newJBool(prettyPrint))
  result = call_589107.call(nil, query_589108, nil, nil, nil)

var contentLiasettingsListposdataproviders* = Call_ContentLiasettingsListposdataproviders_589096(
    name: "contentLiasettingsListposdataproviders", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/liasettings/posdataproviders",
    validator: validate_ContentLiasettingsListposdataproviders_589097,
    base: "/content/v2", url: url_ContentLiasettingsListposdataproviders_589098,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersCustombatch_589109 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersCustombatch_589111(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentOrdersCustombatch_589110(path: JsonNode; query: JsonNode;
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
  var valid_589112 = query.getOrDefault("fields")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "fields", valid_589112
  var valid_589113 = query.getOrDefault("quotaUser")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "quotaUser", valid_589113
  var valid_589114 = query.getOrDefault("alt")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = newJString("json"))
  if valid_589114 != nil:
    section.add "alt", valid_589114
  var valid_589115 = query.getOrDefault("oauth_token")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "oauth_token", valid_589115
  var valid_589116 = query.getOrDefault("userIp")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "userIp", valid_589116
  var valid_589117 = query.getOrDefault("key")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "key", valid_589117
  var valid_589118 = query.getOrDefault("prettyPrint")
  valid_589118 = validateParameter(valid_589118, JBool, required = false,
                                 default = newJBool(true))
  if valid_589118 != nil:
    section.add "prettyPrint", valid_589118
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

proc call*(call_589120: Call_ContentOrdersCustombatch_589109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves or modifies multiple orders in a single request.
  ## 
  let valid = call_589120.validator(path, query, header, formData, body)
  let scheme = call_589120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589120.url(scheme.get, call_589120.host, call_589120.base,
                         call_589120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589120, url, valid)

proc call*(call_589121: Call_ContentOrdersCustombatch_589109; fields: string = "";
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
  var query_589122 = newJObject()
  var body_589123 = newJObject()
  add(query_589122, "fields", newJString(fields))
  add(query_589122, "quotaUser", newJString(quotaUser))
  add(query_589122, "alt", newJString(alt))
  add(query_589122, "oauth_token", newJString(oauthToken))
  add(query_589122, "userIp", newJString(userIp))
  add(query_589122, "key", newJString(key))
  if body != nil:
    body_589123 = body
  add(query_589122, "prettyPrint", newJBool(prettyPrint))
  result = call_589121.call(nil, query_589122, nil, nil, body_589123)

var contentOrdersCustombatch* = Call_ContentOrdersCustombatch_589109(
    name: "contentOrdersCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/orders/batch",
    validator: validate_ContentOrdersCustombatch_589110, base: "/content/v2",
    url: url_ContentOrdersCustombatch_589111, schemes: {Scheme.Https})
type
  Call_ContentPosCustombatch_589124 = ref object of OpenApiRestCall_588450
proc url_ContentPosCustombatch_589126(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentPosCustombatch_589125(path: JsonNode; query: JsonNode;
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
  var valid_589127 = query.getOrDefault("fields")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "fields", valid_589127
  var valid_589128 = query.getOrDefault("quotaUser")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "quotaUser", valid_589128
  var valid_589129 = query.getOrDefault("alt")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = newJString("json"))
  if valid_589129 != nil:
    section.add "alt", valid_589129
  var valid_589130 = query.getOrDefault("dryRun")
  valid_589130 = validateParameter(valid_589130, JBool, required = false, default = nil)
  if valid_589130 != nil:
    section.add "dryRun", valid_589130
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

proc call*(call_589136: Call_ContentPosCustombatch_589124; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Batches multiple POS-related calls in a single request.
  ## 
  let valid = call_589136.validator(path, query, header, formData, body)
  let scheme = call_589136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589136.url(scheme.get, call_589136.host, call_589136.base,
                         call_589136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589136, url, valid)

proc call*(call_589137: Call_ContentPosCustombatch_589124; fields: string = "";
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
  var query_589138 = newJObject()
  var body_589139 = newJObject()
  add(query_589138, "fields", newJString(fields))
  add(query_589138, "quotaUser", newJString(quotaUser))
  add(query_589138, "alt", newJString(alt))
  add(query_589138, "dryRun", newJBool(dryRun))
  add(query_589138, "oauth_token", newJString(oauthToken))
  add(query_589138, "userIp", newJString(userIp))
  add(query_589138, "key", newJString(key))
  if body != nil:
    body_589139 = body
  add(query_589138, "prettyPrint", newJBool(prettyPrint))
  result = call_589137.call(nil, query_589138, nil, nil, body_589139)

var contentPosCustombatch* = Call_ContentPosCustombatch_589124(
    name: "contentPosCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/pos/batch",
    validator: validate_ContentPosCustombatch_589125, base: "/content/v2",
    url: url_ContentPosCustombatch_589126, schemes: {Scheme.Https})
type
  Call_ContentProductsCustombatch_589140 = ref object of OpenApiRestCall_588450
proc url_ContentProductsCustombatch_589142(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentProductsCustombatch_589141(path: JsonNode; query: JsonNode;
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
  var valid_589146 = query.getOrDefault("dryRun")
  valid_589146 = validateParameter(valid_589146, JBool, required = false, default = nil)
  if valid_589146 != nil:
    section.add "dryRun", valid_589146
  var valid_589147 = query.getOrDefault("oauth_token")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "oauth_token", valid_589147
  var valid_589148 = query.getOrDefault("userIp")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "userIp", valid_589148
  var valid_589149 = query.getOrDefault("key")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "key", valid_589149
  var valid_589150 = query.getOrDefault("prettyPrint")
  valid_589150 = validateParameter(valid_589150, JBool, required = false,
                                 default = newJBool(true))
  if valid_589150 != nil:
    section.add "prettyPrint", valid_589150
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

proc call*(call_589152: Call_ContentProductsCustombatch_589140; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves, inserts, and deletes multiple products in a single request.
  ## 
  let valid = call_589152.validator(path, query, header, formData, body)
  let scheme = call_589152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589152.url(scheme.get, call_589152.host, call_589152.base,
                         call_589152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589152, url, valid)

proc call*(call_589153: Call_ContentProductsCustombatch_589140;
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
  var query_589154 = newJObject()
  var body_589155 = newJObject()
  add(query_589154, "fields", newJString(fields))
  add(query_589154, "quotaUser", newJString(quotaUser))
  add(query_589154, "alt", newJString(alt))
  add(query_589154, "dryRun", newJBool(dryRun))
  add(query_589154, "oauth_token", newJString(oauthToken))
  add(query_589154, "userIp", newJString(userIp))
  add(query_589154, "key", newJString(key))
  if body != nil:
    body_589155 = body
  add(query_589154, "prettyPrint", newJBool(prettyPrint))
  result = call_589153.call(nil, query_589154, nil, nil, body_589155)

var contentProductsCustombatch* = Call_ContentProductsCustombatch_589140(
    name: "contentProductsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/products/batch",
    validator: validate_ContentProductsCustombatch_589141, base: "/content/v2",
    url: url_ContentProductsCustombatch_589142, schemes: {Scheme.Https})
type
  Call_ContentProductstatusesCustombatch_589156 = ref object of OpenApiRestCall_588450
proc url_ContentProductstatusesCustombatch_589158(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentProductstatusesCustombatch_589157(path: JsonNode;
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
  var valid_589159 = query.getOrDefault("fields")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "fields", valid_589159
  var valid_589160 = query.getOrDefault("quotaUser")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "quotaUser", valid_589160
  var valid_589161 = query.getOrDefault("alt")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = newJString("json"))
  if valid_589161 != nil:
    section.add "alt", valid_589161
  var valid_589162 = query.getOrDefault("oauth_token")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "oauth_token", valid_589162
  var valid_589163 = query.getOrDefault("userIp")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "userIp", valid_589163
  var valid_589164 = query.getOrDefault("includeAttributes")
  valid_589164 = validateParameter(valid_589164, JBool, required = false, default = nil)
  if valid_589164 != nil:
    section.add "includeAttributes", valid_589164
  var valid_589165 = query.getOrDefault("key")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "key", valid_589165
  var valid_589166 = query.getOrDefault("prettyPrint")
  valid_589166 = validateParameter(valid_589166, JBool, required = false,
                                 default = newJBool(true))
  if valid_589166 != nil:
    section.add "prettyPrint", valid_589166
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

proc call*(call_589168: Call_ContentProductstatusesCustombatch_589156;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the statuses of multiple products in a single request.
  ## 
  let valid = call_589168.validator(path, query, header, formData, body)
  let scheme = call_589168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589168.url(scheme.get, call_589168.host, call_589168.base,
                         call_589168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589168, url, valid)

proc call*(call_589169: Call_ContentProductstatusesCustombatch_589156;
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
  var query_589170 = newJObject()
  var body_589171 = newJObject()
  add(query_589170, "fields", newJString(fields))
  add(query_589170, "quotaUser", newJString(quotaUser))
  add(query_589170, "alt", newJString(alt))
  add(query_589170, "oauth_token", newJString(oauthToken))
  add(query_589170, "userIp", newJString(userIp))
  add(query_589170, "includeAttributes", newJBool(includeAttributes))
  add(query_589170, "key", newJString(key))
  if body != nil:
    body_589171 = body
  add(query_589170, "prettyPrint", newJBool(prettyPrint))
  result = call_589169.call(nil, query_589170, nil, nil, body_589171)

var contentProductstatusesCustombatch* = Call_ContentProductstatusesCustombatch_589156(
    name: "contentProductstatusesCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/productstatuses/batch",
    validator: validate_ContentProductstatusesCustombatch_589157,
    base: "/content/v2", url: url_ContentProductstatusesCustombatch_589158,
    schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsCustombatch_589172 = ref object of OpenApiRestCall_588450
proc url_ContentShippingsettingsCustombatch_589174(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentShippingsettingsCustombatch_589173(path: JsonNode;
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
  var valid_589175 = query.getOrDefault("fields")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "fields", valid_589175
  var valid_589176 = query.getOrDefault("quotaUser")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "quotaUser", valid_589176
  var valid_589177 = query.getOrDefault("alt")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = newJString("json"))
  if valid_589177 != nil:
    section.add "alt", valid_589177
  var valid_589178 = query.getOrDefault("dryRun")
  valid_589178 = validateParameter(valid_589178, JBool, required = false, default = nil)
  if valid_589178 != nil:
    section.add "dryRun", valid_589178
  var valid_589179 = query.getOrDefault("oauth_token")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "oauth_token", valid_589179
  var valid_589180 = query.getOrDefault("userIp")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "userIp", valid_589180
  var valid_589181 = query.getOrDefault("key")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "key", valid_589181
  var valid_589182 = query.getOrDefault("prettyPrint")
  valid_589182 = validateParameter(valid_589182, JBool, required = false,
                                 default = newJBool(true))
  if valid_589182 != nil:
    section.add "prettyPrint", valid_589182
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

proc call*(call_589184: Call_ContentShippingsettingsCustombatch_589172;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves and updates the shipping settings of multiple accounts in a single request.
  ## 
  let valid = call_589184.validator(path, query, header, formData, body)
  let scheme = call_589184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589184.url(scheme.get, call_589184.host, call_589184.base,
                         call_589184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589184, url, valid)

proc call*(call_589185: Call_ContentShippingsettingsCustombatch_589172;
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
  var query_589186 = newJObject()
  var body_589187 = newJObject()
  add(query_589186, "fields", newJString(fields))
  add(query_589186, "quotaUser", newJString(quotaUser))
  add(query_589186, "alt", newJString(alt))
  add(query_589186, "dryRun", newJBool(dryRun))
  add(query_589186, "oauth_token", newJString(oauthToken))
  add(query_589186, "userIp", newJString(userIp))
  add(query_589186, "key", newJString(key))
  if body != nil:
    body_589187 = body
  add(query_589186, "prettyPrint", newJBool(prettyPrint))
  result = call_589185.call(nil, query_589186, nil, nil, body_589187)

var contentShippingsettingsCustombatch* = Call_ContentShippingsettingsCustombatch_589172(
    name: "contentShippingsettingsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/shippingsettings/batch",
    validator: validate_ContentShippingsettingsCustombatch_589173,
    base: "/content/v2", url: url_ContentShippingsettingsCustombatch_589174,
    schemes: {Scheme.Https})
type
  Call_ContentAccountsInsert_589219 = ref object of OpenApiRestCall_588450
proc url_ContentAccountsInsert_589221(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsInsert_589220(path: JsonNode; query: JsonNode;
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
  var valid_589222 = path.getOrDefault("merchantId")
  valid_589222 = validateParameter(valid_589222, JString, required = true,
                                 default = nil)
  if valid_589222 != nil:
    section.add "merchantId", valid_589222
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
  var valid_589223 = query.getOrDefault("fields")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "fields", valid_589223
  var valid_589224 = query.getOrDefault("quotaUser")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "quotaUser", valid_589224
  var valid_589225 = query.getOrDefault("alt")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = newJString("json"))
  if valid_589225 != nil:
    section.add "alt", valid_589225
  var valid_589226 = query.getOrDefault("dryRun")
  valid_589226 = validateParameter(valid_589226, JBool, required = false, default = nil)
  if valid_589226 != nil:
    section.add "dryRun", valid_589226
  var valid_589227 = query.getOrDefault("oauth_token")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "oauth_token", valid_589227
  var valid_589228 = query.getOrDefault("userIp")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "userIp", valid_589228
  var valid_589229 = query.getOrDefault("key")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = nil)
  if valid_589229 != nil:
    section.add "key", valid_589229
  var valid_589230 = query.getOrDefault("prettyPrint")
  valid_589230 = validateParameter(valid_589230, JBool, required = false,
                                 default = newJBool(true))
  if valid_589230 != nil:
    section.add "prettyPrint", valid_589230
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

proc call*(call_589232: Call_ContentAccountsInsert_589219; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Merchant Center sub-account.
  ## 
  let valid = call_589232.validator(path, query, header, formData, body)
  let scheme = call_589232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589232.url(scheme.get, call_589232.host, call_589232.base,
                         call_589232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589232, url, valid)

proc call*(call_589233: Call_ContentAccountsInsert_589219; merchantId: string;
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
  var path_589234 = newJObject()
  var query_589235 = newJObject()
  var body_589236 = newJObject()
  add(query_589235, "fields", newJString(fields))
  add(query_589235, "quotaUser", newJString(quotaUser))
  add(query_589235, "alt", newJString(alt))
  add(query_589235, "dryRun", newJBool(dryRun))
  add(query_589235, "oauth_token", newJString(oauthToken))
  add(query_589235, "userIp", newJString(userIp))
  add(query_589235, "key", newJString(key))
  add(path_589234, "merchantId", newJString(merchantId))
  if body != nil:
    body_589236 = body
  add(query_589235, "prettyPrint", newJBool(prettyPrint))
  result = call_589233.call(path_589234, query_589235, nil, nil, body_589236)

var contentAccountsInsert* = Call_ContentAccountsInsert_589219(
    name: "contentAccountsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/accounts",
    validator: validate_ContentAccountsInsert_589220, base: "/content/v2",
    url: url_ContentAccountsInsert_589221, schemes: {Scheme.Https})
type
  Call_ContentAccountsList_589188 = ref object of OpenApiRestCall_588450
proc url_ContentAccountsList_589190(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsList_589189(path: JsonNode; query: JsonNode;
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
  var valid_589205 = path.getOrDefault("merchantId")
  valid_589205 = validateParameter(valid_589205, JString, required = true,
                                 default = nil)
  if valid_589205 != nil:
    section.add "merchantId", valid_589205
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
  var valid_589206 = query.getOrDefault("fields")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "fields", valid_589206
  var valid_589207 = query.getOrDefault("pageToken")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "pageToken", valid_589207
  var valid_589208 = query.getOrDefault("quotaUser")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "quotaUser", valid_589208
  var valid_589209 = query.getOrDefault("alt")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = newJString("json"))
  if valid_589209 != nil:
    section.add "alt", valid_589209
  var valid_589210 = query.getOrDefault("oauth_token")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "oauth_token", valid_589210
  var valid_589211 = query.getOrDefault("userIp")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "userIp", valid_589211
  var valid_589212 = query.getOrDefault("maxResults")
  valid_589212 = validateParameter(valid_589212, JInt, required = false, default = nil)
  if valid_589212 != nil:
    section.add "maxResults", valid_589212
  var valid_589213 = query.getOrDefault("key")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "key", valid_589213
  var valid_589214 = query.getOrDefault("prettyPrint")
  valid_589214 = validateParameter(valid_589214, JBool, required = false,
                                 default = newJBool(true))
  if valid_589214 != nil:
    section.add "prettyPrint", valid_589214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589215: Call_ContentAccountsList_589188; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_589215.validator(path, query, header, formData, body)
  let scheme = call_589215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589215.url(scheme.get, call_589215.host, call_589215.base,
                         call_589215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589215, url, valid)

proc call*(call_589216: Call_ContentAccountsList_589188; merchantId: string;
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
  var path_589217 = newJObject()
  var query_589218 = newJObject()
  add(query_589218, "fields", newJString(fields))
  add(query_589218, "pageToken", newJString(pageToken))
  add(query_589218, "quotaUser", newJString(quotaUser))
  add(query_589218, "alt", newJString(alt))
  add(query_589218, "oauth_token", newJString(oauthToken))
  add(query_589218, "userIp", newJString(userIp))
  add(query_589218, "maxResults", newJInt(maxResults))
  add(query_589218, "key", newJString(key))
  add(path_589217, "merchantId", newJString(merchantId))
  add(query_589218, "prettyPrint", newJBool(prettyPrint))
  result = call_589216.call(path_589217, query_589218, nil, nil, nil)

var contentAccountsList* = Call_ContentAccountsList_589188(
    name: "contentAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounts",
    validator: validate_ContentAccountsList_589189, base: "/content/v2",
    url: url_ContentAccountsList_589190, schemes: {Scheme.Https})
type
  Call_ContentAccountsUpdate_589253 = ref object of OpenApiRestCall_588450
proc url_ContentAccountsUpdate_589255(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsUpdate_589254(path: JsonNode; query: JsonNode;
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
  var valid_589256 = path.getOrDefault("accountId")
  valid_589256 = validateParameter(valid_589256, JString, required = true,
                                 default = nil)
  if valid_589256 != nil:
    section.add "accountId", valid_589256
  var valid_589257 = path.getOrDefault("merchantId")
  valid_589257 = validateParameter(valid_589257, JString, required = true,
                                 default = nil)
  if valid_589257 != nil:
    section.add "merchantId", valid_589257
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
  var valid_589258 = query.getOrDefault("fields")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "fields", valid_589258
  var valid_589259 = query.getOrDefault("quotaUser")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "quotaUser", valid_589259
  var valid_589260 = query.getOrDefault("alt")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = newJString("json"))
  if valid_589260 != nil:
    section.add "alt", valid_589260
  var valid_589261 = query.getOrDefault("dryRun")
  valid_589261 = validateParameter(valid_589261, JBool, required = false, default = nil)
  if valid_589261 != nil:
    section.add "dryRun", valid_589261
  var valid_589262 = query.getOrDefault("oauth_token")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "oauth_token", valid_589262
  var valid_589263 = query.getOrDefault("userIp")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "userIp", valid_589263
  var valid_589264 = query.getOrDefault("key")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "key", valid_589264
  var valid_589265 = query.getOrDefault("prettyPrint")
  valid_589265 = validateParameter(valid_589265, JBool, required = false,
                                 default = newJBool(true))
  if valid_589265 != nil:
    section.add "prettyPrint", valid_589265
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

proc call*(call_589267: Call_ContentAccountsUpdate_589253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Merchant Center account.
  ## 
  let valid = call_589267.validator(path, query, header, formData, body)
  let scheme = call_589267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589267.url(scheme.get, call_589267.host, call_589267.base,
                         call_589267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589267, url, valid)

proc call*(call_589268: Call_ContentAccountsUpdate_589253; accountId: string;
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
  var path_589269 = newJObject()
  var query_589270 = newJObject()
  var body_589271 = newJObject()
  add(query_589270, "fields", newJString(fields))
  add(query_589270, "quotaUser", newJString(quotaUser))
  add(query_589270, "alt", newJString(alt))
  add(query_589270, "dryRun", newJBool(dryRun))
  add(query_589270, "oauth_token", newJString(oauthToken))
  add(path_589269, "accountId", newJString(accountId))
  add(query_589270, "userIp", newJString(userIp))
  add(query_589270, "key", newJString(key))
  add(path_589269, "merchantId", newJString(merchantId))
  if body != nil:
    body_589271 = body
  add(query_589270, "prettyPrint", newJBool(prettyPrint))
  result = call_589268.call(path_589269, query_589270, nil, nil, body_589271)

var contentAccountsUpdate* = Call_ContentAccountsUpdate_589253(
    name: "contentAccountsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsUpdate_589254, base: "/content/v2",
    url: url_ContentAccountsUpdate_589255, schemes: {Scheme.Https})
type
  Call_ContentAccountsGet_589237 = ref object of OpenApiRestCall_588450
proc url_ContentAccountsGet_589239(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsGet_589238(path: JsonNode; query: JsonNode;
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
  var valid_589240 = path.getOrDefault("accountId")
  valid_589240 = validateParameter(valid_589240, JString, required = true,
                                 default = nil)
  if valid_589240 != nil:
    section.add "accountId", valid_589240
  var valid_589241 = path.getOrDefault("merchantId")
  valid_589241 = validateParameter(valid_589241, JString, required = true,
                                 default = nil)
  if valid_589241 != nil:
    section.add "merchantId", valid_589241
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589242 = query.getOrDefault("fields")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "fields", valid_589242
  var valid_589243 = query.getOrDefault("quotaUser")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "quotaUser", valid_589243
  var valid_589244 = query.getOrDefault("alt")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = newJString("json"))
  if valid_589244 != nil:
    section.add "alt", valid_589244
  var valid_589245 = query.getOrDefault("oauth_token")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "oauth_token", valid_589245
  var valid_589246 = query.getOrDefault("userIp")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = nil)
  if valid_589246 != nil:
    section.add "userIp", valid_589246
  var valid_589247 = query.getOrDefault("key")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "key", valid_589247
  var valid_589248 = query.getOrDefault("prettyPrint")
  valid_589248 = validateParameter(valid_589248, JBool, required = false,
                                 default = newJBool(true))
  if valid_589248 != nil:
    section.add "prettyPrint", valid_589248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589249: Call_ContentAccountsGet_589237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a Merchant Center account.
  ## 
  let valid = call_589249.validator(path, query, header, formData, body)
  let scheme = call_589249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589249.url(scheme.get, call_589249.host, call_589249.base,
                         call_589249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589249, url, valid)

proc call*(call_589250: Call_ContentAccountsGet_589237; accountId: string;
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
  var path_589251 = newJObject()
  var query_589252 = newJObject()
  add(query_589252, "fields", newJString(fields))
  add(query_589252, "quotaUser", newJString(quotaUser))
  add(query_589252, "alt", newJString(alt))
  add(query_589252, "oauth_token", newJString(oauthToken))
  add(path_589251, "accountId", newJString(accountId))
  add(query_589252, "userIp", newJString(userIp))
  add(query_589252, "key", newJString(key))
  add(path_589251, "merchantId", newJString(merchantId))
  add(query_589252, "prettyPrint", newJBool(prettyPrint))
  result = call_589250.call(path_589251, query_589252, nil, nil, nil)

var contentAccountsGet* = Call_ContentAccountsGet_589237(
    name: "contentAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsGet_589238, base: "/content/v2",
    url: url_ContentAccountsGet_589239, schemes: {Scheme.Https})
type
  Call_ContentAccountsPatch_589290 = ref object of OpenApiRestCall_588450
proc url_ContentAccountsPatch_589292(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsPatch_589291(path: JsonNode; query: JsonNode;
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
  var valid_589293 = path.getOrDefault("accountId")
  valid_589293 = validateParameter(valid_589293, JString, required = true,
                                 default = nil)
  if valid_589293 != nil:
    section.add "accountId", valid_589293
  var valid_589294 = path.getOrDefault("merchantId")
  valid_589294 = validateParameter(valid_589294, JString, required = true,
                                 default = nil)
  if valid_589294 != nil:
    section.add "merchantId", valid_589294
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
  var valid_589295 = query.getOrDefault("fields")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "fields", valid_589295
  var valid_589296 = query.getOrDefault("quotaUser")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "quotaUser", valid_589296
  var valid_589297 = query.getOrDefault("alt")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = newJString("json"))
  if valid_589297 != nil:
    section.add "alt", valid_589297
  var valid_589298 = query.getOrDefault("dryRun")
  valid_589298 = validateParameter(valid_589298, JBool, required = false, default = nil)
  if valid_589298 != nil:
    section.add "dryRun", valid_589298
  var valid_589299 = query.getOrDefault("oauth_token")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = nil)
  if valid_589299 != nil:
    section.add "oauth_token", valid_589299
  var valid_589300 = query.getOrDefault("userIp")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "userIp", valid_589300
  var valid_589301 = query.getOrDefault("key")
  valid_589301 = validateParameter(valid_589301, JString, required = false,
                                 default = nil)
  if valid_589301 != nil:
    section.add "key", valid_589301
  var valid_589302 = query.getOrDefault("prettyPrint")
  valid_589302 = validateParameter(valid_589302, JBool, required = false,
                                 default = newJBool(true))
  if valid_589302 != nil:
    section.add "prettyPrint", valid_589302
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

proc call*(call_589304: Call_ContentAccountsPatch_589290; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Merchant Center account. This method supports patch semantics.
  ## 
  let valid = call_589304.validator(path, query, header, formData, body)
  let scheme = call_589304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589304.url(scheme.get, call_589304.host, call_589304.base,
                         call_589304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589304, url, valid)

proc call*(call_589305: Call_ContentAccountsPatch_589290; accountId: string;
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
  var path_589306 = newJObject()
  var query_589307 = newJObject()
  var body_589308 = newJObject()
  add(query_589307, "fields", newJString(fields))
  add(query_589307, "quotaUser", newJString(quotaUser))
  add(query_589307, "alt", newJString(alt))
  add(query_589307, "dryRun", newJBool(dryRun))
  add(query_589307, "oauth_token", newJString(oauthToken))
  add(path_589306, "accountId", newJString(accountId))
  add(query_589307, "userIp", newJString(userIp))
  add(query_589307, "key", newJString(key))
  add(path_589306, "merchantId", newJString(merchantId))
  if body != nil:
    body_589308 = body
  add(query_589307, "prettyPrint", newJBool(prettyPrint))
  result = call_589305.call(path_589306, query_589307, nil, nil, body_589308)

var contentAccountsPatch* = Call_ContentAccountsPatch_589290(
    name: "contentAccountsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsPatch_589291, base: "/content/v2",
    url: url_ContentAccountsPatch_589292, schemes: {Scheme.Https})
type
  Call_ContentAccountsDelete_589272 = ref object of OpenApiRestCall_588450
proc url_ContentAccountsDelete_589274(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsDelete_589273(path: JsonNode; query: JsonNode;
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
  var valid_589275 = path.getOrDefault("accountId")
  valid_589275 = validateParameter(valid_589275, JString, required = true,
                                 default = nil)
  if valid_589275 != nil:
    section.add "accountId", valid_589275
  var valid_589276 = path.getOrDefault("merchantId")
  valid_589276 = validateParameter(valid_589276, JString, required = true,
                                 default = nil)
  if valid_589276 != nil:
    section.add "merchantId", valid_589276
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
  var valid_589277 = query.getOrDefault("fields")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "fields", valid_589277
  var valid_589278 = query.getOrDefault("force")
  valid_589278 = validateParameter(valid_589278, JBool, required = false,
                                 default = newJBool(false))
  if valid_589278 != nil:
    section.add "force", valid_589278
  var valid_589279 = query.getOrDefault("quotaUser")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "quotaUser", valid_589279
  var valid_589280 = query.getOrDefault("alt")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = newJString("json"))
  if valid_589280 != nil:
    section.add "alt", valid_589280
  var valid_589281 = query.getOrDefault("dryRun")
  valid_589281 = validateParameter(valid_589281, JBool, required = false, default = nil)
  if valid_589281 != nil:
    section.add "dryRun", valid_589281
  var valid_589282 = query.getOrDefault("oauth_token")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = nil)
  if valid_589282 != nil:
    section.add "oauth_token", valid_589282
  var valid_589283 = query.getOrDefault("userIp")
  valid_589283 = validateParameter(valid_589283, JString, required = false,
                                 default = nil)
  if valid_589283 != nil:
    section.add "userIp", valid_589283
  var valid_589284 = query.getOrDefault("key")
  valid_589284 = validateParameter(valid_589284, JString, required = false,
                                 default = nil)
  if valid_589284 != nil:
    section.add "key", valid_589284
  var valid_589285 = query.getOrDefault("prettyPrint")
  valid_589285 = validateParameter(valid_589285, JBool, required = false,
                                 default = newJBool(true))
  if valid_589285 != nil:
    section.add "prettyPrint", valid_589285
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589286: Call_ContentAccountsDelete_589272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Merchant Center sub-account.
  ## 
  let valid = call_589286.validator(path, query, header, formData, body)
  let scheme = call_589286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589286.url(scheme.get, call_589286.host, call_589286.base,
                         call_589286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589286, url, valid)

proc call*(call_589287: Call_ContentAccountsDelete_589272; accountId: string;
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
  var path_589288 = newJObject()
  var query_589289 = newJObject()
  add(query_589289, "fields", newJString(fields))
  add(query_589289, "force", newJBool(force))
  add(query_589289, "quotaUser", newJString(quotaUser))
  add(query_589289, "alt", newJString(alt))
  add(query_589289, "dryRun", newJBool(dryRun))
  add(query_589289, "oauth_token", newJString(oauthToken))
  add(path_589288, "accountId", newJString(accountId))
  add(query_589289, "userIp", newJString(userIp))
  add(query_589289, "key", newJString(key))
  add(path_589288, "merchantId", newJString(merchantId))
  add(query_589289, "prettyPrint", newJBool(prettyPrint))
  result = call_589287.call(path_589288, query_589289, nil, nil, nil)

var contentAccountsDelete* = Call_ContentAccountsDelete_589272(
    name: "contentAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsDelete_589273, base: "/content/v2",
    url: url_ContentAccountsDelete_589274, schemes: {Scheme.Https})
type
  Call_ContentAccountsClaimwebsite_589309 = ref object of OpenApiRestCall_588450
proc url_ContentAccountsClaimwebsite_589311(protocol: Scheme; host: string;
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

proc validate_ContentAccountsClaimwebsite_589310(path: JsonNode; query: JsonNode;
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
  var valid_589312 = path.getOrDefault("accountId")
  valid_589312 = validateParameter(valid_589312, JString, required = true,
                                 default = nil)
  if valid_589312 != nil:
    section.add "accountId", valid_589312
  var valid_589313 = path.getOrDefault("merchantId")
  valid_589313 = validateParameter(valid_589313, JString, required = true,
                                 default = nil)
  if valid_589313 != nil:
    section.add "merchantId", valid_589313
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
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
  var valid_589314 = query.getOrDefault("fields")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "fields", valid_589314
  var valid_589315 = query.getOrDefault("quotaUser")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "quotaUser", valid_589315
  var valid_589316 = query.getOrDefault("alt")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = newJString("json"))
  if valid_589316 != nil:
    section.add "alt", valid_589316
  var valid_589317 = query.getOrDefault("oauth_token")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = nil)
  if valid_589317 != nil:
    section.add "oauth_token", valid_589317
  var valid_589318 = query.getOrDefault("userIp")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = nil)
  if valid_589318 != nil:
    section.add "userIp", valid_589318
  var valid_589319 = query.getOrDefault("overwrite")
  valid_589319 = validateParameter(valid_589319, JBool, required = false, default = nil)
  if valid_589319 != nil:
    section.add "overwrite", valid_589319
  var valid_589320 = query.getOrDefault("key")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "key", valid_589320
  var valid_589321 = query.getOrDefault("prettyPrint")
  valid_589321 = validateParameter(valid_589321, JBool, required = false,
                                 default = newJBool(true))
  if valid_589321 != nil:
    section.add "prettyPrint", valid_589321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589322: Call_ContentAccountsClaimwebsite_589309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Claims the website of a Merchant Center sub-account.
  ## 
  let valid = call_589322.validator(path, query, header, formData, body)
  let scheme = call_589322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589322.url(scheme.get, call_589322.host, call_589322.base,
                         call_589322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589322, url, valid)

proc call*(call_589323: Call_ContentAccountsClaimwebsite_589309; accountId: string;
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
  var path_589324 = newJObject()
  var query_589325 = newJObject()
  add(query_589325, "fields", newJString(fields))
  add(query_589325, "quotaUser", newJString(quotaUser))
  add(query_589325, "alt", newJString(alt))
  add(query_589325, "oauth_token", newJString(oauthToken))
  add(path_589324, "accountId", newJString(accountId))
  add(query_589325, "userIp", newJString(userIp))
  add(query_589325, "overwrite", newJBool(overwrite))
  add(query_589325, "key", newJString(key))
  add(path_589324, "merchantId", newJString(merchantId))
  add(query_589325, "prettyPrint", newJBool(prettyPrint))
  result = call_589323.call(path_589324, query_589325, nil, nil, nil)

var contentAccountsClaimwebsite* = Call_ContentAccountsClaimwebsite_589309(
    name: "contentAccountsClaimwebsite", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/accounts/{accountId}/claimwebsite",
    validator: validate_ContentAccountsClaimwebsite_589310, base: "/content/v2",
    url: url_ContentAccountsClaimwebsite_589311, schemes: {Scheme.Https})
type
  Call_ContentAccountsLink_589326 = ref object of OpenApiRestCall_588450
proc url_ContentAccountsLink_589328(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsLink_589327(path: JsonNode; query: JsonNode;
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
  var valid_589329 = path.getOrDefault("accountId")
  valid_589329 = validateParameter(valid_589329, JString, required = true,
                                 default = nil)
  if valid_589329 != nil:
    section.add "accountId", valid_589329
  var valid_589330 = path.getOrDefault("merchantId")
  valid_589330 = validateParameter(valid_589330, JString, required = true,
                                 default = nil)
  if valid_589330 != nil:
    section.add "merchantId", valid_589330
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589331 = query.getOrDefault("fields")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "fields", valid_589331
  var valid_589332 = query.getOrDefault("quotaUser")
  valid_589332 = validateParameter(valid_589332, JString, required = false,
                                 default = nil)
  if valid_589332 != nil:
    section.add "quotaUser", valid_589332
  var valid_589333 = query.getOrDefault("alt")
  valid_589333 = validateParameter(valid_589333, JString, required = false,
                                 default = newJString("json"))
  if valid_589333 != nil:
    section.add "alt", valid_589333
  var valid_589334 = query.getOrDefault("oauth_token")
  valid_589334 = validateParameter(valid_589334, JString, required = false,
                                 default = nil)
  if valid_589334 != nil:
    section.add "oauth_token", valid_589334
  var valid_589335 = query.getOrDefault("userIp")
  valid_589335 = validateParameter(valid_589335, JString, required = false,
                                 default = nil)
  if valid_589335 != nil:
    section.add "userIp", valid_589335
  var valid_589336 = query.getOrDefault("key")
  valid_589336 = validateParameter(valid_589336, JString, required = false,
                                 default = nil)
  if valid_589336 != nil:
    section.add "key", valid_589336
  var valid_589337 = query.getOrDefault("prettyPrint")
  valid_589337 = validateParameter(valid_589337, JBool, required = false,
                                 default = newJBool(true))
  if valid_589337 != nil:
    section.add "prettyPrint", valid_589337
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

proc call*(call_589339: Call_ContentAccountsLink_589326; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs an action on a link between two Merchant Center accounts, namely accountId and linkedAccountId.
  ## 
  let valid = call_589339.validator(path, query, header, formData, body)
  let scheme = call_589339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589339.url(scheme.get, call_589339.host, call_589339.base,
                         call_589339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589339, url, valid)

proc call*(call_589340: Call_ContentAccountsLink_589326; accountId: string;
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
  var path_589341 = newJObject()
  var query_589342 = newJObject()
  var body_589343 = newJObject()
  add(query_589342, "fields", newJString(fields))
  add(query_589342, "quotaUser", newJString(quotaUser))
  add(query_589342, "alt", newJString(alt))
  add(query_589342, "oauth_token", newJString(oauthToken))
  add(path_589341, "accountId", newJString(accountId))
  add(query_589342, "userIp", newJString(userIp))
  add(query_589342, "key", newJString(key))
  add(path_589341, "merchantId", newJString(merchantId))
  if body != nil:
    body_589343 = body
  add(query_589342, "prettyPrint", newJBool(prettyPrint))
  result = call_589340.call(path_589341, query_589342, nil, nil, body_589343)

var contentAccountsLink* = Call_ContentAccountsLink_589326(
    name: "contentAccountsLink", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}/link",
    validator: validate_ContentAccountsLink_589327, base: "/content/v2",
    url: url_ContentAccountsLink_589328, schemes: {Scheme.Https})
type
  Call_ContentAccountstatusesList_589344 = ref object of OpenApiRestCall_588450
proc url_ContentAccountstatusesList_589346(protocol: Scheme; host: string;
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

proc validate_ContentAccountstatusesList_589345(path: JsonNode; query: JsonNode;
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
  var valid_589347 = path.getOrDefault("merchantId")
  valid_589347 = validateParameter(valid_589347, JString, required = true,
                                 default = nil)
  if valid_589347 != nil:
    section.add "merchantId", valid_589347
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
  var valid_589348 = query.getOrDefault("fields")
  valid_589348 = validateParameter(valid_589348, JString, required = false,
                                 default = nil)
  if valid_589348 != nil:
    section.add "fields", valid_589348
  var valid_589349 = query.getOrDefault("pageToken")
  valid_589349 = validateParameter(valid_589349, JString, required = false,
                                 default = nil)
  if valid_589349 != nil:
    section.add "pageToken", valid_589349
  var valid_589350 = query.getOrDefault("quotaUser")
  valid_589350 = validateParameter(valid_589350, JString, required = false,
                                 default = nil)
  if valid_589350 != nil:
    section.add "quotaUser", valid_589350
  var valid_589351 = query.getOrDefault("alt")
  valid_589351 = validateParameter(valid_589351, JString, required = false,
                                 default = newJString("json"))
  if valid_589351 != nil:
    section.add "alt", valid_589351
  var valid_589352 = query.getOrDefault("oauth_token")
  valid_589352 = validateParameter(valid_589352, JString, required = false,
                                 default = nil)
  if valid_589352 != nil:
    section.add "oauth_token", valid_589352
  var valid_589353 = query.getOrDefault("userIp")
  valid_589353 = validateParameter(valid_589353, JString, required = false,
                                 default = nil)
  if valid_589353 != nil:
    section.add "userIp", valid_589353
  var valid_589354 = query.getOrDefault("maxResults")
  valid_589354 = validateParameter(valid_589354, JInt, required = false, default = nil)
  if valid_589354 != nil:
    section.add "maxResults", valid_589354
  var valid_589355 = query.getOrDefault("key")
  valid_589355 = validateParameter(valid_589355, JString, required = false,
                                 default = nil)
  if valid_589355 != nil:
    section.add "key", valid_589355
  var valid_589356 = query.getOrDefault("prettyPrint")
  valid_589356 = validateParameter(valid_589356, JBool, required = false,
                                 default = newJBool(true))
  if valid_589356 != nil:
    section.add "prettyPrint", valid_589356
  var valid_589357 = query.getOrDefault("destinations")
  valid_589357 = validateParameter(valid_589357, JArray, required = false,
                                 default = nil)
  if valid_589357 != nil:
    section.add "destinations", valid_589357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589358: Call_ContentAccountstatusesList_589344; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_589358.validator(path, query, header, formData, body)
  let scheme = call_589358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589358.url(scheme.get, call_589358.host, call_589358.base,
                         call_589358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589358, url, valid)

proc call*(call_589359: Call_ContentAccountstatusesList_589344; merchantId: string;
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
  var path_589360 = newJObject()
  var query_589361 = newJObject()
  add(query_589361, "fields", newJString(fields))
  add(query_589361, "pageToken", newJString(pageToken))
  add(query_589361, "quotaUser", newJString(quotaUser))
  add(query_589361, "alt", newJString(alt))
  add(query_589361, "oauth_token", newJString(oauthToken))
  add(query_589361, "userIp", newJString(userIp))
  add(query_589361, "maxResults", newJInt(maxResults))
  add(query_589361, "key", newJString(key))
  add(path_589360, "merchantId", newJString(merchantId))
  add(query_589361, "prettyPrint", newJBool(prettyPrint))
  if destinations != nil:
    query_589361.add "destinations", destinations
  result = call_589359.call(path_589360, query_589361, nil, nil, nil)

var contentAccountstatusesList* = Call_ContentAccountstatusesList_589344(
    name: "contentAccountstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accountstatuses",
    validator: validate_ContentAccountstatusesList_589345, base: "/content/v2",
    url: url_ContentAccountstatusesList_589346, schemes: {Scheme.Https})
type
  Call_ContentAccountstatusesGet_589362 = ref object of OpenApiRestCall_588450
proc url_ContentAccountstatusesGet_589364(protocol: Scheme; host: string;
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

proc validate_ContentAccountstatusesGet_589363(path: JsonNode; query: JsonNode;
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
  var valid_589365 = path.getOrDefault("accountId")
  valid_589365 = validateParameter(valid_589365, JString, required = true,
                                 default = nil)
  if valid_589365 != nil:
    section.add "accountId", valid_589365
  var valid_589366 = path.getOrDefault("merchantId")
  valid_589366 = validateParameter(valid_589366, JString, required = true,
                                 default = nil)
  if valid_589366 != nil:
    section.add "merchantId", valid_589366
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
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
  var valid_589367 = query.getOrDefault("fields")
  valid_589367 = validateParameter(valid_589367, JString, required = false,
                                 default = nil)
  if valid_589367 != nil:
    section.add "fields", valid_589367
  var valid_589368 = query.getOrDefault("quotaUser")
  valid_589368 = validateParameter(valid_589368, JString, required = false,
                                 default = nil)
  if valid_589368 != nil:
    section.add "quotaUser", valid_589368
  var valid_589369 = query.getOrDefault("alt")
  valid_589369 = validateParameter(valid_589369, JString, required = false,
                                 default = newJString("json"))
  if valid_589369 != nil:
    section.add "alt", valid_589369
  var valid_589370 = query.getOrDefault("oauth_token")
  valid_589370 = validateParameter(valid_589370, JString, required = false,
                                 default = nil)
  if valid_589370 != nil:
    section.add "oauth_token", valid_589370
  var valid_589371 = query.getOrDefault("userIp")
  valid_589371 = validateParameter(valid_589371, JString, required = false,
                                 default = nil)
  if valid_589371 != nil:
    section.add "userIp", valid_589371
  var valid_589372 = query.getOrDefault("key")
  valid_589372 = validateParameter(valid_589372, JString, required = false,
                                 default = nil)
  if valid_589372 != nil:
    section.add "key", valid_589372
  var valid_589373 = query.getOrDefault("prettyPrint")
  valid_589373 = validateParameter(valid_589373, JBool, required = false,
                                 default = newJBool(true))
  if valid_589373 != nil:
    section.add "prettyPrint", valid_589373
  var valid_589374 = query.getOrDefault("destinations")
  valid_589374 = validateParameter(valid_589374, JArray, required = false,
                                 default = nil)
  if valid_589374 != nil:
    section.add "destinations", valid_589374
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589375: Call_ContentAccountstatusesGet_589362; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the status of a Merchant Center account. No itemLevelIssues are returned for multi-client accounts.
  ## 
  let valid = call_589375.validator(path, query, header, formData, body)
  let scheme = call_589375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589375.url(scheme.get, call_589375.host, call_589375.base,
                         call_589375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589375, url, valid)

proc call*(call_589376: Call_ContentAccountstatusesGet_589362; accountId: string;
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
  var path_589377 = newJObject()
  var query_589378 = newJObject()
  add(query_589378, "fields", newJString(fields))
  add(query_589378, "quotaUser", newJString(quotaUser))
  add(query_589378, "alt", newJString(alt))
  add(query_589378, "oauth_token", newJString(oauthToken))
  add(path_589377, "accountId", newJString(accountId))
  add(query_589378, "userIp", newJString(userIp))
  add(query_589378, "key", newJString(key))
  add(path_589377, "merchantId", newJString(merchantId))
  add(query_589378, "prettyPrint", newJBool(prettyPrint))
  if destinations != nil:
    query_589378.add "destinations", destinations
  result = call_589376.call(path_589377, query_589378, nil, nil, nil)

var contentAccountstatusesGet* = Call_ContentAccountstatusesGet_589362(
    name: "contentAccountstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/accountstatuses/{accountId}",
    validator: validate_ContentAccountstatusesGet_589363, base: "/content/v2",
    url: url_ContentAccountstatusesGet_589364, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxList_589379 = ref object of OpenApiRestCall_588450
proc url_ContentAccounttaxList_589381(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccounttaxList_589380(path: JsonNode; query: JsonNode;
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
  var valid_589382 = path.getOrDefault("merchantId")
  valid_589382 = validateParameter(valid_589382, JString, required = true,
                                 default = nil)
  if valid_589382 != nil:
    section.add "merchantId", valid_589382
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
  var valid_589383 = query.getOrDefault("fields")
  valid_589383 = validateParameter(valid_589383, JString, required = false,
                                 default = nil)
  if valid_589383 != nil:
    section.add "fields", valid_589383
  var valid_589384 = query.getOrDefault("pageToken")
  valid_589384 = validateParameter(valid_589384, JString, required = false,
                                 default = nil)
  if valid_589384 != nil:
    section.add "pageToken", valid_589384
  var valid_589385 = query.getOrDefault("quotaUser")
  valid_589385 = validateParameter(valid_589385, JString, required = false,
                                 default = nil)
  if valid_589385 != nil:
    section.add "quotaUser", valid_589385
  var valid_589386 = query.getOrDefault("alt")
  valid_589386 = validateParameter(valid_589386, JString, required = false,
                                 default = newJString("json"))
  if valid_589386 != nil:
    section.add "alt", valid_589386
  var valid_589387 = query.getOrDefault("oauth_token")
  valid_589387 = validateParameter(valid_589387, JString, required = false,
                                 default = nil)
  if valid_589387 != nil:
    section.add "oauth_token", valid_589387
  var valid_589388 = query.getOrDefault("userIp")
  valid_589388 = validateParameter(valid_589388, JString, required = false,
                                 default = nil)
  if valid_589388 != nil:
    section.add "userIp", valid_589388
  var valid_589389 = query.getOrDefault("maxResults")
  valid_589389 = validateParameter(valid_589389, JInt, required = false, default = nil)
  if valid_589389 != nil:
    section.add "maxResults", valid_589389
  var valid_589390 = query.getOrDefault("key")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = nil)
  if valid_589390 != nil:
    section.add "key", valid_589390
  var valid_589391 = query.getOrDefault("prettyPrint")
  valid_589391 = validateParameter(valid_589391, JBool, required = false,
                                 default = newJBool(true))
  if valid_589391 != nil:
    section.add "prettyPrint", valid_589391
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589392: Call_ContentAccounttaxList_589379; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the tax settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_589392.validator(path, query, header, formData, body)
  let scheme = call_589392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589392.url(scheme.get, call_589392.host, call_589392.base,
                         call_589392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589392, url, valid)

proc call*(call_589393: Call_ContentAccounttaxList_589379; merchantId: string;
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
  var path_589394 = newJObject()
  var query_589395 = newJObject()
  add(query_589395, "fields", newJString(fields))
  add(query_589395, "pageToken", newJString(pageToken))
  add(query_589395, "quotaUser", newJString(quotaUser))
  add(query_589395, "alt", newJString(alt))
  add(query_589395, "oauth_token", newJString(oauthToken))
  add(query_589395, "userIp", newJString(userIp))
  add(query_589395, "maxResults", newJInt(maxResults))
  add(query_589395, "key", newJString(key))
  add(path_589394, "merchantId", newJString(merchantId))
  add(query_589395, "prettyPrint", newJBool(prettyPrint))
  result = call_589393.call(path_589394, query_589395, nil, nil, nil)

var contentAccounttaxList* = Call_ContentAccounttaxList_589379(
    name: "contentAccounttaxList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax",
    validator: validate_ContentAccounttaxList_589380, base: "/content/v2",
    url: url_ContentAccounttaxList_589381, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxUpdate_589412 = ref object of OpenApiRestCall_588450
proc url_ContentAccounttaxUpdate_589414(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccounttaxUpdate_589413(path: JsonNode; query: JsonNode;
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
  var valid_589415 = path.getOrDefault("accountId")
  valid_589415 = validateParameter(valid_589415, JString, required = true,
                                 default = nil)
  if valid_589415 != nil:
    section.add "accountId", valid_589415
  var valid_589416 = path.getOrDefault("merchantId")
  valid_589416 = validateParameter(valid_589416, JString, required = true,
                                 default = nil)
  if valid_589416 != nil:
    section.add "merchantId", valid_589416
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
  var valid_589417 = query.getOrDefault("fields")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = nil)
  if valid_589417 != nil:
    section.add "fields", valid_589417
  var valid_589418 = query.getOrDefault("quotaUser")
  valid_589418 = validateParameter(valid_589418, JString, required = false,
                                 default = nil)
  if valid_589418 != nil:
    section.add "quotaUser", valid_589418
  var valid_589419 = query.getOrDefault("alt")
  valid_589419 = validateParameter(valid_589419, JString, required = false,
                                 default = newJString("json"))
  if valid_589419 != nil:
    section.add "alt", valid_589419
  var valid_589420 = query.getOrDefault("dryRun")
  valid_589420 = validateParameter(valid_589420, JBool, required = false, default = nil)
  if valid_589420 != nil:
    section.add "dryRun", valid_589420
  var valid_589421 = query.getOrDefault("oauth_token")
  valid_589421 = validateParameter(valid_589421, JString, required = false,
                                 default = nil)
  if valid_589421 != nil:
    section.add "oauth_token", valid_589421
  var valid_589422 = query.getOrDefault("userIp")
  valid_589422 = validateParameter(valid_589422, JString, required = false,
                                 default = nil)
  if valid_589422 != nil:
    section.add "userIp", valid_589422
  var valid_589423 = query.getOrDefault("key")
  valid_589423 = validateParameter(valid_589423, JString, required = false,
                                 default = nil)
  if valid_589423 != nil:
    section.add "key", valid_589423
  var valid_589424 = query.getOrDefault("prettyPrint")
  valid_589424 = validateParameter(valid_589424, JBool, required = false,
                                 default = newJBool(true))
  if valid_589424 != nil:
    section.add "prettyPrint", valid_589424
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

proc call*(call_589426: Call_ContentAccounttaxUpdate_589412; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the tax settings of the account.
  ## 
  let valid = call_589426.validator(path, query, header, formData, body)
  let scheme = call_589426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589426.url(scheme.get, call_589426.host, call_589426.base,
                         call_589426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589426, url, valid)

proc call*(call_589427: Call_ContentAccounttaxUpdate_589412; accountId: string;
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
  var path_589428 = newJObject()
  var query_589429 = newJObject()
  var body_589430 = newJObject()
  add(query_589429, "fields", newJString(fields))
  add(query_589429, "quotaUser", newJString(quotaUser))
  add(query_589429, "alt", newJString(alt))
  add(query_589429, "dryRun", newJBool(dryRun))
  add(query_589429, "oauth_token", newJString(oauthToken))
  add(path_589428, "accountId", newJString(accountId))
  add(query_589429, "userIp", newJString(userIp))
  add(query_589429, "key", newJString(key))
  add(path_589428, "merchantId", newJString(merchantId))
  if body != nil:
    body_589430 = body
  add(query_589429, "prettyPrint", newJBool(prettyPrint))
  result = call_589427.call(path_589428, query_589429, nil, nil, body_589430)

var contentAccounttaxUpdate* = Call_ContentAccounttaxUpdate_589412(
    name: "contentAccounttaxUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax/{accountId}",
    validator: validate_ContentAccounttaxUpdate_589413, base: "/content/v2",
    url: url_ContentAccounttaxUpdate_589414, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxGet_589396 = ref object of OpenApiRestCall_588450
proc url_ContentAccounttaxGet_589398(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccounttaxGet_589397(path: JsonNode; query: JsonNode;
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
  var valid_589399 = path.getOrDefault("accountId")
  valid_589399 = validateParameter(valid_589399, JString, required = true,
                                 default = nil)
  if valid_589399 != nil:
    section.add "accountId", valid_589399
  var valid_589400 = path.getOrDefault("merchantId")
  valid_589400 = validateParameter(valid_589400, JString, required = true,
                                 default = nil)
  if valid_589400 != nil:
    section.add "merchantId", valid_589400
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589401 = query.getOrDefault("fields")
  valid_589401 = validateParameter(valid_589401, JString, required = false,
                                 default = nil)
  if valid_589401 != nil:
    section.add "fields", valid_589401
  var valid_589402 = query.getOrDefault("quotaUser")
  valid_589402 = validateParameter(valid_589402, JString, required = false,
                                 default = nil)
  if valid_589402 != nil:
    section.add "quotaUser", valid_589402
  var valid_589403 = query.getOrDefault("alt")
  valid_589403 = validateParameter(valid_589403, JString, required = false,
                                 default = newJString("json"))
  if valid_589403 != nil:
    section.add "alt", valid_589403
  var valid_589404 = query.getOrDefault("oauth_token")
  valid_589404 = validateParameter(valid_589404, JString, required = false,
                                 default = nil)
  if valid_589404 != nil:
    section.add "oauth_token", valid_589404
  var valid_589405 = query.getOrDefault("userIp")
  valid_589405 = validateParameter(valid_589405, JString, required = false,
                                 default = nil)
  if valid_589405 != nil:
    section.add "userIp", valid_589405
  var valid_589406 = query.getOrDefault("key")
  valid_589406 = validateParameter(valid_589406, JString, required = false,
                                 default = nil)
  if valid_589406 != nil:
    section.add "key", valid_589406
  var valid_589407 = query.getOrDefault("prettyPrint")
  valid_589407 = validateParameter(valid_589407, JBool, required = false,
                                 default = newJBool(true))
  if valid_589407 != nil:
    section.add "prettyPrint", valid_589407
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589408: Call_ContentAccounttaxGet_589396; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the tax settings of the account.
  ## 
  let valid = call_589408.validator(path, query, header, formData, body)
  let scheme = call_589408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589408.url(scheme.get, call_589408.host, call_589408.base,
                         call_589408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589408, url, valid)

proc call*(call_589409: Call_ContentAccounttaxGet_589396; accountId: string;
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
  var path_589410 = newJObject()
  var query_589411 = newJObject()
  add(query_589411, "fields", newJString(fields))
  add(query_589411, "quotaUser", newJString(quotaUser))
  add(query_589411, "alt", newJString(alt))
  add(query_589411, "oauth_token", newJString(oauthToken))
  add(path_589410, "accountId", newJString(accountId))
  add(query_589411, "userIp", newJString(userIp))
  add(query_589411, "key", newJString(key))
  add(path_589410, "merchantId", newJString(merchantId))
  add(query_589411, "prettyPrint", newJBool(prettyPrint))
  result = call_589409.call(path_589410, query_589411, nil, nil, nil)

var contentAccounttaxGet* = Call_ContentAccounttaxGet_589396(
    name: "contentAccounttaxGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax/{accountId}",
    validator: validate_ContentAccounttaxGet_589397, base: "/content/v2",
    url: url_ContentAccounttaxGet_589398, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxPatch_589431 = ref object of OpenApiRestCall_588450
proc url_ContentAccounttaxPatch_589433(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccounttaxPatch_589432(path: JsonNode; query: JsonNode;
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
  var valid_589434 = path.getOrDefault("accountId")
  valid_589434 = validateParameter(valid_589434, JString, required = true,
                                 default = nil)
  if valid_589434 != nil:
    section.add "accountId", valid_589434
  var valid_589435 = path.getOrDefault("merchantId")
  valid_589435 = validateParameter(valid_589435, JString, required = true,
                                 default = nil)
  if valid_589435 != nil:
    section.add "merchantId", valid_589435
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
  var valid_589436 = query.getOrDefault("fields")
  valid_589436 = validateParameter(valid_589436, JString, required = false,
                                 default = nil)
  if valid_589436 != nil:
    section.add "fields", valid_589436
  var valid_589437 = query.getOrDefault("quotaUser")
  valid_589437 = validateParameter(valid_589437, JString, required = false,
                                 default = nil)
  if valid_589437 != nil:
    section.add "quotaUser", valid_589437
  var valid_589438 = query.getOrDefault("alt")
  valid_589438 = validateParameter(valid_589438, JString, required = false,
                                 default = newJString("json"))
  if valid_589438 != nil:
    section.add "alt", valid_589438
  var valid_589439 = query.getOrDefault("dryRun")
  valid_589439 = validateParameter(valid_589439, JBool, required = false, default = nil)
  if valid_589439 != nil:
    section.add "dryRun", valid_589439
  var valid_589440 = query.getOrDefault("oauth_token")
  valid_589440 = validateParameter(valid_589440, JString, required = false,
                                 default = nil)
  if valid_589440 != nil:
    section.add "oauth_token", valid_589440
  var valid_589441 = query.getOrDefault("userIp")
  valid_589441 = validateParameter(valid_589441, JString, required = false,
                                 default = nil)
  if valid_589441 != nil:
    section.add "userIp", valid_589441
  var valid_589442 = query.getOrDefault("key")
  valid_589442 = validateParameter(valid_589442, JString, required = false,
                                 default = nil)
  if valid_589442 != nil:
    section.add "key", valid_589442
  var valid_589443 = query.getOrDefault("prettyPrint")
  valid_589443 = validateParameter(valid_589443, JBool, required = false,
                                 default = newJBool(true))
  if valid_589443 != nil:
    section.add "prettyPrint", valid_589443
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

proc call*(call_589445: Call_ContentAccounttaxPatch_589431; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the tax settings of the account. This method supports patch semantics.
  ## 
  let valid = call_589445.validator(path, query, header, formData, body)
  let scheme = call_589445.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589445.url(scheme.get, call_589445.host, call_589445.base,
                         call_589445.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589445, url, valid)

proc call*(call_589446: Call_ContentAccounttaxPatch_589431; accountId: string;
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
  var path_589447 = newJObject()
  var query_589448 = newJObject()
  var body_589449 = newJObject()
  add(query_589448, "fields", newJString(fields))
  add(query_589448, "quotaUser", newJString(quotaUser))
  add(query_589448, "alt", newJString(alt))
  add(query_589448, "dryRun", newJBool(dryRun))
  add(query_589448, "oauth_token", newJString(oauthToken))
  add(path_589447, "accountId", newJString(accountId))
  add(query_589448, "userIp", newJString(userIp))
  add(query_589448, "key", newJString(key))
  add(path_589447, "merchantId", newJString(merchantId))
  if body != nil:
    body_589449 = body
  add(query_589448, "prettyPrint", newJBool(prettyPrint))
  result = call_589446.call(path_589447, query_589448, nil, nil, body_589449)

var contentAccounttaxPatch* = Call_ContentAccounttaxPatch_589431(
    name: "contentAccounttaxPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax/{accountId}",
    validator: validate_ContentAccounttaxPatch_589432, base: "/content/v2",
    url: url_ContentAccounttaxPatch_589433, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsInsert_589467 = ref object of OpenApiRestCall_588450
proc url_ContentDatafeedsInsert_589469(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsInsert_589468(path: JsonNode; query: JsonNode;
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
  var valid_589470 = path.getOrDefault("merchantId")
  valid_589470 = validateParameter(valid_589470, JString, required = true,
                                 default = nil)
  if valid_589470 != nil:
    section.add "merchantId", valid_589470
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
  var valid_589471 = query.getOrDefault("fields")
  valid_589471 = validateParameter(valid_589471, JString, required = false,
                                 default = nil)
  if valid_589471 != nil:
    section.add "fields", valid_589471
  var valid_589472 = query.getOrDefault("quotaUser")
  valid_589472 = validateParameter(valid_589472, JString, required = false,
                                 default = nil)
  if valid_589472 != nil:
    section.add "quotaUser", valid_589472
  var valid_589473 = query.getOrDefault("alt")
  valid_589473 = validateParameter(valid_589473, JString, required = false,
                                 default = newJString("json"))
  if valid_589473 != nil:
    section.add "alt", valid_589473
  var valid_589474 = query.getOrDefault("dryRun")
  valid_589474 = validateParameter(valid_589474, JBool, required = false, default = nil)
  if valid_589474 != nil:
    section.add "dryRun", valid_589474
  var valid_589475 = query.getOrDefault("oauth_token")
  valid_589475 = validateParameter(valid_589475, JString, required = false,
                                 default = nil)
  if valid_589475 != nil:
    section.add "oauth_token", valid_589475
  var valid_589476 = query.getOrDefault("userIp")
  valid_589476 = validateParameter(valid_589476, JString, required = false,
                                 default = nil)
  if valid_589476 != nil:
    section.add "userIp", valid_589476
  var valid_589477 = query.getOrDefault("key")
  valid_589477 = validateParameter(valid_589477, JString, required = false,
                                 default = nil)
  if valid_589477 != nil:
    section.add "key", valid_589477
  var valid_589478 = query.getOrDefault("prettyPrint")
  valid_589478 = validateParameter(valid_589478, JBool, required = false,
                                 default = newJBool(true))
  if valid_589478 != nil:
    section.add "prettyPrint", valid_589478
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

proc call*(call_589480: Call_ContentDatafeedsInsert_589467; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers a datafeed configuration with your Merchant Center account.
  ## 
  let valid = call_589480.validator(path, query, header, formData, body)
  let scheme = call_589480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589480.url(scheme.get, call_589480.host, call_589480.base,
                         call_589480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589480, url, valid)

proc call*(call_589481: Call_ContentDatafeedsInsert_589467; merchantId: string;
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
  var path_589482 = newJObject()
  var query_589483 = newJObject()
  var body_589484 = newJObject()
  add(query_589483, "fields", newJString(fields))
  add(query_589483, "quotaUser", newJString(quotaUser))
  add(query_589483, "alt", newJString(alt))
  add(query_589483, "dryRun", newJBool(dryRun))
  add(query_589483, "oauth_token", newJString(oauthToken))
  add(query_589483, "userIp", newJString(userIp))
  add(query_589483, "key", newJString(key))
  add(path_589482, "merchantId", newJString(merchantId))
  if body != nil:
    body_589484 = body
  add(query_589483, "prettyPrint", newJBool(prettyPrint))
  result = call_589481.call(path_589482, query_589483, nil, nil, body_589484)

var contentDatafeedsInsert* = Call_ContentDatafeedsInsert_589467(
    name: "contentDatafeedsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds",
    validator: validate_ContentDatafeedsInsert_589468, base: "/content/v2",
    url: url_ContentDatafeedsInsert_589469, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsList_589450 = ref object of OpenApiRestCall_588450
proc url_ContentDatafeedsList_589452(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsList_589451(path: JsonNode; query: JsonNode;
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
  var valid_589453 = path.getOrDefault("merchantId")
  valid_589453 = validateParameter(valid_589453, JString, required = true,
                                 default = nil)
  if valid_589453 != nil:
    section.add "merchantId", valid_589453
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
  var valid_589454 = query.getOrDefault("fields")
  valid_589454 = validateParameter(valid_589454, JString, required = false,
                                 default = nil)
  if valid_589454 != nil:
    section.add "fields", valid_589454
  var valid_589455 = query.getOrDefault("pageToken")
  valid_589455 = validateParameter(valid_589455, JString, required = false,
                                 default = nil)
  if valid_589455 != nil:
    section.add "pageToken", valid_589455
  var valid_589456 = query.getOrDefault("quotaUser")
  valid_589456 = validateParameter(valid_589456, JString, required = false,
                                 default = nil)
  if valid_589456 != nil:
    section.add "quotaUser", valid_589456
  var valid_589457 = query.getOrDefault("alt")
  valid_589457 = validateParameter(valid_589457, JString, required = false,
                                 default = newJString("json"))
  if valid_589457 != nil:
    section.add "alt", valid_589457
  var valid_589458 = query.getOrDefault("oauth_token")
  valid_589458 = validateParameter(valid_589458, JString, required = false,
                                 default = nil)
  if valid_589458 != nil:
    section.add "oauth_token", valid_589458
  var valid_589459 = query.getOrDefault("userIp")
  valid_589459 = validateParameter(valid_589459, JString, required = false,
                                 default = nil)
  if valid_589459 != nil:
    section.add "userIp", valid_589459
  var valid_589460 = query.getOrDefault("maxResults")
  valid_589460 = validateParameter(valid_589460, JInt, required = false, default = nil)
  if valid_589460 != nil:
    section.add "maxResults", valid_589460
  var valid_589461 = query.getOrDefault("key")
  valid_589461 = validateParameter(valid_589461, JString, required = false,
                                 default = nil)
  if valid_589461 != nil:
    section.add "key", valid_589461
  var valid_589462 = query.getOrDefault("prettyPrint")
  valid_589462 = validateParameter(valid_589462, JBool, required = false,
                                 default = newJBool(true))
  if valid_589462 != nil:
    section.add "prettyPrint", valid_589462
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589463: Call_ContentDatafeedsList_589450; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the configurations for datafeeds in your Merchant Center account.
  ## 
  let valid = call_589463.validator(path, query, header, formData, body)
  let scheme = call_589463.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589463.url(scheme.get, call_589463.host, call_589463.base,
                         call_589463.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589463, url, valid)

proc call*(call_589464: Call_ContentDatafeedsList_589450; merchantId: string;
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
  var path_589465 = newJObject()
  var query_589466 = newJObject()
  add(query_589466, "fields", newJString(fields))
  add(query_589466, "pageToken", newJString(pageToken))
  add(query_589466, "quotaUser", newJString(quotaUser))
  add(query_589466, "alt", newJString(alt))
  add(query_589466, "oauth_token", newJString(oauthToken))
  add(query_589466, "userIp", newJString(userIp))
  add(query_589466, "maxResults", newJInt(maxResults))
  add(query_589466, "key", newJString(key))
  add(path_589465, "merchantId", newJString(merchantId))
  add(query_589466, "prettyPrint", newJBool(prettyPrint))
  result = call_589464.call(path_589465, query_589466, nil, nil, nil)

var contentDatafeedsList* = Call_ContentDatafeedsList_589450(
    name: "contentDatafeedsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds",
    validator: validate_ContentDatafeedsList_589451, base: "/content/v2",
    url: url_ContentDatafeedsList_589452, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsUpdate_589501 = ref object of OpenApiRestCall_588450
proc url_ContentDatafeedsUpdate_589503(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsUpdate_589502(path: JsonNode; query: JsonNode;
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
  var valid_589504 = path.getOrDefault("merchantId")
  valid_589504 = validateParameter(valid_589504, JString, required = true,
                                 default = nil)
  if valid_589504 != nil:
    section.add "merchantId", valid_589504
  var valid_589505 = path.getOrDefault("datafeedId")
  valid_589505 = validateParameter(valid_589505, JString, required = true,
                                 default = nil)
  if valid_589505 != nil:
    section.add "datafeedId", valid_589505
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
  var valid_589506 = query.getOrDefault("fields")
  valid_589506 = validateParameter(valid_589506, JString, required = false,
                                 default = nil)
  if valid_589506 != nil:
    section.add "fields", valid_589506
  var valid_589507 = query.getOrDefault("quotaUser")
  valid_589507 = validateParameter(valid_589507, JString, required = false,
                                 default = nil)
  if valid_589507 != nil:
    section.add "quotaUser", valid_589507
  var valid_589508 = query.getOrDefault("alt")
  valid_589508 = validateParameter(valid_589508, JString, required = false,
                                 default = newJString("json"))
  if valid_589508 != nil:
    section.add "alt", valid_589508
  var valid_589509 = query.getOrDefault("dryRun")
  valid_589509 = validateParameter(valid_589509, JBool, required = false, default = nil)
  if valid_589509 != nil:
    section.add "dryRun", valid_589509
  var valid_589510 = query.getOrDefault("oauth_token")
  valid_589510 = validateParameter(valid_589510, JString, required = false,
                                 default = nil)
  if valid_589510 != nil:
    section.add "oauth_token", valid_589510
  var valid_589511 = query.getOrDefault("userIp")
  valid_589511 = validateParameter(valid_589511, JString, required = false,
                                 default = nil)
  if valid_589511 != nil:
    section.add "userIp", valid_589511
  var valid_589512 = query.getOrDefault("key")
  valid_589512 = validateParameter(valid_589512, JString, required = false,
                                 default = nil)
  if valid_589512 != nil:
    section.add "key", valid_589512
  var valid_589513 = query.getOrDefault("prettyPrint")
  valid_589513 = validateParameter(valid_589513, JBool, required = false,
                                 default = newJBool(true))
  if valid_589513 != nil:
    section.add "prettyPrint", valid_589513
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

proc call*(call_589515: Call_ContentDatafeedsUpdate_589501; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a datafeed configuration of your Merchant Center account.
  ## 
  let valid = call_589515.validator(path, query, header, formData, body)
  let scheme = call_589515.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589515.url(scheme.get, call_589515.host, call_589515.base,
                         call_589515.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589515, url, valid)

proc call*(call_589516: Call_ContentDatafeedsUpdate_589501; merchantId: string;
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
  var path_589517 = newJObject()
  var query_589518 = newJObject()
  var body_589519 = newJObject()
  add(query_589518, "fields", newJString(fields))
  add(query_589518, "quotaUser", newJString(quotaUser))
  add(query_589518, "alt", newJString(alt))
  add(query_589518, "dryRun", newJBool(dryRun))
  add(query_589518, "oauth_token", newJString(oauthToken))
  add(query_589518, "userIp", newJString(userIp))
  add(query_589518, "key", newJString(key))
  add(path_589517, "merchantId", newJString(merchantId))
  if body != nil:
    body_589519 = body
  add(query_589518, "prettyPrint", newJBool(prettyPrint))
  add(path_589517, "datafeedId", newJString(datafeedId))
  result = call_589516.call(path_589517, query_589518, nil, nil, body_589519)

var contentDatafeedsUpdate* = Call_ContentDatafeedsUpdate_589501(
    name: "contentDatafeedsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsUpdate_589502, base: "/content/v2",
    url: url_ContentDatafeedsUpdate_589503, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsGet_589485 = ref object of OpenApiRestCall_588450
proc url_ContentDatafeedsGet_589487(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsGet_589486(path: JsonNode; query: JsonNode;
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
  var valid_589488 = path.getOrDefault("merchantId")
  valid_589488 = validateParameter(valid_589488, JString, required = true,
                                 default = nil)
  if valid_589488 != nil:
    section.add "merchantId", valid_589488
  var valid_589489 = path.getOrDefault("datafeedId")
  valid_589489 = validateParameter(valid_589489, JString, required = true,
                                 default = nil)
  if valid_589489 != nil:
    section.add "datafeedId", valid_589489
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589490 = query.getOrDefault("fields")
  valid_589490 = validateParameter(valid_589490, JString, required = false,
                                 default = nil)
  if valid_589490 != nil:
    section.add "fields", valid_589490
  var valid_589491 = query.getOrDefault("quotaUser")
  valid_589491 = validateParameter(valid_589491, JString, required = false,
                                 default = nil)
  if valid_589491 != nil:
    section.add "quotaUser", valid_589491
  var valid_589492 = query.getOrDefault("alt")
  valid_589492 = validateParameter(valid_589492, JString, required = false,
                                 default = newJString("json"))
  if valid_589492 != nil:
    section.add "alt", valid_589492
  var valid_589493 = query.getOrDefault("oauth_token")
  valid_589493 = validateParameter(valid_589493, JString, required = false,
                                 default = nil)
  if valid_589493 != nil:
    section.add "oauth_token", valid_589493
  var valid_589494 = query.getOrDefault("userIp")
  valid_589494 = validateParameter(valid_589494, JString, required = false,
                                 default = nil)
  if valid_589494 != nil:
    section.add "userIp", valid_589494
  var valid_589495 = query.getOrDefault("key")
  valid_589495 = validateParameter(valid_589495, JString, required = false,
                                 default = nil)
  if valid_589495 != nil:
    section.add "key", valid_589495
  var valid_589496 = query.getOrDefault("prettyPrint")
  valid_589496 = validateParameter(valid_589496, JBool, required = false,
                                 default = newJBool(true))
  if valid_589496 != nil:
    section.add "prettyPrint", valid_589496
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589497: Call_ContentDatafeedsGet_589485; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a datafeed configuration from your Merchant Center account.
  ## 
  let valid = call_589497.validator(path, query, header, formData, body)
  let scheme = call_589497.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589497.url(scheme.get, call_589497.host, call_589497.base,
                         call_589497.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589497, url, valid)

proc call*(call_589498: Call_ContentDatafeedsGet_589485; merchantId: string;
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
  var path_589499 = newJObject()
  var query_589500 = newJObject()
  add(query_589500, "fields", newJString(fields))
  add(query_589500, "quotaUser", newJString(quotaUser))
  add(query_589500, "alt", newJString(alt))
  add(query_589500, "oauth_token", newJString(oauthToken))
  add(query_589500, "userIp", newJString(userIp))
  add(query_589500, "key", newJString(key))
  add(path_589499, "merchantId", newJString(merchantId))
  add(query_589500, "prettyPrint", newJBool(prettyPrint))
  add(path_589499, "datafeedId", newJString(datafeedId))
  result = call_589498.call(path_589499, query_589500, nil, nil, nil)

var contentDatafeedsGet* = Call_ContentDatafeedsGet_589485(
    name: "contentDatafeedsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsGet_589486, base: "/content/v2",
    url: url_ContentDatafeedsGet_589487, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsPatch_589537 = ref object of OpenApiRestCall_588450
proc url_ContentDatafeedsPatch_589539(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsPatch_589538(path: JsonNode; query: JsonNode;
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
  var valid_589540 = path.getOrDefault("merchantId")
  valid_589540 = validateParameter(valid_589540, JString, required = true,
                                 default = nil)
  if valid_589540 != nil:
    section.add "merchantId", valid_589540
  var valid_589541 = path.getOrDefault("datafeedId")
  valid_589541 = validateParameter(valid_589541, JString, required = true,
                                 default = nil)
  if valid_589541 != nil:
    section.add "datafeedId", valid_589541
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
  var valid_589542 = query.getOrDefault("fields")
  valid_589542 = validateParameter(valid_589542, JString, required = false,
                                 default = nil)
  if valid_589542 != nil:
    section.add "fields", valid_589542
  var valid_589543 = query.getOrDefault("quotaUser")
  valid_589543 = validateParameter(valid_589543, JString, required = false,
                                 default = nil)
  if valid_589543 != nil:
    section.add "quotaUser", valid_589543
  var valid_589544 = query.getOrDefault("alt")
  valid_589544 = validateParameter(valid_589544, JString, required = false,
                                 default = newJString("json"))
  if valid_589544 != nil:
    section.add "alt", valid_589544
  var valid_589545 = query.getOrDefault("dryRun")
  valid_589545 = validateParameter(valid_589545, JBool, required = false, default = nil)
  if valid_589545 != nil:
    section.add "dryRun", valid_589545
  var valid_589546 = query.getOrDefault("oauth_token")
  valid_589546 = validateParameter(valid_589546, JString, required = false,
                                 default = nil)
  if valid_589546 != nil:
    section.add "oauth_token", valid_589546
  var valid_589547 = query.getOrDefault("userIp")
  valid_589547 = validateParameter(valid_589547, JString, required = false,
                                 default = nil)
  if valid_589547 != nil:
    section.add "userIp", valid_589547
  var valid_589548 = query.getOrDefault("key")
  valid_589548 = validateParameter(valid_589548, JString, required = false,
                                 default = nil)
  if valid_589548 != nil:
    section.add "key", valid_589548
  var valid_589549 = query.getOrDefault("prettyPrint")
  valid_589549 = validateParameter(valid_589549, JBool, required = false,
                                 default = newJBool(true))
  if valid_589549 != nil:
    section.add "prettyPrint", valid_589549
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

proc call*(call_589551: Call_ContentDatafeedsPatch_589537; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a datafeed configuration of your Merchant Center account. This method supports patch semantics.
  ## 
  let valid = call_589551.validator(path, query, header, formData, body)
  let scheme = call_589551.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589551.url(scheme.get, call_589551.host, call_589551.base,
                         call_589551.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589551, url, valid)

proc call*(call_589552: Call_ContentDatafeedsPatch_589537; merchantId: string;
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
  var path_589553 = newJObject()
  var query_589554 = newJObject()
  var body_589555 = newJObject()
  add(query_589554, "fields", newJString(fields))
  add(query_589554, "quotaUser", newJString(quotaUser))
  add(query_589554, "alt", newJString(alt))
  add(query_589554, "dryRun", newJBool(dryRun))
  add(query_589554, "oauth_token", newJString(oauthToken))
  add(query_589554, "userIp", newJString(userIp))
  add(query_589554, "key", newJString(key))
  add(path_589553, "merchantId", newJString(merchantId))
  if body != nil:
    body_589555 = body
  add(query_589554, "prettyPrint", newJBool(prettyPrint))
  add(path_589553, "datafeedId", newJString(datafeedId))
  result = call_589552.call(path_589553, query_589554, nil, nil, body_589555)

var contentDatafeedsPatch* = Call_ContentDatafeedsPatch_589537(
    name: "contentDatafeedsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsPatch_589538, base: "/content/v2",
    url: url_ContentDatafeedsPatch_589539, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsDelete_589520 = ref object of OpenApiRestCall_588450
proc url_ContentDatafeedsDelete_589522(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsDelete_589521(path: JsonNode; query: JsonNode;
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
  var valid_589523 = path.getOrDefault("merchantId")
  valid_589523 = validateParameter(valid_589523, JString, required = true,
                                 default = nil)
  if valid_589523 != nil:
    section.add "merchantId", valid_589523
  var valid_589524 = path.getOrDefault("datafeedId")
  valid_589524 = validateParameter(valid_589524, JString, required = true,
                                 default = nil)
  if valid_589524 != nil:
    section.add "datafeedId", valid_589524
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
  var valid_589525 = query.getOrDefault("fields")
  valid_589525 = validateParameter(valid_589525, JString, required = false,
                                 default = nil)
  if valid_589525 != nil:
    section.add "fields", valid_589525
  var valid_589526 = query.getOrDefault("quotaUser")
  valid_589526 = validateParameter(valid_589526, JString, required = false,
                                 default = nil)
  if valid_589526 != nil:
    section.add "quotaUser", valid_589526
  var valid_589527 = query.getOrDefault("alt")
  valid_589527 = validateParameter(valid_589527, JString, required = false,
                                 default = newJString("json"))
  if valid_589527 != nil:
    section.add "alt", valid_589527
  var valid_589528 = query.getOrDefault("dryRun")
  valid_589528 = validateParameter(valid_589528, JBool, required = false, default = nil)
  if valid_589528 != nil:
    section.add "dryRun", valid_589528
  var valid_589529 = query.getOrDefault("oauth_token")
  valid_589529 = validateParameter(valid_589529, JString, required = false,
                                 default = nil)
  if valid_589529 != nil:
    section.add "oauth_token", valid_589529
  var valid_589530 = query.getOrDefault("userIp")
  valid_589530 = validateParameter(valid_589530, JString, required = false,
                                 default = nil)
  if valid_589530 != nil:
    section.add "userIp", valid_589530
  var valid_589531 = query.getOrDefault("key")
  valid_589531 = validateParameter(valid_589531, JString, required = false,
                                 default = nil)
  if valid_589531 != nil:
    section.add "key", valid_589531
  var valid_589532 = query.getOrDefault("prettyPrint")
  valid_589532 = validateParameter(valid_589532, JBool, required = false,
                                 default = newJBool(true))
  if valid_589532 != nil:
    section.add "prettyPrint", valid_589532
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589533: Call_ContentDatafeedsDelete_589520; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a datafeed configuration from your Merchant Center account.
  ## 
  let valid = call_589533.validator(path, query, header, formData, body)
  let scheme = call_589533.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589533.url(scheme.get, call_589533.host, call_589533.base,
                         call_589533.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589533, url, valid)

proc call*(call_589534: Call_ContentDatafeedsDelete_589520; merchantId: string;
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
  var path_589535 = newJObject()
  var query_589536 = newJObject()
  add(query_589536, "fields", newJString(fields))
  add(query_589536, "quotaUser", newJString(quotaUser))
  add(query_589536, "alt", newJString(alt))
  add(query_589536, "dryRun", newJBool(dryRun))
  add(query_589536, "oauth_token", newJString(oauthToken))
  add(query_589536, "userIp", newJString(userIp))
  add(query_589536, "key", newJString(key))
  add(path_589535, "merchantId", newJString(merchantId))
  add(query_589536, "prettyPrint", newJBool(prettyPrint))
  add(path_589535, "datafeedId", newJString(datafeedId))
  result = call_589534.call(path_589535, query_589536, nil, nil, nil)

var contentDatafeedsDelete* = Call_ContentDatafeedsDelete_589520(
    name: "contentDatafeedsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsDelete_589521, base: "/content/v2",
    url: url_ContentDatafeedsDelete_589522, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsFetchnow_589556 = ref object of OpenApiRestCall_588450
proc url_ContentDatafeedsFetchnow_589558(protocol: Scheme; host: string;
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

proc validate_ContentDatafeedsFetchnow_589557(path: JsonNode; query: JsonNode;
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
  var valid_589559 = path.getOrDefault("merchantId")
  valid_589559 = validateParameter(valid_589559, JString, required = true,
                                 default = nil)
  if valid_589559 != nil:
    section.add "merchantId", valid_589559
  var valid_589560 = path.getOrDefault("datafeedId")
  valid_589560 = validateParameter(valid_589560, JString, required = true,
                                 default = nil)
  if valid_589560 != nil:
    section.add "datafeedId", valid_589560
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
  var valid_589561 = query.getOrDefault("fields")
  valid_589561 = validateParameter(valid_589561, JString, required = false,
                                 default = nil)
  if valid_589561 != nil:
    section.add "fields", valid_589561
  var valid_589562 = query.getOrDefault("quotaUser")
  valid_589562 = validateParameter(valid_589562, JString, required = false,
                                 default = nil)
  if valid_589562 != nil:
    section.add "quotaUser", valid_589562
  var valid_589563 = query.getOrDefault("alt")
  valid_589563 = validateParameter(valid_589563, JString, required = false,
                                 default = newJString("json"))
  if valid_589563 != nil:
    section.add "alt", valid_589563
  var valid_589564 = query.getOrDefault("dryRun")
  valid_589564 = validateParameter(valid_589564, JBool, required = false, default = nil)
  if valid_589564 != nil:
    section.add "dryRun", valid_589564
  var valid_589565 = query.getOrDefault("oauth_token")
  valid_589565 = validateParameter(valid_589565, JString, required = false,
                                 default = nil)
  if valid_589565 != nil:
    section.add "oauth_token", valid_589565
  var valid_589566 = query.getOrDefault("userIp")
  valid_589566 = validateParameter(valid_589566, JString, required = false,
                                 default = nil)
  if valid_589566 != nil:
    section.add "userIp", valid_589566
  var valid_589567 = query.getOrDefault("key")
  valid_589567 = validateParameter(valid_589567, JString, required = false,
                                 default = nil)
  if valid_589567 != nil:
    section.add "key", valid_589567
  var valid_589568 = query.getOrDefault("prettyPrint")
  valid_589568 = validateParameter(valid_589568, JBool, required = false,
                                 default = newJBool(true))
  if valid_589568 != nil:
    section.add "prettyPrint", valid_589568
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589569: Call_ContentDatafeedsFetchnow_589556; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Invokes a fetch for the datafeed in your Merchant Center account.
  ## 
  let valid = call_589569.validator(path, query, header, formData, body)
  let scheme = call_589569.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589569.url(scheme.get, call_589569.host, call_589569.base,
                         call_589569.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589569, url, valid)

proc call*(call_589570: Call_ContentDatafeedsFetchnow_589556; merchantId: string;
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
  var path_589571 = newJObject()
  var query_589572 = newJObject()
  add(query_589572, "fields", newJString(fields))
  add(query_589572, "quotaUser", newJString(quotaUser))
  add(query_589572, "alt", newJString(alt))
  add(query_589572, "dryRun", newJBool(dryRun))
  add(query_589572, "oauth_token", newJString(oauthToken))
  add(query_589572, "userIp", newJString(userIp))
  add(query_589572, "key", newJString(key))
  add(path_589571, "merchantId", newJString(merchantId))
  add(query_589572, "prettyPrint", newJBool(prettyPrint))
  add(path_589571, "datafeedId", newJString(datafeedId))
  result = call_589570.call(path_589571, query_589572, nil, nil, nil)

var contentDatafeedsFetchnow* = Call_ContentDatafeedsFetchnow_589556(
    name: "contentDatafeedsFetchnow", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/datafeeds/{datafeedId}/fetchNow",
    validator: validate_ContentDatafeedsFetchnow_589557, base: "/content/v2",
    url: url_ContentDatafeedsFetchnow_589558, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesList_589573 = ref object of OpenApiRestCall_588450
proc url_ContentDatafeedstatusesList_589575(protocol: Scheme; host: string;
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

proc validate_ContentDatafeedstatusesList_589574(path: JsonNode; query: JsonNode;
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
  var valid_589576 = path.getOrDefault("merchantId")
  valid_589576 = validateParameter(valid_589576, JString, required = true,
                                 default = nil)
  if valid_589576 != nil:
    section.add "merchantId", valid_589576
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
  var valid_589577 = query.getOrDefault("fields")
  valid_589577 = validateParameter(valid_589577, JString, required = false,
                                 default = nil)
  if valid_589577 != nil:
    section.add "fields", valid_589577
  var valid_589578 = query.getOrDefault("pageToken")
  valid_589578 = validateParameter(valid_589578, JString, required = false,
                                 default = nil)
  if valid_589578 != nil:
    section.add "pageToken", valid_589578
  var valid_589579 = query.getOrDefault("quotaUser")
  valid_589579 = validateParameter(valid_589579, JString, required = false,
                                 default = nil)
  if valid_589579 != nil:
    section.add "quotaUser", valid_589579
  var valid_589580 = query.getOrDefault("alt")
  valid_589580 = validateParameter(valid_589580, JString, required = false,
                                 default = newJString("json"))
  if valid_589580 != nil:
    section.add "alt", valid_589580
  var valid_589581 = query.getOrDefault("oauth_token")
  valid_589581 = validateParameter(valid_589581, JString, required = false,
                                 default = nil)
  if valid_589581 != nil:
    section.add "oauth_token", valid_589581
  var valid_589582 = query.getOrDefault("userIp")
  valid_589582 = validateParameter(valid_589582, JString, required = false,
                                 default = nil)
  if valid_589582 != nil:
    section.add "userIp", valid_589582
  var valid_589583 = query.getOrDefault("maxResults")
  valid_589583 = validateParameter(valid_589583, JInt, required = false, default = nil)
  if valid_589583 != nil:
    section.add "maxResults", valid_589583
  var valid_589584 = query.getOrDefault("key")
  valid_589584 = validateParameter(valid_589584, JString, required = false,
                                 default = nil)
  if valid_589584 != nil:
    section.add "key", valid_589584
  var valid_589585 = query.getOrDefault("prettyPrint")
  valid_589585 = validateParameter(valid_589585, JBool, required = false,
                                 default = newJBool(true))
  if valid_589585 != nil:
    section.add "prettyPrint", valid_589585
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589586: Call_ContentDatafeedstatusesList_589573; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the datafeeds in your Merchant Center account.
  ## 
  let valid = call_589586.validator(path, query, header, formData, body)
  let scheme = call_589586.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589586.url(scheme.get, call_589586.host, call_589586.base,
                         call_589586.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589586, url, valid)

proc call*(call_589587: Call_ContentDatafeedstatusesList_589573;
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
  var path_589588 = newJObject()
  var query_589589 = newJObject()
  add(query_589589, "fields", newJString(fields))
  add(query_589589, "pageToken", newJString(pageToken))
  add(query_589589, "quotaUser", newJString(quotaUser))
  add(query_589589, "alt", newJString(alt))
  add(query_589589, "oauth_token", newJString(oauthToken))
  add(query_589589, "userIp", newJString(userIp))
  add(query_589589, "maxResults", newJInt(maxResults))
  add(query_589589, "key", newJString(key))
  add(path_589588, "merchantId", newJString(merchantId))
  add(query_589589, "prettyPrint", newJBool(prettyPrint))
  result = call_589587.call(path_589588, query_589589, nil, nil, nil)

var contentDatafeedstatusesList* = Call_ContentDatafeedstatusesList_589573(
    name: "contentDatafeedstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeedstatuses",
    validator: validate_ContentDatafeedstatusesList_589574, base: "/content/v2",
    url: url_ContentDatafeedstatusesList_589575, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesGet_589590 = ref object of OpenApiRestCall_588450
proc url_ContentDatafeedstatusesGet_589592(protocol: Scheme; host: string;
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

proc validate_ContentDatafeedstatusesGet_589591(path: JsonNode; query: JsonNode;
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
  var valid_589593 = path.getOrDefault("merchantId")
  valid_589593 = validateParameter(valid_589593, JString, required = true,
                                 default = nil)
  if valid_589593 != nil:
    section.add "merchantId", valid_589593
  var valid_589594 = path.getOrDefault("datafeedId")
  valid_589594 = validateParameter(valid_589594, JString, required = true,
                                 default = nil)
  if valid_589594 != nil:
    section.add "datafeedId", valid_589594
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
  var valid_589595 = query.getOrDefault("fields")
  valid_589595 = validateParameter(valid_589595, JString, required = false,
                                 default = nil)
  if valid_589595 != nil:
    section.add "fields", valid_589595
  var valid_589596 = query.getOrDefault("country")
  valid_589596 = validateParameter(valid_589596, JString, required = false,
                                 default = nil)
  if valid_589596 != nil:
    section.add "country", valid_589596
  var valid_589597 = query.getOrDefault("quotaUser")
  valid_589597 = validateParameter(valid_589597, JString, required = false,
                                 default = nil)
  if valid_589597 != nil:
    section.add "quotaUser", valid_589597
  var valid_589598 = query.getOrDefault("alt")
  valid_589598 = validateParameter(valid_589598, JString, required = false,
                                 default = newJString("json"))
  if valid_589598 != nil:
    section.add "alt", valid_589598
  var valid_589599 = query.getOrDefault("language")
  valid_589599 = validateParameter(valid_589599, JString, required = false,
                                 default = nil)
  if valid_589599 != nil:
    section.add "language", valid_589599
  var valid_589600 = query.getOrDefault("oauth_token")
  valid_589600 = validateParameter(valid_589600, JString, required = false,
                                 default = nil)
  if valid_589600 != nil:
    section.add "oauth_token", valid_589600
  var valid_589601 = query.getOrDefault("userIp")
  valid_589601 = validateParameter(valid_589601, JString, required = false,
                                 default = nil)
  if valid_589601 != nil:
    section.add "userIp", valid_589601
  var valid_589602 = query.getOrDefault("key")
  valid_589602 = validateParameter(valid_589602, JString, required = false,
                                 default = nil)
  if valid_589602 != nil:
    section.add "key", valid_589602
  var valid_589603 = query.getOrDefault("prettyPrint")
  valid_589603 = validateParameter(valid_589603, JBool, required = false,
                                 default = newJBool(true))
  if valid_589603 != nil:
    section.add "prettyPrint", valid_589603
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589604: Call_ContentDatafeedstatusesGet_589590; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the status of a datafeed from your Merchant Center account.
  ## 
  let valid = call_589604.validator(path, query, header, formData, body)
  let scheme = call_589604.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589604.url(scheme.get, call_589604.host, call_589604.base,
                         call_589604.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589604, url, valid)

proc call*(call_589605: Call_ContentDatafeedstatusesGet_589590; merchantId: string;
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
  var path_589606 = newJObject()
  var query_589607 = newJObject()
  add(query_589607, "fields", newJString(fields))
  add(query_589607, "country", newJString(country))
  add(query_589607, "quotaUser", newJString(quotaUser))
  add(query_589607, "alt", newJString(alt))
  add(query_589607, "language", newJString(language))
  add(query_589607, "oauth_token", newJString(oauthToken))
  add(query_589607, "userIp", newJString(userIp))
  add(query_589607, "key", newJString(key))
  add(path_589606, "merchantId", newJString(merchantId))
  add(query_589607, "prettyPrint", newJBool(prettyPrint))
  add(path_589606, "datafeedId", newJString(datafeedId))
  result = call_589605.call(path_589606, query_589607, nil, nil, nil)

var contentDatafeedstatusesGet* = Call_ContentDatafeedstatusesGet_589590(
    name: "contentDatafeedstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/datafeedstatuses/{datafeedId}",
    validator: validate_ContentDatafeedstatusesGet_589591, base: "/content/v2",
    url: url_ContentDatafeedstatusesGet_589592, schemes: {Scheme.Https})
type
  Call_ContentInventorySet_589608 = ref object of OpenApiRestCall_588450
proc url_ContentInventorySet_589610(protocol: Scheme; host: string; base: string;
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

proc validate_ContentInventorySet_589609(path: JsonNode; query: JsonNode;
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
  var valid_589611 = path.getOrDefault("storeCode")
  valid_589611 = validateParameter(valid_589611, JString, required = true,
                                 default = nil)
  if valid_589611 != nil:
    section.add "storeCode", valid_589611
  var valid_589612 = path.getOrDefault("merchantId")
  valid_589612 = validateParameter(valid_589612, JString, required = true,
                                 default = nil)
  if valid_589612 != nil:
    section.add "merchantId", valid_589612
  var valid_589613 = path.getOrDefault("productId")
  valid_589613 = validateParameter(valid_589613, JString, required = true,
                                 default = nil)
  if valid_589613 != nil:
    section.add "productId", valid_589613
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
  var valid_589614 = query.getOrDefault("fields")
  valid_589614 = validateParameter(valid_589614, JString, required = false,
                                 default = nil)
  if valid_589614 != nil:
    section.add "fields", valid_589614
  var valid_589615 = query.getOrDefault("quotaUser")
  valid_589615 = validateParameter(valid_589615, JString, required = false,
                                 default = nil)
  if valid_589615 != nil:
    section.add "quotaUser", valid_589615
  var valid_589616 = query.getOrDefault("alt")
  valid_589616 = validateParameter(valid_589616, JString, required = false,
                                 default = newJString("json"))
  if valid_589616 != nil:
    section.add "alt", valid_589616
  var valid_589617 = query.getOrDefault("dryRun")
  valid_589617 = validateParameter(valid_589617, JBool, required = false, default = nil)
  if valid_589617 != nil:
    section.add "dryRun", valid_589617
  var valid_589618 = query.getOrDefault("oauth_token")
  valid_589618 = validateParameter(valid_589618, JString, required = false,
                                 default = nil)
  if valid_589618 != nil:
    section.add "oauth_token", valid_589618
  var valid_589619 = query.getOrDefault("userIp")
  valid_589619 = validateParameter(valid_589619, JString, required = false,
                                 default = nil)
  if valid_589619 != nil:
    section.add "userIp", valid_589619
  var valid_589620 = query.getOrDefault("key")
  valid_589620 = validateParameter(valid_589620, JString, required = false,
                                 default = nil)
  if valid_589620 != nil:
    section.add "key", valid_589620
  var valid_589621 = query.getOrDefault("prettyPrint")
  valid_589621 = validateParameter(valid_589621, JBool, required = false,
                                 default = newJBool(true))
  if valid_589621 != nil:
    section.add "prettyPrint", valid_589621
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

proc call*(call_589623: Call_ContentInventorySet_589608; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates price and availability of a product in your Merchant Center account.
  ## 
  let valid = call_589623.validator(path, query, header, formData, body)
  let scheme = call_589623.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589623.url(scheme.get, call_589623.host, call_589623.base,
                         call_589623.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589623, url, valid)

proc call*(call_589624: Call_ContentInventorySet_589608; storeCode: string;
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
  var path_589625 = newJObject()
  var query_589626 = newJObject()
  var body_589627 = newJObject()
  add(query_589626, "fields", newJString(fields))
  add(query_589626, "quotaUser", newJString(quotaUser))
  add(query_589626, "alt", newJString(alt))
  add(query_589626, "dryRun", newJBool(dryRun))
  add(query_589626, "oauth_token", newJString(oauthToken))
  add(path_589625, "storeCode", newJString(storeCode))
  add(query_589626, "userIp", newJString(userIp))
  add(query_589626, "key", newJString(key))
  add(path_589625, "merchantId", newJString(merchantId))
  if body != nil:
    body_589627 = body
  add(query_589626, "prettyPrint", newJBool(prettyPrint))
  add(path_589625, "productId", newJString(productId))
  result = call_589624.call(path_589625, query_589626, nil, nil, body_589627)

var contentInventorySet* = Call_ContentInventorySet_589608(
    name: "contentInventorySet", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/inventory/{storeCode}/products/{productId}",
    validator: validate_ContentInventorySet_589609, base: "/content/v2",
    url: url_ContentInventorySet_589610, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsList_589628 = ref object of OpenApiRestCall_588450
proc url_ContentLiasettingsList_589630(protocol: Scheme; host: string; base: string;
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

proc validate_ContentLiasettingsList_589629(path: JsonNode; query: JsonNode;
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
  var valid_589631 = path.getOrDefault("merchantId")
  valid_589631 = validateParameter(valid_589631, JString, required = true,
                                 default = nil)
  if valid_589631 != nil:
    section.add "merchantId", valid_589631
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
  var valid_589632 = query.getOrDefault("fields")
  valid_589632 = validateParameter(valid_589632, JString, required = false,
                                 default = nil)
  if valid_589632 != nil:
    section.add "fields", valid_589632
  var valid_589633 = query.getOrDefault("pageToken")
  valid_589633 = validateParameter(valid_589633, JString, required = false,
                                 default = nil)
  if valid_589633 != nil:
    section.add "pageToken", valid_589633
  var valid_589634 = query.getOrDefault("quotaUser")
  valid_589634 = validateParameter(valid_589634, JString, required = false,
                                 default = nil)
  if valid_589634 != nil:
    section.add "quotaUser", valid_589634
  var valid_589635 = query.getOrDefault("alt")
  valid_589635 = validateParameter(valid_589635, JString, required = false,
                                 default = newJString("json"))
  if valid_589635 != nil:
    section.add "alt", valid_589635
  var valid_589636 = query.getOrDefault("oauth_token")
  valid_589636 = validateParameter(valid_589636, JString, required = false,
                                 default = nil)
  if valid_589636 != nil:
    section.add "oauth_token", valid_589636
  var valid_589637 = query.getOrDefault("userIp")
  valid_589637 = validateParameter(valid_589637, JString, required = false,
                                 default = nil)
  if valid_589637 != nil:
    section.add "userIp", valid_589637
  var valid_589638 = query.getOrDefault("maxResults")
  valid_589638 = validateParameter(valid_589638, JInt, required = false, default = nil)
  if valid_589638 != nil:
    section.add "maxResults", valid_589638
  var valid_589639 = query.getOrDefault("key")
  valid_589639 = validateParameter(valid_589639, JString, required = false,
                                 default = nil)
  if valid_589639 != nil:
    section.add "key", valid_589639
  var valid_589640 = query.getOrDefault("prettyPrint")
  valid_589640 = validateParameter(valid_589640, JBool, required = false,
                                 default = newJBool(true))
  if valid_589640 != nil:
    section.add "prettyPrint", valid_589640
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589641: Call_ContentLiasettingsList_589628; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the LIA settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_589641.validator(path, query, header, formData, body)
  let scheme = call_589641.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589641.url(scheme.get, call_589641.host, call_589641.base,
                         call_589641.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589641, url, valid)

proc call*(call_589642: Call_ContentLiasettingsList_589628; merchantId: string;
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
  var path_589643 = newJObject()
  var query_589644 = newJObject()
  add(query_589644, "fields", newJString(fields))
  add(query_589644, "pageToken", newJString(pageToken))
  add(query_589644, "quotaUser", newJString(quotaUser))
  add(query_589644, "alt", newJString(alt))
  add(query_589644, "oauth_token", newJString(oauthToken))
  add(query_589644, "userIp", newJString(userIp))
  add(query_589644, "maxResults", newJInt(maxResults))
  add(query_589644, "key", newJString(key))
  add(path_589643, "merchantId", newJString(merchantId))
  add(query_589644, "prettyPrint", newJBool(prettyPrint))
  result = call_589642.call(path_589643, query_589644, nil, nil, nil)

var contentLiasettingsList* = Call_ContentLiasettingsList_589628(
    name: "contentLiasettingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings",
    validator: validate_ContentLiasettingsList_589629, base: "/content/v2",
    url: url_ContentLiasettingsList_589630, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsUpdate_589661 = ref object of OpenApiRestCall_588450
proc url_ContentLiasettingsUpdate_589663(protocol: Scheme; host: string;
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

proc validate_ContentLiasettingsUpdate_589662(path: JsonNode; query: JsonNode;
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
  var valid_589664 = path.getOrDefault("accountId")
  valid_589664 = validateParameter(valid_589664, JString, required = true,
                                 default = nil)
  if valid_589664 != nil:
    section.add "accountId", valid_589664
  var valid_589665 = path.getOrDefault("merchantId")
  valid_589665 = validateParameter(valid_589665, JString, required = true,
                                 default = nil)
  if valid_589665 != nil:
    section.add "merchantId", valid_589665
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
  var valid_589666 = query.getOrDefault("fields")
  valid_589666 = validateParameter(valid_589666, JString, required = false,
                                 default = nil)
  if valid_589666 != nil:
    section.add "fields", valid_589666
  var valid_589667 = query.getOrDefault("quotaUser")
  valid_589667 = validateParameter(valid_589667, JString, required = false,
                                 default = nil)
  if valid_589667 != nil:
    section.add "quotaUser", valid_589667
  var valid_589668 = query.getOrDefault("alt")
  valid_589668 = validateParameter(valid_589668, JString, required = false,
                                 default = newJString("json"))
  if valid_589668 != nil:
    section.add "alt", valid_589668
  var valid_589669 = query.getOrDefault("dryRun")
  valid_589669 = validateParameter(valid_589669, JBool, required = false, default = nil)
  if valid_589669 != nil:
    section.add "dryRun", valid_589669
  var valid_589670 = query.getOrDefault("oauth_token")
  valid_589670 = validateParameter(valid_589670, JString, required = false,
                                 default = nil)
  if valid_589670 != nil:
    section.add "oauth_token", valid_589670
  var valid_589671 = query.getOrDefault("userIp")
  valid_589671 = validateParameter(valid_589671, JString, required = false,
                                 default = nil)
  if valid_589671 != nil:
    section.add "userIp", valid_589671
  var valid_589672 = query.getOrDefault("key")
  valid_589672 = validateParameter(valid_589672, JString, required = false,
                                 default = nil)
  if valid_589672 != nil:
    section.add "key", valid_589672
  var valid_589673 = query.getOrDefault("prettyPrint")
  valid_589673 = validateParameter(valid_589673, JBool, required = false,
                                 default = newJBool(true))
  if valid_589673 != nil:
    section.add "prettyPrint", valid_589673
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

proc call*(call_589675: Call_ContentLiasettingsUpdate_589661; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the LIA settings of the account.
  ## 
  let valid = call_589675.validator(path, query, header, formData, body)
  let scheme = call_589675.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589675.url(scheme.get, call_589675.host, call_589675.base,
                         call_589675.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589675, url, valid)

proc call*(call_589676: Call_ContentLiasettingsUpdate_589661; accountId: string;
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
  var path_589677 = newJObject()
  var query_589678 = newJObject()
  var body_589679 = newJObject()
  add(query_589678, "fields", newJString(fields))
  add(query_589678, "quotaUser", newJString(quotaUser))
  add(query_589678, "alt", newJString(alt))
  add(query_589678, "dryRun", newJBool(dryRun))
  add(query_589678, "oauth_token", newJString(oauthToken))
  add(path_589677, "accountId", newJString(accountId))
  add(query_589678, "userIp", newJString(userIp))
  add(query_589678, "key", newJString(key))
  add(path_589677, "merchantId", newJString(merchantId))
  if body != nil:
    body_589679 = body
  add(query_589678, "prettyPrint", newJBool(prettyPrint))
  result = call_589676.call(path_589677, query_589678, nil, nil, body_589679)

var contentLiasettingsUpdate* = Call_ContentLiasettingsUpdate_589661(
    name: "contentLiasettingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}",
    validator: validate_ContentLiasettingsUpdate_589662, base: "/content/v2",
    url: url_ContentLiasettingsUpdate_589663, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsGet_589645 = ref object of OpenApiRestCall_588450
proc url_ContentLiasettingsGet_589647(protocol: Scheme; host: string; base: string;
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

proc validate_ContentLiasettingsGet_589646(path: JsonNode; query: JsonNode;
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
  var valid_589648 = path.getOrDefault("accountId")
  valid_589648 = validateParameter(valid_589648, JString, required = true,
                                 default = nil)
  if valid_589648 != nil:
    section.add "accountId", valid_589648
  var valid_589649 = path.getOrDefault("merchantId")
  valid_589649 = validateParameter(valid_589649, JString, required = true,
                                 default = nil)
  if valid_589649 != nil:
    section.add "merchantId", valid_589649
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589650 = query.getOrDefault("fields")
  valid_589650 = validateParameter(valid_589650, JString, required = false,
                                 default = nil)
  if valid_589650 != nil:
    section.add "fields", valid_589650
  var valid_589651 = query.getOrDefault("quotaUser")
  valid_589651 = validateParameter(valid_589651, JString, required = false,
                                 default = nil)
  if valid_589651 != nil:
    section.add "quotaUser", valid_589651
  var valid_589652 = query.getOrDefault("alt")
  valid_589652 = validateParameter(valid_589652, JString, required = false,
                                 default = newJString("json"))
  if valid_589652 != nil:
    section.add "alt", valid_589652
  var valid_589653 = query.getOrDefault("oauth_token")
  valid_589653 = validateParameter(valid_589653, JString, required = false,
                                 default = nil)
  if valid_589653 != nil:
    section.add "oauth_token", valid_589653
  var valid_589654 = query.getOrDefault("userIp")
  valid_589654 = validateParameter(valid_589654, JString, required = false,
                                 default = nil)
  if valid_589654 != nil:
    section.add "userIp", valid_589654
  var valid_589655 = query.getOrDefault("key")
  valid_589655 = validateParameter(valid_589655, JString, required = false,
                                 default = nil)
  if valid_589655 != nil:
    section.add "key", valid_589655
  var valid_589656 = query.getOrDefault("prettyPrint")
  valid_589656 = validateParameter(valid_589656, JBool, required = false,
                                 default = newJBool(true))
  if valid_589656 != nil:
    section.add "prettyPrint", valid_589656
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589657: Call_ContentLiasettingsGet_589645; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the LIA settings of the account.
  ## 
  let valid = call_589657.validator(path, query, header, formData, body)
  let scheme = call_589657.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589657.url(scheme.get, call_589657.host, call_589657.base,
                         call_589657.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589657, url, valid)

proc call*(call_589658: Call_ContentLiasettingsGet_589645; accountId: string;
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
  var path_589659 = newJObject()
  var query_589660 = newJObject()
  add(query_589660, "fields", newJString(fields))
  add(query_589660, "quotaUser", newJString(quotaUser))
  add(query_589660, "alt", newJString(alt))
  add(query_589660, "oauth_token", newJString(oauthToken))
  add(path_589659, "accountId", newJString(accountId))
  add(query_589660, "userIp", newJString(userIp))
  add(query_589660, "key", newJString(key))
  add(path_589659, "merchantId", newJString(merchantId))
  add(query_589660, "prettyPrint", newJBool(prettyPrint))
  result = call_589658.call(path_589659, query_589660, nil, nil, nil)

var contentLiasettingsGet* = Call_ContentLiasettingsGet_589645(
    name: "contentLiasettingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}",
    validator: validate_ContentLiasettingsGet_589646, base: "/content/v2",
    url: url_ContentLiasettingsGet_589647, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsPatch_589680 = ref object of OpenApiRestCall_588450
proc url_ContentLiasettingsPatch_589682(protocol: Scheme; host: string; base: string;
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

proc validate_ContentLiasettingsPatch_589681(path: JsonNode; query: JsonNode;
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
  var valid_589683 = path.getOrDefault("accountId")
  valid_589683 = validateParameter(valid_589683, JString, required = true,
                                 default = nil)
  if valid_589683 != nil:
    section.add "accountId", valid_589683
  var valid_589684 = path.getOrDefault("merchantId")
  valid_589684 = validateParameter(valid_589684, JString, required = true,
                                 default = nil)
  if valid_589684 != nil:
    section.add "merchantId", valid_589684
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
  var valid_589685 = query.getOrDefault("fields")
  valid_589685 = validateParameter(valid_589685, JString, required = false,
                                 default = nil)
  if valid_589685 != nil:
    section.add "fields", valid_589685
  var valid_589686 = query.getOrDefault("quotaUser")
  valid_589686 = validateParameter(valid_589686, JString, required = false,
                                 default = nil)
  if valid_589686 != nil:
    section.add "quotaUser", valid_589686
  var valid_589687 = query.getOrDefault("alt")
  valid_589687 = validateParameter(valid_589687, JString, required = false,
                                 default = newJString("json"))
  if valid_589687 != nil:
    section.add "alt", valid_589687
  var valid_589688 = query.getOrDefault("dryRun")
  valid_589688 = validateParameter(valid_589688, JBool, required = false, default = nil)
  if valid_589688 != nil:
    section.add "dryRun", valid_589688
  var valid_589689 = query.getOrDefault("oauth_token")
  valid_589689 = validateParameter(valid_589689, JString, required = false,
                                 default = nil)
  if valid_589689 != nil:
    section.add "oauth_token", valid_589689
  var valid_589690 = query.getOrDefault("userIp")
  valid_589690 = validateParameter(valid_589690, JString, required = false,
                                 default = nil)
  if valid_589690 != nil:
    section.add "userIp", valid_589690
  var valid_589691 = query.getOrDefault("key")
  valid_589691 = validateParameter(valid_589691, JString, required = false,
                                 default = nil)
  if valid_589691 != nil:
    section.add "key", valid_589691
  var valid_589692 = query.getOrDefault("prettyPrint")
  valid_589692 = validateParameter(valid_589692, JBool, required = false,
                                 default = newJBool(true))
  if valid_589692 != nil:
    section.add "prettyPrint", valid_589692
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

proc call*(call_589694: Call_ContentLiasettingsPatch_589680; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the LIA settings of the account. This method supports patch semantics.
  ## 
  let valid = call_589694.validator(path, query, header, formData, body)
  let scheme = call_589694.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589694.url(scheme.get, call_589694.host, call_589694.base,
                         call_589694.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589694, url, valid)

proc call*(call_589695: Call_ContentLiasettingsPatch_589680; accountId: string;
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
  var path_589696 = newJObject()
  var query_589697 = newJObject()
  var body_589698 = newJObject()
  add(query_589697, "fields", newJString(fields))
  add(query_589697, "quotaUser", newJString(quotaUser))
  add(query_589697, "alt", newJString(alt))
  add(query_589697, "dryRun", newJBool(dryRun))
  add(query_589697, "oauth_token", newJString(oauthToken))
  add(path_589696, "accountId", newJString(accountId))
  add(query_589697, "userIp", newJString(userIp))
  add(query_589697, "key", newJString(key))
  add(path_589696, "merchantId", newJString(merchantId))
  if body != nil:
    body_589698 = body
  add(query_589697, "prettyPrint", newJBool(prettyPrint))
  result = call_589695.call(path_589696, query_589697, nil, nil, body_589698)

var contentLiasettingsPatch* = Call_ContentLiasettingsPatch_589680(
    name: "contentLiasettingsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}",
    validator: validate_ContentLiasettingsPatch_589681, base: "/content/v2",
    url: url_ContentLiasettingsPatch_589682, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsGetaccessiblegmbaccounts_589699 = ref object of OpenApiRestCall_588450
proc url_ContentLiasettingsGetaccessiblegmbaccounts_589701(protocol: Scheme;
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

proc validate_ContentLiasettingsGetaccessiblegmbaccounts_589700(path: JsonNode;
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
  var valid_589702 = path.getOrDefault("accountId")
  valid_589702 = validateParameter(valid_589702, JString, required = true,
                                 default = nil)
  if valid_589702 != nil:
    section.add "accountId", valid_589702
  var valid_589703 = path.getOrDefault("merchantId")
  valid_589703 = validateParameter(valid_589703, JString, required = true,
                                 default = nil)
  if valid_589703 != nil:
    section.add "merchantId", valid_589703
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589704 = query.getOrDefault("fields")
  valid_589704 = validateParameter(valid_589704, JString, required = false,
                                 default = nil)
  if valid_589704 != nil:
    section.add "fields", valid_589704
  var valid_589705 = query.getOrDefault("quotaUser")
  valid_589705 = validateParameter(valid_589705, JString, required = false,
                                 default = nil)
  if valid_589705 != nil:
    section.add "quotaUser", valid_589705
  var valid_589706 = query.getOrDefault("alt")
  valid_589706 = validateParameter(valid_589706, JString, required = false,
                                 default = newJString("json"))
  if valid_589706 != nil:
    section.add "alt", valid_589706
  var valid_589707 = query.getOrDefault("oauth_token")
  valid_589707 = validateParameter(valid_589707, JString, required = false,
                                 default = nil)
  if valid_589707 != nil:
    section.add "oauth_token", valid_589707
  var valid_589708 = query.getOrDefault("userIp")
  valid_589708 = validateParameter(valid_589708, JString, required = false,
                                 default = nil)
  if valid_589708 != nil:
    section.add "userIp", valid_589708
  var valid_589709 = query.getOrDefault("key")
  valid_589709 = validateParameter(valid_589709, JString, required = false,
                                 default = nil)
  if valid_589709 != nil:
    section.add "key", valid_589709
  var valid_589710 = query.getOrDefault("prettyPrint")
  valid_589710 = validateParameter(valid_589710, JBool, required = false,
                                 default = newJBool(true))
  if valid_589710 != nil:
    section.add "prettyPrint", valid_589710
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589711: Call_ContentLiasettingsGetaccessiblegmbaccounts_589699;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of accessible Google My Business accounts.
  ## 
  let valid = call_589711.validator(path, query, header, formData, body)
  let scheme = call_589711.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589711.url(scheme.get, call_589711.host, call_589711.base,
                         call_589711.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589711, url, valid)

proc call*(call_589712: Call_ContentLiasettingsGetaccessiblegmbaccounts_589699;
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
  var path_589713 = newJObject()
  var query_589714 = newJObject()
  add(query_589714, "fields", newJString(fields))
  add(query_589714, "quotaUser", newJString(quotaUser))
  add(query_589714, "alt", newJString(alt))
  add(query_589714, "oauth_token", newJString(oauthToken))
  add(path_589713, "accountId", newJString(accountId))
  add(query_589714, "userIp", newJString(userIp))
  add(query_589714, "key", newJString(key))
  add(path_589713, "merchantId", newJString(merchantId))
  add(query_589714, "prettyPrint", newJBool(prettyPrint))
  result = call_589712.call(path_589713, query_589714, nil, nil, nil)

var contentLiasettingsGetaccessiblegmbaccounts* = Call_ContentLiasettingsGetaccessiblegmbaccounts_589699(
    name: "contentLiasettingsGetaccessiblegmbaccounts", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/accessiblegmbaccounts",
    validator: validate_ContentLiasettingsGetaccessiblegmbaccounts_589700,
    base: "/content/v2", url: url_ContentLiasettingsGetaccessiblegmbaccounts_589701,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsRequestgmbaccess_589715 = ref object of OpenApiRestCall_588450
proc url_ContentLiasettingsRequestgmbaccess_589717(protocol: Scheme; host: string;
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

proc validate_ContentLiasettingsRequestgmbaccess_589716(path: JsonNode;
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
  var valid_589718 = path.getOrDefault("accountId")
  valid_589718 = validateParameter(valid_589718, JString, required = true,
                                 default = nil)
  if valid_589718 != nil:
    section.add "accountId", valid_589718
  var valid_589719 = path.getOrDefault("merchantId")
  valid_589719 = validateParameter(valid_589719, JString, required = true,
                                 default = nil)
  if valid_589719 != nil:
    section.add "merchantId", valid_589719
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
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
  var valid_589720 = query.getOrDefault("fields")
  valid_589720 = validateParameter(valid_589720, JString, required = false,
                                 default = nil)
  if valid_589720 != nil:
    section.add "fields", valid_589720
  var valid_589721 = query.getOrDefault("quotaUser")
  valid_589721 = validateParameter(valid_589721, JString, required = false,
                                 default = nil)
  if valid_589721 != nil:
    section.add "quotaUser", valid_589721
  var valid_589722 = query.getOrDefault("alt")
  valid_589722 = validateParameter(valid_589722, JString, required = false,
                                 default = newJString("json"))
  if valid_589722 != nil:
    section.add "alt", valid_589722
  var valid_589723 = query.getOrDefault("oauth_token")
  valid_589723 = validateParameter(valid_589723, JString, required = false,
                                 default = nil)
  if valid_589723 != nil:
    section.add "oauth_token", valid_589723
  var valid_589724 = query.getOrDefault("userIp")
  valid_589724 = validateParameter(valid_589724, JString, required = false,
                                 default = nil)
  if valid_589724 != nil:
    section.add "userIp", valid_589724
  var valid_589725 = query.getOrDefault("key")
  valid_589725 = validateParameter(valid_589725, JString, required = false,
                                 default = nil)
  if valid_589725 != nil:
    section.add "key", valid_589725
  assert query != nil,
        "query argument is necessary due to required `gmbEmail` field"
  var valid_589726 = query.getOrDefault("gmbEmail")
  valid_589726 = validateParameter(valid_589726, JString, required = true,
                                 default = nil)
  if valid_589726 != nil:
    section.add "gmbEmail", valid_589726
  var valid_589727 = query.getOrDefault("prettyPrint")
  valid_589727 = validateParameter(valid_589727, JBool, required = false,
                                 default = newJBool(true))
  if valid_589727 != nil:
    section.add "prettyPrint", valid_589727
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589728: Call_ContentLiasettingsRequestgmbaccess_589715;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests access to a specified Google My Business account.
  ## 
  let valid = call_589728.validator(path, query, header, formData, body)
  let scheme = call_589728.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589728.url(scheme.get, call_589728.host, call_589728.base,
                         call_589728.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589728, url, valid)

proc call*(call_589729: Call_ContentLiasettingsRequestgmbaccess_589715;
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
  var path_589730 = newJObject()
  var query_589731 = newJObject()
  add(query_589731, "fields", newJString(fields))
  add(query_589731, "quotaUser", newJString(quotaUser))
  add(query_589731, "alt", newJString(alt))
  add(query_589731, "oauth_token", newJString(oauthToken))
  add(path_589730, "accountId", newJString(accountId))
  add(query_589731, "userIp", newJString(userIp))
  add(query_589731, "key", newJString(key))
  add(query_589731, "gmbEmail", newJString(gmbEmail))
  add(path_589730, "merchantId", newJString(merchantId))
  add(query_589731, "prettyPrint", newJBool(prettyPrint))
  result = call_589729.call(path_589730, query_589731, nil, nil, nil)

var contentLiasettingsRequestgmbaccess* = Call_ContentLiasettingsRequestgmbaccess_589715(
    name: "contentLiasettingsRequestgmbaccess", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/requestgmbaccess",
    validator: validate_ContentLiasettingsRequestgmbaccess_589716,
    base: "/content/v2", url: url_ContentLiasettingsRequestgmbaccess_589717,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsRequestinventoryverification_589732 = ref object of OpenApiRestCall_588450
proc url_ContentLiasettingsRequestinventoryverification_589734(protocol: Scheme;
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

proc validate_ContentLiasettingsRequestinventoryverification_589733(
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
  var valid_589735 = path.getOrDefault("country")
  valid_589735 = validateParameter(valid_589735, JString, required = true,
                                 default = nil)
  if valid_589735 != nil:
    section.add "country", valid_589735
  var valid_589736 = path.getOrDefault("accountId")
  valid_589736 = validateParameter(valid_589736, JString, required = true,
                                 default = nil)
  if valid_589736 != nil:
    section.add "accountId", valid_589736
  var valid_589737 = path.getOrDefault("merchantId")
  valid_589737 = validateParameter(valid_589737, JString, required = true,
                                 default = nil)
  if valid_589737 != nil:
    section.add "merchantId", valid_589737
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589738 = query.getOrDefault("fields")
  valid_589738 = validateParameter(valid_589738, JString, required = false,
                                 default = nil)
  if valid_589738 != nil:
    section.add "fields", valid_589738
  var valid_589739 = query.getOrDefault("quotaUser")
  valid_589739 = validateParameter(valid_589739, JString, required = false,
                                 default = nil)
  if valid_589739 != nil:
    section.add "quotaUser", valid_589739
  var valid_589740 = query.getOrDefault("alt")
  valid_589740 = validateParameter(valid_589740, JString, required = false,
                                 default = newJString("json"))
  if valid_589740 != nil:
    section.add "alt", valid_589740
  var valid_589741 = query.getOrDefault("oauth_token")
  valid_589741 = validateParameter(valid_589741, JString, required = false,
                                 default = nil)
  if valid_589741 != nil:
    section.add "oauth_token", valid_589741
  var valid_589742 = query.getOrDefault("userIp")
  valid_589742 = validateParameter(valid_589742, JString, required = false,
                                 default = nil)
  if valid_589742 != nil:
    section.add "userIp", valid_589742
  var valid_589743 = query.getOrDefault("key")
  valid_589743 = validateParameter(valid_589743, JString, required = false,
                                 default = nil)
  if valid_589743 != nil:
    section.add "key", valid_589743
  var valid_589744 = query.getOrDefault("prettyPrint")
  valid_589744 = validateParameter(valid_589744, JBool, required = false,
                                 default = newJBool(true))
  if valid_589744 != nil:
    section.add "prettyPrint", valid_589744
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589745: Call_ContentLiasettingsRequestinventoryverification_589732;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests inventory validation for the specified country.
  ## 
  let valid = call_589745.validator(path, query, header, formData, body)
  let scheme = call_589745.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589745.url(scheme.get, call_589745.host, call_589745.base,
                         call_589745.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589745, url, valid)

proc call*(call_589746: Call_ContentLiasettingsRequestinventoryverification_589732;
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
  var path_589747 = newJObject()
  var query_589748 = newJObject()
  add(query_589748, "fields", newJString(fields))
  add(query_589748, "quotaUser", newJString(quotaUser))
  add(query_589748, "alt", newJString(alt))
  add(path_589747, "country", newJString(country))
  add(query_589748, "oauth_token", newJString(oauthToken))
  add(path_589747, "accountId", newJString(accountId))
  add(query_589748, "userIp", newJString(userIp))
  add(query_589748, "key", newJString(key))
  add(path_589747, "merchantId", newJString(merchantId))
  add(query_589748, "prettyPrint", newJBool(prettyPrint))
  result = call_589746.call(path_589747, query_589748, nil, nil, nil)

var contentLiasettingsRequestinventoryverification* = Call_ContentLiasettingsRequestinventoryverification_589732(
    name: "contentLiasettingsRequestinventoryverification",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}/requestinventoryverification/{country}",
    validator: validate_ContentLiasettingsRequestinventoryverification_589733,
    base: "/content/v2", url: url_ContentLiasettingsRequestinventoryverification_589734,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsSetinventoryverificationcontact_589749 = ref object of OpenApiRestCall_588450
proc url_ContentLiasettingsSetinventoryverificationcontact_589751(
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

proc validate_ContentLiasettingsSetinventoryverificationcontact_589750(
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
  var valid_589752 = path.getOrDefault("accountId")
  valid_589752 = validateParameter(valid_589752, JString, required = true,
                                 default = nil)
  if valid_589752 != nil:
    section.add "accountId", valid_589752
  var valid_589753 = path.getOrDefault("merchantId")
  valid_589753 = validateParameter(valid_589753, JString, required = true,
                                 default = nil)
  if valid_589753 != nil:
    section.add "merchantId", valid_589753
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
  var valid_589754 = query.getOrDefault("fields")
  valid_589754 = validateParameter(valid_589754, JString, required = false,
                                 default = nil)
  if valid_589754 != nil:
    section.add "fields", valid_589754
  assert query != nil, "query argument is necessary due to required `country` field"
  var valid_589755 = query.getOrDefault("country")
  valid_589755 = validateParameter(valid_589755, JString, required = true,
                                 default = nil)
  if valid_589755 != nil:
    section.add "country", valid_589755
  var valid_589756 = query.getOrDefault("quotaUser")
  valid_589756 = validateParameter(valid_589756, JString, required = false,
                                 default = nil)
  if valid_589756 != nil:
    section.add "quotaUser", valid_589756
  var valid_589757 = query.getOrDefault("alt")
  valid_589757 = validateParameter(valid_589757, JString, required = false,
                                 default = newJString("json"))
  if valid_589757 != nil:
    section.add "alt", valid_589757
  var valid_589758 = query.getOrDefault("contactName")
  valid_589758 = validateParameter(valid_589758, JString, required = true,
                                 default = nil)
  if valid_589758 != nil:
    section.add "contactName", valid_589758
  var valid_589759 = query.getOrDefault("language")
  valid_589759 = validateParameter(valid_589759, JString, required = true,
                                 default = nil)
  if valid_589759 != nil:
    section.add "language", valid_589759
  var valid_589760 = query.getOrDefault("oauth_token")
  valid_589760 = validateParameter(valid_589760, JString, required = false,
                                 default = nil)
  if valid_589760 != nil:
    section.add "oauth_token", valid_589760
  var valid_589761 = query.getOrDefault("userIp")
  valid_589761 = validateParameter(valid_589761, JString, required = false,
                                 default = nil)
  if valid_589761 != nil:
    section.add "userIp", valid_589761
  var valid_589762 = query.getOrDefault("key")
  valid_589762 = validateParameter(valid_589762, JString, required = false,
                                 default = nil)
  if valid_589762 != nil:
    section.add "key", valid_589762
  var valid_589763 = query.getOrDefault("prettyPrint")
  valid_589763 = validateParameter(valid_589763, JBool, required = false,
                                 default = newJBool(true))
  if valid_589763 != nil:
    section.add "prettyPrint", valid_589763
  var valid_589764 = query.getOrDefault("contactEmail")
  valid_589764 = validateParameter(valid_589764, JString, required = true,
                                 default = nil)
  if valid_589764 != nil:
    section.add "contactEmail", valid_589764
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589765: Call_ContentLiasettingsSetinventoryverificationcontact_589749;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the inventory verification contract for the specified country.
  ## 
  let valid = call_589765.validator(path, query, header, formData, body)
  let scheme = call_589765.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589765.url(scheme.get, call_589765.host, call_589765.base,
                         call_589765.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589765, url, valid)

proc call*(call_589766: Call_ContentLiasettingsSetinventoryverificationcontact_589749;
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
  var path_589767 = newJObject()
  var query_589768 = newJObject()
  add(query_589768, "fields", newJString(fields))
  add(query_589768, "country", newJString(country))
  add(query_589768, "quotaUser", newJString(quotaUser))
  add(query_589768, "alt", newJString(alt))
  add(query_589768, "contactName", newJString(contactName))
  add(query_589768, "language", newJString(language))
  add(query_589768, "oauth_token", newJString(oauthToken))
  add(path_589767, "accountId", newJString(accountId))
  add(query_589768, "userIp", newJString(userIp))
  add(query_589768, "key", newJString(key))
  add(path_589767, "merchantId", newJString(merchantId))
  add(query_589768, "prettyPrint", newJBool(prettyPrint))
  add(query_589768, "contactEmail", newJString(contactEmail))
  result = call_589766.call(path_589767, query_589768, nil, nil, nil)

var contentLiasettingsSetinventoryverificationcontact* = Call_ContentLiasettingsSetinventoryverificationcontact_589749(
    name: "contentLiasettingsSetinventoryverificationcontact",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}/setinventoryverificationcontact",
    validator: validate_ContentLiasettingsSetinventoryverificationcontact_589750,
    base: "/content/v2",
    url: url_ContentLiasettingsSetinventoryverificationcontact_589751,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsSetposdataprovider_589769 = ref object of OpenApiRestCall_588450
proc url_ContentLiasettingsSetposdataprovider_589771(protocol: Scheme;
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

proc validate_ContentLiasettingsSetposdataprovider_589770(path: JsonNode;
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
  var valid_589772 = path.getOrDefault("accountId")
  valid_589772 = validateParameter(valid_589772, JString, required = true,
                                 default = nil)
  if valid_589772 != nil:
    section.add "accountId", valid_589772
  var valid_589773 = path.getOrDefault("merchantId")
  valid_589773 = validateParameter(valid_589773, JString, required = true,
                                 default = nil)
  if valid_589773 != nil:
    section.add "merchantId", valid_589773
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
  var valid_589774 = query.getOrDefault("fields")
  valid_589774 = validateParameter(valid_589774, JString, required = false,
                                 default = nil)
  if valid_589774 != nil:
    section.add "fields", valid_589774
  assert query != nil, "query argument is necessary due to required `country` field"
  var valid_589775 = query.getOrDefault("country")
  valid_589775 = validateParameter(valid_589775, JString, required = true,
                                 default = nil)
  if valid_589775 != nil:
    section.add "country", valid_589775
  var valid_589776 = query.getOrDefault("quotaUser")
  valid_589776 = validateParameter(valid_589776, JString, required = false,
                                 default = nil)
  if valid_589776 != nil:
    section.add "quotaUser", valid_589776
  var valid_589777 = query.getOrDefault("alt")
  valid_589777 = validateParameter(valid_589777, JString, required = false,
                                 default = newJString("json"))
  if valid_589777 != nil:
    section.add "alt", valid_589777
  var valid_589778 = query.getOrDefault("oauth_token")
  valid_589778 = validateParameter(valid_589778, JString, required = false,
                                 default = nil)
  if valid_589778 != nil:
    section.add "oauth_token", valid_589778
  var valid_589779 = query.getOrDefault("userIp")
  valid_589779 = validateParameter(valid_589779, JString, required = false,
                                 default = nil)
  if valid_589779 != nil:
    section.add "userIp", valid_589779
  var valid_589780 = query.getOrDefault("posExternalAccountId")
  valid_589780 = validateParameter(valid_589780, JString, required = false,
                                 default = nil)
  if valid_589780 != nil:
    section.add "posExternalAccountId", valid_589780
  var valid_589781 = query.getOrDefault("key")
  valid_589781 = validateParameter(valid_589781, JString, required = false,
                                 default = nil)
  if valid_589781 != nil:
    section.add "key", valid_589781
  var valid_589782 = query.getOrDefault("posDataProviderId")
  valid_589782 = validateParameter(valid_589782, JString, required = false,
                                 default = nil)
  if valid_589782 != nil:
    section.add "posDataProviderId", valid_589782
  var valid_589783 = query.getOrDefault("prettyPrint")
  valid_589783 = validateParameter(valid_589783, JBool, required = false,
                                 default = newJBool(true))
  if valid_589783 != nil:
    section.add "prettyPrint", valid_589783
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589784: Call_ContentLiasettingsSetposdataprovider_589769;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the POS data provider for the specified country.
  ## 
  let valid = call_589784.validator(path, query, header, formData, body)
  let scheme = call_589784.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589784.url(scheme.get, call_589784.host, call_589784.base,
                         call_589784.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589784, url, valid)

proc call*(call_589785: Call_ContentLiasettingsSetposdataprovider_589769;
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
  var path_589786 = newJObject()
  var query_589787 = newJObject()
  add(query_589787, "fields", newJString(fields))
  add(query_589787, "country", newJString(country))
  add(query_589787, "quotaUser", newJString(quotaUser))
  add(query_589787, "alt", newJString(alt))
  add(query_589787, "oauth_token", newJString(oauthToken))
  add(path_589786, "accountId", newJString(accountId))
  add(query_589787, "userIp", newJString(userIp))
  add(query_589787, "posExternalAccountId", newJString(posExternalAccountId))
  add(query_589787, "key", newJString(key))
  add(query_589787, "posDataProviderId", newJString(posDataProviderId))
  add(path_589786, "merchantId", newJString(merchantId))
  add(query_589787, "prettyPrint", newJBool(prettyPrint))
  result = call_589785.call(path_589786, query_589787, nil, nil, nil)

var contentLiasettingsSetposdataprovider* = Call_ContentLiasettingsSetposdataprovider_589769(
    name: "contentLiasettingsSetposdataprovider", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/setposdataprovider",
    validator: validate_ContentLiasettingsSetposdataprovider_589770,
    base: "/content/v2", url: url_ContentLiasettingsSetposdataprovider_589771,
    schemes: {Scheme.Https})
type
  Call_ContentOrderinvoicesCreatechargeinvoice_589788 = ref object of OpenApiRestCall_588450
proc url_ContentOrderinvoicesCreatechargeinvoice_589790(protocol: Scheme;
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

proc validate_ContentOrderinvoicesCreatechargeinvoice_589789(path: JsonNode;
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
  var valid_589791 = path.getOrDefault("orderId")
  valid_589791 = validateParameter(valid_589791, JString, required = true,
                                 default = nil)
  if valid_589791 != nil:
    section.add "orderId", valid_589791
  var valid_589792 = path.getOrDefault("merchantId")
  valid_589792 = validateParameter(valid_589792, JString, required = true,
                                 default = nil)
  if valid_589792 != nil:
    section.add "merchantId", valid_589792
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589793 = query.getOrDefault("fields")
  valid_589793 = validateParameter(valid_589793, JString, required = false,
                                 default = nil)
  if valid_589793 != nil:
    section.add "fields", valid_589793
  var valid_589794 = query.getOrDefault("quotaUser")
  valid_589794 = validateParameter(valid_589794, JString, required = false,
                                 default = nil)
  if valid_589794 != nil:
    section.add "quotaUser", valid_589794
  var valid_589795 = query.getOrDefault("alt")
  valid_589795 = validateParameter(valid_589795, JString, required = false,
                                 default = newJString("json"))
  if valid_589795 != nil:
    section.add "alt", valid_589795
  var valid_589796 = query.getOrDefault("oauth_token")
  valid_589796 = validateParameter(valid_589796, JString, required = false,
                                 default = nil)
  if valid_589796 != nil:
    section.add "oauth_token", valid_589796
  var valid_589797 = query.getOrDefault("userIp")
  valid_589797 = validateParameter(valid_589797, JString, required = false,
                                 default = nil)
  if valid_589797 != nil:
    section.add "userIp", valid_589797
  var valid_589798 = query.getOrDefault("key")
  valid_589798 = validateParameter(valid_589798, JString, required = false,
                                 default = nil)
  if valid_589798 != nil:
    section.add "key", valid_589798
  var valid_589799 = query.getOrDefault("prettyPrint")
  valid_589799 = validateParameter(valid_589799, JBool, required = false,
                                 default = newJBool(true))
  if valid_589799 != nil:
    section.add "prettyPrint", valid_589799
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

proc call*(call_589801: Call_ContentOrderinvoicesCreatechargeinvoice_589788;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a charge invoice for a shipment group, and triggers a charge capture for orderinvoice enabled orders.
  ## 
  let valid = call_589801.validator(path, query, header, formData, body)
  let scheme = call_589801.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589801.url(scheme.get, call_589801.host, call_589801.base,
                         call_589801.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589801, url, valid)

proc call*(call_589802: Call_ContentOrderinvoicesCreatechargeinvoice_589788;
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
  var path_589803 = newJObject()
  var query_589804 = newJObject()
  var body_589805 = newJObject()
  add(query_589804, "fields", newJString(fields))
  add(query_589804, "quotaUser", newJString(quotaUser))
  add(query_589804, "alt", newJString(alt))
  add(query_589804, "oauth_token", newJString(oauthToken))
  add(query_589804, "userIp", newJString(userIp))
  add(path_589803, "orderId", newJString(orderId))
  add(query_589804, "key", newJString(key))
  add(path_589803, "merchantId", newJString(merchantId))
  if body != nil:
    body_589805 = body
  add(query_589804, "prettyPrint", newJBool(prettyPrint))
  result = call_589802.call(path_589803, query_589804, nil, nil, body_589805)

var contentOrderinvoicesCreatechargeinvoice* = Call_ContentOrderinvoicesCreatechargeinvoice_589788(
    name: "contentOrderinvoicesCreatechargeinvoice", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderinvoices/{orderId}/createChargeInvoice",
    validator: validate_ContentOrderinvoicesCreatechargeinvoice_589789,
    base: "/content/v2", url: url_ContentOrderinvoicesCreatechargeinvoice_589790,
    schemes: {Scheme.Https})
type
  Call_ContentOrderinvoicesCreaterefundinvoice_589806 = ref object of OpenApiRestCall_588450
proc url_ContentOrderinvoicesCreaterefundinvoice_589808(protocol: Scheme;
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

proc validate_ContentOrderinvoicesCreaterefundinvoice_589807(path: JsonNode;
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
  var valid_589809 = path.getOrDefault("orderId")
  valid_589809 = validateParameter(valid_589809, JString, required = true,
                                 default = nil)
  if valid_589809 != nil:
    section.add "orderId", valid_589809
  var valid_589810 = path.getOrDefault("merchantId")
  valid_589810 = validateParameter(valid_589810, JString, required = true,
                                 default = nil)
  if valid_589810 != nil:
    section.add "merchantId", valid_589810
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589811 = query.getOrDefault("fields")
  valid_589811 = validateParameter(valid_589811, JString, required = false,
                                 default = nil)
  if valid_589811 != nil:
    section.add "fields", valid_589811
  var valid_589812 = query.getOrDefault("quotaUser")
  valid_589812 = validateParameter(valid_589812, JString, required = false,
                                 default = nil)
  if valid_589812 != nil:
    section.add "quotaUser", valid_589812
  var valid_589813 = query.getOrDefault("alt")
  valid_589813 = validateParameter(valid_589813, JString, required = false,
                                 default = newJString("json"))
  if valid_589813 != nil:
    section.add "alt", valid_589813
  var valid_589814 = query.getOrDefault("oauth_token")
  valid_589814 = validateParameter(valid_589814, JString, required = false,
                                 default = nil)
  if valid_589814 != nil:
    section.add "oauth_token", valid_589814
  var valid_589815 = query.getOrDefault("userIp")
  valid_589815 = validateParameter(valid_589815, JString, required = false,
                                 default = nil)
  if valid_589815 != nil:
    section.add "userIp", valid_589815
  var valid_589816 = query.getOrDefault("key")
  valid_589816 = validateParameter(valid_589816, JString, required = false,
                                 default = nil)
  if valid_589816 != nil:
    section.add "key", valid_589816
  var valid_589817 = query.getOrDefault("prettyPrint")
  valid_589817 = validateParameter(valid_589817, JBool, required = false,
                                 default = newJBool(true))
  if valid_589817 != nil:
    section.add "prettyPrint", valid_589817
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

proc call*(call_589819: Call_ContentOrderinvoicesCreaterefundinvoice_589806;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a refund invoice for one or more shipment groups, and triggers a refund for orderinvoice enabled orders. This can only be used for line items that have previously been charged using createChargeInvoice. All amounts (except for the summary) are incremental with respect to the previous invoice.
  ## 
  let valid = call_589819.validator(path, query, header, formData, body)
  let scheme = call_589819.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589819.url(scheme.get, call_589819.host, call_589819.base,
                         call_589819.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589819, url, valid)

proc call*(call_589820: Call_ContentOrderinvoicesCreaterefundinvoice_589806;
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
  var path_589821 = newJObject()
  var query_589822 = newJObject()
  var body_589823 = newJObject()
  add(query_589822, "fields", newJString(fields))
  add(query_589822, "quotaUser", newJString(quotaUser))
  add(query_589822, "alt", newJString(alt))
  add(query_589822, "oauth_token", newJString(oauthToken))
  add(query_589822, "userIp", newJString(userIp))
  add(path_589821, "orderId", newJString(orderId))
  add(query_589822, "key", newJString(key))
  add(path_589821, "merchantId", newJString(merchantId))
  if body != nil:
    body_589823 = body
  add(query_589822, "prettyPrint", newJBool(prettyPrint))
  result = call_589820.call(path_589821, query_589822, nil, nil, body_589823)

var contentOrderinvoicesCreaterefundinvoice* = Call_ContentOrderinvoicesCreaterefundinvoice_589806(
    name: "contentOrderinvoicesCreaterefundinvoice", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderinvoices/{orderId}/createRefundInvoice",
    validator: validate_ContentOrderinvoicesCreaterefundinvoice_589807,
    base: "/content/v2", url: url_ContentOrderinvoicesCreaterefundinvoice_589808,
    schemes: {Scheme.Https})
type
  Call_ContentOrderpaymentsNotifyauthapproved_589824 = ref object of OpenApiRestCall_588450
proc url_ContentOrderpaymentsNotifyauthapproved_589826(protocol: Scheme;
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

proc validate_ContentOrderpaymentsNotifyauthapproved_589825(path: JsonNode;
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
  var valid_589827 = path.getOrDefault("orderId")
  valid_589827 = validateParameter(valid_589827, JString, required = true,
                                 default = nil)
  if valid_589827 != nil:
    section.add "orderId", valid_589827
  var valid_589828 = path.getOrDefault("merchantId")
  valid_589828 = validateParameter(valid_589828, JString, required = true,
                                 default = nil)
  if valid_589828 != nil:
    section.add "merchantId", valid_589828
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589829 = query.getOrDefault("fields")
  valid_589829 = validateParameter(valid_589829, JString, required = false,
                                 default = nil)
  if valid_589829 != nil:
    section.add "fields", valid_589829
  var valid_589830 = query.getOrDefault("quotaUser")
  valid_589830 = validateParameter(valid_589830, JString, required = false,
                                 default = nil)
  if valid_589830 != nil:
    section.add "quotaUser", valid_589830
  var valid_589831 = query.getOrDefault("alt")
  valid_589831 = validateParameter(valid_589831, JString, required = false,
                                 default = newJString("json"))
  if valid_589831 != nil:
    section.add "alt", valid_589831
  var valid_589832 = query.getOrDefault("oauth_token")
  valid_589832 = validateParameter(valid_589832, JString, required = false,
                                 default = nil)
  if valid_589832 != nil:
    section.add "oauth_token", valid_589832
  var valid_589833 = query.getOrDefault("userIp")
  valid_589833 = validateParameter(valid_589833, JString, required = false,
                                 default = nil)
  if valid_589833 != nil:
    section.add "userIp", valid_589833
  var valid_589834 = query.getOrDefault("key")
  valid_589834 = validateParameter(valid_589834, JString, required = false,
                                 default = nil)
  if valid_589834 != nil:
    section.add "key", valid_589834
  var valid_589835 = query.getOrDefault("prettyPrint")
  valid_589835 = validateParameter(valid_589835, JBool, required = false,
                                 default = newJBool(true))
  if valid_589835 != nil:
    section.add "prettyPrint", valid_589835
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

proc call*(call_589837: Call_ContentOrderpaymentsNotifyauthapproved_589824;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Notify about successfully authorizing user's payment method for a given amount.
  ## 
  let valid = call_589837.validator(path, query, header, formData, body)
  let scheme = call_589837.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589837.url(scheme.get, call_589837.host, call_589837.base,
                         call_589837.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589837, url, valid)

proc call*(call_589838: Call_ContentOrderpaymentsNotifyauthapproved_589824;
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
  var path_589839 = newJObject()
  var query_589840 = newJObject()
  var body_589841 = newJObject()
  add(query_589840, "fields", newJString(fields))
  add(query_589840, "quotaUser", newJString(quotaUser))
  add(query_589840, "alt", newJString(alt))
  add(query_589840, "oauth_token", newJString(oauthToken))
  add(query_589840, "userIp", newJString(userIp))
  add(path_589839, "orderId", newJString(orderId))
  add(query_589840, "key", newJString(key))
  add(path_589839, "merchantId", newJString(merchantId))
  if body != nil:
    body_589841 = body
  add(query_589840, "prettyPrint", newJBool(prettyPrint))
  result = call_589838.call(path_589839, query_589840, nil, nil, body_589841)

var contentOrderpaymentsNotifyauthapproved* = Call_ContentOrderpaymentsNotifyauthapproved_589824(
    name: "contentOrderpaymentsNotifyauthapproved", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderpayments/{orderId}/notifyAuthApproved",
    validator: validate_ContentOrderpaymentsNotifyauthapproved_589825,
    base: "/content/v2", url: url_ContentOrderpaymentsNotifyauthapproved_589826,
    schemes: {Scheme.Https})
type
  Call_ContentOrderpaymentsNotifyauthdeclined_589842 = ref object of OpenApiRestCall_588450
proc url_ContentOrderpaymentsNotifyauthdeclined_589844(protocol: Scheme;
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

proc validate_ContentOrderpaymentsNotifyauthdeclined_589843(path: JsonNode;
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
  var valid_589845 = path.getOrDefault("orderId")
  valid_589845 = validateParameter(valid_589845, JString, required = true,
                                 default = nil)
  if valid_589845 != nil:
    section.add "orderId", valid_589845
  var valid_589846 = path.getOrDefault("merchantId")
  valid_589846 = validateParameter(valid_589846, JString, required = true,
                                 default = nil)
  if valid_589846 != nil:
    section.add "merchantId", valid_589846
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589847 = query.getOrDefault("fields")
  valid_589847 = validateParameter(valid_589847, JString, required = false,
                                 default = nil)
  if valid_589847 != nil:
    section.add "fields", valid_589847
  var valid_589848 = query.getOrDefault("quotaUser")
  valid_589848 = validateParameter(valid_589848, JString, required = false,
                                 default = nil)
  if valid_589848 != nil:
    section.add "quotaUser", valid_589848
  var valid_589849 = query.getOrDefault("alt")
  valid_589849 = validateParameter(valid_589849, JString, required = false,
                                 default = newJString("json"))
  if valid_589849 != nil:
    section.add "alt", valid_589849
  var valid_589850 = query.getOrDefault("oauth_token")
  valid_589850 = validateParameter(valid_589850, JString, required = false,
                                 default = nil)
  if valid_589850 != nil:
    section.add "oauth_token", valid_589850
  var valid_589851 = query.getOrDefault("userIp")
  valid_589851 = validateParameter(valid_589851, JString, required = false,
                                 default = nil)
  if valid_589851 != nil:
    section.add "userIp", valid_589851
  var valid_589852 = query.getOrDefault("key")
  valid_589852 = validateParameter(valid_589852, JString, required = false,
                                 default = nil)
  if valid_589852 != nil:
    section.add "key", valid_589852
  var valid_589853 = query.getOrDefault("prettyPrint")
  valid_589853 = validateParameter(valid_589853, JBool, required = false,
                                 default = newJBool(true))
  if valid_589853 != nil:
    section.add "prettyPrint", valid_589853
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

proc call*(call_589855: Call_ContentOrderpaymentsNotifyauthdeclined_589842;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Notify about failure to authorize user's payment method.
  ## 
  let valid = call_589855.validator(path, query, header, formData, body)
  let scheme = call_589855.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589855.url(scheme.get, call_589855.host, call_589855.base,
                         call_589855.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589855, url, valid)

proc call*(call_589856: Call_ContentOrderpaymentsNotifyauthdeclined_589842;
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
  var path_589857 = newJObject()
  var query_589858 = newJObject()
  var body_589859 = newJObject()
  add(query_589858, "fields", newJString(fields))
  add(query_589858, "quotaUser", newJString(quotaUser))
  add(query_589858, "alt", newJString(alt))
  add(query_589858, "oauth_token", newJString(oauthToken))
  add(query_589858, "userIp", newJString(userIp))
  add(path_589857, "orderId", newJString(orderId))
  add(query_589858, "key", newJString(key))
  add(path_589857, "merchantId", newJString(merchantId))
  if body != nil:
    body_589859 = body
  add(query_589858, "prettyPrint", newJBool(prettyPrint))
  result = call_589856.call(path_589857, query_589858, nil, nil, body_589859)

var contentOrderpaymentsNotifyauthdeclined* = Call_ContentOrderpaymentsNotifyauthdeclined_589842(
    name: "contentOrderpaymentsNotifyauthdeclined", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderpayments/{orderId}/notifyAuthDeclined",
    validator: validate_ContentOrderpaymentsNotifyauthdeclined_589843,
    base: "/content/v2", url: url_ContentOrderpaymentsNotifyauthdeclined_589844,
    schemes: {Scheme.Https})
type
  Call_ContentOrderpaymentsNotifycharge_589860 = ref object of OpenApiRestCall_588450
proc url_ContentOrderpaymentsNotifycharge_589862(protocol: Scheme; host: string;
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

proc validate_ContentOrderpaymentsNotifycharge_589861(path: JsonNode;
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
  var valid_589863 = path.getOrDefault("orderId")
  valid_589863 = validateParameter(valid_589863, JString, required = true,
                                 default = nil)
  if valid_589863 != nil:
    section.add "orderId", valid_589863
  var valid_589864 = path.getOrDefault("merchantId")
  valid_589864 = validateParameter(valid_589864, JString, required = true,
                                 default = nil)
  if valid_589864 != nil:
    section.add "merchantId", valid_589864
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589865 = query.getOrDefault("fields")
  valid_589865 = validateParameter(valid_589865, JString, required = false,
                                 default = nil)
  if valid_589865 != nil:
    section.add "fields", valid_589865
  var valid_589866 = query.getOrDefault("quotaUser")
  valid_589866 = validateParameter(valid_589866, JString, required = false,
                                 default = nil)
  if valid_589866 != nil:
    section.add "quotaUser", valid_589866
  var valid_589867 = query.getOrDefault("alt")
  valid_589867 = validateParameter(valid_589867, JString, required = false,
                                 default = newJString("json"))
  if valid_589867 != nil:
    section.add "alt", valid_589867
  var valid_589868 = query.getOrDefault("oauth_token")
  valid_589868 = validateParameter(valid_589868, JString, required = false,
                                 default = nil)
  if valid_589868 != nil:
    section.add "oauth_token", valid_589868
  var valid_589869 = query.getOrDefault("userIp")
  valid_589869 = validateParameter(valid_589869, JString, required = false,
                                 default = nil)
  if valid_589869 != nil:
    section.add "userIp", valid_589869
  var valid_589870 = query.getOrDefault("key")
  valid_589870 = validateParameter(valid_589870, JString, required = false,
                                 default = nil)
  if valid_589870 != nil:
    section.add "key", valid_589870
  var valid_589871 = query.getOrDefault("prettyPrint")
  valid_589871 = validateParameter(valid_589871, JBool, required = false,
                                 default = newJBool(true))
  if valid_589871 != nil:
    section.add "prettyPrint", valid_589871
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

proc call*(call_589873: Call_ContentOrderpaymentsNotifycharge_589860;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Notify about charge on user's selected payments method.
  ## 
  let valid = call_589873.validator(path, query, header, formData, body)
  let scheme = call_589873.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589873.url(scheme.get, call_589873.host, call_589873.base,
                         call_589873.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589873, url, valid)

proc call*(call_589874: Call_ContentOrderpaymentsNotifycharge_589860;
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
  var path_589875 = newJObject()
  var query_589876 = newJObject()
  var body_589877 = newJObject()
  add(query_589876, "fields", newJString(fields))
  add(query_589876, "quotaUser", newJString(quotaUser))
  add(query_589876, "alt", newJString(alt))
  add(query_589876, "oauth_token", newJString(oauthToken))
  add(query_589876, "userIp", newJString(userIp))
  add(path_589875, "orderId", newJString(orderId))
  add(query_589876, "key", newJString(key))
  add(path_589875, "merchantId", newJString(merchantId))
  if body != nil:
    body_589877 = body
  add(query_589876, "prettyPrint", newJBool(prettyPrint))
  result = call_589874.call(path_589875, query_589876, nil, nil, body_589877)

var contentOrderpaymentsNotifycharge* = Call_ContentOrderpaymentsNotifycharge_589860(
    name: "contentOrderpaymentsNotifycharge", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderpayments/{orderId}/notifyCharge",
    validator: validate_ContentOrderpaymentsNotifycharge_589861,
    base: "/content/v2", url: url_ContentOrderpaymentsNotifycharge_589862,
    schemes: {Scheme.Https})
type
  Call_ContentOrderpaymentsNotifyrefund_589878 = ref object of OpenApiRestCall_588450
proc url_ContentOrderpaymentsNotifyrefund_589880(protocol: Scheme; host: string;
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

proc validate_ContentOrderpaymentsNotifyrefund_589879(path: JsonNode;
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
  var valid_589881 = path.getOrDefault("orderId")
  valid_589881 = validateParameter(valid_589881, JString, required = true,
                                 default = nil)
  if valid_589881 != nil:
    section.add "orderId", valid_589881
  var valid_589882 = path.getOrDefault("merchantId")
  valid_589882 = validateParameter(valid_589882, JString, required = true,
                                 default = nil)
  if valid_589882 != nil:
    section.add "merchantId", valid_589882
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589883 = query.getOrDefault("fields")
  valid_589883 = validateParameter(valid_589883, JString, required = false,
                                 default = nil)
  if valid_589883 != nil:
    section.add "fields", valid_589883
  var valid_589884 = query.getOrDefault("quotaUser")
  valid_589884 = validateParameter(valid_589884, JString, required = false,
                                 default = nil)
  if valid_589884 != nil:
    section.add "quotaUser", valid_589884
  var valid_589885 = query.getOrDefault("alt")
  valid_589885 = validateParameter(valid_589885, JString, required = false,
                                 default = newJString("json"))
  if valid_589885 != nil:
    section.add "alt", valid_589885
  var valid_589886 = query.getOrDefault("oauth_token")
  valid_589886 = validateParameter(valid_589886, JString, required = false,
                                 default = nil)
  if valid_589886 != nil:
    section.add "oauth_token", valid_589886
  var valid_589887 = query.getOrDefault("userIp")
  valid_589887 = validateParameter(valid_589887, JString, required = false,
                                 default = nil)
  if valid_589887 != nil:
    section.add "userIp", valid_589887
  var valid_589888 = query.getOrDefault("key")
  valid_589888 = validateParameter(valid_589888, JString, required = false,
                                 default = nil)
  if valid_589888 != nil:
    section.add "key", valid_589888
  var valid_589889 = query.getOrDefault("prettyPrint")
  valid_589889 = validateParameter(valid_589889, JBool, required = false,
                                 default = newJBool(true))
  if valid_589889 != nil:
    section.add "prettyPrint", valid_589889
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

proc call*(call_589891: Call_ContentOrderpaymentsNotifyrefund_589878;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Notify about refund on user's selected payments method.
  ## 
  let valid = call_589891.validator(path, query, header, formData, body)
  let scheme = call_589891.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589891.url(scheme.get, call_589891.host, call_589891.base,
                         call_589891.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589891, url, valid)

proc call*(call_589892: Call_ContentOrderpaymentsNotifyrefund_589878;
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
  var path_589893 = newJObject()
  var query_589894 = newJObject()
  var body_589895 = newJObject()
  add(query_589894, "fields", newJString(fields))
  add(query_589894, "quotaUser", newJString(quotaUser))
  add(query_589894, "alt", newJString(alt))
  add(query_589894, "oauth_token", newJString(oauthToken))
  add(query_589894, "userIp", newJString(userIp))
  add(path_589893, "orderId", newJString(orderId))
  add(query_589894, "key", newJString(key))
  add(path_589893, "merchantId", newJString(merchantId))
  if body != nil:
    body_589895 = body
  add(query_589894, "prettyPrint", newJBool(prettyPrint))
  result = call_589892.call(path_589893, query_589894, nil, nil, body_589895)

var contentOrderpaymentsNotifyrefund* = Call_ContentOrderpaymentsNotifyrefund_589878(
    name: "contentOrderpaymentsNotifyrefund", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderpayments/{orderId}/notifyRefund",
    validator: validate_ContentOrderpaymentsNotifyrefund_589879,
    base: "/content/v2", url: url_ContentOrderpaymentsNotifyrefund_589880,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreportsListdisbursements_589896 = ref object of OpenApiRestCall_588450
proc url_ContentOrderreportsListdisbursements_589898(protocol: Scheme;
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

proc validate_ContentOrderreportsListdisbursements_589897(path: JsonNode;
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
  var valid_589899 = path.getOrDefault("merchantId")
  valid_589899 = validateParameter(valid_589899, JString, required = true,
                                 default = nil)
  if valid_589899 != nil:
    section.add "merchantId", valid_589899
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
  var valid_589900 = query.getOrDefault("fields")
  valid_589900 = validateParameter(valid_589900, JString, required = false,
                                 default = nil)
  if valid_589900 != nil:
    section.add "fields", valid_589900
  var valid_589901 = query.getOrDefault("pageToken")
  valid_589901 = validateParameter(valid_589901, JString, required = false,
                                 default = nil)
  if valid_589901 != nil:
    section.add "pageToken", valid_589901
  var valid_589902 = query.getOrDefault("quotaUser")
  valid_589902 = validateParameter(valid_589902, JString, required = false,
                                 default = nil)
  if valid_589902 != nil:
    section.add "quotaUser", valid_589902
  var valid_589903 = query.getOrDefault("alt")
  valid_589903 = validateParameter(valid_589903, JString, required = false,
                                 default = newJString("json"))
  if valid_589903 != nil:
    section.add "alt", valid_589903
  var valid_589904 = query.getOrDefault("oauth_token")
  valid_589904 = validateParameter(valid_589904, JString, required = false,
                                 default = nil)
  if valid_589904 != nil:
    section.add "oauth_token", valid_589904
  var valid_589905 = query.getOrDefault("userIp")
  valid_589905 = validateParameter(valid_589905, JString, required = false,
                                 default = nil)
  if valid_589905 != nil:
    section.add "userIp", valid_589905
  var valid_589906 = query.getOrDefault("maxResults")
  valid_589906 = validateParameter(valid_589906, JInt, required = false, default = nil)
  if valid_589906 != nil:
    section.add "maxResults", valid_589906
  var valid_589907 = query.getOrDefault("key")
  valid_589907 = validateParameter(valid_589907, JString, required = false,
                                 default = nil)
  if valid_589907 != nil:
    section.add "key", valid_589907
  var valid_589908 = query.getOrDefault("prettyPrint")
  valid_589908 = validateParameter(valid_589908, JBool, required = false,
                                 default = newJBool(true))
  if valid_589908 != nil:
    section.add "prettyPrint", valid_589908
  assert query != nil, "query argument is necessary due to required `disbursementStartDate` field"
  var valid_589909 = query.getOrDefault("disbursementStartDate")
  valid_589909 = validateParameter(valid_589909, JString, required = true,
                                 default = nil)
  if valid_589909 != nil:
    section.add "disbursementStartDate", valid_589909
  var valid_589910 = query.getOrDefault("disbursementEndDate")
  valid_589910 = validateParameter(valid_589910, JString, required = false,
                                 default = nil)
  if valid_589910 != nil:
    section.add "disbursementEndDate", valid_589910
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589911: Call_ContentOrderreportsListdisbursements_589896;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a report for disbursements from your Merchant Center account.
  ## 
  let valid = call_589911.validator(path, query, header, formData, body)
  let scheme = call_589911.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589911.url(scheme.get, call_589911.host, call_589911.base,
                         call_589911.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589911, url, valid)

proc call*(call_589912: Call_ContentOrderreportsListdisbursements_589896;
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
  var path_589913 = newJObject()
  var query_589914 = newJObject()
  add(query_589914, "fields", newJString(fields))
  add(query_589914, "pageToken", newJString(pageToken))
  add(query_589914, "quotaUser", newJString(quotaUser))
  add(query_589914, "alt", newJString(alt))
  add(query_589914, "oauth_token", newJString(oauthToken))
  add(query_589914, "userIp", newJString(userIp))
  add(query_589914, "maxResults", newJInt(maxResults))
  add(query_589914, "key", newJString(key))
  add(path_589913, "merchantId", newJString(merchantId))
  add(query_589914, "prettyPrint", newJBool(prettyPrint))
  add(query_589914, "disbursementStartDate", newJString(disbursementStartDate))
  add(query_589914, "disbursementEndDate", newJString(disbursementEndDate))
  result = call_589912.call(path_589913, query_589914, nil, nil, nil)

var contentOrderreportsListdisbursements* = Call_ContentOrderreportsListdisbursements_589896(
    name: "contentOrderreportsListdisbursements", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreports/disbursements",
    validator: validate_ContentOrderreportsListdisbursements_589897,
    base: "/content/v2", url: url_ContentOrderreportsListdisbursements_589898,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreportsListtransactions_589915 = ref object of OpenApiRestCall_588450
proc url_ContentOrderreportsListtransactions_589917(protocol: Scheme; host: string;
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

proc validate_ContentOrderreportsListtransactions_589916(path: JsonNode;
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
  var valid_589918 = path.getOrDefault("merchantId")
  valid_589918 = validateParameter(valid_589918, JString, required = true,
                                 default = nil)
  if valid_589918 != nil:
    section.add "merchantId", valid_589918
  var valid_589919 = path.getOrDefault("disbursementId")
  valid_589919 = validateParameter(valid_589919, JString, required = true,
                                 default = nil)
  if valid_589919 != nil:
    section.add "disbursementId", valid_589919
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
  var valid_589920 = query.getOrDefault("fields")
  valid_589920 = validateParameter(valid_589920, JString, required = false,
                                 default = nil)
  if valid_589920 != nil:
    section.add "fields", valid_589920
  var valid_589921 = query.getOrDefault("pageToken")
  valid_589921 = validateParameter(valid_589921, JString, required = false,
                                 default = nil)
  if valid_589921 != nil:
    section.add "pageToken", valid_589921
  var valid_589922 = query.getOrDefault("quotaUser")
  valid_589922 = validateParameter(valid_589922, JString, required = false,
                                 default = nil)
  if valid_589922 != nil:
    section.add "quotaUser", valid_589922
  var valid_589923 = query.getOrDefault("alt")
  valid_589923 = validateParameter(valid_589923, JString, required = false,
                                 default = newJString("json"))
  if valid_589923 != nil:
    section.add "alt", valid_589923
  var valid_589924 = query.getOrDefault("transactionEndDate")
  valid_589924 = validateParameter(valid_589924, JString, required = false,
                                 default = nil)
  if valid_589924 != nil:
    section.add "transactionEndDate", valid_589924
  var valid_589925 = query.getOrDefault("oauth_token")
  valid_589925 = validateParameter(valid_589925, JString, required = false,
                                 default = nil)
  if valid_589925 != nil:
    section.add "oauth_token", valid_589925
  var valid_589926 = query.getOrDefault("userIp")
  valid_589926 = validateParameter(valid_589926, JString, required = false,
                                 default = nil)
  if valid_589926 != nil:
    section.add "userIp", valid_589926
  var valid_589927 = query.getOrDefault("maxResults")
  valid_589927 = validateParameter(valid_589927, JInt, required = false, default = nil)
  if valid_589927 != nil:
    section.add "maxResults", valid_589927
  assert query != nil, "query argument is necessary due to required `transactionStartDate` field"
  var valid_589928 = query.getOrDefault("transactionStartDate")
  valid_589928 = validateParameter(valid_589928, JString, required = true,
                                 default = nil)
  if valid_589928 != nil:
    section.add "transactionStartDate", valid_589928
  var valid_589929 = query.getOrDefault("key")
  valid_589929 = validateParameter(valid_589929, JString, required = false,
                                 default = nil)
  if valid_589929 != nil:
    section.add "key", valid_589929
  var valid_589930 = query.getOrDefault("prettyPrint")
  valid_589930 = validateParameter(valid_589930, JBool, required = false,
                                 default = newJBool(true))
  if valid_589930 != nil:
    section.add "prettyPrint", valid_589930
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589931: Call_ContentOrderreportsListtransactions_589915;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of transactions for a disbursement from your Merchant Center account.
  ## 
  let valid = call_589931.validator(path, query, header, formData, body)
  let scheme = call_589931.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589931.url(scheme.get, call_589931.host, call_589931.base,
                         call_589931.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589931, url, valid)

proc call*(call_589932: Call_ContentOrderreportsListtransactions_589915;
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
  var path_589933 = newJObject()
  var query_589934 = newJObject()
  add(query_589934, "fields", newJString(fields))
  add(query_589934, "pageToken", newJString(pageToken))
  add(query_589934, "quotaUser", newJString(quotaUser))
  add(query_589934, "alt", newJString(alt))
  add(query_589934, "transactionEndDate", newJString(transactionEndDate))
  add(query_589934, "oauth_token", newJString(oauthToken))
  add(query_589934, "userIp", newJString(userIp))
  add(query_589934, "maxResults", newJInt(maxResults))
  add(query_589934, "transactionStartDate", newJString(transactionStartDate))
  add(query_589934, "key", newJString(key))
  add(path_589933, "merchantId", newJString(merchantId))
  add(path_589933, "disbursementId", newJString(disbursementId))
  add(query_589934, "prettyPrint", newJBool(prettyPrint))
  result = call_589932.call(path_589933, query_589934, nil, nil, nil)

var contentOrderreportsListtransactions* = Call_ContentOrderreportsListtransactions_589915(
    name: "contentOrderreportsListtransactions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreports/disbursements/{disbursementId}/transactions",
    validator: validate_ContentOrderreportsListtransactions_589916,
    base: "/content/v2", url: url_ContentOrderreportsListtransactions_589917,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreturnsList_589935 = ref object of OpenApiRestCall_588450
proc url_ContentOrderreturnsList_589937(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrderreturnsList_589936(path: JsonNode; query: JsonNode;
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
  var valid_589938 = path.getOrDefault("merchantId")
  valid_589938 = validateParameter(valid_589938, JString, required = true,
                                 default = nil)
  if valid_589938 != nil:
    section.add "merchantId", valid_589938
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
  var valid_589939 = query.getOrDefault("fields")
  valid_589939 = validateParameter(valid_589939, JString, required = false,
                                 default = nil)
  if valid_589939 != nil:
    section.add "fields", valid_589939
  var valid_589940 = query.getOrDefault("pageToken")
  valid_589940 = validateParameter(valid_589940, JString, required = false,
                                 default = nil)
  if valid_589940 != nil:
    section.add "pageToken", valid_589940
  var valid_589941 = query.getOrDefault("quotaUser")
  valid_589941 = validateParameter(valid_589941, JString, required = false,
                                 default = nil)
  if valid_589941 != nil:
    section.add "quotaUser", valid_589941
  var valid_589942 = query.getOrDefault("alt")
  valid_589942 = validateParameter(valid_589942, JString, required = false,
                                 default = newJString("json"))
  if valid_589942 != nil:
    section.add "alt", valid_589942
  var valid_589943 = query.getOrDefault("oauth_token")
  valid_589943 = validateParameter(valid_589943, JString, required = false,
                                 default = nil)
  if valid_589943 != nil:
    section.add "oauth_token", valid_589943
  var valid_589944 = query.getOrDefault("userIp")
  valid_589944 = validateParameter(valid_589944, JString, required = false,
                                 default = nil)
  if valid_589944 != nil:
    section.add "userIp", valid_589944
  var valid_589945 = query.getOrDefault("maxResults")
  valid_589945 = validateParameter(valid_589945, JInt, required = false, default = nil)
  if valid_589945 != nil:
    section.add "maxResults", valid_589945
  var valid_589946 = query.getOrDefault("orderBy")
  valid_589946 = validateParameter(valid_589946, JString, required = false,
                                 default = newJString("returnCreationTimeAsc"))
  if valid_589946 != nil:
    section.add "orderBy", valid_589946
  var valid_589947 = query.getOrDefault("key")
  valid_589947 = validateParameter(valid_589947, JString, required = false,
                                 default = nil)
  if valid_589947 != nil:
    section.add "key", valid_589947
  var valid_589948 = query.getOrDefault("createdEndDate")
  valid_589948 = validateParameter(valid_589948, JString, required = false,
                                 default = nil)
  if valid_589948 != nil:
    section.add "createdEndDate", valid_589948
  var valid_589949 = query.getOrDefault("prettyPrint")
  valid_589949 = validateParameter(valid_589949, JBool, required = false,
                                 default = newJBool(true))
  if valid_589949 != nil:
    section.add "prettyPrint", valid_589949
  var valid_589950 = query.getOrDefault("createdStartDate")
  valid_589950 = validateParameter(valid_589950, JString, required = false,
                                 default = nil)
  if valid_589950 != nil:
    section.add "createdStartDate", valid_589950
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589951: Call_ContentOrderreturnsList_589935; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists order returns in your Merchant Center account.
  ## 
  let valid = call_589951.validator(path, query, header, formData, body)
  let scheme = call_589951.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589951.url(scheme.get, call_589951.host, call_589951.base,
                         call_589951.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589951, url, valid)

proc call*(call_589952: Call_ContentOrderreturnsList_589935; merchantId: string;
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
  var path_589953 = newJObject()
  var query_589954 = newJObject()
  add(query_589954, "fields", newJString(fields))
  add(query_589954, "pageToken", newJString(pageToken))
  add(query_589954, "quotaUser", newJString(quotaUser))
  add(query_589954, "alt", newJString(alt))
  add(query_589954, "oauth_token", newJString(oauthToken))
  add(query_589954, "userIp", newJString(userIp))
  add(query_589954, "maxResults", newJInt(maxResults))
  add(query_589954, "orderBy", newJString(orderBy))
  add(query_589954, "key", newJString(key))
  add(query_589954, "createdEndDate", newJString(createdEndDate))
  add(path_589953, "merchantId", newJString(merchantId))
  add(query_589954, "prettyPrint", newJBool(prettyPrint))
  add(query_589954, "createdStartDate", newJString(createdStartDate))
  result = call_589952.call(path_589953, query_589954, nil, nil, nil)

var contentOrderreturnsList* = Call_ContentOrderreturnsList_589935(
    name: "contentOrderreturnsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreturns",
    validator: validate_ContentOrderreturnsList_589936, base: "/content/v2",
    url: url_ContentOrderreturnsList_589937, schemes: {Scheme.Https})
type
  Call_ContentOrderreturnsGet_589955 = ref object of OpenApiRestCall_588450
proc url_ContentOrderreturnsGet_589957(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrderreturnsGet_589956(path: JsonNode; query: JsonNode;
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
  var valid_589958 = path.getOrDefault("returnId")
  valid_589958 = validateParameter(valid_589958, JString, required = true,
                                 default = nil)
  if valid_589958 != nil:
    section.add "returnId", valid_589958
  var valid_589959 = path.getOrDefault("merchantId")
  valid_589959 = validateParameter(valid_589959, JString, required = true,
                                 default = nil)
  if valid_589959 != nil:
    section.add "merchantId", valid_589959
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589960 = query.getOrDefault("fields")
  valid_589960 = validateParameter(valid_589960, JString, required = false,
                                 default = nil)
  if valid_589960 != nil:
    section.add "fields", valid_589960
  var valid_589961 = query.getOrDefault("quotaUser")
  valid_589961 = validateParameter(valid_589961, JString, required = false,
                                 default = nil)
  if valid_589961 != nil:
    section.add "quotaUser", valid_589961
  var valid_589962 = query.getOrDefault("alt")
  valid_589962 = validateParameter(valid_589962, JString, required = false,
                                 default = newJString("json"))
  if valid_589962 != nil:
    section.add "alt", valid_589962
  var valid_589963 = query.getOrDefault("oauth_token")
  valid_589963 = validateParameter(valid_589963, JString, required = false,
                                 default = nil)
  if valid_589963 != nil:
    section.add "oauth_token", valid_589963
  var valid_589964 = query.getOrDefault("userIp")
  valid_589964 = validateParameter(valid_589964, JString, required = false,
                                 default = nil)
  if valid_589964 != nil:
    section.add "userIp", valid_589964
  var valid_589965 = query.getOrDefault("key")
  valid_589965 = validateParameter(valid_589965, JString, required = false,
                                 default = nil)
  if valid_589965 != nil:
    section.add "key", valid_589965
  var valid_589966 = query.getOrDefault("prettyPrint")
  valid_589966 = validateParameter(valid_589966, JBool, required = false,
                                 default = newJBool(true))
  if valid_589966 != nil:
    section.add "prettyPrint", valid_589966
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589967: Call_ContentOrderreturnsGet_589955; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an order return from your Merchant Center account.
  ## 
  let valid = call_589967.validator(path, query, header, formData, body)
  let scheme = call_589967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589967.url(scheme.get, call_589967.host, call_589967.base,
                         call_589967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589967, url, valid)

proc call*(call_589968: Call_ContentOrderreturnsGet_589955; returnId: string;
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
  var path_589969 = newJObject()
  var query_589970 = newJObject()
  add(query_589970, "fields", newJString(fields))
  add(query_589970, "quotaUser", newJString(quotaUser))
  add(path_589969, "returnId", newJString(returnId))
  add(query_589970, "alt", newJString(alt))
  add(query_589970, "oauth_token", newJString(oauthToken))
  add(query_589970, "userIp", newJString(userIp))
  add(query_589970, "key", newJString(key))
  add(path_589969, "merchantId", newJString(merchantId))
  add(query_589970, "prettyPrint", newJBool(prettyPrint))
  result = call_589968.call(path_589969, query_589970, nil, nil, nil)

var contentOrderreturnsGet* = Call_ContentOrderreturnsGet_589955(
    name: "contentOrderreturnsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreturns/{returnId}",
    validator: validate_ContentOrderreturnsGet_589956, base: "/content/v2",
    url: url_ContentOrderreturnsGet_589957, schemes: {Scheme.Https})
type
  Call_ContentOrdersList_589971 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersList_589973(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrdersList_589972(path: JsonNode; query: JsonNode;
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
  var valid_589974 = path.getOrDefault("merchantId")
  valid_589974 = validateParameter(valid_589974, JString, required = true,
                                 default = nil)
  if valid_589974 != nil:
    section.add "merchantId", valid_589974
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
  var valid_589975 = query.getOrDefault("fields")
  valid_589975 = validateParameter(valid_589975, JString, required = false,
                                 default = nil)
  if valid_589975 != nil:
    section.add "fields", valid_589975
  var valid_589976 = query.getOrDefault("pageToken")
  valid_589976 = validateParameter(valid_589976, JString, required = false,
                                 default = nil)
  if valid_589976 != nil:
    section.add "pageToken", valid_589976
  var valid_589977 = query.getOrDefault("quotaUser")
  valid_589977 = validateParameter(valid_589977, JString, required = false,
                                 default = nil)
  if valid_589977 != nil:
    section.add "quotaUser", valid_589977
  var valid_589978 = query.getOrDefault("alt")
  valid_589978 = validateParameter(valid_589978, JString, required = false,
                                 default = newJString("json"))
  if valid_589978 != nil:
    section.add "alt", valid_589978
  var valid_589979 = query.getOrDefault("placedDateStart")
  valid_589979 = validateParameter(valid_589979, JString, required = false,
                                 default = nil)
  if valid_589979 != nil:
    section.add "placedDateStart", valid_589979
  var valid_589980 = query.getOrDefault("oauth_token")
  valid_589980 = validateParameter(valid_589980, JString, required = false,
                                 default = nil)
  if valid_589980 != nil:
    section.add "oauth_token", valid_589980
  var valid_589981 = query.getOrDefault("userIp")
  valid_589981 = validateParameter(valid_589981, JString, required = false,
                                 default = nil)
  if valid_589981 != nil:
    section.add "userIp", valid_589981
  var valid_589982 = query.getOrDefault("maxResults")
  valid_589982 = validateParameter(valid_589982, JInt, required = false, default = nil)
  if valid_589982 != nil:
    section.add "maxResults", valid_589982
  var valid_589983 = query.getOrDefault("orderBy")
  valid_589983 = validateParameter(valid_589983, JString, required = false,
                                 default = nil)
  if valid_589983 != nil:
    section.add "orderBy", valid_589983
  var valid_589984 = query.getOrDefault("placedDateEnd")
  valid_589984 = validateParameter(valid_589984, JString, required = false,
                                 default = nil)
  if valid_589984 != nil:
    section.add "placedDateEnd", valid_589984
  var valid_589985 = query.getOrDefault("key")
  valid_589985 = validateParameter(valid_589985, JString, required = false,
                                 default = nil)
  if valid_589985 != nil:
    section.add "key", valid_589985
  var valid_589986 = query.getOrDefault("acknowledged")
  valid_589986 = validateParameter(valid_589986, JBool, required = false, default = nil)
  if valid_589986 != nil:
    section.add "acknowledged", valid_589986
  var valid_589987 = query.getOrDefault("prettyPrint")
  valid_589987 = validateParameter(valid_589987, JBool, required = false,
                                 default = newJBool(true))
  if valid_589987 != nil:
    section.add "prettyPrint", valid_589987
  var valid_589988 = query.getOrDefault("statuses")
  valid_589988 = validateParameter(valid_589988, JArray, required = false,
                                 default = nil)
  if valid_589988 != nil:
    section.add "statuses", valid_589988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589989: Call_ContentOrdersList_589971; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the orders in your Merchant Center account.
  ## 
  let valid = call_589989.validator(path, query, header, formData, body)
  let scheme = call_589989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589989.url(scheme.get, call_589989.host, call_589989.base,
                         call_589989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589989, url, valid)

proc call*(call_589990: Call_ContentOrdersList_589971; merchantId: string;
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
  var path_589991 = newJObject()
  var query_589992 = newJObject()
  add(query_589992, "fields", newJString(fields))
  add(query_589992, "pageToken", newJString(pageToken))
  add(query_589992, "quotaUser", newJString(quotaUser))
  add(query_589992, "alt", newJString(alt))
  add(query_589992, "placedDateStart", newJString(placedDateStart))
  add(query_589992, "oauth_token", newJString(oauthToken))
  add(query_589992, "userIp", newJString(userIp))
  add(query_589992, "maxResults", newJInt(maxResults))
  add(query_589992, "orderBy", newJString(orderBy))
  add(query_589992, "placedDateEnd", newJString(placedDateEnd))
  add(query_589992, "key", newJString(key))
  add(path_589991, "merchantId", newJString(merchantId))
  add(query_589992, "acknowledged", newJBool(acknowledged))
  add(query_589992, "prettyPrint", newJBool(prettyPrint))
  if statuses != nil:
    query_589992.add "statuses", statuses
  result = call_589990.call(path_589991, query_589992, nil, nil, nil)

var contentOrdersList* = Call_ContentOrdersList_589971(name: "contentOrdersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/orders", validator: validate_ContentOrdersList_589972,
    base: "/content/v2", url: url_ContentOrdersList_589973, schemes: {Scheme.Https})
type
  Call_ContentOrdersGet_589993 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersGet_589995(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrdersGet_589994(path: JsonNode; query: JsonNode;
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
  var valid_589996 = path.getOrDefault("orderId")
  valid_589996 = validateParameter(valid_589996, JString, required = true,
                                 default = nil)
  if valid_589996 != nil:
    section.add "orderId", valid_589996
  var valid_589997 = path.getOrDefault("merchantId")
  valid_589997 = validateParameter(valid_589997, JString, required = true,
                                 default = nil)
  if valid_589997 != nil:
    section.add "merchantId", valid_589997
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589998 = query.getOrDefault("fields")
  valid_589998 = validateParameter(valid_589998, JString, required = false,
                                 default = nil)
  if valid_589998 != nil:
    section.add "fields", valid_589998
  var valid_589999 = query.getOrDefault("quotaUser")
  valid_589999 = validateParameter(valid_589999, JString, required = false,
                                 default = nil)
  if valid_589999 != nil:
    section.add "quotaUser", valid_589999
  var valid_590000 = query.getOrDefault("alt")
  valid_590000 = validateParameter(valid_590000, JString, required = false,
                                 default = newJString("json"))
  if valid_590000 != nil:
    section.add "alt", valid_590000
  var valid_590001 = query.getOrDefault("oauth_token")
  valid_590001 = validateParameter(valid_590001, JString, required = false,
                                 default = nil)
  if valid_590001 != nil:
    section.add "oauth_token", valid_590001
  var valid_590002 = query.getOrDefault("userIp")
  valid_590002 = validateParameter(valid_590002, JString, required = false,
                                 default = nil)
  if valid_590002 != nil:
    section.add "userIp", valid_590002
  var valid_590003 = query.getOrDefault("key")
  valid_590003 = validateParameter(valid_590003, JString, required = false,
                                 default = nil)
  if valid_590003 != nil:
    section.add "key", valid_590003
  var valid_590004 = query.getOrDefault("prettyPrint")
  valid_590004 = validateParameter(valid_590004, JBool, required = false,
                                 default = newJBool(true))
  if valid_590004 != nil:
    section.add "prettyPrint", valid_590004
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590005: Call_ContentOrdersGet_589993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an order from your Merchant Center account.
  ## 
  let valid = call_590005.validator(path, query, header, formData, body)
  let scheme = call_590005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590005.url(scheme.get, call_590005.host, call_590005.base,
                         call_590005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590005, url, valid)

proc call*(call_590006: Call_ContentOrdersGet_589993; orderId: string;
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
  var path_590007 = newJObject()
  var query_590008 = newJObject()
  add(query_590008, "fields", newJString(fields))
  add(query_590008, "quotaUser", newJString(quotaUser))
  add(query_590008, "alt", newJString(alt))
  add(query_590008, "oauth_token", newJString(oauthToken))
  add(query_590008, "userIp", newJString(userIp))
  add(path_590007, "orderId", newJString(orderId))
  add(query_590008, "key", newJString(key))
  add(path_590007, "merchantId", newJString(merchantId))
  add(query_590008, "prettyPrint", newJBool(prettyPrint))
  result = call_590006.call(path_590007, query_590008, nil, nil, nil)

var contentOrdersGet* = Call_ContentOrdersGet_589993(name: "contentOrdersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}", validator: validate_ContentOrdersGet_589994,
    base: "/content/v2", url: url_ContentOrdersGet_589995, schemes: {Scheme.Https})
type
  Call_ContentOrdersAcknowledge_590009 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersAcknowledge_590011(protocol: Scheme; host: string;
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

proc validate_ContentOrdersAcknowledge_590010(path: JsonNode; query: JsonNode;
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
  var valid_590012 = path.getOrDefault("orderId")
  valid_590012 = validateParameter(valid_590012, JString, required = true,
                                 default = nil)
  if valid_590012 != nil:
    section.add "orderId", valid_590012
  var valid_590013 = path.getOrDefault("merchantId")
  valid_590013 = validateParameter(valid_590013, JString, required = true,
                                 default = nil)
  if valid_590013 != nil:
    section.add "merchantId", valid_590013
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590014 = query.getOrDefault("fields")
  valid_590014 = validateParameter(valid_590014, JString, required = false,
                                 default = nil)
  if valid_590014 != nil:
    section.add "fields", valid_590014
  var valid_590015 = query.getOrDefault("quotaUser")
  valid_590015 = validateParameter(valid_590015, JString, required = false,
                                 default = nil)
  if valid_590015 != nil:
    section.add "quotaUser", valid_590015
  var valid_590016 = query.getOrDefault("alt")
  valid_590016 = validateParameter(valid_590016, JString, required = false,
                                 default = newJString("json"))
  if valid_590016 != nil:
    section.add "alt", valid_590016
  var valid_590017 = query.getOrDefault("oauth_token")
  valid_590017 = validateParameter(valid_590017, JString, required = false,
                                 default = nil)
  if valid_590017 != nil:
    section.add "oauth_token", valid_590017
  var valid_590018 = query.getOrDefault("userIp")
  valid_590018 = validateParameter(valid_590018, JString, required = false,
                                 default = nil)
  if valid_590018 != nil:
    section.add "userIp", valid_590018
  var valid_590019 = query.getOrDefault("key")
  valid_590019 = validateParameter(valid_590019, JString, required = false,
                                 default = nil)
  if valid_590019 != nil:
    section.add "key", valid_590019
  var valid_590020 = query.getOrDefault("prettyPrint")
  valid_590020 = validateParameter(valid_590020, JBool, required = false,
                                 default = newJBool(true))
  if valid_590020 != nil:
    section.add "prettyPrint", valid_590020
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

proc call*(call_590022: Call_ContentOrdersAcknowledge_590009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks an order as acknowledged.
  ## 
  let valid = call_590022.validator(path, query, header, formData, body)
  let scheme = call_590022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590022.url(scheme.get, call_590022.host, call_590022.base,
                         call_590022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590022, url, valid)

proc call*(call_590023: Call_ContentOrdersAcknowledge_590009; orderId: string;
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
  var path_590024 = newJObject()
  var query_590025 = newJObject()
  var body_590026 = newJObject()
  add(query_590025, "fields", newJString(fields))
  add(query_590025, "quotaUser", newJString(quotaUser))
  add(query_590025, "alt", newJString(alt))
  add(query_590025, "oauth_token", newJString(oauthToken))
  add(query_590025, "userIp", newJString(userIp))
  add(path_590024, "orderId", newJString(orderId))
  add(query_590025, "key", newJString(key))
  add(path_590024, "merchantId", newJString(merchantId))
  if body != nil:
    body_590026 = body
  add(query_590025, "prettyPrint", newJBool(prettyPrint))
  result = call_590023.call(path_590024, query_590025, nil, nil, body_590026)

var contentOrdersAcknowledge* = Call_ContentOrdersAcknowledge_590009(
    name: "contentOrdersAcknowledge", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/acknowledge",
    validator: validate_ContentOrdersAcknowledge_590010, base: "/content/v2",
    url: url_ContentOrdersAcknowledge_590011, schemes: {Scheme.Https})
type
  Call_ContentOrdersCancel_590027 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersCancel_590029(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrdersCancel_590028(path: JsonNode; query: JsonNode;
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
  var valid_590030 = path.getOrDefault("orderId")
  valid_590030 = validateParameter(valid_590030, JString, required = true,
                                 default = nil)
  if valid_590030 != nil:
    section.add "orderId", valid_590030
  var valid_590031 = path.getOrDefault("merchantId")
  valid_590031 = validateParameter(valid_590031, JString, required = true,
                                 default = nil)
  if valid_590031 != nil:
    section.add "merchantId", valid_590031
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590032 = query.getOrDefault("fields")
  valid_590032 = validateParameter(valid_590032, JString, required = false,
                                 default = nil)
  if valid_590032 != nil:
    section.add "fields", valid_590032
  var valid_590033 = query.getOrDefault("quotaUser")
  valid_590033 = validateParameter(valid_590033, JString, required = false,
                                 default = nil)
  if valid_590033 != nil:
    section.add "quotaUser", valid_590033
  var valid_590034 = query.getOrDefault("alt")
  valid_590034 = validateParameter(valid_590034, JString, required = false,
                                 default = newJString("json"))
  if valid_590034 != nil:
    section.add "alt", valid_590034
  var valid_590035 = query.getOrDefault("oauth_token")
  valid_590035 = validateParameter(valid_590035, JString, required = false,
                                 default = nil)
  if valid_590035 != nil:
    section.add "oauth_token", valid_590035
  var valid_590036 = query.getOrDefault("userIp")
  valid_590036 = validateParameter(valid_590036, JString, required = false,
                                 default = nil)
  if valid_590036 != nil:
    section.add "userIp", valid_590036
  var valid_590037 = query.getOrDefault("key")
  valid_590037 = validateParameter(valid_590037, JString, required = false,
                                 default = nil)
  if valid_590037 != nil:
    section.add "key", valid_590037
  var valid_590038 = query.getOrDefault("prettyPrint")
  valid_590038 = validateParameter(valid_590038, JBool, required = false,
                                 default = newJBool(true))
  if valid_590038 != nil:
    section.add "prettyPrint", valid_590038
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

proc call*(call_590040: Call_ContentOrdersCancel_590027; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels all line items in an order, making a full refund.
  ## 
  let valid = call_590040.validator(path, query, header, formData, body)
  let scheme = call_590040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590040.url(scheme.get, call_590040.host, call_590040.base,
                         call_590040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590040, url, valid)

proc call*(call_590041: Call_ContentOrdersCancel_590027; orderId: string;
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
  var path_590042 = newJObject()
  var query_590043 = newJObject()
  var body_590044 = newJObject()
  add(query_590043, "fields", newJString(fields))
  add(query_590043, "quotaUser", newJString(quotaUser))
  add(query_590043, "alt", newJString(alt))
  add(query_590043, "oauth_token", newJString(oauthToken))
  add(query_590043, "userIp", newJString(userIp))
  add(path_590042, "orderId", newJString(orderId))
  add(query_590043, "key", newJString(key))
  add(path_590042, "merchantId", newJString(merchantId))
  if body != nil:
    body_590044 = body
  add(query_590043, "prettyPrint", newJBool(prettyPrint))
  result = call_590041.call(path_590042, query_590043, nil, nil, body_590044)

var contentOrdersCancel* = Call_ContentOrdersCancel_590027(
    name: "contentOrdersCancel", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/orders/{orderId}/cancel",
    validator: validate_ContentOrdersCancel_590028, base: "/content/v2",
    url: url_ContentOrdersCancel_590029, schemes: {Scheme.Https})
type
  Call_ContentOrdersCancellineitem_590045 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersCancellineitem_590047(protocol: Scheme; host: string;
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

proc validate_ContentOrdersCancellineitem_590046(path: JsonNode; query: JsonNode;
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
  var valid_590048 = path.getOrDefault("orderId")
  valid_590048 = validateParameter(valid_590048, JString, required = true,
                                 default = nil)
  if valid_590048 != nil:
    section.add "orderId", valid_590048
  var valid_590049 = path.getOrDefault("merchantId")
  valid_590049 = validateParameter(valid_590049, JString, required = true,
                                 default = nil)
  if valid_590049 != nil:
    section.add "merchantId", valid_590049
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590050 = query.getOrDefault("fields")
  valid_590050 = validateParameter(valid_590050, JString, required = false,
                                 default = nil)
  if valid_590050 != nil:
    section.add "fields", valid_590050
  var valid_590051 = query.getOrDefault("quotaUser")
  valid_590051 = validateParameter(valid_590051, JString, required = false,
                                 default = nil)
  if valid_590051 != nil:
    section.add "quotaUser", valid_590051
  var valid_590052 = query.getOrDefault("alt")
  valid_590052 = validateParameter(valid_590052, JString, required = false,
                                 default = newJString("json"))
  if valid_590052 != nil:
    section.add "alt", valid_590052
  var valid_590053 = query.getOrDefault("oauth_token")
  valid_590053 = validateParameter(valid_590053, JString, required = false,
                                 default = nil)
  if valid_590053 != nil:
    section.add "oauth_token", valid_590053
  var valid_590054 = query.getOrDefault("userIp")
  valid_590054 = validateParameter(valid_590054, JString, required = false,
                                 default = nil)
  if valid_590054 != nil:
    section.add "userIp", valid_590054
  var valid_590055 = query.getOrDefault("key")
  valid_590055 = validateParameter(valid_590055, JString, required = false,
                                 default = nil)
  if valid_590055 != nil:
    section.add "key", valid_590055
  var valid_590056 = query.getOrDefault("prettyPrint")
  valid_590056 = validateParameter(valid_590056, JBool, required = false,
                                 default = newJBool(true))
  if valid_590056 != nil:
    section.add "prettyPrint", valid_590056
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

proc call*(call_590058: Call_ContentOrdersCancellineitem_590045; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a line item, making a full refund.
  ## 
  let valid = call_590058.validator(path, query, header, formData, body)
  let scheme = call_590058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590058.url(scheme.get, call_590058.host, call_590058.base,
                         call_590058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590058, url, valid)

proc call*(call_590059: Call_ContentOrdersCancellineitem_590045; orderId: string;
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
  var path_590060 = newJObject()
  var query_590061 = newJObject()
  var body_590062 = newJObject()
  add(query_590061, "fields", newJString(fields))
  add(query_590061, "quotaUser", newJString(quotaUser))
  add(query_590061, "alt", newJString(alt))
  add(query_590061, "oauth_token", newJString(oauthToken))
  add(query_590061, "userIp", newJString(userIp))
  add(path_590060, "orderId", newJString(orderId))
  add(query_590061, "key", newJString(key))
  add(path_590060, "merchantId", newJString(merchantId))
  if body != nil:
    body_590062 = body
  add(query_590061, "prettyPrint", newJBool(prettyPrint))
  result = call_590059.call(path_590060, query_590061, nil, nil, body_590062)

var contentOrdersCancellineitem* = Call_ContentOrdersCancellineitem_590045(
    name: "contentOrdersCancellineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/cancelLineItem",
    validator: validate_ContentOrdersCancellineitem_590046, base: "/content/v2",
    url: url_ContentOrdersCancellineitem_590047, schemes: {Scheme.Https})
type
  Call_ContentOrdersInstorerefundlineitem_590063 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersInstorerefundlineitem_590065(protocol: Scheme; host: string;
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

proc validate_ContentOrdersInstorerefundlineitem_590064(path: JsonNode;
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
  var valid_590066 = path.getOrDefault("orderId")
  valid_590066 = validateParameter(valid_590066, JString, required = true,
                                 default = nil)
  if valid_590066 != nil:
    section.add "orderId", valid_590066
  var valid_590067 = path.getOrDefault("merchantId")
  valid_590067 = validateParameter(valid_590067, JString, required = true,
                                 default = nil)
  if valid_590067 != nil:
    section.add "merchantId", valid_590067
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590068 = query.getOrDefault("fields")
  valid_590068 = validateParameter(valid_590068, JString, required = false,
                                 default = nil)
  if valid_590068 != nil:
    section.add "fields", valid_590068
  var valid_590069 = query.getOrDefault("quotaUser")
  valid_590069 = validateParameter(valid_590069, JString, required = false,
                                 default = nil)
  if valid_590069 != nil:
    section.add "quotaUser", valid_590069
  var valid_590070 = query.getOrDefault("alt")
  valid_590070 = validateParameter(valid_590070, JString, required = false,
                                 default = newJString("json"))
  if valid_590070 != nil:
    section.add "alt", valid_590070
  var valid_590071 = query.getOrDefault("oauth_token")
  valid_590071 = validateParameter(valid_590071, JString, required = false,
                                 default = nil)
  if valid_590071 != nil:
    section.add "oauth_token", valid_590071
  var valid_590072 = query.getOrDefault("userIp")
  valid_590072 = validateParameter(valid_590072, JString, required = false,
                                 default = nil)
  if valid_590072 != nil:
    section.add "userIp", valid_590072
  var valid_590073 = query.getOrDefault("key")
  valid_590073 = validateParameter(valid_590073, JString, required = false,
                                 default = nil)
  if valid_590073 != nil:
    section.add "key", valid_590073
  var valid_590074 = query.getOrDefault("prettyPrint")
  valid_590074 = validateParameter(valid_590074, JBool, required = false,
                                 default = newJBool(true))
  if valid_590074 != nil:
    section.add "prettyPrint", valid_590074
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

proc call*(call_590076: Call_ContentOrdersInstorerefundlineitem_590063;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deprecated. Notifies that item return and refund was handled directly by merchant outside of Google payments processing (e.g. cash refund done in store).
  ## Note: We recommend calling the returnrefundlineitem method to refund in-store returns. We will issue the refund directly to the customer. This helps to prevent possible differences arising between merchant and Google transaction records. We also recommend having the point of sale system communicate with Google to ensure that customers do not receive a double refund by first refunding via Google then via an in-store return.
  ## 
  let valid = call_590076.validator(path, query, header, formData, body)
  let scheme = call_590076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590076.url(scheme.get, call_590076.host, call_590076.base,
                         call_590076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590076, url, valid)

proc call*(call_590077: Call_ContentOrdersInstorerefundlineitem_590063;
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
  var path_590078 = newJObject()
  var query_590079 = newJObject()
  var body_590080 = newJObject()
  add(query_590079, "fields", newJString(fields))
  add(query_590079, "quotaUser", newJString(quotaUser))
  add(query_590079, "alt", newJString(alt))
  add(query_590079, "oauth_token", newJString(oauthToken))
  add(query_590079, "userIp", newJString(userIp))
  add(path_590078, "orderId", newJString(orderId))
  add(query_590079, "key", newJString(key))
  add(path_590078, "merchantId", newJString(merchantId))
  if body != nil:
    body_590080 = body
  add(query_590079, "prettyPrint", newJBool(prettyPrint))
  result = call_590077.call(path_590078, query_590079, nil, nil, body_590080)

var contentOrdersInstorerefundlineitem* = Call_ContentOrdersInstorerefundlineitem_590063(
    name: "contentOrdersInstorerefundlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/inStoreRefundLineItem",
    validator: validate_ContentOrdersInstorerefundlineitem_590064,
    base: "/content/v2", url: url_ContentOrdersInstorerefundlineitem_590065,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersRefund_590081 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersRefund_590083(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrdersRefund_590082(path: JsonNode; query: JsonNode;
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
  var valid_590084 = path.getOrDefault("orderId")
  valid_590084 = validateParameter(valid_590084, JString, required = true,
                                 default = nil)
  if valid_590084 != nil:
    section.add "orderId", valid_590084
  var valid_590085 = path.getOrDefault("merchantId")
  valid_590085 = validateParameter(valid_590085, JString, required = true,
                                 default = nil)
  if valid_590085 != nil:
    section.add "merchantId", valid_590085
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590086 = query.getOrDefault("fields")
  valid_590086 = validateParameter(valid_590086, JString, required = false,
                                 default = nil)
  if valid_590086 != nil:
    section.add "fields", valid_590086
  var valid_590087 = query.getOrDefault("quotaUser")
  valid_590087 = validateParameter(valid_590087, JString, required = false,
                                 default = nil)
  if valid_590087 != nil:
    section.add "quotaUser", valid_590087
  var valid_590088 = query.getOrDefault("alt")
  valid_590088 = validateParameter(valid_590088, JString, required = false,
                                 default = newJString("json"))
  if valid_590088 != nil:
    section.add "alt", valid_590088
  var valid_590089 = query.getOrDefault("oauth_token")
  valid_590089 = validateParameter(valid_590089, JString, required = false,
                                 default = nil)
  if valid_590089 != nil:
    section.add "oauth_token", valid_590089
  var valid_590090 = query.getOrDefault("userIp")
  valid_590090 = validateParameter(valid_590090, JString, required = false,
                                 default = nil)
  if valid_590090 != nil:
    section.add "userIp", valid_590090
  var valid_590091 = query.getOrDefault("key")
  valid_590091 = validateParameter(valid_590091, JString, required = false,
                                 default = nil)
  if valid_590091 != nil:
    section.add "key", valid_590091
  var valid_590092 = query.getOrDefault("prettyPrint")
  valid_590092 = validateParameter(valid_590092, JBool, required = false,
                                 default = newJBool(true))
  if valid_590092 != nil:
    section.add "prettyPrint", valid_590092
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

proc call*(call_590094: Call_ContentOrdersRefund_590081; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated, please use returnRefundLineItem instead.
  ## 
  let valid = call_590094.validator(path, query, header, formData, body)
  let scheme = call_590094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590094.url(scheme.get, call_590094.host, call_590094.base,
                         call_590094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590094, url, valid)

proc call*(call_590095: Call_ContentOrdersRefund_590081; orderId: string;
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
  var path_590096 = newJObject()
  var query_590097 = newJObject()
  var body_590098 = newJObject()
  add(query_590097, "fields", newJString(fields))
  add(query_590097, "quotaUser", newJString(quotaUser))
  add(query_590097, "alt", newJString(alt))
  add(query_590097, "oauth_token", newJString(oauthToken))
  add(query_590097, "userIp", newJString(userIp))
  add(path_590096, "orderId", newJString(orderId))
  add(query_590097, "key", newJString(key))
  add(path_590096, "merchantId", newJString(merchantId))
  if body != nil:
    body_590098 = body
  add(query_590097, "prettyPrint", newJBool(prettyPrint))
  result = call_590095.call(path_590096, query_590097, nil, nil, body_590098)

var contentOrdersRefund* = Call_ContentOrdersRefund_590081(
    name: "contentOrdersRefund", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/orders/{orderId}/refund",
    validator: validate_ContentOrdersRefund_590082, base: "/content/v2",
    url: url_ContentOrdersRefund_590083, schemes: {Scheme.Https})
type
  Call_ContentOrdersRejectreturnlineitem_590099 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersRejectreturnlineitem_590101(protocol: Scheme; host: string;
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

proc validate_ContentOrdersRejectreturnlineitem_590100(path: JsonNode;
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
  var valid_590102 = path.getOrDefault("orderId")
  valid_590102 = validateParameter(valid_590102, JString, required = true,
                                 default = nil)
  if valid_590102 != nil:
    section.add "orderId", valid_590102
  var valid_590103 = path.getOrDefault("merchantId")
  valid_590103 = validateParameter(valid_590103, JString, required = true,
                                 default = nil)
  if valid_590103 != nil:
    section.add "merchantId", valid_590103
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590104 = query.getOrDefault("fields")
  valid_590104 = validateParameter(valid_590104, JString, required = false,
                                 default = nil)
  if valid_590104 != nil:
    section.add "fields", valid_590104
  var valid_590105 = query.getOrDefault("quotaUser")
  valid_590105 = validateParameter(valid_590105, JString, required = false,
                                 default = nil)
  if valid_590105 != nil:
    section.add "quotaUser", valid_590105
  var valid_590106 = query.getOrDefault("alt")
  valid_590106 = validateParameter(valid_590106, JString, required = false,
                                 default = newJString("json"))
  if valid_590106 != nil:
    section.add "alt", valid_590106
  var valid_590107 = query.getOrDefault("oauth_token")
  valid_590107 = validateParameter(valid_590107, JString, required = false,
                                 default = nil)
  if valid_590107 != nil:
    section.add "oauth_token", valid_590107
  var valid_590108 = query.getOrDefault("userIp")
  valid_590108 = validateParameter(valid_590108, JString, required = false,
                                 default = nil)
  if valid_590108 != nil:
    section.add "userIp", valid_590108
  var valid_590109 = query.getOrDefault("key")
  valid_590109 = validateParameter(valid_590109, JString, required = false,
                                 default = nil)
  if valid_590109 != nil:
    section.add "key", valid_590109
  var valid_590110 = query.getOrDefault("prettyPrint")
  valid_590110 = validateParameter(valid_590110, JBool, required = false,
                                 default = newJBool(true))
  if valid_590110 != nil:
    section.add "prettyPrint", valid_590110
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

proc call*(call_590112: Call_ContentOrdersRejectreturnlineitem_590099;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rejects return on an line item.
  ## 
  let valid = call_590112.validator(path, query, header, formData, body)
  let scheme = call_590112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590112.url(scheme.get, call_590112.host, call_590112.base,
                         call_590112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590112, url, valid)

proc call*(call_590113: Call_ContentOrdersRejectreturnlineitem_590099;
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
  var path_590114 = newJObject()
  var query_590115 = newJObject()
  var body_590116 = newJObject()
  add(query_590115, "fields", newJString(fields))
  add(query_590115, "quotaUser", newJString(quotaUser))
  add(query_590115, "alt", newJString(alt))
  add(query_590115, "oauth_token", newJString(oauthToken))
  add(query_590115, "userIp", newJString(userIp))
  add(path_590114, "orderId", newJString(orderId))
  add(query_590115, "key", newJString(key))
  add(path_590114, "merchantId", newJString(merchantId))
  if body != nil:
    body_590116 = body
  add(query_590115, "prettyPrint", newJBool(prettyPrint))
  result = call_590113.call(path_590114, query_590115, nil, nil, body_590116)

var contentOrdersRejectreturnlineitem* = Call_ContentOrdersRejectreturnlineitem_590099(
    name: "contentOrdersRejectreturnlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/rejectReturnLineItem",
    validator: validate_ContentOrdersRejectreturnlineitem_590100,
    base: "/content/v2", url: url_ContentOrdersRejectreturnlineitem_590101,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersReturnlineitem_590117 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersReturnlineitem_590119(protocol: Scheme; host: string;
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

proc validate_ContentOrdersReturnlineitem_590118(path: JsonNode; query: JsonNode;
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
  var valid_590120 = path.getOrDefault("orderId")
  valid_590120 = validateParameter(valid_590120, JString, required = true,
                                 default = nil)
  if valid_590120 != nil:
    section.add "orderId", valid_590120
  var valid_590121 = path.getOrDefault("merchantId")
  valid_590121 = validateParameter(valid_590121, JString, required = true,
                                 default = nil)
  if valid_590121 != nil:
    section.add "merchantId", valid_590121
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590122 = query.getOrDefault("fields")
  valid_590122 = validateParameter(valid_590122, JString, required = false,
                                 default = nil)
  if valid_590122 != nil:
    section.add "fields", valid_590122
  var valid_590123 = query.getOrDefault("quotaUser")
  valid_590123 = validateParameter(valid_590123, JString, required = false,
                                 default = nil)
  if valid_590123 != nil:
    section.add "quotaUser", valid_590123
  var valid_590124 = query.getOrDefault("alt")
  valid_590124 = validateParameter(valid_590124, JString, required = false,
                                 default = newJString("json"))
  if valid_590124 != nil:
    section.add "alt", valid_590124
  var valid_590125 = query.getOrDefault("oauth_token")
  valid_590125 = validateParameter(valid_590125, JString, required = false,
                                 default = nil)
  if valid_590125 != nil:
    section.add "oauth_token", valid_590125
  var valid_590126 = query.getOrDefault("userIp")
  valid_590126 = validateParameter(valid_590126, JString, required = false,
                                 default = nil)
  if valid_590126 != nil:
    section.add "userIp", valid_590126
  var valid_590127 = query.getOrDefault("key")
  valid_590127 = validateParameter(valid_590127, JString, required = false,
                                 default = nil)
  if valid_590127 != nil:
    section.add "key", valid_590127
  var valid_590128 = query.getOrDefault("prettyPrint")
  valid_590128 = validateParameter(valid_590128, JBool, required = false,
                                 default = newJBool(true))
  if valid_590128 != nil:
    section.add "prettyPrint", valid_590128
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

proc call*(call_590130: Call_ContentOrdersReturnlineitem_590117; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a line item.
  ## 
  let valid = call_590130.validator(path, query, header, formData, body)
  let scheme = call_590130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590130.url(scheme.get, call_590130.host, call_590130.base,
                         call_590130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590130, url, valid)

proc call*(call_590131: Call_ContentOrdersReturnlineitem_590117; orderId: string;
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
  var path_590132 = newJObject()
  var query_590133 = newJObject()
  var body_590134 = newJObject()
  add(query_590133, "fields", newJString(fields))
  add(query_590133, "quotaUser", newJString(quotaUser))
  add(query_590133, "alt", newJString(alt))
  add(query_590133, "oauth_token", newJString(oauthToken))
  add(query_590133, "userIp", newJString(userIp))
  add(path_590132, "orderId", newJString(orderId))
  add(query_590133, "key", newJString(key))
  add(path_590132, "merchantId", newJString(merchantId))
  if body != nil:
    body_590134 = body
  add(query_590133, "prettyPrint", newJBool(prettyPrint))
  result = call_590131.call(path_590132, query_590133, nil, nil, body_590134)

var contentOrdersReturnlineitem* = Call_ContentOrdersReturnlineitem_590117(
    name: "contentOrdersReturnlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/returnLineItem",
    validator: validate_ContentOrdersReturnlineitem_590118, base: "/content/v2",
    url: url_ContentOrdersReturnlineitem_590119, schemes: {Scheme.Https})
type
  Call_ContentOrdersReturnrefundlineitem_590135 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersReturnrefundlineitem_590137(protocol: Scheme; host: string;
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

proc validate_ContentOrdersReturnrefundlineitem_590136(path: JsonNode;
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
  var valid_590138 = path.getOrDefault("orderId")
  valid_590138 = validateParameter(valid_590138, JString, required = true,
                                 default = nil)
  if valid_590138 != nil:
    section.add "orderId", valid_590138
  var valid_590139 = path.getOrDefault("merchantId")
  valid_590139 = validateParameter(valid_590139, JString, required = true,
                                 default = nil)
  if valid_590139 != nil:
    section.add "merchantId", valid_590139
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590140 = query.getOrDefault("fields")
  valid_590140 = validateParameter(valid_590140, JString, required = false,
                                 default = nil)
  if valid_590140 != nil:
    section.add "fields", valid_590140
  var valid_590141 = query.getOrDefault("quotaUser")
  valid_590141 = validateParameter(valid_590141, JString, required = false,
                                 default = nil)
  if valid_590141 != nil:
    section.add "quotaUser", valid_590141
  var valid_590142 = query.getOrDefault("alt")
  valid_590142 = validateParameter(valid_590142, JString, required = false,
                                 default = newJString("json"))
  if valid_590142 != nil:
    section.add "alt", valid_590142
  var valid_590143 = query.getOrDefault("oauth_token")
  valid_590143 = validateParameter(valid_590143, JString, required = false,
                                 default = nil)
  if valid_590143 != nil:
    section.add "oauth_token", valid_590143
  var valid_590144 = query.getOrDefault("userIp")
  valid_590144 = validateParameter(valid_590144, JString, required = false,
                                 default = nil)
  if valid_590144 != nil:
    section.add "userIp", valid_590144
  var valid_590145 = query.getOrDefault("key")
  valid_590145 = validateParameter(valid_590145, JString, required = false,
                                 default = nil)
  if valid_590145 != nil:
    section.add "key", valid_590145
  var valid_590146 = query.getOrDefault("prettyPrint")
  valid_590146 = validateParameter(valid_590146, JBool, required = false,
                                 default = newJBool(true))
  if valid_590146 != nil:
    section.add "prettyPrint", valid_590146
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

proc call*(call_590148: Call_ContentOrdersReturnrefundlineitem_590135;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns and refunds a line item. Note that this method can only be called on fully shipped orders.
  ## 
  let valid = call_590148.validator(path, query, header, formData, body)
  let scheme = call_590148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590148.url(scheme.get, call_590148.host, call_590148.base,
                         call_590148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590148, url, valid)

proc call*(call_590149: Call_ContentOrdersReturnrefundlineitem_590135;
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
  var path_590150 = newJObject()
  var query_590151 = newJObject()
  var body_590152 = newJObject()
  add(query_590151, "fields", newJString(fields))
  add(query_590151, "quotaUser", newJString(quotaUser))
  add(query_590151, "alt", newJString(alt))
  add(query_590151, "oauth_token", newJString(oauthToken))
  add(query_590151, "userIp", newJString(userIp))
  add(path_590150, "orderId", newJString(orderId))
  add(query_590151, "key", newJString(key))
  add(path_590150, "merchantId", newJString(merchantId))
  if body != nil:
    body_590152 = body
  add(query_590151, "prettyPrint", newJBool(prettyPrint))
  result = call_590149.call(path_590150, query_590151, nil, nil, body_590152)

var contentOrdersReturnrefundlineitem* = Call_ContentOrdersReturnrefundlineitem_590135(
    name: "contentOrdersReturnrefundlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/returnRefundLineItem",
    validator: validate_ContentOrdersReturnrefundlineitem_590136,
    base: "/content/v2", url: url_ContentOrdersReturnrefundlineitem_590137,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersSetlineitemmetadata_590153 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersSetlineitemmetadata_590155(protocol: Scheme; host: string;
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

proc validate_ContentOrdersSetlineitemmetadata_590154(path: JsonNode;
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
  var valid_590156 = path.getOrDefault("orderId")
  valid_590156 = validateParameter(valid_590156, JString, required = true,
                                 default = nil)
  if valid_590156 != nil:
    section.add "orderId", valid_590156
  var valid_590157 = path.getOrDefault("merchantId")
  valid_590157 = validateParameter(valid_590157, JString, required = true,
                                 default = nil)
  if valid_590157 != nil:
    section.add "merchantId", valid_590157
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590158 = query.getOrDefault("fields")
  valid_590158 = validateParameter(valid_590158, JString, required = false,
                                 default = nil)
  if valid_590158 != nil:
    section.add "fields", valid_590158
  var valid_590159 = query.getOrDefault("quotaUser")
  valid_590159 = validateParameter(valid_590159, JString, required = false,
                                 default = nil)
  if valid_590159 != nil:
    section.add "quotaUser", valid_590159
  var valid_590160 = query.getOrDefault("alt")
  valid_590160 = validateParameter(valid_590160, JString, required = false,
                                 default = newJString("json"))
  if valid_590160 != nil:
    section.add "alt", valid_590160
  var valid_590161 = query.getOrDefault("oauth_token")
  valid_590161 = validateParameter(valid_590161, JString, required = false,
                                 default = nil)
  if valid_590161 != nil:
    section.add "oauth_token", valid_590161
  var valid_590162 = query.getOrDefault("userIp")
  valid_590162 = validateParameter(valid_590162, JString, required = false,
                                 default = nil)
  if valid_590162 != nil:
    section.add "userIp", valid_590162
  var valid_590163 = query.getOrDefault("key")
  valid_590163 = validateParameter(valid_590163, JString, required = false,
                                 default = nil)
  if valid_590163 != nil:
    section.add "key", valid_590163
  var valid_590164 = query.getOrDefault("prettyPrint")
  valid_590164 = validateParameter(valid_590164, JBool, required = false,
                                 default = newJBool(true))
  if valid_590164 != nil:
    section.add "prettyPrint", valid_590164
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

proc call*(call_590166: Call_ContentOrdersSetlineitemmetadata_590153;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets (or overrides if it already exists) merchant provided annotations in the form of key-value pairs. A common use case would be to supply us with additional structured information about a line item that cannot be provided via other methods. Submitted key-value pairs can be retrieved as part of the orders resource.
  ## 
  let valid = call_590166.validator(path, query, header, formData, body)
  let scheme = call_590166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590166.url(scheme.get, call_590166.host, call_590166.base,
                         call_590166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590166, url, valid)

proc call*(call_590167: Call_ContentOrdersSetlineitemmetadata_590153;
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
  var path_590168 = newJObject()
  var query_590169 = newJObject()
  var body_590170 = newJObject()
  add(query_590169, "fields", newJString(fields))
  add(query_590169, "quotaUser", newJString(quotaUser))
  add(query_590169, "alt", newJString(alt))
  add(query_590169, "oauth_token", newJString(oauthToken))
  add(query_590169, "userIp", newJString(userIp))
  add(path_590168, "orderId", newJString(orderId))
  add(query_590169, "key", newJString(key))
  add(path_590168, "merchantId", newJString(merchantId))
  if body != nil:
    body_590170 = body
  add(query_590169, "prettyPrint", newJBool(prettyPrint))
  result = call_590167.call(path_590168, query_590169, nil, nil, body_590170)

var contentOrdersSetlineitemmetadata* = Call_ContentOrdersSetlineitemmetadata_590153(
    name: "contentOrdersSetlineitemmetadata", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/setLineItemMetadata",
    validator: validate_ContentOrdersSetlineitemmetadata_590154,
    base: "/content/v2", url: url_ContentOrdersSetlineitemmetadata_590155,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersShiplineitems_590171 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersShiplineitems_590173(protocol: Scheme; host: string;
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

proc validate_ContentOrdersShiplineitems_590172(path: JsonNode; query: JsonNode;
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
  var valid_590174 = path.getOrDefault("orderId")
  valid_590174 = validateParameter(valid_590174, JString, required = true,
                                 default = nil)
  if valid_590174 != nil:
    section.add "orderId", valid_590174
  var valid_590175 = path.getOrDefault("merchantId")
  valid_590175 = validateParameter(valid_590175, JString, required = true,
                                 default = nil)
  if valid_590175 != nil:
    section.add "merchantId", valid_590175
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590176 = query.getOrDefault("fields")
  valid_590176 = validateParameter(valid_590176, JString, required = false,
                                 default = nil)
  if valid_590176 != nil:
    section.add "fields", valid_590176
  var valid_590177 = query.getOrDefault("quotaUser")
  valid_590177 = validateParameter(valid_590177, JString, required = false,
                                 default = nil)
  if valid_590177 != nil:
    section.add "quotaUser", valid_590177
  var valid_590178 = query.getOrDefault("alt")
  valid_590178 = validateParameter(valid_590178, JString, required = false,
                                 default = newJString("json"))
  if valid_590178 != nil:
    section.add "alt", valid_590178
  var valid_590179 = query.getOrDefault("oauth_token")
  valid_590179 = validateParameter(valid_590179, JString, required = false,
                                 default = nil)
  if valid_590179 != nil:
    section.add "oauth_token", valid_590179
  var valid_590180 = query.getOrDefault("userIp")
  valid_590180 = validateParameter(valid_590180, JString, required = false,
                                 default = nil)
  if valid_590180 != nil:
    section.add "userIp", valid_590180
  var valid_590181 = query.getOrDefault("key")
  valid_590181 = validateParameter(valid_590181, JString, required = false,
                                 default = nil)
  if valid_590181 != nil:
    section.add "key", valid_590181
  var valid_590182 = query.getOrDefault("prettyPrint")
  valid_590182 = validateParameter(valid_590182, JBool, required = false,
                                 default = newJBool(true))
  if valid_590182 != nil:
    section.add "prettyPrint", valid_590182
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

proc call*(call_590184: Call_ContentOrdersShiplineitems_590171; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks line item(s) as shipped.
  ## 
  let valid = call_590184.validator(path, query, header, formData, body)
  let scheme = call_590184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590184.url(scheme.get, call_590184.host, call_590184.base,
                         call_590184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590184, url, valid)

proc call*(call_590185: Call_ContentOrdersShiplineitems_590171; orderId: string;
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
  var path_590186 = newJObject()
  var query_590187 = newJObject()
  var body_590188 = newJObject()
  add(query_590187, "fields", newJString(fields))
  add(query_590187, "quotaUser", newJString(quotaUser))
  add(query_590187, "alt", newJString(alt))
  add(query_590187, "oauth_token", newJString(oauthToken))
  add(query_590187, "userIp", newJString(userIp))
  add(path_590186, "orderId", newJString(orderId))
  add(query_590187, "key", newJString(key))
  add(path_590186, "merchantId", newJString(merchantId))
  if body != nil:
    body_590188 = body
  add(query_590187, "prettyPrint", newJBool(prettyPrint))
  result = call_590185.call(path_590186, query_590187, nil, nil, body_590188)

var contentOrdersShiplineitems* = Call_ContentOrdersShiplineitems_590171(
    name: "contentOrdersShiplineitems", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/shipLineItems",
    validator: validate_ContentOrdersShiplineitems_590172, base: "/content/v2",
    url: url_ContentOrdersShiplineitems_590173, schemes: {Scheme.Https})
type
  Call_ContentOrdersCreatetestreturn_590189 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersCreatetestreturn_590191(protocol: Scheme; host: string;
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

proc validate_ContentOrdersCreatetestreturn_590190(path: JsonNode; query: JsonNode;
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
  var valid_590192 = path.getOrDefault("orderId")
  valid_590192 = validateParameter(valid_590192, JString, required = true,
                                 default = nil)
  if valid_590192 != nil:
    section.add "orderId", valid_590192
  var valid_590193 = path.getOrDefault("merchantId")
  valid_590193 = validateParameter(valid_590193, JString, required = true,
                                 default = nil)
  if valid_590193 != nil:
    section.add "merchantId", valid_590193
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590194 = query.getOrDefault("fields")
  valid_590194 = validateParameter(valid_590194, JString, required = false,
                                 default = nil)
  if valid_590194 != nil:
    section.add "fields", valid_590194
  var valid_590195 = query.getOrDefault("quotaUser")
  valid_590195 = validateParameter(valid_590195, JString, required = false,
                                 default = nil)
  if valid_590195 != nil:
    section.add "quotaUser", valid_590195
  var valid_590196 = query.getOrDefault("alt")
  valid_590196 = validateParameter(valid_590196, JString, required = false,
                                 default = newJString("json"))
  if valid_590196 != nil:
    section.add "alt", valid_590196
  var valid_590197 = query.getOrDefault("oauth_token")
  valid_590197 = validateParameter(valid_590197, JString, required = false,
                                 default = nil)
  if valid_590197 != nil:
    section.add "oauth_token", valid_590197
  var valid_590198 = query.getOrDefault("userIp")
  valid_590198 = validateParameter(valid_590198, JString, required = false,
                                 default = nil)
  if valid_590198 != nil:
    section.add "userIp", valid_590198
  var valid_590199 = query.getOrDefault("key")
  valid_590199 = validateParameter(valid_590199, JString, required = false,
                                 default = nil)
  if valid_590199 != nil:
    section.add "key", valid_590199
  var valid_590200 = query.getOrDefault("prettyPrint")
  valid_590200 = validateParameter(valid_590200, JBool, required = false,
                                 default = newJBool(true))
  if valid_590200 != nil:
    section.add "prettyPrint", valid_590200
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

proc call*(call_590202: Call_ContentOrdersCreatetestreturn_590189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Creates a test return.
  ## 
  let valid = call_590202.validator(path, query, header, formData, body)
  let scheme = call_590202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590202.url(scheme.get, call_590202.host, call_590202.base,
                         call_590202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590202, url, valid)

proc call*(call_590203: Call_ContentOrdersCreatetestreturn_590189; orderId: string;
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
  var path_590204 = newJObject()
  var query_590205 = newJObject()
  var body_590206 = newJObject()
  add(query_590205, "fields", newJString(fields))
  add(query_590205, "quotaUser", newJString(quotaUser))
  add(query_590205, "alt", newJString(alt))
  add(query_590205, "oauth_token", newJString(oauthToken))
  add(query_590205, "userIp", newJString(userIp))
  add(path_590204, "orderId", newJString(orderId))
  add(query_590205, "key", newJString(key))
  add(path_590204, "merchantId", newJString(merchantId))
  if body != nil:
    body_590206 = body
  add(query_590205, "prettyPrint", newJBool(prettyPrint))
  result = call_590203.call(path_590204, query_590205, nil, nil, body_590206)

var contentOrdersCreatetestreturn* = Call_ContentOrdersCreatetestreturn_590189(
    name: "contentOrdersCreatetestreturn", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/testreturn",
    validator: validate_ContentOrdersCreatetestreturn_590190, base: "/content/v2",
    url: url_ContentOrdersCreatetestreturn_590191, schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdatelineitemshippingdetails_590207 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersUpdatelineitemshippingdetails_590209(protocol: Scheme;
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

proc validate_ContentOrdersUpdatelineitemshippingdetails_590208(path: JsonNode;
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
  var valid_590210 = path.getOrDefault("orderId")
  valid_590210 = validateParameter(valid_590210, JString, required = true,
                                 default = nil)
  if valid_590210 != nil:
    section.add "orderId", valid_590210
  var valid_590211 = path.getOrDefault("merchantId")
  valid_590211 = validateParameter(valid_590211, JString, required = true,
                                 default = nil)
  if valid_590211 != nil:
    section.add "merchantId", valid_590211
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590212 = query.getOrDefault("fields")
  valid_590212 = validateParameter(valid_590212, JString, required = false,
                                 default = nil)
  if valid_590212 != nil:
    section.add "fields", valid_590212
  var valid_590213 = query.getOrDefault("quotaUser")
  valid_590213 = validateParameter(valid_590213, JString, required = false,
                                 default = nil)
  if valid_590213 != nil:
    section.add "quotaUser", valid_590213
  var valid_590214 = query.getOrDefault("alt")
  valid_590214 = validateParameter(valid_590214, JString, required = false,
                                 default = newJString("json"))
  if valid_590214 != nil:
    section.add "alt", valid_590214
  var valid_590215 = query.getOrDefault("oauth_token")
  valid_590215 = validateParameter(valid_590215, JString, required = false,
                                 default = nil)
  if valid_590215 != nil:
    section.add "oauth_token", valid_590215
  var valid_590216 = query.getOrDefault("userIp")
  valid_590216 = validateParameter(valid_590216, JString, required = false,
                                 default = nil)
  if valid_590216 != nil:
    section.add "userIp", valid_590216
  var valid_590217 = query.getOrDefault("key")
  valid_590217 = validateParameter(valid_590217, JString, required = false,
                                 default = nil)
  if valid_590217 != nil:
    section.add "key", valid_590217
  var valid_590218 = query.getOrDefault("prettyPrint")
  valid_590218 = validateParameter(valid_590218, JBool, required = false,
                                 default = newJBool(true))
  if valid_590218 != nil:
    section.add "prettyPrint", valid_590218
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

proc call*(call_590220: Call_ContentOrdersUpdatelineitemshippingdetails_590207;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates ship by and delivery by dates for a line item.
  ## 
  let valid = call_590220.validator(path, query, header, formData, body)
  let scheme = call_590220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590220.url(scheme.get, call_590220.host, call_590220.base,
                         call_590220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590220, url, valid)

proc call*(call_590221: Call_ContentOrdersUpdatelineitemshippingdetails_590207;
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
  var path_590222 = newJObject()
  var query_590223 = newJObject()
  var body_590224 = newJObject()
  add(query_590223, "fields", newJString(fields))
  add(query_590223, "quotaUser", newJString(quotaUser))
  add(query_590223, "alt", newJString(alt))
  add(query_590223, "oauth_token", newJString(oauthToken))
  add(query_590223, "userIp", newJString(userIp))
  add(path_590222, "orderId", newJString(orderId))
  add(query_590223, "key", newJString(key))
  add(path_590222, "merchantId", newJString(merchantId))
  if body != nil:
    body_590224 = body
  add(query_590223, "prettyPrint", newJBool(prettyPrint))
  result = call_590221.call(path_590222, query_590223, nil, nil, body_590224)

var contentOrdersUpdatelineitemshippingdetails* = Call_ContentOrdersUpdatelineitemshippingdetails_590207(
    name: "contentOrdersUpdatelineitemshippingdetails", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateLineItemShippingDetails",
    validator: validate_ContentOrdersUpdatelineitemshippingdetails_590208,
    base: "/content/v2", url: url_ContentOrdersUpdatelineitemshippingdetails_590209,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdatemerchantorderid_590225 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersUpdatemerchantorderid_590227(protocol: Scheme; host: string;
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

proc validate_ContentOrdersUpdatemerchantorderid_590226(path: JsonNode;
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
  var valid_590228 = path.getOrDefault("orderId")
  valid_590228 = validateParameter(valid_590228, JString, required = true,
                                 default = nil)
  if valid_590228 != nil:
    section.add "orderId", valid_590228
  var valid_590229 = path.getOrDefault("merchantId")
  valid_590229 = validateParameter(valid_590229, JString, required = true,
                                 default = nil)
  if valid_590229 != nil:
    section.add "merchantId", valid_590229
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590230 = query.getOrDefault("fields")
  valid_590230 = validateParameter(valid_590230, JString, required = false,
                                 default = nil)
  if valid_590230 != nil:
    section.add "fields", valid_590230
  var valid_590231 = query.getOrDefault("quotaUser")
  valid_590231 = validateParameter(valid_590231, JString, required = false,
                                 default = nil)
  if valid_590231 != nil:
    section.add "quotaUser", valid_590231
  var valid_590232 = query.getOrDefault("alt")
  valid_590232 = validateParameter(valid_590232, JString, required = false,
                                 default = newJString("json"))
  if valid_590232 != nil:
    section.add "alt", valid_590232
  var valid_590233 = query.getOrDefault("oauth_token")
  valid_590233 = validateParameter(valid_590233, JString, required = false,
                                 default = nil)
  if valid_590233 != nil:
    section.add "oauth_token", valid_590233
  var valid_590234 = query.getOrDefault("userIp")
  valid_590234 = validateParameter(valid_590234, JString, required = false,
                                 default = nil)
  if valid_590234 != nil:
    section.add "userIp", valid_590234
  var valid_590235 = query.getOrDefault("key")
  valid_590235 = validateParameter(valid_590235, JString, required = false,
                                 default = nil)
  if valid_590235 != nil:
    section.add "key", valid_590235
  var valid_590236 = query.getOrDefault("prettyPrint")
  valid_590236 = validateParameter(valid_590236, JBool, required = false,
                                 default = newJBool(true))
  if valid_590236 != nil:
    section.add "prettyPrint", valid_590236
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

proc call*(call_590238: Call_ContentOrdersUpdatemerchantorderid_590225;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the merchant order ID for a given order.
  ## 
  let valid = call_590238.validator(path, query, header, formData, body)
  let scheme = call_590238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590238.url(scheme.get, call_590238.host, call_590238.base,
                         call_590238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590238, url, valid)

proc call*(call_590239: Call_ContentOrdersUpdatemerchantorderid_590225;
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
  var path_590240 = newJObject()
  var query_590241 = newJObject()
  var body_590242 = newJObject()
  add(query_590241, "fields", newJString(fields))
  add(query_590241, "quotaUser", newJString(quotaUser))
  add(query_590241, "alt", newJString(alt))
  add(query_590241, "oauth_token", newJString(oauthToken))
  add(query_590241, "userIp", newJString(userIp))
  add(path_590240, "orderId", newJString(orderId))
  add(query_590241, "key", newJString(key))
  add(path_590240, "merchantId", newJString(merchantId))
  if body != nil:
    body_590242 = body
  add(query_590241, "prettyPrint", newJBool(prettyPrint))
  result = call_590239.call(path_590240, query_590241, nil, nil, body_590242)

var contentOrdersUpdatemerchantorderid* = Call_ContentOrdersUpdatemerchantorderid_590225(
    name: "contentOrdersUpdatemerchantorderid", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateMerchantOrderId",
    validator: validate_ContentOrdersUpdatemerchantorderid_590226,
    base: "/content/v2", url: url_ContentOrdersUpdatemerchantorderid_590227,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdateshipment_590243 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersUpdateshipment_590245(protocol: Scheme; host: string;
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

proc validate_ContentOrdersUpdateshipment_590244(path: JsonNode; query: JsonNode;
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
  var valid_590246 = path.getOrDefault("orderId")
  valid_590246 = validateParameter(valid_590246, JString, required = true,
                                 default = nil)
  if valid_590246 != nil:
    section.add "orderId", valid_590246
  var valid_590247 = path.getOrDefault("merchantId")
  valid_590247 = validateParameter(valid_590247, JString, required = true,
                                 default = nil)
  if valid_590247 != nil:
    section.add "merchantId", valid_590247
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590248 = query.getOrDefault("fields")
  valid_590248 = validateParameter(valid_590248, JString, required = false,
                                 default = nil)
  if valid_590248 != nil:
    section.add "fields", valid_590248
  var valid_590249 = query.getOrDefault("quotaUser")
  valid_590249 = validateParameter(valid_590249, JString, required = false,
                                 default = nil)
  if valid_590249 != nil:
    section.add "quotaUser", valid_590249
  var valid_590250 = query.getOrDefault("alt")
  valid_590250 = validateParameter(valid_590250, JString, required = false,
                                 default = newJString("json"))
  if valid_590250 != nil:
    section.add "alt", valid_590250
  var valid_590251 = query.getOrDefault("oauth_token")
  valid_590251 = validateParameter(valid_590251, JString, required = false,
                                 default = nil)
  if valid_590251 != nil:
    section.add "oauth_token", valid_590251
  var valid_590252 = query.getOrDefault("userIp")
  valid_590252 = validateParameter(valid_590252, JString, required = false,
                                 default = nil)
  if valid_590252 != nil:
    section.add "userIp", valid_590252
  var valid_590253 = query.getOrDefault("key")
  valid_590253 = validateParameter(valid_590253, JString, required = false,
                                 default = nil)
  if valid_590253 != nil:
    section.add "key", valid_590253
  var valid_590254 = query.getOrDefault("prettyPrint")
  valid_590254 = validateParameter(valid_590254, JBool, required = false,
                                 default = newJBool(true))
  if valid_590254 != nil:
    section.add "prettyPrint", valid_590254
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

proc call*(call_590256: Call_ContentOrdersUpdateshipment_590243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a shipment's status, carrier, and/or tracking ID.
  ## 
  let valid = call_590256.validator(path, query, header, formData, body)
  let scheme = call_590256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590256.url(scheme.get, call_590256.host, call_590256.base,
                         call_590256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590256, url, valid)

proc call*(call_590257: Call_ContentOrdersUpdateshipment_590243; orderId: string;
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
  var path_590258 = newJObject()
  var query_590259 = newJObject()
  var body_590260 = newJObject()
  add(query_590259, "fields", newJString(fields))
  add(query_590259, "quotaUser", newJString(quotaUser))
  add(query_590259, "alt", newJString(alt))
  add(query_590259, "oauth_token", newJString(oauthToken))
  add(query_590259, "userIp", newJString(userIp))
  add(path_590258, "orderId", newJString(orderId))
  add(query_590259, "key", newJString(key))
  add(path_590258, "merchantId", newJString(merchantId))
  if body != nil:
    body_590260 = body
  add(query_590259, "prettyPrint", newJBool(prettyPrint))
  result = call_590257.call(path_590258, query_590259, nil, nil, body_590260)

var contentOrdersUpdateshipment* = Call_ContentOrdersUpdateshipment_590243(
    name: "contentOrdersUpdateshipment", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateShipment",
    validator: validate_ContentOrdersUpdateshipment_590244, base: "/content/v2",
    url: url_ContentOrdersUpdateshipment_590245, schemes: {Scheme.Https})
type
  Call_ContentOrdersGetbymerchantorderid_590261 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersGetbymerchantorderid_590263(protocol: Scheme; host: string;
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

proc validate_ContentOrdersGetbymerchantorderid_590262(path: JsonNode;
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
  var valid_590264 = path.getOrDefault("merchantOrderId")
  valid_590264 = validateParameter(valid_590264, JString, required = true,
                                 default = nil)
  if valid_590264 != nil:
    section.add "merchantOrderId", valid_590264
  var valid_590265 = path.getOrDefault("merchantId")
  valid_590265 = validateParameter(valid_590265, JString, required = true,
                                 default = nil)
  if valid_590265 != nil:
    section.add "merchantId", valid_590265
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590266 = query.getOrDefault("fields")
  valid_590266 = validateParameter(valid_590266, JString, required = false,
                                 default = nil)
  if valid_590266 != nil:
    section.add "fields", valid_590266
  var valid_590267 = query.getOrDefault("quotaUser")
  valid_590267 = validateParameter(valid_590267, JString, required = false,
                                 default = nil)
  if valid_590267 != nil:
    section.add "quotaUser", valid_590267
  var valid_590268 = query.getOrDefault("alt")
  valid_590268 = validateParameter(valid_590268, JString, required = false,
                                 default = newJString("json"))
  if valid_590268 != nil:
    section.add "alt", valid_590268
  var valid_590269 = query.getOrDefault("oauth_token")
  valid_590269 = validateParameter(valid_590269, JString, required = false,
                                 default = nil)
  if valid_590269 != nil:
    section.add "oauth_token", valid_590269
  var valid_590270 = query.getOrDefault("userIp")
  valid_590270 = validateParameter(valid_590270, JString, required = false,
                                 default = nil)
  if valid_590270 != nil:
    section.add "userIp", valid_590270
  var valid_590271 = query.getOrDefault("key")
  valid_590271 = validateParameter(valid_590271, JString, required = false,
                                 default = nil)
  if valid_590271 != nil:
    section.add "key", valid_590271
  var valid_590272 = query.getOrDefault("prettyPrint")
  valid_590272 = validateParameter(valid_590272, JBool, required = false,
                                 default = newJBool(true))
  if valid_590272 != nil:
    section.add "prettyPrint", valid_590272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590273: Call_ContentOrdersGetbymerchantorderid_590261;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves an order using merchant order ID.
  ## 
  let valid = call_590273.validator(path, query, header, formData, body)
  let scheme = call_590273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590273.url(scheme.get, call_590273.host, call_590273.base,
                         call_590273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590273, url, valid)

proc call*(call_590274: Call_ContentOrdersGetbymerchantorderid_590261;
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
  var path_590275 = newJObject()
  var query_590276 = newJObject()
  add(query_590276, "fields", newJString(fields))
  add(query_590276, "quotaUser", newJString(quotaUser))
  add(query_590276, "alt", newJString(alt))
  add(query_590276, "oauth_token", newJString(oauthToken))
  add(query_590276, "userIp", newJString(userIp))
  add(query_590276, "key", newJString(key))
  add(path_590275, "merchantOrderId", newJString(merchantOrderId))
  add(path_590275, "merchantId", newJString(merchantId))
  add(query_590276, "prettyPrint", newJBool(prettyPrint))
  result = call_590274.call(path_590275, query_590276, nil, nil, nil)

var contentOrdersGetbymerchantorderid* = Call_ContentOrdersGetbymerchantorderid_590261(
    name: "contentOrdersGetbymerchantorderid", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/ordersbymerchantid/{merchantOrderId}",
    validator: validate_ContentOrdersGetbymerchantorderid_590262,
    base: "/content/v2", url: url_ContentOrdersGetbymerchantorderid_590263,
    schemes: {Scheme.Https})
type
  Call_ContentPosInventory_590277 = ref object of OpenApiRestCall_588450
proc url_ContentPosInventory_590279(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosInventory_590278(path: JsonNode; query: JsonNode;
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
  var valid_590280 = path.getOrDefault("targetMerchantId")
  valid_590280 = validateParameter(valid_590280, JString, required = true,
                                 default = nil)
  if valid_590280 != nil:
    section.add "targetMerchantId", valid_590280
  var valid_590281 = path.getOrDefault("merchantId")
  valid_590281 = validateParameter(valid_590281, JString, required = true,
                                 default = nil)
  if valid_590281 != nil:
    section.add "merchantId", valid_590281
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
  var valid_590282 = query.getOrDefault("fields")
  valid_590282 = validateParameter(valid_590282, JString, required = false,
                                 default = nil)
  if valid_590282 != nil:
    section.add "fields", valid_590282
  var valid_590283 = query.getOrDefault("quotaUser")
  valid_590283 = validateParameter(valid_590283, JString, required = false,
                                 default = nil)
  if valid_590283 != nil:
    section.add "quotaUser", valid_590283
  var valid_590284 = query.getOrDefault("alt")
  valid_590284 = validateParameter(valid_590284, JString, required = false,
                                 default = newJString("json"))
  if valid_590284 != nil:
    section.add "alt", valid_590284
  var valid_590285 = query.getOrDefault("dryRun")
  valid_590285 = validateParameter(valid_590285, JBool, required = false, default = nil)
  if valid_590285 != nil:
    section.add "dryRun", valid_590285
  var valid_590286 = query.getOrDefault("oauth_token")
  valid_590286 = validateParameter(valid_590286, JString, required = false,
                                 default = nil)
  if valid_590286 != nil:
    section.add "oauth_token", valid_590286
  var valid_590287 = query.getOrDefault("userIp")
  valid_590287 = validateParameter(valid_590287, JString, required = false,
                                 default = nil)
  if valid_590287 != nil:
    section.add "userIp", valid_590287
  var valid_590288 = query.getOrDefault("key")
  valid_590288 = validateParameter(valid_590288, JString, required = false,
                                 default = nil)
  if valid_590288 != nil:
    section.add "key", valid_590288
  var valid_590289 = query.getOrDefault("prettyPrint")
  valid_590289 = validateParameter(valid_590289, JBool, required = false,
                                 default = newJBool(true))
  if valid_590289 != nil:
    section.add "prettyPrint", valid_590289
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

proc call*(call_590291: Call_ContentPosInventory_590277; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit inventory for the given merchant.
  ## 
  let valid = call_590291.validator(path, query, header, formData, body)
  let scheme = call_590291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590291.url(scheme.get, call_590291.host, call_590291.base,
                         call_590291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590291, url, valid)

proc call*(call_590292: Call_ContentPosInventory_590277; targetMerchantId: string;
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
  var path_590293 = newJObject()
  var query_590294 = newJObject()
  var body_590295 = newJObject()
  add(query_590294, "fields", newJString(fields))
  add(query_590294, "quotaUser", newJString(quotaUser))
  add(query_590294, "alt", newJString(alt))
  add(query_590294, "dryRun", newJBool(dryRun))
  add(path_590293, "targetMerchantId", newJString(targetMerchantId))
  add(query_590294, "oauth_token", newJString(oauthToken))
  add(query_590294, "userIp", newJString(userIp))
  add(query_590294, "key", newJString(key))
  add(path_590293, "merchantId", newJString(merchantId))
  if body != nil:
    body_590295 = body
  add(query_590294, "prettyPrint", newJBool(prettyPrint))
  result = call_590292.call(path_590293, query_590294, nil, nil, body_590295)

var contentPosInventory* = Call_ContentPosInventory_590277(
    name: "contentPosInventory", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/inventory",
    validator: validate_ContentPosInventory_590278, base: "/content/v2",
    url: url_ContentPosInventory_590279, schemes: {Scheme.Https})
type
  Call_ContentPosSale_590296 = ref object of OpenApiRestCall_588450
proc url_ContentPosSale_590298(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosSale_590297(path: JsonNode; query: JsonNode;
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
  var valid_590299 = path.getOrDefault("targetMerchantId")
  valid_590299 = validateParameter(valid_590299, JString, required = true,
                                 default = nil)
  if valid_590299 != nil:
    section.add "targetMerchantId", valid_590299
  var valid_590300 = path.getOrDefault("merchantId")
  valid_590300 = validateParameter(valid_590300, JString, required = true,
                                 default = nil)
  if valid_590300 != nil:
    section.add "merchantId", valid_590300
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
  var valid_590301 = query.getOrDefault("fields")
  valid_590301 = validateParameter(valid_590301, JString, required = false,
                                 default = nil)
  if valid_590301 != nil:
    section.add "fields", valid_590301
  var valid_590302 = query.getOrDefault("quotaUser")
  valid_590302 = validateParameter(valid_590302, JString, required = false,
                                 default = nil)
  if valid_590302 != nil:
    section.add "quotaUser", valid_590302
  var valid_590303 = query.getOrDefault("alt")
  valid_590303 = validateParameter(valid_590303, JString, required = false,
                                 default = newJString("json"))
  if valid_590303 != nil:
    section.add "alt", valid_590303
  var valid_590304 = query.getOrDefault("dryRun")
  valid_590304 = validateParameter(valid_590304, JBool, required = false, default = nil)
  if valid_590304 != nil:
    section.add "dryRun", valid_590304
  var valid_590305 = query.getOrDefault("oauth_token")
  valid_590305 = validateParameter(valid_590305, JString, required = false,
                                 default = nil)
  if valid_590305 != nil:
    section.add "oauth_token", valid_590305
  var valid_590306 = query.getOrDefault("userIp")
  valid_590306 = validateParameter(valid_590306, JString, required = false,
                                 default = nil)
  if valid_590306 != nil:
    section.add "userIp", valid_590306
  var valid_590307 = query.getOrDefault("key")
  valid_590307 = validateParameter(valid_590307, JString, required = false,
                                 default = nil)
  if valid_590307 != nil:
    section.add "key", valid_590307
  var valid_590308 = query.getOrDefault("prettyPrint")
  valid_590308 = validateParameter(valid_590308, JBool, required = false,
                                 default = newJBool(true))
  if valid_590308 != nil:
    section.add "prettyPrint", valid_590308
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

proc call*(call_590310: Call_ContentPosSale_590296; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit a sale event for the given merchant.
  ## 
  let valid = call_590310.validator(path, query, header, formData, body)
  let scheme = call_590310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590310.url(scheme.get, call_590310.host, call_590310.base,
                         call_590310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590310, url, valid)

proc call*(call_590311: Call_ContentPosSale_590296; targetMerchantId: string;
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
  var path_590312 = newJObject()
  var query_590313 = newJObject()
  var body_590314 = newJObject()
  add(query_590313, "fields", newJString(fields))
  add(query_590313, "quotaUser", newJString(quotaUser))
  add(query_590313, "alt", newJString(alt))
  add(query_590313, "dryRun", newJBool(dryRun))
  add(path_590312, "targetMerchantId", newJString(targetMerchantId))
  add(query_590313, "oauth_token", newJString(oauthToken))
  add(query_590313, "userIp", newJString(userIp))
  add(query_590313, "key", newJString(key))
  add(path_590312, "merchantId", newJString(merchantId))
  if body != nil:
    body_590314 = body
  add(query_590313, "prettyPrint", newJBool(prettyPrint))
  result = call_590311.call(path_590312, query_590313, nil, nil, body_590314)

var contentPosSale* = Call_ContentPosSale_590296(name: "contentPosSale",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/sale",
    validator: validate_ContentPosSale_590297, base: "/content/v2",
    url: url_ContentPosSale_590298, schemes: {Scheme.Https})
type
  Call_ContentPosInsert_590331 = ref object of OpenApiRestCall_588450
proc url_ContentPosInsert_590333(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosInsert_590332(path: JsonNode; query: JsonNode;
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
  var valid_590334 = path.getOrDefault("targetMerchantId")
  valid_590334 = validateParameter(valid_590334, JString, required = true,
                                 default = nil)
  if valid_590334 != nil:
    section.add "targetMerchantId", valid_590334
  var valid_590335 = path.getOrDefault("merchantId")
  valid_590335 = validateParameter(valid_590335, JString, required = true,
                                 default = nil)
  if valid_590335 != nil:
    section.add "merchantId", valid_590335
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
  var valid_590336 = query.getOrDefault("fields")
  valid_590336 = validateParameter(valid_590336, JString, required = false,
                                 default = nil)
  if valid_590336 != nil:
    section.add "fields", valid_590336
  var valid_590337 = query.getOrDefault("quotaUser")
  valid_590337 = validateParameter(valid_590337, JString, required = false,
                                 default = nil)
  if valid_590337 != nil:
    section.add "quotaUser", valid_590337
  var valid_590338 = query.getOrDefault("alt")
  valid_590338 = validateParameter(valid_590338, JString, required = false,
                                 default = newJString("json"))
  if valid_590338 != nil:
    section.add "alt", valid_590338
  var valid_590339 = query.getOrDefault("dryRun")
  valid_590339 = validateParameter(valid_590339, JBool, required = false, default = nil)
  if valid_590339 != nil:
    section.add "dryRun", valid_590339
  var valid_590340 = query.getOrDefault("oauth_token")
  valid_590340 = validateParameter(valid_590340, JString, required = false,
                                 default = nil)
  if valid_590340 != nil:
    section.add "oauth_token", valid_590340
  var valid_590341 = query.getOrDefault("userIp")
  valid_590341 = validateParameter(valid_590341, JString, required = false,
                                 default = nil)
  if valid_590341 != nil:
    section.add "userIp", valid_590341
  var valid_590342 = query.getOrDefault("key")
  valid_590342 = validateParameter(valid_590342, JString, required = false,
                                 default = nil)
  if valid_590342 != nil:
    section.add "key", valid_590342
  var valid_590343 = query.getOrDefault("prettyPrint")
  valid_590343 = validateParameter(valid_590343, JBool, required = false,
                                 default = newJBool(true))
  if valid_590343 != nil:
    section.add "prettyPrint", valid_590343
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

proc call*(call_590345: Call_ContentPosInsert_590331; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a store for the given merchant.
  ## 
  let valid = call_590345.validator(path, query, header, formData, body)
  let scheme = call_590345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590345.url(scheme.get, call_590345.host, call_590345.base,
                         call_590345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590345, url, valid)

proc call*(call_590346: Call_ContentPosInsert_590331; targetMerchantId: string;
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
  var path_590347 = newJObject()
  var query_590348 = newJObject()
  var body_590349 = newJObject()
  add(query_590348, "fields", newJString(fields))
  add(query_590348, "quotaUser", newJString(quotaUser))
  add(query_590348, "alt", newJString(alt))
  add(query_590348, "dryRun", newJBool(dryRun))
  add(path_590347, "targetMerchantId", newJString(targetMerchantId))
  add(query_590348, "oauth_token", newJString(oauthToken))
  add(query_590348, "userIp", newJString(userIp))
  add(query_590348, "key", newJString(key))
  add(path_590347, "merchantId", newJString(merchantId))
  if body != nil:
    body_590349 = body
  add(query_590348, "prettyPrint", newJBool(prettyPrint))
  result = call_590346.call(path_590347, query_590348, nil, nil, body_590349)

var contentPosInsert* = Call_ContentPosInsert_590331(name: "contentPosInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store",
    validator: validate_ContentPosInsert_590332, base: "/content/v2",
    url: url_ContentPosInsert_590333, schemes: {Scheme.Https})
type
  Call_ContentPosList_590315 = ref object of OpenApiRestCall_588450
proc url_ContentPosList_590317(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosList_590316(path: JsonNode; query: JsonNode;
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
  var valid_590318 = path.getOrDefault("targetMerchantId")
  valid_590318 = validateParameter(valid_590318, JString, required = true,
                                 default = nil)
  if valid_590318 != nil:
    section.add "targetMerchantId", valid_590318
  var valid_590319 = path.getOrDefault("merchantId")
  valid_590319 = validateParameter(valid_590319, JString, required = true,
                                 default = nil)
  if valid_590319 != nil:
    section.add "merchantId", valid_590319
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590320 = query.getOrDefault("fields")
  valid_590320 = validateParameter(valid_590320, JString, required = false,
                                 default = nil)
  if valid_590320 != nil:
    section.add "fields", valid_590320
  var valid_590321 = query.getOrDefault("quotaUser")
  valid_590321 = validateParameter(valid_590321, JString, required = false,
                                 default = nil)
  if valid_590321 != nil:
    section.add "quotaUser", valid_590321
  var valid_590322 = query.getOrDefault("alt")
  valid_590322 = validateParameter(valid_590322, JString, required = false,
                                 default = newJString("json"))
  if valid_590322 != nil:
    section.add "alt", valid_590322
  var valid_590323 = query.getOrDefault("oauth_token")
  valid_590323 = validateParameter(valid_590323, JString, required = false,
                                 default = nil)
  if valid_590323 != nil:
    section.add "oauth_token", valid_590323
  var valid_590324 = query.getOrDefault("userIp")
  valid_590324 = validateParameter(valid_590324, JString, required = false,
                                 default = nil)
  if valid_590324 != nil:
    section.add "userIp", valid_590324
  var valid_590325 = query.getOrDefault("key")
  valid_590325 = validateParameter(valid_590325, JString, required = false,
                                 default = nil)
  if valid_590325 != nil:
    section.add "key", valid_590325
  var valid_590326 = query.getOrDefault("prettyPrint")
  valid_590326 = validateParameter(valid_590326, JBool, required = false,
                                 default = newJBool(true))
  if valid_590326 != nil:
    section.add "prettyPrint", valid_590326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590327: Call_ContentPosList_590315; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the stores of the target merchant.
  ## 
  let valid = call_590327.validator(path, query, header, formData, body)
  let scheme = call_590327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590327.url(scheme.get, call_590327.host, call_590327.base,
                         call_590327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590327, url, valid)

proc call*(call_590328: Call_ContentPosList_590315; targetMerchantId: string;
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
  var path_590329 = newJObject()
  var query_590330 = newJObject()
  add(query_590330, "fields", newJString(fields))
  add(query_590330, "quotaUser", newJString(quotaUser))
  add(query_590330, "alt", newJString(alt))
  add(path_590329, "targetMerchantId", newJString(targetMerchantId))
  add(query_590330, "oauth_token", newJString(oauthToken))
  add(query_590330, "userIp", newJString(userIp))
  add(query_590330, "key", newJString(key))
  add(path_590329, "merchantId", newJString(merchantId))
  add(query_590330, "prettyPrint", newJBool(prettyPrint))
  result = call_590328.call(path_590329, query_590330, nil, nil, nil)

var contentPosList* = Call_ContentPosList_590315(name: "contentPosList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store",
    validator: validate_ContentPosList_590316, base: "/content/v2",
    url: url_ContentPosList_590317, schemes: {Scheme.Https})
type
  Call_ContentPosGet_590350 = ref object of OpenApiRestCall_588450
proc url_ContentPosGet_590352(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosGet_590351(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_590353 = path.getOrDefault("targetMerchantId")
  valid_590353 = validateParameter(valid_590353, JString, required = true,
                                 default = nil)
  if valid_590353 != nil:
    section.add "targetMerchantId", valid_590353
  var valid_590354 = path.getOrDefault("storeCode")
  valid_590354 = validateParameter(valid_590354, JString, required = true,
                                 default = nil)
  if valid_590354 != nil:
    section.add "storeCode", valid_590354
  var valid_590355 = path.getOrDefault("merchantId")
  valid_590355 = validateParameter(valid_590355, JString, required = true,
                                 default = nil)
  if valid_590355 != nil:
    section.add "merchantId", valid_590355
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590356 = query.getOrDefault("fields")
  valid_590356 = validateParameter(valid_590356, JString, required = false,
                                 default = nil)
  if valid_590356 != nil:
    section.add "fields", valid_590356
  var valid_590357 = query.getOrDefault("quotaUser")
  valid_590357 = validateParameter(valid_590357, JString, required = false,
                                 default = nil)
  if valid_590357 != nil:
    section.add "quotaUser", valid_590357
  var valid_590358 = query.getOrDefault("alt")
  valid_590358 = validateParameter(valid_590358, JString, required = false,
                                 default = newJString("json"))
  if valid_590358 != nil:
    section.add "alt", valid_590358
  var valid_590359 = query.getOrDefault("oauth_token")
  valid_590359 = validateParameter(valid_590359, JString, required = false,
                                 default = nil)
  if valid_590359 != nil:
    section.add "oauth_token", valid_590359
  var valid_590360 = query.getOrDefault("userIp")
  valid_590360 = validateParameter(valid_590360, JString, required = false,
                                 default = nil)
  if valid_590360 != nil:
    section.add "userIp", valid_590360
  var valid_590361 = query.getOrDefault("key")
  valid_590361 = validateParameter(valid_590361, JString, required = false,
                                 default = nil)
  if valid_590361 != nil:
    section.add "key", valid_590361
  var valid_590362 = query.getOrDefault("prettyPrint")
  valid_590362 = validateParameter(valid_590362, JBool, required = false,
                                 default = newJBool(true))
  if valid_590362 != nil:
    section.add "prettyPrint", valid_590362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590363: Call_ContentPosGet_590350; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about the given store.
  ## 
  let valid = call_590363.validator(path, query, header, formData, body)
  let scheme = call_590363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590363.url(scheme.get, call_590363.host, call_590363.base,
                         call_590363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590363, url, valid)

proc call*(call_590364: Call_ContentPosGet_590350; targetMerchantId: string;
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
  var path_590365 = newJObject()
  var query_590366 = newJObject()
  add(query_590366, "fields", newJString(fields))
  add(query_590366, "quotaUser", newJString(quotaUser))
  add(query_590366, "alt", newJString(alt))
  add(path_590365, "targetMerchantId", newJString(targetMerchantId))
  add(query_590366, "oauth_token", newJString(oauthToken))
  add(path_590365, "storeCode", newJString(storeCode))
  add(query_590366, "userIp", newJString(userIp))
  add(query_590366, "key", newJString(key))
  add(path_590365, "merchantId", newJString(merchantId))
  add(query_590366, "prettyPrint", newJBool(prettyPrint))
  result = call_590364.call(path_590365, query_590366, nil, nil, nil)

var contentPosGet* = Call_ContentPosGet_590350(name: "contentPosGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store/{storeCode}",
    validator: validate_ContentPosGet_590351, base: "/content/v2",
    url: url_ContentPosGet_590352, schemes: {Scheme.Https})
type
  Call_ContentPosDelete_590367 = ref object of OpenApiRestCall_588450
proc url_ContentPosDelete_590369(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosDelete_590368(path: JsonNode; query: JsonNode;
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
  var valid_590370 = path.getOrDefault("targetMerchantId")
  valid_590370 = validateParameter(valid_590370, JString, required = true,
                                 default = nil)
  if valid_590370 != nil:
    section.add "targetMerchantId", valid_590370
  var valid_590371 = path.getOrDefault("storeCode")
  valid_590371 = validateParameter(valid_590371, JString, required = true,
                                 default = nil)
  if valid_590371 != nil:
    section.add "storeCode", valid_590371
  var valid_590372 = path.getOrDefault("merchantId")
  valid_590372 = validateParameter(valid_590372, JString, required = true,
                                 default = nil)
  if valid_590372 != nil:
    section.add "merchantId", valid_590372
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
  var valid_590373 = query.getOrDefault("fields")
  valid_590373 = validateParameter(valid_590373, JString, required = false,
                                 default = nil)
  if valid_590373 != nil:
    section.add "fields", valid_590373
  var valid_590374 = query.getOrDefault("quotaUser")
  valid_590374 = validateParameter(valid_590374, JString, required = false,
                                 default = nil)
  if valid_590374 != nil:
    section.add "quotaUser", valid_590374
  var valid_590375 = query.getOrDefault("alt")
  valid_590375 = validateParameter(valid_590375, JString, required = false,
                                 default = newJString("json"))
  if valid_590375 != nil:
    section.add "alt", valid_590375
  var valid_590376 = query.getOrDefault("dryRun")
  valid_590376 = validateParameter(valid_590376, JBool, required = false, default = nil)
  if valid_590376 != nil:
    section.add "dryRun", valid_590376
  var valid_590377 = query.getOrDefault("oauth_token")
  valid_590377 = validateParameter(valid_590377, JString, required = false,
                                 default = nil)
  if valid_590377 != nil:
    section.add "oauth_token", valid_590377
  var valid_590378 = query.getOrDefault("userIp")
  valid_590378 = validateParameter(valid_590378, JString, required = false,
                                 default = nil)
  if valid_590378 != nil:
    section.add "userIp", valid_590378
  var valid_590379 = query.getOrDefault("key")
  valid_590379 = validateParameter(valid_590379, JString, required = false,
                                 default = nil)
  if valid_590379 != nil:
    section.add "key", valid_590379
  var valid_590380 = query.getOrDefault("prettyPrint")
  valid_590380 = validateParameter(valid_590380, JBool, required = false,
                                 default = newJBool(true))
  if valid_590380 != nil:
    section.add "prettyPrint", valid_590380
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590381: Call_ContentPosDelete_590367; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a store for the given merchant.
  ## 
  let valid = call_590381.validator(path, query, header, formData, body)
  let scheme = call_590381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590381.url(scheme.get, call_590381.host, call_590381.base,
                         call_590381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590381, url, valid)

proc call*(call_590382: Call_ContentPosDelete_590367; targetMerchantId: string;
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
  var path_590383 = newJObject()
  var query_590384 = newJObject()
  add(query_590384, "fields", newJString(fields))
  add(query_590384, "quotaUser", newJString(quotaUser))
  add(query_590384, "alt", newJString(alt))
  add(query_590384, "dryRun", newJBool(dryRun))
  add(path_590383, "targetMerchantId", newJString(targetMerchantId))
  add(query_590384, "oauth_token", newJString(oauthToken))
  add(path_590383, "storeCode", newJString(storeCode))
  add(query_590384, "userIp", newJString(userIp))
  add(query_590384, "key", newJString(key))
  add(path_590383, "merchantId", newJString(merchantId))
  add(query_590384, "prettyPrint", newJBool(prettyPrint))
  result = call_590382.call(path_590383, query_590384, nil, nil, nil)

var contentPosDelete* = Call_ContentPosDelete_590367(name: "contentPosDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store/{storeCode}",
    validator: validate_ContentPosDelete_590368, base: "/content/v2",
    url: url_ContentPosDelete_590369, schemes: {Scheme.Https})
type
  Call_ContentProductsInsert_590403 = ref object of OpenApiRestCall_588450
proc url_ContentProductsInsert_590405(protocol: Scheme; host: string; base: string;
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

proc validate_ContentProductsInsert_590404(path: JsonNode; query: JsonNode;
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
  var valid_590406 = path.getOrDefault("merchantId")
  valid_590406 = validateParameter(valid_590406, JString, required = true,
                                 default = nil)
  if valid_590406 != nil:
    section.add "merchantId", valid_590406
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
  var valid_590407 = query.getOrDefault("fields")
  valid_590407 = validateParameter(valid_590407, JString, required = false,
                                 default = nil)
  if valid_590407 != nil:
    section.add "fields", valid_590407
  var valid_590408 = query.getOrDefault("quotaUser")
  valid_590408 = validateParameter(valid_590408, JString, required = false,
                                 default = nil)
  if valid_590408 != nil:
    section.add "quotaUser", valid_590408
  var valid_590409 = query.getOrDefault("alt")
  valid_590409 = validateParameter(valid_590409, JString, required = false,
                                 default = newJString("json"))
  if valid_590409 != nil:
    section.add "alt", valid_590409
  var valid_590410 = query.getOrDefault("dryRun")
  valid_590410 = validateParameter(valid_590410, JBool, required = false, default = nil)
  if valid_590410 != nil:
    section.add "dryRun", valid_590410
  var valid_590411 = query.getOrDefault("oauth_token")
  valid_590411 = validateParameter(valid_590411, JString, required = false,
                                 default = nil)
  if valid_590411 != nil:
    section.add "oauth_token", valid_590411
  var valid_590412 = query.getOrDefault("userIp")
  valid_590412 = validateParameter(valid_590412, JString, required = false,
                                 default = nil)
  if valid_590412 != nil:
    section.add "userIp", valid_590412
  var valid_590413 = query.getOrDefault("key")
  valid_590413 = validateParameter(valid_590413, JString, required = false,
                                 default = nil)
  if valid_590413 != nil:
    section.add "key", valid_590413
  var valid_590414 = query.getOrDefault("prettyPrint")
  valid_590414 = validateParameter(valid_590414, JBool, required = false,
                                 default = newJBool(true))
  if valid_590414 != nil:
    section.add "prettyPrint", valid_590414
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

proc call*(call_590416: Call_ContentProductsInsert_590403; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a product to your Merchant Center account. If an item with the same channel, contentLanguage, offerId, and targetCountry already exists, this method updates that entry.
  ## 
  let valid = call_590416.validator(path, query, header, formData, body)
  let scheme = call_590416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590416.url(scheme.get, call_590416.host, call_590416.base,
                         call_590416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590416, url, valid)

proc call*(call_590417: Call_ContentProductsInsert_590403; merchantId: string;
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
  var path_590418 = newJObject()
  var query_590419 = newJObject()
  var body_590420 = newJObject()
  add(query_590419, "fields", newJString(fields))
  add(query_590419, "quotaUser", newJString(quotaUser))
  add(query_590419, "alt", newJString(alt))
  add(query_590419, "dryRun", newJBool(dryRun))
  add(query_590419, "oauth_token", newJString(oauthToken))
  add(query_590419, "userIp", newJString(userIp))
  add(query_590419, "key", newJString(key))
  add(path_590418, "merchantId", newJString(merchantId))
  if body != nil:
    body_590420 = body
  add(query_590419, "prettyPrint", newJBool(prettyPrint))
  result = call_590417.call(path_590418, query_590419, nil, nil, body_590420)

var contentProductsInsert* = Call_ContentProductsInsert_590403(
    name: "contentProductsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/products",
    validator: validate_ContentProductsInsert_590404, base: "/content/v2",
    url: url_ContentProductsInsert_590405, schemes: {Scheme.Https})
type
  Call_ContentProductsList_590385 = ref object of OpenApiRestCall_588450
proc url_ContentProductsList_590387(protocol: Scheme; host: string; base: string;
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

proc validate_ContentProductsList_590386(path: JsonNode; query: JsonNode;
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
  var valid_590388 = path.getOrDefault("merchantId")
  valid_590388 = validateParameter(valid_590388, JString, required = true,
                                 default = nil)
  if valid_590388 != nil:
    section.add "merchantId", valid_590388
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
  var valid_590389 = query.getOrDefault("fields")
  valid_590389 = validateParameter(valid_590389, JString, required = false,
                                 default = nil)
  if valid_590389 != nil:
    section.add "fields", valid_590389
  var valid_590390 = query.getOrDefault("pageToken")
  valid_590390 = validateParameter(valid_590390, JString, required = false,
                                 default = nil)
  if valid_590390 != nil:
    section.add "pageToken", valid_590390
  var valid_590391 = query.getOrDefault("quotaUser")
  valid_590391 = validateParameter(valid_590391, JString, required = false,
                                 default = nil)
  if valid_590391 != nil:
    section.add "quotaUser", valid_590391
  var valid_590392 = query.getOrDefault("alt")
  valid_590392 = validateParameter(valid_590392, JString, required = false,
                                 default = newJString("json"))
  if valid_590392 != nil:
    section.add "alt", valid_590392
  var valid_590393 = query.getOrDefault("oauth_token")
  valid_590393 = validateParameter(valid_590393, JString, required = false,
                                 default = nil)
  if valid_590393 != nil:
    section.add "oauth_token", valid_590393
  var valid_590394 = query.getOrDefault("userIp")
  valid_590394 = validateParameter(valid_590394, JString, required = false,
                                 default = nil)
  if valid_590394 != nil:
    section.add "userIp", valid_590394
  var valid_590395 = query.getOrDefault("maxResults")
  valid_590395 = validateParameter(valid_590395, JInt, required = false, default = nil)
  if valid_590395 != nil:
    section.add "maxResults", valid_590395
  var valid_590396 = query.getOrDefault("key")
  valid_590396 = validateParameter(valid_590396, JString, required = false,
                                 default = nil)
  if valid_590396 != nil:
    section.add "key", valid_590396
  var valid_590397 = query.getOrDefault("prettyPrint")
  valid_590397 = validateParameter(valid_590397, JBool, required = false,
                                 default = newJBool(true))
  if valid_590397 != nil:
    section.add "prettyPrint", valid_590397
  var valid_590398 = query.getOrDefault("includeInvalidInsertedItems")
  valid_590398 = validateParameter(valid_590398, JBool, required = false, default = nil)
  if valid_590398 != nil:
    section.add "includeInvalidInsertedItems", valid_590398
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590399: Call_ContentProductsList_590385; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the products in your Merchant Center account.
  ## 
  let valid = call_590399.validator(path, query, header, formData, body)
  let scheme = call_590399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590399.url(scheme.get, call_590399.host, call_590399.base,
                         call_590399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590399, url, valid)

proc call*(call_590400: Call_ContentProductsList_590385; merchantId: string;
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
  var path_590401 = newJObject()
  var query_590402 = newJObject()
  add(query_590402, "fields", newJString(fields))
  add(query_590402, "pageToken", newJString(pageToken))
  add(query_590402, "quotaUser", newJString(quotaUser))
  add(query_590402, "alt", newJString(alt))
  add(query_590402, "oauth_token", newJString(oauthToken))
  add(query_590402, "userIp", newJString(userIp))
  add(query_590402, "maxResults", newJInt(maxResults))
  add(query_590402, "key", newJString(key))
  add(path_590401, "merchantId", newJString(merchantId))
  add(query_590402, "prettyPrint", newJBool(prettyPrint))
  add(query_590402, "includeInvalidInsertedItems",
      newJBool(includeInvalidInsertedItems))
  result = call_590400.call(path_590401, query_590402, nil, nil, nil)

var contentProductsList* = Call_ContentProductsList_590385(
    name: "contentProductsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/products",
    validator: validate_ContentProductsList_590386, base: "/content/v2",
    url: url_ContentProductsList_590387, schemes: {Scheme.Https})
type
  Call_ContentProductsGet_590421 = ref object of OpenApiRestCall_588450
proc url_ContentProductsGet_590423(protocol: Scheme; host: string; base: string;
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

proc validate_ContentProductsGet_590422(path: JsonNode; query: JsonNode;
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
  var valid_590424 = path.getOrDefault("merchantId")
  valid_590424 = validateParameter(valid_590424, JString, required = true,
                                 default = nil)
  if valid_590424 != nil:
    section.add "merchantId", valid_590424
  var valid_590425 = path.getOrDefault("productId")
  valid_590425 = validateParameter(valid_590425, JString, required = true,
                                 default = nil)
  if valid_590425 != nil:
    section.add "productId", valid_590425
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590426 = query.getOrDefault("fields")
  valid_590426 = validateParameter(valid_590426, JString, required = false,
                                 default = nil)
  if valid_590426 != nil:
    section.add "fields", valid_590426
  var valid_590427 = query.getOrDefault("quotaUser")
  valid_590427 = validateParameter(valid_590427, JString, required = false,
                                 default = nil)
  if valid_590427 != nil:
    section.add "quotaUser", valid_590427
  var valid_590428 = query.getOrDefault("alt")
  valid_590428 = validateParameter(valid_590428, JString, required = false,
                                 default = newJString("json"))
  if valid_590428 != nil:
    section.add "alt", valid_590428
  var valid_590429 = query.getOrDefault("oauth_token")
  valid_590429 = validateParameter(valid_590429, JString, required = false,
                                 default = nil)
  if valid_590429 != nil:
    section.add "oauth_token", valid_590429
  var valid_590430 = query.getOrDefault("userIp")
  valid_590430 = validateParameter(valid_590430, JString, required = false,
                                 default = nil)
  if valid_590430 != nil:
    section.add "userIp", valid_590430
  var valid_590431 = query.getOrDefault("key")
  valid_590431 = validateParameter(valid_590431, JString, required = false,
                                 default = nil)
  if valid_590431 != nil:
    section.add "key", valid_590431
  var valid_590432 = query.getOrDefault("prettyPrint")
  valid_590432 = validateParameter(valid_590432, JBool, required = false,
                                 default = newJBool(true))
  if valid_590432 != nil:
    section.add "prettyPrint", valid_590432
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590433: Call_ContentProductsGet_590421; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a product from your Merchant Center account.
  ## 
  let valid = call_590433.validator(path, query, header, formData, body)
  let scheme = call_590433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590433.url(scheme.get, call_590433.host, call_590433.base,
                         call_590433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590433, url, valid)

proc call*(call_590434: Call_ContentProductsGet_590421; merchantId: string;
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
  var path_590435 = newJObject()
  var query_590436 = newJObject()
  add(query_590436, "fields", newJString(fields))
  add(query_590436, "quotaUser", newJString(quotaUser))
  add(query_590436, "alt", newJString(alt))
  add(query_590436, "oauth_token", newJString(oauthToken))
  add(query_590436, "userIp", newJString(userIp))
  add(query_590436, "key", newJString(key))
  add(path_590435, "merchantId", newJString(merchantId))
  add(path_590435, "productId", newJString(productId))
  add(query_590436, "prettyPrint", newJBool(prettyPrint))
  result = call_590434.call(path_590435, query_590436, nil, nil, nil)

var contentProductsGet* = Call_ContentProductsGet_590421(
    name: "contentProductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/products/{productId}",
    validator: validate_ContentProductsGet_590422, base: "/content/v2",
    url: url_ContentProductsGet_590423, schemes: {Scheme.Https})
type
  Call_ContentProductsDelete_590437 = ref object of OpenApiRestCall_588450
proc url_ContentProductsDelete_590439(protocol: Scheme; host: string; base: string;
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

proc validate_ContentProductsDelete_590438(path: JsonNode; query: JsonNode;
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
  var valid_590440 = path.getOrDefault("merchantId")
  valid_590440 = validateParameter(valid_590440, JString, required = true,
                                 default = nil)
  if valid_590440 != nil:
    section.add "merchantId", valid_590440
  var valid_590441 = path.getOrDefault("productId")
  valid_590441 = validateParameter(valid_590441, JString, required = true,
                                 default = nil)
  if valid_590441 != nil:
    section.add "productId", valid_590441
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
  var valid_590442 = query.getOrDefault("fields")
  valid_590442 = validateParameter(valid_590442, JString, required = false,
                                 default = nil)
  if valid_590442 != nil:
    section.add "fields", valid_590442
  var valid_590443 = query.getOrDefault("quotaUser")
  valid_590443 = validateParameter(valid_590443, JString, required = false,
                                 default = nil)
  if valid_590443 != nil:
    section.add "quotaUser", valid_590443
  var valid_590444 = query.getOrDefault("alt")
  valid_590444 = validateParameter(valid_590444, JString, required = false,
                                 default = newJString("json"))
  if valid_590444 != nil:
    section.add "alt", valid_590444
  var valid_590445 = query.getOrDefault("dryRun")
  valid_590445 = validateParameter(valid_590445, JBool, required = false, default = nil)
  if valid_590445 != nil:
    section.add "dryRun", valid_590445
  var valid_590446 = query.getOrDefault("oauth_token")
  valid_590446 = validateParameter(valid_590446, JString, required = false,
                                 default = nil)
  if valid_590446 != nil:
    section.add "oauth_token", valid_590446
  var valid_590447 = query.getOrDefault("userIp")
  valid_590447 = validateParameter(valid_590447, JString, required = false,
                                 default = nil)
  if valid_590447 != nil:
    section.add "userIp", valid_590447
  var valid_590448 = query.getOrDefault("key")
  valid_590448 = validateParameter(valid_590448, JString, required = false,
                                 default = nil)
  if valid_590448 != nil:
    section.add "key", valid_590448
  var valid_590449 = query.getOrDefault("prettyPrint")
  valid_590449 = validateParameter(valid_590449, JBool, required = false,
                                 default = newJBool(true))
  if valid_590449 != nil:
    section.add "prettyPrint", valid_590449
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590450: Call_ContentProductsDelete_590437; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a product from your Merchant Center account.
  ## 
  let valid = call_590450.validator(path, query, header, formData, body)
  let scheme = call_590450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590450.url(scheme.get, call_590450.host, call_590450.base,
                         call_590450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590450, url, valid)

proc call*(call_590451: Call_ContentProductsDelete_590437; merchantId: string;
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
  var path_590452 = newJObject()
  var query_590453 = newJObject()
  add(query_590453, "fields", newJString(fields))
  add(query_590453, "quotaUser", newJString(quotaUser))
  add(query_590453, "alt", newJString(alt))
  add(query_590453, "dryRun", newJBool(dryRun))
  add(query_590453, "oauth_token", newJString(oauthToken))
  add(query_590453, "userIp", newJString(userIp))
  add(query_590453, "key", newJString(key))
  add(path_590452, "merchantId", newJString(merchantId))
  add(path_590452, "productId", newJString(productId))
  add(query_590453, "prettyPrint", newJBool(prettyPrint))
  result = call_590451.call(path_590452, query_590453, nil, nil, nil)

var contentProductsDelete* = Call_ContentProductsDelete_590437(
    name: "contentProductsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/products/{productId}",
    validator: validate_ContentProductsDelete_590438, base: "/content/v2",
    url: url_ContentProductsDelete_590439, schemes: {Scheme.Https})
type
  Call_ContentProductstatusesList_590454 = ref object of OpenApiRestCall_588450
proc url_ContentProductstatusesList_590456(protocol: Scheme; host: string;
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

proc validate_ContentProductstatusesList_590455(path: JsonNode; query: JsonNode;
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
  var valid_590457 = path.getOrDefault("merchantId")
  valid_590457 = validateParameter(valid_590457, JString, required = true,
                                 default = nil)
  if valid_590457 != nil:
    section.add "merchantId", valid_590457
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
  var valid_590458 = query.getOrDefault("fields")
  valid_590458 = validateParameter(valid_590458, JString, required = false,
                                 default = nil)
  if valid_590458 != nil:
    section.add "fields", valid_590458
  var valid_590459 = query.getOrDefault("pageToken")
  valid_590459 = validateParameter(valid_590459, JString, required = false,
                                 default = nil)
  if valid_590459 != nil:
    section.add "pageToken", valid_590459
  var valid_590460 = query.getOrDefault("quotaUser")
  valid_590460 = validateParameter(valid_590460, JString, required = false,
                                 default = nil)
  if valid_590460 != nil:
    section.add "quotaUser", valid_590460
  var valid_590461 = query.getOrDefault("alt")
  valid_590461 = validateParameter(valid_590461, JString, required = false,
                                 default = newJString("json"))
  if valid_590461 != nil:
    section.add "alt", valid_590461
  var valid_590462 = query.getOrDefault("oauth_token")
  valid_590462 = validateParameter(valid_590462, JString, required = false,
                                 default = nil)
  if valid_590462 != nil:
    section.add "oauth_token", valid_590462
  var valid_590463 = query.getOrDefault("userIp")
  valid_590463 = validateParameter(valid_590463, JString, required = false,
                                 default = nil)
  if valid_590463 != nil:
    section.add "userIp", valid_590463
  var valid_590464 = query.getOrDefault("maxResults")
  valid_590464 = validateParameter(valid_590464, JInt, required = false, default = nil)
  if valid_590464 != nil:
    section.add "maxResults", valid_590464
  var valid_590465 = query.getOrDefault("includeAttributes")
  valid_590465 = validateParameter(valid_590465, JBool, required = false, default = nil)
  if valid_590465 != nil:
    section.add "includeAttributes", valid_590465
  var valid_590466 = query.getOrDefault("key")
  valid_590466 = validateParameter(valid_590466, JString, required = false,
                                 default = nil)
  if valid_590466 != nil:
    section.add "key", valid_590466
  var valid_590467 = query.getOrDefault("prettyPrint")
  valid_590467 = validateParameter(valid_590467, JBool, required = false,
                                 default = newJBool(true))
  if valid_590467 != nil:
    section.add "prettyPrint", valid_590467
  var valid_590468 = query.getOrDefault("destinations")
  valid_590468 = validateParameter(valid_590468, JArray, required = false,
                                 default = nil)
  if valid_590468 != nil:
    section.add "destinations", valid_590468
  var valid_590469 = query.getOrDefault("includeInvalidInsertedItems")
  valid_590469 = validateParameter(valid_590469, JBool, required = false, default = nil)
  if valid_590469 != nil:
    section.add "includeInvalidInsertedItems", valid_590469
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590470: Call_ContentProductstatusesList_590454; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the products in your Merchant Center account.
  ## 
  let valid = call_590470.validator(path, query, header, formData, body)
  let scheme = call_590470.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590470.url(scheme.get, call_590470.host, call_590470.base,
                         call_590470.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590470, url, valid)

proc call*(call_590471: Call_ContentProductstatusesList_590454; merchantId: string;
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
  var path_590472 = newJObject()
  var query_590473 = newJObject()
  add(query_590473, "fields", newJString(fields))
  add(query_590473, "pageToken", newJString(pageToken))
  add(query_590473, "quotaUser", newJString(quotaUser))
  add(query_590473, "alt", newJString(alt))
  add(query_590473, "oauth_token", newJString(oauthToken))
  add(query_590473, "userIp", newJString(userIp))
  add(query_590473, "maxResults", newJInt(maxResults))
  add(query_590473, "includeAttributes", newJBool(includeAttributes))
  add(query_590473, "key", newJString(key))
  add(path_590472, "merchantId", newJString(merchantId))
  add(query_590473, "prettyPrint", newJBool(prettyPrint))
  if destinations != nil:
    query_590473.add "destinations", destinations
  add(query_590473, "includeInvalidInsertedItems",
      newJBool(includeInvalidInsertedItems))
  result = call_590471.call(path_590472, query_590473, nil, nil, nil)

var contentProductstatusesList* = Call_ContentProductstatusesList_590454(
    name: "contentProductstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/productstatuses",
    validator: validate_ContentProductstatusesList_590455, base: "/content/v2",
    url: url_ContentProductstatusesList_590456, schemes: {Scheme.Https})
type
  Call_ContentProductstatusesGet_590474 = ref object of OpenApiRestCall_588450
proc url_ContentProductstatusesGet_590476(protocol: Scheme; host: string;
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

proc validate_ContentProductstatusesGet_590475(path: JsonNode; query: JsonNode;
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
  var valid_590477 = path.getOrDefault("merchantId")
  valid_590477 = validateParameter(valid_590477, JString, required = true,
                                 default = nil)
  if valid_590477 != nil:
    section.add "merchantId", valid_590477
  var valid_590478 = path.getOrDefault("productId")
  valid_590478 = validateParameter(valid_590478, JString, required = true,
                                 default = nil)
  if valid_590478 != nil:
    section.add "productId", valid_590478
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
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
  var valid_590479 = query.getOrDefault("fields")
  valid_590479 = validateParameter(valid_590479, JString, required = false,
                                 default = nil)
  if valid_590479 != nil:
    section.add "fields", valid_590479
  var valid_590480 = query.getOrDefault("quotaUser")
  valid_590480 = validateParameter(valid_590480, JString, required = false,
                                 default = nil)
  if valid_590480 != nil:
    section.add "quotaUser", valid_590480
  var valid_590481 = query.getOrDefault("alt")
  valid_590481 = validateParameter(valid_590481, JString, required = false,
                                 default = newJString("json"))
  if valid_590481 != nil:
    section.add "alt", valid_590481
  var valid_590482 = query.getOrDefault("oauth_token")
  valid_590482 = validateParameter(valid_590482, JString, required = false,
                                 default = nil)
  if valid_590482 != nil:
    section.add "oauth_token", valid_590482
  var valid_590483 = query.getOrDefault("userIp")
  valid_590483 = validateParameter(valid_590483, JString, required = false,
                                 default = nil)
  if valid_590483 != nil:
    section.add "userIp", valid_590483
  var valid_590484 = query.getOrDefault("includeAttributes")
  valid_590484 = validateParameter(valid_590484, JBool, required = false, default = nil)
  if valid_590484 != nil:
    section.add "includeAttributes", valid_590484
  var valid_590485 = query.getOrDefault("key")
  valid_590485 = validateParameter(valid_590485, JString, required = false,
                                 default = nil)
  if valid_590485 != nil:
    section.add "key", valid_590485
  var valid_590486 = query.getOrDefault("prettyPrint")
  valid_590486 = validateParameter(valid_590486, JBool, required = false,
                                 default = newJBool(true))
  if valid_590486 != nil:
    section.add "prettyPrint", valid_590486
  var valid_590487 = query.getOrDefault("destinations")
  valid_590487 = validateParameter(valid_590487, JArray, required = false,
                                 default = nil)
  if valid_590487 != nil:
    section.add "destinations", valid_590487
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590488: Call_ContentProductstatusesGet_590474; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the status of a product from your Merchant Center account.
  ## 
  let valid = call_590488.validator(path, query, header, formData, body)
  let scheme = call_590488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590488.url(scheme.get, call_590488.host, call_590488.base,
                         call_590488.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590488, url, valid)

proc call*(call_590489: Call_ContentProductstatusesGet_590474; merchantId: string;
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
  var path_590490 = newJObject()
  var query_590491 = newJObject()
  add(query_590491, "fields", newJString(fields))
  add(query_590491, "quotaUser", newJString(quotaUser))
  add(query_590491, "alt", newJString(alt))
  add(query_590491, "oauth_token", newJString(oauthToken))
  add(query_590491, "userIp", newJString(userIp))
  add(query_590491, "includeAttributes", newJBool(includeAttributes))
  add(query_590491, "key", newJString(key))
  add(path_590490, "merchantId", newJString(merchantId))
  add(path_590490, "productId", newJString(productId))
  add(query_590491, "prettyPrint", newJBool(prettyPrint))
  if destinations != nil:
    query_590491.add "destinations", destinations
  result = call_590489.call(path_590490, query_590491, nil, nil, nil)

var contentProductstatusesGet* = Call_ContentProductstatusesGet_590474(
    name: "contentProductstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/productstatuses/{productId}",
    validator: validate_ContentProductstatusesGet_590475, base: "/content/v2",
    url: url_ContentProductstatusesGet_590476, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsList_590492 = ref object of OpenApiRestCall_588450
proc url_ContentShippingsettingsList_590494(protocol: Scheme; host: string;
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

proc validate_ContentShippingsettingsList_590493(path: JsonNode; query: JsonNode;
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
  var valid_590495 = path.getOrDefault("merchantId")
  valid_590495 = validateParameter(valid_590495, JString, required = true,
                                 default = nil)
  if valid_590495 != nil:
    section.add "merchantId", valid_590495
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
  var valid_590496 = query.getOrDefault("fields")
  valid_590496 = validateParameter(valid_590496, JString, required = false,
                                 default = nil)
  if valid_590496 != nil:
    section.add "fields", valid_590496
  var valid_590497 = query.getOrDefault("pageToken")
  valid_590497 = validateParameter(valid_590497, JString, required = false,
                                 default = nil)
  if valid_590497 != nil:
    section.add "pageToken", valid_590497
  var valid_590498 = query.getOrDefault("quotaUser")
  valid_590498 = validateParameter(valid_590498, JString, required = false,
                                 default = nil)
  if valid_590498 != nil:
    section.add "quotaUser", valid_590498
  var valid_590499 = query.getOrDefault("alt")
  valid_590499 = validateParameter(valid_590499, JString, required = false,
                                 default = newJString("json"))
  if valid_590499 != nil:
    section.add "alt", valid_590499
  var valid_590500 = query.getOrDefault("oauth_token")
  valid_590500 = validateParameter(valid_590500, JString, required = false,
                                 default = nil)
  if valid_590500 != nil:
    section.add "oauth_token", valid_590500
  var valid_590501 = query.getOrDefault("userIp")
  valid_590501 = validateParameter(valid_590501, JString, required = false,
                                 default = nil)
  if valid_590501 != nil:
    section.add "userIp", valid_590501
  var valid_590502 = query.getOrDefault("maxResults")
  valid_590502 = validateParameter(valid_590502, JInt, required = false, default = nil)
  if valid_590502 != nil:
    section.add "maxResults", valid_590502
  var valid_590503 = query.getOrDefault("key")
  valid_590503 = validateParameter(valid_590503, JString, required = false,
                                 default = nil)
  if valid_590503 != nil:
    section.add "key", valid_590503
  var valid_590504 = query.getOrDefault("prettyPrint")
  valid_590504 = validateParameter(valid_590504, JBool, required = false,
                                 default = newJBool(true))
  if valid_590504 != nil:
    section.add "prettyPrint", valid_590504
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590505: Call_ContentShippingsettingsList_590492; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the shipping settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_590505.validator(path, query, header, formData, body)
  let scheme = call_590505.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590505.url(scheme.get, call_590505.host, call_590505.base,
                         call_590505.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590505, url, valid)

proc call*(call_590506: Call_ContentShippingsettingsList_590492;
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
  var path_590507 = newJObject()
  var query_590508 = newJObject()
  add(query_590508, "fields", newJString(fields))
  add(query_590508, "pageToken", newJString(pageToken))
  add(query_590508, "quotaUser", newJString(quotaUser))
  add(query_590508, "alt", newJString(alt))
  add(query_590508, "oauth_token", newJString(oauthToken))
  add(query_590508, "userIp", newJString(userIp))
  add(query_590508, "maxResults", newJInt(maxResults))
  add(query_590508, "key", newJString(key))
  add(path_590507, "merchantId", newJString(merchantId))
  add(query_590508, "prettyPrint", newJBool(prettyPrint))
  result = call_590506.call(path_590507, query_590508, nil, nil, nil)

var contentShippingsettingsList* = Call_ContentShippingsettingsList_590492(
    name: "contentShippingsettingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/shippingsettings",
    validator: validate_ContentShippingsettingsList_590493, base: "/content/v2",
    url: url_ContentShippingsettingsList_590494, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsUpdate_590525 = ref object of OpenApiRestCall_588450
proc url_ContentShippingsettingsUpdate_590527(protocol: Scheme; host: string;
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

proc validate_ContentShippingsettingsUpdate_590526(path: JsonNode; query: JsonNode;
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
  var valid_590528 = path.getOrDefault("accountId")
  valid_590528 = validateParameter(valid_590528, JString, required = true,
                                 default = nil)
  if valid_590528 != nil:
    section.add "accountId", valid_590528
  var valid_590529 = path.getOrDefault("merchantId")
  valid_590529 = validateParameter(valid_590529, JString, required = true,
                                 default = nil)
  if valid_590529 != nil:
    section.add "merchantId", valid_590529
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
  var valid_590530 = query.getOrDefault("fields")
  valid_590530 = validateParameter(valid_590530, JString, required = false,
                                 default = nil)
  if valid_590530 != nil:
    section.add "fields", valid_590530
  var valid_590531 = query.getOrDefault("quotaUser")
  valid_590531 = validateParameter(valid_590531, JString, required = false,
                                 default = nil)
  if valid_590531 != nil:
    section.add "quotaUser", valid_590531
  var valid_590532 = query.getOrDefault("alt")
  valid_590532 = validateParameter(valid_590532, JString, required = false,
                                 default = newJString("json"))
  if valid_590532 != nil:
    section.add "alt", valid_590532
  var valid_590533 = query.getOrDefault("dryRun")
  valid_590533 = validateParameter(valid_590533, JBool, required = false, default = nil)
  if valid_590533 != nil:
    section.add "dryRun", valid_590533
  var valid_590534 = query.getOrDefault("oauth_token")
  valid_590534 = validateParameter(valid_590534, JString, required = false,
                                 default = nil)
  if valid_590534 != nil:
    section.add "oauth_token", valid_590534
  var valid_590535 = query.getOrDefault("userIp")
  valid_590535 = validateParameter(valid_590535, JString, required = false,
                                 default = nil)
  if valid_590535 != nil:
    section.add "userIp", valid_590535
  var valid_590536 = query.getOrDefault("key")
  valid_590536 = validateParameter(valid_590536, JString, required = false,
                                 default = nil)
  if valid_590536 != nil:
    section.add "key", valid_590536
  var valid_590537 = query.getOrDefault("prettyPrint")
  valid_590537 = validateParameter(valid_590537, JBool, required = false,
                                 default = newJBool(true))
  if valid_590537 != nil:
    section.add "prettyPrint", valid_590537
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

proc call*(call_590539: Call_ContentShippingsettingsUpdate_590525; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the shipping settings of the account.
  ## 
  let valid = call_590539.validator(path, query, header, formData, body)
  let scheme = call_590539.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590539.url(scheme.get, call_590539.host, call_590539.base,
                         call_590539.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590539, url, valid)

proc call*(call_590540: Call_ContentShippingsettingsUpdate_590525;
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
  var path_590541 = newJObject()
  var query_590542 = newJObject()
  var body_590543 = newJObject()
  add(query_590542, "fields", newJString(fields))
  add(query_590542, "quotaUser", newJString(quotaUser))
  add(query_590542, "alt", newJString(alt))
  add(query_590542, "dryRun", newJBool(dryRun))
  add(query_590542, "oauth_token", newJString(oauthToken))
  add(path_590541, "accountId", newJString(accountId))
  add(query_590542, "userIp", newJString(userIp))
  add(query_590542, "key", newJString(key))
  add(path_590541, "merchantId", newJString(merchantId))
  if body != nil:
    body_590543 = body
  add(query_590542, "prettyPrint", newJBool(prettyPrint))
  result = call_590540.call(path_590541, query_590542, nil, nil, body_590543)

var contentShippingsettingsUpdate* = Call_ContentShippingsettingsUpdate_590525(
    name: "contentShippingsettingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{merchantId}/shippingsettings/{accountId}",
    validator: validate_ContentShippingsettingsUpdate_590526, base: "/content/v2",
    url: url_ContentShippingsettingsUpdate_590527, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGet_590509 = ref object of OpenApiRestCall_588450
proc url_ContentShippingsettingsGet_590511(protocol: Scheme; host: string;
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

proc validate_ContentShippingsettingsGet_590510(path: JsonNode; query: JsonNode;
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
  var valid_590512 = path.getOrDefault("accountId")
  valid_590512 = validateParameter(valid_590512, JString, required = true,
                                 default = nil)
  if valid_590512 != nil:
    section.add "accountId", valid_590512
  var valid_590513 = path.getOrDefault("merchantId")
  valid_590513 = validateParameter(valid_590513, JString, required = true,
                                 default = nil)
  if valid_590513 != nil:
    section.add "merchantId", valid_590513
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590514 = query.getOrDefault("fields")
  valid_590514 = validateParameter(valid_590514, JString, required = false,
                                 default = nil)
  if valid_590514 != nil:
    section.add "fields", valid_590514
  var valid_590515 = query.getOrDefault("quotaUser")
  valid_590515 = validateParameter(valid_590515, JString, required = false,
                                 default = nil)
  if valid_590515 != nil:
    section.add "quotaUser", valid_590515
  var valid_590516 = query.getOrDefault("alt")
  valid_590516 = validateParameter(valid_590516, JString, required = false,
                                 default = newJString("json"))
  if valid_590516 != nil:
    section.add "alt", valid_590516
  var valid_590517 = query.getOrDefault("oauth_token")
  valid_590517 = validateParameter(valid_590517, JString, required = false,
                                 default = nil)
  if valid_590517 != nil:
    section.add "oauth_token", valid_590517
  var valid_590518 = query.getOrDefault("userIp")
  valid_590518 = validateParameter(valid_590518, JString, required = false,
                                 default = nil)
  if valid_590518 != nil:
    section.add "userIp", valid_590518
  var valid_590519 = query.getOrDefault("key")
  valid_590519 = validateParameter(valid_590519, JString, required = false,
                                 default = nil)
  if valid_590519 != nil:
    section.add "key", valid_590519
  var valid_590520 = query.getOrDefault("prettyPrint")
  valid_590520 = validateParameter(valid_590520, JBool, required = false,
                                 default = newJBool(true))
  if valid_590520 != nil:
    section.add "prettyPrint", valid_590520
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590521: Call_ContentShippingsettingsGet_590509; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the shipping settings of the account.
  ## 
  let valid = call_590521.validator(path, query, header, formData, body)
  let scheme = call_590521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590521.url(scheme.get, call_590521.host, call_590521.base,
                         call_590521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590521, url, valid)

proc call*(call_590522: Call_ContentShippingsettingsGet_590509; accountId: string;
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
  var path_590523 = newJObject()
  var query_590524 = newJObject()
  add(query_590524, "fields", newJString(fields))
  add(query_590524, "quotaUser", newJString(quotaUser))
  add(query_590524, "alt", newJString(alt))
  add(query_590524, "oauth_token", newJString(oauthToken))
  add(path_590523, "accountId", newJString(accountId))
  add(query_590524, "userIp", newJString(userIp))
  add(query_590524, "key", newJString(key))
  add(path_590523, "merchantId", newJString(merchantId))
  add(query_590524, "prettyPrint", newJBool(prettyPrint))
  result = call_590522.call(path_590523, query_590524, nil, nil, nil)

var contentShippingsettingsGet* = Call_ContentShippingsettingsGet_590509(
    name: "contentShippingsettingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/shippingsettings/{accountId}",
    validator: validate_ContentShippingsettingsGet_590510, base: "/content/v2",
    url: url_ContentShippingsettingsGet_590511, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsPatch_590544 = ref object of OpenApiRestCall_588450
proc url_ContentShippingsettingsPatch_590546(protocol: Scheme; host: string;
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

proc validate_ContentShippingsettingsPatch_590545(path: JsonNode; query: JsonNode;
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
  var valid_590547 = path.getOrDefault("accountId")
  valid_590547 = validateParameter(valid_590547, JString, required = true,
                                 default = nil)
  if valid_590547 != nil:
    section.add "accountId", valid_590547
  var valid_590548 = path.getOrDefault("merchantId")
  valid_590548 = validateParameter(valid_590548, JString, required = true,
                                 default = nil)
  if valid_590548 != nil:
    section.add "merchantId", valid_590548
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
  var valid_590549 = query.getOrDefault("fields")
  valid_590549 = validateParameter(valid_590549, JString, required = false,
                                 default = nil)
  if valid_590549 != nil:
    section.add "fields", valid_590549
  var valid_590550 = query.getOrDefault("quotaUser")
  valid_590550 = validateParameter(valid_590550, JString, required = false,
                                 default = nil)
  if valid_590550 != nil:
    section.add "quotaUser", valid_590550
  var valid_590551 = query.getOrDefault("alt")
  valid_590551 = validateParameter(valid_590551, JString, required = false,
                                 default = newJString("json"))
  if valid_590551 != nil:
    section.add "alt", valid_590551
  var valid_590552 = query.getOrDefault("dryRun")
  valid_590552 = validateParameter(valid_590552, JBool, required = false, default = nil)
  if valid_590552 != nil:
    section.add "dryRun", valid_590552
  var valid_590553 = query.getOrDefault("oauth_token")
  valid_590553 = validateParameter(valid_590553, JString, required = false,
                                 default = nil)
  if valid_590553 != nil:
    section.add "oauth_token", valid_590553
  var valid_590554 = query.getOrDefault("userIp")
  valid_590554 = validateParameter(valid_590554, JString, required = false,
                                 default = nil)
  if valid_590554 != nil:
    section.add "userIp", valid_590554
  var valid_590555 = query.getOrDefault("key")
  valid_590555 = validateParameter(valid_590555, JString, required = false,
                                 default = nil)
  if valid_590555 != nil:
    section.add "key", valid_590555
  var valid_590556 = query.getOrDefault("prettyPrint")
  valid_590556 = validateParameter(valid_590556, JBool, required = false,
                                 default = newJBool(true))
  if valid_590556 != nil:
    section.add "prettyPrint", valid_590556
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

proc call*(call_590558: Call_ContentShippingsettingsPatch_590544; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the shipping settings of the account. This method supports patch semantics.
  ## 
  let valid = call_590558.validator(path, query, header, formData, body)
  let scheme = call_590558.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590558.url(scheme.get, call_590558.host, call_590558.base,
                         call_590558.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590558, url, valid)

proc call*(call_590559: Call_ContentShippingsettingsPatch_590544;
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
  var path_590560 = newJObject()
  var query_590561 = newJObject()
  var body_590562 = newJObject()
  add(query_590561, "fields", newJString(fields))
  add(query_590561, "quotaUser", newJString(quotaUser))
  add(query_590561, "alt", newJString(alt))
  add(query_590561, "dryRun", newJBool(dryRun))
  add(query_590561, "oauth_token", newJString(oauthToken))
  add(path_590560, "accountId", newJString(accountId))
  add(query_590561, "userIp", newJString(userIp))
  add(query_590561, "key", newJString(key))
  add(path_590560, "merchantId", newJString(merchantId))
  if body != nil:
    body_590562 = body
  add(query_590561, "prettyPrint", newJBool(prettyPrint))
  result = call_590559.call(path_590560, query_590561, nil, nil, body_590562)

var contentShippingsettingsPatch* = Call_ContentShippingsettingsPatch_590544(
    name: "contentShippingsettingsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{merchantId}/shippingsettings/{accountId}",
    validator: validate_ContentShippingsettingsPatch_590545, base: "/content/v2",
    url: url_ContentShippingsettingsPatch_590546, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGetsupportedcarriers_590563 = ref object of OpenApiRestCall_588450
proc url_ContentShippingsettingsGetsupportedcarriers_590565(protocol: Scheme;
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

proc validate_ContentShippingsettingsGetsupportedcarriers_590564(path: JsonNode;
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
  var valid_590566 = path.getOrDefault("merchantId")
  valid_590566 = validateParameter(valid_590566, JString, required = true,
                                 default = nil)
  if valid_590566 != nil:
    section.add "merchantId", valid_590566
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590567 = query.getOrDefault("fields")
  valid_590567 = validateParameter(valid_590567, JString, required = false,
                                 default = nil)
  if valid_590567 != nil:
    section.add "fields", valid_590567
  var valid_590568 = query.getOrDefault("quotaUser")
  valid_590568 = validateParameter(valid_590568, JString, required = false,
                                 default = nil)
  if valid_590568 != nil:
    section.add "quotaUser", valid_590568
  var valid_590569 = query.getOrDefault("alt")
  valid_590569 = validateParameter(valid_590569, JString, required = false,
                                 default = newJString("json"))
  if valid_590569 != nil:
    section.add "alt", valid_590569
  var valid_590570 = query.getOrDefault("oauth_token")
  valid_590570 = validateParameter(valid_590570, JString, required = false,
                                 default = nil)
  if valid_590570 != nil:
    section.add "oauth_token", valid_590570
  var valid_590571 = query.getOrDefault("userIp")
  valid_590571 = validateParameter(valid_590571, JString, required = false,
                                 default = nil)
  if valid_590571 != nil:
    section.add "userIp", valid_590571
  var valid_590572 = query.getOrDefault("key")
  valid_590572 = validateParameter(valid_590572, JString, required = false,
                                 default = nil)
  if valid_590572 != nil:
    section.add "key", valid_590572
  var valid_590573 = query.getOrDefault("prettyPrint")
  valid_590573 = validateParameter(valid_590573, JBool, required = false,
                                 default = newJBool(true))
  if valid_590573 != nil:
    section.add "prettyPrint", valid_590573
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590574: Call_ContentShippingsettingsGetsupportedcarriers_590563;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves supported carriers and carrier services for an account.
  ## 
  let valid = call_590574.validator(path, query, header, formData, body)
  let scheme = call_590574.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590574.url(scheme.get, call_590574.host, call_590574.base,
                         call_590574.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590574, url, valid)

proc call*(call_590575: Call_ContentShippingsettingsGetsupportedcarriers_590563;
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
  var path_590576 = newJObject()
  var query_590577 = newJObject()
  add(query_590577, "fields", newJString(fields))
  add(query_590577, "quotaUser", newJString(quotaUser))
  add(query_590577, "alt", newJString(alt))
  add(query_590577, "oauth_token", newJString(oauthToken))
  add(query_590577, "userIp", newJString(userIp))
  add(query_590577, "key", newJString(key))
  add(path_590576, "merchantId", newJString(merchantId))
  add(query_590577, "prettyPrint", newJBool(prettyPrint))
  result = call_590575.call(path_590576, query_590577, nil, nil, nil)

var contentShippingsettingsGetsupportedcarriers* = Call_ContentShippingsettingsGetsupportedcarriers_590563(
    name: "contentShippingsettingsGetsupportedcarriers", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/supportedCarriers",
    validator: validate_ContentShippingsettingsGetsupportedcarriers_590564,
    base: "/content/v2", url: url_ContentShippingsettingsGetsupportedcarriers_590565,
    schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGetsupportedholidays_590578 = ref object of OpenApiRestCall_588450
proc url_ContentShippingsettingsGetsupportedholidays_590580(protocol: Scheme;
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

proc validate_ContentShippingsettingsGetsupportedholidays_590579(path: JsonNode;
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
  var valid_590581 = path.getOrDefault("merchantId")
  valid_590581 = validateParameter(valid_590581, JString, required = true,
                                 default = nil)
  if valid_590581 != nil:
    section.add "merchantId", valid_590581
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590582 = query.getOrDefault("fields")
  valid_590582 = validateParameter(valid_590582, JString, required = false,
                                 default = nil)
  if valid_590582 != nil:
    section.add "fields", valid_590582
  var valid_590583 = query.getOrDefault("quotaUser")
  valid_590583 = validateParameter(valid_590583, JString, required = false,
                                 default = nil)
  if valid_590583 != nil:
    section.add "quotaUser", valid_590583
  var valid_590584 = query.getOrDefault("alt")
  valid_590584 = validateParameter(valid_590584, JString, required = false,
                                 default = newJString("json"))
  if valid_590584 != nil:
    section.add "alt", valid_590584
  var valid_590585 = query.getOrDefault("oauth_token")
  valid_590585 = validateParameter(valid_590585, JString, required = false,
                                 default = nil)
  if valid_590585 != nil:
    section.add "oauth_token", valid_590585
  var valid_590586 = query.getOrDefault("userIp")
  valid_590586 = validateParameter(valid_590586, JString, required = false,
                                 default = nil)
  if valid_590586 != nil:
    section.add "userIp", valid_590586
  var valid_590587 = query.getOrDefault("key")
  valid_590587 = validateParameter(valid_590587, JString, required = false,
                                 default = nil)
  if valid_590587 != nil:
    section.add "key", valid_590587
  var valid_590588 = query.getOrDefault("prettyPrint")
  valid_590588 = validateParameter(valid_590588, JBool, required = false,
                                 default = newJBool(true))
  if valid_590588 != nil:
    section.add "prettyPrint", valid_590588
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590589: Call_ContentShippingsettingsGetsupportedholidays_590578;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves supported holidays for an account.
  ## 
  let valid = call_590589.validator(path, query, header, formData, body)
  let scheme = call_590589.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590589.url(scheme.get, call_590589.host, call_590589.base,
                         call_590589.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590589, url, valid)

proc call*(call_590590: Call_ContentShippingsettingsGetsupportedholidays_590578;
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
  var path_590591 = newJObject()
  var query_590592 = newJObject()
  add(query_590592, "fields", newJString(fields))
  add(query_590592, "quotaUser", newJString(quotaUser))
  add(query_590592, "alt", newJString(alt))
  add(query_590592, "oauth_token", newJString(oauthToken))
  add(query_590592, "userIp", newJString(userIp))
  add(query_590592, "key", newJString(key))
  add(path_590591, "merchantId", newJString(merchantId))
  add(query_590592, "prettyPrint", newJBool(prettyPrint))
  result = call_590590.call(path_590591, query_590592, nil, nil, nil)

var contentShippingsettingsGetsupportedholidays* = Call_ContentShippingsettingsGetsupportedholidays_590578(
    name: "contentShippingsettingsGetsupportedholidays", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/supportedHolidays",
    validator: validate_ContentShippingsettingsGetsupportedholidays_590579,
    base: "/content/v2", url: url_ContentShippingsettingsGetsupportedholidays_590580,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersCreatetestorder_590593 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersCreatetestorder_590595(protocol: Scheme; host: string;
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

proc validate_ContentOrdersCreatetestorder_590594(path: JsonNode; query: JsonNode;
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
  var valid_590596 = path.getOrDefault("merchantId")
  valid_590596 = validateParameter(valid_590596, JString, required = true,
                                 default = nil)
  if valid_590596 != nil:
    section.add "merchantId", valid_590596
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590597 = query.getOrDefault("fields")
  valid_590597 = validateParameter(valid_590597, JString, required = false,
                                 default = nil)
  if valid_590597 != nil:
    section.add "fields", valid_590597
  var valid_590598 = query.getOrDefault("quotaUser")
  valid_590598 = validateParameter(valid_590598, JString, required = false,
                                 default = nil)
  if valid_590598 != nil:
    section.add "quotaUser", valid_590598
  var valid_590599 = query.getOrDefault("alt")
  valid_590599 = validateParameter(valid_590599, JString, required = false,
                                 default = newJString("json"))
  if valid_590599 != nil:
    section.add "alt", valid_590599
  var valid_590600 = query.getOrDefault("oauth_token")
  valid_590600 = validateParameter(valid_590600, JString, required = false,
                                 default = nil)
  if valid_590600 != nil:
    section.add "oauth_token", valid_590600
  var valid_590601 = query.getOrDefault("userIp")
  valid_590601 = validateParameter(valid_590601, JString, required = false,
                                 default = nil)
  if valid_590601 != nil:
    section.add "userIp", valid_590601
  var valid_590602 = query.getOrDefault("key")
  valid_590602 = validateParameter(valid_590602, JString, required = false,
                                 default = nil)
  if valid_590602 != nil:
    section.add "key", valid_590602
  var valid_590603 = query.getOrDefault("prettyPrint")
  valid_590603 = validateParameter(valid_590603, JBool, required = false,
                                 default = newJBool(true))
  if valid_590603 != nil:
    section.add "prettyPrint", valid_590603
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

proc call*(call_590605: Call_ContentOrdersCreatetestorder_590593; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Creates a test order.
  ## 
  let valid = call_590605.validator(path, query, header, formData, body)
  let scheme = call_590605.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590605.url(scheme.get, call_590605.host, call_590605.base,
                         call_590605.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590605, url, valid)

proc call*(call_590606: Call_ContentOrdersCreatetestorder_590593;
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
  var path_590607 = newJObject()
  var query_590608 = newJObject()
  var body_590609 = newJObject()
  add(query_590608, "fields", newJString(fields))
  add(query_590608, "quotaUser", newJString(quotaUser))
  add(query_590608, "alt", newJString(alt))
  add(query_590608, "oauth_token", newJString(oauthToken))
  add(query_590608, "userIp", newJString(userIp))
  add(query_590608, "key", newJString(key))
  add(path_590607, "merchantId", newJString(merchantId))
  if body != nil:
    body_590609 = body
  add(query_590608, "prettyPrint", newJBool(prettyPrint))
  result = call_590606.call(path_590607, query_590608, nil, nil, body_590609)

var contentOrdersCreatetestorder* = Call_ContentOrdersCreatetestorder_590593(
    name: "contentOrdersCreatetestorder", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/testorders",
    validator: validate_ContentOrdersCreatetestorder_590594, base: "/content/v2",
    url: url_ContentOrdersCreatetestorder_590595, schemes: {Scheme.Https})
type
  Call_ContentOrdersAdvancetestorder_590610 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersAdvancetestorder_590612(protocol: Scheme; host: string;
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

proc validate_ContentOrdersAdvancetestorder_590611(path: JsonNode; query: JsonNode;
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
  var valid_590613 = path.getOrDefault("orderId")
  valid_590613 = validateParameter(valid_590613, JString, required = true,
                                 default = nil)
  if valid_590613 != nil:
    section.add "orderId", valid_590613
  var valid_590614 = path.getOrDefault("merchantId")
  valid_590614 = validateParameter(valid_590614, JString, required = true,
                                 default = nil)
  if valid_590614 != nil:
    section.add "merchantId", valid_590614
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590615 = query.getOrDefault("fields")
  valid_590615 = validateParameter(valid_590615, JString, required = false,
                                 default = nil)
  if valid_590615 != nil:
    section.add "fields", valid_590615
  var valid_590616 = query.getOrDefault("quotaUser")
  valid_590616 = validateParameter(valid_590616, JString, required = false,
                                 default = nil)
  if valid_590616 != nil:
    section.add "quotaUser", valid_590616
  var valid_590617 = query.getOrDefault("alt")
  valid_590617 = validateParameter(valid_590617, JString, required = false,
                                 default = newJString("json"))
  if valid_590617 != nil:
    section.add "alt", valid_590617
  var valid_590618 = query.getOrDefault("oauth_token")
  valid_590618 = validateParameter(valid_590618, JString, required = false,
                                 default = nil)
  if valid_590618 != nil:
    section.add "oauth_token", valid_590618
  var valid_590619 = query.getOrDefault("userIp")
  valid_590619 = validateParameter(valid_590619, JString, required = false,
                                 default = nil)
  if valid_590619 != nil:
    section.add "userIp", valid_590619
  var valid_590620 = query.getOrDefault("key")
  valid_590620 = validateParameter(valid_590620, JString, required = false,
                                 default = nil)
  if valid_590620 != nil:
    section.add "key", valid_590620
  var valid_590621 = query.getOrDefault("prettyPrint")
  valid_590621 = validateParameter(valid_590621, JBool, required = false,
                                 default = newJBool(true))
  if valid_590621 != nil:
    section.add "prettyPrint", valid_590621
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590622: Call_ContentOrdersAdvancetestorder_590610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Moves a test order from state "inProgress" to state "pendingShipment".
  ## 
  let valid = call_590622.validator(path, query, header, formData, body)
  let scheme = call_590622.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590622.url(scheme.get, call_590622.host, call_590622.base,
                         call_590622.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590622, url, valid)

proc call*(call_590623: Call_ContentOrdersAdvancetestorder_590610; orderId: string;
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
  var path_590624 = newJObject()
  var query_590625 = newJObject()
  add(query_590625, "fields", newJString(fields))
  add(query_590625, "quotaUser", newJString(quotaUser))
  add(query_590625, "alt", newJString(alt))
  add(query_590625, "oauth_token", newJString(oauthToken))
  add(query_590625, "userIp", newJString(userIp))
  add(path_590624, "orderId", newJString(orderId))
  add(query_590625, "key", newJString(key))
  add(path_590624, "merchantId", newJString(merchantId))
  add(query_590625, "prettyPrint", newJBool(prettyPrint))
  result = call_590623.call(path_590624, query_590625, nil, nil, nil)

var contentOrdersAdvancetestorder* = Call_ContentOrdersAdvancetestorder_590610(
    name: "contentOrdersAdvancetestorder", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/testorders/{orderId}/advance",
    validator: validate_ContentOrdersAdvancetestorder_590611, base: "/content/v2",
    url: url_ContentOrdersAdvancetestorder_590612, schemes: {Scheme.Https})
type
  Call_ContentOrdersCanceltestorderbycustomer_590626 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersCanceltestorderbycustomer_590628(protocol: Scheme;
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

proc validate_ContentOrdersCanceltestorderbycustomer_590627(path: JsonNode;
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
  var valid_590629 = path.getOrDefault("orderId")
  valid_590629 = validateParameter(valid_590629, JString, required = true,
                                 default = nil)
  if valid_590629 != nil:
    section.add "orderId", valid_590629
  var valid_590630 = path.getOrDefault("merchantId")
  valid_590630 = validateParameter(valid_590630, JString, required = true,
                                 default = nil)
  if valid_590630 != nil:
    section.add "merchantId", valid_590630
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590631 = query.getOrDefault("fields")
  valid_590631 = validateParameter(valid_590631, JString, required = false,
                                 default = nil)
  if valid_590631 != nil:
    section.add "fields", valid_590631
  var valid_590632 = query.getOrDefault("quotaUser")
  valid_590632 = validateParameter(valid_590632, JString, required = false,
                                 default = nil)
  if valid_590632 != nil:
    section.add "quotaUser", valid_590632
  var valid_590633 = query.getOrDefault("alt")
  valid_590633 = validateParameter(valid_590633, JString, required = false,
                                 default = newJString("json"))
  if valid_590633 != nil:
    section.add "alt", valid_590633
  var valid_590634 = query.getOrDefault("oauth_token")
  valid_590634 = validateParameter(valid_590634, JString, required = false,
                                 default = nil)
  if valid_590634 != nil:
    section.add "oauth_token", valid_590634
  var valid_590635 = query.getOrDefault("userIp")
  valid_590635 = validateParameter(valid_590635, JString, required = false,
                                 default = nil)
  if valid_590635 != nil:
    section.add "userIp", valid_590635
  var valid_590636 = query.getOrDefault("key")
  valid_590636 = validateParameter(valid_590636, JString, required = false,
                                 default = nil)
  if valid_590636 != nil:
    section.add "key", valid_590636
  var valid_590637 = query.getOrDefault("prettyPrint")
  valid_590637 = validateParameter(valid_590637, JBool, required = false,
                                 default = newJBool(true))
  if valid_590637 != nil:
    section.add "prettyPrint", valid_590637
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

proc call*(call_590639: Call_ContentOrdersCanceltestorderbycustomer_590626;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sandbox only. Cancels a test order for customer-initiated cancellation.
  ## 
  let valid = call_590639.validator(path, query, header, formData, body)
  let scheme = call_590639.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590639.url(scheme.get, call_590639.host, call_590639.base,
                         call_590639.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590639, url, valid)

proc call*(call_590640: Call_ContentOrdersCanceltestorderbycustomer_590626;
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
  var path_590641 = newJObject()
  var query_590642 = newJObject()
  var body_590643 = newJObject()
  add(query_590642, "fields", newJString(fields))
  add(query_590642, "quotaUser", newJString(quotaUser))
  add(query_590642, "alt", newJString(alt))
  add(query_590642, "oauth_token", newJString(oauthToken))
  add(query_590642, "userIp", newJString(userIp))
  add(path_590641, "orderId", newJString(orderId))
  add(query_590642, "key", newJString(key))
  add(path_590641, "merchantId", newJString(merchantId))
  if body != nil:
    body_590643 = body
  add(query_590642, "prettyPrint", newJBool(prettyPrint))
  result = call_590640.call(path_590641, query_590642, nil, nil, body_590643)

var contentOrdersCanceltestorderbycustomer* = Call_ContentOrdersCanceltestorderbycustomer_590626(
    name: "contentOrdersCanceltestorderbycustomer", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/testorders/{orderId}/cancelByCustomer",
    validator: validate_ContentOrdersCanceltestorderbycustomer_590627,
    base: "/content/v2", url: url_ContentOrdersCanceltestorderbycustomer_590628,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersGettestordertemplate_590644 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersGettestordertemplate_590646(protocol: Scheme; host: string;
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

proc validate_ContentOrdersGettestordertemplate_590645(path: JsonNode;
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
  var valid_590647 = path.getOrDefault("templateName")
  valid_590647 = validateParameter(valid_590647, JString, required = true,
                                 default = newJString("template1"))
  if valid_590647 != nil:
    section.add "templateName", valid_590647
  var valid_590648 = path.getOrDefault("merchantId")
  valid_590648 = validateParameter(valid_590648, JString, required = true,
                                 default = nil)
  if valid_590648 != nil:
    section.add "merchantId", valid_590648
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
  var valid_590649 = query.getOrDefault("fields")
  valid_590649 = validateParameter(valid_590649, JString, required = false,
                                 default = nil)
  if valid_590649 != nil:
    section.add "fields", valid_590649
  var valid_590650 = query.getOrDefault("country")
  valid_590650 = validateParameter(valid_590650, JString, required = false,
                                 default = nil)
  if valid_590650 != nil:
    section.add "country", valid_590650
  var valid_590651 = query.getOrDefault("quotaUser")
  valid_590651 = validateParameter(valid_590651, JString, required = false,
                                 default = nil)
  if valid_590651 != nil:
    section.add "quotaUser", valid_590651
  var valid_590652 = query.getOrDefault("alt")
  valid_590652 = validateParameter(valid_590652, JString, required = false,
                                 default = newJString("json"))
  if valid_590652 != nil:
    section.add "alt", valid_590652
  var valid_590653 = query.getOrDefault("oauth_token")
  valid_590653 = validateParameter(valid_590653, JString, required = false,
                                 default = nil)
  if valid_590653 != nil:
    section.add "oauth_token", valid_590653
  var valid_590654 = query.getOrDefault("userIp")
  valid_590654 = validateParameter(valid_590654, JString, required = false,
                                 default = nil)
  if valid_590654 != nil:
    section.add "userIp", valid_590654
  var valid_590655 = query.getOrDefault("key")
  valid_590655 = validateParameter(valid_590655, JString, required = false,
                                 default = nil)
  if valid_590655 != nil:
    section.add "key", valid_590655
  var valid_590656 = query.getOrDefault("prettyPrint")
  valid_590656 = validateParameter(valid_590656, JBool, required = false,
                                 default = newJBool(true))
  if valid_590656 != nil:
    section.add "prettyPrint", valid_590656
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590657: Call_ContentOrdersGettestordertemplate_590644;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sandbox only. Retrieves an order template that can be used to quickly create a new order in sandbox.
  ## 
  let valid = call_590657.validator(path, query, header, formData, body)
  let scheme = call_590657.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590657.url(scheme.get, call_590657.host, call_590657.base,
                         call_590657.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590657, url, valid)

proc call*(call_590658: Call_ContentOrdersGettestordertemplate_590644;
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
  var path_590659 = newJObject()
  var query_590660 = newJObject()
  add(query_590660, "fields", newJString(fields))
  add(query_590660, "country", newJString(country))
  add(query_590660, "quotaUser", newJString(quotaUser))
  add(query_590660, "alt", newJString(alt))
  add(query_590660, "oauth_token", newJString(oauthToken))
  add(query_590660, "userIp", newJString(userIp))
  add(path_590659, "templateName", newJString(templateName))
  add(query_590660, "key", newJString(key))
  add(path_590659, "merchantId", newJString(merchantId))
  add(query_590660, "prettyPrint", newJBool(prettyPrint))
  result = call_590658.call(path_590659, query_590660, nil, nil, nil)

var contentOrdersGettestordertemplate* = Call_ContentOrdersGettestordertemplate_590644(
    name: "contentOrdersGettestordertemplate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/testordertemplates/{templateName}",
    validator: validate_ContentOrdersGettestordertemplate_590645,
    base: "/content/v2", url: url_ContentOrdersGettestordertemplate_590646,
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
