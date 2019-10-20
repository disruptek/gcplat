
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Search Console
## version: v3
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## View Google Search Console data for your verified sites.
## 
## https://developers.google.com/webmaster-tools/
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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
  gcpServiceName = "webmasters"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_WebmastersSitesList_578609 = ref object of OpenApiRestCall_578339
proc url_WebmastersSitesList_578611(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_WebmastersSitesList_578610(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists the user's Search Console sites.
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
  var valid_578723 = query.getOrDefault("key")
  valid_578723 = validateParameter(valid_578723, JString, required = false,
                                 default = nil)
  if valid_578723 != nil:
    section.add "key", valid_578723
  var valid_578737 = query.getOrDefault("prettyPrint")
  valid_578737 = validateParameter(valid_578737, JBool, required = false,
                                 default = newJBool(true))
  if valid_578737 != nil:
    section.add "prettyPrint", valid_578737
  var valid_578738 = query.getOrDefault("oauth_token")
  valid_578738 = validateParameter(valid_578738, JString, required = false,
                                 default = nil)
  if valid_578738 != nil:
    section.add "oauth_token", valid_578738
  var valid_578739 = query.getOrDefault("alt")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = newJString("json"))
  if valid_578739 != nil:
    section.add "alt", valid_578739
  var valid_578740 = query.getOrDefault("userIp")
  valid_578740 = validateParameter(valid_578740, JString, required = false,
                                 default = nil)
  if valid_578740 != nil:
    section.add "userIp", valid_578740
  var valid_578741 = query.getOrDefault("quotaUser")
  valid_578741 = validateParameter(valid_578741, JString, required = false,
                                 default = nil)
  if valid_578741 != nil:
    section.add "quotaUser", valid_578741
  var valid_578742 = query.getOrDefault("fields")
  valid_578742 = validateParameter(valid_578742, JString, required = false,
                                 default = nil)
  if valid_578742 != nil:
    section.add "fields", valid_578742
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578765: Call_WebmastersSitesList_578609; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the user's Search Console sites.
  ## 
  let valid = call_578765.validator(path, query, header, formData, body)
  let scheme = call_578765.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578765.url(scheme.get, call_578765.host, call_578765.base,
                         call_578765.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578765, url, valid)

proc call*(call_578836: Call_WebmastersSitesList_578609; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## webmastersSitesList
  ## Lists the user's Search Console sites.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
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
  var query_578837 = newJObject()
  add(query_578837, "key", newJString(key))
  add(query_578837, "prettyPrint", newJBool(prettyPrint))
  add(query_578837, "oauth_token", newJString(oauthToken))
  add(query_578837, "alt", newJString(alt))
  add(query_578837, "userIp", newJString(userIp))
  add(query_578837, "quotaUser", newJString(quotaUser))
  add(query_578837, "fields", newJString(fields))
  result = call_578836.call(nil, query_578837, nil, nil, nil)

var webmastersSitesList* = Call_WebmastersSitesList_578609(
    name: "webmastersSitesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/sites",
    validator: validate_WebmastersSitesList_578610, base: "/webmasters/v3",
    url: url_WebmastersSitesList_578611, schemes: {Scheme.Https})
type
  Call_WebmastersSitesAdd_578906 = ref object of OpenApiRestCall_578339
proc url_WebmastersSitesAdd_578908(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "siteUrl" in path, "`siteUrl` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sites/"),
               (kind: VariableSegment, value: "siteUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebmastersSitesAdd_578907(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Adds a site to the set of the user's sites in Search Console.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   siteUrl: JString (required)
  ##          : The URL of the site to add.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `siteUrl` field"
  var valid_578909 = path.getOrDefault("siteUrl")
  valid_578909 = validateParameter(valid_578909, JString, required = true,
                                 default = nil)
  if valid_578909 != nil:
    section.add "siteUrl", valid_578909
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_578910 = query.getOrDefault("key")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "key", valid_578910
  var valid_578911 = query.getOrDefault("prettyPrint")
  valid_578911 = validateParameter(valid_578911, JBool, required = false,
                                 default = newJBool(true))
  if valid_578911 != nil:
    section.add "prettyPrint", valid_578911
  var valid_578912 = query.getOrDefault("oauth_token")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "oauth_token", valid_578912
  var valid_578913 = query.getOrDefault("alt")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = newJString("json"))
  if valid_578913 != nil:
    section.add "alt", valid_578913
  var valid_578914 = query.getOrDefault("userIp")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "userIp", valid_578914
  var valid_578915 = query.getOrDefault("quotaUser")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "quotaUser", valid_578915
  var valid_578916 = query.getOrDefault("fields")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "fields", valid_578916
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578917: Call_WebmastersSitesAdd_578906; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a site to the set of the user's sites in Search Console.
  ## 
  let valid = call_578917.validator(path, query, header, formData, body)
  let scheme = call_578917.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578917.url(scheme.get, call_578917.host, call_578917.base,
                         call_578917.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578917, url, valid)

proc call*(call_578918: Call_WebmastersSitesAdd_578906; siteUrl: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## webmastersSitesAdd
  ## Adds a site to the set of the user's sites in Search Console.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   siteUrl: string (required)
  ##          : The URL of the site to add.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578919 = newJObject()
  var query_578920 = newJObject()
  add(query_578920, "key", newJString(key))
  add(query_578920, "prettyPrint", newJBool(prettyPrint))
  add(query_578920, "oauth_token", newJString(oauthToken))
  add(query_578920, "alt", newJString(alt))
  add(query_578920, "userIp", newJString(userIp))
  add(query_578920, "quotaUser", newJString(quotaUser))
  add(path_578919, "siteUrl", newJString(siteUrl))
  add(query_578920, "fields", newJString(fields))
  result = call_578918.call(path_578919, query_578920, nil, nil, nil)

var webmastersSitesAdd* = Call_WebmastersSitesAdd_578906(
    name: "webmastersSitesAdd", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/sites/{siteUrl}",
    validator: validate_WebmastersSitesAdd_578907, base: "/webmasters/v3",
    url: url_WebmastersSitesAdd_578908, schemes: {Scheme.Https})
type
  Call_WebmastersSitesGet_578877 = ref object of OpenApiRestCall_578339
proc url_WebmastersSitesGet_578879(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "siteUrl" in path, "`siteUrl` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sites/"),
               (kind: VariableSegment, value: "siteUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebmastersSitesGet_578878(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves information about specific site.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   siteUrl: JString (required)
  ##          : The URI of the property as defined in Search Console. Examples: http://www.example.com/ or android-app://com.example/ Note: for property-sets, use the URI that starts with sc-set: which is used in Search Console URLs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `siteUrl` field"
  var valid_578894 = path.getOrDefault("siteUrl")
  valid_578894 = validateParameter(valid_578894, JString, required = true,
                                 default = nil)
  if valid_578894 != nil:
    section.add "siteUrl", valid_578894
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_578895 = query.getOrDefault("key")
  valid_578895 = validateParameter(valid_578895, JString, required = false,
                                 default = nil)
  if valid_578895 != nil:
    section.add "key", valid_578895
  var valid_578896 = query.getOrDefault("prettyPrint")
  valid_578896 = validateParameter(valid_578896, JBool, required = false,
                                 default = newJBool(true))
  if valid_578896 != nil:
    section.add "prettyPrint", valid_578896
  var valid_578897 = query.getOrDefault("oauth_token")
  valid_578897 = validateParameter(valid_578897, JString, required = false,
                                 default = nil)
  if valid_578897 != nil:
    section.add "oauth_token", valid_578897
  var valid_578898 = query.getOrDefault("alt")
  valid_578898 = validateParameter(valid_578898, JString, required = false,
                                 default = newJString("json"))
  if valid_578898 != nil:
    section.add "alt", valid_578898
  var valid_578899 = query.getOrDefault("userIp")
  valid_578899 = validateParameter(valid_578899, JString, required = false,
                                 default = nil)
  if valid_578899 != nil:
    section.add "userIp", valid_578899
  var valid_578900 = query.getOrDefault("quotaUser")
  valid_578900 = validateParameter(valid_578900, JString, required = false,
                                 default = nil)
  if valid_578900 != nil:
    section.add "quotaUser", valid_578900
  var valid_578901 = query.getOrDefault("fields")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = nil)
  if valid_578901 != nil:
    section.add "fields", valid_578901
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578902: Call_WebmastersSitesGet_578877; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about specific site.
  ## 
  let valid = call_578902.validator(path, query, header, formData, body)
  let scheme = call_578902.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578902.url(scheme.get, call_578902.host, call_578902.base,
                         call_578902.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578902, url, valid)

proc call*(call_578903: Call_WebmastersSitesGet_578877; siteUrl: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## webmastersSitesGet
  ## Retrieves information about specific site.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   siteUrl: string (required)
  ##          : The URI of the property as defined in Search Console. Examples: http://www.example.com/ or android-app://com.example/ Note: for property-sets, use the URI that starts with sc-set: which is used in Search Console URLs.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578904 = newJObject()
  var query_578905 = newJObject()
  add(query_578905, "key", newJString(key))
  add(query_578905, "prettyPrint", newJBool(prettyPrint))
  add(query_578905, "oauth_token", newJString(oauthToken))
  add(query_578905, "alt", newJString(alt))
  add(query_578905, "userIp", newJString(userIp))
  add(query_578905, "quotaUser", newJString(quotaUser))
  add(path_578904, "siteUrl", newJString(siteUrl))
  add(query_578905, "fields", newJString(fields))
  result = call_578903.call(path_578904, query_578905, nil, nil, nil)

var webmastersSitesGet* = Call_WebmastersSitesGet_578877(
    name: "webmastersSitesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/sites/{siteUrl}",
    validator: validate_WebmastersSitesGet_578878, base: "/webmasters/v3",
    url: url_WebmastersSitesGet_578879, schemes: {Scheme.Https})
type
  Call_WebmastersSitesDelete_578921 = ref object of OpenApiRestCall_578339
proc url_WebmastersSitesDelete_578923(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "siteUrl" in path, "`siteUrl` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sites/"),
               (kind: VariableSegment, value: "siteUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebmastersSitesDelete_578922(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a site from the set of the user's Search Console sites.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   siteUrl: JString (required)
  ##          : The URI of the property as defined in Search Console. Examples: http://www.example.com/ or android-app://com.example/ Note: for property-sets, use the URI that starts with sc-set: which is used in Search Console URLs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `siteUrl` field"
  var valid_578924 = path.getOrDefault("siteUrl")
  valid_578924 = validateParameter(valid_578924, JString, required = true,
                                 default = nil)
  if valid_578924 != nil:
    section.add "siteUrl", valid_578924
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_578925 = query.getOrDefault("key")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "key", valid_578925
  var valid_578926 = query.getOrDefault("prettyPrint")
  valid_578926 = validateParameter(valid_578926, JBool, required = false,
                                 default = newJBool(true))
  if valid_578926 != nil:
    section.add "prettyPrint", valid_578926
  var valid_578927 = query.getOrDefault("oauth_token")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "oauth_token", valid_578927
  var valid_578928 = query.getOrDefault("alt")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = newJString("json"))
  if valid_578928 != nil:
    section.add "alt", valid_578928
  var valid_578929 = query.getOrDefault("userIp")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "userIp", valid_578929
  var valid_578930 = query.getOrDefault("quotaUser")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "quotaUser", valid_578930
  var valid_578931 = query.getOrDefault("fields")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "fields", valid_578931
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578932: Call_WebmastersSitesDelete_578921; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a site from the set of the user's Search Console sites.
  ## 
  let valid = call_578932.validator(path, query, header, formData, body)
  let scheme = call_578932.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578932.url(scheme.get, call_578932.host, call_578932.base,
                         call_578932.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578932, url, valid)

proc call*(call_578933: Call_WebmastersSitesDelete_578921; siteUrl: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## webmastersSitesDelete
  ## Removes a site from the set of the user's Search Console sites.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   siteUrl: string (required)
  ##          : The URI of the property as defined in Search Console. Examples: http://www.example.com/ or android-app://com.example/ Note: for property-sets, use the URI that starts with sc-set: which is used in Search Console URLs.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578934 = newJObject()
  var query_578935 = newJObject()
  add(query_578935, "key", newJString(key))
  add(query_578935, "prettyPrint", newJBool(prettyPrint))
  add(query_578935, "oauth_token", newJString(oauthToken))
  add(query_578935, "alt", newJString(alt))
  add(query_578935, "userIp", newJString(userIp))
  add(query_578935, "quotaUser", newJString(quotaUser))
  add(path_578934, "siteUrl", newJString(siteUrl))
  add(query_578935, "fields", newJString(fields))
  result = call_578933.call(path_578934, query_578935, nil, nil, nil)

var webmastersSitesDelete* = Call_WebmastersSitesDelete_578921(
    name: "webmastersSitesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/sites/{siteUrl}",
    validator: validate_WebmastersSitesDelete_578922, base: "/webmasters/v3",
    url: url_WebmastersSitesDelete_578923, schemes: {Scheme.Https})
type
  Call_WebmastersSearchanalyticsQuery_578936 = ref object of OpenApiRestCall_578339
proc url_WebmastersSearchanalyticsQuery_578938(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "siteUrl" in path, "`siteUrl` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sites/"),
               (kind: VariableSegment, value: "siteUrl"),
               (kind: ConstantSegment, value: "/searchAnalytics/query")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebmastersSearchanalyticsQuery_578937(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Query your data with filters and parameters that you define. Returns zero or more rows grouped by the row keys that you define. You must define a date range of one or more days.
  ## 
  ## When date is one of the group by values, any days without data are omitted from the result list. If you need to know which days have data, issue a broad date range query grouped by date for any metric, and see which day rows are returned.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   siteUrl: JString (required)
  ##          : The site's URL, including protocol. For example: http://www.example.com/
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `siteUrl` field"
  var valid_578939 = path.getOrDefault("siteUrl")
  valid_578939 = validateParameter(valid_578939, JString, required = true,
                                 default = nil)
  if valid_578939 != nil:
    section.add "siteUrl", valid_578939
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_578940 = query.getOrDefault("key")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "key", valid_578940
  var valid_578941 = query.getOrDefault("prettyPrint")
  valid_578941 = validateParameter(valid_578941, JBool, required = false,
                                 default = newJBool(true))
  if valid_578941 != nil:
    section.add "prettyPrint", valid_578941
  var valid_578942 = query.getOrDefault("oauth_token")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "oauth_token", valid_578942
  var valid_578943 = query.getOrDefault("alt")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = newJString("json"))
  if valid_578943 != nil:
    section.add "alt", valid_578943
  var valid_578944 = query.getOrDefault("userIp")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "userIp", valid_578944
  var valid_578945 = query.getOrDefault("quotaUser")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "quotaUser", valid_578945
  var valid_578946 = query.getOrDefault("fields")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "fields", valid_578946
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578948: Call_WebmastersSearchanalyticsQuery_578936; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query your data with filters and parameters that you define. Returns zero or more rows grouped by the row keys that you define. You must define a date range of one or more days.
  ## 
  ## When date is one of the group by values, any days without data are omitted from the result list. If you need to know which days have data, issue a broad date range query grouped by date for any metric, and see which day rows are returned.
  ## 
  let valid = call_578948.validator(path, query, header, formData, body)
  let scheme = call_578948.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578948.url(scheme.get, call_578948.host, call_578948.base,
                         call_578948.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578948, url, valid)

proc call*(call_578949: Call_WebmastersSearchanalyticsQuery_578936;
          siteUrl: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## webmastersSearchanalyticsQuery
  ## Query your data with filters and parameters that you define. Returns zero or more rows grouped by the row keys that you define. You must define a date range of one or more days.
  ## 
  ## When date is one of the group by values, any days without data are omitted from the result list. If you need to know which days have data, issue a broad date range query grouped by date for any metric, and see which day rows are returned.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   siteUrl: string (required)
  ##          : The site's URL, including protocol. For example: http://www.example.com/
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578950 = newJObject()
  var query_578951 = newJObject()
  var body_578952 = newJObject()
  add(query_578951, "key", newJString(key))
  add(query_578951, "prettyPrint", newJBool(prettyPrint))
  add(query_578951, "oauth_token", newJString(oauthToken))
  add(query_578951, "alt", newJString(alt))
  add(query_578951, "userIp", newJString(userIp))
  add(query_578951, "quotaUser", newJString(quotaUser))
  add(path_578950, "siteUrl", newJString(siteUrl))
  if body != nil:
    body_578952 = body
  add(query_578951, "fields", newJString(fields))
  result = call_578949.call(path_578950, query_578951, nil, nil, body_578952)

var webmastersSearchanalyticsQuery* = Call_WebmastersSearchanalyticsQuery_578936(
    name: "webmastersSearchanalyticsQuery", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/sites/{siteUrl}/searchAnalytics/query",
    validator: validate_WebmastersSearchanalyticsQuery_578937,
    base: "/webmasters/v3", url: url_WebmastersSearchanalyticsQuery_578938,
    schemes: {Scheme.Https})
type
  Call_WebmastersSitemapsList_578953 = ref object of OpenApiRestCall_578339
proc url_WebmastersSitemapsList_578955(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "siteUrl" in path, "`siteUrl` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sites/"),
               (kind: VariableSegment, value: "siteUrl"),
               (kind: ConstantSegment, value: "/sitemaps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebmastersSitemapsList_578954(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the sitemaps-entries submitted for this site, or included in the sitemap index file (if sitemapIndex is specified in the request).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   siteUrl: JString (required)
  ##          : The site's URL, including protocol. For example: http://www.example.com/
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `siteUrl` field"
  var valid_578956 = path.getOrDefault("siteUrl")
  valid_578956 = validateParameter(valid_578956, JString, required = true,
                                 default = nil)
  if valid_578956 != nil:
    section.add "siteUrl", valid_578956
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   sitemapIndex: JString
  ##               : A URL of a site's sitemap index. For example: http://www.example.com/sitemapindex.xml
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578957 = query.getOrDefault("key")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "key", valid_578957
  var valid_578958 = query.getOrDefault("prettyPrint")
  valid_578958 = validateParameter(valid_578958, JBool, required = false,
                                 default = newJBool(true))
  if valid_578958 != nil:
    section.add "prettyPrint", valid_578958
  var valid_578959 = query.getOrDefault("oauth_token")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "oauth_token", valid_578959
  var valid_578960 = query.getOrDefault("sitemapIndex")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "sitemapIndex", valid_578960
  var valid_578961 = query.getOrDefault("alt")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = newJString("json"))
  if valid_578961 != nil:
    section.add "alt", valid_578961
  var valid_578962 = query.getOrDefault("userIp")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "userIp", valid_578962
  var valid_578963 = query.getOrDefault("quotaUser")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "quotaUser", valid_578963
  var valid_578964 = query.getOrDefault("fields")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "fields", valid_578964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578965: Call_WebmastersSitemapsList_578953; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the sitemaps-entries submitted for this site, or included in the sitemap index file (if sitemapIndex is specified in the request).
  ## 
  let valid = call_578965.validator(path, query, header, formData, body)
  let scheme = call_578965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578965.url(scheme.get, call_578965.host, call_578965.base,
                         call_578965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578965, url, valid)

proc call*(call_578966: Call_WebmastersSitemapsList_578953; siteUrl: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          sitemapIndex: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## webmastersSitemapsList
  ## Lists the sitemaps-entries submitted for this site, or included in the sitemap index file (if sitemapIndex is specified in the request).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   sitemapIndex: string
  ##               : A URL of a site's sitemap index. For example: http://www.example.com/sitemapindex.xml
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   siteUrl: string (required)
  ##          : The site's URL, including protocol. For example: http://www.example.com/
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578967 = newJObject()
  var query_578968 = newJObject()
  add(query_578968, "key", newJString(key))
  add(query_578968, "prettyPrint", newJBool(prettyPrint))
  add(query_578968, "oauth_token", newJString(oauthToken))
  add(query_578968, "sitemapIndex", newJString(sitemapIndex))
  add(query_578968, "alt", newJString(alt))
  add(query_578968, "userIp", newJString(userIp))
  add(query_578968, "quotaUser", newJString(quotaUser))
  add(path_578967, "siteUrl", newJString(siteUrl))
  add(query_578968, "fields", newJString(fields))
  result = call_578966.call(path_578967, query_578968, nil, nil, nil)

var webmastersSitemapsList* = Call_WebmastersSitemapsList_578953(
    name: "webmastersSitemapsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/sites/{siteUrl}/sitemaps",
    validator: validate_WebmastersSitemapsList_578954, base: "/webmasters/v3",
    url: url_WebmastersSitemapsList_578955, schemes: {Scheme.Https})
type
  Call_WebmastersSitemapsSubmit_578985 = ref object of OpenApiRestCall_578339
proc url_WebmastersSitemapsSubmit_578987(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "siteUrl" in path, "`siteUrl` is a required path parameter"
  assert "feedpath" in path, "`feedpath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sites/"),
               (kind: VariableSegment, value: "siteUrl"),
               (kind: ConstantSegment, value: "/sitemaps/"),
               (kind: VariableSegment, value: "feedpath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebmastersSitemapsSubmit_578986(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Submits a sitemap for a site.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   siteUrl: JString (required)
  ##          : The site's URL, including protocol. For example: http://www.example.com/
  ##   feedpath: JString (required)
  ##           : The URL of the sitemap to add. For example: http://www.example.com/sitemap.xml
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `siteUrl` field"
  var valid_578988 = path.getOrDefault("siteUrl")
  valid_578988 = validateParameter(valid_578988, JString, required = true,
                                 default = nil)
  if valid_578988 != nil:
    section.add "siteUrl", valid_578988
  var valid_578989 = path.getOrDefault("feedpath")
  valid_578989 = validateParameter(valid_578989, JString, required = true,
                                 default = nil)
  if valid_578989 != nil:
    section.add "feedpath", valid_578989
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_578990 = query.getOrDefault("key")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "key", valid_578990
  var valid_578991 = query.getOrDefault("prettyPrint")
  valid_578991 = validateParameter(valid_578991, JBool, required = false,
                                 default = newJBool(true))
  if valid_578991 != nil:
    section.add "prettyPrint", valid_578991
  var valid_578992 = query.getOrDefault("oauth_token")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "oauth_token", valid_578992
  var valid_578993 = query.getOrDefault("alt")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = newJString("json"))
  if valid_578993 != nil:
    section.add "alt", valid_578993
  var valid_578994 = query.getOrDefault("userIp")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "userIp", valid_578994
  var valid_578995 = query.getOrDefault("quotaUser")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "quotaUser", valid_578995
  var valid_578996 = query.getOrDefault("fields")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "fields", valid_578996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578997: Call_WebmastersSitemapsSubmit_578985; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a sitemap for a site.
  ## 
  let valid = call_578997.validator(path, query, header, formData, body)
  let scheme = call_578997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578997.url(scheme.get, call_578997.host, call_578997.base,
                         call_578997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578997, url, valid)

proc call*(call_578998: Call_WebmastersSitemapsSubmit_578985; siteUrl: string;
          feedpath: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## webmastersSitemapsSubmit
  ## Submits a sitemap for a site.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   siteUrl: string (required)
  ##          : The site's URL, including protocol. For example: http://www.example.com/
  ##   feedpath: string (required)
  ##           : The URL of the sitemap to add. For example: http://www.example.com/sitemap.xml
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578999 = newJObject()
  var query_579000 = newJObject()
  add(query_579000, "key", newJString(key))
  add(query_579000, "prettyPrint", newJBool(prettyPrint))
  add(query_579000, "oauth_token", newJString(oauthToken))
  add(query_579000, "alt", newJString(alt))
  add(query_579000, "userIp", newJString(userIp))
  add(query_579000, "quotaUser", newJString(quotaUser))
  add(path_578999, "siteUrl", newJString(siteUrl))
  add(path_578999, "feedpath", newJString(feedpath))
  add(query_579000, "fields", newJString(fields))
  result = call_578998.call(path_578999, query_579000, nil, nil, nil)

var webmastersSitemapsSubmit* = Call_WebmastersSitemapsSubmit_578985(
    name: "webmastersSitemapsSubmit", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/sites/{siteUrl}/sitemaps/{feedpath}",
    validator: validate_WebmastersSitemapsSubmit_578986, base: "/webmasters/v3",
    url: url_WebmastersSitemapsSubmit_578987, schemes: {Scheme.Https})
type
  Call_WebmastersSitemapsGet_578969 = ref object of OpenApiRestCall_578339
proc url_WebmastersSitemapsGet_578971(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "siteUrl" in path, "`siteUrl` is a required path parameter"
  assert "feedpath" in path, "`feedpath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sites/"),
               (kind: VariableSegment, value: "siteUrl"),
               (kind: ConstantSegment, value: "/sitemaps/"),
               (kind: VariableSegment, value: "feedpath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebmastersSitemapsGet_578970(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves information about a specific sitemap.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   siteUrl: JString (required)
  ##          : The site's URL, including protocol. For example: http://www.example.com/
  ##   feedpath: JString (required)
  ##           : The URL of the actual sitemap. For example: http://www.example.com/sitemap.xml
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `siteUrl` field"
  var valid_578972 = path.getOrDefault("siteUrl")
  valid_578972 = validateParameter(valid_578972, JString, required = true,
                                 default = nil)
  if valid_578972 != nil:
    section.add "siteUrl", valid_578972
  var valid_578973 = path.getOrDefault("feedpath")
  valid_578973 = validateParameter(valid_578973, JString, required = true,
                                 default = nil)
  if valid_578973 != nil:
    section.add "feedpath", valid_578973
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_578974 = query.getOrDefault("key")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "key", valid_578974
  var valid_578975 = query.getOrDefault("prettyPrint")
  valid_578975 = validateParameter(valid_578975, JBool, required = false,
                                 default = newJBool(true))
  if valid_578975 != nil:
    section.add "prettyPrint", valid_578975
  var valid_578976 = query.getOrDefault("oauth_token")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "oauth_token", valid_578976
  var valid_578977 = query.getOrDefault("alt")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = newJString("json"))
  if valid_578977 != nil:
    section.add "alt", valid_578977
  var valid_578978 = query.getOrDefault("userIp")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "userIp", valid_578978
  var valid_578979 = query.getOrDefault("quotaUser")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "quotaUser", valid_578979
  var valid_578980 = query.getOrDefault("fields")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "fields", valid_578980
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578981: Call_WebmastersSitemapsGet_578969; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about a specific sitemap.
  ## 
  let valid = call_578981.validator(path, query, header, formData, body)
  let scheme = call_578981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578981.url(scheme.get, call_578981.host, call_578981.base,
                         call_578981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578981, url, valid)

proc call*(call_578982: Call_WebmastersSitemapsGet_578969; siteUrl: string;
          feedpath: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## webmastersSitemapsGet
  ## Retrieves information about a specific sitemap.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   siteUrl: string (required)
  ##          : The site's URL, including protocol. For example: http://www.example.com/
  ##   feedpath: string (required)
  ##           : The URL of the actual sitemap. For example: http://www.example.com/sitemap.xml
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578983 = newJObject()
  var query_578984 = newJObject()
  add(query_578984, "key", newJString(key))
  add(query_578984, "prettyPrint", newJBool(prettyPrint))
  add(query_578984, "oauth_token", newJString(oauthToken))
  add(query_578984, "alt", newJString(alt))
  add(query_578984, "userIp", newJString(userIp))
  add(query_578984, "quotaUser", newJString(quotaUser))
  add(path_578983, "siteUrl", newJString(siteUrl))
  add(path_578983, "feedpath", newJString(feedpath))
  add(query_578984, "fields", newJString(fields))
  result = call_578982.call(path_578983, query_578984, nil, nil, nil)

var webmastersSitemapsGet* = Call_WebmastersSitemapsGet_578969(
    name: "webmastersSitemapsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/sites/{siteUrl}/sitemaps/{feedpath}",
    validator: validate_WebmastersSitemapsGet_578970, base: "/webmasters/v3",
    url: url_WebmastersSitemapsGet_578971, schemes: {Scheme.Https})
type
  Call_WebmastersSitemapsDelete_579001 = ref object of OpenApiRestCall_578339
proc url_WebmastersSitemapsDelete_579003(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "siteUrl" in path, "`siteUrl` is a required path parameter"
  assert "feedpath" in path, "`feedpath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sites/"),
               (kind: VariableSegment, value: "siteUrl"),
               (kind: ConstantSegment, value: "/sitemaps/"),
               (kind: VariableSegment, value: "feedpath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebmastersSitemapsDelete_579002(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a sitemap from this site.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   siteUrl: JString (required)
  ##          : The site's URL, including protocol. For example: http://www.example.com/
  ##   feedpath: JString (required)
  ##           : The URL of the actual sitemap. For example: http://www.example.com/sitemap.xml
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `siteUrl` field"
  var valid_579004 = path.getOrDefault("siteUrl")
  valid_579004 = validateParameter(valid_579004, JString, required = true,
                                 default = nil)
  if valid_579004 != nil:
    section.add "siteUrl", valid_579004
  var valid_579005 = path.getOrDefault("feedpath")
  valid_579005 = validateParameter(valid_579005, JString, required = true,
                                 default = nil)
  if valid_579005 != nil:
    section.add "feedpath", valid_579005
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579006 = query.getOrDefault("key")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "key", valid_579006
  var valid_579007 = query.getOrDefault("prettyPrint")
  valid_579007 = validateParameter(valid_579007, JBool, required = false,
                                 default = newJBool(true))
  if valid_579007 != nil:
    section.add "prettyPrint", valid_579007
  var valid_579008 = query.getOrDefault("oauth_token")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "oauth_token", valid_579008
  var valid_579009 = query.getOrDefault("alt")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = newJString("json"))
  if valid_579009 != nil:
    section.add "alt", valid_579009
  var valid_579010 = query.getOrDefault("userIp")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "userIp", valid_579010
  var valid_579011 = query.getOrDefault("quotaUser")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "quotaUser", valid_579011
  var valid_579012 = query.getOrDefault("fields")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "fields", valid_579012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579013: Call_WebmastersSitemapsDelete_579001; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a sitemap from this site.
  ## 
  let valid = call_579013.validator(path, query, header, formData, body)
  let scheme = call_579013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579013.url(scheme.get, call_579013.host, call_579013.base,
                         call_579013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579013, url, valid)

proc call*(call_579014: Call_WebmastersSitemapsDelete_579001; siteUrl: string;
          feedpath: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## webmastersSitemapsDelete
  ## Deletes a sitemap from this site.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   siteUrl: string (required)
  ##          : The site's URL, including protocol. For example: http://www.example.com/
  ##   feedpath: string (required)
  ##           : The URL of the actual sitemap. For example: http://www.example.com/sitemap.xml
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579015 = newJObject()
  var query_579016 = newJObject()
  add(query_579016, "key", newJString(key))
  add(query_579016, "prettyPrint", newJBool(prettyPrint))
  add(query_579016, "oauth_token", newJString(oauthToken))
  add(query_579016, "alt", newJString(alt))
  add(query_579016, "userIp", newJString(userIp))
  add(query_579016, "quotaUser", newJString(quotaUser))
  add(path_579015, "siteUrl", newJString(siteUrl))
  add(path_579015, "feedpath", newJString(feedpath))
  add(query_579016, "fields", newJString(fields))
  result = call_579014.call(path_579015, query_579016, nil, nil, nil)

var webmastersSitemapsDelete* = Call_WebmastersSitemapsDelete_579001(
    name: "webmastersSitemapsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/sites/{siteUrl}/sitemaps/{feedpath}",
    validator: validate_WebmastersSitemapsDelete_579002, base: "/webmasters/v3",
    url: url_WebmastersSitemapsDelete_579003, schemes: {Scheme.Https})
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
