
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
  Call_ContentAccountsAuthinfo_578619 = ref object of OpenApiRestCall_578348
proc url_ContentAccountsAuthinfo_578621(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentAccountsAuthinfo_578620(path: JsonNode; query: JsonNode;
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
  var valid_578733 = query.getOrDefault("key")
  valid_578733 = validateParameter(valid_578733, JString, required = false,
                                 default = nil)
  if valid_578733 != nil:
    section.add "key", valid_578733
  var valid_578747 = query.getOrDefault("prettyPrint")
  valid_578747 = validateParameter(valid_578747, JBool, required = false,
                                 default = newJBool(true))
  if valid_578747 != nil:
    section.add "prettyPrint", valid_578747
  var valid_578748 = query.getOrDefault("oauth_token")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "oauth_token", valid_578748
  var valid_578749 = query.getOrDefault("alt")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = newJString("json"))
  if valid_578749 != nil:
    section.add "alt", valid_578749
  var valid_578750 = query.getOrDefault("userIp")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = nil)
  if valid_578750 != nil:
    section.add "userIp", valid_578750
  var valid_578751 = query.getOrDefault("quotaUser")
  valid_578751 = validateParameter(valid_578751, JString, required = false,
                                 default = nil)
  if valid_578751 != nil:
    section.add "quotaUser", valid_578751
  var valid_578752 = query.getOrDefault("fields")
  valid_578752 = validateParameter(valid_578752, JString, required = false,
                                 default = nil)
  if valid_578752 != nil:
    section.add "fields", valid_578752
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578775: Call_ContentAccountsAuthinfo_578619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about the authenticated user.
  ## 
  let valid = call_578775.validator(path, query, header, formData, body)
  let scheme = call_578775.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578775.url(scheme.get, call_578775.host, call_578775.base,
                         call_578775.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578775, url, valid)

proc call*(call_578846: Call_ContentAccountsAuthinfo_578619; key: string = "";
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
  var query_578847 = newJObject()
  add(query_578847, "key", newJString(key))
  add(query_578847, "prettyPrint", newJBool(prettyPrint))
  add(query_578847, "oauth_token", newJString(oauthToken))
  add(query_578847, "alt", newJString(alt))
  add(query_578847, "userIp", newJString(userIp))
  add(query_578847, "quotaUser", newJString(quotaUser))
  add(query_578847, "fields", newJString(fields))
  result = call_578846.call(nil, query_578847, nil, nil, nil)

var contentAccountsAuthinfo* = Call_ContentAccountsAuthinfo_578619(
    name: "contentAccountsAuthinfo", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/authinfo",
    validator: validate_ContentAccountsAuthinfo_578620, base: "/content/v2.1",
    url: url_ContentAccountsAuthinfo_578621, schemes: {Scheme.Https})
type
  Call_ContentAccountsCustombatch_578887 = ref object of OpenApiRestCall_578348
proc url_ContentAccountsCustombatch_578889(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentAccountsCustombatch_578888(path: JsonNode; query: JsonNode;
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
  var valid_578890 = query.getOrDefault("key")
  valid_578890 = validateParameter(valid_578890, JString, required = false,
                                 default = nil)
  if valid_578890 != nil:
    section.add "key", valid_578890
  var valid_578891 = query.getOrDefault("prettyPrint")
  valid_578891 = validateParameter(valid_578891, JBool, required = false,
                                 default = newJBool(true))
  if valid_578891 != nil:
    section.add "prettyPrint", valid_578891
  var valid_578892 = query.getOrDefault("oauth_token")
  valid_578892 = validateParameter(valid_578892, JString, required = false,
                                 default = nil)
  if valid_578892 != nil:
    section.add "oauth_token", valid_578892
  var valid_578893 = query.getOrDefault("alt")
  valid_578893 = validateParameter(valid_578893, JString, required = false,
                                 default = newJString("json"))
  if valid_578893 != nil:
    section.add "alt", valid_578893
  var valid_578894 = query.getOrDefault("userIp")
  valid_578894 = validateParameter(valid_578894, JString, required = false,
                                 default = nil)
  if valid_578894 != nil:
    section.add "userIp", valid_578894
  var valid_578895 = query.getOrDefault("quotaUser")
  valid_578895 = validateParameter(valid_578895, JString, required = false,
                                 default = nil)
  if valid_578895 != nil:
    section.add "quotaUser", valid_578895
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

proc call*(call_578898: Call_ContentAccountsCustombatch_578887; path: JsonNode;
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

proc call*(call_578899: Call_ContentAccountsCustombatch_578887; key: string = "";
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
  var query_578900 = newJObject()
  var body_578901 = newJObject()
  add(query_578900, "key", newJString(key))
  add(query_578900, "prettyPrint", newJBool(prettyPrint))
  add(query_578900, "oauth_token", newJString(oauthToken))
  add(query_578900, "alt", newJString(alt))
  add(query_578900, "userIp", newJString(userIp))
  add(query_578900, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578901 = body
  add(query_578900, "fields", newJString(fields))
  result = call_578899.call(nil, query_578900, nil, nil, body_578901)

var contentAccountsCustombatch* = Call_ContentAccountsCustombatch_578887(
    name: "contentAccountsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accounts/batch",
    validator: validate_ContentAccountsCustombatch_578888, base: "/content/v2.1",
    url: url_ContentAccountsCustombatch_578889, schemes: {Scheme.Https})
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
    base: "/content/v2.1", url: url_ContentAccountstatusesCustombatch_578904,
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
  var valid_578926 = query.getOrDefault("fields")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "fields", valid_578926
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578928: Call_ContentAccounttaxCustombatch_578917; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves and updates tax settings of multiple accounts in a single request.
  ## 
  let valid = call_578928.validator(path, query, header, formData, body)
  let scheme = call_578928.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578928.url(scheme.get, call_578928.host, call_578928.base,
                         call_578928.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578928, url, valid)

proc call*(call_578929: Call_ContentAccounttaxCustombatch_578917; key: string = "";
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
  var query_578930 = newJObject()
  var body_578931 = newJObject()
  add(query_578930, "key", newJString(key))
  add(query_578930, "prettyPrint", newJBool(prettyPrint))
  add(query_578930, "oauth_token", newJString(oauthToken))
  add(query_578930, "alt", newJString(alt))
  add(query_578930, "userIp", newJString(userIp))
  add(query_578930, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578931 = body
  add(query_578930, "fields", newJString(fields))
  result = call_578929.call(nil, query_578930, nil, nil, body_578931)

var contentAccounttaxCustombatch* = Call_ContentAccounttaxCustombatch_578917(
    name: "contentAccounttaxCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/accounttax/batch",
    validator: validate_ContentAccounttaxCustombatch_578918,
    base: "/content/v2.1", url: url_ContentAccounttaxCustombatch_578919,
    schemes: {Scheme.Https})
type
  Call_ContentDatafeedsCustombatch_578932 = ref object of OpenApiRestCall_578348
proc url_ContentDatafeedsCustombatch_578934(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentDatafeedsCustombatch_578933(path: JsonNode; query: JsonNode;
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
  var valid_578935 = query.getOrDefault("key")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "key", valid_578935
  var valid_578936 = query.getOrDefault("prettyPrint")
  valid_578936 = validateParameter(valid_578936, JBool, required = false,
                                 default = newJBool(true))
  if valid_578936 != nil:
    section.add "prettyPrint", valid_578936
  var valid_578937 = query.getOrDefault("oauth_token")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "oauth_token", valid_578937
  var valid_578938 = query.getOrDefault("alt")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = newJString("json"))
  if valid_578938 != nil:
    section.add "alt", valid_578938
  var valid_578939 = query.getOrDefault("userIp")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "userIp", valid_578939
  var valid_578940 = query.getOrDefault("quotaUser")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "quotaUser", valid_578940
  var valid_578941 = query.getOrDefault("fields")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "fields", valid_578941
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578943: Call_ContentDatafeedsCustombatch_578932; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes, fetches, gets, inserts and updates multiple datafeeds in a single request.
  ## 
  let valid = call_578943.validator(path, query, header, formData, body)
  let scheme = call_578943.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578943.url(scheme.get, call_578943.host, call_578943.base,
                         call_578943.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578943, url, valid)

proc call*(call_578944: Call_ContentDatafeedsCustombatch_578932; key: string = "";
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
  var query_578945 = newJObject()
  var body_578946 = newJObject()
  add(query_578945, "key", newJString(key))
  add(query_578945, "prettyPrint", newJBool(prettyPrint))
  add(query_578945, "oauth_token", newJString(oauthToken))
  add(query_578945, "alt", newJString(alt))
  add(query_578945, "userIp", newJString(userIp))
  add(query_578945, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578946 = body
  add(query_578945, "fields", newJString(fields))
  result = call_578944.call(nil, query_578945, nil, nil, body_578946)

var contentDatafeedsCustombatch* = Call_ContentDatafeedsCustombatch_578932(
    name: "contentDatafeedsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/datafeeds/batch",
    validator: validate_ContentDatafeedsCustombatch_578933, base: "/content/v2.1",
    url: url_ContentDatafeedsCustombatch_578934, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesCustombatch_578947 = ref object of OpenApiRestCall_578348
proc url_ContentDatafeedstatusesCustombatch_578949(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentDatafeedstatusesCustombatch_578948(path: JsonNode;
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
  var valid_578950 = query.getOrDefault("key")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "key", valid_578950
  var valid_578951 = query.getOrDefault("prettyPrint")
  valid_578951 = validateParameter(valid_578951, JBool, required = false,
                                 default = newJBool(true))
  if valid_578951 != nil:
    section.add "prettyPrint", valid_578951
  var valid_578952 = query.getOrDefault("oauth_token")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "oauth_token", valid_578952
  var valid_578953 = query.getOrDefault("alt")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = newJString("json"))
  if valid_578953 != nil:
    section.add "alt", valid_578953
  var valid_578954 = query.getOrDefault("userIp")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "userIp", valid_578954
  var valid_578955 = query.getOrDefault("quotaUser")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "quotaUser", valid_578955
  var valid_578956 = query.getOrDefault("fields")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "fields", valid_578956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578958: Call_ContentDatafeedstatusesCustombatch_578947;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets multiple Merchant Center datafeed statuses in a single request.
  ## 
  let valid = call_578958.validator(path, query, header, formData, body)
  let scheme = call_578958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578958.url(scheme.get, call_578958.host, call_578958.base,
                         call_578958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578958, url, valid)

proc call*(call_578959: Call_ContentDatafeedstatusesCustombatch_578947;
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
  var query_578960 = newJObject()
  var body_578961 = newJObject()
  add(query_578960, "key", newJString(key))
  add(query_578960, "prettyPrint", newJBool(prettyPrint))
  add(query_578960, "oauth_token", newJString(oauthToken))
  add(query_578960, "alt", newJString(alt))
  add(query_578960, "userIp", newJString(userIp))
  add(query_578960, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578961 = body
  add(query_578960, "fields", newJString(fields))
  result = call_578959.call(nil, query_578960, nil, nil, body_578961)

var contentDatafeedstatusesCustombatch* = Call_ContentDatafeedstatusesCustombatch_578947(
    name: "contentDatafeedstatusesCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/datafeedstatuses/batch",
    validator: validate_ContentDatafeedstatusesCustombatch_578948,
    base: "/content/v2.1", url: url_ContentDatafeedstatusesCustombatch_578949,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsCustombatch_578962 = ref object of OpenApiRestCall_578348
proc url_ContentLiasettingsCustombatch_578964(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentLiasettingsCustombatch_578963(path: JsonNode; query: JsonNode;
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
  var valid_578965 = query.getOrDefault("key")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "key", valid_578965
  var valid_578966 = query.getOrDefault("prettyPrint")
  valid_578966 = validateParameter(valid_578966, JBool, required = false,
                                 default = newJBool(true))
  if valid_578966 != nil:
    section.add "prettyPrint", valid_578966
  var valid_578967 = query.getOrDefault("oauth_token")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "oauth_token", valid_578967
  var valid_578968 = query.getOrDefault("alt")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = newJString("json"))
  if valid_578968 != nil:
    section.add "alt", valid_578968
  var valid_578969 = query.getOrDefault("userIp")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "userIp", valid_578969
  var valid_578970 = query.getOrDefault("quotaUser")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "quotaUser", valid_578970
  var valid_578971 = query.getOrDefault("fields")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "fields", valid_578971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578973: Call_ContentLiasettingsCustombatch_578962; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves and/or updates the LIA settings of multiple accounts in a single request.
  ## 
  let valid = call_578973.validator(path, query, header, formData, body)
  let scheme = call_578973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578973.url(scheme.get, call_578973.host, call_578973.base,
                         call_578973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578973, url, valid)

proc call*(call_578974: Call_ContentLiasettingsCustombatch_578962;
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
  var query_578975 = newJObject()
  var body_578976 = newJObject()
  add(query_578975, "key", newJString(key))
  add(query_578975, "prettyPrint", newJBool(prettyPrint))
  add(query_578975, "oauth_token", newJString(oauthToken))
  add(query_578975, "alt", newJString(alt))
  add(query_578975, "userIp", newJString(userIp))
  add(query_578975, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578976 = body
  add(query_578975, "fields", newJString(fields))
  result = call_578974.call(nil, query_578975, nil, nil, body_578976)

var contentLiasettingsCustombatch* = Call_ContentLiasettingsCustombatch_578962(
    name: "contentLiasettingsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liasettings/batch",
    validator: validate_ContentLiasettingsCustombatch_578963,
    base: "/content/v2.1", url: url_ContentLiasettingsCustombatch_578964,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsListposdataproviders_578977 = ref object of OpenApiRestCall_578348
proc url_ContentLiasettingsListposdataproviders_578979(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentLiasettingsListposdataproviders_578978(path: JsonNode;
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
  var valid_578980 = query.getOrDefault("key")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "key", valid_578980
  var valid_578981 = query.getOrDefault("prettyPrint")
  valid_578981 = validateParameter(valid_578981, JBool, required = false,
                                 default = newJBool(true))
  if valid_578981 != nil:
    section.add "prettyPrint", valid_578981
  var valid_578982 = query.getOrDefault("oauth_token")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "oauth_token", valid_578982
  var valid_578983 = query.getOrDefault("alt")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = newJString("json"))
  if valid_578983 != nil:
    section.add "alt", valid_578983
  var valid_578984 = query.getOrDefault("userIp")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "userIp", valid_578984
  var valid_578985 = query.getOrDefault("quotaUser")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "quotaUser", valid_578985
  var valid_578986 = query.getOrDefault("fields")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "fields", valid_578986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578987: Call_ContentLiasettingsListposdataproviders_578977;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of POS data providers that have active settings for the all eiligible countries.
  ## 
  let valid = call_578987.validator(path, query, header, formData, body)
  let scheme = call_578987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578987.url(scheme.get, call_578987.host, call_578987.base,
                         call_578987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578987, url, valid)

proc call*(call_578988: Call_ContentLiasettingsListposdataproviders_578977;
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
  var query_578989 = newJObject()
  add(query_578989, "key", newJString(key))
  add(query_578989, "prettyPrint", newJBool(prettyPrint))
  add(query_578989, "oauth_token", newJString(oauthToken))
  add(query_578989, "alt", newJString(alt))
  add(query_578989, "userIp", newJString(userIp))
  add(query_578989, "quotaUser", newJString(quotaUser))
  add(query_578989, "fields", newJString(fields))
  result = call_578988.call(nil, query_578989, nil, nil, nil)

var contentLiasettingsListposdataproviders* = Call_ContentLiasettingsListposdataproviders_578977(
    name: "contentLiasettingsListposdataproviders", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/liasettings/posdataproviders",
    validator: validate_ContentLiasettingsListposdataproviders_578978,
    base: "/content/v2.1", url: url_ContentLiasettingsListposdataproviders_578979,
    schemes: {Scheme.Https})
type
  Call_ContentPosCustombatch_578990 = ref object of OpenApiRestCall_578348
proc url_ContentPosCustombatch_578992(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentPosCustombatch_578991(path: JsonNode; query: JsonNode;
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
  var valid_578993 = query.getOrDefault("key")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "key", valid_578993
  var valid_578994 = query.getOrDefault("prettyPrint")
  valid_578994 = validateParameter(valid_578994, JBool, required = false,
                                 default = newJBool(true))
  if valid_578994 != nil:
    section.add "prettyPrint", valid_578994
  var valid_578995 = query.getOrDefault("oauth_token")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "oauth_token", valid_578995
  var valid_578996 = query.getOrDefault("alt")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = newJString("json"))
  if valid_578996 != nil:
    section.add "alt", valid_578996
  var valid_578997 = query.getOrDefault("userIp")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "userIp", valid_578997
  var valid_578998 = query.getOrDefault("quotaUser")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "quotaUser", valid_578998
  var valid_578999 = query.getOrDefault("fields")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "fields", valid_578999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579001: Call_ContentPosCustombatch_578990; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Batches multiple POS-related calls in a single request.
  ## 
  let valid = call_579001.validator(path, query, header, formData, body)
  let scheme = call_579001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579001.url(scheme.get, call_579001.host, call_579001.base,
                         call_579001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579001, url, valid)

proc call*(call_579002: Call_ContentPosCustombatch_578990; key: string = "";
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
  var query_579003 = newJObject()
  var body_579004 = newJObject()
  add(query_579003, "key", newJString(key))
  add(query_579003, "prettyPrint", newJBool(prettyPrint))
  add(query_579003, "oauth_token", newJString(oauthToken))
  add(query_579003, "alt", newJString(alt))
  add(query_579003, "userIp", newJString(userIp))
  add(query_579003, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579004 = body
  add(query_579003, "fields", newJString(fields))
  result = call_579002.call(nil, query_579003, nil, nil, body_579004)

var contentPosCustombatch* = Call_ContentPosCustombatch_578990(
    name: "contentPosCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/pos/batch",
    validator: validate_ContentPosCustombatch_578991, base: "/content/v2.1",
    url: url_ContentPosCustombatch_578992, schemes: {Scheme.Https})
type
  Call_ContentProductsCustombatch_579005 = ref object of OpenApiRestCall_578348
proc url_ContentProductsCustombatch_579007(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentProductsCustombatch_579006(path: JsonNode; query: JsonNode;
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
  var valid_579008 = query.getOrDefault("key")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "key", valid_579008
  var valid_579009 = query.getOrDefault("prettyPrint")
  valid_579009 = validateParameter(valid_579009, JBool, required = false,
                                 default = newJBool(true))
  if valid_579009 != nil:
    section.add "prettyPrint", valid_579009
  var valid_579010 = query.getOrDefault("oauth_token")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "oauth_token", valid_579010
  var valid_579011 = query.getOrDefault("alt")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = newJString("json"))
  if valid_579011 != nil:
    section.add "alt", valid_579011
  var valid_579012 = query.getOrDefault("userIp")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "userIp", valid_579012
  var valid_579013 = query.getOrDefault("quotaUser")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "quotaUser", valid_579013
  var valid_579014 = query.getOrDefault("fields")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "fields", valid_579014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579016: Call_ContentProductsCustombatch_579005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves, inserts, and deletes multiple products in a single request.
  ## 
  let valid = call_579016.validator(path, query, header, formData, body)
  let scheme = call_579016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579016.url(scheme.get, call_579016.host, call_579016.base,
                         call_579016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579016, url, valid)

proc call*(call_579017: Call_ContentProductsCustombatch_579005; key: string = "";
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
  var query_579018 = newJObject()
  var body_579019 = newJObject()
  add(query_579018, "key", newJString(key))
  add(query_579018, "prettyPrint", newJBool(prettyPrint))
  add(query_579018, "oauth_token", newJString(oauthToken))
  add(query_579018, "alt", newJString(alt))
  add(query_579018, "userIp", newJString(userIp))
  add(query_579018, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579019 = body
  add(query_579018, "fields", newJString(fields))
  result = call_579017.call(nil, query_579018, nil, nil, body_579019)

var contentProductsCustombatch* = Call_ContentProductsCustombatch_579005(
    name: "contentProductsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/products/batch",
    validator: validate_ContentProductsCustombatch_579006, base: "/content/v2.1",
    url: url_ContentProductsCustombatch_579007, schemes: {Scheme.Https})
type
  Call_ContentProductstatusesCustombatch_579020 = ref object of OpenApiRestCall_578348
proc url_ContentProductstatusesCustombatch_579022(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentProductstatusesCustombatch_579021(path: JsonNode;
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
  var valid_579023 = query.getOrDefault("key")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "key", valid_579023
  var valid_579024 = query.getOrDefault("prettyPrint")
  valid_579024 = validateParameter(valid_579024, JBool, required = false,
                                 default = newJBool(true))
  if valid_579024 != nil:
    section.add "prettyPrint", valid_579024
  var valid_579025 = query.getOrDefault("oauth_token")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "oauth_token", valid_579025
  var valid_579026 = query.getOrDefault("alt")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = newJString("json"))
  if valid_579026 != nil:
    section.add "alt", valid_579026
  var valid_579027 = query.getOrDefault("userIp")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "userIp", valid_579027
  var valid_579028 = query.getOrDefault("quotaUser")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "quotaUser", valid_579028
  var valid_579029 = query.getOrDefault("fields")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "fields", valid_579029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579031: Call_ContentProductstatusesCustombatch_579020;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the statuses of multiple products in a single request.
  ## 
  let valid = call_579031.validator(path, query, header, formData, body)
  let scheme = call_579031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579031.url(scheme.get, call_579031.host, call_579031.base,
                         call_579031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579031, url, valid)

proc call*(call_579032: Call_ContentProductstatusesCustombatch_579020;
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
  var query_579033 = newJObject()
  var body_579034 = newJObject()
  add(query_579033, "key", newJString(key))
  add(query_579033, "prettyPrint", newJBool(prettyPrint))
  add(query_579033, "oauth_token", newJString(oauthToken))
  add(query_579033, "alt", newJString(alt))
  add(query_579033, "userIp", newJString(userIp))
  add(query_579033, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579034 = body
  add(query_579033, "fields", newJString(fields))
  result = call_579032.call(nil, query_579033, nil, nil, body_579034)

var contentProductstatusesCustombatch* = Call_ContentProductstatusesCustombatch_579020(
    name: "contentProductstatusesCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/productstatuses/batch",
    validator: validate_ContentProductstatusesCustombatch_579021,
    base: "/content/v2.1", url: url_ContentProductstatusesCustombatch_579022,
    schemes: {Scheme.Https})
type
  Call_ContentRegionalinventoryCustombatch_579035 = ref object of OpenApiRestCall_578348
proc url_ContentRegionalinventoryCustombatch_579037(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentRegionalinventoryCustombatch_579036(path: JsonNode;
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
  var valid_579038 = query.getOrDefault("key")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "key", valid_579038
  var valid_579039 = query.getOrDefault("prettyPrint")
  valid_579039 = validateParameter(valid_579039, JBool, required = false,
                                 default = newJBool(true))
  if valid_579039 != nil:
    section.add "prettyPrint", valid_579039
  var valid_579040 = query.getOrDefault("oauth_token")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "oauth_token", valid_579040
  var valid_579041 = query.getOrDefault("alt")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = newJString("json"))
  if valid_579041 != nil:
    section.add "alt", valid_579041
  var valid_579042 = query.getOrDefault("userIp")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "userIp", valid_579042
  var valid_579043 = query.getOrDefault("quotaUser")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "quotaUser", valid_579043
  var valid_579044 = query.getOrDefault("fields")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "fields", valid_579044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579046: Call_ContentRegionalinventoryCustombatch_579035;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates regional inventory for multiple products or regions in a single request.
  ## 
  let valid = call_579046.validator(path, query, header, formData, body)
  let scheme = call_579046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579046.url(scheme.get, call_579046.host, call_579046.base,
                         call_579046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579046, url, valid)

proc call*(call_579047: Call_ContentRegionalinventoryCustombatch_579035;
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
  var query_579048 = newJObject()
  var body_579049 = newJObject()
  add(query_579048, "key", newJString(key))
  add(query_579048, "prettyPrint", newJBool(prettyPrint))
  add(query_579048, "oauth_token", newJString(oauthToken))
  add(query_579048, "alt", newJString(alt))
  add(query_579048, "userIp", newJString(userIp))
  add(query_579048, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579049 = body
  add(query_579048, "fields", newJString(fields))
  result = call_579047.call(nil, query_579048, nil, nil, body_579049)

var contentRegionalinventoryCustombatch* = Call_ContentRegionalinventoryCustombatch_579035(
    name: "contentRegionalinventoryCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/regionalinventory/batch",
    validator: validate_ContentRegionalinventoryCustombatch_579036,
    base: "/content/v2.1", url: url_ContentRegionalinventoryCustombatch_579037,
    schemes: {Scheme.Https})
type
  Call_ContentReturnaddressCustombatch_579050 = ref object of OpenApiRestCall_578348
proc url_ContentReturnaddressCustombatch_579052(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentReturnaddressCustombatch_579051(path: JsonNode;
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
  var valid_579053 = query.getOrDefault("key")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "key", valid_579053
  var valid_579054 = query.getOrDefault("prettyPrint")
  valid_579054 = validateParameter(valid_579054, JBool, required = false,
                                 default = newJBool(true))
  if valid_579054 != nil:
    section.add "prettyPrint", valid_579054
  var valid_579055 = query.getOrDefault("oauth_token")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "oauth_token", valid_579055
  var valid_579056 = query.getOrDefault("alt")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = newJString("json"))
  if valid_579056 != nil:
    section.add "alt", valid_579056
  var valid_579057 = query.getOrDefault("userIp")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "userIp", valid_579057
  var valid_579058 = query.getOrDefault("quotaUser")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "quotaUser", valid_579058
  var valid_579059 = query.getOrDefault("fields")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "fields", valid_579059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579061: Call_ContentReturnaddressCustombatch_579050;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Batches multiple return address related calls in a single request.
  ## 
  let valid = call_579061.validator(path, query, header, formData, body)
  let scheme = call_579061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579061.url(scheme.get, call_579061.host, call_579061.base,
                         call_579061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579061, url, valid)

proc call*(call_579062: Call_ContentReturnaddressCustombatch_579050;
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
  var query_579063 = newJObject()
  var body_579064 = newJObject()
  add(query_579063, "key", newJString(key))
  add(query_579063, "prettyPrint", newJBool(prettyPrint))
  add(query_579063, "oauth_token", newJString(oauthToken))
  add(query_579063, "alt", newJString(alt))
  add(query_579063, "userIp", newJString(userIp))
  add(query_579063, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579064 = body
  add(query_579063, "fields", newJString(fields))
  result = call_579062.call(nil, query_579063, nil, nil, body_579064)

var contentReturnaddressCustombatch* = Call_ContentReturnaddressCustombatch_579050(
    name: "contentReturnaddressCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/returnaddress/batch",
    validator: validate_ContentReturnaddressCustombatch_579051,
    base: "/content/v2.1", url: url_ContentReturnaddressCustombatch_579052,
    schemes: {Scheme.Https})
type
  Call_ContentReturnpolicyCustombatch_579065 = ref object of OpenApiRestCall_578348
proc url_ContentReturnpolicyCustombatch_579067(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentReturnpolicyCustombatch_579066(path: JsonNode;
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
  var valid_579068 = query.getOrDefault("key")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "key", valid_579068
  var valid_579069 = query.getOrDefault("prettyPrint")
  valid_579069 = validateParameter(valid_579069, JBool, required = false,
                                 default = newJBool(true))
  if valid_579069 != nil:
    section.add "prettyPrint", valid_579069
  var valid_579070 = query.getOrDefault("oauth_token")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = nil)
  if valid_579070 != nil:
    section.add "oauth_token", valid_579070
  var valid_579071 = query.getOrDefault("alt")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = newJString("json"))
  if valid_579071 != nil:
    section.add "alt", valid_579071
  var valid_579072 = query.getOrDefault("userIp")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "userIp", valid_579072
  var valid_579073 = query.getOrDefault("quotaUser")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "quotaUser", valid_579073
  var valid_579074 = query.getOrDefault("fields")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "fields", valid_579074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579076: Call_ContentReturnpolicyCustombatch_579065; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Batches multiple return policy related calls in a single request.
  ## 
  let valid = call_579076.validator(path, query, header, formData, body)
  let scheme = call_579076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579076.url(scheme.get, call_579076.host, call_579076.base,
                         call_579076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579076, url, valid)

proc call*(call_579077: Call_ContentReturnpolicyCustombatch_579065;
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
  var query_579078 = newJObject()
  var body_579079 = newJObject()
  add(query_579078, "key", newJString(key))
  add(query_579078, "prettyPrint", newJBool(prettyPrint))
  add(query_579078, "oauth_token", newJString(oauthToken))
  add(query_579078, "alt", newJString(alt))
  add(query_579078, "userIp", newJString(userIp))
  add(query_579078, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579079 = body
  add(query_579078, "fields", newJString(fields))
  result = call_579077.call(nil, query_579078, nil, nil, body_579079)

var contentReturnpolicyCustombatch* = Call_ContentReturnpolicyCustombatch_579065(
    name: "contentReturnpolicyCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/returnpolicy/batch",
    validator: validate_ContentReturnpolicyCustombatch_579066,
    base: "/content/v2.1", url: url_ContentReturnpolicyCustombatch_579067,
    schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsCustombatch_579080 = ref object of OpenApiRestCall_578348
proc url_ContentShippingsettingsCustombatch_579082(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ContentShippingsettingsCustombatch_579081(path: JsonNode;
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
  var valid_579083 = query.getOrDefault("key")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "key", valid_579083
  var valid_579084 = query.getOrDefault("prettyPrint")
  valid_579084 = validateParameter(valid_579084, JBool, required = false,
                                 default = newJBool(true))
  if valid_579084 != nil:
    section.add "prettyPrint", valid_579084
  var valid_579085 = query.getOrDefault("oauth_token")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "oauth_token", valid_579085
  var valid_579086 = query.getOrDefault("alt")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = newJString("json"))
  if valid_579086 != nil:
    section.add "alt", valid_579086
  var valid_579087 = query.getOrDefault("userIp")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "userIp", valid_579087
  var valid_579088 = query.getOrDefault("quotaUser")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "quotaUser", valid_579088
  var valid_579089 = query.getOrDefault("fields")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "fields", valid_579089
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579091: Call_ContentShippingsettingsCustombatch_579080;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves and updates the shipping settings of multiple accounts in a single request.
  ## 
  let valid = call_579091.validator(path, query, header, formData, body)
  let scheme = call_579091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579091.url(scheme.get, call_579091.host, call_579091.base,
                         call_579091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579091, url, valid)

proc call*(call_579092: Call_ContentShippingsettingsCustombatch_579080;
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
  var query_579093 = newJObject()
  var body_579094 = newJObject()
  add(query_579093, "key", newJString(key))
  add(query_579093, "prettyPrint", newJBool(prettyPrint))
  add(query_579093, "oauth_token", newJString(oauthToken))
  add(query_579093, "alt", newJString(alt))
  add(query_579093, "userIp", newJString(userIp))
  add(query_579093, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579094 = body
  add(query_579093, "fields", newJString(fields))
  result = call_579092.call(nil, query_579093, nil, nil, body_579094)

var contentShippingsettingsCustombatch* = Call_ContentShippingsettingsCustombatch_579080(
    name: "contentShippingsettingsCustombatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/shippingsettings/batch",
    validator: validate_ContentShippingsettingsCustombatch_579081,
    base: "/content/v2.1", url: url_ContentShippingsettingsCustombatch_579082,
    schemes: {Scheme.Https})
type
  Call_ContentAccountsInsert_579126 = ref object of OpenApiRestCall_578348
proc url_ContentAccountsInsert_579128(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsInsert_579127(path: JsonNode; query: JsonNode;
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
  var valid_579129 = path.getOrDefault("merchantId")
  valid_579129 = validateParameter(valid_579129, JString, required = true,
                                 default = nil)
  if valid_579129 != nil:
    section.add "merchantId", valid_579129
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579130 = query.getOrDefault("key")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "key", valid_579130
  var valid_579131 = query.getOrDefault("prettyPrint")
  valid_579131 = validateParameter(valid_579131, JBool, required = false,
                                 default = newJBool(true))
  if valid_579131 != nil:
    section.add "prettyPrint", valid_579131
  var valid_579132 = query.getOrDefault("oauth_token")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "oauth_token", valid_579132
  var valid_579133 = query.getOrDefault("alt")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = newJString("json"))
  if valid_579133 != nil:
    section.add "alt", valid_579133
  var valid_579134 = query.getOrDefault("userIp")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = nil)
  if valid_579134 != nil:
    section.add "userIp", valid_579134
  var valid_579135 = query.getOrDefault("quotaUser")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "quotaUser", valid_579135
  var valid_579136 = query.getOrDefault("fields")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "fields", valid_579136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579138: Call_ContentAccountsInsert_579126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Merchant Center sub-account.
  ## 
  let valid = call_579138.validator(path, query, header, formData, body)
  let scheme = call_579138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579138.url(scheme.get, call_579138.host, call_579138.base,
                         call_579138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579138, url, valid)

proc call*(call_579139: Call_ContentAccountsInsert_579126; merchantId: string;
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
  var path_579140 = newJObject()
  var query_579141 = newJObject()
  var body_579142 = newJObject()
  add(query_579141, "key", newJString(key))
  add(query_579141, "prettyPrint", newJBool(prettyPrint))
  add(query_579141, "oauth_token", newJString(oauthToken))
  add(query_579141, "alt", newJString(alt))
  add(query_579141, "userIp", newJString(userIp))
  add(query_579141, "quotaUser", newJString(quotaUser))
  add(path_579140, "merchantId", newJString(merchantId))
  if body != nil:
    body_579142 = body
  add(query_579141, "fields", newJString(fields))
  result = call_579139.call(path_579140, query_579141, nil, nil, body_579142)

var contentAccountsInsert* = Call_ContentAccountsInsert_579126(
    name: "contentAccountsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/accounts",
    validator: validate_ContentAccountsInsert_579127, base: "/content/v2.1",
    url: url_ContentAccountsInsert_579128, schemes: {Scheme.Https})
type
  Call_ContentAccountsList_579095 = ref object of OpenApiRestCall_578348
proc url_ContentAccountsList_579097(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsList_579096(path: JsonNode; query: JsonNode;
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
  var valid_579112 = path.getOrDefault("merchantId")
  valid_579112 = validateParameter(valid_579112, JString, required = true,
                                 default = nil)
  if valid_579112 != nil:
    section.add "merchantId", valid_579112
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579113 = query.getOrDefault("key")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "key", valid_579113
  var valid_579114 = query.getOrDefault("prettyPrint")
  valid_579114 = validateParameter(valid_579114, JBool, required = false,
                                 default = newJBool(true))
  if valid_579114 != nil:
    section.add "prettyPrint", valid_579114
  var valid_579115 = query.getOrDefault("oauth_token")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "oauth_token", valid_579115
  var valid_579116 = query.getOrDefault("alt")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = newJString("json"))
  if valid_579116 != nil:
    section.add "alt", valid_579116
  var valid_579117 = query.getOrDefault("userIp")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "userIp", valid_579117
  var valid_579118 = query.getOrDefault("quotaUser")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "quotaUser", valid_579118
  var valid_579119 = query.getOrDefault("pageToken")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "pageToken", valid_579119
  var valid_579120 = query.getOrDefault("fields")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "fields", valid_579120
  var valid_579121 = query.getOrDefault("maxResults")
  valid_579121 = validateParameter(valid_579121, JInt, required = false, default = nil)
  if valid_579121 != nil:
    section.add "maxResults", valid_579121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579122: Call_ContentAccountsList_579095; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_579122.validator(path, query, header, formData, body)
  let scheme = call_579122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579122.url(scheme.get, call_579122.host, call_579122.base,
                         call_579122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579122, url, valid)

proc call*(call_579123: Call_ContentAccountsList_579095; merchantId: string;
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
  var path_579124 = newJObject()
  var query_579125 = newJObject()
  add(query_579125, "key", newJString(key))
  add(query_579125, "prettyPrint", newJBool(prettyPrint))
  add(query_579125, "oauth_token", newJString(oauthToken))
  add(query_579125, "alt", newJString(alt))
  add(query_579125, "userIp", newJString(userIp))
  add(query_579125, "quotaUser", newJString(quotaUser))
  add(path_579124, "merchantId", newJString(merchantId))
  add(query_579125, "pageToken", newJString(pageToken))
  add(query_579125, "fields", newJString(fields))
  add(query_579125, "maxResults", newJInt(maxResults))
  result = call_579123.call(path_579124, query_579125, nil, nil, nil)

var contentAccountsList* = Call_ContentAccountsList_579095(
    name: "contentAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounts",
    validator: validate_ContentAccountsList_579096, base: "/content/v2.1",
    url: url_ContentAccountsList_579097, schemes: {Scheme.Https})
type
  Call_ContentAccountsUpdate_579159 = ref object of OpenApiRestCall_578348
proc url_ContentAccountsUpdate_579161(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsUpdate_579160(path: JsonNode; query: JsonNode;
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
  var valid_579162 = path.getOrDefault("merchantId")
  valid_579162 = validateParameter(valid_579162, JString, required = true,
                                 default = nil)
  if valid_579162 != nil:
    section.add "merchantId", valid_579162
  var valid_579163 = path.getOrDefault("accountId")
  valid_579163 = validateParameter(valid_579163, JString, required = true,
                                 default = nil)
  if valid_579163 != nil:
    section.add "accountId", valid_579163
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579164 = query.getOrDefault("key")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "key", valid_579164
  var valid_579165 = query.getOrDefault("prettyPrint")
  valid_579165 = validateParameter(valid_579165, JBool, required = false,
                                 default = newJBool(true))
  if valid_579165 != nil:
    section.add "prettyPrint", valid_579165
  var valid_579166 = query.getOrDefault("oauth_token")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "oauth_token", valid_579166
  var valid_579167 = query.getOrDefault("alt")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = newJString("json"))
  if valid_579167 != nil:
    section.add "alt", valid_579167
  var valid_579168 = query.getOrDefault("userIp")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = nil)
  if valid_579168 != nil:
    section.add "userIp", valid_579168
  var valid_579169 = query.getOrDefault("quotaUser")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "quotaUser", valid_579169
  var valid_579170 = query.getOrDefault("fields")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "fields", valid_579170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579172: Call_ContentAccountsUpdate_579159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Merchant Center account.
  ## 
  let valid = call_579172.validator(path, query, header, formData, body)
  let scheme = call_579172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579172.url(scheme.get, call_579172.host, call_579172.base,
                         call_579172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579172, url, valid)

proc call*(call_579173: Call_ContentAccountsUpdate_579159; merchantId: string;
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
  var path_579174 = newJObject()
  var query_579175 = newJObject()
  var body_579176 = newJObject()
  add(query_579175, "key", newJString(key))
  add(query_579175, "prettyPrint", newJBool(prettyPrint))
  add(query_579175, "oauth_token", newJString(oauthToken))
  add(query_579175, "alt", newJString(alt))
  add(query_579175, "userIp", newJString(userIp))
  add(query_579175, "quotaUser", newJString(quotaUser))
  add(path_579174, "merchantId", newJString(merchantId))
  if body != nil:
    body_579176 = body
  add(path_579174, "accountId", newJString(accountId))
  add(query_579175, "fields", newJString(fields))
  result = call_579173.call(path_579174, query_579175, nil, nil, body_579176)

var contentAccountsUpdate* = Call_ContentAccountsUpdate_579159(
    name: "contentAccountsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsUpdate_579160, base: "/content/v2.1",
    url: url_ContentAccountsUpdate_579161, schemes: {Scheme.Https})
type
  Call_ContentAccountsGet_579143 = ref object of OpenApiRestCall_578348
proc url_ContentAccountsGet_579145(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsGet_579144(path: JsonNode; query: JsonNode;
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
  var valid_579146 = path.getOrDefault("merchantId")
  valid_579146 = validateParameter(valid_579146, JString, required = true,
                                 default = nil)
  if valid_579146 != nil:
    section.add "merchantId", valid_579146
  var valid_579147 = path.getOrDefault("accountId")
  valid_579147 = validateParameter(valid_579147, JString, required = true,
                                 default = nil)
  if valid_579147 != nil:
    section.add "accountId", valid_579147
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579148 = query.getOrDefault("key")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "key", valid_579148
  var valid_579149 = query.getOrDefault("prettyPrint")
  valid_579149 = validateParameter(valid_579149, JBool, required = false,
                                 default = newJBool(true))
  if valid_579149 != nil:
    section.add "prettyPrint", valid_579149
  var valid_579150 = query.getOrDefault("oauth_token")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = nil)
  if valid_579150 != nil:
    section.add "oauth_token", valid_579150
  var valid_579151 = query.getOrDefault("alt")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = newJString("json"))
  if valid_579151 != nil:
    section.add "alt", valid_579151
  var valid_579152 = query.getOrDefault("userIp")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "userIp", valid_579152
  var valid_579153 = query.getOrDefault("quotaUser")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "quotaUser", valid_579153
  var valid_579154 = query.getOrDefault("fields")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "fields", valid_579154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579155: Call_ContentAccountsGet_579143; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a Merchant Center account.
  ## 
  let valid = call_579155.validator(path, query, header, formData, body)
  let scheme = call_579155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579155.url(scheme.get, call_579155.host, call_579155.base,
                         call_579155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579155, url, valid)

proc call*(call_579156: Call_ContentAccountsGet_579143; merchantId: string;
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
  var path_579157 = newJObject()
  var query_579158 = newJObject()
  add(query_579158, "key", newJString(key))
  add(query_579158, "prettyPrint", newJBool(prettyPrint))
  add(query_579158, "oauth_token", newJString(oauthToken))
  add(query_579158, "alt", newJString(alt))
  add(query_579158, "userIp", newJString(userIp))
  add(query_579158, "quotaUser", newJString(quotaUser))
  add(path_579157, "merchantId", newJString(merchantId))
  add(path_579157, "accountId", newJString(accountId))
  add(query_579158, "fields", newJString(fields))
  result = call_579156.call(path_579157, query_579158, nil, nil, nil)

var contentAccountsGet* = Call_ContentAccountsGet_579143(
    name: "contentAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsGet_579144, base: "/content/v2.1",
    url: url_ContentAccountsGet_579145, schemes: {Scheme.Https})
type
  Call_ContentAccountsDelete_579177 = ref object of OpenApiRestCall_578348
proc url_ContentAccountsDelete_579179(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsDelete_579178(path: JsonNode; query: JsonNode;
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
  var valid_579180 = path.getOrDefault("merchantId")
  valid_579180 = validateParameter(valid_579180, JString, required = true,
                                 default = nil)
  if valid_579180 != nil:
    section.add "merchantId", valid_579180
  var valid_579181 = path.getOrDefault("accountId")
  valid_579181 = validateParameter(valid_579181, JString, required = true,
                                 default = nil)
  if valid_579181 != nil:
    section.add "accountId", valid_579181
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579182 = query.getOrDefault("key")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = nil)
  if valid_579182 != nil:
    section.add "key", valid_579182
  var valid_579183 = query.getOrDefault("prettyPrint")
  valid_579183 = validateParameter(valid_579183, JBool, required = false,
                                 default = newJBool(true))
  if valid_579183 != nil:
    section.add "prettyPrint", valid_579183
  var valid_579184 = query.getOrDefault("oauth_token")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = nil)
  if valid_579184 != nil:
    section.add "oauth_token", valid_579184
  var valid_579185 = query.getOrDefault("alt")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = newJString("json"))
  if valid_579185 != nil:
    section.add "alt", valid_579185
  var valid_579186 = query.getOrDefault("userIp")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = nil)
  if valid_579186 != nil:
    section.add "userIp", valid_579186
  var valid_579187 = query.getOrDefault("quotaUser")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = nil)
  if valid_579187 != nil:
    section.add "quotaUser", valid_579187
  var valid_579188 = query.getOrDefault("force")
  valid_579188 = validateParameter(valid_579188, JBool, required = false,
                                 default = newJBool(false))
  if valid_579188 != nil:
    section.add "force", valid_579188
  var valid_579189 = query.getOrDefault("fields")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "fields", valid_579189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579190: Call_ContentAccountsDelete_579177; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Merchant Center sub-account.
  ## 
  let valid = call_579190.validator(path, query, header, formData, body)
  let scheme = call_579190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579190.url(scheme.get, call_579190.host, call_579190.base,
                         call_579190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579190, url, valid)

proc call*(call_579191: Call_ContentAccountsDelete_579177; merchantId: string;
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
  var path_579192 = newJObject()
  var query_579193 = newJObject()
  add(query_579193, "key", newJString(key))
  add(query_579193, "prettyPrint", newJBool(prettyPrint))
  add(query_579193, "oauth_token", newJString(oauthToken))
  add(query_579193, "alt", newJString(alt))
  add(query_579193, "userIp", newJString(userIp))
  add(query_579193, "quotaUser", newJString(quotaUser))
  add(path_579192, "merchantId", newJString(merchantId))
  add(query_579193, "force", newJBool(force))
  add(path_579192, "accountId", newJString(accountId))
  add(query_579193, "fields", newJString(fields))
  result = call_579191.call(path_579192, query_579193, nil, nil, nil)

var contentAccountsDelete* = Call_ContentAccountsDelete_579177(
    name: "contentAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}",
    validator: validate_ContentAccountsDelete_579178, base: "/content/v2.1",
    url: url_ContentAccountsDelete_579179, schemes: {Scheme.Https})
type
  Call_ContentAccountsClaimwebsite_579194 = ref object of OpenApiRestCall_578348
proc url_ContentAccountsClaimwebsite_579196(protocol: Scheme; host: string;
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

proc validate_ContentAccountsClaimwebsite_579195(path: JsonNode; query: JsonNode;
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
  var valid_579197 = path.getOrDefault("merchantId")
  valid_579197 = validateParameter(valid_579197, JString, required = true,
                                 default = nil)
  if valid_579197 != nil:
    section.add "merchantId", valid_579197
  var valid_579198 = path.getOrDefault("accountId")
  valid_579198 = validateParameter(valid_579198, JString, required = true,
                                 default = nil)
  if valid_579198 != nil:
    section.add "accountId", valid_579198
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
  var valid_579199 = query.getOrDefault("key")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "key", valid_579199
  var valid_579200 = query.getOrDefault("prettyPrint")
  valid_579200 = validateParameter(valid_579200, JBool, required = false,
                                 default = newJBool(true))
  if valid_579200 != nil:
    section.add "prettyPrint", valid_579200
  var valid_579201 = query.getOrDefault("oauth_token")
  valid_579201 = validateParameter(valid_579201, JString, required = false,
                                 default = nil)
  if valid_579201 != nil:
    section.add "oauth_token", valid_579201
  var valid_579202 = query.getOrDefault("overwrite")
  valid_579202 = validateParameter(valid_579202, JBool, required = false, default = nil)
  if valid_579202 != nil:
    section.add "overwrite", valid_579202
  var valid_579203 = query.getOrDefault("alt")
  valid_579203 = validateParameter(valid_579203, JString, required = false,
                                 default = newJString("json"))
  if valid_579203 != nil:
    section.add "alt", valid_579203
  var valid_579204 = query.getOrDefault("userIp")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "userIp", valid_579204
  var valid_579205 = query.getOrDefault("quotaUser")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = nil)
  if valid_579205 != nil:
    section.add "quotaUser", valid_579205
  var valid_579206 = query.getOrDefault("fields")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "fields", valid_579206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579207: Call_ContentAccountsClaimwebsite_579194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Claims the website of a Merchant Center sub-account.
  ## 
  let valid = call_579207.validator(path, query, header, formData, body)
  let scheme = call_579207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579207.url(scheme.get, call_579207.host, call_579207.base,
                         call_579207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579207, url, valid)

proc call*(call_579208: Call_ContentAccountsClaimwebsite_579194;
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
  var path_579209 = newJObject()
  var query_579210 = newJObject()
  add(query_579210, "key", newJString(key))
  add(query_579210, "prettyPrint", newJBool(prettyPrint))
  add(query_579210, "oauth_token", newJString(oauthToken))
  add(query_579210, "overwrite", newJBool(overwrite))
  add(query_579210, "alt", newJString(alt))
  add(query_579210, "userIp", newJString(userIp))
  add(query_579210, "quotaUser", newJString(quotaUser))
  add(path_579209, "merchantId", newJString(merchantId))
  add(path_579209, "accountId", newJString(accountId))
  add(query_579210, "fields", newJString(fields))
  result = call_579208.call(path_579209, query_579210, nil, nil, nil)

var contentAccountsClaimwebsite* = Call_ContentAccountsClaimwebsite_579194(
    name: "contentAccountsClaimwebsite", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/accounts/{accountId}/claimwebsite",
    validator: validate_ContentAccountsClaimwebsite_579195, base: "/content/v2.1",
    url: url_ContentAccountsClaimwebsite_579196, schemes: {Scheme.Https})
type
  Call_ContentAccountsLink_579211 = ref object of OpenApiRestCall_578348
proc url_ContentAccountsLink_579213(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccountsLink_579212(path: JsonNode; query: JsonNode;
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
  var valid_579214 = path.getOrDefault("merchantId")
  valid_579214 = validateParameter(valid_579214, JString, required = true,
                                 default = nil)
  if valid_579214 != nil:
    section.add "merchantId", valid_579214
  var valid_579215 = path.getOrDefault("accountId")
  valid_579215 = validateParameter(valid_579215, JString, required = true,
                                 default = nil)
  if valid_579215 != nil:
    section.add "accountId", valid_579215
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579216 = query.getOrDefault("key")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "key", valid_579216
  var valid_579217 = query.getOrDefault("prettyPrint")
  valid_579217 = validateParameter(valid_579217, JBool, required = false,
                                 default = newJBool(true))
  if valid_579217 != nil:
    section.add "prettyPrint", valid_579217
  var valid_579218 = query.getOrDefault("oauth_token")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "oauth_token", valid_579218
  var valid_579219 = query.getOrDefault("alt")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = newJString("json"))
  if valid_579219 != nil:
    section.add "alt", valid_579219
  var valid_579220 = query.getOrDefault("userIp")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = nil)
  if valid_579220 != nil:
    section.add "userIp", valid_579220
  var valid_579221 = query.getOrDefault("quotaUser")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "quotaUser", valid_579221
  var valid_579222 = query.getOrDefault("fields")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = nil)
  if valid_579222 != nil:
    section.add "fields", valid_579222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579224: Call_ContentAccountsLink_579211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs an action on a link between two Merchant Center accounts, namely accountId and linkedAccountId.
  ## 
  let valid = call_579224.validator(path, query, header, formData, body)
  let scheme = call_579224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579224.url(scheme.get, call_579224.host, call_579224.base,
                         call_579224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579224, url, valid)

proc call*(call_579225: Call_ContentAccountsLink_579211; merchantId: string;
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
  var path_579226 = newJObject()
  var query_579227 = newJObject()
  var body_579228 = newJObject()
  add(query_579227, "key", newJString(key))
  add(query_579227, "prettyPrint", newJBool(prettyPrint))
  add(query_579227, "oauth_token", newJString(oauthToken))
  add(query_579227, "alt", newJString(alt))
  add(query_579227, "userIp", newJString(userIp))
  add(query_579227, "quotaUser", newJString(quotaUser))
  add(path_579226, "merchantId", newJString(merchantId))
  if body != nil:
    body_579228 = body
  add(path_579226, "accountId", newJString(accountId))
  add(query_579227, "fields", newJString(fields))
  result = call_579225.call(path_579226, query_579227, nil, nil, body_579228)

var contentAccountsLink* = Call_ContentAccountsLink_579211(
    name: "contentAccountsLink", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/accounts/{accountId}/link",
    validator: validate_ContentAccountsLink_579212, base: "/content/v2.1",
    url: url_ContentAccountsLink_579213, schemes: {Scheme.Https})
type
  Call_ContentAccountstatusesList_579229 = ref object of OpenApiRestCall_578348
proc url_ContentAccountstatusesList_579231(protocol: Scheme; host: string;
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

proc validate_ContentAccountstatusesList_579230(path: JsonNode; query: JsonNode;
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
  var valid_579232 = path.getOrDefault("merchantId")
  valid_579232 = validateParameter(valid_579232, JString, required = true,
                                 default = nil)
  if valid_579232 != nil:
    section.add "merchantId", valid_579232
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579233 = query.getOrDefault("key")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = nil)
  if valid_579233 != nil:
    section.add "key", valid_579233
  var valid_579234 = query.getOrDefault("prettyPrint")
  valid_579234 = validateParameter(valid_579234, JBool, required = false,
                                 default = newJBool(true))
  if valid_579234 != nil:
    section.add "prettyPrint", valid_579234
  var valid_579235 = query.getOrDefault("oauth_token")
  valid_579235 = validateParameter(valid_579235, JString, required = false,
                                 default = nil)
  if valid_579235 != nil:
    section.add "oauth_token", valid_579235
  var valid_579236 = query.getOrDefault("alt")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = newJString("json"))
  if valid_579236 != nil:
    section.add "alt", valid_579236
  var valid_579237 = query.getOrDefault("userIp")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = nil)
  if valid_579237 != nil:
    section.add "userIp", valid_579237
  var valid_579238 = query.getOrDefault("quotaUser")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = nil)
  if valid_579238 != nil:
    section.add "quotaUser", valid_579238
  var valid_579239 = query.getOrDefault("pageToken")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = nil)
  if valid_579239 != nil:
    section.add "pageToken", valid_579239
  var valid_579240 = query.getOrDefault("destinations")
  valid_579240 = validateParameter(valid_579240, JArray, required = false,
                                 default = nil)
  if valid_579240 != nil:
    section.add "destinations", valid_579240
  var valid_579241 = query.getOrDefault("fields")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = nil)
  if valid_579241 != nil:
    section.add "fields", valid_579241
  var valid_579242 = query.getOrDefault("maxResults")
  valid_579242 = validateParameter(valid_579242, JInt, required = false, default = nil)
  if valid_579242 != nil:
    section.add "maxResults", valid_579242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579243: Call_ContentAccountstatusesList_579229; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_579243.validator(path, query, header, formData, body)
  let scheme = call_579243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579243.url(scheme.get, call_579243.host, call_579243.base,
                         call_579243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579243, url, valid)

proc call*(call_579244: Call_ContentAccountstatusesList_579229; merchantId: string;
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
  var path_579245 = newJObject()
  var query_579246 = newJObject()
  add(query_579246, "key", newJString(key))
  add(query_579246, "prettyPrint", newJBool(prettyPrint))
  add(query_579246, "oauth_token", newJString(oauthToken))
  add(query_579246, "alt", newJString(alt))
  add(query_579246, "userIp", newJString(userIp))
  add(query_579246, "quotaUser", newJString(quotaUser))
  add(path_579245, "merchantId", newJString(merchantId))
  add(query_579246, "pageToken", newJString(pageToken))
  if destinations != nil:
    query_579246.add "destinations", destinations
  add(query_579246, "fields", newJString(fields))
  add(query_579246, "maxResults", newJInt(maxResults))
  result = call_579244.call(path_579245, query_579246, nil, nil, nil)

var contentAccountstatusesList* = Call_ContentAccountstatusesList_579229(
    name: "contentAccountstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accountstatuses",
    validator: validate_ContentAccountstatusesList_579230, base: "/content/v2.1",
    url: url_ContentAccountstatusesList_579231, schemes: {Scheme.Https})
type
  Call_ContentAccountstatusesGet_579247 = ref object of OpenApiRestCall_578348
proc url_ContentAccountstatusesGet_579249(protocol: Scheme; host: string;
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

proc validate_ContentAccountstatusesGet_579248(path: JsonNode; query: JsonNode;
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
  var valid_579250 = path.getOrDefault("merchantId")
  valid_579250 = validateParameter(valid_579250, JString, required = true,
                                 default = nil)
  if valid_579250 != nil:
    section.add "merchantId", valid_579250
  var valid_579251 = path.getOrDefault("accountId")
  valid_579251 = validateParameter(valid_579251, JString, required = true,
                                 default = nil)
  if valid_579251 != nil:
    section.add "accountId", valid_579251
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579252 = query.getOrDefault("key")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = nil)
  if valid_579252 != nil:
    section.add "key", valid_579252
  var valid_579253 = query.getOrDefault("prettyPrint")
  valid_579253 = validateParameter(valid_579253, JBool, required = false,
                                 default = newJBool(true))
  if valid_579253 != nil:
    section.add "prettyPrint", valid_579253
  var valid_579254 = query.getOrDefault("oauth_token")
  valid_579254 = validateParameter(valid_579254, JString, required = false,
                                 default = nil)
  if valid_579254 != nil:
    section.add "oauth_token", valid_579254
  var valid_579255 = query.getOrDefault("alt")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = newJString("json"))
  if valid_579255 != nil:
    section.add "alt", valid_579255
  var valid_579256 = query.getOrDefault("userIp")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = nil)
  if valid_579256 != nil:
    section.add "userIp", valid_579256
  var valid_579257 = query.getOrDefault("quotaUser")
  valid_579257 = validateParameter(valid_579257, JString, required = false,
                                 default = nil)
  if valid_579257 != nil:
    section.add "quotaUser", valid_579257
  var valid_579258 = query.getOrDefault("destinations")
  valid_579258 = validateParameter(valid_579258, JArray, required = false,
                                 default = nil)
  if valid_579258 != nil:
    section.add "destinations", valid_579258
  var valid_579259 = query.getOrDefault("fields")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "fields", valid_579259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579260: Call_ContentAccountstatusesGet_579247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the status of a Merchant Center account. No itemLevelIssues are returned for multi-client accounts.
  ## 
  let valid = call_579260.validator(path, query, header, formData, body)
  let scheme = call_579260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579260.url(scheme.get, call_579260.host, call_579260.base,
                         call_579260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579260, url, valid)

proc call*(call_579261: Call_ContentAccountstatusesGet_579247; merchantId: string;
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
  var path_579262 = newJObject()
  var query_579263 = newJObject()
  add(query_579263, "key", newJString(key))
  add(query_579263, "prettyPrint", newJBool(prettyPrint))
  add(query_579263, "oauth_token", newJString(oauthToken))
  add(query_579263, "alt", newJString(alt))
  add(query_579263, "userIp", newJString(userIp))
  add(query_579263, "quotaUser", newJString(quotaUser))
  add(path_579262, "merchantId", newJString(merchantId))
  if destinations != nil:
    query_579263.add "destinations", destinations
  add(path_579262, "accountId", newJString(accountId))
  add(query_579263, "fields", newJString(fields))
  result = call_579261.call(path_579262, query_579263, nil, nil, nil)

var contentAccountstatusesGet* = Call_ContentAccountstatusesGet_579247(
    name: "contentAccountstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/accountstatuses/{accountId}",
    validator: validate_ContentAccountstatusesGet_579248, base: "/content/v2.1",
    url: url_ContentAccountstatusesGet_579249, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxList_579264 = ref object of OpenApiRestCall_578348
proc url_ContentAccounttaxList_579266(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccounttaxList_579265(path: JsonNode; query: JsonNode;
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
  var valid_579267 = path.getOrDefault("merchantId")
  valid_579267 = validateParameter(valid_579267, JString, required = true,
                                 default = nil)
  if valid_579267 != nil:
    section.add "merchantId", valid_579267
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579268 = query.getOrDefault("key")
  valid_579268 = validateParameter(valid_579268, JString, required = false,
                                 default = nil)
  if valid_579268 != nil:
    section.add "key", valid_579268
  var valid_579269 = query.getOrDefault("prettyPrint")
  valid_579269 = validateParameter(valid_579269, JBool, required = false,
                                 default = newJBool(true))
  if valid_579269 != nil:
    section.add "prettyPrint", valid_579269
  var valid_579270 = query.getOrDefault("oauth_token")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = nil)
  if valid_579270 != nil:
    section.add "oauth_token", valid_579270
  var valid_579271 = query.getOrDefault("alt")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = newJString("json"))
  if valid_579271 != nil:
    section.add "alt", valid_579271
  var valid_579272 = query.getOrDefault("userIp")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = nil)
  if valid_579272 != nil:
    section.add "userIp", valid_579272
  var valid_579273 = query.getOrDefault("quotaUser")
  valid_579273 = validateParameter(valid_579273, JString, required = false,
                                 default = nil)
  if valid_579273 != nil:
    section.add "quotaUser", valid_579273
  var valid_579274 = query.getOrDefault("pageToken")
  valid_579274 = validateParameter(valid_579274, JString, required = false,
                                 default = nil)
  if valid_579274 != nil:
    section.add "pageToken", valid_579274
  var valid_579275 = query.getOrDefault("fields")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = nil)
  if valid_579275 != nil:
    section.add "fields", valid_579275
  var valid_579276 = query.getOrDefault("maxResults")
  valid_579276 = validateParameter(valid_579276, JInt, required = false, default = nil)
  if valid_579276 != nil:
    section.add "maxResults", valid_579276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579277: Call_ContentAccounttaxList_579264; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the tax settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_579277.validator(path, query, header, formData, body)
  let scheme = call_579277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579277.url(scheme.get, call_579277.host, call_579277.base,
                         call_579277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579277, url, valid)

proc call*(call_579278: Call_ContentAccounttaxList_579264; merchantId: string;
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
  var path_579279 = newJObject()
  var query_579280 = newJObject()
  add(query_579280, "key", newJString(key))
  add(query_579280, "prettyPrint", newJBool(prettyPrint))
  add(query_579280, "oauth_token", newJString(oauthToken))
  add(query_579280, "alt", newJString(alt))
  add(query_579280, "userIp", newJString(userIp))
  add(query_579280, "quotaUser", newJString(quotaUser))
  add(path_579279, "merchantId", newJString(merchantId))
  add(query_579280, "pageToken", newJString(pageToken))
  add(query_579280, "fields", newJString(fields))
  add(query_579280, "maxResults", newJInt(maxResults))
  result = call_579278.call(path_579279, query_579280, nil, nil, nil)

var contentAccounttaxList* = Call_ContentAccounttaxList_579264(
    name: "contentAccounttaxList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax",
    validator: validate_ContentAccounttaxList_579265, base: "/content/v2.1",
    url: url_ContentAccounttaxList_579266, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxUpdate_579297 = ref object of OpenApiRestCall_578348
proc url_ContentAccounttaxUpdate_579299(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccounttaxUpdate_579298(path: JsonNode; query: JsonNode;
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
  var valid_579300 = path.getOrDefault("merchantId")
  valid_579300 = validateParameter(valid_579300, JString, required = true,
                                 default = nil)
  if valid_579300 != nil:
    section.add "merchantId", valid_579300
  var valid_579301 = path.getOrDefault("accountId")
  valid_579301 = validateParameter(valid_579301, JString, required = true,
                                 default = nil)
  if valid_579301 != nil:
    section.add "accountId", valid_579301
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579302 = query.getOrDefault("key")
  valid_579302 = validateParameter(valid_579302, JString, required = false,
                                 default = nil)
  if valid_579302 != nil:
    section.add "key", valid_579302
  var valid_579303 = query.getOrDefault("prettyPrint")
  valid_579303 = validateParameter(valid_579303, JBool, required = false,
                                 default = newJBool(true))
  if valid_579303 != nil:
    section.add "prettyPrint", valid_579303
  var valid_579304 = query.getOrDefault("oauth_token")
  valid_579304 = validateParameter(valid_579304, JString, required = false,
                                 default = nil)
  if valid_579304 != nil:
    section.add "oauth_token", valid_579304
  var valid_579305 = query.getOrDefault("alt")
  valid_579305 = validateParameter(valid_579305, JString, required = false,
                                 default = newJString("json"))
  if valid_579305 != nil:
    section.add "alt", valid_579305
  var valid_579306 = query.getOrDefault("userIp")
  valid_579306 = validateParameter(valid_579306, JString, required = false,
                                 default = nil)
  if valid_579306 != nil:
    section.add "userIp", valid_579306
  var valid_579307 = query.getOrDefault("quotaUser")
  valid_579307 = validateParameter(valid_579307, JString, required = false,
                                 default = nil)
  if valid_579307 != nil:
    section.add "quotaUser", valid_579307
  var valid_579308 = query.getOrDefault("fields")
  valid_579308 = validateParameter(valid_579308, JString, required = false,
                                 default = nil)
  if valid_579308 != nil:
    section.add "fields", valid_579308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579310: Call_ContentAccounttaxUpdate_579297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the tax settings of the account.
  ## 
  let valid = call_579310.validator(path, query, header, formData, body)
  let scheme = call_579310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579310.url(scheme.get, call_579310.host, call_579310.base,
                         call_579310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579310, url, valid)

proc call*(call_579311: Call_ContentAccounttaxUpdate_579297; merchantId: string;
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
  var path_579312 = newJObject()
  var query_579313 = newJObject()
  var body_579314 = newJObject()
  add(query_579313, "key", newJString(key))
  add(query_579313, "prettyPrint", newJBool(prettyPrint))
  add(query_579313, "oauth_token", newJString(oauthToken))
  add(query_579313, "alt", newJString(alt))
  add(query_579313, "userIp", newJString(userIp))
  add(query_579313, "quotaUser", newJString(quotaUser))
  add(path_579312, "merchantId", newJString(merchantId))
  if body != nil:
    body_579314 = body
  add(path_579312, "accountId", newJString(accountId))
  add(query_579313, "fields", newJString(fields))
  result = call_579311.call(path_579312, query_579313, nil, nil, body_579314)

var contentAccounttaxUpdate* = Call_ContentAccounttaxUpdate_579297(
    name: "contentAccounttaxUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax/{accountId}",
    validator: validate_ContentAccounttaxUpdate_579298, base: "/content/v2.1",
    url: url_ContentAccounttaxUpdate_579299, schemes: {Scheme.Https})
type
  Call_ContentAccounttaxGet_579281 = ref object of OpenApiRestCall_578348
proc url_ContentAccounttaxGet_579283(protocol: Scheme; host: string; base: string;
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

proc validate_ContentAccounttaxGet_579282(path: JsonNode; query: JsonNode;
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
  var valid_579284 = path.getOrDefault("merchantId")
  valid_579284 = validateParameter(valid_579284, JString, required = true,
                                 default = nil)
  if valid_579284 != nil:
    section.add "merchantId", valid_579284
  var valid_579285 = path.getOrDefault("accountId")
  valid_579285 = validateParameter(valid_579285, JString, required = true,
                                 default = nil)
  if valid_579285 != nil:
    section.add "accountId", valid_579285
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579286 = query.getOrDefault("key")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = nil)
  if valid_579286 != nil:
    section.add "key", valid_579286
  var valid_579287 = query.getOrDefault("prettyPrint")
  valid_579287 = validateParameter(valid_579287, JBool, required = false,
                                 default = newJBool(true))
  if valid_579287 != nil:
    section.add "prettyPrint", valid_579287
  var valid_579288 = query.getOrDefault("oauth_token")
  valid_579288 = validateParameter(valid_579288, JString, required = false,
                                 default = nil)
  if valid_579288 != nil:
    section.add "oauth_token", valid_579288
  var valid_579289 = query.getOrDefault("alt")
  valid_579289 = validateParameter(valid_579289, JString, required = false,
                                 default = newJString("json"))
  if valid_579289 != nil:
    section.add "alt", valid_579289
  var valid_579290 = query.getOrDefault("userIp")
  valid_579290 = validateParameter(valid_579290, JString, required = false,
                                 default = nil)
  if valid_579290 != nil:
    section.add "userIp", valid_579290
  var valid_579291 = query.getOrDefault("quotaUser")
  valid_579291 = validateParameter(valid_579291, JString, required = false,
                                 default = nil)
  if valid_579291 != nil:
    section.add "quotaUser", valid_579291
  var valid_579292 = query.getOrDefault("fields")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = nil)
  if valid_579292 != nil:
    section.add "fields", valid_579292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579293: Call_ContentAccounttaxGet_579281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the tax settings of the account.
  ## 
  let valid = call_579293.validator(path, query, header, formData, body)
  let scheme = call_579293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579293.url(scheme.get, call_579293.host, call_579293.base,
                         call_579293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579293, url, valid)

proc call*(call_579294: Call_ContentAccounttaxGet_579281; merchantId: string;
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
  var path_579295 = newJObject()
  var query_579296 = newJObject()
  add(query_579296, "key", newJString(key))
  add(query_579296, "prettyPrint", newJBool(prettyPrint))
  add(query_579296, "oauth_token", newJString(oauthToken))
  add(query_579296, "alt", newJString(alt))
  add(query_579296, "userIp", newJString(userIp))
  add(query_579296, "quotaUser", newJString(quotaUser))
  add(path_579295, "merchantId", newJString(merchantId))
  add(path_579295, "accountId", newJString(accountId))
  add(query_579296, "fields", newJString(fields))
  result = call_579294.call(path_579295, query_579296, nil, nil, nil)

var contentAccounttaxGet* = Call_ContentAccounttaxGet_579281(
    name: "contentAccounttaxGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/accounttax/{accountId}",
    validator: validate_ContentAccounttaxGet_579282, base: "/content/v2.1",
    url: url_ContentAccounttaxGet_579283, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsInsert_579332 = ref object of OpenApiRestCall_578348
proc url_ContentDatafeedsInsert_579334(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsInsert_579333(path: JsonNode; query: JsonNode;
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
  var valid_579335 = path.getOrDefault("merchantId")
  valid_579335 = validateParameter(valid_579335, JString, required = true,
                                 default = nil)
  if valid_579335 != nil:
    section.add "merchantId", valid_579335
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579342 = query.getOrDefault("fields")
  valid_579342 = validateParameter(valid_579342, JString, required = false,
                                 default = nil)
  if valid_579342 != nil:
    section.add "fields", valid_579342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579344: Call_ContentDatafeedsInsert_579332; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers a datafeed configuration with your Merchant Center account.
  ## 
  let valid = call_579344.validator(path, query, header, formData, body)
  let scheme = call_579344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579344.url(scheme.get, call_579344.host, call_579344.base,
                         call_579344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579344, url, valid)

proc call*(call_579345: Call_ContentDatafeedsInsert_579332; merchantId: string;
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
  var path_579346 = newJObject()
  var query_579347 = newJObject()
  var body_579348 = newJObject()
  add(query_579347, "key", newJString(key))
  add(query_579347, "prettyPrint", newJBool(prettyPrint))
  add(query_579347, "oauth_token", newJString(oauthToken))
  add(query_579347, "alt", newJString(alt))
  add(query_579347, "userIp", newJString(userIp))
  add(query_579347, "quotaUser", newJString(quotaUser))
  add(path_579346, "merchantId", newJString(merchantId))
  if body != nil:
    body_579348 = body
  add(query_579347, "fields", newJString(fields))
  result = call_579345.call(path_579346, query_579347, nil, nil, body_579348)

var contentDatafeedsInsert* = Call_ContentDatafeedsInsert_579332(
    name: "contentDatafeedsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds",
    validator: validate_ContentDatafeedsInsert_579333, base: "/content/v2.1",
    url: url_ContentDatafeedsInsert_579334, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsList_579315 = ref object of OpenApiRestCall_578348
proc url_ContentDatafeedsList_579317(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsList_579316(path: JsonNode; query: JsonNode;
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
  var valid_579318 = path.getOrDefault("merchantId")
  valid_579318 = validateParameter(valid_579318, JString, required = true,
                                 default = nil)
  if valid_579318 != nil:
    section.add "merchantId", valid_579318
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579319 = query.getOrDefault("key")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = nil)
  if valid_579319 != nil:
    section.add "key", valid_579319
  var valid_579320 = query.getOrDefault("prettyPrint")
  valid_579320 = validateParameter(valid_579320, JBool, required = false,
                                 default = newJBool(true))
  if valid_579320 != nil:
    section.add "prettyPrint", valid_579320
  var valid_579321 = query.getOrDefault("oauth_token")
  valid_579321 = validateParameter(valid_579321, JString, required = false,
                                 default = nil)
  if valid_579321 != nil:
    section.add "oauth_token", valid_579321
  var valid_579322 = query.getOrDefault("alt")
  valid_579322 = validateParameter(valid_579322, JString, required = false,
                                 default = newJString("json"))
  if valid_579322 != nil:
    section.add "alt", valid_579322
  var valid_579323 = query.getOrDefault("userIp")
  valid_579323 = validateParameter(valid_579323, JString, required = false,
                                 default = nil)
  if valid_579323 != nil:
    section.add "userIp", valid_579323
  var valid_579324 = query.getOrDefault("quotaUser")
  valid_579324 = validateParameter(valid_579324, JString, required = false,
                                 default = nil)
  if valid_579324 != nil:
    section.add "quotaUser", valid_579324
  var valid_579325 = query.getOrDefault("pageToken")
  valid_579325 = validateParameter(valid_579325, JString, required = false,
                                 default = nil)
  if valid_579325 != nil:
    section.add "pageToken", valid_579325
  var valid_579326 = query.getOrDefault("fields")
  valid_579326 = validateParameter(valid_579326, JString, required = false,
                                 default = nil)
  if valid_579326 != nil:
    section.add "fields", valid_579326
  var valid_579327 = query.getOrDefault("maxResults")
  valid_579327 = validateParameter(valid_579327, JInt, required = false, default = nil)
  if valid_579327 != nil:
    section.add "maxResults", valid_579327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579328: Call_ContentDatafeedsList_579315; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the configurations for datafeeds in your Merchant Center account.
  ## 
  let valid = call_579328.validator(path, query, header, formData, body)
  let scheme = call_579328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579328.url(scheme.get, call_579328.host, call_579328.base,
                         call_579328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579328, url, valid)

proc call*(call_579329: Call_ContentDatafeedsList_579315; merchantId: string;
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
  var path_579330 = newJObject()
  var query_579331 = newJObject()
  add(query_579331, "key", newJString(key))
  add(query_579331, "prettyPrint", newJBool(prettyPrint))
  add(query_579331, "oauth_token", newJString(oauthToken))
  add(query_579331, "alt", newJString(alt))
  add(query_579331, "userIp", newJString(userIp))
  add(query_579331, "quotaUser", newJString(quotaUser))
  add(path_579330, "merchantId", newJString(merchantId))
  add(query_579331, "pageToken", newJString(pageToken))
  add(query_579331, "fields", newJString(fields))
  add(query_579331, "maxResults", newJInt(maxResults))
  result = call_579329.call(path_579330, query_579331, nil, nil, nil)

var contentDatafeedsList* = Call_ContentDatafeedsList_579315(
    name: "contentDatafeedsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds",
    validator: validate_ContentDatafeedsList_579316, base: "/content/v2.1",
    url: url_ContentDatafeedsList_579317, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsUpdate_579365 = ref object of OpenApiRestCall_578348
proc url_ContentDatafeedsUpdate_579367(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsUpdate_579366(path: JsonNode; query: JsonNode;
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
  var valid_579368 = path.getOrDefault("merchantId")
  valid_579368 = validateParameter(valid_579368, JString, required = true,
                                 default = nil)
  if valid_579368 != nil:
    section.add "merchantId", valid_579368
  var valid_579369 = path.getOrDefault("datafeedId")
  valid_579369 = validateParameter(valid_579369, JString, required = true,
                                 default = nil)
  if valid_579369 != nil:
    section.add "datafeedId", valid_579369
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579370 = query.getOrDefault("key")
  valid_579370 = validateParameter(valid_579370, JString, required = false,
                                 default = nil)
  if valid_579370 != nil:
    section.add "key", valid_579370
  var valid_579371 = query.getOrDefault("prettyPrint")
  valid_579371 = validateParameter(valid_579371, JBool, required = false,
                                 default = newJBool(true))
  if valid_579371 != nil:
    section.add "prettyPrint", valid_579371
  var valid_579372 = query.getOrDefault("oauth_token")
  valid_579372 = validateParameter(valid_579372, JString, required = false,
                                 default = nil)
  if valid_579372 != nil:
    section.add "oauth_token", valid_579372
  var valid_579373 = query.getOrDefault("alt")
  valid_579373 = validateParameter(valid_579373, JString, required = false,
                                 default = newJString("json"))
  if valid_579373 != nil:
    section.add "alt", valid_579373
  var valid_579374 = query.getOrDefault("userIp")
  valid_579374 = validateParameter(valid_579374, JString, required = false,
                                 default = nil)
  if valid_579374 != nil:
    section.add "userIp", valid_579374
  var valid_579375 = query.getOrDefault("quotaUser")
  valid_579375 = validateParameter(valid_579375, JString, required = false,
                                 default = nil)
  if valid_579375 != nil:
    section.add "quotaUser", valid_579375
  var valid_579376 = query.getOrDefault("fields")
  valid_579376 = validateParameter(valid_579376, JString, required = false,
                                 default = nil)
  if valid_579376 != nil:
    section.add "fields", valid_579376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579378: Call_ContentDatafeedsUpdate_579365; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a datafeed configuration of your Merchant Center account.
  ## 
  let valid = call_579378.validator(path, query, header, formData, body)
  let scheme = call_579378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579378.url(scheme.get, call_579378.host, call_579378.base,
                         call_579378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579378, url, valid)

proc call*(call_579379: Call_ContentDatafeedsUpdate_579365; merchantId: string;
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
  var path_579380 = newJObject()
  var query_579381 = newJObject()
  var body_579382 = newJObject()
  add(query_579381, "key", newJString(key))
  add(query_579381, "prettyPrint", newJBool(prettyPrint))
  add(query_579381, "oauth_token", newJString(oauthToken))
  add(query_579381, "alt", newJString(alt))
  add(query_579381, "userIp", newJString(userIp))
  add(query_579381, "quotaUser", newJString(quotaUser))
  add(path_579380, "merchantId", newJString(merchantId))
  if body != nil:
    body_579382 = body
  add(path_579380, "datafeedId", newJString(datafeedId))
  add(query_579381, "fields", newJString(fields))
  result = call_579379.call(path_579380, query_579381, nil, nil, body_579382)

var contentDatafeedsUpdate* = Call_ContentDatafeedsUpdate_579365(
    name: "contentDatafeedsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsUpdate_579366, base: "/content/v2.1",
    url: url_ContentDatafeedsUpdate_579367, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsGet_579349 = ref object of OpenApiRestCall_578348
proc url_ContentDatafeedsGet_579351(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsGet_579350(path: JsonNode; query: JsonNode;
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
  var valid_579352 = path.getOrDefault("merchantId")
  valid_579352 = validateParameter(valid_579352, JString, required = true,
                                 default = nil)
  if valid_579352 != nil:
    section.add "merchantId", valid_579352
  var valid_579353 = path.getOrDefault("datafeedId")
  valid_579353 = validateParameter(valid_579353, JString, required = true,
                                 default = nil)
  if valid_579353 != nil:
    section.add "datafeedId", valid_579353
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579360 = query.getOrDefault("fields")
  valid_579360 = validateParameter(valid_579360, JString, required = false,
                                 default = nil)
  if valid_579360 != nil:
    section.add "fields", valid_579360
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579361: Call_ContentDatafeedsGet_579349; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a datafeed configuration from your Merchant Center account.
  ## 
  let valid = call_579361.validator(path, query, header, formData, body)
  let scheme = call_579361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579361.url(scheme.get, call_579361.host, call_579361.base,
                         call_579361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579361, url, valid)

proc call*(call_579362: Call_ContentDatafeedsGet_579349; merchantId: string;
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
  var path_579363 = newJObject()
  var query_579364 = newJObject()
  add(query_579364, "key", newJString(key))
  add(query_579364, "prettyPrint", newJBool(prettyPrint))
  add(query_579364, "oauth_token", newJString(oauthToken))
  add(query_579364, "alt", newJString(alt))
  add(query_579364, "userIp", newJString(userIp))
  add(query_579364, "quotaUser", newJString(quotaUser))
  add(path_579363, "merchantId", newJString(merchantId))
  add(path_579363, "datafeedId", newJString(datafeedId))
  add(query_579364, "fields", newJString(fields))
  result = call_579362.call(path_579363, query_579364, nil, nil, nil)

var contentDatafeedsGet* = Call_ContentDatafeedsGet_579349(
    name: "contentDatafeedsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsGet_579350, base: "/content/v2.1",
    url: url_ContentDatafeedsGet_579351, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsDelete_579383 = ref object of OpenApiRestCall_578348
proc url_ContentDatafeedsDelete_579385(protocol: Scheme; host: string; base: string;
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

proc validate_ContentDatafeedsDelete_579384(path: JsonNode; query: JsonNode;
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
  var valid_579386 = path.getOrDefault("merchantId")
  valid_579386 = validateParameter(valid_579386, JString, required = true,
                                 default = nil)
  if valid_579386 != nil:
    section.add "merchantId", valid_579386
  var valid_579387 = path.getOrDefault("datafeedId")
  valid_579387 = validateParameter(valid_579387, JString, required = true,
                                 default = nil)
  if valid_579387 != nil:
    section.add "datafeedId", valid_579387
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579388 = query.getOrDefault("key")
  valid_579388 = validateParameter(valid_579388, JString, required = false,
                                 default = nil)
  if valid_579388 != nil:
    section.add "key", valid_579388
  var valid_579389 = query.getOrDefault("prettyPrint")
  valid_579389 = validateParameter(valid_579389, JBool, required = false,
                                 default = newJBool(true))
  if valid_579389 != nil:
    section.add "prettyPrint", valid_579389
  var valid_579390 = query.getOrDefault("oauth_token")
  valid_579390 = validateParameter(valid_579390, JString, required = false,
                                 default = nil)
  if valid_579390 != nil:
    section.add "oauth_token", valid_579390
  var valid_579391 = query.getOrDefault("alt")
  valid_579391 = validateParameter(valid_579391, JString, required = false,
                                 default = newJString("json"))
  if valid_579391 != nil:
    section.add "alt", valid_579391
  var valid_579392 = query.getOrDefault("userIp")
  valid_579392 = validateParameter(valid_579392, JString, required = false,
                                 default = nil)
  if valid_579392 != nil:
    section.add "userIp", valid_579392
  var valid_579393 = query.getOrDefault("quotaUser")
  valid_579393 = validateParameter(valid_579393, JString, required = false,
                                 default = nil)
  if valid_579393 != nil:
    section.add "quotaUser", valid_579393
  var valid_579394 = query.getOrDefault("fields")
  valid_579394 = validateParameter(valid_579394, JString, required = false,
                                 default = nil)
  if valid_579394 != nil:
    section.add "fields", valid_579394
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579395: Call_ContentDatafeedsDelete_579383; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a datafeed configuration from your Merchant Center account.
  ## 
  let valid = call_579395.validator(path, query, header, formData, body)
  let scheme = call_579395.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579395.url(scheme.get, call_579395.host, call_579395.base,
                         call_579395.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579395, url, valid)

proc call*(call_579396: Call_ContentDatafeedsDelete_579383; merchantId: string;
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
  var path_579397 = newJObject()
  var query_579398 = newJObject()
  add(query_579398, "key", newJString(key))
  add(query_579398, "prettyPrint", newJBool(prettyPrint))
  add(query_579398, "oauth_token", newJString(oauthToken))
  add(query_579398, "alt", newJString(alt))
  add(query_579398, "userIp", newJString(userIp))
  add(query_579398, "quotaUser", newJString(quotaUser))
  add(path_579397, "merchantId", newJString(merchantId))
  add(path_579397, "datafeedId", newJString(datafeedId))
  add(query_579398, "fields", newJString(fields))
  result = call_579396.call(path_579397, query_579398, nil, nil, nil)

var contentDatafeedsDelete* = Call_ContentDatafeedsDelete_579383(
    name: "contentDatafeedsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/datafeeds/{datafeedId}",
    validator: validate_ContentDatafeedsDelete_579384, base: "/content/v2.1",
    url: url_ContentDatafeedsDelete_579385, schemes: {Scheme.Https})
type
  Call_ContentDatafeedsFetchnow_579399 = ref object of OpenApiRestCall_578348
proc url_ContentDatafeedsFetchnow_579401(protocol: Scheme; host: string;
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

proc validate_ContentDatafeedsFetchnow_579400(path: JsonNode; query: JsonNode;
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
  var valid_579402 = path.getOrDefault("merchantId")
  valid_579402 = validateParameter(valid_579402, JString, required = true,
                                 default = nil)
  if valid_579402 != nil:
    section.add "merchantId", valid_579402
  var valid_579403 = path.getOrDefault("datafeedId")
  valid_579403 = validateParameter(valid_579403, JString, required = true,
                                 default = nil)
  if valid_579403 != nil:
    section.add "datafeedId", valid_579403
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579404 = query.getOrDefault("key")
  valid_579404 = validateParameter(valid_579404, JString, required = false,
                                 default = nil)
  if valid_579404 != nil:
    section.add "key", valid_579404
  var valid_579405 = query.getOrDefault("prettyPrint")
  valid_579405 = validateParameter(valid_579405, JBool, required = false,
                                 default = newJBool(true))
  if valid_579405 != nil:
    section.add "prettyPrint", valid_579405
  var valid_579406 = query.getOrDefault("oauth_token")
  valid_579406 = validateParameter(valid_579406, JString, required = false,
                                 default = nil)
  if valid_579406 != nil:
    section.add "oauth_token", valid_579406
  var valid_579407 = query.getOrDefault("alt")
  valid_579407 = validateParameter(valid_579407, JString, required = false,
                                 default = newJString("json"))
  if valid_579407 != nil:
    section.add "alt", valid_579407
  var valid_579408 = query.getOrDefault("userIp")
  valid_579408 = validateParameter(valid_579408, JString, required = false,
                                 default = nil)
  if valid_579408 != nil:
    section.add "userIp", valid_579408
  var valid_579409 = query.getOrDefault("quotaUser")
  valid_579409 = validateParameter(valid_579409, JString, required = false,
                                 default = nil)
  if valid_579409 != nil:
    section.add "quotaUser", valid_579409
  var valid_579410 = query.getOrDefault("fields")
  valid_579410 = validateParameter(valid_579410, JString, required = false,
                                 default = nil)
  if valid_579410 != nil:
    section.add "fields", valid_579410
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579411: Call_ContentDatafeedsFetchnow_579399; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Invokes a fetch for the datafeed in your Merchant Center account.
  ## 
  let valid = call_579411.validator(path, query, header, formData, body)
  let scheme = call_579411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579411.url(scheme.get, call_579411.host, call_579411.base,
                         call_579411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579411, url, valid)

proc call*(call_579412: Call_ContentDatafeedsFetchnow_579399; merchantId: string;
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
  var path_579413 = newJObject()
  var query_579414 = newJObject()
  add(query_579414, "key", newJString(key))
  add(query_579414, "prettyPrint", newJBool(prettyPrint))
  add(query_579414, "oauth_token", newJString(oauthToken))
  add(query_579414, "alt", newJString(alt))
  add(query_579414, "userIp", newJString(userIp))
  add(query_579414, "quotaUser", newJString(quotaUser))
  add(path_579413, "merchantId", newJString(merchantId))
  add(path_579413, "datafeedId", newJString(datafeedId))
  add(query_579414, "fields", newJString(fields))
  result = call_579412.call(path_579413, query_579414, nil, nil, nil)

var contentDatafeedsFetchnow* = Call_ContentDatafeedsFetchnow_579399(
    name: "contentDatafeedsFetchnow", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/datafeeds/{datafeedId}/fetchNow",
    validator: validate_ContentDatafeedsFetchnow_579400, base: "/content/v2.1",
    url: url_ContentDatafeedsFetchnow_579401, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesList_579415 = ref object of OpenApiRestCall_578348
proc url_ContentDatafeedstatusesList_579417(protocol: Scheme; host: string;
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

proc validate_ContentDatafeedstatusesList_579416(path: JsonNode; query: JsonNode;
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
  var valid_579418 = path.getOrDefault("merchantId")
  valid_579418 = validateParameter(valid_579418, JString, required = true,
                                 default = nil)
  if valid_579418 != nil:
    section.add "merchantId", valid_579418
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579419 = query.getOrDefault("key")
  valid_579419 = validateParameter(valid_579419, JString, required = false,
                                 default = nil)
  if valid_579419 != nil:
    section.add "key", valid_579419
  var valid_579420 = query.getOrDefault("prettyPrint")
  valid_579420 = validateParameter(valid_579420, JBool, required = false,
                                 default = newJBool(true))
  if valid_579420 != nil:
    section.add "prettyPrint", valid_579420
  var valid_579421 = query.getOrDefault("oauth_token")
  valid_579421 = validateParameter(valid_579421, JString, required = false,
                                 default = nil)
  if valid_579421 != nil:
    section.add "oauth_token", valid_579421
  var valid_579422 = query.getOrDefault("alt")
  valid_579422 = validateParameter(valid_579422, JString, required = false,
                                 default = newJString("json"))
  if valid_579422 != nil:
    section.add "alt", valid_579422
  var valid_579423 = query.getOrDefault("userIp")
  valid_579423 = validateParameter(valid_579423, JString, required = false,
                                 default = nil)
  if valid_579423 != nil:
    section.add "userIp", valid_579423
  var valid_579424 = query.getOrDefault("quotaUser")
  valid_579424 = validateParameter(valid_579424, JString, required = false,
                                 default = nil)
  if valid_579424 != nil:
    section.add "quotaUser", valid_579424
  var valid_579425 = query.getOrDefault("pageToken")
  valid_579425 = validateParameter(valid_579425, JString, required = false,
                                 default = nil)
  if valid_579425 != nil:
    section.add "pageToken", valid_579425
  var valid_579426 = query.getOrDefault("fields")
  valid_579426 = validateParameter(valid_579426, JString, required = false,
                                 default = nil)
  if valid_579426 != nil:
    section.add "fields", valid_579426
  var valid_579427 = query.getOrDefault("maxResults")
  valid_579427 = validateParameter(valid_579427, JInt, required = false, default = nil)
  if valid_579427 != nil:
    section.add "maxResults", valid_579427
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579428: Call_ContentDatafeedstatusesList_579415; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the datafeeds in your Merchant Center account.
  ## 
  let valid = call_579428.validator(path, query, header, formData, body)
  let scheme = call_579428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579428.url(scheme.get, call_579428.host, call_579428.base,
                         call_579428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579428, url, valid)

proc call*(call_579429: Call_ContentDatafeedstatusesList_579415;
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
  var path_579430 = newJObject()
  var query_579431 = newJObject()
  add(query_579431, "key", newJString(key))
  add(query_579431, "prettyPrint", newJBool(prettyPrint))
  add(query_579431, "oauth_token", newJString(oauthToken))
  add(query_579431, "alt", newJString(alt))
  add(query_579431, "userIp", newJString(userIp))
  add(query_579431, "quotaUser", newJString(quotaUser))
  add(path_579430, "merchantId", newJString(merchantId))
  add(query_579431, "pageToken", newJString(pageToken))
  add(query_579431, "fields", newJString(fields))
  add(query_579431, "maxResults", newJInt(maxResults))
  result = call_579429.call(path_579430, query_579431, nil, nil, nil)

var contentDatafeedstatusesList* = Call_ContentDatafeedstatusesList_579415(
    name: "contentDatafeedstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/datafeedstatuses",
    validator: validate_ContentDatafeedstatusesList_579416, base: "/content/v2.1",
    url: url_ContentDatafeedstatusesList_579417, schemes: {Scheme.Https})
type
  Call_ContentDatafeedstatusesGet_579432 = ref object of OpenApiRestCall_578348
proc url_ContentDatafeedstatusesGet_579434(protocol: Scheme; host: string;
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

proc validate_ContentDatafeedstatusesGet_579433(path: JsonNode; query: JsonNode;
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
  var valid_579435 = path.getOrDefault("merchantId")
  valid_579435 = validateParameter(valid_579435, JString, required = true,
                                 default = nil)
  if valid_579435 != nil:
    section.add "merchantId", valid_579435
  var valid_579436 = path.getOrDefault("datafeedId")
  valid_579436 = validateParameter(valid_579436, JString, required = true,
                                 default = nil)
  if valid_579436 != nil:
    section.add "datafeedId", valid_579436
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579437 = query.getOrDefault("key")
  valid_579437 = validateParameter(valid_579437, JString, required = false,
                                 default = nil)
  if valid_579437 != nil:
    section.add "key", valid_579437
  var valid_579438 = query.getOrDefault("prettyPrint")
  valid_579438 = validateParameter(valid_579438, JBool, required = false,
                                 default = newJBool(true))
  if valid_579438 != nil:
    section.add "prettyPrint", valid_579438
  var valid_579439 = query.getOrDefault("oauth_token")
  valid_579439 = validateParameter(valid_579439, JString, required = false,
                                 default = nil)
  if valid_579439 != nil:
    section.add "oauth_token", valid_579439
  var valid_579440 = query.getOrDefault("alt")
  valid_579440 = validateParameter(valid_579440, JString, required = false,
                                 default = newJString("json"))
  if valid_579440 != nil:
    section.add "alt", valid_579440
  var valid_579441 = query.getOrDefault("userIp")
  valid_579441 = validateParameter(valid_579441, JString, required = false,
                                 default = nil)
  if valid_579441 != nil:
    section.add "userIp", valid_579441
  var valid_579442 = query.getOrDefault("quotaUser")
  valid_579442 = validateParameter(valid_579442, JString, required = false,
                                 default = nil)
  if valid_579442 != nil:
    section.add "quotaUser", valid_579442
  var valid_579443 = query.getOrDefault("country")
  valid_579443 = validateParameter(valid_579443, JString, required = false,
                                 default = nil)
  if valid_579443 != nil:
    section.add "country", valid_579443
  var valid_579444 = query.getOrDefault("fields")
  valid_579444 = validateParameter(valid_579444, JString, required = false,
                                 default = nil)
  if valid_579444 != nil:
    section.add "fields", valid_579444
  var valid_579445 = query.getOrDefault("language")
  valid_579445 = validateParameter(valid_579445, JString, required = false,
                                 default = nil)
  if valid_579445 != nil:
    section.add "language", valid_579445
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579446: Call_ContentDatafeedstatusesGet_579432; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the status of a datafeed from your Merchant Center account.
  ## 
  let valid = call_579446.validator(path, query, header, formData, body)
  let scheme = call_579446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579446.url(scheme.get, call_579446.host, call_579446.base,
                         call_579446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579446, url, valid)

proc call*(call_579447: Call_ContentDatafeedstatusesGet_579432; merchantId: string;
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
  var path_579448 = newJObject()
  var query_579449 = newJObject()
  add(query_579449, "key", newJString(key))
  add(query_579449, "prettyPrint", newJBool(prettyPrint))
  add(query_579449, "oauth_token", newJString(oauthToken))
  add(query_579449, "alt", newJString(alt))
  add(query_579449, "userIp", newJString(userIp))
  add(query_579449, "quotaUser", newJString(quotaUser))
  add(path_579448, "merchantId", newJString(merchantId))
  add(query_579449, "country", newJString(country))
  add(path_579448, "datafeedId", newJString(datafeedId))
  add(query_579449, "fields", newJString(fields))
  add(query_579449, "language", newJString(language))
  result = call_579447.call(path_579448, query_579449, nil, nil, nil)

var contentDatafeedstatusesGet* = Call_ContentDatafeedstatusesGet_579432(
    name: "contentDatafeedstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/datafeedstatuses/{datafeedId}",
    validator: validate_ContentDatafeedstatusesGet_579433, base: "/content/v2.1",
    url: url_ContentDatafeedstatusesGet_579434, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsList_579450 = ref object of OpenApiRestCall_578348
proc url_ContentLiasettingsList_579452(protocol: Scheme; host: string; base: string;
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

proc validate_ContentLiasettingsList_579451(path: JsonNode; query: JsonNode;
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
  var valid_579453 = path.getOrDefault("merchantId")
  valid_579453 = validateParameter(valid_579453, JString, required = true,
                                 default = nil)
  if valid_579453 != nil:
    section.add "merchantId", valid_579453
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579454 = query.getOrDefault("key")
  valid_579454 = validateParameter(valid_579454, JString, required = false,
                                 default = nil)
  if valid_579454 != nil:
    section.add "key", valid_579454
  var valid_579455 = query.getOrDefault("prettyPrint")
  valid_579455 = validateParameter(valid_579455, JBool, required = false,
                                 default = newJBool(true))
  if valid_579455 != nil:
    section.add "prettyPrint", valid_579455
  var valid_579456 = query.getOrDefault("oauth_token")
  valid_579456 = validateParameter(valid_579456, JString, required = false,
                                 default = nil)
  if valid_579456 != nil:
    section.add "oauth_token", valid_579456
  var valid_579457 = query.getOrDefault("alt")
  valid_579457 = validateParameter(valid_579457, JString, required = false,
                                 default = newJString("json"))
  if valid_579457 != nil:
    section.add "alt", valid_579457
  var valid_579458 = query.getOrDefault("userIp")
  valid_579458 = validateParameter(valid_579458, JString, required = false,
                                 default = nil)
  if valid_579458 != nil:
    section.add "userIp", valid_579458
  var valid_579459 = query.getOrDefault("quotaUser")
  valid_579459 = validateParameter(valid_579459, JString, required = false,
                                 default = nil)
  if valid_579459 != nil:
    section.add "quotaUser", valid_579459
  var valid_579460 = query.getOrDefault("pageToken")
  valid_579460 = validateParameter(valid_579460, JString, required = false,
                                 default = nil)
  if valid_579460 != nil:
    section.add "pageToken", valid_579460
  var valid_579461 = query.getOrDefault("fields")
  valid_579461 = validateParameter(valid_579461, JString, required = false,
                                 default = nil)
  if valid_579461 != nil:
    section.add "fields", valid_579461
  var valid_579462 = query.getOrDefault("maxResults")
  valid_579462 = validateParameter(valid_579462, JInt, required = false, default = nil)
  if valid_579462 != nil:
    section.add "maxResults", valid_579462
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579463: Call_ContentLiasettingsList_579450; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the LIA settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_579463.validator(path, query, header, formData, body)
  let scheme = call_579463.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579463.url(scheme.get, call_579463.host, call_579463.base,
                         call_579463.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579463, url, valid)

proc call*(call_579464: Call_ContentLiasettingsList_579450; merchantId: string;
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
  var path_579465 = newJObject()
  var query_579466 = newJObject()
  add(query_579466, "key", newJString(key))
  add(query_579466, "prettyPrint", newJBool(prettyPrint))
  add(query_579466, "oauth_token", newJString(oauthToken))
  add(query_579466, "alt", newJString(alt))
  add(query_579466, "userIp", newJString(userIp))
  add(query_579466, "quotaUser", newJString(quotaUser))
  add(path_579465, "merchantId", newJString(merchantId))
  add(query_579466, "pageToken", newJString(pageToken))
  add(query_579466, "fields", newJString(fields))
  add(query_579466, "maxResults", newJInt(maxResults))
  result = call_579464.call(path_579465, query_579466, nil, nil, nil)

var contentLiasettingsList* = Call_ContentLiasettingsList_579450(
    name: "contentLiasettingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings",
    validator: validate_ContentLiasettingsList_579451, base: "/content/v2.1",
    url: url_ContentLiasettingsList_579452, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsUpdate_579483 = ref object of OpenApiRestCall_578348
proc url_ContentLiasettingsUpdate_579485(protocol: Scheme; host: string;
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

proc validate_ContentLiasettingsUpdate_579484(path: JsonNode; query: JsonNode;
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
  var valid_579486 = path.getOrDefault("merchantId")
  valid_579486 = validateParameter(valid_579486, JString, required = true,
                                 default = nil)
  if valid_579486 != nil:
    section.add "merchantId", valid_579486
  var valid_579487 = path.getOrDefault("accountId")
  valid_579487 = validateParameter(valid_579487, JString, required = true,
                                 default = nil)
  if valid_579487 != nil:
    section.add "accountId", valid_579487
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579488 = query.getOrDefault("key")
  valid_579488 = validateParameter(valid_579488, JString, required = false,
                                 default = nil)
  if valid_579488 != nil:
    section.add "key", valid_579488
  var valid_579489 = query.getOrDefault("prettyPrint")
  valid_579489 = validateParameter(valid_579489, JBool, required = false,
                                 default = newJBool(true))
  if valid_579489 != nil:
    section.add "prettyPrint", valid_579489
  var valid_579490 = query.getOrDefault("oauth_token")
  valid_579490 = validateParameter(valid_579490, JString, required = false,
                                 default = nil)
  if valid_579490 != nil:
    section.add "oauth_token", valid_579490
  var valid_579491 = query.getOrDefault("alt")
  valid_579491 = validateParameter(valid_579491, JString, required = false,
                                 default = newJString("json"))
  if valid_579491 != nil:
    section.add "alt", valid_579491
  var valid_579492 = query.getOrDefault("userIp")
  valid_579492 = validateParameter(valid_579492, JString, required = false,
                                 default = nil)
  if valid_579492 != nil:
    section.add "userIp", valid_579492
  var valid_579493 = query.getOrDefault("quotaUser")
  valid_579493 = validateParameter(valid_579493, JString, required = false,
                                 default = nil)
  if valid_579493 != nil:
    section.add "quotaUser", valid_579493
  var valid_579494 = query.getOrDefault("fields")
  valid_579494 = validateParameter(valid_579494, JString, required = false,
                                 default = nil)
  if valid_579494 != nil:
    section.add "fields", valid_579494
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579496: Call_ContentLiasettingsUpdate_579483; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the LIA settings of the account.
  ## 
  let valid = call_579496.validator(path, query, header, formData, body)
  let scheme = call_579496.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579496.url(scheme.get, call_579496.host, call_579496.base,
                         call_579496.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579496, url, valid)

proc call*(call_579497: Call_ContentLiasettingsUpdate_579483; merchantId: string;
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
  var path_579498 = newJObject()
  var query_579499 = newJObject()
  var body_579500 = newJObject()
  add(query_579499, "key", newJString(key))
  add(query_579499, "prettyPrint", newJBool(prettyPrint))
  add(query_579499, "oauth_token", newJString(oauthToken))
  add(query_579499, "alt", newJString(alt))
  add(query_579499, "userIp", newJString(userIp))
  add(query_579499, "quotaUser", newJString(quotaUser))
  add(path_579498, "merchantId", newJString(merchantId))
  if body != nil:
    body_579500 = body
  add(path_579498, "accountId", newJString(accountId))
  add(query_579499, "fields", newJString(fields))
  result = call_579497.call(path_579498, query_579499, nil, nil, body_579500)

var contentLiasettingsUpdate* = Call_ContentLiasettingsUpdate_579483(
    name: "contentLiasettingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}",
    validator: validate_ContentLiasettingsUpdate_579484, base: "/content/v2.1",
    url: url_ContentLiasettingsUpdate_579485, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsGet_579467 = ref object of OpenApiRestCall_578348
proc url_ContentLiasettingsGet_579469(protocol: Scheme; host: string; base: string;
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

proc validate_ContentLiasettingsGet_579468(path: JsonNode; query: JsonNode;
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
  var valid_579470 = path.getOrDefault("merchantId")
  valid_579470 = validateParameter(valid_579470, JString, required = true,
                                 default = nil)
  if valid_579470 != nil:
    section.add "merchantId", valid_579470
  var valid_579471 = path.getOrDefault("accountId")
  valid_579471 = validateParameter(valid_579471, JString, required = true,
                                 default = nil)
  if valid_579471 != nil:
    section.add "accountId", valid_579471
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579472 = query.getOrDefault("key")
  valid_579472 = validateParameter(valid_579472, JString, required = false,
                                 default = nil)
  if valid_579472 != nil:
    section.add "key", valid_579472
  var valid_579473 = query.getOrDefault("prettyPrint")
  valid_579473 = validateParameter(valid_579473, JBool, required = false,
                                 default = newJBool(true))
  if valid_579473 != nil:
    section.add "prettyPrint", valid_579473
  var valid_579474 = query.getOrDefault("oauth_token")
  valid_579474 = validateParameter(valid_579474, JString, required = false,
                                 default = nil)
  if valid_579474 != nil:
    section.add "oauth_token", valid_579474
  var valid_579475 = query.getOrDefault("alt")
  valid_579475 = validateParameter(valid_579475, JString, required = false,
                                 default = newJString("json"))
  if valid_579475 != nil:
    section.add "alt", valid_579475
  var valid_579476 = query.getOrDefault("userIp")
  valid_579476 = validateParameter(valid_579476, JString, required = false,
                                 default = nil)
  if valid_579476 != nil:
    section.add "userIp", valid_579476
  var valid_579477 = query.getOrDefault("quotaUser")
  valid_579477 = validateParameter(valid_579477, JString, required = false,
                                 default = nil)
  if valid_579477 != nil:
    section.add "quotaUser", valid_579477
  var valid_579478 = query.getOrDefault("fields")
  valid_579478 = validateParameter(valid_579478, JString, required = false,
                                 default = nil)
  if valid_579478 != nil:
    section.add "fields", valid_579478
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579479: Call_ContentLiasettingsGet_579467; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the LIA settings of the account.
  ## 
  let valid = call_579479.validator(path, query, header, formData, body)
  let scheme = call_579479.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579479.url(scheme.get, call_579479.host, call_579479.base,
                         call_579479.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579479, url, valid)

proc call*(call_579480: Call_ContentLiasettingsGet_579467; merchantId: string;
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
  var path_579481 = newJObject()
  var query_579482 = newJObject()
  add(query_579482, "key", newJString(key))
  add(query_579482, "prettyPrint", newJBool(prettyPrint))
  add(query_579482, "oauth_token", newJString(oauthToken))
  add(query_579482, "alt", newJString(alt))
  add(query_579482, "userIp", newJString(userIp))
  add(query_579482, "quotaUser", newJString(quotaUser))
  add(path_579481, "merchantId", newJString(merchantId))
  add(path_579481, "accountId", newJString(accountId))
  add(query_579482, "fields", newJString(fields))
  result = call_579480.call(path_579481, query_579482, nil, nil, nil)

var contentLiasettingsGet* = Call_ContentLiasettingsGet_579467(
    name: "contentLiasettingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}",
    validator: validate_ContentLiasettingsGet_579468, base: "/content/v2.1",
    url: url_ContentLiasettingsGet_579469, schemes: {Scheme.Https})
type
  Call_ContentLiasettingsGetaccessiblegmbaccounts_579501 = ref object of OpenApiRestCall_578348
proc url_ContentLiasettingsGetaccessiblegmbaccounts_579503(protocol: Scheme;
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

proc validate_ContentLiasettingsGetaccessiblegmbaccounts_579502(path: JsonNode;
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
  var valid_579504 = path.getOrDefault("merchantId")
  valid_579504 = validateParameter(valid_579504, JString, required = true,
                                 default = nil)
  if valid_579504 != nil:
    section.add "merchantId", valid_579504
  var valid_579505 = path.getOrDefault("accountId")
  valid_579505 = validateParameter(valid_579505, JString, required = true,
                                 default = nil)
  if valid_579505 != nil:
    section.add "accountId", valid_579505
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579506 = query.getOrDefault("key")
  valid_579506 = validateParameter(valid_579506, JString, required = false,
                                 default = nil)
  if valid_579506 != nil:
    section.add "key", valid_579506
  var valid_579507 = query.getOrDefault("prettyPrint")
  valid_579507 = validateParameter(valid_579507, JBool, required = false,
                                 default = newJBool(true))
  if valid_579507 != nil:
    section.add "prettyPrint", valid_579507
  var valid_579508 = query.getOrDefault("oauth_token")
  valid_579508 = validateParameter(valid_579508, JString, required = false,
                                 default = nil)
  if valid_579508 != nil:
    section.add "oauth_token", valid_579508
  var valid_579509 = query.getOrDefault("alt")
  valid_579509 = validateParameter(valid_579509, JString, required = false,
                                 default = newJString("json"))
  if valid_579509 != nil:
    section.add "alt", valid_579509
  var valid_579510 = query.getOrDefault("userIp")
  valid_579510 = validateParameter(valid_579510, JString, required = false,
                                 default = nil)
  if valid_579510 != nil:
    section.add "userIp", valid_579510
  var valid_579511 = query.getOrDefault("quotaUser")
  valid_579511 = validateParameter(valid_579511, JString, required = false,
                                 default = nil)
  if valid_579511 != nil:
    section.add "quotaUser", valid_579511
  var valid_579512 = query.getOrDefault("fields")
  valid_579512 = validateParameter(valid_579512, JString, required = false,
                                 default = nil)
  if valid_579512 != nil:
    section.add "fields", valid_579512
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579513: Call_ContentLiasettingsGetaccessiblegmbaccounts_579501;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of accessible Google My Business accounts.
  ## 
  let valid = call_579513.validator(path, query, header, formData, body)
  let scheme = call_579513.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579513.url(scheme.get, call_579513.host, call_579513.base,
                         call_579513.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579513, url, valid)

proc call*(call_579514: Call_ContentLiasettingsGetaccessiblegmbaccounts_579501;
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
  var path_579515 = newJObject()
  var query_579516 = newJObject()
  add(query_579516, "key", newJString(key))
  add(query_579516, "prettyPrint", newJBool(prettyPrint))
  add(query_579516, "oauth_token", newJString(oauthToken))
  add(query_579516, "alt", newJString(alt))
  add(query_579516, "userIp", newJString(userIp))
  add(query_579516, "quotaUser", newJString(quotaUser))
  add(path_579515, "merchantId", newJString(merchantId))
  add(path_579515, "accountId", newJString(accountId))
  add(query_579516, "fields", newJString(fields))
  result = call_579514.call(path_579515, query_579516, nil, nil, nil)

var contentLiasettingsGetaccessiblegmbaccounts* = Call_ContentLiasettingsGetaccessiblegmbaccounts_579501(
    name: "contentLiasettingsGetaccessiblegmbaccounts", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/accessiblegmbaccounts",
    validator: validate_ContentLiasettingsGetaccessiblegmbaccounts_579502,
    base: "/content/v2.1", url: url_ContentLiasettingsGetaccessiblegmbaccounts_579503,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsRequestgmbaccess_579517 = ref object of OpenApiRestCall_578348
proc url_ContentLiasettingsRequestgmbaccess_579519(protocol: Scheme; host: string;
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

proc validate_ContentLiasettingsRequestgmbaccess_579518(path: JsonNode;
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
  var valid_579520 = path.getOrDefault("merchantId")
  valid_579520 = validateParameter(valid_579520, JString, required = true,
                                 default = nil)
  if valid_579520 != nil:
    section.add "merchantId", valid_579520
  var valid_579521 = path.getOrDefault("accountId")
  valid_579521 = validateParameter(valid_579521, JString, required = true,
                                 default = nil)
  if valid_579521 != nil:
    section.add "accountId", valid_579521
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
  var valid_579522 = query.getOrDefault("key")
  valid_579522 = validateParameter(valid_579522, JString, required = false,
                                 default = nil)
  if valid_579522 != nil:
    section.add "key", valid_579522
  var valid_579523 = query.getOrDefault("prettyPrint")
  valid_579523 = validateParameter(valid_579523, JBool, required = false,
                                 default = newJBool(true))
  if valid_579523 != nil:
    section.add "prettyPrint", valid_579523
  var valid_579524 = query.getOrDefault("oauth_token")
  valid_579524 = validateParameter(valid_579524, JString, required = false,
                                 default = nil)
  if valid_579524 != nil:
    section.add "oauth_token", valid_579524
  assert query != nil,
        "query argument is necessary due to required `gmbEmail` field"
  var valid_579525 = query.getOrDefault("gmbEmail")
  valid_579525 = validateParameter(valid_579525, JString, required = true,
                                 default = nil)
  if valid_579525 != nil:
    section.add "gmbEmail", valid_579525
  var valid_579526 = query.getOrDefault("alt")
  valid_579526 = validateParameter(valid_579526, JString, required = false,
                                 default = newJString("json"))
  if valid_579526 != nil:
    section.add "alt", valid_579526
  var valid_579527 = query.getOrDefault("userIp")
  valid_579527 = validateParameter(valid_579527, JString, required = false,
                                 default = nil)
  if valid_579527 != nil:
    section.add "userIp", valid_579527
  var valid_579528 = query.getOrDefault("quotaUser")
  valid_579528 = validateParameter(valid_579528, JString, required = false,
                                 default = nil)
  if valid_579528 != nil:
    section.add "quotaUser", valid_579528
  var valid_579529 = query.getOrDefault("fields")
  valid_579529 = validateParameter(valid_579529, JString, required = false,
                                 default = nil)
  if valid_579529 != nil:
    section.add "fields", valid_579529
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579530: Call_ContentLiasettingsRequestgmbaccess_579517;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests access to a specified Google My Business account.
  ## 
  let valid = call_579530.validator(path, query, header, formData, body)
  let scheme = call_579530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579530.url(scheme.get, call_579530.host, call_579530.base,
                         call_579530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579530, url, valid)

proc call*(call_579531: Call_ContentLiasettingsRequestgmbaccess_579517;
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
  var path_579532 = newJObject()
  var query_579533 = newJObject()
  add(query_579533, "key", newJString(key))
  add(query_579533, "prettyPrint", newJBool(prettyPrint))
  add(query_579533, "oauth_token", newJString(oauthToken))
  add(query_579533, "gmbEmail", newJString(gmbEmail))
  add(query_579533, "alt", newJString(alt))
  add(query_579533, "userIp", newJString(userIp))
  add(query_579533, "quotaUser", newJString(quotaUser))
  add(path_579532, "merchantId", newJString(merchantId))
  add(path_579532, "accountId", newJString(accountId))
  add(query_579533, "fields", newJString(fields))
  result = call_579531.call(path_579532, query_579533, nil, nil, nil)

var contentLiasettingsRequestgmbaccess* = Call_ContentLiasettingsRequestgmbaccess_579517(
    name: "contentLiasettingsRequestgmbaccess", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/requestgmbaccess",
    validator: validate_ContentLiasettingsRequestgmbaccess_579518,
    base: "/content/v2.1", url: url_ContentLiasettingsRequestgmbaccess_579519,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsRequestinventoryverification_579534 = ref object of OpenApiRestCall_578348
proc url_ContentLiasettingsRequestinventoryverification_579536(protocol: Scheme;
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

proc validate_ContentLiasettingsRequestinventoryverification_579535(
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
  var valid_579537 = path.getOrDefault("merchantId")
  valid_579537 = validateParameter(valid_579537, JString, required = true,
                                 default = nil)
  if valid_579537 != nil:
    section.add "merchantId", valid_579537
  var valid_579538 = path.getOrDefault("country")
  valid_579538 = validateParameter(valid_579538, JString, required = true,
                                 default = nil)
  if valid_579538 != nil:
    section.add "country", valid_579538
  var valid_579539 = path.getOrDefault("accountId")
  valid_579539 = validateParameter(valid_579539, JString, required = true,
                                 default = nil)
  if valid_579539 != nil:
    section.add "accountId", valid_579539
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579540 = query.getOrDefault("key")
  valid_579540 = validateParameter(valid_579540, JString, required = false,
                                 default = nil)
  if valid_579540 != nil:
    section.add "key", valid_579540
  var valid_579541 = query.getOrDefault("prettyPrint")
  valid_579541 = validateParameter(valid_579541, JBool, required = false,
                                 default = newJBool(true))
  if valid_579541 != nil:
    section.add "prettyPrint", valid_579541
  var valid_579542 = query.getOrDefault("oauth_token")
  valid_579542 = validateParameter(valid_579542, JString, required = false,
                                 default = nil)
  if valid_579542 != nil:
    section.add "oauth_token", valid_579542
  var valid_579543 = query.getOrDefault("alt")
  valid_579543 = validateParameter(valid_579543, JString, required = false,
                                 default = newJString("json"))
  if valid_579543 != nil:
    section.add "alt", valid_579543
  var valid_579544 = query.getOrDefault("userIp")
  valid_579544 = validateParameter(valid_579544, JString, required = false,
                                 default = nil)
  if valid_579544 != nil:
    section.add "userIp", valid_579544
  var valid_579545 = query.getOrDefault("quotaUser")
  valid_579545 = validateParameter(valid_579545, JString, required = false,
                                 default = nil)
  if valid_579545 != nil:
    section.add "quotaUser", valid_579545
  var valid_579546 = query.getOrDefault("fields")
  valid_579546 = validateParameter(valid_579546, JString, required = false,
                                 default = nil)
  if valid_579546 != nil:
    section.add "fields", valid_579546
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579547: Call_ContentLiasettingsRequestinventoryverification_579534;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests inventory validation for the specified country.
  ## 
  let valid = call_579547.validator(path, query, header, formData, body)
  let scheme = call_579547.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579547.url(scheme.get, call_579547.host, call_579547.base,
                         call_579547.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579547, url, valid)

proc call*(call_579548: Call_ContentLiasettingsRequestinventoryverification_579534;
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
  var path_579549 = newJObject()
  var query_579550 = newJObject()
  add(query_579550, "key", newJString(key))
  add(query_579550, "prettyPrint", newJBool(prettyPrint))
  add(query_579550, "oauth_token", newJString(oauthToken))
  add(query_579550, "alt", newJString(alt))
  add(query_579550, "userIp", newJString(userIp))
  add(query_579550, "quotaUser", newJString(quotaUser))
  add(path_579549, "merchantId", newJString(merchantId))
  add(path_579549, "country", newJString(country))
  add(path_579549, "accountId", newJString(accountId))
  add(query_579550, "fields", newJString(fields))
  result = call_579548.call(path_579549, query_579550, nil, nil, nil)

var contentLiasettingsRequestinventoryverification* = Call_ContentLiasettingsRequestinventoryverification_579534(
    name: "contentLiasettingsRequestinventoryverification",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}/requestinventoryverification/{country}",
    validator: validate_ContentLiasettingsRequestinventoryverification_579535,
    base: "/content/v2.1",
    url: url_ContentLiasettingsRequestinventoryverification_579536,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsSetinventoryverificationcontact_579551 = ref object of OpenApiRestCall_578348
proc url_ContentLiasettingsSetinventoryverificationcontact_579553(
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

proc validate_ContentLiasettingsSetinventoryverificationcontact_579552(
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
  var valid_579554 = path.getOrDefault("merchantId")
  valid_579554 = validateParameter(valid_579554, JString, required = true,
                                 default = nil)
  if valid_579554 != nil:
    section.add "merchantId", valid_579554
  var valid_579555 = path.getOrDefault("accountId")
  valid_579555 = validateParameter(valid_579555, JString, required = true,
                                 default = nil)
  if valid_579555 != nil:
    section.add "accountId", valid_579555
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
  var valid_579556 = query.getOrDefault("key")
  valid_579556 = validateParameter(valid_579556, JString, required = false,
                                 default = nil)
  if valid_579556 != nil:
    section.add "key", valid_579556
  var valid_579557 = query.getOrDefault("prettyPrint")
  valid_579557 = validateParameter(valid_579557, JBool, required = false,
                                 default = newJBool(true))
  if valid_579557 != nil:
    section.add "prettyPrint", valid_579557
  var valid_579558 = query.getOrDefault("oauth_token")
  valid_579558 = validateParameter(valid_579558, JString, required = false,
                                 default = nil)
  if valid_579558 != nil:
    section.add "oauth_token", valid_579558
  assert query != nil,
        "query argument is necessary due to required `contactEmail` field"
  var valid_579559 = query.getOrDefault("contactEmail")
  valid_579559 = validateParameter(valid_579559, JString, required = true,
                                 default = nil)
  if valid_579559 != nil:
    section.add "contactEmail", valid_579559
  var valid_579560 = query.getOrDefault("alt")
  valid_579560 = validateParameter(valid_579560, JString, required = false,
                                 default = newJString("json"))
  if valid_579560 != nil:
    section.add "alt", valid_579560
  var valid_579561 = query.getOrDefault("userIp")
  valid_579561 = validateParameter(valid_579561, JString, required = false,
                                 default = nil)
  if valid_579561 != nil:
    section.add "userIp", valid_579561
  var valid_579562 = query.getOrDefault("quotaUser")
  valid_579562 = validateParameter(valid_579562, JString, required = false,
                                 default = nil)
  if valid_579562 != nil:
    section.add "quotaUser", valid_579562
  var valid_579563 = query.getOrDefault("contactName")
  valid_579563 = validateParameter(valid_579563, JString, required = true,
                                 default = nil)
  if valid_579563 != nil:
    section.add "contactName", valid_579563
  var valid_579564 = query.getOrDefault("country")
  valid_579564 = validateParameter(valid_579564, JString, required = true,
                                 default = nil)
  if valid_579564 != nil:
    section.add "country", valid_579564
  var valid_579565 = query.getOrDefault("fields")
  valid_579565 = validateParameter(valid_579565, JString, required = false,
                                 default = nil)
  if valid_579565 != nil:
    section.add "fields", valid_579565
  var valid_579566 = query.getOrDefault("language")
  valid_579566 = validateParameter(valid_579566, JString, required = true,
                                 default = nil)
  if valid_579566 != nil:
    section.add "language", valid_579566
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579567: Call_ContentLiasettingsSetinventoryverificationcontact_579551;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the inventory verification contract for the specified country.
  ## 
  let valid = call_579567.validator(path, query, header, formData, body)
  let scheme = call_579567.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579567.url(scheme.get, call_579567.host, call_579567.base,
                         call_579567.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579567, url, valid)

proc call*(call_579568: Call_ContentLiasettingsSetinventoryverificationcontact_579551;
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
  var path_579569 = newJObject()
  var query_579570 = newJObject()
  add(query_579570, "key", newJString(key))
  add(query_579570, "prettyPrint", newJBool(prettyPrint))
  add(query_579570, "oauth_token", newJString(oauthToken))
  add(query_579570, "contactEmail", newJString(contactEmail))
  add(query_579570, "alt", newJString(alt))
  add(query_579570, "userIp", newJString(userIp))
  add(query_579570, "quotaUser", newJString(quotaUser))
  add(path_579569, "merchantId", newJString(merchantId))
  add(query_579570, "contactName", newJString(contactName))
  add(query_579570, "country", newJString(country))
  add(path_579569, "accountId", newJString(accountId))
  add(query_579570, "fields", newJString(fields))
  add(query_579570, "language", newJString(language))
  result = call_579568.call(path_579569, query_579570, nil, nil, nil)

var contentLiasettingsSetinventoryverificationcontact* = Call_ContentLiasettingsSetinventoryverificationcontact_579551(
    name: "contentLiasettingsSetinventoryverificationcontact",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{merchantId}/liasettings/{accountId}/setinventoryverificationcontact",
    validator: validate_ContentLiasettingsSetinventoryverificationcontact_579552,
    base: "/content/v2.1",
    url: url_ContentLiasettingsSetinventoryverificationcontact_579553,
    schemes: {Scheme.Https})
type
  Call_ContentLiasettingsSetposdataprovider_579571 = ref object of OpenApiRestCall_578348
proc url_ContentLiasettingsSetposdataprovider_579573(protocol: Scheme;
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

proc validate_ContentLiasettingsSetposdataprovider_579572(path: JsonNode;
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
  var valid_579574 = path.getOrDefault("merchantId")
  valid_579574 = validateParameter(valid_579574, JString, required = true,
                                 default = nil)
  if valid_579574 != nil:
    section.add "merchantId", valid_579574
  var valid_579575 = path.getOrDefault("accountId")
  valid_579575 = validateParameter(valid_579575, JString, required = true,
                                 default = nil)
  if valid_579575 != nil:
    section.add "accountId", valid_579575
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579576 = query.getOrDefault("key")
  valid_579576 = validateParameter(valid_579576, JString, required = false,
                                 default = nil)
  if valid_579576 != nil:
    section.add "key", valid_579576
  var valid_579577 = query.getOrDefault("prettyPrint")
  valid_579577 = validateParameter(valid_579577, JBool, required = false,
                                 default = newJBool(true))
  if valid_579577 != nil:
    section.add "prettyPrint", valid_579577
  var valid_579578 = query.getOrDefault("oauth_token")
  valid_579578 = validateParameter(valid_579578, JString, required = false,
                                 default = nil)
  if valid_579578 != nil:
    section.add "oauth_token", valid_579578
  var valid_579579 = query.getOrDefault("alt")
  valid_579579 = validateParameter(valid_579579, JString, required = false,
                                 default = newJString("json"))
  if valid_579579 != nil:
    section.add "alt", valid_579579
  var valid_579580 = query.getOrDefault("userIp")
  valid_579580 = validateParameter(valid_579580, JString, required = false,
                                 default = nil)
  if valid_579580 != nil:
    section.add "userIp", valid_579580
  var valid_579581 = query.getOrDefault("quotaUser")
  valid_579581 = validateParameter(valid_579581, JString, required = false,
                                 default = nil)
  if valid_579581 != nil:
    section.add "quotaUser", valid_579581
  var valid_579582 = query.getOrDefault("posDataProviderId")
  valid_579582 = validateParameter(valid_579582, JString, required = false,
                                 default = nil)
  if valid_579582 != nil:
    section.add "posDataProviderId", valid_579582
  assert query != nil, "query argument is necessary due to required `country` field"
  var valid_579583 = query.getOrDefault("country")
  valid_579583 = validateParameter(valid_579583, JString, required = true,
                                 default = nil)
  if valid_579583 != nil:
    section.add "country", valid_579583
  var valid_579584 = query.getOrDefault("fields")
  valid_579584 = validateParameter(valid_579584, JString, required = false,
                                 default = nil)
  if valid_579584 != nil:
    section.add "fields", valid_579584
  var valid_579585 = query.getOrDefault("posExternalAccountId")
  valid_579585 = validateParameter(valid_579585, JString, required = false,
                                 default = nil)
  if valid_579585 != nil:
    section.add "posExternalAccountId", valid_579585
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579586: Call_ContentLiasettingsSetposdataprovider_579571;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the POS data provider for the specified country.
  ## 
  let valid = call_579586.validator(path, query, header, formData, body)
  let scheme = call_579586.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579586.url(scheme.get, call_579586.host, call_579586.base,
                         call_579586.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579586, url, valid)

proc call*(call_579587: Call_ContentLiasettingsSetposdataprovider_579571;
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
  var path_579588 = newJObject()
  var query_579589 = newJObject()
  add(query_579589, "key", newJString(key))
  add(query_579589, "prettyPrint", newJBool(prettyPrint))
  add(query_579589, "oauth_token", newJString(oauthToken))
  add(query_579589, "alt", newJString(alt))
  add(query_579589, "userIp", newJString(userIp))
  add(query_579589, "quotaUser", newJString(quotaUser))
  add(path_579588, "merchantId", newJString(merchantId))
  add(query_579589, "posDataProviderId", newJString(posDataProviderId))
  add(query_579589, "country", newJString(country))
  add(path_579588, "accountId", newJString(accountId))
  add(query_579589, "fields", newJString(fields))
  add(query_579589, "posExternalAccountId", newJString(posExternalAccountId))
  result = call_579587.call(path_579588, query_579589, nil, nil, nil)

var contentLiasettingsSetposdataprovider* = Call_ContentLiasettingsSetposdataprovider_579571(
    name: "contentLiasettingsSetposdataprovider", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/liasettings/{accountId}/setposdataprovider",
    validator: validate_ContentLiasettingsSetposdataprovider_579572,
    base: "/content/v2.1", url: url_ContentLiasettingsSetposdataprovider_579573,
    schemes: {Scheme.Https})
type
  Call_ContentOrderinvoicesCreatechargeinvoice_579590 = ref object of OpenApiRestCall_578348
proc url_ContentOrderinvoicesCreatechargeinvoice_579592(protocol: Scheme;
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

proc validate_ContentOrderinvoicesCreatechargeinvoice_579591(path: JsonNode;
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
  var valid_579593 = path.getOrDefault("merchantId")
  valid_579593 = validateParameter(valid_579593, JString, required = true,
                                 default = nil)
  if valid_579593 != nil:
    section.add "merchantId", valid_579593
  var valid_579594 = path.getOrDefault("orderId")
  valid_579594 = validateParameter(valid_579594, JString, required = true,
                                 default = nil)
  if valid_579594 != nil:
    section.add "orderId", valid_579594
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579595 = query.getOrDefault("key")
  valid_579595 = validateParameter(valid_579595, JString, required = false,
                                 default = nil)
  if valid_579595 != nil:
    section.add "key", valid_579595
  var valid_579596 = query.getOrDefault("prettyPrint")
  valid_579596 = validateParameter(valid_579596, JBool, required = false,
                                 default = newJBool(true))
  if valid_579596 != nil:
    section.add "prettyPrint", valid_579596
  var valid_579597 = query.getOrDefault("oauth_token")
  valid_579597 = validateParameter(valid_579597, JString, required = false,
                                 default = nil)
  if valid_579597 != nil:
    section.add "oauth_token", valid_579597
  var valid_579598 = query.getOrDefault("alt")
  valid_579598 = validateParameter(valid_579598, JString, required = false,
                                 default = newJString("json"))
  if valid_579598 != nil:
    section.add "alt", valid_579598
  var valid_579599 = query.getOrDefault("userIp")
  valid_579599 = validateParameter(valid_579599, JString, required = false,
                                 default = nil)
  if valid_579599 != nil:
    section.add "userIp", valid_579599
  var valid_579600 = query.getOrDefault("quotaUser")
  valid_579600 = validateParameter(valid_579600, JString, required = false,
                                 default = nil)
  if valid_579600 != nil:
    section.add "quotaUser", valid_579600
  var valid_579601 = query.getOrDefault("fields")
  valid_579601 = validateParameter(valid_579601, JString, required = false,
                                 default = nil)
  if valid_579601 != nil:
    section.add "fields", valid_579601
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579603: Call_ContentOrderinvoicesCreatechargeinvoice_579590;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a charge invoice for a shipment group, and triggers a charge capture for orderinvoice enabled orders.
  ## 
  let valid = call_579603.validator(path, query, header, formData, body)
  let scheme = call_579603.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579603.url(scheme.get, call_579603.host, call_579603.base,
                         call_579603.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579603, url, valid)

proc call*(call_579604: Call_ContentOrderinvoicesCreatechargeinvoice_579590;
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
  var path_579605 = newJObject()
  var query_579606 = newJObject()
  var body_579607 = newJObject()
  add(query_579606, "key", newJString(key))
  add(query_579606, "prettyPrint", newJBool(prettyPrint))
  add(query_579606, "oauth_token", newJString(oauthToken))
  add(query_579606, "alt", newJString(alt))
  add(query_579606, "userIp", newJString(userIp))
  add(query_579606, "quotaUser", newJString(quotaUser))
  add(path_579605, "merchantId", newJString(merchantId))
  if body != nil:
    body_579607 = body
  add(query_579606, "fields", newJString(fields))
  add(path_579605, "orderId", newJString(orderId))
  result = call_579604.call(path_579605, query_579606, nil, nil, body_579607)

var contentOrderinvoicesCreatechargeinvoice* = Call_ContentOrderinvoicesCreatechargeinvoice_579590(
    name: "contentOrderinvoicesCreatechargeinvoice", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderinvoices/{orderId}/createChargeInvoice",
    validator: validate_ContentOrderinvoicesCreatechargeinvoice_579591,
    base: "/content/v2.1", url: url_ContentOrderinvoicesCreatechargeinvoice_579592,
    schemes: {Scheme.Https})
type
  Call_ContentOrderinvoicesCreaterefundinvoice_579608 = ref object of OpenApiRestCall_578348
proc url_ContentOrderinvoicesCreaterefundinvoice_579610(protocol: Scheme;
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

proc validate_ContentOrderinvoicesCreaterefundinvoice_579609(path: JsonNode;
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
  var valid_579611 = path.getOrDefault("merchantId")
  valid_579611 = validateParameter(valid_579611, JString, required = true,
                                 default = nil)
  if valid_579611 != nil:
    section.add "merchantId", valid_579611
  var valid_579612 = path.getOrDefault("orderId")
  valid_579612 = validateParameter(valid_579612, JString, required = true,
                                 default = nil)
  if valid_579612 != nil:
    section.add "orderId", valid_579612
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579613 = query.getOrDefault("key")
  valid_579613 = validateParameter(valid_579613, JString, required = false,
                                 default = nil)
  if valid_579613 != nil:
    section.add "key", valid_579613
  var valid_579614 = query.getOrDefault("prettyPrint")
  valid_579614 = validateParameter(valid_579614, JBool, required = false,
                                 default = newJBool(true))
  if valid_579614 != nil:
    section.add "prettyPrint", valid_579614
  var valid_579615 = query.getOrDefault("oauth_token")
  valid_579615 = validateParameter(valid_579615, JString, required = false,
                                 default = nil)
  if valid_579615 != nil:
    section.add "oauth_token", valid_579615
  var valid_579616 = query.getOrDefault("alt")
  valid_579616 = validateParameter(valid_579616, JString, required = false,
                                 default = newJString("json"))
  if valid_579616 != nil:
    section.add "alt", valid_579616
  var valid_579617 = query.getOrDefault("userIp")
  valid_579617 = validateParameter(valid_579617, JString, required = false,
                                 default = nil)
  if valid_579617 != nil:
    section.add "userIp", valid_579617
  var valid_579618 = query.getOrDefault("quotaUser")
  valid_579618 = validateParameter(valid_579618, JString, required = false,
                                 default = nil)
  if valid_579618 != nil:
    section.add "quotaUser", valid_579618
  var valid_579619 = query.getOrDefault("fields")
  valid_579619 = validateParameter(valid_579619, JString, required = false,
                                 default = nil)
  if valid_579619 != nil:
    section.add "fields", valid_579619
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579621: Call_ContentOrderinvoicesCreaterefundinvoice_579608;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a refund invoice for one or more shipment groups, and triggers a refund for orderinvoice enabled orders. This can only be used for line items that have previously been charged using createChargeInvoice. All amounts (except for the summary) are incremental with respect to the previous invoice.
  ## 
  let valid = call_579621.validator(path, query, header, formData, body)
  let scheme = call_579621.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579621.url(scheme.get, call_579621.host, call_579621.base,
                         call_579621.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579621, url, valid)

proc call*(call_579622: Call_ContentOrderinvoicesCreaterefundinvoice_579608;
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
  var path_579623 = newJObject()
  var query_579624 = newJObject()
  var body_579625 = newJObject()
  add(query_579624, "key", newJString(key))
  add(query_579624, "prettyPrint", newJBool(prettyPrint))
  add(query_579624, "oauth_token", newJString(oauthToken))
  add(query_579624, "alt", newJString(alt))
  add(query_579624, "userIp", newJString(userIp))
  add(query_579624, "quotaUser", newJString(quotaUser))
  add(path_579623, "merchantId", newJString(merchantId))
  if body != nil:
    body_579625 = body
  add(query_579624, "fields", newJString(fields))
  add(path_579623, "orderId", newJString(orderId))
  result = call_579622.call(path_579623, query_579624, nil, nil, body_579625)

var contentOrderinvoicesCreaterefundinvoice* = Call_ContentOrderinvoicesCreaterefundinvoice_579608(
    name: "contentOrderinvoicesCreaterefundinvoice", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orderinvoices/{orderId}/createRefundInvoice",
    validator: validate_ContentOrderinvoicesCreaterefundinvoice_579609,
    base: "/content/v2.1", url: url_ContentOrderinvoicesCreaterefundinvoice_579610,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreportsListdisbursements_579626 = ref object of OpenApiRestCall_578348
proc url_ContentOrderreportsListdisbursements_579628(protocol: Scheme;
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

proc validate_ContentOrderreportsListdisbursements_579627(path: JsonNode;
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
  var valid_579629 = path.getOrDefault("merchantId")
  valid_579629 = validateParameter(valid_579629, JString, required = true,
                                 default = nil)
  if valid_579629 != nil:
    section.add "merchantId", valid_579629
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
  var valid_579630 = query.getOrDefault("key")
  valid_579630 = validateParameter(valid_579630, JString, required = false,
                                 default = nil)
  if valid_579630 != nil:
    section.add "key", valid_579630
  var valid_579631 = query.getOrDefault("prettyPrint")
  valid_579631 = validateParameter(valid_579631, JBool, required = false,
                                 default = newJBool(true))
  if valid_579631 != nil:
    section.add "prettyPrint", valid_579631
  var valid_579632 = query.getOrDefault("oauth_token")
  valid_579632 = validateParameter(valid_579632, JString, required = false,
                                 default = nil)
  if valid_579632 != nil:
    section.add "oauth_token", valid_579632
  var valid_579633 = query.getOrDefault("disbursementEndDate")
  valid_579633 = validateParameter(valid_579633, JString, required = false,
                                 default = nil)
  if valid_579633 != nil:
    section.add "disbursementEndDate", valid_579633
  var valid_579634 = query.getOrDefault("alt")
  valid_579634 = validateParameter(valid_579634, JString, required = false,
                                 default = newJString("json"))
  if valid_579634 != nil:
    section.add "alt", valid_579634
  var valid_579635 = query.getOrDefault("userIp")
  valid_579635 = validateParameter(valid_579635, JString, required = false,
                                 default = nil)
  if valid_579635 != nil:
    section.add "userIp", valid_579635
  var valid_579636 = query.getOrDefault("quotaUser")
  valid_579636 = validateParameter(valid_579636, JString, required = false,
                                 default = nil)
  if valid_579636 != nil:
    section.add "quotaUser", valid_579636
  var valid_579637 = query.getOrDefault("pageToken")
  valid_579637 = validateParameter(valid_579637, JString, required = false,
                                 default = nil)
  if valid_579637 != nil:
    section.add "pageToken", valid_579637
  assert query != nil, "query argument is necessary due to required `disbursementStartDate` field"
  var valid_579638 = query.getOrDefault("disbursementStartDate")
  valid_579638 = validateParameter(valid_579638, JString, required = true,
                                 default = nil)
  if valid_579638 != nil:
    section.add "disbursementStartDate", valid_579638
  var valid_579639 = query.getOrDefault("fields")
  valid_579639 = validateParameter(valid_579639, JString, required = false,
                                 default = nil)
  if valid_579639 != nil:
    section.add "fields", valid_579639
  var valid_579640 = query.getOrDefault("maxResults")
  valid_579640 = validateParameter(valid_579640, JInt, required = false, default = nil)
  if valid_579640 != nil:
    section.add "maxResults", valid_579640
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579641: Call_ContentOrderreportsListdisbursements_579626;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a report for disbursements from your Merchant Center account.
  ## 
  let valid = call_579641.validator(path, query, header, formData, body)
  let scheme = call_579641.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579641.url(scheme.get, call_579641.host, call_579641.base,
                         call_579641.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579641, url, valid)

proc call*(call_579642: Call_ContentOrderreportsListdisbursements_579626;
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
  var path_579643 = newJObject()
  var query_579644 = newJObject()
  add(query_579644, "key", newJString(key))
  add(query_579644, "prettyPrint", newJBool(prettyPrint))
  add(query_579644, "oauth_token", newJString(oauthToken))
  add(query_579644, "disbursementEndDate", newJString(disbursementEndDate))
  add(query_579644, "alt", newJString(alt))
  add(query_579644, "userIp", newJString(userIp))
  add(query_579644, "quotaUser", newJString(quotaUser))
  add(path_579643, "merchantId", newJString(merchantId))
  add(query_579644, "pageToken", newJString(pageToken))
  add(query_579644, "disbursementStartDate", newJString(disbursementStartDate))
  add(query_579644, "fields", newJString(fields))
  add(query_579644, "maxResults", newJInt(maxResults))
  result = call_579642.call(path_579643, query_579644, nil, nil, nil)

var contentOrderreportsListdisbursements* = Call_ContentOrderreportsListdisbursements_579626(
    name: "contentOrderreportsListdisbursements", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreports/disbursements",
    validator: validate_ContentOrderreportsListdisbursements_579627,
    base: "/content/v2.1", url: url_ContentOrderreportsListdisbursements_579628,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreportsListtransactions_579645 = ref object of OpenApiRestCall_578348
proc url_ContentOrderreportsListtransactions_579647(protocol: Scheme; host: string;
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

proc validate_ContentOrderreportsListtransactions_579646(path: JsonNode;
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
  var valid_579648 = path.getOrDefault("merchantId")
  valid_579648 = validateParameter(valid_579648, JString, required = true,
                                 default = nil)
  if valid_579648 != nil:
    section.add "merchantId", valid_579648
  var valid_579649 = path.getOrDefault("disbursementId")
  valid_579649 = validateParameter(valid_579649, JString, required = true,
                                 default = nil)
  if valid_579649 != nil:
    section.add "disbursementId", valid_579649
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
  var valid_579650 = query.getOrDefault("key")
  valid_579650 = validateParameter(valid_579650, JString, required = false,
                                 default = nil)
  if valid_579650 != nil:
    section.add "key", valid_579650
  var valid_579651 = query.getOrDefault("prettyPrint")
  valid_579651 = validateParameter(valid_579651, JBool, required = false,
                                 default = newJBool(true))
  if valid_579651 != nil:
    section.add "prettyPrint", valid_579651
  var valid_579652 = query.getOrDefault("oauth_token")
  valid_579652 = validateParameter(valid_579652, JString, required = false,
                                 default = nil)
  if valid_579652 != nil:
    section.add "oauth_token", valid_579652
  var valid_579653 = query.getOrDefault("transactionEndDate")
  valid_579653 = validateParameter(valid_579653, JString, required = false,
                                 default = nil)
  if valid_579653 != nil:
    section.add "transactionEndDate", valid_579653
  var valid_579654 = query.getOrDefault("alt")
  valid_579654 = validateParameter(valid_579654, JString, required = false,
                                 default = newJString("json"))
  if valid_579654 != nil:
    section.add "alt", valid_579654
  var valid_579655 = query.getOrDefault("userIp")
  valid_579655 = validateParameter(valid_579655, JString, required = false,
                                 default = nil)
  if valid_579655 != nil:
    section.add "userIp", valid_579655
  assert query != nil, "query argument is necessary due to required `transactionStartDate` field"
  var valid_579656 = query.getOrDefault("transactionStartDate")
  valid_579656 = validateParameter(valid_579656, JString, required = true,
                                 default = nil)
  if valid_579656 != nil:
    section.add "transactionStartDate", valid_579656
  var valid_579657 = query.getOrDefault("quotaUser")
  valid_579657 = validateParameter(valid_579657, JString, required = false,
                                 default = nil)
  if valid_579657 != nil:
    section.add "quotaUser", valid_579657
  var valid_579658 = query.getOrDefault("pageToken")
  valid_579658 = validateParameter(valid_579658, JString, required = false,
                                 default = nil)
  if valid_579658 != nil:
    section.add "pageToken", valid_579658
  var valid_579659 = query.getOrDefault("fields")
  valid_579659 = validateParameter(valid_579659, JString, required = false,
                                 default = nil)
  if valid_579659 != nil:
    section.add "fields", valid_579659
  var valid_579660 = query.getOrDefault("maxResults")
  valid_579660 = validateParameter(valid_579660, JInt, required = false, default = nil)
  if valid_579660 != nil:
    section.add "maxResults", valid_579660
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579661: Call_ContentOrderreportsListtransactions_579645;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of transactions for a disbursement from your Merchant Center account.
  ## 
  let valid = call_579661.validator(path, query, header, formData, body)
  let scheme = call_579661.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579661.url(scheme.get, call_579661.host, call_579661.base,
                         call_579661.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579661, url, valid)

proc call*(call_579662: Call_ContentOrderreportsListtransactions_579645;
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
  var path_579663 = newJObject()
  var query_579664 = newJObject()
  add(query_579664, "key", newJString(key))
  add(query_579664, "prettyPrint", newJBool(prettyPrint))
  add(query_579664, "oauth_token", newJString(oauthToken))
  add(query_579664, "transactionEndDate", newJString(transactionEndDate))
  add(query_579664, "alt", newJString(alt))
  add(query_579664, "userIp", newJString(userIp))
  add(query_579664, "transactionStartDate", newJString(transactionStartDate))
  add(query_579664, "quotaUser", newJString(quotaUser))
  add(path_579663, "merchantId", newJString(merchantId))
  add(query_579664, "pageToken", newJString(pageToken))
  add(path_579663, "disbursementId", newJString(disbursementId))
  add(query_579664, "fields", newJString(fields))
  add(query_579664, "maxResults", newJInt(maxResults))
  result = call_579662.call(path_579663, query_579664, nil, nil, nil)

var contentOrderreportsListtransactions* = Call_ContentOrderreportsListtransactions_579645(
    name: "contentOrderreportsListtransactions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreports/disbursements/{disbursementId}/transactions",
    validator: validate_ContentOrderreportsListtransactions_579646,
    base: "/content/v2.1", url: url_ContentOrderreportsListtransactions_579647,
    schemes: {Scheme.Https})
type
  Call_ContentOrderreturnsList_579665 = ref object of OpenApiRestCall_578348
proc url_ContentOrderreturnsList_579667(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrderreturnsList_579666(path: JsonNode; query: JsonNode;
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
  var valid_579668 = path.getOrDefault("merchantId")
  valid_579668 = validateParameter(valid_579668, JString, required = true,
                                 default = nil)
  if valid_579668 != nil:
    section.add "merchantId", valid_579668
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
  var valid_579669 = query.getOrDefault("key")
  valid_579669 = validateParameter(valid_579669, JString, required = false,
                                 default = nil)
  if valid_579669 != nil:
    section.add "key", valid_579669
  var valid_579670 = query.getOrDefault("prettyPrint")
  valid_579670 = validateParameter(valid_579670, JBool, required = false,
                                 default = newJBool(true))
  if valid_579670 != nil:
    section.add "prettyPrint", valid_579670
  var valid_579671 = query.getOrDefault("oauth_token")
  valid_579671 = validateParameter(valid_579671, JString, required = false,
                                 default = nil)
  if valid_579671 != nil:
    section.add "oauth_token", valid_579671
  var valid_579672 = query.getOrDefault("createdStartDate")
  valid_579672 = validateParameter(valid_579672, JString, required = false,
                                 default = nil)
  if valid_579672 != nil:
    section.add "createdStartDate", valid_579672
  var valid_579673 = query.getOrDefault("alt")
  valid_579673 = validateParameter(valid_579673, JString, required = false,
                                 default = newJString("json"))
  if valid_579673 != nil:
    section.add "alt", valid_579673
  var valid_579674 = query.getOrDefault("userIp")
  valid_579674 = validateParameter(valid_579674, JString, required = false,
                                 default = nil)
  if valid_579674 != nil:
    section.add "userIp", valid_579674
  var valid_579675 = query.getOrDefault("quotaUser")
  valid_579675 = validateParameter(valid_579675, JString, required = false,
                                 default = nil)
  if valid_579675 != nil:
    section.add "quotaUser", valid_579675
  var valid_579676 = query.getOrDefault("orderBy")
  valid_579676 = validateParameter(valid_579676, JString, required = false,
                                 default = newJString("returnCreationTimeAsc"))
  if valid_579676 != nil:
    section.add "orderBy", valid_579676
  var valid_579677 = query.getOrDefault("pageToken")
  valid_579677 = validateParameter(valid_579677, JString, required = false,
                                 default = nil)
  if valid_579677 != nil:
    section.add "pageToken", valid_579677
  var valid_579678 = query.getOrDefault("fields")
  valid_579678 = validateParameter(valid_579678, JString, required = false,
                                 default = nil)
  if valid_579678 != nil:
    section.add "fields", valid_579678
  var valid_579679 = query.getOrDefault("maxResults")
  valid_579679 = validateParameter(valid_579679, JInt, required = false, default = nil)
  if valid_579679 != nil:
    section.add "maxResults", valid_579679
  var valid_579680 = query.getOrDefault("createdEndDate")
  valid_579680 = validateParameter(valid_579680, JString, required = false,
                                 default = nil)
  if valid_579680 != nil:
    section.add "createdEndDate", valid_579680
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579681: Call_ContentOrderreturnsList_579665; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists order returns in your Merchant Center account.
  ## 
  let valid = call_579681.validator(path, query, header, formData, body)
  let scheme = call_579681.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579681.url(scheme.get, call_579681.host, call_579681.base,
                         call_579681.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579681, url, valid)

proc call*(call_579682: Call_ContentOrderreturnsList_579665; merchantId: string;
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
  var path_579683 = newJObject()
  var query_579684 = newJObject()
  add(query_579684, "key", newJString(key))
  add(query_579684, "prettyPrint", newJBool(prettyPrint))
  add(query_579684, "oauth_token", newJString(oauthToken))
  add(query_579684, "createdStartDate", newJString(createdStartDate))
  add(query_579684, "alt", newJString(alt))
  add(query_579684, "userIp", newJString(userIp))
  add(query_579684, "quotaUser", newJString(quotaUser))
  add(path_579683, "merchantId", newJString(merchantId))
  add(query_579684, "orderBy", newJString(orderBy))
  add(query_579684, "pageToken", newJString(pageToken))
  add(query_579684, "fields", newJString(fields))
  add(query_579684, "maxResults", newJInt(maxResults))
  add(query_579684, "createdEndDate", newJString(createdEndDate))
  result = call_579682.call(path_579683, query_579684, nil, nil, nil)

var contentOrderreturnsList* = Call_ContentOrderreturnsList_579665(
    name: "contentOrderreturnsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreturns",
    validator: validate_ContentOrderreturnsList_579666, base: "/content/v2.1",
    url: url_ContentOrderreturnsList_579667, schemes: {Scheme.Https})
type
  Call_ContentOrderreturnsGet_579685 = ref object of OpenApiRestCall_578348
proc url_ContentOrderreturnsGet_579687(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrderreturnsGet_579686(path: JsonNode; query: JsonNode;
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
  var valid_579688 = path.getOrDefault("returnId")
  valid_579688 = validateParameter(valid_579688, JString, required = true,
                                 default = nil)
  if valid_579688 != nil:
    section.add "returnId", valid_579688
  var valid_579689 = path.getOrDefault("merchantId")
  valid_579689 = validateParameter(valid_579689, JString, required = true,
                                 default = nil)
  if valid_579689 != nil:
    section.add "merchantId", valid_579689
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579690 = query.getOrDefault("key")
  valid_579690 = validateParameter(valid_579690, JString, required = false,
                                 default = nil)
  if valid_579690 != nil:
    section.add "key", valid_579690
  var valid_579691 = query.getOrDefault("prettyPrint")
  valid_579691 = validateParameter(valid_579691, JBool, required = false,
                                 default = newJBool(true))
  if valid_579691 != nil:
    section.add "prettyPrint", valid_579691
  var valid_579692 = query.getOrDefault("oauth_token")
  valid_579692 = validateParameter(valid_579692, JString, required = false,
                                 default = nil)
  if valid_579692 != nil:
    section.add "oauth_token", valid_579692
  var valid_579693 = query.getOrDefault("alt")
  valid_579693 = validateParameter(valid_579693, JString, required = false,
                                 default = newJString("json"))
  if valid_579693 != nil:
    section.add "alt", valid_579693
  var valid_579694 = query.getOrDefault("userIp")
  valid_579694 = validateParameter(valid_579694, JString, required = false,
                                 default = nil)
  if valid_579694 != nil:
    section.add "userIp", valid_579694
  var valid_579695 = query.getOrDefault("quotaUser")
  valid_579695 = validateParameter(valid_579695, JString, required = false,
                                 default = nil)
  if valid_579695 != nil:
    section.add "quotaUser", valid_579695
  var valid_579696 = query.getOrDefault("fields")
  valid_579696 = validateParameter(valid_579696, JString, required = false,
                                 default = nil)
  if valid_579696 != nil:
    section.add "fields", valid_579696
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579697: Call_ContentOrderreturnsGet_579685; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an order return from your Merchant Center account.
  ## 
  let valid = call_579697.validator(path, query, header, formData, body)
  let scheme = call_579697.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579697.url(scheme.get, call_579697.host, call_579697.base,
                         call_579697.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579697, url, valid)

proc call*(call_579698: Call_ContentOrderreturnsGet_579685; returnId: string;
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
  var path_579699 = newJObject()
  var query_579700 = newJObject()
  add(query_579700, "key", newJString(key))
  add(query_579700, "prettyPrint", newJBool(prettyPrint))
  add(query_579700, "oauth_token", newJString(oauthToken))
  add(path_579699, "returnId", newJString(returnId))
  add(query_579700, "alt", newJString(alt))
  add(query_579700, "userIp", newJString(userIp))
  add(query_579700, "quotaUser", newJString(quotaUser))
  add(path_579699, "merchantId", newJString(merchantId))
  add(query_579700, "fields", newJString(fields))
  result = call_579698.call(path_579699, query_579700, nil, nil, nil)

var contentOrderreturnsGet* = Call_ContentOrderreturnsGet_579685(
    name: "contentOrderreturnsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/orderreturns/{returnId}",
    validator: validate_ContentOrderreturnsGet_579686, base: "/content/v2.1",
    url: url_ContentOrderreturnsGet_579687, schemes: {Scheme.Https})
type
  Call_ContentOrdersList_579701 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersList_579703(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrdersList_579702(path: JsonNode; query: JsonNode;
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
  var valid_579704 = path.getOrDefault("merchantId")
  valid_579704 = validateParameter(valid_579704, JString, required = true,
                                 default = nil)
  if valid_579704 != nil:
    section.add "merchantId", valid_579704
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579705 = query.getOrDefault("key")
  valid_579705 = validateParameter(valid_579705, JString, required = false,
                                 default = nil)
  if valid_579705 != nil:
    section.add "key", valid_579705
  var valid_579706 = query.getOrDefault("prettyPrint")
  valid_579706 = validateParameter(valid_579706, JBool, required = false,
                                 default = newJBool(true))
  if valid_579706 != nil:
    section.add "prettyPrint", valid_579706
  var valid_579707 = query.getOrDefault("oauth_token")
  valid_579707 = validateParameter(valid_579707, JString, required = false,
                                 default = nil)
  if valid_579707 != nil:
    section.add "oauth_token", valid_579707
  var valid_579708 = query.getOrDefault("alt")
  valid_579708 = validateParameter(valid_579708, JString, required = false,
                                 default = newJString("json"))
  if valid_579708 != nil:
    section.add "alt", valid_579708
  var valid_579709 = query.getOrDefault("userIp")
  valid_579709 = validateParameter(valid_579709, JString, required = false,
                                 default = nil)
  if valid_579709 != nil:
    section.add "userIp", valid_579709
  var valid_579710 = query.getOrDefault("quotaUser")
  valid_579710 = validateParameter(valid_579710, JString, required = false,
                                 default = nil)
  if valid_579710 != nil:
    section.add "quotaUser", valid_579710
  var valid_579711 = query.getOrDefault("orderBy")
  valid_579711 = validateParameter(valid_579711, JString, required = false,
                                 default = nil)
  if valid_579711 != nil:
    section.add "orderBy", valid_579711
  var valid_579712 = query.getOrDefault("pageToken")
  valid_579712 = validateParameter(valid_579712, JString, required = false,
                                 default = nil)
  if valid_579712 != nil:
    section.add "pageToken", valid_579712
  var valid_579713 = query.getOrDefault("placedDateStart")
  valid_579713 = validateParameter(valid_579713, JString, required = false,
                                 default = nil)
  if valid_579713 != nil:
    section.add "placedDateStart", valid_579713
  var valid_579714 = query.getOrDefault("statuses")
  valid_579714 = validateParameter(valid_579714, JArray, required = false,
                                 default = nil)
  if valid_579714 != nil:
    section.add "statuses", valid_579714
  var valid_579715 = query.getOrDefault("acknowledged")
  valid_579715 = validateParameter(valid_579715, JBool, required = false, default = nil)
  if valid_579715 != nil:
    section.add "acknowledged", valid_579715
  var valid_579716 = query.getOrDefault("placedDateEnd")
  valid_579716 = validateParameter(valid_579716, JString, required = false,
                                 default = nil)
  if valid_579716 != nil:
    section.add "placedDateEnd", valid_579716
  var valid_579717 = query.getOrDefault("fields")
  valid_579717 = validateParameter(valid_579717, JString, required = false,
                                 default = nil)
  if valid_579717 != nil:
    section.add "fields", valid_579717
  var valid_579718 = query.getOrDefault("maxResults")
  valid_579718 = validateParameter(valid_579718, JInt, required = false, default = nil)
  if valid_579718 != nil:
    section.add "maxResults", valid_579718
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579719: Call_ContentOrdersList_579701; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the orders in your Merchant Center account.
  ## 
  let valid = call_579719.validator(path, query, header, formData, body)
  let scheme = call_579719.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579719.url(scheme.get, call_579719.host, call_579719.base,
                         call_579719.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579719, url, valid)

proc call*(call_579720: Call_ContentOrdersList_579701; merchantId: string;
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
  var path_579721 = newJObject()
  var query_579722 = newJObject()
  add(query_579722, "key", newJString(key))
  add(query_579722, "prettyPrint", newJBool(prettyPrint))
  add(query_579722, "oauth_token", newJString(oauthToken))
  add(query_579722, "alt", newJString(alt))
  add(query_579722, "userIp", newJString(userIp))
  add(query_579722, "quotaUser", newJString(quotaUser))
  add(path_579721, "merchantId", newJString(merchantId))
  add(query_579722, "orderBy", newJString(orderBy))
  add(query_579722, "pageToken", newJString(pageToken))
  add(query_579722, "placedDateStart", newJString(placedDateStart))
  if statuses != nil:
    query_579722.add "statuses", statuses
  add(query_579722, "acknowledged", newJBool(acknowledged))
  add(query_579722, "placedDateEnd", newJString(placedDateEnd))
  add(query_579722, "fields", newJString(fields))
  add(query_579722, "maxResults", newJInt(maxResults))
  result = call_579720.call(path_579721, query_579722, nil, nil, nil)

var contentOrdersList* = Call_ContentOrdersList_579701(name: "contentOrdersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/orders", validator: validate_ContentOrdersList_579702,
    base: "/content/v2.1", url: url_ContentOrdersList_579703,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersGet_579723 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersGet_579725(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrdersGet_579724(path: JsonNode; query: JsonNode;
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
  var valid_579726 = path.getOrDefault("merchantId")
  valid_579726 = validateParameter(valid_579726, JString, required = true,
                                 default = nil)
  if valid_579726 != nil:
    section.add "merchantId", valid_579726
  var valid_579727 = path.getOrDefault("orderId")
  valid_579727 = validateParameter(valid_579727, JString, required = true,
                                 default = nil)
  if valid_579727 != nil:
    section.add "orderId", valid_579727
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579728 = query.getOrDefault("key")
  valid_579728 = validateParameter(valid_579728, JString, required = false,
                                 default = nil)
  if valid_579728 != nil:
    section.add "key", valid_579728
  var valid_579729 = query.getOrDefault("prettyPrint")
  valid_579729 = validateParameter(valid_579729, JBool, required = false,
                                 default = newJBool(true))
  if valid_579729 != nil:
    section.add "prettyPrint", valid_579729
  var valid_579730 = query.getOrDefault("oauth_token")
  valid_579730 = validateParameter(valid_579730, JString, required = false,
                                 default = nil)
  if valid_579730 != nil:
    section.add "oauth_token", valid_579730
  var valid_579731 = query.getOrDefault("alt")
  valid_579731 = validateParameter(valid_579731, JString, required = false,
                                 default = newJString("json"))
  if valid_579731 != nil:
    section.add "alt", valid_579731
  var valid_579732 = query.getOrDefault("userIp")
  valid_579732 = validateParameter(valid_579732, JString, required = false,
                                 default = nil)
  if valid_579732 != nil:
    section.add "userIp", valid_579732
  var valid_579733 = query.getOrDefault("quotaUser")
  valid_579733 = validateParameter(valid_579733, JString, required = false,
                                 default = nil)
  if valid_579733 != nil:
    section.add "quotaUser", valid_579733
  var valid_579734 = query.getOrDefault("fields")
  valid_579734 = validateParameter(valid_579734, JString, required = false,
                                 default = nil)
  if valid_579734 != nil:
    section.add "fields", valid_579734
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579735: Call_ContentOrdersGet_579723; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an order from your Merchant Center account.
  ## 
  let valid = call_579735.validator(path, query, header, formData, body)
  let scheme = call_579735.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579735.url(scheme.get, call_579735.host, call_579735.base,
                         call_579735.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579735, url, valid)

proc call*(call_579736: Call_ContentOrdersGet_579723; merchantId: string;
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
  var path_579737 = newJObject()
  var query_579738 = newJObject()
  add(query_579738, "key", newJString(key))
  add(query_579738, "prettyPrint", newJBool(prettyPrint))
  add(query_579738, "oauth_token", newJString(oauthToken))
  add(query_579738, "alt", newJString(alt))
  add(query_579738, "userIp", newJString(userIp))
  add(query_579738, "quotaUser", newJString(quotaUser))
  add(path_579737, "merchantId", newJString(merchantId))
  add(query_579738, "fields", newJString(fields))
  add(path_579737, "orderId", newJString(orderId))
  result = call_579736.call(path_579737, query_579738, nil, nil, nil)

var contentOrdersGet* = Call_ContentOrdersGet_579723(name: "contentOrdersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}", validator: validate_ContentOrdersGet_579724,
    base: "/content/v2.1", url: url_ContentOrdersGet_579725, schemes: {Scheme.Https})
type
  Call_ContentOrdersAcknowledge_579739 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersAcknowledge_579741(protocol: Scheme; host: string;
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

proc validate_ContentOrdersAcknowledge_579740(path: JsonNode; query: JsonNode;
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
  var valid_579742 = path.getOrDefault("merchantId")
  valid_579742 = validateParameter(valid_579742, JString, required = true,
                                 default = nil)
  if valid_579742 != nil:
    section.add "merchantId", valid_579742
  var valid_579743 = path.getOrDefault("orderId")
  valid_579743 = validateParameter(valid_579743, JString, required = true,
                                 default = nil)
  if valid_579743 != nil:
    section.add "orderId", valid_579743
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579744 = query.getOrDefault("key")
  valid_579744 = validateParameter(valid_579744, JString, required = false,
                                 default = nil)
  if valid_579744 != nil:
    section.add "key", valid_579744
  var valid_579745 = query.getOrDefault("prettyPrint")
  valid_579745 = validateParameter(valid_579745, JBool, required = false,
                                 default = newJBool(true))
  if valid_579745 != nil:
    section.add "prettyPrint", valid_579745
  var valid_579746 = query.getOrDefault("oauth_token")
  valid_579746 = validateParameter(valid_579746, JString, required = false,
                                 default = nil)
  if valid_579746 != nil:
    section.add "oauth_token", valid_579746
  var valid_579747 = query.getOrDefault("alt")
  valid_579747 = validateParameter(valid_579747, JString, required = false,
                                 default = newJString("json"))
  if valid_579747 != nil:
    section.add "alt", valid_579747
  var valid_579748 = query.getOrDefault("userIp")
  valid_579748 = validateParameter(valid_579748, JString, required = false,
                                 default = nil)
  if valid_579748 != nil:
    section.add "userIp", valid_579748
  var valid_579749 = query.getOrDefault("quotaUser")
  valid_579749 = validateParameter(valid_579749, JString, required = false,
                                 default = nil)
  if valid_579749 != nil:
    section.add "quotaUser", valid_579749
  var valid_579750 = query.getOrDefault("fields")
  valid_579750 = validateParameter(valid_579750, JString, required = false,
                                 default = nil)
  if valid_579750 != nil:
    section.add "fields", valid_579750
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579752: Call_ContentOrdersAcknowledge_579739; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks an order as acknowledged.
  ## 
  let valid = call_579752.validator(path, query, header, formData, body)
  let scheme = call_579752.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579752.url(scheme.get, call_579752.host, call_579752.base,
                         call_579752.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579752, url, valid)

proc call*(call_579753: Call_ContentOrdersAcknowledge_579739; merchantId: string;
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
  var path_579754 = newJObject()
  var query_579755 = newJObject()
  var body_579756 = newJObject()
  add(query_579755, "key", newJString(key))
  add(query_579755, "prettyPrint", newJBool(prettyPrint))
  add(query_579755, "oauth_token", newJString(oauthToken))
  add(query_579755, "alt", newJString(alt))
  add(query_579755, "userIp", newJString(userIp))
  add(query_579755, "quotaUser", newJString(quotaUser))
  add(path_579754, "merchantId", newJString(merchantId))
  if body != nil:
    body_579756 = body
  add(query_579755, "fields", newJString(fields))
  add(path_579754, "orderId", newJString(orderId))
  result = call_579753.call(path_579754, query_579755, nil, nil, body_579756)

var contentOrdersAcknowledge* = Call_ContentOrdersAcknowledge_579739(
    name: "contentOrdersAcknowledge", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/acknowledge",
    validator: validate_ContentOrdersAcknowledge_579740, base: "/content/v2.1",
    url: url_ContentOrdersAcknowledge_579741, schemes: {Scheme.Https})
type
  Call_ContentOrdersCancel_579757 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersCancel_579759(protocol: Scheme; host: string; base: string;
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

proc validate_ContentOrdersCancel_579758(path: JsonNode; query: JsonNode;
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
  var valid_579760 = path.getOrDefault("merchantId")
  valid_579760 = validateParameter(valid_579760, JString, required = true,
                                 default = nil)
  if valid_579760 != nil:
    section.add "merchantId", valid_579760
  var valid_579761 = path.getOrDefault("orderId")
  valid_579761 = validateParameter(valid_579761, JString, required = true,
                                 default = nil)
  if valid_579761 != nil:
    section.add "orderId", valid_579761
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579762 = query.getOrDefault("key")
  valid_579762 = validateParameter(valid_579762, JString, required = false,
                                 default = nil)
  if valid_579762 != nil:
    section.add "key", valid_579762
  var valid_579763 = query.getOrDefault("prettyPrint")
  valid_579763 = validateParameter(valid_579763, JBool, required = false,
                                 default = newJBool(true))
  if valid_579763 != nil:
    section.add "prettyPrint", valid_579763
  var valid_579764 = query.getOrDefault("oauth_token")
  valid_579764 = validateParameter(valid_579764, JString, required = false,
                                 default = nil)
  if valid_579764 != nil:
    section.add "oauth_token", valid_579764
  var valid_579765 = query.getOrDefault("alt")
  valid_579765 = validateParameter(valid_579765, JString, required = false,
                                 default = newJString("json"))
  if valid_579765 != nil:
    section.add "alt", valid_579765
  var valid_579766 = query.getOrDefault("userIp")
  valid_579766 = validateParameter(valid_579766, JString, required = false,
                                 default = nil)
  if valid_579766 != nil:
    section.add "userIp", valid_579766
  var valid_579767 = query.getOrDefault("quotaUser")
  valid_579767 = validateParameter(valid_579767, JString, required = false,
                                 default = nil)
  if valid_579767 != nil:
    section.add "quotaUser", valid_579767
  var valid_579768 = query.getOrDefault("fields")
  valid_579768 = validateParameter(valid_579768, JString, required = false,
                                 default = nil)
  if valid_579768 != nil:
    section.add "fields", valid_579768
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579770: Call_ContentOrdersCancel_579757; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels all line items in an order, making a full refund.
  ## 
  let valid = call_579770.validator(path, query, header, formData, body)
  let scheme = call_579770.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579770.url(scheme.get, call_579770.host, call_579770.base,
                         call_579770.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579770, url, valid)

proc call*(call_579771: Call_ContentOrdersCancel_579757; merchantId: string;
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
  var path_579772 = newJObject()
  var query_579773 = newJObject()
  var body_579774 = newJObject()
  add(query_579773, "key", newJString(key))
  add(query_579773, "prettyPrint", newJBool(prettyPrint))
  add(query_579773, "oauth_token", newJString(oauthToken))
  add(query_579773, "alt", newJString(alt))
  add(query_579773, "userIp", newJString(userIp))
  add(query_579773, "quotaUser", newJString(quotaUser))
  add(path_579772, "merchantId", newJString(merchantId))
  if body != nil:
    body_579774 = body
  add(query_579773, "fields", newJString(fields))
  add(path_579772, "orderId", newJString(orderId))
  result = call_579771.call(path_579772, query_579773, nil, nil, body_579774)

var contentOrdersCancel* = Call_ContentOrdersCancel_579757(
    name: "contentOrdersCancel", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/orders/{orderId}/cancel",
    validator: validate_ContentOrdersCancel_579758, base: "/content/v2.1",
    url: url_ContentOrdersCancel_579759, schemes: {Scheme.Https})
type
  Call_ContentOrdersCancellineitem_579775 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersCancellineitem_579777(protocol: Scheme; host: string;
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

proc validate_ContentOrdersCancellineitem_579776(path: JsonNode; query: JsonNode;
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
  var valid_579778 = path.getOrDefault("merchantId")
  valid_579778 = validateParameter(valid_579778, JString, required = true,
                                 default = nil)
  if valid_579778 != nil:
    section.add "merchantId", valid_579778
  var valid_579779 = path.getOrDefault("orderId")
  valid_579779 = validateParameter(valid_579779, JString, required = true,
                                 default = nil)
  if valid_579779 != nil:
    section.add "orderId", valid_579779
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579780 = query.getOrDefault("key")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = nil)
  if valid_579780 != nil:
    section.add "key", valid_579780
  var valid_579781 = query.getOrDefault("prettyPrint")
  valid_579781 = validateParameter(valid_579781, JBool, required = false,
                                 default = newJBool(true))
  if valid_579781 != nil:
    section.add "prettyPrint", valid_579781
  var valid_579782 = query.getOrDefault("oauth_token")
  valid_579782 = validateParameter(valid_579782, JString, required = false,
                                 default = nil)
  if valid_579782 != nil:
    section.add "oauth_token", valid_579782
  var valid_579783 = query.getOrDefault("alt")
  valid_579783 = validateParameter(valid_579783, JString, required = false,
                                 default = newJString("json"))
  if valid_579783 != nil:
    section.add "alt", valid_579783
  var valid_579784 = query.getOrDefault("userIp")
  valid_579784 = validateParameter(valid_579784, JString, required = false,
                                 default = nil)
  if valid_579784 != nil:
    section.add "userIp", valid_579784
  var valid_579785 = query.getOrDefault("quotaUser")
  valid_579785 = validateParameter(valid_579785, JString, required = false,
                                 default = nil)
  if valid_579785 != nil:
    section.add "quotaUser", valid_579785
  var valid_579786 = query.getOrDefault("fields")
  valid_579786 = validateParameter(valid_579786, JString, required = false,
                                 default = nil)
  if valid_579786 != nil:
    section.add "fields", valid_579786
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579788: Call_ContentOrdersCancellineitem_579775; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a line item, making a full refund.
  ## 
  let valid = call_579788.validator(path, query, header, formData, body)
  let scheme = call_579788.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579788.url(scheme.get, call_579788.host, call_579788.base,
                         call_579788.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579788, url, valid)

proc call*(call_579789: Call_ContentOrdersCancellineitem_579775;
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
  var path_579790 = newJObject()
  var query_579791 = newJObject()
  var body_579792 = newJObject()
  add(query_579791, "key", newJString(key))
  add(query_579791, "prettyPrint", newJBool(prettyPrint))
  add(query_579791, "oauth_token", newJString(oauthToken))
  add(query_579791, "alt", newJString(alt))
  add(query_579791, "userIp", newJString(userIp))
  add(query_579791, "quotaUser", newJString(quotaUser))
  add(path_579790, "merchantId", newJString(merchantId))
  if body != nil:
    body_579792 = body
  add(query_579791, "fields", newJString(fields))
  add(path_579790, "orderId", newJString(orderId))
  result = call_579789.call(path_579790, query_579791, nil, nil, body_579792)

var contentOrdersCancellineitem* = Call_ContentOrdersCancellineitem_579775(
    name: "contentOrdersCancellineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/cancelLineItem",
    validator: validate_ContentOrdersCancellineitem_579776, base: "/content/v2.1",
    url: url_ContentOrdersCancellineitem_579777, schemes: {Scheme.Https})
type
  Call_ContentOrdersInstorerefundlineitem_579793 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersInstorerefundlineitem_579795(protocol: Scheme; host: string;
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

proc validate_ContentOrdersInstorerefundlineitem_579794(path: JsonNode;
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
  var valid_579796 = path.getOrDefault("merchantId")
  valid_579796 = validateParameter(valid_579796, JString, required = true,
                                 default = nil)
  if valid_579796 != nil:
    section.add "merchantId", valid_579796
  var valid_579797 = path.getOrDefault("orderId")
  valid_579797 = validateParameter(valid_579797, JString, required = true,
                                 default = nil)
  if valid_579797 != nil:
    section.add "orderId", valid_579797
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579798 = query.getOrDefault("key")
  valid_579798 = validateParameter(valid_579798, JString, required = false,
                                 default = nil)
  if valid_579798 != nil:
    section.add "key", valid_579798
  var valid_579799 = query.getOrDefault("prettyPrint")
  valid_579799 = validateParameter(valid_579799, JBool, required = false,
                                 default = newJBool(true))
  if valid_579799 != nil:
    section.add "prettyPrint", valid_579799
  var valid_579800 = query.getOrDefault("oauth_token")
  valid_579800 = validateParameter(valid_579800, JString, required = false,
                                 default = nil)
  if valid_579800 != nil:
    section.add "oauth_token", valid_579800
  var valid_579801 = query.getOrDefault("alt")
  valid_579801 = validateParameter(valid_579801, JString, required = false,
                                 default = newJString("json"))
  if valid_579801 != nil:
    section.add "alt", valid_579801
  var valid_579802 = query.getOrDefault("userIp")
  valid_579802 = validateParameter(valid_579802, JString, required = false,
                                 default = nil)
  if valid_579802 != nil:
    section.add "userIp", valid_579802
  var valid_579803 = query.getOrDefault("quotaUser")
  valid_579803 = validateParameter(valid_579803, JString, required = false,
                                 default = nil)
  if valid_579803 != nil:
    section.add "quotaUser", valid_579803
  var valid_579804 = query.getOrDefault("fields")
  valid_579804 = validateParameter(valid_579804, JString, required = false,
                                 default = nil)
  if valid_579804 != nil:
    section.add "fields", valid_579804
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579806: Call_ContentOrdersInstorerefundlineitem_579793;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deprecated. Notifies that item return and refund was handled directly by merchant outside of Google payments processing (e.g. cash refund done in store).
  ## Note: We recommend calling the returnrefundlineitem method to refund in-store returns. We will issue the refund directly to the customer. This helps to prevent possible differences arising between merchant and Google transaction records. We also recommend having the point of sale system communicate with Google to ensure that customers do not receive a double refund by first refunding via Google then via an in-store return.
  ## 
  let valid = call_579806.validator(path, query, header, formData, body)
  let scheme = call_579806.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579806.url(scheme.get, call_579806.host, call_579806.base,
                         call_579806.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579806, url, valid)

proc call*(call_579807: Call_ContentOrdersInstorerefundlineitem_579793;
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
  var path_579808 = newJObject()
  var query_579809 = newJObject()
  var body_579810 = newJObject()
  add(query_579809, "key", newJString(key))
  add(query_579809, "prettyPrint", newJBool(prettyPrint))
  add(query_579809, "oauth_token", newJString(oauthToken))
  add(query_579809, "alt", newJString(alt))
  add(query_579809, "userIp", newJString(userIp))
  add(query_579809, "quotaUser", newJString(quotaUser))
  add(path_579808, "merchantId", newJString(merchantId))
  if body != nil:
    body_579810 = body
  add(query_579809, "fields", newJString(fields))
  add(path_579808, "orderId", newJString(orderId))
  result = call_579807.call(path_579808, query_579809, nil, nil, body_579810)

var contentOrdersInstorerefundlineitem* = Call_ContentOrdersInstorerefundlineitem_579793(
    name: "contentOrdersInstorerefundlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/inStoreRefundLineItem",
    validator: validate_ContentOrdersInstorerefundlineitem_579794,
    base: "/content/v2.1", url: url_ContentOrdersInstorerefundlineitem_579795,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersRejectreturnlineitem_579811 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersRejectreturnlineitem_579813(protocol: Scheme; host: string;
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

proc validate_ContentOrdersRejectreturnlineitem_579812(path: JsonNode;
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
  var valid_579814 = path.getOrDefault("merchantId")
  valid_579814 = validateParameter(valid_579814, JString, required = true,
                                 default = nil)
  if valid_579814 != nil:
    section.add "merchantId", valid_579814
  var valid_579815 = path.getOrDefault("orderId")
  valid_579815 = validateParameter(valid_579815, JString, required = true,
                                 default = nil)
  if valid_579815 != nil:
    section.add "orderId", valid_579815
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579816 = query.getOrDefault("key")
  valid_579816 = validateParameter(valid_579816, JString, required = false,
                                 default = nil)
  if valid_579816 != nil:
    section.add "key", valid_579816
  var valid_579817 = query.getOrDefault("prettyPrint")
  valid_579817 = validateParameter(valid_579817, JBool, required = false,
                                 default = newJBool(true))
  if valid_579817 != nil:
    section.add "prettyPrint", valid_579817
  var valid_579818 = query.getOrDefault("oauth_token")
  valid_579818 = validateParameter(valid_579818, JString, required = false,
                                 default = nil)
  if valid_579818 != nil:
    section.add "oauth_token", valid_579818
  var valid_579819 = query.getOrDefault("alt")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = newJString("json"))
  if valid_579819 != nil:
    section.add "alt", valid_579819
  var valid_579820 = query.getOrDefault("userIp")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "userIp", valid_579820
  var valid_579821 = query.getOrDefault("quotaUser")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "quotaUser", valid_579821
  var valid_579822 = query.getOrDefault("fields")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "fields", valid_579822
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579824: Call_ContentOrdersRejectreturnlineitem_579811;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rejects return on an line item.
  ## 
  let valid = call_579824.validator(path, query, header, formData, body)
  let scheme = call_579824.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579824.url(scheme.get, call_579824.host, call_579824.base,
                         call_579824.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579824, url, valid)

proc call*(call_579825: Call_ContentOrdersRejectreturnlineitem_579811;
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
  var path_579826 = newJObject()
  var query_579827 = newJObject()
  var body_579828 = newJObject()
  add(query_579827, "key", newJString(key))
  add(query_579827, "prettyPrint", newJBool(prettyPrint))
  add(query_579827, "oauth_token", newJString(oauthToken))
  add(query_579827, "alt", newJString(alt))
  add(query_579827, "userIp", newJString(userIp))
  add(query_579827, "quotaUser", newJString(quotaUser))
  add(path_579826, "merchantId", newJString(merchantId))
  if body != nil:
    body_579828 = body
  add(query_579827, "fields", newJString(fields))
  add(path_579826, "orderId", newJString(orderId))
  result = call_579825.call(path_579826, query_579827, nil, nil, body_579828)

var contentOrdersRejectreturnlineitem* = Call_ContentOrdersRejectreturnlineitem_579811(
    name: "contentOrdersRejectreturnlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/rejectReturnLineItem",
    validator: validate_ContentOrdersRejectreturnlineitem_579812,
    base: "/content/v2.1", url: url_ContentOrdersRejectreturnlineitem_579813,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersReturnrefundlineitem_579829 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersReturnrefundlineitem_579831(protocol: Scheme; host: string;
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

proc validate_ContentOrdersReturnrefundlineitem_579830(path: JsonNode;
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
  var valid_579832 = path.getOrDefault("merchantId")
  valid_579832 = validateParameter(valid_579832, JString, required = true,
                                 default = nil)
  if valid_579832 != nil:
    section.add "merchantId", valid_579832
  var valid_579833 = path.getOrDefault("orderId")
  valid_579833 = validateParameter(valid_579833, JString, required = true,
                                 default = nil)
  if valid_579833 != nil:
    section.add "orderId", valid_579833
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579834 = query.getOrDefault("key")
  valid_579834 = validateParameter(valid_579834, JString, required = false,
                                 default = nil)
  if valid_579834 != nil:
    section.add "key", valid_579834
  var valid_579835 = query.getOrDefault("prettyPrint")
  valid_579835 = validateParameter(valid_579835, JBool, required = false,
                                 default = newJBool(true))
  if valid_579835 != nil:
    section.add "prettyPrint", valid_579835
  var valid_579836 = query.getOrDefault("oauth_token")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = nil)
  if valid_579836 != nil:
    section.add "oauth_token", valid_579836
  var valid_579837 = query.getOrDefault("alt")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = newJString("json"))
  if valid_579837 != nil:
    section.add "alt", valid_579837
  var valid_579838 = query.getOrDefault("userIp")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "userIp", valid_579838
  var valid_579839 = query.getOrDefault("quotaUser")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "quotaUser", valid_579839
  var valid_579840 = query.getOrDefault("fields")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "fields", valid_579840
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579842: Call_ContentOrdersReturnrefundlineitem_579829;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns and refunds a line item. Note that this method can only be called on fully shipped orders.
  ## 
  let valid = call_579842.validator(path, query, header, formData, body)
  let scheme = call_579842.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579842.url(scheme.get, call_579842.host, call_579842.base,
                         call_579842.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579842, url, valid)

proc call*(call_579843: Call_ContentOrdersReturnrefundlineitem_579829;
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
  var path_579844 = newJObject()
  var query_579845 = newJObject()
  var body_579846 = newJObject()
  add(query_579845, "key", newJString(key))
  add(query_579845, "prettyPrint", newJBool(prettyPrint))
  add(query_579845, "oauth_token", newJString(oauthToken))
  add(query_579845, "alt", newJString(alt))
  add(query_579845, "userIp", newJString(userIp))
  add(query_579845, "quotaUser", newJString(quotaUser))
  add(path_579844, "merchantId", newJString(merchantId))
  if body != nil:
    body_579846 = body
  add(query_579845, "fields", newJString(fields))
  add(path_579844, "orderId", newJString(orderId))
  result = call_579843.call(path_579844, query_579845, nil, nil, body_579846)

var contentOrdersReturnrefundlineitem* = Call_ContentOrdersReturnrefundlineitem_579829(
    name: "contentOrdersReturnrefundlineitem", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/returnRefundLineItem",
    validator: validate_ContentOrdersReturnrefundlineitem_579830,
    base: "/content/v2.1", url: url_ContentOrdersReturnrefundlineitem_579831,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersSetlineitemmetadata_579847 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersSetlineitemmetadata_579849(protocol: Scheme; host: string;
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

proc validate_ContentOrdersSetlineitemmetadata_579848(path: JsonNode;
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
  var valid_579850 = path.getOrDefault("merchantId")
  valid_579850 = validateParameter(valid_579850, JString, required = true,
                                 default = nil)
  if valid_579850 != nil:
    section.add "merchantId", valid_579850
  var valid_579851 = path.getOrDefault("orderId")
  valid_579851 = validateParameter(valid_579851, JString, required = true,
                                 default = nil)
  if valid_579851 != nil:
    section.add "orderId", valid_579851
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579852 = query.getOrDefault("key")
  valid_579852 = validateParameter(valid_579852, JString, required = false,
                                 default = nil)
  if valid_579852 != nil:
    section.add "key", valid_579852
  var valid_579853 = query.getOrDefault("prettyPrint")
  valid_579853 = validateParameter(valid_579853, JBool, required = false,
                                 default = newJBool(true))
  if valid_579853 != nil:
    section.add "prettyPrint", valid_579853
  var valid_579854 = query.getOrDefault("oauth_token")
  valid_579854 = validateParameter(valid_579854, JString, required = false,
                                 default = nil)
  if valid_579854 != nil:
    section.add "oauth_token", valid_579854
  var valid_579855 = query.getOrDefault("alt")
  valid_579855 = validateParameter(valid_579855, JString, required = false,
                                 default = newJString("json"))
  if valid_579855 != nil:
    section.add "alt", valid_579855
  var valid_579856 = query.getOrDefault("userIp")
  valid_579856 = validateParameter(valid_579856, JString, required = false,
                                 default = nil)
  if valid_579856 != nil:
    section.add "userIp", valid_579856
  var valid_579857 = query.getOrDefault("quotaUser")
  valid_579857 = validateParameter(valid_579857, JString, required = false,
                                 default = nil)
  if valid_579857 != nil:
    section.add "quotaUser", valid_579857
  var valid_579858 = query.getOrDefault("fields")
  valid_579858 = validateParameter(valid_579858, JString, required = false,
                                 default = nil)
  if valid_579858 != nil:
    section.add "fields", valid_579858
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579860: Call_ContentOrdersSetlineitemmetadata_579847;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets (or overrides if it already exists) merchant provided annotations in the form of key-value pairs. A common use case would be to supply us with additional structured information about a line item that cannot be provided via other methods. Submitted key-value pairs can be retrieved as part of the orders resource.
  ## 
  let valid = call_579860.validator(path, query, header, formData, body)
  let scheme = call_579860.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579860.url(scheme.get, call_579860.host, call_579860.base,
                         call_579860.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579860, url, valid)

proc call*(call_579861: Call_ContentOrdersSetlineitemmetadata_579847;
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
  var path_579862 = newJObject()
  var query_579863 = newJObject()
  var body_579864 = newJObject()
  add(query_579863, "key", newJString(key))
  add(query_579863, "prettyPrint", newJBool(prettyPrint))
  add(query_579863, "oauth_token", newJString(oauthToken))
  add(query_579863, "alt", newJString(alt))
  add(query_579863, "userIp", newJString(userIp))
  add(query_579863, "quotaUser", newJString(quotaUser))
  add(path_579862, "merchantId", newJString(merchantId))
  if body != nil:
    body_579864 = body
  add(query_579863, "fields", newJString(fields))
  add(path_579862, "orderId", newJString(orderId))
  result = call_579861.call(path_579862, query_579863, nil, nil, body_579864)

var contentOrdersSetlineitemmetadata* = Call_ContentOrdersSetlineitemmetadata_579847(
    name: "contentOrdersSetlineitemmetadata", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/setLineItemMetadata",
    validator: validate_ContentOrdersSetlineitemmetadata_579848,
    base: "/content/v2.1", url: url_ContentOrdersSetlineitemmetadata_579849,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersShiplineitems_579865 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersShiplineitems_579867(protocol: Scheme; host: string;
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

proc validate_ContentOrdersShiplineitems_579866(path: JsonNode; query: JsonNode;
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
  var valid_579868 = path.getOrDefault("merchantId")
  valid_579868 = validateParameter(valid_579868, JString, required = true,
                                 default = nil)
  if valid_579868 != nil:
    section.add "merchantId", valid_579868
  var valid_579869 = path.getOrDefault("orderId")
  valid_579869 = validateParameter(valid_579869, JString, required = true,
                                 default = nil)
  if valid_579869 != nil:
    section.add "orderId", valid_579869
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579870 = query.getOrDefault("key")
  valid_579870 = validateParameter(valid_579870, JString, required = false,
                                 default = nil)
  if valid_579870 != nil:
    section.add "key", valid_579870
  var valid_579871 = query.getOrDefault("prettyPrint")
  valid_579871 = validateParameter(valid_579871, JBool, required = false,
                                 default = newJBool(true))
  if valid_579871 != nil:
    section.add "prettyPrint", valid_579871
  var valid_579872 = query.getOrDefault("oauth_token")
  valid_579872 = validateParameter(valid_579872, JString, required = false,
                                 default = nil)
  if valid_579872 != nil:
    section.add "oauth_token", valid_579872
  var valid_579873 = query.getOrDefault("alt")
  valid_579873 = validateParameter(valid_579873, JString, required = false,
                                 default = newJString("json"))
  if valid_579873 != nil:
    section.add "alt", valid_579873
  var valid_579874 = query.getOrDefault("userIp")
  valid_579874 = validateParameter(valid_579874, JString, required = false,
                                 default = nil)
  if valid_579874 != nil:
    section.add "userIp", valid_579874
  var valid_579875 = query.getOrDefault("quotaUser")
  valid_579875 = validateParameter(valid_579875, JString, required = false,
                                 default = nil)
  if valid_579875 != nil:
    section.add "quotaUser", valid_579875
  var valid_579876 = query.getOrDefault("fields")
  valid_579876 = validateParameter(valid_579876, JString, required = false,
                                 default = nil)
  if valid_579876 != nil:
    section.add "fields", valid_579876
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579878: Call_ContentOrdersShiplineitems_579865; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks line item(s) as shipped.
  ## 
  let valid = call_579878.validator(path, query, header, formData, body)
  let scheme = call_579878.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579878.url(scheme.get, call_579878.host, call_579878.base,
                         call_579878.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579878, url, valid)

proc call*(call_579879: Call_ContentOrdersShiplineitems_579865; merchantId: string;
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
  var path_579880 = newJObject()
  var query_579881 = newJObject()
  var body_579882 = newJObject()
  add(query_579881, "key", newJString(key))
  add(query_579881, "prettyPrint", newJBool(prettyPrint))
  add(query_579881, "oauth_token", newJString(oauthToken))
  add(query_579881, "alt", newJString(alt))
  add(query_579881, "userIp", newJString(userIp))
  add(query_579881, "quotaUser", newJString(quotaUser))
  add(path_579880, "merchantId", newJString(merchantId))
  if body != nil:
    body_579882 = body
  add(query_579881, "fields", newJString(fields))
  add(path_579880, "orderId", newJString(orderId))
  result = call_579879.call(path_579880, query_579881, nil, nil, body_579882)

var contentOrdersShiplineitems* = Call_ContentOrdersShiplineitems_579865(
    name: "contentOrdersShiplineitems", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/shipLineItems",
    validator: validate_ContentOrdersShiplineitems_579866, base: "/content/v2.1",
    url: url_ContentOrdersShiplineitems_579867, schemes: {Scheme.Https})
type
  Call_ContentOrdersCreatetestreturn_579883 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersCreatetestreturn_579885(protocol: Scheme; host: string;
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

proc validate_ContentOrdersCreatetestreturn_579884(path: JsonNode; query: JsonNode;
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
  var valid_579886 = path.getOrDefault("merchantId")
  valid_579886 = validateParameter(valid_579886, JString, required = true,
                                 default = nil)
  if valid_579886 != nil:
    section.add "merchantId", valid_579886
  var valid_579887 = path.getOrDefault("orderId")
  valid_579887 = validateParameter(valid_579887, JString, required = true,
                                 default = nil)
  if valid_579887 != nil:
    section.add "orderId", valid_579887
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579888 = query.getOrDefault("key")
  valid_579888 = validateParameter(valid_579888, JString, required = false,
                                 default = nil)
  if valid_579888 != nil:
    section.add "key", valid_579888
  var valid_579889 = query.getOrDefault("prettyPrint")
  valid_579889 = validateParameter(valid_579889, JBool, required = false,
                                 default = newJBool(true))
  if valid_579889 != nil:
    section.add "prettyPrint", valid_579889
  var valid_579890 = query.getOrDefault("oauth_token")
  valid_579890 = validateParameter(valid_579890, JString, required = false,
                                 default = nil)
  if valid_579890 != nil:
    section.add "oauth_token", valid_579890
  var valid_579891 = query.getOrDefault("alt")
  valid_579891 = validateParameter(valid_579891, JString, required = false,
                                 default = newJString("json"))
  if valid_579891 != nil:
    section.add "alt", valid_579891
  var valid_579892 = query.getOrDefault("userIp")
  valid_579892 = validateParameter(valid_579892, JString, required = false,
                                 default = nil)
  if valid_579892 != nil:
    section.add "userIp", valid_579892
  var valid_579893 = query.getOrDefault("quotaUser")
  valid_579893 = validateParameter(valid_579893, JString, required = false,
                                 default = nil)
  if valid_579893 != nil:
    section.add "quotaUser", valid_579893
  var valid_579894 = query.getOrDefault("fields")
  valid_579894 = validateParameter(valid_579894, JString, required = false,
                                 default = nil)
  if valid_579894 != nil:
    section.add "fields", valid_579894
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579896: Call_ContentOrdersCreatetestreturn_579883; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Creates a test return.
  ## 
  let valid = call_579896.validator(path, query, header, formData, body)
  let scheme = call_579896.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579896.url(scheme.get, call_579896.host, call_579896.base,
                         call_579896.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579896, url, valid)

proc call*(call_579897: Call_ContentOrdersCreatetestreturn_579883;
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
  var path_579898 = newJObject()
  var query_579899 = newJObject()
  var body_579900 = newJObject()
  add(query_579899, "key", newJString(key))
  add(query_579899, "prettyPrint", newJBool(prettyPrint))
  add(query_579899, "oauth_token", newJString(oauthToken))
  add(query_579899, "alt", newJString(alt))
  add(query_579899, "userIp", newJString(userIp))
  add(query_579899, "quotaUser", newJString(quotaUser))
  add(path_579898, "merchantId", newJString(merchantId))
  if body != nil:
    body_579900 = body
  add(query_579899, "fields", newJString(fields))
  add(path_579898, "orderId", newJString(orderId))
  result = call_579897.call(path_579898, query_579899, nil, nil, body_579900)

var contentOrdersCreatetestreturn* = Call_ContentOrdersCreatetestreturn_579883(
    name: "contentOrdersCreatetestreturn", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/testreturn",
    validator: validate_ContentOrdersCreatetestreturn_579884,
    base: "/content/v2.1", url: url_ContentOrdersCreatetestreturn_579885,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdatelineitemshippingdetails_579901 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersUpdatelineitemshippingdetails_579903(protocol: Scheme;
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

proc validate_ContentOrdersUpdatelineitemshippingdetails_579902(path: JsonNode;
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
  var valid_579904 = path.getOrDefault("merchantId")
  valid_579904 = validateParameter(valid_579904, JString, required = true,
                                 default = nil)
  if valid_579904 != nil:
    section.add "merchantId", valid_579904
  var valid_579905 = path.getOrDefault("orderId")
  valid_579905 = validateParameter(valid_579905, JString, required = true,
                                 default = nil)
  if valid_579905 != nil:
    section.add "orderId", valid_579905
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579906 = query.getOrDefault("key")
  valid_579906 = validateParameter(valid_579906, JString, required = false,
                                 default = nil)
  if valid_579906 != nil:
    section.add "key", valid_579906
  var valid_579907 = query.getOrDefault("prettyPrint")
  valid_579907 = validateParameter(valid_579907, JBool, required = false,
                                 default = newJBool(true))
  if valid_579907 != nil:
    section.add "prettyPrint", valid_579907
  var valid_579908 = query.getOrDefault("oauth_token")
  valid_579908 = validateParameter(valid_579908, JString, required = false,
                                 default = nil)
  if valid_579908 != nil:
    section.add "oauth_token", valid_579908
  var valid_579909 = query.getOrDefault("alt")
  valid_579909 = validateParameter(valid_579909, JString, required = false,
                                 default = newJString("json"))
  if valid_579909 != nil:
    section.add "alt", valid_579909
  var valid_579910 = query.getOrDefault("userIp")
  valid_579910 = validateParameter(valid_579910, JString, required = false,
                                 default = nil)
  if valid_579910 != nil:
    section.add "userIp", valid_579910
  var valid_579911 = query.getOrDefault("quotaUser")
  valid_579911 = validateParameter(valid_579911, JString, required = false,
                                 default = nil)
  if valid_579911 != nil:
    section.add "quotaUser", valid_579911
  var valid_579912 = query.getOrDefault("fields")
  valid_579912 = validateParameter(valid_579912, JString, required = false,
                                 default = nil)
  if valid_579912 != nil:
    section.add "fields", valid_579912
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579914: Call_ContentOrdersUpdatelineitemshippingdetails_579901;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates ship by and delivery by dates for a line item.
  ## 
  let valid = call_579914.validator(path, query, header, formData, body)
  let scheme = call_579914.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579914.url(scheme.get, call_579914.host, call_579914.base,
                         call_579914.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579914, url, valid)

proc call*(call_579915: Call_ContentOrdersUpdatelineitemshippingdetails_579901;
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
  var path_579916 = newJObject()
  var query_579917 = newJObject()
  var body_579918 = newJObject()
  add(query_579917, "key", newJString(key))
  add(query_579917, "prettyPrint", newJBool(prettyPrint))
  add(query_579917, "oauth_token", newJString(oauthToken))
  add(query_579917, "alt", newJString(alt))
  add(query_579917, "userIp", newJString(userIp))
  add(query_579917, "quotaUser", newJString(quotaUser))
  add(path_579916, "merchantId", newJString(merchantId))
  if body != nil:
    body_579918 = body
  add(query_579917, "fields", newJString(fields))
  add(path_579916, "orderId", newJString(orderId))
  result = call_579915.call(path_579916, query_579917, nil, nil, body_579918)

var contentOrdersUpdatelineitemshippingdetails* = Call_ContentOrdersUpdatelineitemshippingdetails_579901(
    name: "contentOrdersUpdatelineitemshippingdetails", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateLineItemShippingDetails",
    validator: validate_ContentOrdersUpdatelineitemshippingdetails_579902,
    base: "/content/v2.1", url: url_ContentOrdersUpdatelineitemshippingdetails_579903,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdatemerchantorderid_579919 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersUpdatemerchantorderid_579921(protocol: Scheme; host: string;
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

proc validate_ContentOrdersUpdatemerchantorderid_579920(path: JsonNode;
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
  var valid_579922 = path.getOrDefault("merchantId")
  valid_579922 = validateParameter(valid_579922, JString, required = true,
                                 default = nil)
  if valid_579922 != nil:
    section.add "merchantId", valid_579922
  var valid_579923 = path.getOrDefault("orderId")
  valid_579923 = validateParameter(valid_579923, JString, required = true,
                                 default = nil)
  if valid_579923 != nil:
    section.add "orderId", valid_579923
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579924 = query.getOrDefault("key")
  valid_579924 = validateParameter(valid_579924, JString, required = false,
                                 default = nil)
  if valid_579924 != nil:
    section.add "key", valid_579924
  var valid_579925 = query.getOrDefault("prettyPrint")
  valid_579925 = validateParameter(valid_579925, JBool, required = false,
                                 default = newJBool(true))
  if valid_579925 != nil:
    section.add "prettyPrint", valid_579925
  var valid_579926 = query.getOrDefault("oauth_token")
  valid_579926 = validateParameter(valid_579926, JString, required = false,
                                 default = nil)
  if valid_579926 != nil:
    section.add "oauth_token", valid_579926
  var valid_579927 = query.getOrDefault("alt")
  valid_579927 = validateParameter(valid_579927, JString, required = false,
                                 default = newJString("json"))
  if valid_579927 != nil:
    section.add "alt", valid_579927
  var valid_579928 = query.getOrDefault("userIp")
  valid_579928 = validateParameter(valid_579928, JString, required = false,
                                 default = nil)
  if valid_579928 != nil:
    section.add "userIp", valid_579928
  var valid_579929 = query.getOrDefault("quotaUser")
  valid_579929 = validateParameter(valid_579929, JString, required = false,
                                 default = nil)
  if valid_579929 != nil:
    section.add "quotaUser", valid_579929
  var valid_579930 = query.getOrDefault("fields")
  valid_579930 = validateParameter(valid_579930, JString, required = false,
                                 default = nil)
  if valid_579930 != nil:
    section.add "fields", valid_579930
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579932: Call_ContentOrdersUpdatemerchantorderid_579919;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the merchant order ID for a given order.
  ## 
  let valid = call_579932.validator(path, query, header, formData, body)
  let scheme = call_579932.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579932.url(scheme.get, call_579932.host, call_579932.base,
                         call_579932.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579932, url, valid)

proc call*(call_579933: Call_ContentOrdersUpdatemerchantorderid_579919;
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
  var path_579934 = newJObject()
  var query_579935 = newJObject()
  var body_579936 = newJObject()
  add(query_579935, "key", newJString(key))
  add(query_579935, "prettyPrint", newJBool(prettyPrint))
  add(query_579935, "oauth_token", newJString(oauthToken))
  add(query_579935, "alt", newJString(alt))
  add(query_579935, "userIp", newJString(userIp))
  add(query_579935, "quotaUser", newJString(quotaUser))
  add(path_579934, "merchantId", newJString(merchantId))
  if body != nil:
    body_579936 = body
  add(query_579935, "fields", newJString(fields))
  add(path_579934, "orderId", newJString(orderId))
  result = call_579933.call(path_579934, query_579935, nil, nil, body_579936)

var contentOrdersUpdatemerchantorderid* = Call_ContentOrdersUpdatemerchantorderid_579919(
    name: "contentOrdersUpdatemerchantorderid", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateMerchantOrderId",
    validator: validate_ContentOrdersUpdatemerchantorderid_579920,
    base: "/content/v2.1", url: url_ContentOrdersUpdatemerchantorderid_579921,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersUpdateshipment_579937 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersUpdateshipment_579939(protocol: Scheme; host: string;
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

proc validate_ContentOrdersUpdateshipment_579938(path: JsonNode; query: JsonNode;
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
  var valid_579940 = path.getOrDefault("merchantId")
  valid_579940 = validateParameter(valid_579940, JString, required = true,
                                 default = nil)
  if valid_579940 != nil:
    section.add "merchantId", valid_579940
  var valid_579941 = path.getOrDefault("orderId")
  valid_579941 = validateParameter(valid_579941, JString, required = true,
                                 default = nil)
  if valid_579941 != nil:
    section.add "orderId", valid_579941
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579942 = query.getOrDefault("key")
  valid_579942 = validateParameter(valid_579942, JString, required = false,
                                 default = nil)
  if valid_579942 != nil:
    section.add "key", valid_579942
  var valid_579943 = query.getOrDefault("prettyPrint")
  valid_579943 = validateParameter(valid_579943, JBool, required = false,
                                 default = newJBool(true))
  if valid_579943 != nil:
    section.add "prettyPrint", valid_579943
  var valid_579944 = query.getOrDefault("oauth_token")
  valid_579944 = validateParameter(valid_579944, JString, required = false,
                                 default = nil)
  if valid_579944 != nil:
    section.add "oauth_token", valid_579944
  var valid_579945 = query.getOrDefault("alt")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = newJString("json"))
  if valid_579945 != nil:
    section.add "alt", valid_579945
  var valid_579946 = query.getOrDefault("userIp")
  valid_579946 = validateParameter(valid_579946, JString, required = false,
                                 default = nil)
  if valid_579946 != nil:
    section.add "userIp", valid_579946
  var valid_579947 = query.getOrDefault("quotaUser")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = nil)
  if valid_579947 != nil:
    section.add "quotaUser", valid_579947
  var valid_579948 = query.getOrDefault("fields")
  valid_579948 = validateParameter(valid_579948, JString, required = false,
                                 default = nil)
  if valid_579948 != nil:
    section.add "fields", valid_579948
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579950: Call_ContentOrdersUpdateshipment_579937; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a shipment's status, carrier, and/or tracking ID.
  ## 
  let valid = call_579950.validator(path, query, header, formData, body)
  let scheme = call_579950.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579950.url(scheme.get, call_579950.host, call_579950.base,
                         call_579950.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579950, url, valid)

proc call*(call_579951: Call_ContentOrdersUpdateshipment_579937;
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
  var path_579952 = newJObject()
  var query_579953 = newJObject()
  var body_579954 = newJObject()
  add(query_579953, "key", newJString(key))
  add(query_579953, "prettyPrint", newJBool(prettyPrint))
  add(query_579953, "oauth_token", newJString(oauthToken))
  add(query_579953, "alt", newJString(alt))
  add(query_579953, "userIp", newJString(userIp))
  add(query_579953, "quotaUser", newJString(quotaUser))
  add(path_579952, "merchantId", newJString(merchantId))
  if body != nil:
    body_579954 = body
  add(query_579953, "fields", newJString(fields))
  add(path_579952, "orderId", newJString(orderId))
  result = call_579951.call(path_579952, query_579953, nil, nil, body_579954)

var contentOrdersUpdateshipment* = Call_ContentOrdersUpdateshipment_579937(
    name: "contentOrdersUpdateshipment", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/orders/{orderId}/updateShipment",
    validator: validate_ContentOrdersUpdateshipment_579938, base: "/content/v2.1",
    url: url_ContentOrdersUpdateshipment_579939, schemes: {Scheme.Https})
type
  Call_ContentOrdersGetbymerchantorderid_579955 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersGetbymerchantorderid_579957(protocol: Scheme; host: string;
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

proc validate_ContentOrdersGetbymerchantorderid_579956(path: JsonNode;
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
  var valid_579958 = path.getOrDefault("merchantOrderId")
  valid_579958 = validateParameter(valid_579958, JString, required = true,
                                 default = nil)
  if valid_579958 != nil:
    section.add "merchantOrderId", valid_579958
  var valid_579959 = path.getOrDefault("merchantId")
  valid_579959 = validateParameter(valid_579959, JString, required = true,
                                 default = nil)
  if valid_579959 != nil:
    section.add "merchantId", valid_579959
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  if body != nil:
    result.add "body", body

proc call*(call_579967: Call_ContentOrdersGetbymerchantorderid_579955;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves an order using merchant order ID.
  ## 
  let valid = call_579967.validator(path, query, header, formData, body)
  let scheme = call_579967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579967.url(scheme.get, call_579967.host, call_579967.base,
                         call_579967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579967, url, valid)

proc call*(call_579968: Call_ContentOrdersGetbymerchantorderid_579955;
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
  var path_579969 = newJObject()
  var query_579970 = newJObject()
  add(query_579970, "key", newJString(key))
  add(query_579970, "prettyPrint", newJBool(prettyPrint))
  add(query_579970, "oauth_token", newJString(oauthToken))
  add(path_579969, "merchantOrderId", newJString(merchantOrderId))
  add(query_579970, "alt", newJString(alt))
  add(query_579970, "userIp", newJString(userIp))
  add(query_579970, "quotaUser", newJString(quotaUser))
  add(path_579969, "merchantId", newJString(merchantId))
  add(query_579970, "fields", newJString(fields))
  result = call_579968.call(path_579969, query_579970, nil, nil, nil)

var contentOrdersGetbymerchantorderid* = Call_ContentOrdersGetbymerchantorderid_579955(
    name: "contentOrdersGetbymerchantorderid", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/ordersbymerchantid/{merchantOrderId}",
    validator: validate_ContentOrdersGetbymerchantorderid_579956,
    base: "/content/v2.1", url: url_ContentOrdersGetbymerchantorderid_579957,
    schemes: {Scheme.Https})
type
  Call_ContentPosInventory_579971 = ref object of OpenApiRestCall_578348
proc url_ContentPosInventory_579973(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosInventory_579972(path: JsonNode; query: JsonNode;
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
  var valid_579974 = path.getOrDefault("targetMerchantId")
  valid_579974 = validateParameter(valid_579974, JString, required = true,
                                 default = nil)
  if valid_579974 != nil:
    section.add "targetMerchantId", valid_579974
  var valid_579975 = path.getOrDefault("merchantId")
  valid_579975 = validateParameter(valid_579975, JString, required = true,
                                 default = nil)
  if valid_579975 != nil:
    section.add "merchantId", valid_579975
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579976 = query.getOrDefault("key")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "key", valid_579976
  var valid_579977 = query.getOrDefault("prettyPrint")
  valid_579977 = validateParameter(valid_579977, JBool, required = false,
                                 default = newJBool(true))
  if valid_579977 != nil:
    section.add "prettyPrint", valid_579977
  var valid_579978 = query.getOrDefault("oauth_token")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "oauth_token", valid_579978
  var valid_579979 = query.getOrDefault("alt")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = newJString("json"))
  if valid_579979 != nil:
    section.add "alt", valid_579979
  var valid_579980 = query.getOrDefault("userIp")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "userIp", valid_579980
  var valid_579981 = query.getOrDefault("quotaUser")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "quotaUser", valid_579981
  var valid_579982 = query.getOrDefault("fields")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "fields", valid_579982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579984: Call_ContentPosInventory_579971; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit inventory for the given merchant.
  ## 
  let valid = call_579984.validator(path, query, header, formData, body)
  let scheme = call_579984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579984.url(scheme.get, call_579984.host, call_579984.base,
                         call_579984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579984, url, valid)

proc call*(call_579985: Call_ContentPosInventory_579971; targetMerchantId: string;
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
  var path_579986 = newJObject()
  var query_579987 = newJObject()
  var body_579988 = newJObject()
  add(query_579987, "key", newJString(key))
  add(query_579987, "prettyPrint", newJBool(prettyPrint))
  add(query_579987, "oauth_token", newJString(oauthToken))
  add(path_579986, "targetMerchantId", newJString(targetMerchantId))
  add(query_579987, "alt", newJString(alt))
  add(query_579987, "userIp", newJString(userIp))
  add(query_579987, "quotaUser", newJString(quotaUser))
  add(path_579986, "merchantId", newJString(merchantId))
  if body != nil:
    body_579988 = body
  add(query_579987, "fields", newJString(fields))
  result = call_579985.call(path_579986, query_579987, nil, nil, body_579988)

var contentPosInventory* = Call_ContentPosInventory_579971(
    name: "contentPosInventory", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/inventory",
    validator: validate_ContentPosInventory_579972, base: "/content/v2.1",
    url: url_ContentPosInventory_579973, schemes: {Scheme.Https})
type
  Call_ContentPosSale_579989 = ref object of OpenApiRestCall_578348
proc url_ContentPosSale_579991(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosSale_579990(path: JsonNode; query: JsonNode;
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
  var valid_579992 = path.getOrDefault("targetMerchantId")
  valid_579992 = validateParameter(valid_579992, JString, required = true,
                                 default = nil)
  if valid_579992 != nil:
    section.add "targetMerchantId", valid_579992
  var valid_579993 = path.getOrDefault("merchantId")
  valid_579993 = validateParameter(valid_579993, JString, required = true,
                                 default = nil)
  if valid_579993 != nil:
    section.add "merchantId", valid_579993
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579994 = query.getOrDefault("key")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "key", valid_579994
  var valid_579995 = query.getOrDefault("prettyPrint")
  valid_579995 = validateParameter(valid_579995, JBool, required = false,
                                 default = newJBool(true))
  if valid_579995 != nil:
    section.add "prettyPrint", valid_579995
  var valid_579996 = query.getOrDefault("oauth_token")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "oauth_token", valid_579996
  var valid_579997 = query.getOrDefault("alt")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = newJString("json"))
  if valid_579997 != nil:
    section.add "alt", valid_579997
  var valid_579998 = query.getOrDefault("userIp")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "userIp", valid_579998
  var valid_579999 = query.getOrDefault("quotaUser")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "quotaUser", valid_579999
  var valid_580000 = query.getOrDefault("fields")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "fields", valid_580000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580002: Call_ContentPosSale_579989; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit a sale event for the given merchant.
  ## 
  let valid = call_580002.validator(path, query, header, formData, body)
  let scheme = call_580002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580002.url(scheme.get, call_580002.host, call_580002.base,
                         call_580002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580002, url, valid)

proc call*(call_580003: Call_ContentPosSale_579989; targetMerchantId: string;
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
  var path_580004 = newJObject()
  var query_580005 = newJObject()
  var body_580006 = newJObject()
  add(query_580005, "key", newJString(key))
  add(query_580005, "prettyPrint", newJBool(prettyPrint))
  add(query_580005, "oauth_token", newJString(oauthToken))
  add(path_580004, "targetMerchantId", newJString(targetMerchantId))
  add(query_580005, "alt", newJString(alt))
  add(query_580005, "userIp", newJString(userIp))
  add(query_580005, "quotaUser", newJString(quotaUser))
  add(path_580004, "merchantId", newJString(merchantId))
  if body != nil:
    body_580006 = body
  add(query_580005, "fields", newJString(fields))
  result = call_580003.call(path_580004, query_580005, nil, nil, body_580006)

var contentPosSale* = Call_ContentPosSale_579989(name: "contentPosSale",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/sale",
    validator: validate_ContentPosSale_579990, base: "/content/v2.1",
    url: url_ContentPosSale_579991, schemes: {Scheme.Https})
type
  Call_ContentPosInsert_580023 = ref object of OpenApiRestCall_578348
proc url_ContentPosInsert_580025(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosInsert_580024(path: JsonNode; query: JsonNode;
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
  var valid_580026 = path.getOrDefault("targetMerchantId")
  valid_580026 = validateParameter(valid_580026, JString, required = true,
                                 default = nil)
  if valid_580026 != nil:
    section.add "targetMerchantId", valid_580026
  var valid_580027 = path.getOrDefault("merchantId")
  valid_580027 = validateParameter(valid_580027, JString, required = true,
                                 default = nil)
  if valid_580027 != nil:
    section.add "merchantId", valid_580027
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580030 = query.getOrDefault("oauth_token")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "oauth_token", valid_580030
  var valid_580031 = query.getOrDefault("alt")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = newJString("json"))
  if valid_580031 != nil:
    section.add "alt", valid_580031
  var valid_580032 = query.getOrDefault("userIp")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "userIp", valid_580032
  var valid_580033 = query.getOrDefault("quotaUser")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "quotaUser", valid_580033
  var valid_580034 = query.getOrDefault("fields")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "fields", valid_580034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580036: Call_ContentPosInsert_580023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a store for the given merchant.
  ## 
  let valid = call_580036.validator(path, query, header, formData, body)
  let scheme = call_580036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580036.url(scheme.get, call_580036.host, call_580036.base,
                         call_580036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580036, url, valid)

proc call*(call_580037: Call_ContentPosInsert_580023; targetMerchantId: string;
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
  var path_580038 = newJObject()
  var query_580039 = newJObject()
  var body_580040 = newJObject()
  add(query_580039, "key", newJString(key))
  add(query_580039, "prettyPrint", newJBool(prettyPrint))
  add(query_580039, "oauth_token", newJString(oauthToken))
  add(path_580038, "targetMerchantId", newJString(targetMerchantId))
  add(query_580039, "alt", newJString(alt))
  add(query_580039, "userIp", newJString(userIp))
  add(query_580039, "quotaUser", newJString(quotaUser))
  add(path_580038, "merchantId", newJString(merchantId))
  if body != nil:
    body_580040 = body
  add(query_580039, "fields", newJString(fields))
  result = call_580037.call(path_580038, query_580039, nil, nil, body_580040)

var contentPosInsert* = Call_ContentPosInsert_580023(name: "contentPosInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store",
    validator: validate_ContentPosInsert_580024, base: "/content/v2.1",
    url: url_ContentPosInsert_580025, schemes: {Scheme.Https})
type
  Call_ContentPosList_580007 = ref object of OpenApiRestCall_578348
proc url_ContentPosList_580009(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosList_580008(path: JsonNode; query: JsonNode;
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
  var valid_580010 = path.getOrDefault("targetMerchantId")
  valid_580010 = validateParameter(valid_580010, JString, required = true,
                                 default = nil)
  if valid_580010 != nil:
    section.add "targetMerchantId", valid_580010
  var valid_580011 = path.getOrDefault("merchantId")
  valid_580011 = validateParameter(valid_580011, JString, required = true,
                                 default = nil)
  if valid_580011 != nil:
    section.add "merchantId", valid_580011
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580012 = query.getOrDefault("key")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "key", valid_580012
  var valid_580013 = query.getOrDefault("prettyPrint")
  valid_580013 = validateParameter(valid_580013, JBool, required = false,
                                 default = newJBool(true))
  if valid_580013 != nil:
    section.add "prettyPrint", valid_580013
  var valid_580014 = query.getOrDefault("oauth_token")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "oauth_token", valid_580014
  var valid_580015 = query.getOrDefault("alt")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = newJString("json"))
  if valid_580015 != nil:
    section.add "alt", valid_580015
  var valid_580016 = query.getOrDefault("userIp")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "userIp", valid_580016
  var valid_580017 = query.getOrDefault("quotaUser")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "quotaUser", valid_580017
  var valid_580018 = query.getOrDefault("fields")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "fields", valid_580018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580019: Call_ContentPosList_580007; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the stores of the target merchant.
  ## 
  let valid = call_580019.validator(path, query, header, formData, body)
  let scheme = call_580019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580019.url(scheme.get, call_580019.host, call_580019.base,
                         call_580019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580019, url, valid)

proc call*(call_580020: Call_ContentPosList_580007; targetMerchantId: string;
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
  var path_580021 = newJObject()
  var query_580022 = newJObject()
  add(query_580022, "key", newJString(key))
  add(query_580022, "prettyPrint", newJBool(prettyPrint))
  add(query_580022, "oauth_token", newJString(oauthToken))
  add(path_580021, "targetMerchantId", newJString(targetMerchantId))
  add(query_580022, "alt", newJString(alt))
  add(query_580022, "userIp", newJString(userIp))
  add(query_580022, "quotaUser", newJString(quotaUser))
  add(path_580021, "merchantId", newJString(merchantId))
  add(query_580022, "fields", newJString(fields))
  result = call_580020.call(path_580021, query_580022, nil, nil, nil)

var contentPosList* = Call_ContentPosList_580007(name: "contentPosList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store",
    validator: validate_ContentPosList_580008, base: "/content/v2.1",
    url: url_ContentPosList_580009, schemes: {Scheme.Https})
type
  Call_ContentPosGet_580041 = ref object of OpenApiRestCall_578348
proc url_ContentPosGet_580043(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosGet_580042(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_580044 = path.getOrDefault("targetMerchantId")
  valid_580044 = validateParameter(valid_580044, JString, required = true,
                                 default = nil)
  if valid_580044 != nil:
    section.add "targetMerchantId", valid_580044
  var valid_580045 = path.getOrDefault("storeCode")
  valid_580045 = validateParameter(valid_580045, JString, required = true,
                                 default = nil)
  if valid_580045 != nil:
    section.add "storeCode", valid_580045
  var valid_580046 = path.getOrDefault("merchantId")
  valid_580046 = validateParameter(valid_580046, JString, required = true,
                                 default = nil)
  if valid_580046 != nil:
    section.add "merchantId", valid_580046
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580047 = query.getOrDefault("key")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "key", valid_580047
  var valid_580048 = query.getOrDefault("prettyPrint")
  valid_580048 = validateParameter(valid_580048, JBool, required = false,
                                 default = newJBool(true))
  if valid_580048 != nil:
    section.add "prettyPrint", valid_580048
  var valid_580049 = query.getOrDefault("oauth_token")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "oauth_token", valid_580049
  var valid_580050 = query.getOrDefault("alt")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = newJString("json"))
  if valid_580050 != nil:
    section.add "alt", valid_580050
  var valid_580051 = query.getOrDefault("userIp")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "userIp", valid_580051
  var valid_580052 = query.getOrDefault("quotaUser")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "quotaUser", valid_580052
  var valid_580053 = query.getOrDefault("fields")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "fields", valid_580053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580054: Call_ContentPosGet_580041; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about the given store.
  ## 
  let valid = call_580054.validator(path, query, header, formData, body)
  let scheme = call_580054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580054.url(scheme.get, call_580054.host, call_580054.base,
                         call_580054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580054, url, valid)

proc call*(call_580055: Call_ContentPosGet_580041; targetMerchantId: string;
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
  var path_580056 = newJObject()
  var query_580057 = newJObject()
  add(query_580057, "key", newJString(key))
  add(query_580057, "prettyPrint", newJBool(prettyPrint))
  add(query_580057, "oauth_token", newJString(oauthToken))
  add(path_580056, "targetMerchantId", newJString(targetMerchantId))
  add(path_580056, "storeCode", newJString(storeCode))
  add(query_580057, "alt", newJString(alt))
  add(query_580057, "userIp", newJString(userIp))
  add(query_580057, "quotaUser", newJString(quotaUser))
  add(path_580056, "merchantId", newJString(merchantId))
  add(query_580057, "fields", newJString(fields))
  result = call_580055.call(path_580056, query_580057, nil, nil, nil)

var contentPosGet* = Call_ContentPosGet_580041(name: "contentPosGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store/{storeCode}",
    validator: validate_ContentPosGet_580042, base: "/content/v2.1",
    url: url_ContentPosGet_580043, schemes: {Scheme.Https})
type
  Call_ContentPosDelete_580058 = ref object of OpenApiRestCall_578348
proc url_ContentPosDelete_580060(protocol: Scheme; host: string; base: string;
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

proc validate_ContentPosDelete_580059(path: JsonNode; query: JsonNode;
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
  var valid_580061 = path.getOrDefault("targetMerchantId")
  valid_580061 = validateParameter(valid_580061, JString, required = true,
                                 default = nil)
  if valid_580061 != nil:
    section.add "targetMerchantId", valid_580061
  var valid_580062 = path.getOrDefault("storeCode")
  valid_580062 = validateParameter(valid_580062, JString, required = true,
                                 default = nil)
  if valid_580062 != nil:
    section.add "storeCode", valid_580062
  var valid_580063 = path.getOrDefault("merchantId")
  valid_580063 = validateParameter(valid_580063, JString, required = true,
                                 default = nil)
  if valid_580063 != nil:
    section.add "merchantId", valid_580063
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580064 = query.getOrDefault("key")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "key", valid_580064
  var valid_580065 = query.getOrDefault("prettyPrint")
  valid_580065 = validateParameter(valid_580065, JBool, required = false,
                                 default = newJBool(true))
  if valid_580065 != nil:
    section.add "prettyPrint", valid_580065
  var valid_580066 = query.getOrDefault("oauth_token")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "oauth_token", valid_580066
  var valid_580067 = query.getOrDefault("alt")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = newJString("json"))
  if valid_580067 != nil:
    section.add "alt", valid_580067
  var valid_580068 = query.getOrDefault("userIp")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "userIp", valid_580068
  var valid_580069 = query.getOrDefault("quotaUser")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "quotaUser", valid_580069
  var valid_580070 = query.getOrDefault("fields")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "fields", valid_580070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580071: Call_ContentPosDelete_580058; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a store for the given merchant.
  ## 
  let valid = call_580071.validator(path, query, header, formData, body)
  let scheme = call_580071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580071.url(scheme.get, call_580071.host, call_580071.base,
                         call_580071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580071, url, valid)

proc call*(call_580072: Call_ContentPosDelete_580058; targetMerchantId: string;
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
  var path_580073 = newJObject()
  var query_580074 = newJObject()
  add(query_580074, "key", newJString(key))
  add(query_580074, "prettyPrint", newJBool(prettyPrint))
  add(query_580074, "oauth_token", newJString(oauthToken))
  add(path_580073, "targetMerchantId", newJString(targetMerchantId))
  add(path_580073, "storeCode", newJString(storeCode))
  add(query_580074, "alt", newJString(alt))
  add(query_580074, "userIp", newJString(userIp))
  add(query_580074, "quotaUser", newJString(quotaUser))
  add(path_580073, "merchantId", newJString(merchantId))
  add(query_580074, "fields", newJString(fields))
  result = call_580072.call(path_580073, query_580074, nil, nil, nil)

var contentPosDelete* = Call_ContentPosDelete_580058(name: "contentPosDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/{merchantId}/pos/{targetMerchantId}/store/{storeCode}",
    validator: validate_ContentPosDelete_580059, base: "/content/v2.1",
    url: url_ContentPosDelete_580060, schemes: {Scheme.Https})
type
  Call_ContentProductsInsert_580092 = ref object of OpenApiRestCall_578348
proc url_ContentProductsInsert_580094(protocol: Scheme; host: string; base: string;
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

proc validate_ContentProductsInsert_580093(path: JsonNode; query: JsonNode;
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
  var valid_580095 = path.getOrDefault("merchantId")
  valid_580095 = validateParameter(valid_580095, JString, required = true,
                                 default = nil)
  if valid_580095 != nil:
    section.add "merchantId", valid_580095
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580096 = query.getOrDefault("key")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "key", valid_580096
  var valid_580097 = query.getOrDefault("prettyPrint")
  valid_580097 = validateParameter(valid_580097, JBool, required = false,
                                 default = newJBool(true))
  if valid_580097 != nil:
    section.add "prettyPrint", valid_580097
  var valid_580098 = query.getOrDefault("oauth_token")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "oauth_token", valid_580098
  var valid_580099 = query.getOrDefault("alt")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = newJString("json"))
  if valid_580099 != nil:
    section.add "alt", valid_580099
  var valid_580100 = query.getOrDefault("userIp")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "userIp", valid_580100
  var valid_580101 = query.getOrDefault("quotaUser")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "quotaUser", valid_580101
  var valid_580102 = query.getOrDefault("feedId")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "feedId", valid_580102
  var valid_580103 = query.getOrDefault("fields")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "fields", valid_580103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580105: Call_ContentProductsInsert_580092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a product to your Merchant Center account. If an item with the same channel, contentLanguage, offerId, and targetCountry already exists, this method updates that entry.
  ## 
  let valid = call_580105.validator(path, query, header, formData, body)
  let scheme = call_580105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580105.url(scheme.get, call_580105.host, call_580105.base,
                         call_580105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580105, url, valid)

proc call*(call_580106: Call_ContentProductsInsert_580092; merchantId: string;
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
  var path_580107 = newJObject()
  var query_580108 = newJObject()
  var body_580109 = newJObject()
  add(query_580108, "key", newJString(key))
  add(query_580108, "prettyPrint", newJBool(prettyPrint))
  add(query_580108, "oauth_token", newJString(oauthToken))
  add(query_580108, "alt", newJString(alt))
  add(query_580108, "userIp", newJString(userIp))
  add(query_580108, "quotaUser", newJString(quotaUser))
  add(path_580107, "merchantId", newJString(merchantId))
  add(query_580108, "feedId", newJString(feedId))
  if body != nil:
    body_580109 = body
  add(query_580108, "fields", newJString(fields))
  result = call_580106.call(path_580107, query_580108, nil, nil, body_580109)

var contentProductsInsert* = Call_ContentProductsInsert_580092(
    name: "contentProductsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/products",
    validator: validate_ContentProductsInsert_580093, base: "/content/v2.1",
    url: url_ContentProductsInsert_580094, schemes: {Scheme.Https})
type
  Call_ContentProductsList_580075 = ref object of OpenApiRestCall_578348
proc url_ContentProductsList_580077(protocol: Scheme; host: string; base: string;
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

proc validate_ContentProductsList_580076(path: JsonNode; query: JsonNode;
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
  var valid_580078 = path.getOrDefault("merchantId")
  valid_580078 = validateParameter(valid_580078, JString, required = true,
                                 default = nil)
  if valid_580078 != nil:
    section.add "merchantId", valid_580078
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580079 = query.getOrDefault("key")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "key", valid_580079
  var valid_580080 = query.getOrDefault("prettyPrint")
  valid_580080 = validateParameter(valid_580080, JBool, required = false,
                                 default = newJBool(true))
  if valid_580080 != nil:
    section.add "prettyPrint", valid_580080
  var valid_580081 = query.getOrDefault("oauth_token")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "oauth_token", valid_580081
  var valid_580082 = query.getOrDefault("alt")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = newJString("json"))
  if valid_580082 != nil:
    section.add "alt", valid_580082
  var valid_580083 = query.getOrDefault("userIp")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "userIp", valid_580083
  var valid_580084 = query.getOrDefault("quotaUser")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "quotaUser", valid_580084
  var valid_580085 = query.getOrDefault("pageToken")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "pageToken", valid_580085
  var valid_580086 = query.getOrDefault("fields")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "fields", valid_580086
  var valid_580087 = query.getOrDefault("maxResults")
  valid_580087 = validateParameter(valid_580087, JInt, required = false, default = nil)
  if valid_580087 != nil:
    section.add "maxResults", valid_580087
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580088: Call_ContentProductsList_580075; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the products in your Merchant Center account.
  ## 
  let valid = call_580088.validator(path, query, header, formData, body)
  let scheme = call_580088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580088.url(scheme.get, call_580088.host, call_580088.base,
                         call_580088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580088, url, valid)

proc call*(call_580089: Call_ContentProductsList_580075; merchantId: string;
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
  var path_580090 = newJObject()
  var query_580091 = newJObject()
  add(query_580091, "key", newJString(key))
  add(query_580091, "prettyPrint", newJBool(prettyPrint))
  add(query_580091, "oauth_token", newJString(oauthToken))
  add(query_580091, "alt", newJString(alt))
  add(query_580091, "userIp", newJString(userIp))
  add(query_580091, "quotaUser", newJString(quotaUser))
  add(path_580090, "merchantId", newJString(merchantId))
  add(query_580091, "pageToken", newJString(pageToken))
  add(query_580091, "fields", newJString(fields))
  add(query_580091, "maxResults", newJInt(maxResults))
  result = call_580089.call(path_580090, query_580091, nil, nil, nil)

var contentProductsList* = Call_ContentProductsList_580075(
    name: "contentProductsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/products",
    validator: validate_ContentProductsList_580076, base: "/content/v2.1",
    url: url_ContentProductsList_580077, schemes: {Scheme.Https})
type
  Call_ContentProductsGet_580110 = ref object of OpenApiRestCall_578348
proc url_ContentProductsGet_580112(protocol: Scheme; host: string; base: string;
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

proc validate_ContentProductsGet_580111(path: JsonNode; query: JsonNode;
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
  var valid_580113 = path.getOrDefault("merchantId")
  valid_580113 = validateParameter(valid_580113, JString, required = true,
                                 default = nil)
  if valid_580113 != nil:
    section.add "merchantId", valid_580113
  var valid_580114 = path.getOrDefault("productId")
  valid_580114 = validateParameter(valid_580114, JString, required = true,
                                 default = nil)
  if valid_580114 != nil:
    section.add "productId", valid_580114
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580115 = query.getOrDefault("key")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "key", valid_580115
  var valid_580116 = query.getOrDefault("prettyPrint")
  valid_580116 = validateParameter(valid_580116, JBool, required = false,
                                 default = newJBool(true))
  if valid_580116 != nil:
    section.add "prettyPrint", valid_580116
  var valid_580117 = query.getOrDefault("oauth_token")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "oauth_token", valid_580117
  var valid_580118 = query.getOrDefault("alt")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = newJString("json"))
  if valid_580118 != nil:
    section.add "alt", valid_580118
  var valid_580119 = query.getOrDefault("userIp")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "userIp", valid_580119
  var valid_580120 = query.getOrDefault("quotaUser")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "quotaUser", valid_580120
  var valid_580121 = query.getOrDefault("fields")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "fields", valid_580121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580122: Call_ContentProductsGet_580110; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a product from your Merchant Center account.
  ## 
  let valid = call_580122.validator(path, query, header, formData, body)
  let scheme = call_580122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580122.url(scheme.get, call_580122.host, call_580122.base,
                         call_580122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580122, url, valid)

proc call*(call_580123: Call_ContentProductsGet_580110; merchantId: string;
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
  var path_580124 = newJObject()
  var query_580125 = newJObject()
  add(query_580125, "key", newJString(key))
  add(query_580125, "prettyPrint", newJBool(prettyPrint))
  add(query_580125, "oauth_token", newJString(oauthToken))
  add(query_580125, "alt", newJString(alt))
  add(query_580125, "userIp", newJString(userIp))
  add(query_580125, "quotaUser", newJString(quotaUser))
  add(path_580124, "merchantId", newJString(merchantId))
  add(query_580125, "fields", newJString(fields))
  add(path_580124, "productId", newJString(productId))
  result = call_580123.call(path_580124, query_580125, nil, nil, nil)

var contentProductsGet* = Call_ContentProductsGet_580110(
    name: "contentProductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/products/{productId}",
    validator: validate_ContentProductsGet_580111, base: "/content/v2.1",
    url: url_ContentProductsGet_580112, schemes: {Scheme.Https})
type
  Call_ContentProductsDelete_580126 = ref object of OpenApiRestCall_578348
proc url_ContentProductsDelete_580128(protocol: Scheme; host: string; base: string;
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

proc validate_ContentProductsDelete_580127(path: JsonNode; query: JsonNode;
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
  var valid_580129 = path.getOrDefault("merchantId")
  valid_580129 = validateParameter(valid_580129, JString, required = true,
                                 default = nil)
  if valid_580129 != nil:
    section.add "merchantId", valid_580129
  var valid_580130 = path.getOrDefault("productId")
  valid_580130 = validateParameter(valid_580130, JString, required = true,
                                 default = nil)
  if valid_580130 != nil:
    section.add "productId", valid_580130
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580137 = query.getOrDefault("feedId")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "feedId", valid_580137
  var valid_580138 = query.getOrDefault("fields")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "fields", valid_580138
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580139: Call_ContentProductsDelete_580126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a product from your Merchant Center account.
  ## 
  let valid = call_580139.validator(path, query, header, formData, body)
  let scheme = call_580139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580139.url(scheme.get, call_580139.host, call_580139.base,
                         call_580139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580139, url, valid)

proc call*(call_580140: Call_ContentProductsDelete_580126; merchantId: string;
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
  var path_580141 = newJObject()
  var query_580142 = newJObject()
  add(query_580142, "key", newJString(key))
  add(query_580142, "prettyPrint", newJBool(prettyPrint))
  add(query_580142, "oauth_token", newJString(oauthToken))
  add(query_580142, "alt", newJString(alt))
  add(query_580142, "userIp", newJString(userIp))
  add(query_580142, "quotaUser", newJString(quotaUser))
  add(path_580141, "merchantId", newJString(merchantId))
  add(query_580142, "feedId", newJString(feedId))
  add(query_580142, "fields", newJString(fields))
  add(path_580141, "productId", newJString(productId))
  result = call_580140.call(path_580141, query_580142, nil, nil, nil)

var contentProductsDelete* = Call_ContentProductsDelete_580126(
    name: "contentProductsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{merchantId}/products/{productId}",
    validator: validate_ContentProductsDelete_580127, base: "/content/v2.1",
    url: url_ContentProductsDelete_580128, schemes: {Scheme.Https})
type
  Call_ContentRegionalinventoryInsert_580143 = ref object of OpenApiRestCall_578348
proc url_ContentRegionalinventoryInsert_580145(protocol: Scheme; host: string;
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

proc validate_ContentRegionalinventoryInsert_580144(path: JsonNode;
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
  var valid_580146 = path.getOrDefault("merchantId")
  valid_580146 = validateParameter(valid_580146, JString, required = true,
                                 default = nil)
  if valid_580146 != nil:
    section.add "merchantId", valid_580146
  var valid_580147 = path.getOrDefault("productId")
  valid_580147 = validateParameter(valid_580147, JString, required = true,
                                 default = nil)
  if valid_580147 != nil:
    section.add "productId", valid_580147
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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

proc call*(call_580156: Call_ContentRegionalinventoryInsert_580143; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the regional inventory of a product in your Merchant Center account. If a regional inventory with the same region ID already exists, this method updates that entry.
  ## 
  let valid = call_580156.validator(path, query, header, formData, body)
  let scheme = call_580156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580156.url(scheme.get, call_580156.host, call_580156.base,
                         call_580156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580156, url, valid)

proc call*(call_580157: Call_ContentRegionalinventoryInsert_580143;
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
  add(path_580158, "productId", newJString(productId))
  result = call_580157.call(path_580158, query_580159, nil, nil, body_580160)

var contentRegionalinventoryInsert* = Call_ContentRegionalinventoryInsert_580143(
    name: "contentRegionalinventoryInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/products/{productId}/regionalinventory",
    validator: validate_ContentRegionalinventoryInsert_580144,
    base: "/content/v2.1", url: url_ContentRegionalinventoryInsert_580145,
    schemes: {Scheme.Https})
type
  Call_ContentProductstatusesList_580161 = ref object of OpenApiRestCall_578348
proc url_ContentProductstatusesList_580163(protocol: Scheme; host: string;
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

proc validate_ContentProductstatusesList_580162(path: JsonNode; query: JsonNode;
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
  var valid_580164 = path.getOrDefault("merchantId")
  valid_580164 = validateParameter(valid_580164, JString, required = true,
                                 default = nil)
  if valid_580164 != nil:
    section.add "merchantId", valid_580164
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580165 = query.getOrDefault("key")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "key", valid_580165
  var valid_580166 = query.getOrDefault("prettyPrint")
  valid_580166 = validateParameter(valid_580166, JBool, required = false,
                                 default = newJBool(true))
  if valid_580166 != nil:
    section.add "prettyPrint", valid_580166
  var valid_580167 = query.getOrDefault("oauth_token")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "oauth_token", valid_580167
  var valid_580168 = query.getOrDefault("alt")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = newJString("json"))
  if valid_580168 != nil:
    section.add "alt", valid_580168
  var valid_580169 = query.getOrDefault("userIp")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "userIp", valid_580169
  var valid_580170 = query.getOrDefault("quotaUser")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "quotaUser", valid_580170
  var valid_580171 = query.getOrDefault("pageToken")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "pageToken", valid_580171
  var valid_580172 = query.getOrDefault("destinations")
  valid_580172 = validateParameter(valid_580172, JArray, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "destinations", valid_580172
  var valid_580173 = query.getOrDefault("fields")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "fields", valid_580173
  var valid_580174 = query.getOrDefault("maxResults")
  valid_580174 = validateParameter(valid_580174, JInt, required = false, default = nil)
  if valid_580174 != nil:
    section.add "maxResults", valid_580174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580175: Call_ContentProductstatusesList_580161; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the statuses of the products in your Merchant Center account.
  ## 
  let valid = call_580175.validator(path, query, header, formData, body)
  let scheme = call_580175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580175.url(scheme.get, call_580175.host, call_580175.base,
                         call_580175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580175, url, valid)

proc call*(call_580176: Call_ContentProductstatusesList_580161; merchantId: string;
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
  var path_580177 = newJObject()
  var query_580178 = newJObject()
  add(query_580178, "key", newJString(key))
  add(query_580178, "prettyPrint", newJBool(prettyPrint))
  add(query_580178, "oauth_token", newJString(oauthToken))
  add(query_580178, "alt", newJString(alt))
  add(query_580178, "userIp", newJString(userIp))
  add(query_580178, "quotaUser", newJString(quotaUser))
  add(path_580177, "merchantId", newJString(merchantId))
  add(query_580178, "pageToken", newJString(pageToken))
  if destinations != nil:
    query_580178.add "destinations", destinations
  add(query_580178, "fields", newJString(fields))
  add(query_580178, "maxResults", newJInt(maxResults))
  result = call_580176.call(path_580177, query_580178, nil, nil, nil)

var contentProductstatusesList* = Call_ContentProductstatusesList_580161(
    name: "contentProductstatusesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/productstatuses",
    validator: validate_ContentProductstatusesList_580162, base: "/content/v2.1",
    url: url_ContentProductstatusesList_580163, schemes: {Scheme.Https})
type
  Call_ContentProductstatusesGet_580179 = ref object of OpenApiRestCall_578348
proc url_ContentProductstatusesGet_580181(protocol: Scheme; host: string;
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

proc validate_ContentProductstatusesGet_580180(path: JsonNode; query: JsonNode;
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
  var valid_580182 = path.getOrDefault("merchantId")
  valid_580182 = validateParameter(valid_580182, JString, required = true,
                                 default = nil)
  if valid_580182 != nil:
    section.add "merchantId", valid_580182
  var valid_580183 = path.getOrDefault("productId")
  valid_580183 = validateParameter(valid_580183, JString, required = true,
                                 default = nil)
  if valid_580183 != nil:
    section.add "productId", valid_580183
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580186 = query.getOrDefault("oauth_token")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "oauth_token", valid_580186
  var valid_580187 = query.getOrDefault("alt")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = newJString("json"))
  if valid_580187 != nil:
    section.add "alt", valid_580187
  var valid_580188 = query.getOrDefault("userIp")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "userIp", valid_580188
  var valid_580189 = query.getOrDefault("quotaUser")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "quotaUser", valid_580189
  var valid_580190 = query.getOrDefault("destinations")
  valid_580190 = validateParameter(valid_580190, JArray, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "destinations", valid_580190
  var valid_580191 = query.getOrDefault("fields")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "fields", valid_580191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580192: Call_ContentProductstatusesGet_580179; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the status of a product from your Merchant Center account.
  ## 
  let valid = call_580192.validator(path, query, header, formData, body)
  let scheme = call_580192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580192.url(scheme.get, call_580192.host, call_580192.base,
                         call_580192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580192, url, valid)

proc call*(call_580193: Call_ContentProductstatusesGet_580179; merchantId: string;
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
  var path_580194 = newJObject()
  var query_580195 = newJObject()
  add(query_580195, "key", newJString(key))
  add(query_580195, "prettyPrint", newJBool(prettyPrint))
  add(query_580195, "oauth_token", newJString(oauthToken))
  add(query_580195, "alt", newJString(alt))
  add(query_580195, "userIp", newJString(userIp))
  add(query_580195, "quotaUser", newJString(quotaUser))
  add(path_580194, "merchantId", newJString(merchantId))
  if destinations != nil:
    query_580195.add "destinations", destinations
  add(query_580195, "fields", newJString(fields))
  add(path_580194, "productId", newJString(productId))
  result = call_580193.call(path_580194, query_580195, nil, nil, nil)

var contentProductstatusesGet* = Call_ContentProductstatusesGet_580179(
    name: "contentProductstatusesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/productstatuses/{productId}",
    validator: validate_ContentProductstatusesGet_580180, base: "/content/v2.1",
    url: url_ContentProductstatusesGet_580181, schemes: {Scheme.Https})
type
  Call_ContentReturnaddressInsert_580214 = ref object of OpenApiRestCall_578348
proc url_ContentReturnaddressInsert_580216(protocol: Scheme; host: string;
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

proc validate_ContentReturnaddressInsert_580215(path: JsonNode; query: JsonNode;
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
  var valid_580217 = path.getOrDefault("merchantId")
  valid_580217 = validateParameter(valid_580217, JString, required = true,
                                 default = nil)
  if valid_580217 != nil:
    section.add "merchantId", valid_580217
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580220 = query.getOrDefault("oauth_token")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "oauth_token", valid_580220
  var valid_580221 = query.getOrDefault("alt")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = newJString("json"))
  if valid_580221 != nil:
    section.add "alt", valid_580221
  var valid_580222 = query.getOrDefault("userIp")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "userIp", valid_580222
  var valid_580223 = query.getOrDefault("quotaUser")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "quotaUser", valid_580223
  var valid_580224 = query.getOrDefault("fields")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "fields", valid_580224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580226: Call_ContentReturnaddressInsert_580214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a return address for the Merchant Center account.
  ## 
  let valid = call_580226.validator(path, query, header, formData, body)
  let scheme = call_580226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580226.url(scheme.get, call_580226.host, call_580226.base,
                         call_580226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580226, url, valid)

proc call*(call_580227: Call_ContentReturnaddressInsert_580214; merchantId: string;
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
  var path_580228 = newJObject()
  var query_580229 = newJObject()
  var body_580230 = newJObject()
  add(query_580229, "key", newJString(key))
  add(query_580229, "prettyPrint", newJBool(prettyPrint))
  add(query_580229, "oauth_token", newJString(oauthToken))
  add(query_580229, "alt", newJString(alt))
  add(query_580229, "userIp", newJString(userIp))
  add(query_580229, "quotaUser", newJString(quotaUser))
  add(path_580228, "merchantId", newJString(merchantId))
  if body != nil:
    body_580230 = body
  add(query_580229, "fields", newJString(fields))
  result = call_580227.call(path_580228, query_580229, nil, nil, body_580230)

var contentReturnaddressInsert* = Call_ContentReturnaddressInsert_580214(
    name: "contentReturnaddressInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/returnaddress",
    validator: validate_ContentReturnaddressInsert_580215, base: "/content/v2.1",
    url: url_ContentReturnaddressInsert_580216, schemes: {Scheme.Https})
type
  Call_ContentReturnaddressList_580196 = ref object of OpenApiRestCall_578348
proc url_ContentReturnaddressList_580198(protocol: Scheme; host: string;
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

proc validate_ContentReturnaddressList_580197(path: JsonNode; query: JsonNode;
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
  var valid_580199 = path.getOrDefault("merchantId")
  valid_580199 = validateParameter(valid_580199, JString, required = true,
                                 default = nil)
  if valid_580199 != nil:
    section.add "merchantId", valid_580199
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580202 = query.getOrDefault("oauth_token")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "oauth_token", valid_580202
  var valid_580203 = query.getOrDefault("alt")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = newJString("json"))
  if valid_580203 != nil:
    section.add "alt", valid_580203
  var valid_580204 = query.getOrDefault("userIp")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "userIp", valid_580204
  var valid_580205 = query.getOrDefault("quotaUser")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "quotaUser", valid_580205
  var valid_580206 = query.getOrDefault("pageToken")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "pageToken", valid_580206
  var valid_580207 = query.getOrDefault("country")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "country", valid_580207
  var valid_580208 = query.getOrDefault("fields")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "fields", valid_580208
  var valid_580209 = query.getOrDefault("maxResults")
  valid_580209 = validateParameter(valid_580209, JInt, required = false, default = nil)
  if valid_580209 != nil:
    section.add "maxResults", valid_580209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580210: Call_ContentReturnaddressList_580196; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the return addresses of the Merchant Center account.
  ## 
  let valid = call_580210.validator(path, query, header, formData, body)
  let scheme = call_580210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580210.url(scheme.get, call_580210.host, call_580210.base,
                         call_580210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580210, url, valid)

proc call*(call_580211: Call_ContentReturnaddressList_580196; merchantId: string;
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
  var path_580212 = newJObject()
  var query_580213 = newJObject()
  add(query_580213, "key", newJString(key))
  add(query_580213, "prettyPrint", newJBool(prettyPrint))
  add(query_580213, "oauth_token", newJString(oauthToken))
  add(query_580213, "alt", newJString(alt))
  add(query_580213, "userIp", newJString(userIp))
  add(query_580213, "quotaUser", newJString(quotaUser))
  add(path_580212, "merchantId", newJString(merchantId))
  add(query_580213, "pageToken", newJString(pageToken))
  add(query_580213, "country", newJString(country))
  add(query_580213, "fields", newJString(fields))
  add(query_580213, "maxResults", newJInt(maxResults))
  result = call_580211.call(path_580212, query_580213, nil, nil, nil)

var contentReturnaddressList* = Call_ContentReturnaddressList_580196(
    name: "contentReturnaddressList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/returnaddress",
    validator: validate_ContentReturnaddressList_580197, base: "/content/v2.1",
    url: url_ContentReturnaddressList_580198, schemes: {Scheme.Https})
type
  Call_ContentReturnaddressGet_580231 = ref object of OpenApiRestCall_578348
proc url_ContentReturnaddressGet_580233(protocol: Scheme; host: string; base: string;
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

proc validate_ContentReturnaddressGet_580232(path: JsonNode; query: JsonNode;
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
  var valid_580234 = path.getOrDefault("merchantId")
  valid_580234 = validateParameter(valid_580234, JString, required = true,
                                 default = nil)
  if valid_580234 != nil:
    section.add "merchantId", valid_580234
  var valid_580235 = path.getOrDefault("returnAddressId")
  valid_580235 = validateParameter(valid_580235, JString, required = true,
                                 default = nil)
  if valid_580235 != nil:
    section.add "returnAddressId", valid_580235
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580242 = query.getOrDefault("fields")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "fields", valid_580242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580243: Call_ContentReturnaddressGet_580231; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a return address of the Merchant Center account.
  ## 
  let valid = call_580243.validator(path, query, header, formData, body)
  let scheme = call_580243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580243.url(scheme.get, call_580243.host, call_580243.base,
                         call_580243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580243, url, valid)

proc call*(call_580244: Call_ContentReturnaddressGet_580231; merchantId: string;
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
  var path_580245 = newJObject()
  var query_580246 = newJObject()
  add(query_580246, "key", newJString(key))
  add(query_580246, "prettyPrint", newJBool(prettyPrint))
  add(query_580246, "oauth_token", newJString(oauthToken))
  add(query_580246, "alt", newJString(alt))
  add(query_580246, "userIp", newJString(userIp))
  add(query_580246, "quotaUser", newJString(quotaUser))
  add(path_580245, "merchantId", newJString(merchantId))
  add(path_580245, "returnAddressId", newJString(returnAddressId))
  add(query_580246, "fields", newJString(fields))
  result = call_580244.call(path_580245, query_580246, nil, nil, nil)

var contentReturnaddressGet* = Call_ContentReturnaddressGet_580231(
    name: "contentReturnaddressGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/returnaddress/{returnAddressId}",
    validator: validate_ContentReturnaddressGet_580232, base: "/content/v2.1",
    url: url_ContentReturnaddressGet_580233, schemes: {Scheme.Https})
type
  Call_ContentReturnaddressDelete_580247 = ref object of OpenApiRestCall_578348
proc url_ContentReturnaddressDelete_580249(protocol: Scheme; host: string;
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

proc validate_ContentReturnaddressDelete_580248(path: JsonNode; query: JsonNode;
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
  var valid_580250 = path.getOrDefault("merchantId")
  valid_580250 = validateParameter(valid_580250, JString, required = true,
                                 default = nil)
  if valid_580250 != nil:
    section.add "merchantId", valid_580250
  var valid_580251 = path.getOrDefault("returnAddressId")
  valid_580251 = validateParameter(valid_580251, JString, required = true,
                                 default = nil)
  if valid_580251 != nil:
    section.add "returnAddressId", valid_580251
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580252 = query.getOrDefault("key")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "key", valid_580252
  var valid_580253 = query.getOrDefault("prettyPrint")
  valid_580253 = validateParameter(valid_580253, JBool, required = false,
                                 default = newJBool(true))
  if valid_580253 != nil:
    section.add "prettyPrint", valid_580253
  var valid_580254 = query.getOrDefault("oauth_token")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "oauth_token", valid_580254
  var valid_580255 = query.getOrDefault("alt")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = newJString("json"))
  if valid_580255 != nil:
    section.add "alt", valid_580255
  var valid_580256 = query.getOrDefault("userIp")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "userIp", valid_580256
  var valid_580257 = query.getOrDefault("quotaUser")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "quotaUser", valid_580257
  var valid_580258 = query.getOrDefault("fields")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "fields", valid_580258
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580259: Call_ContentReturnaddressDelete_580247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a return address for the given Merchant Center account.
  ## 
  let valid = call_580259.validator(path, query, header, formData, body)
  let scheme = call_580259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580259.url(scheme.get, call_580259.host, call_580259.base,
                         call_580259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580259, url, valid)

proc call*(call_580260: Call_ContentReturnaddressDelete_580247; merchantId: string;
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
  var path_580261 = newJObject()
  var query_580262 = newJObject()
  add(query_580262, "key", newJString(key))
  add(query_580262, "prettyPrint", newJBool(prettyPrint))
  add(query_580262, "oauth_token", newJString(oauthToken))
  add(query_580262, "alt", newJString(alt))
  add(query_580262, "userIp", newJString(userIp))
  add(query_580262, "quotaUser", newJString(quotaUser))
  add(path_580261, "merchantId", newJString(merchantId))
  add(path_580261, "returnAddressId", newJString(returnAddressId))
  add(query_580262, "fields", newJString(fields))
  result = call_580260.call(path_580261, query_580262, nil, nil, nil)

var contentReturnaddressDelete* = Call_ContentReturnaddressDelete_580247(
    name: "contentReturnaddressDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{merchantId}/returnaddress/{returnAddressId}",
    validator: validate_ContentReturnaddressDelete_580248, base: "/content/v2.1",
    url: url_ContentReturnaddressDelete_580249, schemes: {Scheme.Https})
type
  Call_ContentReturnpolicyInsert_580278 = ref object of OpenApiRestCall_578348
proc url_ContentReturnpolicyInsert_580280(protocol: Scheme; host: string;
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

proc validate_ContentReturnpolicyInsert_580279(path: JsonNode; query: JsonNode;
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
  var valid_580281 = path.getOrDefault("merchantId")
  valid_580281 = validateParameter(valid_580281, JString, required = true,
                                 default = nil)
  if valid_580281 != nil:
    section.add "merchantId", valid_580281
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580282 = query.getOrDefault("key")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "key", valid_580282
  var valid_580283 = query.getOrDefault("prettyPrint")
  valid_580283 = validateParameter(valid_580283, JBool, required = false,
                                 default = newJBool(true))
  if valid_580283 != nil:
    section.add "prettyPrint", valid_580283
  var valid_580284 = query.getOrDefault("oauth_token")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "oauth_token", valid_580284
  var valid_580285 = query.getOrDefault("alt")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = newJString("json"))
  if valid_580285 != nil:
    section.add "alt", valid_580285
  var valid_580286 = query.getOrDefault("userIp")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "userIp", valid_580286
  var valid_580287 = query.getOrDefault("quotaUser")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "quotaUser", valid_580287
  var valid_580288 = query.getOrDefault("fields")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "fields", valid_580288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580290: Call_ContentReturnpolicyInsert_580278; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a return policy for the Merchant Center account.
  ## 
  let valid = call_580290.validator(path, query, header, formData, body)
  let scheme = call_580290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580290.url(scheme.get, call_580290.host, call_580290.base,
                         call_580290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580290, url, valid)

proc call*(call_580291: Call_ContentReturnpolicyInsert_580278; merchantId: string;
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
  var path_580292 = newJObject()
  var query_580293 = newJObject()
  var body_580294 = newJObject()
  add(query_580293, "key", newJString(key))
  add(query_580293, "prettyPrint", newJBool(prettyPrint))
  add(query_580293, "oauth_token", newJString(oauthToken))
  add(query_580293, "alt", newJString(alt))
  add(query_580293, "userIp", newJString(userIp))
  add(query_580293, "quotaUser", newJString(quotaUser))
  add(path_580292, "merchantId", newJString(merchantId))
  if body != nil:
    body_580294 = body
  add(query_580293, "fields", newJString(fields))
  result = call_580291.call(path_580292, query_580293, nil, nil, body_580294)

var contentReturnpolicyInsert* = Call_ContentReturnpolicyInsert_580278(
    name: "contentReturnpolicyInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/returnpolicy",
    validator: validate_ContentReturnpolicyInsert_580279, base: "/content/v2.1",
    url: url_ContentReturnpolicyInsert_580280, schemes: {Scheme.Https})
type
  Call_ContentReturnpolicyList_580263 = ref object of OpenApiRestCall_578348
proc url_ContentReturnpolicyList_580265(protocol: Scheme; host: string; base: string;
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

proc validate_ContentReturnpolicyList_580264(path: JsonNode; query: JsonNode;
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
  var valid_580266 = path.getOrDefault("merchantId")
  valid_580266 = validateParameter(valid_580266, JString, required = true,
                                 default = nil)
  if valid_580266 != nil:
    section.add "merchantId", valid_580266
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580267 = query.getOrDefault("key")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "key", valid_580267
  var valid_580268 = query.getOrDefault("prettyPrint")
  valid_580268 = validateParameter(valid_580268, JBool, required = false,
                                 default = newJBool(true))
  if valid_580268 != nil:
    section.add "prettyPrint", valid_580268
  var valid_580269 = query.getOrDefault("oauth_token")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "oauth_token", valid_580269
  var valid_580270 = query.getOrDefault("alt")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = newJString("json"))
  if valid_580270 != nil:
    section.add "alt", valid_580270
  var valid_580271 = query.getOrDefault("userIp")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "userIp", valid_580271
  var valid_580272 = query.getOrDefault("quotaUser")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "quotaUser", valid_580272
  var valid_580273 = query.getOrDefault("fields")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "fields", valid_580273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580274: Call_ContentReturnpolicyList_580263; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the return policies of the Merchant Center account.
  ## 
  let valid = call_580274.validator(path, query, header, formData, body)
  let scheme = call_580274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580274.url(scheme.get, call_580274.host, call_580274.base,
                         call_580274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580274, url, valid)

proc call*(call_580275: Call_ContentReturnpolicyList_580263; merchantId: string;
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
  var path_580276 = newJObject()
  var query_580277 = newJObject()
  add(query_580277, "key", newJString(key))
  add(query_580277, "prettyPrint", newJBool(prettyPrint))
  add(query_580277, "oauth_token", newJString(oauthToken))
  add(query_580277, "alt", newJString(alt))
  add(query_580277, "userIp", newJString(userIp))
  add(query_580277, "quotaUser", newJString(quotaUser))
  add(path_580276, "merchantId", newJString(merchantId))
  add(query_580277, "fields", newJString(fields))
  result = call_580275.call(path_580276, query_580277, nil, nil, nil)

var contentReturnpolicyList* = Call_ContentReturnpolicyList_580263(
    name: "contentReturnpolicyList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/returnpolicy",
    validator: validate_ContentReturnpolicyList_580264, base: "/content/v2.1",
    url: url_ContentReturnpolicyList_580265, schemes: {Scheme.Https})
type
  Call_ContentReturnpolicyGet_580295 = ref object of OpenApiRestCall_578348
proc url_ContentReturnpolicyGet_580297(protocol: Scheme; host: string; base: string;
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

proc validate_ContentReturnpolicyGet_580296(path: JsonNode; query: JsonNode;
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
  var valid_580298 = path.getOrDefault("merchantId")
  valid_580298 = validateParameter(valid_580298, JString, required = true,
                                 default = nil)
  if valid_580298 != nil:
    section.add "merchantId", valid_580298
  var valid_580299 = path.getOrDefault("returnPolicyId")
  valid_580299 = validateParameter(valid_580299, JString, required = true,
                                 default = nil)
  if valid_580299 != nil:
    section.add "returnPolicyId", valid_580299
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580300 = query.getOrDefault("key")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "key", valid_580300
  var valid_580301 = query.getOrDefault("prettyPrint")
  valid_580301 = validateParameter(valid_580301, JBool, required = false,
                                 default = newJBool(true))
  if valid_580301 != nil:
    section.add "prettyPrint", valid_580301
  var valid_580302 = query.getOrDefault("oauth_token")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "oauth_token", valid_580302
  var valid_580303 = query.getOrDefault("alt")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = newJString("json"))
  if valid_580303 != nil:
    section.add "alt", valid_580303
  var valid_580304 = query.getOrDefault("userIp")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "userIp", valid_580304
  var valid_580305 = query.getOrDefault("quotaUser")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "quotaUser", valid_580305
  var valid_580306 = query.getOrDefault("fields")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "fields", valid_580306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580307: Call_ContentReturnpolicyGet_580295; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a return policy of the Merchant Center account.
  ## 
  let valid = call_580307.validator(path, query, header, formData, body)
  let scheme = call_580307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580307.url(scheme.get, call_580307.host, call_580307.base,
                         call_580307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580307, url, valid)

proc call*(call_580308: Call_ContentReturnpolicyGet_580295; merchantId: string;
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
  var path_580309 = newJObject()
  var query_580310 = newJObject()
  add(query_580310, "key", newJString(key))
  add(query_580310, "prettyPrint", newJBool(prettyPrint))
  add(query_580310, "oauth_token", newJString(oauthToken))
  add(query_580310, "alt", newJString(alt))
  add(query_580310, "userIp", newJString(userIp))
  add(query_580310, "quotaUser", newJString(quotaUser))
  add(path_580309, "merchantId", newJString(merchantId))
  add(path_580309, "returnPolicyId", newJString(returnPolicyId))
  add(query_580310, "fields", newJString(fields))
  result = call_580308.call(path_580309, query_580310, nil, nil, nil)

var contentReturnpolicyGet* = Call_ContentReturnpolicyGet_580295(
    name: "contentReturnpolicyGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/returnpolicy/{returnPolicyId}",
    validator: validate_ContentReturnpolicyGet_580296, base: "/content/v2.1",
    url: url_ContentReturnpolicyGet_580297, schemes: {Scheme.Https})
type
  Call_ContentReturnpolicyDelete_580311 = ref object of OpenApiRestCall_578348
proc url_ContentReturnpolicyDelete_580313(protocol: Scheme; host: string;
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

proc validate_ContentReturnpolicyDelete_580312(path: JsonNode; query: JsonNode;
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
  var valid_580314 = path.getOrDefault("merchantId")
  valid_580314 = validateParameter(valid_580314, JString, required = true,
                                 default = nil)
  if valid_580314 != nil:
    section.add "merchantId", valid_580314
  var valid_580315 = path.getOrDefault("returnPolicyId")
  valid_580315 = validateParameter(valid_580315, JString, required = true,
                                 default = nil)
  if valid_580315 != nil:
    section.add "returnPolicyId", valid_580315
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580316 = query.getOrDefault("key")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "key", valid_580316
  var valid_580317 = query.getOrDefault("prettyPrint")
  valid_580317 = validateParameter(valid_580317, JBool, required = false,
                                 default = newJBool(true))
  if valid_580317 != nil:
    section.add "prettyPrint", valid_580317
  var valid_580318 = query.getOrDefault("oauth_token")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "oauth_token", valid_580318
  var valid_580319 = query.getOrDefault("alt")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = newJString("json"))
  if valid_580319 != nil:
    section.add "alt", valid_580319
  var valid_580320 = query.getOrDefault("userIp")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "userIp", valid_580320
  var valid_580321 = query.getOrDefault("quotaUser")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "quotaUser", valid_580321
  var valid_580322 = query.getOrDefault("fields")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = nil)
  if valid_580322 != nil:
    section.add "fields", valid_580322
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580323: Call_ContentReturnpolicyDelete_580311; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a return policy for the given Merchant Center account.
  ## 
  let valid = call_580323.validator(path, query, header, formData, body)
  let scheme = call_580323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580323.url(scheme.get, call_580323.host, call_580323.base,
                         call_580323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580323, url, valid)

proc call*(call_580324: Call_ContentReturnpolicyDelete_580311; merchantId: string;
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
  var path_580325 = newJObject()
  var query_580326 = newJObject()
  add(query_580326, "key", newJString(key))
  add(query_580326, "prettyPrint", newJBool(prettyPrint))
  add(query_580326, "oauth_token", newJString(oauthToken))
  add(query_580326, "alt", newJString(alt))
  add(query_580326, "userIp", newJString(userIp))
  add(query_580326, "quotaUser", newJString(quotaUser))
  add(path_580325, "merchantId", newJString(merchantId))
  add(path_580325, "returnPolicyId", newJString(returnPolicyId))
  add(query_580326, "fields", newJString(fields))
  result = call_580324.call(path_580325, query_580326, nil, nil, nil)

var contentReturnpolicyDelete* = Call_ContentReturnpolicyDelete_580311(
    name: "contentReturnpolicyDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{merchantId}/returnpolicy/{returnPolicyId}",
    validator: validate_ContentReturnpolicyDelete_580312, base: "/content/v2.1",
    url: url_ContentReturnpolicyDelete_580313, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsList_580327 = ref object of OpenApiRestCall_578348
proc url_ContentShippingsettingsList_580329(protocol: Scheme; host: string;
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

proc validate_ContentShippingsettingsList_580328(path: JsonNode; query: JsonNode;
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
  var valid_580330 = path.getOrDefault("merchantId")
  valid_580330 = validateParameter(valid_580330, JString, required = true,
                                 default = nil)
  if valid_580330 != nil:
    section.add "merchantId", valid_580330
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580331 = query.getOrDefault("key")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "key", valid_580331
  var valid_580332 = query.getOrDefault("prettyPrint")
  valid_580332 = validateParameter(valid_580332, JBool, required = false,
                                 default = newJBool(true))
  if valid_580332 != nil:
    section.add "prettyPrint", valid_580332
  var valid_580333 = query.getOrDefault("oauth_token")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "oauth_token", valid_580333
  var valid_580334 = query.getOrDefault("alt")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = newJString("json"))
  if valid_580334 != nil:
    section.add "alt", valid_580334
  var valid_580335 = query.getOrDefault("userIp")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = nil)
  if valid_580335 != nil:
    section.add "userIp", valid_580335
  var valid_580336 = query.getOrDefault("quotaUser")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "quotaUser", valid_580336
  var valid_580337 = query.getOrDefault("pageToken")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "pageToken", valid_580337
  var valid_580338 = query.getOrDefault("fields")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "fields", valid_580338
  var valid_580339 = query.getOrDefault("maxResults")
  valid_580339 = validateParameter(valid_580339, JInt, required = false, default = nil)
  if valid_580339 != nil:
    section.add "maxResults", valid_580339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580340: Call_ContentShippingsettingsList_580327; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the shipping settings of the sub-accounts in your Merchant Center account.
  ## 
  let valid = call_580340.validator(path, query, header, formData, body)
  let scheme = call_580340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580340.url(scheme.get, call_580340.host, call_580340.base,
                         call_580340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580340, url, valid)

proc call*(call_580341: Call_ContentShippingsettingsList_580327;
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
  var path_580342 = newJObject()
  var query_580343 = newJObject()
  add(query_580343, "key", newJString(key))
  add(query_580343, "prettyPrint", newJBool(prettyPrint))
  add(query_580343, "oauth_token", newJString(oauthToken))
  add(query_580343, "alt", newJString(alt))
  add(query_580343, "userIp", newJString(userIp))
  add(query_580343, "quotaUser", newJString(quotaUser))
  add(path_580342, "merchantId", newJString(merchantId))
  add(query_580343, "pageToken", newJString(pageToken))
  add(query_580343, "fields", newJString(fields))
  add(query_580343, "maxResults", newJInt(maxResults))
  result = call_580341.call(path_580342, query_580343, nil, nil, nil)

var contentShippingsettingsList* = Call_ContentShippingsettingsList_580327(
    name: "contentShippingsettingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/shippingsettings",
    validator: validate_ContentShippingsettingsList_580328, base: "/content/v2.1",
    url: url_ContentShippingsettingsList_580329, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsUpdate_580360 = ref object of OpenApiRestCall_578348
proc url_ContentShippingsettingsUpdate_580362(protocol: Scheme; host: string;
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

proc validate_ContentShippingsettingsUpdate_580361(path: JsonNode; query: JsonNode;
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
  var valid_580363 = path.getOrDefault("merchantId")
  valid_580363 = validateParameter(valid_580363, JString, required = true,
                                 default = nil)
  if valid_580363 != nil:
    section.add "merchantId", valid_580363
  var valid_580364 = path.getOrDefault("accountId")
  valid_580364 = validateParameter(valid_580364, JString, required = true,
                                 default = nil)
  if valid_580364 != nil:
    section.add "accountId", valid_580364
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580365 = query.getOrDefault("key")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "key", valid_580365
  var valid_580366 = query.getOrDefault("prettyPrint")
  valid_580366 = validateParameter(valid_580366, JBool, required = false,
                                 default = newJBool(true))
  if valid_580366 != nil:
    section.add "prettyPrint", valid_580366
  var valid_580367 = query.getOrDefault("oauth_token")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "oauth_token", valid_580367
  var valid_580368 = query.getOrDefault("alt")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = newJString("json"))
  if valid_580368 != nil:
    section.add "alt", valid_580368
  var valid_580369 = query.getOrDefault("userIp")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = nil)
  if valid_580369 != nil:
    section.add "userIp", valid_580369
  var valid_580370 = query.getOrDefault("quotaUser")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "quotaUser", valid_580370
  var valid_580371 = query.getOrDefault("fields")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "fields", valid_580371
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580373: Call_ContentShippingsettingsUpdate_580360; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the shipping settings of the account.
  ## 
  let valid = call_580373.validator(path, query, header, formData, body)
  let scheme = call_580373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580373.url(scheme.get, call_580373.host, call_580373.base,
                         call_580373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580373, url, valid)

proc call*(call_580374: Call_ContentShippingsettingsUpdate_580360;
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
  var path_580375 = newJObject()
  var query_580376 = newJObject()
  var body_580377 = newJObject()
  add(query_580376, "key", newJString(key))
  add(query_580376, "prettyPrint", newJBool(prettyPrint))
  add(query_580376, "oauth_token", newJString(oauthToken))
  add(query_580376, "alt", newJString(alt))
  add(query_580376, "userIp", newJString(userIp))
  add(query_580376, "quotaUser", newJString(quotaUser))
  add(path_580375, "merchantId", newJString(merchantId))
  if body != nil:
    body_580377 = body
  add(path_580375, "accountId", newJString(accountId))
  add(query_580376, "fields", newJString(fields))
  result = call_580374.call(path_580375, query_580376, nil, nil, body_580377)

var contentShippingsettingsUpdate* = Call_ContentShippingsettingsUpdate_580360(
    name: "contentShippingsettingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{merchantId}/shippingsettings/{accountId}",
    validator: validate_ContentShippingsettingsUpdate_580361,
    base: "/content/v2.1", url: url_ContentShippingsettingsUpdate_580362,
    schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGet_580344 = ref object of OpenApiRestCall_578348
proc url_ContentShippingsettingsGet_580346(protocol: Scheme; host: string;
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

proc validate_ContentShippingsettingsGet_580345(path: JsonNode; query: JsonNode;
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
  var valid_580347 = path.getOrDefault("merchantId")
  valid_580347 = validateParameter(valid_580347, JString, required = true,
                                 default = nil)
  if valid_580347 != nil:
    section.add "merchantId", valid_580347
  var valid_580348 = path.getOrDefault("accountId")
  valid_580348 = validateParameter(valid_580348, JString, required = true,
                                 default = nil)
  if valid_580348 != nil:
    section.add "accountId", valid_580348
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580349 = query.getOrDefault("key")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "key", valid_580349
  var valid_580350 = query.getOrDefault("prettyPrint")
  valid_580350 = validateParameter(valid_580350, JBool, required = false,
                                 default = newJBool(true))
  if valid_580350 != nil:
    section.add "prettyPrint", valid_580350
  var valid_580351 = query.getOrDefault("oauth_token")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "oauth_token", valid_580351
  var valid_580352 = query.getOrDefault("alt")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = newJString("json"))
  if valid_580352 != nil:
    section.add "alt", valid_580352
  var valid_580353 = query.getOrDefault("userIp")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = nil)
  if valid_580353 != nil:
    section.add "userIp", valid_580353
  var valid_580354 = query.getOrDefault("quotaUser")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = nil)
  if valid_580354 != nil:
    section.add "quotaUser", valid_580354
  var valid_580355 = query.getOrDefault("fields")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "fields", valid_580355
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580356: Call_ContentShippingsettingsGet_580344; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the shipping settings of the account.
  ## 
  let valid = call_580356.validator(path, query, header, formData, body)
  let scheme = call_580356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580356.url(scheme.get, call_580356.host, call_580356.base,
                         call_580356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580356, url, valid)

proc call*(call_580357: Call_ContentShippingsettingsGet_580344; merchantId: string;
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
  var path_580358 = newJObject()
  var query_580359 = newJObject()
  add(query_580359, "key", newJString(key))
  add(query_580359, "prettyPrint", newJBool(prettyPrint))
  add(query_580359, "oauth_token", newJString(oauthToken))
  add(query_580359, "alt", newJString(alt))
  add(query_580359, "userIp", newJString(userIp))
  add(query_580359, "quotaUser", newJString(quotaUser))
  add(path_580358, "merchantId", newJString(merchantId))
  add(path_580358, "accountId", newJString(accountId))
  add(query_580359, "fields", newJString(fields))
  result = call_580357.call(path_580358, query_580359, nil, nil, nil)

var contentShippingsettingsGet* = Call_ContentShippingsettingsGet_580344(
    name: "contentShippingsettingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/shippingsettings/{accountId}",
    validator: validate_ContentShippingsettingsGet_580345, base: "/content/v2.1",
    url: url_ContentShippingsettingsGet_580346, schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGetsupportedcarriers_580378 = ref object of OpenApiRestCall_578348
proc url_ContentShippingsettingsGetsupportedcarriers_580380(protocol: Scheme;
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

proc validate_ContentShippingsettingsGetsupportedcarriers_580379(path: JsonNode;
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
  var valid_580381 = path.getOrDefault("merchantId")
  valid_580381 = validateParameter(valid_580381, JString, required = true,
                                 default = nil)
  if valid_580381 != nil:
    section.add "merchantId", valid_580381
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580382 = query.getOrDefault("key")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = nil)
  if valid_580382 != nil:
    section.add "key", valid_580382
  var valid_580383 = query.getOrDefault("prettyPrint")
  valid_580383 = validateParameter(valid_580383, JBool, required = false,
                                 default = newJBool(true))
  if valid_580383 != nil:
    section.add "prettyPrint", valid_580383
  var valid_580384 = query.getOrDefault("oauth_token")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "oauth_token", valid_580384
  var valid_580385 = query.getOrDefault("alt")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = newJString("json"))
  if valid_580385 != nil:
    section.add "alt", valid_580385
  var valid_580386 = query.getOrDefault("userIp")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = nil)
  if valid_580386 != nil:
    section.add "userIp", valid_580386
  var valid_580387 = query.getOrDefault("quotaUser")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "quotaUser", valid_580387
  var valid_580388 = query.getOrDefault("fields")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "fields", valid_580388
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580389: Call_ContentShippingsettingsGetsupportedcarriers_580378;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves supported carriers and carrier services for an account.
  ## 
  let valid = call_580389.validator(path, query, header, formData, body)
  let scheme = call_580389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580389.url(scheme.get, call_580389.host, call_580389.base,
                         call_580389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580389, url, valid)

proc call*(call_580390: Call_ContentShippingsettingsGetsupportedcarriers_580378;
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
  var path_580391 = newJObject()
  var query_580392 = newJObject()
  add(query_580392, "key", newJString(key))
  add(query_580392, "prettyPrint", newJBool(prettyPrint))
  add(query_580392, "oauth_token", newJString(oauthToken))
  add(query_580392, "alt", newJString(alt))
  add(query_580392, "userIp", newJString(userIp))
  add(query_580392, "quotaUser", newJString(quotaUser))
  add(path_580391, "merchantId", newJString(merchantId))
  add(query_580392, "fields", newJString(fields))
  result = call_580390.call(path_580391, query_580392, nil, nil, nil)

var contentShippingsettingsGetsupportedcarriers* = Call_ContentShippingsettingsGetsupportedcarriers_580378(
    name: "contentShippingsettingsGetsupportedcarriers", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/supportedCarriers",
    validator: validate_ContentShippingsettingsGetsupportedcarriers_580379,
    base: "/content/v2.1", url: url_ContentShippingsettingsGetsupportedcarriers_580380,
    schemes: {Scheme.Https})
type
  Call_ContentShippingsettingsGetsupportedholidays_580393 = ref object of OpenApiRestCall_578348
proc url_ContentShippingsettingsGetsupportedholidays_580395(protocol: Scheme;
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

proc validate_ContentShippingsettingsGetsupportedholidays_580394(path: JsonNode;
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
  var valid_580396 = path.getOrDefault("merchantId")
  valid_580396 = validateParameter(valid_580396, JString, required = true,
                                 default = nil)
  if valid_580396 != nil:
    section.add "merchantId", valid_580396
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580399 = query.getOrDefault("oauth_token")
  valid_580399 = validateParameter(valid_580399, JString, required = false,
                                 default = nil)
  if valid_580399 != nil:
    section.add "oauth_token", valid_580399
  var valid_580400 = query.getOrDefault("alt")
  valid_580400 = validateParameter(valid_580400, JString, required = false,
                                 default = newJString("json"))
  if valid_580400 != nil:
    section.add "alt", valid_580400
  var valid_580401 = query.getOrDefault("userIp")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "userIp", valid_580401
  var valid_580402 = query.getOrDefault("quotaUser")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "quotaUser", valid_580402
  var valid_580403 = query.getOrDefault("fields")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "fields", valid_580403
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580404: Call_ContentShippingsettingsGetsupportedholidays_580393;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves supported holidays for an account.
  ## 
  let valid = call_580404.validator(path, query, header, formData, body)
  let scheme = call_580404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580404.url(scheme.get, call_580404.host, call_580404.base,
                         call_580404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580404, url, valid)

proc call*(call_580405: Call_ContentShippingsettingsGetsupportedholidays_580393;
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
  var path_580406 = newJObject()
  var query_580407 = newJObject()
  add(query_580407, "key", newJString(key))
  add(query_580407, "prettyPrint", newJBool(prettyPrint))
  add(query_580407, "oauth_token", newJString(oauthToken))
  add(query_580407, "alt", newJString(alt))
  add(query_580407, "userIp", newJString(userIp))
  add(query_580407, "quotaUser", newJString(quotaUser))
  add(path_580406, "merchantId", newJString(merchantId))
  add(query_580407, "fields", newJString(fields))
  result = call_580405.call(path_580406, query_580407, nil, nil, nil)

var contentShippingsettingsGetsupportedholidays* = Call_ContentShippingsettingsGetsupportedholidays_580393(
    name: "contentShippingsettingsGetsupportedholidays", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{merchantId}/supportedHolidays",
    validator: validate_ContentShippingsettingsGetsupportedholidays_580394,
    base: "/content/v2.1", url: url_ContentShippingsettingsGetsupportedholidays_580395,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersCreatetestorder_580408 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersCreatetestorder_580410(protocol: Scheme; host: string;
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

proc validate_ContentOrdersCreatetestorder_580409(path: JsonNode; query: JsonNode;
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
  var valid_580411 = path.getOrDefault("merchantId")
  valid_580411 = validateParameter(valid_580411, JString, required = true,
                                 default = nil)
  if valid_580411 != nil:
    section.add "merchantId", valid_580411
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580418 = query.getOrDefault("fields")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = nil)
  if valid_580418 != nil:
    section.add "fields", valid_580418
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580420: Call_ContentOrdersCreatetestorder_580408; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Creates a test order.
  ## 
  let valid = call_580420.validator(path, query, header, formData, body)
  let scheme = call_580420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580420.url(scheme.get, call_580420.host, call_580420.base,
                         call_580420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580420, url, valid)

proc call*(call_580421: Call_ContentOrdersCreatetestorder_580408;
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
  var path_580422 = newJObject()
  var query_580423 = newJObject()
  var body_580424 = newJObject()
  add(query_580423, "key", newJString(key))
  add(query_580423, "prettyPrint", newJBool(prettyPrint))
  add(query_580423, "oauth_token", newJString(oauthToken))
  add(query_580423, "alt", newJString(alt))
  add(query_580423, "userIp", newJString(userIp))
  add(query_580423, "quotaUser", newJString(quotaUser))
  add(path_580422, "merchantId", newJString(merchantId))
  if body != nil:
    body_580424 = body
  add(query_580423, "fields", newJString(fields))
  result = call_580421.call(path_580422, query_580423, nil, nil, body_580424)

var contentOrdersCreatetestorder* = Call_ContentOrdersCreatetestorder_580408(
    name: "contentOrdersCreatetestorder", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{merchantId}/testorders",
    validator: validate_ContentOrdersCreatetestorder_580409,
    base: "/content/v2.1", url: url_ContentOrdersCreatetestorder_580410,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersAdvancetestorder_580425 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersAdvancetestorder_580427(protocol: Scheme; host: string;
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

proc validate_ContentOrdersAdvancetestorder_580426(path: JsonNode; query: JsonNode;
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
  var valid_580428 = path.getOrDefault("merchantId")
  valid_580428 = validateParameter(valid_580428, JString, required = true,
                                 default = nil)
  if valid_580428 != nil:
    section.add "merchantId", valid_580428
  var valid_580429 = path.getOrDefault("orderId")
  valid_580429 = validateParameter(valid_580429, JString, required = true,
                                 default = nil)
  if valid_580429 != nil:
    section.add "orderId", valid_580429
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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

proc call*(call_580437: Call_ContentOrdersAdvancetestorder_580425; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sandbox only. Moves a test order from state "inProgress" to state "pendingShipment".
  ## 
  let valid = call_580437.validator(path, query, header, formData, body)
  let scheme = call_580437.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580437.url(scheme.get, call_580437.host, call_580437.base,
                         call_580437.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580437, url, valid)

proc call*(call_580438: Call_ContentOrdersAdvancetestorder_580425;
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
  var path_580439 = newJObject()
  var query_580440 = newJObject()
  add(query_580440, "key", newJString(key))
  add(query_580440, "prettyPrint", newJBool(prettyPrint))
  add(query_580440, "oauth_token", newJString(oauthToken))
  add(query_580440, "alt", newJString(alt))
  add(query_580440, "userIp", newJString(userIp))
  add(query_580440, "quotaUser", newJString(quotaUser))
  add(path_580439, "merchantId", newJString(merchantId))
  add(query_580440, "fields", newJString(fields))
  add(path_580439, "orderId", newJString(orderId))
  result = call_580438.call(path_580439, query_580440, nil, nil, nil)

var contentOrdersAdvancetestorder* = Call_ContentOrdersAdvancetestorder_580425(
    name: "contentOrdersAdvancetestorder", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/testorders/{orderId}/advance",
    validator: validate_ContentOrdersAdvancetestorder_580426,
    base: "/content/v2.1", url: url_ContentOrdersAdvancetestorder_580427,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersCanceltestorderbycustomer_580441 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersCanceltestorderbycustomer_580443(protocol: Scheme;
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

proc validate_ContentOrdersCanceltestorderbycustomer_580442(path: JsonNode;
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
  var valid_580444 = path.getOrDefault("merchantId")
  valid_580444 = validateParameter(valid_580444, JString, required = true,
                                 default = nil)
  if valid_580444 != nil:
    section.add "merchantId", valid_580444
  var valid_580445 = path.getOrDefault("orderId")
  valid_580445 = validateParameter(valid_580445, JString, required = true,
                                 default = nil)
  if valid_580445 != nil:
    section.add "orderId", valid_580445
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580448 = query.getOrDefault("oauth_token")
  valid_580448 = validateParameter(valid_580448, JString, required = false,
                                 default = nil)
  if valid_580448 != nil:
    section.add "oauth_token", valid_580448
  var valid_580449 = query.getOrDefault("alt")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = newJString("json"))
  if valid_580449 != nil:
    section.add "alt", valid_580449
  var valid_580450 = query.getOrDefault("userIp")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = nil)
  if valid_580450 != nil:
    section.add "userIp", valid_580450
  var valid_580451 = query.getOrDefault("quotaUser")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = nil)
  if valid_580451 != nil:
    section.add "quotaUser", valid_580451
  var valid_580452 = query.getOrDefault("fields")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "fields", valid_580452
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580454: Call_ContentOrdersCanceltestorderbycustomer_580441;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sandbox only. Cancels a test order for customer-initiated cancellation.
  ## 
  let valid = call_580454.validator(path, query, header, formData, body)
  let scheme = call_580454.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580454.url(scheme.get, call_580454.host, call_580454.base,
                         call_580454.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580454, url, valid)

proc call*(call_580455: Call_ContentOrdersCanceltestorderbycustomer_580441;
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
  var path_580456 = newJObject()
  var query_580457 = newJObject()
  var body_580458 = newJObject()
  add(query_580457, "key", newJString(key))
  add(query_580457, "prettyPrint", newJBool(prettyPrint))
  add(query_580457, "oauth_token", newJString(oauthToken))
  add(query_580457, "alt", newJString(alt))
  add(query_580457, "userIp", newJString(userIp))
  add(query_580457, "quotaUser", newJString(quotaUser))
  add(path_580456, "merchantId", newJString(merchantId))
  if body != nil:
    body_580458 = body
  add(query_580457, "fields", newJString(fields))
  add(path_580456, "orderId", newJString(orderId))
  result = call_580455.call(path_580456, query_580457, nil, nil, body_580458)

var contentOrdersCanceltestorderbycustomer* = Call_ContentOrdersCanceltestorderbycustomer_580441(
    name: "contentOrdersCanceltestorderbycustomer", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{merchantId}/testorders/{orderId}/cancelByCustomer",
    validator: validate_ContentOrdersCanceltestorderbycustomer_580442,
    base: "/content/v2.1", url: url_ContentOrdersCanceltestorderbycustomer_580443,
    schemes: {Scheme.Https})
type
  Call_ContentOrdersGettestordertemplate_580459 = ref object of OpenApiRestCall_578348
proc url_ContentOrdersGettestordertemplate_580461(protocol: Scheme; host: string;
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

proc validate_ContentOrdersGettestordertemplate_580460(path: JsonNode;
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
  var valid_580462 = path.getOrDefault("merchantId")
  valid_580462 = validateParameter(valid_580462, JString, required = true,
                                 default = nil)
  if valid_580462 != nil:
    section.add "merchantId", valid_580462
  var valid_580463 = path.getOrDefault("templateName")
  valid_580463 = validateParameter(valid_580463, JString, required = true,
                                 default = newJString("template1"))
  if valid_580463 != nil:
    section.add "templateName", valid_580463
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580466 = query.getOrDefault("oauth_token")
  valid_580466 = validateParameter(valid_580466, JString, required = false,
                                 default = nil)
  if valid_580466 != nil:
    section.add "oauth_token", valid_580466
  var valid_580467 = query.getOrDefault("alt")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = newJString("json"))
  if valid_580467 != nil:
    section.add "alt", valid_580467
  var valid_580468 = query.getOrDefault("userIp")
  valid_580468 = validateParameter(valid_580468, JString, required = false,
                                 default = nil)
  if valid_580468 != nil:
    section.add "userIp", valid_580468
  var valid_580469 = query.getOrDefault("quotaUser")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = nil)
  if valid_580469 != nil:
    section.add "quotaUser", valid_580469
  var valid_580470 = query.getOrDefault("country")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = nil)
  if valid_580470 != nil:
    section.add "country", valid_580470
  var valid_580471 = query.getOrDefault("fields")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = nil)
  if valid_580471 != nil:
    section.add "fields", valid_580471
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580472: Call_ContentOrdersGettestordertemplate_580459;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sandbox only. Retrieves an order template that can be used to quickly create a new order in sandbox.
  ## 
  let valid = call_580472.validator(path, query, header, formData, body)
  let scheme = call_580472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580472.url(scheme.get, call_580472.host, call_580472.base,
                         call_580472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580472, url, valid)

proc call*(call_580473: Call_ContentOrdersGettestordertemplate_580459;
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
  add(path_580474, "templateName", newJString(templateName))
  add(query_580475, "fields", newJString(fields))
  result = call_580473.call(path_580474, query_580475, nil, nil, nil)

var contentOrdersGettestordertemplate* = Call_ContentOrdersGettestordertemplate_580459(
    name: "contentOrdersGettestordertemplate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{merchantId}/testordertemplates/{templateName}",
    validator: validate_ContentOrdersGettestordertemplate_580460,
    base: "/content/v2.1", url: url_ContentOrdersGettestordertemplate_580461,
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
