
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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
  gcpServiceName = "webmasters"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_WebmastersSitesList_588709 = ref object of OpenApiRestCall_588441
proc url_WebmastersSitesList_588711(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_WebmastersSitesList_588710(path: JsonNode; query: JsonNode;
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
  var valid_588823 = query.getOrDefault("fields")
  valid_588823 = validateParameter(valid_588823, JString, required = false,
                                 default = nil)
  if valid_588823 != nil:
    section.add "fields", valid_588823
  var valid_588824 = query.getOrDefault("quotaUser")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "quotaUser", valid_588824
  var valid_588838 = query.getOrDefault("alt")
  valid_588838 = validateParameter(valid_588838, JString, required = false,
                                 default = newJString("json"))
  if valid_588838 != nil:
    section.add "alt", valid_588838
  var valid_588839 = query.getOrDefault("oauth_token")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "oauth_token", valid_588839
  var valid_588840 = query.getOrDefault("userIp")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "userIp", valid_588840
  var valid_588841 = query.getOrDefault("key")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "key", valid_588841
  var valid_588842 = query.getOrDefault("prettyPrint")
  valid_588842 = validateParameter(valid_588842, JBool, required = false,
                                 default = newJBool(true))
  if valid_588842 != nil:
    section.add "prettyPrint", valid_588842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588865: Call_WebmastersSitesList_588709; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the user's Search Console sites.
  ## 
  let valid = call_588865.validator(path, query, header, formData, body)
  let scheme = call_588865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588865.url(scheme.get, call_588865.host, call_588865.base,
                         call_588865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588865, url, valid)

proc call*(call_588936: Call_WebmastersSitesList_588709; fields: string = "";
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
  var query_588937 = newJObject()
  add(query_588937, "fields", newJString(fields))
  add(query_588937, "quotaUser", newJString(quotaUser))
  add(query_588937, "alt", newJString(alt))
  add(query_588937, "oauth_token", newJString(oauthToken))
  add(query_588937, "userIp", newJString(userIp))
  add(query_588937, "key", newJString(key))
  add(query_588937, "prettyPrint", newJBool(prettyPrint))
  result = call_588936.call(nil, query_588937, nil, nil, nil)

var webmastersSitesList* = Call_WebmastersSitesList_588709(
    name: "webmastersSitesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/sites",
    validator: validate_WebmastersSitesList_588710, base: "/webmasters/v3",
    url: url_WebmastersSitesList_588711, schemes: {Scheme.Https})
type
  Call_WebmastersSitesAdd_589006 = ref object of OpenApiRestCall_588441
proc url_WebmastersSitesAdd_589008(protocol: Scheme; host: string; base: string;
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

proc validate_WebmastersSitesAdd_589007(path: JsonNode; query: JsonNode;
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
  var valid_589009 = path.getOrDefault("siteUrl")
  valid_589009 = validateParameter(valid_589009, JString, required = true,
                                 default = nil)
  if valid_589009 != nil:
    section.add "siteUrl", valid_589009
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
  var valid_589010 = query.getOrDefault("fields")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "fields", valid_589010
  var valid_589011 = query.getOrDefault("quotaUser")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "quotaUser", valid_589011
  var valid_589012 = query.getOrDefault("alt")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = newJString("json"))
  if valid_589012 != nil:
    section.add "alt", valid_589012
  var valid_589013 = query.getOrDefault("oauth_token")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "oauth_token", valid_589013
  var valid_589014 = query.getOrDefault("userIp")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "userIp", valid_589014
  var valid_589015 = query.getOrDefault("key")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "key", valid_589015
  var valid_589016 = query.getOrDefault("prettyPrint")
  valid_589016 = validateParameter(valid_589016, JBool, required = false,
                                 default = newJBool(true))
  if valid_589016 != nil:
    section.add "prettyPrint", valid_589016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589017: Call_WebmastersSitesAdd_589006; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a site to the set of the user's sites in Search Console.
  ## 
  let valid = call_589017.validator(path, query, header, formData, body)
  let scheme = call_589017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589017.url(scheme.get, call_589017.host, call_589017.base,
                         call_589017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589017, url, valid)

proc call*(call_589018: Call_WebmastersSitesAdd_589006; siteUrl: string;
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
  var path_589019 = newJObject()
  var query_589020 = newJObject()
  add(query_589020, "fields", newJString(fields))
  add(query_589020, "quotaUser", newJString(quotaUser))
  add(path_589019, "siteUrl", newJString(siteUrl))
  add(query_589020, "alt", newJString(alt))
  add(query_589020, "oauth_token", newJString(oauthToken))
  add(query_589020, "userIp", newJString(userIp))
  add(query_589020, "key", newJString(key))
  add(query_589020, "prettyPrint", newJBool(prettyPrint))
  result = call_589018.call(path_589019, query_589020, nil, nil, nil)

var webmastersSitesAdd* = Call_WebmastersSitesAdd_589006(
    name: "webmastersSitesAdd", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/sites/{siteUrl}",
    validator: validate_WebmastersSitesAdd_589007, base: "/webmasters/v3",
    url: url_WebmastersSitesAdd_589008, schemes: {Scheme.Https})
type
  Call_WebmastersSitesGet_588977 = ref object of OpenApiRestCall_588441
proc url_WebmastersSitesGet_588979(protocol: Scheme; host: string; base: string;
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

proc validate_WebmastersSitesGet_588978(path: JsonNode; query: JsonNode;
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
  var valid_588994 = path.getOrDefault("siteUrl")
  valid_588994 = validateParameter(valid_588994, JString, required = true,
                                 default = nil)
  if valid_588994 != nil:
    section.add "siteUrl", valid_588994
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
  var valid_588995 = query.getOrDefault("fields")
  valid_588995 = validateParameter(valid_588995, JString, required = false,
                                 default = nil)
  if valid_588995 != nil:
    section.add "fields", valid_588995
  var valid_588996 = query.getOrDefault("quotaUser")
  valid_588996 = validateParameter(valid_588996, JString, required = false,
                                 default = nil)
  if valid_588996 != nil:
    section.add "quotaUser", valid_588996
  var valid_588997 = query.getOrDefault("alt")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = newJString("json"))
  if valid_588997 != nil:
    section.add "alt", valid_588997
  var valid_588998 = query.getOrDefault("oauth_token")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = nil)
  if valid_588998 != nil:
    section.add "oauth_token", valid_588998
  var valid_588999 = query.getOrDefault("userIp")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = nil)
  if valid_588999 != nil:
    section.add "userIp", valid_588999
  var valid_589000 = query.getOrDefault("key")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "key", valid_589000
  var valid_589001 = query.getOrDefault("prettyPrint")
  valid_589001 = validateParameter(valid_589001, JBool, required = false,
                                 default = newJBool(true))
  if valid_589001 != nil:
    section.add "prettyPrint", valid_589001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589002: Call_WebmastersSitesGet_588977; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about specific site.
  ## 
  let valid = call_589002.validator(path, query, header, formData, body)
  let scheme = call_589002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589002.url(scheme.get, call_589002.host, call_589002.base,
                         call_589002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589002, url, valid)

proc call*(call_589003: Call_WebmastersSitesGet_588977; siteUrl: string;
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
  var path_589004 = newJObject()
  var query_589005 = newJObject()
  add(query_589005, "fields", newJString(fields))
  add(query_589005, "quotaUser", newJString(quotaUser))
  add(path_589004, "siteUrl", newJString(siteUrl))
  add(query_589005, "alt", newJString(alt))
  add(query_589005, "oauth_token", newJString(oauthToken))
  add(query_589005, "userIp", newJString(userIp))
  add(query_589005, "key", newJString(key))
  add(query_589005, "prettyPrint", newJBool(prettyPrint))
  result = call_589003.call(path_589004, query_589005, nil, nil, nil)

var webmastersSitesGet* = Call_WebmastersSitesGet_588977(
    name: "webmastersSitesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/sites/{siteUrl}",
    validator: validate_WebmastersSitesGet_588978, base: "/webmasters/v3",
    url: url_WebmastersSitesGet_588979, schemes: {Scheme.Https})
type
  Call_WebmastersSitesDelete_589021 = ref object of OpenApiRestCall_588441
proc url_WebmastersSitesDelete_589023(protocol: Scheme; host: string; base: string;
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

proc validate_WebmastersSitesDelete_589022(path: JsonNode; query: JsonNode;
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
  var valid_589024 = path.getOrDefault("siteUrl")
  valid_589024 = validateParameter(valid_589024, JString, required = true,
                                 default = nil)
  if valid_589024 != nil:
    section.add "siteUrl", valid_589024
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
  var valid_589025 = query.getOrDefault("fields")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "fields", valid_589025
  var valid_589026 = query.getOrDefault("quotaUser")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "quotaUser", valid_589026
  var valid_589027 = query.getOrDefault("alt")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = newJString("json"))
  if valid_589027 != nil:
    section.add "alt", valid_589027
  var valid_589028 = query.getOrDefault("oauth_token")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "oauth_token", valid_589028
  var valid_589029 = query.getOrDefault("userIp")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "userIp", valid_589029
  var valid_589030 = query.getOrDefault("key")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "key", valid_589030
  var valid_589031 = query.getOrDefault("prettyPrint")
  valid_589031 = validateParameter(valid_589031, JBool, required = false,
                                 default = newJBool(true))
  if valid_589031 != nil:
    section.add "prettyPrint", valid_589031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589032: Call_WebmastersSitesDelete_589021; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a site from the set of the user's Search Console sites.
  ## 
  let valid = call_589032.validator(path, query, header, formData, body)
  let scheme = call_589032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589032.url(scheme.get, call_589032.host, call_589032.base,
                         call_589032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589032, url, valid)

proc call*(call_589033: Call_WebmastersSitesDelete_589021; siteUrl: string;
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
  var path_589034 = newJObject()
  var query_589035 = newJObject()
  add(query_589035, "fields", newJString(fields))
  add(query_589035, "quotaUser", newJString(quotaUser))
  add(path_589034, "siteUrl", newJString(siteUrl))
  add(query_589035, "alt", newJString(alt))
  add(query_589035, "oauth_token", newJString(oauthToken))
  add(query_589035, "userIp", newJString(userIp))
  add(query_589035, "key", newJString(key))
  add(query_589035, "prettyPrint", newJBool(prettyPrint))
  result = call_589033.call(path_589034, query_589035, nil, nil, nil)

var webmastersSitesDelete* = Call_WebmastersSitesDelete_589021(
    name: "webmastersSitesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/sites/{siteUrl}",
    validator: validate_WebmastersSitesDelete_589022, base: "/webmasters/v3",
    url: url_WebmastersSitesDelete_589023, schemes: {Scheme.Https})
type
  Call_WebmastersSearchanalyticsQuery_589036 = ref object of OpenApiRestCall_588441
proc url_WebmastersSearchanalyticsQuery_589038(protocol: Scheme; host: string;
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

proc validate_WebmastersSearchanalyticsQuery_589037(path: JsonNode;
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
  var valid_589039 = path.getOrDefault("siteUrl")
  valid_589039 = validateParameter(valid_589039, JString, required = true,
                                 default = nil)
  if valid_589039 != nil:
    section.add "siteUrl", valid_589039
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
  var valid_589040 = query.getOrDefault("fields")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "fields", valid_589040
  var valid_589041 = query.getOrDefault("quotaUser")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "quotaUser", valid_589041
  var valid_589042 = query.getOrDefault("alt")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = newJString("json"))
  if valid_589042 != nil:
    section.add "alt", valid_589042
  var valid_589043 = query.getOrDefault("oauth_token")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "oauth_token", valid_589043
  var valid_589044 = query.getOrDefault("userIp")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "userIp", valid_589044
  var valid_589045 = query.getOrDefault("key")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "key", valid_589045
  var valid_589046 = query.getOrDefault("prettyPrint")
  valid_589046 = validateParameter(valid_589046, JBool, required = false,
                                 default = newJBool(true))
  if valid_589046 != nil:
    section.add "prettyPrint", valid_589046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589048: Call_WebmastersSearchanalyticsQuery_589036; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query your data with filters and parameters that you define. Returns zero or more rows grouped by the row keys that you define. You must define a date range of one or more days.
  ## 
  ## When date is one of the group by values, any days without data are omitted from the result list. If you need to know which days have data, issue a broad date range query grouped by date for any metric, and see which day rows are returned.
  ## 
  let valid = call_589048.validator(path, query, header, formData, body)
  let scheme = call_589048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589048.url(scheme.get, call_589048.host, call_589048.base,
                         call_589048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589048, url, valid)

proc call*(call_589049: Call_WebmastersSearchanalyticsQuery_589036;
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
  var path_589050 = newJObject()
  var query_589051 = newJObject()
  var body_589052 = newJObject()
  add(query_589051, "fields", newJString(fields))
  add(query_589051, "quotaUser", newJString(quotaUser))
  add(path_589050, "siteUrl", newJString(siteUrl))
  add(query_589051, "alt", newJString(alt))
  add(query_589051, "oauth_token", newJString(oauthToken))
  add(query_589051, "userIp", newJString(userIp))
  add(query_589051, "key", newJString(key))
  if body != nil:
    body_589052 = body
  add(query_589051, "prettyPrint", newJBool(prettyPrint))
  result = call_589049.call(path_589050, query_589051, nil, nil, body_589052)

var webmastersSearchanalyticsQuery* = Call_WebmastersSearchanalyticsQuery_589036(
    name: "webmastersSearchanalyticsQuery", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/sites/{siteUrl}/searchAnalytics/query",
    validator: validate_WebmastersSearchanalyticsQuery_589037,
    base: "/webmasters/v3", url: url_WebmastersSearchanalyticsQuery_589038,
    schemes: {Scheme.Https})
type
  Call_WebmastersSitemapsList_589053 = ref object of OpenApiRestCall_588441
proc url_WebmastersSitemapsList_589055(protocol: Scheme; host: string; base: string;
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

proc validate_WebmastersSitemapsList_589054(path: JsonNode; query: JsonNode;
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
  var valid_589056 = path.getOrDefault("siteUrl")
  valid_589056 = validateParameter(valid_589056, JString, required = true,
                                 default = nil)
  if valid_589056 != nil:
    section.add "siteUrl", valid_589056
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
  var valid_589057 = query.getOrDefault("fields")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "fields", valid_589057
  var valid_589058 = query.getOrDefault("quotaUser")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "quotaUser", valid_589058
  var valid_589059 = query.getOrDefault("alt")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = newJString("json"))
  if valid_589059 != nil:
    section.add "alt", valid_589059
  var valid_589060 = query.getOrDefault("sitemapIndex")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "sitemapIndex", valid_589060
  var valid_589061 = query.getOrDefault("oauth_token")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "oauth_token", valid_589061
  var valid_589062 = query.getOrDefault("userIp")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "userIp", valid_589062
  var valid_589063 = query.getOrDefault("key")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "key", valid_589063
  var valid_589064 = query.getOrDefault("prettyPrint")
  valid_589064 = validateParameter(valid_589064, JBool, required = false,
                                 default = newJBool(true))
  if valid_589064 != nil:
    section.add "prettyPrint", valid_589064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589065: Call_WebmastersSitemapsList_589053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the sitemaps-entries submitted for this site, or included in the sitemap index file (if sitemapIndex is specified in the request).
  ## 
  let valid = call_589065.validator(path, query, header, formData, body)
  let scheme = call_589065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589065.url(scheme.get, call_589065.host, call_589065.base,
                         call_589065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589065, url, valid)

proc call*(call_589066: Call_WebmastersSitemapsList_589053; siteUrl: string;
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
  var path_589067 = newJObject()
  var query_589068 = newJObject()
  add(query_589068, "fields", newJString(fields))
  add(query_589068, "quotaUser", newJString(quotaUser))
  add(path_589067, "siteUrl", newJString(siteUrl))
  add(query_589068, "alt", newJString(alt))
  add(query_589068, "sitemapIndex", newJString(sitemapIndex))
  add(query_589068, "oauth_token", newJString(oauthToken))
  add(query_589068, "userIp", newJString(userIp))
  add(query_589068, "key", newJString(key))
  add(query_589068, "prettyPrint", newJBool(prettyPrint))
  result = call_589066.call(path_589067, query_589068, nil, nil, nil)

var webmastersSitemapsList* = Call_WebmastersSitemapsList_589053(
    name: "webmastersSitemapsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/sites/{siteUrl}/sitemaps",
    validator: validate_WebmastersSitemapsList_589054, base: "/webmasters/v3",
    url: url_WebmastersSitemapsList_589055, schemes: {Scheme.Https})
type
  Call_WebmastersSitemapsSubmit_589085 = ref object of OpenApiRestCall_588441
proc url_WebmastersSitemapsSubmit_589087(protocol: Scheme; host: string;
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

proc validate_WebmastersSitemapsSubmit_589086(path: JsonNode; query: JsonNode;
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
  var valid_589088 = path.getOrDefault("feedpath")
  valid_589088 = validateParameter(valid_589088, JString, required = true,
                                 default = nil)
  if valid_589088 != nil:
    section.add "feedpath", valid_589088
  var valid_589089 = path.getOrDefault("siteUrl")
  valid_589089 = validateParameter(valid_589089, JString, required = true,
                                 default = nil)
  if valid_589089 != nil:
    section.add "siteUrl", valid_589089
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
  var valid_589090 = query.getOrDefault("fields")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "fields", valid_589090
  var valid_589091 = query.getOrDefault("quotaUser")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "quotaUser", valid_589091
  var valid_589092 = query.getOrDefault("alt")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = newJString("json"))
  if valid_589092 != nil:
    section.add "alt", valid_589092
  var valid_589093 = query.getOrDefault("oauth_token")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "oauth_token", valid_589093
  var valid_589094 = query.getOrDefault("userIp")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "userIp", valid_589094
  var valid_589095 = query.getOrDefault("key")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "key", valid_589095
  var valid_589096 = query.getOrDefault("prettyPrint")
  valid_589096 = validateParameter(valid_589096, JBool, required = false,
                                 default = newJBool(true))
  if valid_589096 != nil:
    section.add "prettyPrint", valid_589096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589097: Call_WebmastersSitemapsSubmit_589085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a sitemap for a site.
  ## 
  let valid = call_589097.validator(path, query, header, formData, body)
  let scheme = call_589097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589097.url(scheme.get, call_589097.host, call_589097.base,
                         call_589097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589097, url, valid)

proc call*(call_589098: Call_WebmastersSitemapsSubmit_589085; feedpath: string;
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
  var path_589099 = newJObject()
  var query_589100 = newJObject()
  add(path_589099, "feedpath", newJString(feedpath))
  add(query_589100, "fields", newJString(fields))
  add(query_589100, "quotaUser", newJString(quotaUser))
  add(path_589099, "siteUrl", newJString(siteUrl))
  add(query_589100, "alt", newJString(alt))
  add(query_589100, "oauth_token", newJString(oauthToken))
  add(query_589100, "userIp", newJString(userIp))
  add(query_589100, "key", newJString(key))
  add(query_589100, "prettyPrint", newJBool(prettyPrint))
  result = call_589098.call(path_589099, query_589100, nil, nil, nil)

var webmastersSitemapsSubmit* = Call_WebmastersSitemapsSubmit_589085(
    name: "webmastersSitemapsSubmit", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/sites/{siteUrl}/sitemaps/{feedpath}",
    validator: validate_WebmastersSitemapsSubmit_589086, base: "/webmasters/v3",
    url: url_WebmastersSitemapsSubmit_589087, schemes: {Scheme.Https})
type
  Call_WebmastersSitemapsGet_589069 = ref object of OpenApiRestCall_588441
proc url_WebmastersSitemapsGet_589071(protocol: Scheme; host: string; base: string;
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

proc validate_WebmastersSitemapsGet_589070(path: JsonNode; query: JsonNode;
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
  var valid_589072 = path.getOrDefault("feedpath")
  valid_589072 = validateParameter(valid_589072, JString, required = true,
                                 default = nil)
  if valid_589072 != nil:
    section.add "feedpath", valid_589072
  var valid_589073 = path.getOrDefault("siteUrl")
  valid_589073 = validateParameter(valid_589073, JString, required = true,
                                 default = nil)
  if valid_589073 != nil:
    section.add "siteUrl", valid_589073
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
  var valid_589074 = query.getOrDefault("fields")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "fields", valid_589074
  var valid_589075 = query.getOrDefault("quotaUser")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "quotaUser", valid_589075
  var valid_589076 = query.getOrDefault("alt")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = newJString("json"))
  if valid_589076 != nil:
    section.add "alt", valid_589076
  var valid_589077 = query.getOrDefault("oauth_token")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "oauth_token", valid_589077
  var valid_589078 = query.getOrDefault("userIp")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "userIp", valid_589078
  var valid_589079 = query.getOrDefault("key")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "key", valid_589079
  var valid_589080 = query.getOrDefault("prettyPrint")
  valid_589080 = validateParameter(valid_589080, JBool, required = false,
                                 default = newJBool(true))
  if valid_589080 != nil:
    section.add "prettyPrint", valid_589080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589081: Call_WebmastersSitemapsGet_589069; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about a specific sitemap.
  ## 
  let valid = call_589081.validator(path, query, header, formData, body)
  let scheme = call_589081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589081.url(scheme.get, call_589081.host, call_589081.base,
                         call_589081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589081, url, valid)

proc call*(call_589082: Call_WebmastersSitemapsGet_589069; feedpath: string;
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
  var path_589083 = newJObject()
  var query_589084 = newJObject()
  add(path_589083, "feedpath", newJString(feedpath))
  add(query_589084, "fields", newJString(fields))
  add(query_589084, "quotaUser", newJString(quotaUser))
  add(path_589083, "siteUrl", newJString(siteUrl))
  add(query_589084, "alt", newJString(alt))
  add(query_589084, "oauth_token", newJString(oauthToken))
  add(query_589084, "userIp", newJString(userIp))
  add(query_589084, "key", newJString(key))
  add(query_589084, "prettyPrint", newJBool(prettyPrint))
  result = call_589082.call(path_589083, query_589084, nil, nil, nil)

var webmastersSitemapsGet* = Call_WebmastersSitemapsGet_589069(
    name: "webmastersSitemapsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/sites/{siteUrl}/sitemaps/{feedpath}",
    validator: validate_WebmastersSitemapsGet_589070, base: "/webmasters/v3",
    url: url_WebmastersSitemapsGet_589071, schemes: {Scheme.Https})
type
  Call_WebmastersSitemapsDelete_589101 = ref object of OpenApiRestCall_588441
proc url_WebmastersSitemapsDelete_589103(protocol: Scheme; host: string;
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

proc validate_WebmastersSitemapsDelete_589102(path: JsonNode; query: JsonNode;
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
  var valid_589104 = path.getOrDefault("feedpath")
  valid_589104 = validateParameter(valid_589104, JString, required = true,
                                 default = nil)
  if valid_589104 != nil:
    section.add "feedpath", valid_589104
  var valid_589105 = path.getOrDefault("siteUrl")
  valid_589105 = validateParameter(valid_589105, JString, required = true,
                                 default = nil)
  if valid_589105 != nil:
    section.add "siteUrl", valid_589105
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
  var valid_589106 = query.getOrDefault("fields")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "fields", valid_589106
  var valid_589107 = query.getOrDefault("quotaUser")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "quotaUser", valid_589107
  var valid_589108 = query.getOrDefault("alt")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = newJString("json"))
  if valid_589108 != nil:
    section.add "alt", valid_589108
  var valid_589109 = query.getOrDefault("oauth_token")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "oauth_token", valid_589109
  var valid_589110 = query.getOrDefault("userIp")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "userIp", valid_589110
  var valid_589111 = query.getOrDefault("key")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "key", valid_589111
  var valid_589112 = query.getOrDefault("prettyPrint")
  valid_589112 = validateParameter(valid_589112, JBool, required = false,
                                 default = newJBool(true))
  if valid_589112 != nil:
    section.add "prettyPrint", valid_589112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589113: Call_WebmastersSitemapsDelete_589101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a sitemap from this site.
  ## 
  let valid = call_589113.validator(path, query, header, formData, body)
  let scheme = call_589113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589113.url(scheme.get, call_589113.host, call_589113.base,
                         call_589113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589113, url, valid)

proc call*(call_589114: Call_WebmastersSitemapsDelete_589101; feedpath: string;
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
  var path_589115 = newJObject()
  var query_589116 = newJObject()
  add(path_589115, "feedpath", newJString(feedpath))
  add(query_589116, "fields", newJString(fields))
  add(query_589116, "quotaUser", newJString(quotaUser))
  add(path_589115, "siteUrl", newJString(siteUrl))
  add(query_589116, "alt", newJString(alt))
  add(query_589116, "oauth_token", newJString(oauthToken))
  add(query_589116, "userIp", newJString(userIp))
  add(query_589116, "key", newJString(key))
  add(query_589116, "prettyPrint", newJBool(prettyPrint))
  result = call_589114.call(path_589115, query_589116, nil, nil, nil)

var webmastersSitemapsDelete* = Call_WebmastersSitemapsDelete_589101(
    name: "webmastersSitemapsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/sites/{siteUrl}/sitemaps/{feedpath}",
    validator: validate_WebmastersSitemapsDelete_589102, base: "/webmasters/v3",
    url: url_WebmastersSitemapsDelete_589103, schemes: {Scheme.Https})
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
