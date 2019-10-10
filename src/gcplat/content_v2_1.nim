
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
  Call_ContentAccountsAuthinfo_588719 = ref object of OpenApiRestCall_588450
proc url_ContentAccountsAuthinfo_588721(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentAccountsAuthinfo_588720(path: JsonNode; query: JsonNode;
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
  var valid_588833 = query.getOrDefault("fields")
  valid_588833 = validateParameter(valid_588833, JString, required = false,
                                 default = nil)
  if valid_588833 != nil:
    section.add "fields", valid_588833
  var valid_588834 = query.getOrDefault("quotaUser")
  valid_588834 = validateParameter(valid_588834, JString, required = false,
                                 default = nil)
  if valid_588834 != nil:
    section.add "quotaUser", valid_588834
  var valid_588848 = query.getOrDefault("alt")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = newJString("json"))
  if valid_588848 != nil:
    section.add "alt", valid_588848
  var valid_588849 = query.getOrDefault("oauth_token")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = nil)
  if valid_588849 != nil:
    section.add "oauth_token", valid_588849
  var valid_588850 = query.getOrDefault("userIp")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "userIp", valid_588850
  var valid_588851 = query.getOrDefault("key")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = nil)
  if valid_588851 != nil:
    section.add "key", valid_588851
  var valid_588852 = query.getOrDefault("prettyPrint")
  valid_588852 = validateParameter(valid_588852, JBool, required = false,
                                 default = newJBool(true))
  if valid_588852 != nil:
    section.add "prettyPrint", valid_588852
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588875: Call_ContentAccountsAuthinfo_588719; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about the authenticated user.
  ## 
  let valid = call_588875.validator(path, query, header, formData, body)
  let scheme = call_588875.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588875.url(scheme.get, call_588875.host, call_588875.base,
                         call_588875.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588875, url, valid)

proc call*(call_588946: Call_ContentAccountsAuthinfo_588719; fields: string = "";
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
  var query_588947 = newJObject()
  add(query_588947, "fields", newJString(fields))
  add(query_588947, "quotaUser", newJString(quotaUser))
  add(query_588947, "alt", newJString(alt))
  add(query_588947, "oauth_token", newJString(oauthToken))
  add(query_588947, "userIp", newJString(userIp))
  add(query_588947, "key", newJString(key))
  add(query_588947, "prettyPrint", newJBool(prettyPrint))
  result = call_588946.call(nil, query_588947, nil, nil, nil)

var contentAccountsAuthinfo* = Call_ContentAccountsAuthinfo_588719(
    name: "contentAccountsAuthinfo", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/authinfo",
    validator: validate_ContentAccountsAuthinfo_588720, base: "/content/v2.1",
    url: url_ContentAccountsAuthinfo_588721, schemes: {Scheme.Https})
type
  Call_ContentAccountsCustombatch_588987 = ref object of OpenApiRestCall_588450
proc url_ContentAccountsCustombatch_588989(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentAccountsCustombatch_588988(path: JsonNode; query: JsonNode;
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
  var valid_588990 = query.getOrDefault("fields")
  valid_588990 = validateParameter(valid_588990, JString, required = false,
                                 default = nil)
  if valid_588990 != nil:
    section.add "fields", valid_588990
  var valid_588991 = query.getOrDefault("quotaUser")
  valid_588991 = validateParameter(valid_588991, JString, required = false,
                                 default = nil)
  if valid_588991 != nil:
    section.add "quotaUser", valid_588991
  var valid_588992 = query.getOrDefault("alt")
  valid_588992 = validateParameter(valid_588992, JString, required = false,
                                 default = newJString("json"))
  if valid_588992 != nil:
    section.add "alt", valid_588992
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

proc call*(call_588998: Call_ContentAccountsCustombatch_588987; path: JsonNode;
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

proc call*(call_588999: Call_ContentAccountsCustombatch_588987;
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
  var query_589000 = newJObject()
  var body_589001 = newJObject()
  add(query_589000, "fields", newJString(fields))
  add(query_589000, "quotaUser", newJString(quotaUser))
  add(query_589000, "alt", newJString(alt))
  add(query_589000, "oauth_token", newJString(oauthToken))
  add(query_589000, "userIp", newJString(userIp))
  add(query_589000, "key", newJString(key))
  if body != nil:
    body_589001 = body
  add(query_589000, "prettyPrint", newJBool(prettyPrint))
  result = call_588999.call(nil, query_589000, nil, nil, body_589001)

var contentAccountsCustombatch* = Call_ContentAccountsCustombatch_588987(
    name: "contentAccountsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accounts/batch",
    validator: validate_ContentAccountsCustombatch_588988, base: "/content/v2.1",
    url: url_ContentAccountsCustombatch_588989, schemes: {Scheme.Https})
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
    base: "/content/v2.1", url: url_ContentAccountstatusesCustombatch_589004,
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
  var valid_589023 = query.getOrDefault("oauth_token")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "oauth_token", valid_589023
  var valid_589024 = query.getOrDefault("userIp")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "userIp", valid_589024
  var valid_589025 = query.getOrDefault("key")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "key", valid_589025
  var valid_589026 = query.getOrDefault("prettyPrint")
  valid_589026 = validateParameter(valid_589026, JBool, required = false,
                                 default = newJBool(true))
  if valid_589026 != nil:
    section.add "prettyPrint", valid_589026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589028: Call_ContentAccounttaxCustombatch_589017; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves and updates tax settings of multiple accounts in a single request.
  ## 
  let valid = call_589028.validator(path, query, header, formData, body)
  let scheme = call_589028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589028.url(scheme.get, call_589028.host, call_589028.base,
                         call_589028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589028, url, valid)

proc call*(call_589029: Call_ContentAccounttaxCustombatch_589017;
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
  var query_589030 = newJObject()
  var body_589031 = newJObject()
  add(query_589030, "fields", newJString(fields))
  add(query_589030, "quotaUser", newJString(quotaUser))
  add(query_589030, "alt", newJString(alt))
  add(query_589030, "oauth_token", newJString(oauthToken))
  add(query_589030, "userIp", newJString(userIp))
  add(query_589030, "key", newJString(key))
  if body != nil:
    body_589031 = body
  add(query_589030, "prettyPrint", newJBool(prettyPrint))
  result = call_589029.call(nil, query_589030, nil, nil, body_589031)

var contentAccounttaxCustombatch* = Call_ContentAccounttaxCustombatch_589017(
    name: "contentAccounttaxCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accounttax/batch",
    validator: validate_ContentAccounttaxCustombatch_589018,
    base: "/content/v2.1", url: url_ContentAccounttaxCustombatch_589019,
    schemes: {Scheme.Https})
type
  Call_ContentDatafeedsCustombatch_589032 = ref object of OpenApiRestCall_588450
proc url_ContentDatafeedsCustombatch_589034(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentDatafeedsCustombatch_589033(path: JsonNode; query: JsonNode;
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
  var valid_589035 = query.getOrDefault("fields")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "fields", valid_589035
  var valid_589036 = query.getOrDefault("quotaUser")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "quotaUser", valid_589036
  var valid_589037 = query.getOrDefault("alt")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = newJString("json"))
  if valid_589037 != nil:
    section.add "alt", valid_589037
  var valid_589038 = query.getOrDefault("oauth_token")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "oauth_token", valid_589038
  var valid_589039 = query.getOrDefault("userIp")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "userIp", valid_589039
  var valid_589040 = query.getOrDefault("key")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "key", valid_589040
  var valid_589041 = query.getOrDefault("prettyPrint")
  valid_589041 = validateParameter(valid_589041, JBool, required = false,
                                 default = newJBool(true))
  if valid_589041 != nil:
    section.add "prettyPrint", valid_589041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589043: Call_ContentDatafeedsCustombatch_589032; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes, fetches, gets, inserts and updates multiple datafeeds in a single request.
  ## 
  let valid = call_589043.validator(path, query, header, formData, body)
  let scheme = call_589043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589043.url(scheme.get, call_589043.host, call_589043.base,
                         call_589043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589043, url, valid)

proc call*(call_589044: Call_ContentDatafeedsCustombatch_589032;
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
  var query_589045 = newJObject()
  var body_589046 = newJObject()
  add(query_589045, "fields", newJString(fields))
  add(query_589045, "quotaUser", newJString(quotaUser))
  add(query_589045, "alt", newJString(alt))
  add(query_589045, "oauth_token", newJString(oauthToken))
  add(query_589045, "userIp", newJString(userIp))
  add(query_589045, "key", newJString(key))
  if body != nil:
    body_589046 = body
  add(query_589045, "prettyPrint", newJBool(prettyPrint))
  result = call_589044.call(nil, query_589045, nil, nil, body_589046)

var contentDatafeedsCustombatch* = Call_ContentDatafeedsCustombatch_589032(
    name: "contentDatafeedsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/datafeeds/batch",
    validator: validate_ContentDatafeedsCustombatch_589033, base: "/content/v2.1",
    url: url_ContentDatafeedsCustombatch_589034, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesCustombatch_589047 = ref object of OpenApiRestCall_588450
proc url_ContentDatafeedstatusesCustombatch_589049(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentDatafeedstatusesCustombatch_589048(path: JsonNode;
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
  var valid_589050 = query.getOrDefault("fields")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "fields", valid_589050
  var valid_589051 = query.getOrDefault("quotaUser")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "quotaUser", valid_589051
  var valid_589052 = query.getOrDefault("alt")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = newJString("json"))
  if valid_589052 != nil:
    section.add "alt", valid_589052
  var valid_589053 = query.getOrDefault("oauth_token")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "oauth_token", valid_589053
  var valid_589054 = query.getOrDefault("userIp")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "userIp", valid_589054
  var valid_589055 = query.getOrDefault("key")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "key", valid_589055
  var valid_589056 = query.getOrDefault("prettyPrint")
  valid_589056 = validateParameter(valid_589056, JBool, required = false,
                                 default = newJBool(true))
  if valid_589056 != nil:
    section.add "prettyPrint", valid_589056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589058: Call_ContentDatafeedstatusesCustombatch_589047;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets multiple Merchant Center datafeed statuses in a single request.
  ## 
  let valid = call_589058.validator(path, query, header, formData, body)
  let scheme = call_589058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589058.url(scheme.get, call_589058.host, call_589058.base,
                         call_589058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589058, url, valid)

proc call*(call_589059: Call_ContentDatafeedstatusesCustombatch_589047;
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
  var query_589060 = newJObject()
  var body_589061 = newJObject()
  add(query_589060, "fields", newJString(fields))
  add(query_589060, "quotaUser", newJString(quotaUser))
  add(query_589060, "alt", newJString(alt))
  add(query_589060, "oauth_token", newJString(oauthToken))
  add(query_589060, "userIp", newJString(userIp))
  add(query_589060, "key", newJString(key))
  if body != nil:
    body_589061 = body
  add(query_589060, "prettyPrint", newJBool(prettyPrint))
  result = call_589059.call(nil, query_589060, nil, nil, body_589061)

var contentDatafeedstatusesCustombatch* = Call_ContentDatafeedstatusesCustombatch_589047(
    name: "contentDatafeedstatusesCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/datafeedstatuses/batch",
    validator: validate_ContentDatafeedstatusesCustombatch_589048,
    base: "/content/v2.1", url: url_ContentDatafeedstatusesCustombatch_589049,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsCustombatch_589062 = ref object of OpenApiRestCall_588450
proc url_ContentLiasettingsCustombatch_589064(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentLiasettingsCustombatch_589063(path: JsonNode; query: JsonNode;
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
  var valid_589065 = query.getOrDefault("fields")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "fields", valid_589065
  var valid_589066 = query.getOrDefault("quotaUser")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "quotaUser", valid_589066
  var valid_589067 = query.getOrDefault("alt")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = newJString("json"))
  if valid_589067 != nil:
    section.add "alt", valid_589067
  var valid_589068 = query.getOrDefault("oauth_token")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "oauth_token", valid_589068
  var valid_589069 = query.getOrDefault("userIp")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "userIp", valid_589069
  var valid_589070 = query.getOrDefault("key")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "key", valid_589070
  var valid_589071 = query.getOrDefault("prettyPrint")
  valid_589071 = validateParameter(valid_589071, JBool, required = false,
                                 default = newJBool(true))
  if valid_589071 != nil:
    section.add "prettyPrint", valid_589071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589073: Call_ContentLiasettingsCustombatch_589062; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves and/or updates the LIA settings of multiple accounts in a single request.
  ## 
  let valid = call_589073.validator(path, query, header, formData, body)
  let scheme = call_589073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589073.url(scheme.get, call_589073.host, call_589073.base,
                         call_589073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589073, url, valid)

proc call*(call_589074: Call_ContentLiasettingsCustombatch_589062;
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
  var query_589075 = newJObject()
  var body_589076 = newJObject()
  add(query_589075, "fields", newJString(fields))
  add(query_589075, "quotaUser", newJString(quotaUser))
  add(query_589075, "alt", newJString(alt))
  add(query_589075, "oauth_token", newJString(oauthToken))
  add(query_589075, "userIp", newJString(userIp))
  add(query_589075, "key", newJString(key))
  if body != nil:
    body_589076 = body
  add(query_589075, "prettyPrint", newJBool(prettyPrint))
  result = call_589074.call(nil, query_589075, nil, nil, body_589076)

var contentLiasettingsCustombatch* = Call_ContentLiasettingsCustombatch_589062(
    name: "contentLiasettingsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liasettings/batch",
    validator: validate_ContentLiasettingsCustombatch_589063,
    base: "/content/v2.1", url: url_ContentLiasettingsCustombatch_589064,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsListposdataproviders_589077 = ref object of OpenApiRestCall_588450
proc url_ContentLiasettingsListposdataproviders_589079(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentLiasettingsListposdataproviders_589078(path: JsonNode;
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
  var valid_589080 = query.getOrDefault("fields")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "fields", valid_589080
  var valid_589081 = query.getOrDefault("quotaUser")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "quotaUser", valid_589081
  var valid_589082 = query.getOrDefault("alt")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = newJString("json"))
  if valid_589082 != nil:
    section.add "alt", valid_589082
  var valid_589083 = query.getOrDefault("oauth_token")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "oauth_token", valid_589083
  var valid_589084 = query.getOrDefault("userIp")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "userIp", valid_589084
  var valid_589085 = query.getOrDefault("key")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "key", valid_589085
  var valid_589086 = query.getOrDefault("prettyPrint")
  valid_589086 = validateParameter(valid_589086, JBool, required = false,
                                 default = newJBool(true))
  if valid_589086 != nil:
    section.add "prettyPrint", valid_589086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589087: Call_ContentLiasettingsListposdataproviders_589077;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of POS data providers that have active settings for the all eiligible countries.
  ## 
  let valid = call_589087.validator(path, query, header, formData, body)
  let scheme = call_589087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589087.url(scheme.get, call_589087.host, call_589087.base,
                         call_589087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589087, url, valid)

proc call*(call_589088: Call_ContentLiasettingsListposdataproviders_589077;
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
  var query_589089 = newJObject()
  add(query_589089, "fields", newJString(fields))
  add(query_589089, "quotaUser", newJString(quotaUser))
  add(query_589089, "alt", newJString(alt))
  add(query_589089, "oauth_token", newJString(oauthToken))
  add(query_589089, "userIp", newJString(userIp))
  add(query_589089, "key", newJString(key))
  add(query_589089, "prettyPrint", newJBool(prettyPrint))
  result = call_589088.call(nil, query_589089, nil, nil, nil)

var contentLiasettingsListposdataproviders* = Call_ContentLiasettingsListposdataproviders_589077(
    name: "contentLiasettingsListposdataproviders", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/liasettings/posdataproviders",
    validator: validate_ContentLiasettingsListposdataproviders_589078,
    base: "/content/v2.1", url: url_ContentLiasettingsListposdataproviders_589079,
    schemes: {Scheme.Https})
type
  Call_ContentPosCustombatch_589090 = ref object of OpenApiRestCall_588450
proc url_ContentPosCustombatch_589092(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentPosCustombatch_589091(path: JsonNode; query: JsonNode;
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
  var valid_589093 = query.getOrDefault("fields")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "fields", valid_589093
  var valid_589094 = query.getOrDefault("quotaUser")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "quotaUser", valid_589094
  var valid_589095 = query.getOrDefault("alt")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = newJString("json"))
  if valid_589095 != nil:
    section.add "alt", valid_589095
  var valid_589096 = query.getOrDefault("oauth_token")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "oauth_token", valid_589096
  var valid_589097 = query.getOrDefault("userIp")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "userIp", valid_589097
  var valid_589098 = query.getOrDefault("key")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "key", valid_589098
  var valid_589099 = query.getOrDefault("prettyPrint")
  valid_589099 = validateParameter(valid_589099, JBool, required = false,
                                 default = newJBool(true))
  if valid_589099 != nil:
    section.add "prettyPrint", valid_589099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589101: Call_ContentPosCustombatch_589090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Batches multiple POS-related calls in a single request.
  ## 
  let valid = call_589101.validator(path, query, header, formData, body)
  let scheme = call_589101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589101.url(scheme.get, call_589101.host, call_589101.base,
                         call_589101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589101, url, valid)

proc call*(call_589102: Call_ContentPosCustombatch_589090; fields: string = "";
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
  var query_589103 = newJObject()
  var body_589104 = newJObject()
  add(query_589103, "fields", newJString(fields))
  add(query_589103, "quotaUser", newJString(quotaUser))
  add(query_589103, "alt", newJString(alt))
  add(query_589103, "oauth_token", newJString(oauthToken))
  add(query_589103, "userIp", newJString(userIp))
  add(query_589103, "key", newJString(key))
  if body != nil:
    body_589104 = body
  add(query_589103, "prettyPrint", newJBool(prettyPrint))
  result = call_589102.call(nil, query_589103, nil, nil, body_589104)

var contentPosCustombatch* = Call_ContentPosCustombatch_589090(
    name: "contentPosCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/pos/batch",
    validator: validate_ContentPosCustombatch_589091, base: "/content/v2.1",
    url: url_ContentPosCustombatch_589092, schemes: {Scheme.Https})
type
  Call_ContentProductsCustombatch_589105 = ref object of OpenApiRestCall_588450
proc url_ContentProductsCustombatch_589107(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentProductsCustombatch_589106(path: JsonNode; query: JsonNode;
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
  var valid_589108 = query.getOrDefault("fields")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "fields", valid_589108
  var valid_589109 = query.getOrDefault("quotaUser")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "quotaUser", valid_589109
  var valid_589110 = query.getOrDefault("alt")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = newJString("json"))
  if valid_589110 != nil:
    section.add "alt", valid_589110
  var valid_589111 = query.getOrDefault("oauth_token")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "oauth_token", valid_589111
  var valid_589112 = query.getOrDefault("userIp")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "userIp", valid_589112
  var valid_589113 = query.getOrDefault("key")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "key", valid_589113
  var valid_589114 = query.getOrDefault("prettyPrint")
  valid_589114 = validateParameter(valid_589114, JBool, required = false,
                                 default = newJBool(true))
  if valid_589114 != nil:
    section.add "prettyPrint", valid_589114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589116: Call_ContentProductsCustombatch_589105; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves, inserts, and deletes multiple products in a single request.
  ## 
  let valid = call_589116.validator(path, query, header, formData, body)
  let scheme = call_589116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589116.url(scheme.get, call_589116.host, call_589116.base,
                         call_589116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589116, url, valid)

proc call*(call_589117: Call_ContentProductsCustombatch_589105;
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
  var query_589118 = newJObject()
  var body_589119 = newJObject()
  add(query_589118, "fields", newJString(fields))
  add(query_589118, "quotaUser", newJString(quotaUser))
  add(query_589118, "alt", newJString(alt))
  add(query_589118, "oauth_token", newJString(oauthToken))
  add(query_589118, "userIp", newJString(userIp))
  add(query_589118, "key", newJString(key))
  if body != nil:
    body_589119 = body
  add(query_589118, "prettyPrint", newJBool(prettyPrint))
  result = call_589117.call(nil, query_589118, nil, nil, body_589119)

var contentProductsCustombatch* = Call_ContentProductsCustombatch_589105(
    name: "contentProductsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/products/batch",
    validator: validate_ContentProductsCustombatch_589106, base: "/content/v2.1",
    url: url_ContentProductsCustombatch_589107, schemes: {Scheme.Https})
type
  Call_ContentProductstatusesCustombatch_589120 = ref object of OpenApiRestCall_588450
proc url_ContentProductstatusesCustombatch_589122(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentProductstatusesCustombatch_589121(path: JsonNode;
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
  var valid_589123 = query.getOrDefault("fields")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "fields", valid_589123
  var valid_589124 = query.getOrDefault("quotaUser")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "quotaUser", valid_589124
  var valid_589125 = query.getOrDefault("alt")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = newJString("json"))
  if valid_589125 != nil:
    section.add "alt", valid_589125
  var valid_589126 = query.getOrDefault("oauth_token")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "oauth_token", valid_589126
  var valid_589127 = query.getOrDefault("userIp")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "userIp", valid_589127
  var valid_589128 = query.getOrDefault("key")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "key", valid_589128
  var valid_589129 = query.getOrDefault("prettyPrint")
  valid_589129 = validateParameter(valid_589129, JBool, required = false,
                                 default = newJBool(true))
  if valid_589129 != nil:
    section.add "prettyPrint", valid_589129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589131: Call_ContentProductstatusesCustombatch_589120;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the statuses of multiple products in a single request.
  ## 
  let valid = call_589131.validator(path, query, header, formData, body)
  let scheme = call_589131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589131.url(scheme.get, call_589131.host, call_589131.base,
                         call_589131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589131, url, valid)

proc call*(call_589132: Call_ContentProductstatusesCustombatch_589120;
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
  var query_589133 = newJObject()
  var body_589134 = newJObject()
  add(query_589133, "fields", newJString(fields))
  add(query_589133, "quotaUser", newJString(quotaUser))
  add(query_589133, "alt", newJString(alt))
  add(query_589133, "oauth_token", newJString(oauthToken))
  add(query_589133, "userIp", newJString(userIp))
  add(query_589133, "key", newJString(key))
  if body != nil:
    body_589134 = body
  add(query_589133, "prettyPrint", newJBool(prettyPrint))
  result = call_589132.call(nil, query_589133, nil, nil, body_589134)

var contentProductstatusesCustombatch* = Call_ContentProductstatusesCustombatch_589120(
    name: "contentProductstatusesCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/productstatuses/batch",
    validator: validate_ContentProductstatusesCustombatch_589121,
    base: "/content/v2.1", url: url_ContentProductstatusesCustombatch_589122,
    schemes: {Scheme.Https})
type
  Call_ContentRegionalinventoryCustombatch_589135 = ref object of OpenApiRestCall_588450
proc url_ContentRegionalinventoryCustombatch_589137(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentRegionalinventoryCustombatch_589136(path: JsonNode;
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
  var valid_589138 = query.getOrDefault("fields")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "fields", valid_589138
  var valid_589139 = query.getOrDefault("quotaUser")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "quotaUser", valid_589139
  var valid_589140 = query.getOrDefault("alt")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = newJString("json"))
  if valid_589140 != nil:
    section.add "alt", valid_589140
  var valid_589141 = query.getOrDefault("oauth_token")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "oauth_token", valid_589141
  var valid_589142 = query.getOrDefault("userIp")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "userIp", valid_589142
  var valid_589143 = query.getOrDefault("key")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "key", valid_589143
  var valid_589144 = query.getOrDefault("prettyPrint")
  valid_589144 = validateParameter(valid_589144, JBool, required = false,
                                 default = newJBool(true))
  if valid_589144 != nil:
    section.add "prettyPrint", valid_589144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589146: Call_ContentRegionalinventoryCustombatch_589135;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates regional inventory for multiple products or regions in a single request.
  ## 
  let valid = call_589146.validator(path, query, header, formData, body)
  let scheme = call_589146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589146.url(scheme.get, call_589146.host, call_589146.base,
                         call_589146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589146, url, valid)

proc call*(call_589147: Call_ContentRegionalinventoryCustombatch_589135;
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
  var query_589148 = newJObject()
  var body_589149 = newJObject()
  add(query_589148, "fields", newJString(fields))
  add(query_589148, "quotaUser", newJString(quotaUser))
  add(query_589148, "alt", newJString(alt))
  add(query_589148, "oauth_token", newJString(oauthToken))
  add(query_589148, "userIp", newJString(userIp))
  add(query_589148, "key", newJString(key))
  if body != nil:
    body_589149 = body
  add(query_589148, "prettyPrint", newJBool(prettyPrint))
  result = call_589147.call(nil, query_589148, nil, nil, body_589149)

var contentRegionalinventoryCustombatch* = Call_ContentRegionalinventoryCustombatch_589135(
    name: "contentRegionalinventoryCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/regionalinventory/batch",
    validator: validate_ContentRegionalinventoryCustombatch_589136,
    base: "/content/v2.1", url: url_ContentRegionalinventoryCustombatch_589137,
    schemes: {Scheme.Https})
type
  Call_ContentReturnaddressCustombatch_589150 = ref object of OpenApiRestCall_588450
proc url_ContentReturnaddressCustombatch_589152(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentReturnaddressCustombatch_589151(path: JsonNode;
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
  var valid_589153 = query.getOrDefault("fields")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "fields", valid_589153
  var valid_589154 = query.getOrDefault("quotaUser")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "quotaUser", valid_589154
  var valid_589155 = query.getOrDefault("alt")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = newJString("json"))
  if valid_589155 != nil:
    section.add "alt", valid_589155
  var valid_589156 = query.getOrDefault("oauth_token")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "oauth_token", valid_589156
  var valid_589157 = query.getOrDefault("userIp")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "userIp", valid_589157
  var valid_589158 = query.getOrDefault("key")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "key", valid_589158
  var valid_589159 = query.getOrDefault("prettyPrint")
  valid_589159 = validateParameter(valid_589159, JBool, required = false,
                                 default = newJBool(true))
  if valid_589159 != nil:
    section.add "prettyPrint", valid_589159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589161: Call_ContentReturnaddressCustombatch_589150;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Batches multiple return address related calls in a single request.
  ## 
  let valid = call_589161.validator(path, query, header, formData, body)
  let scheme = call_589161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589161.url(scheme.get, call_589161.host, call_589161.base,
                         call_589161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589161, url, valid)

proc call*(call_589162: Call_ContentReturnaddressCustombatch_589150;
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
  var query_589163 = newJObject()
  var body_589164 = newJObject()
  add(query_589163, "fields", newJString(fields))
  add(query_589163, "quotaUser", newJString(quotaUser))
  add(query_589163, "alt", newJString(alt))
  add(query_589163, "oauth_token", newJString(oauthToken))
  add(query_589163, "userIp", newJString(userIp))
  add(query_589163, "key", newJString(key))
  if body != nil:
    body_589164 = body
  add(query_589163, "prettyPrint", newJBool(prettyPrint))
  result = call_589162.call(nil, query_589163, nil, nil, body_589164)

var contentReturnaddressCustombatch* = Call_ContentReturnaddressCustombatch_589150(
    name: "contentReturnaddressCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/returnaddress/batch",
    validator: validate_ContentReturnaddressCustombatch_589151,
    base: "/content/v2.1", url: url_ContentReturnaddressCustombatch_589152,
    schemes: {Scheme.Https})
type
  Call_ContentReturnpolicyCustombatch_589165 = ref object of OpenApiRestCall_588450
proc url_ContentReturnpolicyCustombatch_589167(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentReturnpolicyCustombatch_589166(path: JsonNode;
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
  var valid_589168 = query.getOrDefault("fields")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "fields", valid_589168
  var valid_589169 = query.getOrDefault("quotaUser")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "quotaUser", valid_589169
  var valid_589170 = query.getOrDefault("alt")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = newJString("json"))
  if valid_589170 != nil:
    section.add "alt", valid_589170
  var valid_589171 = query.getOrDefault("oauth_token")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "oauth_token", valid_589171
  var valid_589172 = query.getOrDefault("userIp")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "userIp", valid_589172
  var valid_589173 = query.getOrDefault("key")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "key", valid_589173
  var valid_589174 = query.getOrDefault("prettyPrint")
  valid_589174 = validateParameter(valid_589174, JBool, required = false,
                                 default = newJBool(true))
  if valid_589174 != nil:
    section.add "prettyPrint", valid_589174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589176: Call_ContentReturnpolicyCustombatch_589165; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Batches multiple return policy related calls in a single request.
  ## 
  let valid = call_589176.validator(path, query, header, formData, body)
  let scheme = call_589176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589176.url(scheme.get, call_589176.host, call_589176.base,
                         call_589176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589176, url, valid)

proc call*(call_589177: Call_ContentReturnpolicyCustombatch_589165;
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
  var query_589178 = newJObject()
  var body_589179 = newJObject()
  add(query_589178, "fields", newJString(fields))
  add(query_589178, "quotaUser", newJString(quotaUser))
  add(query_589178, "alt", newJString(alt))
  add(query_589178, "oauth_token", newJString(oauthToken))
  add(query_589178, "userIp", newJString(userIp))
  add(query_589178, "key", newJString(key))
  if body != nil:
    body_589179 = body
  add(query_589178, "prettyPrint", newJBool(prettyPrint))
  result = call_589177.call(nil, query_589178, nil, nil, body_589179)

var contentReturnpolicyCustombatch* = Call_ContentReturnpolicyCustombatch_589165(
    name: "contentReturnpolicyCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/returnpolicy/batch",
    validator: validate_ContentReturnpolicyCustombatch_589166,
    base: "/content/v2.1", url: url_ContentReturnpolicyCustombatch_589167,
    schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsCustombatch_589180 = ref object of OpenApiRestCall_588450
proc url_ContentShippingsettingsCustombatch_589182(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentShippingsettingsCustombatch_589181(path: JsonNode;
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
  var valid_589183 = query.getOrDefault("fields")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "fields", valid_589183
  var valid_589184 = query.getOrDefault("quotaUser")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "quotaUser", valid_589184
  var valid_589185 = query.getOrDefault("alt")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = newJString("json"))
  if valid_589185 != nil:
    section.add "alt", valid_589185
  var valid_589186 = query.getOrDefault("oauth_token")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "oauth_token", valid_589186
  var valid_589187 = query.getOrDefault("userIp")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "userIp", valid_589187
  var valid_589188 = query.getOrDefault("key")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "key", valid_589188
  var valid_589189 = query.getOrDefault("prettyPrint")
  valid_589189 = validateParameter(valid_589189, JBool, required = false,
                                 default = newJBool(true))
  if valid_589189 != nil:
    section.add "prettyPrint", valid_589189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589191: Call_ContentShippingsettingsCustombatch_589180;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves and updates the shipping settings of multiple accounts in a single request.
  ## 
  let valid = call_589191.validator(path, query, header, formData, body)
  let scheme = call_589191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589191.url(scheme.get, call_589191.host, call_589191.base,
                         call_589191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589191, url, valid)

proc call*(call_589192: Call_ContentShippingsettingsCustombatch_589180;
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
  var query_589193 = newJObject()
  var body_589194 = newJObject()
  add(query_589193, "fields", newJString(fields))
  add(query_589193, "quotaUser", newJString(quotaUser))
  add(query_589193, "alt", newJString(alt))
  add(query_589193, "oauth_token", newJString(oauthToken))
  add(query_589193, "userIp", newJString(userIp))
  add(query_589193, "key", newJString(key))
  if body != nil:
    body_589194 = body
  add(query_589193, "prettyPrint", newJBool(prettyPrint))
  result = call_589192.call(nil, query_589193, nil, nil, body_589194)

var contentShippingsettingsCustombatch* = Call_ContentShippingsettingsCustombatch_589180(
    name: "contentShippingsettingsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/shippingsettings/batch",
    validator: validate_ContentShippingsettingsCustombatch_589181,
    base: "/content/v2.1", url: url_ContentShippingsettingsCustombatch_589182,
    schemes: {Scheme.Https})
type
  Call_ContentAccountsInsert_589226 = ref object of OpenApiRestCall_588450
proc url_ContentAccountsInsert_589228(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsInsert_589227(path: JsonNode; query: JsonNode;
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
  var valid_589229 = path.getOrDefault("merchantId")
  valid_589229 = validateParameter(valid_589229, JString, required = true,
                                 default = nil)
  if valid_589229 != nil:
    section.add "merchantId", valid_589229
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589230 = query.getOrDefault("fields")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "fields", valid_589230
  var valid_589231 = query.getOrDefault("quotaUser")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "quotaUser", valid_589231
  var valid_589232 = query.getOrDefault("alt")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = newJString("json"))
  if valid_589232 != nil:
    section.add "alt", valid_589232
  var valid_589233 = query.getOrDefault("oauth_token")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = nil)
  if valid_589233 != nil:
    section.add "oauth_token", valid_589233
  var valid_589234 = query.getOrDefault("userIp")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "userIp", valid_589234
  var valid_589235 = query.getOrDefault("key")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "key", valid_589235
  var valid_589236 = query.getOrDefault("prettyPrint")
  valid_589236 = validateParameter(valid_589236, JBool, required = false,
                                 default = newJBool(true))
  if valid_589236 != nil:
    section.add "prettyPrint", valid_589236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589238: Call_ContentAccountsInsert_589226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Merchant Center sub-account.
  ## 
  let valid = call_589238.validator(path, query, header, formData, body)
  let scheme = call_589238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589238.url(scheme.get, call_589238.host, call_589238.base,
                         call_589238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589238, url, valid)

proc call*(call_589239: Call_ContentAccountsInsert_589226; merchantId: string;
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
  var path_589240 = newJObject()
  var query_589241 = newJObject()
  var body_589242 = newJObject()
  add(query_589241, "fields", newJString(fields))
  add(query_589241, "quotaUser", newJString(quotaUser))
  add(query_589241, "alt", newJString(alt))
  add(query_589241, "oauth_token", newJString(oauthToken))
  add(query_589241, "userIp", newJString(userIp))
  add(query_589241, "key", newJString(key))
  add(path_589240, "merchantId", newJString(merchantId))
  if body != nil:
    body_589242 = body
  add(query_589241, "prettyPrint", newJBool(prettyPrint))
  result = call_589239.call(path_589240, query_589241, nil, nil, body_589242)

var contentAccountsInsert* = Call_ContentAccountsInsert_589226(
    name: "contentAccountsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/accounts",
    validator: validate_ContentAccountsInsert_589227, base: "/content/v2.1",
    url: url_ContentAccountsInsert_589228, schemes: {Scheme.Https})
type
  Call_ContentAccountsList_589195 = ref object of OpenApiRestCall_588450
proc url_ContentAccountsList_589197(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsList_589196(path: JsonNode; query: JsonNode;
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
  var valid_589212 = path.getOrDefault("merchantId")
  valid_589212 = validateParameter(valid_589212, JString, required = true,
                                 default = nil)
  if valid_589212 != nil:
    section.add "merchantId", valid_589212
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
  var valid_589213 = query.getOrDefault("fields")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "fields", valid_589213
  var valid_589214 = query.getOrDefault("pageToken")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "pageToken", valid_589214
  var valid_589215 = query.getOrDefault("quotaUser")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "quotaUser", valid_589215
  var valid_589216 = query.getOrDefault("alt")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = newJString("json"))
  if valid_589216 != nil:
    section.add "alt", valid_589216
  var valid_589217 = query.getOrDefault("oauth_token")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "oauth_token", valid_589217
  var valid_589218 = query.getOrDefault("userIp")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "userIp", valid_589218
  var valid_589219 = query.getOrDefault("maxResults")
  valid_589219 = validateParameter(valid_589219, JInt, required = false, default = nil)
  if valid_589219 != nil:
    section.add "maxResults", valid_589219
  var valid_589220 = query.getOrDefault("key")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "key", valid_589220
  var valid_589221 = query.getOrDefault("prettyPrint")
  valid_589221 = validateParameter(valid_589221, JBool, required = false,
                                 default = newJBool(true))
  if valid_589221 != nil:
    section.add "prettyPrint", valid_589221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589222: Call_ContentAccountsList_589195; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_589222.validator(path, query, header, formData, body)
  let scheme = call_589222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589222.url(scheme.get, call_589222.host, call_589222.base,
                         call_589222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589222, url, valid)

proc call*(call_589223: Call_ContentAccountsList_589195; merchantId: string;
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
  var path_589224 = newJObject()
  var query_589225 = newJObject()
  add(query_589225, "fields", newJString(fields))
  add(query_589225, "pageToken", newJString(pageToken))
  add(query_589225, "quotaUser", newJString(quotaUser))
  add(query_589225, "alt", newJString(alt))
  add(query_589225, "oauth_token", newJString(oauthToken))
  add(query_589225, "userIp", newJString(userIp))
  add(query_589225, "maxResults", newJInt(maxResults))
  add(query_589225, "key", newJString(key))
  add(path_589224, "merchantId", newJString(merchantId))
  add(query_589225, "prettyPrint", newJBool(prettyPrint))
  result = call_589223.call(path_589224, query_589225, nil, nil, nil)

var contentAccountsList* = Call_ContentAccountsList_589195(
    name: "contentAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounts",
    validator: validate_ContentAccountsList_589196, base: "/content/v2.1",
    url: url_ContentAccountsList_589197, schemes: {Scheme.Https})
type
  Call_ContentAccountsUpdate_589259 = ref object of OpenApiRestCall_588450
proc url_ContentAccountsUpdate_589261(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsUpdate_589260(path: JsonNode; query: JsonNode;
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
  var valid_589262 = path.getOrDefault("accountId")
  valid_589262 = validateParameter(valid_589262, JString, required = true,
                                 default = nil)
  if valid_589262 != nil:
    section.add "accountId", valid_589262
  var valid_589263 = path.getOrDefault("merchantId")
  valid_589263 = validateParameter(valid_589263, JString, required = true,
                                 default = nil)
  if valid_589263 != nil:
    section.add "merchantId", valid_589263
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589264 = query.getOrDefault("fields")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "fields", valid_589264
  var valid_589265 = query.getOrDefault("quotaUser")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "quotaUser", valid_589265
  var valid_589266 = query.getOrDefault("alt")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = newJString("json"))
  if valid_589266 != nil:
    section.add "alt", valid_589266
  var valid_589267 = query.getOrDefault("oauth_token")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = nil)
  if valid_589267 != nil:
    section.add "oauth_token", valid_589267
  var valid_589268 = query.getOrDefault("userIp")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = nil)
  if valid_589268 != nil:
    section.add "userIp", valid_589268
  var valid_589269 = query.getOrDefault("key")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "key", valid_589269
  var valid_589270 = query.getOrDefault("prettyPrint")
  valid_589270 = validateParameter(valid_589270, JBool, required = false,
                                 default = newJBool(true))
  if valid_589270 != nil:
    section.add "prettyPrint", valid_589270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589272: Call_ContentAccountsUpdate_589259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Merchant Center account.
  ## 
  let valid = call_589272.validator(path, query, header, formData, body)
  let scheme = call_589272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589272.url(scheme.get, call_589272.host, call_589272.base,
                         call_589272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589272, url, valid)

proc call*(call_589273: Call_ContentAccountsUpdate_589259; accountId: string;
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
  var path_589274 = newJObject()
  var query_589275 = newJObject()
  var body_589276 = newJObject()
  add(query_589275, "fields", newJString(fields))
  add(query_589275, "quotaUser", newJString(quotaUser))
  add(query_589275, "alt", newJString(alt))
  add(query_589275, "oauth_token", newJString(oauthToken))
  add(path_589274, "accountId", newJString(accountId))
  add(query_589275, "userIp", newJString(userIp))
  add(query_589275, "key", newJString(key))
  add(path_589274, "merchantId", newJString(merchantId))
  if body != nil:
    body_589276 = body
  add(query_589275, "prettyPrint", newJBool(prettyPrint))
  result = call_589273.call(path_589274, query_589275, nil, nil, body_589276)

var contentAccountsUpdate* = Call_ContentAccountsUpdate_589259(
    name: "contentAccountsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsUpdate_589260, base: "/content/v2.1",
    url: url_ContentAccountsUpdate_589261, schemes: {Scheme.Https})
type
  Call_ContentAccountsGet_589243 = ref object of OpenApiRestCall_588450
proc url_ContentAccountsGet_589245(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsGet_589244(path: JsonNode; query: JsonNode;
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
  var valid_589246 = path.getOrDefault("accountId")
  valid_589246 = validateParameter(valid_589246, JString, required = true,
                                 default = nil)
  if valid_589246 != nil:
    section.add "accountId", valid_589246
  var valid_589247 = path.getOrDefault("merchantId")
  valid_589247 = validateParameter(valid_589247, JString, required = true,
                                 default = nil)
  if valid_589247 != nil:
    section.add "merchantId", valid_589247
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
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
  if body != nil:
    result.add "body", body

proc call*(call_589255: Call_ContentAccountsGet_589243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a Merchant Center account.
  ## 
  let valid = call_589255.validator(path, query, header, formData, body)
  let scheme = call_589255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589255.url(scheme.get, call_589255.host, call_589255.base,
                         call_589255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589255, url, valid)

proc call*(call_589256: Call_ContentAccountsGet_589243; accountId: string;
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
  var path_589257 = newJObject()
  var query_589258 = newJObject()
  add(query_589258, "fields", newJString(fields))
  add(query_589258, "quotaUser", newJString(quotaUser))
  add(query_589258, "alt", newJString(alt))
  add(query_589258, "oauth_token", newJString(oauthToken))
  add(path_589257, "accountId", newJString(accountId))
  add(query_589258, "userIp", newJString(userIp))
  add(query_589258, "key", newJString(key))
  add(path_589257, "merchantId", newJString(merchantId))
  add(query_589258, "prettyPrint", newJBool(prettyPrint))
  result = call_589256.call(path_589257, query_589258, nil, nil, nil)

var contentAccountsGet* = Call_ContentAccountsGet_589243(
    name: "contentAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsGet_589244, base: "/content/v2.1",
    url: url_ContentAccountsGet_589245, schemes: {Scheme.Https})
type
  Call_ContentAccountsDelete_589277 = ref object of OpenApiRestCall_588450
proc url_ContentAccountsDelete_589279(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsDelete_589278(path: JsonNode; query: JsonNode;
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
  var valid_589280 = path.getOrDefault("accountId")
  valid_589280 = validateParameter(valid_589280, JString, required = true,
                                 default = nil)
  if valid_589280 != nil:
    section.add "accountId", valid_589280
  var valid_589281 = path.getOrDefault("merchantId")
  valid_589281 = validateParameter(valid_589281, JString, required = true,
                                 default = nil)
  if valid_589281 != nil:
    section.add "merchantId", valid_589281
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
  var valid_589282 = query.getOrDefault("fields")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = nil)
  if valid_589282 != nil:
    section.add "fields", valid_589282
  var valid_589283 = query.getOrDefault("force")
  valid_589283 = validateParameter(valid_589283, JBool, required = false,
                                 default = newJBool(false))
  if valid_589283 != nil:
    section.add "force", valid_589283
  var valid_589284 = query.getOrDefault("quotaUser")
  valid_589284 = validateParameter(valid_589284, JString, required = false,
                                 default = nil)
  if valid_589284 != nil:
    section.add "quotaUser", valid_589284
  var valid_589285 = query.getOrDefault("alt")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = newJString("json"))
  if valid_589285 != nil:
    section.add "alt", valid_589285
  var valid_589286 = query.getOrDefault("oauth_token")
  valid_589286 = validateParameter(valid_589286, JString, required = false,
                                 default = nil)
  if valid_589286 != nil:
    section.add "oauth_token", valid_589286
  var valid_589287 = query.getOrDefault("userIp")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = nil)
  if valid_589287 != nil:
    section.add "userIp", valid_589287
  var valid_589288 = query.getOrDefault("key")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = nil)
  if valid_589288 != nil:
    section.add "key", valid_589288
  var valid_589289 = query.getOrDefault("prettyPrint")
  valid_589289 = validateParameter(valid_589289, JBool, required = false,
                                 default = newJBool(true))
  if valid_589289 != nil:
    section.add "prettyPrint", valid_589289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589290: Call_ContentAccountsDelete_589277; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Merchant Center sub-account.
  ## 
  let valid = call_589290.validator(path, query, header, formData, body)
  let scheme = call_589290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589290.url(scheme.get, call_589290.host, call_589290.base,
                         call_589290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589290, url, valid)

proc call*(call_589291: Call_ContentAccountsDelete_589277; accountId: string;
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
  var path_589292 = newJObject()
  var query_589293 = newJObject()
  add(query_589293, "fields", newJString(fields))
  add(query_589293, "force", newJBool(force))
  add(query_589293, "quotaUser", newJString(quotaUser))
  add(query_589293, "alt", newJString(alt))
  add(query_589293, "oauth_token", newJString(oauthToken))
  add(path_589292, "accountId", newJString(accountId))
  add(query_589293, "userIp", newJString(userIp))
  add(query_589293, "key", newJString(key))
  add(path_589292, "merchantId", newJString(merchantId))
  add(query_589293, "prettyPrint", newJBool(prettyPrint))
  result = call_589291.call(path_589292, query_589293, nil, nil, nil)

var contentAccountsDelete* = Call_ContentAccountsDelete_589277(
    name: "contentAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsDelete_589278, base: "/content/v2.1",
    url: url_ContentAccountsDelete_589279, schemes: {Scheme.Https})
type
  Call_ContentAccountsClaimwebsite_589294 = ref object of OpenApiRestCall_588450
proc url_ContentAccountsClaimwebsite_589296(protocol: Scheme; host: string;
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

proc validate_ContentAccountsClaimwebsite_589295(path: JsonNode; query: JsonNode;
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
  var valid_589297 = path.getOrDefault("accountId")
  valid_589297 = validateParameter(valid_589297, JString, required = true,
                                 default = nil)
  if valid_589297 != nil:
    section.add "accountId", valid_589297
  var valid_589298 = path.getOrDefault("merchantId")
  valid_589298 = validateParameter(valid_589298, JString, required = true,
                                 default = nil)
  if valid_589298 != nil:
    section.add "merchantId", valid_589298
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
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
  var valid_589299 = query.getOrDefault("fields")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = nil)
  if valid_589299 != nil:
    section.add "fields", valid_589299
  var valid_589300 = query.getOrDefault("quotaUser")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "quotaUser", valid_589300
  var valid_589301 = query.getOrDefault("alt")
  valid_589301 = validateParameter(valid_589301, JString, required = false,
                                 default = newJString("json"))
  if valid_589301 != nil:
    section.add "alt", valid_589301
  var valid_589302 = query.getOrDefault("oauth_token")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = nil)
  if valid_589302 != nil:
    section.add "oauth_token", valid_589302
  var valid_589303 = query.getOrDefault("userIp")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = nil)
  if valid_589303 != nil:
    section.add "userIp", valid_589303
  var valid_589304 = query.getOrDefault("overwrite")
  valid_589304 = validateParameter(valid_589304, JBool, required = false, default = nil)
  if valid_589304 != nil:
    section.add "overwrite", valid_589304
  var valid_589305 = query.getOrDefault("key")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = nil)
  if valid_589305 != nil:
    section.add "key", valid_589305
  var valid_589306 = query.getOrDefault("prettyPrint")
  valid_589306 = validateParameter(valid_589306, JBool, required = false,
                                 default = newJBool(true))
  if valid_589306 != nil:
    section.add "prettyPrint", valid_589306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589307: Call_ContentAccountsClaimwebsite_589294; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Claims the website of a Merchant Center sub-account.
  ## 
  let valid = call_589307.validator(path, query, header, formData, body)
  let scheme = call_589307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589307.url(scheme.get, call_589307.host, call_589307.base,
                         call_589307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589307, url, valid)

proc call*(call_589308: Call_ContentAccountsClaimwebsite_589294; accountId: string;
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
  var path_589309 = newJObject()
  var query_589310 = newJObject()
  add(query_589310, "fields", newJString(fields))
  add(query_589310, "quotaUser", newJString(quotaUser))
  add(query_589310, "alt", newJString(alt))
  add(query_589310, "oauth_token", newJString(oauthToken))
  add(path_589309, "accountId", newJString(accountId))
  add(query_589310, "userIp", newJString(userIp))
  add(query_589310, "overwrite", newJBool(overwrite))
  add(query_589310, "key", newJString(key))
  add(path_589309, "merchantId", newJString(merchantId))
  add(query_589310, "prettyPrint", newJBool(prettyPrint))
  result = call_589308.call(path_589309, query_589310, nil, nil, nil)

var contentAccountsClaimwebsite* = Call_ContentAccountsClaimwebsite_589294(
    name: "contentAccountsClaimwebsite", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/accounts/{accountId}/claimwebsite",
    validator: validate_ContentAccountsClaimwebsite_589295, base: "/content/v2.1",
    url: url_ContentAccountsClaimwebsite_589296, schemes: {Scheme.Https})
type
  Call_ContentAccountsLink_589311 = ref object of OpenApiRestCall_588450
proc url_ContentAccountsLink_589313(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsLink_589312(path: JsonNode; query: JsonNode;
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
  var valid_589314 = path.getOrDefault("accountId")
  valid_589314 = validateParameter(valid_589314, JString, required = true,
                                 default = nil)
  if valid_589314 != nil:
    section.add "accountId", valid_589314
  var valid_589315 = path.getOrDefault("merchantId")
  valid_589315 = validateParameter(valid_589315, JString, required = true,
                                 default = nil)
  if valid_589315 != nil:
    section.add "merchantId", valid_589315
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589316 = query.getOrDefault("fields")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "fields", valid_589316
  var valid_589317 = query.getOrDefault("quotaUser")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = nil)
  if valid_589317 != nil:
    section.add "quotaUser", valid_589317
  var valid_589318 = query.getOrDefault("alt")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = newJString("json"))
  if valid_589318 != nil:
    section.add "alt", valid_589318
  var valid_589319 = query.getOrDefault("oauth_token")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = nil)
  if valid_589319 != nil:
    section.add "oauth_token", valid_589319
  var valid_589320 = query.getOrDefault("userIp")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "userIp", valid_589320
  var valid_589321 = query.getOrDefault("key")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = nil)
  if valid_589321 != nil:
    section.add "key", valid_589321
  var valid_589322 = query.getOrDefault("prettyPrint")
  valid_589322 = validateParameter(valid_589322, JBool, required = false,
                                 default = newJBool(true))
  if valid_589322 != nil:
    section.add "prettyPrint", valid_589322
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589324: Call_ContentAccountsLink_589311; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs an action on a link between two Merchant Center accounts, namely accountId and linkedAccountId.
  ## 
  let valid = call_589324.validator(path, query, header, formData, body)
  let scheme = call_589324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589324.url(scheme.get, call_589324.host, call_589324.base,
                         call_589324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589324, url, valid)

proc call*(call_589325: Call_ContentAccountsLink_589311; accountId: string;
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
  var path_589326 = newJObject()
  var query_589327 = newJObject()
  var body_589328 = newJObject()
  add(query_589327, "fields", newJString(fields))
  add(query_589327, "quotaUser", newJString(quotaUser))
  add(query_589327, "alt", newJString(alt))
  add(query_589327, "oauth_token", newJString(oauthToken))
  add(path_589326, "accountId", newJString(accountId))
  add(query_589327, "userIp", newJString(userIp))
  add(query_589327, "key", newJString(key))
  add(path_589326, "merchantId", newJString(merchantId))
  if body != nil:
    body_589328 = body
  add(query_589327, "prettyPrint", newJBool(prettyPrint))
  result = call_589325.call(path_589326, query_589327, nil, nil, body_589328)

var contentAccountsLink* = Call_ContentAccountsLink_589311(
    name: "contentAccountsLink", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}/link",
    validator: validate_ContentAccountsLink_589312, base: "/content/v2.1",
    url: url_ContentAccountsLink_589313, schemes: {Scheme.Https})
type
  Call_ContentAccountstatusesList_589329 = ref object of OpenApiRestCall_588450
proc url_ContentAccountstatusesList_589331(protocol: Scheme; host: string;
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

proc validate_ContentAccountstatusesList_589330(path: JsonNode; query: JsonNode;
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
  var valid_589332 = path.getOrDefault("merchantId")
  valid_589332 = validateParameter(valid_589332, JString, required = true,
                                 default = nil)
  if valid_589332 != nil:
    section.add "merchantId", valid_589332
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
  var valid_589333 = query.getOrDefault("fields")
  valid_589333 = validateParameter(valid_589333, JString, required = false,
                                 default = nil)
  if valid_589333 != nil:
    section.add "fields", valid_589333
  var valid_589334 = query.getOrDefault("pageToken")
  valid_589334 = validateParameter(valid_589334, JString, required = false,
                                 default = nil)
  if valid_589334 != nil:
    section.add "pageToken", valid_589334
  var valid_589335 = query.getOrDefault("quotaUser")
  valid_589335 = validateParameter(valid_589335, JString, required = false,
                                 default = nil)
  if valid_589335 != nil:
    section.add "quotaUser", valid_589335
  var valid_589336 = query.getOrDefault("alt")
  valid_589336 = validateParameter(valid_589336, JString, required = false,
                                 default = newJString("json"))
  if valid_589336 != nil:
    section.add "alt", valid_589336
  var valid_589337 = query.getOrDefault("oauth_token")
  valid_589337 = validateParameter(valid_589337, JString, required = false,
                                 default = nil)
  if valid_589337 != nil:
    section.add "oauth_token", valid_589337
  var valid_589338 = query.getOrDefault("userIp")
  valid_589338 = validateParameter(valid_589338, JString, required = false,
                                 default = nil)
  if valid_589338 != nil:
    section.add "userIp", valid_589338
  var valid_589339 = query.getOrDefault("maxResults")
  valid_589339 = validateParameter(valid_589339, JInt, required = false, default = nil)
  if valid_589339 != nil:
    section.add "maxResults", valid_589339
  var valid_589340 = query.getOrDefault("key")
  valid_589340 = validateParameter(valid_589340, JString, required = false,
                                 default = nil)
  if valid_589340 != nil:
    section.add "key", valid_589340
  var valid_589341 = query.getOrDefault("prettyPrint")
  valid_589341 = validateParameter(valid_589341, JBool, required = false,
                                 default = newJBool(true))
  if valid_589341 != nil:
    section.add "prettyPrint", valid_589341
  var valid_589342 = query.getOrDefault("destinations")
  valid_589342 = validateParameter(valid_589342, JArray, required = false,
                                 default = nil)
  if valid_589342 != nil:
    section.add "destinations", valid_589342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589343: Call_ContentAccountstatusesList_589329; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_589343.validator(path, query, header, formData, body)
  let scheme = call_589343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589343.url(scheme.get, call_589343.host, call_589343.base,
                         call_589343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589343, url, valid)

proc call*(call_589344: Call_ContentAccountstatusesList_589329; merchantId: string;
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
  var path_589345 = newJObject()
  var query_589346 = newJObject()
  add(query_589346, "fields", newJString(fields))
  add(query_589346, "pageToken", newJString(pageToken))
  add(query_589346, "quotaUser", newJString(quotaUser))
  add(query_589346, "alt", newJString(alt))
  add(query_589346, "oauth_token", newJString(oauthToken))
  add(query_589346, "userIp", newJString(userIp))
  add(query_589346, "maxResults", newJInt(maxResults))
  add(query_589346, "key", newJString(key))
  add(path_589345, "merchantId", newJString(merchantId))
  add(query_589346, "prettyPrint", newJBool(prettyPrint))
  if destinations != nil:
    query_589346.add "destinations", destinations
  result = call_589344.call(path_589345, query_589346, nil, nil, nil)

var contentAccountstatusesList* = Call_ContentAccountstatusesList_589329(
    name: "contentAccountstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accountstatuses",
    validator: validate_ContentAccountstatusesList_589330, base: "/content/v2.1",
    url: url_ContentAccountstatusesList_589331, schemes: {Scheme.Https})
type
  Call_ContentAccountstatusesGet_589347 = ref object of OpenApiRestCall_588450
proc url_ContentAccountstatusesGet_589349(protocol: Scheme; host: string;
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

proc validate_ContentAccountstatusesGet_589348(path: JsonNode; query: JsonNode;
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
  var valid_589350 = path.getOrDefault("accountId")
  valid_589350 = validateParameter(valid_589350, JString, required = true,
                                 default = nil)
  if valid_589350 != nil:
    section.add "accountId", valid_589350
  var valid_589351 = path.getOrDefault("merchantId")
  valid_589351 = validateParameter(valid_589351, JString, required = true,
                                 default = nil)
  if valid_589351 != nil:
    section.add "merchantId", valid_589351
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
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
  var valid_589352 = query.getOrDefault("fields")
  valid_589352 = validateParameter(valid_589352, JString, required = false,
                                 default = nil)
  if valid_589352 != nil:
    section.add "fields", valid_589352
  var valid_589353 = query.getOrDefault("quotaUser")
  valid_589353 = validateParameter(valid_589353, JString, required = false,
                                 default = nil)
  if valid_589353 != nil:
    section.add "quotaUser", valid_589353
  var valid_589354 = query.getOrDefault("alt")
  valid_589354 = validateParameter(valid_589354, JString, required = false,
                                 default = newJString("json"))
  if valid_589354 != nil:
    section.add "alt", valid_589354
  var valid_589355 = query.getOrDefault("oauth_token")
  valid_589355 = validateParameter(valid_589355, JString, required = false,
                                 default = nil)
  if valid_589355 != nil:
    section.add "oauth_token", valid_589355
  var valid_589356 = query.getOrDefault("userIp")
  valid_589356 = validateParameter(valid_589356, JString, required = false,
                                 default = nil)
  if valid_589356 != nil:
    section.add "userIp", valid_589356
  var valid_589357 = query.getOrDefault("key")
  valid_589357 = validateParameter(valid_589357, JString, required = false,
                                 default = nil)
  if valid_589357 != nil:
    section.add "key", valid_589357
  var valid_589358 = query.getOrDefault("prettyPrint")
  valid_589358 = validateParameter(valid_589358, JBool, required = false,
                                 default = newJBool(true))
  if valid_589358 != nil:
    section.add "prettyPrint", valid_589358
  var valid_589359 = query.getOrDefault("destinations")
  valid_589359 = validateParameter(valid_589359, JArray, required = false,
                                 default = nil)
  if valid_589359 != nil:
    section.add "destinations", valid_589359
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589360: Call_ContentAccountstatusesGet_589347; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the status of a Merchant Center account. No itemLevelIssues are returned for multi-client accounts.
  ## 
  let valid = call_589360.validator(path, query, header, formData, body)
  let scheme = call_589360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589360.url(scheme.get, call_589360.host, call_589360.base,
                         call_589360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589360, url, valid)

proc call*(call_589361: Call_ContentAccountstatusesGet_589347; accountId: string;
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
  var path_589362 = newJObject()
  var query_589363 = newJObject()
  add(query_589363, "fields", newJString(fields))
  add(query_589363, "quotaUser", newJString(quotaUser))
  add(query_589363, "alt", newJString(alt))
  add(query_589363, "oauth_token", newJString(oauthToken))
  add(path_589362, "accountId", newJString(accountId))
  add(query_589363, "userIp", newJString(userIp))
  add(query_589363, "key", newJString(key))
  add(path_589362, "merchantId", newJString(merchantId))
  add(query_589363, "prettyPrint", newJBool(prettyPrint))
  if destinations != nil:
    query_589363.add "destinations", destinations
  result = call_589361.call(path_589362, query_589363, nil, nil, nil)

var contentAccountstatusesGet* = Call_ContentAccountstatusesGet_589347(
    name: "contentAccountstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/accountstatuses/{accountId}",
    validator: validate_ContentAccountstatusesGet_589348, base: "/content/v2.1",
    url: url_ContentAccountstatusesGet_589349, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxList_589364 = ref object of OpenApiRestCall_588450
proc url_ContentAccounttaxList_589366(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccounttaxList_589365(path: JsonNode; query: JsonNode;
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
  var valid_589367 = path.getOrDefault("merchantId")
  valid_589367 = validateParameter(valid_589367, JString, required = true,
                                 default = nil)
  if valid_589367 != nil:
    section.add "merchantId", valid_589367
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
  var valid_589368 = query.getOrDefault("fields")
  valid_589368 = validateParameter(valid_589368, JString, required = false,
                                 default = nil)
  if valid_589368 != nil:
    section.add "fields", valid_589368
  var valid_589369 = query.getOrDefault("pageToken")
  valid_589369 = validateParameter(valid_589369, JString, required = false,
                                 default = nil)
  if valid_589369 != nil:
    section.add "pageToken", valid_589369
  var valid_589370 = query.getOrDefault("quotaUser")
  valid_589370 = validateParameter(valid_589370, JString, required = false,
                                 default = nil)
  if valid_589370 != nil:
    section.add "quotaUser", valid_589370
  var valid_589371 = query.getOrDefault("alt")
  valid_589371 = validateParameter(valid_589371, JString, required = false,
                                 default = newJString("json"))
  if valid_589371 != nil:
    section.add "alt", valid_589371
  var valid_589372 = query.getOrDefault("oauth_token")
  valid_589372 = validateParameter(valid_589372, JString, required = false,
                                 default = nil)
  if valid_589372 != nil:
    section.add "oauth_token", valid_589372
  var valid_589373 = query.getOrDefault("userIp")
  valid_589373 = validateParameter(valid_589373, JString, required = false,
                                 default = nil)
  if valid_589373 != nil:
    section.add "userIp", valid_589373
  var valid_589374 = query.getOrDefault("maxResults")
  valid_589374 = validateParameter(valid_589374, JInt, required = false, default = nil)
  if valid_589374 != nil:
    section.add "maxResults", valid_589374
  var valid_589375 = query.getOrDefault("key")
  valid_589375 = validateParameter(valid_589375, JString, required = false,
                                 default = nil)
  if valid_589375 != nil:
    section.add "key", valid_589375
  var valid_589376 = query.getOrDefault("prettyPrint")
  valid_589376 = validateParameter(valid_589376, JBool, required = false,
                                 default = newJBool(true))
  if valid_589376 != nil:
    section.add "prettyPrint", valid_589376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589377: Call_ContentAccounttaxList_589364; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the tax settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_589377.validator(path, query, header, formData, body)
  let scheme = call_589377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589377.url(scheme.get, call_589377.host, call_589377.base,
                         call_589377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589377, url, valid)

proc call*(call_589378: Call_ContentAccounttaxList_589364; merchantId: string;
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
  var path_589379 = newJObject()
  var query_589380 = newJObject()
  add(query_589380, "fields", newJString(fields))
  add(query_589380, "pageToken", newJString(pageToken))
  add(query_589380, "quotaUser", newJString(quotaUser))
  add(query_589380, "alt", newJString(alt))
  add(query_589380, "oauth_token", newJString(oauthToken))
  add(query_589380, "userIp", newJString(userIp))
  add(query_589380, "maxResults", newJInt(maxResults))
  add(query_589380, "key", newJString(key))
  add(path_589379, "merchantId", newJString(merchantId))
  add(query_589380, "prettyPrint", newJBool(prettyPrint))
  result = call_589378.call(path_589379, query_589380, nil, nil, nil)

var contentAccounttaxList* = Call_ContentAccounttaxList_589364(
    name: "contentAccounttaxList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax",
    validator: validate_ContentAccounttaxList_589365, base: "/content/v2.1",
    url: url_ContentAccounttaxList_589366, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxUpdate_589397 = ref object of OpenApiRestCall_588450
proc url_ContentAccounttaxUpdate_589399(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccounttaxUpdate_589398(path: JsonNode; query: JsonNode;
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
  var valid_589400 = path.getOrDefault("accountId")
  valid_589400 = validateParameter(valid_589400, JString, required = true,
                                 default = nil)
  if valid_589400 != nil:
    section.add "accountId", valid_589400
  var valid_589401 = path.getOrDefault("merchantId")
  valid_589401 = validateParameter(valid_589401, JString, required = true,
                                 default = nil)
  if valid_589401 != nil:
    section.add "merchantId", valid_589401
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589402 = query.getOrDefault("fields")
  valid_589402 = validateParameter(valid_589402, JString, required = false,
                                 default = nil)
  if valid_589402 != nil:
    section.add "fields", valid_589402
  var valid_589403 = query.getOrDefault("quotaUser")
  valid_589403 = validateParameter(valid_589403, JString, required = false,
                                 default = nil)
  if valid_589403 != nil:
    section.add "quotaUser", valid_589403
  var valid_589404 = query.getOrDefault("alt")
  valid_589404 = validateParameter(valid_589404, JString, required = false,
                                 default = newJString("json"))
  if valid_589404 != nil:
    section.add "alt", valid_589404
  var valid_589405 = query.getOrDefault("oauth_token")
  valid_589405 = validateParameter(valid_589405, JString, required = false,
                                 default = nil)
  if valid_589405 != nil:
    section.add "oauth_token", valid_589405
  var valid_589406 = query.getOrDefault("userIp")
  valid_589406 = validateParameter(valid_589406, JString, required = false,
                                 default = nil)
  if valid_589406 != nil:
    section.add "userIp", valid_589406
  var valid_589407 = query.getOrDefault("key")
  valid_589407 = validateParameter(valid_589407, JString, required = false,
                                 default = nil)
  if valid_589407 != nil:
    section.add "key", valid_589407
  var valid_589408 = query.getOrDefault("prettyPrint")
  valid_589408 = validateParameter(valid_589408, JBool, required = false,
                                 default = newJBool(true))
  if valid_589408 != nil:
    section.add "prettyPrint", valid_589408
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589410: Call_ContentAccounttaxUpdate_589397; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the tax settings of the account.
  ## 
  let valid = call_589410.validator(path, query, header, formData, body)
  let scheme = call_589410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589410.url(scheme.get, call_589410.host, call_589410.base,
                         call_589410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589410, url, valid)

proc call*(call_589411: Call_ContentAccounttaxUpdate_589397; accountId: string;
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
  var path_589412 = newJObject()
  var query_589413 = newJObject()
  var body_589414 = newJObject()
  add(query_589413, "fields", newJString(fields))
  add(query_589413, "quotaUser", newJString(quotaUser))
  add(query_589413, "alt", newJString(alt))
  add(query_589413, "oauth_token", newJString(oauthToken))
  add(path_589412, "accountId", newJString(accountId))
  add(query_589413, "userIp", newJString(userIp))
  add(query_589413, "key", newJString(key))
  add(path_589412, "merchantId", newJString(merchantId))
  if body != nil:
    body_589414 = body
  add(query_589413, "prettyPrint", newJBool(prettyPrint))
  result = call_589411.call(path_589412, query_589413, nil, nil, body_589414)

var contentAccounttaxUpdate* = Call_ContentAccounttaxUpdate_589397(
    name: "contentAccounttaxUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax/{accountId}",
    validator: validate_ContentAccounttaxUpdate_589398, base: "/content/v2.1",
    url: url_ContentAccounttaxUpdate_589399, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxGet_589381 = ref object of OpenApiRestCall_588450
proc url_ContentAccounttaxGet_589383(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccounttaxGet_589382(path: JsonNode; query: JsonNode;
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
  var valid_589384 = path.getOrDefault("accountId")
  valid_589384 = validateParameter(valid_589384, JString, required = true,
                                 default = nil)
  if valid_589384 != nil:
    section.add "accountId", valid_589384
  var valid_589385 = path.getOrDefault("merchantId")
  valid_589385 = validateParameter(valid_589385, JString, required = true,
                                 default = nil)
  if valid_589385 != nil:
    section.add "merchantId", valid_589385
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589386 = query.getOrDefault("fields")
  valid_589386 = validateParameter(valid_589386, JString, required = false,
                                 default = nil)
  if valid_589386 != nil:
    section.add "fields", valid_589386
  var valid_589387 = query.getOrDefault("quotaUser")
  valid_589387 = validateParameter(valid_589387, JString, required = false,
                                 default = nil)
  if valid_589387 != nil:
    section.add "quotaUser", valid_589387
  var valid_589388 = query.getOrDefault("alt")
  valid_589388 = validateParameter(valid_589388, JString, required = false,
                                 default = newJString("json"))
  if valid_589388 != nil:
    section.add "alt", valid_589388
  var valid_589389 = query.getOrDefault("oauth_token")
  valid_589389 = validateParameter(valid_589389, JString, required = false,
                                 default = nil)
  if valid_589389 != nil:
    section.add "oauth_token", valid_589389
  var valid_589390 = query.getOrDefault("userIp")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = nil)
  if valid_589390 != nil:
    section.add "userIp", valid_589390
  var valid_589391 = query.getOrDefault("key")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = nil)
  if valid_589391 != nil:
    section.add "key", valid_589391
  var valid_589392 = query.getOrDefault("prettyPrint")
  valid_589392 = validateParameter(valid_589392, JBool, required = false,
                                 default = newJBool(true))
  if valid_589392 != nil:
    section.add "prettyPrint", valid_589392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589393: Call_ContentAccounttaxGet_589381; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the tax settings of the account.
  ## 
  let valid = call_589393.validator(path, query, header, formData, body)
  let scheme = call_589393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589393.url(scheme.get, call_589393.host, call_589393.base,
                         call_589393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589393, url, valid)

proc call*(call_589394: Call_ContentAccounttaxGet_589381; accountId: string;
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
  var path_589395 = newJObject()
  var query_589396 = newJObject()
  add(query_589396, "fields", newJString(fields))
  add(query_589396, "quotaUser", newJString(quotaUser))
  add(query_589396, "alt", newJString(alt))
  add(query_589396, "oauth_token", newJString(oauthToken))
  add(path_589395, "accountId", newJString(accountId))
  add(query_589396, "userIp", newJString(userIp))
  add(query_589396, "key", newJString(key))
  add(path_589395, "merchantId", newJString(merchantId))
  add(query_589396, "prettyPrint", newJBool(prettyPrint))
  result = call_589394.call(path_589395, query_589396, nil, nil, nil)

var contentAccounttaxGet* = Call_ContentAccounttaxGet_589381(
    name: "contentAccounttaxGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax/{accountId}",
    validator: validate_ContentAccounttaxGet_589382, base: "/content/v2.1",
    url: url_ContentAccounttaxGet_589383, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsInsert_589432 = ref object of OpenApiRestCall_588450
proc url_ContentDatafeedsInsert_589434(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsInsert_589433(path: JsonNode; query: JsonNode;
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
  var valid_589439 = query.getOrDefault("oauth_token")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = nil)
  if valid_589439 != nil:
    section.add "oauth_token", valid_589439
  var valid_589440 = query.getOrDefault("userIp")
  valid_589440 = validateParameter(valid_589440, JString, required = false,
                                 default = nil)
  if valid_589440 != nil:
    section.add "userIp", valid_589440
  var valid_589441 = query.getOrDefault("key")
  valid_589441 = validateParameter(valid_589441, JString, required = false,
                                 default = nil)
  if valid_589441 != nil:
    section.add "key", valid_589441
  var valid_589442 = query.getOrDefault("prettyPrint")
  valid_589442 = validateParameter(valid_589442, JBool, required = false,
                                 default = newJBool(true))
  if valid_589442 != nil:
    section.add "prettyPrint", valid_589442
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589444: Call_ContentDatafeedsInsert_589432; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers a datafeed configuration with your Merchant Center account.
  ## 
  let valid = call_589444.validator(path, query, header, formData, body)
  let scheme = call_589444.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589444.url(scheme.get, call_589444.host, call_589444.base,
                         call_589444.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589444, url, valid)

proc call*(call_589445: Call_ContentDatafeedsInsert_589432; merchantId: string;
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
  var path_589446 = newJObject()
  var query_589447 = newJObject()
  var body_589448 = newJObject()
  add(query_589447, "fields", newJString(fields))
  add(query_589447, "quotaUser", newJString(quotaUser))
  add(query_589447, "alt", newJString(alt))
  add(query_589447, "oauth_token", newJString(oauthToken))
  add(query_589447, "userIp", newJString(userIp))
  add(query_589447, "key", newJString(key))
  add(path_589446, "merchantId", newJString(merchantId))
  if body != nil:
    body_589448 = body
  add(query_589447, "prettyPrint", newJBool(prettyPrint))
  result = call_589445.call(path_589446, query_589447, nil, nil, body_589448)

var contentDatafeedsInsert* = Call_ContentDatafeedsInsert_589432(
    name: "contentDatafeedsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds",
    validator: validate_ContentDatafeedsInsert_589433, base: "/content/v2.1",
    url: url_ContentDatafeedsInsert_589434, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsList_589415 = ref object of OpenApiRestCall_588450
proc url_ContentDatafeedsList_589417(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsList_589416(path: JsonNode; query: JsonNode;
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
  var valid_589418 = path.getOrDefault("merchantId")
  valid_589418 = validateParameter(valid_589418, JString, required = true,
                                 default = nil)
  if valid_589418 != nil:
    section.add "merchantId", valid_589418
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
  var valid_589419 = query.getOrDefault("fields")
  valid_589419 = validateParameter(valid_589419, JString, required = false,
                                 default = nil)
  if valid_589419 != nil:
    section.add "fields", valid_589419
  var valid_589420 = query.getOrDefault("pageToken")
  valid_589420 = validateParameter(valid_589420, JString, required = false,
                                 default = nil)
  if valid_589420 != nil:
    section.add "pageToken", valid_589420
  var valid_589421 = query.getOrDefault("quotaUser")
  valid_589421 = validateParameter(valid_589421, JString, required = false,
                                 default = nil)
  if valid_589421 != nil:
    section.add "quotaUser", valid_589421
  var valid_589422 = query.getOrDefault("alt")
  valid_589422 = validateParameter(valid_589422, JString, required = false,
                                 default = newJString("json"))
  if valid_589422 != nil:
    section.add "alt", valid_589422
  var valid_589423 = query.getOrDefault("oauth_token")
  valid_589423 = validateParameter(valid_589423, JString, required = false,
                                 default = nil)
  if valid_589423 != nil:
    section.add "oauth_token", valid_589423
  var valid_589424 = query.getOrDefault("userIp")
  valid_589424 = validateParameter(valid_589424, JString, required = false,
                                 default = nil)
  if valid_589424 != nil:
    section.add "userIp", valid_589424
  var valid_589425 = query.getOrDefault("maxResults")
  valid_589425 = validateParameter(valid_589425, JInt, required = false, default = nil)
  if valid_589425 != nil:
    section.add "maxResults", valid_589425
  var valid_589426 = query.getOrDefault("key")
  valid_589426 = validateParameter(valid_589426, JString, required = false,
                                 default = nil)
  if valid_589426 != nil:
    section.add "key", valid_589426
  var valid_589427 = query.getOrDefault("prettyPrint")
  valid_589427 = validateParameter(valid_589427, JBool, required = false,
                                 default = newJBool(true))
  if valid_589427 != nil:
    section.add "prettyPrint", valid_589427
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589428: Call_ContentDatafeedsList_589415; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the configurations for datafeeds in your Merchant Center account.
  ## 
  let valid = call_589428.validator(path, query, header, formData, body)
  let scheme = call_589428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589428.url(scheme.get, call_589428.host, call_589428.base,
                         call_589428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589428, url, valid)

proc call*(call_589429: Call_ContentDatafeedsList_589415; merchantId: string;
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
  var path_589430 = newJObject()
  var query_589431 = newJObject()
  add(query_589431, "fields", newJString(fields))
  add(query_589431, "pageToken", newJString(pageToken))
  add(query_589431, "quotaUser", newJString(quotaUser))
  add(query_589431, "alt", newJString(alt))
  add(query_589431, "oauth_token", newJString(oauthToken))
  add(query_589431, "userIp", newJString(userIp))
  add(query_589431, "maxResults", newJInt(maxResults))
  add(query_589431, "key", newJString(key))
  add(path_589430, "merchantId", newJString(merchantId))
  add(query_589431, "prettyPrint", newJBool(prettyPrint))
  result = call_589429.call(path_589430, query_589431, nil, nil, nil)

var contentDatafeedsList* = Call_ContentDatafeedsList_589415(
    name: "contentDatafeedsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds",
    validator: validate_ContentDatafeedsList_589416, base: "/content/v2.1",
    url: url_ContentDatafeedsList_589417, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsUpdate_589465 = ref object of OpenApiRestCall_588450
proc url_ContentDatafeedsUpdate_589467(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsUpdate_589466(path: JsonNode; query: JsonNode;
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
  var valid_589468 = path.getOrDefault("merchantId")
  valid_589468 = validateParameter(valid_589468, JString, required = true,
                                 default = nil)
  if valid_589468 != nil:
    section.add "merchantId", valid_589468
  var valid_589469 = path.getOrDefault("datafeedId")
  valid_589469 = validateParameter(valid_589469, JString, required = true,
                                 default = nil)
  if valid_589469 != nil:
    section.add "datafeedId", valid_589469
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589470 = query.getOrDefault("fields")
  valid_589470 = validateParameter(valid_589470, JString, required = false,
                                 default = nil)
  if valid_589470 != nil:
    section.add "fields", valid_589470
  var valid_589471 = query.getOrDefault("quotaUser")
  valid_589471 = validateParameter(valid_589471, JString, required = false,
                                 default = nil)
  if valid_589471 != nil:
    section.add "quotaUser", valid_589471
  var valid_589472 = query.getOrDefault("alt")
  valid_589472 = validateParameter(valid_589472, JString, required = false,
                                 default = newJString("json"))
  if valid_589472 != nil:
    section.add "alt", valid_589472
  var valid_589473 = query.getOrDefault("oauth_token")
  valid_589473 = validateParameter(valid_589473, JString, required = false,
                                 default = nil)
  if valid_589473 != nil:
    section.add "oauth_token", valid_589473
  var valid_589474 = query.getOrDefault("userIp")
  valid_589474 = validateParameter(valid_589474, JString, required = false,
                                 default = nil)
  if valid_589474 != nil:
    section.add "userIp", valid_589474
  var valid_589475 = query.getOrDefault("key")
  valid_589475 = validateParameter(valid_589475, JString, required = false,
                                 default = nil)
  if valid_589475 != nil:
    section.add "key", valid_589475
  var valid_589476 = query.getOrDefault("prettyPrint")
  valid_589476 = validateParameter(valid_589476, JBool, required = false,
                                 default = newJBool(true))
  if valid_589476 != nil:
    section.add "prettyPrint", valid_589476
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589478: Call_ContentDatafeedsUpdate_589465; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a datafeed configuration of your Merchant Center account.
  ## 
  let valid = call_589478.validator(path, query, header, formData, body)
  let scheme = call_589478.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589478.url(scheme.get, call_589478.host, call_589478.base,
                         call_589478.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589478, url, valid)

proc call*(call_589479: Call_ContentDatafeedsUpdate_589465; merchantId: string;
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
  var path_589480 = newJObject()
  var query_589481 = newJObject()
  var body_589482 = newJObject()
  add(query_589481, "fields", newJString(fields))
  add(query_589481, "quotaUser", newJString(quotaUser))
  add(query_589481, "alt", newJString(alt))
  add(query_589481, "oauth_token", newJString(oauthToken))
  add(query_589481, "userIp", newJString(userIp))
  add(query_589481, "key", newJString(key))
  add(path_589480, "merchantId", newJString(merchantId))
  if body != nil:
    body_589482 = body
  add(query_589481, "prettyPrint", newJBool(prettyPrint))
  add(path_589480, "datafeedId", newJString(datafeedId))
  result = call_589479.call(path_589480, query_589481, nil, nil, body_589482)

var contentDatafeedsUpdate* = Call_ContentDatafeedsUpdate_589465(
    name: "contentDatafeedsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsUpdate_589466, base: "/content/v2.1",
    url: url_ContentDatafeedsUpdate_589467, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsGet_589449 = ref object of OpenApiRestCall_588450
proc url_ContentDatafeedsGet_589451(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsGet_589450(path: JsonNode; query: JsonNode;
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
  var valid_589452 = path.getOrDefault("merchantId")
  valid_589452 = validateParameter(valid_589452, JString, required = true,
                                 default = nil)
  if valid_589452 != nil:
    section.add "merchantId", valid_589452
  var valid_589453 = path.getOrDefault("datafeedId")
  valid_589453 = validateParameter(valid_589453, JString, required = true,
                                 default = nil)
  if valid_589453 != nil:
    section.add "datafeedId", valid_589453
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
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
  var valid_589455 = query.getOrDefault("quotaUser")
  valid_589455 = validateParameter(valid_589455, JString, required = false,
                                 default = nil)
  if valid_589455 != nil:
    section.add "quotaUser", valid_589455
  var valid_589456 = query.getOrDefault("alt")
  valid_589456 = validateParameter(valid_589456, JString, required = false,
                                 default = newJString("json"))
  if valid_589456 != nil:
    section.add "alt", valid_589456
  var valid_589457 = query.getOrDefault("oauth_token")
  valid_589457 = validateParameter(valid_589457, JString, required = false,
                                 default = nil)
  if valid_589457 != nil:
    section.add "oauth_token", valid_589457
  var valid_589458 = query.getOrDefault("userIp")
  valid_589458 = validateParameter(valid_589458, JString, required = false,
                                 default = nil)
  if valid_589458 != nil:
    section.add "userIp", valid_589458
  var valid_589459 = query.getOrDefault("key")
  valid_589459 = validateParameter(valid_589459, JString, required = false,
                                 default = nil)
  if valid_589459 != nil:
    section.add "key", valid_589459
  var valid_589460 = query.getOrDefault("prettyPrint")
  valid_589460 = validateParameter(valid_589460, JBool, required = false,
                                 default = newJBool(true))
  if valid_589460 != nil:
    section.add "prettyPrint", valid_589460
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589461: Call_ContentDatafeedsGet_589449; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a datafeed configuration from your Merchant Center account.
  ## 
  let valid = call_589461.validator(path, query, header, formData, body)
  let scheme = call_589461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589461.url(scheme.get, call_589461.host, call_589461.base,
                         call_589461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589461, url, valid)

proc call*(call_589462: Call_ContentDatafeedsGet_589449; merchantId: string;
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
  var path_589463 = newJObject()
  var query_589464 = newJObject()
  add(query_589464, "fields", newJString(fields))
  add(query_589464, "quotaUser", newJString(quotaUser))
  add(query_589464, "alt", newJString(alt))
  add(query_589464, "oauth_token", newJString(oauthToken))
  add(query_589464, "userIp", newJString(userIp))
  add(query_589464, "key", newJString(key))
  add(path_589463, "merchantId", newJString(merchantId))
  add(query_589464, "prettyPrint", newJBool(prettyPrint))
  add(path_589463, "datafeedId", newJString(datafeedId))
  result = call_589462.call(path_589463, query_589464, nil, nil, nil)

var contentDatafeedsGet* = Call_ContentDatafeedsGet_589449(
    name: "contentDatafeedsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsGet_589450, base: "/content/v2.1",
    url: url_ContentDatafeedsGet_589451, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsDelete_589483 = ref object of OpenApiRestCall_588450
proc url_ContentDatafeedsDelete_589485(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsDelete_589484(path: JsonNode; query: JsonNode;
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
  var valid_589486 = path.getOrDefault("merchantId")
  valid_589486 = validateParameter(valid_589486, JString, required = true,
                                 default = nil)
  if valid_589486 != nil:
    section.add "merchantId", valid_589486
  var valid_589487 = path.getOrDefault("datafeedId")
  valid_589487 = validateParameter(valid_589487, JString, required = true,
                                 default = nil)
  if valid_589487 != nil:
    section.add "datafeedId", valid_589487
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589488 = query.getOrDefault("fields")
  valid_589488 = validateParameter(valid_589488, JString, required = false,
                                 default = nil)
  if valid_589488 != nil:
    section.add "fields", valid_589488
  var valid_589489 = query.getOrDefault("quotaUser")
  valid_589489 = validateParameter(valid_589489, JString, required = false,
                                 default = nil)
  if valid_589489 != nil:
    section.add "quotaUser", valid_589489
  var valid_589490 = query.getOrDefault("alt")
  valid_589490 = validateParameter(valid_589490, JString, required = false,
                                 default = newJString("json"))
  if valid_589490 != nil:
    section.add "alt", valid_589490
  var valid_589491 = query.getOrDefault("oauth_token")
  valid_589491 = validateParameter(valid_589491, JString, required = false,
                                 default = nil)
  if valid_589491 != nil:
    section.add "oauth_token", valid_589491
  var valid_589492 = query.getOrDefault("userIp")
  valid_589492 = validateParameter(valid_589492, JString, required = false,
                                 default = nil)
  if valid_589492 != nil:
    section.add "userIp", valid_589492
  var valid_589493 = query.getOrDefault("key")
  valid_589493 = validateParameter(valid_589493, JString, required = false,
                                 default = nil)
  if valid_589493 != nil:
    section.add "key", valid_589493
  var valid_589494 = query.getOrDefault("prettyPrint")
  valid_589494 = validateParameter(valid_589494, JBool, required = false,
                                 default = newJBool(true))
  if valid_589494 != nil:
    section.add "prettyPrint", valid_589494
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589495: Call_ContentDatafeedsDelete_589483; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a datafeed configuration from your Merchant Center account.
  ## 
  let valid = call_589495.validator(path, query, header, formData, body)
  let scheme = call_589495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589495.url(scheme.get, call_589495.host, call_589495.base,
                         call_589495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589495, url, valid)

proc call*(call_589496: Call_ContentDatafeedsDelete_589483; merchantId: string;
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
  var path_589497 = newJObject()
  var query_589498 = newJObject()
  add(query_589498, "fields", newJString(fields))
  add(query_589498, "quotaUser", newJString(quotaUser))
  add(query_589498, "alt", newJString(alt))
  add(query_589498, "oauth_token", newJString(oauthToken))
  add(query_589498, "userIp", newJString(userIp))
  add(query_589498, "key", newJString(key))
  add(path_589497, "merchantId", newJString(merchantId))
  add(query_589498, "prettyPrint", newJBool(prettyPrint))
  add(path_589497, "datafeedId", newJString(datafeedId))
  result = call_589496.call(path_589497, query_589498, nil, nil, nil)

var contentDatafeedsDelete* = Call_ContentDatafeedsDelete_589483(
    name: "contentDatafeedsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsDelete_589484, base: "/content/v2.1",
    url: url_ContentDatafeedsDelete_589485, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsFetchnow_589499 = ref object of OpenApiRestCall_588450
proc url_ContentDatafeedsFetchnow_589501(protocol: Scheme; host: string;
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

proc validate_ContentDatafeedsFetchnow_589500(path: JsonNode; query: JsonNode;
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
  var valid_589502 = path.getOrDefault("merchantId")
  valid_589502 = validateParameter(valid_589502, JString, required = true,
                                 default = nil)
  if valid_589502 != nil:
    section.add "merchantId", valid_589502
  var valid_589503 = path.getOrDefault("datafeedId")
  valid_589503 = validateParameter(valid_589503, JString, required = true,
                                 default = nil)
  if valid_589503 != nil:
    section.add "datafeedId", valid_589503
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589504 = query.getOrDefault("fields")
  valid_589504 = validateParameter(valid_589504, JString, required = false,
                                 default = nil)
  if valid_589504 != nil:
    section.add "fields", valid_589504
  var valid_589505 = query.getOrDefault("quotaUser")
  valid_589505 = validateParameter(valid_589505, JString, required = false,
                                 default = nil)
  if valid_589505 != nil:
    section.add "quotaUser", valid_589505
  var valid_589506 = query.getOrDefault("alt")
  valid_589506 = validateParameter(valid_589506, JString, required = false,
                                 default = newJString("json"))
  if valid_589506 != nil:
    section.add "alt", valid_589506
  var valid_589507 = query.getOrDefault("oauth_token")
  valid_589507 = validateParameter(valid_589507, JString, required = false,
                                 default = nil)
  if valid_589507 != nil:
    section.add "oauth_token", valid_589507
  var valid_589508 = query.getOrDefault("userIp")
  valid_589508 = validateParameter(valid_589508, JString, required = false,
                                 default = nil)
  if valid_589508 != nil:
    section.add "userIp", valid_589508
  var valid_589509 = query.getOrDefault("key")
  valid_589509 = validateParameter(valid_589509, JString, required = false,
                                 default = nil)
  if valid_589509 != nil:
    section.add "key", valid_589509
  var valid_589510 = query.getOrDefault("prettyPrint")
  valid_589510 = validateParameter(valid_589510, JBool, required = false,
                                 default = newJBool(true))
  if valid_589510 != nil:
    section.add "prettyPrint", valid_589510
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589511: Call_ContentDatafeedsFetchnow_589499; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Invokes a fetch for the datafeed in your Merchant Center account.
  ## 
  let valid = call_589511.validator(path, query, header, formData, body)
  let scheme = call_589511.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589511.url(scheme.get, call_589511.host, call_589511.base,
                         call_589511.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589511, url, valid)

proc call*(call_589512: Call_ContentDatafeedsFetchnow_589499; merchantId: string;
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
  var path_589513 = newJObject()
  var query_589514 = newJObject()
  add(query_589514, "fields", newJString(fields))
  add(query_589514, "quotaUser", newJString(quotaUser))
  add(query_589514, "alt", newJString(alt))
  add(query_589514, "oauth_token", newJString(oauthToken))
  add(query_589514, "userIp", newJString(userIp))
  add(query_589514, "key", newJString(key))
  add(path_589513, "merchantId", newJString(merchantId))
  add(query_589514, "prettyPrint", newJBool(prettyPrint))
  add(path_589513, "datafeedId", newJString(datafeedId))
  result = call_589512.call(path_589513, query_589514, nil, nil, nil)

var contentDatafeedsFetchnow* = Call_ContentDatafeedsFetchnow_589499(
    name: "contentDatafeedsFetchnow", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/datafeeds/{datafeedId}/fetchNow",
    validator: validate_ContentDatafeedsFetchnow_589500, base: "/content/v2.1",
    url: url_ContentDatafeedsFetchnow_589501, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesList_589515 = ref object of OpenApiRestCall_588450
proc url_ContentDatafeedstatusesList_589517(protocol: Scheme; host: string;
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

proc validate_ContentDatafeedstatusesList_589516(path: JsonNode; query: JsonNode;
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
  var valid_589518 = path.getOrDefault("merchantId")
  valid_589518 = validateParameter(valid_589518, JString, required = true,
                                 default = nil)
  if valid_589518 != nil:
    section.add "merchantId", valid_589518
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
  var valid_589519 = query.getOrDefault("fields")
  valid_589519 = validateParameter(valid_589519, JString, required = false,
                                 default = nil)
  if valid_589519 != nil:
    section.add "fields", valid_589519
  var valid_589520 = query.getOrDefault("pageToken")
  valid_589520 = validateParameter(valid_589520, JString, required = false,
                                 default = nil)
  if valid_589520 != nil:
    section.add "pageToken", valid_589520
  var valid_589521 = query.getOrDefault("quotaUser")
  valid_589521 = validateParameter(valid_589521, JString, required = false,
                                 default = nil)
  if valid_589521 != nil:
    section.add "quotaUser", valid_589521
  var valid_589522 = query.getOrDefault("alt")
  valid_589522 = validateParameter(valid_589522, JString, required = false,
                                 default = newJString("json"))
  if valid_589522 != nil:
    section.add "alt", valid_589522
  var valid_589523 = query.getOrDefault("oauth_token")
  valid_589523 = validateParameter(valid_589523, JString, required = false,
                                 default = nil)
  if valid_589523 != nil:
    section.add "oauth_token", valid_589523
  var valid_589524 = query.getOrDefault("userIp")
  valid_589524 = validateParameter(valid_589524, JString, required = false,
                                 default = nil)
  if valid_589524 != nil:
    section.add "userIp", valid_589524
  var valid_589525 = query.getOrDefault("maxResults")
  valid_589525 = validateParameter(valid_589525, JInt, required = false, default = nil)
  if valid_589525 != nil:
    section.add "maxResults", valid_589525
  var valid_589526 = query.getOrDefault("key")
  valid_589526 = validateParameter(valid_589526, JString, required = false,
                                 default = nil)
  if valid_589526 != nil:
    section.add "key", valid_589526
  var valid_589527 = query.getOrDefault("prettyPrint")
  valid_589527 = validateParameter(valid_589527, JBool, required = false,
                                 default = newJBool(true))
  if valid_589527 != nil:
    section.add "prettyPrint", valid_589527
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589528: Call_ContentDatafeedstatusesList_589515; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the datafeeds in your Merchant Center account.
  ## 
  let valid = call_589528.validator(path, query, header, formData, body)
  let scheme = call_589528.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589528.url(scheme.get, call_589528.host, call_589528.base,
                         call_589528.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589528, url, valid)

proc call*(call_589529: Call_ContentDatafeedstatusesList_589515;
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
  var path_589530 = newJObject()
  var query_589531 = newJObject()
  add(query_589531, "fields", newJString(fields))
  add(query_589531, "pageToken", newJString(pageToken))
  add(query_589531, "quotaUser", newJString(quotaUser))
  add(query_589531, "alt", newJString(alt))
  add(query_589531, "oauth_token", newJString(oauthToken))
  add(query_589531, "userIp", newJString(userIp))
  add(query_589531, "maxResults", newJInt(maxResults))
  add(query_589531, "key", newJString(key))
  add(path_589530, "merchantId", newJString(merchantId))
  add(query_589531, "prettyPrint", newJBool(prettyPrint))
  result = call_589529.call(path_589530, query_589531, nil, nil, nil)

var contentDatafeedstatusesList* = Call_ContentDatafeedstatusesList_589515(
    name: "contentDatafeedstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeedstatuses",
    validator: validate_ContentDatafeedstatusesList_589516, base: "/content/v2.1",
    url: url_ContentDatafeedstatusesList_589517, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesGet_589532 = ref object of OpenApiRestCall_588450
proc url_ContentDatafeedstatusesGet_589534(protocol: Scheme; host: string;
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

proc validate_ContentDatafeedstatusesGet_589533(path: JsonNode; query: JsonNode;
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
  var valid_589535 = path.getOrDefault("merchantId")
  valid_589535 = validateParameter(valid_589535, JString, required = true,
                                 default = nil)
  if valid_589535 != nil:
    section.add "merchantId", valid_589535
  var valid_589536 = path.getOrDefault("datafeedId")
  valid_589536 = validateParameter(valid_589536, JString, required = true,
                                 default = nil)
  if valid_589536 != nil:
    section.add "datafeedId", valid_589536
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
  var valid_589537 = query.getOrDefault("fields")
  valid_589537 = validateParameter(valid_589537, JString, required = false,
                                 default = nil)
  if valid_589537 != nil:
    section.add "fields", valid_589537
  var valid_589538 = query.getOrDefault("country")
  valid_589538 = validateParameter(valid_589538, JString, required = false,
                                 default = nil)
  if valid_589538 != nil:
    section.add "country", valid_589538
  var valid_589539 = query.getOrDefault("quotaUser")
  valid_589539 = validateParameter(valid_589539, JString, required = false,
                                 default = nil)
  if valid_589539 != nil:
    section.add "quotaUser", valid_589539
  var valid_589540 = query.getOrDefault("alt")
  valid_589540 = validateParameter(valid_589540, JString, required = false,
                                 default = newJString("json"))
  if valid_589540 != nil:
    section.add "alt", valid_589540
  var valid_589541 = query.getOrDefault("language")
  valid_589541 = validateParameter(valid_589541, JString, required = false,
                                 default = nil)
  if valid_589541 != nil:
    section.add "language", valid_589541
  var valid_589542 = query.getOrDefault("oauth_token")
  valid_589542 = validateParameter(valid_589542, JString, required = false,
                                 default = nil)
  if valid_589542 != nil:
    section.add "oauth_token", valid_589542
  var valid_589543 = query.getOrDefault("userIp")
  valid_589543 = validateParameter(valid_589543, JString, required = false,
                                 default = nil)
  if valid_589543 != nil:
    section.add "userIp", valid_589543
  var valid_589544 = query.getOrDefault("key")
  valid_589544 = validateParameter(valid_589544, JString, required = false,
                                 default = nil)
  if valid_589544 != nil:
    section.add "key", valid_589544
  var valid_589545 = query.getOrDefault("prettyPrint")
  valid_589545 = validateParameter(valid_589545, JBool, required = false,
                                 default = newJBool(true))
  if valid_589545 != nil:
    section.add "prettyPrint", valid_589545
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589546: Call_ContentDatafeedstatusesGet_589532; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the status of a datafeed from your Merchant Center account.
  ## 
  let valid = call_589546.validator(path, query, header, formData, body)
  let scheme = call_589546.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589546.url(scheme.get, call_589546.host, call_589546.base,
                         call_589546.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589546, url, valid)

proc call*(call_589547: Call_ContentDatafeedstatusesGet_589532; merchantId: string;
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
  var path_589548 = newJObject()
  var query_589549 = newJObject()
  add(query_589549, "fields", newJString(fields))
  add(query_589549, "country", newJString(country))
  add(query_589549, "quotaUser", newJString(quotaUser))
  add(query_589549, "alt", newJString(alt))
  add(query_589549, "language", newJString(language))
  add(query_589549, "oauth_token", newJString(oauthToken))
  add(query_589549, "userIp", newJString(userIp))
  add(query_589549, "key", newJString(key))
  add(path_589548, "merchantId", newJString(merchantId))
  add(query_589549, "prettyPrint", newJBool(prettyPrint))
  add(path_589548, "datafeedId", newJString(datafeedId))
  result = call_589547.call(path_589548, query_589549, nil, nil, nil)

var contentDatafeedstatusesGet* = Call_ContentDatafeedstatusesGet_589532(
    name: "contentDatafeedstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/datafeedstatuses/{datafeedId}",
    validator: validate_ContentDatafeedstatusesGet_589533, base: "/content/v2.1",
    url: url_ContentDatafeedstatusesGet_589534, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsList_589550 = ref object of OpenApiRestCall_588450
proc url_ContentLiasettingsList_589552(protocol: Scheme; host: string; base: string;
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

proc validate_ContentLiasettingsList_589551(path: JsonNode; query: JsonNode;
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
  var valid_589553 = path.getOrDefault("merchantId")
  valid_589553 = validateParameter(valid_589553, JString, required = true,
                                 default = nil)
  if valid_589553 != nil:
    section.add "merchantId", valid_589553
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
  var valid_589554 = query.getOrDefault("fields")
  valid_589554 = validateParameter(valid_589554, JString, required = false,
                                 default = nil)
  if valid_589554 != nil:
    section.add "fields", valid_589554
  var valid_589555 = query.getOrDefault("pageToken")
  valid_589555 = validateParameter(valid_589555, JString, required = false,
                                 default = nil)
  if valid_589555 != nil:
    section.add "pageToken", valid_589555
  var valid_589556 = query.getOrDefault("quotaUser")
  valid_589556 = validateParameter(valid_589556, JString, required = false,
                                 default = nil)
  if valid_589556 != nil:
    section.add "quotaUser", valid_589556
  var valid_589557 = query.getOrDefault("alt")
  valid_589557 = validateParameter(valid_589557, JString, required = false,
                                 default = newJString("json"))
  if valid_589557 != nil:
    section.add "alt", valid_589557
  var valid_589558 = query.getOrDefault("oauth_token")
  valid_589558 = validateParameter(valid_589558, JString, required = false,
                                 default = nil)
  if valid_589558 != nil:
    section.add "oauth_token", valid_589558
  var valid_589559 = query.getOrDefault("userIp")
  valid_589559 = validateParameter(valid_589559, JString, required = false,
                                 default = nil)
  if valid_589559 != nil:
    section.add "userIp", valid_589559
  var valid_589560 = query.getOrDefault("maxResults")
  valid_589560 = validateParameter(valid_589560, JInt, required = false, default = nil)
  if valid_589560 != nil:
    section.add "maxResults", valid_589560
  var valid_589561 = query.getOrDefault("key")
  valid_589561 = validateParameter(valid_589561, JString, required = false,
                                 default = nil)
  if valid_589561 != nil:
    section.add "key", valid_589561
  var valid_589562 = query.getOrDefault("prettyPrint")
  valid_589562 = validateParameter(valid_589562, JBool, required = false,
                                 default = newJBool(true))
  if valid_589562 != nil:
    section.add "prettyPrint", valid_589562
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589563: Call_ContentLiasettingsList_589550; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the LIA settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_589563.validator(path, query, header, formData, body)
  let scheme = call_589563.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589563.url(scheme.get, call_589563.host, call_589563.base,
                         call_589563.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589563, url, valid)

proc call*(call_589564: Call_ContentLiasettingsList_589550; merchantId: string;
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
  var path_589565 = newJObject()
  var query_589566 = newJObject()
  add(query_589566, "fields", newJString(fields))
  add(query_589566, "pageToken", newJString(pageToken))
  add(query_589566, "quotaUser", newJString(quotaUser))
  add(query_589566, "alt", newJString(alt))
  add(query_589566, "oauth_token", newJString(oauthToken))
  add(query_589566, "userIp", newJString(userIp))
  add(query_589566, "maxResults", newJInt(maxResults))
  add(query_589566, "key", newJString(key))
  add(path_589565, "merchantId", newJString(merchantId))
  add(query_589566, "prettyPrint", newJBool(prettyPrint))
  result = call_589564.call(path_589565, query_589566, nil, nil, nil)

var contentLiasettingsList* = Call_ContentLiasettingsList_589550(
    name: "contentLiasettingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings",
    validator: validate_ContentLiasettingsList_589551, base: "/content/v2.1",
    url: url_ContentLiasettingsList_589552, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsUpdate_589583 = ref object of OpenApiRestCall_588450
proc url_ContentLiasettingsUpdate_589585(protocol: Scheme; host: string;
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

proc validate_ContentLiasettingsUpdate_589584(path: JsonNode; query: JsonNode;
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
  var valid_589586 = path.getOrDefault("accountId")
  valid_589586 = validateParameter(valid_589586, JString, required = true,
                                 default = nil)
  if valid_589586 != nil:
    section.add "accountId", valid_589586
  var valid_589587 = path.getOrDefault("merchantId")
  valid_589587 = validateParameter(valid_589587, JString, required = true,
                                 default = nil)
  if valid_589587 != nil:
    section.add "merchantId", valid_589587
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589588 = query.getOrDefault("fields")
  valid_589588 = validateParameter(valid_589588, JString, required = false,
                                 default = nil)
  if valid_589588 != nil:
    section.add "fields", valid_589588
  var valid_589589 = query.getOrDefault("quotaUser")
  valid_589589 = validateParameter(valid_589589, JString, required = false,
                                 default = nil)
  if valid_589589 != nil:
    section.add "quotaUser", valid_589589
  var valid_589590 = query.getOrDefault("alt")
  valid_589590 = validateParameter(valid_589590, JString, required = false,
                                 default = newJString("json"))
  if valid_589590 != nil:
    section.add "alt", valid_589590
  var valid_589591 = query.getOrDefault("oauth_token")
  valid_589591 = validateParameter(valid_589591, JString, required = false,
                                 default = nil)
  if valid_589591 != nil:
    section.add "oauth_token", valid_589591
  var valid_589592 = query.getOrDefault("userIp")
  valid_589592 = validateParameter(valid_589592, JString, required = false,
                                 default = nil)
  if valid_589592 != nil:
    section.add "userIp", valid_589592
  var valid_589593 = query.getOrDefault("key")
  valid_589593 = validateParameter(valid_589593, JString, required = false,
                                 default = nil)
  if valid_589593 != nil:
    section.add "key", valid_589593
  var valid_589594 = query.getOrDefault("prettyPrint")
  valid_589594 = validateParameter(valid_589594, JBool, required = false,
                                 default = newJBool(true))
  if valid_589594 != nil:
    section.add "prettyPrint", valid_589594
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589596: Call_ContentLiasettingsUpdate_589583; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the LIA settings of the account.
  ## 
  let valid = call_589596.validator(path, query, header, formData, body)
  let scheme = call_589596.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589596.url(scheme.get, call_589596.host, call_589596.base,
                         call_589596.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589596, url, valid)

proc call*(call_589597: Call_ContentLiasettingsUpdate_589583; accountId: string;
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
  var path_589598 = newJObject()
  var query_589599 = newJObject()
  var body_589600 = newJObject()
  add(query_589599, "fields", newJString(fields))
  add(query_589599, "quotaUser", newJString(quotaUser))
  add(query_589599, "alt", newJString(alt))
  add(query_589599, "oauth_token", newJString(oauthToken))
  add(path_589598, "accountId", newJString(accountId))
  add(query_589599, "userIp", newJString(userIp))
  add(query_589599, "key", newJString(key))
  add(path_589598, "merchantId", newJString(merchantId))
  if body != nil:
    body_589600 = body
  add(query_589599, "prettyPrint", newJBool(prettyPrint))
  result = call_589597.call(path_589598, query_589599, nil, nil, body_589600)

var contentLiasettingsUpdate* = Call_ContentLiasettingsUpdate_589583(
    name: "contentLiasettingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}",
    validator: validate_ContentLiasettingsUpdate_589584, base: "/content/v2.1",
    url: url_ContentLiasettingsUpdate_589585, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsGet_589567 = ref object of OpenApiRestCall_588450
proc url_ContentLiasettingsGet_589569(protocol: Scheme; host: string; base: string;
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

proc validate_ContentLiasettingsGet_589568(path: JsonNode; query: JsonNode;
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
  var valid_589570 = path.getOrDefault("accountId")
  valid_589570 = validateParameter(valid_589570, JString, required = true,
                                 default = nil)
  if valid_589570 != nil:
    section.add "accountId", valid_589570
  var valid_589571 = path.getOrDefault("merchantId")
  valid_589571 = validateParameter(valid_589571, JString, required = true,
                                 default = nil)
  if valid_589571 != nil:
    section.add "merchantId", valid_589571
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589572 = query.getOrDefault("fields")
  valid_589572 = validateParameter(valid_589572, JString, required = false,
                                 default = nil)
  if valid_589572 != nil:
    section.add "fields", valid_589572
  var valid_589573 = query.getOrDefault("quotaUser")
  valid_589573 = validateParameter(valid_589573, JString, required = false,
                                 default = nil)
  if valid_589573 != nil:
    section.add "quotaUser", valid_589573
  var valid_589574 = query.getOrDefault("alt")
  valid_589574 = validateParameter(valid_589574, JString, required = false,
                                 default = newJString("json"))
  if valid_589574 != nil:
    section.add "alt", valid_589574
  var valid_589575 = query.getOrDefault("oauth_token")
  valid_589575 = validateParameter(valid_589575, JString, required = false,
                                 default = nil)
  if valid_589575 != nil:
    section.add "oauth_token", valid_589575
  var valid_589576 = query.getOrDefault("userIp")
  valid_589576 = validateParameter(valid_589576, JString, required = false,
                                 default = nil)
  if valid_589576 != nil:
    section.add "userIp", valid_589576
  var valid_589577 = query.getOrDefault("key")
  valid_589577 = validateParameter(valid_589577, JString, required = false,
                                 default = nil)
  if valid_589577 != nil:
    section.add "key", valid_589577
  var valid_589578 = query.getOrDefault("prettyPrint")
  valid_589578 = validateParameter(valid_589578, JBool, required = false,
                                 default = newJBool(true))
  if valid_589578 != nil:
    section.add "prettyPrint", valid_589578
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589579: Call_ContentLiasettingsGet_589567; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the LIA settings of the account.
  ## 
  let valid = call_589579.validator(path, query, header, formData, body)
  let scheme = call_589579.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589579.url(scheme.get, call_589579.host, call_589579.base,
                         call_589579.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589579, url, valid)

proc call*(call_589580: Call_ContentLiasettingsGet_589567; accountId: string;
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
  var path_589581 = newJObject()
  var query_589582 = newJObject()
  add(query_589582, "fields", newJString(fields))
  add(query_589582, "quotaUser", newJString(quotaUser))
  add(query_589582, "alt", newJString(alt))
  add(query_589582, "oauth_token", newJString(oauthToken))
  add(path_589581, "accountId", newJString(accountId))
  add(query_589582, "userIp", newJString(userIp))
  add(query_589582, "key", newJString(key))
  add(path_589581, "merchantId", newJString(merchantId))
  add(query_589582, "prettyPrint", newJBool(prettyPrint))
  result = call_589580.call(path_589581, query_589582, nil, nil, nil)

var contentLiasettingsGet* = Call_ContentLiasettingsGet_589567(
    name: "contentLiasettingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}",
    validator: validate_ContentLiasettingsGet_589568, base: "/content/v2.1",
    url: url_ContentLiasettingsGet_589569, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsGetaccessiblegmbaccounts_589601 = ref object of OpenApiRestCall_588450
proc url_ContentLiasettingsGetaccessiblegmbaccounts_589603(protocol: Scheme;
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

proc validate_ContentLiasettingsGetaccessiblegmbaccounts_589602(path: JsonNode;
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
  var valid_589604 = path.getOrDefault("accountId")
  valid_589604 = validateParameter(valid_589604, JString, required = true,
                                 default = nil)
  if valid_589604 != nil:
    section.add "accountId", valid_589604
  var valid_589605 = path.getOrDefault("merchantId")
  valid_589605 = validateParameter(valid_589605, JString, required = true,
                                 default = nil)
  if valid_589605 != nil:
    section.add "merchantId", valid_589605
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589606 = query.getOrDefault("fields")
  valid_589606 = validateParameter(valid_589606, JString, required = false,
                                 default = nil)
  if valid_589606 != nil:
    section.add "fields", valid_589606
  var valid_589607 = query.getOrDefault("quotaUser")
  valid_589607 = validateParameter(valid_589607, JString, required = false,
                                 default = nil)
  if valid_589607 != nil:
    section.add "quotaUser", valid_589607
  var valid_589608 = query.getOrDefault("alt")
  valid_589608 = validateParameter(valid_589608, JString, required = false,
                                 default = newJString("json"))
  if valid_589608 != nil:
    section.add "alt", valid_589608
  var valid_589609 = query.getOrDefault("oauth_token")
  valid_589609 = validateParameter(valid_589609, JString, required = false,
                                 default = nil)
  if valid_589609 != nil:
    section.add "oauth_token", valid_589609
  var valid_589610 = query.getOrDefault("userIp")
  valid_589610 = validateParameter(valid_589610, JString, required = false,
                                 default = nil)
  if valid_589610 != nil:
    section.add "userIp", valid_589610
  var valid_589611 = query.getOrDefault("key")
  valid_589611 = validateParameter(valid_589611, JString, required = false,
                                 default = nil)
  if valid_589611 != nil:
    section.add "key", valid_589611
  var valid_589612 = query.getOrDefault("prettyPrint")
  valid_589612 = validateParameter(valid_589612, JBool, required = false,
                                 default = newJBool(true))
  if valid_589612 != nil:
    section.add "prettyPrint", valid_589612
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589613: Call_ContentLiasettingsGetaccessiblegmbaccounts_589601;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of accessible Google My Business accounts.
  ## 
  let valid = call_589613.validator(path, query, header, formData, body)
  let scheme = call_589613.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589613.url(scheme.get, call_589613.host, call_589613.base,
                         call_589613.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589613, url, valid)

proc call*(call_589614: Call_ContentLiasettingsGetaccessiblegmbaccounts_589601;
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
  var path_589615 = newJObject()
  var query_589616 = newJObject()
  add(query_589616, "fields", newJString(fields))
  add(query_589616, "quotaUser", newJString(quotaUser))
  add(query_589616, "alt", newJString(alt))
  add(query_589616, "oauth_token", newJString(oauthToken))
  add(path_589615, "accountId", newJString(accountId))
  add(query_589616, "userIp", newJString(userIp))
  add(query_589616, "key", newJString(key))
  add(path_589615, "merchantId", newJString(merchantId))
  add(query_589616, "prettyPrint", newJBool(prettyPrint))
  result = call_589614.call(path_589615, query_589616, nil, nil, nil)

var contentLiasettingsGetaccessiblegmbaccounts* = Call_ContentLiasettingsGetaccessiblegmbaccounts_589601(
    name: "contentLiasettingsGetaccessiblegmbaccounts", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/accessiblegmbaccounts",
    validator: validate_ContentLiasettingsGetaccessiblegmbaccounts_589602,
    base: "/content/v2.1", url: url_ContentLiasettingsGetaccessiblegmbaccounts_589603,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsRequestgmbaccess_589617 = ref object of OpenApiRestCall_588450
proc url_ContentLiasettingsRequestgmbaccess_589619(protocol: Scheme; host: string;
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

proc validate_ContentLiasettingsRequestgmbaccess_589618(path: JsonNode;
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
  var valid_589620 = path.getOrDefault("accountId")
  valid_589620 = validateParameter(valid_589620, JString, required = true,
                                 default = nil)
  if valid_589620 != nil:
    section.add "accountId", valid_589620
  var valid_589621 = path.getOrDefault("merchantId")
  valid_589621 = validateParameter(valid_589621, JString, required = true,
                                 default = nil)
  if valid_589621 != nil:
    section.add "merchantId", valid_589621
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
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
  var valid_589622 = query.getOrDefault("fields")
  valid_589622 = validateParameter(valid_589622, JString, required = false,
                                 default = nil)
  if valid_589622 != nil:
    section.add "fields", valid_589622
  var valid_589623 = query.getOrDefault("quotaUser")
  valid_589623 = validateParameter(valid_589623, JString, required = false,
                                 default = nil)
  if valid_589623 != nil:
    section.add "quotaUser", valid_589623
  var valid_589624 = query.getOrDefault("alt")
  valid_589624 = validateParameter(valid_589624, JString, required = false,
                                 default = newJString("json"))
  if valid_589624 != nil:
    section.add "alt", valid_589624
  var valid_589625 = query.getOrDefault("oauth_token")
  valid_589625 = validateParameter(valid_589625, JString, required = false,
                                 default = nil)
  if valid_589625 != nil:
    section.add "oauth_token", valid_589625
  var valid_589626 = query.getOrDefault("userIp")
  valid_589626 = validateParameter(valid_589626, JString, required = false,
                                 default = nil)
  if valid_589626 != nil:
    section.add "userIp", valid_589626
  var valid_589627 = query.getOrDefault("key")
  valid_589627 = validateParameter(valid_589627, JString, required = false,
                                 default = nil)
  if valid_589627 != nil:
    section.add "key", valid_589627
  assert query != nil,
        "query argument is necessary due to required `gmbEmail` field"
  var valid_589628 = query.getOrDefault("gmbEmail")
  valid_589628 = validateParameter(valid_589628, JString, required = true,
                                 default = nil)
  if valid_589628 != nil:
    section.add "gmbEmail", valid_589628
  var valid_589629 = query.getOrDefault("prettyPrint")
  valid_589629 = validateParameter(valid_589629, JBool, required = false,
                                 default = newJBool(true))
  if valid_589629 != nil:
    section.add "prettyPrint", valid_589629
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589630: Call_ContentLiasettingsRequestgmbaccess_589617;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests access to a specified Google My Business account.
  ## 
  let valid = call_589630.validator(path, query, header, formData, body)
  let scheme = call_589630.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589630.url(scheme.get, call_589630.host, call_589630.base,
                         call_589630.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589630, url, valid)

proc call*(call_589631: Call_ContentLiasettingsRequestgmbaccess_589617;
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
  var path_589632 = newJObject()
  var query_589633 = newJObject()
  add(query_589633, "fields", newJString(fields))
  add(query_589633, "quotaUser", newJString(quotaUser))
  add(query_589633, "alt", newJString(alt))
  add(query_589633, "oauth_token", newJString(oauthToken))
  add(path_589632, "accountId", newJString(accountId))
  add(query_589633, "userIp", newJString(userIp))
  add(query_589633, "key", newJString(key))
  add(query_589633, "gmbEmail", newJString(gmbEmail))
  add(path_589632, "merchantId", newJString(merchantId))
  add(query_589633, "prettyPrint", newJBool(prettyPrint))
  result = call_589631.call(path_589632, query_589633, nil, nil, nil)

var contentLiasettingsRequestgmbaccess* = Call_ContentLiasettingsRequestgmbaccess_589617(
    name: "contentLiasettingsRequestgmbaccess", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/requestgmbaccess",
    validator: validate_ContentLiasettingsRequestgmbaccess_589618,
    base: "/content/v2.1", url: url_ContentLiasettingsRequestgmbaccess_589619,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsRequestinventoryverification_589634 = ref object of OpenApiRestCall_588450
proc url_ContentLiasettingsRequestinventoryverification_589636(protocol: Scheme;
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

proc validate_ContentLiasettingsRequestinventoryverification_589635(
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
  var valid_589637 = path.getOrDefault("country")
  valid_589637 = validateParameter(valid_589637, JString, required = true,
                                 default = nil)
  if valid_589637 != nil:
    section.add "country", valid_589637
  var valid_589638 = path.getOrDefault("accountId")
  valid_589638 = validateParameter(valid_589638, JString, required = true,
                                 default = nil)
  if valid_589638 != nil:
    section.add "accountId", valid_589638
  var valid_589639 = path.getOrDefault("merchantId")
  valid_589639 = validateParameter(valid_589639, JString, required = true,
                                 default = nil)
  if valid_589639 != nil:
    section.add "merchantId", valid_589639
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589640 = query.getOrDefault("fields")
  valid_589640 = validateParameter(valid_589640, JString, required = false,
                                 default = nil)
  if valid_589640 != nil:
    section.add "fields", valid_589640
  var valid_589641 = query.getOrDefault("quotaUser")
  valid_589641 = validateParameter(valid_589641, JString, required = false,
                                 default = nil)
  if valid_589641 != nil:
    section.add "quotaUser", valid_589641
  var valid_589642 = query.getOrDefault("alt")
  valid_589642 = validateParameter(valid_589642, JString, required = false,
                                 default = newJString("json"))
  if valid_589642 != nil:
    section.add "alt", valid_589642
  var valid_589643 = query.getOrDefault("oauth_token")
  valid_589643 = validateParameter(valid_589643, JString, required = false,
                                 default = nil)
  if valid_589643 != nil:
    section.add "oauth_token", valid_589643
  var valid_589644 = query.getOrDefault("userIp")
  valid_589644 = validateParameter(valid_589644, JString, required = false,
                                 default = nil)
  if valid_589644 != nil:
    section.add "userIp", valid_589644
  var valid_589645 = query.getOrDefault("key")
  valid_589645 = validateParameter(valid_589645, JString, required = false,
                                 default = nil)
  if valid_589645 != nil:
    section.add "key", valid_589645
  var valid_589646 = query.getOrDefault("prettyPrint")
  valid_589646 = validateParameter(valid_589646, JBool, required = false,
                                 default = newJBool(true))
  if valid_589646 != nil:
    section.add "prettyPrint", valid_589646
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589647: Call_ContentLiasettingsRequestinventoryverification_589634;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests inventory validation for the specified country.
  ## 
  let valid = call_589647.validator(path, query, header, formData, body)
  let scheme = call_589647.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589647.url(scheme.get, call_589647.host, call_589647.base,
                         call_589647.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589647, url, valid)

proc call*(call_589648: Call_ContentLiasettingsRequestinventoryverification_589634;
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
  var path_589649 = newJObject()
  var query_589650 = newJObject()
  add(query_589650, "fields", newJString(fields))
  add(query_589650, "quotaUser", newJString(quotaUser))
  add(query_589650, "alt", newJString(alt))
  add(path_589649, "country", newJString(country))
  add(query_589650, "oauth_token", newJString(oauthToken))
  add(path_589649, "accountId", newJString(accountId))
  add(query_589650, "userIp", newJString(userIp))
  add(query_589650, "key", newJString(key))
  add(path_589649, "merchantId", newJString(merchantId))
  add(query_589650, "prettyPrint", newJBool(prettyPrint))
  result = call_589648.call(path_589649, query_589650, nil, nil, nil)

var contentLiasettingsRequestinventoryverification* = Call_ContentLiasettingsRequestinventoryverification_589634(
    name: "contentLiasettingsRequestinventoryverification",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}/requestinventoryverification/{country}",
    validator: validate_ContentLiasettingsRequestinventoryverification_589635,
    base: "/content/v2.1",
    url: url_ContentLiasettingsRequestinventoryverification_589636,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsSetinventoryverificationcontact_589651 = ref object of OpenApiRestCall_588450
proc url_ContentLiasettingsSetinventoryverificationcontact_589653(
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

proc validate_ContentLiasettingsSetinventoryverificationcontact_589652(
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
  var valid_589654 = path.getOrDefault("accountId")
  valid_589654 = validateParameter(valid_589654, JString, required = true,
                                 default = nil)
  if valid_589654 != nil:
    section.add "accountId", valid_589654
  var valid_589655 = path.getOrDefault("merchantId")
  valid_589655 = validateParameter(valid_589655, JString, required = true,
                                 default = nil)
  if valid_589655 != nil:
    section.add "merchantId", valid_589655
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
  var valid_589656 = query.getOrDefault("fields")
  valid_589656 = validateParameter(valid_589656, JString, required = false,
                                 default = nil)
  if valid_589656 != nil:
    section.add "fields", valid_589656
  assert query != nil, "query argument is necessary due to required `country` field"
  var valid_589657 = query.getOrDefault("country")
  valid_589657 = validateParameter(valid_589657, JString, required = true,
                                 default = nil)
  if valid_589657 != nil:
    section.add "country", valid_589657
  var valid_589658 = query.getOrDefault("quotaUser")
  valid_589658 = validateParameter(valid_589658, JString, required = false,
                                 default = nil)
  if valid_589658 != nil:
    section.add "quotaUser", valid_589658
  var valid_589659 = query.getOrDefault("alt")
  valid_589659 = validateParameter(valid_589659, JString, required = false,
                                 default = newJString("json"))
  if valid_589659 != nil:
    section.add "alt", valid_589659
  var valid_589660 = query.getOrDefault("contactName")
  valid_589660 = validateParameter(valid_589660, JString, required = true,
                                 default = nil)
  if valid_589660 != nil:
    section.add "contactName", valid_589660
  var valid_589661 = query.getOrDefault("language")
  valid_589661 = validateParameter(valid_589661, JString, required = true,
                                 default = nil)
  if valid_589661 != nil:
    section.add "language", valid_589661
  var valid_589662 = query.getOrDefault("oauth_token")
  valid_589662 = validateParameter(valid_589662, JString, required = false,
                                 default = nil)
  if valid_589662 != nil:
    section.add "oauth_token", valid_589662
  var valid_589663 = query.getOrDefault("userIp")
  valid_589663 = validateParameter(valid_589663, JString, required = false,
                                 default = nil)
  if valid_589663 != nil:
    section.add "userIp", valid_589663
  var valid_589664 = query.getOrDefault("key")
  valid_589664 = validateParameter(valid_589664, JString, required = false,
                                 default = nil)
  if valid_589664 != nil:
    section.add "key", valid_589664
  var valid_589665 = query.getOrDefault("prettyPrint")
  valid_589665 = validateParameter(valid_589665, JBool, required = false,
                                 default = newJBool(true))
  if valid_589665 != nil:
    section.add "prettyPrint", valid_589665
  var valid_589666 = query.getOrDefault("contactEmail")
  valid_589666 = validateParameter(valid_589666, JString, required = true,
                                 default = nil)
  if valid_589666 != nil:
    section.add "contactEmail", valid_589666
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589667: Call_ContentLiasettingsSetinventoryverificationcontact_589651;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the inventory verification contract for the specified country.
  ## 
  let valid = call_589667.validator(path, query, header, formData, body)
  let scheme = call_589667.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589667.url(scheme.get, call_589667.host, call_589667.base,
                         call_589667.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589667, url, valid)

proc call*(call_589668: Call_ContentLiasettingsSetinventoryverificationcontact_589651;
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
  var path_589669 = newJObject()
  var query_589670 = newJObject()
  add(query_589670, "fields", newJString(fields))
  add(query_589670, "country", newJString(country))
  add(query_589670, "quotaUser", newJString(quotaUser))
  add(query_589670, "alt", newJString(alt))
  add(query_589670, "contactName", newJString(contactName))
  add(query_589670, "language", newJString(language))
  add(query_589670, "oauth_token", newJString(oauthToken))
  add(path_589669, "accountId", newJString(accountId))
  add(query_589670, "userIp", newJString(userIp))
  add(query_589670, "key", newJString(key))
  add(path_589669, "merchantId", newJString(merchantId))
  add(query_589670, "prettyPrint", newJBool(prettyPrint))
  add(query_589670, "contactEmail", newJString(contactEmail))
  result = call_589668.call(path_589669, query_589670, nil, nil, nil)

var contentLiasettingsSetinventoryverificationcontact* = Call_ContentLiasettingsSetinventoryverificationcontact_589651(
    name: "contentLiasettingsSetinventoryverificationcontact",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}/setinventoryverificationcontact",
    validator: validate_ContentLiasettingsSetinventoryverificationcontact_589652,
    base: "/content/v2.1",
    url: url_ContentLiasettingsSetinventoryverificationcontact_589653,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsSetposdataprovider_589671 = ref object of OpenApiRestCall_588450
proc url_ContentLiasettingsSetposdataprovider_589673(protocol: Scheme;
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

proc validate_ContentLiasettingsSetposdataprovider_589672(path: JsonNode;
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
  var valid_589674 = path.getOrDefault("accountId")
  valid_589674 = validateParameter(valid_589674, JString, required = true,
                                 default = nil)
  if valid_589674 != nil:
    section.add "accountId", valid_589674
  var valid_589675 = path.getOrDefault("merchantId")
  valid_589675 = validateParameter(valid_589675, JString, required = true,
                                 default = nil)
  if valid_589675 != nil:
    section.add "merchantId", valid_589675
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
  var valid_589676 = query.getOrDefault("fields")
  valid_589676 = validateParameter(valid_589676, JString, required = false,
                                 default = nil)
  if valid_589676 != nil:
    section.add "fields", valid_589676
  assert query != nil, "query argument is necessary due to required `country` field"
  var valid_589677 = query.getOrDefault("country")
  valid_589677 = validateParameter(valid_589677, JString, required = true,
                                 default = nil)
  if valid_589677 != nil:
    section.add "country", valid_589677
  var valid_589678 = query.getOrDefault("quotaUser")
  valid_589678 = validateParameter(valid_589678, JString, required = false,
                                 default = nil)
  if valid_589678 != nil:
    section.add "quotaUser", valid_589678
  var valid_589679 = query.getOrDefault("alt")
  valid_589679 = validateParameter(valid_589679, JString, required = false,
                                 default = newJString("json"))
  if valid_589679 != nil:
    section.add "alt", valid_589679
  var valid_589680 = query.getOrDefault("oauth_token")
  valid_589680 = validateParameter(valid_589680, JString, required = false,
                                 default = nil)
  if valid_589680 != nil:
    section.add "oauth_token", valid_589680
  var valid_589681 = query.getOrDefault("userIp")
  valid_589681 = validateParameter(valid_589681, JString, required = false,
                                 default = nil)
  if valid_589681 != nil:
    section.add "userIp", valid_589681
  var valid_589682 = query.getOrDefault("posExternalAccountId")
  valid_589682 = validateParameter(valid_589682, JString, required = false,
                                 default = nil)
  if valid_589682 != nil:
    section.add "posExternalAccountId", valid_589682
  var valid_589683 = query.getOrDefault("key")
  valid_589683 = validateParameter(valid_589683, JString, required = false,
                                 default = nil)
  if valid_589683 != nil:
    section.add "key", valid_589683
  var valid_589684 = query.getOrDefault("posDataProviderId")
  valid_589684 = validateParameter(valid_589684, JString, required = false,
                                 default = nil)
  if valid_589684 != nil:
    section.add "posDataProviderId", valid_589684
  var valid_589685 = query.getOrDefault("prettyPrint")
  valid_589685 = validateParameter(valid_589685, JBool, required = false,
                                 default = newJBool(true))
  if valid_589685 != nil:
    section.add "prettyPrint", valid_589685
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589686: Call_ContentLiasettingsSetposdataprovider_589671;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the POS data provider for the specified country.
  ## 
  let valid = call_589686.validator(path, query, header, formData, body)
  let scheme = call_589686.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589686.url(scheme.get, call_589686.host, call_589686.base,
                         call_589686.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589686, url, valid)

proc call*(call_589687: Call_ContentLiasettingsSetposdataprovider_589671;
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
  var path_589688 = newJObject()
  var query_589689 = newJObject()
  add(query_589689, "fields", newJString(fields))
  add(query_589689, "country", newJString(country))
  add(query_589689, "quotaUser", newJString(quotaUser))
  add(query_589689, "alt", newJString(alt))
  add(query_589689, "oauth_token", newJString(oauthToken))
  add(path_589688, "accountId", newJString(accountId))
  add(query_589689, "userIp", newJString(userIp))
  add(query_589689, "posExternalAccountId", newJString(posExternalAccountId))
  add(query_589689, "key", newJString(key))
  add(query_589689, "posDataProviderId", newJString(posDataProviderId))
  add(path_589688, "merchantId", newJString(merchantId))
  add(query_589689, "prettyPrint", newJBool(prettyPrint))
  result = call_589687.call(path_589688, query_589689, nil, nil, nil)

var contentLiasettingsSetposdataprovider* = Call_ContentLiasettingsSetposdataprovider_589671(
    name: "contentLiasettingsSetposdataprovider", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/setposdataprovider",
    validator: validate_ContentLiasettingsSetposdataprovider_589672,
    base: "/content/v2.1", url: url_ContentLiasettingsSetposdataprovider_589673,
    schemes: {Scheme.Https})
type
  Call_ContentOrderinvoicesCreatechargeinvoice_589690 = ref object of OpenApiRestCall_588450
proc url_ContentOrderinvoicesCreatechargeinvoice_589692(protocol: Scheme;
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

proc validate_ContentOrderinvoicesCreatechargeinvoice_589691(path: JsonNode;
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
  var valid_589693 = path.getOrDefault("orderId")
  valid_589693 = validateParameter(valid_589693, JString, required = true,
                                 default = nil)
  if valid_589693 != nil:
    section.add "orderId", valid_589693
  var valid_589694 = path.getOrDefault("merchantId")
  valid_589694 = validateParameter(valid_589694, JString, required = true,
                                 default = nil)
  if valid_589694 != nil:
    section.add "merchantId", valid_589694
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589695 = query.getOrDefault("fields")
  valid_589695 = validateParameter(valid_589695, JString, required = false,
                                 default = nil)
  if valid_589695 != nil:
    section.add "fields", valid_589695
  var valid_589696 = query.getOrDefault("quotaUser")
  valid_589696 = validateParameter(valid_589696, JString, required = false,
                                 default = nil)
  if valid_589696 != nil:
    section.add "quotaUser", valid_589696
  var valid_589697 = query.getOrDefault("alt")
  valid_589697 = validateParameter(valid_589697, JString, required = false,
                                 default = newJString("json"))
  if valid_589697 != nil:
    section.add "alt", valid_589697
  var valid_589698 = query.getOrDefault("oauth_token")
  valid_589698 = validateParameter(valid_589698, JString, required = false,
                                 default = nil)
  if valid_589698 != nil:
    section.add "oauth_token", valid_589698
  var valid_589699 = query.getOrDefault("userIp")
  valid_589699 = validateParameter(valid_589699, JString, required = false,
                                 default = nil)
  if valid_589699 != nil:
    section.add "userIp", valid_589699
  var valid_589700 = query.getOrDefault("key")
  valid_589700 = validateParameter(valid_589700, JString, required = false,
                                 default = nil)
  if valid_589700 != nil:
    section.add "key", valid_589700
  var valid_589701 = query.getOrDefault("prettyPrint")
  valid_589701 = validateParameter(valid_589701, JBool, required = false,
                                 default = newJBool(true))
  if valid_589701 != nil:
    section.add "prettyPrint", valid_589701
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589703: Call_ContentOrderinvoicesCreatechargeinvoice_589690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a charge invoice for a shipment group, and triggers a charge capture for orderinvoice enabled orders.
  ## 
  let valid = call_589703.validator(path, query, header, formData, body)
  let scheme = call_589703.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589703.url(scheme.get, call_589703.host, call_589703.base,
                         call_589703.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589703, url, valid)

proc call*(call_589704: Call_ContentOrderinvoicesCreatechargeinvoice_589690;
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
  var path_589705 = newJObject()
  var query_589706 = newJObject()
  var body_589707 = newJObject()
  add(query_589706, "fields", newJString(fields))
  add(query_589706, "quotaUser", newJString(quotaUser))
  add(query_589706, "alt", newJString(alt))
  add(query_589706, "oauth_token", newJString(oauthToken))
  add(query_589706, "userIp", newJString(userIp))
  add(path_589705, "orderId", newJString(orderId))
  add(query_589706, "key", newJString(key))
  add(path_589705, "merchantId", newJString(merchantId))
  if body != nil:
    body_589707 = body
  add(query_589706, "prettyPrint", newJBool(prettyPrint))
  result = call_589704.call(path_589705, query_589706, nil, nil, body_589707)

var contentOrderinvoicesCreatechargeinvoice* = Call_ContentOrderinvoicesCreatechargeinvoice_589690(
    name: "contentOrderinvoicesCreatechargeinvoice", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderinvoices/{orderId}/createChargeInvoice",
    validator: validate_ContentOrderinvoicesCreatechargeinvoice_589691,
    base: "/content/v2.1", url: url_ContentOrderinvoicesCreatechargeinvoice_589692,
    schemes: {Scheme.Https})
type
  Call_ContentOrderinvoicesCreaterefundinvoice_589708 = ref object of OpenApiRestCall_588450
proc url_ContentOrderinvoicesCreaterefundinvoice_589710(protocol: Scheme;
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

proc validate_ContentOrderinvoicesCreaterefundinvoice_589709(path: JsonNode;
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
  var valid_589711 = path.getOrDefault("orderId")
  valid_589711 = validateParameter(valid_589711, JString, required = true,
                                 default = nil)
  if valid_589711 != nil:
    section.add "orderId", valid_589711
  var valid_589712 = path.getOrDefault("merchantId")
  valid_589712 = validateParameter(valid_589712, JString, required = true,
                                 default = nil)
  if valid_589712 != nil:
    section.add "merchantId", valid_589712
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589713 = query.getOrDefault("fields")
  valid_589713 = validateParameter(valid_589713, JString, required = false,
                                 default = nil)
  if valid_589713 != nil:
    section.add "fields", valid_589713
  var valid_589714 = query.getOrDefault("quotaUser")
  valid_589714 = validateParameter(valid_589714, JString, required = false,
                                 default = nil)
  if valid_589714 != nil:
    section.add "quotaUser", valid_589714
  var valid_589715 = query.getOrDefault("alt")
  valid_589715 = validateParameter(valid_589715, JString, required = false,
                                 default = newJString("json"))
  if valid_589715 != nil:
    section.add "alt", valid_589715
  var valid_589716 = query.getOrDefault("oauth_token")
  valid_589716 = validateParameter(valid_589716, JString, required = false,
                                 default = nil)
  if valid_589716 != nil:
    section.add "oauth_token", valid_589716
  var valid_589717 = query.getOrDefault("userIp")
  valid_589717 = validateParameter(valid_589717, JString, required = false,
                                 default = nil)
  if valid_589717 != nil:
    section.add "userIp", valid_589717
  var valid_589718 = query.getOrDefault("key")
  valid_589718 = validateParameter(valid_589718, JString, required = false,
                                 default = nil)
  if valid_589718 != nil:
    section.add "key", valid_589718
  var valid_589719 = query.getOrDefault("prettyPrint")
  valid_589719 = validateParameter(valid_589719, JBool, required = false,
                                 default = newJBool(true))
  if valid_589719 != nil:
    section.add "prettyPrint", valid_589719
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589721: Call_ContentOrderinvoicesCreaterefundinvoice_589708;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a refund invoice for one or more shipment groups, and triggers a refund for orderinvoice enabled orders. This can only be used for line items that have previously been charged using createChargeInvoice. All amounts (except for the summary) are incremental with respect to the previous invoice.
  ## 
  let valid = call_589721.validator(path, query, header, formData, body)
  let scheme = call_589721.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589721.url(scheme.get, call_589721.host, call_589721.base,
                         call_589721.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589721, url, valid)

proc call*(call_589722: Call_ContentOrderinvoicesCreaterefundinvoice_589708;
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
  var path_589723 = newJObject()
  var query_589724 = newJObject()
  var body_589725 = newJObject()
  add(query_589724, "fields", newJString(fields))
  add(query_589724, "quotaUser", newJString(quotaUser))
  add(query_589724, "alt", newJString(alt))
  add(query_589724, "oauth_token", newJString(oauthToken))
  add(query_589724, "userIp", newJString(userIp))
  add(path_589723, "orderId", newJString(orderId))
  add(query_589724, "key", newJString(key))
  add(path_589723, "merchantId", newJString(merchantId))
  if body != nil:
    body_589725 = body
  add(query_589724, "prettyPrint", newJBool(prettyPrint))
  result = call_589722.call(path_589723, query_589724, nil, nil, body_589725)

var contentOrderinvoicesCreaterefundinvoice* = Call_ContentOrderinvoicesCreaterefundinvoice_589708(
    name: "contentOrderinvoicesCreaterefundinvoice", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderinvoices/{orderId}/createRefundInvoice",
    validator: validate_ContentOrderinvoicesCreaterefundinvoice_589709,
    base: "/content/v2.1", url: url_ContentOrderinvoicesCreaterefundinvoice_589710,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreportsListdisbursements_589726 = ref object of OpenApiRestCall_588450
proc url_ContentOrderreportsListdisbursements_589728(protocol: Scheme;
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

proc validate_ContentOrderreportsListdisbursements_589727(path: JsonNode;
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
  var valid_589729 = path.getOrDefault("merchantId")
  valid_589729 = validateParameter(valid_589729, JString, required = true,
                                 default = nil)
  if valid_589729 != nil:
    section.add "merchantId", valid_589729
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
  var valid_589730 = query.getOrDefault("fields")
  valid_589730 = validateParameter(valid_589730, JString, required = false,
                                 default = nil)
  if valid_589730 != nil:
    section.add "fields", valid_589730
  var valid_589731 = query.getOrDefault("pageToken")
  valid_589731 = validateParameter(valid_589731, JString, required = false,
                                 default = nil)
  if valid_589731 != nil:
    section.add "pageToken", valid_589731
  var valid_589732 = query.getOrDefault("quotaUser")
  valid_589732 = validateParameter(valid_589732, JString, required = false,
                                 default = nil)
  if valid_589732 != nil:
    section.add "quotaUser", valid_589732
  var valid_589733 = query.getOrDefault("alt")
  valid_589733 = validateParameter(valid_589733, JString, required = false,
                                 default = newJString("json"))
  if valid_589733 != nil:
    section.add "alt", valid_589733
  var valid_589734 = query.getOrDefault("oauth_token")
  valid_589734 = validateParameter(valid_589734, JString, required = false,
                                 default = nil)
  if valid_589734 != nil:
    section.add "oauth_token", valid_589734
  var valid_589735 = query.getOrDefault("userIp")
  valid_589735 = validateParameter(valid_589735, JString, required = false,
                                 default = nil)
  if valid_589735 != nil:
    section.add "userIp", valid_589735
  var valid_589736 = query.getOrDefault("maxResults")
  valid_589736 = validateParameter(valid_589736, JInt, required = false, default = nil)
  if valid_589736 != nil:
    section.add "maxResults", valid_589736
  var valid_589737 = query.getOrDefault("key")
  valid_589737 = validateParameter(valid_589737, JString, required = false,
                                 default = nil)
  if valid_589737 != nil:
    section.add "key", valid_589737
  var valid_589738 = query.getOrDefault("prettyPrint")
  valid_589738 = validateParameter(valid_589738, JBool, required = false,
                                 default = newJBool(true))
  if valid_589738 != nil:
    section.add "prettyPrint", valid_589738
  assert query != nil, "query argument is necessary due to required `disbursementStartDate` field"
  var valid_589739 = query.getOrDefault("disbursementStartDate")
  valid_589739 = validateParameter(valid_589739, JString, required = true,
                                 default = nil)
  if valid_589739 != nil:
    section.add "disbursementStartDate", valid_589739
  var valid_589740 = query.getOrDefault("disbursementEndDate")
  valid_589740 = validateParameter(valid_589740, JString, required = false,
                                 default = nil)
  if valid_589740 != nil:
    section.add "disbursementEndDate", valid_589740
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589741: Call_ContentOrderreportsListdisbursements_589726;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a report for disbursements from your Merchant Center account.
  ## 
  let valid = call_589741.validator(path, query, header, formData, body)
  let scheme = call_589741.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589741.url(scheme.get, call_589741.host, call_589741.base,
                         call_589741.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589741, url, valid)

proc call*(call_589742: Call_ContentOrderreportsListdisbursements_589726;
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
  var path_589743 = newJObject()
  var query_589744 = newJObject()
  add(query_589744, "fields", newJString(fields))
  add(query_589744, "pageToken", newJString(pageToken))
  add(query_589744, "quotaUser", newJString(quotaUser))
  add(query_589744, "alt", newJString(alt))
  add(query_589744, "oauth_token", newJString(oauthToken))
  add(query_589744, "userIp", newJString(userIp))
  add(query_589744, "maxResults", newJInt(maxResults))
  add(query_589744, "key", newJString(key))
  add(path_589743, "merchantId", newJString(merchantId))
  add(query_589744, "prettyPrint", newJBool(prettyPrint))
  add(query_589744, "disbursementStartDate", newJString(disbursementStartDate))
  add(query_589744, "disbursementEndDate", newJString(disbursementEndDate))
  result = call_589742.call(path_589743, query_589744, nil, nil, nil)

var contentOrderreportsListdisbursements* = Call_ContentOrderreportsListdisbursements_589726(
    name: "contentOrderreportsListdisbursements", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreports/disbursements",
    validator: validate_ContentOrderreportsListdisbursements_589727,
    base: "/content/v2.1", url: url_ContentOrderreportsListdisbursements_589728,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreportsListtransactions_589745 = ref object of OpenApiRestCall_588450
proc url_ContentOrderreportsListtransactions_589747(protocol: Scheme; host: string;
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

proc validate_ContentOrderreportsListtransactions_589746(path: JsonNode;
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
  var valid_589748 = path.getOrDefault("merchantId")
  valid_589748 = validateParameter(valid_589748, JString, required = true,
                                 default = nil)
  if valid_589748 != nil:
    section.add "merchantId", valid_589748
  var valid_589749 = path.getOrDefault("disbursementId")
  valid_589749 = validateParameter(valid_589749, JString, required = true,
                                 default = nil)
  if valid_589749 != nil:
    section.add "disbursementId", valid_589749
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
  var valid_589750 = query.getOrDefault("fields")
  valid_589750 = validateParameter(valid_589750, JString, required = false,
                                 default = nil)
  if valid_589750 != nil:
    section.add "fields", valid_589750
  var valid_589751 = query.getOrDefault("pageToken")
  valid_589751 = validateParameter(valid_589751, JString, required = false,
                                 default = nil)
  if valid_589751 != nil:
    section.add "pageToken", valid_589751
  var valid_589752 = query.getOrDefault("quotaUser")
  valid_589752 = validateParameter(valid_589752, JString, required = false,
                                 default = nil)
  if valid_589752 != nil:
    section.add "quotaUser", valid_589752
  var valid_589753 = query.getOrDefault("alt")
  valid_589753 = validateParameter(valid_589753, JString, required = false,
                                 default = newJString("json"))
  if valid_589753 != nil:
    section.add "alt", valid_589753
  var valid_589754 = query.getOrDefault("transactionEndDate")
  valid_589754 = validateParameter(valid_589754, JString, required = false,
                                 default = nil)
  if valid_589754 != nil:
    section.add "transactionEndDate", valid_589754
  var valid_589755 = query.getOrDefault("oauth_token")
  valid_589755 = validateParameter(valid_589755, JString, required = false,
                                 default = nil)
  if valid_589755 != nil:
    section.add "oauth_token", valid_589755
  var valid_589756 = query.getOrDefault("userIp")
  valid_589756 = validateParameter(valid_589756, JString, required = false,
                                 default = nil)
  if valid_589756 != nil:
    section.add "userIp", valid_589756
  var valid_589757 = query.getOrDefault("maxResults")
  valid_589757 = validateParameter(valid_589757, JInt, required = false, default = nil)
  if valid_589757 != nil:
    section.add "maxResults", valid_589757
  assert query != nil, "query argument is necessary due to required `transactionStartDate` field"
  var valid_589758 = query.getOrDefault("transactionStartDate")
  valid_589758 = validateParameter(valid_589758, JString, required = true,
                                 default = nil)
  if valid_589758 != nil:
    section.add "transactionStartDate", valid_589758
  var valid_589759 = query.getOrDefault("key")
  valid_589759 = validateParameter(valid_589759, JString, required = false,
                                 default = nil)
  if valid_589759 != nil:
    section.add "key", valid_589759
  var valid_589760 = query.getOrDefault("prettyPrint")
  valid_589760 = validateParameter(valid_589760, JBool, required = false,
                                 default = newJBool(true))
  if valid_589760 != nil:
    section.add "prettyPrint", valid_589760
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589761: Call_ContentOrderreportsListtransactions_589745;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of transactions for a disbursement from your Merchant Center account.
  ## 
  let valid = call_589761.validator(path, query, header, formData, body)
  let scheme = call_589761.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589761.url(scheme.get, call_589761.host, call_589761.base,
                         call_589761.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589761, url, valid)

proc call*(call_589762: Call_ContentOrderreportsListtransactions_589745;
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
  var path_589763 = newJObject()
  var query_589764 = newJObject()
  add(query_589764, "fields", newJString(fields))
  add(query_589764, "pageToken", newJString(pageToken))
  add(query_589764, "quotaUser", newJString(quotaUser))
  add(query_589764, "alt", newJString(alt))
  add(query_589764, "transactionEndDate", newJString(transactionEndDate))
  add(query_589764, "oauth_token", newJString(oauthToken))
  add(query_589764, "userIp", newJString(userIp))
  add(query_589764, "maxResults", newJInt(maxResults))
  add(query_589764, "transactionStartDate", newJString(transactionStartDate))
  add(query_589764, "key", newJString(key))
  add(path_589763, "merchantId", newJString(merchantId))
  add(path_589763, "disbursementId", newJString(disbursementId))
  add(query_589764, "prettyPrint", newJBool(prettyPrint))
  result = call_589762.call(path_589763, query_589764, nil, nil, nil)

var contentOrderreportsListtransactions* = Call_ContentOrderreportsListtransactions_589745(
    name: "contentOrderreportsListtransactions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreports/disbursements/{disbursementId}/transactions",
    validator: validate_ContentOrderreportsListtransactions_589746,
    base: "/content/v2.1", url: url_ContentOrderreportsListtransactions_589747,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreturnsList_589765 = ref object of OpenApiRestCall_588450
proc url_ContentOrderreturnsList_589767(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrderreturnsList_589766(path: JsonNode; query: JsonNode;
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
  var valid_589768 = path.getOrDefault("merchantId")
  valid_589768 = validateParameter(valid_589768, JString, required = true,
                                 default = nil)
  if valid_589768 != nil:
    section.add "merchantId", valid_589768
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
  var valid_589769 = query.getOrDefault("fields")
  valid_589769 = validateParameter(valid_589769, JString, required = false,
                                 default = nil)
  if valid_589769 != nil:
    section.add "fields", valid_589769
  var valid_589770 = query.getOrDefault("pageToken")
  valid_589770 = validateParameter(valid_589770, JString, required = false,
                                 default = nil)
  if valid_589770 != nil:
    section.add "pageToken", valid_589770
  var valid_589771 = query.getOrDefault("quotaUser")
  valid_589771 = validateParameter(valid_589771, JString, required = false,
                                 default = nil)
  if valid_589771 != nil:
    section.add "quotaUser", valid_589771
  var valid_589772 = query.getOrDefault("alt")
  valid_589772 = validateParameter(valid_589772, JString, required = false,
                                 default = newJString("json"))
  if valid_589772 != nil:
    section.add "alt", valid_589772
  var valid_589773 = query.getOrDefault("oauth_token")
  valid_589773 = validateParameter(valid_589773, JString, required = false,
                                 default = nil)
  if valid_589773 != nil:
    section.add "oauth_token", valid_589773
  var valid_589774 = query.getOrDefault("userIp")
  valid_589774 = validateParameter(valid_589774, JString, required = false,
                                 default = nil)
  if valid_589774 != nil:
    section.add "userIp", valid_589774
  var valid_589775 = query.getOrDefault("maxResults")
  valid_589775 = validateParameter(valid_589775, JInt, required = false, default = nil)
  if valid_589775 != nil:
    section.add "maxResults", valid_589775
  var valid_589776 = query.getOrDefault("orderBy")
  valid_589776 = validateParameter(valid_589776, JString, required = false,
                                 default = newJString("returnCreationTimeAsc"))
  if valid_589776 != nil:
    section.add "orderBy", valid_589776
  var valid_589777 = query.getOrDefault("key")
  valid_589777 = validateParameter(valid_589777, JString, required = false,
                                 default = nil)
  if valid_589777 != nil:
    section.add "key", valid_589777
  var valid_589778 = query.getOrDefault("createdEndDate")
  valid_589778 = validateParameter(valid_589778, JString, required = false,
                                 default = nil)
  if valid_589778 != nil:
    section.add "createdEndDate", valid_589778
  var valid_589779 = query.getOrDefault("prettyPrint")
  valid_589779 = validateParameter(valid_589779, JBool, required = false,
                                 default = newJBool(true))
  if valid_589779 != nil:
    section.add "prettyPrint", valid_589779
  var valid_589780 = query.getOrDefault("createdStartDate")
  valid_589780 = validateParameter(valid_589780, JString, required = false,
                                 default = nil)
  if valid_589780 != nil:
    section.add "createdStartDate", valid_589780
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589781: Call_ContentOrderreturnsList_589765; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists order returns in your Merchant Center account.
  ## 
  let valid = call_589781.validator(path, query, header, formData, body)
  let scheme = call_589781.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589781.url(scheme.get, call_589781.host, call_589781.base,
                         call_589781.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589781, url, valid)

proc call*(call_589782: Call_ContentOrderreturnsList_589765; merchantId: string;
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
  var path_589783 = newJObject()
  var query_589784 = newJObject()
  add(query_589784, "fields", newJString(fields))
  add(query_589784, "pageToken", newJString(pageToken))
  add(query_589784, "quotaUser", newJString(quotaUser))
  add(query_589784, "alt", newJString(alt))
  add(query_589784, "oauth_token", newJString(oauthToken))
  add(query_589784, "userIp", newJString(userIp))
  add(query_589784, "maxResults", newJInt(maxResults))
  add(query_589784, "orderBy", newJString(orderBy))
  add(query_589784, "key", newJString(key))
  add(query_589784, "createdEndDate", newJString(createdEndDate))
  add(path_589783, "merchantId", newJString(merchantId))
  add(query_589784, "prettyPrint", newJBool(prettyPrint))
  add(query_589784, "createdStartDate", newJString(createdStartDate))
  result = call_589782.call(path_589783, query_589784, nil, nil, nil)

var contentOrderreturnsList* = Call_ContentOrderreturnsList_589765(
    name: "contentOrderreturnsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreturns",
    validator: validate_ContentOrderreturnsList_589766, base: "/content/v2.1",
    url: url_ContentOrderreturnsList_589767, schemes: {Scheme.Https})
type
  Call_ContentOrderreturnsGet_589785 = ref object of OpenApiRestCall_588450
proc url_ContentOrderreturnsGet_589787(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrderreturnsGet_589786(path: JsonNode; query: JsonNode;
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
  var valid_589788 = path.getOrDefault("returnId")
  valid_589788 = validateParameter(valid_589788, JString, required = true,
                                 default = nil)
  if valid_589788 != nil:
    section.add "returnId", valid_589788
  var valid_589789 = path.getOrDefault("merchantId")
  valid_589789 = validateParameter(valid_589789, JString, required = true,
                                 default = nil)
  if valid_589789 != nil:
    section.add "merchantId", valid_589789
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589790 = query.getOrDefault("fields")
  valid_589790 = validateParameter(valid_589790, JString, required = false,
                                 default = nil)
  if valid_589790 != nil:
    section.add "fields", valid_589790
  var valid_589791 = query.getOrDefault("quotaUser")
  valid_589791 = validateParameter(valid_589791, JString, required = false,
                                 default = nil)
  if valid_589791 != nil:
    section.add "quotaUser", valid_589791
  var valid_589792 = query.getOrDefault("alt")
  valid_589792 = validateParameter(valid_589792, JString, required = false,
                                 default = newJString("json"))
  if valid_589792 != nil:
    section.add "alt", valid_589792
  var valid_589793 = query.getOrDefault("oauth_token")
  valid_589793 = validateParameter(valid_589793, JString, required = false,
                                 default = nil)
  if valid_589793 != nil:
    section.add "oauth_token", valid_589793
  var valid_589794 = query.getOrDefault("userIp")
  valid_589794 = validateParameter(valid_589794, JString, required = false,
                                 default = nil)
  if valid_589794 != nil:
    section.add "userIp", valid_589794
  var valid_589795 = query.getOrDefault("key")
  valid_589795 = validateParameter(valid_589795, JString, required = false,
                                 default = nil)
  if valid_589795 != nil:
    section.add "key", valid_589795
  var valid_589796 = query.getOrDefault("prettyPrint")
  valid_589796 = validateParameter(valid_589796, JBool, required = false,
                                 default = newJBool(true))
  if valid_589796 != nil:
    section.add "prettyPrint", valid_589796
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589797: Call_ContentOrderreturnsGet_589785; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an order return from your Merchant Center account.
  ## 
  let valid = call_589797.validator(path, query, header, formData, body)
  let scheme = call_589797.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589797.url(scheme.get, call_589797.host, call_589797.base,
                         call_589797.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589797, url, valid)

proc call*(call_589798: Call_ContentOrderreturnsGet_589785; returnId: string;
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
  var path_589799 = newJObject()
  var query_589800 = newJObject()
  add(query_589800, "fields", newJString(fields))
  add(query_589800, "quotaUser", newJString(quotaUser))
  add(path_589799, "returnId", newJString(returnId))
  add(query_589800, "alt", newJString(alt))
  add(query_589800, "oauth_token", newJString(oauthToken))
  add(query_589800, "userIp", newJString(userIp))
  add(query_589800, "key", newJString(key))
  add(path_589799, "merchantId", newJString(merchantId))
  add(query_589800, "prettyPrint", newJBool(prettyPrint))
  result = call_589798.call(path_589799, query_589800, nil, nil, nil)

var contentOrderreturnsGet* = Call_ContentOrderreturnsGet_589785(
    name: "contentOrderreturnsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreturns/{returnId}",
    validator: validate_ContentOrderreturnsGet_589786, base: "/content/v2.1",
    url: url_ContentOrderreturnsGet_589787, schemes: {Scheme.Https})
type
  Call_ContentOrdersList_589801 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersList_589803(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrdersList_589802(path: JsonNode; query: JsonNode;
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
  var valid_589804 = path.getOrDefault("merchantId")
  valid_589804 = validateParameter(valid_589804, JString, required = true,
                                 default = nil)
  if valid_589804 != nil:
    section.add "merchantId", valid_589804
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
  var valid_589805 = query.getOrDefault("fields")
  valid_589805 = validateParameter(valid_589805, JString, required = false,
                                 default = nil)
  if valid_589805 != nil:
    section.add "fields", valid_589805
  var valid_589806 = query.getOrDefault("pageToken")
  valid_589806 = validateParameter(valid_589806, JString, required = false,
                                 default = nil)
  if valid_589806 != nil:
    section.add "pageToken", valid_589806
  var valid_589807 = query.getOrDefault("quotaUser")
  valid_589807 = validateParameter(valid_589807, JString, required = false,
                                 default = nil)
  if valid_589807 != nil:
    section.add "quotaUser", valid_589807
  var valid_589808 = query.getOrDefault("alt")
  valid_589808 = validateParameter(valid_589808, JString, required = false,
                                 default = newJString("json"))
  if valid_589808 != nil:
    section.add "alt", valid_589808
  var valid_589809 = query.getOrDefault("placedDateStart")
  valid_589809 = validateParameter(valid_589809, JString, required = false,
                                 default = nil)
  if valid_589809 != nil:
    section.add "placedDateStart", valid_589809
  var valid_589810 = query.getOrDefault("oauth_token")
  valid_589810 = validateParameter(valid_589810, JString, required = false,
                                 default = nil)
  if valid_589810 != nil:
    section.add "oauth_token", valid_589810
  var valid_589811 = query.getOrDefault("userIp")
  valid_589811 = validateParameter(valid_589811, JString, required = false,
                                 default = nil)
  if valid_589811 != nil:
    section.add "userIp", valid_589811
  var valid_589812 = query.getOrDefault("maxResults")
  valid_589812 = validateParameter(valid_589812, JInt, required = false, default = nil)
  if valid_589812 != nil:
    section.add "maxResults", valid_589812
  var valid_589813 = query.getOrDefault("orderBy")
  valid_589813 = validateParameter(valid_589813, JString, required = false,
                                 default = nil)
  if valid_589813 != nil:
    section.add "orderBy", valid_589813
  var valid_589814 = query.getOrDefault("placedDateEnd")
  valid_589814 = validateParameter(valid_589814, JString, required = false,
                                 default = nil)
  if valid_589814 != nil:
    section.add "placedDateEnd", valid_589814
  var valid_589815 = query.getOrDefault("key")
  valid_589815 = validateParameter(valid_589815, JString, required = false,
                                 default = nil)
  if valid_589815 != nil:
    section.add "key", valid_589815
  var valid_589816 = query.getOrDefault("acknowledged")
  valid_589816 = validateParameter(valid_589816, JBool, required = false, default = nil)
  if valid_589816 != nil:
    section.add "acknowledged", valid_589816
  var valid_589817 = query.getOrDefault("prettyPrint")
  valid_589817 = validateParameter(valid_589817, JBool, required = false,
                                 default = newJBool(true))
  if valid_589817 != nil:
    section.add "prettyPrint", valid_589817
  var valid_589818 = query.getOrDefault("statuses")
  valid_589818 = validateParameter(valid_589818, JArray, required = false,
                                 default = nil)
  if valid_589818 != nil:
    section.add "statuses", valid_589818
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589819: Call_ContentOrdersList_589801; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the orders in your Merchant Center account.
  ## 
  let valid = call_589819.validator(path, query, header, formData, body)
  let scheme = call_589819.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589819.url(scheme.get, call_589819.host, call_589819.base,
                         call_589819.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589819, url, valid)

proc call*(call_589820: Call_ContentOrdersList_589801; merchantId: string;
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
  var path_589821 = newJObject()
  var query_589822 = newJObject()
  add(query_589822, "fields", newJString(fields))
  add(query_589822, "pageToken", newJString(pageToken))
  add(query_589822, "quotaUser", newJString(quotaUser))
  add(query_589822, "alt", newJString(alt))
  add(query_589822, "placedDateStart", newJString(placedDateStart))
  add(query_589822, "oauth_token", newJString(oauthToken))
  add(query_589822, "userIp", newJString(userIp))
  add(query_589822, "maxResults", newJInt(maxResults))
  add(query_589822, "orderBy", newJString(orderBy))
  add(query_589822, "placedDateEnd", newJString(placedDateEnd))
  add(query_589822, "key", newJString(key))
  add(path_589821, "merchantId", newJString(merchantId))
  add(query_589822, "acknowledged", newJBool(acknowledged))
  add(query_589822, "prettyPrint", newJBool(prettyPrint))
  if statuses != nil:
    query_589822.add "statuses", statuses
  result = call_589820.call(path_589821, query_589822, nil, nil, nil)

var contentOrdersList* = Call_ContentOrdersList_589801(name: "contentOrdersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/orders", validator: validate_ContentOrdersList_589802,
    base: "/content/v2.1", url: url_ContentOrdersList_589803,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersGet_589823 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersGet_589825(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrdersGet_589824(path: JsonNode; query: JsonNode;
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
  var valid_589826 = path.getOrDefault("orderId")
  valid_589826 = validateParameter(valid_589826, JString, required = true,
                                 default = nil)
  if valid_589826 != nil:
    section.add "orderId", valid_589826
  var valid_589827 = path.getOrDefault("merchantId")
  valid_589827 = validateParameter(valid_589827, JString, required = true,
                                 default = nil)
  if valid_589827 != nil:
    section.add "merchantId", valid_589827
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589828 = query.getOrDefault("fields")
  valid_589828 = validateParameter(valid_589828, JString, required = false,
                                 default = nil)
  if valid_589828 != nil:
    section.add "fields", valid_589828
  var valid_589829 = query.getOrDefault("quotaUser")
  valid_589829 = validateParameter(valid_589829, JString, required = false,
                                 default = nil)
  if valid_589829 != nil:
    section.add "quotaUser", valid_589829
  var valid_589830 = query.getOrDefault("alt")
  valid_589830 = validateParameter(valid_589830, JString, required = false,
                                 default = newJString("json"))
  if valid_589830 != nil:
    section.add "alt", valid_589830
  var valid_589831 = query.getOrDefault("oauth_token")
  valid_589831 = validateParameter(valid_589831, JString, required = false,
                                 default = nil)
  if valid_589831 != nil:
    section.add "oauth_token", valid_589831
  var valid_589832 = query.getOrDefault("userIp")
  valid_589832 = validateParameter(valid_589832, JString, required = false,
                                 default = nil)
  if valid_589832 != nil:
    section.add "userIp", valid_589832
  var valid_589833 = query.getOrDefault("key")
  valid_589833 = validateParameter(valid_589833, JString, required = false,
                                 default = nil)
  if valid_589833 != nil:
    section.add "key", valid_589833
  var valid_589834 = query.getOrDefault("prettyPrint")
  valid_589834 = validateParameter(valid_589834, JBool, required = false,
                                 default = newJBool(true))
  if valid_589834 != nil:
    section.add "prettyPrint", valid_589834
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589835: Call_ContentOrdersGet_589823; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an order from your Merchant Center account.
  ## 
  let valid = call_589835.validator(path, query, header, formData, body)
  let scheme = call_589835.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589835.url(scheme.get, call_589835.host, call_589835.base,
                         call_589835.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589835, url, valid)

proc call*(call_589836: Call_ContentOrdersGet_589823; orderId: string;
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
  var path_589837 = newJObject()
  var query_589838 = newJObject()
  add(query_589838, "fields", newJString(fields))
  add(query_589838, "quotaUser", newJString(quotaUser))
  add(query_589838, "alt", newJString(alt))
  add(query_589838, "oauth_token", newJString(oauthToken))
  add(query_589838, "userIp", newJString(userIp))
  add(path_589837, "orderId", newJString(orderId))
  add(query_589838, "key", newJString(key))
  add(path_589837, "merchantId", newJString(merchantId))
  add(query_589838, "prettyPrint", newJBool(prettyPrint))
  result = call_589836.call(path_589837, query_589838, nil, nil, nil)

var contentOrdersGet* = Call_ContentOrdersGet_589823(name: "contentOrdersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}", validator: validate_ContentOrdersGet_589824,
    base: "/content/v2.1", url: url_ContentOrdersGet_589825, schemes: {Scheme.Https})
type
  Call_ContentOrdersAcknowledge_589839 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersAcknowledge_589841(protocol: Scheme; host: string;
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

proc validate_ContentOrdersAcknowledge_589840(path: JsonNode; query: JsonNode;
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
  var valid_589842 = path.getOrDefault("orderId")
  valid_589842 = validateParameter(valid_589842, JString, required = true,
                                 default = nil)
  if valid_589842 != nil:
    section.add "orderId", valid_589842
  var valid_589843 = path.getOrDefault("merchantId")
  valid_589843 = validateParameter(valid_589843, JString, required = true,
                                 default = nil)
  if valid_589843 != nil:
    section.add "merchantId", valid_589843
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589844 = query.getOrDefault("fields")
  valid_589844 = validateParameter(valid_589844, JString, required = false,
                                 default = nil)
  if valid_589844 != nil:
    section.add "fields", valid_589844
  var valid_589845 = query.getOrDefault("quotaUser")
  valid_589845 = validateParameter(valid_589845, JString, required = false,
                                 default = nil)
  if valid_589845 != nil:
    section.add "quotaUser", valid_589845
  var valid_589846 = query.getOrDefault("alt")
  valid_589846 = validateParameter(valid_589846, JString, required = false,
                                 default = newJString("json"))
  if valid_589846 != nil:
    section.add "alt", valid_589846
  var valid_589847 = query.getOrDefault("oauth_token")
  valid_589847 = validateParameter(valid_589847, JString, required = false,
                                 default = nil)
  if valid_589847 != nil:
    section.add "oauth_token", valid_589847
  var valid_589848 = query.getOrDefault("userIp")
  valid_589848 = validateParameter(valid_589848, JString, required = false,
                                 default = nil)
  if valid_589848 != nil:
    section.add "userIp", valid_589848
  var valid_589849 = query.getOrDefault("key")
  valid_589849 = validateParameter(valid_589849, JString, required = false,
                                 default = nil)
  if valid_589849 != nil:
    section.add "key", valid_589849
  var valid_589850 = query.getOrDefault("prettyPrint")
  valid_589850 = validateParameter(valid_589850, JBool, required = false,
                                 default = newJBool(true))
  if valid_589850 != nil:
    section.add "prettyPrint", valid_589850
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589852: Call_ContentOrdersAcknowledge_589839; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks an order as acknowledged.
  ## 
  let valid = call_589852.validator(path, query, header, formData, body)
  let scheme = call_589852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589852.url(scheme.get, call_589852.host, call_589852.base,
                         call_589852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589852, url, valid)

proc call*(call_589853: Call_ContentOrdersAcknowledge_589839; orderId: string;
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
  var path_589854 = newJObject()
  var query_589855 = newJObject()
  var body_589856 = newJObject()
  add(query_589855, "fields", newJString(fields))
  add(query_589855, "quotaUser", newJString(quotaUser))
  add(query_589855, "alt", newJString(alt))
  add(query_589855, "oauth_token", newJString(oauthToken))
  add(query_589855, "userIp", newJString(userIp))
  add(path_589854, "orderId", newJString(orderId))
  add(query_589855, "key", newJString(key))
  add(path_589854, "merchantId", newJString(merchantId))
  if body != nil:
    body_589856 = body
  add(query_589855, "prettyPrint", newJBool(prettyPrint))
  result = call_589853.call(path_589854, query_589855, nil, nil, body_589856)

var contentOrdersAcknowledge* = Call_ContentOrdersAcknowledge_589839(
    name: "contentOrdersAcknowledge", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/acknowledge",
    validator: validate_ContentOrdersAcknowledge_589840, base: "/content/v2.1",
    url: url_ContentOrdersAcknowledge_589841, schemes: {Scheme.Https})
type
  Call_ContentOrdersCancel_589857 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersCancel_589859(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrdersCancel_589858(path: JsonNode; query: JsonNode;
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
  var valid_589860 = path.getOrDefault("orderId")
  valid_589860 = validateParameter(valid_589860, JString, required = true,
                                 default = nil)
  if valid_589860 != nil:
    section.add "orderId", valid_589860
  var valid_589861 = path.getOrDefault("merchantId")
  valid_589861 = validateParameter(valid_589861, JString, required = true,
                                 default = nil)
  if valid_589861 != nil:
    section.add "merchantId", valid_589861
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589862 = query.getOrDefault("fields")
  valid_589862 = validateParameter(valid_589862, JString, required = false,
                                 default = nil)
  if valid_589862 != nil:
    section.add "fields", valid_589862
  var valid_589863 = query.getOrDefault("quotaUser")
  valid_589863 = validateParameter(valid_589863, JString, required = false,
                                 default = nil)
  if valid_589863 != nil:
    section.add "quotaUser", valid_589863
  var valid_589864 = query.getOrDefault("alt")
  valid_589864 = validateParameter(valid_589864, JString, required = false,
                                 default = newJString("json"))
  if valid_589864 != nil:
    section.add "alt", valid_589864
  var valid_589865 = query.getOrDefault("oauth_token")
  valid_589865 = validateParameter(valid_589865, JString, required = false,
                                 default = nil)
  if valid_589865 != nil:
    section.add "oauth_token", valid_589865
  var valid_589866 = query.getOrDefault("userIp")
  valid_589866 = validateParameter(valid_589866, JString, required = false,
                                 default = nil)
  if valid_589866 != nil:
    section.add "userIp", valid_589866
  var valid_589867 = query.getOrDefault("key")
  valid_589867 = validateParameter(valid_589867, JString, required = false,
                                 default = nil)
  if valid_589867 != nil:
    section.add "key", valid_589867
  var valid_589868 = query.getOrDefault("prettyPrint")
  valid_589868 = validateParameter(valid_589868, JBool, required = false,
                                 default = newJBool(true))
  if valid_589868 != nil:
    section.add "prettyPrint", valid_589868
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589870: Call_ContentOrdersCancel_589857; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels all line items in an order, making a full refund.
  ## 
  let valid = call_589870.validator(path, query, header, formData, body)
  let scheme = call_589870.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589870.url(scheme.get, call_589870.host, call_589870.base,
                         call_589870.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589870, url, valid)

proc call*(call_589871: Call_ContentOrdersCancel_589857; orderId: string;
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
  var path_589872 = newJObject()
  var query_589873 = newJObject()
  var body_589874 = newJObject()
  add(query_589873, "fields", newJString(fields))
  add(query_589873, "quotaUser", newJString(quotaUser))
  add(query_589873, "alt", newJString(alt))
  add(query_589873, "oauth_token", newJString(oauthToken))
  add(query_589873, "userIp", newJString(userIp))
  add(path_589872, "orderId", newJString(orderId))
  add(query_589873, "key", newJString(key))
  add(path_589872, "merchantId", newJString(merchantId))
  if body != nil:
    body_589874 = body
  add(query_589873, "prettyPrint", newJBool(prettyPrint))
  result = call_589871.call(path_589872, query_589873, nil, nil, body_589874)

var contentOrdersCancel* = Call_ContentOrdersCancel_589857(
    name: "contentOrdersCancel", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/orders/{orderId}/cancel",
    validator: validate_ContentOrdersCancel_589858, base: "/content/v2.1",
    url: url_ContentOrdersCancel_589859, schemes: {Scheme.Https})
type
  Call_ContentOrdersCancellineitem_589875 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersCancellineitem_589877(protocol: Scheme; host: string;
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

proc validate_ContentOrdersCancellineitem_589876(path: JsonNode; query: JsonNode;
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
  var valid_589878 = path.getOrDefault("orderId")
  valid_589878 = validateParameter(valid_589878, JString, required = true,
                                 default = nil)
  if valid_589878 != nil:
    section.add "orderId", valid_589878
  var valid_589879 = path.getOrDefault("merchantId")
  valid_589879 = validateParameter(valid_589879, JString, required = true,
                                 default = nil)
  if valid_589879 != nil:
    section.add "merchantId", valid_589879
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589880 = query.getOrDefault("fields")
  valid_589880 = validateParameter(valid_589880, JString, required = false,
                                 default = nil)
  if valid_589880 != nil:
    section.add "fields", valid_589880
  var valid_589881 = query.getOrDefault("quotaUser")
  valid_589881 = validateParameter(valid_589881, JString, required = false,
                                 default = nil)
  if valid_589881 != nil:
    section.add "quotaUser", valid_589881
  var valid_589882 = query.getOrDefault("alt")
  valid_589882 = validateParameter(valid_589882, JString, required = false,
                                 default = newJString("json"))
  if valid_589882 != nil:
    section.add "alt", valid_589882
  var valid_589883 = query.getOrDefault("oauth_token")
  valid_589883 = validateParameter(valid_589883, JString, required = false,
                                 default = nil)
  if valid_589883 != nil:
    section.add "oauth_token", valid_589883
  var valid_589884 = query.getOrDefault("userIp")
  valid_589884 = validateParameter(valid_589884, JString, required = false,
                                 default = nil)
  if valid_589884 != nil:
    section.add "userIp", valid_589884
  var valid_589885 = query.getOrDefault("key")
  valid_589885 = validateParameter(valid_589885, JString, required = false,
                                 default = nil)
  if valid_589885 != nil:
    section.add "key", valid_589885
  var valid_589886 = query.getOrDefault("prettyPrint")
  valid_589886 = validateParameter(valid_589886, JBool, required = false,
                                 default = newJBool(true))
  if valid_589886 != nil:
    section.add "prettyPrint", valid_589886
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589888: Call_ContentOrdersCancellineitem_589875; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a line item, making a full refund.
  ## 
  let valid = call_589888.validator(path, query, header, formData, body)
  let scheme = call_589888.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589888.url(scheme.get, call_589888.host, call_589888.base,
                         call_589888.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589888, url, valid)

proc call*(call_589889: Call_ContentOrdersCancellineitem_589875; orderId: string;
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
  var path_589890 = newJObject()
  var query_589891 = newJObject()
  var body_589892 = newJObject()
  add(query_589891, "fields", newJString(fields))
  add(query_589891, "quotaUser", newJString(quotaUser))
  add(query_589891, "alt", newJString(alt))
  add(query_589891, "oauth_token", newJString(oauthToken))
  add(query_589891, "userIp", newJString(userIp))
  add(path_589890, "orderId", newJString(orderId))
  add(query_589891, "key", newJString(key))
  add(path_589890, "merchantId", newJString(merchantId))
  if body != nil:
    body_589892 = body
  add(query_589891, "prettyPrint", newJBool(prettyPrint))
  result = call_589889.call(path_589890, query_589891, nil, nil, body_589892)

var contentOrdersCancellineitem* = Call_ContentOrdersCancellineitem_589875(
    name: "contentOrdersCancellineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/cancelLineItem",
    validator: validate_ContentOrdersCancellineitem_589876, base: "/content/v2.1",
    url: url_ContentOrdersCancellineitem_589877, schemes: {Scheme.Https})
type
  Call_ContentOrdersInstorerefundlineitem_589893 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersInstorerefundlineitem_589895(protocol: Scheme; host: string;
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

proc validate_ContentOrdersInstorerefundlineitem_589894(path: JsonNode;
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
  var valid_589896 = path.getOrDefault("orderId")
  valid_589896 = validateParameter(valid_589896, JString, required = true,
                                 default = nil)
  if valid_589896 != nil:
    section.add "orderId", valid_589896
  var valid_589897 = path.getOrDefault("merchantId")
  valid_589897 = validateParameter(valid_589897, JString, required = true,
                                 default = nil)
  if valid_589897 != nil:
    section.add "merchantId", valid_589897
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589898 = query.getOrDefault("fields")
  valid_589898 = validateParameter(valid_589898, JString, required = false,
                                 default = nil)
  if valid_589898 != nil:
    section.add "fields", valid_589898
  var valid_589899 = query.getOrDefault("quotaUser")
  valid_589899 = validateParameter(valid_589899, JString, required = false,
                                 default = nil)
  if valid_589899 != nil:
    section.add "quotaUser", valid_589899
  var valid_589900 = query.getOrDefault("alt")
  valid_589900 = validateParameter(valid_589900, JString, required = false,
                                 default = newJString("json"))
  if valid_589900 != nil:
    section.add "alt", valid_589900
  var valid_589901 = query.getOrDefault("oauth_token")
  valid_589901 = validateParameter(valid_589901, JString, required = false,
                                 default = nil)
  if valid_589901 != nil:
    section.add "oauth_token", valid_589901
  var valid_589902 = query.getOrDefault("userIp")
  valid_589902 = validateParameter(valid_589902, JString, required = false,
                                 default = nil)
  if valid_589902 != nil:
    section.add "userIp", valid_589902
  var valid_589903 = query.getOrDefault("key")
  valid_589903 = validateParameter(valid_589903, JString, required = false,
                                 default = nil)
  if valid_589903 != nil:
    section.add "key", valid_589903
  var valid_589904 = query.getOrDefault("prettyPrint")
  valid_589904 = validateParameter(valid_589904, JBool, required = false,
                                 default = newJBool(true))
  if valid_589904 != nil:
    section.add "prettyPrint", valid_589904
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589906: Call_ContentOrdersInstorerefundlineitem_589893;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deprecated. Notifies that item return and refund was handled directly by merchant outside of Google payments processing (e.g. cash refund done in store).
  ## Note: We recommend calling the returnrefundlineitem method to refund in-store returns. We will issue the refund directly to the customer. This helps to prevent possible differences arising between merchant and Google transaction records. We also recommend having the point of sale system communicate with Google to ensure that customers do not receive a double refund by first refunding via Google then via an in-store return.
  ## 
  let valid = call_589906.validator(path, query, header, formData, body)
  let scheme = call_589906.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589906.url(scheme.get, call_589906.host, call_589906.base,
                         call_589906.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589906, url, valid)

proc call*(call_589907: Call_ContentOrdersInstorerefundlineitem_589893;
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
  var path_589908 = newJObject()
  var query_589909 = newJObject()
  var body_589910 = newJObject()
  add(query_589909, "fields", newJString(fields))
  add(query_589909, "quotaUser", newJString(quotaUser))
  add(query_589909, "alt", newJString(alt))
  add(query_589909, "oauth_token", newJString(oauthToken))
  add(query_589909, "userIp", newJString(userIp))
  add(path_589908, "orderId", newJString(orderId))
  add(query_589909, "key", newJString(key))
  add(path_589908, "merchantId", newJString(merchantId))
  if body != nil:
    body_589910 = body
  add(query_589909, "prettyPrint", newJBool(prettyPrint))
  result = call_589907.call(path_589908, query_589909, nil, nil, body_589910)

var contentOrdersInstorerefundlineitem* = Call_ContentOrdersInstorerefundlineitem_589893(
    name: "contentOrdersInstorerefundlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/inStoreRefundLineItem",
    validator: validate_ContentOrdersInstorerefundlineitem_589894,
    base: "/content/v2.1", url: url_ContentOrdersInstorerefundlineitem_589895,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersRejectreturnlineitem_589911 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersRejectreturnlineitem_589913(protocol: Scheme; host: string;
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

proc validate_ContentOrdersRejectreturnlineitem_589912(path: JsonNode;
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
  var valid_589914 = path.getOrDefault("orderId")
  valid_589914 = validateParameter(valid_589914, JString, required = true,
                                 default = nil)
  if valid_589914 != nil:
    section.add "orderId", valid_589914
  var valid_589915 = path.getOrDefault("merchantId")
  valid_589915 = validateParameter(valid_589915, JString, required = true,
                                 default = nil)
  if valid_589915 != nil:
    section.add "merchantId", valid_589915
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589916 = query.getOrDefault("fields")
  valid_589916 = validateParameter(valid_589916, JString, required = false,
                                 default = nil)
  if valid_589916 != nil:
    section.add "fields", valid_589916
  var valid_589917 = query.getOrDefault("quotaUser")
  valid_589917 = validateParameter(valid_589917, JString, required = false,
                                 default = nil)
  if valid_589917 != nil:
    section.add "quotaUser", valid_589917
  var valid_589918 = query.getOrDefault("alt")
  valid_589918 = validateParameter(valid_589918, JString, required = false,
                                 default = newJString("json"))
  if valid_589918 != nil:
    section.add "alt", valid_589918
  var valid_589919 = query.getOrDefault("oauth_token")
  valid_589919 = validateParameter(valid_589919, JString, required = false,
                                 default = nil)
  if valid_589919 != nil:
    section.add "oauth_token", valid_589919
  var valid_589920 = query.getOrDefault("userIp")
  valid_589920 = validateParameter(valid_589920, JString, required = false,
                                 default = nil)
  if valid_589920 != nil:
    section.add "userIp", valid_589920
  var valid_589921 = query.getOrDefault("key")
  valid_589921 = validateParameter(valid_589921, JString, required = false,
                                 default = nil)
  if valid_589921 != nil:
    section.add "key", valid_589921
  var valid_589922 = query.getOrDefault("prettyPrint")
  valid_589922 = validateParameter(valid_589922, JBool, required = false,
                                 default = newJBool(true))
  if valid_589922 != nil:
    section.add "prettyPrint", valid_589922
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589924: Call_ContentOrdersRejectreturnlineitem_589911;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rejects return on an line item.
  ## 
  let valid = call_589924.validator(path, query, header, formData, body)
  let scheme = call_589924.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589924.url(scheme.get, call_589924.host, call_589924.base,
                         call_589924.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589924, url, valid)

proc call*(call_589925: Call_ContentOrdersRejectreturnlineitem_589911;
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
  var path_589926 = newJObject()
  var query_589927 = newJObject()
  var body_589928 = newJObject()
  add(query_589927, "fields", newJString(fields))
  add(query_589927, "quotaUser", newJString(quotaUser))
  add(query_589927, "alt", newJString(alt))
  add(query_589927, "oauth_token", newJString(oauthToken))
  add(query_589927, "userIp", newJString(userIp))
  add(path_589926, "orderId", newJString(orderId))
  add(query_589927, "key", newJString(key))
  add(path_589926, "merchantId", newJString(merchantId))
  if body != nil:
    body_589928 = body
  add(query_589927, "prettyPrint", newJBool(prettyPrint))
  result = call_589925.call(path_589926, query_589927, nil, nil, body_589928)

var contentOrdersRejectreturnlineitem* = Call_ContentOrdersRejectreturnlineitem_589911(
    name: "contentOrdersRejectreturnlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/rejectReturnLineItem",
    validator: validate_ContentOrdersRejectreturnlineitem_589912,
    base: "/content/v2.1", url: url_ContentOrdersRejectreturnlineitem_589913,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersReturnrefundlineitem_589929 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersReturnrefundlineitem_589931(protocol: Scheme; host: string;
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

proc validate_ContentOrdersReturnrefundlineitem_589930(path: JsonNode;
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
  var valid_589932 = path.getOrDefault("orderId")
  valid_589932 = validateParameter(valid_589932, JString, required = true,
                                 default = nil)
  if valid_589932 != nil:
    section.add "orderId", valid_589932
  var valid_589933 = path.getOrDefault("merchantId")
  valid_589933 = validateParameter(valid_589933, JString, required = true,
                                 default = nil)
  if valid_589933 != nil:
    section.add "merchantId", valid_589933
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589934 = query.getOrDefault("fields")
  valid_589934 = validateParameter(valid_589934, JString, required = false,
                                 default = nil)
  if valid_589934 != nil:
    section.add "fields", valid_589934
  var valid_589935 = query.getOrDefault("quotaUser")
  valid_589935 = validateParameter(valid_589935, JString, required = false,
                                 default = nil)
  if valid_589935 != nil:
    section.add "quotaUser", valid_589935
  var valid_589936 = query.getOrDefault("alt")
  valid_589936 = validateParameter(valid_589936, JString, required = false,
                                 default = newJString("json"))
  if valid_589936 != nil:
    section.add "alt", valid_589936
  var valid_589937 = query.getOrDefault("oauth_token")
  valid_589937 = validateParameter(valid_589937, JString, required = false,
                                 default = nil)
  if valid_589937 != nil:
    section.add "oauth_token", valid_589937
  var valid_589938 = query.getOrDefault("userIp")
  valid_589938 = validateParameter(valid_589938, JString, required = false,
                                 default = nil)
  if valid_589938 != nil:
    section.add "userIp", valid_589938
  var valid_589939 = query.getOrDefault("key")
  valid_589939 = validateParameter(valid_589939, JString, required = false,
                                 default = nil)
  if valid_589939 != nil:
    section.add "key", valid_589939
  var valid_589940 = query.getOrDefault("prettyPrint")
  valid_589940 = validateParameter(valid_589940, JBool, required = false,
                                 default = newJBool(true))
  if valid_589940 != nil:
    section.add "prettyPrint", valid_589940
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589942: Call_ContentOrdersReturnrefundlineitem_589929;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns and refunds a line item. Note that this method can only be called on fully shipped orders.
  ## 
  let valid = call_589942.validator(path, query, header, formData, body)
  let scheme = call_589942.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589942.url(scheme.get, call_589942.host, call_589942.base,
                         call_589942.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589942, url, valid)

proc call*(call_589943: Call_ContentOrdersReturnrefundlineitem_589929;
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
  var path_589944 = newJObject()
  var query_589945 = newJObject()
  var body_589946 = newJObject()
  add(query_589945, "fields", newJString(fields))
  add(query_589945, "quotaUser", newJString(quotaUser))
  add(query_589945, "alt", newJString(alt))
  add(query_589945, "oauth_token", newJString(oauthToken))
  add(query_589945, "userIp", newJString(userIp))
  add(path_589944, "orderId", newJString(orderId))
  add(query_589945, "key", newJString(key))
  add(path_589944, "merchantId", newJString(merchantId))
  if body != nil:
    body_589946 = body
  add(query_589945, "prettyPrint", newJBool(prettyPrint))
  result = call_589943.call(path_589944, query_589945, nil, nil, body_589946)

var contentOrdersReturnrefundlineitem* = Call_ContentOrdersReturnrefundlineitem_589929(
    name: "contentOrdersReturnrefundlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/returnRefundLineItem",
    validator: validate_ContentOrdersReturnrefundlineitem_589930,
    base: "/content/v2.1", url: url_ContentOrdersReturnrefundlineitem_589931,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersSetlineitemmetadata_589947 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersSetlineitemmetadata_589949(protocol: Scheme; host: string;
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

proc validate_ContentOrdersSetlineitemmetadata_589948(path: JsonNode;
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
  var valid_589950 = path.getOrDefault("orderId")
  valid_589950 = validateParameter(valid_589950, JString, required = true,
                                 default = nil)
  if valid_589950 != nil:
    section.add "orderId", valid_589950
  var valid_589951 = path.getOrDefault("merchantId")
  valid_589951 = validateParameter(valid_589951, JString, required = true,
                                 default = nil)
  if valid_589951 != nil:
    section.add "merchantId", valid_589951
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589952 = query.getOrDefault("fields")
  valid_589952 = validateParameter(valid_589952, JString, required = false,
                                 default = nil)
  if valid_589952 != nil:
    section.add "fields", valid_589952
  var valid_589953 = query.getOrDefault("quotaUser")
  valid_589953 = validateParameter(valid_589953, JString, required = false,
                                 default = nil)
  if valid_589953 != nil:
    section.add "quotaUser", valid_589953
  var valid_589954 = query.getOrDefault("alt")
  valid_589954 = validateParameter(valid_589954, JString, required = false,
                                 default = newJString("json"))
  if valid_589954 != nil:
    section.add "alt", valid_589954
  var valid_589955 = query.getOrDefault("oauth_token")
  valid_589955 = validateParameter(valid_589955, JString, required = false,
                                 default = nil)
  if valid_589955 != nil:
    section.add "oauth_token", valid_589955
  var valid_589956 = query.getOrDefault("userIp")
  valid_589956 = validateParameter(valid_589956, JString, required = false,
                                 default = nil)
  if valid_589956 != nil:
    section.add "userIp", valid_589956
  var valid_589957 = query.getOrDefault("key")
  valid_589957 = validateParameter(valid_589957, JString, required = false,
                                 default = nil)
  if valid_589957 != nil:
    section.add "key", valid_589957
  var valid_589958 = query.getOrDefault("prettyPrint")
  valid_589958 = validateParameter(valid_589958, JBool, required = false,
                                 default = newJBool(true))
  if valid_589958 != nil:
    section.add "prettyPrint", valid_589958
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589960: Call_ContentOrdersSetlineitemmetadata_589947;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets (or overrides if it already exists) merchant provided annotations in the form of key-value pairs. A common use case would be to supply us with additional structured information about a line item that cannot be provided via other methods. Submitted key-value pairs can be retrieved as part of the orders resource.
  ## 
  let valid = call_589960.validator(path, query, header, formData, body)
  let scheme = call_589960.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589960.url(scheme.get, call_589960.host, call_589960.base,
                         call_589960.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589960, url, valid)

proc call*(call_589961: Call_ContentOrdersSetlineitemmetadata_589947;
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
  var path_589962 = newJObject()
  var query_589963 = newJObject()
  var body_589964 = newJObject()
  add(query_589963, "fields", newJString(fields))
  add(query_589963, "quotaUser", newJString(quotaUser))
  add(query_589963, "alt", newJString(alt))
  add(query_589963, "oauth_token", newJString(oauthToken))
  add(query_589963, "userIp", newJString(userIp))
  add(path_589962, "orderId", newJString(orderId))
  add(query_589963, "key", newJString(key))
  add(path_589962, "merchantId", newJString(merchantId))
  if body != nil:
    body_589964 = body
  add(query_589963, "prettyPrint", newJBool(prettyPrint))
  result = call_589961.call(path_589962, query_589963, nil, nil, body_589964)

var contentOrdersSetlineitemmetadata* = Call_ContentOrdersSetlineitemmetadata_589947(
    name: "contentOrdersSetlineitemmetadata", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/setLineItemMetadata",
    validator: validate_ContentOrdersSetlineitemmetadata_589948,
    base: "/content/v2.1", url: url_ContentOrdersSetlineitemmetadata_589949,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersShiplineitems_589965 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersShiplineitems_589967(protocol: Scheme; host: string;
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

proc validate_ContentOrdersShiplineitems_589966(path: JsonNode; query: JsonNode;
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
  var valid_589968 = path.getOrDefault("orderId")
  valid_589968 = validateParameter(valid_589968, JString, required = true,
                                 default = nil)
  if valid_589968 != nil:
    section.add "orderId", valid_589968
  var valid_589969 = path.getOrDefault("merchantId")
  valid_589969 = validateParameter(valid_589969, JString, required = true,
                                 default = nil)
  if valid_589969 != nil:
    section.add "merchantId", valid_589969
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589970 = query.getOrDefault("fields")
  valid_589970 = validateParameter(valid_589970, JString, required = false,
                                 default = nil)
  if valid_589970 != nil:
    section.add "fields", valid_589970
  var valid_589971 = query.getOrDefault("quotaUser")
  valid_589971 = validateParameter(valid_589971, JString, required = false,
                                 default = nil)
  if valid_589971 != nil:
    section.add "quotaUser", valid_589971
  var valid_589972 = query.getOrDefault("alt")
  valid_589972 = validateParameter(valid_589972, JString, required = false,
                                 default = newJString("json"))
  if valid_589972 != nil:
    section.add "alt", valid_589972
  var valid_589973 = query.getOrDefault("oauth_token")
  valid_589973 = validateParameter(valid_589973, JString, required = false,
                                 default = nil)
  if valid_589973 != nil:
    section.add "oauth_token", valid_589973
  var valid_589974 = query.getOrDefault("userIp")
  valid_589974 = validateParameter(valid_589974, JString, required = false,
                                 default = nil)
  if valid_589974 != nil:
    section.add "userIp", valid_589974
  var valid_589975 = query.getOrDefault("key")
  valid_589975 = validateParameter(valid_589975, JString, required = false,
                                 default = nil)
  if valid_589975 != nil:
    section.add "key", valid_589975
  var valid_589976 = query.getOrDefault("prettyPrint")
  valid_589976 = validateParameter(valid_589976, JBool, required = false,
                                 default = newJBool(true))
  if valid_589976 != nil:
    section.add "prettyPrint", valid_589976
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589978: Call_ContentOrdersShiplineitems_589965; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks line item(s) as shipped.
  ## 
  let valid = call_589978.validator(path, query, header, formData, body)
  let scheme = call_589978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589978.url(scheme.get, call_589978.host, call_589978.base,
                         call_589978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589978, url, valid)

proc call*(call_589979: Call_ContentOrdersShiplineitems_589965; orderId: string;
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
  var path_589980 = newJObject()
  var query_589981 = newJObject()
  var body_589982 = newJObject()
  add(query_589981, "fields", newJString(fields))
  add(query_589981, "quotaUser", newJString(quotaUser))
  add(query_589981, "alt", newJString(alt))
  add(query_589981, "oauth_token", newJString(oauthToken))
  add(query_589981, "userIp", newJString(userIp))
  add(path_589980, "orderId", newJString(orderId))
  add(query_589981, "key", newJString(key))
  add(path_589980, "merchantId", newJString(merchantId))
  if body != nil:
    body_589982 = body
  add(query_589981, "prettyPrint", newJBool(prettyPrint))
  result = call_589979.call(path_589980, query_589981, nil, nil, body_589982)

var contentOrdersShiplineitems* = Call_ContentOrdersShiplineitems_589965(
    name: "contentOrdersShiplineitems", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/shipLineItems",
    validator: validate_ContentOrdersShiplineitems_589966, base: "/content/v2.1",
    url: url_ContentOrdersShiplineitems_589967, schemes: {Scheme.Https})
type
  Call_ContentOrdersCreatetestreturn_589983 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersCreatetestreturn_589985(protocol: Scheme; host: string;
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

proc validate_ContentOrdersCreatetestreturn_589984(path: JsonNode; query: JsonNode;
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
  var valid_589986 = path.getOrDefault("orderId")
  valid_589986 = validateParameter(valid_589986, JString, required = true,
                                 default = nil)
  if valid_589986 != nil:
    section.add "orderId", valid_589986
  var valid_589987 = path.getOrDefault("merchantId")
  valid_589987 = validateParameter(valid_589987, JString, required = true,
                                 default = nil)
  if valid_589987 != nil:
    section.add "merchantId", valid_589987
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589988 = query.getOrDefault("fields")
  valid_589988 = validateParameter(valid_589988, JString, required = false,
                                 default = nil)
  if valid_589988 != nil:
    section.add "fields", valid_589988
  var valid_589989 = query.getOrDefault("quotaUser")
  valid_589989 = validateParameter(valid_589989, JString, required = false,
                                 default = nil)
  if valid_589989 != nil:
    section.add "quotaUser", valid_589989
  var valid_589990 = query.getOrDefault("alt")
  valid_589990 = validateParameter(valid_589990, JString, required = false,
                                 default = newJString("json"))
  if valid_589990 != nil:
    section.add "alt", valid_589990
  var valid_589991 = query.getOrDefault("oauth_token")
  valid_589991 = validateParameter(valid_589991, JString, required = false,
                                 default = nil)
  if valid_589991 != nil:
    section.add "oauth_token", valid_589991
  var valid_589992 = query.getOrDefault("userIp")
  valid_589992 = validateParameter(valid_589992, JString, required = false,
                                 default = nil)
  if valid_589992 != nil:
    section.add "userIp", valid_589992
  var valid_589993 = query.getOrDefault("key")
  valid_589993 = validateParameter(valid_589993, JString, required = false,
                                 default = nil)
  if valid_589993 != nil:
    section.add "key", valid_589993
  var valid_589994 = query.getOrDefault("prettyPrint")
  valid_589994 = validateParameter(valid_589994, JBool, required = false,
                                 default = newJBool(true))
  if valid_589994 != nil:
    section.add "prettyPrint", valid_589994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589996: Call_ContentOrdersCreatetestreturn_589983; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Creates a test return.
  ## 
  let valid = call_589996.validator(path, query, header, formData, body)
  let scheme = call_589996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589996.url(scheme.get, call_589996.host, call_589996.base,
                         call_589996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589996, url, valid)

proc call*(call_589997: Call_ContentOrdersCreatetestreturn_589983; orderId: string;
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
  var path_589998 = newJObject()
  var query_589999 = newJObject()
  var body_590000 = newJObject()
  add(query_589999, "fields", newJString(fields))
  add(query_589999, "quotaUser", newJString(quotaUser))
  add(query_589999, "alt", newJString(alt))
  add(query_589999, "oauth_token", newJString(oauthToken))
  add(query_589999, "userIp", newJString(userIp))
  add(path_589998, "orderId", newJString(orderId))
  add(query_589999, "key", newJString(key))
  add(path_589998, "merchantId", newJString(merchantId))
  if body != nil:
    body_590000 = body
  add(query_589999, "prettyPrint", newJBool(prettyPrint))
  result = call_589997.call(path_589998, query_589999, nil, nil, body_590000)

var contentOrdersCreatetestreturn* = Call_ContentOrdersCreatetestreturn_589983(
    name: "contentOrdersCreatetestreturn", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/testreturn",
    validator: validate_ContentOrdersCreatetestreturn_589984,
    base: "/content/v2.1", url: url_ContentOrdersCreatetestreturn_589985,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdatelineitemshippingdetails_590001 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersUpdatelineitemshippingdetails_590003(protocol: Scheme;
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

proc validate_ContentOrdersUpdatelineitemshippingdetails_590002(path: JsonNode;
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
  var valid_590004 = path.getOrDefault("orderId")
  valid_590004 = validateParameter(valid_590004, JString, required = true,
                                 default = nil)
  if valid_590004 != nil:
    section.add "orderId", valid_590004
  var valid_590005 = path.getOrDefault("merchantId")
  valid_590005 = validateParameter(valid_590005, JString, required = true,
                                 default = nil)
  if valid_590005 != nil:
    section.add "merchantId", valid_590005
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590006 = query.getOrDefault("fields")
  valid_590006 = validateParameter(valid_590006, JString, required = false,
                                 default = nil)
  if valid_590006 != nil:
    section.add "fields", valid_590006
  var valid_590007 = query.getOrDefault("quotaUser")
  valid_590007 = validateParameter(valid_590007, JString, required = false,
                                 default = nil)
  if valid_590007 != nil:
    section.add "quotaUser", valid_590007
  var valid_590008 = query.getOrDefault("alt")
  valid_590008 = validateParameter(valid_590008, JString, required = false,
                                 default = newJString("json"))
  if valid_590008 != nil:
    section.add "alt", valid_590008
  var valid_590009 = query.getOrDefault("oauth_token")
  valid_590009 = validateParameter(valid_590009, JString, required = false,
                                 default = nil)
  if valid_590009 != nil:
    section.add "oauth_token", valid_590009
  var valid_590010 = query.getOrDefault("userIp")
  valid_590010 = validateParameter(valid_590010, JString, required = false,
                                 default = nil)
  if valid_590010 != nil:
    section.add "userIp", valid_590010
  var valid_590011 = query.getOrDefault("key")
  valid_590011 = validateParameter(valid_590011, JString, required = false,
                                 default = nil)
  if valid_590011 != nil:
    section.add "key", valid_590011
  var valid_590012 = query.getOrDefault("prettyPrint")
  valid_590012 = validateParameter(valid_590012, JBool, required = false,
                                 default = newJBool(true))
  if valid_590012 != nil:
    section.add "prettyPrint", valid_590012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590014: Call_ContentOrdersUpdatelineitemshippingdetails_590001;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates ship by and delivery by dates for a line item.
  ## 
  let valid = call_590014.validator(path, query, header, formData, body)
  let scheme = call_590014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590014.url(scheme.get, call_590014.host, call_590014.base,
                         call_590014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590014, url, valid)

proc call*(call_590015: Call_ContentOrdersUpdatelineitemshippingdetails_590001;
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
  var path_590016 = newJObject()
  var query_590017 = newJObject()
  var body_590018 = newJObject()
  add(query_590017, "fields", newJString(fields))
  add(query_590017, "quotaUser", newJString(quotaUser))
  add(query_590017, "alt", newJString(alt))
  add(query_590017, "oauth_token", newJString(oauthToken))
  add(query_590017, "userIp", newJString(userIp))
  add(path_590016, "orderId", newJString(orderId))
  add(query_590017, "key", newJString(key))
  add(path_590016, "merchantId", newJString(merchantId))
  if body != nil:
    body_590018 = body
  add(query_590017, "prettyPrint", newJBool(prettyPrint))
  result = call_590015.call(path_590016, query_590017, nil, nil, body_590018)

var contentOrdersUpdatelineitemshippingdetails* = Call_ContentOrdersUpdatelineitemshippingdetails_590001(
    name: "contentOrdersUpdatelineitemshippingdetails", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateLineItemShippingDetails",
    validator: validate_ContentOrdersUpdatelineitemshippingdetails_590002,
    base: "/content/v2.1", url: url_ContentOrdersUpdatelineitemshippingdetails_590003,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdatemerchantorderid_590019 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersUpdatemerchantorderid_590021(protocol: Scheme; host: string;
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

proc validate_ContentOrdersUpdatemerchantorderid_590020(path: JsonNode;
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
  var valid_590022 = path.getOrDefault("orderId")
  valid_590022 = validateParameter(valid_590022, JString, required = true,
                                 default = nil)
  if valid_590022 != nil:
    section.add "orderId", valid_590022
  var valid_590023 = path.getOrDefault("merchantId")
  valid_590023 = validateParameter(valid_590023, JString, required = true,
                                 default = nil)
  if valid_590023 != nil:
    section.add "merchantId", valid_590023
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590024 = query.getOrDefault("fields")
  valid_590024 = validateParameter(valid_590024, JString, required = false,
                                 default = nil)
  if valid_590024 != nil:
    section.add "fields", valid_590024
  var valid_590025 = query.getOrDefault("quotaUser")
  valid_590025 = validateParameter(valid_590025, JString, required = false,
                                 default = nil)
  if valid_590025 != nil:
    section.add "quotaUser", valid_590025
  var valid_590026 = query.getOrDefault("alt")
  valid_590026 = validateParameter(valid_590026, JString, required = false,
                                 default = newJString("json"))
  if valid_590026 != nil:
    section.add "alt", valid_590026
  var valid_590027 = query.getOrDefault("oauth_token")
  valid_590027 = validateParameter(valid_590027, JString, required = false,
                                 default = nil)
  if valid_590027 != nil:
    section.add "oauth_token", valid_590027
  var valid_590028 = query.getOrDefault("userIp")
  valid_590028 = validateParameter(valid_590028, JString, required = false,
                                 default = nil)
  if valid_590028 != nil:
    section.add "userIp", valid_590028
  var valid_590029 = query.getOrDefault("key")
  valid_590029 = validateParameter(valid_590029, JString, required = false,
                                 default = nil)
  if valid_590029 != nil:
    section.add "key", valid_590029
  var valid_590030 = query.getOrDefault("prettyPrint")
  valid_590030 = validateParameter(valid_590030, JBool, required = false,
                                 default = newJBool(true))
  if valid_590030 != nil:
    section.add "prettyPrint", valid_590030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590032: Call_ContentOrdersUpdatemerchantorderid_590019;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the merchant order ID for a given order.
  ## 
  let valid = call_590032.validator(path, query, header, formData, body)
  let scheme = call_590032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590032.url(scheme.get, call_590032.host, call_590032.base,
                         call_590032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590032, url, valid)

proc call*(call_590033: Call_ContentOrdersUpdatemerchantorderid_590019;
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
  var path_590034 = newJObject()
  var query_590035 = newJObject()
  var body_590036 = newJObject()
  add(query_590035, "fields", newJString(fields))
  add(query_590035, "quotaUser", newJString(quotaUser))
  add(query_590035, "alt", newJString(alt))
  add(query_590035, "oauth_token", newJString(oauthToken))
  add(query_590035, "userIp", newJString(userIp))
  add(path_590034, "orderId", newJString(orderId))
  add(query_590035, "key", newJString(key))
  add(path_590034, "merchantId", newJString(merchantId))
  if body != nil:
    body_590036 = body
  add(query_590035, "prettyPrint", newJBool(prettyPrint))
  result = call_590033.call(path_590034, query_590035, nil, nil, body_590036)

var contentOrdersUpdatemerchantorderid* = Call_ContentOrdersUpdatemerchantorderid_590019(
    name: "contentOrdersUpdatemerchantorderid", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateMerchantOrderId",
    validator: validate_ContentOrdersUpdatemerchantorderid_590020,
    base: "/content/v2.1", url: url_ContentOrdersUpdatemerchantorderid_590021,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdateshipment_590037 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersUpdateshipment_590039(protocol: Scheme; host: string;
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

proc validate_ContentOrdersUpdateshipment_590038(path: JsonNode; query: JsonNode;
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
  var valid_590040 = path.getOrDefault("orderId")
  valid_590040 = validateParameter(valid_590040, JString, required = true,
                                 default = nil)
  if valid_590040 != nil:
    section.add "orderId", valid_590040
  var valid_590041 = path.getOrDefault("merchantId")
  valid_590041 = validateParameter(valid_590041, JString, required = true,
                                 default = nil)
  if valid_590041 != nil:
    section.add "merchantId", valid_590041
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590042 = query.getOrDefault("fields")
  valid_590042 = validateParameter(valid_590042, JString, required = false,
                                 default = nil)
  if valid_590042 != nil:
    section.add "fields", valid_590042
  var valid_590043 = query.getOrDefault("quotaUser")
  valid_590043 = validateParameter(valid_590043, JString, required = false,
                                 default = nil)
  if valid_590043 != nil:
    section.add "quotaUser", valid_590043
  var valid_590044 = query.getOrDefault("alt")
  valid_590044 = validateParameter(valid_590044, JString, required = false,
                                 default = newJString("json"))
  if valid_590044 != nil:
    section.add "alt", valid_590044
  var valid_590045 = query.getOrDefault("oauth_token")
  valid_590045 = validateParameter(valid_590045, JString, required = false,
                                 default = nil)
  if valid_590045 != nil:
    section.add "oauth_token", valid_590045
  var valid_590046 = query.getOrDefault("userIp")
  valid_590046 = validateParameter(valid_590046, JString, required = false,
                                 default = nil)
  if valid_590046 != nil:
    section.add "userIp", valid_590046
  var valid_590047 = query.getOrDefault("key")
  valid_590047 = validateParameter(valid_590047, JString, required = false,
                                 default = nil)
  if valid_590047 != nil:
    section.add "key", valid_590047
  var valid_590048 = query.getOrDefault("prettyPrint")
  valid_590048 = validateParameter(valid_590048, JBool, required = false,
                                 default = newJBool(true))
  if valid_590048 != nil:
    section.add "prettyPrint", valid_590048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590050: Call_ContentOrdersUpdateshipment_590037; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a shipment's status, carrier, and/or tracking ID.
  ## 
  let valid = call_590050.validator(path, query, header, formData, body)
  let scheme = call_590050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590050.url(scheme.get, call_590050.host, call_590050.base,
                         call_590050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590050, url, valid)

proc call*(call_590051: Call_ContentOrdersUpdateshipment_590037; orderId: string;
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
  var path_590052 = newJObject()
  var query_590053 = newJObject()
  var body_590054 = newJObject()
  add(query_590053, "fields", newJString(fields))
  add(query_590053, "quotaUser", newJString(quotaUser))
  add(query_590053, "alt", newJString(alt))
  add(query_590053, "oauth_token", newJString(oauthToken))
  add(query_590053, "userIp", newJString(userIp))
  add(path_590052, "orderId", newJString(orderId))
  add(query_590053, "key", newJString(key))
  add(path_590052, "merchantId", newJString(merchantId))
  if body != nil:
    body_590054 = body
  add(query_590053, "prettyPrint", newJBool(prettyPrint))
  result = call_590051.call(path_590052, query_590053, nil, nil, body_590054)

var contentOrdersUpdateshipment* = Call_ContentOrdersUpdateshipment_590037(
    name: "contentOrdersUpdateshipment", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateShipment",
    validator: validate_ContentOrdersUpdateshipment_590038, base: "/content/v2.1",
    url: url_ContentOrdersUpdateshipment_590039, schemes: {Scheme.Https})
type
  Call_ContentOrdersGetbymerchantorderid_590055 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersGetbymerchantorderid_590057(protocol: Scheme; host: string;
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

proc validate_ContentOrdersGetbymerchantorderid_590056(path: JsonNode;
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
  var valid_590058 = path.getOrDefault("merchantOrderId")
  valid_590058 = validateParameter(valid_590058, JString, required = true,
                                 default = nil)
  if valid_590058 != nil:
    section.add "merchantOrderId", valid_590058
  var valid_590059 = path.getOrDefault("merchantId")
  valid_590059 = validateParameter(valid_590059, JString, required = true,
                                 default = nil)
  if valid_590059 != nil:
    section.add "merchantId", valid_590059
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590060 = query.getOrDefault("fields")
  valid_590060 = validateParameter(valid_590060, JString, required = false,
                                 default = nil)
  if valid_590060 != nil:
    section.add "fields", valid_590060
  var valid_590061 = query.getOrDefault("quotaUser")
  valid_590061 = validateParameter(valid_590061, JString, required = false,
                                 default = nil)
  if valid_590061 != nil:
    section.add "quotaUser", valid_590061
  var valid_590062 = query.getOrDefault("alt")
  valid_590062 = validateParameter(valid_590062, JString, required = false,
                                 default = newJString("json"))
  if valid_590062 != nil:
    section.add "alt", valid_590062
  var valid_590063 = query.getOrDefault("oauth_token")
  valid_590063 = validateParameter(valid_590063, JString, required = false,
                                 default = nil)
  if valid_590063 != nil:
    section.add "oauth_token", valid_590063
  var valid_590064 = query.getOrDefault("userIp")
  valid_590064 = validateParameter(valid_590064, JString, required = false,
                                 default = nil)
  if valid_590064 != nil:
    section.add "userIp", valid_590064
  var valid_590065 = query.getOrDefault("key")
  valid_590065 = validateParameter(valid_590065, JString, required = false,
                                 default = nil)
  if valid_590065 != nil:
    section.add "key", valid_590065
  var valid_590066 = query.getOrDefault("prettyPrint")
  valid_590066 = validateParameter(valid_590066, JBool, required = false,
                                 default = newJBool(true))
  if valid_590066 != nil:
    section.add "prettyPrint", valid_590066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590067: Call_ContentOrdersGetbymerchantorderid_590055;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves an order using merchant order ID.
  ## 
  let valid = call_590067.validator(path, query, header, formData, body)
  let scheme = call_590067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590067.url(scheme.get, call_590067.host, call_590067.base,
                         call_590067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590067, url, valid)

proc call*(call_590068: Call_ContentOrdersGetbymerchantorderid_590055;
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
  var path_590069 = newJObject()
  var query_590070 = newJObject()
  add(query_590070, "fields", newJString(fields))
  add(query_590070, "quotaUser", newJString(quotaUser))
  add(query_590070, "alt", newJString(alt))
  add(query_590070, "oauth_token", newJString(oauthToken))
  add(query_590070, "userIp", newJString(userIp))
  add(query_590070, "key", newJString(key))
  add(path_590069, "merchantOrderId", newJString(merchantOrderId))
  add(path_590069, "merchantId", newJString(merchantId))
  add(query_590070, "prettyPrint", newJBool(prettyPrint))
  result = call_590068.call(path_590069, query_590070, nil, nil, nil)

var contentOrdersGetbymerchantorderid* = Call_ContentOrdersGetbymerchantorderid_590055(
    name: "contentOrdersGetbymerchantorderid", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/ordersbymerchantid/{merchantOrderId}",
    validator: validate_ContentOrdersGetbymerchantorderid_590056,
    base: "/content/v2.1", url: url_ContentOrdersGetbymerchantorderid_590057,
    schemes: {Scheme.Https})
type
  Call_ContentPosInventory_590071 = ref object of OpenApiRestCall_588450
proc url_ContentPosInventory_590073(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosInventory_590072(path: JsonNode; query: JsonNode;
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
  var valid_590074 = path.getOrDefault("targetMerchantId")
  valid_590074 = validateParameter(valid_590074, JString, required = true,
                                 default = nil)
  if valid_590074 != nil:
    section.add "targetMerchantId", valid_590074
  var valid_590075 = path.getOrDefault("merchantId")
  valid_590075 = validateParameter(valid_590075, JString, required = true,
                                 default = nil)
  if valid_590075 != nil:
    section.add "merchantId", valid_590075
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590076 = query.getOrDefault("fields")
  valid_590076 = validateParameter(valid_590076, JString, required = false,
                                 default = nil)
  if valid_590076 != nil:
    section.add "fields", valid_590076
  var valid_590077 = query.getOrDefault("quotaUser")
  valid_590077 = validateParameter(valid_590077, JString, required = false,
                                 default = nil)
  if valid_590077 != nil:
    section.add "quotaUser", valid_590077
  var valid_590078 = query.getOrDefault("alt")
  valid_590078 = validateParameter(valid_590078, JString, required = false,
                                 default = newJString("json"))
  if valid_590078 != nil:
    section.add "alt", valid_590078
  var valid_590079 = query.getOrDefault("oauth_token")
  valid_590079 = validateParameter(valid_590079, JString, required = false,
                                 default = nil)
  if valid_590079 != nil:
    section.add "oauth_token", valid_590079
  var valid_590080 = query.getOrDefault("userIp")
  valid_590080 = validateParameter(valid_590080, JString, required = false,
                                 default = nil)
  if valid_590080 != nil:
    section.add "userIp", valid_590080
  var valid_590081 = query.getOrDefault("key")
  valid_590081 = validateParameter(valid_590081, JString, required = false,
                                 default = nil)
  if valid_590081 != nil:
    section.add "key", valid_590081
  var valid_590082 = query.getOrDefault("prettyPrint")
  valid_590082 = validateParameter(valid_590082, JBool, required = false,
                                 default = newJBool(true))
  if valid_590082 != nil:
    section.add "prettyPrint", valid_590082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590084: Call_ContentPosInventory_590071; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit inventory for the given merchant.
  ## 
  let valid = call_590084.validator(path, query, header, formData, body)
  let scheme = call_590084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590084.url(scheme.get, call_590084.host, call_590084.base,
                         call_590084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590084, url, valid)

proc call*(call_590085: Call_ContentPosInventory_590071; targetMerchantId: string;
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
  var path_590086 = newJObject()
  var query_590087 = newJObject()
  var body_590088 = newJObject()
  add(query_590087, "fields", newJString(fields))
  add(query_590087, "quotaUser", newJString(quotaUser))
  add(query_590087, "alt", newJString(alt))
  add(path_590086, "targetMerchantId", newJString(targetMerchantId))
  add(query_590087, "oauth_token", newJString(oauthToken))
  add(query_590087, "userIp", newJString(userIp))
  add(query_590087, "key", newJString(key))
  add(path_590086, "merchantId", newJString(merchantId))
  if body != nil:
    body_590088 = body
  add(query_590087, "prettyPrint", newJBool(prettyPrint))
  result = call_590085.call(path_590086, query_590087, nil, nil, body_590088)

var contentPosInventory* = Call_ContentPosInventory_590071(
    name: "contentPosInventory", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/inventory",
    validator: validate_ContentPosInventory_590072, base: "/content/v2.1",
    url: url_ContentPosInventory_590073, schemes: {Scheme.Https})
type
  Call_ContentPosSale_590089 = ref object of OpenApiRestCall_588450
proc url_ContentPosSale_590091(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosSale_590090(path: JsonNode; query: JsonNode;
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
  var valid_590092 = path.getOrDefault("targetMerchantId")
  valid_590092 = validateParameter(valid_590092, JString, required = true,
                                 default = nil)
  if valid_590092 != nil:
    section.add "targetMerchantId", valid_590092
  var valid_590093 = path.getOrDefault("merchantId")
  valid_590093 = validateParameter(valid_590093, JString, required = true,
                                 default = nil)
  if valid_590093 != nil:
    section.add "merchantId", valid_590093
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590094 = query.getOrDefault("fields")
  valid_590094 = validateParameter(valid_590094, JString, required = false,
                                 default = nil)
  if valid_590094 != nil:
    section.add "fields", valid_590094
  var valid_590095 = query.getOrDefault("quotaUser")
  valid_590095 = validateParameter(valid_590095, JString, required = false,
                                 default = nil)
  if valid_590095 != nil:
    section.add "quotaUser", valid_590095
  var valid_590096 = query.getOrDefault("alt")
  valid_590096 = validateParameter(valid_590096, JString, required = false,
                                 default = newJString("json"))
  if valid_590096 != nil:
    section.add "alt", valid_590096
  var valid_590097 = query.getOrDefault("oauth_token")
  valid_590097 = validateParameter(valid_590097, JString, required = false,
                                 default = nil)
  if valid_590097 != nil:
    section.add "oauth_token", valid_590097
  var valid_590098 = query.getOrDefault("userIp")
  valid_590098 = validateParameter(valid_590098, JString, required = false,
                                 default = nil)
  if valid_590098 != nil:
    section.add "userIp", valid_590098
  var valid_590099 = query.getOrDefault("key")
  valid_590099 = validateParameter(valid_590099, JString, required = false,
                                 default = nil)
  if valid_590099 != nil:
    section.add "key", valid_590099
  var valid_590100 = query.getOrDefault("prettyPrint")
  valid_590100 = validateParameter(valid_590100, JBool, required = false,
                                 default = newJBool(true))
  if valid_590100 != nil:
    section.add "prettyPrint", valid_590100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590102: Call_ContentPosSale_590089; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit a sale event for the given merchant.
  ## 
  let valid = call_590102.validator(path, query, header, formData, body)
  let scheme = call_590102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590102.url(scheme.get, call_590102.host, call_590102.base,
                         call_590102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590102, url, valid)

proc call*(call_590103: Call_ContentPosSale_590089; targetMerchantId: string;
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
  var path_590104 = newJObject()
  var query_590105 = newJObject()
  var body_590106 = newJObject()
  add(query_590105, "fields", newJString(fields))
  add(query_590105, "quotaUser", newJString(quotaUser))
  add(query_590105, "alt", newJString(alt))
  add(path_590104, "targetMerchantId", newJString(targetMerchantId))
  add(query_590105, "oauth_token", newJString(oauthToken))
  add(query_590105, "userIp", newJString(userIp))
  add(query_590105, "key", newJString(key))
  add(path_590104, "merchantId", newJString(merchantId))
  if body != nil:
    body_590106 = body
  add(query_590105, "prettyPrint", newJBool(prettyPrint))
  result = call_590103.call(path_590104, query_590105, nil, nil, body_590106)

var contentPosSale* = Call_ContentPosSale_590089(name: "contentPosSale",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/sale",
    validator: validate_ContentPosSale_590090, base: "/content/v2.1",
    url: url_ContentPosSale_590091, schemes: {Scheme.Https})
type
  Call_ContentPosInsert_590123 = ref object of OpenApiRestCall_588450
proc url_ContentPosInsert_590125(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosInsert_590124(path: JsonNode; query: JsonNode;
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
  var valid_590126 = path.getOrDefault("targetMerchantId")
  valid_590126 = validateParameter(valid_590126, JString, required = true,
                                 default = nil)
  if valid_590126 != nil:
    section.add "targetMerchantId", valid_590126
  var valid_590127 = path.getOrDefault("merchantId")
  valid_590127 = validateParameter(valid_590127, JString, required = true,
                                 default = nil)
  if valid_590127 != nil:
    section.add "merchantId", valid_590127
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590128 = query.getOrDefault("fields")
  valid_590128 = validateParameter(valid_590128, JString, required = false,
                                 default = nil)
  if valid_590128 != nil:
    section.add "fields", valid_590128
  var valid_590129 = query.getOrDefault("quotaUser")
  valid_590129 = validateParameter(valid_590129, JString, required = false,
                                 default = nil)
  if valid_590129 != nil:
    section.add "quotaUser", valid_590129
  var valid_590130 = query.getOrDefault("alt")
  valid_590130 = validateParameter(valid_590130, JString, required = false,
                                 default = newJString("json"))
  if valid_590130 != nil:
    section.add "alt", valid_590130
  var valid_590131 = query.getOrDefault("oauth_token")
  valid_590131 = validateParameter(valid_590131, JString, required = false,
                                 default = nil)
  if valid_590131 != nil:
    section.add "oauth_token", valid_590131
  var valid_590132 = query.getOrDefault("userIp")
  valid_590132 = validateParameter(valid_590132, JString, required = false,
                                 default = nil)
  if valid_590132 != nil:
    section.add "userIp", valid_590132
  var valid_590133 = query.getOrDefault("key")
  valid_590133 = validateParameter(valid_590133, JString, required = false,
                                 default = nil)
  if valid_590133 != nil:
    section.add "key", valid_590133
  var valid_590134 = query.getOrDefault("prettyPrint")
  valid_590134 = validateParameter(valid_590134, JBool, required = false,
                                 default = newJBool(true))
  if valid_590134 != nil:
    section.add "prettyPrint", valid_590134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590136: Call_ContentPosInsert_590123; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a store for the given merchant.
  ## 
  let valid = call_590136.validator(path, query, header, formData, body)
  let scheme = call_590136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590136.url(scheme.get, call_590136.host, call_590136.base,
                         call_590136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590136, url, valid)

proc call*(call_590137: Call_ContentPosInsert_590123; targetMerchantId: string;
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
  var path_590138 = newJObject()
  var query_590139 = newJObject()
  var body_590140 = newJObject()
  add(query_590139, "fields", newJString(fields))
  add(query_590139, "quotaUser", newJString(quotaUser))
  add(query_590139, "alt", newJString(alt))
  add(path_590138, "targetMerchantId", newJString(targetMerchantId))
  add(query_590139, "oauth_token", newJString(oauthToken))
  add(query_590139, "userIp", newJString(userIp))
  add(query_590139, "key", newJString(key))
  add(path_590138, "merchantId", newJString(merchantId))
  if body != nil:
    body_590140 = body
  add(query_590139, "prettyPrint", newJBool(prettyPrint))
  result = call_590137.call(path_590138, query_590139, nil, nil, body_590140)

var contentPosInsert* = Call_ContentPosInsert_590123(name: "contentPosInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store",
    validator: validate_ContentPosInsert_590124, base: "/content/v2.1",
    url: url_ContentPosInsert_590125, schemes: {Scheme.Https})
type
  Call_ContentPosList_590107 = ref object of OpenApiRestCall_588450
proc url_ContentPosList_590109(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosList_590108(path: JsonNode; query: JsonNode;
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
  var valid_590110 = path.getOrDefault("targetMerchantId")
  valid_590110 = validateParameter(valid_590110, JString, required = true,
                                 default = nil)
  if valid_590110 != nil:
    section.add "targetMerchantId", valid_590110
  var valid_590111 = path.getOrDefault("merchantId")
  valid_590111 = validateParameter(valid_590111, JString, required = true,
                                 default = nil)
  if valid_590111 != nil:
    section.add "merchantId", valid_590111
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590112 = query.getOrDefault("fields")
  valid_590112 = validateParameter(valid_590112, JString, required = false,
                                 default = nil)
  if valid_590112 != nil:
    section.add "fields", valid_590112
  var valid_590113 = query.getOrDefault("quotaUser")
  valid_590113 = validateParameter(valid_590113, JString, required = false,
                                 default = nil)
  if valid_590113 != nil:
    section.add "quotaUser", valid_590113
  var valid_590114 = query.getOrDefault("alt")
  valid_590114 = validateParameter(valid_590114, JString, required = false,
                                 default = newJString("json"))
  if valid_590114 != nil:
    section.add "alt", valid_590114
  var valid_590115 = query.getOrDefault("oauth_token")
  valid_590115 = validateParameter(valid_590115, JString, required = false,
                                 default = nil)
  if valid_590115 != nil:
    section.add "oauth_token", valid_590115
  var valid_590116 = query.getOrDefault("userIp")
  valid_590116 = validateParameter(valid_590116, JString, required = false,
                                 default = nil)
  if valid_590116 != nil:
    section.add "userIp", valid_590116
  var valid_590117 = query.getOrDefault("key")
  valid_590117 = validateParameter(valid_590117, JString, required = false,
                                 default = nil)
  if valid_590117 != nil:
    section.add "key", valid_590117
  var valid_590118 = query.getOrDefault("prettyPrint")
  valid_590118 = validateParameter(valid_590118, JBool, required = false,
                                 default = newJBool(true))
  if valid_590118 != nil:
    section.add "prettyPrint", valid_590118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590119: Call_ContentPosList_590107; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the stores of the target merchant.
  ## 
  let valid = call_590119.validator(path, query, header, formData, body)
  let scheme = call_590119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590119.url(scheme.get, call_590119.host, call_590119.base,
                         call_590119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590119, url, valid)

proc call*(call_590120: Call_ContentPosList_590107; targetMerchantId: string;
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
  var path_590121 = newJObject()
  var query_590122 = newJObject()
  add(query_590122, "fields", newJString(fields))
  add(query_590122, "quotaUser", newJString(quotaUser))
  add(query_590122, "alt", newJString(alt))
  add(path_590121, "targetMerchantId", newJString(targetMerchantId))
  add(query_590122, "oauth_token", newJString(oauthToken))
  add(query_590122, "userIp", newJString(userIp))
  add(query_590122, "key", newJString(key))
  add(path_590121, "merchantId", newJString(merchantId))
  add(query_590122, "prettyPrint", newJBool(prettyPrint))
  result = call_590120.call(path_590121, query_590122, nil, nil, nil)

var contentPosList* = Call_ContentPosList_590107(name: "contentPosList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store",
    validator: validate_ContentPosList_590108, base: "/content/v2.1",
    url: url_ContentPosList_590109, schemes: {Scheme.Https})
type
  Call_ContentPosGet_590141 = ref object of OpenApiRestCall_588450
proc url_ContentPosGet_590143(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosGet_590142(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_590144 = path.getOrDefault("targetMerchantId")
  valid_590144 = validateParameter(valid_590144, JString, required = true,
                                 default = nil)
  if valid_590144 != nil:
    section.add "targetMerchantId", valid_590144
  var valid_590145 = path.getOrDefault("storeCode")
  valid_590145 = validateParameter(valid_590145, JString, required = true,
                                 default = nil)
  if valid_590145 != nil:
    section.add "storeCode", valid_590145
  var valid_590146 = path.getOrDefault("merchantId")
  valid_590146 = validateParameter(valid_590146, JString, required = true,
                                 default = nil)
  if valid_590146 != nil:
    section.add "merchantId", valid_590146
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590147 = query.getOrDefault("fields")
  valid_590147 = validateParameter(valid_590147, JString, required = false,
                                 default = nil)
  if valid_590147 != nil:
    section.add "fields", valid_590147
  var valid_590148 = query.getOrDefault("quotaUser")
  valid_590148 = validateParameter(valid_590148, JString, required = false,
                                 default = nil)
  if valid_590148 != nil:
    section.add "quotaUser", valid_590148
  var valid_590149 = query.getOrDefault("alt")
  valid_590149 = validateParameter(valid_590149, JString, required = false,
                                 default = newJString("json"))
  if valid_590149 != nil:
    section.add "alt", valid_590149
  var valid_590150 = query.getOrDefault("oauth_token")
  valid_590150 = validateParameter(valid_590150, JString, required = false,
                                 default = nil)
  if valid_590150 != nil:
    section.add "oauth_token", valid_590150
  var valid_590151 = query.getOrDefault("userIp")
  valid_590151 = validateParameter(valid_590151, JString, required = false,
                                 default = nil)
  if valid_590151 != nil:
    section.add "userIp", valid_590151
  var valid_590152 = query.getOrDefault("key")
  valid_590152 = validateParameter(valid_590152, JString, required = false,
                                 default = nil)
  if valid_590152 != nil:
    section.add "key", valid_590152
  var valid_590153 = query.getOrDefault("prettyPrint")
  valid_590153 = validateParameter(valid_590153, JBool, required = false,
                                 default = newJBool(true))
  if valid_590153 != nil:
    section.add "prettyPrint", valid_590153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590154: Call_ContentPosGet_590141; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about the given store.
  ## 
  let valid = call_590154.validator(path, query, header, formData, body)
  let scheme = call_590154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590154.url(scheme.get, call_590154.host, call_590154.base,
                         call_590154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590154, url, valid)

proc call*(call_590155: Call_ContentPosGet_590141; targetMerchantId: string;
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
  var path_590156 = newJObject()
  var query_590157 = newJObject()
  add(query_590157, "fields", newJString(fields))
  add(query_590157, "quotaUser", newJString(quotaUser))
  add(query_590157, "alt", newJString(alt))
  add(path_590156, "targetMerchantId", newJString(targetMerchantId))
  add(query_590157, "oauth_token", newJString(oauthToken))
  add(path_590156, "storeCode", newJString(storeCode))
  add(query_590157, "userIp", newJString(userIp))
  add(query_590157, "key", newJString(key))
  add(path_590156, "merchantId", newJString(merchantId))
  add(query_590157, "prettyPrint", newJBool(prettyPrint))
  result = call_590155.call(path_590156, query_590157, nil, nil, nil)

var contentPosGet* = Call_ContentPosGet_590141(name: "contentPosGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store/{storeCode}",
    validator: validate_ContentPosGet_590142, base: "/content/v2.1",
    url: url_ContentPosGet_590143, schemes: {Scheme.Https})
type
  Call_ContentPosDelete_590158 = ref object of OpenApiRestCall_588450
proc url_ContentPosDelete_590160(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosDelete_590159(path: JsonNode; query: JsonNode;
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
  var valid_590161 = path.getOrDefault("targetMerchantId")
  valid_590161 = validateParameter(valid_590161, JString, required = true,
                                 default = nil)
  if valid_590161 != nil:
    section.add "targetMerchantId", valid_590161
  var valid_590162 = path.getOrDefault("storeCode")
  valid_590162 = validateParameter(valid_590162, JString, required = true,
                                 default = nil)
  if valid_590162 != nil:
    section.add "storeCode", valid_590162
  var valid_590163 = path.getOrDefault("merchantId")
  valid_590163 = validateParameter(valid_590163, JString, required = true,
                                 default = nil)
  if valid_590163 != nil:
    section.add "merchantId", valid_590163
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590164 = query.getOrDefault("fields")
  valid_590164 = validateParameter(valid_590164, JString, required = false,
                                 default = nil)
  if valid_590164 != nil:
    section.add "fields", valid_590164
  var valid_590165 = query.getOrDefault("quotaUser")
  valid_590165 = validateParameter(valid_590165, JString, required = false,
                                 default = nil)
  if valid_590165 != nil:
    section.add "quotaUser", valid_590165
  var valid_590166 = query.getOrDefault("alt")
  valid_590166 = validateParameter(valid_590166, JString, required = false,
                                 default = newJString("json"))
  if valid_590166 != nil:
    section.add "alt", valid_590166
  var valid_590167 = query.getOrDefault("oauth_token")
  valid_590167 = validateParameter(valid_590167, JString, required = false,
                                 default = nil)
  if valid_590167 != nil:
    section.add "oauth_token", valid_590167
  var valid_590168 = query.getOrDefault("userIp")
  valid_590168 = validateParameter(valid_590168, JString, required = false,
                                 default = nil)
  if valid_590168 != nil:
    section.add "userIp", valid_590168
  var valid_590169 = query.getOrDefault("key")
  valid_590169 = validateParameter(valid_590169, JString, required = false,
                                 default = nil)
  if valid_590169 != nil:
    section.add "key", valid_590169
  var valid_590170 = query.getOrDefault("prettyPrint")
  valid_590170 = validateParameter(valid_590170, JBool, required = false,
                                 default = newJBool(true))
  if valid_590170 != nil:
    section.add "prettyPrint", valid_590170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590171: Call_ContentPosDelete_590158; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a store for the given merchant.
  ## 
  let valid = call_590171.validator(path, query, header, formData, body)
  let scheme = call_590171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590171.url(scheme.get, call_590171.host, call_590171.base,
                         call_590171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590171, url, valid)

proc call*(call_590172: Call_ContentPosDelete_590158; targetMerchantId: string;
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
  var path_590173 = newJObject()
  var query_590174 = newJObject()
  add(query_590174, "fields", newJString(fields))
  add(query_590174, "quotaUser", newJString(quotaUser))
  add(query_590174, "alt", newJString(alt))
  add(path_590173, "targetMerchantId", newJString(targetMerchantId))
  add(query_590174, "oauth_token", newJString(oauthToken))
  add(path_590173, "storeCode", newJString(storeCode))
  add(query_590174, "userIp", newJString(userIp))
  add(query_590174, "key", newJString(key))
  add(path_590173, "merchantId", newJString(merchantId))
  add(query_590174, "prettyPrint", newJBool(prettyPrint))
  result = call_590172.call(path_590173, query_590174, nil, nil, nil)

var contentPosDelete* = Call_ContentPosDelete_590158(name: "contentPosDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store/{storeCode}",
    validator: validate_ContentPosDelete_590159, base: "/content/v2.1",
    url: url_ContentPosDelete_590160, schemes: {Scheme.Https})
type
  Call_ContentProductsInsert_590192 = ref object of OpenApiRestCall_588450
proc url_ContentProductsInsert_590194(protocol: Scheme; host: string; base: string;
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

proc validate_ContentProductsInsert_590193(path: JsonNode; query: JsonNode;
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
  var valid_590195 = path.getOrDefault("merchantId")
  valid_590195 = validateParameter(valid_590195, JString, required = true,
                                 default = nil)
  if valid_590195 != nil:
    section.add "merchantId", valid_590195
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
  var valid_590196 = query.getOrDefault("fields")
  valid_590196 = validateParameter(valid_590196, JString, required = false,
                                 default = nil)
  if valid_590196 != nil:
    section.add "fields", valid_590196
  var valid_590197 = query.getOrDefault("quotaUser")
  valid_590197 = validateParameter(valid_590197, JString, required = false,
                                 default = nil)
  if valid_590197 != nil:
    section.add "quotaUser", valid_590197
  var valid_590198 = query.getOrDefault("alt")
  valid_590198 = validateParameter(valid_590198, JString, required = false,
                                 default = newJString("json"))
  if valid_590198 != nil:
    section.add "alt", valid_590198
  var valid_590199 = query.getOrDefault("feedId")
  valid_590199 = validateParameter(valid_590199, JString, required = false,
                                 default = nil)
  if valid_590199 != nil:
    section.add "feedId", valid_590199
  var valid_590200 = query.getOrDefault("oauth_token")
  valid_590200 = validateParameter(valid_590200, JString, required = false,
                                 default = nil)
  if valid_590200 != nil:
    section.add "oauth_token", valid_590200
  var valid_590201 = query.getOrDefault("userIp")
  valid_590201 = validateParameter(valid_590201, JString, required = false,
                                 default = nil)
  if valid_590201 != nil:
    section.add "userIp", valid_590201
  var valid_590202 = query.getOrDefault("key")
  valid_590202 = validateParameter(valid_590202, JString, required = false,
                                 default = nil)
  if valid_590202 != nil:
    section.add "key", valid_590202
  var valid_590203 = query.getOrDefault("prettyPrint")
  valid_590203 = validateParameter(valid_590203, JBool, required = false,
                                 default = newJBool(true))
  if valid_590203 != nil:
    section.add "prettyPrint", valid_590203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590205: Call_ContentProductsInsert_590192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a product to your Merchant Center account. If an item with the same channel, contentLanguage, offerId, and targetCountry already exists, this method updates that entry.
  ## 
  let valid = call_590205.validator(path, query, header, formData, body)
  let scheme = call_590205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590205.url(scheme.get, call_590205.host, call_590205.base,
                         call_590205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590205, url, valid)

proc call*(call_590206: Call_ContentProductsInsert_590192; merchantId: string;
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
  var path_590207 = newJObject()
  var query_590208 = newJObject()
  var body_590209 = newJObject()
  add(query_590208, "fields", newJString(fields))
  add(query_590208, "quotaUser", newJString(quotaUser))
  add(query_590208, "alt", newJString(alt))
  add(query_590208, "feedId", newJString(feedId))
  add(query_590208, "oauth_token", newJString(oauthToken))
  add(query_590208, "userIp", newJString(userIp))
  add(query_590208, "key", newJString(key))
  add(path_590207, "merchantId", newJString(merchantId))
  if body != nil:
    body_590209 = body
  add(query_590208, "prettyPrint", newJBool(prettyPrint))
  result = call_590206.call(path_590207, query_590208, nil, nil, body_590209)

var contentProductsInsert* = Call_ContentProductsInsert_590192(
    name: "contentProductsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/products",
    validator: validate_ContentProductsInsert_590193, base: "/content/v2.1",
    url: url_ContentProductsInsert_590194, schemes: {Scheme.Https})
type
  Call_ContentProductsList_590175 = ref object of OpenApiRestCall_588450
proc url_ContentProductsList_590177(protocol: Scheme; host: string; base: string;
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

proc validate_ContentProductsList_590176(path: JsonNode; query: JsonNode;
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
  var valid_590178 = path.getOrDefault("merchantId")
  valid_590178 = validateParameter(valid_590178, JString, required = true,
                                 default = nil)
  if valid_590178 != nil:
    section.add "merchantId", valid_590178
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
  var valid_590179 = query.getOrDefault("fields")
  valid_590179 = validateParameter(valid_590179, JString, required = false,
                                 default = nil)
  if valid_590179 != nil:
    section.add "fields", valid_590179
  var valid_590180 = query.getOrDefault("pageToken")
  valid_590180 = validateParameter(valid_590180, JString, required = false,
                                 default = nil)
  if valid_590180 != nil:
    section.add "pageToken", valid_590180
  var valid_590181 = query.getOrDefault("quotaUser")
  valid_590181 = validateParameter(valid_590181, JString, required = false,
                                 default = nil)
  if valid_590181 != nil:
    section.add "quotaUser", valid_590181
  var valid_590182 = query.getOrDefault("alt")
  valid_590182 = validateParameter(valid_590182, JString, required = false,
                                 default = newJString("json"))
  if valid_590182 != nil:
    section.add "alt", valid_590182
  var valid_590183 = query.getOrDefault("oauth_token")
  valid_590183 = validateParameter(valid_590183, JString, required = false,
                                 default = nil)
  if valid_590183 != nil:
    section.add "oauth_token", valid_590183
  var valid_590184 = query.getOrDefault("userIp")
  valid_590184 = validateParameter(valid_590184, JString, required = false,
                                 default = nil)
  if valid_590184 != nil:
    section.add "userIp", valid_590184
  var valid_590185 = query.getOrDefault("maxResults")
  valid_590185 = validateParameter(valid_590185, JInt, required = false, default = nil)
  if valid_590185 != nil:
    section.add "maxResults", valid_590185
  var valid_590186 = query.getOrDefault("key")
  valid_590186 = validateParameter(valid_590186, JString, required = false,
                                 default = nil)
  if valid_590186 != nil:
    section.add "key", valid_590186
  var valid_590187 = query.getOrDefault("prettyPrint")
  valid_590187 = validateParameter(valid_590187, JBool, required = false,
                                 default = newJBool(true))
  if valid_590187 != nil:
    section.add "prettyPrint", valid_590187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590188: Call_ContentProductsList_590175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the products in your Merchant Center account.
  ## 
  let valid = call_590188.validator(path, query, header, formData, body)
  let scheme = call_590188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590188.url(scheme.get, call_590188.host, call_590188.base,
                         call_590188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590188, url, valid)

proc call*(call_590189: Call_ContentProductsList_590175; merchantId: string;
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
  var path_590190 = newJObject()
  var query_590191 = newJObject()
  add(query_590191, "fields", newJString(fields))
  add(query_590191, "pageToken", newJString(pageToken))
  add(query_590191, "quotaUser", newJString(quotaUser))
  add(query_590191, "alt", newJString(alt))
  add(query_590191, "oauth_token", newJString(oauthToken))
  add(query_590191, "userIp", newJString(userIp))
  add(query_590191, "maxResults", newJInt(maxResults))
  add(query_590191, "key", newJString(key))
  add(path_590190, "merchantId", newJString(merchantId))
  add(query_590191, "prettyPrint", newJBool(prettyPrint))
  result = call_590189.call(path_590190, query_590191, nil, nil, nil)

var contentProductsList* = Call_ContentProductsList_590175(
    name: "contentProductsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/products",
    validator: validate_ContentProductsList_590176, base: "/content/v2.1",
    url: url_ContentProductsList_590177, schemes: {Scheme.Https})
type
  Call_ContentProductsGet_590210 = ref object of OpenApiRestCall_588450
proc url_ContentProductsGet_590212(protocol: Scheme; host: string; base: string;
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

proc validate_ContentProductsGet_590211(path: JsonNode; query: JsonNode;
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
  var valid_590213 = path.getOrDefault("merchantId")
  valid_590213 = validateParameter(valid_590213, JString, required = true,
                                 default = nil)
  if valid_590213 != nil:
    section.add "merchantId", valid_590213
  var valid_590214 = path.getOrDefault("productId")
  valid_590214 = validateParameter(valid_590214, JString, required = true,
                                 default = nil)
  if valid_590214 != nil:
    section.add "productId", valid_590214
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590215 = query.getOrDefault("fields")
  valid_590215 = validateParameter(valid_590215, JString, required = false,
                                 default = nil)
  if valid_590215 != nil:
    section.add "fields", valid_590215
  var valid_590216 = query.getOrDefault("quotaUser")
  valid_590216 = validateParameter(valid_590216, JString, required = false,
                                 default = nil)
  if valid_590216 != nil:
    section.add "quotaUser", valid_590216
  var valid_590217 = query.getOrDefault("alt")
  valid_590217 = validateParameter(valid_590217, JString, required = false,
                                 default = newJString("json"))
  if valid_590217 != nil:
    section.add "alt", valid_590217
  var valid_590218 = query.getOrDefault("oauth_token")
  valid_590218 = validateParameter(valid_590218, JString, required = false,
                                 default = nil)
  if valid_590218 != nil:
    section.add "oauth_token", valid_590218
  var valid_590219 = query.getOrDefault("userIp")
  valid_590219 = validateParameter(valid_590219, JString, required = false,
                                 default = nil)
  if valid_590219 != nil:
    section.add "userIp", valid_590219
  var valid_590220 = query.getOrDefault("key")
  valid_590220 = validateParameter(valid_590220, JString, required = false,
                                 default = nil)
  if valid_590220 != nil:
    section.add "key", valid_590220
  var valid_590221 = query.getOrDefault("prettyPrint")
  valid_590221 = validateParameter(valid_590221, JBool, required = false,
                                 default = newJBool(true))
  if valid_590221 != nil:
    section.add "prettyPrint", valid_590221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590222: Call_ContentProductsGet_590210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a product from your Merchant Center account.
  ## 
  let valid = call_590222.validator(path, query, header, formData, body)
  let scheme = call_590222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590222.url(scheme.get, call_590222.host, call_590222.base,
                         call_590222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590222, url, valid)

proc call*(call_590223: Call_ContentProductsGet_590210; merchantId: string;
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
  var path_590224 = newJObject()
  var query_590225 = newJObject()
  add(query_590225, "fields", newJString(fields))
  add(query_590225, "quotaUser", newJString(quotaUser))
  add(query_590225, "alt", newJString(alt))
  add(query_590225, "oauth_token", newJString(oauthToken))
  add(query_590225, "userIp", newJString(userIp))
  add(query_590225, "key", newJString(key))
  add(path_590224, "merchantId", newJString(merchantId))
  add(path_590224, "productId", newJString(productId))
  add(query_590225, "prettyPrint", newJBool(prettyPrint))
  result = call_590223.call(path_590224, query_590225, nil, nil, nil)

var contentProductsGet* = Call_ContentProductsGet_590210(
    name: "contentProductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/products/{productId}",
    validator: validate_ContentProductsGet_590211, base: "/content/v2.1",
    url: url_ContentProductsGet_590212, schemes: {Scheme.Https})
type
  Call_ContentProductsDelete_590226 = ref object of OpenApiRestCall_588450
proc url_ContentProductsDelete_590228(protocol: Scheme; host: string; base: string;
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

proc validate_ContentProductsDelete_590227(path: JsonNode; query: JsonNode;
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
  var valid_590229 = path.getOrDefault("merchantId")
  valid_590229 = validateParameter(valid_590229, JString, required = true,
                                 default = nil)
  if valid_590229 != nil:
    section.add "merchantId", valid_590229
  var valid_590230 = path.getOrDefault("productId")
  valid_590230 = validateParameter(valid_590230, JString, required = true,
                                 default = nil)
  if valid_590230 != nil:
    section.add "productId", valid_590230
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
  var valid_590231 = query.getOrDefault("fields")
  valid_590231 = validateParameter(valid_590231, JString, required = false,
                                 default = nil)
  if valid_590231 != nil:
    section.add "fields", valid_590231
  var valid_590232 = query.getOrDefault("quotaUser")
  valid_590232 = validateParameter(valid_590232, JString, required = false,
                                 default = nil)
  if valid_590232 != nil:
    section.add "quotaUser", valid_590232
  var valid_590233 = query.getOrDefault("alt")
  valid_590233 = validateParameter(valid_590233, JString, required = false,
                                 default = newJString("json"))
  if valid_590233 != nil:
    section.add "alt", valid_590233
  var valid_590234 = query.getOrDefault("feedId")
  valid_590234 = validateParameter(valid_590234, JString, required = false,
                                 default = nil)
  if valid_590234 != nil:
    section.add "feedId", valid_590234
  var valid_590235 = query.getOrDefault("oauth_token")
  valid_590235 = validateParameter(valid_590235, JString, required = false,
                                 default = nil)
  if valid_590235 != nil:
    section.add "oauth_token", valid_590235
  var valid_590236 = query.getOrDefault("userIp")
  valid_590236 = validateParameter(valid_590236, JString, required = false,
                                 default = nil)
  if valid_590236 != nil:
    section.add "userIp", valid_590236
  var valid_590237 = query.getOrDefault("key")
  valid_590237 = validateParameter(valid_590237, JString, required = false,
                                 default = nil)
  if valid_590237 != nil:
    section.add "key", valid_590237
  var valid_590238 = query.getOrDefault("prettyPrint")
  valid_590238 = validateParameter(valid_590238, JBool, required = false,
                                 default = newJBool(true))
  if valid_590238 != nil:
    section.add "prettyPrint", valid_590238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590239: Call_ContentProductsDelete_590226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a product from your Merchant Center account.
  ## 
  let valid = call_590239.validator(path, query, header, formData, body)
  let scheme = call_590239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590239.url(scheme.get, call_590239.host, call_590239.base,
                         call_590239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590239, url, valid)

proc call*(call_590240: Call_ContentProductsDelete_590226; merchantId: string;
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
  var path_590241 = newJObject()
  var query_590242 = newJObject()
  add(query_590242, "fields", newJString(fields))
  add(query_590242, "quotaUser", newJString(quotaUser))
  add(query_590242, "alt", newJString(alt))
  add(query_590242, "feedId", newJString(feedId))
  add(query_590242, "oauth_token", newJString(oauthToken))
  add(query_590242, "userIp", newJString(userIp))
  add(query_590242, "key", newJString(key))
  add(path_590241, "merchantId", newJString(merchantId))
  add(path_590241, "productId", newJString(productId))
  add(query_590242, "prettyPrint", newJBool(prettyPrint))
  result = call_590240.call(path_590241, query_590242, nil, nil, nil)

var contentProductsDelete* = Call_ContentProductsDelete_590226(
    name: "contentProductsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/products/{productId}",
    validator: validate_ContentProductsDelete_590227, base: "/content/v2.1",
    url: url_ContentProductsDelete_590228, schemes: {Scheme.Https})
type
  Call_ContentRegionalinventoryInsert_590243 = ref object of OpenApiRestCall_588450
proc url_ContentRegionalinventoryInsert_590245(protocol: Scheme; host: string;
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

proc validate_ContentRegionalinventoryInsert_590244(path: JsonNode;
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
  var valid_590246 = path.getOrDefault("merchantId")
  valid_590246 = validateParameter(valid_590246, JString, required = true,
                                 default = nil)
  if valid_590246 != nil:
    section.add "merchantId", valid_590246
  var valid_590247 = path.getOrDefault("productId")
  valid_590247 = validateParameter(valid_590247, JString, required = true,
                                 default = nil)
  if valid_590247 != nil:
    section.add "productId", valid_590247
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
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

proc call*(call_590256: Call_ContentRegionalinventoryInsert_590243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the regional inventory of a product in your Merchant Center account. If a regional inventory with the same region ID already exists, this method updates that entry.
  ## 
  let valid = call_590256.validator(path, query, header, formData, body)
  let scheme = call_590256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590256.url(scheme.get, call_590256.host, call_590256.base,
                         call_590256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590256, url, valid)

proc call*(call_590257: Call_ContentRegionalinventoryInsert_590243;
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
  var path_590258 = newJObject()
  var query_590259 = newJObject()
  var body_590260 = newJObject()
  add(query_590259, "fields", newJString(fields))
  add(query_590259, "quotaUser", newJString(quotaUser))
  add(query_590259, "alt", newJString(alt))
  add(query_590259, "oauth_token", newJString(oauthToken))
  add(query_590259, "userIp", newJString(userIp))
  add(query_590259, "key", newJString(key))
  add(path_590258, "merchantId", newJString(merchantId))
  if body != nil:
    body_590260 = body
  add(query_590259, "prettyPrint", newJBool(prettyPrint))
  add(path_590258, "productId", newJString(productId))
  result = call_590257.call(path_590258, query_590259, nil, nil, body_590260)

var contentRegionalinventoryInsert* = Call_ContentRegionalinventoryInsert_590243(
    name: "contentRegionalinventoryInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/products/{productId}/regionalinventory",
    validator: validate_ContentRegionalinventoryInsert_590244,
    base: "/content/v2.1", url: url_ContentRegionalinventoryInsert_590245,
    schemes: {Scheme.Https})
type
  Call_ContentProductstatusesList_590261 = ref object of OpenApiRestCall_588450
proc url_ContentProductstatusesList_590263(protocol: Scheme; host: string;
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

proc validate_ContentProductstatusesList_590262(path: JsonNode; query: JsonNode;
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
  var valid_590264 = path.getOrDefault("merchantId")
  valid_590264 = validateParameter(valid_590264, JString, required = true,
                                 default = nil)
  if valid_590264 != nil:
    section.add "merchantId", valid_590264
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
  var valid_590265 = query.getOrDefault("fields")
  valid_590265 = validateParameter(valid_590265, JString, required = false,
                                 default = nil)
  if valid_590265 != nil:
    section.add "fields", valid_590265
  var valid_590266 = query.getOrDefault("pageToken")
  valid_590266 = validateParameter(valid_590266, JString, required = false,
                                 default = nil)
  if valid_590266 != nil:
    section.add "pageToken", valid_590266
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
  var valid_590271 = query.getOrDefault("maxResults")
  valid_590271 = validateParameter(valid_590271, JInt, required = false, default = nil)
  if valid_590271 != nil:
    section.add "maxResults", valid_590271
  var valid_590272 = query.getOrDefault("key")
  valid_590272 = validateParameter(valid_590272, JString, required = false,
                                 default = nil)
  if valid_590272 != nil:
    section.add "key", valid_590272
  var valid_590273 = query.getOrDefault("prettyPrint")
  valid_590273 = validateParameter(valid_590273, JBool, required = false,
                                 default = newJBool(true))
  if valid_590273 != nil:
    section.add "prettyPrint", valid_590273
  var valid_590274 = query.getOrDefault("destinations")
  valid_590274 = validateParameter(valid_590274, JArray, required = false,
                                 default = nil)
  if valid_590274 != nil:
    section.add "destinations", valid_590274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590275: Call_ContentProductstatusesList_590261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the products in your Merchant Center account.
  ## 
  let valid = call_590275.validator(path, query, header, formData, body)
  let scheme = call_590275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590275.url(scheme.get, call_590275.host, call_590275.base,
                         call_590275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590275, url, valid)

proc call*(call_590276: Call_ContentProductstatusesList_590261; merchantId: string;
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
  var path_590277 = newJObject()
  var query_590278 = newJObject()
  add(query_590278, "fields", newJString(fields))
  add(query_590278, "pageToken", newJString(pageToken))
  add(query_590278, "quotaUser", newJString(quotaUser))
  add(query_590278, "alt", newJString(alt))
  add(query_590278, "oauth_token", newJString(oauthToken))
  add(query_590278, "userIp", newJString(userIp))
  add(query_590278, "maxResults", newJInt(maxResults))
  add(query_590278, "key", newJString(key))
  add(path_590277, "merchantId", newJString(merchantId))
  add(query_590278, "prettyPrint", newJBool(prettyPrint))
  if destinations != nil:
    query_590278.add "destinations", destinations
  result = call_590276.call(path_590277, query_590278, nil, nil, nil)

var contentProductstatusesList* = Call_ContentProductstatusesList_590261(
    name: "contentProductstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/productstatuses",
    validator: validate_ContentProductstatusesList_590262, base: "/content/v2.1",
    url: url_ContentProductstatusesList_590263, schemes: {Scheme.Https})
type
  Call_ContentProductstatusesGet_590279 = ref object of OpenApiRestCall_588450
proc url_ContentProductstatusesGet_590281(protocol: Scheme; host: string;
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

proc validate_ContentProductstatusesGet_590280(path: JsonNode; query: JsonNode;
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
  var valid_590282 = path.getOrDefault("merchantId")
  valid_590282 = validateParameter(valid_590282, JString, required = true,
                                 default = nil)
  if valid_590282 != nil:
    section.add "merchantId", valid_590282
  var valid_590283 = path.getOrDefault("productId")
  valid_590283 = validateParameter(valid_590283, JString, required = true,
                                 default = nil)
  if valid_590283 != nil:
    section.add "productId", valid_590283
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
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
  var valid_590284 = query.getOrDefault("fields")
  valid_590284 = validateParameter(valid_590284, JString, required = false,
                                 default = nil)
  if valid_590284 != nil:
    section.add "fields", valid_590284
  var valid_590285 = query.getOrDefault("quotaUser")
  valid_590285 = validateParameter(valid_590285, JString, required = false,
                                 default = nil)
  if valid_590285 != nil:
    section.add "quotaUser", valid_590285
  var valid_590286 = query.getOrDefault("alt")
  valid_590286 = validateParameter(valid_590286, JString, required = false,
                                 default = newJString("json"))
  if valid_590286 != nil:
    section.add "alt", valid_590286
  var valid_590287 = query.getOrDefault("oauth_token")
  valid_590287 = validateParameter(valid_590287, JString, required = false,
                                 default = nil)
  if valid_590287 != nil:
    section.add "oauth_token", valid_590287
  var valid_590288 = query.getOrDefault("userIp")
  valid_590288 = validateParameter(valid_590288, JString, required = false,
                                 default = nil)
  if valid_590288 != nil:
    section.add "userIp", valid_590288
  var valid_590289 = query.getOrDefault("key")
  valid_590289 = validateParameter(valid_590289, JString, required = false,
                                 default = nil)
  if valid_590289 != nil:
    section.add "key", valid_590289
  var valid_590290 = query.getOrDefault("prettyPrint")
  valid_590290 = validateParameter(valid_590290, JBool, required = false,
                                 default = newJBool(true))
  if valid_590290 != nil:
    section.add "prettyPrint", valid_590290
  var valid_590291 = query.getOrDefault("destinations")
  valid_590291 = validateParameter(valid_590291, JArray, required = false,
                                 default = nil)
  if valid_590291 != nil:
    section.add "destinations", valid_590291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590292: Call_ContentProductstatusesGet_590279; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the status of a product from your Merchant Center account.
  ## 
  let valid = call_590292.validator(path, query, header, formData, body)
  let scheme = call_590292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590292.url(scheme.get, call_590292.host, call_590292.base,
                         call_590292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590292, url, valid)

proc call*(call_590293: Call_ContentProductstatusesGet_590279; merchantId: string;
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
  var path_590294 = newJObject()
  var query_590295 = newJObject()
  add(query_590295, "fields", newJString(fields))
  add(query_590295, "quotaUser", newJString(quotaUser))
  add(query_590295, "alt", newJString(alt))
  add(query_590295, "oauth_token", newJString(oauthToken))
  add(query_590295, "userIp", newJString(userIp))
  add(query_590295, "key", newJString(key))
  add(path_590294, "merchantId", newJString(merchantId))
  add(path_590294, "productId", newJString(productId))
  add(query_590295, "prettyPrint", newJBool(prettyPrint))
  if destinations != nil:
    query_590295.add "destinations", destinations
  result = call_590293.call(path_590294, query_590295, nil, nil, nil)

var contentProductstatusesGet* = Call_ContentProductstatusesGet_590279(
    name: "contentProductstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/productstatuses/{productId}",
    validator: validate_ContentProductstatusesGet_590280, base: "/content/v2.1",
    url: url_ContentProductstatusesGet_590281, schemes: {Scheme.Https})
type
  Call_ContentReturnaddressInsert_590314 = ref object of OpenApiRestCall_588450
proc url_ContentReturnaddressInsert_590316(protocol: Scheme; host: string;
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

proc validate_ContentReturnaddressInsert_590315(path: JsonNode; query: JsonNode;
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
  var valid_590317 = path.getOrDefault("merchantId")
  valid_590317 = validateParameter(valid_590317, JString, required = true,
                                 default = nil)
  if valid_590317 != nil:
    section.add "merchantId", valid_590317
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590318 = query.getOrDefault("fields")
  valid_590318 = validateParameter(valid_590318, JString, required = false,
                                 default = nil)
  if valid_590318 != nil:
    section.add "fields", valid_590318
  var valid_590319 = query.getOrDefault("quotaUser")
  valid_590319 = validateParameter(valid_590319, JString, required = false,
                                 default = nil)
  if valid_590319 != nil:
    section.add "quotaUser", valid_590319
  var valid_590320 = query.getOrDefault("alt")
  valid_590320 = validateParameter(valid_590320, JString, required = false,
                                 default = newJString("json"))
  if valid_590320 != nil:
    section.add "alt", valid_590320
  var valid_590321 = query.getOrDefault("oauth_token")
  valid_590321 = validateParameter(valid_590321, JString, required = false,
                                 default = nil)
  if valid_590321 != nil:
    section.add "oauth_token", valid_590321
  var valid_590322 = query.getOrDefault("userIp")
  valid_590322 = validateParameter(valid_590322, JString, required = false,
                                 default = nil)
  if valid_590322 != nil:
    section.add "userIp", valid_590322
  var valid_590323 = query.getOrDefault("key")
  valid_590323 = validateParameter(valid_590323, JString, required = false,
                                 default = nil)
  if valid_590323 != nil:
    section.add "key", valid_590323
  var valid_590324 = query.getOrDefault("prettyPrint")
  valid_590324 = validateParameter(valid_590324, JBool, required = false,
                                 default = newJBool(true))
  if valid_590324 != nil:
    section.add "prettyPrint", valid_590324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590326: Call_ContentReturnaddressInsert_590314; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a return address for the Merchant Center account.
  ## 
  let valid = call_590326.validator(path, query, header, formData, body)
  let scheme = call_590326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590326.url(scheme.get, call_590326.host, call_590326.base,
                         call_590326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590326, url, valid)

proc call*(call_590327: Call_ContentReturnaddressInsert_590314; merchantId: string;
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
  var path_590328 = newJObject()
  var query_590329 = newJObject()
  var body_590330 = newJObject()
  add(query_590329, "fields", newJString(fields))
  add(query_590329, "quotaUser", newJString(quotaUser))
  add(query_590329, "alt", newJString(alt))
  add(query_590329, "oauth_token", newJString(oauthToken))
  add(query_590329, "userIp", newJString(userIp))
  add(query_590329, "key", newJString(key))
  add(path_590328, "merchantId", newJString(merchantId))
  if body != nil:
    body_590330 = body
  add(query_590329, "prettyPrint", newJBool(prettyPrint))
  result = call_590327.call(path_590328, query_590329, nil, nil, body_590330)

var contentReturnaddressInsert* = Call_ContentReturnaddressInsert_590314(
    name: "contentReturnaddressInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/returnaddress",
    validator: validate_ContentReturnaddressInsert_590315, base: "/content/v2.1",
    url: url_ContentReturnaddressInsert_590316, schemes: {Scheme.Https})
type
  Call_ContentReturnaddressList_590296 = ref object of OpenApiRestCall_588450
proc url_ContentReturnaddressList_590298(protocol: Scheme; host: string;
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

proc validate_ContentReturnaddressList_590297(path: JsonNode; query: JsonNode;
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
  var valid_590299 = path.getOrDefault("merchantId")
  valid_590299 = validateParameter(valid_590299, JString, required = true,
                                 default = nil)
  if valid_590299 != nil:
    section.add "merchantId", valid_590299
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
  var valid_590300 = query.getOrDefault("fields")
  valid_590300 = validateParameter(valid_590300, JString, required = false,
                                 default = nil)
  if valid_590300 != nil:
    section.add "fields", valid_590300
  var valid_590301 = query.getOrDefault("country")
  valid_590301 = validateParameter(valid_590301, JString, required = false,
                                 default = nil)
  if valid_590301 != nil:
    section.add "country", valid_590301
  var valid_590302 = query.getOrDefault("quotaUser")
  valid_590302 = validateParameter(valid_590302, JString, required = false,
                                 default = nil)
  if valid_590302 != nil:
    section.add "quotaUser", valid_590302
  var valid_590303 = query.getOrDefault("pageToken")
  valid_590303 = validateParameter(valid_590303, JString, required = false,
                                 default = nil)
  if valid_590303 != nil:
    section.add "pageToken", valid_590303
  var valid_590304 = query.getOrDefault("alt")
  valid_590304 = validateParameter(valid_590304, JString, required = false,
                                 default = newJString("json"))
  if valid_590304 != nil:
    section.add "alt", valid_590304
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
  var valid_590307 = query.getOrDefault("maxResults")
  valid_590307 = validateParameter(valid_590307, JInt, required = false, default = nil)
  if valid_590307 != nil:
    section.add "maxResults", valid_590307
  var valid_590308 = query.getOrDefault("key")
  valid_590308 = validateParameter(valid_590308, JString, required = false,
                                 default = nil)
  if valid_590308 != nil:
    section.add "key", valid_590308
  var valid_590309 = query.getOrDefault("prettyPrint")
  valid_590309 = validateParameter(valid_590309, JBool, required = false,
                                 default = newJBool(true))
  if valid_590309 != nil:
    section.add "prettyPrint", valid_590309
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590310: Call_ContentReturnaddressList_590296; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the return addresses of the Merchant Center account.
  ## 
  let valid = call_590310.validator(path, query, header, formData, body)
  let scheme = call_590310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590310.url(scheme.get, call_590310.host, call_590310.base,
                         call_590310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590310, url, valid)

proc call*(call_590311: Call_ContentReturnaddressList_590296; merchantId: string;
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
  var path_590312 = newJObject()
  var query_590313 = newJObject()
  add(query_590313, "fields", newJString(fields))
  add(query_590313, "country", newJString(country))
  add(query_590313, "quotaUser", newJString(quotaUser))
  add(query_590313, "pageToken", newJString(pageToken))
  add(query_590313, "alt", newJString(alt))
  add(query_590313, "oauth_token", newJString(oauthToken))
  add(query_590313, "userIp", newJString(userIp))
  add(query_590313, "maxResults", newJInt(maxResults))
  add(query_590313, "key", newJString(key))
  add(path_590312, "merchantId", newJString(merchantId))
  add(query_590313, "prettyPrint", newJBool(prettyPrint))
  result = call_590311.call(path_590312, query_590313, nil, nil, nil)

var contentReturnaddressList* = Call_ContentReturnaddressList_590296(
    name: "contentReturnaddressList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/returnaddress",
    validator: validate_ContentReturnaddressList_590297, base: "/content/v2.1",
    url: url_ContentReturnaddressList_590298, schemes: {Scheme.Https})
type
  Call_ContentReturnaddressGet_590331 = ref object of OpenApiRestCall_588450
proc url_ContentReturnaddressGet_590333(protocol: Scheme; host: string; base: string;
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

proc validate_ContentReturnaddressGet_590332(path: JsonNode; query: JsonNode;
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
  var valid_590334 = path.getOrDefault("returnAddressId")
  valid_590334 = validateParameter(valid_590334, JString, required = true,
                                 default = nil)
  if valid_590334 != nil:
    section.add "returnAddressId", valid_590334
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
  var valid_590339 = query.getOrDefault("oauth_token")
  valid_590339 = validateParameter(valid_590339, JString, required = false,
                                 default = nil)
  if valid_590339 != nil:
    section.add "oauth_token", valid_590339
  var valid_590340 = query.getOrDefault("userIp")
  valid_590340 = validateParameter(valid_590340, JString, required = false,
                                 default = nil)
  if valid_590340 != nil:
    section.add "userIp", valid_590340
  var valid_590341 = query.getOrDefault("key")
  valid_590341 = validateParameter(valid_590341, JString, required = false,
                                 default = nil)
  if valid_590341 != nil:
    section.add "key", valid_590341
  var valid_590342 = query.getOrDefault("prettyPrint")
  valid_590342 = validateParameter(valid_590342, JBool, required = false,
                                 default = newJBool(true))
  if valid_590342 != nil:
    section.add "prettyPrint", valid_590342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590343: Call_ContentReturnaddressGet_590331; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a return address of the Merchant Center account.
  ## 
  let valid = call_590343.validator(path, query, header, formData, body)
  let scheme = call_590343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590343.url(scheme.get, call_590343.host, call_590343.base,
                         call_590343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590343, url, valid)

proc call*(call_590344: Call_ContentReturnaddressGet_590331;
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
  var path_590345 = newJObject()
  var query_590346 = newJObject()
  add(query_590346, "fields", newJString(fields))
  add(query_590346, "quotaUser", newJString(quotaUser))
  add(query_590346, "alt", newJString(alt))
  add(query_590346, "oauth_token", newJString(oauthToken))
  add(query_590346, "userIp", newJString(userIp))
  add(path_590345, "returnAddressId", newJString(returnAddressId))
  add(query_590346, "key", newJString(key))
  add(path_590345, "merchantId", newJString(merchantId))
  add(query_590346, "prettyPrint", newJBool(prettyPrint))
  result = call_590344.call(path_590345, query_590346, nil, nil, nil)

var contentReturnaddressGet* = Call_ContentReturnaddressGet_590331(
    name: "contentReturnaddressGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/returnaddress/{returnAddressId}",
    validator: validate_ContentReturnaddressGet_590332, base: "/content/v2.1",
    url: url_ContentReturnaddressGet_590333, schemes: {Scheme.Https})
type
  Call_ContentReturnaddressDelete_590347 = ref object of OpenApiRestCall_588450
proc url_ContentReturnaddressDelete_590349(protocol: Scheme; host: string;
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

proc validate_ContentReturnaddressDelete_590348(path: JsonNode; query: JsonNode;
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
  var valid_590350 = path.getOrDefault("returnAddressId")
  valid_590350 = validateParameter(valid_590350, JString, required = true,
                                 default = nil)
  if valid_590350 != nil:
    section.add "returnAddressId", valid_590350
  var valid_590351 = path.getOrDefault("merchantId")
  valid_590351 = validateParameter(valid_590351, JString, required = true,
                                 default = nil)
  if valid_590351 != nil:
    section.add "merchantId", valid_590351
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590352 = query.getOrDefault("fields")
  valid_590352 = validateParameter(valid_590352, JString, required = false,
                                 default = nil)
  if valid_590352 != nil:
    section.add "fields", valid_590352
  var valid_590353 = query.getOrDefault("quotaUser")
  valid_590353 = validateParameter(valid_590353, JString, required = false,
                                 default = nil)
  if valid_590353 != nil:
    section.add "quotaUser", valid_590353
  var valid_590354 = query.getOrDefault("alt")
  valid_590354 = validateParameter(valid_590354, JString, required = false,
                                 default = newJString("json"))
  if valid_590354 != nil:
    section.add "alt", valid_590354
  var valid_590355 = query.getOrDefault("oauth_token")
  valid_590355 = validateParameter(valid_590355, JString, required = false,
                                 default = nil)
  if valid_590355 != nil:
    section.add "oauth_token", valid_590355
  var valid_590356 = query.getOrDefault("userIp")
  valid_590356 = validateParameter(valid_590356, JString, required = false,
                                 default = nil)
  if valid_590356 != nil:
    section.add "userIp", valid_590356
  var valid_590357 = query.getOrDefault("key")
  valid_590357 = validateParameter(valid_590357, JString, required = false,
                                 default = nil)
  if valid_590357 != nil:
    section.add "key", valid_590357
  var valid_590358 = query.getOrDefault("prettyPrint")
  valid_590358 = validateParameter(valid_590358, JBool, required = false,
                                 default = newJBool(true))
  if valid_590358 != nil:
    section.add "prettyPrint", valid_590358
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590359: Call_ContentReturnaddressDelete_590347; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a return address for the given Merchant Center account.
  ## 
  let valid = call_590359.validator(path, query, header, formData, body)
  let scheme = call_590359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590359.url(scheme.get, call_590359.host, call_590359.base,
                         call_590359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590359, url, valid)

proc call*(call_590360: Call_ContentReturnaddressDelete_590347;
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
  var path_590361 = newJObject()
  var query_590362 = newJObject()
  add(query_590362, "fields", newJString(fields))
  add(query_590362, "quotaUser", newJString(quotaUser))
  add(query_590362, "alt", newJString(alt))
  add(query_590362, "oauth_token", newJString(oauthToken))
  add(query_590362, "userIp", newJString(userIp))
  add(path_590361, "returnAddressId", newJString(returnAddressId))
  add(query_590362, "key", newJString(key))
  add(path_590361, "merchantId", newJString(merchantId))
  add(query_590362, "prettyPrint", newJBool(prettyPrint))
  result = call_590360.call(path_590361, query_590362, nil, nil, nil)

var contentReturnaddressDelete* = Call_ContentReturnaddressDelete_590347(
    name: "contentReturnaddressDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{merchantId}/returnaddress/{returnAddressId}",
    validator: validate_ContentReturnaddressDelete_590348, base: "/content/v2.1",
    url: url_ContentReturnaddressDelete_590349, schemes: {Scheme.Https})
type
  Call_ContentReturnpolicyInsert_590378 = ref object of OpenApiRestCall_588450
proc url_ContentReturnpolicyInsert_590380(protocol: Scheme; host: string;
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

proc validate_ContentReturnpolicyInsert_590379(path: JsonNode; query: JsonNode;
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
  var valid_590381 = path.getOrDefault("merchantId")
  valid_590381 = validateParameter(valid_590381, JString, required = true,
                                 default = nil)
  if valid_590381 != nil:
    section.add "merchantId", valid_590381
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590382 = query.getOrDefault("fields")
  valid_590382 = validateParameter(valid_590382, JString, required = false,
                                 default = nil)
  if valid_590382 != nil:
    section.add "fields", valid_590382
  var valid_590383 = query.getOrDefault("quotaUser")
  valid_590383 = validateParameter(valid_590383, JString, required = false,
                                 default = nil)
  if valid_590383 != nil:
    section.add "quotaUser", valid_590383
  var valid_590384 = query.getOrDefault("alt")
  valid_590384 = validateParameter(valid_590384, JString, required = false,
                                 default = newJString("json"))
  if valid_590384 != nil:
    section.add "alt", valid_590384
  var valid_590385 = query.getOrDefault("oauth_token")
  valid_590385 = validateParameter(valid_590385, JString, required = false,
                                 default = nil)
  if valid_590385 != nil:
    section.add "oauth_token", valid_590385
  var valid_590386 = query.getOrDefault("userIp")
  valid_590386 = validateParameter(valid_590386, JString, required = false,
                                 default = nil)
  if valid_590386 != nil:
    section.add "userIp", valid_590386
  var valid_590387 = query.getOrDefault("key")
  valid_590387 = validateParameter(valid_590387, JString, required = false,
                                 default = nil)
  if valid_590387 != nil:
    section.add "key", valid_590387
  var valid_590388 = query.getOrDefault("prettyPrint")
  valid_590388 = validateParameter(valid_590388, JBool, required = false,
                                 default = newJBool(true))
  if valid_590388 != nil:
    section.add "prettyPrint", valid_590388
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590390: Call_ContentReturnpolicyInsert_590378; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a return policy for the Merchant Center account.
  ## 
  let valid = call_590390.validator(path, query, header, formData, body)
  let scheme = call_590390.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590390.url(scheme.get, call_590390.host, call_590390.base,
                         call_590390.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590390, url, valid)

proc call*(call_590391: Call_ContentReturnpolicyInsert_590378; merchantId: string;
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
  var path_590392 = newJObject()
  var query_590393 = newJObject()
  var body_590394 = newJObject()
  add(query_590393, "fields", newJString(fields))
  add(query_590393, "quotaUser", newJString(quotaUser))
  add(query_590393, "alt", newJString(alt))
  add(query_590393, "oauth_token", newJString(oauthToken))
  add(query_590393, "userIp", newJString(userIp))
  add(query_590393, "key", newJString(key))
  add(path_590392, "merchantId", newJString(merchantId))
  if body != nil:
    body_590394 = body
  add(query_590393, "prettyPrint", newJBool(prettyPrint))
  result = call_590391.call(path_590392, query_590393, nil, nil, body_590394)

var contentReturnpolicyInsert* = Call_ContentReturnpolicyInsert_590378(
    name: "contentReturnpolicyInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/returnpolicy",
    validator: validate_ContentReturnpolicyInsert_590379, base: "/content/v2.1",
    url: url_ContentReturnpolicyInsert_590380, schemes: {Scheme.Https})
type
  Call_ContentReturnpolicyList_590363 = ref object of OpenApiRestCall_588450
proc url_ContentReturnpolicyList_590365(protocol: Scheme; host: string; base: string;
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

proc validate_ContentReturnpolicyList_590364(path: JsonNode; query: JsonNode;
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
  var valid_590366 = path.getOrDefault("merchantId")
  valid_590366 = validateParameter(valid_590366, JString, required = true,
                                 default = nil)
  if valid_590366 != nil:
    section.add "merchantId", valid_590366
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590367 = query.getOrDefault("fields")
  valid_590367 = validateParameter(valid_590367, JString, required = false,
                                 default = nil)
  if valid_590367 != nil:
    section.add "fields", valid_590367
  var valid_590368 = query.getOrDefault("quotaUser")
  valid_590368 = validateParameter(valid_590368, JString, required = false,
                                 default = nil)
  if valid_590368 != nil:
    section.add "quotaUser", valid_590368
  var valid_590369 = query.getOrDefault("alt")
  valid_590369 = validateParameter(valid_590369, JString, required = false,
                                 default = newJString("json"))
  if valid_590369 != nil:
    section.add "alt", valid_590369
  var valid_590370 = query.getOrDefault("oauth_token")
  valid_590370 = validateParameter(valid_590370, JString, required = false,
                                 default = nil)
  if valid_590370 != nil:
    section.add "oauth_token", valid_590370
  var valid_590371 = query.getOrDefault("userIp")
  valid_590371 = validateParameter(valid_590371, JString, required = false,
                                 default = nil)
  if valid_590371 != nil:
    section.add "userIp", valid_590371
  var valid_590372 = query.getOrDefault("key")
  valid_590372 = validateParameter(valid_590372, JString, required = false,
                                 default = nil)
  if valid_590372 != nil:
    section.add "key", valid_590372
  var valid_590373 = query.getOrDefault("prettyPrint")
  valid_590373 = validateParameter(valid_590373, JBool, required = false,
                                 default = newJBool(true))
  if valid_590373 != nil:
    section.add "prettyPrint", valid_590373
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590374: Call_ContentReturnpolicyList_590363; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the return policies of the Merchant Center account.
  ## 
  let valid = call_590374.validator(path, query, header, formData, body)
  let scheme = call_590374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590374.url(scheme.get, call_590374.host, call_590374.base,
                         call_590374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590374, url, valid)

proc call*(call_590375: Call_ContentReturnpolicyList_590363; merchantId: string;
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
  var path_590376 = newJObject()
  var query_590377 = newJObject()
  add(query_590377, "fields", newJString(fields))
  add(query_590377, "quotaUser", newJString(quotaUser))
  add(query_590377, "alt", newJString(alt))
  add(query_590377, "oauth_token", newJString(oauthToken))
  add(query_590377, "userIp", newJString(userIp))
  add(query_590377, "key", newJString(key))
  add(path_590376, "merchantId", newJString(merchantId))
  add(query_590377, "prettyPrint", newJBool(prettyPrint))
  result = call_590375.call(path_590376, query_590377, nil, nil, nil)

var contentReturnpolicyList* = Call_ContentReturnpolicyList_590363(
    name: "contentReturnpolicyList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/returnpolicy",
    validator: validate_ContentReturnpolicyList_590364, base: "/content/v2.1",
    url: url_ContentReturnpolicyList_590365, schemes: {Scheme.Https})
type
  Call_ContentReturnpolicyGet_590395 = ref object of OpenApiRestCall_588450
proc url_ContentReturnpolicyGet_590397(protocol: Scheme; host: string; base: string;
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

proc validate_ContentReturnpolicyGet_590396(path: JsonNode; query: JsonNode;
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
  var valid_590398 = path.getOrDefault("returnPolicyId")
  valid_590398 = validateParameter(valid_590398, JString, required = true,
                                 default = nil)
  if valid_590398 != nil:
    section.add "returnPolicyId", valid_590398
  var valid_590399 = path.getOrDefault("merchantId")
  valid_590399 = validateParameter(valid_590399, JString, required = true,
                                 default = nil)
  if valid_590399 != nil:
    section.add "merchantId", valid_590399
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590400 = query.getOrDefault("fields")
  valid_590400 = validateParameter(valid_590400, JString, required = false,
                                 default = nil)
  if valid_590400 != nil:
    section.add "fields", valid_590400
  var valid_590401 = query.getOrDefault("quotaUser")
  valid_590401 = validateParameter(valid_590401, JString, required = false,
                                 default = nil)
  if valid_590401 != nil:
    section.add "quotaUser", valid_590401
  var valid_590402 = query.getOrDefault("alt")
  valid_590402 = validateParameter(valid_590402, JString, required = false,
                                 default = newJString("json"))
  if valid_590402 != nil:
    section.add "alt", valid_590402
  var valid_590403 = query.getOrDefault("oauth_token")
  valid_590403 = validateParameter(valid_590403, JString, required = false,
                                 default = nil)
  if valid_590403 != nil:
    section.add "oauth_token", valid_590403
  var valid_590404 = query.getOrDefault("userIp")
  valid_590404 = validateParameter(valid_590404, JString, required = false,
                                 default = nil)
  if valid_590404 != nil:
    section.add "userIp", valid_590404
  var valid_590405 = query.getOrDefault("key")
  valid_590405 = validateParameter(valid_590405, JString, required = false,
                                 default = nil)
  if valid_590405 != nil:
    section.add "key", valid_590405
  var valid_590406 = query.getOrDefault("prettyPrint")
  valid_590406 = validateParameter(valid_590406, JBool, required = false,
                                 default = newJBool(true))
  if valid_590406 != nil:
    section.add "prettyPrint", valid_590406
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590407: Call_ContentReturnpolicyGet_590395; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a return policy of the Merchant Center account.
  ## 
  let valid = call_590407.validator(path, query, header, formData, body)
  let scheme = call_590407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590407.url(scheme.get, call_590407.host, call_590407.base,
                         call_590407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590407, url, valid)

proc call*(call_590408: Call_ContentReturnpolicyGet_590395; returnPolicyId: string;
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
  var path_590409 = newJObject()
  var query_590410 = newJObject()
  add(query_590410, "fields", newJString(fields))
  add(query_590410, "quotaUser", newJString(quotaUser))
  add(query_590410, "alt", newJString(alt))
  add(path_590409, "returnPolicyId", newJString(returnPolicyId))
  add(query_590410, "oauth_token", newJString(oauthToken))
  add(query_590410, "userIp", newJString(userIp))
  add(query_590410, "key", newJString(key))
  add(path_590409, "merchantId", newJString(merchantId))
  add(query_590410, "prettyPrint", newJBool(prettyPrint))
  result = call_590408.call(path_590409, query_590410, nil, nil, nil)

var contentReturnpolicyGet* = Call_ContentReturnpolicyGet_590395(
    name: "contentReturnpolicyGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/returnpolicy/{returnPolicyId}",
    validator: validate_ContentReturnpolicyGet_590396, base: "/content/v2.1",
    url: url_ContentReturnpolicyGet_590397, schemes: {Scheme.Https})
type
  Call_ContentReturnpolicyDelete_590411 = ref object of OpenApiRestCall_588450
proc url_ContentReturnpolicyDelete_590413(protocol: Scheme; host: string;
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

proc validate_ContentReturnpolicyDelete_590412(path: JsonNode; query: JsonNode;
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
  var valid_590414 = path.getOrDefault("returnPolicyId")
  valid_590414 = validateParameter(valid_590414, JString, required = true,
                                 default = nil)
  if valid_590414 != nil:
    section.add "returnPolicyId", valid_590414
  var valid_590415 = path.getOrDefault("merchantId")
  valid_590415 = validateParameter(valid_590415, JString, required = true,
                                 default = nil)
  if valid_590415 != nil:
    section.add "merchantId", valid_590415
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590416 = query.getOrDefault("fields")
  valid_590416 = validateParameter(valid_590416, JString, required = false,
                                 default = nil)
  if valid_590416 != nil:
    section.add "fields", valid_590416
  var valid_590417 = query.getOrDefault("quotaUser")
  valid_590417 = validateParameter(valid_590417, JString, required = false,
                                 default = nil)
  if valid_590417 != nil:
    section.add "quotaUser", valid_590417
  var valid_590418 = query.getOrDefault("alt")
  valid_590418 = validateParameter(valid_590418, JString, required = false,
                                 default = newJString("json"))
  if valid_590418 != nil:
    section.add "alt", valid_590418
  var valid_590419 = query.getOrDefault("oauth_token")
  valid_590419 = validateParameter(valid_590419, JString, required = false,
                                 default = nil)
  if valid_590419 != nil:
    section.add "oauth_token", valid_590419
  var valid_590420 = query.getOrDefault("userIp")
  valid_590420 = validateParameter(valid_590420, JString, required = false,
                                 default = nil)
  if valid_590420 != nil:
    section.add "userIp", valid_590420
  var valid_590421 = query.getOrDefault("key")
  valid_590421 = validateParameter(valid_590421, JString, required = false,
                                 default = nil)
  if valid_590421 != nil:
    section.add "key", valid_590421
  var valid_590422 = query.getOrDefault("prettyPrint")
  valid_590422 = validateParameter(valid_590422, JBool, required = false,
                                 default = newJBool(true))
  if valid_590422 != nil:
    section.add "prettyPrint", valid_590422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590423: Call_ContentReturnpolicyDelete_590411; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a return policy for the given Merchant Center account.
  ## 
  let valid = call_590423.validator(path, query, header, formData, body)
  let scheme = call_590423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590423.url(scheme.get, call_590423.host, call_590423.base,
                         call_590423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590423, url, valid)

proc call*(call_590424: Call_ContentReturnpolicyDelete_590411;
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
  var path_590425 = newJObject()
  var query_590426 = newJObject()
  add(query_590426, "fields", newJString(fields))
  add(query_590426, "quotaUser", newJString(quotaUser))
  add(query_590426, "alt", newJString(alt))
  add(path_590425, "returnPolicyId", newJString(returnPolicyId))
  add(query_590426, "oauth_token", newJString(oauthToken))
  add(query_590426, "userIp", newJString(userIp))
  add(query_590426, "key", newJString(key))
  add(path_590425, "merchantId", newJString(merchantId))
  add(query_590426, "prettyPrint", newJBool(prettyPrint))
  result = call_590424.call(path_590425, query_590426, nil, nil, nil)

var contentReturnpolicyDelete* = Call_ContentReturnpolicyDelete_590411(
    name: "contentReturnpolicyDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{merchantId}/returnpolicy/{returnPolicyId}",
    validator: validate_ContentReturnpolicyDelete_590412, base: "/content/v2.1",
    url: url_ContentReturnpolicyDelete_590413, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsList_590427 = ref object of OpenApiRestCall_588450
proc url_ContentShippingsettingsList_590429(protocol: Scheme; host: string;
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

proc validate_ContentShippingsettingsList_590428(path: JsonNode; query: JsonNode;
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
  var valid_590430 = path.getOrDefault("merchantId")
  valid_590430 = validateParameter(valid_590430, JString, required = true,
                                 default = nil)
  if valid_590430 != nil:
    section.add "merchantId", valid_590430
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
  var valid_590431 = query.getOrDefault("fields")
  valid_590431 = validateParameter(valid_590431, JString, required = false,
                                 default = nil)
  if valid_590431 != nil:
    section.add "fields", valid_590431
  var valid_590432 = query.getOrDefault("pageToken")
  valid_590432 = validateParameter(valid_590432, JString, required = false,
                                 default = nil)
  if valid_590432 != nil:
    section.add "pageToken", valid_590432
  var valid_590433 = query.getOrDefault("quotaUser")
  valid_590433 = validateParameter(valid_590433, JString, required = false,
                                 default = nil)
  if valid_590433 != nil:
    section.add "quotaUser", valid_590433
  var valid_590434 = query.getOrDefault("alt")
  valid_590434 = validateParameter(valid_590434, JString, required = false,
                                 default = newJString("json"))
  if valid_590434 != nil:
    section.add "alt", valid_590434
  var valid_590435 = query.getOrDefault("oauth_token")
  valid_590435 = validateParameter(valid_590435, JString, required = false,
                                 default = nil)
  if valid_590435 != nil:
    section.add "oauth_token", valid_590435
  var valid_590436 = query.getOrDefault("userIp")
  valid_590436 = validateParameter(valid_590436, JString, required = false,
                                 default = nil)
  if valid_590436 != nil:
    section.add "userIp", valid_590436
  var valid_590437 = query.getOrDefault("maxResults")
  valid_590437 = validateParameter(valid_590437, JInt, required = false, default = nil)
  if valid_590437 != nil:
    section.add "maxResults", valid_590437
  var valid_590438 = query.getOrDefault("key")
  valid_590438 = validateParameter(valid_590438, JString, required = false,
                                 default = nil)
  if valid_590438 != nil:
    section.add "key", valid_590438
  var valid_590439 = query.getOrDefault("prettyPrint")
  valid_590439 = validateParameter(valid_590439, JBool, required = false,
                                 default = newJBool(true))
  if valid_590439 != nil:
    section.add "prettyPrint", valid_590439
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590440: Call_ContentShippingsettingsList_590427; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the shipping settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_590440.validator(path, query, header, formData, body)
  let scheme = call_590440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590440.url(scheme.get, call_590440.host, call_590440.base,
                         call_590440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590440, url, valid)

proc call*(call_590441: Call_ContentShippingsettingsList_590427;
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
  var path_590442 = newJObject()
  var query_590443 = newJObject()
  add(query_590443, "fields", newJString(fields))
  add(query_590443, "pageToken", newJString(pageToken))
  add(query_590443, "quotaUser", newJString(quotaUser))
  add(query_590443, "alt", newJString(alt))
  add(query_590443, "oauth_token", newJString(oauthToken))
  add(query_590443, "userIp", newJString(userIp))
  add(query_590443, "maxResults", newJInt(maxResults))
  add(query_590443, "key", newJString(key))
  add(path_590442, "merchantId", newJString(merchantId))
  add(query_590443, "prettyPrint", newJBool(prettyPrint))
  result = call_590441.call(path_590442, query_590443, nil, nil, nil)

var contentShippingsettingsList* = Call_ContentShippingsettingsList_590427(
    name: "contentShippingsettingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/shippingsettings",
    validator: validate_ContentShippingsettingsList_590428, base: "/content/v2.1",
    url: url_ContentShippingsettingsList_590429, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsUpdate_590460 = ref object of OpenApiRestCall_588450
proc url_ContentShippingsettingsUpdate_590462(protocol: Scheme; host: string;
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

proc validate_ContentShippingsettingsUpdate_590461(path: JsonNode; query: JsonNode;
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
  var valid_590463 = path.getOrDefault("accountId")
  valid_590463 = validateParameter(valid_590463, JString, required = true,
                                 default = nil)
  if valid_590463 != nil:
    section.add "accountId", valid_590463
  var valid_590464 = path.getOrDefault("merchantId")
  valid_590464 = validateParameter(valid_590464, JString, required = true,
                                 default = nil)
  if valid_590464 != nil:
    section.add "merchantId", valid_590464
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590465 = query.getOrDefault("fields")
  valid_590465 = validateParameter(valid_590465, JString, required = false,
                                 default = nil)
  if valid_590465 != nil:
    section.add "fields", valid_590465
  var valid_590466 = query.getOrDefault("quotaUser")
  valid_590466 = validateParameter(valid_590466, JString, required = false,
                                 default = nil)
  if valid_590466 != nil:
    section.add "quotaUser", valid_590466
  var valid_590467 = query.getOrDefault("alt")
  valid_590467 = validateParameter(valid_590467, JString, required = false,
                                 default = newJString("json"))
  if valid_590467 != nil:
    section.add "alt", valid_590467
  var valid_590468 = query.getOrDefault("oauth_token")
  valid_590468 = validateParameter(valid_590468, JString, required = false,
                                 default = nil)
  if valid_590468 != nil:
    section.add "oauth_token", valid_590468
  var valid_590469 = query.getOrDefault("userIp")
  valid_590469 = validateParameter(valid_590469, JString, required = false,
                                 default = nil)
  if valid_590469 != nil:
    section.add "userIp", valid_590469
  var valid_590470 = query.getOrDefault("key")
  valid_590470 = validateParameter(valid_590470, JString, required = false,
                                 default = nil)
  if valid_590470 != nil:
    section.add "key", valid_590470
  var valid_590471 = query.getOrDefault("prettyPrint")
  valid_590471 = validateParameter(valid_590471, JBool, required = false,
                                 default = newJBool(true))
  if valid_590471 != nil:
    section.add "prettyPrint", valid_590471
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590473: Call_ContentShippingsettingsUpdate_590460; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the shipping settings of the account.
  ## 
  let valid = call_590473.validator(path, query, header, formData, body)
  let scheme = call_590473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590473.url(scheme.get, call_590473.host, call_590473.base,
                         call_590473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590473, url, valid)

proc call*(call_590474: Call_ContentShippingsettingsUpdate_590460;
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
  var path_590475 = newJObject()
  var query_590476 = newJObject()
  var body_590477 = newJObject()
  add(query_590476, "fields", newJString(fields))
  add(query_590476, "quotaUser", newJString(quotaUser))
  add(query_590476, "alt", newJString(alt))
  add(query_590476, "oauth_token", newJString(oauthToken))
  add(path_590475, "accountId", newJString(accountId))
  add(query_590476, "userIp", newJString(userIp))
  add(query_590476, "key", newJString(key))
  add(path_590475, "merchantId", newJString(merchantId))
  if body != nil:
    body_590477 = body
  add(query_590476, "prettyPrint", newJBool(prettyPrint))
  result = call_590474.call(path_590475, query_590476, nil, nil, body_590477)

var contentShippingsettingsUpdate* = Call_ContentShippingsettingsUpdate_590460(
    name: "contentShippingsettingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{merchantId}/shippingsettings/{accountId}",
    validator: validate_ContentShippingsettingsUpdate_590461,
    base: "/content/v2.1", url: url_ContentShippingsettingsUpdate_590462,
    schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGet_590444 = ref object of OpenApiRestCall_588450
proc url_ContentShippingsettingsGet_590446(protocol: Scheme; host: string;
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

proc validate_ContentShippingsettingsGet_590445(path: JsonNode; query: JsonNode;
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
  var valid_590447 = path.getOrDefault("accountId")
  valid_590447 = validateParameter(valid_590447, JString, required = true,
                                 default = nil)
  if valid_590447 != nil:
    section.add "accountId", valid_590447
  var valid_590448 = path.getOrDefault("merchantId")
  valid_590448 = validateParameter(valid_590448, JString, required = true,
                                 default = nil)
  if valid_590448 != nil:
    section.add "merchantId", valid_590448
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590449 = query.getOrDefault("fields")
  valid_590449 = validateParameter(valid_590449, JString, required = false,
                                 default = nil)
  if valid_590449 != nil:
    section.add "fields", valid_590449
  var valid_590450 = query.getOrDefault("quotaUser")
  valid_590450 = validateParameter(valid_590450, JString, required = false,
                                 default = nil)
  if valid_590450 != nil:
    section.add "quotaUser", valid_590450
  var valid_590451 = query.getOrDefault("alt")
  valid_590451 = validateParameter(valid_590451, JString, required = false,
                                 default = newJString("json"))
  if valid_590451 != nil:
    section.add "alt", valid_590451
  var valid_590452 = query.getOrDefault("oauth_token")
  valid_590452 = validateParameter(valid_590452, JString, required = false,
                                 default = nil)
  if valid_590452 != nil:
    section.add "oauth_token", valid_590452
  var valid_590453 = query.getOrDefault("userIp")
  valid_590453 = validateParameter(valid_590453, JString, required = false,
                                 default = nil)
  if valid_590453 != nil:
    section.add "userIp", valid_590453
  var valid_590454 = query.getOrDefault("key")
  valid_590454 = validateParameter(valid_590454, JString, required = false,
                                 default = nil)
  if valid_590454 != nil:
    section.add "key", valid_590454
  var valid_590455 = query.getOrDefault("prettyPrint")
  valid_590455 = validateParameter(valid_590455, JBool, required = false,
                                 default = newJBool(true))
  if valid_590455 != nil:
    section.add "prettyPrint", valid_590455
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590456: Call_ContentShippingsettingsGet_590444; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the shipping settings of the account.
  ## 
  let valid = call_590456.validator(path, query, header, formData, body)
  let scheme = call_590456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590456.url(scheme.get, call_590456.host, call_590456.base,
                         call_590456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590456, url, valid)

proc call*(call_590457: Call_ContentShippingsettingsGet_590444; accountId: string;
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
  var path_590458 = newJObject()
  var query_590459 = newJObject()
  add(query_590459, "fields", newJString(fields))
  add(query_590459, "quotaUser", newJString(quotaUser))
  add(query_590459, "alt", newJString(alt))
  add(query_590459, "oauth_token", newJString(oauthToken))
  add(path_590458, "accountId", newJString(accountId))
  add(query_590459, "userIp", newJString(userIp))
  add(query_590459, "key", newJString(key))
  add(path_590458, "merchantId", newJString(merchantId))
  add(query_590459, "prettyPrint", newJBool(prettyPrint))
  result = call_590457.call(path_590458, query_590459, nil, nil, nil)

var contentShippingsettingsGet* = Call_ContentShippingsettingsGet_590444(
    name: "contentShippingsettingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/shippingsettings/{accountId}",
    validator: validate_ContentShippingsettingsGet_590445, base: "/content/v2.1",
    url: url_ContentShippingsettingsGet_590446, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGetsupportedcarriers_590478 = ref object of OpenApiRestCall_588450
proc url_ContentShippingsettingsGetsupportedcarriers_590480(protocol: Scheme;
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

proc validate_ContentShippingsettingsGetsupportedcarriers_590479(path: JsonNode;
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
  var valid_590481 = path.getOrDefault("merchantId")
  valid_590481 = validateParameter(valid_590481, JString, required = true,
                                 default = nil)
  if valid_590481 != nil:
    section.add "merchantId", valid_590481
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590482 = query.getOrDefault("fields")
  valid_590482 = validateParameter(valid_590482, JString, required = false,
                                 default = nil)
  if valid_590482 != nil:
    section.add "fields", valid_590482
  var valid_590483 = query.getOrDefault("quotaUser")
  valid_590483 = validateParameter(valid_590483, JString, required = false,
                                 default = nil)
  if valid_590483 != nil:
    section.add "quotaUser", valid_590483
  var valid_590484 = query.getOrDefault("alt")
  valid_590484 = validateParameter(valid_590484, JString, required = false,
                                 default = newJString("json"))
  if valid_590484 != nil:
    section.add "alt", valid_590484
  var valid_590485 = query.getOrDefault("oauth_token")
  valid_590485 = validateParameter(valid_590485, JString, required = false,
                                 default = nil)
  if valid_590485 != nil:
    section.add "oauth_token", valid_590485
  var valid_590486 = query.getOrDefault("userIp")
  valid_590486 = validateParameter(valid_590486, JString, required = false,
                                 default = nil)
  if valid_590486 != nil:
    section.add "userIp", valid_590486
  var valid_590487 = query.getOrDefault("key")
  valid_590487 = validateParameter(valid_590487, JString, required = false,
                                 default = nil)
  if valid_590487 != nil:
    section.add "key", valid_590487
  var valid_590488 = query.getOrDefault("prettyPrint")
  valid_590488 = validateParameter(valid_590488, JBool, required = false,
                                 default = newJBool(true))
  if valid_590488 != nil:
    section.add "prettyPrint", valid_590488
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590489: Call_ContentShippingsettingsGetsupportedcarriers_590478;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves supported carriers and carrier services for an account.
  ## 
  let valid = call_590489.validator(path, query, header, formData, body)
  let scheme = call_590489.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590489.url(scheme.get, call_590489.host, call_590489.base,
                         call_590489.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590489, url, valid)

proc call*(call_590490: Call_ContentShippingsettingsGetsupportedcarriers_590478;
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
  var path_590491 = newJObject()
  var query_590492 = newJObject()
  add(query_590492, "fields", newJString(fields))
  add(query_590492, "quotaUser", newJString(quotaUser))
  add(query_590492, "alt", newJString(alt))
  add(query_590492, "oauth_token", newJString(oauthToken))
  add(query_590492, "userIp", newJString(userIp))
  add(query_590492, "key", newJString(key))
  add(path_590491, "merchantId", newJString(merchantId))
  add(query_590492, "prettyPrint", newJBool(prettyPrint))
  result = call_590490.call(path_590491, query_590492, nil, nil, nil)

var contentShippingsettingsGetsupportedcarriers* = Call_ContentShippingsettingsGetsupportedcarriers_590478(
    name: "contentShippingsettingsGetsupportedcarriers", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/supportedCarriers",
    validator: validate_ContentShippingsettingsGetsupportedcarriers_590479,
    base: "/content/v2.1", url: url_ContentShippingsettingsGetsupportedcarriers_590480,
    schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGetsupportedholidays_590493 = ref object of OpenApiRestCall_588450
proc url_ContentShippingsettingsGetsupportedholidays_590495(protocol: Scheme;
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

proc validate_ContentShippingsettingsGetsupportedholidays_590494(path: JsonNode;
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
  var valid_590496 = path.getOrDefault("merchantId")
  valid_590496 = validateParameter(valid_590496, JString, required = true,
                                 default = nil)
  if valid_590496 != nil:
    section.add "merchantId", valid_590496
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590497 = query.getOrDefault("fields")
  valid_590497 = validateParameter(valid_590497, JString, required = false,
                                 default = nil)
  if valid_590497 != nil:
    section.add "fields", valid_590497
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
  var valid_590502 = query.getOrDefault("key")
  valid_590502 = validateParameter(valid_590502, JString, required = false,
                                 default = nil)
  if valid_590502 != nil:
    section.add "key", valid_590502
  var valid_590503 = query.getOrDefault("prettyPrint")
  valid_590503 = validateParameter(valid_590503, JBool, required = false,
                                 default = newJBool(true))
  if valid_590503 != nil:
    section.add "prettyPrint", valid_590503
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590504: Call_ContentShippingsettingsGetsupportedholidays_590493;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves supported holidays for an account.
  ## 
  let valid = call_590504.validator(path, query, header, formData, body)
  let scheme = call_590504.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590504.url(scheme.get, call_590504.host, call_590504.base,
                         call_590504.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590504, url, valid)

proc call*(call_590505: Call_ContentShippingsettingsGetsupportedholidays_590493;
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
  var path_590506 = newJObject()
  var query_590507 = newJObject()
  add(query_590507, "fields", newJString(fields))
  add(query_590507, "quotaUser", newJString(quotaUser))
  add(query_590507, "alt", newJString(alt))
  add(query_590507, "oauth_token", newJString(oauthToken))
  add(query_590507, "userIp", newJString(userIp))
  add(query_590507, "key", newJString(key))
  add(path_590506, "merchantId", newJString(merchantId))
  add(query_590507, "prettyPrint", newJBool(prettyPrint))
  result = call_590505.call(path_590506, query_590507, nil, nil, nil)

var contentShippingsettingsGetsupportedholidays* = Call_ContentShippingsettingsGetsupportedholidays_590493(
    name: "contentShippingsettingsGetsupportedholidays", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/supportedHolidays",
    validator: validate_ContentShippingsettingsGetsupportedholidays_590494,
    base: "/content/v2.1", url: url_ContentShippingsettingsGetsupportedholidays_590495,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersCreatetestorder_590508 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersCreatetestorder_590510(protocol: Scheme; host: string;
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

proc validate_ContentOrdersCreatetestorder_590509(path: JsonNode; query: JsonNode;
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
  var valid_590511 = path.getOrDefault("merchantId")
  valid_590511 = validateParameter(valid_590511, JString, required = true,
                                 default = nil)
  if valid_590511 != nil:
    section.add "merchantId", valid_590511
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590512 = query.getOrDefault("fields")
  valid_590512 = validateParameter(valid_590512, JString, required = false,
                                 default = nil)
  if valid_590512 != nil:
    section.add "fields", valid_590512
  var valid_590513 = query.getOrDefault("quotaUser")
  valid_590513 = validateParameter(valid_590513, JString, required = false,
                                 default = nil)
  if valid_590513 != nil:
    section.add "quotaUser", valid_590513
  var valid_590514 = query.getOrDefault("alt")
  valid_590514 = validateParameter(valid_590514, JString, required = false,
                                 default = newJString("json"))
  if valid_590514 != nil:
    section.add "alt", valid_590514
  var valid_590515 = query.getOrDefault("oauth_token")
  valid_590515 = validateParameter(valid_590515, JString, required = false,
                                 default = nil)
  if valid_590515 != nil:
    section.add "oauth_token", valid_590515
  var valid_590516 = query.getOrDefault("userIp")
  valid_590516 = validateParameter(valid_590516, JString, required = false,
                                 default = nil)
  if valid_590516 != nil:
    section.add "userIp", valid_590516
  var valid_590517 = query.getOrDefault("key")
  valid_590517 = validateParameter(valid_590517, JString, required = false,
                                 default = nil)
  if valid_590517 != nil:
    section.add "key", valid_590517
  var valid_590518 = query.getOrDefault("prettyPrint")
  valid_590518 = validateParameter(valid_590518, JBool, required = false,
                                 default = newJBool(true))
  if valid_590518 != nil:
    section.add "prettyPrint", valid_590518
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590520: Call_ContentOrdersCreatetestorder_590508; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Creates a test order.
  ## 
  let valid = call_590520.validator(path, query, header, formData, body)
  let scheme = call_590520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590520.url(scheme.get, call_590520.host, call_590520.base,
                         call_590520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590520, url, valid)

proc call*(call_590521: Call_ContentOrdersCreatetestorder_590508;
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
  var path_590522 = newJObject()
  var query_590523 = newJObject()
  var body_590524 = newJObject()
  add(query_590523, "fields", newJString(fields))
  add(query_590523, "quotaUser", newJString(quotaUser))
  add(query_590523, "alt", newJString(alt))
  add(query_590523, "oauth_token", newJString(oauthToken))
  add(query_590523, "userIp", newJString(userIp))
  add(query_590523, "key", newJString(key))
  add(path_590522, "merchantId", newJString(merchantId))
  if body != nil:
    body_590524 = body
  add(query_590523, "prettyPrint", newJBool(prettyPrint))
  result = call_590521.call(path_590522, query_590523, nil, nil, body_590524)

var contentOrdersCreatetestorder* = Call_ContentOrdersCreatetestorder_590508(
    name: "contentOrdersCreatetestorder", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/testorders",
    validator: validate_ContentOrdersCreatetestorder_590509,
    base: "/content/v2.1", url: url_ContentOrdersCreatetestorder_590510,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersAdvancetestorder_590525 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersAdvancetestorder_590527(protocol: Scheme; host: string;
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

proc validate_ContentOrdersAdvancetestorder_590526(path: JsonNode; query: JsonNode;
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
  var valid_590528 = path.getOrDefault("orderId")
  valid_590528 = validateParameter(valid_590528, JString, required = true,
                                 default = nil)
  if valid_590528 != nil:
    section.add "orderId", valid_590528
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
  var valid_590533 = query.getOrDefault("oauth_token")
  valid_590533 = validateParameter(valid_590533, JString, required = false,
                                 default = nil)
  if valid_590533 != nil:
    section.add "oauth_token", valid_590533
  var valid_590534 = query.getOrDefault("userIp")
  valid_590534 = validateParameter(valid_590534, JString, required = false,
                                 default = nil)
  if valid_590534 != nil:
    section.add "userIp", valid_590534
  var valid_590535 = query.getOrDefault("key")
  valid_590535 = validateParameter(valid_590535, JString, required = false,
                                 default = nil)
  if valid_590535 != nil:
    section.add "key", valid_590535
  var valid_590536 = query.getOrDefault("prettyPrint")
  valid_590536 = validateParameter(valid_590536, JBool, required = false,
                                 default = newJBool(true))
  if valid_590536 != nil:
    section.add "prettyPrint", valid_590536
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590537: Call_ContentOrdersAdvancetestorder_590525; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Moves a test order from state "inProgress" to state "pendingShipment".
  ## 
  let valid = call_590537.validator(path, query, header, formData, body)
  let scheme = call_590537.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590537.url(scheme.get, call_590537.host, call_590537.base,
                         call_590537.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590537, url, valid)

proc call*(call_590538: Call_ContentOrdersAdvancetestorder_590525; orderId: string;
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
  var path_590539 = newJObject()
  var query_590540 = newJObject()
  add(query_590540, "fields", newJString(fields))
  add(query_590540, "quotaUser", newJString(quotaUser))
  add(query_590540, "alt", newJString(alt))
  add(query_590540, "oauth_token", newJString(oauthToken))
  add(query_590540, "userIp", newJString(userIp))
  add(path_590539, "orderId", newJString(orderId))
  add(query_590540, "key", newJString(key))
  add(path_590539, "merchantId", newJString(merchantId))
  add(query_590540, "prettyPrint", newJBool(prettyPrint))
  result = call_590538.call(path_590539, query_590540, nil, nil, nil)

var contentOrdersAdvancetestorder* = Call_ContentOrdersAdvancetestorder_590525(
    name: "contentOrdersAdvancetestorder", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/testorders/{orderId}/advance",
    validator: validate_ContentOrdersAdvancetestorder_590526,
    base: "/content/v2.1", url: url_ContentOrdersAdvancetestorder_590527,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersCanceltestorderbycustomer_590541 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersCanceltestorderbycustomer_590543(protocol: Scheme;
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

proc validate_ContentOrdersCanceltestorderbycustomer_590542(path: JsonNode;
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
  var valid_590544 = path.getOrDefault("orderId")
  valid_590544 = validateParameter(valid_590544, JString, required = true,
                                 default = nil)
  if valid_590544 != nil:
    section.add "orderId", valid_590544
  var valid_590545 = path.getOrDefault("merchantId")
  valid_590545 = validateParameter(valid_590545, JString, required = true,
                                 default = nil)
  if valid_590545 != nil:
    section.add "merchantId", valid_590545
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590546 = query.getOrDefault("fields")
  valid_590546 = validateParameter(valid_590546, JString, required = false,
                                 default = nil)
  if valid_590546 != nil:
    section.add "fields", valid_590546
  var valid_590547 = query.getOrDefault("quotaUser")
  valid_590547 = validateParameter(valid_590547, JString, required = false,
                                 default = nil)
  if valid_590547 != nil:
    section.add "quotaUser", valid_590547
  var valid_590548 = query.getOrDefault("alt")
  valid_590548 = validateParameter(valid_590548, JString, required = false,
                                 default = newJString("json"))
  if valid_590548 != nil:
    section.add "alt", valid_590548
  var valid_590549 = query.getOrDefault("oauth_token")
  valid_590549 = validateParameter(valid_590549, JString, required = false,
                                 default = nil)
  if valid_590549 != nil:
    section.add "oauth_token", valid_590549
  var valid_590550 = query.getOrDefault("userIp")
  valid_590550 = validateParameter(valid_590550, JString, required = false,
                                 default = nil)
  if valid_590550 != nil:
    section.add "userIp", valid_590550
  var valid_590551 = query.getOrDefault("key")
  valid_590551 = validateParameter(valid_590551, JString, required = false,
                                 default = nil)
  if valid_590551 != nil:
    section.add "key", valid_590551
  var valid_590552 = query.getOrDefault("prettyPrint")
  valid_590552 = validateParameter(valid_590552, JBool, required = false,
                                 default = newJBool(true))
  if valid_590552 != nil:
    section.add "prettyPrint", valid_590552
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590554: Call_ContentOrdersCanceltestorderbycustomer_590541;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sandbox only. Cancels a test order for customer-initiated cancellation.
  ## 
  let valid = call_590554.validator(path, query, header, formData, body)
  let scheme = call_590554.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590554.url(scheme.get, call_590554.host, call_590554.base,
                         call_590554.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590554, url, valid)

proc call*(call_590555: Call_ContentOrdersCanceltestorderbycustomer_590541;
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
  var path_590556 = newJObject()
  var query_590557 = newJObject()
  var body_590558 = newJObject()
  add(query_590557, "fields", newJString(fields))
  add(query_590557, "quotaUser", newJString(quotaUser))
  add(query_590557, "alt", newJString(alt))
  add(query_590557, "oauth_token", newJString(oauthToken))
  add(query_590557, "userIp", newJString(userIp))
  add(path_590556, "orderId", newJString(orderId))
  add(query_590557, "key", newJString(key))
  add(path_590556, "merchantId", newJString(merchantId))
  if body != nil:
    body_590558 = body
  add(query_590557, "prettyPrint", newJBool(prettyPrint))
  result = call_590555.call(path_590556, query_590557, nil, nil, body_590558)

var contentOrdersCanceltestorderbycustomer* = Call_ContentOrdersCanceltestorderbycustomer_590541(
    name: "contentOrdersCanceltestorderbycustomer", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/testorders/{orderId}/cancelByCustomer",
    validator: validate_ContentOrdersCanceltestorderbycustomer_590542,
    base: "/content/v2.1", url: url_ContentOrdersCanceltestorderbycustomer_590543,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersGettestordertemplate_590559 = ref object of OpenApiRestCall_588450
proc url_ContentOrdersGettestordertemplate_590561(protocol: Scheme; host: string;
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

proc validate_ContentOrdersGettestordertemplate_590560(path: JsonNode;
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
  var valid_590562 = path.getOrDefault("templateName")
  valid_590562 = validateParameter(valid_590562, JString, required = true,
                                 default = newJString("template1"))
  if valid_590562 != nil:
    section.add "templateName", valid_590562
  var valid_590563 = path.getOrDefault("merchantId")
  valid_590563 = validateParameter(valid_590563, JString, required = true,
                                 default = nil)
  if valid_590563 != nil:
    section.add "merchantId", valid_590563
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
  var valid_590564 = query.getOrDefault("fields")
  valid_590564 = validateParameter(valid_590564, JString, required = false,
                                 default = nil)
  if valid_590564 != nil:
    section.add "fields", valid_590564
  var valid_590565 = query.getOrDefault("country")
  valid_590565 = validateParameter(valid_590565, JString, required = false,
                                 default = nil)
  if valid_590565 != nil:
    section.add "country", valid_590565
  var valid_590566 = query.getOrDefault("quotaUser")
  valid_590566 = validateParameter(valid_590566, JString, required = false,
                                 default = nil)
  if valid_590566 != nil:
    section.add "quotaUser", valid_590566
  var valid_590567 = query.getOrDefault("alt")
  valid_590567 = validateParameter(valid_590567, JString, required = false,
                                 default = newJString("json"))
  if valid_590567 != nil:
    section.add "alt", valid_590567
  var valid_590568 = query.getOrDefault("oauth_token")
  valid_590568 = validateParameter(valid_590568, JString, required = false,
                                 default = nil)
  if valid_590568 != nil:
    section.add "oauth_token", valid_590568
  var valid_590569 = query.getOrDefault("userIp")
  valid_590569 = validateParameter(valid_590569, JString, required = false,
                                 default = nil)
  if valid_590569 != nil:
    section.add "userIp", valid_590569
  var valid_590570 = query.getOrDefault("key")
  valid_590570 = validateParameter(valid_590570, JString, required = false,
                                 default = nil)
  if valid_590570 != nil:
    section.add "key", valid_590570
  var valid_590571 = query.getOrDefault("prettyPrint")
  valid_590571 = validateParameter(valid_590571, JBool, required = false,
                                 default = newJBool(true))
  if valid_590571 != nil:
    section.add "prettyPrint", valid_590571
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590572: Call_ContentOrdersGettestordertemplate_590559;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sandbox only. Retrieves an order template that can be used to quickly create a new order in sandbox.
  ## 
  let valid = call_590572.validator(path, query, header, formData, body)
  let scheme = call_590572.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590572.url(scheme.get, call_590572.host, call_590572.base,
                         call_590572.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590572, url, valid)

proc call*(call_590573: Call_ContentOrdersGettestordertemplate_590559;
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
  var path_590574 = newJObject()
  var query_590575 = newJObject()
  add(query_590575, "fields", newJString(fields))
  add(query_590575, "country", newJString(country))
  add(query_590575, "quotaUser", newJString(quotaUser))
  add(query_590575, "alt", newJString(alt))
  add(query_590575, "oauth_token", newJString(oauthToken))
  add(query_590575, "userIp", newJString(userIp))
  add(path_590574, "templateName", newJString(templateName))
  add(query_590575, "key", newJString(key))
  add(path_590574, "merchantId", newJString(merchantId))
  add(query_590575, "prettyPrint", newJBool(prettyPrint))
  result = call_590573.call(path_590574, query_590575, nil, nil, nil)

var contentOrdersGettestordertemplate* = Call_ContentOrdersGettestordertemplate_590559(
    name: "contentOrdersGettestordertemplate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/testordertemplates/{templateName}",
    validator: validate_ContentOrdersGettestordertemplate_590560,
    base: "/content/v2.1", url: url_ContentOrdersGettestordertemplate_590561,
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
