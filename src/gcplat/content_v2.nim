
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

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

  OpenApiRestCall_579373 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579373](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579373): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "content"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ContentAccountsAuthinfo_579643 = ref object of OpenApiRestCall_579373
proc url_ContentAccountsAuthinfo_579645(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ContentAccountsAuthinfo_579644(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns information about the authenticated user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579757 = query.getOrDefault("key")
  valid_579757 = validateParameter(valid_579757, JString, required = false,
                                 default = nil)
  if valid_579757 != nil:
    section.add "key", valid_579757
  var valid_579771 = query.getOrDefault("prettyPrint")
  valid_579771 = validateParameter(valid_579771, JBool, required = false,
                                 default = newJBool(true))
  if valid_579771 != nil:
    section.add "prettyPrint", valid_579771
  var valid_579772 = query.getOrDefault("oauth_token")
  valid_579772 = validateParameter(valid_579772, JString, required = false,
                                 default = nil)
  if valid_579772 != nil:
    section.add "oauth_token", valid_579772
  var valid_579773 = query.getOrDefault("alt")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = newJString("json"))
  if valid_579773 != nil:
    section.add "alt", valid_579773
  var valid_579774 = query.getOrDefault("userIp")
  valid_579774 = validateParameter(valid_579774, JString, required = false,
                                 default = nil)
  if valid_579774 != nil:
    section.add "userIp", valid_579774
  var valid_579775 = query.getOrDefault("quotaUser")
  valid_579775 = validateParameter(valid_579775, JString, required = false,
                                 default = nil)
  if valid_579775 != nil:
    section.add "quotaUser", valid_579775
  var valid_579776 = query.getOrDefault("fields")
  valid_579776 = validateParameter(valid_579776, JString, required = false,
                                 default = nil)
  if valid_579776 != nil:
    section.add "fields", valid_579776
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579799: Call_ContentAccountsAuthinfo_579643; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about the authenticated user.
  ## 
  let valid = call_579799.validator(path, query, header, formData, body)
  let scheme = call_579799.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579799.url(scheme.get, call_579799.host, call_579799.base,
                         call_579799.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579799, url, valid)

proc call*(call_579870: Call_ContentAccountsAuthinfo_579643; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## contentAccountsAuthinfo
  ## Returns information about the authenticated user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579871 = newJObject()
  add(query_579871, "key", newJString(key))
  add(query_579871, "prettyPrint", newJBool(prettyPrint))
  add(query_579871, "oauth_token", newJString(oauthToken))
  add(query_579871, "alt", newJString(alt))
  add(query_579871, "userIp", newJString(userIp))
  add(query_579871, "quotaUser", newJString(quotaUser))
  add(query_579871, "fields", newJString(fields))
  result = call_579870.call(nil, query_579871, nil, nil, nil)

var contentAccountsAuthinfo* = Call_ContentAccountsAuthinfo_579643(
    name: "contentAccountsAuthinfo", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/authinfo",
    validator: validate_ContentAccountsAuthinfo_579644, base: "/content/v2",
    url: url_ContentAccountsAuthinfo_579645, schemes: {Scheme.Https})
type
  Call_ContentAccountsCustombatch_579911 = ref object of OpenApiRestCall_579373
proc url_ContentAccountsCustombatch_579913(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ContentAccountsCustombatch_579912(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves, inserts, updates, and deletes multiple Merchant Center (sub-)accounts in a single request.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579914 = query.getOrDefault("key")
  valid_579914 = validateParameter(valid_579914, JString, required = false,
                                 default = nil)
  if valid_579914 != nil:
    section.add "key", valid_579914
  var valid_579915 = query.getOrDefault("prettyPrint")
  valid_579915 = validateParameter(valid_579915, JBool, required = false,
                                 default = newJBool(true))
  if valid_579915 != nil:
    section.add "prettyPrint", valid_579915
  var valid_579916 = query.getOrDefault("oauth_token")
  valid_579916 = validateParameter(valid_579916, JString, required = false,
                                 default = nil)
  if valid_579916 != nil:
    section.add "oauth_token", valid_579916
  var valid_579917 = query.getOrDefault("alt")
  valid_579917 = validateParameter(valid_579917, JString, required = false,
                                 default = newJString("json"))
  if valid_579917 != nil:
    section.add "alt", valid_579917
  var valid_579918 = query.getOrDefault("userIp")
  valid_579918 = validateParameter(valid_579918, JString, required = false,
                                 default = nil)
  if valid_579918 != nil:
    section.add "userIp", valid_579918
  var valid_579919 = query.getOrDefault("quotaUser")
  valid_579919 = validateParameter(valid_579919, JString, required = false,
                                 default = nil)
  if valid_579919 != nil:
    section.add "quotaUser", valid_579919
  var valid_579920 = query.getOrDefault("dryRun")
  valid_579920 = validateParameter(valid_579920, JBool, required = false, default = nil)
  if valid_579920 != nil:
    section.add "dryRun", valid_579920
  var valid_579921 = query.getOrDefault("fields")
  valid_579921 = validateParameter(valid_579921, JString, required = false,
                                 default = nil)
  if valid_579921 != nil:
    section.add "fields", valid_579921
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579923: Call_ContentAccountsCustombatch_579911; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves, inserts, updates, and deletes multiple Merchant Center (sub-)accounts in a single request.
  ## 
  let valid = call_579923.validator(path, query, header, formData, body)
  let scheme = call_579923.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579923.url(scheme.get, call_579923.host, call_579923.base,
                         call_579923.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579923, url, valid)

proc call*(call_579924: Call_ContentAccountsCustombatch_579911; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; dryRun: bool = false;
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentAccountsCustombatch
  ## Retrieves, inserts, updates, and deletes multiple Merchant Center (sub-)accounts in a single request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579925 = newJObject()
  var body_579926 = newJObject()
  add(query_579925, "key", newJString(key))
  add(query_579925, "prettyPrint", newJBool(prettyPrint))
  add(query_579925, "oauth_token", newJString(oauthToken))
  add(query_579925, "alt", newJString(alt))
  add(query_579925, "userIp", newJString(userIp))
  add(query_579925, "quotaUser", newJString(quotaUser))
  add(query_579925, "dryRun", newJBool(dryRun))
  if body != nil:
    body_579926 = body
  add(query_579925, "fields", newJString(fields))
  result = call_579924.call(nil, query_579925, nil, nil, body_579926)

var contentAccountsCustombatch* = Call_ContentAccountsCustombatch_579911(
    name: "contentAccountsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accounts/batch",
    validator: validate_ContentAccountsCustombatch_579912, base: "/content/v2",
    url: url_ContentAccountsCustombatch_579913, schemes: {Scheme.Https})
type
  Call_ContentAccountstatusesCustombatch_579927 = ref object of OpenApiRestCall_579373
proc url_ContentAccountstatusesCustombatch_579929(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ContentAccountstatusesCustombatch_579928(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves multiple Merchant Center account statuses in a single request.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579930 = query.getOrDefault("key")
  valid_579930 = validateParameter(valid_579930, JString, required = false,
                                 default = nil)
  if valid_579930 != nil:
    section.add "key", valid_579930
  var valid_579931 = query.getOrDefault("prettyPrint")
  valid_579931 = validateParameter(valid_579931, JBool, required = false,
                                 default = newJBool(true))
  if valid_579931 != nil:
    section.add "prettyPrint", valid_579931
  var valid_579932 = query.getOrDefault("oauth_token")
  valid_579932 = validateParameter(valid_579932, JString, required = false,
                                 default = nil)
  if valid_579932 != nil:
    section.add "oauth_token", valid_579932
  var valid_579933 = query.getOrDefault("alt")
  valid_579933 = validateParameter(valid_579933, JString, required = false,
                                 default = newJString("json"))
  if valid_579933 != nil:
    section.add "alt", valid_579933
  var valid_579934 = query.getOrDefault("userIp")
  valid_579934 = validateParameter(valid_579934, JString, required = false,
                                 default = nil)
  if valid_579934 != nil:
    section.add "userIp", valid_579934
  var valid_579935 = query.getOrDefault("quotaUser")
  valid_579935 = validateParameter(valid_579935, JString, required = false,
                                 default = nil)
  if valid_579935 != nil:
    section.add "quotaUser", valid_579935
  var valid_579936 = query.getOrDefault("fields")
  valid_579936 = validateParameter(valid_579936, JString, required = false,
                                 default = nil)
  if valid_579936 != nil:
    section.add "fields", valid_579936
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579938: Call_ContentAccountstatusesCustombatch_579927;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves multiple Merchant Center account statuses in a single request.
  ## 
  let valid = call_579938.validator(path, query, header, formData, body)
  let scheme = call_579938.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579938.url(scheme.get, call_579938.host, call_579938.base,
                         call_579938.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579938, url, valid)

proc call*(call_579939: Call_ContentAccountstatusesCustombatch_579927;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentAccountstatusesCustombatch
  ## Retrieves multiple Merchant Center account statuses in a single request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579940 = newJObject()
  var body_579941 = newJObject()
  add(query_579940, "key", newJString(key))
  add(query_579940, "prettyPrint", newJBool(prettyPrint))
  add(query_579940, "oauth_token", newJString(oauthToken))
  add(query_579940, "alt", newJString(alt))
  add(query_579940, "userIp", newJString(userIp))
  add(query_579940, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579941 = body
  add(query_579940, "fields", newJString(fields))
  result = call_579939.call(nil, query_579940, nil, nil, body_579941)

var contentAccountstatusesCustombatch* = Call_ContentAccountstatusesCustombatch_579927(
    name: "contentAccountstatusesCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accountstatuses/batch",
    validator: validate_ContentAccountstatusesCustombatch_579928,
    base: "/content/v2", url: url_ContentAccountstatusesCustombatch_579929,
    schemes: {Scheme.Https})
type
  Call_ContentAccounttaxCustombatch_579942 = ref object of OpenApiRestCall_579373
proc url_ContentAccounttaxCustombatch_579944(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ContentAccounttaxCustombatch_579943(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves and updates tax settings of multiple accounts in a single request.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579945 = query.getOrDefault("key")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = nil)
  if valid_579945 != nil:
    section.add "key", valid_579945
  var valid_579946 = query.getOrDefault("prettyPrint")
  valid_579946 = validateParameter(valid_579946, JBool, required = false,
                                 default = newJBool(true))
  if valid_579946 != nil:
    section.add "prettyPrint", valid_579946
  var valid_579947 = query.getOrDefault("oauth_token")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = nil)
  if valid_579947 != nil:
    section.add "oauth_token", valid_579947
  var valid_579948 = query.getOrDefault("alt")
  valid_579948 = validateParameter(valid_579948, JString, required = false,
                                 default = newJString("json"))
  if valid_579948 != nil:
    section.add "alt", valid_579948
  var valid_579949 = query.getOrDefault("userIp")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "userIp", valid_579949
  var valid_579950 = query.getOrDefault("quotaUser")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = nil)
  if valid_579950 != nil:
    section.add "quotaUser", valid_579950
  var valid_579951 = query.getOrDefault("dryRun")
  valid_579951 = validateParameter(valid_579951, JBool, required = false, default = nil)
  if valid_579951 != nil:
    section.add "dryRun", valid_579951
  var valid_579952 = query.getOrDefault("fields")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = nil)
  if valid_579952 != nil:
    section.add "fields", valid_579952
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579954: Call_ContentAccounttaxCustombatch_579942; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves and updates tax settings of multiple accounts in a single request.
  ## 
  let valid = call_579954.validator(path, query, header, formData, body)
  let scheme = call_579954.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579954.url(scheme.get, call_579954.host, call_579954.base,
                         call_579954.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579954, url, valid)

proc call*(call_579955: Call_ContentAccounttaxCustombatch_579942; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; dryRun: bool = false;
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentAccounttaxCustombatch
  ## Retrieves and updates tax settings of multiple accounts in a single request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579956 = newJObject()
  var body_579957 = newJObject()
  add(query_579956, "key", newJString(key))
  add(query_579956, "prettyPrint", newJBool(prettyPrint))
  add(query_579956, "oauth_token", newJString(oauthToken))
  add(query_579956, "alt", newJString(alt))
  add(query_579956, "userIp", newJString(userIp))
  add(query_579956, "quotaUser", newJString(quotaUser))
  add(query_579956, "dryRun", newJBool(dryRun))
  if body != nil:
    body_579957 = body
  add(query_579956, "fields", newJString(fields))
  result = call_579955.call(nil, query_579956, nil, nil, body_579957)

var contentAccounttaxCustombatch* = Call_ContentAccounttaxCustombatch_579942(
    name: "contentAccounttaxCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accounttax/batch",
    validator: validate_ContentAccounttaxCustombatch_579943, base: "/content/v2",
    url: url_ContentAccounttaxCustombatch_579944, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsCustombatch_579958 = ref object of OpenApiRestCall_579373
proc url_ContentDatafeedsCustombatch_579960(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ContentDatafeedsCustombatch_579959(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes, fetches, gets, inserts and updates multiple datafeeds in a single request.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579961 = query.getOrDefault("key")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "key", valid_579961
  var valid_579962 = query.getOrDefault("prettyPrint")
  valid_579962 = validateParameter(valid_579962, JBool, required = false,
                                 default = newJBool(true))
  if valid_579962 != nil:
    section.add "prettyPrint", valid_579962
  var valid_579963 = query.getOrDefault("oauth_token")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "oauth_token", valid_579963
  var valid_579964 = query.getOrDefault("alt")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = newJString("json"))
  if valid_579964 != nil:
    section.add "alt", valid_579964
  var valid_579965 = query.getOrDefault("userIp")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "userIp", valid_579965
  var valid_579966 = query.getOrDefault("quotaUser")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "quotaUser", valid_579966
  var valid_579967 = query.getOrDefault("dryRun")
  valid_579967 = validateParameter(valid_579967, JBool, required = false, default = nil)
  if valid_579967 != nil:
    section.add "dryRun", valid_579967
  var valid_579968 = query.getOrDefault("fields")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "fields", valid_579968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579970: Call_ContentDatafeedsCustombatch_579958; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes, fetches, gets, inserts and updates multiple datafeeds in a single request.
  ## 
  let valid = call_579970.validator(path, query, header, formData, body)
  let scheme = call_579970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579970.url(scheme.get, call_579970.host, call_579970.base,
                         call_579970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579970, url, valid)

proc call*(call_579971: Call_ContentDatafeedsCustombatch_579958; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; dryRun: bool = false;
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentDatafeedsCustombatch
  ## Deletes, fetches, gets, inserts and updates multiple datafeeds in a single request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579972 = newJObject()
  var body_579973 = newJObject()
  add(query_579972, "key", newJString(key))
  add(query_579972, "prettyPrint", newJBool(prettyPrint))
  add(query_579972, "oauth_token", newJString(oauthToken))
  add(query_579972, "alt", newJString(alt))
  add(query_579972, "userIp", newJString(userIp))
  add(query_579972, "quotaUser", newJString(quotaUser))
  add(query_579972, "dryRun", newJBool(dryRun))
  if body != nil:
    body_579973 = body
  add(query_579972, "fields", newJString(fields))
  result = call_579971.call(nil, query_579972, nil, nil, body_579973)

var contentDatafeedsCustombatch* = Call_ContentDatafeedsCustombatch_579958(
    name: "contentDatafeedsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/datafeeds/batch",
    validator: validate_ContentDatafeedsCustombatch_579959, base: "/content/v2",
    url: url_ContentDatafeedsCustombatch_579960, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesCustombatch_579974 = ref object of OpenApiRestCall_579373
proc url_ContentDatafeedstatusesCustombatch_579976(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ContentDatafeedstatusesCustombatch_579975(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets multiple Merchant Center datafeed statuses in a single request.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579977 = query.getOrDefault("key")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "key", valid_579977
  var valid_579978 = query.getOrDefault("prettyPrint")
  valid_579978 = validateParameter(valid_579978, JBool, required = false,
                                 default = newJBool(true))
  if valid_579978 != nil:
    section.add "prettyPrint", valid_579978
  var valid_579979 = query.getOrDefault("oauth_token")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "oauth_token", valid_579979
  var valid_579980 = query.getOrDefault("alt")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = newJString("json"))
  if valid_579980 != nil:
    section.add "alt", valid_579980
  var valid_579981 = query.getOrDefault("userIp")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "userIp", valid_579981
  var valid_579982 = query.getOrDefault("quotaUser")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "quotaUser", valid_579982
  var valid_579983 = query.getOrDefault("fields")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "fields", valid_579983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579985: Call_ContentDatafeedstatusesCustombatch_579974;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets multiple Merchant Center datafeed statuses in a single request.
  ## 
  let valid = call_579985.validator(path, query, header, formData, body)
  let scheme = call_579985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579985.url(scheme.get, call_579985.host, call_579985.base,
                         call_579985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579985, url, valid)

proc call*(call_579986: Call_ContentDatafeedstatusesCustombatch_579974;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentDatafeedstatusesCustombatch
  ## Gets multiple Merchant Center datafeed statuses in a single request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579987 = newJObject()
  var body_579988 = newJObject()
  add(query_579987, "key", newJString(key))
  add(query_579987, "prettyPrint", newJBool(prettyPrint))
  add(query_579987, "oauth_token", newJString(oauthToken))
  add(query_579987, "alt", newJString(alt))
  add(query_579987, "userIp", newJString(userIp))
  add(query_579987, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579988 = body
  add(query_579987, "fields", newJString(fields))
  result = call_579986.call(nil, query_579987, nil, nil, body_579988)

var contentDatafeedstatusesCustombatch* = Call_ContentDatafeedstatusesCustombatch_579974(
    name: "contentDatafeedstatusesCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/datafeedstatuses/batch",
    validator: validate_ContentDatafeedstatusesCustombatch_579975,
    base: "/content/v2", url: url_ContentDatafeedstatusesCustombatch_579976,
    schemes: {Scheme.Https})
type
  Call_ContentInventoryCustombatch_579989 = ref object of OpenApiRestCall_579373
proc url_ContentInventoryCustombatch_579991(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ContentInventoryCustombatch_579990(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates price and availability for multiple products or stores in a single request. This operation does not update the expiration date of the products.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579992 = query.getOrDefault("key")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "key", valid_579992
  var valid_579993 = query.getOrDefault("prettyPrint")
  valid_579993 = validateParameter(valid_579993, JBool, required = false,
                                 default = newJBool(true))
  if valid_579993 != nil:
    section.add "prettyPrint", valid_579993
  var valid_579994 = query.getOrDefault("oauth_token")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "oauth_token", valid_579994
  var valid_579995 = query.getOrDefault("alt")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = newJString("json"))
  if valid_579995 != nil:
    section.add "alt", valid_579995
  var valid_579996 = query.getOrDefault("userIp")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "userIp", valid_579996
  var valid_579997 = query.getOrDefault("quotaUser")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "quotaUser", valid_579997
  var valid_579998 = query.getOrDefault("dryRun")
  valid_579998 = validateParameter(valid_579998, JBool, required = false, default = nil)
  if valid_579998 != nil:
    section.add "dryRun", valid_579998
  var valid_579999 = query.getOrDefault("fields")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "fields", valid_579999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580001: Call_ContentInventoryCustombatch_579989; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates price and availability for multiple products or stores in a single request. This operation does not update the expiration date of the products.
  ## 
  let valid = call_580001.validator(path, query, header, formData, body)
  let scheme = call_580001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580001.url(scheme.get, call_580001.host, call_580001.base,
                         call_580001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580001, url, valid)

proc call*(call_580002: Call_ContentInventoryCustombatch_579989; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; dryRun: bool = false;
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentInventoryCustombatch
  ## Updates price and availability for multiple products or stores in a single request. This operation does not update the expiration date of the products.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580003 = newJObject()
  var body_580004 = newJObject()
  add(query_580003, "key", newJString(key))
  add(query_580003, "prettyPrint", newJBool(prettyPrint))
  add(query_580003, "oauth_token", newJString(oauthToken))
  add(query_580003, "alt", newJString(alt))
  add(query_580003, "userIp", newJString(userIp))
  add(query_580003, "quotaUser", newJString(quotaUser))
  add(query_580003, "dryRun", newJBool(dryRun))
  if body != nil:
    body_580004 = body
  add(query_580003, "fields", newJString(fields))
  result = call_580002.call(nil, query_580003, nil, nil, body_580004)

var contentInventoryCustombatch* = Call_ContentInventoryCustombatch_579989(
    name: "contentInventoryCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/inventory/batch",
    validator: validate_ContentInventoryCustombatch_579990, base: "/content/v2",
    url: url_ContentInventoryCustombatch_579991, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsCustombatch_580005 = ref object of OpenApiRestCall_579373
proc url_ContentLiasettingsCustombatch_580007(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ContentLiasettingsCustombatch_580006(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves and/or updates the LIA settings of multiple accounts in a single request.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580008 = query.getOrDefault("key")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "key", valid_580008
  var valid_580009 = query.getOrDefault("prettyPrint")
  valid_580009 = validateParameter(valid_580009, JBool, required = false,
                                 default = newJBool(true))
  if valid_580009 != nil:
    section.add "prettyPrint", valid_580009
  var valid_580010 = query.getOrDefault("oauth_token")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "oauth_token", valid_580010
  var valid_580011 = query.getOrDefault("alt")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = newJString("json"))
  if valid_580011 != nil:
    section.add "alt", valid_580011
  var valid_580012 = query.getOrDefault("userIp")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "userIp", valid_580012
  var valid_580013 = query.getOrDefault("quotaUser")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "quotaUser", valid_580013
  var valid_580014 = query.getOrDefault("dryRun")
  valid_580014 = validateParameter(valid_580014, JBool, required = false, default = nil)
  if valid_580014 != nil:
    section.add "dryRun", valid_580014
  var valid_580015 = query.getOrDefault("fields")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "fields", valid_580015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580017: Call_ContentLiasettingsCustombatch_580005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves and/or updates the LIA settings of multiple accounts in a single request.
  ## 
  let valid = call_580017.validator(path, query, header, formData, body)
  let scheme = call_580017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580017.url(scheme.get, call_580017.host, call_580017.base,
                         call_580017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580017, url, valid)

proc call*(call_580018: Call_ContentLiasettingsCustombatch_580005;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          dryRun: bool = false; body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentLiasettingsCustombatch
  ## Retrieves and/or updates the LIA settings of multiple accounts in a single request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580019 = newJObject()
  var body_580020 = newJObject()
  add(query_580019, "key", newJString(key))
  add(query_580019, "prettyPrint", newJBool(prettyPrint))
  add(query_580019, "oauth_token", newJString(oauthToken))
  add(query_580019, "alt", newJString(alt))
  add(query_580019, "userIp", newJString(userIp))
  add(query_580019, "quotaUser", newJString(quotaUser))
  add(query_580019, "dryRun", newJBool(dryRun))
  if body != nil:
    body_580020 = body
  add(query_580019, "fields", newJString(fields))
  result = call_580018.call(nil, query_580019, nil, nil, body_580020)

var contentLiasettingsCustombatch* = Call_ContentLiasettingsCustombatch_580005(
    name: "contentLiasettingsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liasettings/batch",
    validator: validate_ContentLiasettingsCustombatch_580006, base: "/content/v2",
    url: url_ContentLiasettingsCustombatch_580007, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsListposdataproviders_580021 = ref object of OpenApiRestCall_579373
proc url_ContentLiasettingsListposdataproviders_580023(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ContentLiasettingsListposdataproviders_580022(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of POS data providers that have active settings for the all eiligible countries.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580024 = query.getOrDefault("key")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "key", valid_580024
  var valid_580025 = query.getOrDefault("prettyPrint")
  valid_580025 = validateParameter(valid_580025, JBool, required = false,
                                 default = newJBool(true))
  if valid_580025 != nil:
    section.add "prettyPrint", valid_580025
  var valid_580026 = query.getOrDefault("oauth_token")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "oauth_token", valid_580026
  var valid_580027 = query.getOrDefault("alt")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = newJString("json"))
  if valid_580027 != nil:
    section.add "alt", valid_580027
  var valid_580028 = query.getOrDefault("userIp")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "userIp", valid_580028
  var valid_580029 = query.getOrDefault("quotaUser")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "quotaUser", valid_580029
  var valid_580030 = query.getOrDefault("fields")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "fields", valid_580030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580031: Call_ContentLiasettingsListposdataproviders_580021;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of POS data providers that have active settings for the all eiligible countries.
  ## 
  let valid = call_580031.validator(path, query, header, formData, body)
  let scheme = call_580031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580031.url(scheme.get, call_580031.host, call_580031.base,
                         call_580031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580031, url, valid)

proc call*(call_580032: Call_ContentLiasettingsListposdataproviders_580021;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## contentLiasettingsListposdataproviders
  ## Retrieves the list of POS data providers that have active settings for the all eiligible countries.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580033 = newJObject()
  add(query_580033, "key", newJString(key))
  add(query_580033, "prettyPrint", newJBool(prettyPrint))
  add(query_580033, "oauth_token", newJString(oauthToken))
  add(query_580033, "alt", newJString(alt))
  add(query_580033, "userIp", newJString(userIp))
  add(query_580033, "quotaUser", newJString(quotaUser))
  add(query_580033, "fields", newJString(fields))
  result = call_580032.call(nil, query_580033, nil, nil, nil)

var contentLiasettingsListposdataproviders* = Call_ContentLiasettingsListposdataproviders_580021(
    name: "contentLiasettingsListposdataproviders", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/liasettings/posdataproviders",
    validator: validate_ContentLiasettingsListposdataproviders_580022,
    base: "/content/v2", url: url_ContentLiasettingsListposdataproviders_580023,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersCustombatch_580034 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersCustombatch_580036(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ContentOrdersCustombatch_580035(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves or modifies multiple orders in a single request.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580037 = query.getOrDefault("key")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "key", valid_580037
  var valid_580038 = query.getOrDefault("prettyPrint")
  valid_580038 = validateParameter(valid_580038, JBool, required = false,
                                 default = newJBool(true))
  if valid_580038 != nil:
    section.add "prettyPrint", valid_580038
  var valid_580039 = query.getOrDefault("oauth_token")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "oauth_token", valid_580039
  var valid_580040 = query.getOrDefault("alt")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = newJString("json"))
  if valid_580040 != nil:
    section.add "alt", valid_580040
  var valid_580041 = query.getOrDefault("userIp")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "userIp", valid_580041
  var valid_580042 = query.getOrDefault("quotaUser")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "quotaUser", valid_580042
  var valid_580043 = query.getOrDefault("fields")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "fields", valid_580043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580045: Call_ContentOrdersCustombatch_580034; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves or modifies multiple orders in a single request.
  ## 
  let valid = call_580045.validator(path, query, header, formData, body)
  let scheme = call_580045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580045.url(scheme.get, call_580045.host, call_580045.base,
                         call_580045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580045, url, valid)

proc call*(call_580046: Call_ContentOrdersCustombatch_580034; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentOrdersCustombatch
  ## Retrieves or modifies multiple orders in a single request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580047 = newJObject()
  var body_580048 = newJObject()
  add(query_580047, "key", newJString(key))
  add(query_580047, "prettyPrint", newJBool(prettyPrint))
  add(query_580047, "oauth_token", newJString(oauthToken))
  add(query_580047, "alt", newJString(alt))
  add(query_580047, "userIp", newJString(userIp))
  add(query_580047, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580048 = body
  add(query_580047, "fields", newJString(fields))
  result = call_580046.call(nil, query_580047, nil, nil, body_580048)

var contentOrdersCustombatch* = Call_ContentOrdersCustombatch_580034(
    name: "contentOrdersCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/orders/batch",
    validator: validate_ContentOrdersCustombatch_580035, base: "/content/v2",
    url: url_ContentOrdersCustombatch_580036, schemes: {Scheme.Https})
type
  Call_ContentPosCustombatch_580049 = ref object of OpenApiRestCall_579373
proc url_ContentPosCustombatch_580051(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ContentPosCustombatch_580050(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Batches multiple POS-related calls in a single request.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580052 = query.getOrDefault("key")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "key", valid_580052
  var valid_580053 = query.getOrDefault("prettyPrint")
  valid_580053 = validateParameter(valid_580053, JBool, required = false,
                                 default = newJBool(true))
  if valid_580053 != nil:
    section.add "prettyPrint", valid_580053
  var valid_580054 = query.getOrDefault("oauth_token")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "oauth_token", valid_580054
  var valid_580055 = query.getOrDefault("alt")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = newJString("json"))
  if valid_580055 != nil:
    section.add "alt", valid_580055
  var valid_580056 = query.getOrDefault("userIp")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "userIp", valid_580056
  var valid_580057 = query.getOrDefault("quotaUser")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "quotaUser", valid_580057
  var valid_580058 = query.getOrDefault("dryRun")
  valid_580058 = validateParameter(valid_580058, JBool, required = false, default = nil)
  if valid_580058 != nil:
    section.add "dryRun", valid_580058
  var valid_580059 = query.getOrDefault("fields")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "fields", valid_580059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580061: Call_ContentPosCustombatch_580049; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Batches multiple POS-related calls in a single request.
  ## 
  let valid = call_580061.validator(path, query, header, formData, body)
  let scheme = call_580061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580061.url(scheme.get, call_580061.host, call_580061.base,
                         call_580061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580061, url, valid)

proc call*(call_580062: Call_ContentPosCustombatch_580049; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; dryRun: bool = false;
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentPosCustombatch
  ## Batches multiple POS-related calls in a single request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580063 = newJObject()
  var body_580064 = newJObject()
  add(query_580063, "key", newJString(key))
  add(query_580063, "prettyPrint", newJBool(prettyPrint))
  add(query_580063, "oauth_token", newJString(oauthToken))
  add(query_580063, "alt", newJString(alt))
  add(query_580063, "userIp", newJString(userIp))
  add(query_580063, "quotaUser", newJString(quotaUser))
  add(query_580063, "dryRun", newJBool(dryRun))
  if body != nil:
    body_580064 = body
  add(query_580063, "fields", newJString(fields))
  result = call_580062.call(nil, query_580063, nil, nil, body_580064)

var contentPosCustombatch* = Call_ContentPosCustombatch_580049(
    name: "contentPosCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/pos/batch",
    validator: validate_ContentPosCustombatch_580050, base: "/content/v2",
    url: url_ContentPosCustombatch_580051, schemes: {Scheme.Https})
type
  Call_ContentProductsCustombatch_580065 = ref object of OpenApiRestCall_579373
proc url_ContentProductsCustombatch_580067(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ContentProductsCustombatch_580066(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves, inserts, and deletes multiple products in a single request.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580068 = query.getOrDefault("key")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "key", valid_580068
  var valid_580069 = query.getOrDefault("prettyPrint")
  valid_580069 = validateParameter(valid_580069, JBool, required = false,
                                 default = newJBool(true))
  if valid_580069 != nil:
    section.add "prettyPrint", valid_580069
  var valid_580070 = query.getOrDefault("oauth_token")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "oauth_token", valid_580070
  var valid_580071 = query.getOrDefault("alt")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = newJString("json"))
  if valid_580071 != nil:
    section.add "alt", valid_580071
  var valid_580072 = query.getOrDefault("userIp")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "userIp", valid_580072
  var valid_580073 = query.getOrDefault("quotaUser")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "quotaUser", valid_580073
  var valid_580074 = query.getOrDefault("dryRun")
  valid_580074 = validateParameter(valid_580074, JBool, required = false, default = nil)
  if valid_580074 != nil:
    section.add "dryRun", valid_580074
  var valid_580075 = query.getOrDefault("fields")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "fields", valid_580075
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580077: Call_ContentProductsCustombatch_580065; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves, inserts, and deletes multiple products in a single request.
  ## 
  let valid = call_580077.validator(path, query, header, formData, body)
  let scheme = call_580077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580077.url(scheme.get, call_580077.host, call_580077.base,
                         call_580077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580077, url, valid)

proc call*(call_580078: Call_ContentProductsCustombatch_580065; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; dryRun: bool = false;
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentProductsCustombatch
  ## Retrieves, inserts, and deletes multiple products in a single request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580079 = newJObject()
  var body_580080 = newJObject()
  add(query_580079, "key", newJString(key))
  add(query_580079, "prettyPrint", newJBool(prettyPrint))
  add(query_580079, "oauth_token", newJString(oauthToken))
  add(query_580079, "alt", newJString(alt))
  add(query_580079, "userIp", newJString(userIp))
  add(query_580079, "quotaUser", newJString(quotaUser))
  add(query_580079, "dryRun", newJBool(dryRun))
  if body != nil:
    body_580080 = body
  add(query_580079, "fields", newJString(fields))
  result = call_580078.call(nil, query_580079, nil, nil, body_580080)

var contentProductsCustombatch* = Call_ContentProductsCustombatch_580065(
    name: "contentProductsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/products/batch",
    validator: validate_ContentProductsCustombatch_580066, base: "/content/v2",
    url: url_ContentProductsCustombatch_580067, schemes: {Scheme.Https})
type
  Call_ContentProductstatusesCustombatch_580081 = ref object of OpenApiRestCall_579373
proc url_ContentProductstatusesCustombatch_580083(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ContentProductstatusesCustombatch_580082(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the statuses of multiple products in a single request.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   includeAttributes: JBool
  ##                    : Flag to include full product data in the results of this request. The default value is false.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
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
  var valid_580086 = query.getOrDefault("oauth_token")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "oauth_token", valid_580086
  var valid_580087 = query.getOrDefault("alt")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = newJString("json"))
  if valid_580087 != nil:
    section.add "alt", valid_580087
  var valid_580088 = query.getOrDefault("userIp")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "userIp", valid_580088
  var valid_580089 = query.getOrDefault("quotaUser")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "quotaUser", valid_580089
  var valid_580090 = query.getOrDefault("includeAttributes")
  valid_580090 = validateParameter(valid_580090, JBool, required = false, default = nil)
  if valid_580090 != nil:
    section.add "includeAttributes", valid_580090
  var valid_580091 = query.getOrDefault("fields")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "fields", valid_580091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580093: Call_ContentProductstatusesCustombatch_580081;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the statuses of multiple products in a single request.
  ## 
  let valid = call_580093.validator(path, query, header, formData, body)
  let scheme = call_580093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580093.url(scheme.get, call_580093.host, call_580093.base,
                         call_580093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580093, url, valid)

proc call*(call_580094: Call_ContentProductstatusesCustombatch_580081;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; includeAttributes: bool = false; fields: string = ""): Recallable =
  ## contentProductstatusesCustombatch
  ## Gets the statuses of multiple products in a single request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   includeAttributes: bool
  ##                    : Flag to include full product data in the results of this request. The default value is false.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580095 = newJObject()
  var body_580096 = newJObject()
  add(query_580095, "key", newJString(key))
  add(query_580095, "prettyPrint", newJBool(prettyPrint))
  add(query_580095, "oauth_token", newJString(oauthToken))
  add(query_580095, "alt", newJString(alt))
  add(query_580095, "userIp", newJString(userIp))
  add(query_580095, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580096 = body
  add(query_580095, "includeAttributes", newJBool(includeAttributes))
  add(query_580095, "fields", newJString(fields))
  result = call_580094.call(nil, query_580095, nil, nil, body_580096)

var contentProductstatusesCustombatch* = Call_ContentProductstatusesCustombatch_580081(
    name: "contentProductstatusesCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/productstatuses/batch",
    validator: validate_ContentProductstatusesCustombatch_580082,
    base: "/content/v2", url: url_ContentProductstatusesCustombatch_580083,
    schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsCustombatch_580097 = ref object of OpenApiRestCall_579373
proc url_ContentShippingsettingsCustombatch_580099(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ContentShippingsettingsCustombatch_580098(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves and updates the shipping settings of multiple accounts in a single request.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
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
  var valid_580102 = query.getOrDefault("oauth_token")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "oauth_token", valid_580102
  var valid_580103 = query.getOrDefault("alt")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = newJString("json"))
  if valid_580103 != nil:
    section.add "alt", valid_580103
  var valid_580104 = query.getOrDefault("userIp")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "userIp", valid_580104
  var valid_580105 = query.getOrDefault("quotaUser")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "quotaUser", valid_580105
  var valid_580106 = query.getOrDefault("dryRun")
  valid_580106 = validateParameter(valid_580106, JBool, required = false, default = nil)
  if valid_580106 != nil:
    section.add "dryRun", valid_580106
  var valid_580107 = query.getOrDefault("fields")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "fields", valid_580107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580109: Call_ContentShippingsettingsCustombatch_580097;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves and updates the shipping settings of multiple accounts in a single request.
  ## 
  let valid = call_580109.validator(path, query, header, formData, body)
  let scheme = call_580109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580109.url(scheme.get, call_580109.host, call_580109.base,
                         call_580109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580109, url, valid)

proc call*(call_580110: Call_ContentShippingsettingsCustombatch_580097;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          dryRun: bool = false; body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentShippingsettingsCustombatch
  ## Retrieves and updates the shipping settings of multiple accounts in a single request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580111 = newJObject()
  var body_580112 = newJObject()
  add(query_580111, "key", newJString(key))
  add(query_580111, "prettyPrint", newJBool(prettyPrint))
  add(query_580111, "oauth_token", newJString(oauthToken))
  add(query_580111, "alt", newJString(alt))
  add(query_580111, "userIp", newJString(userIp))
  add(query_580111, "quotaUser", newJString(quotaUser))
  add(query_580111, "dryRun", newJBool(dryRun))
  if body != nil:
    body_580112 = body
  add(query_580111, "fields", newJString(fields))
  result = call_580110.call(nil, query_580111, nil, nil, body_580112)

var contentShippingsettingsCustombatch* = Call_ContentShippingsettingsCustombatch_580097(
    name: "contentShippingsettingsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/shippingsettings/batch",
    validator: validate_ContentShippingsettingsCustombatch_580098,
    base: "/content/v2", url: url_ContentShippingsettingsCustombatch_580099,
    schemes: {Scheme.Https})
type
  Call_ContentAccountsInsert_580144 = ref object of OpenApiRestCall_579373
proc url_ContentAccountsInsert_580146(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentAccountsInsert_580145(path: JsonNode; query: JsonNode;
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
  var valid_580147 = path.getOrDefault("merchantId")
  valid_580147 = validateParameter(valid_580147, JString, required = true,
                                 default = nil)
  if valid_580147 != nil:
    section.add "merchantId", valid_580147
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580148 = query.getOrDefault("key")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "key", valid_580148
  var valid_580149 = query.getOrDefault("prettyPrint")
  valid_580149 = validateParameter(valid_580149, JBool, required = false,
                                 default = newJBool(true))
  if valid_580149 != nil:
    section.add "prettyPrint", valid_580149
  var valid_580150 = query.getOrDefault("oauth_token")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "oauth_token", valid_580150
  var valid_580151 = query.getOrDefault("alt")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = newJString("json"))
  if valid_580151 != nil:
    section.add "alt", valid_580151
  var valid_580152 = query.getOrDefault("userIp")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "userIp", valid_580152
  var valid_580153 = query.getOrDefault("quotaUser")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "quotaUser", valid_580153
  var valid_580154 = query.getOrDefault("dryRun")
  valid_580154 = validateParameter(valid_580154, JBool, required = false, default = nil)
  if valid_580154 != nil:
    section.add "dryRun", valid_580154
  var valid_580155 = query.getOrDefault("fields")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "fields", valid_580155
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580157: Call_ContentAccountsInsert_580144; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Merchant Center sub-account.
  ## 
  let valid = call_580157.validator(path, query, header, formData, body)
  let scheme = call_580157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580157.url(scheme.get, call_580157.host, call_580157.base,
                         call_580157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580157, url, valid)

proc call*(call_580158: Call_ContentAccountsInsert_580144; merchantId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          dryRun: bool = false; body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentAccountsInsert
  ## Creates a Merchant Center sub-account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. This must be a multi-client account.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580159 = newJObject()
  var query_580160 = newJObject()
  var body_580161 = newJObject()
  add(query_580160, "key", newJString(key))
  add(query_580160, "prettyPrint", newJBool(prettyPrint))
  add(query_580160, "oauth_token", newJString(oauthToken))
  add(query_580160, "alt", newJString(alt))
  add(query_580160, "userIp", newJString(userIp))
  add(query_580160, "quotaUser", newJString(quotaUser))
  add(path_580159, "merchantId", newJString(merchantId))
  add(query_580160, "dryRun", newJBool(dryRun))
  if body != nil:
    body_580161 = body
  add(query_580160, "fields", newJString(fields))
  result = call_580158.call(path_580159, query_580160, nil, nil, body_580161)

var contentAccountsInsert* = Call_ContentAccountsInsert_580144(
    name: "contentAccountsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/accounts",
    validator: validate_ContentAccountsInsert_580145, base: "/content/v2",
    url: url_ContentAccountsInsert_580146, schemes: {Scheme.Https})
type
  Call_ContentAccountsList_580113 = ref object of OpenApiRestCall_579373
proc url_ContentAccountsList_580115(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentAccountsList_580114(path: JsonNode; query: JsonNode;
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
  var valid_580130 = path.getOrDefault("merchantId")
  valid_580130 = validateParameter(valid_580130, JString, required = true,
                                 default = nil)
  if valid_580130 != nil:
    section.add "merchantId", valid_580130
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of accounts to return in the response, used for paging.
  section = newJObject()
  var valid_580131 = query.getOrDefault("key")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "key", valid_580131
  var valid_580132 = query.getOrDefault("prettyPrint")
  valid_580132 = validateParameter(valid_580132, JBool, required = false,
                                 default = newJBool(true))
  if valid_580132 != nil:
    section.add "prettyPrint", valid_580132
  var valid_580133 = query.getOrDefault("oauth_token")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "oauth_token", valid_580133
  var valid_580134 = query.getOrDefault("alt")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = newJString("json"))
  if valid_580134 != nil:
    section.add "alt", valid_580134
  var valid_580135 = query.getOrDefault("userIp")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "userIp", valid_580135
  var valid_580136 = query.getOrDefault("quotaUser")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "quotaUser", valid_580136
  var valid_580137 = query.getOrDefault("pageToken")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "pageToken", valid_580137
  var valid_580138 = query.getOrDefault("fields")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "fields", valid_580138
  var valid_580139 = query.getOrDefault("maxResults")
  valid_580139 = validateParameter(valid_580139, JInt, required = false, default = nil)
  if valid_580139 != nil:
    section.add "maxResults", valid_580139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580140: Call_ContentAccountsList_580113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_580140.validator(path, query, header, formData, body)
  let scheme = call_580140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580140.url(scheme.get, call_580140.host, call_580140.base,
                         call_580140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580140, url, valid)

proc call*(call_580141: Call_ContentAccountsList_580113; merchantId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 0): Recallable =
  ## contentAccountsList
  ## Lists the sub-accounts in your Merchant Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. This must be a multi-client account.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of accounts to return in the response, used for paging.
  var path_580142 = newJObject()
  var query_580143 = newJObject()
  add(query_580143, "key", newJString(key))
  add(query_580143, "prettyPrint", newJBool(prettyPrint))
  add(query_580143, "oauth_token", newJString(oauthToken))
  add(query_580143, "alt", newJString(alt))
  add(query_580143, "userIp", newJString(userIp))
  add(query_580143, "quotaUser", newJString(quotaUser))
  add(path_580142, "merchantId", newJString(merchantId))
  add(query_580143, "pageToken", newJString(pageToken))
  add(query_580143, "fields", newJString(fields))
  add(query_580143, "maxResults", newJInt(maxResults))
  result = call_580141.call(path_580142, query_580143, nil, nil, nil)

var contentAccountsList* = Call_ContentAccountsList_580113(
    name: "contentAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounts",
    validator: validate_ContentAccountsList_580114, base: "/content/v2",
    url: url_ContentAccountsList_580115, schemes: {Scheme.Https})
type
  Call_ContentAccountsUpdate_580178 = ref object of OpenApiRestCall_579373
proc url_ContentAccountsUpdate_580180(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentAccountsUpdate_580179(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   accountId: JString (required)
  ##            : The ID of the account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580181 = path.getOrDefault("merchantId")
  valid_580181 = validateParameter(valid_580181, JString, required = true,
                                 default = nil)
  if valid_580181 != nil:
    section.add "merchantId", valid_580181
  var valid_580182 = path.getOrDefault("accountId")
  valid_580182 = validateParameter(valid_580182, JString, required = true,
                                 default = nil)
  if valid_580182 != nil:
    section.add "accountId", valid_580182
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580183 = query.getOrDefault("key")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "key", valid_580183
  var valid_580184 = query.getOrDefault("prettyPrint")
  valid_580184 = validateParameter(valid_580184, JBool, required = false,
                                 default = newJBool(true))
  if valid_580184 != nil:
    section.add "prettyPrint", valid_580184
  var valid_580185 = query.getOrDefault("oauth_token")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "oauth_token", valid_580185
  var valid_580186 = query.getOrDefault("alt")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = newJString("json"))
  if valid_580186 != nil:
    section.add "alt", valid_580186
  var valid_580187 = query.getOrDefault("userIp")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "userIp", valid_580187
  var valid_580188 = query.getOrDefault("quotaUser")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "quotaUser", valid_580188
  var valid_580189 = query.getOrDefault("dryRun")
  valid_580189 = validateParameter(valid_580189, JBool, required = false, default = nil)
  if valid_580189 != nil:
    section.add "dryRun", valid_580189
  var valid_580190 = query.getOrDefault("fields")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "fields", valid_580190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580192: Call_ContentAccountsUpdate_580178; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Merchant Center account.
  ## 
  let valid = call_580192.validator(path, query, header, formData, body)
  let scheme = call_580192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580192.url(scheme.get, call_580192.host, call_580192.base,
                         call_580192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580192, url, valid)

proc call*(call_580193: Call_ContentAccountsUpdate_580178; merchantId: string;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; dryRun: bool = false; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentAccountsUpdate
  ## Updates a Merchant Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The ID of the account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580194 = newJObject()
  var query_580195 = newJObject()
  var body_580196 = newJObject()
  add(query_580195, "key", newJString(key))
  add(query_580195, "prettyPrint", newJBool(prettyPrint))
  add(query_580195, "oauth_token", newJString(oauthToken))
  add(query_580195, "alt", newJString(alt))
  add(query_580195, "userIp", newJString(userIp))
  add(query_580195, "quotaUser", newJString(quotaUser))
  add(path_580194, "merchantId", newJString(merchantId))
  add(query_580195, "dryRun", newJBool(dryRun))
  if body != nil:
    body_580196 = body
  add(path_580194, "accountId", newJString(accountId))
  add(query_580195, "fields", newJString(fields))
  result = call_580193.call(path_580194, query_580195, nil, nil, body_580196)

var contentAccountsUpdate* = Call_ContentAccountsUpdate_580178(
    name: "contentAccountsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsUpdate_580179, base: "/content/v2",
    url: url_ContentAccountsUpdate_580180, schemes: {Scheme.Https})
type
  Call_ContentAccountsGet_580162 = ref object of OpenApiRestCall_579373
proc url_ContentAccountsGet_580164(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentAccountsGet_580163(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves a Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   accountId: JString (required)
  ##            : The ID of the account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580165 = path.getOrDefault("merchantId")
  valid_580165 = validateParameter(valid_580165, JString, required = true,
                                 default = nil)
  if valid_580165 != nil:
    section.add "merchantId", valid_580165
  var valid_580166 = path.getOrDefault("accountId")
  valid_580166 = validateParameter(valid_580166, JString, required = true,
                                 default = nil)
  if valid_580166 != nil:
    section.add "accountId", valid_580166
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580167 = query.getOrDefault("key")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "key", valid_580167
  var valid_580168 = query.getOrDefault("prettyPrint")
  valid_580168 = validateParameter(valid_580168, JBool, required = false,
                                 default = newJBool(true))
  if valid_580168 != nil:
    section.add "prettyPrint", valid_580168
  var valid_580169 = query.getOrDefault("oauth_token")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "oauth_token", valid_580169
  var valid_580170 = query.getOrDefault("alt")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = newJString("json"))
  if valid_580170 != nil:
    section.add "alt", valid_580170
  var valid_580171 = query.getOrDefault("userIp")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "userIp", valid_580171
  var valid_580172 = query.getOrDefault("quotaUser")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "quotaUser", valid_580172
  var valid_580173 = query.getOrDefault("fields")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "fields", valid_580173
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580174: Call_ContentAccountsGet_580162; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a Merchant Center account.
  ## 
  let valid = call_580174.validator(path, query, header, formData, body)
  let scheme = call_580174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580174.url(scheme.get, call_580174.host, call_580174.base,
                         call_580174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580174, url, valid)

proc call*(call_580175: Call_ContentAccountsGet_580162; merchantId: string;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## contentAccountsGet
  ## Retrieves a Merchant Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   accountId: string (required)
  ##            : The ID of the account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580176 = newJObject()
  var query_580177 = newJObject()
  add(query_580177, "key", newJString(key))
  add(query_580177, "prettyPrint", newJBool(prettyPrint))
  add(query_580177, "oauth_token", newJString(oauthToken))
  add(query_580177, "alt", newJString(alt))
  add(query_580177, "userIp", newJString(userIp))
  add(query_580177, "quotaUser", newJString(quotaUser))
  add(path_580176, "merchantId", newJString(merchantId))
  add(path_580176, "accountId", newJString(accountId))
  add(query_580177, "fields", newJString(fields))
  result = call_580175.call(path_580176, query_580177, nil, nil, nil)

var contentAccountsGet* = Call_ContentAccountsGet_580162(
    name: "contentAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsGet_580163, base: "/content/v2",
    url: url_ContentAccountsGet_580164, schemes: {Scheme.Https})
type
  Call_ContentAccountsDelete_580197 = ref object of OpenApiRestCall_579373
proc url_ContentAccountsDelete_580199(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentAccountsDelete_580198(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a Merchant Center sub-account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. This must be a multi-client account, and accountId must be the ID of a sub-account of this account.
  ##   accountId: JString (required)
  ##            : The ID of the account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580200 = path.getOrDefault("merchantId")
  valid_580200 = validateParameter(valid_580200, JString, required = true,
                                 default = nil)
  if valid_580200 != nil:
    section.add "merchantId", valid_580200
  var valid_580201 = path.getOrDefault("accountId")
  valid_580201 = validateParameter(valid_580201, JString, required = true,
                                 default = nil)
  if valid_580201 != nil:
    section.add "accountId", valid_580201
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   force: JBool
  ##        : Flag to delete sub-accounts with products. The default value is false.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580202 = query.getOrDefault("key")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "key", valid_580202
  var valid_580203 = query.getOrDefault("prettyPrint")
  valid_580203 = validateParameter(valid_580203, JBool, required = false,
                                 default = newJBool(true))
  if valid_580203 != nil:
    section.add "prettyPrint", valid_580203
  var valid_580204 = query.getOrDefault("oauth_token")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "oauth_token", valid_580204
  var valid_580205 = query.getOrDefault("alt")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = newJString("json"))
  if valid_580205 != nil:
    section.add "alt", valid_580205
  var valid_580206 = query.getOrDefault("userIp")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "userIp", valid_580206
  var valid_580207 = query.getOrDefault("quotaUser")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "quotaUser", valid_580207
  var valid_580208 = query.getOrDefault("dryRun")
  valid_580208 = validateParameter(valid_580208, JBool, required = false, default = nil)
  if valid_580208 != nil:
    section.add "dryRun", valid_580208
  var valid_580209 = query.getOrDefault("force")
  valid_580209 = validateParameter(valid_580209, JBool, required = false,
                                 default = newJBool(false))
  if valid_580209 != nil:
    section.add "force", valid_580209
  var valid_580210 = query.getOrDefault("fields")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "fields", valid_580210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580211: Call_ContentAccountsDelete_580197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Merchant Center sub-account.
  ## 
  let valid = call_580211.validator(path, query, header, formData, body)
  let scheme = call_580211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580211.url(scheme.get, call_580211.host, call_580211.base,
                         call_580211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580211, url, valid)

proc call*(call_580212: Call_ContentAccountsDelete_580197; merchantId: string;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; dryRun: bool = false; force: bool = false;
          fields: string = ""): Recallable =
  ## contentAccountsDelete
  ## Deletes a Merchant Center sub-account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. This must be a multi-client account, and accountId must be the ID of a sub-account of this account.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   force: bool
  ##        : Flag to delete sub-accounts with products. The default value is false.
  ##   accountId: string (required)
  ##            : The ID of the account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580213 = newJObject()
  var query_580214 = newJObject()
  add(query_580214, "key", newJString(key))
  add(query_580214, "prettyPrint", newJBool(prettyPrint))
  add(query_580214, "oauth_token", newJString(oauthToken))
  add(query_580214, "alt", newJString(alt))
  add(query_580214, "userIp", newJString(userIp))
  add(query_580214, "quotaUser", newJString(quotaUser))
  add(path_580213, "merchantId", newJString(merchantId))
  add(query_580214, "dryRun", newJBool(dryRun))
  add(query_580214, "force", newJBool(force))
  add(path_580213, "accountId", newJString(accountId))
  add(query_580214, "fields", newJString(fields))
  result = call_580212.call(path_580213, query_580214, nil, nil, nil)

var contentAccountsDelete* = Call_ContentAccountsDelete_580197(
    name: "contentAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsDelete_580198, base: "/content/v2",
    url: url_ContentAccountsDelete_580199, schemes: {Scheme.Https})
type
  Call_ContentAccountsClaimwebsite_580215 = ref object of OpenApiRestCall_579373
proc url_ContentAccountsClaimwebsite_580217(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentAccountsClaimwebsite_580216(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Claims the website of a Merchant Center sub-account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   accountId: JString (required)
  ##            : The ID of the account whose website is claimed.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580218 = path.getOrDefault("merchantId")
  valid_580218 = validateParameter(valid_580218, JString, required = true,
                                 default = nil)
  if valid_580218 != nil:
    section.add "merchantId", valid_580218
  var valid_580219 = path.getOrDefault("accountId")
  valid_580219 = validateParameter(valid_580219, JString, required = true,
                                 default = nil)
  if valid_580219 != nil:
    section.add "accountId", valid_580219
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   overwrite: JBool
  ##            : Only available to selected merchants. When set to True, this flag removes any existing claim on the requested website by another account and replaces it with a claim from this account.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
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
  var valid_580222 = query.getOrDefault("oauth_token")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "oauth_token", valid_580222
  var valid_580223 = query.getOrDefault("overwrite")
  valid_580223 = validateParameter(valid_580223, JBool, required = false, default = nil)
  if valid_580223 != nil:
    section.add "overwrite", valid_580223
  var valid_580224 = query.getOrDefault("alt")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = newJString("json"))
  if valid_580224 != nil:
    section.add "alt", valid_580224
  var valid_580225 = query.getOrDefault("userIp")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "userIp", valid_580225
  var valid_580226 = query.getOrDefault("quotaUser")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "quotaUser", valid_580226
  var valid_580227 = query.getOrDefault("fields")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "fields", valid_580227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580228: Call_ContentAccountsClaimwebsite_580215; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Claims the website of a Merchant Center sub-account.
  ## 
  let valid = call_580228.validator(path, query, header, formData, body)
  let scheme = call_580228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580228.url(scheme.get, call_580228.host, call_580228.base,
                         call_580228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580228, url, valid)

proc call*(call_580229: Call_ContentAccountsClaimwebsite_580215;
          merchantId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; overwrite: bool = false;
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## contentAccountsClaimwebsite
  ## Claims the website of a Merchant Center sub-account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   overwrite: bool
  ##            : Only available to selected merchants. When set to True, this flag removes any existing claim on the requested website by another account and replaces it with a claim from this account.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   accountId: string (required)
  ##            : The ID of the account whose website is claimed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580230 = newJObject()
  var query_580231 = newJObject()
  add(query_580231, "key", newJString(key))
  add(query_580231, "prettyPrint", newJBool(prettyPrint))
  add(query_580231, "oauth_token", newJString(oauthToken))
  add(query_580231, "overwrite", newJBool(overwrite))
  add(query_580231, "alt", newJString(alt))
  add(query_580231, "userIp", newJString(userIp))
  add(query_580231, "quotaUser", newJString(quotaUser))
  add(path_580230, "merchantId", newJString(merchantId))
  add(path_580230, "accountId", newJString(accountId))
  add(query_580231, "fields", newJString(fields))
  result = call_580229.call(path_580230, query_580231, nil, nil, nil)

var contentAccountsClaimwebsite* = Call_ContentAccountsClaimwebsite_580215(
    name: "contentAccountsClaimwebsite", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/accounts/{accountId}/claimwebsite",
    validator: validate_ContentAccountsClaimwebsite_580216, base: "/content/v2",
    url: url_ContentAccountsClaimwebsite_580217, schemes: {Scheme.Https})
type
  Call_ContentAccountsLink_580232 = ref object of OpenApiRestCall_579373
proc url_ContentAccountsLink_580234(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentAccountsLink_580233(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Performs an action on a link between two Merchant Center accounts, namely accountId and linkedAccountId.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   accountId: JString (required)
  ##            : The ID of the account that should be linked.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580235 = path.getOrDefault("merchantId")
  valid_580235 = validateParameter(valid_580235, JString, required = true,
                                 default = nil)
  if valid_580235 != nil:
    section.add "merchantId", valid_580235
  var valid_580236 = path.getOrDefault("accountId")
  valid_580236 = validateParameter(valid_580236, JString, required = true,
                                 default = nil)
  if valid_580236 != nil:
    section.add "accountId", valid_580236
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580237 = query.getOrDefault("key")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "key", valid_580237
  var valid_580238 = query.getOrDefault("prettyPrint")
  valid_580238 = validateParameter(valid_580238, JBool, required = false,
                                 default = newJBool(true))
  if valid_580238 != nil:
    section.add "prettyPrint", valid_580238
  var valid_580239 = query.getOrDefault("oauth_token")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "oauth_token", valid_580239
  var valid_580240 = query.getOrDefault("alt")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = newJString("json"))
  if valid_580240 != nil:
    section.add "alt", valid_580240
  var valid_580241 = query.getOrDefault("userIp")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "userIp", valid_580241
  var valid_580242 = query.getOrDefault("quotaUser")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "quotaUser", valid_580242
  var valid_580243 = query.getOrDefault("fields")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "fields", valid_580243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580245: Call_ContentAccountsLink_580232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs an action on a link between two Merchant Center accounts, namely accountId and linkedAccountId.
  ## 
  let valid = call_580245.validator(path, query, header, formData, body)
  let scheme = call_580245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580245.url(scheme.get, call_580245.host, call_580245.base,
                         call_580245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580245, url, valid)

proc call*(call_580246: Call_ContentAccountsLink_580232; merchantId: string;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentAccountsLink
  ## Performs an action on a link between two Merchant Center accounts, namely accountId and linkedAccountId.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The ID of the account that should be linked.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580247 = newJObject()
  var query_580248 = newJObject()
  var body_580249 = newJObject()
  add(query_580248, "key", newJString(key))
  add(query_580248, "prettyPrint", newJBool(prettyPrint))
  add(query_580248, "oauth_token", newJString(oauthToken))
  add(query_580248, "alt", newJString(alt))
  add(query_580248, "userIp", newJString(userIp))
  add(query_580248, "quotaUser", newJString(quotaUser))
  add(path_580247, "merchantId", newJString(merchantId))
  if body != nil:
    body_580249 = body
  add(path_580247, "accountId", newJString(accountId))
  add(query_580248, "fields", newJString(fields))
  result = call_580246.call(path_580247, query_580248, nil, nil, body_580249)

var contentAccountsLink* = Call_ContentAccountsLink_580232(
    name: "contentAccountsLink", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}/link",
    validator: validate_ContentAccountsLink_580233, base: "/content/v2",
    url: url_ContentAccountsLink_580234, schemes: {Scheme.Https})
type
  Call_ContentAccountstatusesList_580250 = ref object of OpenApiRestCall_579373
proc url_ContentAccountstatusesList_580252(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentAccountstatusesList_580251(path: JsonNode; query: JsonNode;
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
  var valid_580253 = path.getOrDefault("merchantId")
  valid_580253 = validateParameter(valid_580253, JString, required = true,
                                 default = nil)
  if valid_580253 != nil:
    section.add "merchantId", valid_580253
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   destinations: JArray
  ##               : If set, only issues for the specified destinations are returned, otherwise only issues for the Shopping destination.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of account statuses to return in the response, used for paging.
  section = newJObject()
  var valid_580254 = query.getOrDefault("key")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "key", valid_580254
  var valid_580255 = query.getOrDefault("prettyPrint")
  valid_580255 = validateParameter(valid_580255, JBool, required = false,
                                 default = newJBool(true))
  if valid_580255 != nil:
    section.add "prettyPrint", valid_580255
  var valid_580256 = query.getOrDefault("oauth_token")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "oauth_token", valid_580256
  var valid_580257 = query.getOrDefault("alt")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = newJString("json"))
  if valid_580257 != nil:
    section.add "alt", valid_580257
  var valid_580258 = query.getOrDefault("userIp")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "userIp", valid_580258
  var valid_580259 = query.getOrDefault("quotaUser")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "quotaUser", valid_580259
  var valid_580260 = query.getOrDefault("pageToken")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "pageToken", valid_580260
  var valid_580261 = query.getOrDefault("destinations")
  valid_580261 = validateParameter(valid_580261, JArray, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "destinations", valid_580261
  var valid_580262 = query.getOrDefault("fields")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "fields", valid_580262
  var valid_580263 = query.getOrDefault("maxResults")
  valid_580263 = validateParameter(valid_580263, JInt, required = false, default = nil)
  if valid_580263 != nil:
    section.add "maxResults", valid_580263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580264: Call_ContentAccountstatusesList_580250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_580264.validator(path, query, header, formData, body)
  let scheme = call_580264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580264.url(scheme.get, call_580264.host, call_580264.base,
                         call_580264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580264, url, valid)

proc call*(call_580265: Call_ContentAccountstatusesList_580250; merchantId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; destinations: JsonNode = nil; fields: string = "";
          maxResults: int = 0): Recallable =
  ## contentAccountstatusesList
  ## Lists the statuses of the sub-accounts in your Merchant Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. This must be a multi-client account.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   destinations: JArray
  ##               : If set, only issues for the specified destinations are returned, otherwise only issues for the Shopping destination.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of account statuses to return in the response, used for paging.
  var path_580266 = newJObject()
  var query_580267 = newJObject()
  add(query_580267, "key", newJString(key))
  add(query_580267, "prettyPrint", newJBool(prettyPrint))
  add(query_580267, "oauth_token", newJString(oauthToken))
  add(query_580267, "alt", newJString(alt))
  add(query_580267, "userIp", newJString(userIp))
  add(query_580267, "quotaUser", newJString(quotaUser))
  add(path_580266, "merchantId", newJString(merchantId))
  add(query_580267, "pageToken", newJString(pageToken))
  if destinations != nil:
    query_580267.add "destinations", destinations
  add(query_580267, "fields", newJString(fields))
  add(query_580267, "maxResults", newJInt(maxResults))
  result = call_580265.call(path_580266, query_580267, nil, nil, nil)

var contentAccountstatusesList* = Call_ContentAccountstatusesList_580250(
    name: "contentAccountstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accountstatuses",
    validator: validate_ContentAccountstatusesList_580251, base: "/content/v2",
    url: url_ContentAccountstatusesList_580252, schemes: {Scheme.Https})
type
  Call_ContentAccountstatusesGet_580268 = ref object of OpenApiRestCall_579373
proc url_ContentAccountstatusesGet_580270(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentAccountstatusesGet_580269(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the status of a Merchant Center account. No itemLevelIssues are returned for multi-client accounts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   accountId: JString (required)
  ##            : The ID of the account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580271 = path.getOrDefault("merchantId")
  valid_580271 = validateParameter(valid_580271, JString, required = true,
                                 default = nil)
  if valid_580271 != nil:
    section.add "merchantId", valid_580271
  var valid_580272 = path.getOrDefault("accountId")
  valid_580272 = validateParameter(valid_580272, JString, required = true,
                                 default = nil)
  if valid_580272 != nil:
    section.add "accountId", valid_580272
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   destinations: JArray
  ##               : If set, only issues for the specified destinations are returned, otherwise only issues for the Shopping destination.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580273 = query.getOrDefault("key")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "key", valid_580273
  var valid_580274 = query.getOrDefault("prettyPrint")
  valid_580274 = validateParameter(valid_580274, JBool, required = false,
                                 default = newJBool(true))
  if valid_580274 != nil:
    section.add "prettyPrint", valid_580274
  var valid_580275 = query.getOrDefault("oauth_token")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = nil)
  if valid_580275 != nil:
    section.add "oauth_token", valid_580275
  var valid_580276 = query.getOrDefault("alt")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = newJString("json"))
  if valid_580276 != nil:
    section.add "alt", valid_580276
  var valid_580277 = query.getOrDefault("userIp")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "userIp", valid_580277
  var valid_580278 = query.getOrDefault("quotaUser")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "quotaUser", valid_580278
  var valid_580279 = query.getOrDefault("destinations")
  valid_580279 = validateParameter(valid_580279, JArray, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "destinations", valid_580279
  var valid_580280 = query.getOrDefault("fields")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "fields", valid_580280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580281: Call_ContentAccountstatusesGet_580268; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the status of a Merchant Center account. No itemLevelIssues are returned for multi-client accounts.
  ## 
  let valid = call_580281.validator(path, query, header, formData, body)
  let scheme = call_580281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580281.url(scheme.get, call_580281.host, call_580281.base,
                         call_580281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580281, url, valid)

proc call*(call_580282: Call_ContentAccountstatusesGet_580268; merchantId: string;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; destinations: JsonNode = nil; fields: string = ""): Recallable =
  ## contentAccountstatusesGet
  ## Retrieves the status of a Merchant Center account. No itemLevelIssues are returned for multi-client accounts.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   destinations: JArray
  ##               : If set, only issues for the specified destinations are returned, otherwise only issues for the Shopping destination.
  ##   accountId: string (required)
  ##            : The ID of the account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580283 = newJObject()
  var query_580284 = newJObject()
  add(query_580284, "key", newJString(key))
  add(query_580284, "prettyPrint", newJBool(prettyPrint))
  add(query_580284, "oauth_token", newJString(oauthToken))
  add(query_580284, "alt", newJString(alt))
  add(query_580284, "userIp", newJString(userIp))
  add(query_580284, "quotaUser", newJString(quotaUser))
  add(path_580283, "merchantId", newJString(merchantId))
  if destinations != nil:
    query_580284.add "destinations", destinations
  add(path_580283, "accountId", newJString(accountId))
  add(query_580284, "fields", newJString(fields))
  result = call_580282.call(path_580283, query_580284, nil, nil, nil)

var contentAccountstatusesGet* = Call_ContentAccountstatusesGet_580268(
    name: "contentAccountstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/accountstatuses/{accountId}",
    validator: validate_ContentAccountstatusesGet_580269, base: "/content/v2",
    url: url_ContentAccountstatusesGet_580270, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxList_580285 = ref object of OpenApiRestCall_579373
proc url_ContentAccounttaxList_580287(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentAccounttaxList_580286(path: JsonNode; query: JsonNode;
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
  var valid_580288 = path.getOrDefault("merchantId")
  valid_580288 = validateParameter(valid_580288, JString, required = true,
                                 default = nil)
  if valid_580288 != nil:
    section.add "merchantId", valid_580288
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of tax settings to return in the response, used for paging.
  section = newJObject()
  var valid_580289 = query.getOrDefault("key")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "key", valid_580289
  var valid_580290 = query.getOrDefault("prettyPrint")
  valid_580290 = validateParameter(valid_580290, JBool, required = false,
                                 default = newJBool(true))
  if valid_580290 != nil:
    section.add "prettyPrint", valid_580290
  var valid_580291 = query.getOrDefault("oauth_token")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "oauth_token", valid_580291
  var valid_580292 = query.getOrDefault("alt")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = newJString("json"))
  if valid_580292 != nil:
    section.add "alt", valid_580292
  var valid_580293 = query.getOrDefault("userIp")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "userIp", valid_580293
  var valid_580294 = query.getOrDefault("quotaUser")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "quotaUser", valid_580294
  var valid_580295 = query.getOrDefault("pageToken")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "pageToken", valid_580295
  var valid_580296 = query.getOrDefault("fields")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = nil)
  if valid_580296 != nil:
    section.add "fields", valid_580296
  var valid_580297 = query.getOrDefault("maxResults")
  valid_580297 = validateParameter(valid_580297, JInt, required = false, default = nil)
  if valid_580297 != nil:
    section.add "maxResults", valid_580297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580298: Call_ContentAccounttaxList_580285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the tax settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_580298.validator(path, query, header, formData, body)
  let scheme = call_580298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580298.url(scheme.get, call_580298.host, call_580298.base,
                         call_580298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580298, url, valid)

proc call*(call_580299: Call_ContentAccounttaxList_580285; merchantId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 0): Recallable =
  ## contentAccounttaxList
  ## Lists the tax settings of the sub-accounts in your Merchant Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. This must be a multi-client account.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of tax settings to return in the response, used for paging.
  var path_580300 = newJObject()
  var query_580301 = newJObject()
  add(query_580301, "key", newJString(key))
  add(query_580301, "prettyPrint", newJBool(prettyPrint))
  add(query_580301, "oauth_token", newJString(oauthToken))
  add(query_580301, "alt", newJString(alt))
  add(query_580301, "userIp", newJString(userIp))
  add(query_580301, "quotaUser", newJString(quotaUser))
  add(path_580300, "merchantId", newJString(merchantId))
  add(query_580301, "pageToken", newJString(pageToken))
  add(query_580301, "fields", newJString(fields))
  add(query_580301, "maxResults", newJInt(maxResults))
  result = call_580299.call(path_580300, query_580301, nil, nil, nil)

var contentAccounttaxList* = Call_ContentAccounttaxList_580285(
    name: "contentAccounttaxList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax",
    validator: validate_ContentAccounttaxList_580286, base: "/content/v2",
    url: url_ContentAccounttaxList_580287, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxUpdate_580318 = ref object of OpenApiRestCall_579373
proc url_ContentAccounttaxUpdate_580320(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentAccounttaxUpdate_580319(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the tax settings of the account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   accountId: JString (required)
  ##            : The ID of the account for which to get/update account tax settings.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580321 = path.getOrDefault("merchantId")
  valid_580321 = validateParameter(valid_580321, JString, required = true,
                                 default = nil)
  if valid_580321 != nil:
    section.add "merchantId", valid_580321
  var valid_580322 = path.getOrDefault("accountId")
  valid_580322 = validateParameter(valid_580322, JString, required = true,
                                 default = nil)
  if valid_580322 != nil:
    section.add "accountId", valid_580322
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580323 = query.getOrDefault("key")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "key", valid_580323
  var valid_580324 = query.getOrDefault("prettyPrint")
  valid_580324 = validateParameter(valid_580324, JBool, required = false,
                                 default = newJBool(true))
  if valid_580324 != nil:
    section.add "prettyPrint", valid_580324
  var valid_580325 = query.getOrDefault("oauth_token")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "oauth_token", valid_580325
  var valid_580326 = query.getOrDefault("alt")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = newJString("json"))
  if valid_580326 != nil:
    section.add "alt", valid_580326
  var valid_580327 = query.getOrDefault("userIp")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "userIp", valid_580327
  var valid_580328 = query.getOrDefault("quotaUser")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "quotaUser", valid_580328
  var valid_580329 = query.getOrDefault("dryRun")
  valid_580329 = validateParameter(valid_580329, JBool, required = false, default = nil)
  if valid_580329 != nil:
    section.add "dryRun", valid_580329
  var valid_580330 = query.getOrDefault("fields")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "fields", valid_580330
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580332: Call_ContentAccounttaxUpdate_580318; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the tax settings of the account.
  ## 
  let valid = call_580332.validator(path, query, header, formData, body)
  let scheme = call_580332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580332.url(scheme.get, call_580332.host, call_580332.base,
                         call_580332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580332, url, valid)

proc call*(call_580333: Call_ContentAccounttaxUpdate_580318; merchantId: string;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; dryRun: bool = false; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentAccounttaxUpdate
  ## Updates the tax settings of the account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The ID of the account for which to get/update account tax settings.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580334 = newJObject()
  var query_580335 = newJObject()
  var body_580336 = newJObject()
  add(query_580335, "key", newJString(key))
  add(query_580335, "prettyPrint", newJBool(prettyPrint))
  add(query_580335, "oauth_token", newJString(oauthToken))
  add(query_580335, "alt", newJString(alt))
  add(query_580335, "userIp", newJString(userIp))
  add(query_580335, "quotaUser", newJString(quotaUser))
  add(path_580334, "merchantId", newJString(merchantId))
  add(query_580335, "dryRun", newJBool(dryRun))
  if body != nil:
    body_580336 = body
  add(path_580334, "accountId", newJString(accountId))
  add(query_580335, "fields", newJString(fields))
  result = call_580333.call(path_580334, query_580335, nil, nil, body_580336)

var contentAccounttaxUpdate* = Call_ContentAccounttaxUpdate_580318(
    name: "contentAccounttaxUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax/{accountId}",
    validator: validate_ContentAccounttaxUpdate_580319, base: "/content/v2",
    url: url_ContentAccounttaxUpdate_580320, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxGet_580302 = ref object of OpenApiRestCall_579373
proc url_ContentAccounttaxGet_580304(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentAccounttaxGet_580303(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the tax settings of the account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   accountId: JString (required)
  ##            : The ID of the account for which to get/update account tax settings.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580305 = path.getOrDefault("merchantId")
  valid_580305 = validateParameter(valid_580305, JString, required = true,
                                 default = nil)
  if valid_580305 != nil:
    section.add "merchantId", valid_580305
  var valid_580306 = path.getOrDefault("accountId")
  valid_580306 = validateParameter(valid_580306, JString, required = true,
                                 default = nil)
  if valid_580306 != nil:
    section.add "accountId", valid_580306
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
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
  var valid_580309 = query.getOrDefault("oauth_token")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "oauth_token", valid_580309
  var valid_580310 = query.getOrDefault("alt")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = newJString("json"))
  if valid_580310 != nil:
    section.add "alt", valid_580310
  var valid_580311 = query.getOrDefault("userIp")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "userIp", valid_580311
  var valid_580312 = query.getOrDefault("quotaUser")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "quotaUser", valid_580312
  var valid_580313 = query.getOrDefault("fields")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "fields", valid_580313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580314: Call_ContentAccounttaxGet_580302; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the tax settings of the account.
  ## 
  let valid = call_580314.validator(path, query, header, formData, body)
  let scheme = call_580314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580314.url(scheme.get, call_580314.host, call_580314.base,
                         call_580314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580314, url, valid)

proc call*(call_580315: Call_ContentAccounttaxGet_580302; merchantId: string;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## contentAccounttaxGet
  ## Retrieves the tax settings of the account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   accountId: string (required)
  ##            : The ID of the account for which to get/update account tax settings.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580316 = newJObject()
  var query_580317 = newJObject()
  add(query_580317, "key", newJString(key))
  add(query_580317, "prettyPrint", newJBool(prettyPrint))
  add(query_580317, "oauth_token", newJString(oauthToken))
  add(query_580317, "alt", newJString(alt))
  add(query_580317, "userIp", newJString(userIp))
  add(query_580317, "quotaUser", newJString(quotaUser))
  add(path_580316, "merchantId", newJString(merchantId))
  add(path_580316, "accountId", newJString(accountId))
  add(query_580317, "fields", newJString(fields))
  result = call_580315.call(path_580316, query_580317, nil, nil, nil)

var contentAccounttaxGet* = Call_ContentAccounttaxGet_580302(
    name: "contentAccounttaxGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax/{accountId}",
    validator: validate_ContentAccounttaxGet_580303, base: "/content/v2",
    url: url_ContentAccounttaxGet_580304, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsInsert_580354 = ref object of OpenApiRestCall_579373
proc url_ContentDatafeedsInsert_580356(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentDatafeedsInsert_580355(path: JsonNode; query: JsonNode;
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
  var valid_580357 = path.getOrDefault("merchantId")
  valid_580357 = validateParameter(valid_580357, JString, required = true,
                                 default = nil)
  if valid_580357 != nil:
    section.add "merchantId", valid_580357
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580358 = query.getOrDefault("key")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "key", valid_580358
  var valid_580359 = query.getOrDefault("prettyPrint")
  valid_580359 = validateParameter(valid_580359, JBool, required = false,
                                 default = newJBool(true))
  if valid_580359 != nil:
    section.add "prettyPrint", valid_580359
  var valid_580360 = query.getOrDefault("oauth_token")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "oauth_token", valid_580360
  var valid_580361 = query.getOrDefault("alt")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = newJString("json"))
  if valid_580361 != nil:
    section.add "alt", valid_580361
  var valid_580362 = query.getOrDefault("userIp")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "userIp", valid_580362
  var valid_580363 = query.getOrDefault("quotaUser")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = nil)
  if valid_580363 != nil:
    section.add "quotaUser", valid_580363
  var valid_580364 = query.getOrDefault("dryRun")
  valid_580364 = validateParameter(valid_580364, JBool, required = false, default = nil)
  if valid_580364 != nil:
    section.add "dryRun", valid_580364
  var valid_580365 = query.getOrDefault("fields")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "fields", valid_580365
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580367: Call_ContentDatafeedsInsert_580354; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers a datafeed configuration with your Merchant Center account.
  ## 
  let valid = call_580367.validator(path, query, header, formData, body)
  let scheme = call_580367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580367.url(scheme.get, call_580367.host, call_580367.base,
                         call_580367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580367, url, valid)

proc call*(call_580368: Call_ContentDatafeedsInsert_580354; merchantId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          dryRun: bool = false; body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentDatafeedsInsert
  ## Registers a datafeed configuration with your Merchant Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the datafeed. This account cannot be a multi-client account.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580369 = newJObject()
  var query_580370 = newJObject()
  var body_580371 = newJObject()
  add(query_580370, "key", newJString(key))
  add(query_580370, "prettyPrint", newJBool(prettyPrint))
  add(query_580370, "oauth_token", newJString(oauthToken))
  add(query_580370, "alt", newJString(alt))
  add(query_580370, "userIp", newJString(userIp))
  add(query_580370, "quotaUser", newJString(quotaUser))
  add(path_580369, "merchantId", newJString(merchantId))
  add(query_580370, "dryRun", newJBool(dryRun))
  if body != nil:
    body_580371 = body
  add(query_580370, "fields", newJString(fields))
  result = call_580368.call(path_580369, query_580370, nil, nil, body_580371)

var contentDatafeedsInsert* = Call_ContentDatafeedsInsert_580354(
    name: "contentDatafeedsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds",
    validator: validate_ContentDatafeedsInsert_580355, base: "/content/v2",
    url: url_ContentDatafeedsInsert_580356, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsList_580337 = ref object of OpenApiRestCall_579373
proc url_ContentDatafeedsList_580339(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentDatafeedsList_580338(path: JsonNode; query: JsonNode;
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
  var valid_580340 = path.getOrDefault("merchantId")
  valid_580340 = validateParameter(valid_580340, JString, required = true,
                                 default = nil)
  if valid_580340 != nil:
    section.add "merchantId", valid_580340
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of products to return in the response, used for paging.
  section = newJObject()
  var valid_580341 = query.getOrDefault("key")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "key", valid_580341
  var valid_580342 = query.getOrDefault("prettyPrint")
  valid_580342 = validateParameter(valid_580342, JBool, required = false,
                                 default = newJBool(true))
  if valid_580342 != nil:
    section.add "prettyPrint", valid_580342
  var valid_580343 = query.getOrDefault("oauth_token")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "oauth_token", valid_580343
  var valid_580344 = query.getOrDefault("alt")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = newJString("json"))
  if valid_580344 != nil:
    section.add "alt", valid_580344
  var valid_580345 = query.getOrDefault("userIp")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = nil)
  if valid_580345 != nil:
    section.add "userIp", valid_580345
  var valid_580346 = query.getOrDefault("quotaUser")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = nil)
  if valid_580346 != nil:
    section.add "quotaUser", valid_580346
  var valid_580347 = query.getOrDefault("pageToken")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = nil)
  if valid_580347 != nil:
    section.add "pageToken", valid_580347
  var valid_580348 = query.getOrDefault("fields")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "fields", valid_580348
  var valid_580349 = query.getOrDefault("maxResults")
  valid_580349 = validateParameter(valid_580349, JInt, required = false, default = nil)
  if valid_580349 != nil:
    section.add "maxResults", valid_580349
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580350: Call_ContentDatafeedsList_580337; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the configurations for datafeeds in your Merchant Center account.
  ## 
  let valid = call_580350.validator(path, query, header, formData, body)
  let scheme = call_580350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580350.url(scheme.get, call_580350.host, call_580350.base,
                         call_580350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580350, url, valid)

proc call*(call_580351: Call_ContentDatafeedsList_580337; merchantId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 0): Recallable =
  ## contentDatafeedsList
  ## Lists the configurations for datafeeds in your Merchant Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the datafeeds. This account cannot be a multi-client account.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of products to return in the response, used for paging.
  var path_580352 = newJObject()
  var query_580353 = newJObject()
  add(query_580353, "key", newJString(key))
  add(query_580353, "prettyPrint", newJBool(prettyPrint))
  add(query_580353, "oauth_token", newJString(oauthToken))
  add(query_580353, "alt", newJString(alt))
  add(query_580353, "userIp", newJString(userIp))
  add(query_580353, "quotaUser", newJString(quotaUser))
  add(path_580352, "merchantId", newJString(merchantId))
  add(query_580353, "pageToken", newJString(pageToken))
  add(query_580353, "fields", newJString(fields))
  add(query_580353, "maxResults", newJInt(maxResults))
  result = call_580351.call(path_580352, query_580353, nil, nil, nil)

var contentDatafeedsList* = Call_ContentDatafeedsList_580337(
    name: "contentDatafeedsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds",
    validator: validate_ContentDatafeedsList_580338, base: "/content/v2",
    url: url_ContentDatafeedsList_580339, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsUpdate_580388 = ref object of OpenApiRestCall_579373
proc url_ContentDatafeedsUpdate_580390(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentDatafeedsUpdate_580389(path: JsonNode; query: JsonNode;
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
  var valid_580391 = path.getOrDefault("merchantId")
  valid_580391 = validateParameter(valid_580391, JString, required = true,
                                 default = nil)
  if valid_580391 != nil:
    section.add "merchantId", valid_580391
  var valid_580392 = path.getOrDefault("datafeedId")
  valid_580392 = validateParameter(valid_580392, JString, required = true,
                                 default = nil)
  if valid_580392 != nil:
    section.add "datafeedId", valid_580392
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580393 = query.getOrDefault("key")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = nil)
  if valid_580393 != nil:
    section.add "key", valid_580393
  var valid_580394 = query.getOrDefault("prettyPrint")
  valid_580394 = validateParameter(valid_580394, JBool, required = false,
                                 default = newJBool(true))
  if valid_580394 != nil:
    section.add "prettyPrint", valid_580394
  var valid_580395 = query.getOrDefault("oauth_token")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = nil)
  if valid_580395 != nil:
    section.add "oauth_token", valid_580395
  var valid_580396 = query.getOrDefault("alt")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = newJString("json"))
  if valid_580396 != nil:
    section.add "alt", valid_580396
  var valid_580397 = query.getOrDefault("userIp")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = nil)
  if valid_580397 != nil:
    section.add "userIp", valid_580397
  var valid_580398 = query.getOrDefault("quotaUser")
  valid_580398 = validateParameter(valid_580398, JString, required = false,
                                 default = nil)
  if valid_580398 != nil:
    section.add "quotaUser", valid_580398
  var valid_580399 = query.getOrDefault("dryRun")
  valid_580399 = validateParameter(valid_580399, JBool, required = false, default = nil)
  if valid_580399 != nil:
    section.add "dryRun", valid_580399
  var valid_580400 = query.getOrDefault("fields")
  valid_580400 = validateParameter(valid_580400, JString, required = false,
                                 default = nil)
  if valid_580400 != nil:
    section.add "fields", valid_580400
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580402: Call_ContentDatafeedsUpdate_580388; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a datafeed configuration of your Merchant Center account.
  ## 
  let valid = call_580402.validator(path, query, header, formData, body)
  let scheme = call_580402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580402.url(scheme.get, call_580402.host, call_580402.base,
                         call_580402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580402, url, valid)

proc call*(call_580403: Call_ContentDatafeedsUpdate_580388; merchantId: string;
          datafeedId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; dryRun: bool = false; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentDatafeedsUpdate
  ## Updates a datafeed configuration of your Merchant Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the datafeed. This account cannot be a multi-client account.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   body: JObject
  ##   datafeedId: string (required)
  ##             : The ID of the datafeed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580404 = newJObject()
  var query_580405 = newJObject()
  var body_580406 = newJObject()
  add(query_580405, "key", newJString(key))
  add(query_580405, "prettyPrint", newJBool(prettyPrint))
  add(query_580405, "oauth_token", newJString(oauthToken))
  add(query_580405, "alt", newJString(alt))
  add(query_580405, "userIp", newJString(userIp))
  add(query_580405, "quotaUser", newJString(quotaUser))
  add(path_580404, "merchantId", newJString(merchantId))
  add(query_580405, "dryRun", newJBool(dryRun))
  if body != nil:
    body_580406 = body
  add(path_580404, "datafeedId", newJString(datafeedId))
  add(query_580405, "fields", newJString(fields))
  result = call_580403.call(path_580404, query_580405, nil, nil, body_580406)

var contentDatafeedsUpdate* = Call_ContentDatafeedsUpdate_580388(
    name: "contentDatafeedsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsUpdate_580389, base: "/content/v2",
    url: url_ContentDatafeedsUpdate_580390, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsGet_580372 = ref object of OpenApiRestCall_579373
proc url_ContentDatafeedsGet_580374(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentDatafeedsGet_580373(path: JsonNode; query: JsonNode;
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
  var valid_580375 = path.getOrDefault("merchantId")
  valid_580375 = validateParameter(valid_580375, JString, required = true,
                                 default = nil)
  if valid_580375 != nil:
    section.add "merchantId", valid_580375
  var valid_580376 = path.getOrDefault("datafeedId")
  valid_580376 = validateParameter(valid_580376, JString, required = true,
                                 default = nil)
  if valid_580376 != nil:
    section.add "datafeedId", valid_580376
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
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
  var valid_580379 = query.getOrDefault("oauth_token")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = nil)
  if valid_580379 != nil:
    section.add "oauth_token", valid_580379
  var valid_580380 = query.getOrDefault("alt")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = newJString("json"))
  if valid_580380 != nil:
    section.add "alt", valid_580380
  var valid_580381 = query.getOrDefault("userIp")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "userIp", valid_580381
  var valid_580382 = query.getOrDefault("quotaUser")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = nil)
  if valid_580382 != nil:
    section.add "quotaUser", valid_580382
  var valid_580383 = query.getOrDefault("fields")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = nil)
  if valid_580383 != nil:
    section.add "fields", valid_580383
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580384: Call_ContentDatafeedsGet_580372; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a datafeed configuration from your Merchant Center account.
  ## 
  let valid = call_580384.validator(path, query, header, formData, body)
  let scheme = call_580384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580384.url(scheme.get, call_580384.host, call_580384.base,
                         call_580384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580384, url, valid)

proc call*(call_580385: Call_ContentDatafeedsGet_580372; merchantId: string;
          datafeedId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## contentDatafeedsGet
  ## Retrieves a datafeed configuration from your Merchant Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the datafeed. This account cannot be a multi-client account.
  ##   datafeedId: string (required)
  ##             : The ID of the datafeed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580386 = newJObject()
  var query_580387 = newJObject()
  add(query_580387, "key", newJString(key))
  add(query_580387, "prettyPrint", newJBool(prettyPrint))
  add(query_580387, "oauth_token", newJString(oauthToken))
  add(query_580387, "alt", newJString(alt))
  add(query_580387, "userIp", newJString(userIp))
  add(query_580387, "quotaUser", newJString(quotaUser))
  add(path_580386, "merchantId", newJString(merchantId))
  add(path_580386, "datafeedId", newJString(datafeedId))
  add(query_580387, "fields", newJString(fields))
  result = call_580385.call(path_580386, query_580387, nil, nil, nil)

var contentDatafeedsGet* = Call_ContentDatafeedsGet_580372(
    name: "contentDatafeedsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsGet_580373, base: "/content/v2",
    url: url_ContentDatafeedsGet_580374, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsDelete_580407 = ref object of OpenApiRestCall_579373
proc url_ContentDatafeedsDelete_580409(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentDatafeedsDelete_580408(path: JsonNode; query: JsonNode;
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
  var valid_580410 = path.getOrDefault("merchantId")
  valid_580410 = validateParameter(valid_580410, JString, required = true,
                                 default = nil)
  if valid_580410 != nil:
    section.add "merchantId", valid_580410
  var valid_580411 = path.getOrDefault("datafeedId")
  valid_580411 = validateParameter(valid_580411, JString, required = true,
                                 default = nil)
  if valid_580411 != nil:
    section.add "datafeedId", valid_580411
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
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
  var valid_580414 = query.getOrDefault("oauth_token")
  valid_580414 = validateParameter(valid_580414, JString, required = false,
                                 default = nil)
  if valid_580414 != nil:
    section.add "oauth_token", valid_580414
  var valid_580415 = query.getOrDefault("alt")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = newJString("json"))
  if valid_580415 != nil:
    section.add "alt", valid_580415
  var valid_580416 = query.getOrDefault("userIp")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = nil)
  if valid_580416 != nil:
    section.add "userIp", valid_580416
  var valid_580417 = query.getOrDefault("quotaUser")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "quotaUser", valid_580417
  var valid_580418 = query.getOrDefault("dryRun")
  valid_580418 = validateParameter(valid_580418, JBool, required = false, default = nil)
  if valid_580418 != nil:
    section.add "dryRun", valid_580418
  var valid_580419 = query.getOrDefault("fields")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = nil)
  if valid_580419 != nil:
    section.add "fields", valid_580419
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580420: Call_ContentDatafeedsDelete_580407; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a datafeed configuration from your Merchant Center account.
  ## 
  let valid = call_580420.validator(path, query, header, formData, body)
  let scheme = call_580420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580420.url(scheme.get, call_580420.host, call_580420.base,
                         call_580420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580420, url, valid)

proc call*(call_580421: Call_ContentDatafeedsDelete_580407; merchantId: string;
          datafeedId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; dryRun: bool = false; fields: string = ""): Recallable =
  ## contentDatafeedsDelete
  ## Deletes a datafeed configuration from your Merchant Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the datafeed. This account cannot be a multi-client account.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   datafeedId: string (required)
  ##             : The ID of the datafeed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580422 = newJObject()
  var query_580423 = newJObject()
  add(query_580423, "key", newJString(key))
  add(query_580423, "prettyPrint", newJBool(prettyPrint))
  add(query_580423, "oauth_token", newJString(oauthToken))
  add(query_580423, "alt", newJString(alt))
  add(query_580423, "userIp", newJString(userIp))
  add(query_580423, "quotaUser", newJString(quotaUser))
  add(path_580422, "merchantId", newJString(merchantId))
  add(query_580423, "dryRun", newJBool(dryRun))
  add(path_580422, "datafeedId", newJString(datafeedId))
  add(query_580423, "fields", newJString(fields))
  result = call_580421.call(path_580422, query_580423, nil, nil, nil)

var contentDatafeedsDelete* = Call_ContentDatafeedsDelete_580407(
    name: "contentDatafeedsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsDelete_580408, base: "/content/v2",
    url: url_ContentDatafeedsDelete_580409, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsFetchnow_580424 = ref object of OpenApiRestCall_579373
proc url_ContentDatafeedsFetchnow_580426(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentDatafeedsFetchnow_580425(path: JsonNode; query: JsonNode;
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
  var valid_580427 = path.getOrDefault("merchantId")
  valid_580427 = validateParameter(valid_580427, JString, required = true,
                                 default = nil)
  if valid_580427 != nil:
    section.add "merchantId", valid_580427
  var valid_580428 = path.getOrDefault("datafeedId")
  valid_580428 = validateParameter(valid_580428, JString, required = true,
                                 default = nil)
  if valid_580428 != nil:
    section.add "datafeedId", valid_580428
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580429 = query.getOrDefault("key")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = nil)
  if valid_580429 != nil:
    section.add "key", valid_580429
  var valid_580430 = query.getOrDefault("prettyPrint")
  valid_580430 = validateParameter(valid_580430, JBool, required = false,
                                 default = newJBool(true))
  if valid_580430 != nil:
    section.add "prettyPrint", valid_580430
  var valid_580431 = query.getOrDefault("oauth_token")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "oauth_token", valid_580431
  var valid_580432 = query.getOrDefault("alt")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = newJString("json"))
  if valid_580432 != nil:
    section.add "alt", valid_580432
  var valid_580433 = query.getOrDefault("userIp")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = nil)
  if valid_580433 != nil:
    section.add "userIp", valid_580433
  var valid_580434 = query.getOrDefault("quotaUser")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = nil)
  if valid_580434 != nil:
    section.add "quotaUser", valid_580434
  var valid_580435 = query.getOrDefault("dryRun")
  valid_580435 = validateParameter(valid_580435, JBool, required = false, default = nil)
  if valid_580435 != nil:
    section.add "dryRun", valid_580435
  var valid_580436 = query.getOrDefault("fields")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "fields", valid_580436
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580437: Call_ContentDatafeedsFetchnow_580424; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Invokes a fetch for the datafeed in your Merchant Center account.
  ## 
  let valid = call_580437.validator(path, query, header, formData, body)
  let scheme = call_580437.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580437.url(scheme.get, call_580437.host, call_580437.base,
                         call_580437.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580437, url, valid)

proc call*(call_580438: Call_ContentDatafeedsFetchnow_580424; merchantId: string;
          datafeedId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; dryRun: bool = false; fields: string = ""): Recallable =
  ## contentDatafeedsFetchnow
  ## Invokes a fetch for the datafeed in your Merchant Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the datafeed. This account cannot be a multi-client account.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   datafeedId: string (required)
  ##             : The ID of the datafeed to be fetched.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580439 = newJObject()
  var query_580440 = newJObject()
  add(query_580440, "key", newJString(key))
  add(query_580440, "prettyPrint", newJBool(prettyPrint))
  add(query_580440, "oauth_token", newJString(oauthToken))
  add(query_580440, "alt", newJString(alt))
  add(query_580440, "userIp", newJString(userIp))
  add(query_580440, "quotaUser", newJString(quotaUser))
  add(path_580439, "merchantId", newJString(merchantId))
  add(query_580440, "dryRun", newJBool(dryRun))
  add(path_580439, "datafeedId", newJString(datafeedId))
  add(query_580440, "fields", newJString(fields))
  result = call_580438.call(path_580439, query_580440, nil, nil, nil)

var contentDatafeedsFetchnow* = Call_ContentDatafeedsFetchnow_580424(
    name: "contentDatafeedsFetchnow", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/datafeeds/{datafeedId}/fetchNow",
    validator: validate_ContentDatafeedsFetchnow_580425, base: "/content/v2",
    url: url_ContentDatafeedsFetchnow_580426, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesList_580441 = ref object of OpenApiRestCall_579373
proc url_ContentDatafeedstatusesList_580443(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentDatafeedstatusesList_580442(path: JsonNode; query: JsonNode;
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
  var valid_580444 = path.getOrDefault("merchantId")
  valid_580444 = validateParameter(valid_580444, JString, required = true,
                                 default = nil)
  if valid_580444 != nil:
    section.add "merchantId", valid_580444
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of products to return in the response, used for paging.
  section = newJObject()
  var valid_580445 = query.getOrDefault("key")
  valid_580445 = validateParameter(valid_580445, JString, required = false,
                                 default = nil)
  if valid_580445 != nil:
    section.add "key", valid_580445
  var valid_580446 = query.getOrDefault("prettyPrint")
  valid_580446 = validateParameter(valid_580446, JBool, required = false,
                                 default = newJBool(true))
  if valid_580446 != nil:
    section.add "prettyPrint", valid_580446
  var valid_580447 = query.getOrDefault("oauth_token")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = nil)
  if valid_580447 != nil:
    section.add "oauth_token", valid_580447
  var valid_580448 = query.getOrDefault("alt")
  valid_580448 = validateParameter(valid_580448, JString, required = false,
                                 default = newJString("json"))
  if valid_580448 != nil:
    section.add "alt", valid_580448
  var valid_580449 = query.getOrDefault("userIp")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "userIp", valid_580449
  var valid_580450 = query.getOrDefault("quotaUser")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = nil)
  if valid_580450 != nil:
    section.add "quotaUser", valid_580450
  var valid_580451 = query.getOrDefault("pageToken")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = nil)
  if valid_580451 != nil:
    section.add "pageToken", valid_580451
  var valid_580452 = query.getOrDefault("fields")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "fields", valid_580452
  var valid_580453 = query.getOrDefault("maxResults")
  valid_580453 = validateParameter(valid_580453, JInt, required = false, default = nil)
  if valid_580453 != nil:
    section.add "maxResults", valid_580453
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580454: Call_ContentDatafeedstatusesList_580441; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the datafeeds in your Merchant Center account.
  ## 
  let valid = call_580454.validator(path, query, header, formData, body)
  let scheme = call_580454.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580454.url(scheme.get, call_580454.host, call_580454.base,
                         call_580454.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580454, url, valid)

proc call*(call_580455: Call_ContentDatafeedstatusesList_580441;
          merchantId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## contentDatafeedstatusesList
  ## Lists the statuses of the datafeeds in your Merchant Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the datafeeds. This account cannot be a multi-client account.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of products to return in the response, used for paging.
  var path_580456 = newJObject()
  var query_580457 = newJObject()
  add(query_580457, "key", newJString(key))
  add(query_580457, "prettyPrint", newJBool(prettyPrint))
  add(query_580457, "oauth_token", newJString(oauthToken))
  add(query_580457, "alt", newJString(alt))
  add(query_580457, "userIp", newJString(userIp))
  add(query_580457, "quotaUser", newJString(quotaUser))
  add(path_580456, "merchantId", newJString(merchantId))
  add(query_580457, "pageToken", newJString(pageToken))
  add(query_580457, "fields", newJString(fields))
  add(query_580457, "maxResults", newJInt(maxResults))
  result = call_580455.call(path_580456, query_580457, nil, nil, nil)

var contentDatafeedstatusesList* = Call_ContentDatafeedstatusesList_580441(
    name: "contentDatafeedstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeedstatuses",
    validator: validate_ContentDatafeedstatusesList_580442, base: "/content/v2",
    url: url_ContentDatafeedstatusesList_580443, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesGet_580458 = ref object of OpenApiRestCall_579373
proc url_ContentDatafeedstatusesGet_580460(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentDatafeedstatusesGet_580459(path: JsonNode; query: JsonNode;
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
  var valid_580461 = path.getOrDefault("merchantId")
  valid_580461 = validateParameter(valid_580461, JString, required = true,
                                 default = nil)
  if valid_580461 != nil:
    section.add "merchantId", valid_580461
  var valid_580462 = path.getOrDefault("datafeedId")
  valid_580462 = validateParameter(valid_580462, JString, required = true,
                                 default = nil)
  if valid_580462 != nil:
    section.add "datafeedId", valid_580462
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   country: JString
  ##          : The country for which to get the datafeed status. If this parameter is provided then language must also be provided. Note that this parameter is required for feeds targeting multiple countries and languages, since a feed may have a different status for each target.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: JString
  ##           : The language for which to get the datafeed status. If this parameter is provided then country must also be provided. Note that this parameter is required for feeds targeting multiple countries and languages, since a feed may have a different status for each target.
  section = newJObject()
  var valid_580463 = query.getOrDefault("key")
  valid_580463 = validateParameter(valid_580463, JString, required = false,
                                 default = nil)
  if valid_580463 != nil:
    section.add "key", valid_580463
  var valid_580464 = query.getOrDefault("prettyPrint")
  valid_580464 = validateParameter(valid_580464, JBool, required = false,
                                 default = newJBool(true))
  if valid_580464 != nil:
    section.add "prettyPrint", valid_580464
  var valid_580465 = query.getOrDefault("oauth_token")
  valid_580465 = validateParameter(valid_580465, JString, required = false,
                                 default = nil)
  if valid_580465 != nil:
    section.add "oauth_token", valid_580465
  var valid_580466 = query.getOrDefault("alt")
  valid_580466 = validateParameter(valid_580466, JString, required = false,
                                 default = newJString("json"))
  if valid_580466 != nil:
    section.add "alt", valid_580466
  var valid_580467 = query.getOrDefault("userIp")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = nil)
  if valid_580467 != nil:
    section.add "userIp", valid_580467
  var valid_580468 = query.getOrDefault("quotaUser")
  valid_580468 = validateParameter(valid_580468, JString, required = false,
                                 default = nil)
  if valid_580468 != nil:
    section.add "quotaUser", valid_580468
  var valid_580469 = query.getOrDefault("country")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = nil)
  if valid_580469 != nil:
    section.add "country", valid_580469
  var valid_580470 = query.getOrDefault("fields")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = nil)
  if valid_580470 != nil:
    section.add "fields", valid_580470
  var valid_580471 = query.getOrDefault("language")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = nil)
  if valid_580471 != nil:
    section.add "language", valid_580471
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580472: Call_ContentDatafeedstatusesGet_580458; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the status of a datafeed from your Merchant Center account.
  ## 
  let valid = call_580472.validator(path, query, header, formData, body)
  let scheme = call_580472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580472.url(scheme.get, call_580472.host, call_580472.base,
                         call_580472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580472, url, valid)

proc call*(call_580473: Call_ContentDatafeedstatusesGet_580458; merchantId: string;
          datafeedId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; country: string = ""; fields: string = "";
          language: string = ""): Recallable =
  ## contentDatafeedstatusesGet
  ## Retrieves the status of a datafeed from your Merchant Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the datafeed. This account cannot be a multi-client account.
  ##   country: string
  ##          : The country for which to get the datafeed status. If this parameter is provided then language must also be provided. Note that this parameter is required for feeds targeting multiple countries and languages, since a feed may have a different status for each target.
  ##   datafeedId: string (required)
  ##             : The ID of the datafeed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: string
  ##           : The language for which to get the datafeed status. If this parameter is provided then country must also be provided. Note that this parameter is required for feeds targeting multiple countries and languages, since a feed may have a different status for each target.
  var path_580474 = newJObject()
  var query_580475 = newJObject()
  add(query_580475, "key", newJString(key))
  add(query_580475, "prettyPrint", newJBool(prettyPrint))
  add(query_580475, "oauth_token", newJString(oauthToken))
  add(query_580475, "alt", newJString(alt))
  add(query_580475, "userIp", newJString(userIp))
  add(query_580475, "quotaUser", newJString(quotaUser))
  add(path_580474, "merchantId", newJString(merchantId))
  add(query_580475, "country", newJString(country))
  add(path_580474, "datafeedId", newJString(datafeedId))
  add(query_580475, "fields", newJString(fields))
  add(query_580475, "language", newJString(language))
  result = call_580473.call(path_580474, query_580475, nil, nil, nil)

var contentDatafeedstatusesGet* = Call_ContentDatafeedstatusesGet_580458(
    name: "contentDatafeedstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/datafeedstatuses/{datafeedId}",
    validator: validate_ContentDatafeedstatusesGet_580459, base: "/content/v2",
    url: url_ContentDatafeedstatusesGet_580460, schemes: {Scheme.Https})
type
  Call_ContentInventorySet_580476 = ref object of OpenApiRestCall_579373
proc url_ContentInventorySet_580478(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentInventorySet_580477(path: JsonNode; query: JsonNode;
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
  var valid_580479 = path.getOrDefault("storeCode")
  valid_580479 = validateParameter(valid_580479, JString, required = true,
                                 default = nil)
  if valid_580479 != nil:
    section.add "storeCode", valid_580479
  var valid_580480 = path.getOrDefault("merchantId")
  valid_580480 = validateParameter(valid_580480, JString, required = true,
                                 default = nil)
  if valid_580480 != nil:
    section.add "merchantId", valid_580480
  var valid_580481 = path.getOrDefault("productId")
  valid_580481 = validateParameter(valid_580481, JString, required = true,
                                 default = nil)
  if valid_580481 != nil:
    section.add "productId", valid_580481
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580482 = query.getOrDefault("key")
  valid_580482 = validateParameter(valid_580482, JString, required = false,
                                 default = nil)
  if valid_580482 != nil:
    section.add "key", valid_580482
  var valid_580483 = query.getOrDefault("prettyPrint")
  valid_580483 = validateParameter(valid_580483, JBool, required = false,
                                 default = newJBool(true))
  if valid_580483 != nil:
    section.add "prettyPrint", valid_580483
  var valid_580484 = query.getOrDefault("oauth_token")
  valid_580484 = validateParameter(valid_580484, JString, required = false,
                                 default = nil)
  if valid_580484 != nil:
    section.add "oauth_token", valid_580484
  var valid_580485 = query.getOrDefault("alt")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = newJString("json"))
  if valid_580485 != nil:
    section.add "alt", valid_580485
  var valid_580486 = query.getOrDefault("userIp")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = nil)
  if valid_580486 != nil:
    section.add "userIp", valid_580486
  var valid_580487 = query.getOrDefault("quotaUser")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = nil)
  if valid_580487 != nil:
    section.add "quotaUser", valid_580487
  var valid_580488 = query.getOrDefault("dryRun")
  valid_580488 = validateParameter(valid_580488, JBool, required = false, default = nil)
  if valid_580488 != nil:
    section.add "dryRun", valid_580488
  var valid_580489 = query.getOrDefault("fields")
  valid_580489 = validateParameter(valid_580489, JString, required = false,
                                 default = nil)
  if valid_580489 != nil:
    section.add "fields", valid_580489
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580491: Call_ContentInventorySet_580476; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates price and availability of a product in your Merchant Center account.
  ## 
  let valid = call_580491.validator(path, query, header, formData, body)
  let scheme = call_580491.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580491.url(scheme.get, call_580491.host, call_580491.base,
                         call_580491.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580491, url, valid)

proc call*(call_580492: Call_ContentInventorySet_580476; storeCode: string;
          merchantId: string; productId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; dryRun: bool = false;
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentInventorySet
  ## Updates price and availability of a product in your Merchant Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   storeCode: string (required)
  ##            : The code of the store for which to update price and availability. Use online to update price and availability of an online product.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that contains the product. This account cannot be a multi-client account.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : The REST ID of the product for which to update price and availability.
  var path_580493 = newJObject()
  var query_580494 = newJObject()
  var body_580495 = newJObject()
  add(query_580494, "key", newJString(key))
  add(query_580494, "prettyPrint", newJBool(prettyPrint))
  add(query_580494, "oauth_token", newJString(oauthToken))
  add(path_580493, "storeCode", newJString(storeCode))
  add(query_580494, "alt", newJString(alt))
  add(query_580494, "userIp", newJString(userIp))
  add(query_580494, "quotaUser", newJString(quotaUser))
  add(path_580493, "merchantId", newJString(merchantId))
  add(query_580494, "dryRun", newJBool(dryRun))
  if body != nil:
    body_580495 = body
  add(query_580494, "fields", newJString(fields))
  add(path_580493, "productId", newJString(productId))
  result = call_580492.call(path_580493, query_580494, nil, nil, body_580495)

var contentInventorySet* = Call_ContentInventorySet_580476(
    name: "contentInventorySet", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/inventory/{storeCode}/products/{productId}",
    validator: validate_ContentInventorySet_580477, base: "/content/v2",
    url: url_ContentInventorySet_580478, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsList_580496 = ref object of OpenApiRestCall_579373
proc url_ContentLiasettingsList_580498(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentLiasettingsList_580497(path: JsonNode; query: JsonNode;
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
  var valid_580499 = path.getOrDefault("merchantId")
  valid_580499 = validateParameter(valid_580499, JString, required = true,
                                 default = nil)
  if valid_580499 != nil:
    section.add "merchantId", valid_580499
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of LIA settings to return in the response, used for paging.
  section = newJObject()
  var valid_580500 = query.getOrDefault("key")
  valid_580500 = validateParameter(valid_580500, JString, required = false,
                                 default = nil)
  if valid_580500 != nil:
    section.add "key", valid_580500
  var valid_580501 = query.getOrDefault("prettyPrint")
  valid_580501 = validateParameter(valid_580501, JBool, required = false,
                                 default = newJBool(true))
  if valid_580501 != nil:
    section.add "prettyPrint", valid_580501
  var valid_580502 = query.getOrDefault("oauth_token")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = nil)
  if valid_580502 != nil:
    section.add "oauth_token", valid_580502
  var valid_580503 = query.getOrDefault("alt")
  valid_580503 = validateParameter(valid_580503, JString, required = false,
                                 default = newJString("json"))
  if valid_580503 != nil:
    section.add "alt", valid_580503
  var valid_580504 = query.getOrDefault("userIp")
  valid_580504 = validateParameter(valid_580504, JString, required = false,
                                 default = nil)
  if valid_580504 != nil:
    section.add "userIp", valid_580504
  var valid_580505 = query.getOrDefault("quotaUser")
  valid_580505 = validateParameter(valid_580505, JString, required = false,
                                 default = nil)
  if valid_580505 != nil:
    section.add "quotaUser", valid_580505
  var valid_580506 = query.getOrDefault("pageToken")
  valid_580506 = validateParameter(valid_580506, JString, required = false,
                                 default = nil)
  if valid_580506 != nil:
    section.add "pageToken", valid_580506
  var valid_580507 = query.getOrDefault("fields")
  valid_580507 = validateParameter(valid_580507, JString, required = false,
                                 default = nil)
  if valid_580507 != nil:
    section.add "fields", valid_580507
  var valid_580508 = query.getOrDefault("maxResults")
  valid_580508 = validateParameter(valid_580508, JInt, required = false, default = nil)
  if valid_580508 != nil:
    section.add "maxResults", valid_580508
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580509: Call_ContentLiasettingsList_580496; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the LIA settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_580509.validator(path, query, header, formData, body)
  let scheme = call_580509.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580509.url(scheme.get, call_580509.host, call_580509.base,
                         call_580509.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580509, url, valid)

proc call*(call_580510: Call_ContentLiasettingsList_580496; merchantId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 0): Recallable =
  ## contentLiasettingsList
  ## Lists the LIA settings of the sub-accounts in your Merchant Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. This must be a multi-client account.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of LIA settings to return in the response, used for paging.
  var path_580511 = newJObject()
  var query_580512 = newJObject()
  add(query_580512, "key", newJString(key))
  add(query_580512, "prettyPrint", newJBool(prettyPrint))
  add(query_580512, "oauth_token", newJString(oauthToken))
  add(query_580512, "alt", newJString(alt))
  add(query_580512, "userIp", newJString(userIp))
  add(query_580512, "quotaUser", newJString(quotaUser))
  add(path_580511, "merchantId", newJString(merchantId))
  add(query_580512, "pageToken", newJString(pageToken))
  add(query_580512, "fields", newJString(fields))
  add(query_580512, "maxResults", newJInt(maxResults))
  result = call_580510.call(path_580511, query_580512, nil, nil, nil)

var contentLiasettingsList* = Call_ContentLiasettingsList_580496(
    name: "contentLiasettingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings",
    validator: validate_ContentLiasettingsList_580497, base: "/content/v2",
    url: url_ContentLiasettingsList_580498, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsUpdate_580529 = ref object of OpenApiRestCall_579373
proc url_ContentLiasettingsUpdate_580531(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentLiasettingsUpdate_580530(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the LIA settings of the account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   accountId: JString (required)
  ##            : The ID of the account for which to get or update LIA settings.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580532 = path.getOrDefault("merchantId")
  valid_580532 = validateParameter(valid_580532, JString, required = true,
                                 default = nil)
  if valid_580532 != nil:
    section.add "merchantId", valid_580532
  var valid_580533 = path.getOrDefault("accountId")
  valid_580533 = validateParameter(valid_580533, JString, required = true,
                                 default = nil)
  if valid_580533 != nil:
    section.add "accountId", valid_580533
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580534 = query.getOrDefault("key")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = nil)
  if valid_580534 != nil:
    section.add "key", valid_580534
  var valid_580535 = query.getOrDefault("prettyPrint")
  valid_580535 = validateParameter(valid_580535, JBool, required = false,
                                 default = newJBool(true))
  if valid_580535 != nil:
    section.add "prettyPrint", valid_580535
  var valid_580536 = query.getOrDefault("oauth_token")
  valid_580536 = validateParameter(valid_580536, JString, required = false,
                                 default = nil)
  if valid_580536 != nil:
    section.add "oauth_token", valid_580536
  var valid_580537 = query.getOrDefault("alt")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = newJString("json"))
  if valid_580537 != nil:
    section.add "alt", valid_580537
  var valid_580538 = query.getOrDefault("userIp")
  valid_580538 = validateParameter(valid_580538, JString, required = false,
                                 default = nil)
  if valid_580538 != nil:
    section.add "userIp", valid_580538
  var valid_580539 = query.getOrDefault("quotaUser")
  valid_580539 = validateParameter(valid_580539, JString, required = false,
                                 default = nil)
  if valid_580539 != nil:
    section.add "quotaUser", valid_580539
  var valid_580540 = query.getOrDefault("dryRun")
  valid_580540 = validateParameter(valid_580540, JBool, required = false, default = nil)
  if valid_580540 != nil:
    section.add "dryRun", valid_580540
  var valid_580541 = query.getOrDefault("fields")
  valid_580541 = validateParameter(valid_580541, JString, required = false,
                                 default = nil)
  if valid_580541 != nil:
    section.add "fields", valid_580541
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580543: Call_ContentLiasettingsUpdate_580529; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the LIA settings of the account.
  ## 
  let valid = call_580543.validator(path, query, header, formData, body)
  let scheme = call_580543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580543.url(scheme.get, call_580543.host, call_580543.base,
                         call_580543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580543, url, valid)

proc call*(call_580544: Call_ContentLiasettingsUpdate_580529; merchantId: string;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; dryRun: bool = false; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentLiasettingsUpdate
  ## Updates the LIA settings of the account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The ID of the account for which to get or update LIA settings.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580545 = newJObject()
  var query_580546 = newJObject()
  var body_580547 = newJObject()
  add(query_580546, "key", newJString(key))
  add(query_580546, "prettyPrint", newJBool(prettyPrint))
  add(query_580546, "oauth_token", newJString(oauthToken))
  add(query_580546, "alt", newJString(alt))
  add(query_580546, "userIp", newJString(userIp))
  add(query_580546, "quotaUser", newJString(quotaUser))
  add(path_580545, "merchantId", newJString(merchantId))
  add(query_580546, "dryRun", newJBool(dryRun))
  if body != nil:
    body_580547 = body
  add(path_580545, "accountId", newJString(accountId))
  add(query_580546, "fields", newJString(fields))
  result = call_580544.call(path_580545, query_580546, nil, nil, body_580547)

var contentLiasettingsUpdate* = Call_ContentLiasettingsUpdate_580529(
    name: "contentLiasettingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}",
    validator: validate_ContentLiasettingsUpdate_580530, base: "/content/v2",
    url: url_ContentLiasettingsUpdate_580531, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsGet_580513 = ref object of OpenApiRestCall_579373
proc url_ContentLiasettingsGet_580515(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentLiasettingsGet_580514(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the LIA settings of the account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   accountId: JString (required)
  ##            : The ID of the account for which to get or update LIA settings.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580516 = path.getOrDefault("merchantId")
  valid_580516 = validateParameter(valid_580516, JString, required = true,
                                 default = nil)
  if valid_580516 != nil:
    section.add "merchantId", valid_580516
  var valid_580517 = path.getOrDefault("accountId")
  valid_580517 = validateParameter(valid_580517, JString, required = true,
                                 default = nil)
  if valid_580517 != nil:
    section.add "accountId", valid_580517
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580518 = query.getOrDefault("key")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = nil)
  if valid_580518 != nil:
    section.add "key", valid_580518
  var valid_580519 = query.getOrDefault("prettyPrint")
  valid_580519 = validateParameter(valid_580519, JBool, required = false,
                                 default = newJBool(true))
  if valid_580519 != nil:
    section.add "prettyPrint", valid_580519
  var valid_580520 = query.getOrDefault("oauth_token")
  valid_580520 = validateParameter(valid_580520, JString, required = false,
                                 default = nil)
  if valid_580520 != nil:
    section.add "oauth_token", valid_580520
  var valid_580521 = query.getOrDefault("alt")
  valid_580521 = validateParameter(valid_580521, JString, required = false,
                                 default = newJString("json"))
  if valid_580521 != nil:
    section.add "alt", valid_580521
  var valid_580522 = query.getOrDefault("userIp")
  valid_580522 = validateParameter(valid_580522, JString, required = false,
                                 default = nil)
  if valid_580522 != nil:
    section.add "userIp", valid_580522
  var valid_580523 = query.getOrDefault("quotaUser")
  valid_580523 = validateParameter(valid_580523, JString, required = false,
                                 default = nil)
  if valid_580523 != nil:
    section.add "quotaUser", valid_580523
  var valid_580524 = query.getOrDefault("fields")
  valid_580524 = validateParameter(valid_580524, JString, required = false,
                                 default = nil)
  if valid_580524 != nil:
    section.add "fields", valid_580524
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580525: Call_ContentLiasettingsGet_580513; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the LIA settings of the account.
  ## 
  let valid = call_580525.validator(path, query, header, formData, body)
  let scheme = call_580525.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580525.url(scheme.get, call_580525.host, call_580525.base,
                         call_580525.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580525, url, valid)

proc call*(call_580526: Call_ContentLiasettingsGet_580513; merchantId: string;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## contentLiasettingsGet
  ## Retrieves the LIA settings of the account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   accountId: string (required)
  ##            : The ID of the account for which to get or update LIA settings.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580527 = newJObject()
  var query_580528 = newJObject()
  add(query_580528, "key", newJString(key))
  add(query_580528, "prettyPrint", newJBool(prettyPrint))
  add(query_580528, "oauth_token", newJString(oauthToken))
  add(query_580528, "alt", newJString(alt))
  add(query_580528, "userIp", newJString(userIp))
  add(query_580528, "quotaUser", newJString(quotaUser))
  add(path_580527, "merchantId", newJString(merchantId))
  add(path_580527, "accountId", newJString(accountId))
  add(query_580528, "fields", newJString(fields))
  result = call_580526.call(path_580527, query_580528, nil, nil, nil)

var contentLiasettingsGet* = Call_ContentLiasettingsGet_580513(
    name: "contentLiasettingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}",
    validator: validate_ContentLiasettingsGet_580514, base: "/content/v2",
    url: url_ContentLiasettingsGet_580515, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsGetaccessiblegmbaccounts_580548 = ref object of OpenApiRestCall_579373
proc url_ContentLiasettingsGetaccessiblegmbaccounts_580550(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentLiasettingsGetaccessiblegmbaccounts_580549(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of accessible Google My Business accounts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   accountId: JString (required)
  ##            : The ID of the account for which to retrieve accessible Google My Business accounts.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580551 = path.getOrDefault("merchantId")
  valid_580551 = validateParameter(valid_580551, JString, required = true,
                                 default = nil)
  if valid_580551 != nil:
    section.add "merchantId", valid_580551
  var valid_580552 = path.getOrDefault("accountId")
  valid_580552 = validateParameter(valid_580552, JString, required = true,
                                 default = nil)
  if valid_580552 != nil:
    section.add "accountId", valid_580552
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580553 = query.getOrDefault("key")
  valid_580553 = validateParameter(valid_580553, JString, required = false,
                                 default = nil)
  if valid_580553 != nil:
    section.add "key", valid_580553
  var valid_580554 = query.getOrDefault("prettyPrint")
  valid_580554 = validateParameter(valid_580554, JBool, required = false,
                                 default = newJBool(true))
  if valid_580554 != nil:
    section.add "prettyPrint", valid_580554
  var valid_580555 = query.getOrDefault("oauth_token")
  valid_580555 = validateParameter(valid_580555, JString, required = false,
                                 default = nil)
  if valid_580555 != nil:
    section.add "oauth_token", valid_580555
  var valid_580556 = query.getOrDefault("alt")
  valid_580556 = validateParameter(valid_580556, JString, required = false,
                                 default = newJString("json"))
  if valid_580556 != nil:
    section.add "alt", valid_580556
  var valid_580557 = query.getOrDefault("userIp")
  valid_580557 = validateParameter(valid_580557, JString, required = false,
                                 default = nil)
  if valid_580557 != nil:
    section.add "userIp", valid_580557
  var valid_580558 = query.getOrDefault("quotaUser")
  valid_580558 = validateParameter(valid_580558, JString, required = false,
                                 default = nil)
  if valid_580558 != nil:
    section.add "quotaUser", valid_580558
  var valid_580559 = query.getOrDefault("fields")
  valid_580559 = validateParameter(valid_580559, JString, required = false,
                                 default = nil)
  if valid_580559 != nil:
    section.add "fields", valid_580559
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580560: Call_ContentLiasettingsGetaccessiblegmbaccounts_580548;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of accessible Google My Business accounts.
  ## 
  let valid = call_580560.validator(path, query, header, formData, body)
  let scheme = call_580560.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580560.url(scheme.get, call_580560.host, call_580560.base,
                         call_580560.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580560, url, valid)

proc call*(call_580561: Call_ContentLiasettingsGetaccessiblegmbaccounts_580548;
          merchantId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## contentLiasettingsGetaccessiblegmbaccounts
  ## Retrieves the list of accessible Google My Business accounts.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   accountId: string (required)
  ##            : The ID of the account for which to retrieve accessible Google My Business accounts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580562 = newJObject()
  var query_580563 = newJObject()
  add(query_580563, "key", newJString(key))
  add(query_580563, "prettyPrint", newJBool(prettyPrint))
  add(query_580563, "oauth_token", newJString(oauthToken))
  add(query_580563, "alt", newJString(alt))
  add(query_580563, "userIp", newJString(userIp))
  add(query_580563, "quotaUser", newJString(quotaUser))
  add(path_580562, "merchantId", newJString(merchantId))
  add(path_580562, "accountId", newJString(accountId))
  add(query_580563, "fields", newJString(fields))
  result = call_580561.call(path_580562, query_580563, nil, nil, nil)

var contentLiasettingsGetaccessiblegmbaccounts* = Call_ContentLiasettingsGetaccessiblegmbaccounts_580548(
    name: "contentLiasettingsGetaccessiblegmbaccounts", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/accessiblegmbaccounts",
    validator: validate_ContentLiasettingsGetaccessiblegmbaccounts_580549,
    base: "/content/v2", url: url_ContentLiasettingsGetaccessiblegmbaccounts_580550,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsRequestgmbaccess_580564 = ref object of OpenApiRestCall_579373
proc url_ContentLiasettingsRequestgmbaccess_580566(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentLiasettingsRequestgmbaccess_580565(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Requests access to a specified Google My Business account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   accountId: JString (required)
  ##            : The ID of the account for which GMB access is requested.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580567 = path.getOrDefault("merchantId")
  valid_580567 = validateParameter(valid_580567, JString, required = true,
                                 default = nil)
  if valid_580567 != nil:
    section.add "merchantId", valid_580567
  var valid_580568 = path.getOrDefault("accountId")
  valid_580568 = validateParameter(valid_580568, JString, required = true,
                                 default = nil)
  if valid_580568 != nil:
    section.add "accountId", valid_580568
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   gmbEmail: JString (required)
  ##           : The email of the Google My Business account.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580569 = query.getOrDefault("key")
  valid_580569 = validateParameter(valid_580569, JString, required = false,
                                 default = nil)
  if valid_580569 != nil:
    section.add "key", valid_580569
  var valid_580570 = query.getOrDefault("prettyPrint")
  valid_580570 = validateParameter(valid_580570, JBool, required = false,
                                 default = newJBool(true))
  if valid_580570 != nil:
    section.add "prettyPrint", valid_580570
  var valid_580571 = query.getOrDefault("oauth_token")
  valid_580571 = validateParameter(valid_580571, JString, required = false,
                                 default = nil)
  if valid_580571 != nil:
    section.add "oauth_token", valid_580571
  assert query != nil,
        "query argument is necessary due to required `gmbEmail` field"
  var valid_580572 = query.getOrDefault("gmbEmail")
  valid_580572 = validateParameter(valid_580572, JString, required = true,
                                 default = nil)
  if valid_580572 != nil:
    section.add "gmbEmail", valid_580572
  var valid_580573 = query.getOrDefault("alt")
  valid_580573 = validateParameter(valid_580573, JString, required = false,
                                 default = newJString("json"))
  if valid_580573 != nil:
    section.add "alt", valid_580573
  var valid_580574 = query.getOrDefault("userIp")
  valid_580574 = validateParameter(valid_580574, JString, required = false,
                                 default = nil)
  if valid_580574 != nil:
    section.add "userIp", valid_580574
  var valid_580575 = query.getOrDefault("quotaUser")
  valid_580575 = validateParameter(valid_580575, JString, required = false,
                                 default = nil)
  if valid_580575 != nil:
    section.add "quotaUser", valid_580575
  var valid_580576 = query.getOrDefault("fields")
  valid_580576 = validateParameter(valid_580576, JString, required = false,
                                 default = nil)
  if valid_580576 != nil:
    section.add "fields", valid_580576
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580577: Call_ContentLiasettingsRequestgmbaccess_580564;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests access to a specified Google My Business account.
  ## 
  let valid = call_580577.validator(path, query, header, formData, body)
  let scheme = call_580577.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580577.url(scheme.get, call_580577.host, call_580577.base,
                         call_580577.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580577, url, valid)

proc call*(call_580578: Call_ContentLiasettingsRequestgmbaccess_580564;
          gmbEmail: string; merchantId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## contentLiasettingsRequestgmbaccess
  ## Requests access to a specified Google My Business account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   gmbEmail: string (required)
  ##           : The email of the Google My Business account.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   accountId: string (required)
  ##            : The ID of the account for which GMB access is requested.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580579 = newJObject()
  var query_580580 = newJObject()
  add(query_580580, "key", newJString(key))
  add(query_580580, "prettyPrint", newJBool(prettyPrint))
  add(query_580580, "oauth_token", newJString(oauthToken))
  add(query_580580, "gmbEmail", newJString(gmbEmail))
  add(query_580580, "alt", newJString(alt))
  add(query_580580, "userIp", newJString(userIp))
  add(query_580580, "quotaUser", newJString(quotaUser))
  add(path_580579, "merchantId", newJString(merchantId))
  add(path_580579, "accountId", newJString(accountId))
  add(query_580580, "fields", newJString(fields))
  result = call_580578.call(path_580579, query_580580, nil, nil, nil)

var contentLiasettingsRequestgmbaccess* = Call_ContentLiasettingsRequestgmbaccess_580564(
    name: "contentLiasettingsRequestgmbaccess", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/requestgmbaccess",
    validator: validate_ContentLiasettingsRequestgmbaccess_580565,
    base: "/content/v2", url: url_ContentLiasettingsRequestgmbaccess_580566,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsRequestinventoryverification_580581 = ref object of OpenApiRestCall_579373
proc url_ContentLiasettingsRequestinventoryverification_580583(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentLiasettingsRequestinventoryverification_580582(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Requests inventory validation for the specified country.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   country: JString (required)
  ##          : The country for which inventory validation is requested.
  ##   accountId: JString (required)
  ##            : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580584 = path.getOrDefault("merchantId")
  valid_580584 = validateParameter(valid_580584, JString, required = true,
                                 default = nil)
  if valid_580584 != nil:
    section.add "merchantId", valid_580584
  var valid_580585 = path.getOrDefault("country")
  valid_580585 = validateParameter(valid_580585, JString, required = true,
                                 default = nil)
  if valid_580585 != nil:
    section.add "country", valid_580585
  var valid_580586 = path.getOrDefault("accountId")
  valid_580586 = validateParameter(valid_580586, JString, required = true,
                                 default = nil)
  if valid_580586 != nil:
    section.add "accountId", valid_580586
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580587 = query.getOrDefault("key")
  valid_580587 = validateParameter(valid_580587, JString, required = false,
                                 default = nil)
  if valid_580587 != nil:
    section.add "key", valid_580587
  var valid_580588 = query.getOrDefault("prettyPrint")
  valid_580588 = validateParameter(valid_580588, JBool, required = false,
                                 default = newJBool(true))
  if valid_580588 != nil:
    section.add "prettyPrint", valid_580588
  var valid_580589 = query.getOrDefault("oauth_token")
  valid_580589 = validateParameter(valid_580589, JString, required = false,
                                 default = nil)
  if valid_580589 != nil:
    section.add "oauth_token", valid_580589
  var valid_580590 = query.getOrDefault("alt")
  valid_580590 = validateParameter(valid_580590, JString, required = false,
                                 default = newJString("json"))
  if valid_580590 != nil:
    section.add "alt", valid_580590
  var valid_580591 = query.getOrDefault("userIp")
  valid_580591 = validateParameter(valid_580591, JString, required = false,
                                 default = nil)
  if valid_580591 != nil:
    section.add "userIp", valid_580591
  var valid_580592 = query.getOrDefault("quotaUser")
  valid_580592 = validateParameter(valid_580592, JString, required = false,
                                 default = nil)
  if valid_580592 != nil:
    section.add "quotaUser", valid_580592
  var valid_580593 = query.getOrDefault("fields")
  valid_580593 = validateParameter(valid_580593, JString, required = false,
                                 default = nil)
  if valid_580593 != nil:
    section.add "fields", valid_580593
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580594: Call_ContentLiasettingsRequestinventoryverification_580581;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests inventory validation for the specified country.
  ## 
  let valid = call_580594.validator(path, query, header, formData, body)
  let scheme = call_580594.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580594.url(scheme.get, call_580594.host, call_580594.base,
                         call_580594.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580594, url, valid)

proc call*(call_580595: Call_ContentLiasettingsRequestinventoryverification_580581;
          merchantId: string; country: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## contentLiasettingsRequestinventoryverification
  ## Requests inventory validation for the specified country.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   country: string (required)
  ##          : The country for which inventory validation is requested.
  ##   accountId: string (required)
  ##            : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580596 = newJObject()
  var query_580597 = newJObject()
  add(query_580597, "key", newJString(key))
  add(query_580597, "prettyPrint", newJBool(prettyPrint))
  add(query_580597, "oauth_token", newJString(oauthToken))
  add(query_580597, "alt", newJString(alt))
  add(query_580597, "userIp", newJString(userIp))
  add(query_580597, "quotaUser", newJString(quotaUser))
  add(path_580596, "merchantId", newJString(merchantId))
  add(path_580596, "country", newJString(country))
  add(path_580596, "accountId", newJString(accountId))
  add(query_580597, "fields", newJString(fields))
  result = call_580595.call(path_580596, query_580597, nil, nil, nil)

var contentLiasettingsRequestinventoryverification* = Call_ContentLiasettingsRequestinventoryverification_580581(
    name: "contentLiasettingsRequestinventoryverification",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}/requestinventoryverification/{country}",
    validator: validate_ContentLiasettingsRequestinventoryverification_580582,
    base: "/content/v2", url: url_ContentLiasettingsRequestinventoryverification_580583,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsSetinventoryverificationcontact_580598 = ref object of OpenApiRestCall_579373
proc url_ContentLiasettingsSetinventoryverificationcontact_580600(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentLiasettingsSetinventoryverificationcontact_580599(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the inventory verification contract for the specified country.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   accountId: JString (required)
  ##            : The ID of the account that manages the order. This cannot be a multi-client account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580601 = path.getOrDefault("merchantId")
  valid_580601 = validateParameter(valid_580601, JString, required = true,
                                 default = nil)
  if valid_580601 != nil:
    section.add "merchantId", valid_580601
  var valid_580602 = path.getOrDefault("accountId")
  valid_580602 = validateParameter(valid_580602, JString, required = true,
                                 default = nil)
  if valid_580602 != nil:
    section.add "accountId", valid_580602
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   contactEmail: JString (required)
  ##               : The email of the inventory verification contact.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   contactName: JString (required)
  ##              : The name of the inventory verification contact.
  ##   country: JString (required)
  ##          : The country for which inventory verification is requested.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: JString (required)
  ##           : The language for which inventory verification is requested.
  section = newJObject()
  var valid_580603 = query.getOrDefault("key")
  valid_580603 = validateParameter(valid_580603, JString, required = false,
                                 default = nil)
  if valid_580603 != nil:
    section.add "key", valid_580603
  var valid_580604 = query.getOrDefault("prettyPrint")
  valid_580604 = validateParameter(valid_580604, JBool, required = false,
                                 default = newJBool(true))
  if valid_580604 != nil:
    section.add "prettyPrint", valid_580604
  var valid_580605 = query.getOrDefault("oauth_token")
  valid_580605 = validateParameter(valid_580605, JString, required = false,
                                 default = nil)
  if valid_580605 != nil:
    section.add "oauth_token", valid_580605
  assert query != nil,
        "query argument is necessary due to required `contactEmail` field"
  var valid_580606 = query.getOrDefault("contactEmail")
  valid_580606 = validateParameter(valid_580606, JString, required = true,
                                 default = nil)
  if valid_580606 != nil:
    section.add "contactEmail", valid_580606
  var valid_580607 = query.getOrDefault("alt")
  valid_580607 = validateParameter(valid_580607, JString, required = false,
                                 default = newJString("json"))
  if valid_580607 != nil:
    section.add "alt", valid_580607
  var valid_580608 = query.getOrDefault("userIp")
  valid_580608 = validateParameter(valid_580608, JString, required = false,
                                 default = nil)
  if valid_580608 != nil:
    section.add "userIp", valid_580608
  var valid_580609 = query.getOrDefault("quotaUser")
  valid_580609 = validateParameter(valid_580609, JString, required = false,
                                 default = nil)
  if valid_580609 != nil:
    section.add "quotaUser", valid_580609
  var valid_580610 = query.getOrDefault("contactName")
  valid_580610 = validateParameter(valid_580610, JString, required = true,
                                 default = nil)
  if valid_580610 != nil:
    section.add "contactName", valid_580610
  var valid_580611 = query.getOrDefault("country")
  valid_580611 = validateParameter(valid_580611, JString, required = true,
                                 default = nil)
  if valid_580611 != nil:
    section.add "country", valid_580611
  var valid_580612 = query.getOrDefault("fields")
  valid_580612 = validateParameter(valid_580612, JString, required = false,
                                 default = nil)
  if valid_580612 != nil:
    section.add "fields", valid_580612
  var valid_580613 = query.getOrDefault("language")
  valid_580613 = validateParameter(valid_580613, JString, required = true,
                                 default = nil)
  if valid_580613 != nil:
    section.add "language", valid_580613
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580614: Call_ContentLiasettingsSetinventoryverificationcontact_580598;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the inventory verification contract for the specified country.
  ## 
  let valid = call_580614.validator(path, query, header, formData, body)
  let scheme = call_580614.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580614.url(scheme.get, call_580614.host, call_580614.base,
                         call_580614.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580614, url, valid)

proc call*(call_580615: Call_ContentLiasettingsSetinventoryverificationcontact_580598;
          contactEmail: string; merchantId: string; contactName: string;
          country: string; accountId: string; language: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## contentLiasettingsSetinventoryverificationcontact
  ## Sets the inventory verification contract for the specified country.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   contactEmail: string (required)
  ##               : The email of the inventory verification contact.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   contactName: string (required)
  ##              : The name of the inventory verification contact.
  ##   country: string (required)
  ##          : The country for which inventory verification is requested.
  ##   accountId: string (required)
  ##            : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: string (required)
  ##           : The language for which inventory verification is requested.
  var path_580616 = newJObject()
  var query_580617 = newJObject()
  add(query_580617, "key", newJString(key))
  add(query_580617, "prettyPrint", newJBool(prettyPrint))
  add(query_580617, "oauth_token", newJString(oauthToken))
  add(query_580617, "contactEmail", newJString(contactEmail))
  add(query_580617, "alt", newJString(alt))
  add(query_580617, "userIp", newJString(userIp))
  add(query_580617, "quotaUser", newJString(quotaUser))
  add(path_580616, "merchantId", newJString(merchantId))
  add(query_580617, "contactName", newJString(contactName))
  add(query_580617, "country", newJString(country))
  add(path_580616, "accountId", newJString(accountId))
  add(query_580617, "fields", newJString(fields))
  add(query_580617, "language", newJString(language))
  result = call_580615.call(path_580616, query_580617, nil, nil, nil)

var contentLiasettingsSetinventoryverificationcontact* = Call_ContentLiasettingsSetinventoryverificationcontact_580598(
    name: "contentLiasettingsSetinventoryverificationcontact",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}/setinventoryverificationcontact",
    validator: validate_ContentLiasettingsSetinventoryverificationcontact_580599,
    base: "/content/v2",
    url: url_ContentLiasettingsSetinventoryverificationcontact_580600,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsSetposdataprovider_580618 = ref object of OpenApiRestCall_579373
proc url_ContentLiasettingsSetposdataprovider_580620(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentLiasettingsSetposdataprovider_580619(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the POS data provider for the specified country.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   accountId: JString (required)
  ##            : The ID of the account for which to retrieve accessible Google My Business accounts.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580621 = path.getOrDefault("merchantId")
  valid_580621 = validateParameter(valid_580621, JString, required = true,
                                 default = nil)
  if valid_580621 != nil:
    section.add "merchantId", valid_580621
  var valid_580622 = path.getOrDefault("accountId")
  valid_580622 = validateParameter(valid_580622, JString, required = true,
                                 default = nil)
  if valid_580622 != nil:
    section.add "accountId", valid_580622
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   posDataProviderId: JString
  ##                    : The ID of POS data provider.
  ##   country: JString (required)
  ##          : The country for which the POS data provider is selected.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   posExternalAccountId: JString
  ##                       : The account ID by which this merchant is known to the POS data provider.
  section = newJObject()
  var valid_580623 = query.getOrDefault("key")
  valid_580623 = validateParameter(valid_580623, JString, required = false,
                                 default = nil)
  if valid_580623 != nil:
    section.add "key", valid_580623
  var valid_580624 = query.getOrDefault("prettyPrint")
  valid_580624 = validateParameter(valid_580624, JBool, required = false,
                                 default = newJBool(true))
  if valid_580624 != nil:
    section.add "prettyPrint", valid_580624
  var valid_580625 = query.getOrDefault("oauth_token")
  valid_580625 = validateParameter(valid_580625, JString, required = false,
                                 default = nil)
  if valid_580625 != nil:
    section.add "oauth_token", valid_580625
  var valid_580626 = query.getOrDefault("alt")
  valid_580626 = validateParameter(valid_580626, JString, required = false,
                                 default = newJString("json"))
  if valid_580626 != nil:
    section.add "alt", valid_580626
  var valid_580627 = query.getOrDefault("userIp")
  valid_580627 = validateParameter(valid_580627, JString, required = false,
                                 default = nil)
  if valid_580627 != nil:
    section.add "userIp", valid_580627
  var valid_580628 = query.getOrDefault("quotaUser")
  valid_580628 = validateParameter(valid_580628, JString, required = false,
                                 default = nil)
  if valid_580628 != nil:
    section.add "quotaUser", valid_580628
  var valid_580629 = query.getOrDefault("posDataProviderId")
  valid_580629 = validateParameter(valid_580629, JString, required = false,
                                 default = nil)
  if valid_580629 != nil:
    section.add "posDataProviderId", valid_580629
  assert query != nil, "query argument is necessary due to required `country` field"
  var valid_580630 = query.getOrDefault("country")
  valid_580630 = validateParameter(valid_580630, JString, required = true,
                                 default = nil)
  if valid_580630 != nil:
    section.add "country", valid_580630
  var valid_580631 = query.getOrDefault("fields")
  valid_580631 = validateParameter(valid_580631, JString, required = false,
                                 default = nil)
  if valid_580631 != nil:
    section.add "fields", valid_580631
  var valid_580632 = query.getOrDefault("posExternalAccountId")
  valid_580632 = validateParameter(valid_580632, JString, required = false,
                                 default = nil)
  if valid_580632 != nil:
    section.add "posExternalAccountId", valid_580632
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580633: Call_ContentLiasettingsSetposdataprovider_580618;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the POS data provider for the specified country.
  ## 
  let valid = call_580633.validator(path, query, header, formData, body)
  let scheme = call_580633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580633.url(scheme.get, call_580633.host, call_580633.base,
                         call_580633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580633, url, valid)

proc call*(call_580634: Call_ContentLiasettingsSetposdataprovider_580618;
          merchantId: string; country: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; posDataProviderId: string = "";
          fields: string = ""; posExternalAccountId: string = ""): Recallable =
  ## contentLiasettingsSetposdataprovider
  ## Sets the POS data provider for the specified country.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   posDataProviderId: string
  ##                    : The ID of POS data provider.
  ##   country: string (required)
  ##          : The country for which the POS data provider is selected.
  ##   accountId: string (required)
  ##            : The ID of the account for which to retrieve accessible Google My Business accounts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   posExternalAccountId: string
  ##                       : The account ID by which this merchant is known to the POS data provider.
  var path_580635 = newJObject()
  var query_580636 = newJObject()
  add(query_580636, "key", newJString(key))
  add(query_580636, "prettyPrint", newJBool(prettyPrint))
  add(query_580636, "oauth_token", newJString(oauthToken))
  add(query_580636, "alt", newJString(alt))
  add(query_580636, "userIp", newJString(userIp))
  add(query_580636, "quotaUser", newJString(quotaUser))
  add(path_580635, "merchantId", newJString(merchantId))
  add(query_580636, "posDataProviderId", newJString(posDataProviderId))
  add(query_580636, "country", newJString(country))
  add(path_580635, "accountId", newJString(accountId))
  add(query_580636, "fields", newJString(fields))
  add(query_580636, "posExternalAccountId", newJString(posExternalAccountId))
  result = call_580634.call(path_580635, query_580636, nil, nil, nil)

var contentLiasettingsSetposdataprovider* = Call_ContentLiasettingsSetposdataprovider_580618(
    name: "contentLiasettingsSetposdataprovider", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/setposdataprovider",
    validator: validate_ContentLiasettingsSetposdataprovider_580619,
    base: "/content/v2", url: url_ContentLiasettingsSetposdataprovider_580620,
    schemes: {Scheme.Https})
type
  Call_ContentOrderinvoicesCreatechargeinvoice_580637 = ref object of OpenApiRestCall_579373
proc url_ContentOrderinvoicesCreatechargeinvoice_580639(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentOrderinvoicesCreatechargeinvoice_580638(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a charge invoice for a shipment group, and triggers a charge capture for orderinvoice enabled orders.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580640 = path.getOrDefault("merchantId")
  valid_580640 = validateParameter(valid_580640, JString, required = true,
                                 default = nil)
  if valid_580640 != nil:
    section.add "merchantId", valid_580640
  var valid_580641 = path.getOrDefault("orderId")
  valid_580641 = validateParameter(valid_580641, JString, required = true,
                                 default = nil)
  if valid_580641 != nil:
    section.add "orderId", valid_580641
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580642 = query.getOrDefault("key")
  valid_580642 = validateParameter(valid_580642, JString, required = false,
                                 default = nil)
  if valid_580642 != nil:
    section.add "key", valid_580642
  var valid_580643 = query.getOrDefault("prettyPrint")
  valid_580643 = validateParameter(valid_580643, JBool, required = false,
                                 default = newJBool(true))
  if valid_580643 != nil:
    section.add "prettyPrint", valid_580643
  var valid_580644 = query.getOrDefault("oauth_token")
  valid_580644 = validateParameter(valid_580644, JString, required = false,
                                 default = nil)
  if valid_580644 != nil:
    section.add "oauth_token", valid_580644
  var valid_580645 = query.getOrDefault("alt")
  valid_580645 = validateParameter(valid_580645, JString, required = false,
                                 default = newJString("json"))
  if valid_580645 != nil:
    section.add "alt", valid_580645
  var valid_580646 = query.getOrDefault("userIp")
  valid_580646 = validateParameter(valid_580646, JString, required = false,
                                 default = nil)
  if valid_580646 != nil:
    section.add "userIp", valid_580646
  var valid_580647 = query.getOrDefault("quotaUser")
  valid_580647 = validateParameter(valid_580647, JString, required = false,
                                 default = nil)
  if valid_580647 != nil:
    section.add "quotaUser", valid_580647
  var valid_580648 = query.getOrDefault("fields")
  valid_580648 = validateParameter(valid_580648, JString, required = false,
                                 default = nil)
  if valid_580648 != nil:
    section.add "fields", valid_580648
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580650: Call_ContentOrderinvoicesCreatechargeinvoice_580637;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a charge invoice for a shipment group, and triggers a charge capture for orderinvoice enabled orders.
  ## 
  let valid = call_580650.validator(path, query, header, formData, body)
  let scheme = call_580650.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580650.url(scheme.get, call_580650.host, call_580650.base,
                         call_580650.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580650, url, valid)

proc call*(call_580651: Call_ContentOrderinvoicesCreatechargeinvoice_580637;
          merchantId: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentOrderinvoicesCreatechargeinvoice
  ## Creates a charge invoice for a shipment group, and triggers a charge capture for orderinvoice enabled orders.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order.
  var path_580652 = newJObject()
  var query_580653 = newJObject()
  var body_580654 = newJObject()
  add(query_580653, "key", newJString(key))
  add(query_580653, "prettyPrint", newJBool(prettyPrint))
  add(query_580653, "oauth_token", newJString(oauthToken))
  add(query_580653, "alt", newJString(alt))
  add(query_580653, "userIp", newJString(userIp))
  add(query_580653, "quotaUser", newJString(quotaUser))
  add(path_580652, "merchantId", newJString(merchantId))
  if body != nil:
    body_580654 = body
  add(query_580653, "fields", newJString(fields))
  add(path_580652, "orderId", newJString(orderId))
  result = call_580651.call(path_580652, query_580653, nil, nil, body_580654)

var contentOrderinvoicesCreatechargeinvoice* = Call_ContentOrderinvoicesCreatechargeinvoice_580637(
    name: "contentOrderinvoicesCreatechargeinvoice", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderinvoices/{orderId}/createChargeInvoice",
    validator: validate_ContentOrderinvoicesCreatechargeinvoice_580638,
    base: "/content/v2", url: url_ContentOrderinvoicesCreatechargeinvoice_580639,
    schemes: {Scheme.Https})
type
  Call_ContentOrderinvoicesCreaterefundinvoice_580655 = ref object of OpenApiRestCall_579373
proc url_ContentOrderinvoicesCreaterefundinvoice_580657(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentOrderinvoicesCreaterefundinvoice_580656(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a refund invoice for one or more shipment groups, and triggers a refund for orderinvoice enabled orders. This can only be used for line items that have previously been charged using createChargeInvoice. All amounts (except for the summary) are incremental with respect to the previous invoice.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580658 = path.getOrDefault("merchantId")
  valid_580658 = validateParameter(valid_580658, JString, required = true,
                                 default = nil)
  if valid_580658 != nil:
    section.add "merchantId", valid_580658
  var valid_580659 = path.getOrDefault("orderId")
  valid_580659 = validateParameter(valid_580659, JString, required = true,
                                 default = nil)
  if valid_580659 != nil:
    section.add "orderId", valid_580659
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580660 = query.getOrDefault("key")
  valid_580660 = validateParameter(valid_580660, JString, required = false,
                                 default = nil)
  if valid_580660 != nil:
    section.add "key", valid_580660
  var valid_580661 = query.getOrDefault("prettyPrint")
  valid_580661 = validateParameter(valid_580661, JBool, required = false,
                                 default = newJBool(true))
  if valid_580661 != nil:
    section.add "prettyPrint", valid_580661
  var valid_580662 = query.getOrDefault("oauth_token")
  valid_580662 = validateParameter(valid_580662, JString, required = false,
                                 default = nil)
  if valid_580662 != nil:
    section.add "oauth_token", valid_580662
  var valid_580663 = query.getOrDefault("alt")
  valid_580663 = validateParameter(valid_580663, JString, required = false,
                                 default = newJString("json"))
  if valid_580663 != nil:
    section.add "alt", valid_580663
  var valid_580664 = query.getOrDefault("userIp")
  valid_580664 = validateParameter(valid_580664, JString, required = false,
                                 default = nil)
  if valid_580664 != nil:
    section.add "userIp", valid_580664
  var valid_580665 = query.getOrDefault("quotaUser")
  valid_580665 = validateParameter(valid_580665, JString, required = false,
                                 default = nil)
  if valid_580665 != nil:
    section.add "quotaUser", valid_580665
  var valid_580666 = query.getOrDefault("fields")
  valid_580666 = validateParameter(valid_580666, JString, required = false,
                                 default = nil)
  if valid_580666 != nil:
    section.add "fields", valid_580666
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580668: Call_ContentOrderinvoicesCreaterefundinvoice_580655;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a refund invoice for one or more shipment groups, and triggers a refund for orderinvoice enabled orders. This can only be used for line items that have previously been charged using createChargeInvoice. All amounts (except for the summary) are incremental with respect to the previous invoice.
  ## 
  let valid = call_580668.validator(path, query, header, formData, body)
  let scheme = call_580668.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580668.url(scheme.get, call_580668.host, call_580668.base,
                         call_580668.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580668, url, valid)

proc call*(call_580669: Call_ContentOrderinvoicesCreaterefundinvoice_580655;
          merchantId: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentOrderinvoicesCreaterefundinvoice
  ## Creates a refund invoice for one or more shipment groups, and triggers a refund for orderinvoice enabled orders. This can only be used for line items that have previously been charged using createChargeInvoice. All amounts (except for the summary) are incremental with respect to the previous invoice.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order.
  var path_580670 = newJObject()
  var query_580671 = newJObject()
  var body_580672 = newJObject()
  add(query_580671, "key", newJString(key))
  add(query_580671, "prettyPrint", newJBool(prettyPrint))
  add(query_580671, "oauth_token", newJString(oauthToken))
  add(query_580671, "alt", newJString(alt))
  add(query_580671, "userIp", newJString(userIp))
  add(query_580671, "quotaUser", newJString(quotaUser))
  add(path_580670, "merchantId", newJString(merchantId))
  if body != nil:
    body_580672 = body
  add(query_580671, "fields", newJString(fields))
  add(path_580670, "orderId", newJString(orderId))
  result = call_580669.call(path_580670, query_580671, nil, nil, body_580672)

var contentOrderinvoicesCreaterefundinvoice* = Call_ContentOrderinvoicesCreaterefundinvoice_580655(
    name: "contentOrderinvoicesCreaterefundinvoice", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderinvoices/{orderId}/createRefundInvoice",
    validator: validate_ContentOrderinvoicesCreaterefundinvoice_580656,
    base: "/content/v2", url: url_ContentOrderinvoicesCreaterefundinvoice_580657,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreportsListdisbursements_580673 = ref object of OpenApiRestCall_579373
proc url_ContentOrderreportsListdisbursements_580675(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentOrderreportsListdisbursements_580674(path: JsonNode;
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
  var valid_580676 = path.getOrDefault("merchantId")
  valid_580676 = validateParameter(valid_580676, JString, required = true,
                                 default = nil)
  if valid_580676 != nil:
    section.add "merchantId", valid_580676
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   disbursementEndDate: JString
  ##                      : The last date which disbursements occurred. In ISO 8601 format. Default: current date.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   disbursementStartDate: JString (required)
  ##                        : The first date which disbursements occurred. In ISO 8601 format.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of disbursements to return in the response, used for paging.
  section = newJObject()
  var valid_580677 = query.getOrDefault("key")
  valid_580677 = validateParameter(valid_580677, JString, required = false,
                                 default = nil)
  if valid_580677 != nil:
    section.add "key", valid_580677
  var valid_580678 = query.getOrDefault("prettyPrint")
  valid_580678 = validateParameter(valid_580678, JBool, required = false,
                                 default = newJBool(true))
  if valid_580678 != nil:
    section.add "prettyPrint", valid_580678
  var valid_580679 = query.getOrDefault("oauth_token")
  valid_580679 = validateParameter(valid_580679, JString, required = false,
                                 default = nil)
  if valid_580679 != nil:
    section.add "oauth_token", valid_580679
  var valid_580680 = query.getOrDefault("disbursementEndDate")
  valid_580680 = validateParameter(valid_580680, JString, required = false,
                                 default = nil)
  if valid_580680 != nil:
    section.add "disbursementEndDate", valid_580680
  var valid_580681 = query.getOrDefault("alt")
  valid_580681 = validateParameter(valid_580681, JString, required = false,
                                 default = newJString("json"))
  if valid_580681 != nil:
    section.add "alt", valid_580681
  var valid_580682 = query.getOrDefault("userIp")
  valid_580682 = validateParameter(valid_580682, JString, required = false,
                                 default = nil)
  if valid_580682 != nil:
    section.add "userIp", valid_580682
  var valid_580683 = query.getOrDefault("quotaUser")
  valid_580683 = validateParameter(valid_580683, JString, required = false,
                                 default = nil)
  if valid_580683 != nil:
    section.add "quotaUser", valid_580683
  var valid_580684 = query.getOrDefault("pageToken")
  valid_580684 = validateParameter(valid_580684, JString, required = false,
                                 default = nil)
  if valid_580684 != nil:
    section.add "pageToken", valid_580684
  assert query != nil, "query argument is necessary due to required `disbursementStartDate` field"
  var valid_580685 = query.getOrDefault("disbursementStartDate")
  valid_580685 = validateParameter(valid_580685, JString, required = true,
                                 default = nil)
  if valid_580685 != nil:
    section.add "disbursementStartDate", valid_580685
  var valid_580686 = query.getOrDefault("fields")
  valid_580686 = validateParameter(valid_580686, JString, required = false,
                                 default = nil)
  if valid_580686 != nil:
    section.add "fields", valid_580686
  var valid_580687 = query.getOrDefault("maxResults")
  valid_580687 = validateParameter(valid_580687, JInt, required = false, default = nil)
  if valid_580687 != nil:
    section.add "maxResults", valid_580687
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580688: Call_ContentOrderreportsListdisbursements_580673;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a report for disbursements from your Merchant Center account.
  ## 
  let valid = call_580688.validator(path, query, header, formData, body)
  let scheme = call_580688.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580688.url(scheme.get, call_580688.host, call_580688.base,
                         call_580688.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580688, url, valid)

proc call*(call_580689: Call_ContentOrderreportsListdisbursements_580673;
          merchantId: string; disbursementStartDate: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          disbursementEndDate: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## contentOrderreportsListdisbursements
  ## Retrieves a report for disbursements from your Merchant Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   disbursementEndDate: string
  ##                      : The last date which disbursements occurred. In ISO 8601 format. Default: current date.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   disbursementStartDate: string (required)
  ##                        : The first date which disbursements occurred. In ISO 8601 format.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of disbursements to return in the response, used for paging.
  var path_580690 = newJObject()
  var query_580691 = newJObject()
  add(query_580691, "key", newJString(key))
  add(query_580691, "prettyPrint", newJBool(prettyPrint))
  add(query_580691, "oauth_token", newJString(oauthToken))
  add(query_580691, "disbursementEndDate", newJString(disbursementEndDate))
  add(query_580691, "alt", newJString(alt))
  add(query_580691, "userIp", newJString(userIp))
  add(query_580691, "quotaUser", newJString(quotaUser))
  add(path_580690, "merchantId", newJString(merchantId))
  add(query_580691, "pageToken", newJString(pageToken))
  add(query_580691, "disbursementStartDate", newJString(disbursementStartDate))
  add(query_580691, "fields", newJString(fields))
  add(query_580691, "maxResults", newJInt(maxResults))
  result = call_580689.call(path_580690, query_580691, nil, nil, nil)

var contentOrderreportsListdisbursements* = Call_ContentOrderreportsListdisbursements_580673(
    name: "contentOrderreportsListdisbursements", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreports/disbursements",
    validator: validate_ContentOrderreportsListdisbursements_580674,
    base: "/content/v2", url: url_ContentOrderreportsListdisbursements_580675,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreportsListtransactions_580692 = ref object of OpenApiRestCall_579373
proc url_ContentOrderreportsListtransactions_580694(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentOrderreportsListtransactions_580693(path: JsonNode;
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
  var valid_580695 = path.getOrDefault("merchantId")
  valid_580695 = validateParameter(valid_580695, JString, required = true,
                                 default = nil)
  if valid_580695 != nil:
    section.add "merchantId", valid_580695
  var valid_580696 = path.getOrDefault("disbursementId")
  valid_580696 = validateParameter(valid_580696, JString, required = true,
                                 default = nil)
  if valid_580696 != nil:
    section.add "disbursementId", valid_580696
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   transactionEndDate: JString
  ##                     : The last date in which transaction occurred. In ISO 8601 format. Default: current date.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   transactionStartDate: JString (required)
  ##                       : The first date in which transaction occurred. In ISO 8601 format.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of disbursements to return in the response, used for paging.
  section = newJObject()
  var valid_580697 = query.getOrDefault("key")
  valid_580697 = validateParameter(valid_580697, JString, required = false,
                                 default = nil)
  if valid_580697 != nil:
    section.add "key", valid_580697
  var valid_580698 = query.getOrDefault("prettyPrint")
  valid_580698 = validateParameter(valid_580698, JBool, required = false,
                                 default = newJBool(true))
  if valid_580698 != nil:
    section.add "prettyPrint", valid_580698
  var valid_580699 = query.getOrDefault("oauth_token")
  valid_580699 = validateParameter(valid_580699, JString, required = false,
                                 default = nil)
  if valid_580699 != nil:
    section.add "oauth_token", valid_580699
  var valid_580700 = query.getOrDefault("transactionEndDate")
  valid_580700 = validateParameter(valid_580700, JString, required = false,
                                 default = nil)
  if valid_580700 != nil:
    section.add "transactionEndDate", valid_580700
  var valid_580701 = query.getOrDefault("alt")
  valid_580701 = validateParameter(valid_580701, JString, required = false,
                                 default = newJString("json"))
  if valid_580701 != nil:
    section.add "alt", valid_580701
  var valid_580702 = query.getOrDefault("userIp")
  valid_580702 = validateParameter(valid_580702, JString, required = false,
                                 default = nil)
  if valid_580702 != nil:
    section.add "userIp", valid_580702
  assert query != nil, "query argument is necessary due to required `transactionStartDate` field"
  var valid_580703 = query.getOrDefault("transactionStartDate")
  valid_580703 = validateParameter(valid_580703, JString, required = true,
                                 default = nil)
  if valid_580703 != nil:
    section.add "transactionStartDate", valid_580703
  var valid_580704 = query.getOrDefault("quotaUser")
  valid_580704 = validateParameter(valid_580704, JString, required = false,
                                 default = nil)
  if valid_580704 != nil:
    section.add "quotaUser", valid_580704
  var valid_580705 = query.getOrDefault("pageToken")
  valid_580705 = validateParameter(valid_580705, JString, required = false,
                                 default = nil)
  if valid_580705 != nil:
    section.add "pageToken", valid_580705
  var valid_580706 = query.getOrDefault("fields")
  valid_580706 = validateParameter(valid_580706, JString, required = false,
                                 default = nil)
  if valid_580706 != nil:
    section.add "fields", valid_580706
  var valid_580707 = query.getOrDefault("maxResults")
  valid_580707 = validateParameter(valid_580707, JInt, required = false, default = nil)
  if valid_580707 != nil:
    section.add "maxResults", valid_580707
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580708: Call_ContentOrderreportsListtransactions_580692;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of transactions for a disbursement from your Merchant Center account.
  ## 
  let valid = call_580708.validator(path, query, header, formData, body)
  let scheme = call_580708.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580708.url(scheme.get, call_580708.host, call_580708.base,
                         call_580708.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580708, url, valid)

proc call*(call_580709: Call_ContentOrderreportsListtransactions_580692;
          transactionStartDate: string; merchantId: string; disbursementId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          transactionEndDate: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## contentOrderreportsListtransactions
  ## Retrieves a list of transactions for a disbursement from your Merchant Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   transactionEndDate: string
  ##                     : The last date in which transaction occurred. In ISO 8601 format. Default: current date.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   transactionStartDate: string (required)
  ##                       : The first date in which transaction occurred. In ISO 8601 format.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   disbursementId: string (required)
  ##                 : The Google-provided ID of the disbursement (found in Wallet).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of disbursements to return in the response, used for paging.
  var path_580710 = newJObject()
  var query_580711 = newJObject()
  add(query_580711, "key", newJString(key))
  add(query_580711, "prettyPrint", newJBool(prettyPrint))
  add(query_580711, "oauth_token", newJString(oauthToken))
  add(query_580711, "transactionEndDate", newJString(transactionEndDate))
  add(query_580711, "alt", newJString(alt))
  add(query_580711, "userIp", newJString(userIp))
  add(query_580711, "transactionStartDate", newJString(transactionStartDate))
  add(query_580711, "quotaUser", newJString(quotaUser))
  add(path_580710, "merchantId", newJString(merchantId))
  add(query_580711, "pageToken", newJString(pageToken))
  add(path_580710, "disbursementId", newJString(disbursementId))
  add(query_580711, "fields", newJString(fields))
  add(query_580711, "maxResults", newJInt(maxResults))
  result = call_580709.call(path_580710, query_580711, nil, nil, nil)

var contentOrderreportsListtransactions* = Call_ContentOrderreportsListtransactions_580692(
    name: "contentOrderreportsListtransactions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreports/disbursements/{disbursementId}/transactions",
    validator: validate_ContentOrderreportsListtransactions_580693,
    base: "/content/v2", url: url_ContentOrderreportsListtransactions_580694,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreturnsList_580712 = ref object of OpenApiRestCall_579373
proc url_ContentOrderreturnsList_580714(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentOrderreturnsList_580713(path: JsonNode; query: JsonNode;
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
  var valid_580715 = path.getOrDefault("merchantId")
  valid_580715 = validateParameter(valid_580715, JString, required = true,
                                 default = nil)
  if valid_580715 != nil:
    section.add "merchantId", valid_580715
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   createdStartDate: JString
  ##                   : Obtains order returns created after this date (inclusively), in ISO 8601 format.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: JString
  ##          : Return the results in the specified order.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of order returns to return in the response, used for paging. The default value is 25 returns per page, and the maximum allowed value is 250 returns per page.
  ##   createdEndDate: JString
  ##                 : Obtains order returns created before this date (inclusively), in ISO 8601 format.
  section = newJObject()
  var valid_580716 = query.getOrDefault("key")
  valid_580716 = validateParameter(valid_580716, JString, required = false,
                                 default = nil)
  if valid_580716 != nil:
    section.add "key", valid_580716
  var valid_580717 = query.getOrDefault("prettyPrint")
  valid_580717 = validateParameter(valid_580717, JBool, required = false,
                                 default = newJBool(true))
  if valid_580717 != nil:
    section.add "prettyPrint", valid_580717
  var valid_580718 = query.getOrDefault("oauth_token")
  valid_580718 = validateParameter(valid_580718, JString, required = false,
                                 default = nil)
  if valid_580718 != nil:
    section.add "oauth_token", valid_580718
  var valid_580719 = query.getOrDefault("createdStartDate")
  valid_580719 = validateParameter(valid_580719, JString, required = false,
                                 default = nil)
  if valid_580719 != nil:
    section.add "createdStartDate", valid_580719
  var valid_580720 = query.getOrDefault("alt")
  valid_580720 = validateParameter(valid_580720, JString, required = false,
                                 default = newJString("json"))
  if valid_580720 != nil:
    section.add "alt", valid_580720
  var valid_580721 = query.getOrDefault("userIp")
  valid_580721 = validateParameter(valid_580721, JString, required = false,
                                 default = nil)
  if valid_580721 != nil:
    section.add "userIp", valid_580721
  var valid_580722 = query.getOrDefault("quotaUser")
  valid_580722 = validateParameter(valid_580722, JString, required = false,
                                 default = nil)
  if valid_580722 != nil:
    section.add "quotaUser", valid_580722
  var valid_580723 = query.getOrDefault("orderBy")
  valid_580723 = validateParameter(valid_580723, JString, required = false,
                                 default = newJString("returnCreationTimeAsc"))
  if valid_580723 != nil:
    section.add "orderBy", valid_580723
  var valid_580724 = query.getOrDefault("pageToken")
  valid_580724 = validateParameter(valid_580724, JString, required = false,
                                 default = nil)
  if valid_580724 != nil:
    section.add "pageToken", valid_580724
  var valid_580725 = query.getOrDefault("fields")
  valid_580725 = validateParameter(valid_580725, JString, required = false,
                                 default = nil)
  if valid_580725 != nil:
    section.add "fields", valid_580725
  var valid_580726 = query.getOrDefault("maxResults")
  valid_580726 = validateParameter(valid_580726, JInt, required = false, default = nil)
  if valid_580726 != nil:
    section.add "maxResults", valid_580726
  var valid_580727 = query.getOrDefault("createdEndDate")
  valid_580727 = validateParameter(valid_580727, JString, required = false,
                                 default = nil)
  if valid_580727 != nil:
    section.add "createdEndDate", valid_580727
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580728: Call_ContentOrderreturnsList_580712; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists order returns in your Merchant Center account.
  ## 
  let valid = call_580728.validator(path, query, header, formData, body)
  let scheme = call_580728.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580728.url(scheme.get, call_580728.host, call_580728.base,
                         call_580728.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580728, url, valid)

proc call*(call_580729: Call_ContentOrderreturnsList_580712; merchantId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          createdStartDate: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; orderBy: string = "returnCreationTimeAsc";
          pageToken: string = ""; fields: string = ""; maxResults: int = 0;
          createdEndDate: string = ""): Recallable =
  ## contentOrderreturnsList
  ## Lists order returns in your Merchant Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   createdStartDate: string
  ##                   : Obtains order returns created after this date (inclusively), in ISO 8601 format.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderBy: string
  ##          : Return the results in the specified order.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of order returns to return in the response, used for paging. The default value is 25 returns per page, and the maximum allowed value is 250 returns per page.
  ##   createdEndDate: string
  ##                 : Obtains order returns created before this date (inclusively), in ISO 8601 format.
  var path_580730 = newJObject()
  var query_580731 = newJObject()
  add(query_580731, "key", newJString(key))
  add(query_580731, "prettyPrint", newJBool(prettyPrint))
  add(query_580731, "oauth_token", newJString(oauthToken))
  add(query_580731, "createdStartDate", newJString(createdStartDate))
  add(query_580731, "alt", newJString(alt))
  add(query_580731, "userIp", newJString(userIp))
  add(query_580731, "quotaUser", newJString(quotaUser))
  add(path_580730, "merchantId", newJString(merchantId))
  add(query_580731, "orderBy", newJString(orderBy))
  add(query_580731, "pageToken", newJString(pageToken))
  add(query_580731, "fields", newJString(fields))
  add(query_580731, "maxResults", newJInt(maxResults))
  add(query_580731, "createdEndDate", newJString(createdEndDate))
  result = call_580729.call(path_580730, query_580731, nil, nil, nil)

var contentOrderreturnsList* = Call_ContentOrderreturnsList_580712(
    name: "contentOrderreturnsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreturns",
    validator: validate_ContentOrderreturnsList_580713, base: "/content/v2",
    url: url_ContentOrderreturnsList_580714, schemes: {Scheme.Https})
type
  Call_ContentOrderreturnsGet_580732 = ref object of OpenApiRestCall_579373
proc url_ContentOrderreturnsGet_580734(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentOrderreturnsGet_580733(path: JsonNode; query: JsonNode;
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
  var valid_580735 = path.getOrDefault("returnId")
  valid_580735 = validateParameter(valid_580735, JString, required = true,
                                 default = nil)
  if valid_580735 != nil:
    section.add "returnId", valid_580735
  var valid_580736 = path.getOrDefault("merchantId")
  valid_580736 = validateParameter(valid_580736, JString, required = true,
                                 default = nil)
  if valid_580736 != nil:
    section.add "merchantId", valid_580736
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580737 = query.getOrDefault("key")
  valid_580737 = validateParameter(valid_580737, JString, required = false,
                                 default = nil)
  if valid_580737 != nil:
    section.add "key", valid_580737
  var valid_580738 = query.getOrDefault("prettyPrint")
  valid_580738 = validateParameter(valid_580738, JBool, required = false,
                                 default = newJBool(true))
  if valid_580738 != nil:
    section.add "prettyPrint", valid_580738
  var valid_580739 = query.getOrDefault("oauth_token")
  valid_580739 = validateParameter(valid_580739, JString, required = false,
                                 default = nil)
  if valid_580739 != nil:
    section.add "oauth_token", valid_580739
  var valid_580740 = query.getOrDefault("alt")
  valid_580740 = validateParameter(valid_580740, JString, required = false,
                                 default = newJString("json"))
  if valid_580740 != nil:
    section.add "alt", valid_580740
  var valid_580741 = query.getOrDefault("userIp")
  valid_580741 = validateParameter(valid_580741, JString, required = false,
                                 default = nil)
  if valid_580741 != nil:
    section.add "userIp", valid_580741
  var valid_580742 = query.getOrDefault("quotaUser")
  valid_580742 = validateParameter(valid_580742, JString, required = false,
                                 default = nil)
  if valid_580742 != nil:
    section.add "quotaUser", valid_580742
  var valid_580743 = query.getOrDefault("fields")
  valid_580743 = validateParameter(valid_580743, JString, required = false,
                                 default = nil)
  if valid_580743 != nil:
    section.add "fields", valid_580743
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580744: Call_ContentOrderreturnsGet_580732; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an order return from your Merchant Center account.
  ## 
  let valid = call_580744.validator(path, query, header, formData, body)
  let scheme = call_580744.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580744.url(scheme.get, call_580744.host, call_580744.base,
                         call_580744.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580744, url, valid)

proc call*(call_580745: Call_ContentOrderreturnsGet_580732; returnId: string;
          merchantId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## contentOrderreturnsGet
  ## Retrieves an order return from your Merchant Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   returnId: string (required)
  ##           : Merchant order return ID generated by Google.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580746 = newJObject()
  var query_580747 = newJObject()
  add(query_580747, "key", newJString(key))
  add(query_580747, "prettyPrint", newJBool(prettyPrint))
  add(query_580747, "oauth_token", newJString(oauthToken))
  add(path_580746, "returnId", newJString(returnId))
  add(query_580747, "alt", newJString(alt))
  add(query_580747, "userIp", newJString(userIp))
  add(query_580747, "quotaUser", newJString(quotaUser))
  add(path_580746, "merchantId", newJString(merchantId))
  add(query_580747, "fields", newJString(fields))
  result = call_580745.call(path_580746, query_580747, nil, nil, nil)

var contentOrderreturnsGet* = Call_ContentOrderreturnsGet_580732(
    name: "contentOrderreturnsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreturns/{returnId}",
    validator: validate_ContentOrderreturnsGet_580733, base: "/content/v2",
    url: url_ContentOrderreturnsGet_580734, schemes: {Scheme.Https})
type
  Call_ContentOrdersList_580748 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersList_580750(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentOrdersList_580749(path: JsonNode; query: JsonNode;
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
  var valid_580751 = path.getOrDefault("merchantId")
  valid_580751 = validateParameter(valid_580751, JString, required = true,
                                 default = nil)
  if valid_580751 != nil:
    section.add "merchantId", valid_580751
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: JString
  ##          : Order results by placement date in descending or ascending order.
  ## 
  ## Acceptable values are:
  ## - placedDateAsc
  ## - placedDateDesc
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   placedDateStart: JString
  ##                  : Obtains orders placed after this date (inclusively), in ISO 8601 format.
  ##   statuses: JArray
  ##           : Obtains orders that match any of the specified statuses. Please note that active is a shortcut for pendingShipment and partiallyShipped, and completed is a shortcut for shipped, partiallyDelivered, delivered, partiallyReturned, returned, and canceled.
  ##   acknowledged: JBool
  ##               : Obtains orders that match the acknowledgement status. When set to true, obtains orders that have been acknowledged. When false, obtains orders that have not been acknowledged.
  ## We recommend using this filter set to false, in conjunction with the acknowledge call, such that only un-acknowledged orders are returned.
  ##   placedDateEnd: JString
  ##                : Obtains orders placed before this date (exclusively), in ISO 8601 format.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of orders to return in the response, used for paging. The default value is 25 orders per page, and the maximum allowed value is 250 orders per page.
  section = newJObject()
  var valid_580752 = query.getOrDefault("key")
  valid_580752 = validateParameter(valid_580752, JString, required = false,
                                 default = nil)
  if valid_580752 != nil:
    section.add "key", valid_580752
  var valid_580753 = query.getOrDefault("prettyPrint")
  valid_580753 = validateParameter(valid_580753, JBool, required = false,
                                 default = newJBool(true))
  if valid_580753 != nil:
    section.add "prettyPrint", valid_580753
  var valid_580754 = query.getOrDefault("oauth_token")
  valid_580754 = validateParameter(valid_580754, JString, required = false,
                                 default = nil)
  if valid_580754 != nil:
    section.add "oauth_token", valid_580754
  var valid_580755 = query.getOrDefault("alt")
  valid_580755 = validateParameter(valid_580755, JString, required = false,
                                 default = newJString("json"))
  if valid_580755 != nil:
    section.add "alt", valid_580755
  var valid_580756 = query.getOrDefault("userIp")
  valid_580756 = validateParameter(valid_580756, JString, required = false,
                                 default = nil)
  if valid_580756 != nil:
    section.add "userIp", valid_580756
  var valid_580757 = query.getOrDefault("quotaUser")
  valid_580757 = validateParameter(valid_580757, JString, required = false,
                                 default = nil)
  if valid_580757 != nil:
    section.add "quotaUser", valid_580757
  var valid_580758 = query.getOrDefault("orderBy")
  valid_580758 = validateParameter(valid_580758, JString, required = false,
                                 default = nil)
  if valid_580758 != nil:
    section.add "orderBy", valid_580758
  var valid_580759 = query.getOrDefault("pageToken")
  valid_580759 = validateParameter(valid_580759, JString, required = false,
                                 default = nil)
  if valid_580759 != nil:
    section.add "pageToken", valid_580759
  var valid_580760 = query.getOrDefault("placedDateStart")
  valid_580760 = validateParameter(valid_580760, JString, required = false,
                                 default = nil)
  if valid_580760 != nil:
    section.add "placedDateStart", valid_580760
  var valid_580761 = query.getOrDefault("statuses")
  valid_580761 = validateParameter(valid_580761, JArray, required = false,
                                 default = nil)
  if valid_580761 != nil:
    section.add "statuses", valid_580761
  var valid_580762 = query.getOrDefault("acknowledged")
  valid_580762 = validateParameter(valid_580762, JBool, required = false, default = nil)
  if valid_580762 != nil:
    section.add "acknowledged", valid_580762
  var valid_580763 = query.getOrDefault("placedDateEnd")
  valid_580763 = validateParameter(valid_580763, JString, required = false,
                                 default = nil)
  if valid_580763 != nil:
    section.add "placedDateEnd", valid_580763
  var valid_580764 = query.getOrDefault("fields")
  valid_580764 = validateParameter(valid_580764, JString, required = false,
                                 default = nil)
  if valid_580764 != nil:
    section.add "fields", valid_580764
  var valid_580765 = query.getOrDefault("maxResults")
  valid_580765 = validateParameter(valid_580765, JInt, required = false, default = nil)
  if valid_580765 != nil:
    section.add "maxResults", valid_580765
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580766: Call_ContentOrdersList_580748; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the orders in your Merchant Center account.
  ## 
  let valid = call_580766.validator(path, query, header, formData, body)
  let scheme = call_580766.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580766.url(scheme.get, call_580766.host, call_580766.base,
                         call_580766.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580766, url, valid)

proc call*(call_580767: Call_ContentOrdersList_580748; merchantId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          orderBy: string = ""; pageToken: string = ""; placedDateStart: string = "";
          statuses: JsonNode = nil; acknowledged: bool = false;
          placedDateEnd: string = ""; fields: string = ""; maxResults: int = 0): Recallable =
  ## contentOrdersList
  ## Lists the orders in your Merchant Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderBy: string
  ##          : Order results by placement date in descending or ascending order.
  ## 
  ## Acceptable values are:
  ## - placedDateAsc
  ## - placedDateDesc
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   placedDateStart: string
  ##                  : Obtains orders placed after this date (inclusively), in ISO 8601 format.
  ##   statuses: JArray
  ##           : Obtains orders that match any of the specified statuses. Please note that active is a shortcut for pendingShipment and partiallyShipped, and completed is a shortcut for shipped, partiallyDelivered, delivered, partiallyReturned, returned, and canceled.
  ##   acknowledged: bool
  ##               : Obtains orders that match the acknowledgement status. When set to true, obtains orders that have been acknowledged. When false, obtains orders that have not been acknowledged.
  ## We recommend using this filter set to false, in conjunction with the acknowledge call, such that only un-acknowledged orders are returned.
  ##   placedDateEnd: string
  ##                : Obtains orders placed before this date (exclusively), in ISO 8601 format.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of orders to return in the response, used for paging. The default value is 25 orders per page, and the maximum allowed value is 250 orders per page.
  var path_580768 = newJObject()
  var query_580769 = newJObject()
  add(query_580769, "key", newJString(key))
  add(query_580769, "prettyPrint", newJBool(prettyPrint))
  add(query_580769, "oauth_token", newJString(oauthToken))
  add(query_580769, "alt", newJString(alt))
  add(query_580769, "userIp", newJString(userIp))
  add(query_580769, "quotaUser", newJString(quotaUser))
  add(path_580768, "merchantId", newJString(merchantId))
  add(query_580769, "orderBy", newJString(orderBy))
  add(query_580769, "pageToken", newJString(pageToken))
  add(query_580769, "placedDateStart", newJString(placedDateStart))
  if statuses != nil:
    query_580769.add "statuses", statuses
  add(query_580769, "acknowledged", newJBool(acknowledged))
  add(query_580769, "placedDateEnd", newJString(placedDateEnd))
  add(query_580769, "fields", newJString(fields))
  add(query_580769, "maxResults", newJInt(maxResults))
  result = call_580767.call(path_580768, query_580769, nil, nil, nil)

var contentOrdersList* = Call_ContentOrdersList_580748(name: "contentOrdersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/orders", validator: validate_ContentOrdersList_580749,
    base: "/content/v2", url: url_ContentOrdersList_580750, schemes: {Scheme.Https})
type
  Call_ContentOrdersGet_580770 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersGet_580772(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentOrdersGet_580771(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieves an order from your Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580773 = path.getOrDefault("merchantId")
  valid_580773 = validateParameter(valid_580773, JString, required = true,
                                 default = nil)
  if valid_580773 != nil:
    section.add "merchantId", valid_580773
  var valid_580774 = path.getOrDefault("orderId")
  valid_580774 = validateParameter(valid_580774, JString, required = true,
                                 default = nil)
  if valid_580774 != nil:
    section.add "orderId", valid_580774
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580775 = query.getOrDefault("key")
  valid_580775 = validateParameter(valid_580775, JString, required = false,
                                 default = nil)
  if valid_580775 != nil:
    section.add "key", valid_580775
  var valid_580776 = query.getOrDefault("prettyPrint")
  valid_580776 = validateParameter(valid_580776, JBool, required = false,
                                 default = newJBool(true))
  if valid_580776 != nil:
    section.add "prettyPrint", valid_580776
  var valid_580777 = query.getOrDefault("oauth_token")
  valid_580777 = validateParameter(valid_580777, JString, required = false,
                                 default = nil)
  if valid_580777 != nil:
    section.add "oauth_token", valid_580777
  var valid_580778 = query.getOrDefault("alt")
  valid_580778 = validateParameter(valid_580778, JString, required = false,
                                 default = newJString("json"))
  if valid_580778 != nil:
    section.add "alt", valid_580778
  var valid_580779 = query.getOrDefault("userIp")
  valid_580779 = validateParameter(valid_580779, JString, required = false,
                                 default = nil)
  if valid_580779 != nil:
    section.add "userIp", valid_580779
  var valid_580780 = query.getOrDefault("quotaUser")
  valid_580780 = validateParameter(valid_580780, JString, required = false,
                                 default = nil)
  if valid_580780 != nil:
    section.add "quotaUser", valid_580780
  var valid_580781 = query.getOrDefault("fields")
  valid_580781 = validateParameter(valid_580781, JString, required = false,
                                 default = nil)
  if valid_580781 != nil:
    section.add "fields", valid_580781
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580782: Call_ContentOrdersGet_580770; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an order from your Merchant Center account.
  ## 
  let valid = call_580782.validator(path, query, header, formData, body)
  let scheme = call_580782.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580782.url(scheme.get, call_580782.host, call_580782.base,
                         call_580782.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580782, url, valid)

proc call*(call_580783: Call_ContentOrdersGet_580770; merchantId: string;
          orderId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## contentOrdersGet
  ## Retrieves an order from your Merchant Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order.
  var path_580784 = newJObject()
  var query_580785 = newJObject()
  add(query_580785, "key", newJString(key))
  add(query_580785, "prettyPrint", newJBool(prettyPrint))
  add(query_580785, "oauth_token", newJString(oauthToken))
  add(query_580785, "alt", newJString(alt))
  add(query_580785, "userIp", newJString(userIp))
  add(query_580785, "quotaUser", newJString(quotaUser))
  add(path_580784, "merchantId", newJString(merchantId))
  add(query_580785, "fields", newJString(fields))
  add(path_580784, "orderId", newJString(orderId))
  result = call_580783.call(path_580784, query_580785, nil, nil, nil)

var contentOrdersGet* = Call_ContentOrdersGet_580770(name: "contentOrdersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}", validator: validate_ContentOrdersGet_580771,
    base: "/content/v2", url: url_ContentOrdersGet_580772, schemes: {Scheme.Https})
type
  Call_ContentOrdersAcknowledge_580786 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersAcknowledge_580788(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentOrdersAcknowledge_580787(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Marks an order as acknowledged.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580789 = path.getOrDefault("merchantId")
  valid_580789 = validateParameter(valid_580789, JString, required = true,
                                 default = nil)
  if valid_580789 != nil:
    section.add "merchantId", valid_580789
  var valid_580790 = path.getOrDefault("orderId")
  valid_580790 = validateParameter(valid_580790, JString, required = true,
                                 default = nil)
  if valid_580790 != nil:
    section.add "orderId", valid_580790
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580791 = query.getOrDefault("key")
  valid_580791 = validateParameter(valid_580791, JString, required = false,
                                 default = nil)
  if valid_580791 != nil:
    section.add "key", valid_580791
  var valid_580792 = query.getOrDefault("prettyPrint")
  valid_580792 = validateParameter(valid_580792, JBool, required = false,
                                 default = newJBool(true))
  if valid_580792 != nil:
    section.add "prettyPrint", valid_580792
  var valid_580793 = query.getOrDefault("oauth_token")
  valid_580793 = validateParameter(valid_580793, JString, required = false,
                                 default = nil)
  if valid_580793 != nil:
    section.add "oauth_token", valid_580793
  var valid_580794 = query.getOrDefault("alt")
  valid_580794 = validateParameter(valid_580794, JString, required = false,
                                 default = newJString("json"))
  if valid_580794 != nil:
    section.add "alt", valid_580794
  var valid_580795 = query.getOrDefault("userIp")
  valid_580795 = validateParameter(valid_580795, JString, required = false,
                                 default = nil)
  if valid_580795 != nil:
    section.add "userIp", valid_580795
  var valid_580796 = query.getOrDefault("quotaUser")
  valid_580796 = validateParameter(valid_580796, JString, required = false,
                                 default = nil)
  if valid_580796 != nil:
    section.add "quotaUser", valid_580796
  var valid_580797 = query.getOrDefault("fields")
  valid_580797 = validateParameter(valid_580797, JString, required = false,
                                 default = nil)
  if valid_580797 != nil:
    section.add "fields", valid_580797
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580799: Call_ContentOrdersAcknowledge_580786; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks an order as acknowledged.
  ## 
  let valid = call_580799.validator(path, query, header, formData, body)
  let scheme = call_580799.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580799.url(scheme.get, call_580799.host, call_580799.base,
                         call_580799.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580799, url, valid)

proc call*(call_580800: Call_ContentOrdersAcknowledge_580786; merchantId: string;
          orderId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentOrdersAcknowledge
  ## Marks an order as acknowledged.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order.
  var path_580801 = newJObject()
  var query_580802 = newJObject()
  var body_580803 = newJObject()
  add(query_580802, "key", newJString(key))
  add(query_580802, "prettyPrint", newJBool(prettyPrint))
  add(query_580802, "oauth_token", newJString(oauthToken))
  add(query_580802, "alt", newJString(alt))
  add(query_580802, "userIp", newJString(userIp))
  add(query_580802, "quotaUser", newJString(quotaUser))
  add(path_580801, "merchantId", newJString(merchantId))
  if body != nil:
    body_580803 = body
  add(query_580802, "fields", newJString(fields))
  add(path_580801, "orderId", newJString(orderId))
  result = call_580800.call(path_580801, query_580802, nil, nil, body_580803)

var contentOrdersAcknowledge* = Call_ContentOrdersAcknowledge_580786(
    name: "contentOrdersAcknowledge", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/acknowledge",
    validator: validate_ContentOrdersAcknowledge_580787, base: "/content/v2",
    url: url_ContentOrdersAcknowledge_580788, schemes: {Scheme.Https})
type
  Call_ContentOrdersCancel_580804 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersCancel_580806(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentOrdersCancel_580805(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Cancels all line items in an order, making a full refund.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order to cancel.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580807 = path.getOrDefault("merchantId")
  valid_580807 = validateParameter(valid_580807, JString, required = true,
                                 default = nil)
  if valid_580807 != nil:
    section.add "merchantId", valid_580807
  var valid_580808 = path.getOrDefault("orderId")
  valid_580808 = validateParameter(valid_580808, JString, required = true,
                                 default = nil)
  if valid_580808 != nil:
    section.add "orderId", valid_580808
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580809 = query.getOrDefault("key")
  valid_580809 = validateParameter(valid_580809, JString, required = false,
                                 default = nil)
  if valid_580809 != nil:
    section.add "key", valid_580809
  var valid_580810 = query.getOrDefault("prettyPrint")
  valid_580810 = validateParameter(valid_580810, JBool, required = false,
                                 default = newJBool(true))
  if valid_580810 != nil:
    section.add "prettyPrint", valid_580810
  var valid_580811 = query.getOrDefault("oauth_token")
  valid_580811 = validateParameter(valid_580811, JString, required = false,
                                 default = nil)
  if valid_580811 != nil:
    section.add "oauth_token", valid_580811
  var valid_580812 = query.getOrDefault("alt")
  valid_580812 = validateParameter(valid_580812, JString, required = false,
                                 default = newJString("json"))
  if valid_580812 != nil:
    section.add "alt", valid_580812
  var valid_580813 = query.getOrDefault("userIp")
  valid_580813 = validateParameter(valid_580813, JString, required = false,
                                 default = nil)
  if valid_580813 != nil:
    section.add "userIp", valid_580813
  var valid_580814 = query.getOrDefault("quotaUser")
  valid_580814 = validateParameter(valid_580814, JString, required = false,
                                 default = nil)
  if valid_580814 != nil:
    section.add "quotaUser", valid_580814
  var valid_580815 = query.getOrDefault("fields")
  valid_580815 = validateParameter(valid_580815, JString, required = false,
                                 default = nil)
  if valid_580815 != nil:
    section.add "fields", valid_580815
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580817: Call_ContentOrdersCancel_580804; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels all line items in an order, making a full refund.
  ## 
  let valid = call_580817.validator(path, query, header, formData, body)
  let scheme = call_580817.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580817.url(scheme.get, call_580817.host, call_580817.base,
                         call_580817.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580817, url, valid)

proc call*(call_580818: Call_ContentOrdersCancel_580804; merchantId: string;
          orderId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentOrdersCancel
  ## Cancels all line items in an order, making a full refund.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order to cancel.
  var path_580819 = newJObject()
  var query_580820 = newJObject()
  var body_580821 = newJObject()
  add(query_580820, "key", newJString(key))
  add(query_580820, "prettyPrint", newJBool(prettyPrint))
  add(query_580820, "oauth_token", newJString(oauthToken))
  add(query_580820, "alt", newJString(alt))
  add(query_580820, "userIp", newJString(userIp))
  add(query_580820, "quotaUser", newJString(quotaUser))
  add(path_580819, "merchantId", newJString(merchantId))
  if body != nil:
    body_580821 = body
  add(query_580820, "fields", newJString(fields))
  add(path_580819, "orderId", newJString(orderId))
  result = call_580818.call(path_580819, query_580820, nil, nil, body_580821)

var contentOrdersCancel* = Call_ContentOrdersCancel_580804(
    name: "contentOrdersCancel", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/orders/{orderId}/cancel",
    validator: validate_ContentOrdersCancel_580805, base: "/content/v2",
    url: url_ContentOrdersCancel_580806, schemes: {Scheme.Https})
type
  Call_ContentOrdersCancellineitem_580822 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersCancellineitem_580824(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentOrdersCancellineitem_580823(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels a line item, making a full refund.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580825 = path.getOrDefault("merchantId")
  valid_580825 = validateParameter(valid_580825, JString, required = true,
                                 default = nil)
  if valid_580825 != nil:
    section.add "merchantId", valid_580825
  var valid_580826 = path.getOrDefault("orderId")
  valid_580826 = validateParameter(valid_580826, JString, required = true,
                                 default = nil)
  if valid_580826 != nil:
    section.add "orderId", valid_580826
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580827 = query.getOrDefault("key")
  valid_580827 = validateParameter(valid_580827, JString, required = false,
                                 default = nil)
  if valid_580827 != nil:
    section.add "key", valid_580827
  var valid_580828 = query.getOrDefault("prettyPrint")
  valid_580828 = validateParameter(valid_580828, JBool, required = false,
                                 default = newJBool(true))
  if valid_580828 != nil:
    section.add "prettyPrint", valid_580828
  var valid_580829 = query.getOrDefault("oauth_token")
  valid_580829 = validateParameter(valid_580829, JString, required = false,
                                 default = nil)
  if valid_580829 != nil:
    section.add "oauth_token", valid_580829
  var valid_580830 = query.getOrDefault("alt")
  valid_580830 = validateParameter(valid_580830, JString, required = false,
                                 default = newJString("json"))
  if valid_580830 != nil:
    section.add "alt", valid_580830
  var valid_580831 = query.getOrDefault("userIp")
  valid_580831 = validateParameter(valid_580831, JString, required = false,
                                 default = nil)
  if valid_580831 != nil:
    section.add "userIp", valid_580831
  var valid_580832 = query.getOrDefault("quotaUser")
  valid_580832 = validateParameter(valid_580832, JString, required = false,
                                 default = nil)
  if valid_580832 != nil:
    section.add "quotaUser", valid_580832
  var valid_580833 = query.getOrDefault("fields")
  valid_580833 = validateParameter(valid_580833, JString, required = false,
                                 default = nil)
  if valid_580833 != nil:
    section.add "fields", valid_580833
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580835: Call_ContentOrdersCancellineitem_580822; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a line item, making a full refund.
  ## 
  let valid = call_580835.validator(path, query, header, formData, body)
  let scheme = call_580835.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580835.url(scheme.get, call_580835.host, call_580835.base,
                         call_580835.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580835, url, valid)

proc call*(call_580836: Call_ContentOrdersCancellineitem_580822;
          merchantId: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentOrdersCancellineitem
  ## Cancels a line item, making a full refund.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order.
  var path_580837 = newJObject()
  var query_580838 = newJObject()
  var body_580839 = newJObject()
  add(query_580838, "key", newJString(key))
  add(query_580838, "prettyPrint", newJBool(prettyPrint))
  add(query_580838, "oauth_token", newJString(oauthToken))
  add(query_580838, "alt", newJString(alt))
  add(query_580838, "userIp", newJString(userIp))
  add(query_580838, "quotaUser", newJString(quotaUser))
  add(path_580837, "merchantId", newJString(merchantId))
  if body != nil:
    body_580839 = body
  add(query_580838, "fields", newJString(fields))
  add(path_580837, "orderId", newJString(orderId))
  result = call_580836.call(path_580837, query_580838, nil, nil, body_580839)

var contentOrdersCancellineitem* = Call_ContentOrdersCancellineitem_580822(
    name: "contentOrdersCancellineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/cancelLineItem",
    validator: validate_ContentOrdersCancellineitem_580823, base: "/content/v2",
    url: url_ContentOrdersCancellineitem_580824, schemes: {Scheme.Https})
type
  Call_ContentOrdersInstorerefundlineitem_580840 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersInstorerefundlineitem_580842(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentOrdersInstorerefundlineitem_580841(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deprecated. Notifies that item return and refund was handled directly by merchant outside of Google payments processing (e.g. cash refund done in store).
  ## Note: We recommend calling the returnrefundlineitem method to refund in-store returns. We will issue the refund directly to the customer. This helps to prevent possible differences arising between merchant and Google transaction records. We also recommend having the point of sale system communicate with Google to ensure that customers do not receive a double refund by first refunding via Google then via an in-store return.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580843 = path.getOrDefault("merchantId")
  valid_580843 = validateParameter(valid_580843, JString, required = true,
                                 default = nil)
  if valid_580843 != nil:
    section.add "merchantId", valid_580843
  var valid_580844 = path.getOrDefault("orderId")
  valid_580844 = validateParameter(valid_580844, JString, required = true,
                                 default = nil)
  if valid_580844 != nil:
    section.add "orderId", valid_580844
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580845 = query.getOrDefault("key")
  valid_580845 = validateParameter(valid_580845, JString, required = false,
                                 default = nil)
  if valid_580845 != nil:
    section.add "key", valid_580845
  var valid_580846 = query.getOrDefault("prettyPrint")
  valid_580846 = validateParameter(valid_580846, JBool, required = false,
                                 default = newJBool(true))
  if valid_580846 != nil:
    section.add "prettyPrint", valid_580846
  var valid_580847 = query.getOrDefault("oauth_token")
  valid_580847 = validateParameter(valid_580847, JString, required = false,
                                 default = nil)
  if valid_580847 != nil:
    section.add "oauth_token", valid_580847
  var valid_580848 = query.getOrDefault("alt")
  valid_580848 = validateParameter(valid_580848, JString, required = false,
                                 default = newJString("json"))
  if valid_580848 != nil:
    section.add "alt", valid_580848
  var valid_580849 = query.getOrDefault("userIp")
  valid_580849 = validateParameter(valid_580849, JString, required = false,
                                 default = nil)
  if valid_580849 != nil:
    section.add "userIp", valid_580849
  var valid_580850 = query.getOrDefault("quotaUser")
  valid_580850 = validateParameter(valid_580850, JString, required = false,
                                 default = nil)
  if valid_580850 != nil:
    section.add "quotaUser", valid_580850
  var valid_580851 = query.getOrDefault("fields")
  valid_580851 = validateParameter(valid_580851, JString, required = false,
                                 default = nil)
  if valid_580851 != nil:
    section.add "fields", valid_580851
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580853: Call_ContentOrdersInstorerefundlineitem_580840;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deprecated. Notifies that item return and refund was handled directly by merchant outside of Google payments processing (e.g. cash refund done in store).
  ## Note: We recommend calling the returnrefundlineitem method to refund in-store returns. We will issue the refund directly to the customer. This helps to prevent possible differences arising between merchant and Google transaction records. We also recommend having the point of sale system communicate with Google to ensure that customers do not receive a double refund by first refunding via Google then via an in-store return.
  ## 
  let valid = call_580853.validator(path, query, header, formData, body)
  let scheme = call_580853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580853.url(scheme.get, call_580853.host, call_580853.base,
                         call_580853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580853, url, valid)

proc call*(call_580854: Call_ContentOrdersInstorerefundlineitem_580840;
          merchantId: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentOrdersInstorerefundlineitem
  ## Deprecated. Notifies that item return and refund was handled directly by merchant outside of Google payments processing (e.g. cash refund done in store).
  ## Note: We recommend calling the returnrefundlineitem method to refund in-store returns. We will issue the refund directly to the customer. This helps to prevent possible differences arising between merchant and Google transaction records. We also recommend having the point of sale system communicate with Google to ensure that customers do not receive a double refund by first refunding via Google then via an in-store return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order.
  var path_580855 = newJObject()
  var query_580856 = newJObject()
  var body_580857 = newJObject()
  add(query_580856, "key", newJString(key))
  add(query_580856, "prettyPrint", newJBool(prettyPrint))
  add(query_580856, "oauth_token", newJString(oauthToken))
  add(query_580856, "alt", newJString(alt))
  add(query_580856, "userIp", newJString(userIp))
  add(query_580856, "quotaUser", newJString(quotaUser))
  add(path_580855, "merchantId", newJString(merchantId))
  if body != nil:
    body_580857 = body
  add(query_580856, "fields", newJString(fields))
  add(path_580855, "orderId", newJString(orderId))
  result = call_580854.call(path_580855, query_580856, nil, nil, body_580857)

var contentOrdersInstorerefundlineitem* = Call_ContentOrdersInstorerefundlineitem_580840(
    name: "contentOrdersInstorerefundlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/inStoreRefundLineItem",
    validator: validate_ContentOrdersInstorerefundlineitem_580841,
    base: "/content/v2", url: url_ContentOrdersInstorerefundlineitem_580842,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersRefund_580858 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersRefund_580860(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentOrdersRefund_580859(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deprecated, please use returnRefundLineItem instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order to refund.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580861 = path.getOrDefault("merchantId")
  valid_580861 = validateParameter(valid_580861, JString, required = true,
                                 default = nil)
  if valid_580861 != nil:
    section.add "merchantId", valid_580861
  var valid_580862 = path.getOrDefault("orderId")
  valid_580862 = validateParameter(valid_580862, JString, required = true,
                                 default = nil)
  if valid_580862 != nil:
    section.add "orderId", valid_580862
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580863 = query.getOrDefault("key")
  valid_580863 = validateParameter(valid_580863, JString, required = false,
                                 default = nil)
  if valid_580863 != nil:
    section.add "key", valid_580863
  var valid_580864 = query.getOrDefault("prettyPrint")
  valid_580864 = validateParameter(valid_580864, JBool, required = false,
                                 default = newJBool(true))
  if valid_580864 != nil:
    section.add "prettyPrint", valid_580864
  var valid_580865 = query.getOrDefault("oauth_token")
  valid_580865 = validateParameter(valid_580865, JString, required = false,
                                 default = nil)
  if valid_580865 != nil:
    section.add "oauth_token", valid_580865
  var valid_580866 = query.getOrDefault("alt")
  valid_580866 = validateParameter(valid_580866, JString, required = false,
                                 default = newJString("json"))
  if valid_580866 != nil:
    section.add "alt", valid_580866
  var valid_580867 = query.getOrDefault("userIp")
  valid_580867 = validateParameter(valid_580867, JString, required = false,
                                 default = nil)
  if valid_580867 != nil:
    section.add "userIp", valid_580867
  var valid_580868 = query.getOrDefault("quotaUser")
  valid_580868 = validateParameter(valid_580868, JString, required = false,
                                 default = nil)
  if valid_580868 != nil:
    section.add "quotaUser", valid_580868
  var valid_580869 = query.getOrDefault("fields")
  valid_580869 = validateParameter(valid_580869, JString, required = false,
                                 default = nil)
  if valid_580869 != nil:
    section.add "fields", valid_580869
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580871: Call_ContentOrdersRefund_580858; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated, please use returnRefundLineItem instead.
  ## 
  let valid = call_580871.validator(path, query, header, formData, body)
  let scheme = call_580871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580871.url(scheme.get, call_580871.host, call_580871.base,
                         call_580871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580871, url, valid)

proc call*(call_580872: Call_ContentOrdersRefund_580858; merchantId: string;
          orderId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentOrdersRefund
  ## Deprecated, please use returnRefundLineItem instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order to refund.
  var path_580873 = newJObject()
  var query_580874 = newJObject()
  var body_580875 = newJObject()
  add(query_580874, "key", newJString(key))
  add(query_580874, "prettyPrint", newJBool(prettyPrint))
  add(query_580874, "oauth_token", newJString(oauthToken))
  add(query_580874, "alt", newJString(alt))
  add(query_580874, "userIp", newJString(userIp))
  add(query_580874, "quotaUser", newJString(quotaUser))
  add(path_580873, "merchantId", newJString(merchantId))
  if body != nil:
    body_580875 = body
  add(query_580874, "fields", newJString(fields))
  add(path_580873, "orderId", newJString(orderId))
  result = call_580872.call(path_580873, query_580874, nil, nil, body_580875)

var contentOrdersRefund* = Call_ContentOrdersRefund_580858(
    name: "contentOrdersRefund", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/orders/{orderId}/refund",
    validator: validate_ContentOrdersRefund_580859, base: "/content/v2",
    url: url_ContentOrdersRefund_580860, schemes: {Scheme.Https})
type
  Call_ContentOrdersRejectreturnlineitem_580876 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersRejectreturnlineitem_580878(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentOrdersRejectreturnlineitem_580877(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rejects return on an line item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580879 = path.getOrDefault("merchantId")
  valid_580879 = validateParameter(valid_580879, JString, required = true,
                                 default = nil)
  if valid_580879 != nil:
    section.add "merchantId", valid_580879
  var valid_580880 = path.getOrDefault("orderId")
  valid_580880 = validateParameter(valid_580880, JString, required = true,
                                 default = nil)
  if valid_580880 != nil:
    section.add "orderId", valid_580880
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580881 = query.getOrDefault("key")
  valid_580881 = validateParameter(valid_580881, JString, required = false,
                                 default = nil)
  if valid_580881 != nil:
    section.add "key", valid_580881
  var valid_580882 = query.getOrDefault("prettyPrint")
  valid_580882 = validateParameter(valid_580882, JBool, required = false,
                                 default = newJBool(true))
  if valid_580882 != nil:
    section.add "prettyPrint", valid_580882
  var valid_580883 = query.getOrDefault("oauth_token")
  valid_580883 = validateParameter(valid_580883, JString, required = false,
                                 default = nil)
  if valid_580883 != nil:
    section.add "oauth_token", valid_580883
  var valid_580884 = query.getOrDefault("alt")
  valid_580884 = validateParameter(valid_580884, JString, required = false,
                                 default = newJString("json"))
  if valid_580884 != nil:
    section.add "alt", valid_580884
  var valid_580885 = query.getOrDefault("userIp")
  valid_580885 = validateParameter(valid_580885, JString, required = false,
                                 default = nil)
  if valid_580885 != nil:
    section.add "userIp", valid_580885
  var valid_580886 = query.getOrDefault("quotaUser")
  valid_580886 = validateParameter(valid_580886, JString, required = false,
                                 default = nil)
  if valid_580886 != nil:
    section.add "quotaUser", valid_580886
  var valid_580887 = query.getOrDefault("fields")
  valid_580887 = validateParameter(valid_580887, JString, required = false,
                                 default = nil)
  if valid_580887 != nil:
    section.add "fields", valid_580887
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580889: Call_ContentOrdersRejectreturnlineitem_580876;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rejects return on an line item.
  ## 
  let valid = call_580889.validator(path, query, header, formData, body)
  let scheme = call_580889.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580889.url(scheme.get, call_580889.host, call_580889.base,
                         call_580889.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580889, url, valid)

proc call*(call_580890: Call_ContentOrdersRejectreturnlineitem_580876;
          merchantId: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentOrdersRejectreturnlineitem
  ## Rejects return on an line item.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order.
  var path_580891 = newJObject()
  var query_580892 = newJObject()
  var body_580893 = newJObject()
  add(query_580892, "key", newJString(key))
  add(query_580892, "prettyPrint", newJBool(prettyPrint))
  add(query_580892, "oauth_token", newJString(oauthToken))
  add(query_580892, "alt", newJString(alt))
  add(query_580892, "userIp", newJString(userIp))
  add(query_580892, "quotaUser", newJString(quotaUser))
  add(path_580891, "merchantId", newJString(merchantId))
  if body != nil:
    body_580893 = body
  add(query_580892, "fields", newJString(fields))
  add(path_580891, "orderId", newJString(orderId))
  result = call_580890.call(path_580891, query_580892, nil, nil, body_580893)

var contentOrdersRejectreturnlineitem* = Call_ContentOrdersRejectreturnlineitem_580876(
    name: "contentOrdersRejectreturnlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/rejectReturnLineItem",
    validator: validate_ContentOrdersRejectreturnlineitem_580877,
    base: "/content/v2", url: url_ContentOrdersRejectreturnlineitem_580878,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersReturnlineitem_580894 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersReturnlineitem_580896(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentOrdersReturnlineitem_580895(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a line item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580897 = path.getOrDefault("merchantId")
  valid_580897 = validateParameter(valid_580897, JString, required = true,
                                 default = nil)
  if valid_580897 != nil:
    section.add "merchantId", valid_580897
  var valid_580898 = path.getOrDefault("orderId")
  valid_580898 = validateParameter(valid_580898, JString, required = true,
                                 default = nil)
  if valid_580898 != nil:
    section.add "orderId", valid_580898
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580899 = query.getOrDefault("key")
  valid_580899 = validateParameter(valid_580899, JString, required = false,
                                 default = nil)
  if valid_580899 != nil:
    section.add "key", valid_580899
  var valid_580900 = query.getOrDefault("prettyPrint")
  valid_580900 = validateParameter(valid_580900, JBool, required = false,
                                 default = newJBool(true))
  if valid_580900 != nil:
    section.add "prettyPrint", valid_580900
  var valid_580901 = query.getOrDefault("oauth_token")
  valid_580901 = validateParameter(valid_580901, JString, required = false,
                                 default = nil)
  if valid_580901 != nil:
    section.add "oauth_token", valid_580901
  var valid_580902 = query.getOrDefault("alt")
  valid_580902 = validateParameter(valid_580902, JString, required = false,
                                 default = newJString("json"))
  if valid_580902 != nil:
    section.add "alt", valid_580902
  var valid_580903 = query.getOrDefault("userIp")
  valid_580903 = validateParameter(valid_580903, JString, required = false,
                                 default = nil)
  if valid_580903 != nil:
    section.add "userIp", valid_580903
  var valid_580904 = query.getOrDefault("quotaUser")
  valid_580904 = validateParameter(valid_580904, JString, required = false,
                                 default = nil)
  if valid_580904 != nil:
    section.add "quotaUser", valid_580904
  var valid_580905 = query.getOrDefault("fields")
  valid_580905 = validateParameter(valid_580905, JString, required = false,
                                 default = nil)
  if valid_580905 != nil:
    section.add "fields", valid_580905
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580907: Call_ContentOrdersReturnlineitem_580894; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a line item.
  ## 
  let valid = call_580907.validator(path, query, header, formData, body)
  let scheme = call_580907.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580907.url(scheme.get, call_580907.host, call_580907.base,
                         call_580907.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580907, url, valid)

proc call*(call_580908: Call_ContentOrdersReturnlineitem_580894;
          merchantId: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentOrdersReturnlineitem
  ## Returns a line item.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order.
  var path_580909 = newJObject()
  var query_580910 = newJObject()
  var body_580911 = newJObject()
  add(query_580910, "key", newJString(key))
  add(query_580910, "prettyPrint", newJBool(prettyPrint))
  add(query_580910, "oauth_token", newJString(oauthToken))
  add(query_580910, "alt", newJString(alt))
  add(query_580910, "userIp", newJString(userIp))
  add(query_580910, "quotaUser", newJString(quotaUser))
  add(path_580909, "merchantId", newJString(merchantId))
  if body != nil:
    body_580911 = body
  add(query_580910, "fields", newJString(fields))
  add(path_580909, "orderId", newJString(orderId))
  result = call_580908.call(path_580909, query_580910, nil, nil, body_580911)

var contentOrdersReturnlineitem* = Call_ContentOrdersReturnlineitem_580894(
    name: "contentOrdersReturnlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/returnLineItem",
    validator: validate_ContentOrdersReturnlineitem_580895, base: "/content/v2",
    url: url_ContentOrdersReturnlineitem_580896, schemes: {Scheme.Https})
type
  Call_ContentOrdersReturnrefundlineitem_580912 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersReturnrefundlineitem_580914(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentOrdersReturnrefundlineitem_580913(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns and refunds a line item. Note that this method can only be called on fully shipped orders.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580915 = path.getOrDefault("merchantId")
  valid_580915 = validateParameter(valid_580915, JString, required = true,
                                 default = nil)
  if valid_580915 != nil:
    section.add "merchantId", valid_580915
  var valid_580916 = path.getOrDefault("orderId")
  valid_580916 = validateParameter(valid_580916, JString, required = true,
                                 default = nil)
  if valid_580916 != nil:
    section.add "orderId", valid_580916
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580917 = query.getOrDefault("key")
  valid_580917 = validateParameter(valid_580917, JString, required = false,
                                 default = nil)
  if valid_580917 != nil:
    section.add "key", valid_580917
  var valid_580918 = query.getOrDefault("prettyPrint")
  valid_580918 = validateParameter(valid_580918, JBool, required = false,
                                 default = newJBool(true))
  if valid_580918 != nil:
    section.add "prettyPrint", valid_580918
  var valid_580919 = query.getOrDefault("oauth_token")
  valid_580919 = validateParameter(valid_580919, JString, required = false,
                                 default = nil)
  if valid_580919 != nil:
    section.add "oauth_token", valid_580919
  var valid_580920 = query.getOrDefault("alt")
  valid_580920 = validateParameter(valid_580920, JString, required = false,
                                 default = newJString("json"))
  if valid_580920 != nil:
    section.add "alt", valid_580920
  var valid_580921 = query.getOrDefault("userIp")
  valid_580921 = validateParameter(valid_580921, JString, required = false,
                                 default = nil)
  if valid_580921 != nil:
    section.add "userIp", valid_580921
  var valid_580922 = query.getOrDefault("quotaUser")
  valid_580922 = validateParameter(valid_580922, JString, required = false,
                                 default = nil)
  if valid_580922 != nil:
    section.add "quotaUser", valid_580922
  var valid_580923 = query.getOrDefault("fields")
  valid_580923 = validateParameter(valid_580923, JString, required = false,
                                 default = nil)
  if valid_580923 != nil:
    section.add "fields", valid_580923
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580925: Call_ContentOrdersReturnrefundlineitem_580912;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns and refunds a line item. Note that this method can only be called on fully shipped orders.
  ## 
  let valid = call_580925.validator(path, query, header, formData, body)
  let scheme = call_580925.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580925.url(scheme.get, call_580925.host, call_580925.base,
                         call_580925.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580925, url, valid)

proc call*(call_580926: Call_ContentOrdersReturnrefundlineitem_580912;
          merchantId: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentOrdersReturnrefundlineitem
  ## Returns and refunds a line item. Note that this method can only be called on fully shipped orders.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order.
  var path_580927 = newJObject()
  var query_580928 = newJObject()
  var body_580929 = newJObject()
  add(query_580928, "key", newJString(key))
  add(query_580928, "prettyPrint", newJBool(prettyPrint))
  add(query_580928, "oauth_token", newJString(oauthToken))
  add(query_580928, "alt", newJString(alt))
  add(query_580928, "userIp", newJString(userIp))
  add(query_580928, "quotaUser", newJString(quotaUser))
  add(path_580927, "merchantId", newJString(merchantId))
  if body != nil:
    body_580929 = body
  add(query_580928, "fields", newJString(fields))
  add(path_580927, "orderId", newJString(orderId))
  result = call_580926.call(path_580927, query_580928, nil, nil, body_580929)

var contentOrdersReturnrefundlineitem* = Call_ContentOrdersReturnrefundlineitem_580912(
    name: "contentOrdersReturnrefundlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/returnRefundLineItem",
    validator: validate_ContentOrdersReturnrefundlineitem_580913,
    base: "/content/v2", url: url_ContentOrdersReturnrefundlineitem_580914,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersSetlineitemmetadata_580930 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersSetlineitemmetadata_580932(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentOrdersSetlineitemmetadata_580931(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets (or overrides if it already exists) merchant provided annotations in the form of key-value pairs. A common use case would be to supply us with additional structured information about a line item that cannot be provided via other methods. Submitted key-value pairs can be retrieved as part of the orders resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580933 = path.getOrDefault("merchantId")
  valid_580933 = validateParameter(valid_580933, JString, required = true,
                                 default = nil)
  if valid_580933 != nil:
    section.add "merchantId", valid_580933
  var valid_580934 = path.getOrDefault("orderId")
  valid_580934 = validateParameter(valid_580934, JString, required = true,
                                 default = nil)
  if valid_580934 != nil:
    section.add "orderId", valid_580934
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580935 = query.getOrDefault("key")
  valid_580935 = validateParameter(valid_580935, JString, required = false,
                                 default = nil)
  if valid_580935 != nil:
    section.add "key", valid_580935
  var valid_580936 = query.getOrDefault("prettyPrint")
  valid_580936 = validateParameter(valid_580936, JBool, required = false,
                                 default = newJBool(true))
  if valid_580936 != nil:
    section.add "prettyPrint", valid_580936
  var valid_580937 = query.getOrDefault("oauth_token")
  valid_580937 = validateParameter(valid_580937, JString, required = false,
                                 default = nil)
  if valid_580937 != nil:
    section.add "oauth_token", valid_580937
  var valid_580938 = query.getOrDefault("alt")
  valid_580938 = validateParameter(valid_580938, JString, required = false,
                                 default = newJString("json"))
  if valid_580938 != nil:
    section.add "alt", valid_580938
  var valid_580939 = query.getOrDefault("userIp")
  valid_580939 = validateParameter(valid_580939, JString, required = false,
                                 default = nil)
  if valid_580939 != nil:
    section.add "userIp", valid_580939
  var valid_580940 = query.getOrDefault("quotaUser")
  valid_580940 = validateParameter(valid_580940, JString, required = false,
                                 default = nil)
  if valid_580940 != nil:
    section.add "quotaUser", valid_580940
  var valid_580941 = query.getOrDefault("fields")
  valid_580941 = validateParameter(valid_580941, JString, required = false,
                                 default = nil)
  if valid_580941 != nil:
    section.add "fields", valid_580941
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580943: Call_ContentOrdersSetlineitemmetadata_580930;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets (or overrides if it already exists) merchant provided annotations in the form of key-value pairs. A common use case would be to supply us with additional structured information about a line item that cannot be provided via other methods. Submitted key-value pairs can be retrieved as part of the orders resource.
  ## 
  let valid = call_580943.validator(path, query, header, formData, body)
  let scheme = call_580943.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580943.url(scheme.get, call_580943.host, call_580943.base,
                         call_580943.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580943, url, valid)

proc call*(call_580944: Call_ContentOrdersSetlineitemmetadata_580930;
          merchantId: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentOrdersSetlineitemmetadata
  ## Sets (or overrides if it already exists) merchant provided annotations in the form of key-value pairs. A common use case would be to supply us with additional structured information about a line item that cannot be provided via other methods. Submitted key-value pairs can be retrieved as part of the orders resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order.
  var path_580945 = newJObject()
  var query_580946 = newJObject()
  var body_580947 = newJObject()
  add(query_580946, "key", newJString(key))
  add(query_580946, "prettyPrint", newJBool(prettyPrint))
  add(query_580946, "oauth_token", newJString(oauthToken))
  add(query_580946, "alt", newJString(alt))
  add(query_580946, "userIp", newJString(userIp))
  add(query_580946, "quotaUser", newJString(quotaUser))
  add(path_580945, "merchantId", newJString(merchantId))
  if body != nil:
    body_580947 = body
  add(query_580946, "fields", newJString(fields))
  add(path_580945, "orderId", newJString(orderId))
  result = call_580944.call(path_580945, query_580946, nil, nil, body_580947)

var contentOrdersSetlineitemmetadata* = Call_ContentOrdersSetlineitemmetadata_580930(
    name: "contentOrdersSetlineitemmetadata", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/setLineItemMetadata",
    validator: validate_ContentOrdersSetlineitemmetadata_580931,
    base: "/content/v2", url: url_ContentOrdersSetlineitemmetadata_580932,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersShiplineitems_580948 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersShiplineitems_580950(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentOrdersShiplineitems_580949(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Marks line item(s) as shipped.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580951 = path.getOrDefault("merchantId")
  valid_580951 = validateParameter(valid_580951, JString, required = true,
                                 default = nil)
  if valid_580951 != nil:
    section.add "merchantId", valid_580951
  var valid_580952 = path.getOrDefault("orderId")
  valid_580952 = validateParameter(valid_580952, JString, required = true,
                                 default = nil)
  if valid_580952 != nil:
    section.add "orderId", valid_580952
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580953 = query.getOrDefault("key")
  valid_580953 = validateParameter(valid_580953, JString, required = false,
                                 default = nil)
  if valid_580953 != nil:
    section.add "key", valid_580953
  var valid_580954 = query.getOrDefault("prettyPrint")
  valid_580954 = validateParameter(valid_580954, JBool, required = false,
                                 default = newJBool(true))
  if valid_580954 != nil:
    section.add "prettyPrint", valid_580954
  var valid_580955 = query.getOrDefault("oauth_token")
  valid_580955 = validateParameter(valid_580955, JString, required = false,
                                 default = nil)
  if valid_580955 != nil:
    section.add "oauth_token", valid_580955
  var valid_580956 = query.getOrDefault("alt")
  valid_580956 = validateParameter(valid_580956, JString, required = false,
                                 default = newJString("json"))
  if valid_580956 != nil:
    section.add "alt", valid_580956
  var valid_580957 = query.getOrDefault("userIp")
  valid_580957 = validateParameter(valid_580957, JString, required = false,
                                 default = nil)
  if valid_580957 != nil:
    section.add "userIp", valid_580957
  var valid_580958 = query.getOrDefault("quotaUser")
  valid_580958 = validateParameter(valid_580958, JString, required = false,
                                 default = nil)
  if valid_580958 != nil:
    section.add "quotaUser", valid_580958
  var valid_580959 = query.getOrDefault("fields")
  valid_580959 = validateParameter(valid_580959, JString, required = false,
                                 default = nil)
  if valid_580959 != nil:
    section.add "fields", valid_580959
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580961: Call_ContentOrdersShiplineitems_580948; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks line item(s) as shipped.
  ## 
  let valid = call_580961.validator(path, query, header, formData, body)
  let scheme = call_580961.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580961.url(scheme.get, call_580961.host, call_580961.base,
                         call_580961.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580961, url, valid)

proc call*(call_580962: Call_ContentOrdersShiplineitems_580948; merchantId: string;
          orderId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentOrdersShiplineitems
  ## Marks line item(s) as shipped.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order.
  var path_580963 = newJObject()
  var query_580964 = newJObject()
  var body_580965 = newJObject()
  add(query_580964, "key", newJString(key))
  add(query_580964, "prettyPrint", newJBool(prettyPrint))
  add(query_580964, "oauth_token", newJString(oauthToken))
  add(query_580964, "alt", newJString(alt))
  add(query_580964, "userIp", newJString(userIp))
  add(query_580964, "quotaUser", newJString(quotaUser))
  add(path_580963, "merchantId", newJString(merchantId))
  if body != nil:
    body_580965 = body
  add(query_580964, "fields", newJString(fields))
  add(path_580963, "orderId", newJString(orderId))
  result = call_580962.call(path_580963, query_580964, nil, nil, body_580965)

var contentOrdersShiplineitems* = Call_ContentOrdersShiplineitems_580948(
    name: "contentOrdersShiplineitems", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/shipLineItems",
    validator: validate_ContentOrdersShiplineitems_580949, base: "/content/v2",
    url: url_ContentOrdersShiplineitems_580950, schemes: {Scheme.Https})
type
  Call_ContentOrdersCreatetestreturn_580966 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersCreatetestreturn_580968(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentOrdersCreatetestreturn_580967(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sandbox only. Creates a test return.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580969 = path.getOrDefault("merchantId")
  valid_580969 = validateParameter(valid_580969, JString, required = true,
                                 default = nil)
  if valid_580969 != nil:
    section.add "merchantId", valid_580969
  var valid_580970 = path.getOrDefault("orderId")
  valid_580970 = validateParameter(valid_580970, JString, required = true,
                                 default = nil)
  if valid_580970 != nil:
    section.add "orderId", valid_580970
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580971 = query.getOrDefault("key")
  valid_580971 = validateParameter(valid_580971, JString, required = false,
                                 default = nil)
  if valid_580971 != nil:
    section.add "key", valid_580971
  var valid_580972 = query.getOrDefault("prettyPrint")
  valid_580972 = validateParameter(valid_580972, JBool, required = false,
                                 default = newJBool(true))
  if valid_580972 != nil:
    section.add "prettyPrint", valid_580972
  var valid_580973 = query.getOrDefault("oauth_token")
  valid_580973 = validateParameter(valid_580973, JString, required = false,
                                 default = nil)
  if valid_580973 != nil:
    section.add "oauth_token", valid_580973
  var valid_580974 = query.getOrDefault("alt")
  valid_580974 = validateParameter(valid_580974, JString, required = false,
                                 default = newJString("json"))
  if valid_580974 != nil:
    section.add "alt", valid_580974
  var valid_580975 = query.getOrDefault("userIp")
  valid_580975 = validateParameter(valid_580975, JString, required = false,
                                 default = nil)
  if valid_580975 != nil:
    section.add "userIp", valid_580975
  var valid_580976 = query.getOrDefault("quotaUser")
  valid_580976 = validateParameter(valid_580976, JString, required = false,
                                 default = nil)
  if valid_580976 != nil:
    section.add "quotaUser", valid_580976
  var valid_580977 = query.getOrDefault("fields")
  valid_580977 = validateParameter(valid_580977, JString, required = false,
                                 default = nil)
  if valid_580977 != nil:
    section.add "fields", valid_580977
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580979: Call_ContentOrdersCreatetestreturn_580966; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Creates a test return.
  ## 
  let valid = call_580979.validator(path, query, header, formData, body)
  let scheme = call_580979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580979.url(scheme.get, call_580979.host, call_580979.base,
                         call_580979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580979, url, valid)

proc call*(call_580980: Call_ContentOrdersCreatetestreturn_580966;
          merchantId: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentOrdersCreatetestreturn
  ## Sandbox only. Creates a test return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order.
  var path_580981 = newJObject()
  var query_580982 = newJObject()
  var body_580983 = newJObject()
  add(query_580982, "key", newJString(key))
  add(query_580982, "prettyPrint", newJBool(prettyPrint))
  add(query_580982, "oauth_token", newJString(oauthToken))
  add(query_580982, "alt", newJString(alt))
  add(query_580982, "userIp", newJString(userIp))
  add(query_580982, "quotaUser", newJString(quotaUser))
  add(path_580981, "merchantId", newJString(merchantId))
  if body != nil:
    body_580983 = body
  add(query_580982, "fields", newJString(fields))
  add(path_580981, "orderId", newJString(orderId))
  result = call_580980.call(path_580981, query_580982, nil, nil, body_580983)

var contentOrdersCreatetestreturn* = Call_ContentOrdersCreatetestreturn_580966(
    name: "contentOrdersCreatetestreturn", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/testreturn",
    validator: validate_ContentOrdersCreatetestreturn_580967, base: "/content/v2",
    url: url_ContentOrdersCreatetestreturn_580968, schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdatelineitemshippingdetails_580984 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersUpdatelineitemshippingdetails_580986(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentOrdersUpdatelineitemshippingdetails_580985(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates ship by and delivery by dates for a line item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_580987 = path.getOrDefault("merchantId")
  valid_580987 = validateParameter(valid_580987, JString, required = true,
                                 default = nil)
  if valid_580987 != nil:
    section.add "merchantId", valid_580987
  var valid_580988 = path.getOrDefault("orderId")
  valid_580988 = validateParameter(valid_580988, JString, required = true,
                                 default = nil)
  if valid_580988 != nil:
    section.add "orderId", valid_580988
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580989 = query.getOrDefault("key")
  valid_580989 = validateParameter(valid_580989, JString, required = false,
                                 default = nil)
  if valid_580989 != nil:
    section.add "key", valid_580989
  var valid_580990 = query.getOrDefault("prettyPrint")
  valid_580990 = validateParameter(valid_580990, JBool, required = false,
                                 default = newJBool(true))
  if valid_580990 != nil:
    section.add "prettyPrint", valid_580990
  var valid_580991 = query.getOrDefault("oauth_token")
  valid_580991 = validateParameter(valid_580991, JString, required = false,
                                 default = nil)
  if valid_580991 != nil:
    section.add "oauth_token", valid_580991
  var valid_580992 = query.getOrDefault("alt")
  valid_580992 = validateParameter(valid_580992, JString, required = false,
                                 default = newJString("json"))
  if valid_580992 != nil:
    section.add "alt", valid_580992
  var valid_580993 = query.getOrDefault("userIp")
  valid_580993 = validateParameter(valid_580993, JString, required = false,
                                 default = nil)
  if valid_580993 != nil:
    section.add "userIp", valid_580993
  var valid_580994 = query.getOrDefault("quotaUser")
  valid_580994 = validateParameter(valid_580994, JString, required = false,
                                 default = nil)
  if valid_580994 != nil:
    section.add "quotaUser", valid_580994
  var valid_580995 = query.getOrDefault("fields")
  valid_580995 = validateParameter(valid_580995, JString, required = false,
                                 default = nil)
  if valid_580995 != nil:
    section.add "fields", valid_580995
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580997: Call_ContentOrdersUpdatelineitemshippingdetails_580984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates ship by and delivery by dates for a line item.
  ## 
  let valid = call_580997.validator(path, query, header, formData, body)
  let scheme = call_580997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580997.url(scheme.get, call_580997.host, call_580997.base,
                         call_580997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580997, url, valid)

proc call*(call_580998: Call_ContentOrdersUpdatelineitemshippingdetails_580984;
          merchantId: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentOrdersUpdatelineitemshippingdetails
  ## Updates ship by and delivery by dates for a line item.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order.
  var path_580999 = newJObject()
  var query_581000 = newJObject()
  var body_581001 = newJObject()
  add(query_581000, "key", newJString(key))
  add(query_581000, "prettyPrint", newJBool(prettyPrint))
  add(query_581000, "oauth_token", newJString(oauthToken))
  add(query_581000, "alt", newJString(alt))
  add(query_581000, "userIp", newJString(userIp))
  add(query_581000, "quotaUser", newJString(quotaUser))
  add(path_580999, "merchantId", newJString(merchantId))
  if body != nil:
    body_581001 = body
  add(query_581000, "fields", newJString(fields))
  add(path_580999, "orderId", newJString(orderId))
  result = call_580998.call(path_580999, query_581000, nil, nil, body_581001)

var contentOrdersUpdatelineitemshippingdetails* = Call_ContentOrdersUpdatelineitemshippingdetails_580984(
    name: "contentOrdersUpdatelineitemshippingdetails", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateLineItemShippingDetails",
    validator: validate_ContentOrdersUpdatelineitemshippingdetails_580985,
    base: "/content/v2", url: url_ContentOrdersUpdatelineitemshippingdetails_580986,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdatemerchantorderid_581002 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersUpdatemerchantorderid_581004(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentOrdersUpdatemerchantorderid_581003(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the merchant order ID for a given order.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_581005 = path.getOrDefault("merchantId")
  valid_581005 = validateParameter(valid_581005, JString, required = true,
                                 default = nil)
  if valid_581005 != nil:
    section.add "merchantId", valid_581005
  var valid_581006 = path.getOrDefault("orderId")
  valid_581006 = validateParameter(valid_581006, JString, required = true,
                                 default = nil)
  if valid_581006 != nil:
    section.add "orderId", valid_581006
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581007 = query.getOrDefault("key")
  valid_581007 = validateParameter(valid_581007, JString, required = false,
                                 default = nil)
  if valid_581007 != nil:
    section.add "key", valid_581007
  var valid_581008 = query.getOrDefault("prettyPrint")
  valid_581008 = validateParameter(valid_581008, JBool, required = false,
                                 default = newJBool(true))
  if valid_581008 != nil:
    section.add "prettyPrint", valid_581008
  var valid_581009 = query.getOrDefault("oauth_token")
  valid_581009 = validateParameter(valid_581009, JString, required = false,
                                 default = nil)
  if valid_581009 != nil:
    section.add "oauth_token", valid_581009
  var valid_581010 = query.getOrDefault("alt")
  valid_581010 = validateParameter(valid_581010, JString, required = false,
                                 default = newJString("json"))
  if valid_581010 != nil:
    section.add "alt", valid_581010
  var valid_581011 = query.getOrDefault("userIp")
  valid_581011 = validateParameter(valid_581011, JString, required = false,
                                 default = nil)
  if valid_581011 != nil:
    section.add "userIp", valid_581011
  var valid_581012 = query.getOrDefault("quotaUser")
  valid_581012 = validateParameter(valid_581012, JString, required = false,
                                 default = nil)
  if valid_581012 != nil:
    section.add "quotaUser", valid_581012
  var valid_581013 = query.getOrDefault("fields")
  valid_581013 = validateParameter(valid_581013, JString, required = false,
                                 default = nil)
  if valid_581013 != nil:
    section.add "fields", valid_581013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_581015: Call_ContentOrdersUpdatemerchantorderid_581002;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the merchant order ID for a given order.
  ## 
  let valid = call_581015.validator(path, query, header, formData, body)
  let scheme = call_581015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581015.url(scheme.get, call_581015.host, call_581015.base,
                         call_581015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581015, url, valid)

proc call*(call_581016: Call_ContentOrdersUpdatemerchantorderid_581002;
          merchantId: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentOrdersUpdatemerchantorderid
  ## Updates the merchant order ID for a given order.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order.
  var path_581017 = newJObject()
  var query_581018 = newJObject()
  var body_581019 = newJObject()
  add(query_581018, "key", newJString(key))
  add(query_581018, "prettyPrint", newJBool(prettyPrint))
  add(query_581018, "oauth_token", newJString(oauthToken))
  add(query_581018, "alt", newJString(alt))
  add(query_581018, "userIp", newJString(userIp))
  add(query_581018, "quotaUser", newJString(quotaUser))
  add(path_581017, "merchantId", newJString(merchantId))
  if body != nil:
    body_581019 = body
  add(query_581018, "fields", newJString(fields))
  add(path_581017, "orderId", newJString(orderId))
  result = call_581016.call(path_581017, query_581018, nil, nil, body_581019)

var contentOrdersUpdatemerchantorderid* = Call_ContentOrdersUpdatemerchantorderid_581002(
    name: "contentOrdersUpdatemerchantorderid", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateMerchantOrderId",
    validator: validate_ContentOrdersUpdatemerchantorderid_581003,
    base: "/content/v2", url: url_ContentOrdersUpdatemerchantorderid_581004,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdateshipment_581020 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersUpdateshipment_581022(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentOrdersUpdateshipment_581021(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a shipment's status, carrier, and/or tracking ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_581023 = path.getOrDefault("merchantId")
  valid_581023 = validateParameter(valid_581023, JString, required = true,
                                 default = nil)
  if valid_581023 != nil:
    section.add "merchantId", valid_581023
  var valid_581024 = path.getOrDefault("orderId")
  valid_581024 = validateParameter(valid_581024, JString, required = true,
                                 default = nil)
  if valid_581024 != nil:
    section.add "orderId", valid_581024
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581025 = query.getOrDefault("key")
  valid_581025 = validateParameter(valid_581025, JString, required = false,
                                 default = nil)
  if valid_581025 != nil:
    section.add "key", valid_581025
  var valid_581026 = query.getOrDefault("prettyPrint")
  valid_581026 = validateParameter(valid_581026, JBool, required = false,
                                 default = newJBool(true))
  if valid_581026 != nil:
    section.add "prettyPrint", valid_581026
  var valid_581027 = query.getOrDefault("oauth_token")
  valid_581027 = validateParameter(valid_581027, JString, required = false,
                                 default = nil)
  if valid_581027 != nil:
    section.add "oauth_token", valid_581027
  var valid_581028 = query.getOrDefault("alt")
  valid_581028 = validateParameter(valid_581028, JString, required = false,
                                 default = newJString("json"))
  if valid_581028 != nil:
    section.add "alt", valid_581028
  var valid_581029 = query.getOrDefault("userIp")
  valid_581029 = validateParameter(valid_581029, JString, required = false,
                                 default = nil)
  if valid_581029 != nil:
    section.add "userIp", valid_581029
  var valid_581030 = query.getOrDefault("quotaUser")
  valid_581030 = validateParameter(valid_581030, JString, required = false,
                                 default = nil)
  if valid_581030 != nil:
    section.add "quotaUser", valid_581030
  var valid_581031 = query.getOrDefault("fields")
  valid_581031 = validateParameter(valid_581031, JString, required = false,
                                 default = nil)
  if valid_581031 != nil:
    section.add "fields", valid_581031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_581033: Call_ContentOrdersUpdateshipment_581020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a shipment's status, carrier, and/or tracking ID.
  ## 
  let valid = call_581033.validator(path, query, header, formData, body)
  let scheme = call_581033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581033.url(scheme.get, call_581033.host, call_581033.base,
                         call_581033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581033, url, valid)

proc call*(call_581034: Call_ContentOrdersUpdateshipment_581020;
          merchantId: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentOrdersUpdateshipment
  ## Updates a shipment's status, carrier, and/or tracking ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the order.
  var path_581035 = newJObject()
  var query_581036 = newJObject()
  var body_581037 = newJObject()
  add(query_581036, "key", newJString(key))
  add(query_581036, "prettyPrint", newJBool(prettyPrint))
  add(query_581036, "oauth_token", newJString(oauthToken))
  add(query_581036, "alt", newJString(alt))
  add(query_581036, "userIp", newJString(userIp))
  add(query_581036, "quotaUser", newJString(quotaUser))
  add(path_581035, "merchantId", newJString(merchantId))
  if body != nil:
    body_581037 = body
  add(query_581036, "fields", newJString(fields))
  add(path_581035, "orderId", newJString(orderId))
  result = call_581034.call(path_581035, query_581036, nil, nil, body_581037)

var contentOrdersUpdateshipment* = Call_ContentOrdersUpdateshipment_581020(
    name: "contentOrdersUpdateshipment", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateShipment",
    validator: validate_ContentOrdersUpdateshipment_581021, base: "/content/v2",
    url: url_ContentOrdersUpdateshipment_581022, schemes: {Scheme.Https})
type
  Call_ContentOrdersGetbymerchantorderid_581038 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersGetbymerchantorderid_581040(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentOrdersGetbymerchantorderid_581039(path: JsonNode;
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
  var valid_581041 = path.getOrDefault("merchantOrderId")
  valid_581041 = validateParameter(valid_581041, JString, required = true,
                                 default = nil)
  if valid_581041 != nil:
    section.add "merchantOrderId", valid_581041
  var valid_581042 = path.getOrDefault("merchantId")
  valid_581042 = validateParameter(valid_581042, JString, required = true,
                                 default = nil)
  if valid_581042 != nil:
    section.add "merchantId", valid_581042
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581043 = query.getOrDefault("key")
  valid_581043 = validateParameter(valid_581043, JString, required = false,
                                 default = nil)
  if valid_581043 != nil:
    section.add "key", valid_581043
  var valid_581044 = query.getOrDefault("prettyPrint")
  valid_581044 = validateParameter(valid_581044, JBool, required = false,
                                 default = newJBool(true))
  if valid_581044 != nil:
    section.add "prettyPrint", valid_581044
  var valid_581045 = query.getOrDefault("oauth_token")
  valid_581045 = validateParameter(valid_581045, JString, required = false,
                                 default = nil)
  if valid_581045 != nil:
    section.add "oauth_token", valid_581045
  var valid_581046 = query.getOrDefault("alt")
  valid_581046 = validateParameter(valid_581046, JString, required = false,
                                 default = newJString("json"))
  if valid_581046 != nil:
    section.add "alt", valid_581046
  var valid_581047 = query.getOrDefault("userIp")
  valid_581047 = validateParameter(valid_581047, JString, required = false,
                                 default = nil)
  if valid_581047 != nil:
    section.add "userIp", valid_581047
  var valid_581048 = query.getOrDefault("quotaUser")
  valid_581048 = validateParameter(valid_581048, JString, required = false,
                                 default = nil)
  if valid_581048 != nil:
    section.add "quotaUser", valid_581048
  var valid_581049 = query.getOrDefault("fields")
  valid_581049 = validateParameter(valid_581049, JString, required = false,
                                 default = nil)
  if valid_581049 != nil:
    section.add "fields", valid_581049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581050: Call_ContentOrdersGetbymerchantorderid_581038;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves an order using merchant order ID.
  ## 
  let valid = call_581050.validator(path, query, header, formData, body)
  let scheme = call_581050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581050.url(scheme.get, call_581050.host, call_581050.base,
                         call_581050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581050, url, valid)

proc call*(call_581051: Call_ContentOrdersGetbymerchantorderid_581038;
          merchantOrderId: string; merchantId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## contentOrdersGetbymerchantorderid
  ## Retrieves an order using merchant order ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   merchantOrderId: string (required)
  ##                  : The merchant order ID to be looked for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581052 = newJObject()
  var query_581053 = newJObject()
  add(query_581053, "key", newJString(key))
  add(query_581053, "prettyPrint", newJBool(prettyPrint))
  add(query_581053, "oauth_token", newJString(oauthToken))
  add(path_581052, "merchantOrderId", newJString(merchantOrderId))
  add(query_581053, "alt", newJString(alt))
  add(query_581053, "userIp", newJString(userIp))
  add(query_581053, "quotaUser", newJString(quotaUser))
  add(path_581052, "merchantId", newJString(merchantId))
  add(query_581053, "fields", newJString(fields))
  result = call_581051.call(path_581052, query_581053, nil, nil, nil)

var contentOrdersGetbymerchantorderid* = Call_ContentOrdersGetbymerchantorderid_581038(
    name: "contentOrdersGetbymerchantorderid", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/ordersbymerchantid/{merchantOrderId}",
    validator: validate_ContentOrdersGetbymerchantorderid_581039,
    base: "/content/v2", url: url_ContentOrdersGetbymerchantorderid_581040,
    schemes: {Scheme.Https})
type
  Call_ContentPosInventory_581054 = ref object of OpenApiRestCall_579373
proc url_ContentPosInventory_581056(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentPosInventory_581055(path: JsonNode; query: JsonNode;
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
  var valid_581057 = path.getOrDefault("targetMerchantId")
  valid_581057 = validateParameter(valid_581057, JString, required = true,
                                 default = nil)
  if valid_581057 != nil:
    section.add "targetMerchantId", valid_581057
  var valid_581058 = path.getOrDefault("merchantId")
  valid_581058 = validateParameter(valid_581058, JString, required = true,
                                 default = nil)
  if valid_581058 != nil:
    section.add "merchantId", valid_581058
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581059 = query.getOrDefault("key")
  valid_581059 = validateParameter(valid_581059, JString, required = false,
                                 default = nil)
  if valid_581059 != nil:
    section.add "key", valid_581059
  var valid_581060 = query.getOrDefault("prettyPrint")
  valid_581060 = validateParameter(valid_581060, JBool, required = false,
                                 default = newJBool(true))
  if valid_581060 != nil:
    section.add "prettyPrint", valid_581060
  var valid_581061 = query.getOrDefault("oauth_token")
  valid_581061 = validateParameter(valid_581061, JString, required = false,
                                 default = nil)
  if valid_581061 != nil:
    section.add "oauth_token", valid_581061
  var valid_581062 = query.getOrDefault("alt")
  valid_581062 = validateParameter(valid_581062, JString, required = false,
                                 default = newJString("json"))
  if valid_581062 != nil:
    section.add "alt", valid_581062
  var valid_581063 = query.getOrDefault("userIp")
  valid_581063 = validateParameter(valid_581063, JString, required = false,
                                 default = nil)
  if valid_581063 != nil:
    section.add "userIp", valid_581063
  var valid_581064 = query.getOrDefault("quotaUser")
  valid_581064 = validateParameter(valid_581064, JString, required = false,
                                 default = nil)
  if valid_581064 != nil:
    section.add "quotaUser", valid_581064
  var valid_581065 = query.getOrDefault("dryRun")
  valid_581065 = validateParameter(valid_581065, JBool, required = false, default = nil)
  if valid_581065 != nil:
    section.add "dryRun", valid_581065
  var valid_581066 = query.getOrDefault("fields")
  valid_581066 = validateParameter(valid_581066, JString, required = false,
                                 default = nil)
  if valid_581066 != nil:
    section.add "fields", valid_581066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_581068: Call_ContentPosInventory_581054; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit inventory for the given merchant.
  ## 
  let valid = call_581068.validator(path, query, header, formData, body)
  let scheme = call_581068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581068.url(scheme.get, call_581068.host, call_581068.base,
                         call_581068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581068, url, valid)

proc call*(call_581069: Call_ContentPosInventory_581054; targetMerchantId: string;
          merchantId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; dryRun: bool = false; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentPosInventory
  ## Submit inventory for the given merchant.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   targetMerchantId: string (required)
  ##                   : The ID of the target merchant.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the POS or inventory data provider.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581070 = newJObject()
  var query_581071 = newJObject()
  var body_581072 = newJObject()
  add(query_581071, "key", newJString(key))
  add(query_581071, "prettyPrint", newJBool(prettyPrint))
  add(query_581071, "oauth_token", newJString(oauthToken))
  add(path_581070, "targetMerchantId", newJString(targetMerchantId))
  add(query_581071, "alt", newJString(alt))
  add(query_581071, "userIp", newJString(userIp))
  add(query_581071, "quotaUser", newJString(quotaUser))
  add(path_581070, "merchantId", newJString(merchantId))
  add(query_581071, "dryRun", newJBool(dryRun))
  if body != nil:
    body_581072 = body
  add(query_581071, "fields", newJString(fields))
  result = call_581069.call(path_581070, query_581071, nil, nil, body_581072)

var contentPosInventory* = Call_ContentPosInventory_581054(
    name: "contentPosInventory", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/inventory",
    validator: validate_ContentPosInventory_581055, base: "/content/v2",
    url: url_ContentPosInventory_581056, schemes: {Scheme.Https})
type
  Call_ContentPosSale_581073 = ref object of OpenApiRestCall_579373
proc url_ContentPosSale_581075(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentPosSale_581074(path: JsonNode; query: JsonNode;
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
  var valid_581076 = path.getOrDefault("targetMerchantId")
  valid_581076 = validateParameter(valid_581076, JString, required = true,
                                 default = nil)
  if valid_581076 != nil:
    section.add "targetMerchantId", valid_581076
  var valid_581077 = path.getOrDefault("merchantId")
  valid_581077 = validateParameter(valid_581077, JString, required = true,
                                 default = nil)
  if valid_581077 != nil:
    section.add "merchantId", valid_581077
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581078 = query.getOrDefault("key")
  valid_581078 = validateParameter(valid_581078, JString, required = false,
                                 default = nil)
  if valid_581078 != nil:
    section.add "key", valid_581078
  var valid_581079 = query.getOrDefault("prettyPrint")
  valid_581079 = validateParameter(valid_581079, JBool, required = false,
                                 default = newJBool(true))
  if valid_581079 != nil:
    section.add "prettyPrint", valid_581079
  var valid_581080 = query.getOrDefault("oauth_token")
  valid_581080 = validateParameter(valid_581080, JString, required = false,
                                 default = nil)
  if valid_581080 != nil:
    section.add "oauth_token", valid_581080
  var valid_581081 = query.getOrDefault("alt")
  valid_581081 = validateParameter(valid_581081, JString, required = false,
                                 default = newJString("json"))
  if valid_581081 != nil:
    section.add "alt", valid_581081
  var valid_581082 = query.getOrDefault("userIp")
  valid_581082 = validateParameter(valid_581082, JString, required = false,
                                 default = nil)
  if valid_581082 != nil:
    section.add "userIp", valid_581082
  var valid_581083 = query.getOrDefault("quotaUser")
  valid_581083 = validateParameter(valid_581083, JString, required = false,
                                 default = nil)
  if valid_581083 != nil:
    section.add "quotaUser", valid_581083
  var valid_581084 = query.getOrDefault("dryRun")
  valid_581084 = validateParameter(valid_581084, JBool, required = false, default = nil)
  if valid_581084 != nil:
    section.add "dryRun", valid_581084
  var valid_581085 = query.getOrDefault("fields")
  valid_581085 = validateParameter(valid_581085, JString, required = false,
                                 default = nil)
  if valid_581085 != nil:
    section.add "fields", valid_581085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_581087: Call_ContentPosSale_581073; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit a sale event for the given merchant.
  ## 
  let valid = call_581087.validator(path, query, header, formData, body)
  let scheme = call_581087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581087.url(scheme.get, call_581087.host, call_581087.base,
                         call_581087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581087, url, valid)

proc call*(call_581088: Call_ContentPosSale_581073; targetMerchantId: string;
          merchantId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; dryRun: bool = false; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentPosSale
  ## Submit a sale event for the given merchant.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   targetMerchantId: string (required)
  ##                   : The ID of the target merchant.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the POS or inventory data provider.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581089 = newJObject()
  var query_581090 = newJObject()
  var body_581091 = newJObject()
  add(query_581090, "key", newJString(key))
  add(query_581090, "prettyPrint", newJBool(prettyPrint))
  add(query_581090, "oauth_token", newJString(oauthToken))
  add(path_581089, "targetMerchantId", newJString(targetMerchantId))
  add(query_581090, "alt", newJString(alt))
  add(query_581090, "userIp", newJString(userIp))
  add(query_581090, "quotaUser", newJString(quotaUser))
  add(path_581089, "merchantId", newJString(merchantId))
  add(query_581090, "dryRun", newJBool(dryRun))
  if body != nil:
    body_581091 = body
  add(query_581090, "fields", newJString(fields))
  result = call_581088.call(path_581089, query_581090, nil, nil, body_581091)

var contentPosSale* = Call_ContentPosSale_581073(name: "contentPosSale",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/sale",
    validator: validate_ContentPosSale_581074, base: "/content/v2",
    url: url_ContentPosSale_581075, schemes: {Scheme.Https})
type
  Call_ContentPosInsert_581108 = ref object of OpenApiRestCall_579373
proc url_ContentPosInsert_581110(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentPosInsert_581109(path: JsonNode; query: JsonNode;
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
  var valid_581111 = path.getOrDefault("targetMerchantId")
  valid_581111 = validateParameter(valid_581111, JString, required = true,
                                 default = nil)
  if valid_581111 != nil:
    section.add "targetMerchantId", valid_581111
  var valid_581112 = path.getOrDefault("merchantId")
  valid_581112 = validateParameter(valid_581112, JString, required = true,
                                 default = nil)
  if valid_581112 != nil:
    section.add "merchantId", valid_581112
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581113 = query.getOrDefault("key")
  valid_581113 = validateParameter(valid_581113, JString, required = false,
                                 default = nil)
  if valid_581113 != nil:
    section.add "key", valid_581113
  var valid_581114 = query.getOrDefault("prettyPrint")
  valid_581114 = validateParameter(valid_581114, JBool, required = false,
                                 default = newJBool(true))
  if valid_581114 != nil:
    section.add "prettyPrint", valid_581114
  var valid_581115 = query.getOrDefault("oauth_token")
  valid_581115 = validateParameter(valid_581115, JString, required = false,
                                 default = nil)
  if valid_581115 != nil:
    section.add "oauth_token", valid_581115
  var valid_581116 = query.getOrDefault("alt")
  valid_581116 = validateParameter(valid_581116, JString, required = false,
                                 default = newJString("json"))
  if valid_581116 != nil:
    section.add "alt", valid_581116
  var valid_581117 = query.getOrDefault("userIp")
  valid_581117 = validateParameter(valid_581117, JString, required = false,
                                 default = nil)
  if valid_581117 != nil:
    section.add "userIp", valid_581117
  var valid_581118 = query.getOrDefault("quotaUser")
  valid_581118 = validateParameter(valid_581118, JString, required = false,
                                 default = nil)
  if valid_581118 != nil:
    section.add "quotaUser", valid_581118
  var valid_581119 = query.getOrDefault("dryRun")
  valid_581119 = validateParameter(valid_581119, JBool, required = false, default = nil)
  if valid_581119 != nil:
    section.add "dryRun", valid_581119
  var valid_581120 = query.getOrDefault("fields")
  valid_581120 = validateParameter(valid_581120, JString, required = false,
                                 default = nil)
  if valid_581120 != nil:
    section.add "fields", valid_581120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_581122: Call_ContentPosInsert_581108; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a store for the given merchant.
  ## 
  let valid = call_581122.validator(path, query, header, formData, body)
  let scheme = call_581122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581122.url(scheme.get, call_581122.host, call_581122.base,
                         call_581122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581122, url, valid)

proc call*(call_581123: Call_ContentPosInsert_581108; targetMerchantId: string;
          merchantId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; dryRun: bool = false; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentPosInsert
  ## Creates a store for the given merchant.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   targetMerchantId: string (required)
  ##                   : The ID of the target merchant.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the POS or inventory data provider.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581124 = newJObject()
  var query_581125 = newJObject()
  var body_581126 = newJObject()
  add(query_581125, "key", newJString(key))
  add(query_581125, "prettyPrint", newJBool(prettyPrint))
  add(query_581125, "oauth_token", newJString(oauthToken))
  add(path_581124, "targetMerchantId", newJString(targetMerchantId))
  add(query_581125, "alt", newJString(alt))
  add(query_581125, "userIp", newJString(userIp))
  add(query_581125, "quotaUser", newJString(quotaUser))
  add(path_581124, "merchantId", newJString(merchantId))
  add(query_581125, "dryRun", newJBool(dryRun))
  if body != nil:
    body_581126 = body
  add(query_581125, "fields", newJString(fields))
  result = call_581123.call(path_581124, query_581125, nil, nil, body_581126)

var contentPosInsert* = Call_ContentPosInsert_581108(name: "contentPosInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store",
    validator: validate_ContentPosInsert_581109, base: "/content/v2",
    url: url_ContentPosInsert_581110, schemes: {Scheme.Https})
type
  Call_ContentPosList_581092 = ref object of OpenApiRestCall_579373
proc url_ContentPosList_581094(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentPosList_581093(path: JsonNode; query: JsonNode;
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
  var valid_581095 = path.getOrDefault("targetMerchantId")
  valid_581095 = validateParameter(valid_581095, JString, required = true,
                                 default = nil)
  if valid_581095 != nil:
    section.add "targetMerchantId", valid_581095
  var valid_581096 = path.getOrDefault("merchantId")
  valid_581096 = validateParameter(valid_581096, JString, required = true,
                                 default = nil)
  if valid_581096 != nil:
    section.add "merchantId", valid_581096
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581097 = query.getOrDefault("key")
  valid_581097 = validateParameter(valid_581097, JString, required = false,
                                 default = nil)
  if valid_581097 != nil:
    section.add "key", valid_581097
  var valid_581098 = query.getOrDefault("prettyPrint")
  valid_581098 = validateParameter(valid_581098, JBool, required = false,
                                 default = newJBool(true))
  if valid_581098 != nil:
    section.add "prettyPrint", valid_581098
  var valid_581099 = query.getOrDefault("oauth_token")
  valid_581099 = validateParameter(valid_581099, JString, required = false,
                                 default = nil)
  if valid_581099 != nil:
    section.add "oauth_token", valid_581099
  var valid_581100 = query.getOrDefault("alt")
  valid_581100 = validateParameter(valid_581100, JString, required = false,
                                 default = newJString("json"))
  if valid_581100 != nil:
    section.add "alt", valid_581100
  var valid_581101 = query.getOrDefault("userIp")
  valid_581101 = validateParameter(valid_581101, JString, required = false,
                                 default = nil)
  if valid_581101 != nil:
    section.add "userIp", valid_581101
  var valid_581102 = query.getOrDefault("quotaUser")
  valid_581102 = validateParameter(valid_581102, JString, required = false,
                                 default = nil)
  if valid_581102 != nil:
    section.add "quotaUser", valid_581102
  var valid_581103 = query.getOrDefault("fields")
  valid_581103 = validateParameter(valid_581103, JString, required = false,
                                 default = nil)
  if valid_581103 != nil:
    section.add "fields", valid_581103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581104: Call_ContentPosList_581092; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the stores of the target merchant.
  ## 
  let valid = call_581104.validator(path, query, header, formData, body)
  let scheme = call_581104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581104.url(scheme.get, call_581104.host, call_581104.base,
                         call_581104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581104, url, valid)

proc call*(call_581105: Call_ContentPosList_581092; targetMerchantId: string;
          merchantId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## contentPosList
  ## Lists the stores of the target merchant.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   targetMerchantId: string (required)
  ##                   : The ID of the target merchant.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the POS or inventory data provider.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581106 = newJObject()
  var query_581107 = newJObject()
  add(query_581107, "key", newJString(key))
  add(query_581107, "prettyPrint", newJBool(prettyPrint))
  add(query_581107, "oauth_token", newJString(oauthToken))
  add(path_581106, "targetMerchantId", newJString(targetMerchantId))
  add(query_581107, "alt", newJString(alt))
  add(query_581107, "userIp", newJString(userIp))
  add(query_581107, "quotaUser", newJString(quotaUser))
  add(path_581106, "merchantId", newJString(merchantId))
  add(query_581107, "fields", newJString(fields))
  result = call_581105.call(path_581106, query_581107, nil, nil, nil)

var contentPosList* = Call_ContentPosList_581092(name: "contentPosList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store",
    validator: validate_ContentPosList_581093, base: "/content/v2",
    url: url_ContentPosList_581094, schemes: {Scheme.Https})
type
  Call_ContentPosGet_581127 = ref object of OpenApiRestCall_579373
proc url_ContentPosGet_581129(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentPosGet_581128(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_581130 = path.getOrDefault("targetMerchantId")
  valid_581130 = validateParameter(valid_581130, JString, required = true,
                                 default = nil)
  if valid_581130 != nil:
    section.add "targetMerchantId", valid_581130
  var valid_581131 = path.getOrDefault("storeCode")
  valid_581131 = validateParameter(valid_581131, JString, required = true,
                                 default = nil)
  if valid_581131 != nil:
    section.add "storeCode", valid_581131
  var valid_581132 = path.getOrDefault("merchantId")
  valid_581132 = validateParameter(valid_581132, JString, required = true,
                                 default = nil)
  if valid_581132 != nil:
    section.add "merchantId", valid_581132
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581133 = query.getOrDefault("key")
  valid_581133 = validateParameter(valid_581133, JString, required = false,
                                 default = nil)
  if valid_581133 != nil:
    section.add "key", valid_581133
  var valid_581134 = query.getOrDefault("prettyPrint")
  valid_581134 = validateParameter(valid_581134, JBool, required = false,
                                 default = newJBool(true))
  if valid_581134 != nil:
    section.add "prettyPrint", valid_581134
  var valid_581135 = query.getOrDefault("oauth_token")
  valid_581135 = validateParameter(valid_581135, JString, required = false,
                                 default = nil)
  if valid_581135 != nil:
    section.add "oauth_token", valid_581135
  var valid_581136 = query.getOrDefault("alt")
  valid_581136 = validateParameter(valid_581136, JString, required = false,
                                 default = newJString("json"))
  if valid_581136 != nil:
    section.add "alt", valid_581136
  var valid_581137 = query.getOrDefault("userIp")
  valid_581137 = validateParameter(valid_581137, JString, required = false,
                                 default = nil)
  if valid_581137 != nil:
    section.add "userIp", valid_581137
  var valid_581138 = query.getOrDefault("quotaUser")
  valid_581138 = validateParameter(valid_581138, JString, required = false,
                                 default = nil)
  if valid_581138 != nil:
    section.add "quotaUser", valid_581138
  var valid_581139 = query.getOrDefault("fields")
  valid_581139 = validateParameter(valid_581139, JString, required = false,
                                 default = nil)
  if valid_581139 != nil:
    section.add "fields", valid_581139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581140: Call_ContentPosGet_581127; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about the given store.
  ## 
  let valid = call_581140.validator(path, query, header, formData, body)
  let scheme = call_581140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581140.url(scheme.get, call_581140.host, call_581140.base,
                         call_581140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581140, url, valid)

proc call*(call_581141: Call_ContentPosGet_581127; targetMerchantId: string;
          storeCode: string; merchantId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## contentPosGet
  ## Retrieves information about the given store.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   targetMerchantId: string (required)
  ##                   : The ID of the target merchant.
  ##   storeCode: string (required)
  ##            : A store code that is unique per merchant.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the POS or inventory data provider.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581142 = newJObject()
  var query_581143 = newJObject()
  add(query_581143, "key", newJString(key))
  add(query_581143, "prettyPrint", newJBool(prettyPrint))
  add(query_581143, "oauth_token", newJString(oauthToken))
  add(path_581142, "targetMerchantId", newJString(targetMerchantId))
  add(path_581142, "storeCode", newJString(storeCode))
  add(query_581143, "alt", newJString(alt))
  add(query_581143, "userIp", newJString(userIp))
  add(query_581143, "quotaUser", newJString(quotaUser))
  add(path_581142, "merchantId", newJString(merchantId))
  add(query_581143, "fields", newJString(fields))
  result = call_581141.call(path_581142, query_581143, nil, nil, nil)

var contentPosGet* = Call_ContentPosGet_581127(name: "contentPosGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store/{storeCode}",
    validator: validate_ContentPosGet_581128, base: "/content/v2",
    url: url_ContentPosGet_581129, schemes: {Scheme.Https})
type
  Call_ContentPosDelete_581144 = ref object of OpenApiRestCall_579373
proc url_ContentPosDelete_581146(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentPosDelete_581145(path: JsonNode; query: JsonNode;
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
  var valid_581147 = path.getOrDefault("targetMerchantId")
  valid_581147 = validateParameter(valid_581147, JString, required = true,
                                 default = nil)
  if valid_581147 != nil:
    section.add "targetMerchantId", valid_581147
  var valid_581148 = path.getOrDefault("storeCode")
  valid_581148 = validateParameter(valid_581148, JString, required = true,
                                 default = nil)
  if valid_581148 != nil:
    section.add "storeCode", valid_581148
  var valid_581149 = path.getOrDefault("merchantId")
  valid_581149 = validateParameter(valid_581149, JString, required = true,
                                 default = nil)
  if valid_581149 != nil:
    section.add "merchantId", valid_581149
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581150 = query.getOrDefault("key")
  valid_581150 = validateParameter(valid_581150, JString, required = false,
                                 default = nil)
  if valid_581150 != nil:
    section.add "key", valid_581150
  var valid_581151 = query.getOrDefault("prettyPrint")
  valid_581151 = validateParameter(valid_581151, JBool, required = false,
                                 default = newJBool(true))
  if valid_581151 != nil:
    section.add "prettyPrint", valid_581151
  var valid_581152 = query.getOrDefault("oauth_token")
  valid_581152 = validateParameter(valid_581152, JString, required = false,
                                 default = nil)
  if valid_581152 != nil:
    section.add "oauth_token", valid_581152
  var valid_581153 = query.getOrDefault("alt")
  valid_581153 = validateParameter(valid_581153, JString, required = false,
                                 default = newJString("json"))
  if valid_581153 != nil:
    section.add "alt", valid_581153
  var valid_581154 = query.getOrDefault("userIp")
  valid_581154 = validateParameter(valid_581154, JString, required = false,
                                 default = nil)
  if valid_581154 != nil:
    section.add "userIp", valid_581154
  var valid_581155 = query.getOrDefault("quotaUser")
  valid_581155 = validateParameter(valid_581155, JString, required = false,
                                 default = nil)
  if valid_581155 != nil:
    section.add "quotaUser", valid_581155
  var valid_581156 = query.getOrDefault("dryRun")
  valid_581156 = validateParameter(valid_581156, JBool, required = false, default = nil)
  if valid_581156 != nil:
    section.add "dryRun", valid_581156
  var valid_581157 = query.getOrDefault("fields")
  valid_581157 = validateParameter(valid_581157, JString, required = false,
                                 default = nil)
  if valid_581157 != nil:
    section.add "fields", valid_581157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581158: Call_ContentPosDelete_581144; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a store for the given merchant.
  ## 
  let valid = call_581158.validator(path, query, header, formData, body)
  let scheme = call_581158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581158.url(scheme.get, call_581158.host, call_581158.base,
                         call_581158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581158, url, valid)

proc call*(call_581159: Call_ContentPosDelete_581144; targetMerchantId: string;
          storeCode: string; merchantId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; dryRun: bool = false;
          fields: string = ""): Recallable =
  ## contentPosDelete
  ## Deletes a store for the given merchant.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   targetMerchantId: string (required)
  ##                   : The ID of the target merchant.
  ##   storeCode: string (required)
  ##            : A store code that is unique per merchant.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the POS or inventory data provider.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581160 = newJObject()
  var query_581161 = newJObject()
  add(query_581161, "key", newJString(key))
  add(query_581161, "prettyPrint", newJBool(prettyPrint))
  add(query_581161, "oauth_token", newJString(oauthToken))
  add(path_581160, "targetMerchantId", newJString(targetMerchantId))
  add(path_581160, "storeCode", newJString(storeCode))
  add(query_581161, "alt", newJString(alt))
  add(query_581161, "userIp", newJString(userIp))
  add(query_581161, "quotaUser", newJString(quotaUser))
  add(path_581160, "merchantId", newJString(merchantId))
  add(query_581161, "dryRun", newJBool(dryRun))
  add(query_581161, "fields", newJString(fields))
  result = call_581159.call(path_581160, query_581161, nil, nil, nil)

var contentPosDelete* = Call_ContentPosDelete_581144(name: "contentPosDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store/{storeCode}",
    validator: validate_ContentPosDelete_581145, base: "/content/v2",
    url: url_ContentPosDelete_581146, schemes: {Scheme.Https})
type
  Call_ContentProductsInsert_581180 = ref object of OpenApiRestCall_579373
proc url_ContentProductsInsert_581182(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentProductsInsert_581181(path: JsonNode; query: JsonNode;
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
  var valid_581183 = path.getOrDefault("merchantId")
  valid_581183 = validateParameter(valid_581183, JString, required = true,
                                 default = nil)
  if valid_581183 != nil:
    section.add "merchantId", valid_581183
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581184 = query.getOrDefault("key")
  valid_581184 = validateParameter(valid_581184, JString, required = false,
                                 default = nil)
  if valid_581184 != nil:
    section.add "key", valid_581184
  var valid_581185 = query.getOrDefault("prettyPrint")
  valid_581185 = validateParameter(valid_581185, JBool, required = false,
                                 default = newJBool(true))
  if valid_581185 != nil:
    section.add "prettyPrint", valid_581185
  var valid_581186 = query.getOrDefault("oauth_token")
  valid_581186 = validateParameter(valid_581186, JString, required = false,
                                 default = nil)
  if valid_581186 != nil:
    section.add "oauth_token", valid_581186
  var valid_581187 = query.getOrDefault("alt")
  valid_581187 = validateParameter(valid_581187, JString, required = false,
                                 default = newJString("json"))
  if valid_581187 != nil:
    section.add "alt", valid_581187
  var valid_581188 = query.getOrDefault("userIp")
  valid_581188 = validateParameter(valid_581188, JString, required = false,
                                 default = nil)
  if valid_581188 != nil:
    section.add "userIp", valid_581188
  var valid_581189 = query.getOrDefault("quotaUser")
  valid_581189 = validateParameter(valid_581189, JString, required = false,
                                 default = nil)
  if valid_581189 != nil:
    section.add "quotaUser", valid_581189
  var valid_581190 = query.getOrDefault("dryRun")
  valid_581190 = validateParameter(valid_581190, JBool, required = false, default = nil)
  if valid_581190 != nil:
    section.add "dryRun", valid_581190
  var valid_581191 = query.getOrDefault("fields")
  valid_581191 = validateParameter(valid_581191, JString, required = false,
                                 default = nil)
  if valid_581191 != nil:
    section.add "fields", valid_581191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_581193: Call_ContentProductsInsert_581180; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a product to your Merchant Center account. If an item with the same channel, contentLanguage, offerId, and targetCountry already exists, this method updates that entry.
  ## 
  let valid = call_581193.validator(path, query, header, formData, body)
  let scheme = call_581193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581193.url(scheme.get, call_581193.host, call_581193.base,
                         call_581193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581193, url, valid)

proc call*(call_581194: Call_ContentProductsInsert_581180; merchantId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          dryRun: bool = false; body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentProductsInsert
  ## Uploads a product to your Merchant Center account. If an item with the same channel, contentLanguage, offerId, and targetCountry already exists, this method updates that entry.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that contains the product. This account cannot be a multi-client account.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581195 = newJObject()
  var query_581196 = newJObject()
  var body_581197 = newJObject()
  add(query_581196, "key", newJString(key))
  add(query_581196, "prettyPrint", newJBool(prettyPrint))
  add(query_581196, "oauth_token", newJString(oauthToken))
  add(query_581196, "alt", newJString(alt))
  add(query_581196, "userIp", newJString(userIp))
  add(query_581196, "quotaUser", newJString(quotaUser))
  add(path_581195, "merchantId", newJString(merchantId))
  add(query_581196, "dryRun", newJBool(dryRun))
  if body != nil:
    body_581197 = body
  add(query_581196, "fields", newJString(fields))
  result = call_581194.call(path_581195, query_581196, nil, nil, body_581197)

var contentProductsInsert* = Call_ContentProductsInsert_581180(
    name: "contentProductsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/products",
    validator: validate_ContentProductsInsert_581181, base: "/content/v2",
    url: url_ContentProductsInsert_581182, schemes: {Scheme.Https})
type
  Call_ContentProductsList_581162 = ref object of OpenApiRestCall_579373
proc url_ContentProductsList_581164(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentProductsList_581163(path: JsonNode; query: JsonNode;
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
  var valid_581165 = path.getOrDefault("merchantId")
  valid_581165 = validateParameter(valid_581165, JString, required = true,
                                 default = nil)
  if valid_581165 != nil:
    section.add "merchantId", valid_581165
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   includeInvalidInsertedItems: JBool
  ##                              : Flag to include the invalid inserted items in the result of the list request. By default the invalid items are not shown (the default value is false).
  ##   maxResults: JInt
  ##             : The maximum number of products to return in the response, used for paging.
  section = newJObject()
  var valid_581166 = query.getOrDefault("key")
  valid_581166 = validateParameter(valid_581166, JString, required = false,
                                 default = nil)
  if valid_581166 != nil:
    section.add "key", valid_581166
  var valid_581167 = query.getOrDefault("prettyPrint")
  valid_581167 = validateParameter(valid_581167, JBool, required = false,
                                 default = newJBool(true))
  if valid_581167 != nil:
    section.add "prettyPrint", valid_581167
  var valid_581168 = query.getOrDefault("oauth_token")
  valid_581168 = validateParameter(valid_581168, JString, required = false,
                                 default = nil)
  if valid_581168 != nil:
    section.add "oauth_token", valid_581168
  var valid_581169 = query.getOrDefault("alt")
  valid_581169 = validateParameter(valid_581169, JString, required = false,
                                 default = newJString("json"))
  if valid_581169 != nil:
    section.add "alt", valid_581169
  var valid_581170 = query.getOrDefault("userIp")
  valid_581170 = validateParameter(valid_581170, JString, required = false,
                                 default = nil)
  if valid_581170 != nil:
    section.add "userIp", valid_581170
  var valid_581171 = query.getOrDefault("quotaUser")
  valid_581171 = validateParameter(valid_581171, JString, required = false,
                                 default = nil)
  if valid_581171 != nil:
    section.add "quotaUser", valid_581171
  var valid_581172 = query.getOrDefault("pageToken")
  valid_581172 = validateParameter(valid_581172, JString, required = false,
                                 default = nil)
  if valid_581172 != nil:
    section.add "pageToken", valid_581172
  var valid_581173 = query.getOrDefault("fields")
  valid_581173 = validateParameter(valid_581173, JString, required = false,
                                 default = nil)
  if valid_581173 != nil:
    section.add "fields", valid_581173
  var valid_581174 = query.getOrDefault("includeInvalidInsertedItems")
  valid_581174 = validateParameter(valid_581174, JBool, required = false, default = nil)
  if valid_581174 != nil:
    section.add "includeInvalidInsertedItems", valid_581174
  var valid_581175 = query.getOrDefault("maxResults")
  valid_581175 = validateParameter(valid_581175, JInt, required = false, default = nil)
  if valid_581175 != nil:
    section.add "maxResults", valid_581175
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581176: Call_ContentProductsList_581162; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the products in your Merchant Center account.
  ## 
  let valid = call_581176.validator(path, query, header, formData, body)
  let scheme = call_581176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581176.url(scheme.get, call_581176.host, call_581176.base,
                         call_581176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581176, url, valid)

proc call*(call_581177: Call_ContentProductsList_581162; merchantId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = "";
          includeInvalidInsertedItems: bool = false; maxResults: int = 0): Recallable =
  ## contentProductsList
  ## Lists the products in your Merchant Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that contains the products. This account cannot be a multi-client account.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   includeInvalidInsertedItems: bool
  ##                              : Flag to include the invalid inserted items in the result of the list request. By default the invalid items are not shown (the default value is false).
  ##   maxResults: int
  ##             : The maximum number of products to return in the response, used for paging.
  var path_581178 = newJObject()
  var query_581179 = newJObject()
  add(query_581179, "key", newJString(key))
  add(query_581179, "prettyPrint", newJBool(prettyPrint))
  add(query_581179, "oauth_token", newJString(oauthToken))
  add(query_581179, "alt", newJString(alt))
  add(query_581179, "userIp", newJString(userIp))
  add(query_581179, "quotaUser", newJString(quotaUser))
  add(path_581178, "merchantId", newJString(merchantId))
  add(query_581179, "pageToken", newJString(pageToken))
  add(query_581179, "fields", newJString(fields))
  add(query_581179, "includeInvalidInsertedItems",
      newJBool(includeInvalidInsertedItems))
  add(query_581179, "maxResults", newJInt(maxResults))
  result = call_581177.call(path_581178, query_581179, nil, nil, nil)

var contentProductsList* = Call_ContentProductsList_581162(
    name: "contentProductsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/products",
    validator: validate_ContentProductsList_581163, base: "/content/v2",
    url: url_ContentProductsList_581164, schemes: {Scheme.Https})
type
  Call_ContentProductsGet_581198 = ref object of OpenApiRestCall_579373
proc url_ContentProductsGet_581200(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentProductsGet_581199(path: JsonNode; query: JsonNode;
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
  var valid_581201 = path.getOrDefault("merchantId")
  valid_581201 = validateParameter(valid_581201, JString, required = true,
                                 default = nil)
  if valid_581201 != nil:
    section.add "merchantId", valid_581201
  var valid_581202 = path.getOrDefault("productId")
  valid_581202 = validateParameter(valid_581202, JString, required = true,
                                 default = nil)
  if valid_581202 != nil:
    section.add "productId", valid_581202
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581203 = query.getOrDefault("key")
  valid_581203 = validateParameter(valid_581203, JString, required = false,
                                 default = nil)
  if valid_581203 != nil:
    section.add "key", valid_581203
  var valid_581204 = query.getOrDefault("prettyPrint")
  valid_581204 = validateParameter(valid_581204, JBool, required = false,
                                 default = newJBool(true))
  if valid_581204 != nil:
    section.add "prettyPrint", valid_581204
  var valid_581205 = query.getOrDefault("oauth_token")
  valid_581205 = validateParameter(valid_581205, JString, required = false,
                                 default = nil)
  if valid_581205 != nil:
    section.add "oauth_token", valid_581205
  var valid_581206 = query.getOrDefault("alt")
  valid_581206 = validateParameter(valid_581206, JString, required = false,
                                 default = newJString("json"))
  if valid_581206 != nil:
    section.add "alt", valid_581206
  var valid_581207 = query.getOrDefault("userIp")
  valid_581207 = validateParameter(valid_581207, JString, required = false,
                                 default = nil)
  if valid_581207 != nil:
    section.add "userIp", valid_581207
  var valid_581208 = query.getOrDefault("quotaUser")
  valid_581208 = validateParameter(valid_581208, JString, required = false,
                                 default = nil)
  if valid_581208 != nil:
    section.add "quotaUser", valid_581208
  var valid_581209 = query.getOrDefault("fields")
  valid_581209 = validateParameter(valid_581209, JString, required = false,
                                 default = nil)
  if valid_581209 != nil:
    section.add "fields", valid_581209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581210: Call_ContentProductsGet_581198; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a product from your Merchant Center account.
  ## 
  let valid = call_581210.validator(path, query, header, formData, body)
  let scheme = call_581210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581210.url(scheme.get, call_581210.host, call_581210.base,
                         call_581210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581210, url, valid)

proc call*(call_581211: Call_ContentProductsGet_581198; merchantId: string;
          productId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## contentProductsGet
  ## Retrieves a product from your Merchant Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that contains the product. This account cannot be a multi-client account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : The REST ID of the product.
  var path_581212 = newJObject()
  var query_581213 = newJObject()
  add(query_581213, "key", newJString(key))
  add(query_581213, "prettyPrint", newJBool(prettyPrint))
  add(query_581213, "oauth_token", newJString(oauthToken))
  add(query_581213, "alt", newJString(alt))
  add(query_581213, "userIp", newJString(userIp))
  add(query_581213, "quotaUser", newJString(quotaUser))
  add(path_581212, "merchantId", newJString(merchantId))
  add(query_581213, "fields", newJString(fields))
  add(path_581212, "productId", newJString(productId))
  result = call_581211.call(path_581212, query_581213, nil, nil, nil)

var contentProductsGet* = Call_ContentProductsGet_581198(
    name: "contentProductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/products/{productId}",
    validator: validate_ContentProductsGet_581199, base: "/content/v2",
    url: url_ContentProductsGet_581200, schemes: {Scheme.Https})
type
  Call_ContentProductsDelete_581214 = ref object of OpenApiRestCall_579373
proc url_ContentProductsDelete_581216(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentProductsDelete_581215(path: JsonNode; query: JsonNode;
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581219 = query.getOrDefault("key")
  valid_581219 = validateParameter(valid_581219, JString, required = false,
                                 default = nil)
  if valid_581219 != nil:
    section.add "key", valid_581219
  var valid_581220 = query.getOrDefault("prettyPrint")
  valid_581220 = validateParameter(valid_581220, JBool, required = false,
                                 default = newJBool(true))
  if valid_581220 != nil:
    section.add "prettyPrint", valid_581220
  var valid_581221 = query.getOrDefault("oauth_token")
  valid_581221 = validateParameter(valid_581221, JString, required = false,
                                 default = nil)
  if valid_581221 != nil:
    section.add "oauth_token", valid_581221
  var valid_581222 = query.getOrDefault("alt")
  valid_581222 = validateParameter(valid_581222, JString, required = false,
                                 default = newJString("json"))
  if valid_581222 != nil:
    section.add "alt", valid_581222
  var valid_581223 = query.getOrDefault("userIp")
  valid_581223 = validateParameter(valid_581223, JString, required = false,
                                 default = nil)
  if valid_581223 != nil:
    section.add "userIp", valid_581223
  var valid_581224 = query.getOrDefault("quotaUser")
  valid_581224 = validateParameter(valid_581224, JString, required = false,
                                 default = nil)
  if valid_581224 != nil:
    section.add "quotaUser", valid_581224
  var valid_581225 = query.getOrDefault("dryRun")
  valid_581225 = validateParameter(valid_581225, JBool, required = false, default = nil)
  if valid_581225 != nil:
    section.add "dryRun", valid_581225
  var valid_581226 = query.getOrDefault("fields")
  valid_581226 = validateParameter(valid_581226, JString, required = false,
                                 default = nil)
  if valid_581226 != nil:
    section.add "fields", valid_581226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581227: Call_ContentProductsDelete_581214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a product from your Merchant Center account.
  ## 
  let valid = call_581227.validator(path, query, header, formData, body)
  let scheme = call_581227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581227.url(scheme.get, call_581227.host, call_581227.base,
                         call_581227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581227, url, valid)

proc call*(call_581228: Call_ContentProductsDelete_581214; merchantId: string;
          productId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; dryRun: bool = false; fields: string = ""): Recallable =
  ## contentProductsDelete
  ## Deletes a product from your Merchant Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that contains the product. This account cannot be a multi-client account.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : The REST ID of the product.
  var path_581229 = newJObject()
  var query_581230 = newJObject()
  add(query_581230, "key", newJString(key))
  add(query_581230, "prettyPrint", newJBool(prettyPrint))
  add(query_581230, "oauth_token", newJString(oauthToken))
  add(query_581230, "alt", newJString(alt))
  add(query_581230, "userIp", newJString(userIp))
  add(query_581230, "quotaUser", newJString(quotaUser))
  add(path_581229, "merchantId", newJString(merchantId))
  add(query_581230, "dryRun", newJBool(dryRun))
  add(query_581230, "fields", newJString(fields))
  add(path_581229, "productId", newJString(productId))
  result = call_581228.call(path_581229, query_581230, nil, nil, nil)

var contentProductsDelete* = Call_ContentProductsDelete_581214(
    name: "contentProductsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/products/{productId}",
    validator: validate_ContentProductsDelete_581215, base: "/content/v2",
    url: url_ContentProductsDelete_581216, schemes: {Scheme.Https})
type
  Call_ContentProductstatusesList_581231 = ref object of OpenApiRestCall_579373
proc url_ContentProductstatusesList_581233(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentProductstatusesList_581232(path: JsonNode; query: JsonNode;
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
  var valid_581234 = path.getOrDefault("merchantId")
  valid_581234 = validateParameter(valid_581234, JString, required = true,
                                 default = nil)
  if valid_581234 != nil:
    section.add "merchantId", valid_581234
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   destinations: JArray
  ##               : If set, only issues for the specified destinations are returned, otherwise only issues for the Shopping destination.
  ##   includeAttributes: JBool
  ##                    : Flag to include full product data in the results of the list request. The default value is false.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   includeInvalidInsertedItems: JBool
  ##                              : Flag to include the invalid inserted items in the result of the list request. By default the invalid items are not shown (the default value is false).
  ##   maxResults: JInt
  ##             : The maximum number of product statuses to return in the response, used for paging.
  section = newJObject()
  var valid_581235 = query.getOrDefault("key")
  valid_581235 = validateParameter(valid_581235, JString, required = false,
                                 default = nil)
  if valid_581235 != nil:
    section.add "key", valid_581235
  var valid_581236 = query.getOrDefault("prettyPrint")
  valid_581236 = validateParameter(valid_581236, JBool, required = false,
                                 default = newJBool(true))
  if valid_581236 != nil:
    section.add "prettyPrint", valid_581236
  var valid_581237 = query.getOrDefault("oauth_token")
  valid_581237 = validateParameter(valid_581237, JString, required = false,
                                 default = nil)
  if valid_581237 != nil:
    section.add "oauth_token", valid_581237
  var valid_581238 = query.getOrDefault("alt")
  valid_581238 = validateParameter(valid_581238, JString, required = false,
                                 default = newJString("json"))
  if valid_581238 != nil:
    section.add "alt", valid_581238
  var valid_581239 = query.getOrDefault("userIp")
  valid_581239 = validateParameter(valid_581239, JString, required = false,
                                 default = nil)
  if valid_581239 != nil:
    section.add "userIp", valid_581239
  var valid_581240 = query.getOrDefault("quotaUser")
  valid_581240 = validateParameter(valid_581240, JString, required = false,
                                 default = nil)
  if valid_581240 != nil:
    section.add "quotaUser", valid_581240
  var valid_581241 = query.getOrDefault("pageToken")
  valid_581241 = validateParameter(valid_581241, JString, required = false,
                                 default = nil)
  if valid_581241 != nil:
    section.add "pageToken", valid_581241
  var valid_581242 = query.getOrDefault("destinations")
  valid_581242 = validateParameter(valid_581242, JArray, required = false,
                                 default = nil)
  if valid_581242 != nil:
    section.add "destinations", valid_581242
  var valid_581243 = query.getOrDefault("includeAttributes")
  valid_581243 = validateParameter(valid_581243, JBool, required = false, default = nil)
  if valid_581243 != nil:
    section.add "includeAttributes", valid_581243
  var valid_581244 = query.getOrDefault("fields")
  valid_581244 = validateParameter(valid_581244, JString, required = false,
                                 default = nil)
  if valid_581244 != nil:
    section.add "fields", valid_581244
  var valid_581245 = query.getOrDefault("includeInvalidInsertedItems")
  valid_581245 = validateParameter(valid_581245, JBool, required = false, default = nil)
  if valid_581245 != nil:
    section.add "includeInvalidInsertedItems", valid_581245
  var valid_581246 = query.getOrDefault("maxResults")
  valid_581246 = validateParameter(valid_581246, JInt, required = false, default = nil)
  if valid_581246 != nil:
    section.add "maxResults", valid_581246
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581247: Call_ContentProductstatusesList_581231; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the products in your Merchant Center account.
  ## 
  let valid = call_581247.validator(path, query, header, formData, body)
  let scheme = call_581247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581247.url(scheme.get, call_581247.host, call_581247.base,
                         call_581247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581247, url, valid)

proc call*(call_581248: Call_ContentProductstatusesList_581231; merchantId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; destinations: JsonNode = nil;
          includeAttributes: bool = false; fields: string = "";
          includeInvalidInsertedItems: bool = false; maxResults: int = 0): Recallable =
  ## contentProductstatusesList
  ## Lists the statuses of the products in your Merchant Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that contains the products. This account cannot be a multi-client account.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   destinations: JArray
  ##               : If set, only issues for the specified destinations are returned, otherwise only issues for the Shopping destination.
  ##   includeAttributes: bool
  ##                    : Flag to include full product data in the results of the list request. The default value is false.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   includeInvalidInsertedItems: bool
  ##                              : Flag to include the invalid inserted items in the result of the list request. By default the invalid items are not shown (the default value is false).
  ##   maxResults: int
  ##             : The maximum number of product statuses to return in the response, used for paging.
  var path_581249 = newJObject()
  var query_581250 = newJObject()
  add(query_581250, "key", newJString(key))
  add(query_581250, "prettyPrint", newJBool(prettyPrint))
  add(query_581250, "oauth_token", newJString(oauthToken))
  add(query_581250, "alt", newJString(alt))
  add(query_581250, "userIp", newJString(userIp))
  add(query_581250, "quotaUser", newJString(quotaUser))
  add(path_581249, "merchantId", newJString(merchantId))
  add(query_581250, "pageToken", newJString(pageToken))
  if destinations != nil:
    query_581250.add "destinations", destinations
  add(query_581250, "includeAttributes", newJBool(includeAttributes))
  add(query_581250, "fields", newJString(fields))
  add(query_581250, "includeInvalidInsertedItems",
      newJBool(includeInvalidInsertedItems))
  add(query_581250, "maxResults", newJInt(maxResults))
  result = call_581248.call(path_581249, query_581250, nil, nil, nil)

var contentProductstatusesList* = Call_ContentProductstatusesList_581231(
    name: "contentProductstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/productstatuses",
    validator: validate_ContentProductstatusesList_581232, base: "/content/v2",
    url: url_ContentProductstatusesList_581233, schemes: {Scheme.Https})
type
  Call_ContentProductstatusesGet_581251 = ref object of OpenApiRestCall_579373
proc url_ContentProductstatusesGet_581253(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentProductstatusesGet_581252(path: JsonNode; query: JsonNode;
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
  var valid_581254 = path.getOrDefault("merchantId")
  valid_581254 = validateParameter(valid_581254, JString, required = true,
                                 default = nil)
  if valid_581254 != nil:
    section.add "merchantId", valid_581254
  var valid_581255 = path.getOrDefault("productId")
  valid_581255 = validateParameter(valid_581255, JString, required = true,
                                 default = nil)
  if valid_581255 != nil:
    section.add "productId", valid_581255
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   destinations: JArray
  ##               : If set, only issues for the specified destinations are returned, otherwise only issues for the Shopping destination.
  ##   includeAttributes: JBool
  ##                    : Flag to include full product data in the result of this get request. The default value is false.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581256 = query.getOrDefault("key")
  valid_581256 = validateParameter(valid_581256, JString, required = false,
                                 default = nil)
  if valid_581256 != nil:
    section.add "key", valid_581256
  var valid_581257 = query.getOrDefault("prettyPrint")
  valid_581257 = validateParameter(valid_581257, JBool, required = false,
                                 default = newJBool(true))
  if valid_581257 != nil:
    section.add "prettyPrint", valid_581257
  var valid_581258 = query.getOrDefault("oauth_token")
  valid_581258 = validateParameter(valid_581258, JString, required = false,
                                 default = nil)
  if valid_581258 != nil:
    section.add "oauth_token", valid_581258
  var valid_581259 = query.getOrDefault("alt")
  valid_581259 = validateParameter(valid_581259, JString, required = false,
                                 default = newJString("json"))
  if valid_581259 != nil:
    section.add "alt", valid_581259
  var valid_581260 = query.getOrDefault("userIp")
  valid_581260 = validateParameter(valid_581260, JString, required = false,
                                 default = nil)
  if valid_581260 != nil:
    section.add "userIp", valid_581260
  var valid_581261 = query.getOrDefault("quotaUser")
  valid_581261 = validateParameter(valid_581261, JString, required = false,
                                 default = nil)
  if valid_581261 != nil:
    section.add "quotaUser", valid_581261
  var valid_581262 = query.getOrDefault("destinations")
  valid_581262 = validateParameter(valid_581262, JArray, required = false,
                                 default = nil)
  if valid_581262 != nil:
    section.add "destinations", valid_581262
  var valid_581263 = query.getOrDefault("includeAttributes")
  valid_581263 = validateParameter(valid_581263, JBool, required = false, default = nil)
  if valid_581263 != nil:
    section.add "includeAttributes", valid_581263
  var valid_581264 = query.getOrDefault("fields")
  valid_581264 = validateParameter(valid_581264, JString, required = false,
                                 default = nil)
  if valid_581264 != nil:
    section.add "fields", valid_581264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581265: Call_ContentProductstatusesGet_581251; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the status of a product from your Merchant Center account.
  ## 
  let valid = call_581265.validator(path, query, header, formData, body)
  let scheme = call_581265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581265.url(scheme.get, call_581265.host, call_581265.base,
                         call_581265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581265, url, valid)

proc call*(call_581266: Call_ContentProductstatusesGet_581251; merchantId: string;
          productId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; destinations: JsonNode = nil;
          includeAttributes: bool = false; fields: string = ""): Recallable =
  ## contentProductstatusesGet
  ## Gets the status of a product from your Merchant Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that contains the product. This account cannot be a multi-client account.
  ##   destinations: JArray
  ##               : If set, only issues for the specified destinations are returned, otherwise only issues for the Shopping destination.
  ##   includeAttributes: bool
  ##                    : Flag to include full product data in the result of this get request. The default value is false.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : The REST ID of the product.
  var path_581267 = newJObject()
  var query_581268 = newJObject()
  add(query_581268, "key", newJString(key))
  add(query_581268, "prettyPrint", newJBool(prettyPrint))
  add(query_581268, "oauth_token", newJString(oauthToken))
  add(query_581268, "alt", newJString(alt))
  add(query_581268, "userIp", newJString(userIp))
  add(query_581268, "quotaUser", newJString(quotaUser))
  add(path_581267, "merchantId", newJString(merchantId))
  if destinations != nil:
    query_581268.add "destinations", destinations
  add(query_581268, "includeAttributes", newJBool(includeAttributes))
  add(query_581268, "fields", newJString(fields))
  add(path_581267, "productId", newJString(productId))
  result = call_581266.call(path_581267, query_581268, nil, nil, nil)

var contentProductstatusesGet* = Call_ContentProductstatusesGet_581251(
    name: "contentProductstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/productstatuses/{productId}",
    validator: validate_ContentProductstatusesGet_581252, base: "/content/v2",
    url: url_ContentProductstatusesGet_581253, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsList_581269 = ref object of OpenApiRestCall_579373
proc url_ContentShippingsettingsList_581271(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentShippingsettingsList_581270(path: JsonNode; query: JsonNode;
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
  var valid_581272 = path.getOrDefault("merchantId")
  valid_581272 = validateParameter(valid_581272, JString, required = true,
                                 default = nil)
  if valid_581272 != nil:
    section.add "merchantId", valid_581272
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of shipping settings to return in the response, used for paging.
  section = newJObject()
  var valid_581273 = query.getOrDefault("key")
  valid_581273 = validateParameter(valid_581273, JString, required = false,
                                 default = nil)
  if valid_581273 != nil:
    section.add "key", valid_581273
  var valid_581274 = query.getOrDefault("prettyPrint")
  valid_581274 = validateParameter(valid_581274, JBool, required = false,
                                 default = newJBool(true))
  if valid_581274 != nil:
    section.add "prettyPrint", valid_581274
  var valid_581275 = query.getOrDefault("oauth_token")
  valid_581275 = validateParameter(valid_581275, JString, required = false,
                                 default = nil)
  if valid_581275 != nil:
    section.add "oauth_token", valid_581275
  var valid_581276 = query.getOrDefault("alt")
  valid_581276 = validateParameter(valid_581276, JString, required = false,
                                 default = newJString("json"))
  if valid_581276 != nil:
    section.add "alt", valid_581276
  var valid_581277 = query.getOrDefault("userIp")
  valid_581277 = validateParameter(valid_581277, JString, required = false,
                                 default = nil)
  if valid_581277 != nil:
    section.add "userIp", valid_581277
  var valid_581278 = query.getOrDefault("quotaUser")
  valid_581278 = validateParameter(valid_581278, JString, required = false,
                                 default = nil)
  if valid_581278 != nil:
    section.add "quotaUser", valid_581278
  var valid_581279 = query.getOrDefault("pageToken")
  valid_581279 = validateParameter(valid_581279, JString, required = false,
                                 default = nil)
  if valid_581279 != nil:
    section.add "pageToken", valid_581279
  var valid_581280 = query.getOrDefault("fields")
  valid_581280 = validateParameter(valid_581280, JString, required = false,
                                 default = nil)
  if valid_581280 != nil:
    section.add "fields", valid_581280
  var valid_581281 = query.getOrDefault("maxResults")
  valid_581281 = validateParameter(valid_581281, JInt, required = false, default = nil)
  if valid_581281 != nil:
    section.add "maxResults", valid_581281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581282: Call_ContentShippingsettingsList_581269; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the shipping settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_581282.validator(path, query, header, formData, body)
  let scheme = call_581282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581282.url(scheme.get, call_581282.host, call_581282.base,
                         call_581282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581282, url, valid)

proc call*(call_581283: Call_ContentShippingsettingsList_581269;
          merchantId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## contentShippingsettingsList
  ## Lists the shipping settings of the sub-accounts in your Merchant Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. This must be a multi-client account.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of shipping settings to return in the response, used for paging.
  var path_581284 = newJObject()
  var query_581285 = newJObject()
  add(query_581285, "key", newJString(key))
  add(query_581285, "prettyPrint", newJBool(prettyPrint))
  add(query_581285, "oauth_token", newJString(oauthToken))
  add(query_581285, "alt", newJString(alt))
  add(query_581285, "userIp", newJString(userIp))
  add(query_581285, "quotaUser", newJString(quotaUser))
  add(path_581284, "merchantId", newJString(merchantId))
  add(query_581285, "pageToken", newJString(pageToken))
  add(query_581285, "fields", newJString(fields))
  add(query_581285, "maxResults", newJInt(maxResults))
  result = call_581283.call(path_581284, query_581285, nil, nil, nil)

var contentShippingsettingsList* = Call_ContentShippingsettingsList_581269(
    name: "contentShippingsettingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/shippingsettings",
    validator: validate_ContentShippingsettingsList_581270, base: "/content/v2",
    url: url_ContentShippingsettingsList_581271, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsUpdate_581302 = ref object of OpenApiRestCall_579373
proc url_ContentShippingsettingsUpdate_581304(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentShippingsettingsUpdate_581303(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the shipping settings of the account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   accountId: JString (required)
  ##            : The ID of the account for which to get/update shipping settings.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_581305 = path.getOrDefault("merchantId")
  valid_581305 = validateParameter(valid_581305, JString, required = true,
                                 default = nil)
  if valid_581305 != nil:
    section.add "merchantId", valid_581305
  var valid_581306 = path.getOrDefault("accountId")
  valid_581306 = validateParameter(valid_581306, JString, required = true,
                                 default = nil)
  if valid_581306 != nil:
    section.add "accountId", valid_581306
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dryRun: JBool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581307 = query.getOrDefault("key")
  valid_581307 = validateParameter(valid_581307, JString, required = false,
                                 default = nil)
  if valid_581307 != nil:
    section.add "key", valid_581307
  var valid_581308 = query.getOrDefault("prettyPrint")
  valid_581308 = validateParameter(valid_581308, JBool, required = false,
                                 default = newJBool(true))
  if valid_581308 != nil:
    section.add "prettyPrint", valid_581308
  var valid_581309 = query.getOrDefault("oauth_token")
  valid_581309 = validateParameter(valid_581309, JString, required = false,
                                 default = nil)
  if valid_581309 != nil:
    section.add "oauth_token", valid_581309
  var valid_581310 = query.getOrDefault("alt")
  valid_581310 = validateParameter(valid_581310, JString, required = false,
                                 default = newJString("json"))
  if valid_581310 != nil:
    section.add "alt", valid_581310
  var valid_581311 = query.getOrDefault("userIp")
  valid_581311 = validateParameter(valid_581311, JString, required = false,
                                 default = nil)
  if valid_581311 != nil:
    section.add "userIp", valid_581311
  var valid_581312 = query.getOrDefault("quotaUser")
  valid_581312 = validateParameter(valid_581312, JString, required = false,
                                 default = nil)
  if valid_581312 != nil:
    section.add "quotaUser", valid_581312
  var valid_581313 = query.getOrDefault("dryRun")
  valid_581313 = validateParameter(valid_581313, JBool, required = false, default = nil)
  if valid_581313 != nil:
    section.add "dryRun", valid_581313
  var valid_581314 = query.getOrDefault("fields")
  valid_581314 = validateParameter(valid_581314, JString, required = false,
                                 default = nil)
  if valid_581314 != nil:
    section.add "fields", valid_581314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_581316: Call_ContentShippingsettingsUpdate_581302; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the shipping settings of the account.
  ## 
  let valid = call_581316.validator(path, query, header, formData, body)
  let scheme = call_581316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581316.url(scheme.get, call_581316.host, call_581316.base,
                         call_581316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581316, url, valid)

proc call*(call_581317: Call_ContentShippingsettingsUpdate_581302;
          merchantId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; dryRun: bool = false;
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentShippingsettingsUpdate
  ## Updates the shipping settings of the account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   dryRun: bool
  ##         : Flag to simulate a request like in a live environment. If set to true, dry-run mode checks the validity of the request and returns errors (if any).
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The ID of the account for which to get/update shipping settings.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581318 = newJObject()
  var query_581319 = newJObject()
  var body_581320 = newJObject()
  add(query_581319, "key", newJString(key))
  add(query_581319, "prettyPrint", newJBool(prettyPrint))
  add(query_581319, "oauth_token", newJString(oauthToken))
  add(query_581319, "alt", newJString(alt))
  add(query_581319, "userIp", newJString(userIp))
  add(query_581319, "quotaUser", newJString(quotaUser))
  add(path_581318, "merchantId", newJString(merchantId))
  add(query_581319, "dryRun", newJBool(dryRun))
  if body != nil:
    body_581320 = body
  add(path_581318, "accountId", newJString(accountId))
  add(query_581319, "fields", newJString(fields))
  result = call_581317.call(path_581318, query_581319, nil, nil, body_581320)

var contentShippingsettingsUpdate* = Call_ContentShippingsettingsUpdate_581302(
    name: "contentShippingsettingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{merchantId}/shippingsettings/{accountId}",
    validator: validate_ContentShippingsettingsUpdate_581303, base: "/content/v2",
    url: url_ContentShippingsettingsUpdate_581304, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGet_581286 = ref object of OpenApiRestCall_579373
proc url_ContentShippingsettingsGet_581288(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentShippingsettingsGet_581287(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the shipping settings of the account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   accountId: JString (required)
  ##            : The ID of the account for which to get/update shipping settings.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_581289 = path.getOrDefault("merchantId")
  valid_581289 = validateParameter(valid_581289, JString, required = true,
                                 default = nil)
  if valid_581289 != nil:
    section.add "merchantId", valid_581289
  var valid_581290 = path.getOrDefault("accountId")
  valid_581290 = validateParameter(valid_581290, JString, required = true,
                                 default = nil)
  if valid_581290 != nil:
    section.add "accountId", valid_581290
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581291 = query.getOrDefault("key")
  valid_581291 = validateParameter(valid_581291, JString, required = false,
                                 default = nil)
  if valid_581291 != nil:
    section.add "key", valid_581291
  var valid_581292 = query.getOrDefault("prettyPrint")
  valid_581292 = validateParameter(valid_581292, JBool, required = false,
                                 default = newJBool(true))
  if valid_581292 != nil:
    section.add "prettyPrint", valid_581292
  var valid_581293 = query.getOrDefault("oauth_token")
  valid_581293 = validateParameter(valid_581293, JString, required = false,
                                 default = nil)
  if valid_581293 != nil:
    section.add "oauth_token", valid_581293
  var valid_581294 = query.getOrDefault("alt")
  valid_581294 = validateParameter(valid_581294, JString, required = false,
                                 default = newJString("json"))
  if valid_581294 != nil:
    section.add "alt", valid_581294
  var valid_581295 = query.getOrDefault("userIp")
  valid_581295 = validateParameter(valid_581295, JString, required = false,
                                 default = nil)
  if valid_581295 != nil:
    section.add "userIp", valid_581295
  var valid_581296 = query.getOrDefault("quotaUser")
  valid_581296 = validateParameter(valid_581296, JString, required = false,
                                 default = nil)
  if valid_581296 != nil:
    section.add "quotaUser", valid_581296
  var valid_581297 = query.getOrDefault("fields")
  valid_581297 = validateParameter(valid_581297, JString, required = false,
                                 default = nil)
  if valid_581297 != nil:
    section.add "fields", valid_581297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581298: Call_ContentShippingsettingsGet_581286; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the shipping settings of the account.
  ## 
  let valid = call_581298.validator(path, query, header, formData, body)
  let scheme = call_581298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581298.url(scheme.get, call_581298.host, call_581298.base,
                         call_581298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581298, url, valid)

proc call*(call_581299: Call_ContentShippingsettingsGet_581286; merchantId: string;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## contentShippingsettingsGet
  ## Retrieves the shipping settings of the account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the managing account. If this parameter is not the same as accountId, then this account must be a multi-client account and accountId must be the ID of a sub-account of this account.
  ##   accountId: string (required)
  ##            : The ID of the account for which to get/update shipping settings.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581300 = newJObject()
  var query_581301 = newJObject()
  add(query_581301, "key", newJString(key))
  add(query_581301, "prettyPrint", newJBool(prettyPrint))
  add(query_581301, "oauth_token", newJString(oauthToken))
  add(query_581301, "alt", newJString(alt))
  add(query_581301, "userIp", newJString(userIp))
  add(query_581301, "quotaUser", newJString(quotaUser))
  add(path_581300, "merchantId", newJString(merchantId))
  add(path_581300, "accountId", newJString(accountId))
  add(query_581301, "fields", newJString(fields))
  result = call_581299.call(path_581300, query_581301, nil, nil, nil)

var contentShippingsettingsGet* = Call_ContentShippingsettingsGet_581286(
    name: "contentShippingsettingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/shippingsettings/{accountId}",
    validator: validate_ContentShippingsettingsGet_581287, base: "/content/v2",
    url: url_ContentShippingsettingsGet_581288, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGetsupportedcarriers_581321 = ref object of OpenApiRestCall_579373
proc url_ContentShippingsettingsGetsupportedcarriers_581323(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentShippingsettingsGetsupportedcarriers_581322(path: JsonNode;
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
  var valid_581324 = path.getOrDefault("merchantId")
  valid_581324 = validateParameter(valid_581324, JString, required = true,
                                 default = nil)
  if valid_581324 != nil:
    section.add "merchantId", valid_581324
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581325 = query.getOrDefault("key")
  valid_581325 = validateParameter(valid_581325, JString, required = false,
                                 default = nil)
  if valid_581325 != nil:
    section.add "key", valid_581325
  var valid_581326 = query.getOrDefault("prettyPrint")
  valid_581326 = validateParameter(valid_581326, JBool, required = false,
                                 default = newJBool(true))
  if valid_581326 != nil:
    section.add "prettyPrint", valid_581326
  var valid_581327 = query.getOrDefault("oauth_token")
  valid_581327 = validateParameter(valid_581327, JString, required = false,
                                 default = nil)
  if valid_581327 != nil:
    section.add "oauth_token", valid_581327
  var valid_581328 = query.getOrDefault("alt")
  valid_581328 = validateParameter(valid_581328, JString, required = false,
                                 default = newJString("json"))
  if valid_581328 != nil:
    section.add "alt", valid_581328
  var valid_581329 = query.getOrDefault("userIp")
  valid_581329 = validateParameter(valid_581329, JString, required = false,
                                 default = nil)
  if valid_581329 != nil:
    section.add "userIp", valid_581329
  var valid_581330 = query.getOrDefault("quotaUser")
  valid_581330 = validateParameter(valid_581330, JString, required = false,
                                 default = nil)
  if valid_581330 != nil:
    section.add "quotaUser", valid_581330
  var valid_581331 = query.getOrDefault("fields")
  valid_581331 = validateParameter(valid_581331, JString, required = false,
                                 default = nil)
  if valid_581331 != nil:
    section.add "fields", valid_581331
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581332: Call_ContentShippingsettingsGetsupportedcarriers_581321;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves supported carriers and carrier services for an account.
  ## 
  let valid = call_581332.validator(path, query, header, formData, body)
  let scheme = call_581332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581332.url(scheme.get, call_581332.host, call_581332.base,
                         call_581332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581332, url, valid)

proc call*(call_581333: Call_ContentShippingsettingsGetsupportedcarriers_581321;
          merchantId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## contentShippingsettingsGetsupportedcarriers
  ## Retrieves supported carriers and carrier services for an account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account for which to retrieve the supported carriers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581334 = newJObject()
  var query_581335 = newJObject()
  add(query_581335, "key", newJString(key))
  add(query_581335, "prettyPrint", newJBool(prettyPrint))
  add(query_581335, "oauth_token", newJString(oauthToken))
  add(query_581335, "alt", newJString(alt))
  add(query_581335, "userIp", newJString(userIp))
  add(query_581335, "quotaUser", newJString(quotaUser))
  add(path_581334, "merchantId", newJString(merchantId))
  add(query_581335, "fields", newJString(fields))
  result = call_581333.call(path_581334, query_581335, nil, nil, nil)

var contentShippingsettingsGetsupportedcarriers* = Call_ContentShippingsettingsGetsupportedcarriers_581321(
    name: "contentShippingsettingsGetsupportedcarriers", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/supportedCarriers",
    validator: validate_ContentShippingsettingsGetsupportedcarriers_581322,
    base: "/content/v2", url: url_ContentShippingsettingsGetsupportedcarriers_581323,
    schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGetsupportedholidays_581336 = ref object of OpenApiRestCall_579373
proc url_ContentShippingsettingsGetsupportedholidays_581338(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentShippingsettingsGetsupportedholidays_581337(path: JsonNode;
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
  var valid_581339 = path.getOrDefault("merchantId")
  valid_581339 = validateParameter(valid_581339, JString, required = true,
                                 default = nil)
  if valid_581339 != nil:
    section.add "merchantId", valid_581339
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581340 = query.getOrDefault("key")
  valid_581340 = validateParameter(valid_581340, JString, required = false,
                                 default = nil)
  if valid_581340 != nil:
    section.add "key", valid_581340
  var valid_581341 = query.getOrDefault("prettyPrint")
  valid_581341 = validateParameter(valid_581341, JBool, required = false,
                                 default = newJBool(true))
  if valid_581341 != nil:
    section.add "prettyPrint", valid_581341
  var valid_581342 = query.getOrDefault("oauth_token")
  valid_581342 = validateParameter(valid_581342, JString, required = false,
                                 default = nil)
  if valid_581342 != nil:
    section.add "oauth_token", valid_581342
  var valid_581343 = query.getOrDefault("alt")
  valid_581343 = validateParameter(valid_581343, JString, required = false,
                                 default = newJString("json"))
  if valid_581343 != nil:
    section.add "alt", valid_581343
  var valid_581344 = query.getOrDefault("userIp")
  valid_581344 = validateParameter(valid_581344, JString, required = false,
                                 default = nil)
  if valid_581344 != nil:
    section.add "userIp", valid_581344
  var valid_581345 = query.getOrDefault("quotaUser")
  valid_581345 = validateParameter(valid_581345, JString, required = false,
                                 default = nil)
  if valid_581345 != nil:
    section.add "quotaUser", valid_581345
  var valid_581346 = query.getOrDefault("fields")
  valid_581346 = validateParameter(valid_581346, JString, required = false,
                                 default = nil)
  if valid_581346 != nil:
    section.add "fields", valid_581346
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581347: Call_ContentShippingsettingsGetsupportedholidays_581336;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves supported holidays for an account.
  ## 
  let valid = call_581347.validator(path, query, header, formData, body)
  let scheme = call_581347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581347.url(scheme.get, call_581347.host, call_581347.base,
                         call_581347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581347, url, valid)

proc call*(call_581348: Call_ContentShippingsettingsGetsupportedholidays_581336;
          merchantId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## contentShippingsettingsGetsupportedholidays
  ## Retrieves supported holidays for an account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account for which to retrieve the supported holidays.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581349 = newJObject()
  var query_581350 = newJObject()
  add(query_581350, "key", newJString(key))
  add(query_581350, "prettyPrint", newJBool(prettyPrint))
  add(query_581350, "oauth_token", newJString(oauthToken))
  add(query_581350, "alt", newJString(alt))
  add(query_581350, "userIp", newJString(userIp))
  add(query_581350, "quotaUser", newJString(quotaUser))
  add(path_581349, "merchantId", newJString(merchantId))
  add(query_581350, "fields", newJString(fields))
  result = call_581348.call(path_581349, query_581350, nil, nil, nil)

var contentShippingsettingsGetsupportedholidays* = Call_ContentShippingsettingsGetsupportedholidays_581336(
    name: "contentShippingsettingsGetsupportedholidays", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/supportedHolidays",
    validator: validate_ContentShippingsettingsGetsupportedholidays_581337,
    base: "/content/v2", url: url_ContentShippingsettingsGetsupportedholidays_581338,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersCreatetestorder_581351 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersCreatetestorder_581353(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentOrdersCreatetestorder_581352(path: JsonNode; query: JsonNode;
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
  var valid_581354 = path.getOrDefault("merchantId")
  valid_581354 = validateParameter(valid_581354, JString, required = true,
                                 default = nil)
  if valid_581354 != nil:
    section.add "merchantId", valid_581354
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581355 = query.getOrDefault("key")
  valid_581355 = validateParameter(valid_581355, JString, required = false,
                                 default = nil)
  if valid_581355 != nil:
    section.add "key", valid_581355
  var valid_581356 = query.getOrDefault("prettyPrint")
  valid_581356 = validateParameter(valid_581356, JBool, required = false,
                                 default = newJBool(true))
  if valid_581356 != nil:
    section.add "prettyPrint", valid_581356
  var valid_581357 = query.getOrDefault("oauth_token")
  valid_581357 = validateParameter(valid_581357, JString, required = false,
                                 default = nil)
  if valid_581357 != nil:
    section.add "oauth_token", valid_581357
  var valid_581358 = query.getOrDefault("alt")
  valid_581358 = validateParameter(valid_581358, JString, required = false,
                                 default = newJString("json"))
  if valid_581358 != nil:
    section.add "alt", valid_581358
  var valid_581359 = query.getOrDefault("userIp")
  valid_581359 = validateParameter(valid_581359, JString, required = false,
                                 default = nil)
  if valid_581359 != nil:
    section.add "userIp", valid_581359
  var valid_581360 = query.getOrDefault("quotaUser")
  valid_581360 = validateParameter(valid_581360, JString, required = false,
                                 default = nil)
  if valid_581360 != nil:
    section.add "quotaUser", valid_581360
  var valid_581361 = query.getOrDefault("fields")
  valid_581361 = validateParameter(valid_581361, JString, required = false,
                                 default = nil)
  if valid_581361 != nil:
    section.add "fields", valid_581361
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_581363: Call_ContentOrdersCreatetestorder_581351; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Creates a test order.
  ## 
  let valid = call_581363.validator(path, query, header, formData, body)
  let scheme = call_581363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581363.url(scheme.get, call_581363.host, call_581363.base,
                         call_581363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581363, url, valid)

proc call*(call_581364: Call_ContentOrdersCreatetestorder_581351;
          merchantId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentOrdersCreatetestorder
  ## Sandbox only. Creates a test order.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that should manage the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581365 = newJObject()
  var query_581366 = newJObject()
  var body_581367 = newJObject()
  add(query_581366, "key", newJString(key))
  add(query_581366, "prettyPrint", newJBool(prettyPrint))
  add(query_581366, "oauth_token", newJString(oauthToken))
  add(query_581366, "alt", newJString(alt))
  add(query_581366, "userIp", newJString(userIp))
  add(query_581366, "quotaUser", newJString(quotaUser))
  add(path_581365, "merchantId", newJString(merchantId))
  if body != nil:
    body_581367 = body
  add(query_581366, "fields", newJString(fields))
  result = call_581364.call(path_581365, query_581366, nil, nil, body_581367)

var contentOrdersCreatetestorder* = Call_ContentOrdersCreatetestorder_581351(
    name: "contentOrdersCreatetestorder", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/testorders",
    validator: validate_ContentOrdersCreatetestorder_581352, base: "/content/v2",
    url: url_ContentOrdersCreatetestorder_581353, schemes: {Scheme.Https})
type
  Call_ContentOrdersAdvancetestorder_581368 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersAdvancetestorder_581370(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentOrdersAdvancetestorder_581369(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sandbox only. Moves a test order from state "inProgress" to state "pendingShipment".
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the test order to modify.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_581371 = path.getOrDefault("merchantId")
  valid_581371 = validateParameter(valid_581371, JString, required = true,
                                 default = nil)
  if valid_581371 != nil:
    section.add "merchantId", valid_581371
  var valid_581372 = path.getOrDefault("orderId")
  valid_581372 = validateParameter(valid_581372, JString, required = true,
                                 default = nil)
  if valid_581372 != nil:
    section.add "orderId", valid_581372
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581373 = query.getOrDefault("key")
  valid_581373 = validateParameter(valid_581373, JString, required = false,
                                 default = nil)
  if valid_581373 != nil:
    section.add "key", valid_581373
  var valid_581374 = query.getOrDefault("prettyPrint")
  valid_581374 = validateParameter(valid_581374, JBool, required = false,
                                 default = newJBool(true))
  if valid_581374 != nil:
    section.add "prettyPrint", valid_581374
  var valid_581375 = query.getOrDefault("oauth_token")
  valid_581375 = validateParameter(valid_581375, JString, required = false,
                                 default = nil)
  if valid_581375 != nil:
    section.add "oauth_token", valid_581375
  var valid_581376 = query.getOrDefault("alt")
  valid_581376 = validateParameter(valid_581376, JString, required = false,
                                 default = newJString("json"))
  if valid_581376 != nil:
    section.add "alt", valid_581376
  var valid_581377 = query.getOrDefault("userIp")
  valid_581377 = validateParameter(valid_581377, JString, required = false,
                                 default = nil)
  if valid_581377 != nil:
    section.add "userIp", valid_581377
  var valid_581378 = query.getOrDefault("quotaUser")
  valid_581378 = validateParameter(valid_581378, JString, required = false,
                                 default = nil)
  if valid_581378 != nil:
    section.add "quotaUser", valid_581378
  var valid_581379 = query.getOrDefault("fields")
  valid_581379 = validateParameter(valid_581379, JString, required = false,
                                 default = nil)
  if valid_581379 != nil:
    section.add "fields", valid_581379
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581380: Call_ContentOrdersAdvancetestorder_581368; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Moves a test order from state "inProgress" to state "pendingShipment".
  ## 
  let valid = call_581380.validator(path, query, header, formData, body)
  let scheme = call_581380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581380.url(scheme.get, call_581380.host, call_581380.base,
                         call_581380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581380, url, valid)

proc call*(call_581381: Call_ContentOrdersAdvancetestorder_581368;
          merchantId: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## contentOrdersAdvancetestorder
  ## Sandbox only. Moves a test order from state "inProgress" to state "pendingShipment".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the test order to modify.
  var path_581382 = newJObject()
  var query_581383 = newJObject()
  add(query_581383, "key", newJString(key))
  add(query_581383, "prettyPrint", newJBool(prettyPrint))
  add(query_581383, "oauth_token", newJString(oauthToken))
  add(query_581383, "alt", newJString(alt))
  add(query_581383, "userIp", newJString(userIp))
  add(query_581383, "quotaUser", newJString(quotaUser))
  add(path_581382, "merchantId", newJString(merchantId))
  add(query_581383, "fields", newJString(fields))
  add(path_581382, "orderId", newJString(orderId))
  result = call_581381.call(path_581382, query_581383, nil, nil, nil)

var contentOrdersAdvancetestorder* = Call_ContentOrdersAdvancetestorder_581368(
    name: "contentOrdersAdvancetestorder", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/testorders/{orderId}/advance",
    validator: validate_ContentOrdersAdvancetestorder_581369, base: "/content/v2",
    url: url_ContentOrdersAdvancetestorder_581370, schemes: {Scheme.Https})
type
  Call_ContentOrdersCanceltestorderbycustomer_581384 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersCanceltestorderbycustomer_581386(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentOrdersCanceltestorderbycustomer_581385(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sandbox only. Cancels a test order for customer-initiated cancellation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the test order to cancel.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_581387 = path.getOrDefault("merchantId")
  valid_581387 = validateParameter(valid_581387, JString, required = true,
                                 default = nil)
  if valid_581387 != nil:
    section.add "merchantId", valid_581387
  var valid_581388 = path.getOrDefault("orderId")
  valid_581388 = validateParameter(valid_581388, JString, required = true,
                                 default = nil)
  if valid_581388 != nil:
    section.add "orderId", valid_581388
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581389 = query.getOrDefault("key")
  valid_581389 = validateParameter(valid_581389, JString, required = false,
                                 default = nil)
  if valid_581389 != nil:
    section.add "key", valid_581389
  var valid_581390 = query.getOrDefault("prettyPrint")
  valid_581390 = validateParameter(valid_581390, JBool, required = false,
                                 default = newJBool(true))
  if valid_581390 != nil:
    section.add "prettyPrint", valid_581390
  var valid_581391 = query.getOrDefault("oauth_token")
  valid_581391 = validateParameter(valid_581391, JString, required = false,
                                 default = nil)
  if valid_581391 != nil:
    section.add "oauth_token", valid_581391
  var valid_581392 = query.getOrDefault("alt")
  valid_581392 = validateParameter(valid_581392, JString, required = false,
                                 default = newJString("json"))
  if valid_581392 != nil:
    section.add "alt", valid_581392
  var valid_581393 = query.getOrDefault("userIp")
  valid_581393 = validateParameter(valid_581393, JString, required = false,
                                 default = nil)
  if valid_581393 != nil:
    section.add "userIp", valid_581393
  var valid_581394 = query.getOrDefault("quotaUser")
  valid_581394 = validateParameter(valid_581394, JString, required = false,
                                 default = nil)
  if valid_581394 != nil:
    section.add "quotaUser", valid_581394
  var valid_581395 = query.getOrDefault("fields")
  valid_581395 = validateParameter(valid_581395, JString, required = false,
                                 default = nil)
  if valid_581395 != nil:
    section.add "fields", valid_581395
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_581397: Call_ContentOrdersCanceltestorderbycustomer_581384;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sandbox only. Cancels a test order for customer-initiated cancellation.
  ## 
  let valid = call_581397.validator(path, query, header, formData, body)
  let scheme = call_581397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581397.url(scheme.get, call_581397.host, call_581397.base,
                         call_581397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581397, url, valid)

proc call*(call_581398: Call_ContentOrdersCanceltestorderbycustomer_581384;
          merchantId: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentOrdersCanceltestorderbycustomer
  ## Sandbox only. Cancels a test order for customer-initiated cancellation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The ID of the test order to cancel.
  var path_581399 = newJObject()
  var query_581400 = newJObject()
  var body_581401 = newJObject()
  add(query_581400, "key", newJString(key))
  add(query_581400, "prettyPrint", newJBool(prettyPrint))
  add(query_581400, "oauth_token", newJString(oauthToken))
  add(query_581400, "alt", newJString(alt))
  add(query_581400, "userIp", newJString(userIp))
  add(query_581400, "quotaUser", newJString(quotaUser))
  add(path_581399, "merchantId", newJString(merchantId))
  if body != nil:
    body_581401 = body
  add(query_581400, "fields", newJString(fields))
  add(path_581399, "orderId", newJString(orderId))
  result = call_581398.call(path_581399, query_581400, nil, nil, body_581401)

var contentOrdersCanceltestorderbycustomer* = Call_ContentOrdersCanceltestorderbycustomer_581384(
    name: "contentOrdersCanceltestorderbycustomer", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/testorders/{orderId}/cancelByCustomer",
    validator: validate_ContentOrdersCanceltestorderbycustomer_581385,
    base: "/content/v2", url: url_ContentOrdersCanceltestorderbycustomer_581386,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersGettestordertemplate_581402 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersGettestordertemplate_581404(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentOrdersGettestordertemplate_581403(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sandbox only. Retrieves an order template that can be used to quickly create a new order in sandbox.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that should manage the order. This cannot be a multi-client account.
  ##   templateName: JString (required)
  ##               : The name of the template to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_581405 = path.getOrDefault("merchantId")
  valid_581405 = validateParameter(valid_581405, JString, required = true,
                                 default = nil)
  if valid_581405 != nil:
    section.add "merchantId", valid_581405
  var valid_581406 = path.getOrDefault("templateName")
  valid_581406 = validateParameter(valid_581406, JString, required = true,
                                 default = newJString("template1"))
  if valid_581406 != nil:
    section.add "templateName", valid_581406
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   country: JString
  ##          : The country of the template to retrieve. Defaults to US.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581407 = query.getOrDefault("key")
  valid_581407 = validateParameter(valid_581407, JString, required = false,
                                 default = nil)
  if valid_581407 != nil:
    section.add "key", valid_581407
  var valid_581408 = query.getOrDefault("prettyPrint")
  valid_581408 = validateParameter(valid_581408, JBool, required = false,
                                 default = newJBool(true))
  if valid_581408 != nil:
    section.add "prettyPrint", valid_581408
  var valid_581409 = query.getOrDefault("oauth_token")
  valid_581409 = validateParameter(valid_581409, JString, required = false,
                                 default = nil)
  if valid_581409 != nil:
    section.add "oauth_token", valid_581409
  var valid_581410 = query.getOrDefault("alt")
  valid_581410 = validateParameter(valid_581410, JString, required = false,
                                 default = newJString("json"))
  if valid_581410 != nil:
    section.add "alt", valid_581410
  var valid_581411 = query.getOrDefault("userIp")
  valid_581411 = validateParameter(valid_581411, JString, required = false,
                                 default = nil)
  if valid_581411 != nil:
    section.add "userIp", valid_581411
  var valid_581412 = query.getOrDefault("quotaUser")
  valid_581412 = validateParameter(valid_581412, JString, required = false,
                                 default = nil)
  if valid_581412 != nil:
    section.add "quotaUser", valid_581412
  var valid_581413 = query.getOrDefault("country")
  valid_581413 = validateParameter(valid_581413, JString, required = false,
                                 default = nil)
  if valid_581413 != nil:
    section.add "country", valid_581413
  var valid_581414 = query.getOrDefault("fields")
  valid_581414 = validateParameter(valid_581414, JString, required = false,
                                 default = nil)
  if valid_581414 != nil:
    section.add "fields", valid_581414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581415: Call_ContentOrdersGettestordertemplate_581402;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sandbox only. Retrieves an order template that can be used to quickly create a new order in sandbox.
  ## 
  let valid = call_581415.validator(path, query, header, formData, body)
  let scheme = call_581415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581415.url(scheme.get, call_581415.host, call_581415.base,
                         call_581415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581415, url, valid)

proc call*(call_581416: Call_ContentOrdersGettestordertemplate_581402;
          merchantId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; country: string = "";
          templateName: string = "template1"; fields: string = ""): Recallable =
  ## contentOrdersGettestordertemplate
  ## Sandbox only. Retrieves an order template that can be used to quickly create a new order in sandbox.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   merchantId: string (required)
  ##             : The ID of the account that should manage the order. This cannot be a multi-client account.
  ##   country: string
  ##          : The country of the template to retrieve. Defaults to US.
  ##   templateName: string (required)
  ##               : The name of the template to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581417 = newJObject()
  var query_581418 = newJObject()
  add(query_581418, "key", newJString(key))
  add(query_581418, "prettyPrint", newJBool(prettyPrint))
  add(query_581418, "oauth_token", newJString(oauthToken))
  add(query_581418, "alt", newJString(alt))
  add(query_581418, "userIp", newJString(userIp))
  add(query_581418, "quotaUser", newJString(quotaUser))
  add(path_581417, "merchantId", newJString(merchantId))
  add(query_581418, "country", newJString(country))
  add(path_581417, "templateName", newJString(templateName))
  add(query_581418, "fields", newJString(fields))
  result = call_581416.call(path_581417, query_581418, nil, nil, nil)

var contentOrdersGettestordertemplate* = Call_ContentOrdersGettestordertemplate_581402(
    name: "contentOrdersGettestordertemplate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/testordertemplates/{templateName}",
    validator: validate_ContentOrdersGettestordertemplate_581403,
    base: "/content/v2", url: url_ContentOrdersGettestordertemplate_581404,
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
