
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

  OpenApiRestCall_578348 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578348](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578348): Option[Scheme] {.used.} =
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
  Call_ContentAccountsAuthinfo_578618 = ref object of OpenApiRestCall_578348
proc url_ContentAccountsAuthinfo_578620(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentAccountsAuthinfo_578619(path: JsonNode; query: JsonNode;
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
  var valid_578732 = query.getOrDefault("key")
  valid_578732 = validateParameter(valid_578732, JString, required = false,
                                 default = nil)
  if valid_578732 != nil:
    section.add "key", valid_578732
  var valid_578746 = query.getOrDefault("prettyPrint")
  valid_578746 = validateParameter(valid_578746, JBool, required = false,
                                 default = newJBool(true))
  if valid_578746 != nil:
    section.add "prettyPrint", valid_578746
  var valid_578747 = query.getOrDefault("oauth_token")
  valid_578747 = validateParameter(valid_578747, JString, required = false,
                                 default = nil)
  if valid_578747 != nil:
    section.add "oauth_token", valid_578747
  var valid_578748 = query.getOrDefault("alt")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = newJString("json"))
  if valid_578748 != nil:
    section.add "alt", valid_578748
  var valid_578749 = query.getOrDefault("userIp")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = nil)
  if valid_578749 != nil:
    section.add "userIp", valid_578749
  var valid_578750 = query.getOrDefault("quotaUser")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = nil)
  if valid_578750 != nil:
    section.add "quotaUser", valid_578750
  var valid_578751 = query.getOrDefault("fields")
  valid_578751 = validateParameter(valid_578751, JString, required = false,
                                 default = nil)
  if valid_578751 != nil:
    section.add "fields", valid_578751
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578774: Call_ContentAccountsAuthinfo_578618; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about the authenticated user.
  ## 
  let valid = call_578774.validator(path, query, header, formData, body)
  let scheme = call_578774.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578774.url(scheme.get, call_578774.host, call_578774.base,
                         call_578774.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578774, url, valid)

proc call*(call_578845: Call_ContentAccountsAuthinfo_578618; key: string = "";
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
  var query_578846 = newJObject()
  add(query_578846, "key", newJString(key))
  add(query_578846, "prettyPrint", newJBool(prettyPrint))
  add(query_578846, "oauth_token", newJString(oauthToken))
  add(query_578846, "alt", newJString(alt))
  add(query_578846, "userIp", newJString(userIp))
  add(query_578846, "quotaUser", newJString(quotaUser))
  add(query_578846, "fields", newJString(fields))
  result = call_578845.call(nil, query_578846, nil, nil, nil)

var contentAccountsAuthinfo* = Call_ContentAccountsAuthinfo_578618(
    name: "contentAccountsAuthinfo", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/authinfo",
    validator: validate_ContentAccountsAuthinfo_578619, base: "/content/v2",
    url: url_ContentAccountsAuthinfo_578620, schemes: {Scheme.Https})
type
  Call_ContentAccountsCustombatch_578886 = ref object of OpenApiRestCall_578348
proc url_ContentAccountsCustombatch_578888(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentAccountsCustombatch_578887(path: JsonNode; query: JsonNode;
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
  var valid_578889 = query.getOrDefault("key")
  valid_578889 = validateParameter(valid_578889, JString, required = false,
                                 default = nil)
  if valid_578889 != nil:
    section.add "key", valid_578889
  var valid_578890 = query.getOrDefault("prettyPrint")
  valid_578890 = validateParameter(valid_578890, JBool, required = false,
                                 default = newJBool(true))
  if valid_578890 != nil:
    section.add "prettyPrint", valid_578890
  var valid_578891 = query.getOrDefault("oauth_token")
  valid_578891 = validateParameter(valid_578891, JString, required = false,
                                 default = nil)
  if valid_578891 != nil:
    section.add "oauth_token", valid_578891
  var valid_578892 = query.getOrDefault("alt")
  valid_578892 = validateParameter(valid_578892, JString, required = false,
                                 default = newJString("json"))
  if valid_578892 != nil:
    section.add "alt", valid_578892
  var valid_578893 = query.getOrDefault("userIp")
  valid_578893 = validateParameter(valid_578893, JString, required = false,
                                 default = nil)
  if valid_578893 != nil:
    section.add "userIp", valid_578893
  var valid_578894 = query.getOrDefault("quotaUser")
  valid_578894 = validateParameter(valid_578894, JString, required = false,
                                 default = nil)
  if valid_578894 != nil:
    section.add "quotaUser", valid_578894
  var valid_578895 = query.getOrDefault("dryRun")
  valid_578895 = validateParameter(valid_578895, JBool, required = false, default = nil)
  if valid_578895 != nil:
    section.add "dryRun", valid_578895
  var valid_578896 = query.getOrDefault("fields")
  valid_578896 = validateParameter(valid_578896, JString, required = false,
                                 default = nil)
  if valid_578896 != nil:
    section.add "fields", valid_578896
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578898: Call_ContentAccountsCustombatch_578886; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves, inserts, updates, and deletes multiple Merchant Center (sub-)accounts in a single request.
  ## 
  let valid = call_578898.validator(path, query, header, formData, body)
  let scheme = call_578898.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578898.url(scheme.get, call_578898.host, call_578898.base,
                         call_578898.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578898, url, valid)

proc call*(call_578899: Call_ContentAccountsCustombatch_578886; key: string = "";
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
  var query_578900 = newJObject()
  var body_578901 = newJObject()
  add(query_578900, "key", newJString(key))
  add(query_578900, "prettyPrint", newJBool(prettyPrint))
  add(query_578900, "oauth_token", newJString(oauthToken))
  add(query_578900, "alt", newJString(alt))
  add(query_578900, "userIp", newJString(userIp))
  add(query_578900, "quotaUser", newJString(quotaUser))
  add(query_578900, "dryRun", newJBool(dryRun))
  if body != nil:
    body_578901 = body
  add(query_578900, "fields", newJString(fields))
  result = call_578899.call(nil, query_578900, nil, nil, body_578901)

var contentAccountsCustombatch* = Call_ContentAccountsCustombatch_578886(
    name: "contentAccountsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accounts/batch",
    validator: validate_ContentAccountsCustombatch_578887, base: "/content/v2",
    url: url_ContentAccountsCustombatch_578888, schemes: {Scheme.Https})
type
  Call_ContentAccountstatusesCustombatch_578902 = ref object of OpenApiRestCall_578348
proc url_ContentAccountstatusesCustombatch_578904(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentAccountstatusesCustombatch_578903(path: JsonNode;
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
  var valid_578905 = query.getOrDefault("key")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = nil)
  if valid_578905 != nil:
    section.add "key", valid_578905
  var valid_578906 = query.getOrDefault("prettyPrint")
  valid_578906 = validateParameter(valid_578906, JBool, required = false,
                                 default = newJBool(true))
  if valid_578906 != nil:
    section.add "prettyPrint", valid_578906
  var valid_578907 = query.getOrDefault("oauth_token")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "oauth_token", valid_578907
  var valid_578908 = query.getOrDefault("alt")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = newJString("json"))
  if valid_578908 != nil:
    section.add "alt", valid_578908
  var valid_578909 = query.getOrDefault("userIp")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "userIp", valid_578909
  var valid_578910 = query.getOrDefault("quotaUser")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "quotaUser", valid_578910
  var valid_578911 = query.getOrDefault("fields")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "fields", valid_578911
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578913: Call_ContentAccountstatusesCustombatch_578902;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves multiple Merchant Center account statuses in a single request.
  ## 
  let valid = call_578913.validator(path, query, header, formData, body)
  let scheme = call_578913.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578913.url(scheme.get, call_578913.host, call_578913.base,
                         call_578913.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578913, url, valid)

proc call*(call_578914: Call_ContentAccountstatusesCustombatch_578902;
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
  var query_578915 = newJObject()
  var body_578916 = newJObject()
  add(query_578915, "key", newJString(key))
  add(query_578915, "prettyPrint", newJBool(prettyPrint))
  add(query_578915, "oauth_token", newJString(oauthToken))
  add(query_578915, "alt", newJString(alt))
  add(query_578915, "userIp", newJString(userIp))
  add(query_578915, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578916 = body
  add(query_578915, "fields", newJString(fields))
  result = call_578914.call(nil, query_578915, nil, nil, body_578916)

var contentAccountstatusesCustombatch* = Call_ContentAccountstatusesCustombatch_578902(
    name: "contentAccountstatusesCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accountstatuses/batch",
    validator: validate_ContentAccountstatusesCustombatch_578903,
    base: "/content/v2", url: url_ContentAccountstatusesCustombatch_578904,
    schemes: {Scheme.Https})
type
  Call_ContentAccounttaxCustombatch_578917 = ref object of OpenApiRestCall_578348
proc url_ContentAccounttaxCustombatch_578919(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentAccounttaxCustombatch_578918(path: JsonNode; query: JsonNode;
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
  var valid_578920 = query.getOrDefault("key")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "key", valid_578920
  var valid_578921 = query.getOrDefault("prettyPrint")
  valid_578921 = validateParameter(valid_578921, JBool, required = false,
                                 default = newJBool(true))
  if valid_578921 != nil:
    section.add "prettyPrint", valid_578921
  var valid_578922 = query.getOrDefault("oauth_token")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "oauth_token", valid_578922
  var valid_578923 = query.getOrDefault("alt")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = newJString("json"))
  if valid_578923 != nil:
    section.add "alt", valid_578923
  var valid_578924 = query.getOrDefault("userIp")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "userIp", valid_578924
  var valid_578925 = query.getOrDefault("quotaUser")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "quotaUser", valid_578925
  var valid_578926 = query.getOrDefault("dryRun")
  valid_578926 = validateParameter(valid_578926, JBool, required = false, default = nil)
  if valid_578926 != nil:
    section.add "dryRun", valid_578926
  var valid_578927 = query.getOrDefault("fields")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "fields", valid_578927
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578929: Call_ContentAccounttaxCustombatch_578917; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves and updates tax settings of multiple accounts in a single request.
  ## 
  let valid = call_578929.validator(path, query, header, formData, body)
  let scheme = call_578929.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578929.url(scheme.get, call_578929.host, call_578929.base,
                         call_578929.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578929, url, valid)

proc call*(call_578930: Call_ContentAccounttaxCustombatch_578917; key: string = "";
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
  var query_578931 = newJObject()
  var body_578932 = newJObject()
  add(query_578931, "key", newJString(key))
  add(query_578931, "prettyPrint", newJBool(prettyPrint))
  add(query_578931, "oauth_token", newJString(oauthToken))
  add(query_578931, "alt", newJString(alt))
  add(query_578931, "userIp", newJString(userIp))
  add(query_578931, "quotaUser", newJString(quotaUser))
  add(query_578931, "dryRun", newJBool(dryRun))
  if body != nil:
    body_578932 = body
  add(query_578931, "fields", newJString(fields))
  result = call_578930.call(nil, query_578931, nil, nil, body_578932)

var contentAccounttaxCustombatch* = Call_ContentAccounttaxCustombatch_578917(
    name: "contentAccounttaxCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accounttax/batch",
    validator: validate_ContentAccounttaxCustombatch_578918, base: "/content/v2",
    url: url_ContentAccounttaxCustombatch_578919, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsCustombatch_578933 = ref object of OpenApiRestCall_578348
proc url_ContentDatafeedsCustombatch_578935(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentDatafeedsCustombatch_578934(path: JsonNode; query: JsonNode;
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
  var valid_578936 = query.getOrDefault("key")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "key", valid_578936
  var valid_578937 = query.getOrDefault("prettyPrint")
  valid_578937 = validateParameter(valid_578937, JBool, required = false,
                                 default = newJBool(true))
  if valid_578937 != nil:
    section.add "prettyPrint", valid_578937
  var valid_578938 = query.getOrDefault("oauth_token")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "oauth_token", valid_578938
  var valid_578939 = query.getOrDefault("alt")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = newJString("json"))
  if valid_578939 != nil:
    section.add "alt", valid_578939
  var valid_578940 = query.getOrDefault("userIp")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "userIp", valid_578940
  var valid_578941 = query.getOrDefault("quotaUser")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "quotaUser", valid_578941
  var valid_578942 = query.getOrDefault("dryRun")
  valid_578942 = validateParameter(valid_578942, JBool, required = false, default = nil)
  if valid_578942 != nil:
    section.add "dryRun", valid_578942
  var valid_578943 = query.getOrDefault("fields")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "fields", valid_578943
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578945: Call_ContentDatafeedsCustombatch_578933; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes, fetches, gets, inserts and updates multiple datafeeds in a single request.
  ## 
  let valid = call_578945.validator(path, query, header, formData, body)
  let scheme = call_578945.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578945.url(scheme.get, call_578945.host, call_578945.base,
                         call_578945.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578945, url, valid)

proc call*(call_578946: Call_ContentDatafeedsCustombatch_578933; key: string = "";
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
  var query_578947 = newJObject()
  var body_578948 = newJObject()
  add(query_578947, "key", newJString(key))
  add(query_578947, "prettyPrint", newJBool(prettyPrint))
  add(query_578947, "oauth_token", newJString(oauthToken))
  add(query_578947, "alt", newJString(alt))
  add(query_578947, "userIp", newJString(userIp))
  add(query_578947, "quotaUser", newJString(quotaUser))
  add(query_578947, "dryRun", newJBool(dryRun))
  if body != nil:
    body_578948 = body
  add(query_578947, "fields", newJString(fields))
  result = call_578946.call(nil, query_578947, nil, nil, body_578948)

var contentDatafeedsCustombatch* = Call_ContentDatafeedsCustombatch_578933(
    name: "contentDatafeedsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/datafeeds/batch",
    validator: validate_ContentDatafeedsCustombatch_578934, base: "/content/v2",
    url: url_ContentDatafeedsCustombatch_578935, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesCustombatch_578949 = ref object of OpenApiRestCall_578348
proc url_ContentDatafeedstatusesCustombatch_578951(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentDatafeedstatusesCustombatch_578950(path: JsonNode;
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
  var valid_578952 = query.getOrDefault("key")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "key", valid_578952
  var valid_578953 = query.getOrDefault("prettyPrint")
  valid_578953 = validateParameter(valid_578953, JBool, required = false,
                                 default = newJBool(true))
  if valid_578953 != nil:
    section.add "prettyPrint", valid_578953
  var valid_578954 = query.getOrDefault("oauth_token")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "oauth_token", valid_578954
  var valid_578955 = query.getOrDefault("alt")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = newJString("json"))
  if valid_578955 != nil:
    section.add "alt", valid_578955
  var valid_578956 = query.getOrDefault("userIp")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "userIp", valid_578956
  var valid_578957 = query.getOrDefault("quotaUser")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "quotaUser", valid_578957
  var valid_578958 = query.getOrDefault("fields")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "fields", valid_578958
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578960: Call_ContentDatafeedstatusesCustombatch_578949;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets multiple Merchant Center datafeed statuses in a single request.
  ## 
  let valid = call_578960.validator(path, query, header, formData, body)
  let scheme = call_578960.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578960.url(scheme.get, call_578960.host, call_578960.base,
                         call_578960.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578960, url, valid)

proc call*(call_578961: Call_ContentDatafeedstatusesCustombatch_578949;
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
  var query_578962 = newJObject()
  var body_578963 = newJObject()
  add(query_578962, "key", newJString(key))
  add(query_578962, "prettyPrint", newJBool(prettyPrint))
  add(query_578962, "oauth_token", newJString(oauthToken))
  add(query_578962, "alt", newJString(alt))
  add(query_578962, "userIp", newJString(userIp))
  add(query_578962, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578963 = body
  add(query_578962, "fields", newJString(fields))
  result = call_578961.call(nil, query_578962, nil, nil, body_578963)

var contentDatafeedstatusesCustombatch* = Call_ContentDatafeedstatusesCustombatch_578949(
    name: "contentDatafeedstatusesCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/datafeedstatuses/batch",
    validator: validate_ContentDatafeedstatusesCustombatch_578950,
    base: "/content/v2", url: url_ContentDatafeedstatusesCustombatch_578951,
    schemes: {Scheme.Https})
type
  Call_ContentInventoryCustombatch_578964 = ref object of OpenApiRestCall_578348
proc url_ContentInventoryCustombatch_578966(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentInventoryCustombatch_578965(path: JsonNode; query: JsonNode;
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
  var valid_578967 = query.getOrDefault("key")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "key", valid_578967
  var valid_578968 = query.getOrDefault("prettyPrint")
  valid_578968 = validateParameter(valid_578968, JBool, required = false,
                                 default = newJBool(true))
  if valid_578968 != nil:
    section.add "prettyPrint", valid_578968
  var valid_578969 = query.getOrDefault("oauth_token")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "oauth_token", valid_578969
  var valid_578970 = query.getOrDefault("alt")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = newJString("json"))
  if valid_578970 != nil:
    section.add "alt", valid_578970
  var valid_578971 = query.getOrDefault("userIp")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "userIp", valid_578971
  var valid_578972 = query.getOrDefault("quotaUser")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "quotaUser", valid_578972
  var valid_578973 = query.getOrDefault("dryRun")
  valid_578973 = validateParameter(valid_578973, JBool, required = false, default = nil)
  if valid_578973 != nil:
    section.add "dryRun", valid_578973
  var valid_578974 = query.getOrDefault("fields")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "fields", valid_578974
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578976: Call_ContentInventoryCustombatch_578964; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates price and availability for multiple products or stores in a single request. This operation does not update the expiration date of the products.
  ## 
  let valid = call_578976.validator(path, query, header, formData, body)
  let scheme = call_578976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578976.url(scheme.get, call_578976.host, call_578976.base,
                         call_578976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578976, url, valid)

proc call*(call_578977: Call_ContentInventoryCustombatch_578964; key: string = "";
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
  var query_578978 = newJObject()
  var body_578979 = newJObject()
  add(query_578978, "key", newJString(key))
  add(query_578978, "prettyPrint", newJBool(prettyPrint))
  add(query_578978, "oauth_token", newJString(oauthToken))
  add(query_578978, "alt", newJString(alt))
  add(query_578978, "userIp", newJString(userIp))
  add(query_578978, "quotaUser", newJString(quotaUser))
  add(query_578978, "dryRun", newJBool(dryRun))
  if body != nil:
    body_578979 = body
  add(query_578978, "fields", newJString(fields))
  result = call_578977.call(nil, query_578978, nil, nil, body_578979)

var contentInventoryCustombatch* = Call_ContentInventoryCustombatch_578964(
    name: "contentInventoryCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/inventory/batch",
    validator: validate_ContentInventoryCustombatch_578965, base: "/content/v2",
    url: url_ContentInventoryCustombatch_578966, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsCustombatch_578980 = ref object of OpenApiRestCall_578348
proc url_ContentLiasettingsCustombatch_578982(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentLiasettingsCustombatch_578981(path: JsonNode; query: JsonNode;
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
  var valid_578983 = query.getOrDefault("key")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "key", valid_578983
  var valid_578984 = query.getOrDefault("prettyPrint")
  valid_578984 = validateParameter(valid_578984, JBool, required = false,
                                 default = newJBool(true))
  if valid_578984 != nil:
    section.add "prettyPrint", valid_578984
  var valid_578985 = query.getOrDefault("oauth_token")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "oauth_token", valid_578985
  var valid_578986 = query.getOrDefault("alt")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = newJString("json"))
  if valid_578986 != nil:
    section.add "alt", valid_578986
  var valid_578987 = query.getOrDefault("userIp")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "userIp", valid_578987
  var valid_578988 = query.getOrDefault("quotaUser")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "quotaUser", valid_578988
  var valid_578989 = query.getOrDefault("dryRun")
  valid_578989 = validateParameter(valid_578989, JBool, required = false, default = nil)
  if valid_578989 != nil:
    section.add "dryRun", valid_578989
  var valid_578990 = query.getOrDefault("fields")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "fields", valid_578990
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578992: Call_ContentLiasettingsCustombatch_578980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves and/or updates the LIA settings of multiple accounts in a single request.
  ## 
  let valid = call_578992.validator(path, query, header, formData, body)
  let scheme = call_578992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578992.url(scheme.get, call_578992.host, call_578992.base,
                         call_578992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578992, url, valid)

proc call*(call_578993: Call_ContentLiasettingsCustombatch_578980;
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
  var query_578994 = newJObject()
  var body_578995 = newJObject()
  add(query_578994, "key", newJString(key))
  add(query_578994, "prettyPrint", newJBool(prettyPrint))
  add(query_578994, "oauth_token", newJString(oauthToken))
  add(query_578994, "alt", newJString(alt))
  add(query_578994, "userIp", newJString(userIp))
  add(query_578994, "quotaUser", newJString(quotaUser))
  add(query_578994, "dryRun", newJBool(dryRun))
  if body != nil:
    body_578995 = body
  add(query_578994, "fields", newJString(fields))
  result = call_578993.call(nil, query_578994, nil, nil, body_578995)

var contentLiasettingsCustombatch* = Call_ContentLiasettingsCustombatch_578980(
    name: "contentLiasettingsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liasettings/batch",
    validator: validate_ContentLiasettingsCustombatch_578981, base: "/content/v2",
    url: url_ContentLiasettingsCustombatch_578982, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsListposdataproviders_578996 = ref object of OpenApiRestCall_578348
proc url_ContentLiasettingsListposdataproviders_578998(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentLiasettingsListposdataproviders_578997(path: JsonNode;
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
  var valid_578999 = query.getOrDefault("key")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "key", valid_578999
  var valid_579000 = query.getOrDefault("prettyPrint")
  valid_579000 = validateParameter(valid_579000, JBool, required = false,
                                 default = newJBool(true))
  if valid_579000 != nil:
    section.add "prettyPrint", valid_579000
  var valid_579001 = query.getOrDefault("oauth_token")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "oauth_token", valid_579001
  var valid_579002 = query.getOrDefault("alt")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = newJString("json"))
  if valid_579002 != nil:
    section.add "alt", valid_579002
  var valid_579003 = query.getOrDefault("userIp")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "userIp", valid_579003
  var valid_579004 = query.getOrDefault("quotaUser")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "quotaUser", valid_579004
  var valid_579005 = query.getOrDefault("fields")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "fields", valid_579005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579006: Call_ContentLiasettingsListposdataproviders_578996;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of POS data providers that have active settings for the all eiligible countries.
  ## 
  let valid = call_579006.validator(path, query, header, formData, body)
  let scheme = call_579006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579006.url(scheme.get, call_579006.host, call_579006.base,
                         call_579006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579006, url, valid)

proc call*(call_579007: Call_ContentLiasettingsListposdataproviders_578996;
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
  var query_579008 = newJObject()
  add(query_579008, "key", newJString(key))
  add(query_579008, "prettyPrint", newJBool(prettyPrint))
  add(query_579008, "oauth_token", newJString(oauthToken))
  add(query_579008, "alt", newJString(alt))
  add(query_579008, "userIp", newJString(userIp))
  add(query_579008, "quotaUser", newJString(quotaUser))
  add(query_579008, "fields", newJString(fields))
  result = call_579007.call(nil, query_579008, nil, nil, nil)

var contentLiasettingsListposdataproviders* = Call_ContentLiasettingsListposdataproviders_578996(
    name: "contentLiasettingsListposdataproviders", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/liasettings/posdataproviders",
    validator: validate_ContentLiasettingsListposdataproviders_578997,
    base: "/content/v2", url: url_ContentLiasettingsListposdataproviders_578998,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersCustombatch_579009 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersCustombatch_579011(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentOrdersCustombatch_579010(path: JsonNode; query: JsonNode;
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
  var valid_579012 = query.getOrDefault("key")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "key", valid_579012
  var valid_579013 = query.getOrDefault("prettyPrint")
  valid_579013 = validateParameter(valid_579013, JBool, required = false,
                                 default = newJBool(true))
  if valid_579013 != nil:
    section.add "prettyPrint", valid_579013
  var valid_579014 = query.getOrDefault("oauth_token")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "oauth_token", valid_579014
  var valid_579015 = query.getOrDefault("alt")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = newJString("json"))
  if valid_579015 != nil:
    section.add "alt", valid_579015
  var valid_579016 = query.getOrDefault("userIp")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "userIp", valid_579016
  var valid_579017 = query.getOrDefault("quotaUser")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "quotaUser", valid_579017
  var valid_579018 = query.getOrDefault("fields")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "fields", valid_579018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579020: Call_ContentOrdersCustombatch_579009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves or modifies multiple orders in a single request.
  ## 
  let valid = call_579020.validator(path, query, header, formData, body)
  let scheme = call_579020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579020.url(scheme.get, call_579020.host, call_579020.base,
                         call_579020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579020, url, valid)

proc call*(call_579021: Call_ContentOrdersCustombatch_579009; key: string = "";
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
  var query_579022 = newJObject()
  var body_579023 = newJObject()
  add(query_579022, "key", newJString(key))
  add(query_579022, "prettyPrint", newJBool(prettyPrint))
  add(query_579022, "oauth_token", newJString(oauthToken))
  add(query_579022, "alt", newJString(alt))
  add(query_579022, "userIp", newJString(userIp))
  add(query_579022, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579023 = body
  add(query_579022, "fields", newJString(fields))
  result = call_579021.call(nil, query_579022, nil, nil, body_579023)

var contentOrdersCustombatch* = Call_ContentOrdersCustombatch_579009(
    name: "contentOrdersCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/orders/batch",
    validator: validate_ContentOrdersCustombatch_579010, base: "/content/v2",
    url: url_ContentOrdersCustombatch_579011, schemes: {Scheme.Https})
type
  Call_ContentPosCustombatch_579024 = ref object of OpenApiRestCall_578348
proc url_ContentPosCustombatch_579026(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentPosCustombatch_579025(path: JsonNode; query: JsonNode;
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
  var valid_579027 = query.getOrDefault("key")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "key", valid_579027
  var valid_579028 = query.getOrDefault("prettyPrint")
  valid_579028 = validateParameter(valid_579028, JBool, required = false,
                                 default = newJBool(true))
  if valid_579028 != nil:
    section.add "prettyPrint", valid_579028
  var valid_579029 = query.getOrDefault("oauth_token")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "oauth_token", valid_579029
  var valid_579030 = query.getOrDefault("alt")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = newJString("json"))
  if valid_579030 != nil:
    section.add "alt", valid_579030
  var valid_579031 = query.getOrDefault("userIp")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "userIp", valid_579031
  var valid_579032 = query.getOrDefault("quotaUser")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "quotaUser", valid_579032
  var valid_579033 = query.getOrDefault("dryRun")
  valid_579033 = validateParameter(valid_579033, JBool, required = false, default = nil)
  if valid_579033 != nil:
    section.add "dryRun", valid_579033
  var valid_579034 = query.getOrDefault("fields")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "fields", valid_579034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579036: Call_ContentPosCustombatch_579024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Batches multiple POS-related calls in a single request.
  ## 
  let valid = call_579036.validator(path, query, header, formData, body)
  let scheme = call_579036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579036.url(scheme.get, call_579036.host, call_579036.base,
                         call_579036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579036, url, valid)

proc call*(call_579037: Call_ContentPosCustombatch_579024; key: string = "";
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
  var query_579038 = newJObject()
  var body_579039 = newJObject()
  add(query_579038, "key", newJString(key))
  add(query_579038, "prettyPrint", newJBool(prettyPrint))
  add(query_579038, "oauth_token", newJString(oauthToken))
  add(query_579038, "alt", newJString(alt))
  add(query_579038, "userIp", newJString(userIp))
  add(query_579038, "quotaUser", newJString(quotaUser))
  add(query_579038, "dryRun", newJBool(dryRun))
  if body != nil:
    body_579039 = body
  add(query_579038, "fields", newJString(fields))
  result = call_579037.call(nil, query_579038, nil, nil, body_579039)

var contentPosCustombatch* = Call_ContentPosCustombatch_579024(
    name: "contentPosCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/pos/batch",
    validator: validate_ContentPosCustombatch_579025, base: "/content/v2",
    url: url_ContentPosCustombatch_579026, schemes: {Scheme.Https})
type
  Call_ContentProductsCustombatch_579040 = ref object of OpenApiRestCall_578348
proc url_ContentProductsCustombatch_579042(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentProductsCustombatch_579041(path: JsonNode; query: JsonNode;
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
  var valid_579043 = query.getOrDefault("key")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "key", valid_579043
  var valid_579044 = query.getOrDefault("prettyPrint")
  valid_579044 = validateParameter(valid_579044, JBool, required = false,
                                 default = newJBool(true))
  if valid_579044 != nil:
    section.add "prettyPrint", valid_579044
  var valid_579045 = query.getOrDefault("oauth_token")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "oauth_token", valid_579045
  var valid_579046 = query.getOrDefault("alt")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = newJString("json"))
  if valid_579046 != nil:
    section.add "alt", valid_579046
  var valid_579047 = query.getOrDefault("userIp")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "userIp", valid_579047
  var valid_579048 = query.getOrDefault("quotaUser")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "quotaUser", valid_579048
  var valid_579049 = query.getOrDefault("dryRun")
  valid_579049 = validateParameter(valid_579049, JBool, required = false, default = nil)
  if valid_579049 != nil:
    section.add "dryRun", valid_579049
  var valid_579050 = query.getOrDefault("fields")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "fields", valid_579050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579052: Call_ContentProductsCustombatch_579040; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves, inserts, and deletes multiple products in a single request.
  ## 
  let valid = call_579052.validator(path, query, header, formData, body)
  let scheme = call_579052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579052.url(scheme.get, call_579052.host, call_579052.base,
                         call_579052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579052, url, valid)

proc call*(call_579053: Call_ContentProductsCustombatch_579040; key: string = "";
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
  var query_579054 = newJObject()
  var body_579055 = newJObject()
  add(query_579054, "key", newJString(key))
  add(query_579054, "prettyPrint", newJBool(prettyPrint))
  add(query_579054, "oauth_token", newJString(oauthToken))
  add(query_579054, "alt", newJString(alt))
  add(query_579054, "userIp", newJString(userIp))
  add(query_579054, "quotaUser", newJString(quotaUser))
  add(query_579054, "dryRun", newJBool(dryRun))
  if body != nil:
    body_579055 = body
  add(query_579054, "fields", newJString(fields))
  result = call_579053.call(nil, query_579054, nil, nil, body_579055)

var contentProductsCustombatch* = Call_ContentProductsCustombatch_579040(
    name: "contentProductsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/products/batch",
    validator: validate_ContentProductsCustombatch_579041, base: "/content/v2",
    url: url_ContentProductsCustombatch_579042, schemes: {Scheme.Https})
type
  Call_ContentProductstatusesCustombatch_579056 = ref object of OpenApiRestCall_578348
proc url_ContentProductstatusesCustombatch_579058(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentProductstatusesCustombatch_579057(path: JsonNode;
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
  var valid_579059 = query.getOrDefault("key")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "key", valid_579059
  var valid_579060 = query.getOrDefault("prettyPrint")
  valid_579060 = validateParameter(valid_579060, JBool, required = false,
                                 default = newJBool(true))
  if valid_579060 != nil:
    section.add "prettyPrint", valid_579060
  var valid_579061 = query.getOrDefault("oauth_token")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "oauth_token", valid_579061
  var valid_579062 = query.getOrDefault("alt")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = newJString("json"))
  if valid_579062 != nil:
    section.add "alt", valid_579062
  var valid_579063 = query.getOrDefault("userIp")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "userIp", valid_579063
  var valid_579064 = query.getOrDefault("quotaUser")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "quotaUser", valid_579064
  var valid_579065 = query.getOrDefault("includeAttributes")
  valid_579065 = validateParameter(valid_579065, JBool, required = false, default = nil)
  if valid_579065 != nil:
    section.add "includeAttributes", valid_579065
  var valid_579066 = query.getOrDefault("fields")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "fields", valid_579066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579068: Call_ContentProductstatusesCustombatch_579056;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the statuses of multiple products in a single request.
  ## 
  let valid = call_579068.validator(path, query, header, formData, body)
  let scheme = call_579068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579068.url(scheme.get, call_579068.host, call_579068.base,
                         call_579068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579068, url, valid)

proc call*(call_579069: Call_ContentProductstatusesCustombatch_579056;
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
  var query_579070 = newJObject()
  var body_579071 = newJObject()
  add(query_579070, "key", newJString(key))
  add(query_579070, "prettyPrint", newJBool(prettyPrint))
  add(query_579070, "oauth_token", newJString(oauthToken))
  add(query_579070, "alt", newJString(alt))
  add(query_579070, "userIp", newJString(userIp))
  add(query_579070, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579071 = body
  add(query_579070, "includeAttributes", newJBool(includeAttributes))
  add(query_579070, "fields", newJString(fields))
  result = call_579069.call(nil, query_579070, nil, nil, body_579071)

var contentProductstatusesCustombatch* = Call_ContentProductstatusesCustombatch_579056(
    name: "contentProductstatusesCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/productstatuses/batch",
    validator: validate_ContentProductstatusesCustombatch_579057,
    base: "/content/v2", url: url_ContentProductstatusesCustombatch_579058,
    schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsCustombatch_579072 = ref object of OpenApiRestCall_578348
proc url_ContentShippingsettingsCustombatch_579074(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentShippingsettingsCustombatch_579073(path: JsonNode;
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
  var valid_579075 = query.getOrDefault("key")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "key", valid_579075
  var valid_579076 = query.getOrDefault("prettyPrint")
  valid_579076 = validateParameter(valid_579076, JBool, required = false,
                                 default = newJBool(true))
  if valid_579076 != nil:
    section.add "prettyPrint", valid_579076
  var valid_579077 = query.getOrDefault("oauth_token")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "oauth_token", valid_579077
  var valid_579078 = query.getOrDefault("alt")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = newJString("json"))
  if valid_579078 != nil:
    section.add "alt", valid_579078
  var valid_579079 = query.getOrDefault("userIp")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "userIp", valid_579079
  var valid_579080 = query.getOrDefault("quotaUser")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "quotaUser", valid_579080
  var valid_579081 = query.getOrDefault("dryRun")
  valid_579081 = validateParameter(valid_579081, JBool, required = false, default = nil)
  if valid_579081 != nil:
    section.add "dryRun", valid_579081
  var valid_579082 = query.getOrDefault("fields")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "fields", valid_579082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579084: Call_ContentShippingsettingsCustombatch_579072;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves and updates the shipping settings of multiple accounts in a single request.
  ## 
  let valid = call_579084.validator(path, query, header, formData, body)
  let scheme = call_579084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579084.url(scheme.get, call_579084.host, call_579084.base,
                         call_579084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579084, url, valid)

proc call*(call_579085: Call_ContentShippingsettingsCustombatch_579072;
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
  var query_579086 = newJObject()
  var body_579087 = newJObject()
  add(query_579086, "key", newJString(key))
  add(query_579086, "prettyPrint", newJBool(prettyPrint))
  add(query_579086, "oauth_token", newJString(oauthToken))
  add(query_579086, "alt", newJString(alt))
  add(query_579086, "userIp", newJString(userIp))
  add(query_579086, "quotaUser", newJString(quotaUser))
  add(query_579086, "dryRun", newJBool(dryRun))
  if body != nil:
    body_579087 = body
  add(query_579086, "fields", newJString(fields))
  result = call_579085.call(nil, query_579086, nil, nil, body_579087)

var contentShippingsettingsCustombatch* = Call_ContentShippingsettingsCustombatch_579072(
    name: "contentShippingsettingsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/shippingsettings/batch",
    validator: validate_ContentShippingsettingsCustombatch_579073,
    base: "/content/v2", url: url_ContentShippingsettingsCustombatch_579074,
    schemes: {Scheme.Https})
type
  Call_ContentAccountsInsert_579119 = ref object of OpenApiRestCall_578348
proc url_ContentAccountsInsert_579121(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsInsert_579120(path: JsonNode; query: JsonNode;
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
  var valid_579122 = path.getOrDefault("merchantId")
  valid_579122 = validateParameter(valid_579122, JString, required = true,
                                 default = nil)
  if valid_579122 != nil:
    section.add "merchantId", valid_579122
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
  var valid_579123 = query.getOrDefault("key")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "key", valid_579123
  var valid_579124 = query.getOrDefault("prettyPrint")
  valid_579124 = validateParameter(valid_579124, JBool, required = false,
                                 default = newJBool(true))
  if valid_579124 != nil:
    section.add "prettyPrint", valid_579124
  var valid_579125 = query.getOrDefault("oauth_token")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "oauth_token", valid_579125
  var valid_579126 = query.getOrDefault("alt")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = newJString("json"))
  if valid_579126 != nil:
    section.add "alt", valid_579126
  var valid_579127 = query.getOrDefault("userIp")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "userIp", valid_579127
  var valid_579128 = query.getOrDefault("quotaUser")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "quotaUser", valid_579128
  var valid_579129 = query.getOrDefault("dryRun")
  valid_579129 = validateParameter(valid_579129, JBool, required = false, default = nil)
  if valid_579129 != nil:
    section.add "dryRun", valid_579129
  var valid_579130 = query.getOrDefault("fields")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "fields", valid_579130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579132: Call_ContentAccountsInsert_579119; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Merchant Center sub-account.
  ## 
  let valid = call_579132.validator(path, query, header, formData, body)
  let scheme = call_579132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579132.url(scheme.get, call_579132.host, call_579132.base,
                         call_579132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579132, url, valid)

proc call*(call_579133: Call_ContentAccountsInsert_579119; merchantId: string;
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
  var path_579134 = newJObject()
  var query_579135 = newJObject()
  var body_579136 = newJObject()
  add(query_579135, "key", newJString(key))
  add(query_579135, "prettyPrint", newJBool(prettyPrint))
  add(query_579135, "oauth_token", newJString(oauthToken))
  add(query_579135, "alt", newJString(alt))
  add(query_579135, "userIp", newJString(userIp))
  add(query_579135, "quotaUser", newJString(quotaUser))
  add(path_579134, "merchantId", newJString(merchantId))
  add(query_579135, "dryRun", newJBool(dryRun))
  if body != nil:
    body_579136 = body
  add(query_579135, "fields", newJString(fields))
  result = call_579133.call(path_579134, query_579135, nil, nil, body_579136)

var contentAccountsInsert* = Call_ContentAccountsInsert_579119(
    name: "contentAccountsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/accounts",
    validator: validate_ContentAccountsInsert_579120, base: "/content/v2",
    url: url_ContentAccountsInsert_579121, schemes: {Scheme.Https})
type
  Call_ContentAccountsList_579088 = ref object of OpenApiRestCall_578348
proc url_ContentAccountsList_579090(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsList_579089(path: JsonNode; query: JsonNode;
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
  var valid_579105 = path.getOrDefault("merchantId")
  valid_579105 = validateParameter(valid_579105, JString, required = true,
                                 default = nil)
  if valid_579105 != nil:
    section.add "merchantId", valid_579105
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
  var valid_579106 = query.getOrDefault("key")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "key", valid_579106
  var valid_579107 = query.getOrDefault("prettyPrint")
  valid_579107 = validateParameter(valid_579107, JBool, required = false,
                                 default = newJBool(true))
  if valid_579107 != nil:
    section.add "prettyPrint", valid_579107
  var valid_579108 = query.getOrDefault("oauth_token")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "oauth_token", valid_579108
  var valid_579109 = query.getOrDefault("alt")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = newJString("json"))
  if valid_579109 != nil:
    section.add "alt", valid_579109
  var valid_579110 = query.getOrDefault("userIp")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "userIp", valid_579110
  var valid_579111 = query.getOrDefault("quotaUser")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "quotaUser", valid_579111
  var valid_579112 = query.getOrDefault("pageToken")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "pageToken", valid_579112
  var valid_579113 = query.getOrDefault("fields")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "fields", valid_579113
  var valid_579114 = query.getOrDefault("maxResults")
  valid_579114 = validateParameter(valid_579114, JInt, required = false, default = nil)
  if valid_579114 != nil:
    section.add "maxResults", valid_579114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579115: Call_ContentAccountsList_579088; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_579115.validator(path, query, header, formData, body)
  let scheme = call_579115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579115.url(scheme.get, call_579115.host, call_579115.base,
                         call_579115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579115, url, valid)

proc call*(call_579116: Call_ContentAccountsList_579088; merchantId: string;
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
  var path_579117 = newJObject()
  var query_579118 = newJObject()
  add(query_579118, "key", newJString(key))
  add(query_579118, "prettyPrint", newJBool(prettyPrint))
  add(query_579118, "oauth_token", newJString(oauthToken))
  add(query_579118, "alt", newJString(alt))
  add(query_579118, "userIp", newJString(userIp))
  add(query_579118, "quotaUser", newJString(quotaUser))
  add(path_579117, "merchantId", newJString(merchantId))
  add(query_579118, "pageToken", newJString(pageToken))
  add(query_579118, "fields", newJString(fields))
  add(query_579118, "maxResults", newJInt(maxResults))
  result = call_579116.call(path_579117, query_579118, nil, nil, nil)

var contentAccountsList* = Call_ContentAccountsList_579088(
    name: "contentAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounts",
    validator: validate_ContentAccountsList_579089, base: "/content/v2",
    url: url_ContentAccountsList_579090, schemes: {Scheme.Https})
type
  Call_ContentAccountsUpdate_579153 = ref object of OpenApiRestCall_578348
proc url_ContentAccountsUpdate_579155(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsUpdate_579154(path: JsonNode; query: JsonNode;
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
  var valid_579156 = path.getOrDefault("merchantId")
  valid_579156 = validateParameter(valid_579156, JString, required = true,
                                 default = nil)
  if valid_579156 != nil:
    section.add "merchantId", valid_579156
  var valid_579157 = path.getOrDefault("accountId")
  valid_579157 = validateParameter(valid_579157, JString, required = true,
                                 default = nil)
  if valid_579157 != nil:
    section.add "accountId", valid_579157
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
  var valid_579158 = query.getOrDefault("key")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "key", valid_579158
  var valid_579159 = query.getOrDefault("prettyPrint")
  valid_579159 = validateParameter(valid_579159, JBool, required = false,
                                 default = newJBool(true))
  if valid_579159 != nil:
    section.add "prettyPrint", valid_579159
  var valid_579160 = query.getOrDefault("oauth_token")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "oauth_token", valid_579160
  var valid_579161 = query.getOrDefault("alt")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = newJString("json"))
  if valid_579161 != nil:
    section.add "alt", valid_579161
  var valid_579162 = query.getOrDefault("userIp")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "userIp", valid_579162
  var valid_579163 = query.getOrDefault("quotaUser")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "quotaUser", valid_579163
  var valid_579164 = query.getOrDefault("dryRun")
  valid_579164 = validateParameter(valid_579164, JBool, required = false, default = nil)
  if valid_579164 != nil:
    section.add "dryRun", valid_579164
  var valid_579165 = query.getOrDefault("fields")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "fields", valid_579165
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579167: Call_ContentAccountsUpdate_579153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Merchant Center account.
  ## 
  let valid = call_579167.validator(path, query, header, formData, body)
  let scheme = call_579167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579167.url(scheme.get, call_579167.host, call_579167.base,
                         call_579167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579167, url, valid)

proc call*(call_579168: Call_ContentAccountsUpdate_579153; merchantId: string;
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
  var path_579169 = newJObject()
  var query_579170 = newJObject()
  var body_579171 = newJObject()
  add(query_579170, "key", newJString(key))
  add(query_579170, "prettyPrint", newJBool(prettyPrint))
  add(query_579170, "oauth_token", newJString(oauthToken))
  add(query_579170, "alt", newJString(alt))
  add(query_579170, "userIp", newJString(userIp))
  add(query_579170, "quotaUser", newJString(quotaUser))
  add(path_579169, "merchantId", newJString(merchantId))
  add(query_579170, "dryRun", newJBool(dryRun))
  if body != nil:
    body_579171 = body
  add(path_579169, "accountId", newJString(accountId))
  add(query_579170, "fields", newJString(fields))
  result = call_579168.call(path_579169, query_579170, nil, nil, body_579171)

var contentAccountsUpdate* = Call_ContentAccountsUpdate_579153(
    name: "contentAccountsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsUpdate_579154, base: "/content/v2",
    url: url_ContentAccountsUpdate_579155, schemes: {Scheme.Https})
type
  Call_ContentAccountsGet_579137 = ref object of OpenApiRestCall_578348
proc url_ContentAccountsGet_579139(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsGet_579138(path: JsonNode; query: JsonNode;
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
  var valid_579140 = path.getOrDefault("merchantId")
  valid_579140 = validateParameter(valid_579140, JString, required = true,
                                 default = nil)
  if valid_579140 != nil:
    section.add "merchantId", valid_579140
  var valid_579141 = path.getOrDefault("accountId")
  valid_579141 = validateParameter(valid_579141, JString, required = true,
                                 default = nil)
  if valid_579141 != nil:
    section.add "accountId", valid_579141
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
  var valid_579142 = query.getOrDefault("key")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "key", valid_579142
  var valid_579143 = query.getOrDefault("prettyPrint")
  valid_579143 = validateParameter(valid_579143, JBool, required = false,
                                 default = newJBool(true))
  if valid_579143 != nil:
    section.add "prettyPrint", valid_579143
  var valid_579144 = query.getOrDefault("oauth_token")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "oauth_token", valid_579144
  var valid_579145 = query.getOrDefault("alt")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = newJString("json"))
  if valid_579145 != nil:
    section.add "alt", valid_579145
  var valid_579146 = query.getOrDefault("userIp")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "userIp", valid_579146
  var valid_579147 = query.getOrDefault("quotaUser")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "quotaUser", valid_579147
  var valid_579148 = query.getOrDefault("fields")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "fields", valid_579148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579149: Call_ContentAccountsGet_579137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a Merchant Center account.
  ## 
  let valid = call_579149.validator(path, query, header, formData, body)
  let scheme = call_579149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579149.url(scheme.get, call_579149.host, call_579149.base,
                         call_579149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579149, url, valid)

proc call*(call_579150: Call_ContentAccountsGet_579137; merchantId: string;
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
  var path_579151 = newJObject()
  var query_579152 = newJObject()
  add(query_579152, "key", newJString(key))
  add(query_579152, "prettyPrint", newJBool(prettyPrint))
  add(query_579152, "oauth_token", newJString(oauthToken))
  add(query_579152, "alt", newJString(alt))
  add(query_579152, "userIp", newJString(userIp))
  add(query_579152, "quotaUser", newJString(quotaUser))
  add(path_579151, "merchantId", newJString(merchantId))
  add(path_579151, "accountId", newJString(accountId))
  add(query_579152, "fields", newJString(fields))
  result = call_579150.call(path_579151, query_579152, nil, nil, nil)

var contentAccountsGet* = Call_ContentAccountsGet_579137(
    name: "contentAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsGet_579138, base: "/content/v2",
    url: url_ContentAccountsGet_579139, schemes: {Scheme.Https})
type
  Call_ContentAccountsPatch_579190 = ref object of OpenApiRestCall_578348
proc url_ContentAccountsPatch_579192(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsPatch_579191(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a Merchant Center account. This method supports patch semantics.
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
  var valid_579193 = path.getOrDefault("merchantId")
  valid_579193 = validateParameter(valid_579193, JString, required = true,
                                 default = nil)
  if valid_579193 != nil:
    section.add "merchantId", valid_579193
  var valid_579194 = path.getOrDefault("accountId")
  valid_579194 = validateParameter(valid_579194, JString, required = true,
                                 default = nil)
  if valid_579194 != nil:
    section.add "accountId", valid_579194
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
  var valid_579195 = query.getOrDefault("key")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "key", valid_579195
  var valid_579196 = query.getOrDefault("prettyPrint")
  valid_579196 = validateParameter(valid_579196, JBool, required = false,
                                 default = newJBool(true))
  if valid_579196 != nil:
    section.add "prettyPrint", valid_579196
  var valid_579197 = query.getOrDefault("oauth_token")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = nil)
  if valid_579197 != nil:
    section.add "oauth_token", valid_579197
  var valid_579198 = query.getOrDefault("alt")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = newJString("json"))
  if valid_579198 != nil:
    section.add "alt", valid_579198
  var valid_579199 = query.getOrDefault("userIp")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "userIp", valid_579199
  var valid_579200 = query.getOrDefault("quotaUser")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = nil)
  if valid_579200 != nil:
    section.add "quotaUser", valid_579200
  var valid_579201 = query.getOrDefault("dryRun")
  valid_579201 = validateParameter(valid_579201, JBool, required = false, default = nil)
  if valid_579201 != nil:
    section.add "dryRun", valid_579201
  var valid_579202 = query.getOrDefault("fields")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = nil)
  if valid_579202 != nil:
    section.add "fields", valid_579202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579204: Call_ContentAccountsPatch_579190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Merchant Center account. This method supports patch semantics.
  ## 
  let valid = call_579204.validator(path, query, header, formData, body)
  let scheme = call_579204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579204.url(scheme.get, call_579204.host, call_579204.base,
                         call_579204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579204, url, valid)

proc call*(call_579205: Call_ContentAccountsPatch_579190; merchantId: string;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; dryRun: bool = false; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentAccountsPatch
  ## Updates a Merchant Center account. This method supports patch semantics.
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
  var path_579206 = newJObject()
  var query_579207 = newJObject()
  var body_579208 = newJObject()
  add(query_579207, "key", newJString(key))
  add(query_579207, "prettyPrint", newJBool(prettyPrint))
  add(query_579207, "oauth_token", newJString(oauthToken))
  add(query_579207, "alt", newJString(alt))
  add(query_579207, "userIp", newJString(userIp))
  add(query_579207, "quotaUser", newJString(quotaUser))
  add(path_579206, "merchantId", newJString(merchantId))
  add(query_579207, "dryRun", newJBool(dryRun))
  if body != nil:
    body_579208 = body
  add(path_579206, "accountId", newJString(accountId))
  add(query_579207, "fields", newJString(fields))
  result = call_579205.call(path_579206, query_579207, nil, nil, body_579208)

var contentAccountsPatch* = Call_ContentAccountsPatch_579190(
    name: "contentAccountsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsPatch_579191, base: "/content/v2",
    url: url_ContentAccountsPatch_579192, schemes: {Scheme.Https})
type
  Call_ContentAccountsDelete_579172 = ref object of OpenApiRestCall_578348
proc url_ContentAccountsDelete_579174(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsDelete_579173(path: JsonNode; query: JsonNode;
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
  var valid_579175 = path.getOrDefault("merchantId")
  valid_579175 = validateParameter(valid_579175, JString, required = true,
                                 default = nil)
  if valid_579175 != nil:
    section.add "merchantId", valid_579175
  var valid_579176 = path.getOrDefault("accountId")
  valid_579176 = validateParameter(valid_579176, JString, required = true,
                                 default = nil)
  if valid_579176 != nil:
    section.add "accountId", valid_579176
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
  var valid_579177 = query.getOrDefault("key")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "key", valid_579177
  var valid_579178 = query.getOrDefault("prettyPrint")
  valid_579178 = validateParameter(valid_579178, JBool, required = false,
                                 default = newJBool(true))
  if valid_579178 != nil:
    section.add "prettyPrint", valid_579178
  var valid_579179 = query.getOrDefault("oauth_token")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "oauth_token", valid_579179
  var valid_579180 = query.getOrDefault("alt")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = newJString("json"))
  if valid_579180 != nil:
    section.add "alt", valid_579180
  var valid_579181 = query.getOrDefault("userIp")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "userIp", valid_579181
  var valid_579182 = query.getOrDefault("quotaUser")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = nil)
  if valid_579182 != nil:
    section.add "quotaUser", valid_579182
  var valid_579183 = query.getOrDefault("dryRun")
  valid_579183 = validateParameter(valid_579183, JBool, required = false, default = nil)
  if valid_579183 != nil:
    section.add "dryRun", valid_579183
  var valid_579184 = query.getOrDefault("force")
  valid_579184 = validateParameter(valid_579184, JBool, required = false,
                                 default = newJBool(false))
  if valid_579184 != nil:
    section.add "force", valid_579184
  var valid_579185 = query.getOrDefault("fields")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "fields", valid_579185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579186: Call_ContentAccountsDelete_579172; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Merchant Center sub-account.
  ## 
  let valid = call_579186.validator(path, query, header, formData, body)
  let scheme = call_579186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579186.url(scheme.get, call_579186.host, call_579186.base,
                         call_579186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579186, url, valid)

proc call*(call_579187: Call_ContentAccountsDelete_579172; merchantId: string;
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
  var path_579188 = newJObject()
  var query_579189 = newJObject()
  add(query_579189, "key", newJString(key))
  add(query_579189, "prettyPrint", newJBool(prettyPrint))
  add(query_579189, "oauth_token", newJString(oauthToken))
  add(query_579189, "alt", newJString(alt))
  add(query_579189, "userIp", newJString(userIp))
  add(query_579189, "quotaUser", newJString(quotaUser))
  add(path_579188, "merchantId", newJString(merchantId))
  add(query_579189, "dryRun", newJBool(dryRun))
  add(query_579189, "force", newJBool(force))
  add(path_579188, "accountId", newJString(accountId))
  add(query_579189, "fields", newJString(fields))
  result = call_579187.call(path_579188, query_579189, nil, nil, nil)

var contentAccountsDelete* = Call_ContentAccountsDelete_579172(
    name: "contentAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsDelete_579173, base: "/content/v2",
    url: url_ContentAccountsDelete_579174, schemes: {Scheme.Https})
type
  Call_ContentAccountsClaimwebsite_579209 = ref object of OpenApiRestCall_578348
proc url_ContentAccountsClaimwebsite_579211(protocol: Scheme; host: string;
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

proc validate_ContentAccountsClaimwebsite_579210(path: JsonNode; query: JsonNode;
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
  var valid_579212 = path.getOrDefault("merchantId")
  valid_579212 = validateParameter(valid_579212, JString, required = true,
                                 default = nil)
  if valid_579212 != nil:
    section.add "merchantId", valid_579212
  var valid_579213 = path.getOrDefault("accountId")
  valid_579213 = validateParameter(valid_579213, JString, required = true,
                                 default = nil)
  if valid_579213 != nil:
    section.add "accountId", valid_579213
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
  var valid_579214 = query.getOrDefault("key")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = nil)
  if valid_579214 != nil:
    section.add "key", valid_579214
  var valid_579215 = query.getOrDefault("prettyPrint")
  valid_579215 = validateParameter(valid_579215, JBool, required = false,
                                 default = newJBool(true))
  if valid_579215 != nil:
    section.add "prettyPrint", valid_579215
  var valid_579216 = query.getOrDefault("oauth_token")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "oauth_token", valid_579216
  var valid_579217 = query.getOrDefault("overwrite")
  valid_579217 = validateParameter(valid_579217, JBool, required = false, default = nil)
  if valid_579217 != nil:
    section.add "overwrite", valid_579217
  var valid_579218 = query.getOrDefault("alt")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = newJString("json"))
  if valid_579218 != nil:
    section.add "alt", valid_579218
  var valid_579219 = query.getOrDefault("userIp")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "userIp", valid_579219
  var valid_579220 = query.getOrDefault("quotaUser")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = nil)
  if valid_579220 != nil:
    section.add "quotaUser", valid_579220
  var valid_579221 = query.getOrDefault("fields")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "fields", valid_579221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579222: Call_ContentAccountsClaimwebsite_579209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Claims the website of a Merchant Center sub-account.
  ## 
  let valid = call_579222.validator(path, query, header, formData, body)
  let scheme = call_579222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579222.url(scheme.get, call_579222.host, call_579222.base,
                         call_579222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579222, url, valid)

proc call*(call_579223: Call_ContentAccountsClaimwebsite_579209;
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
  var path_579224 = newJObject()
  var query_579225 = newJObject()
  add(query_579225, "key", newJString(key))
  add(query_579225, "prettyPrint", newJBool(prettyPrint))
  add(query_579225, "oauth_token", newJString(oauthToken))
  add(query_579225, "overwrite", newJBool(overwrite))
  add(query_579225, "alt", newJString(alt))
  add(query_579225, "userIp", newJString(userIp))
  add(query_579225, "quotaUser", newJString(quotaUser))
  add(path_579224, "merchantId", newJString(merchantId))
  add(path_579224, "accountId", newJString(accountId))
  add(query_579225, "fields", newJString(fields))
  result = call_579223.call(path_579224, query_579225, nil, nil, nil)

var contentAccountsClaimwebsite* = Call_ContentAccountsClaimwebsite_579209(
    name: "contentAccountsClaimwebsite", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/accounts/{accountId}/claimwebsite",
    validator: validate_ContentAccountsClaimwebsite_579210, base: "/content/v2",
    url: url_ContentAccountsClaimwebsite_579211, schemes: {Scheme.Https})
type
  Call_ContentAccountsLink_579226 = ref object of OpenApiRestCall_578348
proc url_ContentAccountsLink_579228(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsLink_579227(path: JsonNode; query: JsonNode;
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
  var valid_579229 = path.getOrDefault("merchantId")
  valid_579229 = validateParameter(valid_579229, JString, required = true,
                                 default = nil)
  if valid_579229 != nil:
    section.add "merchantId", valid_579229
  var valid_579230 = path.getOrDefault("accountId")
  valid_579230 = validateParameter(valid_579230, JString, required = true,
                                 default = nil)
  if valid_579230 != nil:
    section.add "accountId", valid_579230
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
  var valid_579231 = query.getOrDefault("key")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = nil)
  if valid_579231 != nil:
    section.add "key", valid_579231
  var valid_579232 = query.getOrDefault("prettyPrint")
  valid_579232 = validateParameter(valid_579232, JBool, required = false,
                                 default = newJBool(true))
  if valid_579232 != nil:
    section.add "prettyPrint", valid_579232
  var valid_579233 = query.getOrDefault("oauth_token")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = nil)
  if valid_579233 != nil:
    section.add "oauth_token", valid_579233
  var valid_579234 = query.getOrDefault("alt")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = newJString("json"))
  if valid_579234 != nil:
    section.add "alt", valid_579234
  var valid_579235 = query.getOrDefault("userIp")
  valid_579235 = validateParameter(valid_579235, JString, required = false,
                                 default = nil)
  if valid_579235 != nil:
    section.add "userIp", valid_579235
  var valid_579236 = query.getOrDefault("quotaUser")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = nil)
  if valid_579236 != nil:
    section.add "quotaUser", valid_579236
  var valid_579237 = query.getOrDefault("fields")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = nil)
  if valid_579237 != nil:
    section.add "fields", valid_579237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579239: Call_ContentAccountsLink_579226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs an action on a link between two Merchant Center accounts, namely accountId and linkedAccountId.
  ## 
  let valid = call_579239.validator(path, query, header, formData, body)
  let scheme = call_579239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579239.url(scheme.get, call_579239.host, call_579239.base,
                         call_579239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579239, url, valid)

proc call*(call_579240: Call_ContentAccountsLink_579226; merchantId: string;
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
  var path_579241 = newJObject()
  var query_579242 = newJObject()
  var body_579243 = newJObject()
  add(query_579242, "key", newJString(key))
  add(query_579242, "prettyPrint", newJBool(prettyPrint))
  add(query_579242, "oauth_token", newJString(oauthToken))
  add(query_579242, "alt", newJString(alt))
  add(query_579242, "userIp", newJString(userIp))
  add(query_579242, "quotaUser", newJString(quotaUser))
  add(path_579241, "merchantId", newJString(merchantId))
  if body != nil:
    body_579243 = body
  add(path_579241, "accountId", newJString(accountId))
  add(query_579242, "fields", newJString(fields))
  result = call_579240.call(path_579241, query_579242, nil, nil, body_579243)

var contentAccountsLink* = Call_ContentAccountsLink_579226(
    name: "contentAccountsLink", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}/link",
    validator: validate_ContentAccountsLink_579227, base: "/content/v2",
    url: url_ContentAccountsLink_579228, schemes: {Scheme.Https})
type
  Call_ContentAccountstatusesList_579244 = ref object of OpenApiRestCall_578348
proc url_ContentAccountstatusesList_579246(protocol: Scheme; host: string;
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

proc validate_ContentAccountstatusesList_579245(path: JsonNode; query: JsonNode;
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
  var valid_579247 = path.getOrDefault("merchantId")
  valid_579247 = validateParameter(valid_579247, JString, required = true,
                                 default = nil)
  if valid_579247 != nil:
    section.add "merchantId", valid_579247
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
  var valid_579248 = query.getOrDefault("key")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = nil)
  if valid_579248 != nil:
    section.add "key", valid_579248
  var valid_579249 = query.getOrDefault("prettyPrint")
  valid_579249 = validateParameter(valid_579249, JBool, required = false,
                                 default = newJBool(true))
  if valid_579249 != nil:
    section.add "prettyPrint", valid_579249
  var valid_579250 = query.getOrDefault("oauth_token")
  valid_579250 = validateParameter(valid_579250, JString, required = false,
                                 default = nil)
  if valid_579250 != nil:
    section.add "oauth_token", valid_579250
  var valid_579251 = query.getOrDefault("alt")
  valid_579251 = validateParameter(valid_579251, JString, required = false,
                                 default = newJString("json"))
  if valid_579251 != nil:
    section.add "alt", valid_579251
  var valid_579252 = query.getOrDefault("userIp")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = nil)
  if valid_579252 != nil:
    section.add "userIp", valid_579252
  var valid_579253 = query.getOrDefault("quotaUser")
  valid_579253 = validateParameter(valid_579253, JString, required = false,
                                 default = nil)
  if valid_579253 != nil:
    section.add "quotaUser", valid_579253
  var valid_579254 = query.getOrDefault("pageToken")
  valid_579254 = validateParameter(valid_579254, JString, required = false,
                                 default = nil)
  if valid_579254 != nil:
    section.add "pageToken", valid_579254
  var valid_579255 = query.getOrDefault("destinations")
  valid_579255 = validateParameter(valid_579255, JArray, required = false,
                                 default = nil)
  if valid_579255 != nil:
    section.add "destinations", valid_579255
  var valid_579256 = query.getOrDefault("fields")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = nil)
  if valid_579256 != nil:
    section.add "fields", valid_579256
  var valid_579257 = query.getOrDefault("maxResults")
  valid_579257 = validateParameter(valid_579257, JInt, required = false, default = nil)
  if valid_579257 != nil:
    section.add "maxResults", valid_579257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579258: Call_ContentAccountstatusesList_579244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_579258.validator(path, query, header, formData, body)
  let scheme = call_579258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579258.url(scheme.get, call_579258.host, call_579258.base,
                         call_579258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579258, url, valid)

proc call*(call_579259: Call_ContentAccountstatusesList_579244; merchantId: string;
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
  var path_579260 = newJObject()
  var query_579261 = newJObject()
  add(query_579261, "key", newJString(key))
  add(query_579261, "prettyPrint", newJBool(prettyPrint))
  add(query_579261, "oauth_token", newJString(oauthToken))
  add(query_579261, "alt", newJString(alt))
  add(query_579261, "userIp", newJString(userIp))
  add(query_579261, "quotaUser", newJString(quotaUser))
  add(path_579260, "merchantId", newJString(merchantId))
  add(query_579261, "pageToken", newJString(pageToken))
  if destinations != nil:
    query_579261.add "destinations", destinations
  add(query_579261, "fields", newJString(fields))
  add(query_579261, "maxResults", newJInt(maxResults))
  result = call_579259.call(path_579260, query_579261, nil, nil, nil)

var contentAccountstatusesList* = Call_ContentAccountstatusesList_579244(
    name: "contentAccountstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accountstatuses",
    validator: validate_ContentAccountstatusesList_579245, base: "/content/v2",
    url: url_ContentAccountstatusesList_579246, schemes: {Scheme.Https})
type
  Call_ContentAccountstatusesGet_579262 = ref object of OpenApiRestCall_578348
proc url_ContentAccountstatusesGet_579264(protocol: Scheme; host: string;
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

proc validate_ContentAccountstatusesGet_579263(path: JsonNode; query: JsonNode;
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
  var valid_579265 = path.getOrDefault("merchantId")
  valid_579265 = validateParameter(valid_579265, JString, required = true,
                                 default = nil)
  if valid_579265 != nil:
    section.add "merchantId", valid_579265
  var valid_579266 = path.getOrDefault("accountId")
  valid_579266 = validateParameter(valid_579266, JString, required = true,
                                 default = nil)
  if valid_579266 != nil:
    section.add "accountId", valid_579266
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
  var valid_579267 = query.getOrDefault("key")
  valid_579267 = validateParameter(valid_579267, JString, required = false,
                                 default = nil)
  if valid_579267 != nil:
    section.add "key", valid_579267
  var valid_579268 = query.getOrDefault("prettyPrint")
  valid_579268 = validateParameter(valid_579268, JBool, required = false,
                                 default = newJBool(true))
  if valid_579268 != nil:
    section.add "prettyPrint", valid_579268
  var valid_579269 = query.getOrDefault("oauth_token")
  valid_579269 = validateParameter(valid_579269, JString, required = false,
                                 default = nil)
  if valid_579269 != nil:
    section.add "oauth_token", valid_579269
  var valid_579270 = query.getOrDefault("alt")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = newJString("json"))
  if valid_579270 != nil:
    section.add "alt", valid_579270
  var valid_579271 = query.getOrDefault("userIp")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = nil)
  if valid_579271 != nil:
    section.add "userIp", valid_579271
  var valid_579272 = query.getOrDefault("quotaUser")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = nil)
  if valid_579272 != nil:
    section.add "quotaUser", valid_579272
  var valid_579273 = query.getOrDefault("destinations")
  valid_579273 = validateParameter(valid_579273, JArray, required = false,
                                 default = nil)
  if valid_579273 != nil:
    section.add "destinations", valid_579273
  var valid_579274 = query.getOrDefault("fields")
  valid_579274 = validateParameter(valid_579274, JString, required = false,
                                 default = nil)
  if valid_579274 != nil:
    section.add "fields", valid_579274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579275: Call_ContentAccountstatusesGet_579262; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the status of a Merchant Center account. No itemLevelIssues are returned for multi-client accounts.
  ## 
  let valid = call_579275.validator(path, query, header, formData, body)
  let scheme = call_579275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579275.url(scheme.get, call_579275.host, call_579275.base,
                         call_579275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579275, url, valid)

proc call*(call_579276: Call_ContentAccountstatusesGet_579262; merchantId: string;
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
  var path_579277 = newJObject()
  var query_579278 = newJObject()
  add(query_579278, "key", newJString(key))
  add(query_579278, "prettyPrint", newJBool(prettyPrint))
  add(query_579278, "oauth_token", newJString(oauthToken))
  add(query_579278, "alt", newJString(alt))
  add(query_579278, "userIp", newJString(userIp))
  add(query_579278, "quotaUser", newJString(quotaUser))
  add(path_579277, "merchantId", newJString(merchantId))
  if destinations != nil:
    query_579278.add "destinations", destinations
  add(path_579277, "accountId", newJString(accountId))
  add(query_579278, "fields", newJString(fields))
  result = call_579276.call(path_579277, query_579278, nil, nil, nil)

var contentAccountstatusesGet* = Call_ContentAccountstatusesGet_579262(
    name: "contentAccountstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/accountstatuses/{accountId}",
    validator: validate_ContentAccountstatusesGet_579263, base: "/content/v2",
    url: url_ContentAccountstatusesGet_579264, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxList_579279 = ref object of OpenApiRestCall_578348
proc url_ContentAccounttaxList_579281(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccounttaxList_579280(path: JsonNode; query: JsonNode;
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
  var valid_579282 = path.getOrDefault("merchantId")
  valid_579282 = validateParameter(valid_579282, JString, required = true,
                                 default = nil)
  if valid_579282 != nil:
    section.add "merchantId", valid_579282
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
  var valid_579283 = query.getOrDefault("key")
  valid_579283 = validateParameter(valid_579283, JString, required = false,
                                 default = nil)
  if valid_579283 != nil:
    section.add "key", valid_579283
  var valid_579284 = query.getOrDefault("prettyPrint")
  valid_579284 = validateParameter(valid_579284, JBool, required = false,
                                 default = newJBool(true))
  if valid_579284 != nil:
    section.add "prettyPrint", valid_579284
  var valid_579285 = query.getOrDefault("oauth_token")
  valid_579285 = validateParameter(valid_579285, JString, required = false,
                                 default = nil)
  if valid_579285 != nil:
    section.add "oauth_token", valid_579285
  var valid_579286 = query.getOrDefault("alt")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = newJString("json"))
  if valid_579286 != nil:
    section.add "alt", valid_579286
  var valid_579287 = query.getOrDefault("userIp")
  valid_579287 = validateParameter(valid_579287, JString, required = false,
                                 default = nil)
  if valid_579287 != nil:
    section.add "userIp", valid_579287
  var valid_579288 = query.getOrDefault("quotaUser")
  valid_579288 = validateParameter(valid_579288, JString, required = false,
                                 default = nil)
  if valid_579288 != nil:
    section.add "quotaUser", valid_579288
  var valid_579289 = query.getOrDefault("pageToken")
  valid_579289 = validateParameter(valid_579289, JString, required = false,
                                 default = nil)
  if valid_579289 != nil:
    section.add "pageToken", valid_579289
  var valid_579290 = query.getOrDefault("fields")
  valid_579290 = validateParameter(valid_579290, JString, required = false,
                                 default = nil)
  if valid_579290 != nil:
    section.add "fields", valid_579290
  var valid_579291 = query.getOrDefault("maxResults")
  valid_579291 = validateParameter(valid_579291, JInt, required = false, default = nil)
  if valid_579291 != nil:
    section.add "maxResults", valid_579291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579292: Call_ContentAccounttaxList_579279; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the tax settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_579292.validator(path, query, header, formData, body)
  let scheme = call_579292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579292.url(scheme.get, call_579292.host, call_579292.base,
                         call_579292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579292, url, valid)

proc call*(call_579293: Call_ContentAccounttaxList_579279; merchantId: string;
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
  var path_579294 = newJObject()
  var query_579295 = newJObject()
  add(query_579295, "key", newJString(key))
  add(query_579295, "prettyPrint", newJBool(prettyPrint))
  add(query_579295, "oauth_token", newJString(oauthToken))
  add(query_579295, "alt", newJString(alt))
  add(query_579295, "userIp", newJString(userIp))
  add(query_579295, "quotaUser", newJString(quotaUser))
  add(path_579294, "merchantId", newJString(merchantId))
  add(query_579295, "pageToken", newJString(pageToken))
  add(query_579295, "fields", newJString(fields))
  add(query_579295, "maxResults", newJInt(maxResults))
  result = call_579293.call(path_579294, query_579295, nil, nil, nil)

var contentAccounttaxList* = Call_ContentAccounttaxList_579279(
    name: "contentAccounttaxList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax",
    validator: validate_ContentAccounttaxList_579280, base: "/content/v2",
    url: url_ContentAccounttaxList_579281, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxUpdate_579312 = ref object of OpenApiRestCall_578348
proc url_ContentAccounttaxUpdate_579314(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccounttaxUpdate_579313(path: JsonNode; query: JsonNode;
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
  var valid_579315 = path.getOrDefault("merchantId")
  valid_579315 = validateParameter(valid_579315, JString, required = true,
                                 default = nil)
  if valid_579315 != nil:
    section.add "merchantId", valid_579315
  var valid_579316 = path.getOrDefault("accountId")
  valid_579316 = validateParameter(valid_579316, JString, required = true,
                                 default = nil)
  if valid_579316 != nil:
    section.add "accountId", valid_579316
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
  var valid_579317 = query.getOrDefault("key")
  valid_579317 = validateParameter(valid_579317, JString, required = false,
                                 default = nil)
  if valid_579317 != nil:
    section.add "key", valid_579317
  var valid_579318 = query.getOrDefault("prettyPrint")
  valid_579318 = validateParameter(valid_579318, JBool, required = false,
                                 default = newJBool(true))
  if valid_579318 != nil:
    section.add "prettyPrint", valid_579318
  var valid_579319 = query.getOrDefault("oauth_token")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = nil)
  if valid_579319 != nil:
    section.add "oauth_token", valid_579319
  var valid_579320 = query.getOrDefault("alt")
  valid_579320 = validateParameter(valid_579320, JString, required = false,
                                 default = newJString("json"))
  if valid_579320 != nil:
    section.add "alt", valid_579320
  var valid_579321 = query.getOrDefault("userIp")
  valid_579321 = validateParameter(valid_579321, JString, required = false,
                                 default = nil)
  if valid_579321 != nil:
    section.add "userIp", valid_579321
  var valid_579322 = query.getOrDefault("quotaUser")
  valid_579322 = validateParameter(valid_579322, JString, required = false,
                                 default = nil)
  if valid_579322 != nil:
    section.add "quotaUser", valid_579322
  var valid_579323 = query.getOrDefault("dryRun")
  valid_579323 = validateParameter(valid_579323, JBool, required = false, default = nil)
  if valid_579323 != nil:
    section.add "dryRun", valid_579323
  var valid_579324 = query.getOrDefault("fields")
  valid_579324 = validateParameter(valid_579324, JString, required = false,
                                 default = nil)
  if valid_579324 != nil:
    section.add "fields", valid_579324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579326: Call_ContentAccounttaxUpdate_579312; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the tax settings of the account.
  ## 
  let valid = call_579326.validator(path, query, header, formData, body)
  let scheme = call_579326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579326.url(scheme.get, call_579326.host, call_579326.base,
                         call_579326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579326, url, valid)

proc call*(call_579327: Call_ContentAccounttaxUpdate_579312; merchantId: string;
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
  var path_579328 = newJObject()
  var query_579329 = newJObject()
  var body_579330 = newJObject()
  add(query_579329, "key", newJString(key))
  add(query_579329, "prettyPrint", newJBool(prettyPrint))
  add(query_579329, "oauth_token", newJString(oauthToken))
  add(query_579329, "alt", newJString(alt))
  add(query_579329, "userIp", newJString(userIp))
  add(query_579329, "quotaUser", newJString(quotaUser))
  add(path_579328, "merchantId", newJString(merchantId))
  add(query_579329, "dryRun", newJBool(dryRun))
  if body != nil:
    body_579330 = body
  add(path_579328, "accountId", newJString(accountId))
  add(query_579329, "fields", newJString(fields))
  result = call_579327.call(path_579328, query_579329, nil, nil, body_579330)

var contentAccounttaxUpdate* = Call_ContentAccounttaxUpdate_579312(
    name: "contentAccounttaxUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax/{accountId}",
    validator: validate_ContentAccounttaxUpdate_579313, base: "/content/v2",
    url: url_ContentAccounttaxUpdate_579314, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxGet_579296 = ref object of OpenApiRestCall_578348
proc url_ContentAccounttaxGet_579298(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccounttaxGet_579297(path: JsonNode; query: JsonNode;
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
  var valid_579299 = path.getOrDefault("merchantId")
  valid_579299 = validateParameter(valid_579299, JString, required = true,
                                 default = nil)
  if valid_579299 != nil:
    section.add "merchantId", valid_579299
  var valid_579300 = path.getOrDefault("accountId")
  valid_579300 = validateParameter(valid_579300, JString, required = true,
                                 default = nil)
  if valid_579300 != nil:
    section.add "accountId", valid_579300
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
  var valid_579301 = query.getOrDefault("key")
  valid_579301 = validateParameter(valid_579301, JString, required = false,
                                 default = nil)
  if valid_579301 != nil:
    section.add "key", valid_579301
  var valid_579302 = query.getOrDefault("prettyPrint")
  valid_579302 = validateParameter(valid_579302, JBool, required = false,
                                 default = newJBool(true))
  if valid_579302 != nil:
    section.add "prettyPrint", valid_579302
  var valid_579303 = query.getOrDefault("oauth_token")
  valid_579303 = validateParameter(valid_579303, JString, required = false,
                                 default = nil)
  if valid_579303 != nil:
    section.add "oauth_token", valid_579303
  var valid_579304 = query.getOrDefault("alt")
  valid_579304 = validateParameter(valid_579304, JString, required = false,
                                 default = newJString("json"))
  if valid_579304 != nil:
    section.add "alt", valid_579304
  var valid_579305 = query.getOrDefault("userIp")
  valid_579305 = validateParameter(valid_579305, JString, required = false,
                                 default = nil)
  if valid_579305 != nil:
    section.add "userIp", valid_579305
  var valid_579306 = query.getOrDefault("quotaUser")
  valid_579306 = validateParameter(valid_579306, JString, required = false,
                                 default = nil)
  if valid_579306 != nil:
    section.add "quotaUser", valid_579306
  var valid_579307 = query.getOrDefault("fields")
  valid_579307 = validateParameter(valid_579307, JString, required = false,
                                 default = nil)
  if valid_579307 != nil:
    section.add "fields", valid_579307
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579308: Call_ContentAccounttaxGet_579296; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the tax settings of the account.
  ## 
  let valid = call_579308.validator(path, query, header, formData, body)
  let scheme = call_579308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579308.url(scheme.get, call_579308.host, call_579308.base,
                         call_579308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579308, url, valid)

proc call*(call_579309: Call_ContentAccounttaxGet_579296; merchantId: string;
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
  var path_579310 = newJObject()
  var query_579311 = newJObject()
  add(query_579311, "key", newJString(key))
  add(query_579311, "prettyPrint", newJBool(prettyPrint))
  add(query_579311, "oauth_token", newJString(oauthToken))
  add(query_579311, "alt", newJString(alt))
  add(query_579311, "userIp", newJString(userIp))
  add(query_579311, "quotaUser", newJString(quotaUser))
  add(path_579310, "merchantId", newJString(merchantId))
  add(path_579310, "accountId", newJString(accountId))
  add(query_579311, "fields", newJString(fields))
  result = call_579309.call(path_579310, query_579311, nil, nil, nil)

var contentAccounttaxGet* = Call_ContentAccounttaxGet_579296(
    name: "contentAccounttaxGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax/{accountId}",
    validator: validate_ContentAccounttaxGet_579297, base: "/content/v2",
    url: url_ContentAccounttaxGet_579298, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxPatch_579331 = ref object of OpenApiRestCall_578348
proc url_ContentAccounttaxPatch_579333(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccounttaxPatch_579332(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the tax settings of the account. This method supports patch semantics.
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
  var valid_579334 = path.getOrDefault("merchantId")
  valid_579334 = validateParameter(valid_579334, JString, required = true,
                                 default = nil)
  if valid_579334 != nil:
    section.add "merchantId", valid_579334
  var valid_579335 = path.getOrDefault("accountId")
  valid_579335 = validateParameter(valid_579335, JString, required = true,
                                 default = nil)
  if valid_579335 != nil:
    section.add "accountId", valid_579335
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
  var valid_579336 = query.getOrDefault("key")
  valid_579336 = validateParameter(valid_579336, JString, required = false,
                                 default = nil)
  if valid_579336 != nil:
    section.add "key", valid_579336
  var valid_579337 = query.getOrDefault("prettyPrint")
  valid_579337 = validateParameter(valid_579337, JBool, required = false,
                                 default = newJBool(true))
  if valid_579337 != nil:
    section.add "prettyPrint", valid_579337
  var valid_579338 = query.getOrDefault("oauth_token")
  valid_579338 = validateParameter(valid_579338, JString, required = false,
                                 default = nil)
  if valid_579338 != nil:
    section.add "oauth_token", valid_579338
  var valid_579339 = query.getOrDefault("alt")
  valid_579339 = validateParameter(valid_579339, JString, required = false,
                                 default = newJString("json"))
  if valid_579339 != nil:
    section.add "alt", valid_579339
  var valid_579340 = query.getOrDefault("userIp")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = nil)
  if valid_579340 != nil:
    section.add "userIp", valid_579340
  var valid_579341 = query.getOrDefault("quotaUser")
  valid_579341 = validateParameter(valid_579341, JString, required = false,
                                 default = nil)
  if valid_579341 != nil:
    section.add "quotaUser", valid_579341
  var valid_579342 = query.getOrDefault("dryRun")
  valid_579342 = validateParameter(valid_579342, JBool, required = false, default = nil)
  if valid_579342 != nil:
    section.add "dryRun", valid_579342
  var valid_579343 = query.getOrDefault("fields")
  valid_579343 = validateParameter(valid_579343, JString, required = false,
                                 default = nil)
  if valid_579343 != nil:
    section.add "fields", valid_579343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579345: Call_ContentAccounttaxPatch_579331; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the tax settings of the account. This method supports patch semantics.
  ## 
  let valid = call_579345.validator(path, query, header, formData, body)
  let scheme = call_579345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579345.url(scheme.get, call_579345.host, call_579345.base,
                         call_579345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579345, url, valid)

proc call*(call_579346: Call_ContentAccounttaxPatch_579331; merchantId: string;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; dryRun: bool = false; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentAccounttaxPatch
  ## Updates the tax settings of the account. This method supports patch semantics.
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
  var path_579347 = newJObject()
  var query_579348 = newJObject()
  var body_579349 = newJObject()
  add(query_579348, "key", newJString(key))
  add(query_579348, "prettyPrint", newJBool(prettyPrint))
  add(query_579348, "oauth_token", newJString(oauthToken))
  add(query_579348, "alt", newJString(alt))
  add(query_579348, "userIp", newJString(userIp))
  add(query_579348, "quotaUser", newJString(quotaUser))
  add(path_579347, "merchantId", newJString(merchantId))
  add(query_579348, "dryRun", newJBool(dryRun))
  if body != nil:
    body_579349 = body
  add(path_579347, "accountId", newJString(accountId))
  add(query_579348, "fields", newJString(fields))
  result = call_579346.call(path_579347, query_579348, nil, nil, body_579349)

var contentAccounttaxPatch* = Call_ContentAccounttaxPatch_579331(
    name: "contentAccounttaxPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax/{accountId}",
    validator: validate_ContentAccounttaxPatch_579332, base: "/content/v2",
    url: url_ContentAccounttaxPatch_579333, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsInsert_579367 = ref object of OpenApiRestCall_578348
proc url_ContentDatafeedsInsert_579369(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsInsert_579368(path: JsonNode; query: JsonNode;
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
  var valid_579370 = path.getOrDefault("merchantId")
  valid_579370 = validateParameter(valid_579370, JString, required = true,
                                 default = nil)
  if valid_579370 != nil:
    section.add "merchantId", valid_579370
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
  var valid_579371 = query.getOrDefault("key")
  valid_579371 = validateParameter(valid_579371, JString, required = false,
                                 default = nil)
  if valid_579371 != nil:
    section.add "key", valid_579371
  var valid_579372 = query.getOrDefault("prettyPrint")
  valid_579372 = validateParameter(valid_579372, JBool, required = false,
                                 default = newJBool(true))
  if valid_579372 != nil:
    section.add "prettyPrint", valid_579372
  var valid_579373 = query.getOrDefault("oauth_token")
  valid_579373 = validateParameter(valid_579373, JString, required = false,
                                 default = nil)
  if valid_579373 != nil:
    section.add "oauth_token", valid_579373
  var valid_579374 = query.getOrDefault("alt")
  valid_579374 = validateParameter(valid_579374, JString, required = false,
                                 default = newJString("json"))
  if valid_579374 != nil:
    section.add "alt", valid_579374
  var valid_579375 = query.getOrDefault("userIp")
  valid_579375 = validateParameter(valid_579375, JString, required = false,
                                 default = nil)
  if valid_579375 != nil:
    section.add "userIp", valid_579375
  var valid_579376 = query.getOrDefault("quotaUser")
  valid_579376 = validateParameter(valid_579376, JString, required = false,
                                 default = nil)
  if valid_579376 != nil:
    section.add "quotaUser", valid_579376
  var valid_579377 = query.getOrDefault("dryRun")
  valid_579377 = validateParameter(valid_579377, JBool, required = false, default = nil)
  if valid_579377 != nil:
    section.add "dryRun", valid_579377
  var valid_579378 = query.getOrDefault("fields")
  valid_579378 = validateParameter(valid_579378, JString, required = false,
                                 default = nil)
  if valid_579378 != nil:
    section.add "fields", valid_579378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579380: Call_ContentDatafeedsInsert_579367; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers a datafeed configuration with your Merchant Center account.
  ## 
  let valid = call_579380.validator(path, query, header, formData, body)
  let scheme = call_579380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579380.url(scheme.get, call_579380.host, call_579380.base,
                         call_579380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579380, url, valid)

proc call*(call_579381: Call_ContentDatafeedsInsert_579367; merchantId: string;
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
  var path_579382 = newJObject()
  var query_579383 = newJObject()
  var body_579384 = newJObject()
  add(query_579383, "key", newJString(key))
  add(query_579383, "prettyPrint", newJBool(prettyPrint))
  add(query_579383, "oauth_token", newJString(oauthToken))
  add(query_579383, "alt", newJString(alt))
  add(query_579383, "userIp", newJString(userIp))
  add(query_579383, "quotaUser", newJString(quotaUser))
  add(path_579382, "merchantId", newJString(merchantId))
  add(query_579383, "dryRun", newJBool(dryRun))
  if body != nil:
    body_579384 = body
  add(query_579383, "fields", newJString(fields))
  result = call_579381.call(path_579382, query_579383, nil, nil, body_579384)

var contentDatafeedsInsert* = Call_ContentDatafeedsInsert_579367(
    name: "contentDatafeedsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds",
    validator: validate_ContentDatafeedsInsert_579368, base: "/content/v2",
    url: url_ContentDatafeedsInsert_579369, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsList_579350 = ref object of OpenApiRestCall_578348
proc url_ContentDatafeedsList_579352(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsList_579351(path: JsonNode; query: JsonNode;
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
  var valid_579353 = path.getOrDefault("merchantId")
  valid_579353 = validateParameter(valid_579353, JString, required = true,
                                 default = nil)
  if valid_579353 != nil:
    section.add "merchantId", valid_579353
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
  var valid_579354 = query.getOrDefault("key")
  valid_579354 = validateParameter(valid_579354, JString, required = false,
                                 default = nil)
  if valid_579354 != nil:
    section.add "key", valid_579354
  var valid_579355 = query.getOrDefault("prettyPrint")
  valid_579355 = validateParameter(valid_579355, JBool, required = false,
                                 default = newJBool(true))
  if valid_579355 != nil:
    section.add "prettyPrint", valid_579355
  var valid_579356 = query.getOrDefault("oauth_token")
  valid_579356 = validateParameter(valid_579356, JString, required = false,
                                 default = nil)
  if valid_579356 != nil:
    section.add "oauth_token", valid_579356
  var valid_579357 = query.getOrDefault("alt")
  valid_579357 = validateParameter(valid_579357, JString, required = false,
                                 default = newJString("json"))
  if valid_579357 != nil:
    section.add "alt", valid_579357
  var valid_579358 = query.getOrDefault("userIp")
  valid_579358 = validateParameter(valid_579358, JString, required = false,
                                 default = nil)
  if valid_579358 != nil:
    section.add "userIp", valid_579358
  var valid_579359 = query.getOrDefault("quotaUser")
  valid_579359 = validateParameter(valid_579359, JString, required = false,
                                 default = nil)
  if valid_579359 != nil:
    section.add "quotaUser", valid_579359
  var valid_579360 = query.getOrDefault("pageToken")
  valid_579360 = validateParameter(valid_579360, JString, required = false,
                                 default = nil)
  if valid_579360 != nil:
    section.add "pageToken", valid_579360
  var valid_579361 = query.getOrDefault("fields")
  valid_579361 = validateParameter(valid_579361, JString, required = false,
                                 default = nil)
  if valid_579361 != nil:
    section.add "fields", valid_579361
  var valid_579362 = query.getOrDefault("maxResults")
  valid_579362 = validateParameter(valid_579362, JInt, required = false, default = nil)
  if valid_579362 != nil:
    section.add "maxResults", valid_579362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579363: Call_ContentDatafeedsList_579350; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the configurations for datafeeds in your Merchant Center account.
  ## 
  let valid = call_579363.validator(path, query, header, formData, body)
  let scheme = call_579363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579363.url(scheme.get, call_579363.host, call_579363.base,
                         call_579363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579363, url, valid)

proc call*(call_579364: Call_ContentDatafeedsList_579350; merchantId: string;
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
  var path_579365 = newJObject()
  var query_579366 = newJObject()
  add(query_579366, "key", newJString(key))
  add(query_579366, "prettyPrint", newJBool(prettyPrint))
  add(query_579366, "oauth_token", newJString(oauthToken))
  add(query_579366, "alt", newJString(alt))
  add(query_579366, "userIp", newJString(userIp))
  add(query_579366, "quotaUser", newJString(quotaUser))
  add(path_579365, "merchantId", newJString(merchantId))
  add(query_579366, "pageToken", newJString(pageToken))
  add(query_579366, "fields", newJString(fields))
  add(query_579366, "maxResults", newJInt(maxResults))
  result = call_579364.call(path_579365, query_579366, nil, nil, nil)

var contentDatafeedsList* = Call_ContentDatafeedsList_579350(
    name: "contentDatafeedsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds",
    validator: validate_ContentDatafeedsList_579351, base: "/content/v2",
    url: url_ContentDatafeedsList_579352, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsUpdate_579401 = ref object of OpenApiRestCall_578348
proc url_ContentDatafeedsUpdate_579403(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsUpdate_579402(path: JsonNode; query: JsonNode;
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
  var valid_579404 = path.getOrDefault("merchantId")
  valid_579404 = validateParameter(valid_579404, JString, required = true,
                                 default = nil)
  if valid_579404 != nil:
    section.add "merchantId", valid_579404
  var valid_579405 = path.getOrDefault("datafeedId")
  valid_579405 = validateParameter(valid_579405, JString, required = true,
                                 default = nil)
  if valid_579405 != nil:
    section.add "datafeedId", valid_579405
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
  var valid_579406 = query.getOrDefault("key")
  valid_579406 = validateParameter(valid_579406, JString, required = false,
                                 default = nil)
  if valid_579406 != nil:
    section.add "key", valid_579406
  var valid_579407 = query.getOrDefault("prettyPrint")
  valid_579407 = validateParameter(valid_579407, JBool, required = false,
                                 default = newJBool(true))
  if valid_579407 != nil:
    section.add "prettyPrint", valid_579407
  var valid_579408 = query.getOrDefault("oauth_token")
  valid_579408 = validateParameter(valid_579408, JString, required = false,
                                 default = nil)
  if valid_579408 != nil:
    section.add "oauth_token", valid_579408
  var valid_579409 = query.getOrDefault("alt")
  valid_579409 = validateParameter(valid_579409, JString, required = false,
                                 default = newJString("json"))
  if valid_579409 != nil:
    section.add "alt", valid_579409
  var valid_579410 = query.getOrDefault("userIp")
  valid_579410 = validateParameter(valid_579410, JString, required = false,
                                 default = nil)
  if valid_579410 != nil:
    section.add "userIp", valid_579410
  var valid_579411 = query.getOrDefault("quotaUser")
  valid_579411 = validateParameter(valid_579411, JString, required = false,
                                 default = nil)
  if valid_579411 != nil:
    section.add "quotaUser", valid_579411
  var valid_579412 = query.getOrDefault("dryRun")
  valid_579412 = validateParameter(valid_579412, JBool, required = false, default = nil)
  if valid_579412 != nil:
    section.add "dryRun", valid_579412
  var valid_579413 = query.getOrDefault("fields")
  valid_579413 = validateParameter(valid_579413, JString, required = false,
                                 default = nil)
  if valid_579413 != nil:
    section.add "fields", valid_579413
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579415: Call_ContentDatafeedsUpdate_579401; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a datafeed configuration of your Merchant Center account.
  ## 
  let valid = call_579415.validator(path, query, header, formData, body)
  let scheme = call_579415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579415.url(scheme.get, call_579415.host, call_579415.base,
                         call_579415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579415, url, valid)

proc call*(call_579416: Call_ContentDatafeedsUpdate_579401; merchantId: string;
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
  var path_579417 = newJObject()
  var query_579418 = newJObject()
  var body_579419 = newJObject()
  add(query_579418, "key", newJString(key))
  add(query_579418, "prettyPrint", newJBool(prettyPrint))
  add(query_579418, "oauth_token", newJString(oauthToken))
  add(query_579418, "alt", newJString(alt))
  add(query_579418, "userIp", newJString(userIp))
  add(query_579418, "quotaUser", newJString(quotaUser))
  add(path_579417, "merchantId", newJString(merchantId))
  add(query_579418, "dryRun", newJBool(dryRun))
  if body != nil:
    body_579419 = body
  add(path_579417, "datafeedId", newJString(datafeedId))
  add(query_579418, "fields", newJString(fields))
  result = call_579416.call(path_579417, query_579418, nil, nil, body_579419)

var contentDatafeedsUpdate* = Call_ContentDatafeedsUpdate_579401(
    name: "contentDatafeedsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsUpdate_579402, base: "/content/v2",
    url: url_ContentDatafeedsUpdate_579403, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsGet_579385 = ref object of OpenApiRestCall_578348
proc url_ContentDatafeedsGet_579387(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsGet_579386(path: JsonNode; query: JsonNode;
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
  var valid_579388 = path.getOrDefault("merchantId")
  valid_579388 = validateParameter(valid_579388, JString, required = true,
                                 default = nil)
  if valid_579388 != nil:
    section.add "merchantId", valid_579388
  var valid_579389 = path.getOrDefault("datafeedId")
  valid_579389 = validateParameter(valid_579389, JString, required = true,
                                 default = nil)
  if valid_579389 != nil:
    section.add "datafeedId", valid_579389
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
  var valid_579390 = query.getOrDefault("key")
  valid_579390 = validateParameter(valid_579390, JString, required = false,
                                 default = nil)
  if valid_579390 != nil:
    section.add "key", valid_579390
  var valid_579391 = query.getOrDefault("prettyPrint")
  valid_579391 = validateParameter(valid_579391, JBool, required = false,
                                 default = newJBool(true))
  if valid_579391 != nil:
    section.add "prettyPrint", valid_579391
  var valid_579392 = query.getOrDefault("oauth_token")
  valid_579392 = validateParameter(valid_579392, JString, required = false,
                                 default = nil)
  if valid_579392 != nil:
    section.add "oauth_token", valid_579392
  var valid_579393 = query.getOrDefault("alt")
  valid_579393 = validateParameter(valid_579393, JString, required = false,
                                 default = newJString("json"))
  if valid_579393 != nil:
    section.add "alt", valid_579393
  var valid_579394 = query.getOrDefault("userIp")
  valid_579394 = validateParameter(valid_579394, JString, required = false,
                                 default = nil)
  if valid_579394 != nil:
    section.add "userIp", valid_579394
  var valid_579395 = query.getOrDefault("quotaUser")
  valid_579395 = validateParameter(valid_579395, JString, required = false,
                                 default = nil)
  if valid_579395 != nil:
    section.add "quotaUser", valid_579395
  var valid_579396 = query.getOrDefault("fields")
  valid_579396 = validateParameter(valid_579396, JString, required = false,
                                 default = nil)
  if valid_579396 != nil:
    section.add "fields", valid_579396
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579397: Call_ContentDatafeedsGet_579385; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a datafeed configuration from your Merchant Center account.
  ## 
  let valid = call_579397.validator(path, query, header, formData, body)
  let scheme = call_579397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579397.url(scheme.get, call_579397.host, call_579397.base,
                         call_579397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579397, url, valid)

proc call*(call_579398: Call_ContentDatafeedsGet_579385; merchantId: string;
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
  var path_579399 = newJObject()
  var query_579400 = newJObject()
  add(query_579400, "key", newJString(key))
  add(query_579400, "prettyPrint", newJBool(prettyPrint))
  add(query_579400, "oauth_token", newJString(oauthToken))
  add(query_579400, "alt", newJString(alt))
  add(query_579400, "userIp", newJString(userIp))
  add(query_579400, "quotaUser", newJString(quotaUser))
  add(path_579399, "merchantId", newJString(merchantId))
  add(path_579399, "datafeedId", newJString(datafeedId))
  add(query_579400, "fields", newJString(fields))
  result = call_579398.call(path_579399, query_579400, nil, nil, nil)

var contentDatafeedsGet* = Call_ContentDatafeedsGet_579385(
    name: "contentDatafeedsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsGet_579386, base: "/content/v2",
    url: url_ContentDatafeedsGet_579387, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsPatch_579437 = ref object of OpenApiRestCall_578348
proc url_ContentDatafeedsPatch_579439(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsPatch_579438(path: JsonNode; query: JsonNode;
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
  var valid_579440 = path.getOrDefault("merchantId")
  valid_579440 = validateParameter(valid_579440, JString, required = true,
                                 default = nil)
  if valid_579440 != nil:
    section.add "merchantId", valid_579440
  var valid_579441 = path.getOrDefault("datafeedId")
  valid_579441 = validateParameter(valid_579441, JString, required = true,
                                 default = nil)
  if valid_579441 != nil:
    section.add "datafeedId", valid_579441
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
  var valid_579442 = query.getOrDefault("key")
  valid_579442 = validateParameter(valid_579442, JString, required = false,
                                 default = nil)
  if valid_579442 != nil:
    section.add "key", valid_579442
  var valid_579443 = query.getOrDefault("prettyPrint")
  valid_579443 = validateParameter(valid_579443, JBool, required = false,
                                 default = newJBool(true))
  if valid_579443 != nil:
    section.add "prettyPrint", valid_579443
  var valid_579444 = query.getOrDefault("oauth_token")
  valid_579444 = validateParameter(valid_579444, JString, required = false,
                                 default = nil)
  if valid_579444 != nil:
    section.add "oauth_token", valid_579444
  var valid_579445 = query.getOrDefault("alt")
  valid_579445 = validateParameter(valid_579445, JString, required = false,
                                 default = newJString("json"))
  if valid_579445 != nil:
    section.add "alt", valid_579445
  var valid_579446 = query.getOrDefault("userIp")
  valid_579446 = validateParameter(valid_579446, JString, required = false,
                                 default = nil)
  if valid_579446 != nil:
    section.add "userIp", valid_579446
  var valid_579447 = query.getOrDefault("quotaUser")
  valid_579447 = validateParameter(valid_579447, JString, required = false,
                                 default = nil)
  if valid_579447 != nil:
    section.add "quotaUser", valid_579447
  var valid_579448 = query.getOrDefault("dryRun")
  valid_579448 = validateParameter(valid_579448, JBool, required = false, default = nil)
  if valid_579448 != nil:
    section.add "dryRun", valid_579448
  var valid_579449 = query.getOrDefault("fields")
  valid_579449 = validateParameter(valid_579449, JString, required = false,
                                 default = nil)
  if valid_579449 != nil:
    section.add "fields", valid_579449
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579451: Call_ContentDatafeedsPatch_579437; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a datafeed configuration of your Merchant Center account. This method supports patch semantics.
  ## 
  let valid = call_579451.validator(path, query, header, formData, body)
  let scheme = call_579451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579451.url(scheme.get, call_579451.host, call_579451.base,
                         call_579451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579451, url, valid)

proc call*(call_579452: Call_ContentDatafeedsPatch_579437; merchantId: string;
          datafeedId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; dryRun: bool = false; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentDatafeedsPatch
  ## Updates a datafeed configuration of your Merchant Center account. This method supports patch semantics.
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
  var path_579453 = newJObject()
  var query_579454 = newJObject()
  var body_579455 = newJObject()
  add(query_579454, "key", newJString(key))
  add(query_579454, "prettyPrint", newJBool(prettyPrint))
  add(query_579454, "oauth_token", newJString(oauthToken))
  add(query_579454, "alt", newJString(alt))
  add(query_579454, "userIp", newJString(userIp))
  add(query_579454, "quotaUser", newJString(quotaUser))
  add(path_579453, "merchantId", newJString(merchantId))
  add(query_579454, "dryRun", newJBool(dryRun))
  if body != nil:
    body_579455 = body
  add(path_579453, "datafeedId", newJString(datafeedId))
  add(query_579454, "fields", newJString(fields))
  result = call_579452.call(path_579453, query_579454, nil, nil, body_579455)

var contentDatafeedsPatch* = Call_ContentDatafeedsPatch_579437(
    name: "contentDatafeedsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsPatch_579438, base: "/content/v2",
    url: url_ContentDatafeedsPatch_579439, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsDelete_579420 = ref object of OpenApiRestCall_578348
proc url_ContentDatafeedsDelete_579422(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsDelete_579421(path: JsonNode; query: JsonNode;
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
  var valid_579423 = path.getOrDefault("merchantId")
  valid_579423 = validateParameter(valid_579423, JString, required = true,
                                 default = nil)
  if valid_579423 != nil:
    section.add "merchantId", valid_579423
  var valid_579424 = path.getOrDefault("datafeedId")
  valid_579424 = validateParameter(valid_579424, JString, required = true,
                                 default = nil)
  if valid_579424 != nil:
    section.add "datafeedId", valid_579424
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
  var valid_579425 = query.getOrDefault("key")
  valid_579425 = validateParameter(valid_579425, JString, required = false,
                                 default = nil)
  if valid_579425 != nil:
    section.add "key", valid_579425
  var valid_579426 = query.getOrDefault("prettyPrint")
  valid_579426 = validateParameter(valid_579426, JBool, required = false,
                                 default = newJBool(true))
  if valid_579426 != nil:
    section.add "prettyPrint", valid_579426
  var valid_579427 = query.getOrDefault("oauth_token")
  valid_579427 = validateParameter(valid_579427, JString, required = false,
                                 default = nil)
  if valid_579427 != nil:
    section.add "oauth_token", valid_579427
  var valid_579428 = query.getOrDefault("alt")
  valid_579428 = validateParameter(valid_579428, JString, required = false,
                                 default = newJString("json"))
  if valid_579428 != nil:
    section.add "alt", valid_579428
  var valid_579429 = query.getOrDefault("userIp")
  valid_579429 = validateParameter(valid_579429, JString, required = false,
                                 default = nil)
  if valid_579429 != nil:
    section.add "userIp", valid_579429
  var valid_579430 = query.getOrDefault("quotaUser")
  valid_579430 = validateParameter(valid_579430, JString, required = false,
                                 default = nil)
  if valid_579430 != nil:
    section.add "quotaUser", valid_579430
  var valid_579431 = query.getOrDefault("dryRun")
  valid_579431 = validateParameter(valid_579431, JBool, required = false, default = nil)
  if valid_579431 != nil:
    section.add "dryRun", valid_579431
  var valid_579432 = query.getOrDefault("fields")
  valid_579432 = validateParameter(valid_579432, JString, required = false,
                                 default = nil)
  if valid_579432 != nil:
    section.add "fields", valid_579432
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579433: Call_ContentDatafeedsDelete_579420; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a datafeed configuration from your Merchant Center account.
  ## 
  let valid = call_579433.validator(path, query, header, formData, body)
  let scheme = call_579433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579433.url(scheme.get, call_579433.host, call_579433.base,
                         call_579433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579433, url, valid)

proc call*(call_579434: Call_ContentDatafeedsDelete_579420; merchantId: string;
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
  var path_579435 = newJObject()
  var query_579436 = newJObject()
  add(query_579436, "key", newJString(key))
  add(query_579436, "prettyPrint", newJBool(prettyPrint))
  add(query_579436, "oauth_token", newJString(oauthToken))
  add(query_579436, "alt", newJString(alt))
  add(query_579436, "userIp", newJString(userIp))
  add(query_579436, "quotaUser", newJString(quotaUser))
  add(path_579435, "merchantId", newJString(merchantId))
  add(query_579436, "dryRun", newJBool(dryRun))
  add(path_579435, "datafeedId", newJString(datafeedId))
  add(query_579436, "fields", newJString(fields))
  result = call_579434.call(path_579435, query_579436, nil, nil, nil)

var contentDatafeedsDelete* = Call_ContentDatafeedsDelete_579420(
    name: "contentDatafeedsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsDelete_579421, base: "/content/v2",
    url: url_ContentDatafeedsDelete_579422, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsFetchnow_579456 = ref object of OpenApiRestCall_578348
proc url_ContentDatafeedsFetchnow_579458(protocol: Scheme; host: string;
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

proc validate_ContentDatafeedsFetchnow_579457(path: JsonNode; query: JsonNode;
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
  var valid_579459 = path.getOrDefault("merchantId")
  valid_579459 = validateParameter(valid_579459, JString, required = true,
                                 default = nil)
  if valid_579459 != nil:
    section.add "merchantId", valid_579459
  var valid_579460 = path.getOrDefault("datafeedId")
  valid_579460 = validateParameter(valid_579460, JString, required = true,
                                 default = nil)
  if valid_579460 != nil:
    section.add "datafeedId", valid_579460
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
  var valid_579461 = query.getOrDefault("key")
  valid_579461 = validateParameter(valid_579461, JString, required = false,
                                 default = nil)
  if valid_579461 != nil:
    section.add "key", valid_579461
  var valid_579462 = query.getOrDefault("prettyPrint")
  valid_579462 = validateParameter(valid_579462, JBool, required = false,
                                 default = newJBool(true))
  if valid_579462 != nil:
    section.add "prettyPrint", valid_579462
  var valid_579463 = query.getOrDefault("oauth_token")
  valid_579463 = validateParameter(valid_579463, JString, required = false,
                                 default = nil)
  if valid_579463 != nil:
    section.add "oauth_token", valid_579463
  var valid_579464 = query.getOrDefault("alt")
  valid_579464 = validateParameter(valid_579464, JString, required = false,
                                 default = newJString("json"))
  if valid_579464 != nil:
    section.add "alt", valid_579464
  var valid_579465 = query.getOrDefault("userIp")
  valid_579465 = validateParameter(valid_579465, JString, required = false,
                                 default = nil)
  if valid_579465 != nil:
    section.add "userIp", valid_579465
  var valid_579466 = query.getOrDefault("quotaUser")
  valid_579466 = validateParameter(valid_579466, JString, required = false,
                                 default = nil)
  if valid_579466 != nil:
    section.add "quotaUser", valid_579466
  var valid_579467 = query.getOrDefault("dryRun")
  valid_579467 = validateParameter(valid_579467, JBool, required = false, default = nil)
  if valid_579467 != nil:
    section.add "dryRun", valid_579467
  var valid_579468 = query.getOrDefault("fields")
  valid_579468 = validateParameter(valid_579468, JString, required = false,
                                 default = nil)
  if valid_579468 != nil:
    section.add "fields", valid_579468
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579469: Call_ContentDatafeedsFetchnow_579456; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Invokes a fetch for the datafeed in your Merchant Center account.
  ## 
  let valid = call_579469.validator(path, query, header, formData, body)
  let scheme = call_579469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579469.url(scheme.get, call_579469.host, call_579469.base,
                         call_579469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579469, url, valid)

proc call*(call_579470: Call_ContentDatafeedsFetchnow_579456; merchantId: string;
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
  var path_579471 = newJObject()
  var query_579472 = newJObject()
  add(query_579472, "key", newJString(key))
  add(query_579472, "prettyPrint", newJBool(prettyPrint))
  add(query_579472, "oauth_token", newJString(oauthToken))
  add(query_579472, "alt", newJString(alt))
  add(query_579472, "userIp", newJString(userIp))
  add(query_579472, "quotaUser", newJString(quotaUser))
  add(path_579471, "merchantId", newJString(merchantId))
  add(query_579472, "dryRun", newJBool(dryRun))
  add(path_579471, "datafeedId", newJString(datafeedId))
  add(query_579472, "fields", newJString(fields))
  result = call_579470.call(path_579471, query_579472, nil, nil, nil)

var contentDatafeedsFetchnow* = Call_ContentDatafeedsFetchnow_579456(
    name: "contentDatafeedsFetchnow", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/datafeeds/{datafeedId}/fetchNow",
    validator: validate_ContentDatafeedsFetchnow_579457, base: "/content/v2",
    url: url_ContentDatafeedsFetchnow_579458, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesList_579473 = ref object of OpenApiRestCall_578348
proc url_ContentDatafeedstatusesList_579475(protocol: Scheme; host: string;
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

proc validate_ContentDatafeedstatusesList_579474(path: JsonNode; query: JsonNode;
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
  var valid_579476 = path.getOrDefault("merchantId")
  valid_579476 = validateParameter(valid_579476, JString, required = true,
                                 default = nil)
  if valid_579476 != nil:
    section.add "merchantId", valid_579476
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
  var valid_579477 = query.getOrDefault("key")
  valid_579477 = validateParameter(valid_579477, JString, required = false,
                                 default = nil)
  if valid_579477 != nil:
    section.add "key", valid_579477
  var valid_579478 = query.getOrDefault("prettyPrint")
  valid_579478 = validateParameter(valid_579478, JBool, required = false,
                                 default = newJBool(true))
  if valid_579478 != nil:
    section.add "prettyPrint", valid_579478
  var valid_579479 = query.getOrDefault("oauth_token")
  valid_579479 = validateParameter(valid_579479, JString, required = false,
                                 default = nil)
  if valid_579479 != nil:
    section.add "oauth_token", valid_579479
  var valid_579480 = query.getOrDefault("alt")
  valid_579480 = validateParameter(valid_579480, JString, required = false,
                                 default = newJString("json"))
  if valid_579480 != nil:
    section.add "alt", valid_579480
  var valid_579481 = query.getOrDefault("userIp")
  valid_579481 = validateParameter(valid_579481, JString, required = false,
                                 default = nil)
  if valid_579481 != nil:
    section.add "userIp", valid_579481
  var valid_579482 = query.getOrDefault("quotaUser")
  valid_579482 = validateParameter(valid_579482, JString, required = false,
                                 default = nil)
  if valid_579482 != nil:
    section.add "quotaUser", valid_579482
  var valid_579483 = query.getOrDefault("pageToken")
  valid_579483 = validateParameter(valid_579483, JString, required = false,
                                 default = nil)
  if valid_579483 != nil:
    section.add "pageToken", valid_579483
  var valid_579484 = query.getOrDefault("fields")
  valid_579484 = validateParameter(valid_579484, JString, required = false,
                                 default = nil)
  if valid_579484 != nil:
    section.add "fields", valid_579484
  var valid_579485 = query.getOrDefault("maxResults")
  valid_579485 = validateParameter(valid_579485, JInt, required = false, default = nil)
  if valid_579485 != nil:
    section.add "maxResults", valid_579485
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579486: Call_ContentDatafeedstatusesList_579473; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the datafeeds in your Merchant Center account.
  ## 
  let valid = call_579486.validator(path, query, header, formData, body)
  let scheme = call_579486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579486.url(scheme.get, call_579486.host, call_579486.base,
                         call_579486.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579486, url, valid)

proc call*(call_579487: Call_ContentDatafeedstatusesList_579473;
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
  var path_579488 = newJObject()
  var query_579489 = newJObject()
  add(query_579489, "key", newJString(key))
  add(query_579489, "prettyPrint", newJBool(prettyPrint))
  add(query_579489, "oauth_token", newJString(oauthToken))
  add(query_579489, "alt", newJString(alt))
  add(query_579489, "userIp", newJString(userIp))
  add(query_579489, "quotaUser", newJString(quotaUser))
  add(path_579488, "merchantId", newJString(merchantId))
  add(query_579489, "pageToken", newJString(pageToken))
  add(query_579489, "fields", newJString(fields))
  add(query_579489, "maxResults", newJInt(maxResults))
  result = call_579487.call(path_579488, query_579489, nil, nil, nil)

var contentDatafeedstatusesList* = Call_ContentDatafeedstatusesList_579473(
    name: "contentDatafeedstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeedstatuses",
    validator: validate_ContentDatafeedstatusesList_579474, base: "/content/v2",
    url: url_ContentDatafeedstatusesList_579475, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesGet_579490 = ref object of OpenApiRestCall_578348
proc url_ContentDatafeedstatusesGet_579492(protocol: Scheme; host: string;
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

proc validate_ContentDatafeedstatusesGet_579491(path: JsonNode; query: JsonNode;
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
  var valid_579493 = path.getOrDefault("merchantId")
  valid_579493 = validateParameter(valid_579493, JString, required = true,
                                 default = nil)
  if valid_579493 != nil:
    section.add "merchantId", valid_579493
  var valid_579494 = path.getOrDefault("datafeedId")
  valid_579494 = validateParameter(valid_579494, JString, required = true,
                                 default = nil)
  if valid_579494 != nil:
    section.add "datafeedId", valid_579494
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
  var valid_579495 = query.getOrDefault("key")
  valid_579495 = validateParameter(valid_579495, JString, required = false,
                                 default = nil)
  if valid_579495 != nil:
    section.add "key", valid_579495
  var valid_579496 = query.getOrDefault("prettyPrint")
  valid_579496 = validateParameter(valid_579496, JBool, required = false,
                                 default = newJBool(true))
  if valid_579496 != nil:
    section.add "prettyPrint", valid_579496
  var valid_579497 = query.getOrDefault("oauth_token")
  valid_579497 = validateParameter(valid_579497, JString, required = false,
                                 default = nil)
  if valid_579497 != nil:
    section.add "oauth_token", valid_579497
  var valid_579498 = query.getOrDefault("alt")
  valid_579498 = validateParameter(valid_579498, JString, required = false,
                                 default = newJString("json"))
  if valid_579498 != nil:
    section.add "alt", valid_579498
  var valid_579499 = query.getOrDefault("userIp")
  valid_579499 = validateParameter(valid_579499, JString, required = false,
                                 default = nil)
  if valid_579499 != nil:
    section.add "userIp", valid_579499
  var valid_579500 = query.getOrDefault("quotaUser")
  valid_579500 = validateParameter(valid_579500, JString, required = false,
                                 default = nil)
  if valid_579500 != nil:
    section.add "quotaUser", valid_579500
  var valid_579501 = query.getOrDefault("country")
  valid_579501 = validateParameter(valid_579501, JString, required = false,
                                 default = nil)
  if valid_579501 != nil:
    section.add "country", valid_579501
  var valid_579502 = query.getOrDefault("fields")
  valid_579502 = validateParameter(valid_579502, JString, required = false,
                                 default = nil)
  if valid_579502 != nil:
    section.add "fields", valid_579502
  var valid_579503 = query.getOrDefault("language")
  valid_579503 = validateParameter(valid_579503, JString, required = false,
                                 default = nil)
  if valid_579503 != nil:
    section.add "language", valid_579503
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579504: Call_ContentDatafeedstatusesGet_579490; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the status of a datafeed from your Merchant Center account.
  ## 
  let valid = call_579504.validator(path, query, header, formData, body)
  let scheme = call_579504.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579504.url(scheme.get, call_579504.host, call_579504.base,
                         call_579504.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579504, url, valid)

proc call*(call_579505: Call_ContentDatafeedstatusesGet_579490; merchantId: string;
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
  var path_579506 = newJObject()
  var query_579507 = newJObject()
  add(query_579507, "key", newJString(key))
  add(query_579507, "prettyPrint", newJBool(prettyPrint))
  add(query_579507, "oauth_token", newJString(oauthToken))
  add(query_579507, "alt", newJString(alt))
  add(query_579507, "userIp", newJString(userIp))
  add(query_579507, "quotaUser", newJString(quotaUser))
  add(path_579506, "merchantId", newJString(merchantId))
  add(query_579507, "country", newJString(country))
  add(path_579506, "datafeedId", newJString(datafeedId))
  add(query_579507, "fields", newJString(fields))
  add(query_579507, "language", newJString(language))
  result = call_579505.call(path_579506, query_579507, nil, nil, nil)

var contentDatafeedstatusesGet* = Call_ContentDatafeedstatusesGet_579490(
    name: "contentDatafeedstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/datafeedstatuses/{datafeedId}",
    validator: validate_ContentDatafeedstatusesGet_579491, base: "/content/v2",
    url: url_ContentDatafeedstatusesGet_579492, schemes: {Scheme.Https})
type
  Call_ContentInventorySet_579508 = ref object of OpenApiRestCall_578348
proc url_ContentInventorySet_579510(protocol: Scheme; host: string; base: string;
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

proc validate_ContentInventorySet_579509(path: JsonNode; query: JsonNode;
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
  var valid_579511 = path.getOrDefault("storeCode")
  valid_579511 = validateParameter(valid_579511, JString, required = true,
                                 default = nil)
  if valid_579511 != nil:
    section.add "storeCode", valid_579511
  var valid_579512 = path.getOrDefault("merchantId")
  valid_579512 = validateParameter(valid_579512, JString, required = true,
                                 default = nil)
  if valid_579512 != nil:
    section.add "merchantId", valid_579512
  var valid_579513 = path.getOrDefault("productId")
  valid_579513 = validateParameter(valid_579513, JString, required = true,
                                 default = nil)
  if valid_579513 != nil:
    section.add "productId", valid_579513
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
  var valid_579514 = query.getOrDefault("key")
  valid_579514 = validateParameter(valid_579514, JString, required = false,
                                 default = nil)
  if valid_579514 != nil:
    section.add "key", valid_579514
  var valid_579515 = query.getOrDefault("prettyPrint")
  valid_579515 = validateParameter(valid_579515, JBool, required = false,
                                 default = newJBool(true))
  if valid_579515 != nil:
    section.add "prettyPrint", valid_579515
  var valid_579516 = query.getOrDefault("oauth_token")
  valid_579516 = validateParameter(valid_579516, JString, required = false,
                                 default = nil)
  if valid_579516 != nil:
    section.add "oauth_token", valid_579516
  var valid_579517 = query.getOrDefault("alt")
  valid_579517 = validateParameter(valid_579517, JString, required = false,
                                 default = newJString("json"))
  if valid_579517 != nil:
    section.add "alt", valid_579517
  var valid_579518 = query.getOrDefault("userIp")
  valid_579518 = validateParameter(valid_579518, JString, required = false,
                                 default = nil)
  if valid_579518 != nil:
    section.add "userIp", valid_579518
  var valid_579519 = query.getOrDefault("quotaUser")
  valid_579519 = validateParameter(valid_579519, JString, required = false,
                                 default = nil)
  if valid_579519 != nil:
    section.add "quotaUser", valid_579519
  var valid_579520 = query.getOrDefault("dryRun")
  valid_579520 = validateParameter(valid_579520, JBool, required = false, default = nil)
  if valid_579520 != nil:
    section.add "dryRun", valid_579520
  var valid_579521 = query.getOrDefault("fields")
  valid_579521 = validateParameter(valid_579521, JString, required = false,
                                 default = nil)
  if valid_579521 != nil:
    section.add "fields", valid_579521
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579523: Call_ContentInventorySet_579508; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates price and availability of a product in your Merchant Center account.
  ## 
  let valid = call_579523.validator(path, query, header, formData, body)
  let scheme = call_579523.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579523.url(scheme.get, call_579523.host, call_579523.base,
                         call_579523.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579523, url, valid)

proc call*(call_579524: Call_ContentInventorySet_579508; storeCode: string;
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
  var path_579525 = newJObject()
  var query_579526 = newJObject()
  var body_579527 = newJObject()
  add(query_579526, "key", newJString(key))
  add(query_579526, "prettyPrint", newJBool(prettyPrint))
  add(query_579526, "oauth_token", newJString(oauthToken))
  add(path_579525, "storeCode", newJString(storeCode))
  add(query_579526, "alt", newJString(alt))
  add(query_579526, "userIp", newJString(userIp))
  add(query_579526, "quotaUser", newJString(quotaUser))
  add(path_579525, "merchantId", newJString(merchantId))
  add(query_579526, "dryRun", newJBool(dryRun))
  if body != nil:
    body_579527 = body
  add(query_579526, "fields", newJString(fields))
  add(path_579525, "productId", newJString(productId))
  result = call_579524.call(path_579525, query_579526, nil, nil, body_579527)

var contentInventorySet* = Call_ContentInventorySet_579508(
    name: "contentInventorySet", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/inventory/{storeCode}/products/{productId}",
    validator: validate_ContentInventorySet_579509, base: "/content/v2",
    url: url_ContentInventorySet_579510, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsList_579528 = ref object of OpenApiRestCall_578348
proc url_ContentLiasettingsList_579530(protocol: Scheme; host: string; base: string;
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

proc validate_ContentLiasettingsList_579529(path: JsonNode; query: JsonNode;
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
  var valid_579531 = path.getOrDefault("merchantId")
  valid_579531 = validateParameter(valid_579531, JString, required = true,
                                 default = nil)
  if valid_579531 != nil:
    section.add "merchantId", valid_579531
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
  var valid_579532 = query.getOrDefault("key")
  valid_579532 = validateParameter(valid_579532, JString, required = false,
                                 default = nil)
  if valid_579532 != nil:
    section.add "key", valid_579532
  var valid_579533 = query.getOrDefault("prettyPrint")
  valid_579533 = validateParameter(valid_579533, JBool, required = false,
                                 default = newJBool(true))
  if valid_579533 != nil:
    section.add "prettyPrint", valid_579533
  var valid_579534 = query.getOrDefault("oauth_token")
  valid_579534 = validateParameter(valid_579534, JString, required = false,
                                 default = nil)
  if valid_579534 != nil:
    section.add "oauth_token", valid_579534
  var valid_579535 = query.getOrDefault("alt")
  valid_579535 = validateParameter(valid_579535, JString, required = false,
                                 default = newJString("json"))
  if valid_579535 != nil:
    section.add "alt", valid_579535
  var valid_579536 = query.getOrDefault("userIp")
  valid_579536 = validateParameter(valid_579536, JString, required = false,
                                 default = nil)
  if valid_579536 != nil:
    section.add "userIp", valid_579536
  var valid_579537 = query.getOrDefault("quotaUser")
  valid_579537 = validateParameter(valid_579537, JString, required = false,
                                 default = nil)
  if valid_579537 != nil:
    section.add "quotaUser", valid_579537
  var valid_579538 = query.getOrDefault("pageToken")
  valid_579538 = validateParameter(valid_579538, JString, required = false,
                                 default = nil)
  if valid_579538 != nil:
    section.add "pageToken", valid_579538
  var valid_579539 = query.getOrDefault("fields")
  valid_579539 = validateParameter(valid_579539, JString, required = false,
                                 default = nil)
  if valid_579539 != nil:
    section.add "fields", valid_579539
  var valid_579540 = query.getOrDefault("maxResults")
  valid_579540 = validateParameter(valid_579540, JInt, required = false, default = nil)
  if valid_579540 != nil:
    section.add "maxResults", valid_579540
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579541: Call_ContentLiasettingsList_579528; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the LIA settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_579541.validator(path, query, header, formData, body)
  let scheme = call_579541.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579541.url(scheme.get, call_579541.host, call_579541.base,
                         call_579541.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579541, url, valid)

proc call*(call_579542: Call_ContentLiasettingsList_579528; merchantId: string;
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
  var path_579543 = newJObject()
  var query_579544 = newJObject()
  add(query_579544, "key", newJString(key))
  add(query_579544, "prettyPrint", newJBool(prettyPrint))
  add(query_579544, "oauth_token", newJString(oauthToken))
  add(query_579544, "alt", newJString(alt))
  add(query_579544, "userIp", newJString(userIp))
  add(query_579544, "quotaUser", newJString(quotaUser))
  add(path_579543, "merchantId", newJString(merchantId))
  add(query_579544, "pageToken", newJString(pageToken))
  add(query_579544, "fields", newJString(fields))
  add(query_579544, "maxResults", newJInt(maxResults))
  result = call_579542.call(path_579543, query_579544, nil, nil, nil)

var contentLiasettingsList* = Call_ContentLiasettingsList_579528(
    name: "contentLiasettingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings",
    validator: validate_ContentLiasettingsList_579529, base: "/content/v2",
    url: url_ContentLiasettingsList_579530, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsUpdate_579561 = ref object of OpenApiRestCall_578348
proc url_ContentLiasettingsUpdate_579563(protocol: Scheme; host: string;
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

proc validate_ContentLiasettingsUpdate_579562(path: JsonNode; query: JsonNode;
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
  var valid_579564 = path.getOrDefault("merchantId")
  valid_579564 = validateParameter(valid_579564, JString, required = true,
                                 default = nil)
  if valid_579564 != nil:
    section.add "merchantId", valid_579564
  var valid_579565 = path.getOrDefault("accountId")
  valid_579565 = validateParameter(valid_579565, JString, required = true,
                                 default = nil)
  if valid_579565 != nil:
    section.add "accountId", valid_579565
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
  var valid_579566 = query.getOrDefault("key")
  valid_579566 = validateParameter(valid_579566, JString, required = false,
                                 default = nil)
  if valid_579566 != nil:
    section.add "key", valid_579566
  var valid_579567 = query.getOrDefault("prettyPrint")
  valid_579567 = validateParameter(valid_579567, JBool, required = false,
                                 default = newJBool(true))
  if valid_579567 != nil:
    section.add "prettyPrint", valid_579567
  var valid_579568 = query.getOrDefault("oauth_token")
  valid_579568 = validateParameter(valid_579568, JString, required = false,
                                 default = nil)
  if valid_579568 != nil:
    section.add "oauth_token", valid_579568
  var valid_579569 = query.getOrDefault("alt")
  valid_579569 = validateParameter(valid_579569, JString, required = false,
                                 default = newJString("json"))
  if valid_579569 != nil:
    section.add "alt", valid_579569
  var valid_579570 = query.getOrDefault("userIp")
  valid_579570 = validateParameter(valid_579570, JString, required = false,
                                 default = nil)
  if valid_579570 != nil:
    section.add "userIp", valid_579570
  var valid_579571 = query.getOrDefault("quotaUser")
  valid_579571 = validateParameter(valid_579571, JString, required = false,
                                 default = nil)
  if valid_579571 != nil:
    section.add "quotaUser", valid_579571
  var valid_579572 = query.getOrDefault("dryRun")
  valid_579572 = validateParameter(valid_579572, JBool, required = false, default = nil)
  if valid_579572 != nil:
    section.add "dryRun", valid_579572
  var valid_579573 = query.getOrDefault("fields")
  valid_579573 = validateParameter(valid_579573, JString, required = false,
                                 default = nil)
  if valid_579573 != nil:
    section.add "fields", valid_579573
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579575: Call_ContentLiasettingsUpdate_579561; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the LIA settings of the account.
  ## 
  let valid = call_579575.validator(path, query, header, formData, body)
  let scheme = call_579575.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579575.url(scheme.get, call_579575.host, call_579575.base,
                         call_579575.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579575, url, valid)

proc call*(call_579576: Call_ContentLiasettingsUpdate_579561; merchantId: string;
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
  var path_579577 = newJObject()
  var query_579578 = newJObject()
  var body_579579 = newJObject()
  add(query_579578, "key", newJString(key))
  add(query_579578, "prettyPrint", newJBool(prettyPrint))
  add(query_579578, "oauth_token", newJString(oauthToken))
  add(query_579578, "alt", newJString(alt))
  add(query_579578, "userIp", newJString(userIp))
  add(query_579578, "quotaUser", newJString(quotaUser))
  add(path_579577, "merchantId", newJString(merchantId))
  add(query_579578, "dryRun", newJBool(dryRun))
  if body != nil:
    body_579579 = body
  add(path_579577, "accountId", newJString(accountId))
  add(query_579578, "fields", newJString(fields))
  result = call_579576.call(path_579577, query_579578, nil, nil, body_579579)

var contentLiasettingsUpdate* = Call_ContentLiasettingsUpdate_579561(
    name: "contentLiasettingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}",
    validator: validate_ContentLiasettingsUpdate_579562, base: "/content/v2",
    url: url_ContentLiasettingsUpdate_579563, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsGet_579545 = ref object of OpenApiRestCall_578348
proc url_ContentLiasettingsGet_579547(protocol: Scheme; host: string; base: string;
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

proc validate_ContentLiasettingsGet_579546(path: JsonNode; query: JsonNode;
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
  var valid_579548 = path.getOrDefault("merchantId")
  valid_579548 = validateParameter(valid_579548, JString, required = true,
                                 default = nil)
  if valid_579548 != nil:
    section.add "merchantId", valid_579548
  var valid_579549 = path.getOrDefault("accountId")
  valid_579549 = validateParameter(valid_579549, JString, required = true,
                                 default = nil)
  if valid_579549 != nil:
    section.add "accountId", valid_579549
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
  var valid_579550 = query.getOrDefault("key")
  valid_579550 = validateParameter(valid_579550, JString, required = false,
                                 default = nil)
  if valid_579550 != nil:
    section.add "key", valid_579550
  var valid_579551 = query.getOrDefault("prettyPrint")
  valid_579551 = validateParameter(valid_579551, JBool, required = false,
                                 default = newJBool(true))
  if valid_579551 != nil:
    section.add "prettyPrint", valid_579551
  var valid_579552 = query.getOrDefault("oauth_token")
  valid_579552 = validateParameter(valid_579552, JString, required = false,
                                 default = nil)
  if valid_579552 != nil:
    section.add "oauth_token", valid_579552
  var valid_579553 = query.getOrDefault("alt")
  valid_579553 = validateParameter(valid_579553, JString, required = false,
                                 default = newJString("json"))
  if valid_579553 != nil:
    section.add "alt", valid_579553
  var valid_579554 = query.getOrDefault("userIp")
  valid_579554 = validateParameter(valid_579554, JString, required = false,
                                 default = nil)
  if valid_579554 != nil:
    section.add "userIp", valid_579554
  var valid_579555 = query.getOrDefault("quotaUser")
  valid_579555 = validateParameter(valid_579555, JString, required = false,
                                 default = nil)
  if valid_579555 != nil:
    section.add "quotaUser", valid_579555
  var valid_579556 = query.getOrDefault("fields")
  valid_579556 = validateParameter(valid_579556, JString, required = false,
                                 default = nil)
  if valid_579556 != nil:
    section.add "fields", valid_579556
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579557: Call_ContentLiasettingsGet_579545; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the LIA settings of the account.
  ## 
  let valid = call_579557.validator(path, query, header, formData, body)
  let scheme = call_579557.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579557.url(scheme.get, call_579557.host, call_579557.base,
                         call_579557.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579557, url, valid)

proc call*(call_579558: Call_ContentLiasettingsGet_579545; merchantId: string;
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
  var path_579559 = newJObject()
  var query_579560 = newJObject()
  add(query_579560, "key", newJString(key))
  add(query_579560, "prettyPrint", newJBool(prettyPrint))
  add(query_579560, "oauth_token", newJString(oauthToken))
  add(query_579560, "alt", newJString(alt))
  add(query_579560, "userIp", newJString(userIp))
  add(query_579560, "quotaUser", newJString(quotaUser))
  add(path_579559, "merchantId", newJString(merchantId))
  add(path_579559, "accountId", newJString(accountId))
  add(query_579560, "fields", newJString(fields))
  result = call_579558.call(path_579559, query_579560, nil, nil, nil)

var contentLiasettingsGet* = Call_ContentLiasettingsGet_579545(
    name: "contentLiasettingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}",
    validator: validate_ContentLiasettingsGet_579546, base: "/content/v2",
    url: url_ContentLiasettingsGet_579547, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsPatch_579580 = ref object of OpenApiRestCall_578348
proc url_ContentLiasettingsPatch_579582(protocol: Scheme; host: string; base: string;
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

proc validate_ContentLiasettingsPatch_579581(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the LIA settings of the account. This method supports patch semantics.
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
  var valid_579583 = path.getOrDefault("merchantId")
  valid_579583 = validateParameter(valid_579583, JString, required = true,
                                 default = nil)
  if valid_579583 != nil:
    section.add "merchantId", valid_579583
  var valid_579584 = path.getOrDefault("accountId")
  valid_579584 = validateParameter(valid_579584, JString, required = true,
                                 default = nil)
  if valid_579584 != nil:
    section.add "accountId", valid_579584
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
  var valid_579585 = query.getOrDefault("key")
  valid_579585 = validateParameter(valid_579585, JString, required = false,
                                 default = nil)
  if valid_579585 != nil:
    section.add "key", valid_579585
  var valid_579586 = query.getOrDefault("prettyPrint")
  valid_579586 = validateParameter(valid_579586, JBool, required = false,
                                 default = newJBool(true))
  if valid_579586 != nil:
    section.add "prettyPrint", valid_579586
  var valid_579587 = query.getOrDefault("oauth_token")
  valid_579587 = validateParameter(valid_579587, JString, required = false,
                                 default = nil)
  if valid_579587 != nil:
    section.add "oauth_token", valid_579587
  var valid_579588 = query.getOrDefault("alt")
  valid_579588 = validateParameter(valid_579588, JString, required = false,
                                 default = newJString("json"))
  if valid_579588 != nil:
    section.add "alt", valid_579588
  var valid_579589 = query.getOrDefault("userIp")
  valid_579589 = validateParameter(valid_579589, JString, required = false,
                                 default = nil)
  if valid_579589 != nil:
    section.add "userIp", valid_579589
  var valid_579590 = query.getOrDefault("quotaUser")
  valid_579590 = validateParameter(valid_579590, JString, required = false,
                                 default = nil)
  if valid_579590 != nil:
    section.add "quotaUser", valid_579590
  var valid_579591 = query.getOrDefault("dryRun")
  valid_579591 = validateParameter(valid_579591, JBool, required = false, default = nil)
  if valid_579591 != nil:
    section.add "dryRun", valid_579591
  var valid_579592 = query.getOrDefault("fields")
  valid_579592 = validateParameter(valid_579592, JString, required = false,
                                 default = nil)
  if valid_579592 != nil:
    section.add "fields", valid_579592
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579594: Call_ContentLiasettingsPatch_579580; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the LIA settings of the account. This method supports patch semantics.
  ## 
  let valid = call_579594.validator(path, query, header, formData, body)
  let scheme = call_579594.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579594.url(scheme.get, call_579594.host, call_579594.base,
                         call_579594.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579594, url, valid)

proc call*(call_579595: Call_ContentLiasettingsPatch_579580; merchantId: string;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; dryRun: bool = false; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentLiasettingsPatch
  ## Updates the LIA settings of the account. This method supports patch semantics.
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
  var path_579596 = newJObject()
  var query_579597 = newJObject()
  var body_579598 = newJObject()
  add(query_579597, "key", newJString(key))
  add(query_579597, "prettyPrint", newJBool(prettyPrint))
  add(query_579597, "oauth_token", newJString(oauthToken))
  add(query_579597, "alt", newJString(alt))
  add(query_579597, "userIp", newJString(userIp))
  add(query_579597, "quotaUser", newJString(quotaUser))
  add(path_579596, "merchantId", newJString(merchantId))
  add(query_579597, "dryRun", newJBool(dryRun))
  if body != nil:
    body_579598 = body
  add(path_579596, "accountId", newJString(accountId))
  add(query_579597, "fields", newJString(fields))
  result = call_579595.call(path_579596, query_579597, nil, nil, body_579598)

var contentLiasettingsPatch* = Call_ContentLiasettingsPatch_579580(
    name: "contentLiasettingsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}",
    validator: validate_ContentLiasettingsPatch_579581, base: "/content/v2",
    url: url_ContentLiasettingsPatch_579582, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsGetaccessiblegmbaccounts_579599 = ref object of OpenApiRestCall_578348
proc url_ContentLiasettingsGetaccessiblegmbaccounts_579601(protocol: Scheme;
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

proc validate_ContentLiasettingsGetaccessiblegmbaccounts_579600(path: JsonNode;
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
  var valid_579602 = path.getOrDefault("merchantId")
  valid_579602 = validateParameter(valid_579602, JString, required = true,
                                 default = nil)
  if valid_579602 != nil:
    section.add "merchantId", valid_579602
  var valid_579603 = path.getOrDefault("accountId")
  valid_579603 = validateParameter(valid_579603, JString, required = true,
                                 default = nil)
  if valid_579603 != nil:
    section.add "accountId", valid_579603
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
  var valid_579604 = query.getOrDefault("key")
  valid_579604 = validateParameter(valid_579604, JString, required = false,
                                 default = nil)
  if valid_579604 != nil:
    section.add "key", valid_579604
  var valid_579605 = query.getOrDefault("prettyPrint")
  valid_579605 = validateParameter(valid_579605, JBool, required = false,
                                 default = newJBool(true))
  if valid_579605 != nil:
    section.add "prettyPrint", valid_579605
  var valid_579606 = query.getOrDefault("oauth_token")
  valid_579606 = validateParameter(valid_579606, JString, required = false,
                                 default = nil)
  if valid_579606 != nil:
    section.add "oauth_token", valid_579606
  var valid_579607 = query.getOrDefault("alt")
  valid_579607 = validateParameter(valid_579607, JString, required = false,
                                 default = newJString("json"))
  if valid_579607 != nil:
    section.add "alt", valid_579607
  var valid_579608 = query.getOrDefault("userIp")
  valid_579608 = validateParameter(valid_579608, JString, required = false,
                                 default = nil)
  if valid_579608 != nil:
    section.add "userIp", valid_579608
  var valid_579609 = query.getOrDefault("quotaUser")
  valid_579609 = validateParameter(valid_579609, JString, required = false,
                                 default = nil)
  if valid_579609 != nil:
    section.add "quotaUser", valid_579609
  var valid_579610 = query.getOrDefault("fields")
  valid_579610 = validateParameter(valid_579610, JString, required = false,
                                 default = nil)
  if valid_579610 != nil:
    section.add "fields", valid_579610
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579611: Call_ContentLiasettingsGetaccessiblegmbaccounts_579599;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of accessible Google My Business accounts.
  ## 
  let valid = call_579611.validator(path, query, header, formData, body)
  let scheme = call_579611.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579611.url(scheme.get, call_579611.host, call_579611.base,
                         call_579611.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579611, url, valid)

proc call*(call_579612: Call_ContentLiasettingsGetaccessiblegmbaccounts_579599;
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
  var path_579613 = newJObject()
  var query_579614 = newJObject()
  add(query_579614, "key", newJString(key))
  add(query_579614, "prettyPrint", newJBool(prettyPrint))
  add(query_579614, "oauth_token", newJString(oauthToken))
  add(query_579614, "alt", newJString(alt))
  add(query_579614, "userIp", newJString(userIp))
  add(query_579614, "quotaUser", newJString(quotaUser))
  add(path_579613, "merchantId", newJString(merchantId))
  add(path_579613, "accountId", newJString(accountId))
  add(query_579614, "fields", newJString(fields))
  result = call_579612.call(path_579613, query_579614, nil, nil, nil)

var contentLiasettingsGetaccessiblegmbaccounts* = Call_ContentLiasettingsGetaccessiblegmbaccounts_579599(
    name: "contentLiasettingsGetaccessiblegmbaccounts", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/accessiblegmbaccounts",
    validator: validate_ContentLiasettingsGetaccessiblegmbaccounts_579600,
    base: "/content/v2", url: url_ContentLiasettingsGetaccessiblegmbaccounts_579601,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsRequestgmbaccess_579615 = ref object of OpenApiRestCall_578348
proc url_ContentLiasettingsRequestgmbaccess_579617(protocol: Scheme; host: string;
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

proc validate_ContentLiasettingsRequestgmbaccess_579616(path: JsonNode;
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
  var valid_579618 = path.getOrDefault("merchantId")
  valid_579618 = validateParameter(valid_579618, JString, required = true,
                                 default = nil)
  if valid_579618 != nil:
    section.add "merchantId", valid_579618
  var valid_579619 = path.getOrDefault("accountId")
  valid_579619 = validateParameter(valid_579619, JString, required = true,
                                 default = nil)
  if valid_579619 != nil:
    section.add "accountId", valid_579619
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
  var valid_579620 = query.getOrDefault("key")
  valid_579620 = validateParameter(valid_579620, JString, required = false,
                                 default = nil)
  if valid_579620 != nil:
    section.add "key", valid_579620
  var valid_579621 = query.getOrDefault("prettyPrint")
  valid_579621 = validateParameter(valid_579621, JBool, required = false,
                                 default = newJBool(true))
  if valid_579621 != nil:
    section.add "prettyPrint", valid_579621
  var valid_579622 = query.getOrDefault("oauth_token")
  valid_579622 = validateParameter(valid_579622, JString, required = false,
                                 default = nil)
  if valid_579622 != nil:
    section.add "oauth_token", valid_579622
  assert query != nil,
        "query argument is necessary due to required `gmbEmail` field"
  var valid_579623 = query.getOrDefault("gmbEmail")
  valid_579623 = validateParameter(valid_579623, JString, required = true,
                                 default = nil)
  if valid_579623 != nil:
    section.add "gmbEmail", valid_579623
  var valid_579624 = query.getOrDefault("alt")
  valid_579624 = validateParameter(valid_579624, JString, required = false,
                                 default = newJString("json"))
  if valid_579624 != nil:
    section.add "alt", valid_579624
  var valid_579625 = query.getOrDefault("userIp")
  valid_579625 = validateParameter(valid_579625, JString, required = false,
                                 default = nil)
  if valid_579625 != nil:
    section.add "userIp", valid_579625
  var valid_579626 = query.getOrDefault("quotaUser")
  valid_579626 = validateParameter(valid_579626, JString, required = false,
                                 default = nil)
  if valid_579626 != nil:
    section.add "quotaUser", valid_579626
  var valid_579627 = query.getOrDefault("fields")
  valid_579627 = validateParameter(valid_579627, JString, required = false,
                                 default = nil)
  if valid_579627 != nil:
    section.add "fields", valid_579627
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579628: Call_ContentLiasettingsRequestgmbaccess_579615;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests access to a specified Google My Business account.
  ## 
  let valid = call_579628.validator(path, query, header, formData, body)
  let scheme = call_579628.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579628.url(scheme.get, call_579628.host, call_579628.base,
                         call_579628.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579628, url, valid)

proc call*(call_579629: Call_ContentLiasettingsRequestgmbaccess_579615;
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
  var path_579630 = newJObject()
  var query_579631 = newJObject()
  add(query_579631, "key", newJString(key))
  add(query_579631, "prettyPrint", newJBool(prettyPrint))
  add(query_579631, "oauth_token", newJString(oauthToken))
  add(query_579631, "gmbEmail", newJString(gmbEmail))
  add(query_579631, "alt", newJString(alt))
  add(query_579631, "userIp", newJString(userIp))
  add(query_579631, "quotaUser", newJString(quotaUser))
  add(path_579630, "merchantId", newJString(merchantId))
  add(path_579630, "accountId", newJString(accountId))
  add(query_579631, "fields", newJString(fields))
  result = call_579629.call(path_579630, query_579631, nil, nil, nil)

var contentLiasettingsRequestgmbaccess* = Call_ContentLiasettingsRequestgmbaccess_579615(
    name: "contentLiasettingsRequestgmbaccess", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/requestgmbaccess",
    validator: validate_ContentLiasettingsRequestgmbaccess_579616,
    base: "/content/v2", url: url_ContentLiasettingsRequestgmbaccess_579617,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsRequestinventoryverification_579632 = ref object of OpenApiRestCall_578348
proc url_ContentLiasettingsRequestinventoryverification_579634(protocol: Scheme;
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

proc validate_ContentLiasettingsRequestinventoryverification_579633(
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
  var valid_579635 = path.getOrDefault("merchantId")
  valid_579635 = validateParameter(valid_579635, JString, required = true,
                                 default = nil)
  if valid_579635 != nil:
    section.add "merchantId", valid_579635
  var valid_579636 = path.getOrDefault("country")
  valid_579636 = validateParameter(valid_579636, JString, required = true,
                                 default = nil)
  if valid_579636 != nil:
    section.add "country", valid_579636
  var valid_579637 = path.getOrDefault("accountId")
  valid_579637 = validateParameter(valid_579637, JString, required = true,
                                 default = nil)
  if valid_579637 != nil:
    section.add "accountId", valid_579637
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
  var valid_579638 = query.getOrDefault("key")
  valid_579638 = validateParameter(valid_579638, JString, required = false,
                                 default = nil)
  if valid_579638 != nil:
    section.add "key", valid_579638
  var valid_579639 = query.getOrDefault("prettyPrint")
  valid_579639 = validateParameter(valid_579639, JBool, required = false,
                                 default = newJBool(true))
  if valid_579639 != nil:
    section.add "prettyPrint", valid_579639
  var valid_579640 = query.getOrDefault("oauth_token")
  valid_579640 = validateParameter(valid_579640, JString, required = false,
                                 default = nil)
  if valid_579640 != nil:
    section.add "oauth_token", valid_579640
  var valid_579641 = query.getOrDefault("alt")
  valid_579641 = validateParameter(valid_579641, JString, required = false,
                                 default = newJString("json"))
  if valid_579641 != nil:
    section.add "alt", valid_579641
  var valid_579642 = query.getOrDefault("userIp")
  valid_579642 = validateParameter(valid_579642, JString, required = false,
                                 default = nil)
  if valid_579642 != nil:
    section.add "userIp", valid_579642
  var valid_579643 = query.getOrDefault("quotaUser")
  valid_579643 = validateParameter(valid_579643, JString, required = false,
                                 default = nil)
  if valid_579643 != nil:
    section.add "quotaUser", valid_579643
  var valid_579644 = query.getOrDefault("fields")
  valid_579644 = validateParameter(valid_579644, JString, required = false,
                                 default = nil)
  if valid_579644 != nil:
    section.add "fields", valid_579644
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579645: Call_ContentLiasettingsRequestinventoryverification_579632;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests inventory validation for the specified country.
  ## 
  let valid = call_579645.validator(path, query, header, formData, body)
  let scheme = call_579645.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579645.url(scheme.get, call_579645.host, call_579645.base,
                         call_579645.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579645, url, valid)

proc call*(call_579646: Call_ContentLiasettingsRequestinventoryverification_579632;
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
  var path_579647 = newJObject()
  var query_579648 = newJObject()
  add(query_579648, "key", newJString(key))
  add(query_579648, "prettyPrint", newJBool(prettyPrint))
  add(query_579648, "oauth_token", newJString(oauthToken))
  add(query_579648, "alt", newJString(alt))
  add(query_579648, "userIp", newJString(userIp))
  add(query_579648, "quotaUser", newJString(quotaUser))
  add(path_579647, "merchantId", newJString(merchantId))
  add(path_579647, "country", newJString(country))
  add(path_579647, "accountId", newJString(accountId))
  add(query_579648, "fields", newJString(fields))
  result = call_579646.call(path_579647, query_579648, nil, nil, nil)

var contentLiasettingsRequestinventoryverification* = Call_ContentLiasettingsRequestinventoryverification_579632(
    name: "contentLiasettingsRequestinventoryverification",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}/requestinventoryverification/{country}",
    validator: validate_ContentLiasettingsRequestinventoryverification_579633,
    base: "/content/v2", url: url_ContentLiasettingsRequestinventoryverification_579634,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsSetinventoryverificationcontact_579649 = ref object of OpenApiRestCall_578348
proc url_ContentLiasettingsSetinventoryverificationcontact_579651(
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

proc validate_ContentLiasettingsSetinventoryverificationcontact_579650(
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
  var valid_579652 = path.getOrDefault("merchantId")
  valid_579652 = validateParameter(valid_579652, JString, required = true,
                                 default = nil)
  if valid_579652 != nil:
    section.add "merchantId", valid_579652
  var valid_579653 = path.getOrDefault("accountId")
  valid_579653 = validateParameter(valid_579653, JString, required = true,
                                 default = nil)
  if valid_579653 != nil:
    section.add "accountId", valid_579653
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
  var valid_579654 = query.getOrDefault("key")
  valid_579654 = validateParameter(valid_579654, JString, required = false,
                                 default = nil)
  if valid_579654 != nil:
    section.add "key", valid_579654
  var valid_579655 = query.getOrDefault("prettyPrint")
  valid_579655 = validateParameter(valid_579655, JBool, required = false,
                                 default = newJBool(true))
  if valid_579655 != nil:
    section.add "prettyPrint", valid_579655
  var valid_579656 = query.getOrDefault("oauth_token")
  valid_579656 = validateParameter(valid_579656, JString, required = false,
                                 default = nil)
  if valid_579656 != nil:
    section.add "oauth_token", valid_579656
  assert query != nil,
        "query argument is necessary due to required `contactEmail` field"
  var valid_579657 = query.getOrDefault("contactEmail")
  valid_579657 = validateParameter(valid_579657, JString, required = true,
                                 default = nil)
  if valid_579657 != nil:
    section.add "contactEmail", valid_579657
  var valid_579658 = query.getOrDefault("alt")
  valid_579658 = validateParameter(valid_579658, JString, required = false,
                                 default = newJString("json"))
  if valid_579658 != nil:
    section.add "alt", valid_579658
  var valid_579659 = query.getOrDefault("userIp")
  valid_579659 = validateParameter(valid_579659, JString, required = false,
                                 default = nil)
  if valid_579659 != nil:
    section.add "userIp", valid_579659
  var valid_579660 = query.getOrDefault("quotaUser")
  valid_579660 = validateParameter(valid_579660, JString, required = false,
                                 default = nil)
  if valid_579660 != nil:
    section.add "quotaUser", valid_579660
  var valid_579661 = query.getOrDefault("contactName")
  valid_579661 = validateParameter(valid_579661, JString, required = true,
                                 default = nil)
  if valid_579661 != nil:
    section.add "contactName", valid_579661
  var valid_579662 = query.getOrDefault("country")
  valid_579662 = validateParameter(valid_579662, JString, required = true,
                                 default = nil)
  if valid_579662 != nil:
    section.add "country", valid_579662
  var valid_579663 = query.getOrDefault("fields")
  valid_579663 = validateParameter(valid_579663, JString, required = false,
                                 default = nil)
  if valid_579663 != nil:
    section.add "fields", valid_579663
  var valid_579664 = query.getOrDefault("language")
  valid_579664 = validateParameter(valid_579664, JString, required = true,
                                 default = nil)
  if valid_579664 != nil:
    section.add "language", valid_579664
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579665: Call_ContentLiasettingsSetinventoryverificationcontact_579649;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the inventory verification contract for the specified country.
  ## 
  let valid = call_579665.validator(path, query, header, formData, body)
  let scheme = call_579665.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579665.url(scheme.get, call_579665.host, call_579665.base,
                         call_579665.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579665, url, valid)

proc call*(call_579666: Call_ContentLiasettingsSetinventoryverificationcontact_579649;
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
  var path_579667 = newJObject()
  var query_579668 = newJObject()
  add(query_579668, "key", newJString(key))
  add(query_579668, "prettyPrint", newJBool(prettyPrint))
  add(query_579668, "oauth_token", newJString(oauthToken))
  add(query_579668, "contactEmail", newJString(contactEmail))
  add(query_579668, "alt", newJString(alt))
  add(query_579668, "userIp", newJString(userIp))
  add(query_579668, "quotaUser", newJString(quotaUser))
  add(path_579667, "merchantId", newJString(merchantId))
  add(query_579668, "contactName", newJString(contactName))
  add(query_579668, "country", newJString(country))
  add(path_579667, "accountId", newJString(accountId))
  add(query_579668, "fields", newJString(fields))
  add(query_579668, "language", newJString(language))
  result = call_579666.call(path_579667, query_579668, nil, nil, nil)

var contentLiasettingsSetinventoryverificationcontact* = Call_ContentLiasettingsSetinventoryverificationcontact_579649(
    name: "contentLiasettingsSetinventoryverificationcontact",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}/setinventoryverificationcontact",
    validator: validate_ContentLiasettingsSetinventoryverificationcontact_579650,
    base: "/content/v2",
    url: url_ContentLiasettingsSetinventoryverificationcontact_579651,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsSetposdataprovider_579669 = ref object of OpenApiRestCall_578348
proc url_ContentLiasettingsSetposdataprovider_579671(protocol: Scheme;
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

proc validate_ContentLiasettingsSetposdataprovider_579670(path: JsonNode;
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
  var valid_579672 = path.getOrDefault("merchantId")
  valid_579672 = validateParameter(valid_579672, JString, required = true,
                                 default = nil)
  if valid_579672 != nil:
    section.add "merchantId", valid_579672
  var valid_579673 = path.getOrDefault("accountId")
  valid_579673 = validateParameter(valid_579673, JString, required = true,
                                 default = nil)
  if valid_579673 != nil:
    section.add "accountId", valid_579673
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
  var valid_579674 = query.getOrDefault("key")
  valid_579674 = validateParameter(valid_579674, JString, required = false,
                                 default = nil)
  if valid_579674 != nil:
    section.add "key", valid_579674
  var valid_579675 = query.getOrDefault("prettyPrint")
  valid_579675 = validateParameter(valid_579675, JBool, required = false,
                                 default = newJBool(true))
  if valid_579675 != nil:
    section.add "prettyPrint", valid_579675
  var valid_579676 = query.getOrDefault("oauth_token")
  valid_579676 = validateParameter(valid_579676, JString, required = false,
                                 default = nil)
  if valid_579676 != nil:
    section.add "oauth_token", valid_579676
  var valid_579677 = query.getOrDefault("alt")
  valid_579677 = validateParameter(valid_579677, JString, required = false,
                                 default = newJString("json"))
  if valid_579677 != nil:
    section.add "alt", valid_579677
  var valid_579678 = query.getOrDefault("userIp")
  valid_579678 = validateParameter(valid_579678, JString, required = false,
                                 default = nil)
  if valid_579678 != nil:
    section.add "userIp", valid_579678
  var valid_579679 = query.getOrDefault("quotaUser")
  valid_579679 = validateParameter(valid_579679, JString, required = false,
                                 default = nil)
  if valid_579679 != nil:
    section.add "quotaUser", valid_579679
  var valid_579680 = query.getOrDefault("posDataProviderId")
  valid_579680 = validateParameter(valid_579680, JString, required = false,
                                 default = nil)
  if valid_579680 != nil:
    section.add "posDataProviderId", valid_579680
  assert query != nil, "query argument is necessary due to required `country` field"
  var valid_579681 = query.getOrDefault("country")
  valid_579681 = validateParameter(valid_579681, JString, required = true,
                                 default = nil)
  if valid_579681 != nil:
    section.add "country", valid_579681
  var valid_579682 = query.getOrDefault("fields")
  valid_579682 = validateParameter(valid_579682, JString, required = false,
                                 default = nil)
  if valid_579682 != nil:
    section.add "fields", valid_579682
  var valid_579683 = query.getOrDefault("posExternalAccountId")
  valid_579683 = validateParameter(valid_579683, JString, required = false,
                                 default = nil)
  if valid_579683 != nil:
    section.add "posExternalAccountId", valid_579683
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579684: Call_ContentLiasettingsSetposdataprovider_579669;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the POS data provider for the specified country.
  ## 
  let valid = call_579684.validator(path, query, header, formData, body)
  let scheme = call_579684.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579684.url(scheme.get, call_579684.host, call_579684.base,
                         call_579684.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579684, url, valid)

proc call*(call_579685: Call_ContentLiasettingsSetposdataprovider_579669;
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
  var path_579686 = newJObject()
  var query_579687 = newJObject()
  add(query_579687, "key", newJString(key))
  add(query_579687, "prettyPrint", newJBool(prettyPrint))
  add(query_579687, "oauth_token", newJString(oauthToken))
  add(query_579687, "alt", newJString(alt))
  add(query_579687, "userIp", newJString(userIp))
  add(query_579687, "quotaUser", newJString(quotaUser))
  add(path_579686, "merchantId", newJString(merchantId))
  add(query_579687, "posDataProviderId", newJString(posDataProviderId))
  add(query_579687, "country", newJString(country))
  add(path_579686, "accountId", newJString(accountId))
  add(query_579687, "fields", newJString(fields))
  add(query_579687, "posExternalAccountId", newJString(posExternalAccountId))
  result = call_579685.call(path_579686, query_579687, nil, nil, nil)

var contentLiasettingsSetposdataprovider* = Call_ContentLiasettingsSetposdataprovider_579669(
    name: "contentLiasettingsSetposdataprovider", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/setposdataprovider",
    validator: validate_ContentLiasettingsSetposdataprovider_579670,
    base: "/content/v2", url: url_ContentLiasettingsSetposdataprovider_579671,
    schemes: {Scheme.Https})
type
  Call_ContentOrderinvoicesCreatechargeinvoice_579688 = ref object of OpenApiRestCall_578348
proc url_ContentOrderinvoicesCreatechargeinvoice_579690(protocol: Scheme;
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

proc validate_ContentOrderinvoicesCreatechargeinvoice_579689(path: JsonNode;
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
  var valid_579691 = path.getOrDefault("merchantId")
  valid_579691 = validateParameter(valid_579691, JString, required = true,
                                 default = nil)
  if valid_579691 != nil:
    section.add "merchantId", valid_579691
  var valid_579692 = path.getOrDefault("orderId")
  valid_579692 = validateParameter(valid_579692, JString, required = true,
                                 default = nil)
  if valid_579692 != nil:
    section.add "orderId", valid_579692
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
  var valid_579693 = query.getOrDefault("key")
  valid_579693 = validateParameter(valid_579693, JString, required = false,
                                 default = nil)
  if valid_579693 != nil:
    section.add "key", valid_579693
  var valid_579694 = query.getOrDefault("prettyPrint")
  valid_579694 = validateParameter(valid_579694, JBool, required = false,
                                 default = newJBool(true))
  if valid_579694 != nil:
    section.add "prettyPrint", valid_579694
  var valid_579695 = query.getOrDefault("oauth_token")
  valid_579695 = validateParameter(valid_579695, JString, required = false,
                                 default = nil)
  if valid_579695 != nil:
    section.add "oauth_token", valid_579695
  var valid_579696 = query.getOrDefault("alt")
  valid_579696 = validateParameter(valid_579696, JString, required = false,
                                 default = newJString("json"))
  if valid_579696 != nil:
    section.add "alt", valid_579696
  var valid_579697 = query.getOrDefault("userIp")
  valid_579697 = validateParameter(valid_579697, JString, required = false,
                                 default = nil)
  if valid_579697 != nil:
    section.add "userIp", valid_579697
  var valid_579698 = query.getOrDefault("quotaUser")
  valid_579698 = validateParameter(valid_579698, JString, required = false,
                                 default = nil)
  if valid_579698 != nil:
    section.add "quotaUser", valid_579698
  var valid_579699 = query.getOrDefault("fields")
  valid_579699 = validateParameter(valid_579699, JString, required = false,
                                 default = nil)
  if valid_579699 != nil:
    section.add "fields", valid_579699
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579701: Call_ContentOrderinvoicesCreatechargeinvoice_579688;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a charge invoice for a shipment group, and triggers a charge capture for orderinvoice enabled orders.
  ## 
  let valid = call_579701.validator(path, query, header, formData, body)
  let scheme = call_579701.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579701.url(scheme.get, call_579701.host, call_579701.base,
                         call_579701.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579701, url, valid)

proc call*(call_579702: Call_ContentOrderinvoicesCreatechargeinvoice_579688;
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
  var path_579703 = newJObject()
  var query_579704 = newJObject()
  var body_579705 = newJObject()
  add(query_579704, "key", newJString(key))
  add(query_579704, "prettyPrint", newJBool(prettyPrint))
  add(query_579704, "oauth_token", newJString(oauthToken))
  add(query_579704, "alt", newJString(alt))
  add(query_579704, "userIp", newJString(userIp))
  add(query_579704, "quotaUser", newJString(quotaUser))
  add(path_579703, "merchantId", newJString(merchantId))
  if body != nil:
    body_579705 = body
  add(query_579704, "fields", newJString(fields))
  add(path_579703, "orderId", newJString(orderId))
  result = call_579702.call(path_579703, query_579704, nil, nil, body_579705)

var contentOrderinvoicesCreatechargeinvoice* = Call_ContentOrderinvoicesCreatechargeinvoice_579688(
    name: "contentOrderinvoicesCreatechargeinvoice", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderinvoices/{orderId}/createChargeInvoice",
    validator: validate_ContentOrderinvoicesCreatechargeinvoice_579689,
    base: "/content/v2", url: url_ContentOrderinvoicesCreatechargeinvoice_579690,
    schemes: {Scheme.Https})
type
  Call_ContentOrderinvoicesCreaterefundinvoice_579706 = ref object of OpenApiRestCall_578348
proc url_ContentOrderinvoicesCreaterefundinvoice_579708(protocol: Scheme;
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

proc validate_ContentOrderinvoicesCreaterefundinvoice_579707(path: JsonNode;
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
  var valid_579709 = path.getOrDefault("merchantId")
  valid_579709 = validateParameter(valid_579709, JString, required = true,
                                 default = nil)
  if valid_579709 != nil:
    section.add "merchantId", valid_579709
  var valid_579710 = path.getOrDefault("orderId")
  valid_579710 = validateParameter(valid_579710, JString, required = true,
                                 default = nil)
  if valid_579710 != nil:
    section.add "orderId", valid_579710
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
  var valid_579711 = query.getOrDefault("key")
  valid_579711 = validateParameter(valid_579711, JString, required = false,
                                 default = nil)
  if valid_579711 != nil:
    section.add "key", valid_579711
  var valid_579712 = query.getOrDefault("prettyPrint")
  valid_579712 = validateParameter(valid_579712, JBool, required = false,
                                 default = newJBool(true))
  if valid_579712 != nil:
    section.add "prettyPrint", valid_579712
  var valid_579713 = query.getOrDefault("oauth_token")
  valid_579713 = validateParameter(valid_579713, JString, required = false,
                                 default = nil)
  if valid_579713 != nil:
    section.add "oauth_token", valid_579713
  var valid_579714 = query.getOrDefault("alt")
  valid_579714 = validateParameter(valid_579714, JString, required = false,
                                 default = newJString("json"))
  if valid_579714 != nil:
    section.add "alt", valid_579714
  var valid_579715 = query.getOrDefault("userIp")
  valid_579715 = validateParameter(valid_579715, JString, required = false,
                                 default = nil)
  if valid_579715 != nil:
    section.add "userIp", valid_579715
  var valid_579716 = query.getOrDefault("quotaUser")
  valid_579716 = validateParameter(valid_579716, JString, required = false,
                                 default = nil)
  if valid_579716 != nil:
    section.add "quotaUser", valid_579716
  var valid_579717 = query.getOrDefault("fields")
  valid_579717 = validateParameter(valid_579717, JString, required = false,
                                 default = nil)
  if valid_579717 != nil:
    section.add "fields", valid_579717
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579719: Call_ContentOrderinvoicesCreaterefundinvoice_579706;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a refund invoice for one or more shipment groups, and triggers a refund for orderinvoice enabled orders. This can only be used for line items that have previously been charged using createChargeInvoice. All amounts (except for the summary) are incremental with respect to the previous invoice.
  ## 
  let valid = call_579719.validator(path, query, header, formData, body)
  let scheme = call_579719.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579719.url(scheme.get, call_579719.host, call_579719.base,
                         call_579719.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579719, url, valid)

proc call*(call_579720: Call_ContentOrderinvoicesCreaterefundinvoice_579706;
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
  var path_579721 = newJObject()
  var query_579722 = newJObject()
  var body_579723 = newJObject()
  add(query_579722, "key", newJString(key))
  add(query_579722, "prettyPrint", newJBool(prettyPrint))
  add(query_579722, "oauth_token", newJString(oauthToken))
  add(query_579722, "alt", newJString(alt))
  add(query_579722, "userIp", newJString(userIp))
  add(query_579722, "quotaUser", newJString(quotaUser))
  add(path_579721, "merchantId", newJString(merchantId))
  if body != nil:
    body_579723 = body
  add(query_579722, "fields", newJString(fields))
  add(path_579721, "orderId", newJString(orderId))
  result = call_579720.call(path_579721, query_579722, nil, nil, body_579723)

var contentOrderinvoicesCreaterefundinvoice* = Call_ContentOrderinvoicesCreaterefundinvoice_579706(
    name: "contentOrderinvoicesCreaterefundinvoice", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderinvoices/{orderId}/createRefundInvoice",
    validator: validate_ContentOrderinvoicesCreaterefundinvoice_579707,
    base: "/content/v2", url: url_ContentOrderinvoicesCreaterefundinvoice_579708,
    schemes: {Scheme.Https})
type
  Call_ContentOrderpaymentsNotifyauthapproved_579724 = ref object of OpenApiRestCall_578348
proc url_ContentOrderpaymentsNotifyauthapproved_579726(protocol: Scheme;
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

proc validate_ContentOrderpaymentsNotifyauthapproved_579725(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Notify about successfully authorizing user's payment method for a given amount.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order for for which payment authorization is happening.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_579727 = path.getOrDefault("merchantId")
  valid_579727 = validateParameter(valid_579727, JString, required = true,
                                 default = nil)
  if valid_579727 != nil:
    section.add "merchantId", valid_579727
  var valid_579728 = path.getOrDefault("orderId")
  valid_579728 = validateParameter(valid_579728, JString, required = true,
                                 default = nil)
  if valid_579728 != nil:
    section.add "orderId", valid_579728
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
  var valid_579729 = query.getOrDefault("key")
  valid_579729 = validateParameter(valid_579729, JString, required = false,
                                 default = nil)
  if valid_579729 != nil:
    section.add "key", valid_579729
  var valid_579730 = query.getOrDefault("prettyPrint")
  valid_579730 = validateParameter(valid_579730, JBool, required = false,
                                 default = newJBool(true))
  if valid_579730 != nil:
    section.add "prettyPrint", valid_579730
  var valid_579731 = query.getOrDefault("oauth_token")
  valid_579731 = validateParameter(valid_579731, JString, required = false,
                                 default = nil)
  if valid_579731 != nil:
    section.add "oauth_token", valid_579731
  var valid_579732 = query.getOrDefault("alt")
  valid_579732 = validateParameter(valid_579732, JString, required = false,
                                 default = newJString("json"))
  if valid_579732 != nil:
    section.add "alt", valid_579732
  var valid_579733 = query.getOrDefault("userIp")
  valid_579733 = validateParameter(valid_579733, JString, required = false,
                                 default = nil)
  if valid_579733 != nil:
    section.add "userIp", valid_579733
  var valid_579734 = query.getOrDefault("quotaUser")
  valid_579734 = validateParameter(valid_579734, JString, required = false,
                                 default = nil)
  if valid_579734 != nil:
    section.add "quotaUser", valid_579734
  var valid_579735 = query.getOrDefault("fields")
  valid_579735 = validateParameter(valid_579735, JString, required = false,
                                 default = nil)
  if valid_579735 != nil:
    section.add "fields", valid_579735
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579737: Call_ContentOrderpaymentsNotifyauthapproved_579724;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Notify about successfully authorizing user's payment method for a given amount.
  ## 
  let valid = call_579737.validator(path, query, header, formData, body)
  let scheme = call_579737.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579737.url(scheme.get, call_579737.host, call_579737.base,
                         call_579737.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579737, url, valid)

proc call*(call_579738: Call_ContentOrderpaymentsNotifyauthapproved_579724;
          merchantId: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentOrderpaymentsNotifyauthapproved
  ## Notify about successfully authorizing user's payment method for a given amount.
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
  ##          : The ID of the order for for which payment authorization is happening.
  var path_579739 = newJObject()
  var query_579740 = newJObject()
  var body_579741 = newJObject()
  add(query_579740, "key", newJString(key))
  add(query_579740, "prettyPrint", newJBool(prettyPrint))
  add(query_579740, "oauth_token", newJString(oauthToken))
  add(query_579740, "alt", newJString(alt))
  add(query_579740, "userIp", newJString(userIp))
  add(query_579740, "quotaUser", newJString(quotaUser))
  add(path_579739, "merchantId", newJString(merchantId))
  if body != nil:
    body_579741 = body
  add(query_579740, "fields", newJString(fields))
  add(path_579739, "orderId", newJString(orderId))
  result = call_579738.call(path_579739, query_579740, nil, nil, body_579741)

var contentOrderpaymentsNotifyauthapproved* = Call_ContentOrderpaymentsNotifyauthapproved_579724(
    name: "contentOrderpaymentsNotifyauthapproved", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderpayments/{orderId}/notifyAuthApproved",
    validator: validate_ContentOrderpaymentsNotifyauthapproved_579725,
    base: "/content/v2", url: url_ContentOrderpaymentsNotifyauthapproved_579726,
    schemes: {Scheme.Https})
type
  Call_ContentOrderpaymentsNotifyauthdeclined_579742 = ref object of OpenApiRestCall_578348
proc url_ContentOrderpaymentsNotifyauthdeclined_579744(protocol: Scheme;
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

proc validate_ContentOrderpaymentsNotifyauthdeclined_579743(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Notify about failure to authorize user's payment method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order for which payment authorization was declined.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_579745 = path.getOrDefault("merchantId")
  valid_579745 = validateParameter(valid_579745, JString, required = true,
                                 default = nil)
  if valid_579745 != nil:
    section.add "merchantId", valid_579745
  var valid_579746 = path.getOrDefault("orderId")
  valid_579746 = validateParameter(valid_579746, JString, required = true,
                                 default = nil)
  if valid_579746 != nil:
    section.add "orderId", valid_579746
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
  var valid_579747 = query.getOrDefault("key")
  valid_579747 = validateParameter(valid_579747, JString, required = false,
                                 default = nil)
  if valid_579747 != nil:
    section.add "key", valid_579747
  var valid_579748 = query.getOrDefault("prettyPrint")
  valid_579748 = validateParameter(valid_579748, JBool, required = false,
                                 default = newJBool(true))
  if valid_579748 != nil:
    section.add "prettyPrint", valid_579748
  var valid_579749 = query.getOrDefault("oauth_token")
  valid_579749 = validateParameter(valid_579749, JString, required = false,
                                 default = nil)
  if valid_579749 != nil:
    section.add "oauth_token", valid_579749
  var valid_579750 = query.getOrDefault("alt")
  valid_579750 = validateParameter(valid_579750, JString, required = false,
                                 default = newJString("json"))
  if valid_579750 != nil:
    section.add "alt", valid_579750
  var valid_579751 = query.getOrDefault("userIp")
  valid_579751 = validateParameter(valid_579751, JString, required = false,
                                 default = nil)
  if valid_579751 != nil:
    section.add "userIp", valid_579751
  var valid_579752 = query.getOrDefault("quotaUser")
  valid_579752 = validateParameter(valid_579752, JString, required = false,
                                 default = nil)
  if valid_579752 != nil:
    section.add "quotaUser", valid_579752
  var valid_579753 = query.getOrDefault("fields")
  valid_579753 = validateParameter(valid_579753, JString, required = false,
                                 default = nil)
  if valid_579753 != nil:
    section.add "fields", valid_579753
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579755: Call_ContentOrderpaymentsNotifyauthdeclined_579742;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Notify about failure to authorize user's payment method.
  ## 
  let valid = call_579755.validator(path, query, header, formData, body)
  let scheme = call_579755.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579755.url(scheme.get, call_579755.host, call_579755.base,
                         call_579755.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579755, url, valid)

proc call*(call_579756: Call_ContentOrderpaymentsNotifyauthdeclined_579742;
          merchantId: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentOrderpaymentsNotifyauthdeclined
  ## Notify about failure to authorize user's payment method.
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
  ##          : The ID of the order for which payment authorization was declined.
  var path_579757 = newJObject()
  var query_579758 = newJObject()
  var body_579759 = newJObject()
  add(query_579758, "key", newJString(key))
  add(query_579758, "prettyPrint", newJBool(prettyPrint))
  add(query_579758, "oauth_token", newJString(oauthToken))
  add(query_579758, "alt", newJString(alt))
  add(query_579758, "userIp", newJString(userIp))
  add(query_579758, "quotaUser", newJString(quotaUser))
  add(path_579757, "merchantId", newJString(merchantId))
  if body != nil:
    body_579759 = body
  add(query_579758, "fields", newJString(fields))
  add(path_579757, "orderId", newJString(orderId))
  result = call_579756.call(path_579757, query_579758, nil, nil, body_579759)

var contentOrderpaymentsNotifyauthdeclined* = Call_ContentOrderpaymentsNotifyauthdeclined_579742(
    name: "contentOrderpaymentsNotifyauthdeclined", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderpayments/{orderId}/notifyAuthDeclined",
    validator: validate_ContentOrderpaymentsNotifyauthdeclined_579743,
    base: "/content/v2", url: url_ContentOrderpaymentsNotifyauthdeclined_579744,
    schemes: {Scheme.Https})
type
  Call_ContentOrderpaymentsNotifycharge_579760 = ref object of OpenApiRestCall_578348
proc url_ContentOrderpaymentsNotifycharge_579762(protocol: Scheme; host: string;
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

proc validate_ContentOrderpaymentsNotifycharge_579761(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Notify about charge on user's selected payments method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order for which charge is happening.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_579763 = path.getOrDefault("merchantId")
  valid_579763 = validateParameter(valid_579763, JString, required = true,
                                 default = nil)
  if valid_579763 != nil:
    section.add "merchantId", valid_579763
  var valid_579764 = path.getOrDefault("orderId")
  valid_579764 = validateParameter(valid_579764, JString, required = true,
                                 default = nil)
  if valid_579764 != nil:
    section.add "orderId", valid_579764
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
  var valid_579765 = query.getOrDefault("key")
  valid_579765 = validateParameter(valid_579765, JString, required = false,
                                 default = nil)
  if valid_579765 != nil:
    section.add "key", valid_579765
  var valid_579766 = query.getOrDefault("prettyPrint")
  valid_579766 = validateParameter(valid_579766, JBool, required = false,
                                 default = newJBool(true))
  if valid_579766 != nil:
    section.add "prettyPrint", valid_579766
  var valid_579767 = query.getOrDefault("oauth_token")
  valid_579767 = validateParameter(valid_579767, JString, required = false,
                                 default = nil)
  if valid_579767 != nil:
    section.add "oauth_token", valid_579767
  var valid_579768 = query.getOrDefault("alt")
  valid_579768 = validateParameter(valid_579768, JString, required = false,
                                 default = newJString("json"))
  if valid_579768 != nil:
    section.add "alt", valid_579768
  var valid_579769 = query.getOrDefault("userIp")
  valid_579769 = validateParameter(valid_579769, JString, required = false,
                                 default = nil)
  if valid_579769 != nil:
    section.add "userIp", valid_579769
  var valid_579770 = query.getOrDefault("quotaUser")
  valid_579770 = validateParameter(valid_579770, JString, required = false,
                                 default = nil)
  if valid_579770 != nil:
    section.add "quotaUser", valid_579770
  var valid_579771 = query.getOrDefault("fields")
  valid_579771 = validateParameter(valid_579771, JString, required = false,
                                 default = nil)
  if valid_579771 != nil:
    section.add "fields", valid_579771
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579773: Call_ContentOrderpaymentsNotifycharge_579760;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Notify about charge on user's selected payments method.
  ## 
  let valid = call_579773.validator(path, query, header, formData, body)
  let scheme = call_579773.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579773.url(scheme.get, call_579773.host, call_579773.base,
                         call_579773.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579773, url, valid)

proc call*(call_579774: Call_ContentOrderpaymentsNotifycharge_579760;
          merchantId: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentOrderpaymentsNotifycharge
  ## Notify about charge on user's selected payments method.
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
  ##          : The ID of the order for which charge is happening.
  var path_579775 = newJObject()
  var query_579776 = newJObject()
  var body_579777 = newJObject()
  add(query_579776, "key", newJString(key))
  add(query_579776, "prettyPrint", newJBool(prettyPrint))
  add(query_579776, "oauth_token", newJString(oauthToken))
  add(query_579776, "alt", newJString(alt))
  add(query_579776, "userIp", newJString(userIp))
  add(query_579776, "quotaUser", newJString(quotaUser))
  add(path_579775, "merchantId", newJString(merchantId))
  if body != nil:
    body_579777 = body
  add(query_579776, "fields", newJString(fields))
  add(path_579775, "orderId", newJString(orderId))
  result = call_579774.call(path_579775, query_579776, nil, nil, body_579777)

var contentOrderpaymentsNotifycharge* = Call_ContentOrderpaymentsNotifycharge_579760(
    name: "contentOrderpaymentsNotifycharge", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderpayments/{orderId}/notifyCharge",
    validator: validate_ContentOrderpaymentsNotifycharge_579761,
    base: "/content/v2", url: url_ContentOrderpaymentsNotifycharge_579762,
    schemes: {Scheme.Https})
type
  Call_ContentOrderpaymentsNotifyrefund_579778 = ref object of OpenApiRestCall_578348
proc url_ContentOrderpaymentsNotifyrefund_579780(protocol: Scheme; host: string;
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

proc validate_ContentOrderpaymentsNotifyrefund_579779(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Notify about refund on user's selected payments method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   merchantId: JString (required)
  ##             : The ID of the account that manages the order. This cannot be a multi-client account.
  ##   orderId: JString (required)
  ##          : The ID of the order for which charge is happening.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `merchantId` field"
  var valid_579781 = path.getOrDefault("merchantId")
  valid_579781 = validateParameter(valid_579781, JString, required = true,
                                 default = nil)
  if valid_579781 != nil:
    section.add "merchantId", valid_579781
  var valid_579782 = path.getOrDefault("orderId")
  valid_579782 = validateParameter(valid_579782, JString, required = true,
                                 default = nil)
  if valid_579782 != nil:
    section.add "orderId", valid_579782
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
  var valid_579783 = query.getOrDefault("key")
  valid_579783 = validateParameter(valid_579783, JString, required = false,
                                 default = nil)
  if valid_579783 != nil:
    section.add "key", valid_579783
  var valid_579784 = query.getOrDefault("prettyPrint")
  valid_579784 = validateParameter(valid_579784, JBool, required = false,
                                 default = newJBool(true))
  if valid_579784 != nil:
    section.add "prettyPrint", valid_579784
  var valid_579785 = query.getOrDefault("oauth_token")
  valid_579785 = validateParameter(valid_579785, JString, required = false,
                                 default = nil)
  if valid_579785 != nil:
    section.add "oauth_token", valid_579785
  var valid_579786 = query.getOrDefault("alt")
  valid_579786 = validateParameter(valid_579786, JString, required = false,
                                 default = newJString("json"))
  if valid_579786 != nil:
    section.add "alt", valid_579786
  var valid_579787 = query.getOrDefault("userIp")
  valid_579787 = validateParameter(valid_579787, JString, required = false,
                                 default = nil)
  if valid_579787 != nil:
    section.add "userIp", valid_579787
  var valid_579788 = query.getOrDefault("quotaUser")
  valid_579788 = validateParameter(valid_579788, JString, required = false,
                                 default = nil)
  if valid_579788 != nil:
    section.add "quotaUser", valid_579788
  var valid_579789 = query.getOrDefault("fields")
  valid_579789 = validateParameter(valid_579789, JString, required = false,
                                 default = nil)
  if valid_579789 != nil:
    section.add "fields", valid_579789
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579791: Call_ContentOrderpaymentsNotifyrefund_579778;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Notify about refund on user's selected payments method.
  ## 
  let valid = call_579791.validator(path, query, header, formData, body)
  let scheme = call_579791.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579791.url(scheme.get, call_579791.host, call_579791.base,
                         call_579791.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579791, url, valid)

proc call*(call_579792: Call_ContentOrderpaymentsNotifyrefund_579778;
          merchantId: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## contentOrderpaymentsNotifyrefund
  ## Notify about refund on user's selected payments method.
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
  ##          : The ID of the order for which charge is happening.
  var path_579793 = newJObject()
  var query_579794 = newJObject()
  var body_579795 = newJObject()
  add(query_579794, "key", newJString(key))
  add(query_579794, "prettyPrint", newJBool(prettyPrint))
  add(query_579794, "oauth_token", newJString(oauthToken))
  add(query_579794, "alt", newJString(alt))
  add(query_579794, "userIp", newJString(userIp))
  add(query_579794, "quotaUser", newJString(quotaUser))
  add(path_579793, "merchantId", newJString(merchantId))
  if body != nil:
    body_579795 = body
  add(query_579794, "fields", newJString(fields))
  add(path_579793, "orderId", newJString(orderId))
  result = call_579792.call(path_579793, query_579794, nil, nil, body_579795)

var contentOrderpaymentsNotifyrefund* = Call_ContentOrderpaymentsNotifyrefund_579778(
    name: "contentOrderpaymentsNotifyrefund", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderpayments/{orderId}/notifyRefund",
    validator: validate_ContentOrderpaymentsNotifyrefund_579779,
    base: "/content/v2", url: url_ContentOrderpaymentsNotifyrefund_579780,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreportsListdisbursements_579796 = ref object of OpenApiRestCall_578348
proc url_ContentOrderreportsListdisbursements_579798(protocol: Scheme;
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

proc validate_ContentOrderreportsListdisbursements_579797(path: JsonNode;
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
  var valid_579799 = path.getOrDefault("merchantId")
  valid_579799 = validateParameter(valid_579799, JString, required = true,
                                 default = nil)
  if valid_579799 != nil:
    section.add "merchantId", valid_579799
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
  var valid_579800 = query.getOrDefault("key")
  valid_579800 = validateParameter(valid_579800, JString, required = false,
                                 default = nil)
  if valid_579800 != nil:
    section.add "key", valid_579800
  var valid_579801 = query.getOrDefault("prettyPrint")
  valid_579801 = validateParameter(valid_579801, JBool, required = false,
                                 default = newJBool(true))
  if valid_579801 != nil:
    section.add "prettyPrint", valid_579801
  var valid_579802 = query.getOrDefault("oauth_token")
  valid_579802 = validateParameter(valid_579802, JString, required = false,
                                 default = nil)
  if valid_579802 != nil:
    section.add "oauth_token", valid_579802
  var valid_579803 = query.getOrDefault("disbursementEndDate")
  valid_579803 = validateParameter(valid_579803, JString, required = false,
                                 default = nil)
  if valid_579803 != nil:
    section.add "disbursementEndDate", valid_579803
  var valid_579804 = query.getOrDefault("alt")
  valid_579804 = validateParameter(valid_579804, JString, required = false,
                                 default = newJString("json"))
  if valid_579804 != nil:
    section.add "alt", valid_579804
  var valid_579805 = query.getOrDefault("userIp")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = nil)
  if valid_579805 != nil:
    section.add "userIp", valid_579805
  var valid_579806 = query.getOrDefault("quotaUser")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "quotaUser", valid_579806
  var valid_579807 = query.getOrDefault("pageToken")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "pageToken", valid_579807
  assert query != nil, "query argument is necessary due to required `disbursementStartDate` field"
  var valid_579808 = query.getOrDefault("disbursementStartDate")
  valid_579808 = validateParameter(valid_579808, JString, required = true,
                                 default = nil)
  if valid_579808 != nil:
    section.add "disbursementStartDate", valid_579808
  var valid_579809 = query.getOrDefault("fields")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "fields", valid_579809
  var valid_579810 = query.getOrDefault("maxResults")
  valid_579810 = validateParameter(valid_579810, JInt, required = false, default = nil)
  if valid_579810 != nil:
    section.add "maxResults", valid_579810
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579811: Call_ContentOrderreportsListdisbursements_579796;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a report for disbursements from your Merchant Center account.
  ## 
  let valid = call_579811.validator(path, query, header, formData, body)
  let scheme = call_579811.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579811.url(scheme.get, call_579811.host, call_579811.base,
                         call_579811.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579811, url, valid)

proc call*(call_579812: Call_ContentOrderreportsListdisbursements_579796;
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
  var path_579813 = newJObject()
  var query_579814 = newJObject()
  add(query_579814, "key", newJString(key))
  add(query_579814, "prettyPrint", newJBool(prettyPrint))
  add(query_579814, "oauth_token", newJString(oauthToken))
  add(query_579814, "disbursementEndDate", newJString(disbursementEndDate))
  add(query_579814, "alt", newJString(alt))
  add(query_579814, "userIp", newJString(userIp))
  add(query_579814, "quotaUser", newJString(quotaUser))
  add(path_579813, "merchantId", newJString(merchantId))
  add(query_579814, "pageToken", newJString(pageToken))
  add(query_579814, "disbursementStartDate", newJString(disbursementStartDate))
  add(query_579814, "fields", newJString(fields))
  add(query_579814, "maxResults", newJInt(maxResults))
  result = call_579812.call(path_579813, query_579814, nil, nil, nil)

var contentOrderreportsListdisbursements* = Call_ContentOrderreportsListdisbursements_579796(
    name: "contentOrderreportsListdisbursements", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreports/disbursements",
    validator: validate_ContentOrderreportsListdisbursements_579797,
    base: "/content/v2", url: url_ContentOrderreportsListdisbursements_579798,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreportsListtransactions_579815 = ref object of OpenApiRestCall_578348
proc url_ContentOrderreportsListtransactions_579817(protocol: Scheme; host: string;
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

proc validate_ContentOrderreportsListtransactions_579816(path: JsonNode;
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
  var valid_579818 = path.getOrDefault("merchantId")
  valid_579818 = validateParameter(valid_579818, JString, required = true,
                                 default = nil)
  if valid_579818 != nil:
    section.add "merchantId", valid_579818
  var valid_579819 = path.getOrDefault("disbursementId")
  valid_579819 = validateParameter(valid_579819, JString, required = true,
                                 default = nil)
  if valid_579819 != nil:
    section.add "disbursementId", valid_579819
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
  var valid_579820 = query.getOrDefault("key")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "key", valid_579820
  var valid_579821 = query.getOrDefault("prettyPrint")
  valid_579821 = validateParameter(valid_579821, JBool, required = false,
                                 default = newJBool(true))
  if valid_579821 != nil:
    section.add "prettyPrint", valid_579821
  var valid_579822 = query.getOrDefault("oauth_token")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "oauth_token", valid_579822
  var valid_579823 = query.getOrDefault("transactionEndDate")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "transactionEndDate", valid_579823
  var valid_579824 = query.getOrDefault("alt")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = newJString("json"))
  if valid_579824 != nil:
    section.add "alt", valid_579824
  var valid_579825 = query.getOrDefault("userIp")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "userIp", valid_579825
  assert query != nil, "query argument is necessary due to required `transactionStartDate` field"
  var valid_579826 = query.getOrDefault("transactionStartDate")
  valid_579826 = validateParameter(valid_579826, JString, required = true,
                                 default = nil)
  if valid_579826 != nil:
    section.add "transactionStartDate", valid_579826
  var valid_579827 = query.getOrDefault("quotaUser")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "quotaUser", valid_579827
  var valid_579828 = query.getOrDefault("pageToken")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = nil)
  if valid_579828 != nil:
    section.add "pageToken", valid_579828
  var valid_579829 = query.getOrDefault("fields")
  valid_579829 = validateParameter(valid_579829, JString, required = false,
                                 default = nil)
  if valid_579829 != nil:
    section.add "fields", valid_579829
  var valid_579830 = query.getOrDefault("maxResults")
  valid_579830 = validateParameter(valid_579830, JInt, required = false, default = nil)
  if valid_579830 != nil:
    section.add "maxResults", valid_579830
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579831: Call_ContentOrderreportsListtransactions_579815;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of transactions for a disbursement from your Merchant Center account.
  ## 
  let valid = call_579831.validator(path, query, header, formData, body)
  let scheme = call_579831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579831.url(scheme.get, call_579831.host, call_579831.base,
                         call_579831.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579831, url, valid)

proc call*(call_579832: Call_ContentOrderreportsListtransactions_579815;
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
  var path_579833 = newJObject()
  var query_579834 = newJObject()
  add(query_579834, "key", newJString(key))
  add(query_579834, "prettyPrint", newJBool(prettyPrint))
  add(query_579834, "oauth_token", newJString(oauthToken))
  add(query_579834, "transactionEndDate", newJString(transactionEndDate))
  add(query_579834, "alt", newJString(alt))
  add(query_579834, "userIp", newJString(userIp))
  add(query_579834, "transactionStartDate", newJString(transactionStartDate))
  add(query_579834, "quotaUser", newJString(quotaUser))
  add(path_579833, "merchantId", newJString(merchantId))
  add(query_579834, "pageToken", newJString(pageToken))
  add(path_579833, "disbursementId", newJString(disbursementId))
  add(query_579834, "fields", newJString(fields))
  add(query_579834, "maxResults", newJInt(maxResults))
  result = call_579832.call(path_579833, query_579834, nil, nil, nil)

var contentOrderreportsListtransactions* = Call_ContentOrderreportsListtransactions_579815(
    name: "contentOrderreportsListtransactions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreports/disbursements/{disbursementId}/transactions",
    validator: validate_ContentOrderreportsListtransactions_579816,
    base: "/content/v2", url: url_ContentOrderreportsListtransactions_579817,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreturnsList_579835 = ref object of OpenApiRestCall_578348
proc url_ContentOrderreturnsList_579837(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrderreturnsList_579836(path: JsonNode; query: JsonNode;
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
  var valid_579838 = path.getOrDefault("merchantId")
  valid_579838 = validateParameter(valid_579838, JString, required = true,
                                 default = nil)
  if valid_579838 != nil:
    section.add "merchantId", valid_579838
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
  var valid_579839 = query.getOrDefault("key")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "key", valid_579839
  var valid_579840 = query.getOrDefault("prettyPrint")
  valid_579840 = validateParameter(valid_579840, JBool, required = false,
                                 default = newJBool(true))
  if valid_579840 != nil:
    section.add "prettyPrint", valid_579840
  var valid_579841 = query.getOrDefault("oauth_token")
  valid_579841 = validateParameter(valid_579841, JString, required = false,
                                 default = nil)
  if valid_579841 != nil:
    section.add "oauth_token", valid_579841
  var valid_579842 = query.getOrDefault("createdStartDate")
  valid_579842 = validateParameter(valid_579842, JString, required = false,
                                 default = nil)
  if valid_579842 != nil:
    section.add "createdStartDate", valid_579842
  var valid_579843 = query.getOrDefault("alt")
  valid_579843 = validateParameter(valid_579843, JString, required = false,
                                 default = newJString("json"))
  if valid_579843 != nil:
    section.add "alt", valid_579843
  var valid_579844 = query.getOrDefault("userIp")
  valid_579844 = validateParameter(valid_579844, JString, required = false,
                                 default = nil)
  if valid_579844 != nil:
    section.add "userIp", valid_579844
  var valid_579845 = query.getOrDefault("quotaUser")
  valid_579845 = validateParameter(valid_579845, JString, required = false,
                                 default = nil)
  if valid_579845 != nil:
    section.add "quotaUser", valid_579845
  var valid_579846 = query.getOrDefault("orderBy")
  valid_579846 = validateParameter(valid_579846, JString, required = false,
                                 default = newJString("returnCreationTimeAsc"))
  if valid_579846 != nil:
    section.add "orderBy", valid_579846
  var valid_579847 = query.getOrDefault("pageToken")
  valid_579847 = validateParameter(valid_579847, JString, required = false,
                                 default = nil)
  if valid_579847 != nil:
    section.add "pageToken", valid_579847
  var valid_579848 = query.getOrDefault("fields")
  valid_579848 = validateParameter(valid_579848, JString, required = false,
                                 default = nil)
  if valid_579848 != nil:
    section.add "fields", valid_579848
  var valid_579849 = query.getOrDefault("maxResults")
  valid_579849 = validateParameter(valid_579849, JInt, required = false, default = nil)
  if valid_579849 != nil:
    section.add "maxResults", valid_579849
  var valid_579850 = query.getOrDefault("createdEndDate")
  valid_579850 = validateParameter(valid_579850, JString, required = false,
                                 default = nil)
  if valid_579850 != nil:
    section.add "createdEndDate", valid_579850
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579851: Call_ContentOrderreturnsList_579835; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists order returns in your Merchant Center account.
  ## 
  let valid = call_579851.validator(path, query, header, formData, body)
  let scheme = call_579851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579851.url(scheme.get, call_579851.host, call_579851.base,
                         call_579851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579851, url, valid)

proc call*(call_579852: Call_ContentOrderreturnsList_579835; merchantId: string;
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
  var path_579853 = newJObject()
  var query_579854 = newJObject()
  add(query_579854, "key", newJString(key))
  add(query_579854, "prettyPrint", newJBool(prettyPrint))
  add(query_579854, "oauth_token", newJString(oauthToken))
  add(query_579854, "createdStartDate", newJString(createdStartDate))
  add(query_579854, "alt", newJString(alt))
  add(query_579854, "userIp", newJString(userIp))
  add(query_579854, "quotaUser", newJString(quotaUser))
  add(path_579853, "merchantId", newJString(merchantId))
  add(query_579854, "orderBy", newJString(orderBy))
  add(query_579854, "pageToken", newJString(pageToken))
  add(query_579854, "fields", newJString(fields))
  add(query_579854, "maxResults", newJInt(maxResults))
  add(query_579854, "createdEndDate", newJString(createdEndDate))
  result = call_579852.call(path_579853, query_579854, nil, nil, nil)

var contentOrderreturnsList* = Call_ContentOrderreturnsList_579835(
    name: "contentOrderreturnsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreturns",
    validator: validate_ContentOrderreturnsList_579836, base: "/content/v2",
    url: url_ContentOrderreturnsList_579837, schemes: {Scheme.Https})
type
  Call_ContentOrderreturnsGet_579855 = ref object of OpenApiRestCall_578348
proc url_ContentOrderreturnsGet_579857(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrderreturnsGet_579856(path: JsonNode; query: JsonNode;
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
  var valid_579858 = path.getOrDefault("returnId")
  valid_579858 = validateParameter(valid_579858, JString, required = true,
                                 default = nil)
  if valid_579858 != nil:
    section.add "returnId", valid_579858
  var valid_579859 = path.getOrDefault("merchantId")
  valid_579859 = validateParameter(valid_579859, JString, required = true,
                                 default = nil)
  if valid_579859 != nil:
    section.add "merchantId", valid_579859
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
  var valid_579860 = query.getOrDefault("key")
  valid_579860 = validateParameter(valid_579860, JString, required = false,
                                 default = nil)
  if valid_579860 != nil:
    section.add "key", valid_579860
  var valid_579861 = query.getOrDefault("prettyPrint")
  valid_579861 = validateParameter(valid_579861, JBool, required = false,
                                 default = newJBool(true))
  if valid_579861 != nil:
    section.add "prettyPrint", valid_579861
  var valid_579862 = query.getOrDefault("oauth_token")
  valid_579862 = validateParameter(valid_579862, JString, required = false,
                                 default = nil)
  if valid_579862 != nil:
    section.add "oauth_token", valid_579862
  var valid_579863 = query.getOrDefault("alt")
  valid_579863 = validateParameter(valid_579863, JString, required = false,
                                 default = newJString("json"))
  if valid_579863 != nil:
    section.add "alt", valid_579863
  var valid_579864 = query.getOrDefault("userIp")
  valid_579864 = validateParameter(valid_579864, JString, required = false,
                                 default = nil)
  if valid_579864 != nil:
    section.add "userIp", valid_579864
  var valid_579865 = query.getOrDefault("quotaUser")
  valid_579865 = validateParameter(valid_579865, JString, required = false,
                                 default = nil)
  if valid_579865 != nil:
    section.add "quotaUser", valid_579865
  var valid_579866 = query.getOrDefault("fields")
  valid_579866 = validateParameter(valid_579866, JString, required = false,
                                 default = nil)
  if valid_579866 != nil:
    section.add "fields", valid_579866
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579867: Call_ContentOrderreturnsGet_579855; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an order return from your Merchant Center account.
  ## 
  let valid = call_579867.validator(path, query, header, formData, body)
  let scheme = call_579867.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579867.url(scheme.get, call_579867.host, call_579867.base,
                         call_579867.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579867, url, valid)

proc call*(call_579868: Call_ContentOrderreturnsGet_579855; returnId: string;
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
  var path_579869 = newJObject()
  var query_579870 = newJObject()
  add(query_579870, "key", newJString(key))
  add(query_579870, "prettyPrint", newJBool(prettyPrint))
  add(query_579870, "oauth_token", newJString(oauthToken))
  add(path_579869, "returnId", newJString(returnId))
  add(query_579870, "alt", newJString(alt))
  add(query_579870, "userIp", newJString(userIp))
  add(query_579870, "quotaUser", newJString(quotaUser))
  add(path_579869, "merchantId", newJString(merchantId))
  add(query_579870, "fields", newJString(fields))
  result = call_579868.call(path_579869, query_579870, nil, nil, nil)

var contentOrderreturnsGet* = Call_ContentOrderreturnsGet_579855(
    name: "contentOrderreturnsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreturns/{returnId}",
    validator: validate_ContentOrderreturnsGet_579856, base: "/content/v2",
    url: url_ContentOrderreturnsGet_579857, schemes: {Scheme.Https})
type
  Call_ContentOrdersList_579871 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersList_579873(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrdersList_579872(path: JsonNode; query: JsonNode;
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
  var valid_579874 = path.getOrDefault("merchantId")
  valid_579874 = validateParameter(valid_579874, JString, required = true,
                                 default = nil)
  if valid_579874 != nil:
    section.add "merchantId", valid_579874
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
  var valid_579875 = query.getOrDefault("key")
  valid_579875 = validateParameter(valid_579875, JString, required = false,
                                 default = nil)
  if valid_579875 != nil:
    section.add "key", valid_579875
  var valid_579876 = query.getOrDefault("prettyPrint")
  valid_579876 = validateParameter(valid_579876, JBool, required = false,
                                 default = newJBool(true))
  if valid_579876 != nil:
    section.add "prettyPrint", valid_579876
  var valid_579877 = query.getOrDefault("oauth_token")
  valid_579877 = validateParameter(valid_579877, JString, required = false,
                                 default = nil)
  if valid_579877 != nil:
    section.add "oauth_token", valid_579877
  var valid_579878 = query.getOrDefault("alt")
  valid_579878 = validateParameter(valid_579878, JString, required = false,
                                 default = newJString("json"))
  if valid_579878 != nil:
    section.add "alt", valid_579878
  var valid_579879 = query.getOrDefault("userIp")
  valid_579879 = validateParameter(valid_579879, JString, required = false,
                                 default = nil)
  if valid_579879 != nil:
    section.add "userIp", valid_579879
  var valid_579880 = query.getOrDefault("quotaUser")
  valid_579880 = validateParameter(valid_579880, JString, required = false,
                                 default = nil)
  if valid_579880 != nil:
    section.add "quotaUser", valid_579880
  var valid_579881 = query.getOrDefault("orderBy")
  valid_579881 = validateParameter(valid_579881, JString, required = false,
                                 default = nil)
  if valid_579881 != nil:
    section.add "orderBy", valid_579881
  var valid_579882 = query.getOrDefault("pageToken")
  valid_579882 = validateParameter(valid_579882, JString, required = false,
                                 default = nil)
  if valid_579882 != nil:
    section.add "pageToken", valid_579882
  var valid_579883 = query.getOrDefault("placedDateStart")
  valid_579883 = validateParameter(valid_579883, JString, required = false,
                                 default = nil)
  if valid_579883 != nil:
    section.add "placedDateStart", valid_579883
  var valid_579884 = query.getOrDefault("statuses")
  valid_579884 = validateParameter(valid_579884, JArray, required = false,
                                 default = nil)
  if valid_579884 != nil:
    section.add "statuses", valid_579884
  var valid_579885 = query.getOrDefault("acknowledged")
  valid_579885 = validateParameter(valid_579885, JBool, required = false, default = nil)
  if valid_579885 != nil:
    section.add "acknowledged", valid_579885
  var valid_579886 = query.getOrDefault("placedDateEnd")
  valid_579886 = validateParameter(valid_579886, JString, required = false,
                                 default = nil)
  if valid_579886 != nil:
    section.add "placedDateEnd", valid_579886
  var valid_579887 = query.getOrDefault("fields")
  valid_579887 = validateParameter(valid_579887, JString, required = false,
                                 default = nil)
  if valid_579887 != nil:
    section.add "fields", valid_579887
  var valid_579888 = query.getOrDefault("maxResults")
  valid_579888 = validateParameter(valid_579888, JInt, required = false, default = nil)
  if valid_579888 != nil:
    section.add "maxResults", valid_579888
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579889: Call_ContentOrdersList_579871; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the orders in your Merchant Center account.
  ## 
  let valid = call_579889.validator(path, query, header, formData, body)
  let scheme = call_579889.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579889.url(scheme.get, call_579889.host, call_579889.base,
                         call_579889.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579889, url, valid)

proc call*(call_579890: Call_ContentOrdersList_579871; merchantId: string;
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
  var path_579891 = newJObject()
  var query_579892 = newJObject()
  add(query_579892, "key", newJString(key))
  add(query_579892, "prettyPrint", newJBool(prettyPrint))
  add(query_579892, "oauth_token", newJString(oauthToken))
  add(query_579892, "alt", newJString(alt))
  add(query_579892, "userIp", newJString(userIp))
  add(query_579892, "quotaUser", newJString(quotaUser))
  add(path_579891, "merchantId", newJString(merchantId))
  add(query_579892, "orderBy", newJString(orderBy))
  add(query_579892, "pageToken", newJString(pageToken))
  add(query_579892, "placedDateStart", newJString(placedDateStart))
  if statuses != nil:
    query_579892.add "statuses", statuses
  add(query_579892, "acknowledged", newJBool(acknowledged))
  add(query_579892, "placedDateEnd", newJString(placedDateEnd))
  add(query_579892, "fields", newJString(fields))
  add(query_579892, "maxResults", newJInt(maxResults))
  result = call_579890.call(path_579891, query_579892, nil, nil, nil)

var contentOrdersList* = Call_ContentOrdersList_579871(name: "contentOrdersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/orders", validator: validate_ContentOrdersList_579872,
    base: "/content/v2", url: url_ContentOrdersList_579873, schemes: {Scheme.Https})
type
  Call_ContentOrdersGet_579893 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersGet_579895(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrdersGet_579894(path: JsonNode; query: JsonNode;
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
  var valid_579896 = path.getOrDefault("merchantId")
  valid_579896 = validateParameter(valid_579896, JString, required = true,
                                 default = nil)
  if valid_579896 != nil:
    section.add "merchantId", valid_579896
  var valid_579897 = path.getOrDefault("orderId")
  valid_579897 = validateParameter(valid_579897, JString, required = true,
                                 default = nil)
  if valid_579897 != nil:
    section.add "orderId", valid_579897
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
  var valid_579898 = query.getOrDefault("key")
  valid_579898 = validateParameter(valid_579898, JString, required = false,
                                 default = nil)
  if valid_579898 != nil:
    section.add "key", valid_579898
  var valid_579899 = query.getOrDefault("prettyPrint")
  valid_579899 = validateParameter(valid_579899, JBool, required = false,
                                 default = newJBool(true))
  if valid_579899 != nil:
    section.add "prettyPrint", valid_579899
  var valid_579900 = query.getOrDefault("oauth_token")
  valid_579900 = validateParameter(valid_579900, JString, required = false,
                                 default = nil)
  if valid_579900 != nil:
    section.add "oauth_token", valid_579900
  var valid_579901 = query.getOrDefault("alt")
  valid_579901 = validateParameter(valid_579901, JString, required = false,
                                 default = newJString("json"))
  if valid_579901 != nil:
    section.add "alt", valid_579901
  var valid_579902 = query.getOrDefault("userIp")
  valid_579902 = validateParameter(valid_579902, JString, required = false,
                                 default = nil)
  if valid_579902 != nil:
    section.add "userIp", valid_579902
  var valid_579903 = query.getOrDefault("quotaUser")
  valid_579903 = validateParameter(valid_579903, JString, required = false,
                                 default = nil)
  if valid_579903 != nil:
    section.add "quotaUser", valid_579903
  var valid_579904 = query.getOrDefault("fields")
  valid_579904 = validateParameter(valid_579904, JString, required = false,
                                 default = nil)
  if valid_579904 != nil:
    section.add "fields", valid_579904
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579905: Call_ContentOrdersGet_579893; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an order from your Merchant Center account.
  ## 
  let valid = call_579905.validator(path, query, header, formData, body)
  let scheme = call_579905.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579905.url(scheme.get, call_579905.host, call_579905.base,
                         call_579905.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579905, url, valid)

proc call*(call_579906: Call_ContentOrdersGet_579893; merchantId: string;
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
  var path_579907 = newJObject()
  var query_579908 = newJObject()
  add(query_579908, "key", newJString(key))
  add(query_579908, "prettyPrint", newJBool(prettyPrint))
  add(query_579908, "oauth_token", newJString(oauthToken))
  add(query_579908, "alt", newJString(alt))
  add(query_579908, "userIp", newJString(userIp))
  add(query_579908, "quotaUser", newJString(quotaUser))
  add(path_579907, "merchantId", newJString(merchantId))
  add(query_579908, "fields", newJString(fields))
  add(path_579907, "orderId", newJString(orderId))
  result = call_579906.call(path_579907, query_579908, nil, nil, nil)

var contentOrdersGet* = Call_ContentOrdersGet_579893(name: "contentOrdersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}", validator: validate_ContentOrdersGet_579894,
    base: "/content/v2", url: url_ContentOrdersGet_579895, schemes: {Scheme.Https})
type
  Call_ContentOrdersAcknowledge_579909 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersAcknowledge_579911(protocol: Scheme; host: string;
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

proc validate_ContentOrdersAcknowledge_579910(path: JsonNode; query: JsonNode;
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
  var valid_579912 = path.getOrDefault("merchantId")
  valid_579912 = validateParameter(valid_579912, JString, required = true,
                                 default = nil)
  if valid_579912 != nil:
    section.add "merchantId", valid_579912
  var valid_579913 = path.getOrDefault("orderId")
  valid_579913 = validateParameter(valid_579913, JString, required = true,
                                 default = nil)
  if valid_579913 != nil:
    section.add "orderId", valid_579913
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
  var valid_579920 = query.getOrDefault("fields")
  valid_579920 = validateParameter(valid_579920, JString, required = false,
                                 default = nil)
  if valid_579920 != nil:
    section.add "fields", valid_579920
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579922: Call_ContentOrdersAcknowledge_579909; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks an order as acknowledged.
  ## 
  let valid = call_579922.validator(path, query, header, formData, body)
  let scheme = call_579922.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579922.url(scheme.get, call_579922.host, call_579922.base,
                         call_579922.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579922, url, valid)

proc call*(call_579923: Call_ContentOrdersAcknowledge_579909; merchantId: string;
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
  var path_579924 = newJObject()
  var query_579925 = newJObject()
  var body_579926 = newJObject()
  add(query_579925, "key", newJString(key))
  add(query_579925, "prettyPrint", newJBool(prettyPrint))
  add(query_579925, "oauth_token", newJString(oauthToken))
  add(query_579925, "alt", newJString(alt))
  add(query_579925, "userIp", newJString(userIp))
  add(query_579925, "quotaUser", newJString(quotaUser))
  add(path_579924, "merchantId", newJString(merchantId))
  if body != nil:
    body_579926 = body
  add(query_579925, "fields", newJString(fields))
  add(path_579924, "orderId", newJString(orderId))
  result = call_579923.call(path_579924, query_579925, nil, nil, body_579926)

var contentOrdersAcknowledge* = Call_ContentOrdersAcknowledge_579909(
    name: "contentOrdersAcknowledge", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/acknowledge",
    validator: validate_ContentOrdersAcknowledge_579910, base: "/content/v2",
    url: url_ContentOrdersAcknowledge_579911, schemes: {Scheme.Https})
type
  Call_ContentOrdersCancel_579927 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersCancel_579929(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrdersCancel_579928(path: JsonNode; query: JsonNode;
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
  var valid_579930 = path.getOrDefault("merchantId")
  valid_579930 = validateParameter(valid_579930, JString, required = true,
                                 default = nil)
  if valid_579930 != nil:
    section.add "merchantId", valid_579930
  var valid_579931 = path.getOrDefault("orderId")
  valid_579931 = validateParameter(valid_579931, JString, required = true,
                                 default = nil)
  if valid_579931 != nil:
    section.add "orderId", valid_579931
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
  var valid_579932 = query.getOrDefault("key")
  valid_579932 = validateParameter(valid_579932, JString, required = false,
                                 default = nil)
  if valid_579932 != nil:
    section.add "key", valid_579932
  var valid_579933 = query.getOrDefault("prettyPrint")
  valid_579933 = validateParameter(valid_579933, JBool, required = false,
                                 default = newJBool(true))
  if valid_579933 != nil:
    section.add "prettyPrint", valid_579933
  var valid_579934 = query.getOrDefault("oauth_token")
  valid_579934 = validateParameter(valid_579934, JString, required = false,
                                 default = nil)
  if valid_579934 != nil:
    section.add "oauth_token", valid_579934
  var valid_579935 = query.getOrDefault("alt")
  valid_579935 = validateParameter(valid_579935, JString, required = false,
                                 default = newJString("json"))
  if valid_579935 != nil:
    section.add "alt", valid_579935
  var valid_579936 = query.getOrDefault("userIp")
  valid_579936 = validateParameter(valid_579936, JString, required = false,
                                 default = nil)
  if valid_579936 != nil:
    section.add "userIp", valid_579936
  var valid_579937 = query.getOrDefault("quotaUser")
  valid_579937 = validateParameter(valid_579937, JString, required = false,
                                 default = nil)
  if valid_579937 != nil:
    section.add "quotaUser", valid_579937
  var valid_579938 = query.getOrDefault("fields")
  valid_579938 = validateParameter(valid_579938, JString, required = false,
                                 default = nil)
  if valid_579938 != nil:
    section.add "fields", valid_579938
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579940: Call_ContentOrdersCancel_579927; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels all line items in an order, making a full refund.
  ## 
  let valid = call_579940.validator(path, query, header, formData, body)
  let scheme = call_579940.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579940.url(scheme.get, call_579940.host, call_579940.base,
                         call_579940.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579940, url, valid)

proc call*(call_579941: Call_ContentOrdersCancel_579927; merchantId: string;
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
  var path_579942 = newJObject()
  var query_579943 = newJObject()
  var body_579944 = newJObject()
  add(query_579943, "key", newJString(key))
  add(query_579943, "prettyPrint", newJBool(prettyPrint))
  add(query_579943, "oauth_token", newJString(oauthToken))
  add(query_579943, "alt", newJString(alt))
  add(query_579943, "userIp", newJString(userIp))
  add(query_579943, "quotaUser", newJString(quotaUser))
  add(path_579942, "merchantId", newJString(merchantId))
  if body != nil:
    body_579944 = body
  add(query_579943, "fields", newJString(fields))
  add(path_579942, "orderId", newJString(orderId))
  result = call_579941.call(path_579942, query_579943, nil, nil, body_579944)

var contentOrdersCancel* = Call_ContentOrdersCancel_579927(
    name: "contentOrdersCancel", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/orders/{orderId}/cancel",
    validator: validate_ContentOrdersCancel_579928, base: "/content/v2",
    url: url_ContentOrdersCancel_579929, schemes: {Scheme.Https})
type
  Call_ContentOrdersCancellineitem_579945 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersCancellineitem_579947(protocol: Scheme; host: string;
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

proc validate_ContentOrdersCancellineitem_579946(path: JsonNode; query: JsonNode;
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
  var valid_579948 = path.getOrDefault("merchantId")
  valid_579948 = validateParameter(valid_579948, JString, required = true,
                                 default = nil)
  if valid_579948 != nil:
    section.add "merchantId", valid_579948
  var valid_579949 = path.getOrDefault("orderId")
  valid_579949 = validateParameter(valid_579949, JString, required = true,
                                 default = nil)
  if valid_579949 != nil:
    section.add "orderId", valid_579949
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
  var valid_579950 = query.getOrDefault("key")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = nil)
  if valid_579950 != nil:
    section.add "key", valid_579950
  var valid_579951 = query.getOrDefault("prettyPrint")
  valid_579951 = validateParameter(valid_579951, JBool, required = false,
                                 default = newJBool(true))
  if valid_579951 != nil:
    section.add "prettyPrint", valid_579951
  var valid_579952 = query.getOrDefault("oauth_token")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = nil)
  if valid_579952 != nil:
    section.add "oauth_token", valid_579952
  var valid_579953 = query.getOrDefault("alt")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = newJString("json"))
  if valid_579953 != nil:
    section.add "alt", valid_579953
  var valid_579954 = query.getOrDefault("userIp")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "userIp", valid_579954
  var valid_579955 = query.getOrDefault("quotaUser")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "quotaUser", valid_579955
  var valid_579956 = query.getOrDefault("fields")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = nil)
  if valid_579956 != nil:
    section.add "fields", valid_579956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579958: Call_ContentOrdersCancellineitem_579945; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a line item, making a full refund.
  ## 
  let valid = call_579958.validator(path, query, header, formData, body)
  let scheme = call_579958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579958.url(scheme.get, call_579958.host, call_579958.base,
                         call_579958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579958, url, valid)

proc call*(call_579959: Call_ContentOrdersCancellineitem_579945;
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
  var path_579960 = newJObject()
  var query_579961 = newJObject()
  var body_579962 = newJObject()
  add(query_579961, "key", newJString(key))
  add(query_579961, "prettyPrint", newJBool(prettyPrint))
  add(query_579961, "oauth_token", newJString(oauthToken))
  add(query_579961, "alt", newJString(alt))
  add(query_579961, "userIp", newJString(userIp))
  add(query_579961, "quotaUser", newJString(quotaUser))
  add(path_579960, "merchantId", newJString(merchantId))
  if body != nil:
    body_579962 = body
  add(query_579961, "fields", newJString(fields))
  add(path_579960, "orderId", newJString(orderId))
  result = call_579959.call(path_579960, query_579961, nil, nil, body_579962)

var contentOrdersCancellineitem* = Call_ContentOrdersCancellineitem_579945(
    name: "contentOrdersCancellineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/cancelLineItem",
    validator: validate_ContentOrdersCancellineitem_579946, base: "/content/v2",
    url: url_ContentOrdersCancellineitem_579947, schemes: {Scheme.Https})
type
  Call_ContentOrdersInstorerefundlineitem_579963 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersInstorerefundlineitem_579965(protocol: Scheme; host: string;
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

proc validate_ContentOrdersInstorerefundlineitem_579964(path: JsonNode;
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
  var valid_579966 = path.getOrDefault("merchantId")
  valid_579966 = validateParameter(valid_579966, JString, required = true,
                                 default = nil)
  if valid_579966 != nil:
    section.add "merchantId", valid_579966
  var valid_579967 = path.getOrDefault("orderId")
  valid_579967 = validateParameter(valid_579967, JString, required = true,
                                 default = nil)
  if valid_579967 != nil:
    section.add "orderId", valid_579967
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
  var valid_579968 = query.getOrDefault("key")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "key", valid_579968
  var valid_579969 = query.getOrDefault("prettyPrint")
  valid_579969 = validateParameter(valid_579969, JBool, required = false,
                                 default = newJBool(true))
  if valid_579969 != nil:
    section.add "prettyPrint", valid_579969
  var valid_579970 = query.getOrDefault("oauth_token")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "oauth_token", valid_579970
  var valid_579971 = query.getOrDefault("alt")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = newJString("json"))
  if valid_579971 != nil:
    section.add "alt", valid_579971
  var valid_579972 = query.getOrDefault("userIp")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "userIp", valid_579972
  var valid_579973 = query.getOrDefault("quotaUser")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "quotaUser", valid_579973
  var valid_579974 = query.getOrDefault("fields")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "fields", valid_579974
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579976: Call_ContentOrdersInstorerefundlineitem_579963;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deprecated. Notifies that item return and refund was handled directly by merchant outside of Google payments processing (e.g. cash refund done in store).
  ## Note: We recommend calling the returnrefundlineitem method to refund in-store returns. We will issue the refund directly to the customer. This helps to prevent possible differences arising between merchant and Google transaction records. We also recommend having the point of sale system communicate with Google to ensure that customers do not receive a double refund by first refunding via Google then via an in-store return.
  ## 
  let valid = call_579976.validator(path, query, header, formData, body)
  let scheme = call_579976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579976.url(scheme.get, call_579976.host, call_579976.base,
                         call_579976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579976, url, valid)

proc call*(call_579977: Call_ContentOrdersInstorerefundlineitem_579963;
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
  var path_579978 = newJObject()
  var query_579979 = newJObject()
  var body_579980 = newJObject()
  add(query_579979, "key", newJString(key))
  add(query_579979, "prettyPrint", newJBool(prettyPrint))
  add(query_579979, "oauth_token", newJString(oauthToken))
  add(query_579979, "alt", newJString(alt))
  add(query_579979, "userIp", newJString(userIp))
  add(query_579979, "quotaUser", newJString(quotaUser))
  add(path_579978, "merchantId", newJString(merchantId))
  if body != nil:
    body_579980 = body
  add(query_579979, "fields", newJString(fields))
  add(path_579978, "orderId", newJString(orderId))
  result = call_579977.call(path_579978, query_579979, nil, nil, body_579980)

var contentOrdersInstorerefundlineitem* = Call_ContentOrdersInstorerefundlineitem_579963(
    name: "contentOrdersInstorerefundlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/inStoreRefundLineItem",
    validator: validate_ContentOrdersInstorerefundlineitem_579964,
    base: "/content/v2", url: url_ContentOrdersInstorerefundlineitem_579965,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersRefund_579981 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersRefund_579983(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrdersRefund_579982(path: JsonNode; query: JsonNode;
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
  var valid_579984 = path.getOrDefault("merchantId")
  valid_579984 = validateParameter(valid_579984, JString, required = true,
                                 default = nil)
  if valid_579984 != nil:
    section.add "merchantId", valid_579984
  var valid_579985 = path.getOrDefault("orderId")
  valid_579985 = validateParameter(valid_579985, JString, required = true,
                                 default = nil)
  if valid_579985 != nil:
    section.add "orderId", valid_579985
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
  var valid_579986 = query.getOrDefault("key")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "key", valid_579986
  var valid_579987 = query.getOrDefault("prettyPrint")
  valid_579987 = validateParameter(valid_579987, JBool, required = false,
                                 default = newJBool(true))
  if valid_579987 != nil:
    section.add "prettyPrint", valid_579987
  var valid_579988 = query.getOrDefault("oauth_token")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "oauth_token", valid_579988
  var valid_579989 = query.getOrDefault("alt")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = newJString("json"))
  if valid_579989 != nil:
    section.add "alt", valid_579989
  var valid_579990 = query.getOrDefault("userIp")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "userIp", valid_579990
  var valid_579991 = query.getOrDefault("quotaUser")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "quotaUser", valid_579991
  var valid_579992 = query.getOrDefault("fields")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "fields", valid_579992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579994: Call_ContentOrdersRefund_579981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated, please use returnRefundLineItem instead.
  ## 
  let valid = call_579994.validator(path, query, header, formData, body)
  let scheme = call_579994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579994.url(scheme.get, call_579994.host, call_579994.base,
                         call_579994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579994, url, valid)

proc call*(call_579995: Call_ContentOrdersRefund_579981; merchantId: string;
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
  var path_579996 = newJObject()
  var query_579997 = newJObject()
  var body_579998 = newJObject()
  add(query_579997, "key", newJString(key))
  add(query_579997, "prettyPrint", newJBool(prettyPrint))
  add(query_579997, "oauth_token", newJString(oauthToken))
  add(query_579997, "alt", newJString(alt))
  add(query_579997, "userIp", newJString(userIp))
  add(query_579997, "quotaUser", newJString(quotaUser))
  add(path_579996, "merchantId", newJString(merchantId))
  if body != nil:
    body_579998 = body
  add(query_579997, "fields", newJString(fields))
  add(path_579996, "orderId", newJString(orderId))
  result = call_579995.call(path_579996, query_579997, nil, nil, body_579998)

var contentOrdersRefund* = Call_ContentOrdersRefund_579981(
    name: "contentOrdersRefund", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/orders/{orderId}/refund",
    validator: validate_ContentOrdersRefund_579982, base: "/content/v2",
    url: url_ContentOrdersRefund_579983, schemes: {Scheme.Https})
type
  Call_ContentOrdersRejectreturnlineitem_579999 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersRejectreturnlineitem_580001(protocol: Scheme; host: string;
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

proc validate_ContentOrdersRejectreturnlineitem_580000(path: JsonNode;
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
  var valid_580002 = path.getOrDefault("merchantId")
  valid_580002 = validateParameter(valid_580002, JString, required = true,
                                 default = nil)
  if valid_580002 != nil:
    section.add "merchantId", valid_580002
  var valid_580003 = path.getOrDefault("orderId")
  valid_580003 = validateParameter(valid_580003, JString, required = true,
                                 default = nil)
  if valid_580003 != nil:
    section.add "orderId", valid_580003
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
  var valid_580004 = query.getOrDefault("key")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "key", valid_580004
  var valid_580005 = query.getOrDefault("prettyPrint")
  valid_580005 = validateParameter(valid_580005, JBool, required = false,
                                 default = newJBool(true))
  if valid_580005 != nil:
    section.add "prettyPrint", valid_580005
  var valid_580006 = query.getOrDefault("oauth_token")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "oauth_token", valid_580006
  var valid_580007 = query.getOrDefault("alt")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = newJString("json"))
  if valid_580007 != nil:
    section.add "alt", valid_580007
  var valid_580008 = query.getOrDefault("userIp")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "userIp", valid_580008
  var valid_580009 = query.getOrDefault("quotaUser")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "quotaUser", valid_580009
  var valid_580010 = query.getOrDefault("fields")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "fields", valid_580010
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580012: Call_ContentOrdersRejectreturnlineitem_579999;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rejects return on an line item.
  ## 
  let valid = call_580012.validator(path, query, header, formData, body)
  let scheme = call_580012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580012.url(scheme.get, call_580012.host, call_580012.base,
                         call_580012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580012, url, valid)

proc call*(call_580013: Call_ContentOrdersRejectreturnlineitem_579999;
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
  var path_580014 = newJObject()
  var query_580015 = newJObject()
  var body_580016 = newJObject()
  add(query_580015, "key", newJString(key))
  add(query_580015, "prettyPrint", newJBool(prettyPrint))
  add(query_580015, "oauth_token", newJString(oauthToken))
  add(query_580015, "alt", newJString(alt))
  add(query_580015, "userIp", newJString(userIp))
  add(query_580015, "quotaUser", newJString(quotaUser))
  add(path_580014, "merchantId", newJString(merchantId))
  if body != nil:
    body_580016 = body
  add(query_580015, "fields", newJString(fields))
  add(path_580014, "orderId", newJString(orderId))
  result = call_580013.call(path_580014, query_580015, nil, nil, body_580016)

var contentOrdersRejectreturnlineitem* = Call_ContentOrdersRejectreturnlineitem_579999(
    name: "contentOrdersRejectreturnlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/rejectReturnLineItem",
    validator: validate_ContentOrdersRejectreturnlineitem_580000,
    base: "/content/v2", url: url_ContentOrdersRejectreturnlineitem_580001,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersReturnlineitem_580017 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersReturnlineitem_580019(protocol: Scheme; host: string;
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

proc validate_ContentOrdersReturnlineitem_580018(path: JsonNode; query: JsonNode;
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
  var valid_580020 = path.getOrDefault("merchantId")
  valid_580020 = validateParameter(valid_580020, JString, required = true,
                                 default = nil)
  if valid_580020 != nil:
    section.add "merchantId", valid_580020
  var valid_580021 = path.getOrDefault("orderId")
  valid_580021 = validateParameter(valid_580021, JString, required = true,
                                 default = nil)
  if valid_580021 != nil:
    section.add "orderId", valid_580021
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
  var valid_580022 = query.getOrDefault("key")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "key", valid_580022
  var valid_580023 = query.getOrDefault("prettyPrint")
  valid_580023 = validateParameter(valid_580023, JBool, required = false,
                                 default = newJBool(true))
  if valid_580023 != nil:
    section.add "prettyPrint", valid_580023
  var valid_580024 = query.getOrDefault("oauth_token")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "oauth_token", valid_580024
  var valid_580025 = query.getOrDefault("alt")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = newJString("json"))
  if valid_580025 != nil:
    section.add "alt", valid_580025
  var valid_580026 = query.getOrDefault("userIp")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "userIp", valid_580026
  var valid_580027 = query.getOrDefault("quotaUser")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "quotaUser", valid_580027
  var valid_580028 = query.getOrDefault("fields")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "fields", valid_580028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580030: Call_ContentOrdersReturnlineitem_580017; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a line item.
  ## 
  let valid = call_580030.validator(path, query, header, formData, body)
  let scheme = call_580030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580030.url(scheme.get, call_580030.host, call_580030.base,
                         call_580030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580030, url, valid)

proc call*(call_580031: Call_ContentOrdersReturnlineitem_580017;
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
  var path_580032 = newJObject()
  var query_580033 = newJObject()
  var body_580034 = newJObject()
  add(query_580033, "key", newJString(key))
  add(query_580033, "prettyPrint", newJBool(prettyPrint))
  add(query_580033, "oauth_token", newJString(oauthToken))
  add(query_580033, "alt", newJString(alt))
  add(query_580033, "userIp", newJString(userIp))
  add(query_580033, "quotaUser", newJString(quotaUser))
  add(path_580032, "merchantId", newJString(merchantId))
  if body != nil:
    body_580034 = body
  add(query_580033, "fields", newJString(fields))
  add(path_580032, "orderId", newJString(orderId))
  result = call_580031.call(path_580032, query_580033, nil, nil, body_580034)

var contentOrdersReturnlineitem* = Call_ContentOrdersReturnlineitem_580017(
    name: "contentOrdersReturnlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/returnLineItem",
    validator: validate_ContentOrdersReturnlineitem_580018, base: "/content/v2",
    url: url_ContentOrdersReturnlineitem_580019, schemes: {Scheme.Https})
type
  Call_ContentOrdersReturnrefundlineitem_580035 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersReturnrefundlineitem_580037(protocol: Scheme; host: string;
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

proc validate_ContentOrdersReturnrefundlineitem_580036(path: JsonNode;
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
  var valid_580038 = path.getOrDefault("merchantId")
  valid_580038 = validateParameter(valid_580038, JString, required = true,
                                 default = nil)
  if valid_580038 != nil:
    section.add "merchantId", valid_580038
  var valid_580039 = path.getOrDefault("orderId")
  valid_580039 = validateParameter(valid_580039, JString, required = true,
                                 default = nil)
  if valid_580039 != nil:
    section.add "orderId", valid_580039
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
  var valid_580040 = query.getOrDefault("key")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "key", valid_580040
  var valid_580041 = query.getOrDefault("prettyPrint")
  valid_580041 = validateParameter(valid_580041, JBool, required = false,
                                 default = newJBool(true))
  if valid_580041 != nil:
    section.add "prettyPrint", valid_580041
  var valid_580042 = query.getOrDefault("oauth_token")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "oauth_token", valid_580042
  var valid_580043 = query.getOrDefault("alt")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = newJString("json"))
  if valid_580043 != nil:
    section.add "alt", valid_580043
  var valid_580044 = query.getOrDefault("userIp")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "userIp", valid_580044
  var valid_580045 = query.getOrDefault("quotaUser")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "quotaUser", valid_580045
  var valid_580046 = query.getOrDefault("fields")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "fields", valid_580046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580048: Call_ContentOrdersReturnrefundlineitem_580035;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns and refunds a line item. Note that this method can only be called on fully shipped orders.
  ## 
  let valid = call_580048.validator(path, query, header, formData, body)
  let scheme = call_580048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580048.url(scheme.get, call_580048.host, call_580048.base,
                         call_580048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580048, url, valid)

proc call*(call_580049: Call_ContentOrdersReturnrefundlineitem_580035;
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
  var path_580050 = newJObject()
  var query_580051 = newJObject()
  var body_580052 = newJObject()
  add(query_580051, "key", newJString(key))
  add(query_580051, "prettyPrint", newJBool(prettyPrint))
  add(query_580051, "oauth_token", newJString(oauthToken))
  add(query_580051, "alt", newJString(alt))
  add(query_580051, "userIp", newJString(userIp))
  add(query_580051, "quotaUser", newJString(quotaUser))
  add(path_580050, "merchantId", newJString(merchantId))
  if body != nil:
    body_580052 = body
  add(query_580051, "fields", newJString(fields))
  add(path_580050, "orderId", newJString(orderId))
  result = call_580049.call(path_580050, query_580051, nil, nil, body_580052)

var contentOrdersReturnrefundlineitem* = Call_ContentOrdersReturnrefundlineitem_580035(
    name: "contentOrdersReturnrefundlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/returnRefundLineItem",
    validator: validate_ContentOrdersReturnrefundlineitem_580036,
    base: "/content/v2", url: url_ContentOrdersReturnrefundlineitem_580037,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersSetlineitemmetadata_580053 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersSetlineitemmetadata_580055(protocol: Scheme; host: string;
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

proc validate_ContentOrdersSetlineitemmetadata_580054(path: JsonNode;
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
  var valid_580056 = path.getOrDefault("merchantId")
  valid_580056 = validateParameter(valid_580056, JString, required = true,
                                 default = nil)
  if valid_580056 != nil:
    section.add "merchantId", valid_580056
  var valid_580057 = path.getOrDefault("orderId")
  valid_580057 = validateParameter(valid_580057, JString, required = true,
                                 default = nil)
  if valid_580057 != nil:
    section.add "orderId", valid_580057
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
  var valid_580058 = query.getOrDefault("key")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "key", valid_580058
  var valid_580059 = query.getOrDefault("prettyPrint")
  valid_580059 = validateParameter(valid_580059, JBool, required = false,
                                 default = newJBool(true))
  if valid_580059 != nil:
    section.add "prettyPrint", valid_580059
  var valid_580060 = query.getOrDefault("oauth_token")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "oauth_token", valid_580060
  var valid_580061 = query.getOrDefault("alt")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = newJString("json"))
  if valid_580061 != nil:
    section.add "alt", valid_580061
  var valid_580062 = query.getOrDefault("userIp")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "userIp", valid_580062
  var valid_580063 = query.getOrDefault("quotaUser")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "quotaUser", valid_580063
  var valid_580064 = query.getOrDefault("fields")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "fields", valid_580064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580066: Call_ContentOrdersSetlineitemmetadata_580053;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets (or overrides if it already exists) merchant provided annotations in the form of key-value pairs. A common use case would be to supply us with additional structured information about a line item that cannot be provided via other methods. Submitted key-value pairs can be retrieved as part of the orders resource.
  ## 
  let valid = call_580066.validator(path, query, header, formData, body)
  let scheme = call_580066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580066.url(scheme.get, call_580066.host, call_580066.base,
                         call_580066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580066, url, valid)

proc call*(call_580067: Call_ContentOrdersSetlineitemmetadata_580053;
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
  var path_580068 = newJObject()
  var query_580069 = newJObject()
  var body_580070 = newJObject()
  add(query_580069, "key", newJString(key))
  add(query_580069, "prettyPrint", newJBool(prettyPrint))
  add(query_580069, "oauth_token", newJString(oauthToken))
  add(query_580069, "alt", newJString(alt))
  add(query_580069, "userIp", newJString(userIp))
  add(query_580069, "quotaUser", newJString(quotaUser))
  add(path_580068, "merchantId", newJString(merchantId))
  if body != nil:
    body_580070 = body
  add(query_580069, "fields", newJString(fields))
  add(path_580068, "orderId", newJString(orderId))
  result = call_580067.call(path_580068, query_580069, nil, nil, body_580070)

var contentOrdersSetlineitemmetadata* = Call_ContentOrdersSetlineitemmetadata_580053(
    name: "contentOrdersSetlineitemmetadata", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/setLineItemMetadata",
    validator: validate_ContentOrdersSetlineitemmetadata_580054,
    base: "/content/v2", url: url_ContentOrdersSetlineitemmetadata_580055,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersShiplineitems_580071 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersShiplineitems_580073(protocol: Scheme; host: string;
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

proc validate_ContentOrdersShiplineitems_580072(path: JsonNode; query: JsonNode;
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
  var valid_580074 = path.getOrDefault("merchantId")
  valid_580074 = validateParameter(valid_580074, JString, required = true,
                                 default = nil)
  if valid_580074 != nil:
    section.add "merchantId", valid_580074
  var valid_580075 = path.getOrDefault("orderId")
  valid_580075 = validateParameter(valid_580075, JString, required = true,
                                 default = nil)
  if valid_580075 != nil:
    section.add "orderId", valid_580075
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
  var valid_580076 = query.getOrDefault("key")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "key", valid_580076
  var valid_580077 = query.getOrDefault("prettyPrint")
  valid_580077 = validateParameter(valid_580077, JBool, required = false,
                                 default = newJBool(true))
  if valid_580077 != nil:
    section.add "prettyPrint", valid_580077
  var valid_580078 = query.getOrDefault("oauth_token")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "oauth_token", valid_580078
  var valid_580079 = query.getOrDefault("alt")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = newJString("json"))
  if valid_580079 != nil:
    section.add "alt", valid_580079
  var valid_580080 = query.getOrDefault("userIp")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "userIp", valid_580080
  var valid_580081 = query.getOrDefault("quotaUser")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "quotaUser", valid_580081
  var valid_580082 = query.getOrDefault("fields")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "fields", valid_580082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580084: Call_ContentOrdersShiplineitems_580071; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks line item(s) as shipped.
  ## 
  let valid = call_580084.validator(path, query, header, formData, body)
  let scheme = call_580084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580084.url(scheme.get, call_580084.host, call_580084.base,
                         call_580084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580084, url, valid)

proc call*(call_580085: Call_ContentOrdersShiplineitems_580071; merchantId: string;
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
  var path_580086 = newJObject()
  var query_580087 = newJObject()
  var body_580088 = newJObject()
  add(query_580087, "key", newJString(key))
  add(query_580087, "prettyPrint", newJBool(prettyPrint))
  add(query_580087, "oauth_token", newJString(oauthToken))
  add(query_580087, "alt", newJString(alt))
  add(query_580087, "userIp", newJString(userIp))
  add(query_580087, "quotaUser", newJString(quotaUser))
  add(path_580086, "merchantId", newJString(merchantId))
  if body != nil:
    body_580088 = body
  add(query_580087, "fields", newJString(fields))
  add(path_580086, "orderId", newJString(orderId))
  result = call_580085.call(path_580086, query_580087, nil, nil, body_580088)

var contentOrdersShiplineitems* = Call_ContentOrdersShiplineitems_580071(
    name: "contentOrdersShiplineitems", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/shipLineItems",
    validator: validate_ContentOrdersShiplineitems_580072, base: "/content/v2",
    url: url_ContentOrdersShiplineitems_580073, schemes: {Scheme.Https})
type
  Call_ContentOrdersCreatetestreturn_580089 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersCreatetestreturn_580091(protocol: Scheme; host: string;
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

proc validate_ContentOrdersCreatetestreturn_580090(path: JsonNode; query: JsonNode;
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
  var valid_580092 = path.getOrDefault("merchantId")
  valid_580092 = validateParameter(valid_580092, JString, required = true,
                                 default = nil)
  if valid_580092 != nil:
    section.add "merchantId", valid_580092
  var valid_580093 = path.getOrDefault("orderId")
  valid_580093 = validateParameter(valid_580093, JString, required = true,
                                 default = nil)
  if valid_580093 != nil:
    section.add "orderId", valid_580093
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
  var valid_580094 = query.getOrDefault("key")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "key", valid_580094
  var valid_580095 = query.getOrDefault("prettyPrint")
  valid_580095 = validateParameter(valid_580095, JBool, required = false,
                                 default = newJBool(true))
  if valid_580095 != nil:
    section.add "prettyPrint", valid_580095
  var valid_580096 = query.getOrDefault("oauth_token")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "oauth_token", valid_580096
  var valid_580097 = query.getOrDefault("alt")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = newJString("json"))
  if valid_580097 != nil:
    section.add "alt", valid_580097
  var valid_580098 = query.getOrDefault("userIp")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "userIp", valid_580098
  var valid_580099 = query.getOrDefault("quotaUser")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "quotaUser", valid_580099
  var valid_580100 = query.getOrDefault("fields")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "fields", valid_580100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580102: Call_ContentOrdersCreatetestreturn_580089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Creates a test return.
  ## 
  let valid = call_580102.validator(path, query, header, formData, body)
  let scheme = call_580102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580102.url(scheme.get, call_580102.host, call_580102.base,
                         call_580102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580102, url, valid)

proc call*(call_580103: Call_ContentOrdersCreatetestreturn_580089;
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
  var path_580104 = newJObject()
  var query_580105 = newJObject()
  var body_580106 = newJObject()
  add(query_580105, "key", newJString(key))
  add(query_580105, "prettyPrint", newJBool(prettyPrint))
  add(query_580105, "oauth_token", newJString(oauthToken))
  add(query_580105, "alt", newJString(alt))
  add(query_580105, "userIp", newJString(userIp))
  add(query_580105, "quotaUser", newJString(quotaUser))
  add(path_580104, "merchantId", newJString(merchantId))
  if body != nil:
    body_580106 = body
  add(query_580105, "fields", newJString(fields))
  add(path_580104, "orderId", newJString(orderId))
  result = call_580103.call(path_580104, query_580105, nil, nil, body_580106)

var contentOrdersCreatetestreturn* = Call_ContentOrdersCreatetestreturn_580089(
    name: "contentOrdersCreatetestreturn", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/testreturn",
    validator: validate_ContentOrdersCreatetestreturn_580090, base: "/content/v2",
    url: url_ContentOrdersCreatetestreturn_580091, schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdatelineitemshippingdetails_580107 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersUpdatelineitemshippingdetails_580109(protocol: Scheme;
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

proc validate_ContentOrdersUpdatelineitemshippingdetails_580108(path: JsonNode;
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
  var valid_580110 = path.getOrDefault("merchantId")
  valid_580110 = validateParameter(valid_580110, JString, required = true,
                                 default = nil)
  if valid_580110 != nil:
    section.add "merchantId", valid_580110
  var valid_580111 = path.getOrDefault("orderId")
  valid_580111 = validateParameter(valid_580111, JString, required = true,
                                 default = nil)
  if valid_580111 != nil:
    section.add "orderId", valid_580111
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
  var valid_580112 = query.getOrDefault("key")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "key", valid_580112
  var valid_580113 = query.getOrDefault("prettyPrint")
  valid_580113 = validateParameter(valid_580113, JBool, required = false,
                                 default = newJBool(true))
  if valid_580113 != nil:
    section.add "prettyPrint", valid_580113
  var valid_580114 = query.getOrDefault("oauth_token")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "oauth_token", valid_580114
  var valid_580115 = query.getOrDefault("alt")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = newJString("json"))
  if valid_580115 != nil:
    section.add "alt", valid_580115
  var valid_580116 = query.getOrDefault("userIp")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "userIp", valid_580116
  var valid_580117 = query.getOrDefault("quotaUser")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "quotaUser", valid_580117
  var valid_580118 = query.getOrDefault("fields")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "fields", valid_580118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580120: Call_ContentOrdersUpdatelineitemshippingdetails_580107;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates ship by and delivery by dates for a line item.
  ## 
  let valid = call_580120.validator(path, query, header, formData, body)
  let scheme = call_580120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580120.url(scheme.get, call_580120.host, call_580120.base,
                         call_580120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580120, url, valid)

proc call*(call_580121: Call_ContentOrdersUpdatelineitemshippingdetails_580107;
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
  var path_580122 = newJObject()
  var query_580123 = newJObject()
  var body_580124 = newJObject()
  add(query_580123, "key", newJString(key))
  add(query_580123, "prettyPrint", newJBool(prettyPrint))
  add(query_580123, "oauth_token", newJString(oauthToken))
  add(query_580123, "alt", newJString(alt))
  add(query_580123, "userIp", newJString(userIp))
  add(query_580123, "quotaUser", newJString(quotaUser))
  add(path_580122, "merchantId", newJString(merchantId))
  if body != nil:
    body_580124 = body
  add(query_580123, "fields", newJString(fields))
  add(path_580122, "orderId", newJString(orderId))
  result = call_580121.call(path_580122, query_580123, nil, nil, body_580124)

var contentOrdersUpdatelineitemshippingdetails* = Call_ContentOrdersUpdatelineitemshippingdetails_580107(
    name: "contentOrdersUpdatelineitemshippingdetails", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateLineItemShippingDetails",
    validator: validate_ContentOrdersUpdatelineitemshippingdetails_580108,
    base: "/content/v2", url: url_ContentOrdersUpdatelineitemshippingdetails_580109,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdatemerchantorderid_580125 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersUpdatemerchantorderid_580127(protocol: Scheme; host: string;
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

proc validate_ContentOrdersUpdatemerchantorderid_580126(path: JsonNode;
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
  var valid_580128 = path.getOrDefault("merchantId")
  valid_580128 = validateParameter(valid_580128, JString, required = true,
                                 default = nil)
  if valid_580128 != nil:
    section.add "merchantId", valid_580128
  var valid_580129 = path.getOrDefault("orderId")
  valid_580129 = validateParameter(valid_580129, JString, required = true,
                                 default = nil)
  if valid_580129 != nil:
    section.add "orderId", valid_580129
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
  var valid_580132 = query.getOrDefault("oauth_token")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "oauth_token", valid_580132
  var valid_580133 = query.getOrDefault("alt")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = newJString("json"))
  if valid_580133 != nil:
    section.add "alt", valid_580133
  var valid_580134 = query.getOrDefault("userIp")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "userIp", valid_580134
  var valid_580135 = query.getOrDefault("quotaUser")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "quotaUser", valid_580135
  var valid_580136 = query.getOrDefault("fields")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "fields", valid_580136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580138: Call_ContentOrdersUpdatemerchantorderid_580125;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the merchant order ID for a given order.
  ## 
  let valid = call_580138.validator(path, query, header, formData, body)
  let scheme = call_580138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580138.url(scheme.get, call_580138.host, call_580138.base,
                         call_580138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580138, url, valid)

proc call*(call_580139: Call_ContentOrdersUpdatemerchantorderid_580125;
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
  var path_580140 = newJObject()
  var query_580141 = newJObject()
  var body_580142 = newJObject()
  add(query_580141, "key", newJString(key))
  add(query_580141, "prettyPrint", newJBool(prettyPrint))
  add(query_580141, "oauth_token", newJString(oauthToken))
  add(query_580141, "alt", newJString(alt))
  add(query_580141, "userIp", newJString(userIp))
  add(query_580141, "quotaUser", newJString(quotaUser))
  add(path_580140, "merchantId", newJString(merchantId))
  if body != nil:
    body_580142 = body
  add(query_580141, "fields", newJString(fields))
  add(path_580140, "orderId", newJString(orderId))
  result = call_580139.call(path_580140, query_580141, nil, nil, body_580142)

var contentOrdersUpdatemerchantorderid* = Call_ContentOrdersUpdatemerchantorderid_580125(
    name: "contentOrdersUpdatemerchantorderid", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateMerchantOrderId",
    validator: validate_ContentOrdersUpdatemerchantorderid_580126,
    base: "/content/v2", url: url_ContentOrdersUpdatemerchantorderid_580127,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdateshipment_580143 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersUpdateshipment_580145(protocol: Scheme; host: string;
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

proc validate_ContentOrdersUpdateshipment_580144(path: JsonNode; query: JsonNode;
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
  var valid_580146 = path.getOrDefault("merchantId")
  valid_580146 = validateParameter(valid_580146, JString, required = true,
                                 default = nil)
  if valid_580146 != nil:
    section.add "merchantId", valid_580146
  var valid_580147 = path.getOrDefault("orderId")
  valid_580147 = validateParameter(valid_580147, JString, required = true,
                                 default = nil)
  if valid_580147 != nil:
    section.add "orderId", valid_580147
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
  var valid_580154 = query.getOrDefault("fields")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "fields", valid_580154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580156: Call_ContentOrdersUpdateshipment_580143; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a shipment's status, carrier, and/or tracking ID.
  ## 
  let valid = call_580156.validator(path, query, header, formData, body)
  let scheme = call_580156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580156.url(scheme.get, call_580156.host, call_580156.base,
                         call_580156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580156, url, valid)

proc call*(call_580157: Call_ContentOrdersUpdateshipment_580143;
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
  var path_580158 = newJObject()
  var query_580159 = newJObject()
  var body_580160 = newJObject()
  add(query_580159, "key", newJString(key))
  add(query_580159, "prettyPrint", newJBool(prettyPrint))
  add(query_580159, "oauth_token", newJString(oauthToken))
  add(query_580159, "alt", newJString(alt))
  add(query_580159, "userIp", newJString(userIp))
  add(query_580159, "quotaUser", newJString(quotaUser))
  add(path_580158, "merchantId", newJString(merchantId))
  if body != nil:
    body_580160 = body
  add(query_580159, "fields", newJString(fields))
  add(path_580158, "orderId", newJString(orderId))
  result = call_580157.call(path_580158, query_580159, nil, nil, body_580160)

var contentOrdersUpdateshipment* = Call_ContentOrdersUpdateshipment_580143(
    name: "contentOrdersUpdateshipment", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateShipment",
    validator: validate_ContentOrdersUpdateshipment_580144, base: "/content/v2",
    url: url_ContentOrdersUpdateshipment_580145, schemes: {Scheme.Https})
type
  Call_ContentOrdersGetbymerchantorderid_580161 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersGetbymerchantorderid_580163(protocol: Scheme; host: string;
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

proc validate_ContentOrdersGetbymerchantorderid_580162(path: JsonNode;
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
  var valid_580164 = path.getOrDefault("merchantOrderId")
  valid_580164 = validateParameter(valid_580164, JString, required = true,
                                 default = nil)
  if valid_580164 != nil:
    section.add "merchantOrderId", valid_580164
  var valid_580165 = path.getOrDefault("merchantId")
  valid_580165 = validateParameter(valid_580165, JString, required = true,
                                 default = nil)
  if valid_580165 != nil:
    section.add "merchantId", valid_580165
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
  var valid_580166 = query.getOrDefault("key")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "key", valid_580166
  var valid_580167 = query.getOrDefault("prettyPrint")
  valid_580167 = validateParameter(valid_580167, JBool, required = false,
                                 default = newJBool(true))
  if valid_580167 != nil:
    section.add "prettyPrint", valid_580167
  var valid_580168 = query.getOrDefault("oauth_token")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "oauth_token", valid_580168
  var valid_580169 = query.getOrDefault("alt")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = newJString("json"))
  if valid_580169 != nil:
    section.add "alt", valid_580169
  var valid_580170 = query.getOrDefault("userIp")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "userIp", valid_580170
  var valid_580171 = query.getOrDefault("quotaUser")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "quotaUser", valid_580171
  var valid_580172 = query.getOrDefault("fields")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "fields", valid_580172
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580173: Call_ContentOrdersGetbymerchantorderid_580161;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves an order using merchant order ID.
  ## 
  let valid = call_580173.validator(path, query, header, formData, body)
  let scheme = call_580173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580173.url(scheme.get, call_580173.host, call_580173.base,
                         call_580173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580173, url, valid)

proc call*(call_580174: Call_ContentOrdersGetbymerchantorderid_580161;
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
  var path_580175 = newJObject()
  var query_580176 = newJObject()
  add(query_580176, "key", newJString(key))
  add(query_580176, "prettyPrint", newJBool(prettyPrint))
  add(query_580176, "oauth_token", newJString(oauthToken))
  add(path_580175, "merchantOrderId", newJString(merchantOrderId))
  add(query_580176, "alt", newJString(alt))
  add(query_580176, "userIp", newJString(userIp))
  add(query_580176, "quotaUser", newJString(quotaUser))
  add(path_580175, "merchantId", newJString(merchantId))
  add(query_580176, "fields", newJString(fields))
  result = call_580174.call(path_580175, query_580176, nil, nil, nil)

var contentOrdersGetbymerchantorderid* = Call_ContentOrdersGetbymerchantorderid_580161(
    name: "contentOrdersGetbymerchantorderid", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/ordersbymerchantid/{merchantOrderId}",
    validator: validate_ContentOrdersGetbymerchantorderid_580162,
    base: "/content/v2", url: url_ContentOrdersGetbymerchantorderid_580163,
    schemes: {Scheme.Https})
type
  Call_ContentPosInventory_580177 = ref object of OpenApiRestCall_578348
proc url_ContentPosInventory_580179(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosInventory_580178(path: JsonNode; query: JsonNode;
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
  var valid_580180 = path.getOrDefault("targetMerchantId")
  valid_580180 = validateParameter(valid_580180, JString, required = true,
                                 default = nil)
  if valid_580180 != nil:
    section.add "targetMerchantId", valid_580180
  var valid_580181 = path.getOrDefault("merchantId")
  valid_580181 = validateParameter(valid_580181, JString, required = true,
                                 default = nil)
  if valid_580181 != nil:
    section.add "merchantId", valid_580181
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
  var valid_580182 = query.getOrDefault("key")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "key", valid_580182
  var valid_580183 = query.getOrDefault("prettyPrint")
  valid_580183 = validateParameter(valid_580183, JBool, required = false,
                                 default = newJBool(true))
  if valid_580183 != nil:
    section.add "prettyPrint", valid_580183
  var valid_580184 = query.getOrDefault("oauth_token")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "oauth_token", valid_580184
  var valid_580185 = query.getOrDefault("alt")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = newJString("json"))
  if valid_580185 != nil:
    section.add "alt", valid_580185
  var valid_580186 = query.getOrDefault("userIp")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "userIp", valid_580186
  var valid_580187 = query.getOrDefault("quotaUser")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "quotaUser", valid_580187
  var valid_580188 = query.getOrDefault("dryRun")
  valid_580188 = validateParameter(valid_580188, JBool, required = false, default = nil)
  if valid_580188 != nil:
    section.add "dryRun", valid_580188
  var valid_580189 = query.getOrDefault("fields")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "fields", valid_580189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580191: Call_ContentPosInventory_580177; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit inventory for the given merchant.
  ## 
  let valid = call_580191.validator(path, query, header, formData, body)
  let scheme = call_580191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580191.url(scheme.get, call_580191.host, call_580191.base,
                         call_580191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580191, url, valid)

proc call*(call_580192: Call_ContentPosInventory_580177; targetMerchantId: string;
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
  var path_580193 = newJObject()
  var query_580194 = newJObject()
  var body_580195 = newJObject()
  add(query_580194, "key", newJString(key))
  add(query_580194, "prettyPrint", newJBool(prettyPrint))
  add(query_580194, "oauth_token", newJString(oauthToken))
  add(path_580193, "targetMerchantId", newJString(targetMerchantId))
  add(query_580194, "alt", newJString(alt))
  add(query_580194, "userIp", newJString(userIp))
  add(query_580194, "quotaUser", newJString(quotaUser))
  add(path_580193, "merchantId", newJString(merchantId))
  add(query_580194, "dryRun", newJBool(dryRun))
  if body != nil:
    body_580195 = body
  add(query_580194, "fields", newJString(fields))
  result = call_580192.call(path_580193, query_580194, nil, nil, body_580195)

var contentPosInventory* = Call_ContentPosInventory_580177(
    name: "contentPosInventory", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/inventory",
    validator: validate_ContentPosInventory_580178, base: "/content/v2",
    url: url_ContentPosInventory_580179, schemes: {Scheme.Https})
type
  Call_ContentPosSale_580196 = ref object of OpenApiRestCall_578348
proc url_ContentPosSale_580198(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosSale_580197(path: JsonNode; query: JsonNode;
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
  var valid_580199 = path.getOrDefault("targetMerchantId")
  valid_580199 = validateParameter(valid_580199, JString, required = true,
                                 default = nil)
  if valid_580199 != nil:
    section.add "targetMerchantId", valid_580199
  var valid_580200 = path.getOrDefault("merchantId")
  valid_580200 = validateParameter(valid_580200, JString, required = true,
                                 default = nil)
  if valid_580200 != nil:
    section.add "merchantId", valid_580200
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
  var valid_580201 = query.getOrDefault("key")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "key", valid_580201
  var valid_580202 = query.getOrDefault("prettyPrint")
  valid_580202 = validateParameter(valid_580202, JBool, required = false,
                                 default = newJBool(true))
  if valid_580202 != nil:
    section.add "prettyPrint", valid_580202
  var valid_580203 = query.getOrDefault("oauth_token")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "oauth_token", valid_580203
  var valid_580204 = query.getOrDefault("alt")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = newJString("json"))
  if valid_580204 != nil:
    section.add "alt", valid_580204
  var valid_580205 = query.getOrDefault("userIp")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "userIp", valid_580205
  var valid_580206 = query.getOrDefault("quotaUser")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "quotaUser", valid_580206
  var valid_580207 = query.getOrDefault("dryRun")
  valid_580207 = validateParameter(valid_580207, JBool, required = false, default = nil)
  if valid_580207 != nil:
    section.add "dryRun", valid_580207
  var valid_580208 = query.getOrDefault("fields")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "fields", valid_580208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580210: Call_ContentPosSale_580196; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit a sale event for the given merchant.
  ## 
  let valid = call_580210.validator(path, query, header, formData, body)
  let scheme = call_580210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580210.url(scheme.get, call_580210.host, call_580210.base,
                         call_580210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580210, url, valid)

proc call*(call_580211: Call_ContentPosSale_580196; targetMerchantId: string;
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
  var path_580212 = newJObject()
  var query_580213 = newJObject()
  var body_580214 = newJObject()
  add(query_580213, "key", newJString(key))
  add(query_580213, "prettyPrint", newJBool(prettyPrint))
  add(query_580213, "oauth_token", newJString(oauthToken))
  add(path_580212, "targetMerchantId", newJString(targetMerchantId))
  add(query_580213, "alt", newJString(alt))
  add(query_580213, "userIp", newJString(userIp))
  add(query_580213, "quotaUser", newJString(quotaUser))
  add(path_580212, "merchantId", newJString(merchantId))
  add(query_580213, "dryRun", newJBool(dryRun))
  if body != nil:
    body_580214 = body
  add(query_580213, "fields", newJString(fields))
  result = call_580211.call(path_580212, query_580213, nil, nil, body_580214)

var contentPosSale* = Call_ContentPosSale_580196(name: "contentPosSale",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/sale",
    validator: validate_ContentPosSale_580197, base: "/content/v2",
    url: url_ContentPosSale_580198, schemes: {Scheme.Https})
type
  Call_ContentPosInsert_580231 = ref object of OpenApiRestCall_578348
proc url_ContentPosInsert_580233(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosInsert_580232(path: JsonNode; query: JsonNode;
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
  var valid_580234 = path.getOrDefault("targetMerchantId")
  valid_580234 = validateParameter(valid_580234, JString, required = true,
                                 default = nil)
  if valid_580234 != nil:
    section.add "targetMerchantId", valid_580234
  var valid_580235 = path.getOrDefault("merchantId")
  valid_580235 = validateParameter(valid_580235, JString, required = true,
                                 default = nil)
  if valid_580235 != nil:
    section.add "merchantId", valid_580235
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
  var valid_580236 = query.getOrDefault("key")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "key", valid_580236
  var valid_580237 = query.getOrDefault("prettyPrint")
  valid_580237 = validateParameter(valid_580237, JBool, required = false,
                                 default = newJBool(true))
  if valid_580237 != nil:
    section.add "prettyPrint", valid_580237
  var valid_580238 = query.getOrDefault("oauth_token")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "oauth_token", valid_580238
  var valid_580239 = query.getOrDefault("alt")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = newJString("json"))
  if valid_580239 != nil:
    section.add "alt", valid_580239
  var valid_580240 = query.getOrDefault("userIp")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "userIp", valid_580240
  var valid_580241 = query.getOrDefault("quotaUser")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "quotaUser", valid_580241
  var valid_580242 = query.getOrDefault("dryRun")
  valid_580242 = validateParameter(valid_580242, JBool, required = false, default = nil)
  if valid_580242 != nil:
    section.add "dryRun", valid_580242
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

proc call*(call_580245: Call_ContentPosInsert_580231; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a store for the given merchant.
  ## 
  let valid = call_580245.validator(path, query, header, formData, body)
  let scheme = call_580245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580245.url(scheme.get, call_580245.host, call_580245.base,
                         call_580245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580245, url, valid)

proc call*(call_580246: Call_ContentPosInsert_580231; targetMerchantId: string;
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
  var path_580247 = newJObject()
  var query_580248 = newJObject()
  var body_580249 = newJObject()
  add(query_580248, "key", newJString(key))
  add(query_580248, "prettyPrint", newJBool(prettyPrint))
  add(query_580248, "oauth_token", newJString(oauthToken))
  add(path_580247, "targetMerchantId", newJString(targetMerchantId))
  add(query_580248, "alt", newJString(alt))
  add(query_580248, "userIp", newJString(userIp))
  add(query_580248, "quotaUser", newJString(quotaUser))
  add(path_580247, "merchantId", newJString(merchantId))
  add(query_580248, "dryRun", newJBool(dryRun))
  if body != nil:
    body_580249 = body
  add(query_580248, "fields", newJString(fields))
  result = call_580246.call(path_580247, query_580248, nil, nil, body_580249)

var contentPosInsert* = Call_ContentPosInsert_580231(name: "contentPosInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store",
    validator: validate_ContentPosInsert_580232, base: "/content/v2",
    url: url_ContentPosInsert_580233, schemes: {Scheme.Https})
type
  Call_ContentPosList_580215 = ref object of OpenApiRestCall_578348
proc url_ContentPosList_580217(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosList_580216(path: JsonNode; query: JsonNode;
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
  var valid_580218 = path.getOrDefault("targetMerchantId")
  valid_580218 = validateParameter(valid_580218, JString, required = true,
                                 default = nil)
  if valid_580218 != nil:
    section.add "targetMerchantId", valid_580218
  var valid_580219 = path.getOrDefault("merchantId")
  valid_580219 = validateParameter(valid_580219, JString, required = true,
                                 default = nil)
  if valid_580219 != nil:
    section.add "merchantId", valid_580219
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
  var valid_580223 = query.getOrDefault("alt")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = newJString("json"))
  if valid_580223 != nil:
    section.add "alt", valid_580223
  var valid_580224 = query.getOrDefault("userIp")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "userIp", valid_580224
  var valid_580225 = query.getOrDefault("quotaUser")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "quotaUser", valid_580225
  var valid_580226 = query.getOrDefault("fields")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "fields", valid_580226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580227: Call_ContentPosList_580215; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the stores of the target merchant.
  ## 
  let valid = call_580227.validator(path, query, header, formData, body)
  let scheme = call_580227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580227.url(scheme.get, call_580227.host, call_580227.base,
                         call_580227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580227, url, valid)

proc call*(call_580228: Call_ContentPosList_580215; targetMerchantId: string;
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
  var path_580229 = newJObject()
  var query_580230 = newJObject()
  add(query_580230, "key", newJString(key))
  add(query_580230, "prettyPrint", newJBool(prettyPrint))
  add(query_580230, "oauth_token", newJString(oauthToken))
  add(path_580229, "targetMerchantId", newJString(targetMerchantId))
  add(query_580230, "alt", newJString(alt))
  add(query_580230, "userIp", newJString(userIp))
  add(query_580230, "quotaUser", newJString(quotaUser))
  add(path_580229, "merchantId", newJString(merchantId))
  add(query_580230, "fields", newJString(fields))
  result = call_580228.call(path_580229, query_580230, nil, nil, nil)

var contentPosList* = Call_ContentPosList_580215(name: "contentPosList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store",
    validator: validate_ContentPosList_580216, base: "/content/v2",
    url: url_ContentPosList_580217, schemes: {Scheme.Https})
type
  Call_ContentPosGet_580250 = ref object of OpenApiRestCall_578348
proc url_ContentPosGet_580252(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosGet_580251(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_580253 = path.getOrDefault("targetMerchantId")
  valid_580253 = validateParameter(valid_580253, JString, required = true,
                                 default = nil)
  if valid_580253 != nil:
    section.add "targetMerchantId", valid_580253
  var valid_580254 = path.getOrDefault("storeCode")
  valid_580254 = validateParameter(valid_580254, JString, required = true,
                                 default = nil)
  if valid_580254 != nil:
    section.add "storeCode", valid_580254
  var valid_580255 = path.getOrDefault("merchantId")
  valid_580255 = validateParameter(valid_580255, JString, required = true,
                                 default = nil)
  if valid_580255 != nil:
    section.add "merchantId", valid_580255
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
  var valid_580256 = query.getOrDefault("key")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "key", valid_580256
  var valid_580257 = query.getOrDefault("prettyPrint")
  valid_580257 = validateParameter(valid_580257, JBool, required = false,
                                 default = newJBool(true))
  if valid_580257 != nil:
    section.add "prettyPrint", valid_580257
  var valid_580258 = query.getOrDefault("oauth_token")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "oauth_token", valid_580258
  var valid_580259 = query.getOrDefault("alt")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = newJString("json"))
  if valid_580259 != nil:
    section.add "alt", valid_580259
  var valid_580260 = query.getOrDefault("userIp")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "userIp", valid_580260
  var valid_580261 = query.getOrDefault("quotaUser")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "quotaUser", valid_580261
  var valid_580262 = query.getOrDefault("fields")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "fields", valid_580262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580263: Call_ContentPosGet_580250; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about the given store.
  ## 
  let valid = call_580263.validator(path, query, header, formData, body)
  let scheme = call_580263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580263.url(scheme.get, call_580263.host, call_580263.base,
                         call_580263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580263, url, valid)

proc call*(call_580264: Call_ContentPosGet_580250; targetMerchantId: string;
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
  var path_580265 = newJObject()
  var query_580266 = newJObject()
  add(query_580266, "key", newJString(key))
  add(query_580266, "prettyPrint", newJBool(prettyPrint))
  add(query_580266, "oauth_token", newJString(oauthToken))
  add(path_580265, "targetMerchantId", newJString(targetMerchantId))
  add(path_580265, "storeCode", newJString(storeCode))
  add(query_580266, "alt", newJString(alt))
  add(query_580266, "userIp", newJString(userIp))
  add(query_580266, "quotaUser", newJString(quotaUser))
  add(path_580265, "merchantId", newJString(merchantId))
  add(query_580266, "fields", newJString(fields))
  result = call_580264.call(path_580265, query_580266, nil, nil, nil)

var contentPosGet* = Call_ContentPosGet_580250(name: "contentPosGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store/{storeCode}",
    validator: validate_ContentPosGet_580251, base: "/content/v2",
    url: url_ContentPosGet_580252, schemes: {Scheme.Https})
type
  Call_ContentPosDelete_580267 = ref object of OpenApiRestCall_578348
proc url_ContentPosDelete_580269(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosDelete_580268(path: JsonNode; query: JsonNode;
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
  var valid_580270 = path.getOrDefault("targetMerchantId")
  valid_580270 = validateParameter(valid_580270, JString, required = true,
                                 default = nil)
  if valid_580270 != nil:
    section.add "targetMerchantId", valid_580270
  var valid_580271 = path.getOrDefault("storeCode")
  valid_580271 = validateParameter(valid_580271, JString, required = true,
                                 default = nil)
  if valid_580271 != nil:
    section.add "storeCode", valid_580271
  var valid_580272 = path.getOrDefault("merchantId")
  valid_580272 = validateParameter(valid_580272, JString, required = true,
                                 default = nil)
  if valid_580272 != nil:
    section.add "merchantId", valid_580272
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
  var valid_580279 = query.getOrDefault("dryRun")
  valid_580279 = validateParameter(valid_580279, JBool, required = false, default = nil)
  if valid_580279 != nil:
    section.add "dryRun", valid_580279
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

proc call*(call_580281: Call_ContentPosDelete_580267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a store for the given merchant.
  ## 
  let valid = call_580281.validator(path, query, header, formData, body)
  let scheme = call_580281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580281.url(scheme.get, call_580281.host, call_580281.base,
                         call_580281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580281, url, valid)

proc call*(call_580282: Call_ContentPosDelete_580267; targetMerchantId: string;
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
  var path_580283 = newJObject()
  var query_580284 = newJObject()
  add(query_580284, "key", newJString(key))
  add(query_580284, "prettyPrint", newJBool(prettyPrint))
  add(query_580284, "oauth_token", newJString(oauthToken))
  add(path_580283, "targetMerchantId", newJString(targetMerchantId))
  add(path_580283, "storeCode", newJString(storeCode))
  add(query_580284, "alt", newJString(alt))
  add(query_580284, "userIp", newJString(userIp))
  add(query_580284, "quotaUser", newJString(quotaUser))
  add(path_580283, "merchantId", newJString(merchantId))
  add(query_580284, "dryRun", newJBool(dryRun))
  add(query_580284, "fields", newJString(fields))
  result = call_580282.call(path_580283, query_580284, nil, nil, nil)

var contentPosDelete* = Call_ContentPosDelete_580267(name: "contentPosDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store/{storeCode}",
    validator: validate_ContentPosDelete_580268, base: "/content/v2",
    url: url_ContentPosDelete_580269, schemes: {Scheme.Https})
type
  Call_ContentProductsInsert_580303 = ref object of OpenApiRestCall_578348
proc url_ContentProductsInsert_580305(protocol: Scheme; host: string; base: string;
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

proc validate_ContentProductsInsert_580304(path: JsonNode; query: JsonNode;
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
  var valid_580306 = path.getOrDefault("merchantId")
  valid_580306 = validateParameter(valid_580306, JString, required = true,
                                 default = nil)
  if valid_580306 != nil:
    section.add "merchantId", valid_580306
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
  var valid_580313 = query.getOrDefault("dryRun")
  valid_580313 = validateParameter(valid_580313, JBool, required = false, default = nil)
  if valid_580313 != nil:
    section.add "dryRun", valid_580313
  var valid_580314 = query.getOrDefault("fields")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "fields", valid_580314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580316: Call_ContentProductsInsert_580303; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a product to your Merchant Center account. If an item with the same channel, contentLanguage, offerId, and targetCountry already exists, this method updates that entry.
  ## 
  let valid = call_580316.validator(path, query, header, formData, body)
  let scheme = call_580316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580316.url(scheme.get, call_580316.host, call_580316.base,
                         call_580316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580316, url, valid)

proc call*(call_580317: Call_ContentProductsInsert_580303; merchantId: string;
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
  var path_580318 = newJObject()
  var query_580319 = newJObject()
  var body_580320 = newJObject()
  add(query_580319, "key", newJString(key))
  add(query_580319, "prettyPrint", newJBool(prettyPrint))
  add(query_580319, "oauth_token", newJString(oauthToken))
  add(query_580319, "alt", newJString(alt))
  add(query_580319, "userIp", newJString(userIp))
  add(query_580319, "quotaUser", newJString(quotaUser))
  add(path_580318, "merchantId", newJString(merchantId))
  add(query_580319, "dryRun", newJBool(dryRun))
  if body != nil:
    body_580320 = body
  add(query_580319, "fields", newJString(fields))
  result = call_580317.call(path_580318, query_580319, nil, nil, body_580320)

var contentProductsInsert* = Call_ContentProductsInsert_580303(
    name: "contentProductsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/products",
    validator: validate_ContentProductsInsert_580304, base: "/content/v2",
    url: url_ContentProductsInsert_580305, schemes: {Scheme.Https})
type
  Call_ContentProductsList_580285 = ref object of OpenApiRestCall_578348
proc url_ContentProductsList_580287(protocol: Scheme; host: string; base: string;
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

proc validate_ContentProductsList_580286(path: JsonNode; query: JsonNode;
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
  ##   includeInvalidInsertedItems: JBool
  ##                              : Flag to include the invalid inserted items in the result of the list request. By default the invalid items are not shown (the default value is false).
  ##   maxResults: JInt
  ##             : The maximum number of products to return in the response, used for paging.
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
  var valid_580297 = query.getOrDefault("includeInvalidInsertedItems")
  valid_580297 = validateParameter(valid_580297, JBool, required = false, default = nil)
  if valid_580297 != nil:
    section.add "includeInvalidInsertedItems", valid_580297
  var valid_580298 = query.getOrDefault("maxResults")
  valid_580298 = validateParameter(valid_580298, JInt, required = false, default = nil)
  if valid_580298 != nil:
    section.add "maxResults", valid_580298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580299: Call_ContentProductsList_580285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the products in your Merchant Center account.
  ## 
  let valid = call_580299.validator(path, query, header, formData, body)
  let scheme = call_580299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580299.url(scheme.get, call_580299.host, call_580299.base,
                         call_580299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580299, url, valid)

proc call*(call_580300: Call_ContentProductsList_580285; merchantId: string;
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
  var path_580301 = newJObject()
  var query_580302 = newJObject()
  add(query_580302, "key", newJString(key))
  add(query_580302, "prettyPrint", newJBool(prettyPrint))
  add(query_580302, "oauth_token", newJString(oauthToken))
  add(query_580302, "alt", newJString(alt))
  add(query_580302, "userIp", newJString(userIp))
  add(query_580302, "quotaUser", newJString(quotaUser))
  add(path_580301, "merchantId", newJString(merchantId))
  add(query_580302, "pageToken", newJString(pageToken))
  add(query_580302, "fields", newJString(fields))
  add(query_580302, "includeInvalidInsertedItems",
      newJBool(includeInvalidInsertedItems))
  add(query_580302, "maxResults", newJInt(maxResults))
  result = call_580300.call(path_580301, query_580302, nil, nil, nil)

var contentProductsList* = Call_ContentProductsList_580285(
    name: "contentProductsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/products",
    validator: validate_ContentProductsList_580286, base: "/content/v2",
    url: url_ContentProductsList_580287, schemes: {Scheme.Https})
type
  Call_ContentProductsGet_580321 = ref object of OpenApiRestCall_578348
proc url_ContentProductsGet_580323(protocol: Scheme; host: string; base: string;
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

proc validate_ContentProductsGet_580322(path: JsonNode; query: JsonNode;
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
  var valid_580324 = path.getOrDefault("merchantId")
  valid_580324 = validateParameter(valid_580324, JString, required = true,
                                 default = nil)
  if valid_580324 != nil:
    section.add "merchantId", valid_580324
  var valid_580325 = path.getOrDefault("productId")
  valid_580325 = validateParameter(valid_580325, JString, required = true,
                                 default = nil)
  if valid_580325 != nil:
    section.add "productId", valid_580325
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
  var valid_580328 = query.getOrDefault("oauth_token")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "oauth_token", valid_580328
  var valid_580329 = query.getOrDefault("alt")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = newJString("json"))
  if valid_580329 != nil:
    section.add "alt", valid_580329
  var valid_580330 = query.getOrDefault("userIp")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "userIp", valid_580330
  var valid_580331 = query.getOrDefault("quotaUser")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "quotaUser", valid_580331
  var valid_580332 = query.getOrDefault("fields")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = nil)
  if valid_580332 != nil:
    section.add "fields", valid_580332
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580333: Call_ContentProductsGet_580321; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a product from your Merchant Center account.
  ## 
  let valid = call_580333.validator(path, query, header, formData, body)
  let scheme = call_580333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580333.url(scheme.get, call_580333.host, call_580333.base,
                         call_580333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580333, url, valid)

proc call*(call_580334: Call_ContentProductsGet_580321; merchantId: string;
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
  var path_580335 = newJObject()
  var query_580336 = newJObject()
  add(query_580336, "key", newJString(key))
  add(query_580336, "prettyPrint", newJBool(prettyPrint))
  add(query_580336, "oauth_token", newJString(oauthToken))
  add(query_580336, "alt", newJString(alt))
  add(query_580336, "userIp", newJString(userIp))
  add(query_580336, "quotaUser", newJString(quotaUser))
  add(path_580335, "merchantId", newJString(merchantId))
  add(query_580336, "fields", newJString(fields))
  add(path_580335, "productId", newJString(productId))
  result = call_580334.call(path_580335, query_580336, nil, nil, nil)

var contentProductsGet* = Call_ContentProductsGet_580321(
    name: "contentProductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/products/{productId}",
    validator: validate_ContentProductsGet_580322, base: "/content/v2",
    url: url_ContentProductsGet_580323, schemes: {Scheme.Https})
type
  Call_ContentProductsDelete_580337 = ref object of OpenApiRestCall_578348
proc url_ContentProductsDelete_580339(protocol: Scheme; host: string; base: string;
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

proc validate_ContentProductsDelete_580338(path: JsonNode; query: JsonNode;
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
  var valid_580340 = path.getOrDefault("merchantId")
  valid_580340 = validateParameter(valid_580340, JString, required = true,
                                 default = nil)
  if valid_580340 != nil:
    section.add "merchantId", valid_580340
  var valid_580341 = path.getOrDefault("productId")
  valid_580341 = validateParameter(valid_580341, JString, required = true,
                                 default = nil)
  if valid_580341 != nil:
    section.add "productId", valid_580341
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
  var valid_580342 = query.getOrDefault("key")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "key", valid_580342
  var valid_580343 = query.getOrDefault("prettyPrint")
  valid_580343 = validateParameter(valid_580343, JBool, required = false,
                                 default = newJBool(true))
  if valid_580343 != nil:
    section.add "prettyPrint", valid_580343
  var valid_580344 = query.getOrDefault("oauth_token")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "oauth_token", valid_580344
  var valid_580345 = query.getOrDefault("alt")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = newJString("json"))
  if valid_580345 != nil:
    section.add "alt", valid_580345
  var valid_580346 = query.getOrDefault("userIp")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = nil)
  if valid_580346 != nil:
    section.add "userIp", valid_580346
  var valid_580347 = query.getOrDefault("quotaUser")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = nil)
  if valid_580347 != nil:
    section.add "quotaUser", valid_580347
  var valid_580348 = query.getOrDefault("dryRun")
  valid_580348 = validateParameter(valid_580348, JBool, required = false, default = nil)
  if valid_580348 != nil:
    section.add "dryRun", valid_580348
  var valid_580349 = query.getOrDefault("fields")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "fields", valid_580349
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580350: Call_ContentProductsDelete_580337; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a product from your Merchant Center account.
  ## 
  let valid = call_580350.validator(path, query, header, formData, body)
  let scheme = call_580350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580350.url(scheme.get, call_580350.host, call_580350.base,
                         call_580350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580350, url, valid)

proc call*(call_580351: Call_ContentProductsDelete_580337; merchantId: string;
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
  var path_580352 = newJObject()
  var query_580353 = newJObject()
  add(query_580353, "key", newJString(key))
  add(query_580353, "prettyPrint", newJBool(prettyPrint))
  add(query_580353, "oauth_token", newJString(oauthToken))
  add(query_580353, "alt", newJString(alt))
  add(query_580353, "userIp", newJString(userIp))
  add(query_580353, "quotaUser", newJString(quotaUser))
  add(path_580352, "merchantId", newJString(merchantId))
  add(query_580353, "dryRun", newJBool(dryRun))
  add(query_580353, "fields", newJString(fields))
  add(path_580352, "productId", newJString(productId))
  result = call_580351.call(path_580352, query_580353, nil, nil, nil)

var contentProductsDelete* = Call_ContentProductsDelete_580337(
    name: "contentProductsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/products/{productId}",
    validator: validate_ContentProductsDelete_580338, base: "/content/v2",
    url: url_ContentProductsDelete_580339, schemes: {Scheme.Https})
type
  Call_ContentProductstatusesList_580354 = ref object of OpenApiRestCall_578348
proc url_ContentProductstatusesList_580356(protocol: Scheme; host: string;
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

proc validate_ContentProductstatusesList_580355(path: JsonNode; query: JsonNode;
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
  var valid_580364 = query.getOrDefault("pageToken")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "pageToken", valid_580364
  var valid_580365 = query.getOrDefault("destinations")
  valid_580365 = validateParameter(valid_580365, JArray, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "destinations", valid_580365
  var valid_580366 = query.getOrDefault("includeAttributes")
  valid_580366 = validateParameter(valid_580366, JBool, required = false, default = nil)
  if valid_580366 != nil:
    section.add "includeAttributes", valid_580366
  var valid_580367 = query.getOrDefault("fields")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "fields", valid_580367
  var valid_580368 = query.getOrDefault("includeInvalidInsertedItems")
  valid_580368 = validateParameter(valid_580368, JBool, required = false, default = nil)
  if valid_580368 != nil:
    section.add "includeInvalidInsertedItems", valid_580368
  var valid_580369 = query.getOrDefault("maxResults")
  valid_580369 = validateParameter(valid_580369, JInt, required = false, default = nil)
  if valid_580369 != nil:
    section.add "maxResults", valid_580369
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580370: Call_ContentProductstatusesList_580354; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the products in your Merchant Center account.
  ## 
  let valid = call_580370.validator(path, query, header, formData, body)
  let scheme = call_580370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580370.url(scheme.get, call_580370.host, call_580370.base,
                         call_580370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580370, url, valid)

proc call*(call_580371: Call_ContentProductstatusesList_580354; merchantId: string;
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
  var path_580372 = newJObject()
  var query_580373 = newJObject()
  add(query_580373, "key", newJString(key))
  add(query_580373, "prettyPrint", newJBool(prettyPrint))
  add(query_580373, "oauth_token", newJString(oauthToken))
  add(query_580373, "alt", newJString(alt))
  add(query_580373, "userIp", newJString(userIp))
  add(query_580373, "quotaUser", newJString(quotaUser))
  add(path_580372, "merchantId", newJString(merchantId))
  add(query_580373, "pageToken", newJString(pageToken))
  if destinations != nil:
    query_580373.add "destinations", destinations
  add(query_580373, "includeAttributes", newJBool(includeAttributes))
  add(query_580373, "fields", newJString(fields))
  add(query_580373, "includeInvalidInsertedItems",
      newJBool(includeInvalidInsertedItems))
  add(query_580373, "maxResults", newJInt(maxResults))
  result = call_580371.call(path_580372, query_580373, nil, nil, nil)

var contentProductstatusesList* = Call_ContentProductstatusesList_580354(
    name: "contentProductstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/productstatuses",
    validator: validate_ContentProductstatusesList_580355, base: "/content/v2",
    url: url_ContentProductstatusesList_580356, schemes: {Scheme.Https})
type
  Call_ContentProductstatusesGet_580374 = ref object of OpenApiRestCall_578348
proc url_ContentProductstatusesGet_580376(protocol: Scheme; host: string;
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

proc validate_ContentProductstatusesGet_580375(path: JsonNode; query: JsonNode;
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
  var valid_580377 = path.getOrDefault("merchantId")
  valid_580377 = validateParameter(valid_580377, JString, required = true,
                                 default = nil)
  if valid_580377 != nil:
    section.add "merchantId", valid_580377
  var valid_580378 = path.getOrDefault("productId")
  valid_580378 = validateParameter(valid_580378, JString, required = true,
                                 default = nil)
  if valid_580378 != nil:
    section.add "productId", valid_580378
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
  var valid_580385 = query.getOrDefault("destinations")
  valid_580385 = validateParameter(valid_580385, JArray, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "destinations", valid_580385
  var valid_580386 = query.getOrDefault("includeAttributes")
  valid_580386 = validateParameter(valid_580386, JBool, required = false, default = nil)
  if valid_580386 != nil:
    section.add "includeAttributes", valid_580386
  var valid_580387 = query.getOrDefault("fields")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "fields", valid_580387
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580388: Call_ContentProductstatusesGet_580374; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the status of a product from your Merchant Center account.
  ## 
  let valid = call_580388.validator(path, query, header, formData, body)
  let scheme = call_580388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580388.url(scheme.get, call_580388.host, call_580388.base,
                         call_580388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580388, url, valid)

proc call*(call_580389: Call_ContentProductstatusesGet_580374; merchantId: string;
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
  var path_580390 = newJObject()
  var query_580391 = newJObject()
  add(query_580391, "key", newJString(key))
  add(query_580391, "prettyPrint", newJBool(prettyPrint))
  add(query_580391, "oauth_token", newJString(oauthToken))
  add(query_580391, "alt", newJString(alt))
  add(query_580391, "userIp", newJString(userIp))
  add(query_580391, "quotaUser", newJString(quotaUser))
  add(path_580390, "merchantId", newJString(merchantId))
  if destinations != nil:
    query_580391.add "destinations", destinations
  add(query_580391, "includeAttributes", newJBool(includeAttributes))
  add(query_580391, "fields", newJString(fields))
  add(path_580390, "productId", newJString(productId))
  result = call_580389.call(path_580390, query_580391, nil, nil, nil)

var contentProductstatusesGet* = Call_ContentProductstatusesGet_580374(
    name: "contentProductstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/productstatuses/{productId}",
    validator: validate_ContentProductstatusesGet_580375, base: "/content/v2",
    url: url_ContentProductstatusesGet_580376, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsList_580392 = ref object of OpenApiRestCall_578348
proc url_ContentShippingsettingsList_580394(protocol: Scheme; host: string;
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

proc validate_ContentShippingsettingsList_580393(path: JsonNode; query: JsonNode;
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
  var valid_580395 = path.getOrDefault("merchantId")
  valid_580395 = validateParameter(valid_580395, JString, required = true,
                                 default = nil)
  if valid_580395 != nil:
    section.add "merchantId", valid_580395
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
  var valid_580396 = query.getOrDefault("key")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = nil)
  if valid_580396 != nil:
    section.add "key", valid_580396
  var valid_580397 = query.getOrDefault("prettyPrint")
  valid_580397 = validateParameter(valid_580397, JBool, required = false,
                                 default = newJBool(true))
  if valid_580397 != nil:
    section.add "prettyPrint", valid_580397
  var valid_580398 = query.getOrDefault("oauth_token")
  valid_580398 = validateParameter(valid_580398, JString, required = false,
                                 default = nil)
  if valid_580398 != nil:
    section.add "oauth_token", valid_580398
  var valid_580399 = query.getOrDefault("alt")
  valid_580399 = validateParameter(valid_580399, JString, required = false,
                                 default = newJString("json"))
  if valid_580399 != nil:
    section.add "alt", valid_580399
  var valid_580400 = query.getOrDefault("userIp")
  valid_580400 = validateParameter(valid_580400, JString, required = false,
                                 default = nil)
  if valid_580400 != nil:
    section.add "userIp", valid_580400
  var valid_580401 = query.getOrDefault("quotaUser")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "quotaUser", valid_580401
  var valid_580402 = query.getOrDefault("pageToken")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "pageToken", valid_580402
  var valid_580403 = query.getOrDefault("fields")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "fields", valid_580403
  var valid_580404 = query.getOrDefault("maxResults")
  valid_580404 = validateParameter(valid_580404, JInt, required = false, default = nil)
  if valid_580404 != nil:
    section.add "maxResults", valid_580404
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580405: Call_ContentShippingsettingsList_580392; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the shipping settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_580405.validator(path, query, header, formData, body)
  let scheme = call_580405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580405.url(scheme.get, call_580405.host, call_580405.base,
                         call_580405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580405, url, valid)

proc call*(call_580406: Call_ContentShippingsettingsList_580392;
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
  var path_580407 = newJObject()
  var query_580408 = newJObject()
  add(query_580408, "key", newJString(key))
  add(query_580408, "prettyPrint", newJBool(prettyPrint))
  add(query_580408, "oauth_token", newJString(oauthToken))
  add(query_580408, "alt", newJString(alt))
  add(query_580408, "userIp", newJString(userIp))
  add(query_580408, "quotaUser", newJString(quotaUser))
  add(path_580407, "merchantId", newJString(merchantId))
  add(query_580408, "pageToken", newJString(pageToken))
  add(query_580408, "fields", newJString(fields))
  add(query_580408, "maxResults", newJInt(maxResults))
  result = call_580406.call(path_580407, query_580408, nil, nil, nil)

var contentShippingsettingsList* = Call_ContentShippingsettingsList_580392(
    name: "contentShippingsettingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/shippingsettings",
    validator: validate_ContentShippingsettingsList_580393, base: "/content/v2",
    url: url_ContentShippingsettingsList_580394, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsUpdate_580425 = ref object of OpenApiRestCall_578348
proc url_ContentShippingsettingsUpdate_580427(protocol: Scheme; host: string;
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

proc validate_ContentShippingsettingsUpdate_580426(path: JsonNode; query: JsonNode;
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
  var valid_580428 = path.getOrDefault("merchantId")
  valid_580428 = validateParameter(valid_580428, JString, required = true,
                                 default = nil)
  if valid_580428 != nil:
    section.add "merchantId", valid_580428
  var valid_580429 = path.getOrDefault("accountId")
  valid_580429 = validateParameter(valid_580429, JString, required = true,
                                 default = nil)
  if valid_580429 != nil:
    section.add "accountId", valid_580429
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
  var valid_580432 = query.getOrDefault("oauth_token")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "oauth_token", valid_580432
  var valid_580433 = query.getOrDefault("alt")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = newJString("json"))
  if valid_580433 != nil:
    section.add "alt", valid_580433
  var valid_580434 = query.getOrDefault("userIp")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = nil)
  if valid_580434 != nil:
    section.add "userIp", valid_580434
  var valid_580435 = query.getOrDefault("quotaUser")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "quotaUser", valid_580435
  var valid_580436 = query.getOrDefault("dryRun")
  valid_580436 = validateParameter(valid_580436, JBool, required = false, default = nil)
  if valid_580436 != nil:
    section.add "dryRun", valid_580436
  var valid_580437 = query.getOrDefault("fields")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = nil)
  if valid_580437 != nil:
    section.add "fields", valid_580437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580439: Call_ContentShippingsettingsUpdate_580425; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the shipping settings of the account.
  ## 
  let valid = call_580439.validator(path, query, header, formData, body)
  let scheme = call_580439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580439.url(scheme.get, call_580439.host, call_580439.base,
                         call_580439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580439, url, valid)

proc call*(call_580440: Call_ContentShippingsettingsUpdate_580425;
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
  var path_580441 = newJObject()
  var query_580442 = newJObject()
  var body_580443 = newJObject()
  add(query_580442, "key", newJString(key))
  add(query_580442, "prettyPrint", newJBool(prettyPrint))
  add(query_580442, "oauth_token", newJString(oauthToken))
  add(query_580442, "alt", newJString(alt))
  add(query_580442, "userIp", newJString(userIp))
  add(query_580442, "quotaUser", newJString(quotaUser))
  add(path_580441, "merchantId", newJString(merchantId))
  add(query_580442, "dryRun", newJBool(dryRun))
  if body != nil:
    body_580443 = body
  add(path_580441, "accountId", newJString(accountId))
  add(query_580442, "fields", newJString(fields))
  result = call_580440.call(path_580441, query_580442, nil, nil, body_580443)

var contentShippingsettingsUpdate* = Call_ContentShippingsettingsUpdate_580425(
    name: "contentShippingsettingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{merchantId}/shippingsettings/{accountId}",
    validator: validate_ContentShippingsettingsUpdate_580426, base: "/content/v2",
    url: url_ContentShippingsettingsUpdate_580427, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGet_580409 = ref object of OpenApiRestCall_578348
proc url_ContentShippingsettingsGet_580411(protocol: Scheme; host: string;
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

proc validate_ContentShippingsettingsGet_580410(path: JsonNode; query: JsonNode;
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
  var valid_580412 = path.getOrDefault("merchantId")
  valid_580412 = validateParameter(valid_580412, JString, required = true,
                                 default = nil)
  if valid_580412 != nil:
    section.add "merchantId", valid_580412
  var valid_580413 = path.getOrDefault("accountId")
  valid_580413 = validateParameter(valid_580413, JString, required = true,
                                 default = nil)
  if valid_580413 != nil:
    section.add "accountId", valid_580413
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
  var valid_580414 = query.getOrDefault("key")
  valid_580414 = validateParameter(valid_580414, JString, required = false,
                                 default = nil)
  if valid_580414 != nil:
    section.add "key", valid_580414
  var valid_580415 = query.getOrDefault("prettyPrint")
  valid_580415 = validateParameter(valid_580415, JBool, required = false,
                                 default = newJBool(true))
  if valid_580415 != nil:
    section.add "prettyPrint", valid_580415
  var valid_580416 = query.getOrDefault("oauth_token")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = nil)
  if valid_580416 != nil:
    section.add "oauth_token", valid_580416
  var valid_580417 = query.getOrDefault("alt")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = newJString("json"))
  if valid_580417 != nil:
    section.add "alt", valid_580417
  var valid_580418 = query.getOrDefault("userIp")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = nil)
  if valid_580418 != nil:
    section.add "userIp", valid_580418
  var valid_580419 = query.getOrDefault("quotaUser")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = nil)
  if valid_580419 != nil:
    section.add "quotaUser", valid_580419
  var valid_580420 = query.getOrDefault("fields")
  valid_580420 = validateParameter(valid_580420, JString, required = false,
                                 default = nil)
  if valid_580420 != nil:
    section.add "fields", valid_580420
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580421: Call_ContentShippingsettingsGet_580409; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the shipping settings of the account.
  ## 
  let valid = call_580421.validator(path, query, header, formData, body)
  let scheme = call_580421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580421.url(scheme.get, call_580421.host, call_580421.base,
                         call_580421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580421, url, valid)

proc call*(call_580422: Call_ContentShippingsettingsGet_580409; merchantId: string;
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
  var path_580423 = newJObject()
  var query_580424 = newJObject()
  add(query_580424, "key", newJString(key))
  add(query_580424, "prettyPrint", newJBool(prettyPrint))
  add(query_580424, "oauth_token", newJString(oauthToken))
  add(query_580424, "alt", newJString(alt))
  add(query_580424, "userIp", newJString(userIp))
  add(query_580424, "quotaUser", newJString(quotaUser))
  add(path_580423, "merchantId", newJString(merchantId))
  add(path_580423, "accountId", newJString(accountId))
  add(query_580424, "fields", newJString(fields))
  result = call_580422.call(path_580423, query_580424, nil, nil, nil)

var contentShippingsettingsGet* = Call_ContentShippingsettingsGet_580409(
    name: "contentShippingsettingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/shippingsettings/{accountId}",
    validator: validate_ContentShippingsettingsGet_580410, base: "/content/v2",
    url: url_ContentShippingsettingsGet_580411, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsPatch_580444 = ref object of OpenApiRestCall_578348
proc url_ContentShippingsettingsPatch_580446(protocol: Scheme; host: string;
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

proc validate_ContentShippingsettingsPatch_580445(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the shipping settings of the account. This method supports patch semantics.
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
  var valid_580447 = path.getOrDefault("merchantId")
  valid_580447 = validateParameter(valid_580447, JString, required = true,
                                 default = nil)
  if valid_580447 != nil:
    section.add "merchantId", valid_580447
  var valid_580448 = path.getOrDefault("accountId")
  valid_580448 = validateParameter(valid_580448, JString, required = true,
                                 default = nil)
  if valid_580448 != nil:
    section.add "accountId", valid_580448
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
  var valid_580449 = query.getOrDefault("key")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "key", valid_580449
  var valid_580450 = query.getOrDefault("prettyPrint")
  valid_580450 = validateParameter(valid_580450, JBool, required = false,
                                 default = newJBool(true))
  if valid_580450 != nil:
    section.add "prettyPrint", valid_580450
  var valid_580451 = query.getOrDefault("oauth_token")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = nil)
  if valid_580451 != nil:
    section.add "oauth_token", valid_580451
  var valid_580452 = query.getOrDefault("alt")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = newJString("json"))
  if valid_580452 != nil:
    section.add "alt", valid_580452
  var valid_580453 = query.getOrDefault("userIp")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "userIp", valid_580453
  var valid_580454 = query.getOrDefault("quotaUser")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = nil)
  if valid_580454 != nil:
    section.add "quotaUser", valid_580454
  var valid_580455 = query.getOrDefault("dryRun")
  valid_580455 = validateParameter(valid_580455, JBool, required = false, default = nil)
  if valid_580455 != nil:
    section.add "dryRun", valid_580455
  var valid_580456 = query.getOrDefault("fields")
  valid_580456 = validateParameter(valid_580456, JString, required = false,
                                 default = nil)
  if valid_580456 != nil:
    section.add "fields", valid_580456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580458: Call_ContentShippingsettingsPatch_580444; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the shipping settings of the account. This method supports patch semantics.
  ## 
  let valid = call_580458.validator(path, query, header, formData, body)
  let scheme = call_580458.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580458.url(scheme.get, call_580458.host, call_580458.base,
                         call_580458.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580458, url, valid)

proc call*(call_580459: Call_ContentShippingsettingsPatch_580444;
          merchantId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; dryRun: bool = false;
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## contentShippingsettingsPatch
  ## Updates the shipping settings of the account. This method supports patch semantics.
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
  var path_580460 = newJObject()
  var query_580461 = newJObject()
  var body_580462 = newJObject()
  add(query_580461, "key", newJString(key))
  add(query_580461, "prettyPrint", newJBool(prettyPrint))
  add(query_580461, "oauth_token", newJString(oauthToken))
  add(query_580461, "alt", newJString(alt))
  add(query_580461, "userIp", newJString(userIp))
  add(query_580461, "quotaUser", newJString(quotaUser))
  add(path_580460, "merchantId", newJString(merchantId))
  add(query_580461, "dryRun", newJBool(dryRun))
  if body != nil:
    body_580462 = body
  add(path_580460, "accountId", newJString(accountId))
  add(query_580461, "fields", newJString(fields))
  result = call_580459.call(path_580460, query_580461, nil, nil, body_580462)

var contentShippingsettingsPatch* = Call_ContentShippingsettingsPatch_580444(
    name: "contentShippingsettingsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{merchantId}/shippingsettings/{accountId}",
    validator: validate_ContentShippingsettingsPatch_580445, base: "/content/v2",
    url: url_ContentShippingsettingsPatch_580446, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGetsupportedcarriers_580463 = ref object of OpenApiRestCall_578348
proc url_ContentShippingsettingsGetsupportedcarriers_580465(protocol: Scheme;
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

proc validate_ContentShippingsettingsGetsupportedcarriers_580464(path: JsonNode;
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
  var valid_580466 = path.getOrDefault("merchantId")
  valid_580466 = validateParameter(valid_580466, JString, required = true,
                                 default = nil)
  if valid_580466 != nil:
    section.add "merchantId", valid_580466
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
  var valid_580467 = query.getOrDefault("key")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = nil)
  if valid_580467 != nil:
    section.add "key", valid_580467
  var valid_580468 = query.getOrDefault("prettyPrint")
  valid_580468 = validateParameter(valid_580468, JBool, required = false,
                                 default = newJBool(true))
  if valid_580468 != nil:
    section.add "prettyPrint", valid_580468
  var valid_580469 = query.getOrDefault("oauth_token")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = nil)
  if valid_580469 != nil:
    section.add "oauth_token", valid_580469
  var valid_580470 = query.getOrDefault("alt")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = newJString("json"))
  if valid_580470 != nil:
    section.add "alt", valid_580470
  var valid_580471 = query.getOrDefault("userIp")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = nil)
  if valid_580471 != nil:
    section.add "userIp", valid_580471
  var valid_580472 = query.getOrDefault("quotaUser")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = nil)
  if valid_580472 != nil:
    section.add "quotaUser", valid_580472
  var valid_580473 = query.getOrDefault("fields")
  valid_580473 = validateParameter(valid_580473, JString, required = false,
                                 default = nil)
  if valid_580473 != nil:
    section.add "fields", valid_580473
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580474: Call_ContentShippingsettingsGetsupportedcarriers_580463;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves supported carriers and carrier services for an account.
  ## 
  let valid = call_580474.validator(path, query, header, formData, body)
  let scheme = call_580474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580474.url(scheme.get, call_580474.host, call_580474.base,
                         call_580474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580474, url, valid)

proc call*(call_580475: Call_ContentShippingsettingsGetsupportedcarriers_580463;
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
  var path_580476 = newJObject()
  var query_580477 = newJObject()
  add(query_580477, "key", newJString(key))
  add(query_580477, "prettyPrint", newJBool(prettyPrint))
  add(query_580477, "oauth_token", newJString(oauthToken))
  add(query_580477, "alt", newJString(alt))
  add(query_580477, "userIp", newJString(userIp))
  add(query_580477, "quotaUser", newJString(quotaUser))
  add(path_580476, "merchantId", newJString(merchantId))
  add(query_580477, "fields", newJString(fields))
  result = call_580475.call(path_580476, query_580477, nil, nil, nil)

var contentShippingsettingsGetsupportedcarriers* = Call_ContentShippingsettingsGetsupportedcarriers_580463(
    name: "contentShippingsettingsGetsupportedcarriers", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/supportedCarriers",
    validator: validate_ContentShippingsettingsGetsupportedcarriers_580464,
    base: "/content/v2", url: url_ContentShippingsettingsGetsupportedcarriers_580465,
    schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGetsupportedholidays_580478 = ref object of OpenApiRestCall_578348
proc url_ContentShippingsettingsGetsupportedholidays_580480(protocol: Scheme;
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

proc validate_ContentShippingsettingsGetsupportedholidays_580479(path: JsonNode;
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
  var valid_580481 = path.getOrDefault("merchantId")
  valid_580481 = validateParameter(valid_580481, JString, required = true,
                                 default = nil)
  if valid_580481 != nil:
    section.add "merchantId", valid_580481
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
  var valid_580488 = query.getOrDefault("fields")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "fields", valid_580488
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580489: Call_ContentShippingsettingsGetsupportedholidays_580478;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves supported holidays for an account.
  ## 
  let valid = call_580489.validator(path, query, header, formData, body)
  let scheme = call_580489.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580489.url(scheme.get, call_580489.host, call_580489.base,
                         call_580489.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580489, url, valid)

proc call*(call_580490: Call_ContentShippingsettingsGetsupportedholidays_580478;
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
  var path_580491 = newJObject()
  var query_580492 = newJObject()
  add(query_580492, "key", newJString(key))
  add(query_580492, "prettyPrint", newJBool(prettyPrint))
  add(query_580492, "oauth_token", newJString(oauthToken))
  add(query_580492, "alt", newJString(alt))
  add(query_580492, "userIp", newJString(userIp))
  add(query_580492, "quotaUser", newJString(quotaUser))
  add(path_580491, "merchantId", newJString(merchantId))
  add(query_580492, "fields", newJString(fields))
  result = call_580490.call(path_580491, query_580492, nil, nil, nil)

var contentShippingsettingsGetsupportedholidays* = Call_ContentShippingsettingsGetsupportedholidays_580478(
    name: "contentShippingsettingsGetsupportedholidays", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/supportedHolidays",
    validator: validate_ContentShippingsettingsGetsupportedholidays_580479,
    base: "/content/v2", url: url_ContentShippingsettingsGetsupportedholidays_580480,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersCreatetestorder_580493 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersCreatetestorder_580495(protocol: Scheme; host: string;
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

proc validate_ContentOrdersCreatetestorder_580494(path: JsonNode; query: JsonNode;
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
  var valid_580496 = path.getOrDefault("merchantId")
  valid_580496 = validateParameter(valid_580496, JString, required = true,
                                 default = nil)
  if valid_580496 != nil:
    section.add "merchantId", valid_580496
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580505: Call_ContentOrdersCreatetestorder_580493; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Creates a test order.
  ## 
  let valid = call_580505.validator(path, query, header, formData, body)
  let scheme = call_580505.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580505.url(scheme.get, call_580505.host, call_580505.base,
                         call_580505.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580505, url, valid)

proc call*(call_580506: Call_ContentOrdersCreatetestorder_580493;
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
  var path_580507 = newJObject()
  var query_580508 = newJObject()
  var body_580509 = newJObject()
  add(query_580508, "key", newJString(key))
  add(query_580508, "prettyPrint", newJBool(prettyPrint))
  add(query_580508, "oauth_token", newJString(oauthToken))
  add(query_580508, "alt", newJString(alt))
  add(query_580508, "userIp", newJString(userIp))
  add(query_580508, "quotaUser", newJString(quotaUser))
  add(path_580507, "merchantId", newJString(merchantId))
  if body != nil:
    body_580509 = body
  add(query_580508, "fields", newJString(fields))
  result = call_580506.call(path_580507, query_580508, nil, nil, body_580509)

var contentOrdersCreatetestorder* = Call_ContentOrdersCreatetestorder_580493(
    name: "contentOrdersCreatetestorder", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/testorders",
    validator: validate_ContentOrdersCreatetestorder_580494, base: "/content/v2",
    url: url_ContentOrdersCreatetestorder_580495, schemes: {Scheme.Https})
type
  Call_ContentOrdersAdvancetestorder_580510 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersAdvancetestorder_580512(protocol: Scheme; host: string;
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

proc validate_ContentOrdersAdvancetestorder_580511(path: JsonNode; query: JsonNode;
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
  var valid_580513 = path.getOrDefault("merchantId")
  valid_580513 = validateParameter(valid_580513, JString, required = true,
                                 default = nil)
  if valid_580513 != nil:
    section.add "merchantId", valid_580513
  var valid_580514 = path.getOrDefault("orderId")
  valid_580514 = validateParameter(valid_580514, JString, required = true,
                                 default = nil)
  if valid_580514 != nil:
    section.add "orderId", valid_580514
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
  var valid_580517 = query.getOrDefault("oauth_token")
  valid_580517 = validateParameter(valid_580517, JString, required = false,
                                 default = nil)
  if valid_580517 != nil:
    section.add "oauth_token", valid_580517
  var valid_580518 = query.getOrDefault("alt")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = newJString("json"))
  if valid_580518 != nil:
    section.add "alt", valid_580518
  var valid_580519 = query.getOrDefault("userIp")
  valid_580519 = validateParameter(valid_580519, JString, required = false,
                                 default = nil)
  if valid_580519 != nil:
    section.add "userIp", valid_580519
  var valid_580520 = query.getOrDefault("quotaUser")
  valid_580520 = validateParameter(valid_580520, JString, required = false,
                                 default = nil)
  if valid_580520 != nil:
    section.add "quotaUser", valid_580520
  var valid_580521 = query.getOrDefault("fields")
  valid_580521 = validateParameter(valid_580521, JString, required = false,
                                 default = nil)
  if valid_580521 != nil:
    section.add "fields", valid_580521
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580522: Call_ContentOrdersAdvancetestorder_580510; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Moves a test order from state "inProgress" to state "pendingShipment".
  ## 
  let valid = call_580522.validator(path, query, header, formData, body)
  let scheme = call_580522.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580522.url(scheme.get, call_580522.host, call_580522.base,
                         call_580522.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580522, url, valid)

proc call*(call_580523: Call_ContentOrdersAdvancetestorder_580510;
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
  var path_580524 = newJObject()
  var query_580525 = newJObject()
  add(query_580525, "key", newJString(key))
  add(query_580525, "prettyPrint", newJBool(prettyPrint))
  add(query_580525, "oauth_token", newJString(oauthToken))
  add(query_580525, "alt", newJString(alt))
  add(query_580525, "userIp", newJString(userIp))
  add(query_580525, "quotaUser", newJString(quotaUser))
  add(path_580524, "merchantId", newJString(merchantId))
  add(query_580525, "fields", newJString(fields))
  add(path_580524, "orderId", newJString(orderId))
  result = call_580523.call(path_580524, query_580525, nil, nil, nil)

var contentOrdersAdvancetestorder* = Call_ContentOrdersAdvancetestorder_580510(
    name: "contentOrdersAdvancetestorder", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/testorders/{orderId}/advance",
    validator: validate_ContentOrdersAdvancetestorder_580511, base: "/content/v2",
    url: url_ContentOrdersAdvancetestorder_580512, schemes: {Scheme.Https})
type
  Call_ContentOrdersCanceltestorderbycustomer_580526 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersCanceltestorderbycustomer_580528(protocol: Scheme;
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

proc validate_ContentOrdersCanceltestorderbycustomer_580527(path: JsonNode;
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
  var valid_580529 = path.getOrDefault("merchantId")
  valid_580529 = validateParameter(valid_580529, JString, required = true,
                                 default = nil)
  if valid_580529 != nil:
    section.add "merchantId", valid_580529
  var valid_580530 = path.getOrDefault("orderId")
  valid_580530 = validateParameter(valid_580530, JString, required = true,
                                 default = nil)
  if valid_580530 != nil:
    section.add "orderId", valid_580530
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580539: Call_ContentOrdersCanceltestorderbycustomer_580526;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sandbox only. Cancels a test order for customer-initiated cancellation.
  ## 
  let valid = call_580539.validator(path, query, header, formData, body)
  let scheme = call_580539.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580539.url(scheme.get, call_580539.host, call_580539.base,
                         call_580539.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580539, url, valid)

proc call*(call_580540: Call_ContentOrdersCanceltestorderbycustomer_580526;
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
  var path_580541 = newJObject()
  var query_580542 = newJObject()
  var body_580543 = newJObject()
  add(query_580542, "key", newJString(key))
  add(query_580542, "prettyPrint", newJBool(prettyPrint))
  add(query_580542, "oauth_token", newJString(oauthToken))
  add(query_580542, "alt", newJString(alt))
  add(query_580542, "userIp", newJString(userIp))
  add(query_580542, "quotaUser", newJString(quotaUser))
  add(path_580541, "merchantId", newJString(merchantId))
  if body != nil:
    body_580543 = body
  add(query_580542, "fields", newJString(fields))
  add(path_580541, "orderId", newJString(orderId))
  result = call_580540.call(path_580541, query_580542, nil, nil, body_580543)

var contentOrdersCanceltestorderbycustomer* = Call_ContentOrdersCanceltestorderbycustomer_580526(
    name: "contentOrdersCanceltestorderbycustomer", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/testorders/{orderId}/cancelByCustomer",
    validator: validate_ContentOrdersCanceltestorderbycustomer_580527,
    base: "/content/v2", url: url_ContentOrdersCanceltestorderbycustomer_580528,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersGettestordertemplate_580544 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersGettestordertemplate_580546(protocol: Scheme; host: string;
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

proc validate_ContentOrdersGettestordertemplate_580545(path: JsonNode;
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
  var valid_580547 = path.getOrDefault("merchantId")
  valid_580547 = validateParameter(valid_580547, JString, required = true,
                                 default = nil)
  if valid_580547 != nil:
    section.add "merchantId", valid_580547
  var valid_580548 = path.getOrDefault("templateName")
  valid_580548 = validateParameter(valid_580548, JString, required = true,
                                 default = newJString("template1"))
  if valid_580548 != nil:
    section.add "templateName", valid_580548
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
  var valid_580549 = query.getOrDefault("key")
  valid_580549 = validateParameter(valid_580549, JString, required = false,
                                 default = nil)
  if valid_580549 != nil:
    section.add "key", valid_580549
  var valid_580550 = query.getOrDefault("prettyPrint")
  valid_580550 = validateParameter(valid_580550, JBool, required = false,
                                 default = newJBool(true))
  if valid_580550 != nil:
    section.add "prettyPrint", valid_580550
  var valid_580551 = query.getOrDefault("oauth_token")
  valid_580551 = validateParameter(valid_580551, JString, required = false,
                                 default = nil)
  if valid_580551 != nil:
    section.add "oauth_token", valid_580551
  var valid_580552 = query.getOrDefault("alt")
  valid_580552 = validateParameter(valid_580552, JString, required = false,
                                 default = newJString("json"))
  if valid_580552 != nil:
    section.add "alt", valid_580552
  var valid_580553 = query.getOrDefault("userIp")
  valid_580553 = validateParameter(valid_580553, JString, required = false,
                                 default = nil)
  if valid_580553 != nil:
    section.add "userIp", valid_580553
  var valid_580554 = query.getOrDefault("quotaUser")
  valid_580554 = validateParameter(valid_580554, JString, required = false,
                                 default = nil)
  if valid_580554 != nil:
    section.add "quotaUser", valid_580554
  var valid_580555 = query.getOrDefault("country")
  valid_580555 = validateParameter(valid_580555, JString, required = false,
                                 default = nil)
  if valid_580555 != nil:
    section.add "country", valid_580555
  var valid_580556 = query.getOrDefault("fields")
  valid_580556 = validateParameter(valid_580556, JString, required = false,
                                 default = nil)
  if valid_580556 != nil:
    section.add "fields", valid_580556
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580557: Call_ContentOrdersGettestordertemplate_580544;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sandbox only. Retrieves an order template that can be used to quickly create a new order in sandbox.
  ## 
  let valid = call_580557.validator(path, query, header, formData, body)
  let scheme = call_580557.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580557.url(scheme.get, call_580557.host, call_580557.base,
                         call_580557.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580557, url, valid)

proc call*(call_580558: Call_ContentOrdersGettestordertemplate_580544;
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
  var path_580559 = newJObject()
  var query_580560 = newJObject()
  add(query_580560, "key", newJString(key))
  add(query_580560, "prettyPrint", newJBool(prettyPrint))
  add(query_580560, "oauth_token", newJString(oauthToken))
  add(query_580560, "alt", newJString(alt))
  add(query_580560, "userIp", newJString(userIp))
  add(query_580560, "quotaUser", newJString(quotaUser))
  add(path_580559, "merchantId", newJString(merchantId))
  add(query_580560, "country", newJString(country))
  add(path_580559, "templateName", newJString(templateName))
  add(query_580560, "fields", newJString(fields))
  result = call_580558.call(path_580559, query_580560, nil, nil, nil)

var contentOrdersGettestordertemplate* = Call_ContentOrdersGettestordertemplate_580544(
    name: "contentOrdersGettestordertemplate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/testordertemplates/{templateName}",
    validator: validate_ContentOrdersGettestordertemplate_580545,
    base: "/content/v2", url: url_ContentOrdersGettestordertemplate_580546,
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
