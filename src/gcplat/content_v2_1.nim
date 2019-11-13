
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

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
  Call_ContentAccountsAuthinfo_579644 = ref object of OpenApiRestCall_579373
proc url_ContentAccountsAuthinfo_579646(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsAuthinfo_579645(path: JsonNode; query: JsonNode;
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
  var valid_579758 = query.getOrDefault("key")
  valid_579758 = validateParameter(valid_579758, JString, required = false,
                                 default = nil)
  if valid_579758 != nil:
    section.add "key", valid_579758
  var valid_579772 = query.getOrDefault("prettyPrint")
  valid_579772 = validateParameter(valid_579772, JBool, required = false,
                                 default = newJBool(true))
  if valid_579772 != nil:
    section.add "prettyPrint", valid_579772
  var valid_579773 = query.getOrDefault("oauth_token")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "oauth_token", valid_579773
  var valid_579774 = query.getOrDefault("alt")
  valid_579774 = validateParameter(valid_579774, JString, required = false,
                                 default = newJString("json"))
  if valid_579774 != nil:
    section.add "alt", valid_579774
  var valid_579775 = query.getOrDefault("userIp")
  valid_579775 = validateParameter(valid_579775, JString, required = false,
                                 default = nil)
  if valid_579775 != nil:
    section.add "userIp", valid_579775
  var valid_579776 = query.getOrDefault("quotaUser")
  valid_579776 = validateParameter(valid_579776, JString, required = false,
                                 default = nil)
  if valid_579776 != nil:
    section.add "quotaUser", valid_579776
  var valid_579777 = query.getOrDefault("fields")
  valid_579777 = validateParameter(valid_579777, JString, required = false,
                                 default = nil)
  if valid_579777 != nil:
    section.add "fields", valid_579777
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579800: Call_ContentAccountsAuthinfo_579644; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about the authenticated user.
  ## 
  let valid = call_579800.validator(path, query, header, formData, body)
  let scheme = call_579800.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579800.url(scheme.get, call_579800.host, call_579800.base,
                         call_579800.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579800, url, valid)

proc call*(call_579871: Call_ContentAccountsAuthinfo_579644; key: string = "";
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
  var query_579872 = newJObject()
  add(query_579872, "key", newJString(key))
  add(query_579872, "prettyPrint", newJBool(prettyPrint))
  add(query_579872, "oauth_token", newJString(oauthToken))
  add(query_579872, "alt", newJString(alt))
  add(query_579872, "userIp", newJString(userIp))
  add(query_579872, "quotaUser", newJString(quotaUser))
  add(query_579872, "fields", newJString(fields))
  result = call_579871.call(nil, query_579872, nil, nil, nil)

var contentAccountsAuthinfo* = Call_ContentAccountsAuthinfo_579644(
    name: "contentAccountsAuthinfo", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/authinfo",
    validator: validate_ContentAccountsAuthinfo_579645, base: "/content/v2.1",
    url: url_ContentAccountsAuthinfo_579646, schemes: {Scheme.Https})
type
  Call_ContentAccountsCustombatch_579912 = ref object of OpenApiRestCall_579373
proc url_ContentAccountsCustombatch_579914(protocol: Scheme; host: string;
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

proc validate_ContentAccountsCustombatch_579913(path: JsonNode; query: JsonNode;
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579915 = query.getOrDefault("key")
  valid_579915 = validateParameter(valid_579915, JString, required = false,
                                 default = nil)
  if valid_579915 != nil:
    section.add "key", valid_579915
  var valid_579916 = query.getOrDefault("prettyPrint")
  valid_579916 = validateParameter(valid_579916, JBool, required = false,
                                 default = newJBool(true))
  if valid_579916 != nil:
    section.add "prettyPrint", valid_579916
  var valid_579917 = query.getOrDefault("oauth_token")
  valid_579917 = validateParameter(valid_579917, JString, required = false,
                                 default = nil)
  if valid_579917 != nil:
    section.add "oauth_token", valid_579917
  var valid_579918 = query.getOrDefault("alt")
  valid_579918 = validateParameter(valid_579918, JString, required = false,
                                 default = newJString("json"))
  if valid_579918 != nil:
    section.add "alt", valid_579918
  var valid_579919 = query.getOrDefault("userIp")
  valid_579919 = validateParameter(valid_579919, JString, required = false,
                                 default = nil)
  if valid_579919 != nil:
    section.add "userIp", valid_579919
  var valid_579920 = query.getOrDefault("quotaUser")
  valid_579920 = validateParameter(valid_579920, JString, required = false,
                                 default = nil)
  if valid_579920 != nil:
    section.add "quotaUser", valid_579920
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

proc call*(call_579923: Call_ContentAccountsCustombatch_579912; path: JsonNode;
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

proc call*(call_579924: Call_ContentAccountsCustombatch_579912; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
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
  if body != nil:
    body_579926 = body
  add(query_579925, "fields", newJString(fields))
  result = call_579924.call(nil, query_579925, nil, nil, body_579926)

var contentAccountsCustombatch* = Call_ContentAccountsCustombatch_579912(
    name: "contentAccountsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accounts/batch",
    validator: validate_ContentAccountsCustombatch_579913, base: "/content/v2.1",
    url: url_ContentAccountsCustombatch_579914, schemes: {Scheme.Https})
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
    base: "/content/v2.1", url: url_ContentAccountstatusesCustombatch_579929,
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
  var valid_579951 = query.getOrDefault("fields")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = nil)
  if valid_579951 != nil:
    section.add "fields", valid_579951
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579953: Call_ContentAccounttaxCustombatch_579942; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves and updates tax settings of multiple accounts in a single request.
  ## 
  let valid = call_579953.validator(path, query, header, formData, body)
  let scheme = call_579953.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579953.url(scheme.get, call_579953.host, call_579953.base,
                         call_579953.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579953, url, valid)

proc call*(call_579954: Call_ContentAccounttaxCustombatch_579942; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
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
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579955 = newJObject()
  var body_579956 = newJObject()
  add(query_579955, "key", newJString(key))
  add(query_579955, "prettyPrint", newJBool(prettyPrint))
  add(query_579955, "oauth_token", newJString(oauthToken))
  add(query_579955, "alt", newJString(alt))
  add(query_579955, "userIp", newJString(userIp))
  add(query_579955, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579956 = body
  add(query_579955, "fields", newJString(fields))
  result = call_579954.call(nil, query_579955, nil, nil, body_579956)

var contentAccounttaxCustombatch* = Call_ContentAccounttaxCustombatch_579942(
    name: "contentAccounttaxCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accounttax/batch",
    validator: validate_ContentAccounttaxCustombatch_579943,
    base: "/content/v2.1", url: url_ContentAccounttaxCustombatch_579944,
    schemes: {Scheme.Https})
type
  Call_ContentDatafeedsCustombatch_579957 = ref object of OpenApiRestCall_579373
proc url_ContentDatafeedsCustombatch_579959(protocol: Scheme; host: string;
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

proc validate_ContentDatafeedsCustombatch_579958(path: JsonNode; query: JsonNode;
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579960 = query.getOrDefault("key")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "key", valid_579960
  var valid_579961 = query.getOrDefault("prettyPrint")
  valid_579961 = validateParameter(valid_579961, JBool, required = false,
                                 default = newJBool(true))
  if valid_579961 != nil:
    section.add "prettyPrint", valid_579961
  var valid_579962 = query.getOrDefault("oauth_token")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "oauth_token", valid_579962
  var valid_579963 = query.getOrDefault("alt")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = newJString("json"))
  if valid_579963 != nil:
    section.add "alt", valid_579963
  var valid_579964 = query.getOrDefault("userIp")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "userIp", valid_579964
  var valid_579965 = query.getOrDefault("quotaUser")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "quotaUser", valid_579965
  var valid_579966 = query.getOrDefault("fields")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "fields", valid_579966
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579968: Call_ContentDatafeedsCustombatch_579957; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes, fetches, gets, inserts and updates multiple datafeeds in a single request.
  ## 
  let valid = call_579968.validator(path, query, header, formData, body)
  let scheme = call_579968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579968.url(scheme.get, call_579968.host, call_579968.base,
                         call_579968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579968, url, valid)

proc call*(call_579969: Call_ContentDatafeedsCustombatch_579957; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
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
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579970 = newJObject()
  var body_579971 = newJObject()
  add(query_579970, "key", newJString(key))
  add(query_579970, "prettyPrint", newJBool(prettyPrint))
  add(query_579970, "oauth_token", newJString(oauthToken))
  add(query_579970, "alt", newJString(alt))
  add(query_579970, "userIp", newJString(userIp))
  add(query_579970, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579971 = body
  add(query_579970, "fields", newJString(fields))
  result = call_579969.call(nil, query_579970, nil, nil, body_579971)

var contentDatafeedsCustombatch* = Call_ContentDatafeedsCustombatch_579957(
    name: "contentDatafeedsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/datafeeds/batch",
    validator: validate_ContentDatafeedsCustombatch_579958, base: "/content/v2.1",
    url: url_ContentDatafeedsCustombatch_579959, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesCustombatch_579972 = ref object of OpenApiRestCall_579373
proc url_ContentDatafeedstatusesCustombatch_579974(protocol: Scheme; host: string;
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

proc validate_ContentDatafeedstatusesCustombatch_579973(path: JsonNode;
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
  var valid_579975 = query.getOrDefault("key")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "key", valid_579975
  var valid_579976 = query.getOrDefault("prettyPrint")
  valid_579976 = validateParameter(valid_579976, JBool, required = false,
                                 default = newJBool(true))
  if valid_579976 != nil:
    section.add "prettyPrint", valid_579976
  var valid_579977 = query.getOrDefault("oauth_token")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "oauth_token", valid_579977
  var valid_579978 = query.getOrDefault("alt")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = newJString("json"))
  if valid_579978 != nil:
    section.add "alt", valid_579978
  var valid_579979 = query.getOrDefault("userIp")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "userIp", valid_579979
  var valid_579980 = query.getOrDefault("quotaUser")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "quotaUser", valid_579980
  var valid_579981 = query.getOrDefault("fields")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "fields", valid_579981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579983: Call_ContentDatafeedstatusesCustombatch_579972;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets multiple Merchant Center datafeed statuses in a single request.
  ## 
  let valid = call_579983.validator(path, query, header, formData, body)
  let scheme = call_579983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579983.url(scheme.get, call_579983.host, call_579983.base,
                         call_579983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579983, url, valid)

proc call*(call_579984: Call_ContentDatafeedstatusesCustombatch_579972;
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
  var query_579985 = newJObject()
  var body_579986 = newJObject()
  add(query_579985, "key", newJString(key))
  add(query_579985, "prettyPrint", newJBool(prettyPrint))
  add(query_579985, "oauth_token", newJString(oauthToken))
  add(query_579985, "alt", newJString(alt))
  add(query_579985, "userIp", newJString(userIp))
  add(query_579985, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579986 = body
  add(query_579985, "fields", newJString(fields))
  result = call_579984.call(nil, query_579985, nil, nil, body_579986)

var contentDatafeedstatusesCustombatch* = Call_ContentDatafeedstatusesCustombatch_579972(
    name: "contentDatafeedstatusesCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/datafeedstatuses/batch",
    validator: validate_ContentDatafeedstatusesCustombatch_579973,
    base: "/content/v2.1", url: url_ContentDatafeedstatusesCustombatch_579974,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsCustombatch_579987 = ref object of OpenApiRestCall_579373
proc url_ContentLiasettingsCustombatch_579989(protocol: Scheme; host: string;
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

proc validate_ContentLiasettingsCustombatch_579988(path: JsonNode; query: JsonNode;
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579990 = query.getOrDefault("key")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "key", valid_579990
  var valid_579991 = query.getOrDefault("prettyPrint")
  valid_579991 = validateParameter(valid_579991, JBool, required = false,
                                 default = newJBool(true))
  if valid_579991 != nil:
    section.add "prettyPrint", valid_579991
  var valid_579992 = query.getOrDefault("oauth_token")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "oauth_token", valid_579992
  var valid_579993 = query.getOrDefault("alt")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = newJString("json"))
  if valid_579993 != nil:
    section.add "alt", valid_579993
  var valid_579994 = query.getOrDefault("userIp")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "userIp", valid_579994
  var valid_579995 = query.getOrDefault("quotaUser")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "quotaUser", valid_579995
  var valid_579996 = query.getOrDefault("fields")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "fields", valid_579996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579998: Call_ContentLiasettingsCustombatch_579987; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves and/or updates the LIA settings of multiple accounts in a single request.
  ## 
  let valid = call_579998.validator(path, query, header, formData, body)
  let scheme = call_579998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579998.url(scheme.get, call_579998.host, call_579998.base,
                         call_579998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579998, url, valid)

proc call*(call_579999: Call_ContentLiasettingsCustombatch_579987;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
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
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580000 = newJObject()
  var body_580001 = newJObject()
  add(query_580000, "key", newJString(key))
  add(query_580000, "prettyPrint", newJBool(prettyPrint))
  add(query_580000, "oauth_token", newJString(oauthToken))
  add(query_580000, "alt", newJString(alt))
  add(query_580000, "userIp", newJString(userIp))
  add(query_580000, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580001 = body
  add(query_580000, "fields", newJString(fields))
  result = call_579999.call(nil, query_580000, nil, nil, body_580001)

var contentLiasettingsCustombatch* = Call_ContentLiasettingsCustombatch_579987(
    name: "contentLiasettingsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liasettings/batch",
    validator: validate_ContentLiasettingsCustombatch_579988,
    base: "/content/v2.1", url: url_ContentLiasettingsCustombatch_579989,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsListposdataproviders_580002 = ref object of OpenApiRestCall_579373
proc url_ContentLiasettingsListposdataproviders_580004(protocol: Scheme;
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

proc validate_ContentLiasettingsListposdataproviders_580003(path: JsonNode;
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
  var valid_580005 = query.getOrDefault("key")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "key", valid_580005
  var valid_580006 = query.getOrDefault("prettyPrint")
  valid_580006 = validateParameter(valid_580006, JBool, required = false,
                                 default = newJBool(true))
  if valid_580006 != nil:
    section.add "prettyPrint", valid_580006
  var valid_580007 = query.getOrDefault("oauth_token")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "oauth_token", valid_580007
  var valid_580008 = query.getOrDefault("alt")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = newJString("json"))
  if valid_580008 != nil:
    section.add "alt", valid_580008
  var valid_580009 = query.getOrDefault("userIp")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "userIp", valid_580009
  var valid_580010 = query.getOrDefault("quotaUser")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "quotaUser", valid_580010
  var valid_580011 = query.getOrDefault("fields")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "fields", valid_580011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580012: Call_ContentLiasettingsListposdataproviders_580002;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of POS data providers that have active settings for the all eiligible countries.
  ## 
  let valid = call_580012.validator(path, query, header, formData, body)
  let scheme = call_580012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580012.url(scheme.get, call_580012.host, call_580012.base,
                         call_580012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580012, url, valid)

proc call*(call_580013: Call_ContentLiasettingsListposdataproviders_580002;
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
  var query_580014 = newJObject()
  add(query_580014, "key", newJString(key))
  add(query_580014, "prettyPrint", newJBool(prettyPrint))
  add(query_580014, "oauth_token", newJString(oauthToken))
  add(query_580014, "alt", newJString(alt))
  add(query_580014, "userIp", newJString(userIp))
  add(query_580014, "quotaUser", newJString(quotaUser))
  add(query_580014, "fields", newJString(fields))
  result = call_580013.call(nil, query_580014, nil, nil, nil)

var contentLiasettingsListposdataproviders* = Call_ContentLiasettingsListposdataproviders_580002(
    name: "contentLiasettingsListposdataproviders", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/liasettings/posdataproviders",
    validator: validate_ContentLiasettingsListposdataproviders_580003,
    base: "/content/v2.1", url: url_ContentLiasettingsListposdataproviders_580004,
    schemes: {Scheme.Https})
type
  Call_ContentPosCustombatch_580015 = ref object of OpenApiRestCall_579373
proc url_ContentPosCustombatch_580017(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosCustombatch_580016(path: JsonNode; query: JsonNode;
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580018 = query.getOrDefault("key")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "key", valid_580018
  var valid_580019 = query.getOrDefault("prettyPrint")
  valid_580019 = validateParameter(valid_580019, JBool, required = false,
                                 default = newJBool(true))
  if valid_580019 != nil:
    section.add "prettyPrint", valid_580019
  var valid_580020 = query.getOrDefault("oauth_token")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "oauth_token", valid_580020
  var valid_580021 = query.getOrDefault("alt")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = newJString("json"))
  if valid_580021 != nil:
    section.add "alt", valid_580021
  var valid_580022 = query.getOrDefault("userIp")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "userIp", valid_580022
  var valid_580023 = query.getOrDefault("quotaUser")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "quotaUser", valid_580023
  var valid_580024 = query.getOrDefault("fields")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "fields", valid_580024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580026: Call_ContentPosCustombatch_580015; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Batches multiple POS-related calls in a single request.
  ## 
  let valid = call_580026.validator(path, query, header, formData, body)
  let scheme = call_580026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580026.url(scheme.get, call_580026.host, call_580026.base,
                         call_580026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580026, url, valid)

proc call*(call_580027: Call_ContentPosCustombatch_580015; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
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
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580028 = newJObject()
  var body_580029 = newJObject()
  add(query_580028, "key", newJString(key))
  add(query_580028, "prettyPrint", newJBool(prettyPrint))
  add(query_580028, "oauth_token", newJString(oauthToken))
  add(query_580028, "alt", newJString(alt))
  add(query_580028, "userIp", newJString(userIp))
  add(query_580028, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580029 = body
  add(query_580028, "fields", newJString(fields))
  result = call_580027.call(nil, query_580028, nil, nil, body_580029)

var contentPosCustombatch* = Call_ContentPosCustombatch_580015(
    name: "contentPosCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/pos/batch",
    validator: validate_ContentPosCustombatch_580016, base: "/content/v2.1",
    url: url_ContentPosCustombatch_580017, schemes: {Scheme.Https})
type
  Call_ContentProductsCustombatch_580030 = ref object of OpenApiRestCall_579373
proc url_ContentProductsCustombatch_580032(protocol: Scheme; host: string;
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

proc validate_ContentProductsCustombatch_580031(path: JsonNode; query: JsonNode;
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580033 = query.getOrDefault("key")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "key", valid_580033
  var valid_580034 = query.getOrDefault("prettyPrint")
  valid_580034 = validateParameter(valid_580034, JBool, required = false,
                                 default = newJBool(true))
  if valid_580034 != nil:
    section.add "prettyPrint", valid_580034
  var valid_580035 = query.getOrDefault("oauth_token")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "oauth_token", valid_580035
  var valid_580036 = query.getOrDefault("alt")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = newJString("json"))
  if valid_580036 != nil:
    section.add "alt", valid_580036
  var valid_580037 = query.getOrDefault("userIp")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "userIp", valid_580037
  var valid_580038 = query.getOrDefault("quotaUser")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "quotaUser", valid_580038
  var valid_580039 = query.getOrDefault("fields")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "fields", valid_580039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580041: Call_ContentProductsCustombatch_580030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves, inserts, and deletes multiple products in a single request.
  ## 
  let valid = call_580041.validator(path, query, header, formData, body)
  let scheme = call_580041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580041.url(scheme.get, call_580041.host, call_580041.base,
                         call_580041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580041, url, valid)

proc call*(call_580042: Call_ContentProductsCustombatch_580030; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
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
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580043 = newJObject()
  var body_580044 = newJObject()
  add(query_580043, "key", newJString(key))
  add(query_580043, "prettyPrint", newJBool(prettyPrint))
  add(query_580043, "oauth_token", newJString(oauthToken))
  add(query_580043, "alt", newJString(alt))
  add(query_580043, "userIp", newJString(userIp))
  add(query_580043, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580044 = body
  add(query_580043, "fields", newJString(fields))
  result = call_580042.call(nil, query_580043, nil, nil, body_580044)

var contentProductsCustombatch* = Call_ContentProductsCustombatch_580030(
    name: "contentProductsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/products/batch",
    validator: validate_ContentProductsCustombatch_580031, base: "/content/v2.1",
    url: url_ContentProductsCustombatch_580032, schemes: {Scheme.Https})
type
  Call_ContentProductstatusesCustombatch_580045 = ref object of OpenApiRestCall_579373
proc url_ContentProductstatusesCustombatch_580047(protocol: Scheme; host: string;
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

proc validate_ContentProductstatusesCustombatch_580046(path: JsonNode;
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580048 = query.getOrDefault("key")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "key", valid_580048
  var valid_580049 = query.getOrDefault("prettyPrint")
  valid_580049 = validateParameter(valid_580049, JBool, required = false,
                                 default = newJBool(true))
  if valid_580049 != nil:
    section.add "prettyPrint", valid_580049
  var valid_580050 = query.getOrDefault("oauth_token")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "oauth_token", valid_580050
  var valid_580051 = query.getOrDefault("alt")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = newJString("json"))
  if valid_580051 != nil:
    section.add "alt", valid_580051
  var valid_580052 = query.getOrDefault("userIp")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "userIp", valid_580052
  var valid_580053 = query.getOrDefault("quotaUser")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "quotaUser", valid_580053
  var valid_580054 = query.getOrDefault("fields")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "fields", valid_580054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580056: Call_ContentProductstatusesCustombatch_580045;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the statuses of multiple products in a single request.
  ## 
  let valid = call_580056.validator(path, query, header, formData, body)
  let scheme = call_580056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580056.url(scheme.get, call_580056.host, call_580056.base,
                         call_580056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580056, url, valid)

proc call*(call_580057: Call_ContentProductstatusesCustombatch_580045;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580058 = newJObject()
  var body_580059 = newJObject()
  add(query_580058, "key", newJString(key))
  add(query_580058, "prettyPrint", newJBool(prettyPrint))
  add(query_580058, "oauth_token", newJString(oauthToken))
  add(query_580058, "alt", newJString(alt))
  add(query_580058, "userIp", newJString(userIp))
  add(query_580058, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580059 = body
  add(query_580058, "fields", newJString(fields))
  result = call_580057.call(nil, query_580058, nil, nil, body_580059)

var contentProductstatusesCustombatch* = Call_ContentProductstatusesCustombatch_580045(
    name: "contentProductstatusesCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/productstatuses/batch",
    validator: validate_ContentProductstatusesCustombatch_580046,
    base: "/content/v2.1", url: url_ContentProductstatusesCustombatch_580047,
    schemes: {Scheme.Https})
type
  Call_ContentRegionalinventoryCustombatch_580060 = ref object of OpenApiRestCall_579373
proc url_ContentRegionalinventoryCustombatch_580062(protocol: Scheme; host: string;
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

proc validate_ContentRegionalinventoryCustombatch_580061(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates regional inventory for multiple products or regions in a single request.
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
  var valid_580063 = query.getOrDefault("key")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "key", valid_580063
  var valid_580064 = query.getOrDefault("prettyPrint")
  valid_580064 = validateParameter(valid_580064, JBool, required = false,
                                 default = newJBool(true))
  if valid_580064 != nil:
    section.add "prettyPrint", valid_580064
  var valid_580065 = query.getOrDefault("oauth_token")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "oauth_token", valid_580065
  var valid_580066 = query.getOrDefault("alt")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = newJString("json"))
  if valid_580066 != nil:
    section.add "alt", valid_580066
  var valid_580067 = query.getOrDefault("userIp")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "userIp", valid_580067
  var valid_580068 = query.getOrDefault("quotaUser")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "quotaUser", valid_580068
  var valid_580069 = query.getOrDefault("fields")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "fields", valid_580069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580071: Call_ContentRegionalinventoryCustombatch_580060;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates regional inventory for multiple products or regions in a single request.
  ## 
  let valid = call_580071.validator(path, query, header, formData, body)
  let scheme = call_580071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580071.url(scheme.get, call_580071.host, call_580071.base,
                         call_580071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580071, url, valid)

proc call*(call_580072: Call_ContentRegionalinventoryCustombatch_580060;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentRegionalinventoryCustombatch
  ## Updates regional inventory for multiple products or regions in a single request.
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
  var query_580073 = newJObject()
  var body_580074 = newJObject()
  add(query_580073, "key", newJString(key))
  add(query_580073, "prettyPrint", newJBool(prettyPrint))
  add(query_580073, "oauth_token", newJString(oauthToken))
  add(query_580073, "alt", newJString(alt))
  add(query_580073, "userIp", newJString(userIp))
  add(query_580073, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580074 = body
  add(query_580073, "fields", newJString(fields))
  result = call_580072.call(nil, query_580073, nil, nil, body_580074)

var contentRegionalinventoryCustombatch* = Call_ContentRegionalinventoryCustombatch_580060(
    name: "contentRegionalinventoryCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/regionalinventory/batch",
    validator: validate_ContentRegionalinventoryCustombatch_580061,
    base: "/content/v2.1", url: url_ContentRegionalinventoryCustombatch_580062,
    schemes: {Scheme.Https})
type
  Call_ContentReturnaddressCustombatch_580075 = ref object of OpenApiRestCall_579373
proc url_ContentReturnaddressCustombatch_580077(protocol: Scheme; host: string;
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

proc validate_ContentReturnaddressCustombatch_580076(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Batches multiple return address related calls in a single request.
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
  var valid_580078 = query.getOrDefault("key")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "key", valid_580078
  var valid_580079 = query.getOrDefault("prettyPrint")
  valid_580079 = validateParameter(valid_580079, JBool, required = false,
                                 default = newJBool(true))
  if valid_580079 != nil:
    section.add "prettyPrint", valid_580079
  var valid_580080 = query.getOrDefault("oauth_token")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "oauth_token", valid_580080
  var valid_580081 = query.getOrDefault("alt")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = newJString("json"))
  if valid_580081 != nil:
    section.add "alt", valid_580081
  var valid_580082 = query.getOrDefault("userIp")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "userIp", valid_580082
  var valid_580083 = query.getOrDefault("quotaUser")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "quotaUser", valid_580083
  var valid_580084 = query.getOrDefault("fields")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "fields", valid_580084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580086: Call_ContentReturnaddressCustombatch_580075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Batches multiple return address related calls in a single request.
  ## 
  let valid = call_580086.validator(path, query, header, formData, body)
  let scheme = call_580086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580086.url(scheme.get, call_580086.host, call_580086.base,
                         call_580086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580086, url, valid)

proc call*(call_580087: Call_ContentReturnaddressCustombatch_580075;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentReturnaddressCustombatch
  ## Batches multiple return address related calls in a single request.
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
  var query_580088 = newJObject()
  var body_580089 = newJObject()
  add(query_580088, "key", newJString(key))
  add(query_580088, "prettyPrint", newJBool(prettyPrint))
  add(query_580088, "oauth_token", newJString(oauthToken))
  add(query_580088, "alt", newJString(alt))
  add(query_580088, "userIp", newJString(userIp))
  add(query_580088, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580089 = body
  add(query_580088, "fields", newJString(fields))
  result = call_580087.call(nil, query_580088, nil, nil, body_580089)

var contentReturnaddressCustombatch* = Call_ContentReturnaddressCustombatch_580075(
    name: "contentReturnaddressCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/returnaddress/batch",
    validator: validate_ContentReturnaddressCustombatch_580076,
    base: "/content/v2.1", url: url_ContentReturnaddressCustombatch_580077,
    schemes: {Scheme.Https})
type
  Call_ContentReturnpolicyCustombatch_580090 = ref object of OpenApiRestCall_579373
proc url_ContentReturnpolicyCustombatch_580092(protocol: Scheme; host: string;
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

proc validate_ContentReturnpolicyCustombatch_580091(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Batches multiple return policy related calls in a single request.
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
  var valid_580093 = query.getOrDefault("key")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "key", valid_580093
  var valid_580094 = query.getOrDefault("prettyPrint")
  valid_580094 = validateParameter(valid_580094, JBool, required = false,
                                 default = newJBool(true))
  if valid_580094 != nil:
    section.add "prettyPrint", valid_580094
  var valid_580095 = query.getOrDefault("oauth_token")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "oauth_token", valid_580095
  var valid_580096 = query.getOrDefault("alt")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = newJString("json"))
  if valid_580096 != nil:
    section.add "alt", valid_580096
  var valid_580097 = query.getOrDefault("userIp")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "userIp", valid_580097
  var valid_580098 = query.getOrDefault("quotaUser")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "quotaUser", valid_580098
  var valid_580099 = query.getOrDefault("fields")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "fields", valid_580099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580101: Call_ContentReturnpolicyCustombatch_580090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Batches multiple return policy related calls in a single request.
  ## 
  let valid = call_580101.validator(path, query, header, formData, body)
  let scheme = call_580101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580101.url(scheme.get, call_580101.host, call_580101.base,
                         call_580101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580101, url, valid)

proc call*(call_580102: Call_ContentReturnpolicyCustombatch_580090;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentReturnpolicyCustombatch
  ## Batches multiple return policy related calls in a single request.
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
  var query_580103 = newJObject()
  var body_580104 = newJObject()
  add(query_580103, "key", newJString(key))
  add(query_580103, "prettyPrint", newJBool(prettyPrint))
  add(query_580103, "oauth_token", newJString(oauthToken))
  add(query_580103, "alt", newJString(alt))
  add(query_580103, "userIp", newJString(userIp))
  add(query_580103, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580104 = body
  add(query_580103, "fields", newJString(fields))
  result = call_580102.call(nil, query_580103, nil, nil, body_580104)

var contentReturnpolicyCustombatch* = Call_ContentReturnpolicyCustombatch_580090(
    name: "contentReturnpolicyCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/returnpolicy/batch",
    validator: validate_ContentReturnpolicyCustombatch_580091,
    base: "/content/v2.1", url: url_ContentReturnpolicyCustombatch_580092,
    schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsCustombatch_580105 = ref object of OpenApiRestCall_579373
proc url_ContentShippingsettingsCustombatch_580107(protocol: Scheme; host: string;
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

proc validate_ContentShippingsettingsCustombatch_580106(path: JsonNode;
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580108 = query.getOrDefault("key")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "key", valid_580108
  var valid_580109 = query.getOrDefault("prettyPrint")
  valid_580109 = validateParameter(valid_580109, JBool, required = false,
                                 default = newJBool(true))
  if valid_580109 != nil:
    section.add "prettyPrint", valid_580109
  var valid_580110 = query.getOrDefault("oauth_token")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "oauth_token", valid_580110
  var valid_580111 = query.getOrDefault("alt")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = newJString("json"))
  if valid_580111 != nil:
    section.add "alt", valid_580111
  var valid_580112 = query.getOrDefault("userIp")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "userIp", valid_580112
  var valid_580113 = query.getOrDefault("quotaUser")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "quotaUser", valid_580113
  var valid_580114 = query.getOrDefault("fields")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "fields", valid_580114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580116: Call_ContentShippingsettingsCustombatch_580105;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves and updates the shipping settings of multiple accounts in a single request.
  ## 
  let valid = call_580116.validator(path, query, header, formData, body)
  let scheme = call_580116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580116.url(scheme.get, call_580116.host, call_580116.base,
                         call_580116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580116, url, valid)

proc call*(call_580117: Call_ContentShippingsettingsCustombatch_580105;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
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
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580118 = newJObject()
  var body_580119 = newJObject()
  add(query_580118, "key", newJString(key))
  add(query_580118, "prettyPrint", newJBool(prettyPrint))
  add(query_580118, "oauth_token", newJString(oauthToken))
  add(query_580118, "alt", newJString(alt))
  add(query_580118, "userIp", newJString(userIp))
  add(query_580118, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580119 = body
  add(query_580118, "fields", newJString(fields))
  result = call_580117.call(nil, query_580118, nil, nil, body_580119)

var contentShippingsettingsCustombatch* = Call_ContentShippingsettingsCustombatch_580105(
    name: "contentShippingsettingsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/shippingsettings/batch",
    validator: validate_ContentShippingsettingsCustombatch_580106,
    base: "/content/v2.1", url: url_ContentShippingsettingsCustombatch_580107,
    schemes: {Scheme.Https})
type
  Call_ContentAccountsInsert_580151 = ref object of OpenApiRestCall_579373
proc url_ContentAccountsInsert_580153(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsInsert_580152(path: JsonNode; query: JsonNode;
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
  var valid_580154 = path.getOrDefault("merchantId")
  valid_580154 = validateParameter(valid_580154, JString, required = true,
                                 default = nil)
  if valid_580154 != nil:
    section.add "merchantId", valid_580154
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
  var valid_580155 = query.getOrDefault("key")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "key", valid_580155
  var valid_580156 = query.getOrDefault("prettyPrint")
  valid_580156 = validateParameter(valid_580156, JBool, required = false,
                                 default = newJBool(true))
  if valid_580156 != nil:
    section.add "prettyPrint", valid_580156
  var valid_580157 = query.getOrDefault("oauth_token")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "oauth_token", valid_580157
  var valid_580158 = query.getOrDefault("alt")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = newJString("json"))
  if valid_580158 != nil:
    section.add "alt", valid_580158
  var valid_580159 = query.getOrDefault("userIp")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "userIp", valid_580159
  var valid_580160 = query.getOrDefault("quotaUser")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "quotaUser", valid_580160
  var valid_580161 = query.getOrDefault("fields")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "fields", valid_580161
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580163: Call_ContentAccountsInsert_580151; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Merchant Center sub-account.
  ## 
  let valid = call_580163.validator(path, query, header, formData, body)
  let scheme = call_580163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580163.url(scheme.get, call_580163.host, call_580163.base,
                         call_580163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580163, url, valid)

proc call*(call_580164: Call_ContentAccountsInsert_580151; merchantId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
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
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580165 = newJObject()
  var query_580166 = newJObject()
  var body_580167 = newJObject()
  add(query_580166, "key", newJString(key))
  add(query_580166, "prettyPrint", newJBool(prettyPrint))
  add(query_580166, "oauth_token", newJString(oauthToken))
  add(query_580166, "alt", newJString(alt))
  add(query_580166, "userIp", newJString(userIp))
  add(query_580166, "quotaUser", newJString(quotaUser))
  add(path_580165, "merchantId", newJString(merchantId))
  if body != nil:
    body_580167 = body
  add(query_580166, "fields", newJString(fields))
  result = call_580164.call(path_580165, query_580166, nil, nil, body_580167)

var contentAccountsInsert* = Call_ContentAccountsInsert_580151(
    name: "contentAccountsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/accounts",
    validator: validate_ContentAccountsInsert_580152, base: "/content/v2.1",
    url: url_ContentAccountsInsert_580153, schemes: {Scheme.Https})
type
  Call_ContentAccountsList_580120 = ref object of OpenApiRestCall_579373
proc url_ContentAccountsList_580122(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsList_580121(path: JsonNode; query: JsonNode;
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
  var valid_580137 = path.getOrDefault("merchantId")
  valid_580137 = validateParameter(valid_580137, JString, required = true,
                                 default = nil)
  if valid_580137 != nil:
    section.add "merchantId", valid_580137
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
  var valid_580138 = query.getOrDefault("key")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "key", valid_580138
  var valid_580139 = query.getOrDefault("prettyPrint")
  valid_580139 = validateParameter(valid_580139, JBool, required = false,
                                 default = newJBool(true))
  if valid_580139 != nil:
    section.add "prettyPrint", valid_580139
  var valid_580140 = query.getOrDefault("oauth_token")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "oauth_token", valid_580140
  var valid_580141 = query.getOrDefault("alt")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = newJString("json"))
  if valid_580141 != nil:
    section.add "alt", valid_580141
  var valid_580142 = query.getOrDefault("userIp")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "userIp", valid_580142
  var valid_580143 = query.getOrDefault("quotaUser")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "quotaUser", valid_580143
  var valid_580144 = query.getOrDefault("pageToken")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "pageToken", valid_580144
  var valid_580145 = query.getOrDefault("fields")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "fields", valid_580145
  var valid_580146 = query.getOrDefault("maxResults")
  valid_580146 = validateParameter(valid_580146, JInt, required = false, default = nil)
  if valid_580146 != nil:
    section.add "maxResults", valid_580146
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580147: Call_ContentAccountsList_580120; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_580147.validator(path, query, header, formData, body)
  let scheme = call_580147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580147.url(scheme.get, call_580147.host, call_580147.base,
                         call_580147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580147, url, valid)

proc call*(call_580148: Call_ContentAccountsList_580120; merchantId: string;
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
  var path_580149 = newJObject()
  var query_580150 = newJObject()
  add(query_580150, "key", newJString(key))
  add(query_580150, "prettyPrint", newJBool(prettyPrint))
  add(query_580150, "oauth_token", newJString(oauthToken))
  add(query_580150, "alt", newJString(alt))
  add(query_580150, "userIp", newJString(userIp))
  add(query_580150, "quotaUser", newJString(quotaUser))
  add(path_580149, "merchantId", newJString(merchantId))
  add(query_580150, "pageToken", newJString(pageToken))
  add(query_580150, "fields", newJString(fields))
  add(query_580150, "maxResults", newJInt(maxResults))
  result = call_580148.call(path_580149, query_580150, nil, nil, nil)

var contentAccountsList* = Call_ContentAccountsList_580120(
    name: "contentAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounts",
    validator: validate_ContentAccountsList_580121, base: "/content/v2.1",
    url: url_ContentAccountsList_580122, schemes: {Scheme.Https})
type
  Call_ContentAccountsUpdate_580184 = ref object of OpenApiRestCall_579373
proc url_ContentAccountsUpdate_580186(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsUpdate_580185(path: JsonNode; query: JsonNode;
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
  var valid_580187 = path.getOrDefault("merchantId")
  valid_580187 = validateParameter(valid_580187, JString, required = true,
                                 default = nil)
  if valid_580187 != nil:
    section.add "merchantId", valid_580187
  var valid_580188 = path.getOrDefault("accountId")
  valid_580188 = validateParameter(valid_580188, JString, required = true,
                                 default = nil)
  if valid_580188 != nil:
    section.add "accountId", valid_580188
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
  var valid_580189 = query.getOrDefault("key")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "key", valid_580189
  var valid_580190 = query.getOrDefault("prettyPrint")
  valid_580190 = validateParameter(valid_580190, JBool, required = false,
                                 default = newJBool(true))
  if valid_580190 != nil:
    section.add "prettyPrint", valid_580190
  var valid_580191 = query.getOrDefault("oauth_token")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "oauth_token", valid_580191
  var valid_580192 = query.getOrDefault("alt")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = newJString("json"))
  if valid_580192 != nil:
    section.add "alt", valid_580192
  var valid_580193 = query.getOrDefault("userIp")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "userIp", valid_580193
  var valid_580194 = query.getOrDefault("quotaUser")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "quotaUser", valid_580194
  var valid_580195 = query.getOrDefault("fields")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "fields", valid_580195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580197: Call_ContentAccountsUpdate_580184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Merchant Center account.
  ## 
  let valid = call_580197.validator(path, query, header, formData, body)
  let scheme = call_580197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580197.url(scheme.get, call_580197.host, call_580197.base,
                         call_580197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580197, url, valid)

proc call*(call_580198: Call_ContentAccountsUpdate_580184; merchantId: string;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
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
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The ID of the account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580199 = newJObject()
  var query_580200 = newJObject()
  var body_580201 = newJObject()
  add(query_580200, "key", newJString(key))
  add(query_580200, "prettyPrint", newJBool(prettyPrint))
  add(query_580200, "oauth_token", newJString(oauthToken))
  add(query_580200, "alt", newJString(alt))
  add(query_580200, "userIp", newJString(userIp))
  add(query_580200, "quotaUser", newJString(quotaUser))
  add(path_580199, "merchantId", newJString(merchantId))
  if body != nil:
    body_580201 = body
  add(path_580199, "accountId", newJString(accountId))
  add(query_580200, "fields", newJString(fields))
  result = call_580198.call(path_580199, query_580200, nil, nil, body_580201)

var contentAccountsUpdate* = Call_ContentAccountsUpdate_580184(
    name: "contentAccountsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsUpdate_580185, base: "/content/v2.1",
    url: url_ContentAccountsUpdate_580186, schemes: {Scheme.Https})
type
  Call_ContentAccountsGet_580168 = ref object of OpenApiRestCall_579373
proc url_ContentAccountsGet_580170(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsGet_580169(path: JsonNode; query: JsonNode;
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
  var valid_580171 = path.getOrDefault("merchantId")
  valid_580171 = validateParameter(valid_580171, JString, required = true,
                                 default = nil)
  if valid_580171 != nil:
    section.add "merchantId", valid_580171
  var valid_580172 = path.getOrDefault("accountId")
  valid_580172 = validateParameter(valid_580172, JString, required = true,
                                 default = nil)
  if valid_580172 != nil:
    section.add "accountId", valid_580172
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
  var valid_580173 = query.getOrDefault("key")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "key", valid_580173
  var valid_580174 = query.getOrDefault("prettyPrint")
  valid_580174 = validateParameter(valid_580174, JBool, required = false,
                                 default = newJBool(true))
  if valid_580174 != nil:
    section.add "prettyPrint", valid_580174
  var valid_580175 = query.getOrDefault("oauth_token")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "oauth_token", valid_580175
  var valid_580176 = query.getOrDefault("alt")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = newJString("json"))
  if valid_580176 != nil:
    section.add "alt", valid_580176
  var valid_580177 = query.getOrDefault("userIp")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "userIp", valid_580177
  var valid_580178 = query.getOrDefault("quotaUser")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "quotaUser", valid_580178
  var valid_580179 = query.getOrDefault("fields")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "fields", valid_580179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580180: Call_ContentAccountsGet_580168; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a Merchant Center account.
  ## 
  let valid = call_580180.validator(path, query, header, formData, body)
  let scheme = call_580180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580180.url(scheme.get, call_580180.host, call_580180.base,
                         call_580180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580180, url, valid)

proc call*(call_580181: Call_ContentAccountsGet_580168; merchantId: string;
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
  var path_580182 = newJObject()
  var query_580183 = newJObject()
  add(query_580183, "key", newJString(key))
  add(query_580183, "prettyPrint", newJBool(prettyPrint))
  add(query_580183, "oauth_token", newJString(oauthToken))
  add(query_580183, "alt", newJString(alt))
  add(query_580183, "userIp", newJString(userIp))
  add(query_580183, "quotaUser", newJString(quotaUser))
  add(path_580182, "merchantId", newJString(merchantId))
  add(path_580182, "accountId", newJString(accountId))
  add(query_580183, "fields", newJString(fields))
  result = call_580181.call(path_580182, query_580183, nil, nil, nil)

var contentAccountsGet* = Call_ContentAccountsGet_580168(
    name: "contentAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsGet_580169, base: "/content/v2.1",
    url: url_ContentAccountsGet_580170, schemes: {Scheme.Https})
type
  Call_ContentAccountsDelete_580202 = ref object of OpenApiRestCall_579373
proc url_ContentAccountsDelete_580204(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsDelete_580203(path: JsonNode; query: JsonNode;
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
  var valid_580205 = path.getOrDefault("merchantId")
  valid_580205 = validateParameter(valid_580205, JString, required = true,
                                 default = nil)
  if valid_580205 != nil:
    section.add "merchantId", valid_580205
  var valid_580206 = path.getOrDefault("accountId")
  valid_580206 = validateParameter(valid_580206, JString, required = true,
                                 default = nil)
  if valid_580206 != nil:
    section.add "accountId", valid_580206
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
  ##   force: JBool
  ##        : Flag to delete sub-accounts with products. The default value is false.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580207 = query.getOrDefault("key")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "key", valid_580207
  var valid_580208 = query.getOrDefault("prettyPrint")
  valid_580208 = validateParameter(valid_580208, JBool, required = false,
                                 default = newJBool(true))
  if valid_580208 != nil:
    section.add "prettyPrint", valid_580208
  var valid_580209 = query.getOrDefault("oauth_token")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "oauth_token", valid_580209
  var valid_580210 = query.getOrDefault("alt")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = newJString("json"))
  if valid_580210 != nil:
    section.add "alt", valid_580210
  var valid_580211 = query.getOrDefault("userIp")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "userIp", valid_580211
  var valid_580212 = query.getOrDefault("quotaUser")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "quotaUser", valid_580212
  var valid_580213 = query.getOrDefault("force")
  valid_580213 = validateParameter(valid_580213, JBool, required = false,
                                 default = newJBool(false))
  if valid_580213 != nil:
    section.add "force", valid_580213
  var valid_580214 = query.getOrDefault("fields")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "fields", valid_580214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580215: Call_ContentAccountsDelete_580202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Merchant Center sub-account.
  ## 
  let valid = call_580215.validator(path, query, header, formData, body)
  let scheme = call_580215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580215.url(scheme.get, call_580215.host, call_580215.base,
                         call_580215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580215, url, valid)

proc call*(call_580216: Call_ContentAccountsDelete_580202; merchantId: string;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; force: bool = false; fields: string = ""): Recallable =
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
  ##   force: bool
  ##        : Flag to delete sub-accounts with products. The default value is false.
  ##   accountId: string (required)
  ##            : The ID of the account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580217 = newJObject()
  var query_580218 = newJObject()
  add(query_580218, "key", newJString(key))
  add(query_580218, "prettyPrint", newJBool(prettyPrint))
  add(query_580218, "oauth_token", newJString(oauthToken))
  add(query_580218, "alt", newJString(alt))
  add(query_580218, "userIp", newJString(userIp))
  add(query_580218, "quotaUser", newJString(quotaUser))
  add(path_580217, "merchantId", newJString(merchantId))
  add(query_580218, "force", newJBool(force))
  add(path_580217, "accountId", newJString(accountId))
  add(query_580218, "fields", newJString(fields))
  result = call_580216.call(path_580217, query_580218, nil, nil, nil)

var contentAccountsDelete* = Call_ContentAccountsDelete_580202(
    name: "contentAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsDelete_580203, base: "/content/v2.1",
    url: url_ContentAccountsDelete_580204, schemes: {Scheme.Https})
type
  Call_ContentAccountsClaimwebsite_580219 = ref object of OpenApiRestCall_579373
proc url_ContentAccountsClaimwebsite_580221(protocol: Scheme; host: string;
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

proc validate_ContentAccountsClaimwebsite_580220(path: JsonNode; query: JsonNode;
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
  var valid_580222 = path.getOrDefault("merchantId")
  valid_580222 = validateParameter(valid_580222, JString, required = true,
                                 default = nil)
  if valid_580222 != nil:
    section.add "merchantId", valid_580222
  var valid_580223 = path.getOrDefault("accountId")
  valid_580223 = validateParameter(valid_580223, JString, required = true,
                                 default = nil)
  if valid_580223 != nil:
    section.add "accountId", valid_580223
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
  var valid_580226 = query.getOrDefault("oauth_token")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "oauth_token", valid_580226
  var valid_580227 = query.getOrDefault("overwrite")
  valid_580227 = validateParameter(valid_580227, JBool, required = false, default = nil)
  if valid_580227 != nil:
    section.add "overwrite", valid_580227
  var valid_580228 = query.getOrDefault("alt")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = newJString("json"))
  if valid_580228 != nil:
    section.add "alt", valid_580228
  var valid_580229 = query.getOrDefault("userIp")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "userIp", valid_580229
  var valid_580230 = query.getOrDefault("quotaUser")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "quotaUser", valid_580230
  var valid_580231 = query.getOrDefault("fields")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "fields", valid_580231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580232: Call_ContentAccountsClaimwebsite_580219; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Claims the website of a Merchant Center sub-account.
  ## 
  let valid = call_580232.validator(path, query, header, formData, body)
  let scheme = call_580232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580232.url(scheme.get, call_580232.host, call_580232.base,
                         call_580232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580232, url, valid)

proc call*(call_580233: Call_ContentAccountsClaimwebsite_580219;
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
  var path_580234 = newJObject()
  var query_580235 = newJObject()
  add(query_580235, "key", newJString(key))
  add(query_580235, "prettyPrint", newJBool(prettyPrint))
  add(query_580235, "oauth_token", newJString(oauthToken))
  add(query_580235, "overwrite", newJBool(overwrite))
  add(query_580235, "alt", newJString(alt))
  add(query_580235, "userIp", newJString(userIp))
  add(query_580235, "quotaUser", newJString(quotaUser))
  add(path_580234, "merchantId", newJString(merchantId))
  add(path_580234, "accountId", newJString(accountId))
  add(query_580235, "fields", newJString(fields))
  result = call_580233.call(path_580234, query_580235, nil, nil, nil)

var contentAccountsClaimwebsite* = Call_ContentAccountsClaimwebsite_580219(
    name: "contentAccountsClaimwebsite", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/accounts/{accountId}/claimwebsite",
    validator: validate_ContentAccountsClaimwebsite_580220, base: "/content/v2.1",
    url: url_ContentAccountsClaimwebsite_580221, schemes: {Scheme.Https})
type
  Call_ContentAccountsLink_580236 = ref object of OpenApiRestCall_579373
proc url_ContentAccountsLink_580238(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsLink_580237(path: JsonNode; query: JsonNode;
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
  var valid_580239 = path.getOrDefault("merchantId")
  valid_580239 = validateParameter(valid_580239, JString, required = true,
                                 default = nil)
  if valid_580239 != nil:
    section.add "merchantId", valid_580239
  var valid_580240 = path.getOrDefault("accountId")
  valid_580240 = validateParameter(valid_580240, JString, required = true,
                                 default = nil)
  if valid_580240 != nil:
    section.add "accountId", valid_580240
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
  var valid_580241 = query.getOrDefault("key")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "key", valid_580241
  var valid_580242 = query.getOrDefault("prettyPrint")
  valid_580242 = validateParameter(valid_580242, JBool, required = false,
                                 default = newJBool(true))
  if valid_580242 != nil:
    section.add "prettyPrint", valid_580242
  var valid_580243 = query.getOrDefault("oauth_token")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "oauth_token", valid_580243
  var valid_580244 = query.getOrDefault("alt")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = newJString("json"))
  if valid_580244 != nil:
    section.add "alt", valid_580244
  var valid_580245 = query.getOrDefault("userIp")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "userIp", valid_580245
  var valid_580246 = query.getOrDefault("quotaUser")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "quotaUser", valid_580246
  var valid_580247 = query.getOrDefault("fields")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "fields", valid_580247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580249: Call_ContentAccountsLink_580236; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs an action on a link between two Merchant Center accounts, namely accountId and linkedAccountId.
  ## 
  let valid = call_580249.validator(path, query, header, formData, body)
  let scheme = call_580249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580249.url(scheme.get, call_580249.host, call_580249.base,
                         call_580249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580249, url, valid)

proc call*(call_580250: Call_ContentAccountsLink_580236; merchantId: string;
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
  var path_580251 = newJObject()
  var query_580252 = newJObject()
  var body_580253 = newJObject()
  add(query_580252, "key", newJString(key))
  add(query_580252, "prettyPrint", newJBool(prettyPrint))
  add(query_580252, "oauth_token", newJString(oauthToken))
  add(query_580252, "alt", newJString(alt))
  add(query_580252, "userIp", newJString(userIp))
  add(query_580252, "quotaUser", newJString(quotaUser))
  add(path_580251, "merchantId", newJString(merchantId))
  if body != nil:
    body_580253 = body
  add(path_580251, "accountId", newJString(accountId))
  add(query_580252, "fields", newJString(fields))
  result = call_580250.call(path_580251, query_580252, nil, nil, body_580253)

var contentAccountsLink* = Call_ContentAccountsLink_580236(
    name: "contentAccountsLink", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}/link",
    validator: validate_ContentAccountsLink_580237, base: "/content/v2.1",
    url: url_ContentAccountsLink_580238, schemes: {Scheme.Https})
type
  Call_ContentAccountstatusesList_580254 = ref object of OpenApiRestCall_579373
proc url_ContentAccountstatusesList_580256(protocol: Scheme; host: string;
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

proc validate_ContentAccountstatusesList_580255(path: JsonNode; query: JsonNode;
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
  var valid_580257 = path.getOrDefault("merchantId")
  valid_580257 = validateParameter(valid_580257, JString, required = true,
                                 default = nil)
  if valid_580257 != nil:
    section.add "merchantId", valid_580257
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
  var valid_580258 = query.getOrDefault("key")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "key", valid_580258
  var valid_580259 = query.getOrDefault("prettyPrint")
  valid_580259 = validateParameter(valid_580259, JBool, required = false,
                                 default = newJBool(true))
  if valid_580259 != nil:
    section.add "prettyPrint", valid_580259
  var valid_580260 = query.getOrDefault("oauth_token")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "oauth_token", valid_580260
  var valid_580261 = query.getOrDefault("alt")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = newJString("json"))
  if valid_580261 != nil:
    section.add "alt", valid_580261
  var valid_580262 = query.getOrDefault("userIp")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "userIp", valid_580262
  var valid_580263 = query.getOrDefault("quotaUser")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "quotaUser", valid_580263
  var valid_580264 = query.getOrDefault("pageToken")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "pageToken", valid_580264
  var valid_580265 = query.getOrDefault("destinations")
  valid_580265 = validateParameter(valid_580265, JArray, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "destinations", valid_580265
  var valid_580266 = query.getOrDefault("fields")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "fields", valid_580266
  var valid_580267 = query.getOrDefault("maxResults")
  valid_580267 = validateParameter(valid_580267, JInt, required = false, default = nil)
  if valid_580267 != nil:
    section.add "maxResults", valid_580267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580268: Call_ContentAccountstatusesList_580254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_580268.validator(path, query, header, formData, body)
  let scheme = call_580268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580268.url(scheme.get, call_580268.host, call_580268.base,
                         call_580268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580268, url, valid)

proc call*(call_580269: Call_ContentAccountstatusesList_580254; merchantId: string;
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
  var path_580270 = newJObject()
  var query_580271 = newJObject()
  add(query_580271, "key", newJString(key))
  add(query_580271, "prettyPrint", newJBool(prettyPrint))
  add(query_580271, "oauth_token", newJString(oauthToken))
  add(query_580271, "alt", newJString(alt))
  add(query_580271, "userIp", newJString(userIp))
  add(query_580271, "quotaUser", newJString(quotaUser))
  add(path_580270, "merchantId", newJString(merchantId))
  add(query_580271, "pageToken", newJString(pageToken))
  if destinations != nil:
    query_580271.add "destinations", destinations
  add(query_580271, "fields", newJString(fields))
  add(query_580271, "maxResults", newJInt(maxResults))
  result = call_580269.call(path_580270, query_580271, nil, nil, nil)

var contentAccountstatusesList* = Call_ContentAccountstatusesList_580254(
    name: "contentAccountstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accountstatuses",
    validator: validate_ContentAccountstatusesList_580255, base: "/content/v2.1",
    url: url_ContentAccountstatusesList_580256, schemes: {Scheme.Https})
type
  Call_ContentAccountstatusesGet_580272 = ref object of OpenApiRestCall_579373
proc url_ContentAccountstatusesGet_580274(protocol: Scheme; host: string;
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

proc validate_ContentAccountstatusesGet_580273(path: JsonNode; query: JsonNode;
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
  var valid_580275 = path.getOrDefault("merchantId")
  valid_580275 = validateParameter(valid_580275, JString, required = true,
                                 default = nil)
  if valid_580275 != nil:
    section.add "merchantId", valid_580275
  var valid_580276 = path.getOrDefault("accountId")
  valid_580276 = validateParameter(valid_580276, JString, required = true,
                                 default = nil)
  if valid_580276 != nil:
    section.add "accountId", valid_580276
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
  var valid_580277 = query.getOrDefault("key")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "key", valid_580277
  var valid_580278 = query.getOrDefault("prettyPrint")
  valid_580278 = validateParameter(valid_580278, JBool, required = false,
                                 default = newJBool(true))
  if valid_580278 != nil:
    section.add "prettyPrint", valid_580278
  var valid_580279 = query.getOrDefault("oauth_token")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "oauth_token", valid_580279
  var valid_580280 = query.getOrDefault("alt")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = newJString("json"))
  if valid_580280 != nil:
    section.add "alt", valid_580280
  var valid_580281 = query.getOrDefault("userIp")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "userIp", valid_580281
  var valid_580282 = query.getOrDefault("quotaUser")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "quotaUser", valid_580282
  var valid_580283 = query.getOrDefault("destinations")
  valid_580283 = validateParameter(valid_580283, JArray, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "destinations", valid_580283
  var valid_580284 = query.getOrDefault("fields")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "fields", valid_580284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580285: Call_ContentAccountstatusesGet_580272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the status of a Merchant Center account. No itemLevelIssues are returned for multi-client accounts.
  ## 
  let valid = call_580285.validator(path, query, header, formData, body)
  let scheme = call_580285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580285.url(scheme.get, call_580285.host, call_580285.base,
                         call_580285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580285, url, valid)

proc call*(call_580286: Call_ContentAccountstatusesGet_580272; merchantId: string;
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
  var path_580287 = newJObject()
  var query_580288 = newJObject()
  add(query_580288, "key", newJString(key))
  add(query_580288, "prettyPrint", newJBool(prettyPrint))
  add(query_580288, "oauth_token", newJString(oauthToken))
  add(query_580288, "alt", newJString(alt))
  add(query_580288, "userIp", newJString(userIp))
  add(query_580288, "quotaUser", newJString(quotaUser))
  add(path_580287, "merchantId", newJString(merchantId))
  if destinations != nil:
    query_580288.add "destinations", destinations
  add(path_580287, "accountId", newJString(accountId))
  add(query_580288, "fields", newJString(fields))
  result = call_580286.call(path_580287, query_580288, nil, nil, nil)

var contentAccountstatusesGet* = Call_ContentAccountstatusesGet_580272(
    name: "contentAccountstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/accountstatuses/{accountId}",
    validator: validate_ContentAccountstatusesGet_580273, base: "/content/v2.1",
    url: url_ContentAccountstatusesGet_580274, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxList_580289 = ref object of OpenApiRestCall_579373
proc url_ContentAccounttaxList_580291(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccounttaxList_580290(path: JsonNode; query: JsonNode;
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
  var valid_580292 = path.getOrDefault("merchantId")
  valid_580292 = validateParameter(valid_580292, JString, required = true,
                                 default = nil)
  if valid_580292 != nil:
    section.add "merchantId", valid_580292
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
  var valid_580293 = query.getOrDefault("key")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "key", valid_580293
  var valid_580294 = query.getOrDefault("prettyPrint")
  valid_580294 = validateParameter(valid_580294, JBool, required = false,
                                 default = newJBool(true))
  if valid_580294 != nil:
    section.add "prettyPrint", valid_580294
  var valid_580295 = query.getOrDefault("oauth_token")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "oauth_token", valid_580295
  var valid_580296 = query.getOrDefault("alt")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = newJString("json"))
  if valid_580296 != nil:
    section.add "alt", valid_580296
  var valid_580297 = query.getOrDefault("userIp")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "userIp", valid_580297
  var valid_580298 = query.getOrDefault("quotaUser")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "quotaUser", valid_580298
  var valid_580299 = query.getOrDefault("pageToken")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "pageToken", valid_580299
  var valid_580300 = query.getOrDefault("fields")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "fields", valid_580300
  var valid_580301 = query.getOrDefault("maxResults")
  valid_580301 = validateParameter(valid_580301, JInt, required = false, default = nil)
  if valid_580301 != nil:
    section.add "maxResults", valid_580301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580302: Call_ContentAccounttaxList_580289; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the tax settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_580302.validator(path, query, header, formData, body)
  let scheme = call_580302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580302.url(scheme.get, call_580302.host, call_580302.base,
                         call_580302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580302, url, valid)

proc call*(call_580303: Call_ContentAccounttaxList_580289; merchantId: string;
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
  var path_580304 = newJObject()
  var query_580305 = newJObject()
  add(query_580305, "key", newJString(key))
  add(query_580305, "prettyPrint", newJBool(prettyPrint))
  add(query_580305, "oauth_token", newJString(oauthToken))
  add(query_580305, "alt", newJString(alt))
  add(query_580305, "userIp", newJString(userIp))
  add(query_580305, "quotaUser", newJString(quotaUser))
  add(path_580304, "merchantId", newJString(merchantId))
  add(query_580305, "pageToken", newJString(pageToken))
  add(query_580305, "fields", newJString(fields))
  add(query_580305, "maxResults", newJInt(maxResults))
  result = call_580303.call(path_580304, query_580305, nil, nil, nil)

var contentAccounttaxList* = Call_ContentAccounttaxList_580289(
    name: "contentAccounttaxList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax",
    validator: validate_ContentAccounttaxList_580290, base: "/content/v2.1",
    url: url_ContentAccounttaxList_580291, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxUpdate_580322 = ref object of OpenApiRestCall_579373
proc url_ContentAccounttaxUpdate_580324(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccounttaxUpdate_580323(path: JsonNode; query: JsonNode;
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
  var valid_580325 = path.getOrDefault("merchantId")
  valid_580325 = validateParameter(valid_580325, JString, required = true,
                                 default = nil)
  if valid_580325 != nil:
    section.add "merchantId", valid_580325
  var valid_580326 = path.getOrDefault("accountId")
  valid_580326 = validateParameter(valid_580326, JString, required = true,
                                 default = nil)
  if valid_580326 != nil:
    section.add "accountId", valid_580326
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
  var valid_580327 = query.getOrDefault("key")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "key", valid_580327
  var valid_580328 = query.getOrDefault("prettyPrint")
  valid_580328 = validateParameter(valid_580328, JBool, required = false,
                                 default = newJBool(true))
  if valid_580328 != nil:
    section.add "prettyPrint", valid_580328
  var valid_580329 = query.getOrDefault("oauth_token")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "oauth_token", valid_580329
  var valid_580330 = query.getOrDefault("alt")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = newJString("json"))
  if valid_580330 != nil:
    section.add "alt", valid_580330
  var valid_580331 = query.getOrDefault("userIp")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "userIp", valid_580331
  var valid_580332 = query.getOrDefault("quotaUser")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = nil)
  if valid_580332 != nil:
    section.add "quotaUser", valid_580332
  var valid_580333 = query.getOrDefault("fields")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "fields", valid_580333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580335: Call_ContentAccounttaxUpdate_580322; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the tax settings of the account.
  ## 
  let valid = call_580335.validator(path, query, header, formData, body)
  let scheme = call_580335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580335.url(scheme.get, call_580335.host, call_580335.base,
                         call_580335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580335, url, valid)

proc call*(call_580336: Call_ContentAccounttaxUpdate_580322; merchantId: string;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
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
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The ID of the account for which to get/update account tax settings.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580337 = newJObject()
  var query_580338 = newJObject()
  var body_580339 = newJObject()
  add(query_580338, "key", newJString(key))
  add(query_580338, "prettyPrint", newJBool(prettyPrint))
  add(query_580338, "oauth_token", newJString(oauthToken))
  add(query_580338, "alt", newJString(alt))
  add(query_580338, "userIp", newJString(userIp))
  add(query_580338, "quotaUser", newJString(quotaUser))
  add(path_580337, "merchantId", newJString(merchantId))
  if body != nil:
    body_580339 = body
  add(path_580337, "accountId", newJString(accountId))
  add(query_580338, "fields", newJString(fields))
  result = call_580336.call(path_580337, query_580338, nil, nil, body_580339)

var contentAccounttaxUpdate* = Call_ContentAccounttaxUpdate_580322(
    name: "contentAccounttaxUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax/{accountId}",
    validator: validate_ContentAccounttaxUpdate_580323, base: "/content/v2.1",
    url: url_ContentAccounttaxUpdate_580324, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxGet_580306 = ref object of OpenApiRestCall_579373
proc url_ContentAccounttaxGet_580308(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccounttaxGet_580307(path: JsonNode; query: JsonNode;
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
  var valid_580309 = path.getOrDefault("merchantId")
  valid_580309 = validateParameter(valid_580309, JString, required = true,
                                 default = nil)
  if valid_580309 != nil:
    section.add "merchantId", valid_580309
  var valid_580310 = path.getOrDefault("accountId")
  valid_580310 = validateParameter(valid_580310, JString, required = true,
                                 default = nil)
  if valid_580310 != nil:
    section.add "accountId", valid_580310
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
  var valid_580313 = query.getOrDefault("oauth_token")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "oauth_token", valid_580313
  var valid_580314 = query.getOrDefault("alt")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = newJString("json"))
  if valid_580314 != nil:
    section.add "alt", valid_580314
  var valid_580315 = query.getOrDefault("userIp")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "userIp", valid_580315
  var valid_580316 = query.getOrDefault("quotaUser")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "quotaUser", valid_580316
  var valid_580317 = query.getOrDefault("fields")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "fields", valid_580317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580318: Call_ContentAccounttaxGet_580306; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the tax settings of the account.
  ## 
  let valid = call_580318.validator(path, query, header, formData, body)
  let scheme = call_580318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580318.url(scheme.get, call_580318.host, call_580318.base,
                         call_580318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580318, url, valid)

proc call*(call_580319: Call_ContentAccounttaxGet_580306; merchantId: string;
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
  var path_580320 = newJObject()
  var query_580321 = newJObject()
  add(query_580321, "key", newJString(key))
  add(query_580321, "prettyPrint", newJBool(prettyPrint))
  add(query_580321, "oauth_token", newJString(oauthToken))
  add(query_580321, "alt", newJString(alt))
  add(query_580321, "userIp", newJString(userIp))
  add(query_580321, "quotaUser", newJString(quotaUser))
  add(path_580320, "merchantId", newJString(merchantId))
  add(path_580320, "accountId", newJString(accountId))
  add(query_580321, "fields", newJString(fields))
  result = call_580319.call(path_580320, query_580321, nil, nil, nil)

var contentAccounttaxGet* = Call_ContentAccounttaxGet_580306(
    name: "contentAccounttaxGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax/{accountId}",
    validator: validate_ContentAccounttaxGet_580307, base: "/content/v2.1",
    url: url_ContentAccounttaxGet_580308, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsInsert_580357 = ref object of OpenApiRestCall_579373
proc url_ContentDatafeedsInsert_580359(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsInsert_580358(path: JsonNode; query: JsonNode;
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
  var valid_580360 = path.getOrDefault("merchantId")
  valid_580360 = validateParameter(valid_580360, JString, required = true,
                                 default = nil)
  if valid_580360 != nil:
    section.add "merchantId", valid_580360
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
  var valid_580363 = query.getOrDefault("oauth_token")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = nil)
  if valid_580363 != nil:
    section.add "oauth_token", valid_580363
  var valid_580364 = query.getOrDefault("alt")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = newJString("json"))
  if valid_580364 != nil:
    section.add "alt", valid_580364
  var valid_580365 = query.getOrDefault("userIp")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "userIp", valid_580365
  var valid_580366 = query.getOrDefault("quotaUser")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = nil)
  if valid_580366 != nil:
    section.add "quotaUser", valid_580366
  var valid_580367 = query.getOrDefault("fields")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "fields", valid_580367
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580369: Call_ContentDatafeedsInsert_580357; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers a datafeed configuration with your Merchant Center account.
  ## 
  let valid = call_580369.validator(path, query, header, formData, body)
  let scheme = call_580369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580369.url(scheme.get, call_580369.host, call_580369.base,
                         call_580369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580369, url, valid)

proc call*(call_580370: Call_ContentDatafeedsInsert_580357; merchantId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
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
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580371 = newJObject()
  var query_580372 = newJObject()
  var body_580373 = newJObject()
  add(query_580372, "key", newJString(key))
  add(query_580372, "prettyPrint", newJBool(prettyPrint))
  add(query_580372, "oauth_token", newJString(oauthToken))
  add(query_580372, "alt", newJString(alt))
  add(query_580372, "userIp", newJString(userIp))
  add(query_580372, "quotaUser", newJString(quotaUser))
  add(path_580371, "merchantId", newJString(merchantId))
  if body != nil:
    body_580373 = body
  add(query_580372, "fields", newJString(fields))
  result = call_580370.call(path_580371, query_580372, nil, nil, body_580373)

var contentDatafeedsInsert* = Call_ContentDatafeedsInsert_580357(
    name: "contentDatafeedsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds",
    validator: validate_ContentDatafeedsInsert_580358, base: "/content/v2.1",
    url: url_ContentDatafeedsInsert_580359, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsList_580340 = ref object of OpenApiRestCall_579373
proc url_ContentDatafeedsList_580342(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsList_580341(path: JsonNode; query: JsonNode;
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
  var valid_580343 = path.getOrDefault("merchantId")
  valid_580343 = validateParameter(valid_580343, JString, required = true,
                                 default = nil)
  if valid_580343 != nil:
    section.add "merchantId", valid_580343
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
  var valid_580344 = query.getOrDefault("key")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "key", valid_580344
  var valid_580345 = query.getOrDefault("prettyPrint")
  valid_580345 = validateParameter(valid_580345, JBool, required = false,
                                 default = newJBool(true))
  if valid_580345 != nil:
    section.add "prettyPrint", valid_580345
  var valid_580346 = query.getOrDefault("oauth_token")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = nil)
  if valid_580346 != nil:
    section.add "oauth_token", valid_580346
  var valid_580347 = query.getOrDefault("alt")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = newJString("json"))
  if valid_580347 != nil:
    section.add "alt", valid_580347
  var valid_580348 = query.getOrDefault("userIp")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "userIp", valid_580348
  var valid_580349 = query.getOrDefault("quotaUser")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "quotaUser", valid_580349
  var valid_580350 = query.getOrDefault("pageToken")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = nil)
  if valid_580350 != nil:
    section.add "pageToken", valid_580350
  var valid_580351 = query.getOrDefault("fields")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "fields", valid_580351
  var valid_580352 = query.getOrDefault("maxResults")
  valid_580352 = validateParameter(valid_580352, JInt, required = false, default = nil)
  if valid_580352 != nil:
    section.add "maxResults", valid_580352
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580353: Call_ContentDatafeedsList_580340; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the configurations for datafeeds in your Merchant Center account.
  ## 
  let valid = call_580353.validator(path, query, header, formData, body)
  let scheme = call_580353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580353.url(scheme.get, call_580353.host, call_580353.base,
                         call_580353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580353, url, valid)

proc call*(call_580354: Call_ContentDatafeedsList_580340; merchantId: string;
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
  var path_580355 = newJObject()
  var query_580356 = newJObject()
  add(query_580356, "key", newJString(key))
  add(query_580356, "prettyPrint", newJBool(prettyPrint))
  add(query_580356, "oauth_token", newJString(oauthToken))
  add(query_580356, "alt", newJString(alt))
  add(query_580356, "userIp", newJString(userIp))
  add(query_580356, "quotaUser", newJString(quotaUser))
  add(path_580355, "merchantId", newJString(merchantId))
  add(query_580356, "pageToken", newJString(pageToken))
  add(query_580356, "fields", newJString(fields))
  add(query_580356, "maxResults", newJInt(maxResults))
  result = call_580354.call(path_580355, query_580356, nil, nil, nil)

var contentDatafeedsList* = Call_ContentDatafeedsList_580340(
    name: "contentDatafeedsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds",
    validator: validate_ContentDatafeedsList_580341, base: "/content/v2.1",
    url: url_ContentDatafeedsList_580342, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsUpdate_580390 = ref object of OpenApiRestCall_579373
proc url_ContentDatafeedsUpdate_580392(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsUpdate_580391(path: JsonNode; query: JsonNode;
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
  var valid_580393 = path.getOrDefault("merchantId")
  valid_580393 = validateParameter(valid_580393, JString, required = true,
                                 default = nil)
  if valid_580393 != nil:
    section.add "merchantId", valid_580393
  var valid_580394 = path.getOrDefault("datafeedId")
  valid_580394 = validateParameter(valid_580394, JString, required = true,
                                 default = nil)
  if valid_580394 != nil:
    section.add "datafeedId", valid_580394
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
  var valid_580395 = query.getOrDefault("key")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = nil)
  if valid_580395 != nil:
    section.add "key", valid_580395
  var valid_580396 = query.getOrDefault("prettyPrint")
  valid_580396 = validateParameter(valid_580396, JBool, required = false,
                                 default = newJBool(true))
  if valid_580396 != nil:
    section.add "prettyPrint", valid_580396
  var valid_580397 = query.getOrDefault("oauth_token")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = nil)
  if valid_580397 != nil:
    section.add "oauth_token", valid_580397
  var valid_580398 = query.getOrDefault("alt")
  valid_580398 = validateParameter(valid_580398, JString, required = false,
                                 default = newJString("json"))
  if valid_580398 != nil:
    section.add "alt", valid_580398
  var valid_580399 = query.getOrDefault("userIp")
  valid_580399 = validateParameter(valid_580399, JString, required = false,
                                 default = nil)
  if valid_580399 != nil:
    section.add "userIp", valid_580399
  var valid_580400 = query.getOrDefault("quotaUser")
  valid_580400 = validateParameter(valid_580400, JString, required = false,
                                 default = nil)
  if valid_580400 != nil:
    section.add "quotaUser", valid_580400
  var valid_580401 = query.getOrDefault("fields")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "fields", valid_580401
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580403: Call_ContentDatafeedsUpdate_580390; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a datafeed configuration of your Merchant Center account.
  ## 
  let valid = call_580403.validator(path, query, header, formData, body)
  let scheme = call_580403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580403.url(scheme.get, call_580403.host, call_580403.base,
                         call_580403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580403, url, valid)

proc call*(call_580404: Call_ContentDatafeedsUpdate_580390; merchantId: string;
          datafeedId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
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
  ##   body: JObject
  ##   datafeedId: string (required)
  ##             : The ID of the datafeed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580405 = newJObject()
  var query_580406 = newJObject()
  var body_580407 = newJObject()
  add(query_580406, "key", newJString(key))
  add(query_580406, "prettyPrint", newJBool(prettyPrint))
  add(query_580406, "oauth_token", newJString(oauthToken))
  add(query_580406, "alt", newJString(alt))
  add(query_580406, "userIp", newJString(userIp))
  add(query_580406, "quotaUser", newJString(quotaUser))
  add(path_580405, "merchantId", newJString(merchantId))
  if body != nil:
    body_580407 = body
  add(path_580405, "datafeedId", newJString(datafeedId))
  add(query_580406, "fields", newJString(fields))
  result = call_580404.call(path_580405, query_580406, nil, nil, body_580407)

var contentDatafeedsUpdate* = Call_ContentDatafeedsUpdate_580390(
    name: "contentDatafeedsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsUpdate_580391, base: "/content/v2.1",
    url: url_ContentDatafeedsUpdate_580392, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsGet_580374 = ref object of OpenApiRestCall_579373
proc url_ContentDatafeedsGet_580376(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsGet_580375(path: JsonNode; query: JsonNode;
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
  var valid_580377 = path.getOrDefault("merchantId")
  valid_580377 = validateParameter(valid_580377, JString, required = true,
                                 default = nil)
  if valid_580377 != nil:
    section.add "merchantId", valid_580377
  var valid_580378 = path.getOrDefault("datafeedId")
  valid_580378 = validateParameter(valid_580378, JString, required = true,
                                 default = nil)
  if valid_580378 != nil:
    section.add "datafeedId", valid_580378
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
  var valid_580379 = query.getOrDefault("key")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = nil)
  if valid_580379 != nil:
    section.add "key", valid_580379
  var valid_580380 = query.getOrDefault("prettyPrint")
  valid_580380 = validateParameter(valid_580380, JBool, required = false,
                                 default = newJBool(true))
  if valid_580380 != nil:
    section.add "prettyPrint", valid_580380
  var valid_580381 = query.getOrDefault("oauth_token")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "oauth_token", valid_580381
  var valid_580382 = query.getOrDefault("alt")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = newJString("json"))
  if valid_580382 != nil:
    section.add "alt", valid_580382
  var valid_580383 = query.getOrDefault("userIp")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = nil)
  if valid_580383 != nil:
    section.add "userIp", valid_580383
  var valid_580384 = query.getOrDefault("quotaUser")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "quotaUser", valid_580384
  var valid_580385 = query.getOrDefault("fields")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "fields", valid_580385
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580386: Call_ContentDatafeedsGet_580374; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a datafeed configuration from your Merchant Center account.
  ## 
  let valid = call_580386.validator(path, query, header, formData, body)
  let scheme = call_580386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580386.url(scheme.get, call_580386.host, call_580386.base,
                         call_580386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580386, url, valid)

proc call*(call_580387: Call_ContentDatafeedsGet_580374; merchantId: string;
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
  var path_580388 = newJObject()
  var query_580389 = newJObject()
  add(query_580389, "key", newJString(key))
  add(query_580389, "prettyPrint", newJBool(prettyPrint))
  add(query_580389, "oauth_token", newJString(oauthToken))
  add(query_580389, "alt", newJString(alt))
  add(query_580389, "userIp", newJString(userIp))
  add(query_580389, "quotaUser", newJString(quotaUser))
  add(path_580388, "merchantId", newJString(merchantId))
  add(path_580388, "datafeedId", newJString(datafeedId))
  add(query_580389, "fields", newJString(fields))
  result = call_580387.call(path_580388, query_580389, nil, nil, nil)

var contentDatafeedsGet* = Call_ContentDatafeedsGet_580374(
    name: "contentDatafeedsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsGet_580375, base: "/content/v2.1",
    url: url_ContentDatafeedsGet_580376, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsDelete_580408 = ref object of OpenApiRestCall_579373
proc url_ContentDatafeedsDelete_580410(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsDelete_580409(path: JsonNode; query: JsonNode;
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
  var valid_580411 = path.getOrDefault("merchantId")
  valid_580411 = validateParameter(valid_580411, JString, required = true,
                                 default = nil)
  if valid_580411 != nil:
    section.add "merchantId", valid_580411
  var valid_580412 = path.getOrDefault("datafeedId")
  valid_580412 = validateParameter(valid_580412, JString, required = true,
                                 default = nil)
  if valid_580412 != nil:
    section.add "datafeedId", valid_580412
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
  var valid_580415 = query.getOrDefault("oauth_token")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = nil)
  if valid_580415 != nil:
    section.add "oauth_token", valid_580415
  var valid_580416 = query.getOrDefault("alt")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = newJString("json"))
  if valid_580416 != nil:
    section.add "alt", valid_580416
  var valid_580417 = query.getOrDefault("userIp")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "userIp", valid_580417
  var valid_580418 = query.getOrDefault("quotaUser")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = nil)
  if valid_580418 != nil:
    section.add "quotaUser", valid_580418
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

proc call*(call_580420: Call_ContentDatafeedsDelete_580408; path: JsonNode;
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

proc call*(call_580421: Call_ContentDatafeedsDelete_580408; merchantId: string;
          datafeedId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
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
  add(path_580422, "datafeedId", newJString(datafeedId))
  add(query_580423, "fields", newJString(fields))
  result = call_580421.call(path_580422, query_580423, nil, nil, nil)

var contentDatafeedsDelete* = Call_ContentDatafeedsDelete_580408(
    name: "contentDatafeedsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsDelete_580409, base: "/content/v2.1",
    url: url_ContentDatafeedsDelete_580410, schemes: {Scheme.Https})
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
  var valid_580435 = query.getOrDefault("fields")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "fields", valid_580435
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580436: Call_ContentDatafeedsFetchnow_580424; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Invokes a fetch for the datafeed in your Merchant Center account.
  ## 
  let valid = call_580436.validator(path, query, header, formData, body)
  let scheme = call_580436.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580436.url(scheme.get, call_580436.host, call_580436.base,
                         call_580436.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580436, url, valid)

proc call*(call_580437: Call_ContentDatafeedsFetchnow_580424; merchantId: string;
          datafeedId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
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
  ##   datafeedId: string (required)
  ##             : The ID of the datafeed to be fetched.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580438 = newJObject()
  var query_580439 = newJObject()
  add(query_580439, "key", newJString(key))
  add(query_580439, "prettyPrint", newJBool(prettyPrint))
  add(query_580439, "oauth_token", newJString(oauthToken))
  add(query_580439, "alt", newJString(alt))
  add(query_580439, "userIp", newJString(userIp))
  add(query_580439, "quotaUser", newJString(quotaUser))
  add(path_580438, "merchantId", newJString(merchantId))
  add(path_580438, "datafeedId", newJString(datafeedId))
  add(query_580439, "fields", newJString(fields))
  result = call_580437.call(path_580438, query_580439, nil, nil, nil)

var contentDatafeedsFetchnow* = Call_ContentDatafeedsFetchnow_580424(
    name: "contentDatafeedsFetchnow", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/datafeeds/{datafeedId}/fetchNow",
    validator: validate_ContentDatafeedsFetchnow_580425, base: "/content/v2.1",
    url: url_ContentDatafeedsFetchnow_580426, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesList_580440 = ref object of OpenApiRestCall_579373
proc url_ContentDatafeedstatusesList_580442(protocol: Scheme; host: string;
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

proc validate_ContentDatafeedstatusesList_580441(path: JsonNode; query: JsonNode;
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
  var valid_580443 = path.getOrDefault("merchantId")
  valid_580443 = validateParameter(valid_580443, JString, required = true,
                                 default = nil)
  if valid_580443 != nil:
    section.add "merchantId", valid_580443
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
  var valid_580444 = query.getOrDefault("key")
  valid_580444 = validateParameter(valid_580444, JString, required = false,
                                 default = nil)
  if valid_580444 != nil:
    section.add "key", valid_580444
  var valid_580445 = query.getOrDefault("prettyPrint")
  valid_580445 = validateParameter(valid_580445, JBool, required = false,
                                 default = newJBool(true))
  if valid_580445 != nil:
    section.add "prettyPrint", valid_580445
  var valid_580446 = query.getOrDefault("oauth_token")
  valid_580446 = validateParameter(valid_580446, JString, required = false,
                                 default = nil)
  if valid_580446 != nil:
    section.add "oauth_token", valid_580446
  var valid_580447 = query.getOrDefault("alt")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = newJString("json"))
  if valid_580447 != nil:
    section.add "alt", valid_580447
  var valid_580448 = query.getOrDefault("userIp")
  valid_580448 = validateParameter(valid_580448, JString, required = false,
                                 default = nil)
  if valid_580448 != nil:
    section.add "userIp", valid_580448
  var valid_580449 = query.getOrDefault("quotaUser")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "quotaUser", valid_580449
  var valid_580450 = query.getOrDefault("pageToken")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = nil)
  if valid_580450 != nil:
    section.add "pageToken", valid_580450
  var valid_580451 = query.getOrDefault("fields")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = nil)
  if valid_580451 != nil:
    section.add "fields", valid_580451
  var valid_580452 = query.getOrDefault("maxResults")
  valid_580452 = validateParameter(valid_580452, JInt, required = false, default = nil)
  if valid_580452 != nil:
    section.add "maxResults", valid_580452
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580453: Call_ContentDatafeedstatusesList_580440; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the datafeeds in your Merchant Center account.
  ## 
  let valid = call_580453.validator(path, query, header, formData, body)
  let scheme = call_580453.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580453.url(scheme.get, call_580453.host, call_580453.base,
                         call_580453.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580453, url, valid)

proc call*(call_580454: Call_ContentDatafeedstatusesList_580440;
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
  var path_580455 = newJObject()
  var query_580456 = newJObject()
  add(query_580456, "key", newJString(key))
  add(query_580456, "prettyPrint", newJBool(prettyPrint))
  add(query_580456, "oauth_token", newJString(oauthToken))
  add(query_580456, "alt", newJString(alt))
  add(query_580456, "userIp", newJString(userIp))
  add(query_580456, "quotaUser", newJString(quotaUser))
  add(path_580455, "merchantId", newJString(merchantId))
  add(query_580456, "pageToken", newJString(pageToken))
  add(query_580456, "fields", newJString(fields))
  add(query_580456, "maxResults", newJInt(maxResults))
  result = call_580454.call(path_580455, query_580456, nil, nil, nil)

var contentDatafeedstatusesList* = Call_ContentDatafeedstatusesList_580440(
    name: "contentDatafeedstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeedstatuses",
    validator: validate_ContentDatafeedstatusesList_580441, base: "/content/v2.1",
    url: url_ContentDatafeedstatusesList_580442, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesGet_580457 = ref object of OpenApiRestCall_579373
proc url_ContentDatafeedstatusesGet_580459(protocol: Scheme; host: string;
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

proc validate_ContentDatafeedstatusesGet_580458(path: JsonNode; query: JsonNode;
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
  var valid_580460 = path.getOrDefault("merchantId")
  valid_580460 = validateParameter(valid_580460, JString, required = true,
                                 default = nil)
  if valid_580460 != nil:
    section.add "merchantId", valid_580460
  var valid_580461 = path.getOrDefault("datafeedId")
  valid_580461 = validateParameter(valid_580461, JString, required = true,
                                 default = nil)
  if valid_580461 != nil:
    section.add "datafeedId", valid_580461
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
  var valid_580462 = query.getOrDefault("key")
  valid_580462 = validateParameter(valid_580462, JString, required = false,
                                 default = nil)
  if valid_580462 != nil:
    section.add "key", valid_580462
  var valid_580463 = query.getOrDefault("prettyPrint")
  valid_580463 = validateParameter(valid_580463, JBool, required = false,
                                 default = newJBool(true))
  if valid_580463 != nil:
    section.add "prettyPrint", valid_580463
  var valid_580464 = query.getOrDefault("oauth_token")
  valid_580464 = validateParameter(valid_580464, JString, required = false,
                                 default = nil)
  if valid_580464 != nil:
    section.add "oauth_token", valid_580464
  var valid_580465 = query.getOrDefault("alt")
  valid_580465 = validateParameter(valid_580465, JString, required = false,
                                 default = newJString("json"))
  if valid_580465 != nil:
    section.add "alt", valid_580465
  var valid_580466 = query.getOrDefault("userIp")
  valid_580466 = validateParameter(valid_580466, JString, required = false,
                                 default = nil)
  if valid_580466 != nil:
    section.add "userIp", valid_580466
  var valid_580467 = query.getOrDefault("quotaUser")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = nil)
  if valid_580467 != nil:
    section.add "quotaUser", valid_580467
  var valid_580468 = query.getOrDefault("country")
  valid_580468 = validateParameter(valid_580468, JString, required = false,
                                 default = nil)
  if valid_580468 != nil:
    section.add "country", valid_580468
  var valid_580469 = query.getOrDefault("fields")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = nil)
  if valid_580469 != nil:
    section.add "fields", valid_580469
  var valid_580470 = query.getOrDefault("language")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = nil)
  if valid_580470 != nil:
    section.add "language", valid_580470
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580471: Call_ContentDatafeedstatusesGet_580457; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the status of a datafeed from your Merchant Center account.
  ## 
  let valid = call_580471.validator(path, query, header, formData, body)
  let scheme = call_580471.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580471.url(scheme.get, call_580471.host, call_580471.base,
                         call_580471.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580471, url, valid)

proc call*(call_580472: Call_ContentDatafeedstatusesGet_580457; merchantId: string;
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
  var path_580473 = newJObject()
  var query_580474 = newJObject()
  add(query_580474, "key", newJString(key))
  add(query_580474, "prettyPrint", newJBool(prettyPrint))
  add(query_580474, "oauth_token", newJString(oauthToken))
  add(query_580474, "alt", newJString(alt))
  add(query_580474, "userIp", newJString(userIp))
  add(query_580474, "quotaUser", newJString(quotaUser))
  add(path_580473, "merchantId", newJString(merchantId))
  add(query_580474, "country", newJString(country))
  add(path_580473, "datafeedId", newJString(datafeedId))
  add(query_580474, "fields", newJString(fields))
  add(query_580474, "language", newJString(language))
  result = call_580472.call(path_580473, query_580474, nil, nil, nil)

var contentDatafeedstatusesGet* = Call_ContentDatafeedstatusesGet_580457(
    name: "contentDatafeedstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/datafeedstatuses/{datafeedId}",
    validator: validate_ContentDatafeedstatusesGet_580458, base: "/content/v2.1",
    url: url_ContentDatafeedstatusesGet_580459, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsList_580475 = ref object of OpenApiRestCall_579373
proc url_ContentLiasettingsList_580477(protocol: Scheme; host: string; base: string;
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

proc validate_ContentLiasettingsList_580476(path: JsonNode; query: JsonNode;
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
  var valid_580478 = path.getOrDefault("merchantId")
  valid_580478 = validateParameter(valid_580478, JString, required = true,
                                 default = nil)
  if valid_580478 != nil:
    section.add "merchantId", valid_580478
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
  var valid_580479 = query.getOrDefault("key")
  valid_580479 = validateParameter(valid_580479, JString, required = false,
                                 default = nil)
  if valid_580479 != nil:
    section.add "key", valid_580479
  var valid_580480 = query.getOrDefault("prettyPrint")
  valid_580480 = validateParameter(valid_580480, JBool, required = false,
                                 default = newJBool(true))
  if valid_580480 != nil:
    section.add "prettyPrint", valid_580480
  var valid_580481 = query.getOrDefault("oauth_token")
  valid_580481 = validateParameter(valid_580481, JString, required = false,
                                 default = nil)
  if valid_580481 != nil:
    section.add "oauth_token", valid_580481
  var valid_580482 = query.getOrDefault("alt")
  valid_580482 = validateParameter(valid_580482, JString, required = false,
                                 default = newJString("json"))
  if valid_580482 != nil:
    section.add "alt", valid_580482
  var valid_580483 = query.getOrDefault("userIp")
  valid_580483 = validateParameter(valid_580483, JString, required = false,
                                 default = nil)
  if valid_580483 != nil:
    section.add "userIp", valid_580483
  var valid_580484 = query.getOrDefault("quotaUser")
  valid_580484 = validateParameter(valid_580484, JString, required = false,
                                 default = nil)
  if valid_580484 != nil:
    section.add "quotaUser", valid_580484
  var valid_580485 = query.getOrDefault("pageToken")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = nil)
  if valid_580485 != nil:
    section.add "pageToken", valid_580485
  var valid_580486 = query.getOrDefault("fields")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = nil)
  if valid_580486 != nil:
    section.add "fields", valid_580486
  var valid_580487 = query.getOrDefault("maxResults")
  valid_580487 = validateParameter(valid_580487, JInt, required = false, default = nil)
  if valid_580487 != nil:
    section.add "maxResults", valid_580487
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580488: Call_ContentLiasettingsList_580475; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the LIA settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_580488.validator(path, query, header, formData, body)
  let scheme = call_580488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580488.url(scheme.get, call_580488.host, call_580488.base,
                         call_580488.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580488, url, valid)

proc call*(call_580489: Call_ContentLiasettingsList_580475; merchantId: string;
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
  var path_580490 = newJObject()
  var query_580491 = newJObject()
  add(query_580491, "key", newJString(key))
  add(query_580491, "prettyPrint", newJBool(prettyPrint))
  add(query_580491, "oauth_token", newJString(oauthToken))
  add(query_580491, "alt", newJString(alt))
  add(query_580491, "userIp", newJString(userIp))
  add(query_580491, "quotaUser", newJString(quotaUser))
  add(path_580490, "merchantId", newJString(merchantId))
  add(query_580491, "pageToken", newJString(pageToken))
  add(query_580491, "fields", newJString(fields))
  add(query_580491, "maxResults", newJInt(maxResults))
  result = call_580489.call(path_580490, query_580491, nil, nil, nil)

var contentLiasettingsList* = Call_ContentLiasettingsList_580475(
    name: "contentLiasettingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings",
    validator: validate_ContentLiasettingsList_580476, base: "/content/v2.1",
    url: url_ContentLiasettingsList_580477, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsUpdate_580508 = ref object of OpenApiRestCall_579373
proc url_ContentLiasettingsUpdate_580510(protocol: Scheme; host: string;
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

proc validate_ContentLiasettingsUpdate_580509(path: JsonNode; query: JsonNode;
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
  var valid_580511 = path.getOrDefault("merchantId")
  valid_580511 = validateParameter(valid_580511, JString, required = true,
                                 default = nil)
  if valid_580511 != nil:
    section.add "merchantId", valid_580511
  var valid_580512 = path.getOrDefault("accountId")
  valid_580512 = validateParameter(valid_580512, JString, required = true,
                                 default = nil)
  if valid_580512 != nil:
    section.add "accountId", valid_580512
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
  var valid_580513 = query.getOrDefault("key")
  valid_580513 = validateParameter(valid_580513, JString, required = false,
                                 default = nil)
  if valid_580513 != nil:
    section.add "key", valid_580513
  var valid_580514 = query.getOrDefault("prettyPrint")
  valid_580514 = validateParameter(valid_580514, JBool, required = false,
                                 default = newJBool(true))
  if valid_580514 != nil:
    section.add "prettyPrint", valid_580514
  var valid_580515 = query.getOrDefault("oauth_token")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = nil)
  if valid_580515 != nil:
    section.add "oauth_token", valid_580515
  var valid_580516 = query.getOrDefault("alt")
  valid_580516 = validateParameter(valid_580516, JString, required = false,
                                 default = newJString("json"))
  if valid_580516 != nil:
    section.add "alt", valid_580516
  var valid_580517 = query.getOrDefault("userIp")
  valid_580517 = validateParameter(valid_580517, JString, required = false,
                                 default = nil)
  if valid_580517 != nil:
    section.add "userIp", valid_580517
  var valid_580518 = query.getOrDefault("quotaUser")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = nil)
  if valid_580518 != nil:
    section.add "quotaUser", valid_580518
  var valid_580519 = query.getOrDefault("fields")
  valid_580519 = validateParameter(valid_580519, JString, required = false,
                                 default = nil)
  if valid_580519 != nil:
    section.add "fields", valid_580519
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580521: Call_ContentLiasettingsUpdate_580508; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the LIA settings of the account.
  ## 
  let valid = call_580521.validator(path, query, header, formData, body)
  let scheme = call_580521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580521.url(scheme.get, call_580521.host, call_580521.base,
                         call_580521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580521, url, valid)

proc call*(call_580522: Call_ContentLiasettingsUpdate_580508; merchantId: string;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
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
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The ID of the account for which to get or update LIA settings.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580523 = newJObject()
  var query_580524 = newJObject()
  var body_580525 = newJObject()
  add(query_580524, "key", newJString(key))
  add(query_580524, "prettyPrint", newJBool(prettyPrint))
  add(query_580524, "oauth_token", newJString(oauthToken))
  add(query_580524, "alt", newJString(alt))
  add(query_580524, "userIp", newJString(userIp))
  add(query_580524, "quotaUser", newJString(quotaUser))
  add(path_580523, "merchantId", newJString(merchantId))
  if body != nil:
    body_580525 = body
  add(path_580523, "accountId", newJString(accountId))
  add(query_580524, "fields", newJString(fields))
  result = call_580522.call(path_580523, query_580524, nil, nil, body_580525)

var contentLiasettingsUpdate* = Call_ContentLiasettingsUpdate_580508(
    name: "contentLiasettingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}",
    validator: validate_ContentLiasettingsUpdate_580509, base: "/content/v2.1",
    url: url_ContentLiasettingsUpdate_580510, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsGet_580492 = ref object of OpenApiRestCall_579373
proc url_ContentLiasettingsGet_580494(protocol: Scheme; host: string; base: string;
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

proc validate_ContentLiasettingsGet_580493(path: JsonNode; query: JsonNode;
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
  var valid_580495 = path.getOrDefault("merchantId")
  valid_580495 = validateParameter(valid_580495, JString, required = true,
                                 default = nil)
  if valid_580495 != nil:
    section.add "merchantId", valid_580495
  var valid_580496 = path.getOrDefault("accountId")
  valid_580496 = validateParameter(valid_580496, JString, required = true,
                                 default = nil)
  if valid_580496 != nil:
    section.add "accountId", valid_580496
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
  var valid_580499 = query.getOrDefault("oauth_token")
  valid_580499 = validateParameter(valid_580499, JString, required = false,
                                 default = nil)
  if valid_580499 != nil:
    section.add "oauth_token", valid_580499
  var valid_580500 = query.getOrDefault("alt")
  valid_580500 = validateParameter(valid_580500, JString, required = false,
                                 default = newJString("json"))
  if valid_580500 != nil:
    section.add "alt", valid_580500
  var valid_580501 = query.getOrDefault("userIp")
  valid_580501 = validateParameter(valid_580501, JString, required = false,
                                 default = nil)
  if valid_580501 != nil:
    section.add "userIp", valid_580501
  var valid_580502 = query.getOrDefault("quotaUser")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = nil)
  if valid_580502 != nil:
    section.add "quotaUser", valid_580502
  var valid_580503 = query.getOrDefault("fields")
  valid_580503 = validateParameter(valid_580503, JString, required = false,
                                 default = nil)
  if valid_580503 != nil:
    section.add "fields", valid_580503
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580504: Call_ContentLiasettingsGet_580492; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the LIA settings of the account.
  ## 
  let valid = call_580504.validator(path, query, header, formData, body)
  let scheme = call_580504.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580504.url(scheme.get, call_580504.host, call_580504.base,
                         call_580504.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580504, url, valid)

proc call*(call_580505: Call_ContentLiasettingsGet_580492; merchantId: string;
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
  var path_580506 = newJObject()
  var query_580507 = newJObject()
  add(query_580507, "key", newJString(key))
  add(query_580507, "prettyPrint", newJBool(prettyPrint))
  add(query_580507, "oauth_token", newJString(oauthToken))
  add(query_580507, "alt", newJString(alt))
  add(query_580507, "userIp", newJString(userIp))
  add(query_580507, "quotaUser", newJString(quotaUser))
  add(path_580506, "merchantId", newJString(merchantId))
  add(path_580506, "accountId", newJString(accountId))
  add(query_580507, "fields", newJString(fields))
  result = call_580505.call(path_580506, query_580507, nil, nil, nil)

var contentLiasettingsGet* = Call_ContentLiasettingsGet_580492(
    name: "contentLiasettingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}",
    validator: validate_ContentLiasettingsGet_580493, base: "/content/v2.1",
    url: url_ContentLiasettingsGet_580494, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsGetaccessiblegmbaccounts_580526 = ref object of OpenApiRestCall_579373
proc url_ContentLiasettingsGetaccessiblegmbaccounts_580528(protocol: Scheme;
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

proc validate_ContentLiasettingsGetaccessiblegmbaccounts_580527(path: JsonNode;
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
  var valid_580529 = path.getOrDefault("merchantId")
  valid_580529 = validateParameter(valid_580529, JString, required = true,
                                 default = nil)
  if valid_580529 != nil:
    section.add "merchantId", valid_580529
  var valid_580530 = path.getOrDefault("accountId")
  valid_580530 = validateParameter(valid_580530, JString, required = true,
                                 default = nil)
  if valid_580530 != nil:
    section.add "accountId", valid_580530
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
  var valid_580531 = query.getOrDefault("key")
  valid_580531 = validateParameter(valid_580531, JString, required = false,
                                 default = nil)
  if valid_580531 != nil:
    section.add "key", valid_580531
  var valid_580532 = query.getOrDefault("prettyPrint")
  valid_580532 = validateParameter(valid_580532, JBool, required = false,
                                 default = newJBool(true))
  if valid_580532 != nil:
    section.add "prettyPrint", valid_580532
  var valid_580533 = query.getOrDefault("oauth_token")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = nil)
  if valid_580533 != nil:
    section.add "oauth_token", valid_580533
  var valid_580534 = query.getOrDefault("alt")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = newJString("json"))
  if valid_580534 != nil:
    section.add "alt", valid_580534
  var valid_580535 = query.getOrDefault("userIp")
  valid_580535 = validateParameter(valid_580535, JString, required = false,
                                 default = nil)
  if valid_580535 != nil:
    section.add "userIp", valid_580535
  var valid_580536 = query.getOrDefault("quotaUser")
  valid_580536 = validateParameter(valid_580536, JString, required = false,
                                 default = nil)
  if valid_580536 != nil:
    section.add "quotaUser", valid_580536
  var valid_580537 = query.getOrDefault("fields")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = nil)
  if valid_580537 != nil:
    section.add "fields", valid_580537
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580538: Call_ContentLiasettingsGetaccessiblegmbaccounts_580526;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of accessible Google My Business accounts.
  ## 
  let valid = call_580538.validator(path, query, header, formData, body)
  let scheme = call_580538.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580538.url(scheme.get, call_580538.host, call_580538.base,
                         call_580538.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580538, url, valid)

proc call*(call_580539: Call_ContentLiasettingsGetaccessiblegmbaccounts_580526;
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
  var path_580540 = newJObject()
  var query_580541 = newJObject()
  add(query_580541, "key", newJString(key))
  add(query_580541, "prettyPrint", newJBool(prettyPrint))
  add(query_580541, "oauth_token", newJString(oauthToken))
  add(query_580541, "alt", newJString(alt))
  add(query_580541, "userIp", newJString(userIp))
  add(query_580541, "quotaUser", newJString(quotaUser))
  add(path_580540, "merchantId", newJString(merchantId))
  add(path_580540, "accountId", newJString(accountId))
  add(query_580541, "fields", newJString(fields))
  result = call_580539.call(path_580540, query_580541, nil, nil, nil)

var contentLiasettingsGetaccessiblegmbaccounts* = Call_ContentLiasettingsGetaccessiblegmbaccounts_580526(
    name: "contentLiasettingsGetaccessiblegmbaccounts", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/accessiblegmbaccounts",
    validator: validate_ContentLiasettingsGetaccessiblegmbaccounts_580527,
    base: "/content/v2.1", url: url_ContentLiasettingsGetaccessiblegmbaccounts_580528,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsRequestgmbaccess_580542 = ref object of OpenApiRestCall_579373
proc url_ContentLiasettingsRequestgmbaccess_580544(protocol: Scheme; host: string;
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

proc validate_ContentLiasettingsRequestgmbaccess_580543(path: JsonNode;
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
  var valid_580545 = path.getOrDefault("merchantId")
  valid_580545 = validateParameter(valid_580545, JString, required = true,
                                 default = nil)
  if valid_580545 != nil:
    section.add "merchantId", valid_580545
  var valid_580546 = path.getOrDefault("accountId")
  valid_580546 = validateParameter(valid_580546, JString, required = true,
                                 default = nil)
  if valid_580546 != nil:
    section.add "accountId", valid_580546
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
  var valid_580547 = query.getOrDefault("key")
  valid_580547 = validateParameter(valid_580547, JString, required = false,
                                 default = nil)
  if valid_580547 != nil:
    section.add "key", valid_580547
  var valid_580548 = query.getOrDefault("prettyPrint")
  valid_580548 = validateParameter(valid_580548, JBool, required = false,
                                 default = newJBool(true))
  if valid_580548 != nil:
    section.add "prettyPrint", valid_580548
  var valid_580549 = query.getOrDefault("oauth_token")
  valid_580549 = validateParameter(valid_580549, JString, required = false,
                                 default = nil)
  if valid_580549 != nil:
    section.add "oauth_token", valid_580549
  assert query != nil,
        "query argument is necessary due to required `gmbEmail` field"
  var valid_580550 = query.getOrDefault("gmbEmail")
  valid_580550 = validateParameter(valid_580550, JString, required = true,
                                 default = nil)
  if valid_580550 != nil:
    section.add "gmbEmail", valid_580550
  var valid_580551 = query.getOrDefault("alt")
  valid_580551 = validateParameter(valid_580551, JString, required = false,
                                 default = newJString("json"))
  if valid_580551 != nil:
    section.add "alt", valid_580551
  var valid_580552 = query.getOrDefault("userIp")
  valid_580552 = validateParameter(valid_580552, JString, required = false,
                                 default = nil)
  if valid_580552 != nil:
    section.add "userIp", valid_580552
  var valid_580553 = query.getOrDefault("quotaUser")
  valid_580553 = validateParameter(valid_580553, JString, required = false,
                                 default = nil)
  if valid_580553 != nil:
    section.add "quotaUser", valid_580553
  var valid_580554 = query.getOrDefault("fields")
  valid_580554 = validateParameter(valid_580554, JString, required = false,
                                 default = nil)
  if valid_580554 != nil:
    section.add "fields", valid_580554
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580555: Call_ContentLiasettingsRequestgmbaccess_580542;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests access to a specified Google My Business account.
  ## 
  let valid = call_580555.validator(path, query, header, formData, body)
  let scheme = call_580555.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580555.url(scheme.get, call_580555.host, call_580555.base,
                         call_580555.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580555, url, valid)

proc call*(call_580556: Call_ContentLiasettingsRequestgmbaccess_580542;
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
  var path_580557 = newJObject()
  var query_580558 = newJObject()
  add(query_580558, "key", newJString(key))
  add(query_580558, "prettyPrint", newJBool(prettyPrint))
  add(query_580558, "oauth_token", newJString(oauthToken))
  add(query_580558, "gmbEmail", newJString(gmbEmail))
  add(query_580558, "alt", newJString(alt))
  add(query_580558, "userIp", newJString(userIp))
  add(query_580558, "quotaUser", newJString(quotaUser))
  add(path_580557, "merchantId", newJString(merchantId))
  add(path_580557, "accountId", newJString(accountId))
  add(query_580558, "fields", newJString(fields))
  result = call_580556.call(path_580557, query_580558, nil, nil, nil)

var contentLiasettingsRequestgmbaccess* = Call_ContentLiasettingsRequestgmbaccess_580542(
    name: "contentLiasettingsRequestgmbaccess", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/requestgmbaccess",
    validator: validate_ContentLiasettingsRequestgmbaccess_580543,
    base: "/content/v2.1", url: url_ContentLiasettingsRequestgmbaccess_580544,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsRequestinventoryverification_580559 = ref object of OpenApiRestCall_579373
proc url_ContentLiasettingsRequestinventoryverification_580561(protocol: Scheme;
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

proc validate_ContentLiasettingsRequestinventoryverification_580560(
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
  var valid_580562 = path.getOrDefault("merchantId")
  valid_580562 = validateParameter(valid_580562, JString, required = true,
                                 default = nil)
  if valid_580562 != nil:
    section.add "merchantId", valid_580562
  var valid_580563 = path.getOrDefault("country")
  valid_580563 = validateParameter(valid_580563, JString, required = true,
                                 default = nil)
  if valid_580563 != nil:
    section.add "country", valid_580563
  var valid_580564 = path.getOrDefault("accountId")
  valid_580564 = validateParameter(valid_580564, JString, required = true,
                                 default = nil)
  if valid_580564 != nil:
    section.add "accountId", valid_580564
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
  var valid_580565 = query.getOrDefault("key")
  valid_580565 = validateParameter(valid_580565, JString, required = false,
                                 default = nil)
  if valid_580565 != nil:
    section.add "key", valid_580565
  var valid_580566 = query.getOrDefault("prettyPrint")
  valid_580566 = validateParameter(valid_580566, JBool, required = false,
                                 default = newJBool(true))
  if valid_580566 != nil:
    section.add "prettyPrint", valid_580566
  var valid_580567 = query.getOrDefault("oauth_token")
  valid_580567 = validateParameter(valid_580567, JString, required = false,
                                 default = nil)
  if valid_580567 != nil:
    section.add "oauth_token", valid_580567
  var valid_580568 = query.getOrDefault("alt")
  valid_580568 = validateParameter(valid_580568, JString, required = false,
                                 default = newJString("json"))
  if valid_580568 != nil:
    section.add "alt", valid_580568
  var valid_580569 = query.getOrDefault("userIp")
  valid_580569 = validateParameter(valid_580569, JString, required = false,
                                 default = nil)
  if valid_580569 != nil:
    section.add "userIp", valid_580569
  var valid_580570 = query.getOrDefault("quotaUser")
  valid_580570 = validateParameter(valid_580570, JString, required = false,
                                 default = nil)
  if valid_580570 != nil:
    section.add "quotaUser", valid_580570
  var valid_580571 = query.getOrDefault("fields")
  valid_580571 = validateParameter(valid_580571, JString, required = false,
                                 default = nil)
  if valid_580571 != nil:
    section.add "fields", valid_580571
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580572: Call_ContentLiasettingsRequestinventoryverification_580559;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests inventory validation for the specified country.
  ## 
  let valid = call_580572.validator(path, query, header, formData, body)
  let scheme = call_580572.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580572.url(scheme.get, call_580572.host, call_580572.base,
                         call_580572.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580572, url, valid)

proc call*(call_580573: Call_ContentLiasettingsRequestinventoryverification_580559;
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
  var path_580574 = newJObject()
  var query_580575 = newJObject()
  add(query_580575, "key", newJString(key))
  add(query_580575, "prettyPrint", newJBool(prettyPrint))
  add(query_580575, "oauth_token", newJString(oauthToken))
  add(query_580575, "alt", newJString(alt))
  add(query_580575, "userIp", newJString(userIp))
  add(query_580575, "quotaUser", newJString(quotaUser))
  add(path_580574, "merchantId", newJString(merchantId))
  add(path_580574, "country", newJString(country))
  add(path_580574, "accountId", newJString(accountId))
  add(query_580575, "fields", newJString(fields))
  result = call_580573.call(path_580574, query_580575, nil, nil, nil)

var contentLiasettingsRequestinventoryverification* = Call_ContentLiasettingsRequestinventoryverification_580559(
    name: "contentLiasettingsRequestinventoryverification",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}/requestinventoryverification/{country}",
    validator: validate_ContentLiasettingsRequestinventoryverification_580560,
    base: "/content/v2.1",
    url: url_ContentLiasettingsRequestinventoryverification_580561,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsSetinventoryverificationcontact_580576 = ref object of OpenApiRestCall_579373
proc url_ContentLiasettingsSetinventoryverificationcontact_580578(
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

proc validate_ContentLiasettingsSetinventoryverificationcontact_580577(
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
  var valid_580579 = path.getOrDefault("merchantId")
  valid_580579 = validateParameter(valid_580579, JString, required = true,
                                 default = nil)
  if valid_580579 != nil:
    section.add "merchantId", valid_580579
  var valid_580580 = path.getOrDefault("accountId")
  valid_580580 = validateParameter(valid_580580, JString, required = true,
                                 default = nil)
  if valid_580580 != nil:
    section.add "accountId", valid_580580
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
  var valid_580581 = query.getOrDefault("key")
  valid_580581 = validateParameter(valid_580581, JString, required = false,
                                 default = nil)
  if valid_580581 != nil:
    section.add "key", valid_580581
  var valid_580582 = query.getOrDefault("prettyPrint")
  valid_580582 = validateParameter(valid_580582, JBool, required = false,
                                 default = newJBool(true))
  if valid_580582 != nil:
    section.add "prettyPrint", valid_580582
  var valid_580583 = query.getOrDefault("oauth_token")
  valid_580583 = validateParameter(valid_580583, JString, required = false,
                                 default = nil)
  if valid_580583 != nil:
    section.add "oauth_token", valid_580583
  assert query != nil,
        "query argument is necessary due to required `contactEmail` field"
  var valid_580584 = query.getOrDefault("contactEmail")
  valid_580584 = validateParameter(valid_580584, JString, required = true,
                                 default = nil)
  if valid_580584 != nil:
    section.add "contactEmail", valid_580584
  var valid_580585 = query.getOrDefault("alt")
  valid_580585 = validateParameter(valid_580585, JString, required = false,
                                 default = newJString("json"))
  if valid_580585 != nil:
    section.add "alt", valid_580585
  var valid_580586 = query.getOrDefault("userIp")
  valid_580586 = validateParameter(valid_580586, JString, required = false,
                                 default = nil)
  if valid_580586 != nil:
    section.add "userIp", valid_580586
  var valid_580587 = query.getOrDefault("quotaUser")
  valid_580587 = validateParameter(valid_580587, JString, required = false,
                                 default = nil)
  if valid_580587 != nil:
    section.add "quotaUser", valid_580587
  var valid_580588 = query.getOrDefault("contactName")
  valid_580588 = validateParameter(valid_580588, JString, required = true,
                                 default = nil)
  if valid_580588 != nil:
    section.add "contactName", valid_580588
  var valid_580589 = query.getOrDefault("country")
  valid_580589 = validateParameter(valid_580589, JString, required = true,
                                 default = nil)
  if valid_580589 != nil:
    section.add "country", valid_580589
  var valid_580590 = query.getOrDefault("fields")
  valid_580590 = validateParameter(valid_580590, JString, required = false,
                                 default = nil)
  if valid_580590 != nil:
    section.add "fields", valid_580590
  var valid_580591 = query.getOrDefault("language")
  valid_580591 = validateParameter(valid_580591, JString, required = true,
                                 default = nil)
  if valid_580591 != nil:
    section.add "language", valid_580591
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580592: Call_ContentLiasettingsSetinventoryverificationcontact_580576;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the inventory verification contract for the specified country.
  ## 
  let valid = call_580592.validator(path, query, header, formData, body)
  let scheme = call_580592.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580592.url(scheme.get, call_580592.host, call_580592.base,
                         call_580592.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580592, url, valid)

proc call*(call_580593: Call_ContentLiasettingsSetinventoryverificationcontact_580576;
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
  var path_580594 = newJObject()
  var query_580595 = newJObject()
  add(query_580595, "key", newJString(key))
  add(query_580595, "prettyPrint", newJBool(prettyPrint))
  add(query_580595, "oauth_token", newJString(oauthToken))
  add(query_580595, "contactEmail", newJString(contactEmail))
  add(query_580595, "alt", newJString(alt))
  add(query_580595, "userIp", newJString(userIp))
  add(query_580595, "quotaUser", newJString(quotaUser))
  add(path_580594, "merchantId", newJString(merchantId))
  add(query_580595, "contactName", newJString(contactName))
  add(query_580595, "country", newJString(country))
  add(path_580594, "accountId", newJString(accountId))
  add(query_580595, "fields", newJString(fields))
  add(query_580595, "language", newJString(language))
  result = call_580593.call(path_580594, query_580595, nil, nil, nil)

var contentLiasettingsSetinventoryverificationcontact* = Call_ContentLiasettingsSetinventoryverificationcontact_580576(
    name: "contentLiasettingsSetinventoryverificationcontact",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}/setinventoryverificationcontact",
    validator: validate_ContentLiasettingsSetinventoryverificationcontact_580577,
    base: "/content/v2.1",
    url: url_ContentLiasettingsSetinventoryverificationcontact_580578,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsSetposdataprovider_580596 = ref object of OpenApiRestCall_579373
proc url_ContentLiasettingsSetposdataprovider_580598(protocol: Scheme;
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

proc validate_ContentLiasettingsSetposdataprovider_580597(path: JsonNode;
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
  var valid_580599 = path.getOrDefault("merchantId")
  valid_580599 = validateParameter(valid_580599, JString, required = true,
                                 default = nil)
  if valid_580599 != nil:
    section.add "merchantId", valid_580599
  var valid_580600 = path.getOrDefault("accountId")
  valid_580600 = validateParameter(valid_580600, JString, required = true,
                                 default = nil)
  if valid_580600 != nil:
    section.add "accountId", valid_580600
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
  var valid_580601 = query.getOrDefault("key")
  valid_580601 = validateParameter(valid_580601, JString, required = false,
                                 default = nil)
  if valid_580601 != nil:
    section.add "key", valid_580601
  var valid_580602 = query.getOrDefault("prettyPrint")
  valid_580602 = validateParameter(valid_580602, JBool, required = false,
                                 default = newJBool(true))
  if valid_580602 != nil:
    section.add "prettyPrint", valid_580602
  var valid_580603 = query.getOrDefault("oauth_token")
  valid_580603 = validateParameter(valid_580603, JString, required = false,
                                 default = nil)
  if valid_580603 != nil:
    section.add "oauth_token", valid_580603
  var valid_580604 = query.getOrDefault("alt")
  valid_580604 = validateParameter(valid_580604, JString, required = false,
                                 default = newJString("json"))
  if valid_580604 != nil:
    section.add "alt", valid_580604
  var valid_580605 = query.getOrDefault("userIp")
  valid_580605 = validateParameter(valid_580605, JString, required = false,
                                 default = nil)
  if valid_580605 != nil:
    section.add "userIp", valid_580605
  var valid_580606 = query.getOrDefault("quotaUser")
  valid_580606 = validateParameter(valid_580606, JString, required = false,
                                 default = nil)
  if valid_580606 != nil:
    section.add "quotaUser", valid_580606
  var valid_580607 = query.getOrDefault("posDataProviderId")
  valid_580607 = validateParameter(valid_580607, JString, required = false,
                                 default = nil)
  if valid_580607 != nil:
    section.add "posDataProviderId", valid_580607
  assert query != nil, "query argument is necessary due to required `country` field"
  var valid_580608 = query.getOrDefault("country")
  valid_580608 = validateParameter(valid_580608, JString, required = true,
                                 default = nil)
  if valid_580608 != nil:
    section.add "country", valid_580608
  var valid_580609 = query.getOrDefault("fields")
  valid_580609 = validateParameter(valid_580609, JString, required = false,
                                 default = nil)
  if valid_580609 != nil:
    section.add "fields", valid_580609
  var valid_580610 = query.getOrDefault("posExternalAccountId")
  valid_580610 = validateParameter(valid_580610, JString, required = false,
                                 default = nil)
  if valid_580610 != nil:
    section.add "posExternalAccountId", valid_580610
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580611: Call_ContentLiasettingsSetposdataprovider_580596;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the POS data provider for the specified country.
  ## 
  let valid = call_580611.validator(path, query, header, formData, body)
  let scheme = call_580611.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580611.url(scheme.get, call_580611.host, call_580611.base,
                         call_580611.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580611, url, valid)

proc call*(call_580612: Call_ContentLiasettingsSetposdataprovider_580596;
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
  var path_580613 = newJObject()
  var query_580614 = newJObject()
  add(query_580614, "key", newJString(key))
  add(query_580614, "prettyPrint", newJBool(prettyPrint))
  add(query_580614, "oauth_token", newJString(oauthToken))
  add(query_580614, "alt", newJString(alt))
  add(query_580614, "userIp", newJString(userIp))
  add(query_580614, "quotaUser", newJString(quotaUser))
  add(path_580613, "merchantId", newJString(merchantId))
  add(query_580614, "posDataProviderId", newJString(posDataProviderId))
  add(query_580614, "country", newJString(country))
  add(path_580613, "accountId", newJString(accountId))
  add(query_580614, "fields", newJString(fields))
  add(query_580614, "posExternalAccountId", newJString(posExternalAccountId))
  result = call_580612.call(path_580613, query_580614, nil, nil, nil)

var contentLiasettingsSetposdataprovider* = Call_ContentLiasettingsSetposdataprovider_580596(
    name: "contentLiasettingsSetposdataprovider", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/setposdataprovider",
    validator: validate_ContentLiasettingsSetposdataprovider_580597,
    base: "/content/v2.1", url: url_ContentLiasettingsSetposdataprovider_580598,
    schemes: {Scheme.Https})
type
  Call_ContentOrderinvoicesCreatechargeinvoice_580615 = ref object of OpenApiRestCall_579373
proc url_ContentOrderinvoicesCreatechargeinvoice_580617(protocol: Scheme;
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

proc validate_ContentOrderinvoicesCreatechargeinvoice_580616(path: JsonNode;
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
  var valid_580618 = path.getOrDefault("merchantId")
  valid_580618 = validateParameter(valid_580618, JString, required = true,
                                 default = nil)
  if valid_580618 != nil:
    section.add "merchantId", valid_580618
  var valid_580619 = path.getOrDefault("orderId")
  valid_580619 = validateParameter(valid_580619, JString, required = true,
                                 default = nil)
  if valid_580619 != nil:
    section.add "orderId", valid_580619
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
  var valid_580620 = query.getOrDefault("key")
  valid_580620 = validateParameter(valid_580620, JString, required = false,
                                 default = nil)
  if valid_580620 != nil:
    section.add "key", valid_580620
  var valid_580621 = query.getOrDefault("prettyPrint")
  valid_580621 = validateParameter(valid_580621, JBool, required = false,
                                 default = newJBool(true))
  if valid_580621 != nil:
    section.add "prettyPrint", valid_580621
  var valid_580622 = query.getOrDefault("oauth_token")
  valid_580622 = validateParameter(valid_580622, JString, required = false,
                                 default = nil)
  if valid_580622 != nil:
    section.add "oauth_token", valid_580622
  var valid_580623 = query.getOrDefault("alt")
  valid_580623 = validateParameter(valid_580623, JString, required = false,
                                 default = newJString("json"))
  if valid_580623 != nil:
    section.add "alt", valid_580623
  var valid_580624 = query.getOrDefault("userIp")
  valid_580624 = validateParameter(valid_580624, JString, required = false,
                                 default = nil)
  if valid_580624 != nil:
    section.add "userIp", valid_580624
  var valid_580625 = query.getOrDefault("quotaUser")
  valid_580625 = validateParameter(valid_580625, JString, required = false,
                                 default = nil)
  if valid_580625 != nil:
    section.add "quotaUser", valid_580625
  var valid_580626 = query.getOrDefault("fields")
  valid_580626 = validateParameter(valid_580626, JString, required = false,
                                 default = nil)
  if valid_580626 != nil:
    section.add "fields", valid_580626
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580628: Call_ContentOrderinvoicesCreatechargeinvoice_580615;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a charge invoice for a shipment group, and triggers a charge capture for orderinvoice enabled orders.
  ## 
  let valid = call_580628.validator(path, query, header, formData, body)
  let scheme = call_580628.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580628.url(scheme.get, call_580628.host, call_580628.base,
                         call_580628.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580628, url, valid)

proc call*(call_580629: Call_ContentOrderinvoicesCreatechargeinvoice_580615;
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
  var path_580630 = newJObject()
  var query_580631 = newJObject()
  var body_580632 = newJObject()
  add(query_580631, "key", newJString(key))
  add(query_580631, "prettyPrint", newJBool(prettyPrint))
  add(query_580631, "oauth_token", newJString(oauthToken))
  add(query_580631, "alt", newJString(alt))
  add(query_580631, "userIp", newJString(userIp))
  add(query_580631, "quotaUser", newJString(quotaUser))
  add(path_580630, "merchantId", newJString(merchantId))
  if body != nil:
    body_580632 = body
  add(query_580631, "fields", newJString(fields))
  add(path_580630, "orderId", newJString(orderId))
  result = call_580629.call(path_580630, query_580631, nil, nil, body_580632)

var contentOrderinvoicesCreatechargeinvoice* = Call_ContentOrderinvoicesCreatechargeinvoice_580615(
    name: "contentOrderinvoicesCreatechargeinvoice", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderinvoices/{orderId}/createChargeInvoice",
    validator: validate_ContentOrderinvoicesCreatechargeinvoice_580616,
    base: "/content/v2.1", url: url_ContentOrderinvoicesCreatechargeinvoice_580617,
    schemes: {Scheme.Https})
type
  Call_ContentOrderinvoicesCreaterefundinvoice_580633 = ref object of OpenApiRestCall_579373
proc url_ContentOrderinvoicesCreaterefundinvoice_580635(protocol: Scheme;
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

proc validate_ContentOrderinvoicesCreaterefundinvoice_580634(path: JsonNode;
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
  var valid_580636 = path.getOrDefault("merchantId")
  valid_580636 = validateParameter(valid_580636, JString, required = true,
                                 default = nil)
  if valid_580636 != nil:
    section.add "merchantId", valid_580636
  var valid_580637 = path.getOrDefault("orderId")
  valid_580637 = validateParameter(valid_580637, JString, required = true,
                                 default = nil)
  if valid_580637 != nil:
    section.add "orderId", valid_580637
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
  var valid_580638 = query.getOrDefault("key")
  valid_580638 = validateParameter(valid_580638, JString, required = false,
                                 default = nil)
  if valid_580638 != nil:
    section.add "key", valid_580638
  var valid_580639 = query.getOrDefault("prettyPrint")
  valid_580639 = validateParameter(valid_580639, JBool, required = false,
                                 default = newJBool(true))
  if valid_580639 != nil:
    section.add "prettyPrint", valid_580639
  var valid_580640 = query.getOrDefault("oauth_token")
  valid_580640 = validateParameter(valid_580640, JString, required = false,
                                 default = nil)
  if valid_580640 != nil:
    section.add "oauth_token", valid_580640
  var valid_580641 = query.getOrDefault("alt")
  valid_580641 = validateParameter(valid_580641, JString, required = false,
                                 default = newJString("json"))
  if valid_580641 != nil:
    section.add "alt", valid_580641
  var valid_580642 = query.getOrDefault("userIp")
  valid_580642 = validateParameter(valid_580642, JString, required = false,
                                 default = nil)
  if valid_580642 != nil:
    section.add "userIp", valid_580642
  var valid_580643 = query.getOrDefault("quotaUser")
  valid_580643 = validateParameter(valid_580643, JString, required = false,
                                 default = nil)
  if valid_580643 != nil:
    section.add "quotaUser", valid_580643
  var valid_580644 = query.getOrDefault("fields")
  valid_580644 = validateParameter(valid_580644, JString, required = false,
                                 default = nil)
  if valid_580644 != nil:
    section.add "fields", valid_580644
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580646: Call_ContentOrderinvoicesCreaterefundinvoice_580633;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a refund invoice for one or more shipment groups, and triggers a refund for orderinvoice enabled orders. This can only be used for line items that have previously been charged using createChargeInvoice. All amounts (except for the summary) are incremental with respect to the previous invoice.
  ## 
  let valid = call_580646.validator(path, query, header, formData, body)
  let scheme = call_580646.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580646.url(scheme.get, call_580646.host, call_580646.base,
                         call_580646.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580646, url, valid)

proc call*(call_580647: Call_ContentOrderinvoicesCreaterefundinvoice_580633;
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
  var path_580648 = newJObject()
  var query_580649 = newJObject()
  var body_580650 = newJObject()
  add(query_580649, "key", newJString(key))
  add(query_580649, "prettyPrint", newJBool(prettyPrint))
  add(query_580649, "oauth_token", newJString(oauthToken))
  add(query_580649, "alt", newJString(alt))
  add(query_580649, "userIp", newJString(userIp))
  add(query_580649, "quotaUser", newJString(quotaUser))
  add(path_580648, "merchantId", newJString(merchantId))
  if body != nil:
    body_580650 = body
  add(query_580649, "fields", newJString(fields))
  add(path_580648, "orderId", newJString(orderId))
  result = call_580647.call(path_580648, query_580649, nil, nil, body_580650)

var contentOrderinvoicesCreaterefundinvoice* = Call_ContentOrderinvoicesCreaterefundinvoice_580633(
    name: "contentOrderinvoicesCreaterefundinvoice", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderinvoices/{orderId}/createRefundInvoice",
    validator: validate_ContentOrderinvoicesCreaterefundinvoice_580634,
    base: "/content/v2.1", url: url_ContentOrderinvoicesCreaterefundinvoice_580635,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreportsListdisbursements_580651 = ref object of OpenApiRestCall_579373
proc url_ContentOrderreportsListdisbursements_580653(protocol: Scheme;
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

proc validate_ContentOrderreportsListdisbursements_580652(path: JsonNode;
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
  var valid_580654 = path.getOrDefault("merchantId")
  valid_580654 = validateParameter(valid_580654, JString, required = true,
                                 default = nil)
  if valid_580654 != nil:
    section.add "merchantId", valid_580654
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
  var valid_580655 = query.getOrDefault("key")
  valid_580655 = validateParameter(valid_580655, JString, required = false,
                                 default = nil)
  if valid_580655 != nil:
    section.add "key", valid_580655
  var valid_580656 = query.getOrDefault("prettyPrint")
  valid_580656 = validateParameter(valid_580656, JBool, required = false,
                                 default = newJBool(true))
  if valid_580656 != nil:
    section.add "prettyPrint", valid_580656
  var valid_580657 = query.getOrDefault("oauth_token")
  valid_580657 = validateParameter(valid_580657, JString, required = false,
                                 default = nil)
  if valid_580657 != nil:
    section.add "oauth_token", valid_580657
  var valid_580658 = query.getOrDefault("disbursementEndDate")
  valid_580658 = validateParameter(valid_580658, JString, required = false,
                                 default = nil)
  if valid_580658 != nil:
    section.add "disbursementEndDate", valid_580658
  var valid_580659 = query.getOrDefault("alt")
  valid_580659 = validateParameter(valid_580659, JString, required = false,
                                 default = newJString("json"))
  if valid_580659 != nil:
    section.add "alt", valid_580659
  var valid_580660 = query.getOrDefault("userIp")
  valid_580660 = validateParameter(valid_580660, JString, required = false,
                                 default = nil)
  if valid_580660 != nil:
    section.add "userIp", valid_580660
  var valid_580661 = query.getOrDefault("quotaUser")
  valid_580661 = validateParameter(valid_580661, JString, required = false,
                                 default = nil)
  if valid_580661 != nil:
    section.add "quotaUser", valid_580661
  var valid_580662 = query.getOrDefault("pageToken")
  valid_580662 = validateParameter(valid_580662, JString, required = false,
                                 default = nil)
  if valid_580662 != nil:
    section.add "pageToken", valid_580662
  assert query != nil, "query argument is necessary due to required `disbursementStartDate` field"
  var valid_580663 = query.getOrDefault("disbursementStartDate")
  valid_580663 = validateParameter(valid_580663, JString, required = true,
                                 default = nil)
  if valid_580663 != nil:
    section.add "disbursementStartDate", valid_580663
  var valid_580664 = query.getOrDefault("fields")
  valid_580664 = validateParameter(valid_580664, JString, required = false,
                                 default = nil)
  if valid_580664 != nil:
    section.add "fields", valid_580664
  var valid_580665 = query.getOrDefault("maxResults")
  valid_580665 = validateParameter(valid_580665, JInt, required = false, default = nil)
  if valid_580665 != nil:
    section.add "maxResults", valid_580665
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580666: Call_ContentOrderreportsListdisbursements_580651;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a report for disbursements from your Merchant Center account.
  ## 
  let valid = call_580666.validator(path, query, header, formData, body)
  let scheme = call_580666.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580666.url(scheme.get, call_580666.host, call_580666.base,
                         call_580666.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580666, url, valid)

proc call*(call_580667: Call_ContentOrderreportsListdisbursements_580651;
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
  var path_580668 = newJObject()
  var query_580669 = newJObject()
  add(query_580669, "key", newJString(key))
  add(query_580669, "prettyPrint", newJBool(prettyPrint))
  add(query_580669, "oauth_token", newJString(oauthToken))
  add(query_580669, "disbursementEndDate", newJString(disbursementEndDate))
  add(query_580669, "alt", newJString(alt))
  add(query_580669, "userIp", newJString(userIp))
  add(query_580669, "quotaUser", newJString(quotaUser))
  add(path_580668, "merchantId", newJString(merchantId))
  add(query_580669, "pageToken", newJString(pageToken))
  add(query_580669, "disbursementStartDate", newJString(disbursementStartDate))
  add(query_580669, "fields", newJString(fields))
  add(query_580669, "maxResults", newJInt(maxResults))
  result = call_580667.call(path_580668, query_580669, nil, nil, nil)

var contentOrderreportsListdisbursements* = Call_ContentOrderreportsListdisbursements_580651(
    name: "contentOrderreportsListdisbursements", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreports/disbursements",
    validator: validate_ContentOrderreportsListdisbursements_580652,
    base: "/content/v2.1", url: url_ContentOrderreportsListdisbursements_580653,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreportsListtransactions_580670 = ref object of OpenApiRestCall_579373
proc url_ContentOrderreportsListtransactions_580672(protocol: Scheme; host: string;
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

proc validate_ContentOrderreportsListtransactions_580671(path: JsonNode;
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
  var valid_580673 = path.getOrDefault("merchantId")
  valid_580673 = validateParameter(valid_580673, JString, required = true,
                                 default = nil)
  if valid_580673 != nil:
    section.add "merchantId", valid_580673
  var valid_580674 = path.getOrDefault("disbursementId")
  valid_580674 = validateParameter(valid_580674, JString, required = true,
                                 default = nil)
  if valid_580674 != nil:
    section.add "disbursementId", valid_580674
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
  var valid_580675 = query.getOrDefault("key")
  valid_580675 = validateParameter(valid_580675, JString, required = false,
                                 default = nil)
  if valid_580675 != nil:
    section.add "key", valid_580675
  var valid_580676 = query.getOrDefault("prettyPrint")
  valid_580676 = validateParameter(valid_580676, JBool, required = false,
                                 default = newJBool(true))
  if valid_580676 != nil:
    section.add "prettyPrint", valid_580676
  var valid_580677 = query.getOrDefault("oauth_token")
  valid_580677 = validateParameter(valid_580677, JString, required = false,
                                 default = nil)
  if valid_580677 != nil:
    section.add "oauth_token", valid_580677
  var valid_580678 = query.getOrDefault("transactionEndDate")
  valid_580678 = validateParameter(valid_580678, JString, required = false,
                                 default = nil)
  if valid_580678 != nil:
    section.add "transactionEndDate", valid_580678
  var valid_580679 = query.getOrDefault("alt")
  valid_580679 = validateParameter(valid_580679, JString, required = false,
                                 default = newJString("json"))
  if valid_580679 != nil:
    section.add "alt", valid_580679
  var valid_580680 = query.getOrDefault("userIp")
  valid_580680 = validateParameter(valid_580680, JString, required = false,
                                 default = nil)
  if valid_580680 != nil:
    section.add "userIp", valid_580680
  assert query != nil, "query argument is necessary due to required `transactionStartDate` field"
  var valid_580681 = query.getOrDefault("transactionStartDate")
  valid_580681 = validateParameter(valid_580681, JString, required = true,
                                 default = nil)
  if valid_580681 != nil:
    section.add "transactionStartDate", valid_580681
  var valid_580682 = query.getOrDefault("quotaUser")
  valid_580682 = validateParameter(valid_580682, JString, required = false,
                                 default = nil)
  if valid_580682 != nil:
    section.add "quotaUser", valid_580682
  var valid_580683 = query.getOrDefault("pageToken")
  valid_580683 = validateParameter(valid_580683, JString, required = false,
                                 default = nil)
  if valid_580683 != nil:
    section.add "pageToken", valid_580683
  var valid_580684 = query.getOrDefault("fields")
  valid_580684 = validateParameter(valid_580684, JString, required = false,
                                 default = nil)
  if valid_580684 != nil:
    section.add "fields", valid_580684
  var valid_580685 = query.getOrDefault("maxResults")
  valid_580685 = validateParameter(valid_580685, JInt, required = false, default = nil)
  if valid_580685 != nil:
    section.add "maxResults", valid_580685
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580686: Call_ContentOrderreportsListtransactions_580670;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of transactions for a disbursement from your Merchant Center account.
  ## 
  let valid = call_580686.validator(path, query, header, formData, body)
  let scheme = call_580686.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580686.url(scheme.get, call_580686.host, call_580686.base,
                         call_580686.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580686, url, valid)

proc call*(call_580687: Call_ContentOrderreportsListtransactions_580670;
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
  var path_580688 = newJObject()
  var query_580689 = newJObject()
  add(query_580689, "key", newJString(key))
  add(query_580689, "prettyPrint", newJBool(prettyPrint))
  add(query_580689, "oauth_token", newJString(oauthToken))
  add(query_580689, "transactionEndDate", newJString(transactionEndDate))
  add(query_580689, "alt", newJString(alt))
  add(query_580689, "userIp", newJString(userIp))
  add(query_580689, "transactionStartDate", newJString(transactionStartDate))
  add(query_580689, "quotaUser", newJString(quotaUser))
  add(path_580688, "merchantId", newJString(merchantId))
  add(query_580689, "pageToken", newJString(pageToken))
  add(path_580688, "disbursementId", newJString(disbursementId))
  add(query_580689, "fields", newJString(fields))
  add(query_580689, "maxResults", newJInt(maxResults))
  result = call_580687.call(path_580688, query_580689, nil, nil, nil)

var contentOrderreportsListtransactions* = Call_ContentOrderreportsListtransactions_580670(
    name: "contentOrderreportsListtransactions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreports/disbursements/{disbursementId}/transactions",
    validator: validate_ContentOrderreportsListtransactions_580671,
    base: "/content/v2.1", url: url_ContentOrderreportsListtransactions_580672,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreturnsList_580690 = ref object of OpenApiRestCall_579373
proc url_ContentOrderreturnsList_580692(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrderreturnsList_580691(path: JsonNode; query: JsonNode;
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
  var valid_580693 = path.getOrDefault("merchantId")
  valid_580693 = validateParameter(valid_580693, JString, required = true,
                                 default = nil)
  if valid_580693 != nil:
    section.add "merchantId", valid_580693
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
  var valid_580694 = query.getOrDefault("key")
  valid_580694 = validateParameter(valid_580694, JString, required = false,
                                 default = nil)
  if valid_580694 != nil:
    section.add "key", valid_580694
  var valid_580695 = query.getOrDefault("prettyPrint")
  valid_580695 = validateParameter(valid_580695, JBool, required = false,
                                 default = newJBool(true))
  if valid_580695 != nil:
    section.add "prettyPrint", valid_580695
  var valid_580696 = query.getOrDefault("oauth_token")
  valid_580696 = validateParameter(valid_580696, JString, required = false,
                                 default = nil)
  if valid_580696 != nil:
    section.add "oauth_token", valid_580696
  var valid_580697 = query.getOrDefault("createdStartDate")
  valid_580697 = validateParameter(valid_580697, JString, required = false,
                                 default = nil)
  if valid_580697 != nil:
    section.add "createdStartDate", valid_580697
  var valid_580698 = query.getOrDefault("alt")
  valid_580698 = validateParameter(valid_580698, JString, required = false,
                                 default = newJString("json"))
  if valid_580698 != nil:
    section.add "alt", valid_580698
  var valid_580699 = query.getOrDefault("userIp")
  valid_580699 = validateParameter(valid_580699, JString, required = false,
                                 default = nil)
  if valid_580699 != nil:
    section.add "userIp", valid_580699
  var valid_580700 = query.getOrDefault("quotaUser")
  valid_580700 = validateParameter(valid_580700, JString, required = false,
                                 default = nil)
  if valid_580700 != nil:
    section.add "quotaUser", valid_580700
  var valid_580701 = query.getOrDefault("orderBy")
  valid_580701 = validateParameter(valid_580701, JString, required = false,
                                 default = newJString("returnCreationTimeAsc"))
  if valid_580701 != nil:
    section.add "orderBy", valid_580701
  var valid_580702 = query.getOrDefault("pageToken")
  valid_580702 = validateParameter(valid_580702, JString, required = false,
                                 default = nil)
  if valid_580702 != nil:
    section.add "pageToken", valid_580702
  var valid_580703 = query.getOrDefault("fields")
  valid_580703 = validateParameter(valid_580703, JString, required = false,
                                 default = nil)
  if valid_580703 != nil:
    section.add "fields", valid_580703
  var valid_580704 = query.getOrDefault("maxResults")
  valid_580704 = validateParameter(valid_580704, JInt, required = false, default = nil)
  if valid_580704 != nil:
    section.add "maxResults", valid_580704
  var valid_580705 = query.getOrDefault("createdEndDate")
  valid_580705 = validateParameter(valid_580705, JString, required = false,
                                 default = nil)
  if valid_580705 != nil:
    section.add "createdEndDate", valid_580705
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580706: Call_ContentOrderreturnsList_580690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists order returns in your Merchant Center account.
  ## 
  let valid = call_580706.validator(path, query, header, formData, body)
  let scheme = call_580706.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580706.url(scheme.get, call_580706.host, call_580706.base,
                         call_580706.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580706, url, valid)

proc call*(call_580707: Call_ContentOrderreturnsList_580690; merchantId: string;
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
  var path_580708 = newJObject()
  var query_580709 = newJObject()
  add(query_580709, "key", newJString(key))
  add(query_580709, "prettyPrint", newJBool(prettyPrint))
  add(query_580709, "oauth_token", newJString(oauthToken))
  add(query_580709, "createdStartDate", newJString(createdStartDate))
  add(query_580709, "alt", newJString(alt))
  add(query_580709, "userIp", newJString(userIp))
  add(query_580709, "quotaUser", newJString(quotaUser))
  add(path_580708, "merchantId", newJString(merchantId))
  add(query_580709, "orderBy", newJString(orderBy))
  add(query_580709, "pageToken", newJString(pageToken))
  add(query_580709, "fields", newJString(fields))
  add(query_580709, "maxResults", newJInt(maxResults))
  add(query_580709, "createdEndDate", newJString(createdEndDate))
  result = call_580707.call(path_580708, query_580709, nil, nil, nil)

var contentOrderreturnsList* = Call_ContentOrderreturnsList_580690(
    name: "contentOrderreturnsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreturns",
    validator: validate_ContentOrderreturnsList_580691, base: "/content/v2.1",
    url: url_ContentOrderreturnsList_580692, schemes: {Scheme.Https})
type
  Call_ContentOrderreturnsGet_580710 = ref object of OpenApiRestCall_579373
proc url_ContentOrderreturnsGet_580712(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrderreturnsGet_580711(path: JsonNode; query: JsonNode;
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
  var valid_580713 = path.getOrDefault("returnId")
  valid_580713 = validateParameter(valid_580713, JString, required = true,
                                 default = nil)
  if valid_580713 != nil:
    section.add "returnId", valid_580713
  var valid_580714 = path.getOrDefault("merchantId")
  valid_580714 = validateParameter(valid_580714, JString, required = true,
                                 default = nil)
  if valid_580714 != nil:
    section.add "merchantId", valid_580714
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
  var valid_580715 = query.getOrDefault("key")
  valid_580715 = validateParameter(valid_580715, JString, required = false,
                                 default = nil)
  if valid_580715 != nil:
    section.add "key", valid_580715
  var valid_580716 = query.getOrDefault("prettyPrint")
  valid_580716 = validateParameter(valid_580716, JBool, required = false,
                                 default = newJBool(true))
  if valid_580716 != nil:
    section.add "prettyPrint", valid_580716
  var valid_580717 = query.getOrDefault("oauth_token")
  valid_580717 = validateParameter(valid_580717, JString, required = false,
                                 default = nil)
  if valid_580717 != nil:
    section.add "oauth_token", valid_580717
  var valid_580718 = query.getOrDefault("alt")
  valid_580718 = validateParameter(valid_580718, JString, required = false,
                                 default = newJString("json"))
  if valid_580718 != nil:
    section.add "alt", valid_580718
  var valid_580719 = query.getOrDefault("userIp")
  valid_580719 = validateParameter(valid_580719, JString, required = false,
                                 default = nil)
  if valid_580719 != nil:
    section.add "userIp", valid_580719
  var valid_580720 = query.getOrDefault("quotaUser")
  valid_580720 = validateParameter(valid_580720, JString, required = false,
                                 default = nil)
  if valid_580720 != nil:
    section.add "quotaUser", valid_580720
  var valid_580721 = query.getOrDefault("fields")
  valid_580721 = validateParameter(valid_580721, JString, required = false,
                                 default = nil)
  if valid_580721 != nil:
    section.add "fields", valid_580721
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580722: Call_ContentOrderreturnsGet_580710; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an order return from your Merchant Center account.
  ## 
  let valid = call_580722.validator(path, query, header, formData, body)
  let scheme = call_580722.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580722.url(scheme.get, call_580722.host, call_580722.base,
                         call_580722.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580722, url, valid)

proc call*(call_580723: Call_ContentOrderreturnsGet_580710; returnId: string;
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
  var path_580724 = newJObject()
  var query_580725 = newJObject()
  add(query_580725, "key", newJString(key))
  add(query_580725, "prettyPrint", newJBool(prettyPrint))
  add(query_580725, "oauth_token", newJString(oauthToken))
  add(path_580724, "returnId", newJString(returnId))
  add(query_580725, "alt", newJString(alt))
  add(query_580725, "userIp", newJString(userIp))
  add(query_580725, "quotaUser", newJString(quotaUser))
  add(path_580724, "merchantId", newJString(merchantId))
  add(query_580725, "fields", newJString(fields))
  result = call_580723.call(path_580724, query_580725, nil, nil, nil)

var contentOrderreturnsGet* = Call_ContentOrderreturnsGet_580710(
    name: "contentOrderreturnsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreturns/{returnId}",
    validator: validate_ContentOrderreturnsGet_580711, base: "/content/v2.1",
    url: url_ContentOrderreturnsGet_580712, schemes: {Scheme.Https})
type
  Call_ContentOrdersList_580726 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersList_580728(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrdersList_580727(path: JsonNode; query: JsonNode;
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
  var valid_580729 = path.getOrDefault("merchantId")
  valid_580729 = validateParameter(valid_580729, JString, required = true,
                                 default = nil)
  if valid_580729 != nil:
    section.add "merchantId", valid_580729
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
  var valid_580732 = query.getOrDefault("oauth_token")
  valid_580732 = validateParameter(valid_580732, JString, required = false,
                                 default = nil)
  if valid_580732 != nil:
    section.add "oauth_token", valid_580732
  var valid_580733 = query.getOrDefault("alt")
  valid_580733 = validateParameter(valid_580733, JString, required = false,
                                 default = newJString("json"))
  if valid_580733 != nil:
    section.add "alt", valid_580733
  var valid_580734 = query.getOrDefault("userIp")
  valid_580734 = validateParameter(valid_580734, JString, required = false,
                                 default = nil)
  if valid_580734 != nil:
    section.add "userIp", valid_580734
  var valid_580735 = query.getOrDefault("quotaUser")
  valid_580735 = validateParameter(valid_580735, JString, required = false,
                                 default = nil)
  if valid_580735 != nil:
    section.add "quotaUser", valid_580735
  var valid_580736 = query.getOrDefault("orderBy")
  valid_580736 = validateParameter(valid_580736, JString, required = false,
                                 default = nil)
  if valid_580736 != nil:
    section.add "orderBy", valid_580736
  var valid_580737 = query.getOrDefault("pageToken")
  valid_580737 = validateParameter(valid_580737, JString, required = false,
                                 default = nil)
  if valid_580737 != nil:
    section.add "pageToken", valid_580737
  var valid_580738 = query.getOrDefault("placedDateStart")
  valid_580738 = validateParameter(valid_580738, JString, required = false,
                                 default = nil)
  if valid_580738 != nil:
    section.add "placedDateStart", valid_580738
  var valid_580739 = query.getOrDefault("statuses")
  valid_580739 = validateParameter(valid_580739, JArray, required = false,
                                 default = nil)
  if valid_580739 != nil:
    section.add "statuses", valid_580739
  var valid_580740 = query.getOrDefault("acknowledged")
  valid_580740 = validateParameter(valid_580740, JBool, required = false, default = nil)
  if valid_580740 != nil:
    section.add "acknowledged", valid_580740
  var valid_580741 = query.getOrDefault("placedDateEnd")
  valid_580741 = validateParameter(valid_580741, JString, required = false,
                                 default = nil)
  if valid_580741 != nil:
    section.add "placedDateEnd", valid_580741
  var valid_580742 = query.getOrDefault("fields")
  valid_580742 = validateParameter(valid_580742, JString, required = false,
                                 default = nil)
  if valid_580742 != nil:
    section.add "fields", valid_580742
  var valid_580743 = query.getOrDefault("maxResults")
  valid_580743 = validateParameter(valid_580743, JInt, required = false, default = nil)
  if valid_580743 != nil:
    section.add "maxResults", valid_580743
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580744: Call_ContentOrdersList_580726; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the orders in your Merchant Center account.
  ## 
  let valid = call_580744.validator(path, query, header, formData, body)
  let scheme = call_580744.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580744.url(scheme.get, call_580744.host, call_580744.base,
                         call_580744.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580744, url, valid)

proc call*(call_580745: Call_ContentOrdersList_580726; merchantId: string;
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
  var path_580746 = newJObject()
  var query_580747 = newJObject()
  add(query_580747, "key", newJString(key))
  add(query_580747, "prettyPrint", newJBool(prettyPrint))
  add(query_580747, "oauth_token", newJString(oauthToken))
  add(query_580747, "alt", newJString(alt))
  add(query_580747, "userIp", newJString(userIp))
  add(query_580747, "quotaUser", newJString(quotaUser))
  add(path_580746, "merchantId", newJString(merchantId))
  add(query_580747, "orderBy", newJString(orderBy))
  add(query_580747, "pageToken", newJString(pageToken))
  add(query_580747, "placedDateStart", newJString(placedDateStart))
  if statuses != nil:
    query_580747.add "statuses", statuses
  add(query_580747, "acknowledged", newJBool(acknowledged))
  add(query_580747, "placedDateEnd", newJString(placedDateEnd))
  add(query_580747, "fields", newJString(fields))
  add(query_580747, "maxResults", newJInt(maxResults))
  result = call_580745.call(path_580746, query_580747, nil, nil, nil)

var contentOrdersList* = Call_ContentOrdersList_580726(name: "contentOrdersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/orders", validator: validate_ContentOrdersList_580727,
    base: "/content/v2.1", url: url_ContentOrdersList_580728,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersGet_580748 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersGet_580750(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrdersGet_580749(path: JsonNode; query: JsonNode;
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
  var valid_580751 = path.getOrDefault("merchantId")
  valid_580751 = validateParameter(valid_580751, JString, required = true,
                                 default = nil)
  if valid_580751 != nil:
    section.add "merchantId", valid_580751
  var valid_580752 = path.getOrDefault("orderId")
  valid_580752 = validateParameter(valid_580752, JString, required = true,
                                 default = nil)
  if valid_580752 != nil:
    section.add "orderId", valid_580752
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
  var valid_580753 = query.getOrDefault("key")
  valid_580753 = validateParameter(valid_580753, JString, required = false,
                                 default = nil)
  if valid_580753 != nil:
    section.add "key", valid_580753
  var valid_580754 = query.getOrDefault("prettyPrint")
  valid_580754 = validateParameter(valid_580754, JBool, required = false,
                                 default = newJBool(true))
  if valid_580754 != nil:
    section.add "prettyPrint", valid_580754
  var valid_580755 = query.getOrDefault("oauth_token")
  valid_580755 = validateParameter(valid_580755, JString, required = false,
                                 default = nil)
  if valid_580755 != nil:
    section.add "oauth_token", valid_580755
  var valid_580756 = query.getOrDefault("alt")
  valid_580756 = validateParameter(valid_580756, JString, required = false,
                                 default = newJString("json"))
  if valid_580756 != nil:
    section.add "alt", valid_580756
  var valid_580757 = query.getOrDefault("userIp")
  valid_580757 = validateParameter(valid_580757, JString, required = false,
                                 default = nil)
  if valid_580757 != nil:
    section.add "userIp", valid_580757
  var valid_580758 = query.getOrDefault("quotaUser")
  valid_580758 = validateParameter(valid_580758, JString, required = false,
                                 default = nil)
  if valid_580758 != nil:
    section.add "quotaUser", valid_580758
  var valid_580759 = query.getOrDefault("fields")
  valid_580759 = validateParameter(valid_580759, JString, required = false,
                                 default = nil)
  if valid_580759 != nil:
    section.add "fields", valid_580759
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580760: Call_ContentOrdersGet_580748; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an order from your Merchant Center account.
  ## 
  let valid = call_580760.validator(path, query, header, formData, body)
  let scheme = call_580760.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580760.url(scheme.get, call_580760.host, call_580760.base,
                         call_580760.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580760, url, valid)

proc call*(call_580761: Call_ContentOrdersGet_580748; merchantId: string;
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
  var path_580762 = newJObject()
  var query_580763 = newJObject()
  add(query_580763, "key", newJString(key))
  add(query_580763, "prettyPrint", newJBool(prettyPrint))
  add(query_580763, "oauth_token", newJString(oauthToken))
  add(query_580763, "alt", newJString(alt))
  add(query_580763, "userIp", newJString(userIp))
  add(query_580763, "quotaUser", newJString(quotaUser))
  add(path_580762, "merchantId", newJString(merchantId))
  add(query_580763, "fields", newJString(fields))
  add(path_580762, "orderId", newJString(orderId))
  result = call_580761.call(path_580762, query_580763, nil, nil, nil)

var contentOrdersGet* = Call_ContentOrdersGet_580748(name: "contentOrdersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}", validator: validate_ContentOrdersGet_580749,
    base: "/content/v2.1", url: url_ContentOrdersGet_580750, schemes: {Scheme.Https})
type
  Call_ContentOrdersAcknowledge_580764 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersAcknowledge_580766(protocol: Scheme; host: string;
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

proc validate_ContentOrdersAcknowledge_580765(path: JsonNode; query: JsonNode;
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
  var valid_580767 = path.getOrDefault("merchantId")
  valid_580767 = validateParameter(valid_580767, JString, required = true,
                                 default = nil)
  if valid_580767 != nil:
    section.add "merchantId", valid_580767
  var valid_580768 = path.getOrDefault("orderId")
  valid_580768 = validateParameter(valid_580768, JString, required = true,
                                 default = nil)
  if valid_580768 != nil:
    section.add "orderId", valid_580768
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
  var valid_580771 = query.getOrDefault("oauth_token")
  valid_580771 = validateParameter(valid_580771, JString, required = false,
                                 default = nil)
  if valid_580771 != nil:
    section.add "oauth_token", valid_580771
  var valid_580772 = query.getOrDefault("alt")
  valid_580772 = validateParameter(valid_580772, JString, required = false,
                                 default = newJString("json"))
  if valid_580772 != nil:
    section.add "alt", valid_580772
  var valid_580773 = query.getOrDefault("userIp")
  valid_580773 = validateParameter(valid_580773, JString, required = false,
                                 default = nil)
  if valid_580773 != nil:
    section.add "userIp", valid_580773
  var valid_580774 = query.getOrDefault("quotaUser")
  valid_580774 = validateParameter(valid_580774, JString, required = false,
                                 default = nil)
  if valid_580774 != nil:
    section.add "quotaUser", valid_580774
  var valid_580775 = query.getOrDefault("fields")
  valid_580775 = validateParameter(valid_580775, JString, required = false,
                                 default = nil)
  if valid_580775 != nil:
    section.add "fields", valid_580775
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580777: Call_ContentOrdersAcknowledge_580764; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks an order as acknowledged.
  ## 
  let valid = call_580777.validator(path, query, header, formData, body)
  let scheme = call_580777.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580777.url(scheme.get, call_580777.host, call_580777.base,
                         call_580777.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580777, url, valid)

proc call*(call_580778: Call_ContentOrdersAcknowledge_580764; merchantId: string;
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
  var path_580779 = newJObject()
  var query_580780 = newJObject()
  var body_580781 = newJObject()
  add(query_580780, "key", newJString(key))
  add(query_580780, "prettyPrint", newJBool(prettyPrint))
  add(query_580780, "oauth_token", newJString(oauthToken))
  add(query_580780, "alt", newJString(alt))
  add(query_580780, "userIp", newJString(userIp))
  add(query_580780, "quotaUser", newJString(quotaUser))
  add(path_580779, "merchantId", newJString(merchantId))
  if body != nil:
    body_580781 = body
  add(query_580780, "fields", newJString(fields))
  add(path_580779, "orderId", newJString(orderId))
  result = call_580778.call(path_580779, query_580780, nil, nil, body_580781)

var contentOrdersAcknowledge* = Call_ContentOrdersAcknowledge_580764(
    name: "contentOrdersAcknowledge", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/acknowledge",
    validator: validate_ContentOrdersAcknowledge_580765, base: "/content/v2.1",
    url: url_ContentOrdersAcknowledge_580766, schemes: {Scheme.Https})
type
  Call_ContentOrdersCancel_580782 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersCancel_580784(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrdersCancel_580783(path: JsonNode; query: JsonNode;
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
  var valid_580785 = path.getOrDefault("merchantId")
  valid_580785 = validateParameter(valid_580785, JString, required = true,
                                 default = nil)
  if valid_580785 != nil:
    section.add "merchantId", valid_580785
  var valid_580786 = path.getOrDefault("orderId")
  valid_580786 = validateParameter(valid_580786, JString, required = true,
                                 default = nil)
  if valid_580786 != nil:
    section.add "orderId", valid_580786
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
  var valid_580789 = query.getOrDefault("oauth_token")
  valid_580789 = validateParameter(valid_580789, JString, required = false,
                                 default = nil)
  if valid_580789 != nil:
    section.add "oauth_token", valid_580789
  var valid_580790 = query.getOrDefault("alt")
  valid_580790 = validateParameter(valid_580790, JString, required = false,
                                 default = newJString("json"))
  if valid_580790 != nil:
    section.add "alt", valid_580790
  var valid_580791 = query.getOrDefault("userIp")
  valid_580791 = validateParameter(valid_580791, JString, required = false,
                                 default = nil)
  if valid_580791 != nil:
    section.add "userIp", valid_580791
  var valid_580792 = query.getOrDefault("quotaUser")
  valid_580792 = validateParameter(valid_580792, JString, required = false,
                                 default = nil)
  if valid_580792 != nil:
    section.add "quotaUser", valid_580792
  var valid_580793 = query.getOrDefault("fields")
  valid_580793 = validateParameter(valid_580793, JString, required = false,
                                 default = nil)
  if valid_580793 != nil:
    section.add "fields", valid_580793
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580795: Call_ContentOrdersCancel_580782; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels all line items in an order, making a full refund.
  ## 
  let valid = call_580795.validator(path, query, header, formData, body)
  let scheme = call_580795.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580795.url(scheme.get, call_580795.host, call_580795.base,
                         call_580795.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580795, url, valid)

proc call*(call_580796: Call_ContentOrdersCancel_580782; merchantId: string;
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
  var path_580797 = newJObject()
  var query_580798 = newJObject()
  var body_580799 = newJObject()
  add(query_580798, "key", newJString(key))
  add(query_580798, "prettyPrint", newJBool(prettyPrint))
  add(query_580798, "oauth_token", newJString(oauthToken))
  add(query_580798, "alt", newJString(alt))
  add(query_580798, "userIp", newJString(userIp))
  add(query_580798, "quotaUser", newJString(quotaUser))
  add(path_580797, "merchantId", newJString(merchantId))
  if body != nil:
    body_580799 = body
  add(query_580798, "fields", newJString(fields))
  add(path_580797, "orderId", newJString(orderId))
  result = call_580796.call(path_580797, query_580798, nil, nil, body_580799)

var contentOrdersCancel* = Call_ContentOrdersCancel_580782(
    name: "contentOrdersCancel", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/orders/{orderId}/cancel",
    validator: validate_ContentOrdersCancel_580783, base: "/content/v2.1",
    url: url_ContentOrdersCancel_580784, schemes: {Scheme.Https})
type
  Call_ContentOrdersCancellineitem_580800 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersCancellineitem_580802(protocol: Scheme; host: string;
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

proc validate_ContentOrdersCancellineitem_580801(path: JsonNode; query: JsonNode;
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
  var valid_580803 = path.getOrDefault("merchantId")
  valid_580803 = validateParameter(valid_580803, JString, required = true,
                                 default = nil)
  if valid_580803 != nil:
    section.add "merchantId", valid_580803
  var valid_580804 = path.getOrDefault("orderId")
  valid_580804 = validateParameter(valid_580804, JString, required = true,
                                 default = nil)
  if valid_580804 != nil:
    section.add "orderId", valid_580804
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
  var valid_580807 = query.getOrDefault("oauth_token")
  valid_580807 = validateParameter(valid_580807, JString, required = false,
                                 default = nil)
  if valid_580807 != nil:
    section.add "oauth_token", valid_580807
  var valid_580808 = query.getOrDefault("alt")
  valid_580808 = validateParameter(valid_580808, JString, required = false,
                                 default = newJString("json"))
  if valid_580808 != nil:
    section.add "alt", valid_580808
  var valid_580809 = query.getOrDefault("userIp")
  valid_580809 = validateParameter(valid_580809, JString, required = false,
                                 default = nil)
  if valid_580809 != nil:
    section.add "userIp", valid_580809
  var valid_580810 = query.getOrDefault("quotaUser")
  valid_580810 = validateParameter(valid_580810, JString, required = false,
                                 default = nil)
  if valid_580810 != nil:
    section.add "quotaUser", valid_580810
  var valid_580811 = query.getOrDefault("fields")
  valid_580811 = validateParameter(valid_580811, JString, required = false,
                                 default = nil)
  if valid_580811 != nil:
    section.add "fields", valid_580811
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580813: Call_ContentOrdersCancellineitem_580800; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a line item, making a full refund.
  ## 
  let valid = call_580813.validator(path, query, header, formData, body)
  let scheme = call_580813.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580813.url(scheme.get, call_580813.host, call_580813.base,
                         call_580813.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580813, url, valid)

proc call*(call_580814: Call_ContentOrdersCancellineitem_580800;
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
  var path_580815 = newJObject()
  var query_580816 = newJObject()
  var body_580817 = newJObject()
  add(query_580816, "key", newJString(key))
  add(query_580816, "prettyPrint", newJBool(prettyPrint))
  add(query_580816, "oauth_token", newJString(oauthToken))
  add(query_580816, "alt", newJString(alt))
  add(query_580816, "userIp", newJString(userIp))
  add(query_580816, "quotaUser", newJString(quotaUser))
  add(path_580815, "merchantId", newJString(merchantId))
  if body != nil:
    body_580817 = body
  add(query_580816, "fields", newJString(fields))
  add(path_580815, "orderId", newJString(orderId))
  result = call_580814.call(path_580815, query_580816, nil, nil, body_580817)

var contentOrdersCancellineitem* = Call_ContentOrdersCancellineitem_580800(
    name: "contentOrdersCancellineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/cancelLineItem",
    validator: validate_ContentOrdersCancellineitem_580801, base: "/content/v2.1",
    url: url_ContentOrdersCancellineitem_580802, schemes: {Scheme.Https})
type
  Call_ContentOrdersInstorerefundlineitem_580818 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersInstorerefundlineitem_580820(protocol: Scheme; host: string;
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

proc validate_ContentOrdersInstorerefundlineitem_580819(path: JsonNode;
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
  var valid_580821 = path.getOrDefault("merchantId")
  valid_580821 = validateParameter(valid_580821, JString, required = true,
                                 default = nil)
  if valid_580821 != nil:
    section.add "merchantId", valid_580821
  var valid_580822 = path.getOrDefault("orderId")
  valid_580822 = validateParameter(valid_580822, JString, required = true,
                                 default = nil)
  if valid_580822 != nil:
    section.add "orderId", valid_580822
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
  var valid_580825 = query.getOrDefault("oauth_token")
  valid_580825 = validateParameter(valid_580825, JString, required = false,
                                 default = nil)
  if valid_580825 != nil:
    section.add "oauth_token", valid_580825
  var valid_580826 = query.getOrDefault("alt")
  valid_580826 = validateParameter(valid_580826, JString, required = false,
                                 default = newJString("json"))
  if valid_580826 != nil:
    section.add "alt", valid_580826
  var valid_580827 = query.getOrDefault("userIp")
  valid_580827 = validateParameter(valid_580827, JString, required = false,
                                 default = nil)
  if valid_580827 != nil:
    section.add "userIp", valid_580827
  var valid_580828 = query.getOrDefault("quotaUser")
  valid_580828 = validateParameter(valid_580828, JString, required = false,
                                 default = nil)
  if valid_580828 != nil:
    section.add "quotaUser", valid_580828
  var valid_580829 = query.getOrDefault("fields")
  valid_580829 = validateParameter(valid_580829, JString, required = false,
                                 default = nil)
  if valid_580829 != nil:
    section.add "fields", valid_580829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580831: Call_ContentOrdersInstorerefundlineitem_580818;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deprecated. Notifies that item return and refund was handled directly by merchant outside of Google payments processing (e.g. cash refund done in store).
  ## Note: We recommend calling the returnrefundlineitem method to refund in-store returns. We will issue the refund directly to the customer. This helps to prevent possible differences arising between merchant and Google transaction records. We also recommend having the point of sale system communicate with Google to ensure that customers do not receive a double refund by first refunding via Google then via an in-store return.
  ## 
  let valid = call_580831.validator(path, query, header, formData, body)
  let scheme = call_580831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580831.url(scheme.get, call_580831.host, call_580831.base,
                         call_580831.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580831, url, valid)

proc call*(call_580832: Call_ContentOrdersInstorerefundlineitem_580818;
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
  var path_580833 = newJObject()
  var query_580834 = newJObject()
  var body_580835 = newJObject()
  add(query_580834, "key", newJString(key))
  add(query_580834, "prettyPrint", newJBool(prettyPrint))
  add(query_580834, "oauth_token", newJString(oauthToken))
  add(query_580834, "alt", newJString(alt))
  add(query_580834, "userIp", newJString(userIp))
  add(query_580834, "quotaUser", newJString(quotaUser))
  add(path_580833, "merchantId", newJString(merchantId))
  if body != nil:
    body_580835 = body
  add(query_580834, "fields", newJString(fields))
  add(path_580833, "orderId", newJString(orderId))
  result = call_580832.call(path_580833, query_580834, nil, nil, body_580835)

var contentOrdersInstorerefundlineitem* = Call_ContentOrdersInstorerefundlineitem_580818(
    name: "contentOrdersInstorerefundlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/inStoreRefundLineItem",
    validator: validate_ContentOrdersInstorerefundlineitem_580819,
    base: "/content/v2.1", url: url_ContentOrdersInstorerefundlineitem_580820,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersRejectreturnlineitem_580836 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersRejectreturnlineitem_580838(protocol: Scheme; host: string;
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

proc validate_ContentOrdersRejectreturnlineitem_580837(path: JsonNode;
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
  var valid_580839 = path.getOrDefault("merchantId")
  valid_580839 = validateParameter(valid_580839, JString, required = true,
                                 default = nil)
  if valid_580839 != nil:
    section.add "merchantId", valid_580839
  var valid_580840 = path.getOrDefault("orderId")
  valid_580840 = validateParameter(valid_580840, JString, required = true,
                                 default = nil)
  if valid_580840 != nil:
    section.add "orderId", valid_580840
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
  var valid_580843 = query.getOrDefault("oauth_token")
  valid_580843 = validateParameter(valid_580843, JString, required = false,
                                 default = nil)
  if valid_580843 != nil:
    section.add "oauth_token", valid_580843
  var valid_580844 = query.getOrDefault("alt")
  valid_580844 = validateParameter(valid_580844, JString, required = false,
                                 default = newJString("json"))
  if valid_580844 != nil:
    section.add "alt", valid_580844
  var valid_580845 = query.getOrDefault("userIp")
  valid_580845 = validateParameter(valid_580845, JString, required = false,
                                 default = nil)
  if valid_580845 != nil:
    section.add "userIp", valid_580845
  var valid_580846 = query.getOrDefault("quotaUser")
  valid_580846 = validateParameter(valid_580846, JString, required = false,
                                 default = nil)
  if valid_580846 != nil:
    section.add "quotaUser", valid_580846
  var valid_580847 = query.getOrDefault("fields")
  valid_580847 = validateParameter(valid_580847, JString, required = false,
                                 default = nil)
  if valid_580847 != nil:
    section.add "fields", valid_580847
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580849: Call_ContentOrdersRejectreturnlineitem_580836;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rejects return on an line item.
  ## 
  let valid = call_580849.validator(path, query, header, formData, body)
  let scheme = call_580849.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580849.url(scheme.get, call_580849.host, call_580849.base,
                         call_580849.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580849, url, valid)

proc call*(call_580850: Call_ContentOrdersRejectreturnlineitem_580836;
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
  var path_580851 = newJObject()
  var query_580852 = newJObject()
  var body_580853 = newJObject()
  add(query_580852, "key", newJString(key))
  add(query_580852, "prettyPrint", newJBool(prettyPrint))
  add(query_580852, "oauth_token", newJString(oauthToken))
  add(query_580852, "alt", newJString(alt))
  add(query_580852, "userIp", newJString(userIp))
  add(query_580852, "quotaUser", newJString(quotaUser))
  add(path_580851, "merchantId", newJString(merchantId))
  if body != nil:
    body_580853 = body
  add(query_580852, "fields", newJString(fields))
  add(path_580851, "orderId", newJString(orderId))
  result = call_580850.call(path_580851, query_580852, nil, nil, body_580853)

var contentOrdersRejectreturnlineitem* = Call_ContentOrdersRejectreturnlineitem_580836(
    name: "contentOrdersRejectreturnlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/rejectReturnLineItem",
    validator: validate_ContentOrdersRejectreturnlineitem_580837,
    base: "/content/v2.1", url: url_ContentOrdersRejectreturnlineitem_580838,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersReturnrefundlineitem_580854 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersReturnrefundlineitem_580856(protocol: Scheme; host: string;
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

proc validate_ContentOrdersReturnrefundlineitem_580855(path: JsonNode;
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
  var valid_580857 = path.getOrDefault("merchantId")
  valid_580857 = validateParameter(valid_580857, JString, required = true,
                                 default = nil)
  if valid_580857 != nil:
    section.add "merchantId", valid_580857
  var valid_580858 = path.getOrDefault("orderId")
  valid_580858 = validateParameter(valid_580858, JString, required = true,
                                 default = nil)
  if valid_580858 != nil:
    section.add "orderId", valid_580858
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
  var valid_580861 = query.getOrDefault("oauth_token")
  valid_580861 = validateParameter(valid_580861, JString, required = false,
                                 default = nil)
  if valid_580861 != nil:
    section.add "oauth_token", valid_580861
  var valid_580862 = query.getOrDefault("alt")
  valid_580862 = validateParameter(valid_580862, JString, required = false,
                                 default = newJString("json"))
  if valid_580862 != nil:
    section.add "alt", valid_580862
  var valid_580863 = query.getOrDefault("userIp")
  valid_580863 = validateParameter(valid_580863, JString, required = false,
                                 default = nil)
  if valid_580863 != nil:
    section.add "userIp", valid_580863
  var valid_580864 = query.getOrDefault("quotaUser")
  valid_580864 = validateParameter(valid_580864, JString, required = false,
                                 default = nil)
  if valid_580864 != nil:
    section.add "quotaUser", valid_580864
  var valid_580865 = query.getOrDefault("fields")
  valid_580865 = validateParameter(valid_580865, JString, required = false,
                                 default = nil)
  if valid_580865 != nil:
    section.add "fields", valid_580865
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580867: Call_ContentOrdersReturnrefundlineitem_580854;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns and refunds a line item. Note that this method can only be called on fully shipped orders.
  ## 
  let valid = call_580867.validator(path, query, header, formData, body)
  let scheme = call_580867.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580867.url(scheme.get, call_580867.host, call_580867.base,
                         call_580867.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580867, url, valid)

proc call*(call_580868: Call_ContentOrdersReturnrefundlineitem_580854;
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
  var path_580869 = newJObject()
  var query_580870 = newJObject()
  var body_580871 = newJObject()
  add(query_580870, "key", newJString(key))
  add(query_580870, "prettyPrint", newJBool(prettyPrint))
  add(query_580870, "oauth_token", newJString(oauthToken))
  add(query_580870, "alt", newJString(alt))
  add(query_580870, "userIp", newJString(userIp))
  add(query_580870, "quotaUser", newJString(quotaUser))
  add(path_580869, "merchantId", newJString(merchantId))
  if body != nil:
    body_580871 = body
  add(query_580870, "fields", newJString(fields))
  add(path_580869, "orderId", newJString(orderId))
  result = call_580868.call(path_580869, query_580870, nil, nil, body_580871)

var contentOrdersReturnrefundlineitem* = Call_ContentOrdersReturnrefundlineitem_580854(
    name: "contentOrdersReturnrefundlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/returnRefundLineItem",
    validator: validate_ContentOrdersReturnrefundlineitem_580855,
    base: "/content/v2.1", url: url_ContentOrdersReturnrefundlineitem_580856,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersSetlineitemmetadata_580872 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersSetlineitemmetadata_580874(protocol: Scheme; host: string;
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

proc validate_ContentOrdersSetlineitemmetadata_580873(path: JsonNode;
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
  var valid_580875 = path.getOrDefault("merchantId")
  valid_580875 = validateParameter(valid_580875, JString, required = true,
                                 default = nil)
  if valid_580875 != nil:
    section.add "merchantId", valid_580875
  var valid_580876 = path.getOrDefault("orderId")
  valid_580876 = validateParameter(valid_580876, JString, required = true,
                                 default = nil)
  if valid_580876 != nil:
    section.add "orderId", valid_580876
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
  var valid_580877 = query.getOrDefault("key")
  valid_580877 = validateParameter(valid_580877, JString, required = false,
                                 default = nil)
  if valid_580877 != nil:
    section.add "key", valid_580877
  var valid_580878 = query.getOrDefault("prettyPrint")
  valid_580878 = validateParameter(valid_580878, JBool, required = false,
                                 default = newJBool(true))
  if valid_580878 != nil:
    section.add "prettyPrint", valid_580878
  var valid_580879 = query.getOrDefault("oauth_token")
  valid_580879 = validateParameter(valid_580879, JString, required = false,
                                 default = nil)
  if valid_580879 != nil:
    section.add "oauth_token", valid_580879
  var valid_580880 = query.getOrDefault("alt")
  valid_580880 = validateParameter(valid_580880, JString, required = false,
                                 default = newJString("json"))
  if valid_580880 != nil:
    section.add "alt", valid_580880
  var valid_580881 = query.getOrDefault("userIp")
  valid_580881 = validateParameter(valid_580881, JString, required = false,
                                 default = nil)
  if valid_580881 != nil:
    section.add "userIp", valid_580881
  var valid_580882 = query.getOrDefault("quotaUser")
  valid_580882 = validateParameter(valid_580882, JString, required = false,
                                 default = nil)
  if valid_580882 != nil:
    section.add "quotaUser", valid_580882
  var valid_580883 = query.getOrDefault("fields")
  valid_580883 = validateParameter(valid_580883, JString, required = false,
                                 default = nil)
  if valid_580883 != nil:
    section.add "fields", valid_580883
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580885: Call_ContentOrdersSetlineitemmetadata_580872;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets (or overrides if it already exists) merchant provided annotations in the form of key-value pairs. A common use case would be to supply us with additional structured information about a line item that cannot be provided via other methods. Submitted key-value pairs can be retrieved as part of the orders resource.
  ## 
  let valid = call_580885.validator(path, query, header, formData, body)
  let scheme = call_580885.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580885.url(scheme.get, call_580885.host, call_580885.base,
                         call_580885.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580885, url, valid)

proc call*(call_580886: Call_ContentOrdersSetlineitemmetadata_580872;
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
  var path_580887 = newJObject()
  var query_580888 = newJObject()
  var body_580889 = newJObject()
  add(query_580888, "key", newJString(key))
  add(query_580888, "prettyPrint", newJBool(prettyPrint))
  add(query_580888, "oauth_token", newJString(oauthToken))
  add(query_580888, "alt", newJString(alt))
  add(query_580888, "userIp", newJString(userIp))
  add(query_580888, "quotaUser", newJString(quotaUser))
  add(path_580887, "merchantId", newJString(merchantId))
  if body != nil:
    body_580889 = body
  add(query_580888, "fields", newJString(fields))
  add(path_580887, "orderId", newJString(orderId))
  result = call_580886.call(path_580887, query_580888, nil, nil, body_580889)

var contentOrdersSetlineitemmetadata* = Call_ContentOrdersSetlineitemmetadata_580872(
    name: "contentOrdersSetlineitemmetadata", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/setLineItemMetadata",
    validator: validate_ContentOrdersSetlineitemmetadata_580873,
    base: "/content/v2.1", url: url_ContentOrdersSetlineitemmetadata_580874,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersShiplineitems_580890 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersShiplineitems_580892(protocol: Scheme; host: string;
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

proc validate_ContentOrdersShiplineitems_580891(path: JsonNode; query: JsonNode;
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
  var valid_580893 = path.getOrDefault("merchantId")
  valid_580893 = validateParameter(valid_580893, JString, required = true,
                                 default = nil)
  if valid_580893 != nil:
    section.add "merchantId", valid_580893
  var valid_580894 = path.getOrDefault("orderId")
  valid_580894 = validateParameter(valid_580894, JString, required = true,
                                 default = nil)
  if valid_580894 != nil:
    section.add "orderId", valid_580894
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
  var valid_580895 = query.getOrDefault("key")
  valid_580895 = validateParameter(valid_580895, JString, required = false,
                                 default = nil)
  if valid_580895 != nil:
    section.add "key", valid_580895
  var valid_580896 = query.getOrDefault("prettyPrint")
  valid_580896 = validateParameter(valid_580896, JBool, required = false,
                                 default = newJBool(true))
  if valid_580896 != nil:
    section.add "prettyPrint", valid_580896
  var valid_580897 = query.getOrDefault("oauth_token")
  valid_580897 = validateParameter(valid_580897, JString, required = false,
                                 default = nil)
  if valid_580897 != nil:
    section.add "oauth_token", valid_580897
  var valid_580898 = query.getOrDefault("alt")
  valid_580898 = validateParameter(valid_580898, JString, required = false,
                                 default = newJString("json"))
  if valid_580898 != nil:
    section.add "alt", valid_580898
  var valid_580899 = query.getOrDefault("userIp")
  valid_580899 = validateParameter(valid_580899, JString, required = false,
                                 default = nil)
  if valid_580899 != nil:
    section.add "userIp", valid_580899
  var valid_580900 = query.getOrDefault("quotaUser")
  valid_580900 = validateParameter(valid_580900, JString, required = false,
                                 default = nil)
  if valid_580900 != nil:
    section.add "quotaUser", valid_580900
  var valid_580901 = query.getOrDefault("fields")
  valid_580901 = validateParameter(valid_580901, JString, required = false,
                                 default = nil)
  if valid_580901 != nil:
    section.add "fields", valid_580901
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580903: Call_ContentOrdersShiplineitems_580890; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks line item(s) as shipped.
  ## 
  let valid = call_580903.validator(path, query, header, formData, body)
  let scheme = call_580903.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580903.url(scheme.get, call_580903.host, call_580903.base,
                         call_580903.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580903, url, valid)

proc call*(call_580904: Call_ContentOrdersShiplineitems_580890; merchantId: string;
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
  var path_580905 = newJObject()
  var query_580906 = newJObject()
  var body_580907 = newJObject()
  add(query_580906, "key", newJString(key))
  add(query_580906, "prettyPrint", newJBool(prettyPrint))
  add(query_580906, "oauth_token", newJString(oauthToken))
  add(query_580906, "alt", newJString(alt))
  add(query_580906, "userIp", newJString(userIp))
  add(query_580906, "quotaUser", newJString(quotaUser))
  add(path_580905, "merchantId", newJString(merchantId))
  if body != nil:
    body_580907 = body
  add(query_580906, "fields", newJString(fields))
  add(path_580905, "orderId", newJString(orderId))
  result = call_580904.call(path_580905, query_580906, nil, nil, body_580907)

var contentOrdersShiplineitems* = Call_ContentOrdersShiplineitems_580890(
    name: "contentOrdersShiplineitems", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/shipLineItems",
    validator: validate_ContentOrdersShiplineitems_580891, base: "/content/v2.1",
    url: url_ContentOrdersShiplineitems_580892, schemes: {Scheme.Https})
type
  Call_ContentOrdersCreatetestreturn_580908 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersCreatetestreturn_580910(protocol: Scheme; host: string;
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

proc validate_ContentOrdersCreatetestreturn_580909(path: JsonNode; query: JsonNode;
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
  var valid_580911 = path.getOrDefault("merchantId")
  valid_580911 = validateParameter(valid_580911, JString, required = true,
                                 default = nil)
  if valid_580911 != nil:
    section.add "merchantId", valid_580911
  var valid_580912 = path.getOrDefault("orderId")
  valid_580912 = validateParameter(valid_580912, JString, required = true,
                                 default = nil)
  if valid_580912 != nil:
    section.add "orderId", valid_580912
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
  var valid_580913 = query.getOrDefault("key")
  valid_580913 = validateParameter(valid_580913, JString, required = false,
                                 default = nil)
  if valid_580913 != nil:
    section.add "key", valid_580913
  var valid_580914 = query.getOrDefault("prettyPrint")
  valid_580914 = validateParameter(valid_580914, JBool, required = false,
                                 default = newJBool(true))
  if valid_580914 != nil:
    section.add "prettyPrint", valid_580914
  var valid_580915 = query.getOrDefault("oauth_token")
  valid_580915 = validateParameter(valid_580915, JString, required = false,
                                 default = nil)
  if valid_580915 != nil:
    section.add "oauth_token", valid_580915
  var valid_580916 = query.getOrDefault("alt")
  valid_580916 = validateParameter(valid_580916, JString, required = false,
                                 default = newJString("json"))
  if valid_580916 != nil:
    section.add "alt", valid_580916
  var valid_580917 = query.getOrDefault("userIp")
  valid_580917 = validateParameter(valid_580917, JString, required = false,
                                 default = nil)
  if valid_580917 != nil:
    section.add "userIp", valid_580917
  var valid_580918 = query.getOrDefault("quotaUser")
  valid_580918 = validateParameter(valid_580918, JString, required = false,
                                 default = nil)
  if valid_580918 != nil:
    section.add "quotaUser", valid_580918
  var valid_580919 = query.getOrDefault("fields")
  valid_580919 = validateParameter(valid_580919, JString, required = false,
                                 default = nil)
  if valid_580919 != nil:
    section.add "fields", valid_580919
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580921: Call_ContentOrdersCreatetestreturn_580908; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Creates a test return.
  ## 
  let valid = call_580921.validator(path, query, header, formData, body)
  let scheme = call_580921.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580921.url(scheme.get, call_580921.host, call_580921.base,
                         call_580921.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580921, url, valid)

proc call*(call_580922: Call_ContentOrdersCreatetestreturn_580908;
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
  var path_580923 = newJObject()
  var query_580924 = newJObject()
  var body_580925 = newJObject()
  add(query_580924, "key", newJString(key))
  add(query_580924, "prettyPrint", newJBool(prettyPrint))
  add(query_580924, "oauth_token", newJString(oauthToken))
  add(query_580924, "alt", newJString(alt))
  add(query_580924, "userIp", newJString(userIp))
  add(query_580924, "quotaUser", newJString(quotaUser))
  add(path_580923, "merchantId", newJString(merchantId))
  if body != nil:
    body_580925 = body
  add(query_580924, "fields", newJString(fields))
  add(path_580923, "orderId", newJString(orderId))
  result = call_580922.call(path_580923, query_580924, nil, nil, body_580925)

var contentOrdersCreatetestreturn* = Call_ContentOrdersCreatetestreturn_580908(
    name: "contentOrdersCreatetestreturn", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/testreturn",
    validator: validate_ContentOrdersCreatetestreturn_580909,
    base: "/content/v2.1", url: url_ContentOrdersCreatetestreturn_580910,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdatelineitemshippingdetails_580926 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersUpdatelineitemshippingdetails_580928(protocol: Scheme;
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

proc validate_ContentOrdersUpdatelineitemshippingdetails_580927(path: JsonNode;
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
  var valid_580929 = path.getOrDefault("merchantId")
  valid_580929 = validateParameter(valid_580929, JString, required = true,
                                 default = nil)
  if valid_580929 != nil:
    section.add "merchantId", valid_580929
  var valid_580930 = path.getOrDefault("orderId")
  valid_580930 = validateParameter(valid_580930, JString, required = true,
                                 default = nil)
  if valid_580930 != nil:
    section.add "orderId", valid_580930
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
  var valid_580931 = query.getOrDefault("key")
  valid_580931 = validateParameter(valid_580931, JString, required = false,
                                 default = nil)
  if valid_580931 != nil:
    section.add "key", valid_580931
  var valid_580932 = query.getOrDefault("prettyPrint")
  valid_580932 = validateParameter(valid_580932, JBool, required = false,
                                 default = newJBool(true))
  if valid_580932 != nil:
    section.add "prettyPrint", valid_580932
  var valid_580933 = query.getOrDefault("oauth_token")
  valid_580933 = validateParameter(valid_580933, JString, required = false,
                                 default = nil)
  if valid_580933 != nil:
    section.add "oauth_token", valid_580933
  var valid_580934 = query.getOrDefault("alt")
  valid_580934 = validateParameter(valid_580934, JString, required = false,
                                 default = newJString("json"))
  if valid_580934 != nil:
    section.add "alt", valid_580934
  var valid_580935 = query.getOrDefault("userIp")
  valid_580935 = validateParameter(valid_580935, JString, required = false,
                                 default = nil)
  if valid_580935 != nil:
    section.add "userIp", valid_580935
  var valid_580936 = query.getOrDefault("quotaUser")
  valid_580936 = validateParameter(valid_580936, JString, required = false,
                                 default = nil)
  if valid_580936 != nil:
    section.add "quotaUser", valid_580936
  var valid_580937 = query.getOrDefault("fields")
  valid_580937 = validateParameter(valid_580937, JString, required = false,
                                 default = nil)
  if valid_580937 != nil:
    section.add "fields", valid_580937
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580939: Call_ContentOrdersUpdatelineitemshippingdetails_580926;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates ship by and delivery by dates for a line item.
  ## 
  let valid = call_580939.validator(path, query, header, formData, body)
  let scheme = call_580939.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580939.url(scheme.get, call_580939.host, call_580939.base,
                         call_580939.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580939, url, valid)

proc call*(call_580940: Call_ContentOrdersUpdatelineitemshippingdetails_580926;
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
  var path_580941 = newJObject()
  var query_580942 = newJObject()
  var body_580943 = newJObject()
  add(query_580942, "key", newJString(key))
  add(query_580942, "prettyPrint", newJBool(prettyPrint))
  add(query_580942, "oauth_token", newJString(oauthToken))
  add(query_580942, "alt", newJString(alt))
  add(query_580942, "userIp", newJString(userIp))
  add(query_580942, "quotaUser", newJString(quotaUser))
  add(path_580941, "merchantId", newJString(merchantId))
  if body != nil:
    body_580943 = body
  add(query_580942, "fields", newJString(fields))
  add(path_580941, "orderId", newJString(orderId))
  result = call_580940.call(path_580941, query_580942, nil, nil, body_580943)

var contentOrdersUpdatelineitemshippingdetails* = Call_ContentOrdersUpdatelineitemshippingdetails_580926(
    name: "contentOrdersUpdatelineitemshippingdetails", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateLineItemShippingDetails",
    validator: validate_ContentOrdersUpdatelineitemshippingdetails_580927,
    base: "/content/v2.1", url: url_ContentOrdersUpdatelineitemshippingdetails_580928,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdatemerchantorderid_580944 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersUpdatemerchantorderid_580946(protocol: Scheme; host: string;
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

proc validate_ContentOrdersUpdatemerchantorderid_580945(path: JsonNode;
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
  var valid_580947 = path.getOrDefault("merchantId")
  valid_580947 = validateParameter(valid_580947, JString, required = true,
                                 default = nil)
  if valid_580947 != nil:
    section.add "merchantId", valid_580947
  var valid_580948 = path.getOrDefault("orderId")
  valid_580948 = validateParameter(valid_580948, JString, required = true,
                                 default = nil)
  if valid_580948 != nil:
    section.add "orderId", valid_580948
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
  var valid_580949 = query.getOrDefault("key")
  valid_580949 = validateParameter(valid_580949, JString, required = false,
                                 default = nil)
  if valid_580949 != nil:
    section.add "key", valid_580949
  var valid_580950 = query.getOrDefault("prettyPrint")
  valid_580950 = validateParameter(valid_580950, JBool, required = false,
                                 default = newJBool(true))
  if valid_580950 != nil:
    section.add "prettyPrint", valid_580950
  var valid_580951 = query.getOrDefault("oauth_token")
  valid_580951 = validateParameter(valid_580951, JString, required = false,
                                 default = nil)
  if valid_580951 != nil:
    section.add "oauth_token", valid_580951
  var valid_580952 = query.getOrDefault("alt")
  valid_580952 = validateParameter(valid_580952, JString, required = false,
                                 default = newJString("json"))
  if valid_580952 != nil:
    section.add "alt", valid_580952
  var valid_580953 = query.getOrDefault("userIp")
  valid_580953 = validateParameter(valid_580953, JString, required = false,
                                 default = nil)
  if valid_580953 != nil:
    section.add "userIp", valid_580953
  var valid_580954 = query.getOrDefault("quotaUser")
  valid_580954 = validateParameter(valid_580954, JString, required = false,
                                 default = nil)
  if valid_580954 != nil:
    section.add "quotaUser", valid_580954
  var valid_580955 = query.getOrDefault("fields")
  valid_580955 = validateParameter(valid_580955, JString, required = false,
                                 default = nil)
  if valid_580955 != nil:
    section.add "fields", valid_580955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580957: Call_ContentOrdersUpdatemerchantorderid_580944;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the merchant order ID for a given order.
  ## 
  let valid = call_580957.validator(path, query, header, formData, body)
  let scheme = call_580957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580957.url(scheme.get, call_580957.host, call_580957.base,
                         call_580957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580957, url, valid)

proc call*(call_580958: Call_ContentOrdersUpdatemerchantorderid_580944;
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
  var path_580959 = newJObject()
  var query_580960 = newJObject()
  var body_580961 = newJObject()
  add(query_580960, "key", newJString(key))
  add(query_580960, "prettyPrint", newJBool(prettyPrint))
  add(query_580960, "oauth_token", newJString(oauthToken))
  add(query_580960, "alt", newJString(alt))
  add(query_580960, "userIp", newJString(userIp))
  add(query_580960, "quotaUser", newJString(quotaUser))
  add(path_580959, "merchantId", newJString(merchantId))
  if body != nil:
    body_580961 = body
  add(query_580960, "fields", newJString(fields))
  add(path_580959, "orderId", newJString(orderId))
  result = call_580958.call(path_580959, query_580960, nil, nil, body_580961)

var contentOrdersUpdatemerchantorderid* = Call_ContentOrdersUpdatemerchantorderid_580944(
    name: "contentOrdersUpdatemerchantorderid", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateMerchantOrderId",
    validator: validate_ContentOrdersUpdatemerchantorderid_580945,
    base: "/content/v2.1", url: url_ContentOrdersUpdatemerchantorderid_580946,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdateshipment_580962 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersUpdateshipment_580964(protocol: Scheme; host: string;
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

proc validate_ContentOrdersUpdateshipment_580963(path: JsonNode; query: JsonNode;
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
  var valid_580965 = path.getOrDefault("merchantId")
  valid_580965 = validateParameter(valid_580965, JString, required = true,
                                 default = nil)
  if valid_580965 != nil:
    section.add "merchantId", valid_580965
  var valid_580966 = path.getOrDefault("orderId")
  valid_580966 = validateParameter(valid_580966, JString, required = true,
                                 default = nil)
  if valid_580966 != nil:
    section.add "orderId", valid_580966
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
  var valid_580967 = query.getOrDefault("key")
  valid_580967 = validateParameter(valid_580967, JString, required = false,
                                 default = nil)
  if valid_580967 != nil:
    section.add "key", valid_580967
  var valid_580968 = query.getOrDefault("prettyPrint")
  valid_580968 = validateParameter(valid_580968, JBool, required = false,
                                 default = newJBool(true))
  if valid_580968 != nil:
    section.add "prettyPrint", valid_580968
  var valid_580969 = query.getOrDefault("oauth_token")
  valid_580969 = validateParameter(valid_580969, JString, required = false,
                                 default = nil)
  if valid_580969 != nil:
    section.add "oauth_token", valid_580969
  var valid_580970 = query.getOrDefault("alt")
  valid_580970 = validateParameter(valid_580970, JString, required = false,
                                 default = newJString("json"))
  if valid_580970 != nil:
    section.add "alt", valid_580970
  var valid_580971 = query.getOrDefault("userIp")
  valid_580971 = validateParameter(valid_580971, JString, required = false,
                                 default = nil)
  if valid_580971 != nil:
    section.add "userIp", valid_580971
  var valid_580972 = query.getOrDefault("quotaUser")
  valid_580972 = validateParameter(valid_580972, JString, required = false,
                                 default = nil)
  if valid_580972 != nil:
    section.add "quotaUser", valid_580972
  var valid_580973 = query.getOrDefault("fields")
  valid_580973 = validateParameter(valid_580973, JString, required = false,
                                 default = nil)
  if valid_580973 != nil:
    section.add "fields", valid_580973
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580975: Call_ContentOrdersUpdateshipment_580962; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a shipment's status, carrier, and/or tracking ID.
  ## 
  let valid = call_580975.validator(path, query, header, formData, body)
  let scheme = call_580975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580975.url(scheme.get, call_580975.host, call_580975.base,
                         call_580975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580975, url, valid)

proc call*(call_580976: Call_ContentOrdersUpdateshipment_580962;
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
  var path_580977 = newJObject()
  var query_580978 = newJObject()
  var body_580979 = newJObject()
  add(query_580978, "key", newJString(key))
  add(query_580978, "prettyPrint", newJBool(prettyPrint))
  add(query_580978, "oauth_token", newJString(oauthToken))
  add(query_580978, "alt", newJString(alt))
  add(query_580978, "userIp", newJString(userIp))
  add(query_580978, "quotaUser", newJString(quotaUser))
  add(path_580977, "merchantId", newJString(merchantId))
  if body != nil:
    body_580979 = body
  add(query_580978, "fields", newJString(fields))
  add(path_580977, "orderId", newJString(orderId))
  result = call_580976.call(path_580977, query_580978, nil, nil, body_580979)

var contentOrdersUpdateshipment* = Call_ContentOrdersUpdateshipment_580962(
    name: "contentOrdersUpdateshipment", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateShipment",
    validator: validate_ContentOrdersUpdateshipment_580963, base: "/content/v2.1",
    url: url_ContentOrdersUpdateshipment_580964, schemes: {Scheme.Https})
type
  Call_ContentOrdersGetbymerchantorderid_580980 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersGetbymerchantorderid_580982(protocol: Scheme; host: string;
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

proc validate_ContentOrdersGetbymerchantorderid_580981(path: JsonNode;
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
  var valid_580983 = path.getOrDefault("merchantOrderId")
  valid_580983 = validateParameter(valid_580983, JString, required = true,
                                 default = nil)
  if valid_580983 != nil:
    section.add "merchantOrderId", valid_580983
  var valid_580984 = path.getOrDefault("merchantId")
  valid_580984 = validateParameter(valid_580984, JString, required = true,
                                 default = nil)
  if valid_580984 != nil:
    section.add "merchantId", valid_580984
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
  var valid_580985 = query.getOrDefault("key")
  valid_580985 = validateParameter(valid_580985, JString, required = false,
                                 default = nil)
  if valid_580985 != nil:
    section.add "key", valid_580985
  var valid_580986 = query.getOrDefault("prettyPrint")
  valid_580986 = validateParameter(valid_580986, JBool, required = false,
                                 default = newJBool(true))
  if valid_580986 != nil:
    section.add "prettyPrint", valid_580986
  var valid_580987 = query.getOrDefault("oauth_token")
  valid_580987 = validateParameter(valid_580987, JString, required = false,
                                 default = nil)
  if valid_580987 != nil:
    section.add "oauth_token", valid_580987
  var valid_580988 = query.getOrDefault("alt")
  valid_580988 = validateParameter(valid_580988, JString, required = false,
                                 default = newJString("json"))
  if valid_580988 != nil:
    section.add "alt", valid_580988
  var valid_580989 = query.getOrDefault("userIp")
  valid_580989 = validateParameter(valid_580989, JString, required = false,
                                 default = nil)
  if valid_580989 != nil:
    section.add "userIp", valid_580989
  var valid_580990 = query.getOrDefault("quotaUser")
  valid_580990 = validateParameter(valid_580990, JString, required = false,
                                 default = nil)
  if valid_580990 != nil:
    section.add "quotaUser", valid_580990
  var valid_580991 = query.getOrDefault("fields")
  valid_580991 = validateParameter(valid_580991, JString, required = false,
                                 default = nil)
  if valid_580991 != nil:
    section.add "fields", valid_580991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580992: Call_ContentOrdersGetbymerchantorderid_580980;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves an order using merchant order ID.
  ## 
  let valid = call_580992.validator(path, query, header, formData, body)
  let scheme = call_580992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580992.url(scheme.get, call_580992.host, call_580992.base,
                         call_580992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580992, url, valid)

proc call*(call_580993: Call_ContentOrdersGetbymerchantorderid_580980;
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
  var path_580994 = newJObject()
  var query_580995 = newJObject()
  add(query_580995, "key", newJString(key))
  add(query_580995, "prettyPrint", newJBool(prettyPrint))
  add(query_580995, "oauth_token", newJString(oauthToken))
  add(path_580994, "merchantOrderId", newJString(merchantOrderId))
  add(query_580995, "alt", newJString(alt))
  add(query_580995, "userIp", newJString(userIp))
  add(query_580995, "quotaUser", newJString(quotaUser))
  add(path_580994, "merchantId", newJString(merchantId))
  add(query_580995, "fields", newJString(fields))
  result = call_580993.call(path_580994, query_580995, nil, nil, nil)

var contentOrdersGetbymerchantorderid* = Call_ContentOrdersGetbymerchantorderid_580980(
    name: "contentOrdersGetbymerchantorderid", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/ordersbymerchantid/{merchantOrderId}",
    validator: validate_ContentOrdersGetbymerchantorderid_580981,
    base: "/content/v2.1", url: url_ContentOrdersGetbymerchantorderid_580982,
    schemes: {Scheme.Https})
type
  Call_ContentPosInventory_580996 = ref object of OpenApiRestCall_579373
proc url_ContentPosInventory_580998(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosInventory_580997(path: JsonNode; query: JsonNode;
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
  var valid_580999 = path.getOrDefault("targetMerchantId")
  valid_580999 = validateParameter(valid_580999, JString, required = true,
                                 default = nil)
  if valid_580999 != nil:
    section.add "targetMerchantId", valid_580999
  var valid_581000 = path.getOrDefault("merchantId")
  valid_581000 = validateParameter(valid_581000, JString, required = true,
                                 default = nil)
  if valid_581000 != nil:
    section.add "merchantId", valid_581000
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
  var valid_581001 = query.getOrDefault("key")
  valid_581001 = validateParameter(valid_581001, JString, required = false,
                                 default = nil)
  if valid_581001 != nil:
    section.add "key", valid_581001
  var valid_581002 = query.getOrDefault("prettyPrint")
  valid_581002 = validateParameter(valid_581002, JBool, required = false,
                                 default = newJBool(true))
  if valid_581002 != nil:
    section.add "prettyPrint", valid_581002
  var valid_581003 = query.getOrDefault("oauth_token")
  valid_581003 = validateParameter(valid_581003, JString, required = false,
                                 default = nil)
  if valid_581003 != nil:
    section.add "oauth_token", valid_581003
  var valid_581004 = query.getOrDefault("alt")
  valid_581004 = validateParameter(valid_581004, JString, required = false,
                                 default = newJString("json"))
  if valid_581004 != nil:
    section.add "alt", valid_581004
  var valid_581005 = query.getOrDefault("userIp")
  valid_581005 = validateParameter(valid_581005, JString, required = false,
                                 default = nil)
  if valid_581005 != nil:
    section.add "userIp", valid_581005
  var valid_581006 = query.getOrDefault("quotaUser")
  valid_581006 = validateParameter(valid_581006, JString, required = false,
                                 default = nil)
  if valid_581006 != nil:
    section.add "quotaUser", valid_581006
  var valid_581007 = query.getOrDefault("fields")
  valid_581007 = validateParameter(valid_581007, JString, required = false,
                                 default = nil)
  if valid_581007 != nil:
    section.add "fields", valid_581007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_581009: Call_ContentPosInventory_580996; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit inventory for the given merchant.
  ## 
  let valid = call_581009.validator(path, query, header, formData, body)
  let scheme = call_581009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581009.url(scheme.get, call_581009.host, call_581009.base,
                         call_581009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581009, url, valid)

proc call*(call_581010: Call_ContentPosInventory_580996; targetMerchantId: string;
          merchantId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
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
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581011 = newJObject()
  var query_581012 = newJObject()
  var body_581013 = newJObject()
  add(query_581012, "key", newJString(key))
  add(query_581012, "prettyPrint", newJBool(prettyPrint))
  add(query_581012, "oauth_token", newJString(oauthToken))
  add(path_581011, "targetMerchantId", newJString(targetMerchantId))
  add(query_581012, "alt", newJString(alt))
  add(query_581012, "userIp", newJString(userIp))
  add(query_581012, "quotaUser", newJString(quotaUser))
  add(path_581011, "merchantId", newJString(merchantId))
  if body != nil:
    body_581013 = body
  add(query_581012, "fields", newJString(fields))
  result = call_581010.call(path_581011, query_581012, nil, nil, body_581013)

var contentPosInventory* = Call_ContentPosInventory_580996(
    name: "contentPosInventory", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/inventory",
    validator: validate_ContentPosInventory_580997, base: "/content/v2.1",
    url: url_ContentPosInventory_580998, schemes: {Scheme.Https})
type
  Call_ContentPosSale_581014 = ref object of OpenApiRestCall_579373
proc url_ContentPosSale_581016(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosSale_581015(path: JsonNode; query: JsonNode;
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
  var valid_581017 = path.getOrDefault("targetMerchantId")
  valid_581017 = validateParameter(valid_581017, JString, required = true,
                                 default = nil)
  if valid_581017 != nil:
    section.add "targetMerchantId", valid_581017
  var valid_581018 = path.getOrDefault("merchantId")
  valid_581018 = validateParameter(valid_581018, JString, required = true,
                                 default = nil)
  if valid_581018 != nil:
    section.add "merchantId", valid_581018
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
  var valid_581019 = query.getOrDefault("key")
  valid_581019 = validateParameter(valid_581019, JString, required = false,
                                 default = nil)
  if valid_581019 != nil:
    section.add "key", valid_581019
  var valid_581020 = query.getOrDefault("prettyPrint")
  valid_581020 = validateParameter(valid_581020, JBool, required = false,
                                 default = newJBool(true))
  if valid_581020 != nil:
    section.add "prettyPrint", valid_581020
  var valid_581021 = query.getOrDefault("oauth_token")
  valid_581021 = validateParameter(valid_581021, JString, required = false,
                                 default = nil)
  if valid_581021 != nil:
    section.add "oauth_token", valid_581021
  var valid_581022 = query.getOrDefault("alt")
  valid_581022 = validateParameter(valid_581022, JString, required = false,
                                 default = newJString("json"))
  if valid_581022 != nil:
    section.add "alt", valid_581022
  var valid_581023 = query.getOrDefault("userIp")
  valid_581023 = validateParameter(valid_581023, JString, required = false,
                                 default = nil)
  if valid_581023 != nil:
    section.add "userIp", valid_581023
  var valid_581024 = query.getOrDefault("quotaUser")
  valid_581024 = validateParameter(valid_581024, JString, required = false,
                                 default = nil)
  if valid_581024 != nil:
    section.add "quotaUser", valid_581024
  var valid_581025 = query.getOrDefault("fields")
  valid_581025 = validateParameter(valid_581025, JString, required = false,
                                 default = nil)
  if valid_581025 != nil:
    section.add "fields", valid_581025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_581027: Call_ContentPosSale_581014; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit a sale event for the given merchant.
  ## 
  let valid = call_581027.validator(path, query, header, formData, body)
  let scheme = call_581027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581027.url(scheme.get, call_581027.host, call_581027.base,
                         call_581027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581027, url, valid)

proc call*(call_581028: Call_ContentPosSale_581014; targetMerchantId: string;
          merchantId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
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
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581029 = newJObject()
  var query_581030 = newJObject()
  var body_581031 = newJObject()
  add(query_581030, "key", newJString(key))
  add(query_581030, "prettyPrint", newJBool(prettyPrint))
  add(query_581030, "oauth_token", newJString(oauthToken))
  add(path_581029, "targetMerchantId", newJString(targetMerchantId))
  add(query_581030, "alt", newJString(alt))
  add(query_581030, "userIp", newJString(userIp))
  add(query_581030, "quotaUser", newJString(quotaUser))
  add(path_581029, "merchantId", newJString(merchantId))
  if body != nil:
    body_581031 = body
  add(query_581030, "fields", newJString(fields))
  result = call_581028.call(path_581029, query_581030, nil, nil, body_581031)

var contentPosSale* = Call_ContentPosSale_581014(name: "contentPosSale",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/sale",
    validator: validate_ContentPosSale_581015, base: "/content/v2.1",
    url: url_ContentPosSale_581016, schemes: {Scheme.Https})
type
  Call_ContentPosInsert_581048 = ref object of OpenApiRestCall_579373
proc url_ContentPosInsert_581050(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosInsert_581049(path: JsonNode; query: JsonNode;
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
  var valid_581051 = path.getOrDefault("targetMerchantId")
  valid_581051 = validateParameter(valid_581051, JString, required = true,
                                 default = nil)
  if valid_581051 != nil:
    section.add "targetMerchantId", valid_581051
  var valid_581052 = path.getOrDefault("merchantId")
  valid_581052 = validateParameter(valid_581052, JString, required = true,
                                 default = nil)
  if valid_581052 != nil:
    section.add "merchantId", valid_581052
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
  var valid_581053 = query.getOrDefault("key")
  valid_581053 = validateParameter(valid_581053, JString, required = false,
                                 default = nil)
  if valid_581053 != nil:
    section.add "key", valid_581053
  var valid_581054 = query.getOrDefault("prettyPrint")
  valid_581054 = validateParameter(valid_581054, JBool, required = false,
                                 default = newJBool(true))
  if valid_581054 != nil:
    section.add "prettyPrint", valid_581054
  var valid_581055 = query.getOrDefault("oauth_token")
  valid_581055 = validateParameter(valid_581055, JString, required = false,
                                 default = nil)
  if valid_581055 != nil:
    section.add "oauth_token", valid_581055
  var valid_581056 = query.getOrDefault("alt")
  valid_581056 = validateParameter(valid_581056, JString, required = false,
                                 default = newJString("json"))
  if valid_581056 != nil:
    section.add "alt", valid_581056
  var valid_581057 = query.getOrDefault("userIp")
  valid_581057 = validateParameter(valid_581057, JString, required = false,
                                 default = nil)
  if valid_581057 != nil:
    section.add "userIp", valid_581057
  var valid_581058 = query.getOrDefault("quotaUser")
  valid_581058 = validateParameter(valid_581058, JString, required = false,
                                 default = nil)
  if valid_581058 != nil:
    section.add "quotaUser", valid_581058
  var valid_581059 = query.getOrDefault("fields")
  valid_581059 = validateParameter(valid_581059, JString, required = false,
                                 default = nil)
  if valid_581059 != nil:
    section.add "fields", valid_581059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_581061: Call_ContentPosInsert_581048; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a store for the given merchant.
  ## 
  let valid = call_581061.validator(path, query, header, formData, body)
  let scheme = call_581061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581061.url(scheme.get, call_581061.host, call_581061.base,
                         call_581061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581061, url, valid)

proc call*(call_581062: Call_ContentPosInsert_581048; targetMerchantId: string;
          merchantId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
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
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581063 = newJObject()
  var query_581064 = newJObject()
  var body_581065 = newJObject()
  add(query_581064, "key", newJString(key))
  add(query_581064, "prettyPrint", newJBool(prettyPrint))
  add(query_581064, "oauth_token", newJString(oauthToken))
  add(path_581063, "targetMerchantId", newJString(targetMerchantId))
  add(query_581064, "alt", newJString(alt))
  add(query_581064, "userIp", newJString(userIp))
  add(query_581064, "quotaUser", newJString(quotaUser))
  add(path_581063, "merchantId", newJString(merchantId))
  if body != nil:
    body_581065 = body
  add(query_581064, "fields", newJString(fields))
  result = call_581062.call(path_581063, query_581064, nil, nil, body_581065)

var contentPosInsert* = Call_ContentPosInsert_581048(name: "contentPosInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store",
    validator: validate_ContentPosInsert_581049, base: "/content/v2.1",
    url: url_ContentPosInsert_581050, schemes: {Scheme.Https})
type
  Call_ContentPosList_581032 = ref object of OpenApiRestCall_579373
proc url_ContentPosList_581034(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosList_581033(path: JsonNode; query: JsonNode;
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
  var valid_581035 = path.getOrDefault("targetMerchantId")
  valid_581035 = validateParameter(valid_581035, JString, required = true,
                                 default = nil)
  if valid_581035 != nil:
    section.add "targetMerchantId", valid_581035
  var valid_581036 = path.getOrDefault("merchantId")
  valid_581036 = validateParameter(valid_581036, JString, required = true,
                                 default = nil)
  if valid_581036 != nil:
    section.add "merchantId", valid_581036
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
  var valid_581037 = query.getOrDefault("key")
  valid_581037 = validateParameter(valid_581037, JString, required = false,
                                 default = nil)
  if valid_581037 != nil:
    section.add "key", valid_581037
  var valid_581038 = query.getOrDefault("prettyPrint")
  valid_581038 = validateParameter(valid_581038, JBool, required = false,
                                 default = newJBool(true))
  if valid_581038 != nil:
    section.add "prettyPrint", valid_581038
  var valid_581039 = query.getOrDefault("oauth_token")
  valid_581039 = validateParameter(valid_581039, JString, required = false,
                                 default = nil)
  if valid_581039 != nil:
    section.add "oauth_token", valid_581039
  var valid_581040 = query.getOrDefault("alt")
  valid_581040 = validateParameter(valid_581040, JString, required = false,
                                 default = newJString("json"))
  if valid_581040 != nil:
    section.add "alt", valid_581040
  var valid_581041 = query.getOrDefault("userIp")
  valid_581041 = validateParameter(valid_581041, JString, required = false,
                                 default = nil)
  if valid_581041 != nil:
    section.add "userIp", valid_581041
  var valid_581042 = query.getOrDefault("quotaUser")
  valid_581042 = validateParameter(valid_581042, JString, required = false,
                                 default = nil)
  if valid_581042 != nil:
    section.add "quotaUser", valid_581042
  var valid_581043 = query.getOrDefault("fields")
  valid_581043 = validateParameter(valid_581043, JString, required = false,
                                 default = nil)
  if valid_581043 != nil:
    section.add "fields", valid_581043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581044: Call_ContentPosList_581032; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the stores of the target merchant.
  ## 
  let valid = call_581044.validator(path, query, header, formData, body)
  let scheme = call_581044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581044.url(scheme.get, call_581044.host, call_581044.base,
                         call_581044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581044, url, valid)

proc call*(call_581045: Call_ContentPosList_581032; targetMerchantId: string;
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
  var path_581046 = newJObject()
  var query_581047 = newJObject()
  add(query_581047, "key", newJString(key))
  add(query_581047, "prettyPrint", newJBool(prettyPrint))
  add(query_581047, "oauth_token", newJString(oauthToken))
  add(path_581046, "targetMerchantId", newJString(targetMerchantId))
  add(query_581047, "alt", newJString(alt))
  add(query_581047, "userIp", newJString(userIp))
  add(query_581047, "quotaUser", newJString(quotaUser))
  add(path_581046, "merchantId", newJString(merchantId))
  add(query_581047, "fields", newJString(fields))
  result = call_581045.call(path_581046, query_581047, nil, nil, nil)

var contentPosList* = Call_ContentPosList_581032(name: "contentPosList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store",
    validator: validate_ContentPosList_581033, base: "/content/v2.1",
    url: url_ContentPosList_581034, schemes: {Scheme.Https})
type
  Call_ContentPosGet_581066 = ref object of OpenApiRestCall_579373
proc url_ContentPosGet_581068(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosGet_581067(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_581069 = path.getOrDefault("targetMerchantId")
  valid_581069 = validateParameter(valid_581069, JString, required = true,
                                 default = nil)
  if valid_581069 != nil:
    section.add "targetMerchantId", valid_581069
  var valid_581070 = path.getOrDefault("storeCode")
  valid_581070 = validateParameter(valid_581070, JString, required = true,
                                 default = nil)
  if valid_581070 != nil:
    section.add "storeCode", valid_581070
  var valid_581071 = path.getOrDefault("merchantId")
  valid_581071 = validateParameter(valid_581071, JString, required = true,
                                 default = nil)
  if valid_581071 != nil:
    section.add "merchantId", valid_581071
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
  var valid_581072 = query.getOrDefault("key")
  valid_581072 = validateParameter(valid_581072, JString, required = false,
                                 default = nil)
  if valid_581072 != nil:
    section.add "key", valid_581072
  var valid_581073 = query.getOrDefault("prettyPrint")
  valid_581073 = validateParameter(valid_581073, JBool, required = false,
                                 default = newJBool(true))
  if valid_581073 != nil:
    section.add "prettyPrint", valid_581073
  var valid_581074 = query.getOrDefault("oauth_token")
  valid_581074 = validateParameter(valid_581074, JString, required = false,
                                 default = nil)
  if valid_581074 != nil:
    section.add "oauth_token", valid_581074
  var valid_581075 = query.getOrDefault("alt")
  valid_581075 = validateParameter(valid_581075, JString, required = false,
                                 default = newJString("json"))
  if valid_581075 != nil:
    section.add "alt", valid_581075
  var valid_581076 = query.getOrDefault("userIp")
  valid_581076 = validateParameter(valid_581076, JString, required = false,
                                 default = nil)
  if valid_581076 != nil:
    section.add "userIp", valid_581076
  var valid_581077 = query.getOrDefault("quotaUser")
  valid_581077 = validateParameter(valid_581077, JString, required = false,
                                 default = nil)
  if valid_581077 != nil:
    section.add "quotaUser", valid_581077
  var valid_581078 = query.getOrDefault("fields")
  valid_581078 = validateParameter(valid_581078, JString, required = false,
                                 default = nil)
  if valid_581078 != nil:
    section.add "fields", valid_581078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581079: Call_ContentPosGet_581066; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about the given store.
  ## 
  let valid = call_581079.validator(path, query, header, formData, body)
  let scheme = call_581079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581079.url(scheme.get, call_581079.host, call_581079.base,
                         call_581079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581079, url, valid)

proc call*(call_581080: Call_ContentPosGet_581066; targetMerchantId: string;
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
  var path_581081 = newJObject()
  var query_581082 = newJObject()
  add(query_581082, "key", newJString(key))
  add(query_581082, "prettyPrint", newJBool(prettyPrint))
  add(query_581082, "oauth_token", newJString(oauthToken))
  add(path_581081, "targetMerchantId", newJString(targetMerchantId))
  add(path_581081, "storeCode", newJString(storeCode))
  add(query_581082, "alt", newJString(alt))
  add(query_581082, "userIp", newJString(userIp))
  add(query_581082, "quotaUser", newJString(quotaUser))
  add(path_581081, "merchantId", newJString(merchantId))
  add(query_581082, "fields", newJString(fields))
  result = call_581080.call(path_581081, query_581082, nil, nil, nil)

var contentPosGet* = Call_ContentPosGet_581066(name: "contentPosGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store/{storeCode}",
    validator: validate_ContentPosGet_581067, base: "/content/v2.1",
    url: url_ContentPosGet_581068, schemes: {Scheme.Https})
type
  Call_ContentPosDelete_581083 = ref object of OpenApiRestCall_579373
proc url_ContentPosDelete_581085(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosDelete_581084(path: JsonNode; query: JsonNode;
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
  var valid_581086 = path.getOrDefault("targetMerchantId")
  valid_581086 = validateParameter(valid_581086, JString, required = true,
                                 default = nil)
  if valid_581086 != nil:
    section.add "targetMerchantId", valid_581086
  var valid_581087 = path.getOrDefault("storeCode")
  valid_581087 = validateParameter(valid_581087, JString, required = true,
                                 default = nil)
  if valid_581087 != nil:
    section.add "storeCode", valid_581087
  var valid_581088 = path.getOrDefault("merchantId")
  valid_581088 = validateParameter(valid_581088, JString, required = true,
                                 default = nil)
  if valid_581088 != nil:
    section.add "merchantId", valid_581088
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
  var valid_581089 = query.getOrDefault("key")
  valid_581089 = validateParameter(valid_581089, JString, required = false,
                                 default = nil)
  if valid_581089 != nil:
    section.add "key", valid_581089
  var valid_581090 = query.getOrDefault("prettyPrint")
  valid_581090 = validateParameter(valid_581090, JBool, required = false,
                                 default = newJBool(true))
  if valid_581090 != nil:
    section.add "prettyPrint", valid_581090
  var valid_581091 = query.getOrDefault("oauth_token")
  valid_581091 = validateParameter(valid_581091, JString, required = false,
                                 default = nil)
  if valid_581091 != nil:
    section.add "oauth_token", valid_581091
  var valid_581092 = query.getOrDefault("alt")
  valid_581092 = validateParameter(valid_581092, JString, required = false,
                                 default = newJString("json"))
  if valid_581092 != nil:
    section.add "alt", valid_581092
  var valid_581093 = query.getOrDefault("userIp")
  valid_581093 = validateParameter(valid_581093, JString, required = false,
                                 default = nil)
  if valid_581093 != nil:
    section.add "userIp", valid_581093
  var valid_581094 = query.getOrDefault("quotaUser")
  valid_581094 = validateParameter(valid_581094, JString, required = false,
                                 default = nil)
  if valid_581094 != nil:
    section.add "quotaUser", valid_581094
  var valid_581095 = query.getOrDefault("fields")
  valid_581095 = validateParameter(valid_581095, JString, required = false,
                                 default = nil)
  if valid_581095 != nil:
    section.add "fields", valid_581095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581096: Call_ContentPosDelete_581083; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a store for the given merchant.
  ## 
  let valid = call_581096.validator(path, query, header, formData, body)
  let scheme = call_581096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581096.url(scheme.get, call_581096.host, call_581096.base,
                         call_581096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581096, url, valid)

proc call*(call_581097: Call_ContentPosDelete_581083; targetMerchantId: string;
          storeCode: string; merchantId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581098 = newJObject()
  var query_581099 = newJObject()
  add(query_581099, "key", newJString(key))
  add(query_581099, "prettyPrint", newJBool(prettyPrint))
  add(query_581099, "oauth_token", newJString(oauthToken))
  add(path_581098, "targetMerchantId", newJString(targetMerchantId))
  add(path_581098, "storeCode", newJString(storeCode))
  add(query_581099, "alt", newJString(alt))
  add(query_581099, "userIp", newJString(userIp))
  add(query_581099, "quotaUser", newJString(quotaUser))
  add(path_581098, "merchantId", newJString(merchantId))
  add(query_581099, "fields", newJString(fields))
  result = call_581097.call(path_581098, query_581099, nil, nil, nil)

var contentPosDelete* = Call_ContentPosDelete_581083(name: "contentPosDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store/{storeCode}",
    validator: validate_ContentPosDelete_581084, base: "/content/v2.1",
    url: url_ContentPosDelete_581085, schemes: {Scheme.Https})
type
  Call_ContentProductsInsert_581117 = ref object of OpenApiRestCall_579373
proc url_ContentProductsInsert_581119(protocol: Scheme; host: string; base: string;
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

proc validate_ContentProductsInsert_581118(path: JsonNode; query: JsonNode;
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
  var valid_581120 = path.getOrDefault("merchantId")
  valid_581120 = validateParameter(valid_581120, JString, required = true,
                                 default = nil)
  if valid_581120 != nil:
    section.add "merchantId", valid_581120
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
  ##   feedId: JString
  ##         : The Content API Supplemental Feed ID.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581121 = query.getOrDefault("key")
  valid_581121 = validateParameter(valid_581121, JString, required = false,
                                 default = nil)
  if valid_581121 != nil:
    section.add "key", valid_581121
  var valid_581122 = query.getOrDefault("prettyPrint")
  valid_581122 = validateParameter(valid_581122, JBool, required = false,
                                 default = newJBool(true))
  if valid_581122 != nil:
    section.add "prettyPrint", valid_581122
  var valid_581123 = query.getOrDefault("oauth_token")
  valid_581123 = validateParameter(valid_581123, JString, required = false,
                                 default = nil)
  if valid_581123 != nil:
    section.add "oauth_token", valid_581123
  var valid_581124 = query.getOrDefault("alt")
  valid_581124 = validateParameter(valid_581124, JString, required = false,
                                 default = newJString("json"))
  if valid_581124 != nil:
    section.add "alt", valid_581124
  var valid_581125 = query.getOrDefault("userIp")
  valid_581125 = validateParameter(valid_581125, JString, required = false,
                                 default = nil)
  if valid_581125 != nil:
    section.add "userIp", valid_581125
  var valid_581126 = query.getOrDefault("quotaUser")
  valid_581126 = validateParameter(valid_581126, JString, required = false,
                                 default = nil)
  if valid_581126 != nil:
    section.add "quotaUser", valid_581126
  var valid_581127 = query.getOrDefault("feedId")
  valid_581127 = validateParameter(valid_581127, JString, required = false,
                                 default = nil)
  if valid_581127 != nil:
    section.add "feedId", valid_581127
  var valid_581128 = query.getOrDefault("fields")
  valid_581128 = validateParameter(valid_581128, JString, required = false,
                                 default = nil)
  if valid_581128 != nil:
    section.add "fields", valid_581128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_581130: Call_ContentProductsInsert_581117; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a product to your Merchant Center account. If an item with the same channel, contentLanguage, offerId, and targetCountry already exists, this method updates that entry.
  ## 
  let valid = call_581130.validator(path, query, header, formData, body)
  let scheme = call_581130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581130.url(scheme.get, call_581130.host, call_581130.base,
                         call_581130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581130, url, valid)

proc call*(call_581131: Call_ContentProductsInsert_581117; merchantId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          feedId: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
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
  ##   feedId: string
  ##         : The Content API Supplemental Feed ID.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581132 = newJObject()
  var query_581133 = newJObject()
  var body_581134 = newJObject()
  add(query_581133, "key", newJString(key))
  add(query_581133, "prettyPrint", newJBool(prettyPrint))
  add(query_581133, "oauth_token", newJString(oauthToken))
  add(query_581133, "alt", newJString(alt))
  add(query_581133, "userIp", newJString(userIp))
  add(query_581133, "quotaUser", newJString(quotaUser))
  add(path_581132, "merchantId", newJString(merchantId))
  add(query_581133, "feedId", newJString(feedId))
  if body != nil:
    body_581134 = body
  add(query_581133, "fields", newJString(fields))
  result = call_581131.call(path_581132, query_581133, nil, nil, body_581134)

var contentProductsInsert* = Call_ContentProductsInsert_581117(
    name: "contentProductsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/products",
    validator: validate_ContentProductsInsert_581118, base: "/content/v2.1",
    url: url_ContentProductsInsert_581119, schemes: {Scheme.Https})
type
  Call_ContentProductsList_581100 = ref object of OpenApiRestCall_579373
proc url_ContentProductsList_581102(protocol: Scheme; host: string; base: string;
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

proc validate_ContentProductsList_581101(path: JsonNode; query: JsonNode;
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
  var valid_581103 = path.getOrDefault("merchantId")
  valid_581103 = validateParameter(valid_581103, JString, required = true,
                                 default = nil)
  if valid_581103 != nil:
    section.add "merchantId", valid_581103
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
  var valid_581106 = query.getOrDefault("oauth_token")
  valid_581106 = validateParameter(valid_581106, JString, required = false,
                                 default = nil)
  if valid_581106 != nil:
    section.add "oauth_token", valid_581106
  var valid_581107 = query.getOrDefault("alt")
  valid_581107 = validateParameter(valid_581107, JString, required = false,
                                 default = newJString("json"))
  if valid_581107 != nil:
    section.add "alt", valid_581107
  var valid_581108 = query.getOrDefault("userIp")
  valid_581108 = validateParameter(valid_581108, JString, required = false,
                                 default = nil)
  if valid_581108 != nil:
    section.add "userIp", valid_581108
  var valid_581109 = query.getOrDefault("quotaUser")
  valid_581109 = validateParameter(valid_581109, JString, required = false,
                                 default = nil)
  if valid_581109 != nil:
    section.add "quotaUser", valid_581109
  var valid_581110 = query.getOrDefault("pageToken")
  valid_581110 = validateParameter(valid_581110, JString, required = false,
                                 default = nil)
  if valid_581110 != nil:
    section.add "pageToken", valid_581110
  var valid_581111 = query.getOrDefault("fields")
  valid_581111 = validateParameter(valid_581111, JString, required = false,
                                 default = nil)
  if valid_581111 != nil:
    section.add "fields", valid_581111
  var valid_581112 = query.getOrDefault("maxResults")
  valid_581112 = validateParameter(valid_581112, JInt, required = false, default = nil)
  if valid_581112 != nil:
    section.add "maxResults", valid_581112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581113: Call_ContentProductsList_581100; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the products in your Merchant Center account.
  ## 
  let valid = call_581113.validator(path, query, header, formData, body)
  let scheme = call_581113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581113.url(scheme.get, call_581113.host, call_581113.base,
                         call_581113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581113, url, valid)

proc call*(call_581114: Call_ContentProductsList_581100; merchantId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 0): Recallable =
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
  ##   maxResults: int
  ##             : The maximum number of products to return in the response, used for paging.
  var path_581115 = newJObject()
  var query_581116 = newJObject()
  add(query_581116, "key", newJString(key))
  add(query_581116, "prettyPrint", newJBool(prettyPrint))
  add(query_581116, "oauth_token", newJString(oauthToken))
  add(query_581116, "alt", newJString(alt))
  add(query_581116, "userIp", newJString(userIp))
  add(query_581116, "quotaUser", newJString(quotaUser))
  add(path_581115, "merchantId", newJString(merchantId))
  add(query_581116, "pageToken", newJString(pageToken))
  add(query_581116, "fields", newJString(fields))
  add(query_581116, "maxResults", newJInt(maxResults))
  result = call_581114.call(path_581115, query_581116, nil, nil, nil)

var contentProductsList* = Call_ContentProductsList_581100(
    name: "contentProductsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/products",
    validator: validate_ContentProductsList_581101, base: "/content/v2.1",
    url: url_ContentProductsList_581102, schemes: {Scheme.Https})
type
  Call_ContentProductsGet_581135 = ref object of OpenApiRestCall_579373
proc url_ContentProductsGet_581137(protocol: Scheme; host: string; base: string;
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

proc validate_ContentProductsGet_581136(path: JsonNode; query: JsonNode;
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
  var valid_581138 = path.getOrDefault("merchantId")
  valid_581138 = validateParameter(valid_581138, JString, required = true,
                                 default = nil)
  if valid_581138 != nil:
    section.add "merchantId", valid_581138
  var valid_581139 = path.getOrDefault("productId")
  valid_581139 = validateParameter(valid_581139, JString, required = true,
                                 default = nil)
  if valid_581139 != nil:
    section.add "productId", valid_581139
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
  var valid_581142 = query.getOrDefault("oauth_token")
  valid_581142 = validateParameter(valid_581142, JString, required = false,
                                 default = nil)
  if valid_581142 != nil:
    section.add "oauth_token", valid_581142
  var valid_581143 = query.getOrDefault("alt")
  valid_581143 = validateParameter(valid_581143, JString, required = false,
                                 default = newJString("json"))
  if valid_581143 != nil:
    section.add "alt", valid_581143
  var valid_581144 = query.getOrDefault("userIp")
  valid_581144 = validateParameter(valid_581144, JString, required = false,
                                 default = nil)
  if valid_581144 != nil:
    section.add "userIp", valid_581144
  var valid_581145 = query.getOrDefault("quotaUser")
  valid_581145 = validateParameter(valid_581145, JString, required = false,
                                 default = nil)
  if valid_581145 != nil:
    section.add "quotaUser", valid_581145
  var valid_581146 = query.getOrDefault("fields")
  valid_581146 = validateParameter(valid_581146, JString, required = false,
                                 default = nil)
  if valid_581146 != nil:
    section.add "fields", valid_581146
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581147: Call_ContentProductsGet_581135; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a product from your Merchant Center account.
  ## 
  let valid = call_581147.validator(path, query, header, formData, body)
  let scheme = call_581147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581147.url(scheme.get, call_581147.host, call_581147.base,
                         call_581147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581147, url, valid)

proc call*(call_581148: Call_ContentProductsGet_581135; merchantId: string;
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
  var path_581149 = newJObject()
  var query_581150 = newJObject()
  add(query_581150, "key", newJString(key))
  add(query_581150, "prettyPrint", newJBool(prettyPrint))
  add(query_581150, "oauth_token", newJString(oauthToken))
  add(query_581150, "alt", newJString(alt))
  add(query_581150, "userIp", newJString(userIp))
  add(query_581150, "quotaUser", newJString(quotaUser))
  add(path_581149, "merchantId", newJString(merchantId))
  add(query_581150, "fields", newJString(fields))
  add(path_581149, "productId", newJString(productId))
  result = call_581148.call(path_581149, query_581150, nil, nil, nil)

var contentProductsGet* = Call_ContentProductsGet_581135(
    name: "contentProductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/products/{productId}",
    validator: validate_ContentProductsGet_581136, base: "/content/v2.1",
    url: url_ContentProductsGet_581137, schemes: {Scheme.Https})
type
  Call_ContentProductsDelete_581151 = ref object of OpenApiRestCall_579373
proc url_ContentProductsDelete_581153(protocol: Scheme; host: string; base: string;
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

proc validate_ContentProductsDelete_581152(path: JsonNode; query: JsonNode;
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
  var valid_581154 = path.getOrDefault("merchantId")
  valid_581154 = validateParameter(valid_581154, JString, required = true,
                                 default = nil)
  if valid_581154 != nil:
    section.add "merchantId", valid_581154
  var valid_581155 = path.getOrDefault("productId")
  valid_581155 = validateParameter(valid_581155, JString, required = true,
                                 default = nil)
  if valid_581155 != nil:
    section.add "productId", valid_581155
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
  ##   feedId: JString
  ##         : The Content API Supplemental Feed ID.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581156 = query.getOrDefault("key")
  valid_581156 = validateParameter(valid_581156, JString, required = false,
                                 default = nil)
  if valid_581156 != nil:
    section.add "key", valid_581156
  var valid_581157 = query.getOrDefault("prettyPrint")
  valid_581157 = validateParameter(valid_581157, JBool, required = false,
                                 default = newJBool(true))
  if valid_581157 != nil:
    section.add "prettyPrint", valid_581157
  var valid_581158 = query.getOrDefault("oauth_token")
  valid_581158 = validateParameter(valid_581158, JString, required = false,
                                 default = nil)
  if valid_581158 != nil:
    section.add "oauth_token", valid_581158
  var valid_581159 = query.getOrDefault("alt")
  valid_581159 = validateParameter(valid_581159, JString, required = false,
                                 default = newJString("json"))
  if valid_581159 != nil:
    section.add "alt", valid_581159
  var valid_581160 = query.getOrDefault("userIp")
  valid_581160 = validateParameter(valid_581160, JString, required = false,
                                 default = nil)
  if valid_581160 != nil:
    section.add "userIp", valid_581160
  var valid_581161 = query.getOrDefault("quotaUser")
  valid_581161 = validateParameter(valid_581161, JString, required = false,
                                 default = nil)
  if valid_581161 != nil:
    section.add "quotaUser", valid_581161
  var valid_581162 = query.getOrDefault("feedId")
  valid_581162 = validateParameter(valid_581162, JString, required = false,
                                 default = nil)
  if valid_581162 != nil:
    section.add "feedId", valid_581162
  var valid_581163 = query.getOrDefault("fields")
  valid_581163 = validateParameter(valid_581163, JString, required = false,
                                 default = nil)
  if valid_581163 != nil:
    section.add "fields", valid_581163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581164: Call_ContentProductsDelete_581151; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a product from your Merchant Center account.
  ## 
  let valid = call_581164.validator(path, query, header, formData, body)
  let scheme = call_581164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581164.url(scheme.get, call_581164.host, call_581164.base,
                         call_581164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581164, url, valid)

proc call*(call_581165: Call_ContentProductsDelete_581151; merchantId: string;
          productId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; feedId: string = ""; fields: string = ""): Recallable =
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
  ##   feedId: string
  ##         : The Content API Supplemental Feed ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : The REST ID of the product.
  var path_581166 = newJObject()
  var query_581167 = newJObject()
  add(query_581167, "key", newJString(key))
  add(query_581167, "prettyPrint", newJBool(prettyPrint))
  add(query_581167, "oauth_token", newJString(oauthToken))
  add(query_581167, "alt", newJString(alt))
  add(query_581167, "userIp", newJString(userIp))
  add(query_581167, "quotaUser", newJString(quotaUser))
  add(path_581166, "merchantId", newJString(merchantId))
  add(query_581167, "feedId", newJString(feedId))
  add(query_581167, "fields", newJString(fields))
  add(path_581166, "productId", newJString(productId))
  result = call_581165.call(path_581166, query_581167, nil, nil, nil)

var contentProductsDelete* = Call_ContentProductsDelete_581151(
    name: "contentProductsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/products/{productId}",
    validator: validate_ContentProductsDelete_581152, base: "/content/v2.1",
    url: url_ContentProductsDelete_581153, schemes: {Scheme.Https})
type
  Call_ContentRegionalinventoryInsert_581168 = ref object of OpenApiRestCall_579373
proc url_ContentRegionalinventoryInsert_581170(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentRegionalinventoryInsert_581169(path: JsonNode;
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
  var valid_581171 = path.getOrDefault("merchantId")
  valid_581171 = validateParameter(valid_581171, JString, required = true,
                                 default = nil)
  if valid_581171 != nil:
    section.add "merchantId", valid_581171
  var valid_581172 = path.getOrDefault("productId")
  valid_581172 = validateParameter(valid_581172, JString, required = true,
                                 default = nil)
  if valid_581172 != nil:
    section.add "productId", valid_581172
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
  var valid_581175 = query.getOrDefault("oauth_token")
  valid_581175 = validateParameter(valid_581175, JString, required = false,
                                 default = nil)
  if valid_581175 != nil:
    section.add "oauth_token", valid_581175
  var valid_581176 = query.getOrDefault("alt")
  valid_581176 = validateParameter(valid_581176, JString, required = false,
                                 default = newJString("json"))
  if valid_581176 != nil:
    section.add "alt", valid_581176
  var valid_581177 = query.getOrDefault("userIp")
  valid_581177 = validateParameter(valid_581177, JString, required = false,
                                 default = nil)
  if valid_581177 != nil:
    section.add "userIp", valid_581177
  var valid_581178 = query.getOrDefault("quotaUser")
  valid_581178 = validateParameter(valid_581178, JString, required = false,
                                 default = nil)
  if valid_581178 != nil:
    section.add "quotaUser", valid_581178
  var valid_581179 = query.getOrDefault("fields")
  valid_581179 = validateParameter(valid_581179, JString, required = false,
                                 default = nil)
  if valid_581179 != nil:
    section.add "fields", valid_581179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_581181: Call_ContentRegionalinventoryInsert_581168; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the regional inventory of a product in your Merchant Center account. If a regional inventory with the same region ID already exists, this method updates that entry.
  ## 
  let valid = call_581181.validator(path, query, header, formData, body)
  let scheme = call_581181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581181.url(scheme.get, call_581181.host, call_581181.base,
                         call_581181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581181, url, valid)

proc call*(call_581182: Call_ContentRegionalinventoryInsert_581168;
          merchantId: string; productId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentRegionalinventoryInsert
  ## Update the regional inventory of a product in your Merchant Center account. If a regional inventory with the same region ID already exists, this method updates that entry.
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
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : The REST ID of the product for which to update the regional inventory.
  var path_581183 = newJObject()
  var query_581184 = newJObject()
  var body_581185 = newJObject()
  add(query_581184, "key", newJString(key))
  add(query_581184, "prettyPrint", newJBool(prettyPrint))
  add(query_581184, "oauth_token", newJString(oauthToken))
  add(query_581184, "alt", newJString(alt))
  add(query_581184, "userIp", newJString(userIp))
  add(query_581184, "quotaUser", newJString(quotaUser))
  add(path_581183, "merchantId", newJString(merchantId))
  if body != nil:
    body_581185 = body
  add(query_581184, "fields", newJString(fields))
  add(path_581183, "productId", newJString(productId))
  result = call_581182.call(path_581183, query_581184, nil, nil, body_581185)

var contentRegionalinventoryInsert* = Call_ContentRegionalinventoryInsert_581168(
    name: "contentRegionalinventoryInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/products/{productId}/regionalinventory",
    validator: validate_ContentRegionalinventoryInsert_581169,
    base: "/content/v2.1", url: url_ContentRegionalinventoryInsert_581170,
    schemes: {Scheme.Https})
type
  Call_ContentProductstatusesList_581186 = ref object of OpenApiRestCall_579373
proc url_ContentProductstatusesList_581188(protocol: Scheme; host: string;
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

proc validate_ContentProductstatusesList_581187(path: JsonNode; query: JsonNode;
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
  var valid_581189 = path.getOrDefault("merchantId")
  valid_581189 = validateParameter(valid_581189, JString, required = true,
                                 default = nil)
  if valid_581189 != nil:
    section.add "merchantId", valid_581189
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
  ##             : The maximum number of product statuses to return in the response, used for paging.
  section = newJObject()
  var valid_581190 = query.getOrDefault("key")
  valid_581190 = validateParameter(valid_581190, JString, required = false,
                                 default = nil)
  if valid_581190 != nil:
    section.add "key", valid_581190
  var valid_581191 = query.getOrDefault("prettyPrint")
  valid_581191 = validateParameter(valid_581191, JBool, required = false,
                                 default = newJBool(true))
  if valid_581191 != nil:
    section.add "prettyPrint", valid_581191
  var valid_581192 = query.getOrDefault("oauth_token")
  valid_581192 = validateParameter(valid_581192, JString, required = false,
                                 default = nil)
  if valid_581192 != nil:
    section.add "oauth_token", valid_581192
  var valid_581193 = query.getOrDefault("alt")
  valid_581193 = validateParameter(valid_581193, JString, required = false,
                                 default = newJString("json"))
  if valid_581193 != nil:
    section.add "alt", valid_581193
  var valid_581194 = query.getOrDefault("userIp")
  valid_581194 = validateParameter(valid_581194, JString, required = false,
                                 default = nil)
  if valid_581194 != nil:
    section.add "userIp", valid_581194
  var valid_581195 = query.getOrDefault("quotaUser")
  valid_581195 = validateParameter(valid_581195, JString, required = false,
                                 default = nil)
  if valid_581195 != nil:
    section.add "quotaUser", valid_581195
  var valid_581196 = query.getOrDefault("pageToken")
  valid_581196 = validateParameter(valid_581196, JString, required = false,
                                 default = nil)
  if valid_581196 != nil:
    section.add "pageToken", valid_581196
  var valid_581197 = query.getOrDefault("destinations")
  valid_581197 = validateParameter(valid_581197, JArray, required = false,
                                 default = nil)
  if valid_581197 != nil:
    section.add "destinations", valid_581197
  var valid_581198 = query.getOrDefault("fields")
  valid_581198 = validateParameter(valid_581198, JString, required = false,
                                 default = nil)
  if valid_581198 != nil:
    section.add "fields", valid_581198
  var valid_581199 = query.getOrDefault("maxResults")
  valid_581199 = validateParameter(valid_581199, JInt, required = false, default = nil)
  if valid_581199 != nil:
    section.add "maxResults", valid_581199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581200: Call_ContentProductstatusesList_581186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the products in your Merchant Center account.
  ## 
  let valid = call_581200.validator(path, query, header, formData, body)
  let scheme = call_581200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581200.url(scheme.get, call_581200.host, call_581200.base,
                         call_581200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581200, url, valid)

proc call*(call_581201: Call_ContentProductstatusesList_581186; merchantId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; destinations: JsonNode = nil; fields: string = "";
          maxResults: int = 0): Recallable =
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of product statuses to return in the response, used for paging.
  var path_581202 = newJObject()
  var query_581203 = newJObject()
  add(query_581203, "key", newJString(key))
  add(query_581203, "prettyPrint", newJBool(prettyPrint))
  add(query_581203, "oauth_token", newJString(oauthToken))
  add(query_581203, "alt", newJString(alt))
  add(query_581203, "userIp", newJString(userIp))
  add(query_581203, "quotaUser", newJString(quotaUser))
  add(path_581202, "merchantId", newJString(merchantId))
  add(query_581203, "pageToken", newJString(pageToken))
  if destinations != nil:
    query_581203.add "destinations", destinations
  add(query_581203, "fields", newJString(fields))
  add(query_581203, "maxResults", newJInt(maxResults))
  result = call_581201.call(path_581202, query_581203, nil, nil, nil)

var contentProductstatusesList* = Call_ContentProductstatusesList_581186(
    name: "contentProductstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/productstatuses",
    validator: validate_ContentProductstatusesList_581187, base: "/content/v2.1",
    url: url_ContentProductstatusesList_581188, schemes: {Scheme.Https})
type
  Call_ContentProductstatusesGet_581204 = ref object of OpenApiRestCall_579373
proc url_ContentProductstatusesGet_581206(protocol: Scheme; host: string;
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

proc validate_ContentProductstatusesGet_581205(path: JsonNode; query: JsonNode;
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
  var valid_581207 = path.getOrDefault("merchantId")
  valid_581207 = validateParameter(valid_581207, JString, required = true,
                                 default = nil)
  if valid_581207 != nil:
    section.add "merchantId", valid_581207
  var valid_581208 = path.getOrDefault("productId")
  valid_581208 = validateParameter(valid_581208, JString, required = true,
                                 default = nil)
  if valid_581208 != nil:
    section.add "productId", valid_581208
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
  var valid_581209 = query.getOrDefault("key")
  valid_581209 = validateParameter(valid_581209, JString, required = false,
                                 default = nil)
  if valid_581209 != nil:
    section.add "key", valid_581209
  var valid_581210 = query.getOrDefault("prettyPrint")
  valid_581210 = validateParameter(valid_581210, JBool, required = false,
                                 default = newJBool(true))
  if valid_581210 != nil:
    section.add "prettyPrint", valid_581210
  var valid_581211 = query.getOrDefault("oauth_token")
  valid_581211 = validateParameter(valid_581211, JString, required = false,
                                 default = nil)
  if valid_581211 != nil:
    section.add "oauth_token", valid_581211
  var valid_581212 = query.getOrDefault("alt")
  valid_581212 = validateParameter(valid_581212, JString, required = false,
                                 default = newJString("json"))
  if valid_581212 != nil:
    section.add "alt", valid_581212
  var valid_581213 = query.getOrDefault("userIp")
  valid_581213 = validateParameter(valid_581213, JString, required = false,
                                 default = nil)
  if valid_581213 != nil:
    section.add "userIp", valid_581213
  var valid_581214 = query.getOrDefault("quotaUser")
  valid_581214 = validateParameter(valid_581214, JString, required = false,
                                 default = nil)
  if valid_581214 != nil:
    section.add "quotaUser", valid_581214
  var valid_581215 = query.getOrDefault("destinations")
  valid_581215 = validateParameter(valid_581215, JArray, required = false,
                                 default = nil)
  if valid_581215 != nil:
    section.add "destinations", valid_581215
  var valid_581216 = query.getOrDefault("fields")
  valid_581216 = validateParameter(valid_581216, JString, required = false,
                                 default = nil)
  if valid_581216 != nil:
    section.add "fields", valid_581216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581217: Call_ContentProductstatusesGet_581204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the status of a product from your Merchant Center account.
  ## 
  let valid = call_581217.validator(path, query, header, formData, body)
  let scheme = call_581217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581217.url(scheme.get, call_581217.host, call_581217.base,
                         call_581217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581217, url, valid)

proc call*(call_581218: Call_ContentProductstatusesGet_581204; merchantId: string;
          productId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; destinations: JsonNode = nil; fields: string = ""): Recallable =
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : The REST ID of the product.
  var path_581219 = newJObject()
  var query_581220 = newJObject()
  add(query_581220, "key", newJString(key))
  add(query_581220, "prettyPrint", newJBool(prettyPrint))
  add(query_581220, "oauth_token", newJString(oauthToken))
  add(query_581220, "alt", newJString(alt))
  add(query_581220, "userIp", newJString(userIp))
  add(query_581220, "quotaUser", newJString(quotaUser))
  add(path_581219, "merchantId", newJString(merchantId))
  if destinations != nil:
    query_581220.add "destinations", destinations
  add(query_581220, "fields", newJString(fields))
  add(path_581219, "productId", newJString(productId))
  result = call_581218.call(path_581219, query_581220, nil, nil, nil)

var contentProductstatusesGet* = Call_ContentProductstatusesGet_581204(
    name: "contentProductstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/productstatuses/{productId}",
    validator: validate_ContentProductstatusesGet_581205, base: "/content/v2.1",
    url: url_ContentProductstatusesGet_581206, schemes: {Scheme.Https})
type
  Call_ContentReturnaddressInsert_581239 = ref object of OpenApiRestCall_579373
proc url_ContentReturnaddressInsert_581241(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentReturnaddressInsert_581240(path: JsonNode; query: JsonNode;
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
  var valid_581242 = path.getOrDefault("merchantId")
  valid_581242 = validateParameter(valid_581242, JString, required = true,
                                 default = nil)
  if valid_581242 != nil:
    section.add "merchantId", valid_581242
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
  var valid_581245 = query.getOrDefault("oauth_token")
  valid_581245 = validateParameter(valid_581245, JString, required = false,
                                 default = nil)
  if valid_581245 != nil:
    section.add "oauth_token", valid_581245
  var valid_581246 = query.getOrDefault("alt")
  valid_581246 = validateParameter(valid_581246, JString, required = false,
                                 default = newJString("json"))
  if valid_581246 != nil:
    section.add "alt", valid_581246
  var valid_581247 = query.getOrDefault("userIp")
  valid_581247 = validateParameter(valid_581247, JString, required = false,
                                 default = nil)
  if valid_581247 != nil:
    section.add "userIp", valid_581247
  var valid_581248 = query.getOrDefault("quotaUser")
  valid_581248 = validateParameter(valid_581248, JString, required = false,
                                 default = nil)
  if valid_581248 != nil:
    section.add "quotaUser", valid_581248
  var valid_581249 = query.getOrDefault("fields")
  valid_581249 = validateParameter(valid_581249, JString, required = false,
                                 default = nil)
  if valid_581249 != nil:
    section.add "fields", valid_581249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_581251: Call_ContentReturnaddressInsert_581239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a return address for the Merchant Center account.
  ## 
  let valid = call_581251.validator(path, query, header, formData, body)
  let scheme = call_581251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581251.url(scheme.get, call_581251.host, call_581251.base,
                         call_581251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581251, url, valid)

proc call*(call_581252: Call_ContentReturnaddressInsert_581239; merchantId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentReturnaddressInsert
  ## Inserts a return address for the Merchant Center account.
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
  ##             : The Merchant Center account to insert a return address for.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581253 = newJObject()
  var query_581254 = newJObject()
  var body_581255 = newJObject()
  add(query_581254, "key", newJString(key))
  add(query_581254, "prettyPrint", newJBool(prettyPrint))
  add(query_581254, "oauth_token", newJString(oauthToken))
  add(query_581254, "alt", newJString(alt))
  add(query_581254, "userIp", newJString(userIp))
  add(query_581254, "quotaUser", newJString(quotaUser))
  add(path_581253, "merchantId", newJString(merchantId))
  if body != nil:
    body_581255 = body
  add(query_581254, "fields", newJString(fields))
  result = call_581252.call(path_581253, query_581254, nil, nil, body_581255)

var contentReturnaddressInsert* = Call_ContentReturnaddressInsert_581239(
    name: "contentReturnaddressInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/returnaddress",
    validator: validate_ContentReturnaddressInsert_581240, base: "/content/v2.1",
    url: url_ContentReturnaddressInsert_581241, schemes: {Scheme.Https})
type
  Call_ContentReturnaddressList_581221 = ref object of OpenApiRestCall_579373
proc url_ContentReturnaddressList_581223(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentReturnaddressList_581222(path: JsonNode; query: JsonNode;
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
  var valid_581224 = path.getOrDefault("merchantId")
  valid_581224 = validateParameter(valid_581224, JString, required = true,
                                 default = nil)
  if valid_581224 != nil:
    section.add "merchantId", valid_581224
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
  ##   country: JString
  ##          : List only return addresses applicable to the given country of sale. When omitted, all return addresses are listed.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of addresses in the response, used for paging.
  section = newJObject()
  var valid_581225 = query.getOrDefault("key")
  valid_581225 = validateParameter(valid_581225, JString, required = false,
                                 default = nil)
  if valid_581225 != nil:
    section.add "key", valid_581225
  var valid_581226 = query.getOrDefault("prettyPrint")
  valid_581226 = validateParameter(valid_581226, JBool, required = false,
                                 default = newJBool(true))
  if valid_581226 != nil:
    section.add "prettyPrint", valid_581226
  var valid_581227 = query.getOrDefault("oauth_token")
  valid_581227 = validateParameter(valid_581227, JString, required = false,
                                 default = nil)
  if valid_581227 != nil:
    section.add "oauth_token", valid_581227
  var valid_581228 = query.getOrDefault("alt")
  valid_581228 = validateParameter(valid_581228, JString, required = false,
                                 default = newJString("json"))
  if valid_581228 != nil:
    section.add "alt", valid_581228
  var valid_581229 = query.getOrDefault("userIp")
  valid_581229 = validateParameter(valid_581229, JString, required = false,
                                 default = nil)
  if valid_581229 != nil:
    section.add "userIp", valid_581229
  var valid_581230 = query.getOrDefault("quotaUser")
  valid_581230 = validateParameter(valid_581230, JString, required = false,
                                 default = nil)
  if valid_581230 != nil:
    section.add "quotaUser", valid_581230
  var valid_581231 = query.getOrDefault("pageToken")
  valid_581231 = validateParameter(valid_581231, JString, required = false,
                                 default = nil)
  if valid_581231 != nil:
    section.add "pageToken", valid_581231
  var valid_581232 = query.getOrDefault("country")
  valid_581232 = validateParameter(valid_581232, JString, required = false,
                                 default = nil)
  if valid_581232 != nil:
    section.add "country", valid_581232
  var valid_581233 = query.getOrDefault("fields")
  valid_581233 = validateParameter(valid_581233, JString, required = false,
                                 default = nil)
  if valid_581233 != nil:
    section.add "fields", valid_581233
  var valid_581234 = query.getOrDefault("maxResults")
  valid_581234 = validateParameter(valid_581234, JInt, required = false, default = nil)
  if valid_581234 != nil:
    section.add "maxResults", valid_581234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581235: Call_ContentReturnaddressList_581221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the return addresses of the Merchant Center account.
  ## 
  let valid = call_581235.validator(path, query, header, formData, body)
  let scheme = call_581235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581235.url(scheme.get, call_581235.host, call_581235.base,
                         call_581235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581235, url, valid)

proc call*(call_581236: Call_ContentReturnaddressList_581221; merchantId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; country: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## contentReturnaddressList
  ## Lists the return addresses of the Merchant Center account.
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
  ##             : The Merchant Center account to list return addresses for.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   country: string
  ##          : List only return addresses applicable to the given country of sale. When omitted, all return addresses are listed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of addresses in the response, used for paging.
  var path_581237 = newJObject()
  var query_581238 = newJObject()
  add(query_581238, "key", newJString(key))
  add(query_581238, "prettyPrint", newJBool(prettyPrint))
  add(query_581238, "oauth_token", newJString(oauthToken))
  add(query_581238, "alt", newJString(alt))
  add(query_581238, "userIp", newJString(userIp))
  add(query_581238, "quotaUser", newJString(quotaUser))
  add(path_581237, "merchantId", newJString(merchantId))
  add(query_581238, "pageToken", newJString(pageToken))
  add(query_581238, "country", newJString(country))
  add(query_581238, "fields", newJString(fields))
  add(query_581238, "maxResults", newJInt(maxResults))
  result = call_581236.call(path_581237, query_581238, nil, nil, nil)

var contentReturnaddressList* = Call_ContentReturnaddressList_581221(
    name: "contentReturnaddressList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/returnaddress",
    validator: validate_ContentReturnaddressList_581222, base: "/content/v2.1",
    url: url_ContentReturnaddressList_581223, schemes: {Scheme.Https})
type
  Call_ContentReturnaddressGet_581256 = ref object of OpenApiRestCall_579373
proc url_ContentReturnaddressGet_581258(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentReturnaddressGet_581257(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a return address of the Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The Merchant Center account to get a return address for.
  ##   returnAddressId: JString (required)
  ##                  : Return address ID generated by Google.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_581259 = path.getOrDefault("merchantId")
  valid_581259 = validateParameter(valid_581259, JString, required = true,
                                 default = nil)
  if valid_581259 != nil:
    section.add "merchantId", valid_581259
  var valid_581260 = path.getOrDefault("returnAddressId")
  valid_581260 = validateParameter(valid_581260, JString, required = true,
                                 default = nil)
  if valid_581260 != nil:
    section.add "returnAddressId", valid_581260
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
  var valid_581261 = query.getOrDefault("key")
  valid_581261 = validateParameter(valid_581261, JString, required = false,
                                 default = nil)
  if valid_581261 != nil:
    section.add "key", valid_581261
  var valid_581262 = query.getOrDefault("prettyPrint")
  valid_581262 = validateParameter(valid_581262, JBool, required = false,
                                 default = newJBool(true))
  if valid_581262 != nil:
    section.add "prettyPrint", valid_581262
  var valid_581263 = query.getOrDefault("oauth_token")
  valid_581263 = validateParameter(valid_581263, JString, required = false,
                                 default = nil)
  if valid_581263 != nil:
    section.add "oauth_token", valid_581263
  var valid_581264 = query.getOrDefault("alt")
  valid_581264 = validateParameter(valid_581264, JString, required = false,
                                 default = newJString("json"))
  if valid_581264 != nil:
    section.add "alt", valid_581264
  var valid_581265 = query.getOrDefault("userIp")
  valid_581265 = validateParameter(valid_581265, JString, required = false,
                                 default = nil)
  if valid_581265 != nil:
    section.add "userIp", valid_581265
  var valid_581266 = query.getOrDefault("quotaUser")
  valid_581266 = validateParameter(valid_581266, JString, required = false,
                                 default = nil)
  if valid_581266 != nil:
    section.add "quotaUser", valid_581266
  var valid_581267 = query.getOrDefault("fields")
  valid_581267 = validateParameter(valid_581267, JString, required = false,
                                 default = nil)
  if valid_581267 != nil:
    section.add "fields", valid_581267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581268: Call_ContentReturnaddressGet_581256; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a return address of the Merchant Center account.
  ## 
  let valid = call_581268.validator(path, query, header, formData, body)
  let scheme = call_581268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581268.url(scheme.get, call_581268.host, call_581268.base,
                         call_581268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581268, url, valid)

proc call*(call_581269: Call_ContentReturnaddressGet_581256; merchantId: string;
          returnAddressId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## contentReturnaddressGet
  ## Gets a return address of the Merchant Center account.
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
  ##             : The Merchant Center account to get a return address for.
  ##   returnAddressId: string (required)
  ##                  : Return address ID generated by Google.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581270 = newJObject()
  var query_581271 = newJObject()
  add(query_581271, "key", newJString(key))
  add(query_581271, "prettyPrint", newJBool(prettyPrint))
  add(query_581271, "oauth_token", newJString(oauthToken))
  add(query_581271, "alt", newJString(alt))
  add(query_581271, "userIp", newJString(userIp))
  add(query_581271, "quotaUser", newJString(quotaUser))
  add(path_581270, "merchantId", newJString(merchantId))
  add(path_581270, "returnAddressId", newJString(returnAddressId))
  add(query_581271, "fields", newJString(fields))
  result = call_581269.call(path_581270, query_581271, nil, nil, nil)

var contentReturnaddressGet* = Call_ContentReturnaddressGet_581256(
    name: "contentReturnaddressGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/returnaddress/{returnAddressId}",
    validator: validate_ContentReturnaddressGet_581257, base: "/content/v2.1",
    url: url_ContentReturnaddressGet_581258, schemes: {Scheme.Https})
type
  Call_ContentReturnaddressDelete_581272 = ref object of OpenApiRestCall_579373
proc url_ContentReturnaddressDelete_581274(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentReturnaddressDelete_581273(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a return address for the given Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The Merchant Center account from which to delete the given return address.
  ##   returnAddressId: JString (required)
  ##                  : Return address ID generated by Google.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_581275 = path.getOrDefault("merchantId")
  valid_581275 = validateParameter(valid_581275, JString, required = true,
                                 default = nil)
  if valid_581275 != nil:
    section.add "merchantId", valid_581275
  var valid_581276 = path.getOrDefault("returnAddressId")
  valid_581276 = validateParameter(valid_581276, JString, required = true,
                                 default = nil)
  if valid_581276 != nil:
    section.add "returnAddressId", valid_581276
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
  var valid_581277 = query.getOrDefault("key")
  valid_581277 = validateParameter(valid_581277, JString, required = false,
                                 default = nil)
  if valid_581277 != nil:
    section.add "key", valid_581277
  var valid_581278 = query.getOrDefault("prettyPrint")
  valid_581278 = validateParameter(valid_581278, JBool, required = false,
                                 default = newJBool(true))
  if valid_581278 != nil:
    section.add "prettyPrint", valid_581278
  var valid_581279 = query.getOrDefault("oauth_token")
  valid_581279 = validateParameter(valid_581279, JString, required = false,
                                 default = nil)
  if valid_581279 != nil:
    section.add "oauth_token", valid_581279
  var valid_581280 = query.getOrDefault("alt")
  valid_581280 = validateParameter(valid_581280, JString, required = false,
                                 default = newJString("json"))
  if valid_581280 != nil:
    section.add "alt", valid_581280
  var valid_581281 = query.getOrDefault("userIp")
  valid_581281 = validateParameter(valid_581281, JString, required = false,
                                 default = nil)
  if valid_581281 != nil:
    section.add "userIp", valid_581281
  var valid_581282 = query.getOrDefault("quotaUser")
  valid_581282 = validateParameter(valid_581282, JString, required = false,
                                 default = nil)
  if valid_581282 != nil:
    section.add "quotaUser", valid_581282
  var valid_581283 = query.getOrDefault("fields")
  valid_581283 = validateParameter(valid_581283, JString, required = false,
                                 default = nil)
  if valid_581283 != nil:
    section.add "fields", valid_581283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581284: Call_ContentReturnaddressDelete_581272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a return address for the given Merchant Center account.
  ## 
  let valid = call_581284.validator(path, query, header, formData, body)
  let scheme = call_581284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581284.url(scheme.get, call_581284.host, call_581284.base,
                         call_581284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581284, url, valid)

proc call*(call_581285: Call_ContentReturnaddressDelete_581272; merchantId: string;
          returnAddressId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## contentReturnaddressDelete
  ## Deletes a return address for the given Merchant Center account.
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
  ##             : The Merchant Center account from which to delete the given return address.
  ##   returnAddressId: string (required)
  ##                  : Return address ID generated by Google.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581286 = newJObject()
  var query_581287 = newJObject()
  add(query_581287, "key", newJString(key))
  add(query_581287, "prettyPrint", newJBool(prettyPrint))
  add(query_581287, "oauth_token", newJString(oauthToken))
  add(query_581287, "alt", newJString(alt))
  add(query_581287, "userIp", newJString(userIp))
  add(query_581287, "quotaUser", newJString(quotaUser))
  add(path_581286, "merchantId", newJString(merchantId))
  add(path_581286, "returnAddressId", newJString(returnAddressId))
  add(query_581287, "fields", newJString(fields))
  result = call_581285.call(path_581286, query_581287, nil, nil, nil)

var contentReturnaddressDelete* = Call_ContentReturnaddressDelete_581272(
    name: "contentReturnaddressDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{merchantId}/returnaddress/{returnAddressId}",
    validator: validate_ContentReturnaddressDelete_581273, base: "/content/v2.1",
    url: url_ContentReturnaddressDelete_581274, schemes: {Scheme.Https})
type
  Call_ContentReturnpolicyInsert_581303 = ref object of OpenApiRestCall_579373
proc url_ContentReturnpolicyInsert_581305(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentReturnpolicyInsert_581304(path: JsonNode; query: JsonNode;
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
  var valid_581306 = path.getOrDefault("merchantId")
  valid_581306 = validateParameter(valid_581306, JString, required = true,
                                 default = nil)
  if valid_581306 != nil:
    section.add "merchantId", valid_581306
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
  var valid_581313 = query.getOrDefault("fields")
  valid_581313 = validateParameter(valid_581313, JString, required = false,
                                 default = nil)
  if valid_581313 != nil:
    section.add "fields", valid_581313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_581315: Call_ContentReturnpolicyInsert_581303; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a return policy for the Merchant Center account.
  ## 
  let valid = call_581315.validator(path, query, header, formData, body)
  let scheme = call_581315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581315.url(scheme.get, call_581315.host, call_581315.base,
                         call_581315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581315, url, valid)

proc call*(call_581316: Call_ContentReturnpolicyInsert_581303; merchantId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentReturnpolicyInsert
  ## Inserts a return policy for the Merchant Center account.
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
  ##             : The Merchant Center account to insert a return policy for.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581317 = newJObject()
  var query_581318 = newJObject()
  var body_581319 = newJObject()
  add(query_581318, "key", newJString(key))
  add(query_581318, "prettyPrint", newJBool(prettyPrint))
  add(query_581318, "oauth_token", newJString(oauthToken))
  add(query_581318, "alt", newJString(alt))
  add(query_581318, "userIp", newJString(userIp))
  add(query_581318, "quotaUser", newJString(quotaUser))
  add(path_581317, "merchantId", newJString(merchantId))
  if body != nil:
    body_581319 = body
  add(query_581318, "fields", newJString(fields))
  result = call_581316.call(path_581317, query_581318, nil, nil, body_581319)

var contentReturnpolicyInsert* = Call_ContentReturnpolicyInsert_581303(
    name: "contentReturnpolicyInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/returnpolicy",
    validator: validate_ContentReturnpolicyInsert_581304, base: "/content/v2.1",
    url: url_ContentReturnpolicyInsert_581305, schemes: {Scheme.Https})
type
  Call_ContentReturnpolicyList_581288 = ref object of OpenApiRestCall_579373
proc url_ContentReturnpolicyList_581290(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentReturnpolicyList_581289(path: JsonNode; query: JsonNode;
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
  var valid_581291 = path.getOrDefault("merchantId")
  valid_581291 = validateParameter(valid_581291, JString, required = true,
                                 default = nil)
  if valid_581291 != nil:
    section.add "merchantId", valid_581291
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
  var valid_581292 = query.getOrDefault("key")
  valid_581292 = validateParameter(valid_581292, JString, required = false,
                                 default = nil)
  if valid_581292 != nil:
    section.add "key", valid_581292
  var valid_581293 = query.getOrDefault("prettyPrint")
  valid_581293 = validateParameter(valid_581293, JBool, required = false,
                                 default = newJBool(true))
  if valid_581293 != nil:
    section.add "prettyPrint", valid_581293
  var valid_581294 = query.getOrDefault("oauth_token")
  valid_581294 = validateParameter(valid_581294, JString, required = false,
                                 default = nil)
  if valid_581294 != nil:
    section.add "oauth_token", valid_581294
  var valid_581295 = query.getOrDefault("alt")
  valid_581295 = validateParameter(valid_581295, JString, required = false,
                                 default = newJString("json"))
  if valid_581295 != nil:
    section.add "alt", valid_581295
  var valid_581296 = query.getOrDefault("userIp")
  valid_581296 = validateParameter(valid_581296, JString, required = false,
                                 default = nil)
  if valid_581296 != nil:
    section.add "userIp", valid_581296
  var valid_581297 = query.getOrDefault("quotaUser")
  valid_581297 = validateParameter(valid_581297, JString, required = false,
                                 default = nil)
  if valid_581297 != nil:
    section.add "quotaUser", valid_581297
  var valid_581298 = query.getOrDefault("fields")
  valid_581298 = validateParameter(valid_581298, JString, required = false,
                                 default = nil)
  if valid_581298 != nil:
    section.add "fields", valid_581298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581299: Call_ContentReturnpolicyList_581288; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the return policies of the Merchant Center account.
  ## 
  let valid = call_581299.validator(path, query, header, formData, body)
  let scheme = call_581299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581299.url(scheme.get, call_581299.host, call_581299.base,
                         call_581299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581299, url, valid)

proc call*(call_581300: Call_ContentReturnpolicyList_581288; merchantId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## contentReturnpolicyList
  ## Lists the return policies of the Merchant Center account.
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
  ##             : The Merchant Center account to list return policies for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581301 = newJObject()
  var query_581302 = newJObject()
  add(query_581302, "key", newJString(key))
  add(query_581302, "prettyPrint", newJBool(prettyPrint))
  add(query_581302, "oauth_token", newJString(oauthToken))
  add(query_581302, "alt", newJString(alt))
  add(query_581302, "userIp", newJString(userIp))
  add(query_581302, "quotaUser", newJString(quotaUser))
  add(path_581301, "merchantId", newJString(merchantId))
  add(query_581302, "fields", newJString(fields))
  result = call_581300.call(path_581301, query_581302, nil, nil, nil)

var contentReturnpolicyList* = Call_ContentReturnpolicyList_581288(
    name: "contentReturnpolicyList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/returnpolicy",
    validator: validate_ContentReturnpolicyList_581289, base: "/content/v2.1",
    url: url_ContentReturnpolicyList_581290, schemes: {Scheme.Https})
type
  Call_ContentReturnpolicyGet_581320 = ref object of OpenApiRestCall_579373
proc url_ContentReturnpolicyGet_581322(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentReturnpolicyGet_581321(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a return policy of the Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The Merchant Center account to get a return policy for.
  ##   returnPolicyId: JString (required)
  ##                 : Return policy ID generated by Google.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_581323 = path.getOrDefault("merchantId")
  valid_581323 = validateParameter(valid_581323, JString, required = true,
                                 default = nil)
  if valid_581323 != nil:
    section.add "merchantId", valid_581323
  var valid_581324 = path.getOrDefault("returnPolicyId")
  valid_581324 = validateParameter(valid_581324, JString, required = true,
                                 default = nil)
  if valid_581324 != nil:
    section.add "returnPolicyId", valid_581324
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

proc call*(call_581332: Call_ContentReturnpolicyGet_581320; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a return policy of the Merchant Center account.
  ## 
  let valid = call_581332.validator(path, query, header, formData, body)
  let scheme = call_581332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581332.url(scheme.get, call_581332.host, call_581332.base,
                         call_581332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581332, url, valid)

proc call*(call_581333: Call_ContentReturnpolicyGet_581320; merchantId: string;
          returnPolicyId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## contentReturnpolicyGet
  ## Gets a return policy of the Merchant Center account.
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
  ##             : The Merchant Center account to get a return policy for.
  ##   returnPolicyId: string (required)
  ##                 : Return policy ID generated by Google.
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
  add(path_581334, "returnPolicyId", newJString(returnPolicyId))
  add(query_581335, "fields", newJString(fields))
  result = call_581333.call(path_581334, query_581335, nil, nil, nil)

var contentReturnpolicyGet* = Call_ContentReturnpolicyGet_581320(
    name: "contentReturnpolicyGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/returnpolicy/{returnPolicyId}",
    validator: validate_ContentReturnpolicyGet_581321, base: "/content/v2.1",
    url: url_ContentReturnpolicyGet_581322, schemes: {Scheme.Https})
type
  Call_ContentReturnpolicyDelete_581336 = ref object of OpenApiRestCall_579373
proc url_ContentReturnpolicyDelete_581338(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContentReturnpolicyDelete_581337(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a return policy for the given Merchant Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The Merchant Center account from which to delete the given return policy.
  ##   returnPolicyId: JString (required)
  ##                 : Return policy ID generated by Google.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_581339 = path.getOrDefault("merchantId")
  valid_581339 = validateParameter(valid_581339, JString, required = true,
                                 default = nil)
  if valid_581339 != nil:
    section.add "merchantId", valid_581339
  var valid_581340 = path.getOrDefault("returnPolicyId")
  valid_581340 = validateParameter(valid_581340, JString, required = true,
                                 default = nil)
  if valid_581340 != nil:
    section.add "returnPolicyId", valid_581340
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
  var valid_581341 = query.getOrDefault("key")
  valid_581341 = validateParameter(valid_581341, JString, required = false,
                                 default = nil)
  if valid_581341 != nil:
    section.add "key", valid_581341
  var valid_581342 = query.getOrDefault("prettyPrint")
  valid_581342 = validateParameter(valid_581342, JBool, required = false,
                                 default = newJBool(true))
  if valid_581342 != nil:
    section.add "prettyPrint", valid_581342
  var valid_581343 = query.getOrDefault("oauth_token")
  valid_581343 = validateParameter(valid_581343, JString, required = false,
                                 default = nil)
  if valid_581343 != nil:
    section.add "oauth_token", valid_581343
  var valid_581344 = query.getOrDefault("alt")
  valid_581344 = validateParameter(valid_581344, JString, required = false,
                                 default = newJString("json"))
  if valid_581344 != nil:
    section.add "alt", valid_581344
  var valid_581345 = query.getOrDefault("userIp")
  valid_581345 = validateParameter(valid_581345, JString, required = false,
                                 default = nil)
  if valid_581345 != nil:
    section.add "userIp", valid_581345
  var valid_581346 = query.getOrDefault("quotaUser")
  valid_581346 = validateParameter(valid_581346, JString, required = false,
                                 default = nil)
  if valid_581346 != nil:
    section.add "quotaUser", valid_581346
  var valid_581347 = query.getOrDefault("fields")
  valid_581347 = validateParameter(valid_581347, JString, required = false,
                                 default = nil)
  if valid_581347 != nil:
    section.add "fields", valid_581347
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581348: Call_ContentReturnpolicyDelete_581336; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a return policy for the given Merchant Center account.
  ## 
  let valid = call_581348.validator(path, query, header, formData, body)
  let scheme = call_581348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581348.url(scheme.get, call_581348.host, call_581348.base,
                         call_581348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581348, url, valid)

proc call*(call_581349: Call_ContentReturnpolicyDelete_581336; merchantId: string;
          returnPolicyId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## contentReturnpolicyDelete
  ## Deletes a return policy for the given Merchant Center account.
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
  ##             : The Merchant Center account from which to delete the given return policy.
  ##   returnPolicyId: string (required)
  ##                 : Return policy ID generated by Google.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581350 = newJObject()
  var query_581351 = newJObject()
  add(query_581351, "key", newJString(key))
  add(query_581351, "prettyPrint", newJBool(prettyPrint))
  add(query_581351, "oauth_token", newJString(oauthToken))
  add(query_581351, "alt", newJString(alt))
  add(query_581351, "userIp", newJString(userIp))
  add(query_581351, "quotaUser", newJString(quotaUser))
  add(path_581350, "merchantId", newJString(merchantId))
  add(path_581350, "returnPolicyId", newJString(returnPolicyId))
  add(query_581351, "fields", newJString(fields))
  result = call_581349.call(path_581350, query_581351, nil, nil, nil)

var contentReturnpolicyDelete* = Call_ContentReturnpolicyDelete_581336(
    name: "contentReturnpolicyDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{merchantId}/returnpolicy/{returnPolicyId}",
    validator: validate_ContentReturnpolicyDelete_581337, base: "/content/v2.1",
    url: url_ContentReturnpolicyDelete_581338, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsList_581352 = ref object of OpenApiRestCall_579373
proc url_ContentShippingsettingsList_581354(protocol: Scheme; host: string;
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

proc validate_ContentShippingsettingsList_581353(path: JsonNode; query: JsonNode;
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
  var valid_581355 = path.getOrDefault("merchantId")
  valid_581355 = validateParameter(valid_581355, JString, required = true,
                                 default = nil)
  if valid_581355 != nil:
    section.add "merchantId", valid_581355
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
  var valid_581356 = query.getOrDefault("key")
  valid_581356 = validateParameter(valid_581356, JString, required = false,
                                 default = nil)
  if valid_581356 != nil:
    section.add "key", valid_581356
  var valid_581357 = query.getOrDefault("prettyPrint")
  valid_581357 = validateParameter(valid_581357, JBool, required = false,
                                 default = newJBool(true))
  if valid_581357 != nil:
    section.add "prettyPrint", valid_581357
  var valid_581358 = query.getOrDefault("oauth_token")
  valid_581358 = validateParameter(valid_581358, JString, required = false,
                                 default = nil)
  if valid_581358 != nil:
    section.add "oauth_token", valid_581358
  var valid_581359 = query.getOrDefault("alt")
  valid_581359 = validateParameter(valid_581359, JString, required = false,
                                 default = newJString("json"))
  if valid_581359 != nil:
    section.add "alt", valid_581359
  var valid_581360 = query.getOrDefault("userIp")
  valid_581360 = validateParameter(valid_581360, JString, required = false,
                                 default = nil)
  if valid_581360 != nil:
    section.add "userIp", valid_581360
  var valid_581361 = query.getOrDefault("quotaUser")
  valid_581361 = validateParameter(valid_581361, JString, required = false,
                                 default = nil)
  if valid_581361 != nil:
    section.add "quotaUser", valid_581361
  var valid_581362 = query.getOrDefault("pageToken")
  valid_581362 = validateParameter(valid_581362, JString, required = false,
                                 default = nil)
  if valid_581362 != nil:
    section.add "pageToken", valid_581362
  var valid_581363 = query.getOrDefault("fields")
  valid_581363 = validateParameter(valid_581363, JString, required = false,
                                 default = nil)
  if valid_581363 != nil:
    section.add "fields", valid_581363
  var valid_581364 = query.getOrDefault("maxResults")
  valid_581364 = validateParameter(valid_581364, JInt, required = false, default = nil)
  if valid_581364 != nil:
    section.add "maxResults", valid_581364
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581365: Call_ContentShippingsettingsList_581352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the shipping settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_581365.validator(path, query, header, formData, body)
  let scheme = call_581365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581365.url(scheme.get, call_581365.host, call_581365.base,
                         call_581365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581365, url, valid)

proc call*(call_581366: Call_ContentShippingsettingsList_581352;
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
  var path_581367 = newJObject()
  var query_581368 = newJObject()
  add(query_581368, "key", newJString(key))
  add(query_581368, "prettyPrint", newJBool(prettyPrint))
  add(query_581368, "oauth_token", newJString(oauthToken))
  add(query_581368, "alt", newJString(alt))
  add(query_581368, "userIp", newJString(userIp))
  add(query_581368, "quotaUser", newJString(quotaUser))
  add(path_581367, "merchantId", newJString(merchantId))
  add(query_581368, "pageToken", newJString(pageToken))
  add(query_581368, "fields", newJString(fields))
  add(query_581368, "maxResults", newJInt(maxResults))
  result = call_581366.call(path_581367, query_581368, nil, nil, nil)

var contentShippingsettingsList* = Call_ContentShippingsettingsList_581352(
    name: "contentShippingsettingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/shippingsettings",
    validator: validate_ContentShippingsettingsList_581353, base: "/content/v2.1",
    url: url_ContentShippingsettingsList_581354, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsUpdate_581385 = ref object of OpenApiRestCall_579373
proc url_ContentShippingsettingsUpdate_581387(protocol: Scheme; host: string;
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

proc validate_ContentShippingsettingsUpdate_581386(path: JsonNode; query: JsonNode;
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
  var valid_581388 = path.getOrDefault("merchantId")
  valid_581388 = validateParameter(valid_581388, JString, required = true,
                                 default = nil)
  if valid_581388 != nil:
    section.add "merchantId", valid_581388
  var valid_581389 = path.getOrDefault("accountId")
  valid_581389 = validateParameter(valid_581389, JString, required = true,
                                 default = nil)
  if valid_581389 != nil:
    section.add "accountId", valid_581389
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
  var valid_581390 = query.getOrDefault("key")
  valid_581390 = validateParameter(valid_581390, JString, required = false,
                                 default = nil)
  if valid_581390 != nil:
    section.add "key", valid_581390
  var valid_581391 = query.getOrDefault("prettyPrint")
  valid_581391 = validateParameter(valid_581391, JBool, required = false,
                                 default = newJBool(true))
  if valid_581391 != nil:
    section.add "prettyPrint", valid_581391
  var valid_581392 = query.getOrDefault("oauth_token")
  valid_581392 = validateParameter(valid_581392, JString, required = false,
                                 default = nil)
  if valid_581392 != nil:
    section.add "oauth_token", valid_581392
  var valid_581393 = query.getOrDefault("alt")
  valid_581393 = validateParameter(valid_581393, JString, required = false,
                                 default = newJString("json"))
  if valid_581393 != nil:
    section.add "alt", valid_581393
  var valid_581394 = query.getOrDefault("userIp")
  valid_581394 = validateParameter(valid_581394, JString, required = false,
                                 default = nil)
  if valid_581394 != nil:
    section.add "userIp", valid_581394
  var valid_581395 = query.getOrDefault("quotaUser")
  valid_581395 = validateParameter(valid_581395, JString, required = false,
                                 default = nil)
  if valid_581395 != nil:
    section.add "quotaUser", valid_581395
  var valid_581396 = query.getOrDefault("fields")
  valid_581396 = validateParameter(valid_581396, JString, required = false,
                                 default = nil)
  if valid_581396 != nil:
    section.add "fields", valid_581396
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_581398: Call_ContentShippingsettingsUpdate_581385; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the shipping settings of the account.
  ## 
  let valid = call_581398.validator(path, query, header, formData, body)
  let scheme = call_581398.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581398.url(scheme.get, call_581398.host, call_581398.base,
                         call_581398.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581398, url, valid)

proc call*(call_581399: Call_ContentShippingsettingsUpdate_581385;
          merchantId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
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
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The ID of the account for which to get/update shipping settings.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581400 = newJObject()
  var query_581401 = newJObject()
  var body_581402 = newJObject()
  add(query_581401, "key", newJString(key))
  add(query_581401, "prettyPrint", newJBool(prettyPrint))
  add(query_581401, "oauth_token", newJString(oauthToken))
  add(query_581401, "alt", newJString(alt))
  add(query_581401, "userIp", newJString(userIp))
  add(query_581401, "quotaUser", newJString(quotaUser))
  add(path_581400, "merchantId", newJString(merchantId))
  if body != nil:
    body_581402 = body
  add(path_581400, "accountId", newJString(accountId))
  add(query_581401, "fields", newJString(fields))
  result = call_581399.call(path_581400, query_581401, nil, nil, body_581402)

var contentShippingsettingsUpdate* = Call_ContentShippingsettingsUpdate_581385(
    name: "contentShippingsettingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{merchantId}/shippingsettings/{accountId}",
    validator: validate_ContentShippingsettingsUpdate_581386,
    base: "/content/v2.1", url: url_ContentShippingsettingsUpdate_581387,
    schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGet_581369 = ref object of OpenApiRestCall_579373
proc url_ContentShippingsettingsGet_581371(protocol: Scheme; host: string;
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

proc validate_ContentShippingsettingsGet_581370(path: JsonNode; query: JsonNode;
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
  var valid_581372 = path.getOrDefault("merchantId")
  valid_581372 = validateParameter(valid_581372, JString, required = true,
                                 default = nil)
  if valid_581372 != nil:
    section.add "merchantId", valid_581372
  var valid_581373 = path.getOrDefault("accountId")
  valid_581373 = validateParameter(valid_581373, JString, required = true,
                                 default = nil)
  if valid_581373 != nil:
    section.add "accountId", valid_581373
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
  var valid_581374 = query.getOrDefault("key")
  valid_581374 = validateParameter(valid_581374, JString, required = false,
                                 default = nil)
  if valid_581374 != nil:
    section.add "key", valid_581374
  var valid_581375 = query.getOrDefault("prettyPrint")
  valid_581375 = validateParameter(valid_581375, JBool, required = false,
                                 default = newJBool(true))
  if valid_581375 != nil:
    section.add "prettyPrint", valid_581375
  var valid_581376 = query.getOrDefault("oauth_token")
  valid_581376 = validateParameter(valid_581376, JString, required = false,
                                 default = nil)
  if valid_581376 != nil:
    section.add "oauth_token", valid_581376
  var valid_581377 = query.getOrDefault("alt")
  valid_581377 = validateParameter(valid_581377, JString, required = false,
                                 default = newJString("json"))
  if valid_581377 != nil:
    section.add "alt", valid_581377
  var valid_581378 = query.getOrDefault("userIp")
  valid_581378 = validateParameter(valid_581378, JString, required = false,
                                 default = nil)
  if valid_581378 != nil:
    section.add "userIp", valid_581378
  var valid_581379 = query.getOrDefault("quotaUser")
  valid_581379 = validateParameter(valid_581379, JString, required = false,
                                 default = nil)
  if valid_581379 != nil:
    section.add "quotaUser", valid_581379
  var valid_581380 = query.getOrDefault("fields")
  valid_581380 = validateParameter(valid_581380, JString, required = false,
                                 default = nil)
  if valid_581380 != nil:
    section.add "fields", valid_581380
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581381: Call_ContentShippingsettingsGet_581369; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the shipping settings of the account.
  ## 
  let valid = call_581381.validator(path, query, header, formData, body)
  let scheme = call_581381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581381.url(scheme.get, call_581381.host, call_581381.base,
                         call_581381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581381, url, valid)

proc call*(call_581382: Call_ContentShippingsettingsGet_581369; merchantId: string;
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
  var path_581383 = newJObject()
  var query_581384 = newJObject()
  add(query_581384, "key", newJString(key))
  add(query_581384, "prettyPrint", newJBool(prettyPrint))
  add(query_581384, "oauth_token", newJString(oauthToken))
  add(query_581384, "alt", newJString(alt))
  add(query_581384, "userIp", newJString(userIp))
  add(query_581384, "quotaUser", newJString(quotaUser))
  add(path_581383, "merchantId", newJString(merchantId))
  add(path_581383, "accountId", newJString(accountId))
  add(query_581384, "fields", newJString(fields))
  result = call_581382.call(path_581383, query_581384, nil, nil, nil)

var contentShippingsettingsGet* = Call_ContentShippingsettingsGet_581369(
    name: "contentShippingsettingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/shippingsettings/{accountId}",
    validator: validate_ContentShippingsettingsGet_581370, base: "/content/v2.1",
    url: url_ContentShippingsettingsGet_581371, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGetsupportedcarriers_581403 = ref object of OpenApiRestCall_579373
proc url_ContentShippingsettingsGetsupportedcarriers_581405(protocol: Scheme;
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

proc validate_ContentShippingsettingsGetsupportedcarriers_581404(path: JsonNode;
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
  var valid_581406 = path.getOrDefault("merchantId")
  valid_581406 = validateParameter(valid_581406, JString, required = true,
                                 default = nil)
  if valid_581406 != nil:
    section.add "merchantId", valid_581406
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
  var valid_581413 = query.getOrDefault("fields")
  valid_581413 = validateParameter(valid_581413, JString, required = false,
                                 default = nil)
  if valid_581413 != nil:
    section.add "fields", valid_581413
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581414: Call_ContentShippingsettingsGetsupportedcarriers_581403;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves supported carriers and carrier services for an account.
  ## 
  let valid = call_581414.validator(path, query, header, formData, body)
  let scheme = call_581414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581414.url(scheme.get, call_581414.host, call_581414.base,
                         call_581414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581414, url, valid)

proc call*(call_581415: Call_ContentShippingsettingsGetsupportedcarriers_581403;
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
  var path_581416 = newJObject()
  var query_581417 = newJObject()
  add(query_581417, "key", newJString(key))
  add(query_581417, "prettyPrint", newJBool(prettyPrint))
  add(query_581417, "oauth_token", newJString(oauthToken))
  add(query_581417, "alt", newJString(alt))
  add(query_581417, "userIp", newJString(userIp))
  add(query_581417, "quotaUser", newJString(quotaUser))
  add(path_581416, "merchantId", newJString(merchantId))
  add(query_581417, "fields", newJString(fields))
  result = call_581415.call(path_581416, query_581417, nil, nil, nil)

var contentShippingsettingsGetsupportedcarriers* = Call_ContentShippingsettingsGetsupportedcarriers_581403(
    name: "contentShippingsettingsGetsupportedcarriers", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/supportedCarriers",
    validator: validate_ContentShippingsettingsGetsupportedcarriers_581404,
    base: "/content/v2.1", url: url_ContentShippingsettingsGetsupportedcarriers_581405,
    schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGetsupportedholidays_581418 = ref object of OpenApiRestCall_579373
proc url_ContentShippingsettingsGetsupportedholidays_581420(protocol: Scheme;
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

proc validate_ContentShippingsettingsGetsupportedholidays_581419(path: JsonNode;
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
  var valid_581421 = path.getOrDefault("merchantId")
  valid_581421 = validateParameter(valid_581421, JString, required = true,
                                 default = nil)
  if valid_581421 != nil:
    section.add "merchantId", valid_581421
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
  var valid_581422 = query.getOrDefault("key")
  valid_581422 = validateParameter(valid_581422, JString, required = false,
                                 default = nil)
  if valid_581422 != nil:
    section.add "key", valid_581422
  var valid_581423 = query.getOrDefault("prettyPrint")
  valid_581423 = validateParameter(valid_581423, JBool, required = false,
                                 default = newJBool(true))
  if valid_581423 != nil:
    section.add "prettyPrint", valid_581423
  var valid_581424 = query.getOrDefault("oauth_token")
  valid_581424 = validateParameter(valid_581424, JString, required = false,
                                 default = nil)
  if valid_581424 != nil:
    section.add "oauth_token", valid_581424
  var valid_581425 = query.getOrDefault("alt")
  valid_581425 = validateParameter(valid_581425, JString, required = false,
                                 default = newJString("json"))
  if valid_581425 != nil:
    section.add "alt", valid_581425
  var valid_581426 = query.getOrDefault("userIp")
  valid_581426 = validateParameter(valid_581426, JString, required = false,
                                 default = nil)
  if valid_581426 != nil:
    section.add "userIp", valid_581426
  var valid_581427 = query.getOrDefault("quotaUser")
  valid_581427 = validateParameter(valid_581427, JString, required = false,
                                 default = nil)
  if valid_581427 != nil:
    section.add "quotaUser", valid_581427
  var valid_581428 = query.getOrDefault("fields")
  valid_581428 = validateParameter(valid_581428, JString, required = false,
                                 default = nil)
  if valid_581428 != nil:
    section.add "fields", valid_581428
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581429: Call_ContentShippingsettingsGetsupportedholidays_581418;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves supported holidays for an account.
  ## 
  let valid = call_581429.validator(path, query, header, formData, body)
  let scheme = call_581429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581429.url(scheme.get, call_581429.host, call_581429.base,
                         call_581429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581429, url, valid)

proc call*(call_581430: Call_ContentShippingsettingsGetsupportedholidays_581418;
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
  var path_581431 = newJObject()
  var query_581432 = newJObject()
  add(query_581432, "key", newJString(key))
  add(query_581432, "prettyPrint", newJBool(prettyPrint))
  add(query_581432, "oauth_token", newJString(oauthToken))
  add(query_581432, "alt", newJString(alt))
  add(query_581432, "userIp", newJString(userIp))
  add(query_581432, "quotaUser", newJString(quotaUser))
  add(path_581431, "merchantId", newJString(merchantId))
  add(query_581432, "fields", newJString(fields))
  result = call_581430.call(path_581431, query_581432, nil, nil, nil)

var contentShippingsettingsGetsupportedholidays* = Call_ContentShippingsettingsGetsupportedholidays_581418(
    name: "contentShippingsettingsGetsupportedholidays", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/supportedHolidays",
    validator: validate_ContentShippingsettingsGetsupportedholidays_581419,
    base: "/content/v2.1", url: url_ContentShippingsettingsGetsupportedholidays_581420,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersCreatetestorder_581433 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersCreatetestorder_581435(protocol: Scheme; host: string;
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

proc validate_ContentOrdersCreatetestorder_581434(path: JsonNode; query: JsonNode;
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
  var valid_581436 = path.getOrDefault("merchantId")
  valid_581436 = validateParameter(valid_581436, JString, required = true,
                                 default = nil)
  if valid_581436 != nil:
    section.add "merchantId", valid_581436
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
  var valid_581439 = query.getOrDefault("oauth_token")
  valid_581439 = validateParameter(valid_581439, JString, required = false,
                                 default = nil)
  if valid_581439 != nil:
    section.add "oauth_token", valid_581439
  var valid_581440 = query.getOrDefault("alt")
  valid_581440 = validateParameter(valid_581440, JString, required = false,
                                 default = newJString("json"))
  if valid_581440 != nil:
    section.add "alt", valid_581440
  var valid_581441 = query.getOrDefault("userIp")
  valid_581441 = validateParameter(valid_581441, JString, required = false,
                                 default = nil)
  if valid_581441 != nil:
    section.add "userIp", valid_581441
  var valid_581442 = query.getOrDefault("quotaUser")
  valid_581442 = validateParameter(valid_581442, JString, required = false,
                                 default = nil)
  if valid_581442 != nil:
    section.add "quotaUser", valid_581442
  var valid_581443 = query.getOrDefault("fields")
  valid_581443 = validateParameter(valid_581443, JString, required = false,
                                 default = nil)
  if valid_581443 != nil:
    section.add "fields", valid_581443
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_581445: Call_ContentOrdersCreatetestorder_581433; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Creates a test order.
  ## 
  let valid = call_581445.validator(path, query, header, formData, body)
  let scheme = call_581445.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581445.url(scheme.get, call_581445.host, call_581445.base,
                         call_581445.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581445, url, valid)

proc call*(call_581446: Call_ContentOrdersCreatetestorder_581433;
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
  var path_581447 = newJObject()
  var query_581448 = newJObject()
  var body_581449 = newJObject()
  add(query_581448, "key", newJString(key))
  add(query_581448, "prettyPrint", newJBool(prettyPrint))
  add(query_581448, "oauth_token", newJString(oauthToken))
  add(query_581448, "alt", newJString(alt))
  add(query_581448, "userIp", newJString(userIp))
  add(query_581448, "quotaUser", newJString(quotaUser))
  add(path_581447, "merchantId", newJString(merchantId))
  if body != nil:
    body_581449 = body
  add(query_581448, "fields", newJString(fields))
  result = call_581446.call(path_581447, query_581448, nil, nil, body_581449)

var contentOrdersCreatetestorder* = Call_ContentOrdersCreatetestorder_581433(
    name: "contentOrdersCreatetestorder", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/testorders",
    validator: validate_ContentOrdersCreatetestorder_581434,
    base: "/content/v2.1", url: url_ContentOrdersCreatetestorder_581435,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersAdvancetestorder_581450 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersAdvancetestorder_581452(protocol: Scheme; host: string;
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

proc validate_ContentOrdersAdvancetestorder_581451(path: JsonNode; query: JsonNode;
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
  var valid_581453 = path.getOrDefault("merchantId")
  valid_581453 = validateParameter(valid_581453, JString, required = true,
                                 default = nil)
  if valid_581453 != nil:
    section.add "merchantId", valid_581453
  var valid_581454 = path.getOrDefault("orderId")
  valid_581454 = validateParameter(valid_581454, JString, required = true,
                                 default = nil)
  if valid_581454 != nil:
    section.add "orderId", valid_581454
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
  var valid_581455 = query.getOrDefault("key")
  valid_581455 = validateParameter(valid_581455, JString, required = false,
                                 default = nil)
  if valid_581455 != nil:
    section.add "key", valid_581455
  var valid_581456 = query.getOrDefault("prettyPrint")
  valid_581456 = validateParameter(valid_581456, JBool, required = false,
                                 default = newJBool(true))
  if valid_581456 != nil:
    section.add "prettyPrint", valid_581456
  var valid_581457 = query.getOrDefault("oauth_token")
  valid_581457 = validateParameter(valid_581457, JString, required = false,
                                 default = nil)
  if valid_581457 != nil:
    section.add "oauth_token", valid_581457
  var valid_581458 = query.getOrDefault("alt")
  valid_581458 = validateParameter(valid_581458, JString, required = false,
                                 default = newJString("json"))
  if valid_581458 != nil:
    section.add "alt", valid_581458
  var valid_581459 = query.getOrDefault("userIp")
  valid_581459 = validateParameter(valid_581459, JString, required = false,
                                 default = nil)
  if valid_581459 != nil:
    section.add "userIp", valid_581459
  var valid_581460 = query.getOrDefault("quotaUser")
  valid_581460 = validateParameter(valid_581460, JString, required = false,
                                 default = nil)
  if valid_581460 != nil:
    section.add "quotaUser", valid_581460
  var valid_581461 = query.getOrDefault("fields")
  valid_581461 = validateParameter(valid_581461, JString, required = false,
                                 default = nil)
  if valid_581461 != nil:
    section.add "fields", valid_581461
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581462: Call_ContentOrdersAdvancetestorder_581450; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Moves a test order from state "inProgress" to state "pendingShipment".
  ## 
  let valid = call_581462.validator(path, query, header, formData, body)
  let scheme = call_581462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581462.url(scheme.get, call_581462.host, call_581462.base,
                         call_581462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581462, url, valid)

proc call*(call_581463: Call_ContentOrdersAdvancetestorder_581450;
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
  var path_581464 = newJObject()
  var query_581465 = newJObject()
  add(query_581465, "key", newJString(key))
  add(query_581465, "prettyPrint", newJBool(prettyPrint))
  add(query_581465, "oauth_token", newJString(oauthToken))
  add(query_581465, "alt", newJString(alt))
  add(query_581465, "userIp", newJString(userIp))
  add(query_581465, "quotaUser", newJString(quotaUser))
  add(path_581464, "merchantId", newJString(merchantId))
  add(query_581465, "fields", newJString(fields))
  add(path_581464, "orderId", newJString(orderId))
  result = call_581463.call(path_581464, query_581465, nil, nil, nil)

var contentOrdersAdvancetestorder* = Call_ContentOrdersAdvancetestorder_581450(
    name: "contentOrdersAdvancetestorder", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/testorders/{orderId}/advance",
    validator: validate_ContentOrdersAdvancetestorder_581451,
    base: "/content/v2.1", url: url_ContentOrdersAdvancetestorder_581452,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersCanceltestorderbycustomer_581466 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersCanceltestorderbycustomer_581468(protocol: Scheme;
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

proc validate_ContentOrdersCanceltestorderbycustomer_581467(path: JsonNode;
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
  var valid_581469 = path.getOrDefault("merchantId")
  valid_581469 = validateParameter(valid_581469, JString, required = true,
                                 default = nil)
  if valid_581469 != nil:
    section.add "merchantId", valid_581469
  var valid_581470 = path.getOrDefault("orderId")
  valid_581470 = validateParameter(valid_581470, JString, required = true,
                                 default = nil)
  if valid_581470 != nil:
    section.add "orderId", valid_581470
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
  var valid_581471 = query.getOrDefault("key")
  valid_581471 = validateParameter(valid_581471, JString, required = false,
                                 default = nil)
  if valid_581471 != nil:
    section.add "key", valid_581471
  var valid_581472 = query.getOrDefault("prettyPrint")
  valid_581472 = validateParameter(valid_581472, JBool, required = false,
                                 default = newJBool(true))
  if valid_581472 != nil:
    section.add "prettyPrint", valid_581472
  var valid_581473 = query.getOrDefault("oauth_token")
  valid_581473 = validateParameter(valid_581473, JString, required = false,
                                 default = nil)
  if valid_581473 != nil:
    section.add "oauth_token", valid_581473
  var valid_581474 = query.getOrDefault("alt")
  valid_581474 = validateParameter(valid_581474, JString, required = false,
                                 default = newJString("json"))
  if valid_581474 != nil:
    section.add "alt", valid_581474
  var valid_581475 = query.getOrDefault("userIp")
  valid_581475 = validateParameter(valid_581475, JString, required = false,
                                 default = nil)
  if valid_581475 != nil:
    section.add "userIp", valid_581475
  var valid_581476 = query.getOrDefault("quotaUser")
  valid_581476 = validateParameter(valid_581476, JString, required = false,
                                 default = nil)
  if valid_581476 != nil:
    section.add "quotaUser", valid_581476
  var valid_581477 = query.getOrDefault("fields")
  valid_581477 = validateParameter(valid_581477, JString, required = false,
                                 default = nil)
  if valid_581477 != nil:
    section.add "fields", valid_581477
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_581479: Call_ContentOrdersCanceltestorderbycustomer_581466;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sandbox only. Cancels a test order for customer-initiated cancellation.
  ## 
  let valid = call_581479.validator(path, query, header, formData, body)
  let scheme = call_581479.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581479.url(scheme.get, call_581479.host, call_581479.base,
                         call_581479.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581479, url, valid)

proc call*(call_581480: Call_ContentOrdersCanceltestorderbycustomer_581466;
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
  var path_581481 = newJObject()
  var query_581482 = newJObject()
  var body_581483 = newJObject()
  add(query_581482, "key", newJString(key))
  add(query_581482, "prettyPrint", newJBool(prettyPrint))
  add(query_581482, "oauth_token", newJString(oauthToken))
  add(query_581482, "alt", newJString(alt))
  add(query_581482, "userIp", newJString(userIp))
  add(query_581482, "quotaUser", newJString(quotaUser))
  add(path_581481, "merchantId", newJString(merchantId))
  if body != nil:
    body_581483 = body
  add(query_581482, "fields", newJString(fields))
  add(path_581481, "orderId", newJString(orderId))
  result = call_581480.call(path_581481, query_581482, nil, nil, body_581483)

var contentOrdersCanceltestorderbycustomer* = Call_ContentOrdersCanceltestorderbycustomer_581466(
    name: "contentOrdersCanceltestorderbycustomer", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/testorders/{orderId}/cancelByCustomer",
    validator: validate_ContentOrdersCanceltestorderbycustomer_581467,
    base: "/content/v2.1", url: url_ContentOrdersCanceltestorderbycustomer_581468,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersGettestordertemplate_581484 = ref object of OpenApiRestCall_579373
proc url_ContentOrdersGettestordertemplate_581486(protocol: Scheme; host: string;
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

proc validate_ContentOrdersGettestordertemplate_581485(path: JsonNode;
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
  var valid_581487 = path.getOrDefault("merchantId")
  valid_581487 = validateParameter(valid_581487, JString, required = true,
                                 default = nil)
  if valid_581487 != nil:
    section.add "merchantId", valid_581487
  var valid_581488 = path.getOrDefault("templateName")
  valid_581488 = validateParameter(valid_581488, JString, required = true,
                                 default = newJString("template1"))
  if valid_581488 != nil:
    section.add "templateName", valid_581488
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
  var valid_581489 = query.getOrDefault("key")
  valid_581489 = validateParameter(valid_581489, JString, required = false,
                                 default = nil)
  if valid_581489 != nil:
    section.add "key", valid_581489
  var valid_581490 = query.getOrDefault("prettyPrint")
  valid_581490 = validateParameter(valid_581490, JBool, required = false,
                                 default = newJBool(true))
  if valid_581490 != nil:
    section.add "prettyPrint", valid_581490
  var valid_581491 = query.getOrDefault("oauth_token")
  valid_581491 = validateParameter(valid_581491, JString, required = false,
                                 default = nil)
  if valid_581491 != nil:
    section.add "oauth_token", valid_581491
  var valid_581492 = query.getOrDefault("alt")
  valid_581492 = validateParameter(valid_581492, JString, required = false,
                                 default = newJString("json"))
  if valid_581492 != nil:
    section.add "alt", valid_581492
  var valid_581493 = query.getOrDefault("userIp")
  valid_581493 = validateParameter(valid_581493, JString, required = false,
                                 default = nil)
  if valid_581493 != nil:
    section.add "userIp", valid_581493
  var valid_581494 = query.getOrDefault("quotaUser")
  valid_581494 = validateParameter(valid_581494, JString, required = false,
                                 default = nil)
  if valid_581494 != nil:
    section.add "quotaUser", valid_581494
  var valid_581495 = query.getOrDefault("country")
  valid_581495 = validateParameter(valid_581495, JString, required = false,
                                 default = nil)
  if valid_581495 != nil:
    section.add "country", valid_581495
  var valid_581496 = query.getOrDefault("fields")
  valid_581496 = validateParameter(valid_581496, JString, required = false,
                                 default = nil)
  if valid_581496 != nil:
    section.add "fields", valid_581496
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581497: Call_ContentOrdersGettestordertemplate_581484;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sandbox only. Retrieves an order template that can be used to quickly create a new order in sandbox.
  ## 
  let valid = call_581497.validator(path, query, header, formData, body)
  let scheme = call_581497.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581497.url(scheme.get, call_581497.host, call_581497.base,
                         call_581497.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581497, url, valid)

proc call*(call_581498: Call_ContentOrdersGettestordertemplate_581484;
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
  var path_581499 = newJObject()
  var query_581500 = newJObject()
  add(query_581500, "key", newJString(key))
  add(query_581500, "prettyPrint", newJBool(prettyPrint))
  add(query_581500, "oauth_token", newJString(oauthToken))
  add(query_581500, "alt", newJString(alt))
  add(query_581500, "userIp", newJString(userIp))
  add(query_581500, "quotaUser", newJString(quotaUser))
  add(path_581499, "merchantId", newJString(merchantId))
  add(query_581500, "country", newJString(country))
  add(path_581499, "templateName", newJString(templateName))
  add(query_581500, "fields", newJString(fields))
  result = call_581498.call(path_581499, query_581500, nil, nil, nil)

var contentOrdersGettestordertemplate* = Call_ContentOrdersGettestordertemplate_581484(
    name: "contentOrdersGettestordertemplate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/testordertemplates/{templateName}",
    validator: validate_ContentOrdersGettestordertemplate_581485,
    base: "/content/v2.1", url: url_ContentOrdersGettestordertemplate_581486,
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
