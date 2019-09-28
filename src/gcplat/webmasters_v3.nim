
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

  OpenApiRestCall_579408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579408): Option[Scheme] {.used.} =
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
  gcpServiceName = "webmasters"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_WebmastersSitesList_579676 = ref object of OpenApiRestCall_579408
proc url_WebmastersSitesList_579678(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_WebmastersSitesList_579677(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists the user's Search Console sites.
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
  var valid_579790 = query.getOrDefault("fields")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = nil)
  if valid_579790 != nil:
    section.add "fields", valid_579790
  var valid_579791 = query.getOrDefault("quotaUser")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "quotaUser", valid_579791
  var valid_579805 = query.getOrDefault("alt")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = newJString("json"))
  if valid_579805 != nil:
    section.add "alt", valid_579805
  var valid_579806 = query.getOrDefault("oauth_token")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "oauth_token", valid_579806
  var valid_579807 = query.getOrDefault("userIp")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "userIp", valid_579807
  var valid_579808 = query.getOrDefault("key")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "key", valid_579808
  var valid_579809 = query.getOrDefault("prettyPrint")
  valid_579809 = validateParameter(valid_579809, JBool, required = false,
                                 default = newJBool(true))
  if valid_579809 != nil:
    section.add "prettyPrint", valid_579809
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579832: Call_WebmastersSitesList_579676; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the user's Search Console sites.
  ## 
  let valid = call_579832.validator(path, query, header, formData, body)
  let scheme = call_579832.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579832.url(scheme.get, call_579832.host, call_579832.base,
                         call_579832.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579832, url, valid)

proc call*(call_579903: Call_WebmastersSitesList_579676; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## webmastersSitesList
  ## Lists the user's Search Console sites.
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
  var query_579904 = newJObject()
  add(query_579904, "fields", newJString(fields))
  add(query_579904, "quotaUser", newJString(quotaUser))
  add(query_579904, "alt", newJString(alt))
  add(query_579904, "oauth_token", newJString(oauthToken))
  add(query_579904, "userIp", newJString(userIp))
  add(query_579904, "key", newJString(key))
  add(query_579904, "prettyPrint", newJBool(prettyPrint))
  result = call_579903.call(nil, query_579904, nil, nil, nil)

var webmastersSitesList* = Call_WebmastersSitesList_579676(
    name: "webmastersSitesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/sites",
    validator: validate_WebmastersSitesList_579677, base: "/webmasters/v3",
    url: url_WebmastersSitesList_579678, schemes: {Scheme.Https})
type
  Call_WebmastersSitesAdd_579973 = ref object of OpenApiRestCall_579408
proc url_WebmastersSitesAdd_579975(protocol: Scheme; host: string; base: string;
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

proc validate_WebmastersSitesAdd_579974(path: JsonNode; query: JsonNode;
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
  var valid_579976 = path.getOrDefault("siteUrl")
  valid_579976 = validateParameter(valid_579976, JString, required = true,
                                 default = nil)
  if valid_579976 != nil:
    section.add "siteUrl", valid_579976
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579977 = query.getOrDefault("fields")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "fields", valid_579977
  var valid_579978 = query.getOrDefault("quotaUser")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "quotaUser", valid_579978
  var valid_579979 = query.getOrDefault("alt")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = newJString("json"))
  if valid_579979 != nil:
    section.add "alt", valid_579979
  var valid_579980 = query.getOrDefault("oauth_token")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "oauth_token", valid_579980
  var valid_579981 = query.getOrDefault("userIp")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "userIp", valid_579981
  var valid_579982 = query.getOrDefault("key")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "key", valid_579982
  var valid_579983 = query.getOrDefault("prettyPrint")
  valid_579983 = validateParameter(valid_579983, JBool, required = false,
                                 default = newJBool(true))
  if valid_579983 != nil:
    section.add "prettyPrint", valid_579983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579984: Call_WebmastersSitesAdd_579973; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a site to the set of the user's sites in Search Console.
  ## 
  let valid = call_579984.validator(path, query, header, formData, body)
  let scheme = call_579984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579984.url(scheme.get, call_579984.host, call_579984.base,
                         call_579984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579984, url, valid)

proc call*(call_579985: Call_WebmastersSitesAdd_579973; siteUrl: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## webmastersSitesAdd
  ## Adds a site to the set of the user's sites in Search Console.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   siteUrl: string (required)
  ##          : The URL of the site to add.
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
  var path_579986 = newJObject()
  var query_579987 = newJObject()
  add(query_579987, "fields", newJString(fields))
  add(query_579987, "quotaUser", newJString(quotaUser))
  add(path_579986, "siteUrl", newJString(siteUrl))
  add(query_579987, "alt", newJString(alt))
  add(query_579987, "oauth_token", newJString(oauthToken))
  add(query_579987, "userIp", newJString(userIp))
  add(query_579987, "key", newJString(key))
  add(query_579987, "prettyPrint", newJBool(prettyPrint))
  result = call_579985.call(path_579986, query_579987, nil, nil, nil)

var webmastersSitesAdd* = Call_WebmastersSitesAdd_579973(
    name: "webmastersSitesAdd", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/sites/{siteUrl}",
    validator: validate_WebmastersSitesAdd_579974, base: "/webmasters/v3",
    url: url_WebmastersSitesAdd_579975, schemes: {Scheme.Https})
type
  Call_WebmastersSitesGet_579944 = ref object of OpenApiRestCall_579408
proc url_WebmastersSitesGet_579946(protocol: Scheme; host: string; base: string;
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

proc validate_WebmastersSitesGet_579945(path: JsonNode; query: JsonNode;
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
  var valid_579961 = path.getOrDefault("siteUrl")
  valid_579961 = validateParameter(valid_579961, JString, required = true,
                                 default = nil)
  if valid_579961 != nil:
    section.add "siteUrl", valid_579961
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579962 = query.getOrDefault("fields")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "fields", valid_579962
  var valid_579963 = query.getOrDefault("quotaUser")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "quotaUser", valid_579963
  var valid_579964 = query.getOrDefault("alt")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = newJString("json"))
  if valid_579964 != nil:
    section.add "alt", valid_579964
  var valid_579965 = query.getOrDefault("oauth_token")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "oauth_token", valid_579965
  var valid_579966 = query.getOrDefault("userIp")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "userIp", valid_579966
  var valid_579967 = query.getOrDefault("key")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "key", valid_579967
  var valid_579968 = query.getOrDefault("prettyPrint")
  valid_579968 = validateParameter(valid_579968, JBool, required = false,
                                 default = newJBool(true))
  if valid_579968 != nil:
    section.add "prettyPrint", valid_579968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579969: Call_WebmastersSitesGet_579944; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about specific site.
  ## 
  let valid = call_579969.validator(path, query, header, formData, body)
  let scheme = call_579969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579969.url(scheme.get, call_579969.host, call_579969.base,
                         call_579969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579969, url, valid)

proc call*(call_579970: Call_WebmastersSitesGet_579944; siteUrl: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## webmastersSitesGet
  ## Retrieves information about specific site.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   siteUrl: string (required)
  ##          : The URI of the property as defined in Search Console. Examples: http://www.example.com/ or android-app://com.example/ Note: for property-sets, use the URI that starts with sc-set: which is used in Search Console URLs.
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
  var path_579971 = newJObject()
  var query_579972 = newJObject()
  add(query_579972, "fields", newJString(fields))
  add(query_579972, "quotaUser", newJString(quotaUser))
  add(path_579971, "siteUrl", newJString(siteUrl))
  add(query_579972, "alt", newJString(alt))
  add(query_579972, "oauth_token", newJString(oauthToken))
  add(query_579972, "userIp", newJString(userIp))
  add(query_579972, "key", newJString(key))
  add(query_579972, "prettyPrint", newJBool(prettyPrint))
  result = call_579970.call(path_579971, query_579972, nil, nil, nil)

var webmastersSitesGet* = Call_WebmastersSitesGet_579944(
    name: "webmastersSitesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/sites/{siteUrl}",
    validator: validate_WebmastersSitesGet_579945, base: "/webmasters/v3",
    url: url_WebmastersSitesGet_579946, schemes: {Scheme.Https})
type
  Call_WebmastersSitesDelete_579988 = ref object of OpenApiRestCall_579408
proc url_WebmastersSitesDelete_579990(protocol: Scheme; host: string; base: string;
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

proc validate_WebmastersSitesDelete_579989(path: JsonNode; query: JsonNode;
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
  var valid_579991 = path.getOrDefault("siteUrl")
  valid_579991 = validateParameter(valid_579991, JString, required = true,
                                 default = nil)
  if valid_579991 != nil:
    section.add "siteUrl", valid_579991
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579992 = query.getOrDefault("fields")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "fields", valid_579992
  var valid_579993 = query.getOrDefault("quotaUser")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "quotaUser", valid_579993
  var valid_579994 = query.getOrDefault("alt")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = newJString("json"))
  if valid_579994 != nil:
    section.add "alt", valid_579994
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
  if body != nil:
    result.add "body", body

proc call*(call_579999: Call_WebmastersSitesDelete_579988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a site from the set of the user's Search Console sites.
  ## 
  let valid = call_579999.validator(path, query, header, formData, body)
  let scheme = call_579999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579999.url(scheme.get, call_579999.host, call_579999.base,
                         call_579999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579999, url, valid)

proc call*(call_580000: Call_WebmastersSitesDelete_579988; siteUrl: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## webmastersSitesDelete
  ## Removes a site from the set of the user's Search Console sites.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   siteUrl: string (required)
  ##          : The URI of the property as defined in Search Console. Examples: http://www.example.com/ or android-app://com.example/ Note: for property-sets, use the URI that starts with sc-set: which is used in Search Console URLs.
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
  var path_580001 = newJObject()
  var query_580002 = newJObject()
  add(query_580002, "fields", newJString(fields))
  add(query_580002, "quotaUser", newJString(quotaUser))
  add(path_580001, "siteUrl", newJString(siteUrl))
  add(query_580002, "alt", newJString(alt))
  add(query_580002, "oauth_token", newJString(oauthToken))
  add(query_580002, "userIp", newJString(userIp))
  add(query_580002, "key", newJString(key))
  add(query_580002, "prettyPrint", newJBool(prettyPrint))
  result = call_580000.call(path_580001, query_580002, nil, nil, nil)

var webmastersSitesDelete* = Call_WebmastersSitesDelete_579988(
    name: "webmastersSitesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/sites/{siteUrl}",
    validator: validate_WebmastersSitesDelete_579989, base: "/webmasters/v3",
    url: url_WebmastersSitesDelete_579990, schemes: {Scheme.Https})
type
  Call_WebmastersSearchanalyticsQuery_580003 = ref object of OpenApiRestCall_579408
proc url_WebmastersSearchanalyticsQuery_580005(protocol: Scheme; host: string;
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

proc validate_WebmastersSearchanalyticsQuery_580004(path: JsonNode;
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
  var valid_580006 = path.getOrDefault("siteUrl")
  valid_580006 = validateParameter(valid_580006, JString, required = true,
                                 default = nil)
  if valid_580006 != nil:
    section.add "siteUrl", valid_580006
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
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
  var valid_580010 = query.getOrDefault("oauth_token")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "oauth_token", valid_580010
  var valid_580011 = query.getOrDefault("userIp")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "userIp", valid_580011
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580015: Call_WebmastersSearchanalyticsQuery_580003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query your data with filters and parameters that you define. Returns zero or more rows grouped by the row keys that you define. You must define a date range of one or more days.
  ## 
  ## When date is one of the group by values, any days without data are omitted from the result list. If you need to know which days have data, issue a broad date range query grouped by date for any metric, and see which day rows are returned.
  ## 
  let valid = call_580015.validator(path, query, header, formData, body)
  let scheme = call_580015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580015.url(scheme.get, call_580015.host, call_580015.base,
                         call_580015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580015, url, valid)

proc call*(call_580016: Call_WebmastersSearchanalyticsQuery_580003;
          siteUrl: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## webmastersSearchanalyticsQuery
  ## Query your data with filters and parameters that you define. Returns zero or more rows grouped by the row keys that you define. You must define a date range of one or more days.
  ## 
  ## When date is one of the group by values, any days without data are omitted from the result list. If you need to know which days have data, issue a broad date range query grouped by date for any metric, and see which day rows are returned.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   siteUrl: string (required)
  ##          : The site's URL, including protocol. For example: http://www.example.com/
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
  var path_580017 = newJObject()
  var query_580018 = newJObject()
  var body_580019 = newJObject()
  add(query_580018, "fields", newJString(fields))
  add(query_580018, "quotaUser", newJString(quotaUser))
  add(path_580017, "siteUrl", newJString(siteUrl))
  add(query_580018, "alt", newJString(alt))
  add(query_580018, "oauth_token", newJString(oauthToken))
  add(query_580018, "userIp", newJString(userIp))
  add(query_580018, "key", newJString(key))
  if body != nil:
    body_580019 = body
  add(query_580018, "prettyPrint", newJBool(prettyPrint))
  result = call_580016.call(path_580017, query_580018, nil, nil, body_580019)

var webmastersSearchanalyticsQuery* = Call_WebmastersSearchanalyticsQuery_580003(
    name: "webmastersSearchanalyticsQuery", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/sites/{siteUrl}/searchAnalytics/query",
    validator: validate_WebmastersSearchanalyticsQuery_580004,
    base: "/webmasters/v3", url: url_WebmastersSearchanalyticsQuery_580005,
    schemes: {Scheme.Https})
type
  Call_WebmastersSitemapsList_580020 = ref object of OpenApiRestCall_579408
proc url_WebmastersSitemapsList_580022(protocol: Scheme; host: string; base: string;
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

proc validate_WebmastersSitemapsList_580021(path: JsonNode; query: JsonNode;
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
  var valid_580023 = path.getOrDefault("siteUrl")
  valid_580023 = validateParameter(valid_580023, JString, required = true,
                                 default = nil)
  if valid_580023 != nil:
    section.add "siteUrl", valid_580023
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   sitemapIndex: JString
  ##               : A URL of a site's sitemap index. For example: http://www.example.com/sitemapindex.xml
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580024 = query.getOrDefault("fields")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "fields", valid_580024
  var valid_580025 = query.getOrDefault("quotaUser")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "quotaUser", valid_580025
  var valid_580026 = query.getOrDefault("alt")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = newJString("json"))
  if valid_580026 != nil:
    section.add "alt", valid_580026
  var valid_580027 = query.getOrDefault("sitemapIndex")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "sitemapIndex", valid_580027
  var valid_580028 = query.getOrDefault("oauth_token")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "oauth_token", valid_580028
  var valid_580029 = query.getOrDefault("userIp")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "userIp", valid_580029
  var valid_580030 = query.getOrDefault("key")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "key", valid_580030
  var valid_580031 = query.getOrDefault("prettyPrint")
  valid_580031 = validateParameter(valid_580031, JBool, required = false,
                                 default = newJBool(true))
  if valid_580031 != nil:
    section.add "prettyPrint", valid_580031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580032: Call_WebmastersSitemapsList_580020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the sitemaps-entries submitted for this site, or included in the sitemap index file (if sitemapIndex is specified in the request).
  ## 
  let valid = call_580032.validator(path, query, header, formData, body)
  let scheme = call_580032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580032.url(scheme.get, call_580032.host, call_580032.base,
                         call_580032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580032, url, valid)

proc call*(call_580033: Call_WebmastersSitemapsList_580020; siteUrl: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          sitemapIndex: string = ""; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## webmastersSitemapsList
  ## Lists the sitemaps-entries submitted for this site, or included in the sitemap index file (if sitemapIndex is specified in the request).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   siteUrl: string (required)
  ##          : The site's URL, including protocol. For example: http://www.example.com/
  ##   alt: string
  ##      : Data format for the response.
  ##   sitemapIndex: string
  ##               : A URL of a site's sitemap index. For example: http://www.example.com/sitemapindex.xml
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580034 = newJObject()
  var query_580035 = newJObject()
  add(query_580035, "fields", newJString(fields))
  add(query_580035, "quotaUser", newJString(quotaUser))
  add(path_580034, "siteUrl", newJString(siteUrl))
  add(query_580035, "alt", newJString(alt))
  add(query_580035, "sitemapIndex", newJString(sitemapIndex))
  add(query_580035, "oauth_token", newJString(oauthToken))
  add(query_580035, "userIp", newJString(userIp))
  add(query_580035, "key", newJString(key))
  add(query_580035, "prettyPrint", newJBool(prettyPrint))
  result = call_580033.call(path_580034, query_580035, nil, nil, nil)

var webmastersSitemapsList* = Call_WebmastersSitemapsList_580020(
    name: "webmastersSitemapsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/sites/{siteUrl}/sitemaps",
    validator: validate_WebmastersSitemapsList_580021, base: "/webmasters/v3",
    url: url_WebmastersSitemapsList_580022, schemes: {Scheme.Https})
type
  Call_WebmastersSitemapsSubmit_580052 = ref object of OpenApiRestCall_579408
proc url_WebmastersSitemapsSubmit_580054(protocol: Scheme; host: string;
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

proc validate_WebmastersSitemapsSubmit_580053(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Submits a sitemap for a site.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   feedpath: JString (required)
  ##           : The URL of the sitemap to add. For example: http://www.example.com/sitemap.xml
  ##   siteUrl: JString (required)
  ##          : The site's URL, including protocol. For example: http://www.example.com/
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `feedpath` field"
  var valid_580055 = path.getOrDefault("feedpath")
  valid_580055 = validateParameter(valid_580055, JString, required = true,
                                 default = nil)
  if valid_580055 != nil:
    section.add "feedpath", valid_580055
  var valid_580056 = path.getOrDefault("siteUrl")
  valid_580056 = validateParameter(valid_580056, JString, required = true,
                                 default = nil)
  if valid_580056 != nil:
    section.add "siteUrl", valid_580056
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580057 = query.getOrDefault("fields")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "fields", valid_580057
  var valid_580058 = query.getOrDefault("quotaUser")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "quotaUser", valid_580058
  var valid_580059 = query.getOrDefault("alt")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = newJString("json"))
  if valid_580059 != nil:
    section.add "alt", valid_580059
  var valid_580060 = query.getOrDefault("oauth_token")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "oauth_token", valid_580060
  var valid_580061 = query.getOrDefault("userIp")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "userIp", valid_580061
  var valid_580062 = query.getOrDefault("key")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "key", valid_580062
  var valid_580063 = query.getOrDefault("prettyPrint")
  valid_580063 = validateParameter(valid_580063, JBool, required = false,
                                 default = newJBool(true))
  if valid_580063 != nil:
    section.add "prettyPrint", valid_580063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580064: Call_WebmastersSitemapsSubmit_580052; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a sitemap for a site.
  ## 
  let valid = call_580064.validator(path, query, header, formData, body)
  let scheme = call_580064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580064.url(scheme.get, call_580064.host, call_580064.base,
                         call_580064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580064, url, valid)

proc call*(call_580065: Call_WebmastersSitemapsSubmit_580052; feedpath: string;
          siteUrl: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## webmastersSitemapsSubmit
  ## Submits a sitemap for a site.
  ##   feedpath: string (required)
  ##           : The URL of the sitemap to add. For example: http://www.example.com/sitemap.xml
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   siteUrl: string (required)
  ##          : The site's URL, including protocol. For example: http://www.example.com/
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
  var path_580066 = newJObject()
  var query_580067 = newJObject()
  add(path_580066, "feedpath", newJString(feedpath))
  add(query_580067, "fields", newJString(fields))
  add(query_580067, "quotaUser", newJString(quotaUser))
  add(path_580066, "siteUrl", newJString(siteUrl))
  add(query_580067, "alt", newJString(alt))
  add(query_580067, "oauth_token", newJString(oauthToken))
  add(query_580067, "userIp", newJString(userIp))
  add(query_580067, "key", newJString(key))
  add(query_580067, "prettyPrint", newJBool(prettyPrint))
  result = call_580065.call(path_580066, query_580067, nil, nil, nil)

var webmastersSitemapsSubmit* = Call_WebmastersSitemapsSubmit_580052(
    name: "webmastersSitemapsSubmit", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/sites/{siteUrl}/sitemaps/{feedpath}",
    validator: validate_WebmastersSitemapsSubmit_580053, base: "/webmasters/v3",
    url: url_WebmastersSitemapsSubmit_580054, schemes: {Scheme.Https})
type
  Call_WebmastersSitemapsGet_580036 = ref object of OpenApiRestCall_579408
proc url_WebmastersSitemapsGet_580038(protocol: Scheme; host: string; base: string;
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

proc validate_WebmastersSitemapsGet_580037(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves information about a specific sitemap.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   feedpath: JString (required)
  ##           : The URL of the actual sitemap. For example: http://www.example.com/sitemap.xml
  ##   siteUrl: JString (required)
  ##          : The site's URL, including protocol. For example: http://www.example.com/
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `feedpath` field"
  var valid_580039 = path.getOrDefault("feedpath")
  valid_580039 = validateParameter(valid_580039, JString, required = true,
                                 default = nil)
  if valid_580039 != nil:
    section.add "feedpath", valid_580039
  var valid_580040 = path.getOrDefault("siteUrl")
  valid_580040 = validateParameter(valid_580040, JString, required = true,
                                 default = nil)
  if valid_580040 != nil:
    section.add "siteUrl", valid_580040
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580041 = query.getOrDefault("fields")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "fields", valid_580041
  var valid_580042 = query.getOrDefault("quotaUser")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "quotaUser", valid_580042
  var valid_580043 = query.getOrDefault("alt")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = newJString("json"))
  if valid_580043 != nil:
    section.add "alt", valid_580043
  var valid_580044 = query.getOrDefault("oauth_token")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "oauth_token", valid_580044
  var valid_580045 = query.getOrDefault("userIp")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "userIp", valid_580045
  var valid_580046 = query.getOrDefault("key")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "key", valid_580046
  var valid_580047 = query.getOrDefault("prettyPrint")
  valid_580047 = validateParameter(valid_580047, JBool, required = false,
                                 default = newJBool(true))
  if valid_580047 != nil:
    section.add "prettyPrint", valid_580047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580048: Call_WebmastersSitemapsGet_580036; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about a specific sitemap.
  ## 
  let valid = call_580048.validator(path, query, header, formData, body)
  let scheme = call_580048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580048.url(scheme.get, call_580048.host, call_580048.base,
                         call_580048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580048, url, valid)

proc call*(call_580049: Call_WebmastersSitemapsGet_580036; feedpath: string;
          siteUrl: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## webmastersSitemapsGet
  ## Retrieves information about a specific sitemap.
  ##   feedpath: string (required)
  ##           : The URL of the actual sitemap. For example: http://www.example.com/sitemap.xml
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   siteUrl: string (required)
  ##          : The site's URL, including protocol. For example: http://www.example.com/
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
  var path_580050 = newJObject()
  var query_580051 = newJObject()
  add(path_580050, "feedpath", newJString(feedpath))
  add(query_580051, "fields", newJString(fields))
  add(query_580051, "quotaUser", newJString(quotaUser))
  add(path_580050, "siteUrl", newJString(siteUrl))
  add(query_580051, "alt", newJString(alt))
  add(query_580051, "oauth_token", newJString(oauthToken))
  add(query_580051, "userIp", newJString(userIp))
  add(query_580051, "key", newJString(key))
  add(query_580051, "prettyPrint", newJBool(prettyPrint))
  result = call_580049.call(path_580050, query_580051, nil, nil, nil)

var webmastersSitemapsGet* = Call_WebmastersSitemapsGet_580036(
    name: "webmastersSitemapsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/sites/{siteUrl}/sitemaps/{feedpath}",
    validator: validate_WebmastersSitemapsGet_580037, base: "/webmasters/v3",
    url: url_WebmastersSitemapsGet_580038, schemes: {Scheme.Https})
type
  Call_WebmastersSitemapsDelete_580068 = ref object of OpenApiRestCall_579408
proc url_WebmastersSitemapsDelete_580070(protocol: Scheme; host: string;
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

proc validate_WebmastersSitemapsDelete_580069(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a sitemap from this site.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   feedpath: JString (required)
  ##           : The URL of the actual sitemap. For example: http://www.example.com/sitemap.xml
  ##   siteUrl: JString (required)
  ##          : The site's URL, including protocol. For example: http://www.example.com/
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `feedpath` field"
  var valid_580071 = path.getOrDefault("feedpath")
  valid_580071 = validateParameter(valid_580071, JString, required = true,
                                 default = nil)
  if valid_580071 != nil:
    section.add "feedpath", valid_580071
  var valid_580072 = path.getOrDefault("siteUrl")
  valid_580072 = validateParameter(valid_580072, JString, required = true,
                                 default = nil)
  if valid_580072 != nil:
    section.add "siteUrl", valid_580072
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580073 = query.getOrDefault("fields")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "fields", valid_580073
  var valid_580074 = query.getOrDefault("quotaUser")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "quotaUser", valid_580074
  var valid_580075 = query.getOrDefault("alt")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = newJString("json"))
  if valid_580075 != nil:
    section.add "alt", valid_580075
  var valid_580076 = query.getOrDefault("oauth_token")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "oauth_token", valid_580076
  var valid_580077 = query.getOrDefault("userIp")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "userIp", valid_580077
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580080: Call_WebmastersSitemapsDelete_580068; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a sitemap from this site.
  ## 
  let valid = call_580080.validator(path, query, header, formData, body)
  let scheme = call_580080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580080.url(scheme.get, call_580080.host, call_580080.base,
                         call_580080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580080, url, valid)

proc call*(call_580081: Call_WebmastersSitemapsDelete_580068; feedpath: string;
          siteUrl: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## webmastersSitemapsDelete
  ## Deletes a sitemap from this site.
  ##   feedpath: string (required)
  ##           : The URL of the actual sitemap. For example: http://www.example.com/sitemap.xml
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   siteUrl: string (required)
  ##          : The site's URL, including protocol. For example: http://www.example.com/
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
  var path_580082 = newJObject()
  var query_580083 = newJObject()
  add(path_580082, "feedpath", newJString(feedpath))
  add(query_580083, "fields", newJString(fields))
  add(query_580083, "quotaUser", newJString(quotaUser))
  add(path_580082, "siteUrl", newJString(siteUrl))
  add(query_580083, "alt", newJString(alt))
  add(query_580083, "oauth_token", newJString(oauthToken))
  add(query_580083, "userIp", newJString(userIp))
  add(query_580083, "key", newJString(key))
  add(query_580083, "prettyPrint", newJBool(prettyPrint))
  result = call_580081.call(path_580082, query_580083, nil, nil, nil)

var webmastersSitemapsDelete* = Call_WebmastersSitemapsDelete_580068(
    name: "webmastersSitemapsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/sites/{siteUrl}/sitemaps/{feedpath}",
    validator: validate_WebmastersSitemapsDelete_580069, base: "/webmasters/v3",
    url: url_WebmastersSitemapsDelete_580070, schemes: {Scheme.Https})
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
