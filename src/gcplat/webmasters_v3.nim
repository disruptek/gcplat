
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_WebmastersSitesList_593676 = ref object of OpenApiRestCall_593408
proc url_WebmastersSitesList_593678(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_WebmastersSitesList_593677(path: JsonNode; query: JsonNode;
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
  var valid_593790 = query.getOrDefault("fields")
  valid_593790 = validateParameter(valid_593790, JString, required = false,
                                 default = nil)
  if valid_593790 != nil:
    section.add "fields", valid_593790
  var valid_593791 = query.getOrDefault("quotaUser")
  valid_593791 = validateParameter(valid_593791, JString, required = false,
                                 default = nil)
  if valid_593791 != nil:
    section.add "quotaUser", valid_593791
  var valid_593805 = query.getOrDefault("alt")
  valid_593805 = validateParameter(valid_593805, JString, required = false,
                                 default = newJString("json"))
  if valid_593805 != nil:
    section.add "alt", valid_593805
  var valid_593806 = query.getOrDefault("oauth_token")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "oauth_token", valid_593806
  var valid_593807 = query.getOrDefault("userIp")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "userIp", valid_593807
  var valid_593808 = query.getOrDefault("key")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "key", valid_593808
  var valid_593809 = query.getOrDefault("prettyPrint")
  valid_593809 = validateParameter(valid_593809, JBool, required = false,
                                 default = newJBool(true))
  if valid_593809 != nil:
    section.add "prettyPrint", valid_593809
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593832: Call_WebmastersSitesList_593676; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the user's Search Console sites.
  ## 
  let valid = call_593832.validator(path, query, header, formData, body)
  let scheme = call_593832.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593832.url(scheme.get, call_593832.host, call_593832.base,
                         call_593832.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593832, url, valid)

proc call*(call_593903: Call_WebmastersSitesList_593676; fields: string = "";
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
  var query_593904 = newJObject()
  add(query_593904, "fields", newJString(fields))
  add(query_593904, "quotaUser", newJString(quotaUser))
  add(query_593904, "alt", newJString(alt))
  add(query_593904, "oauth_token", newJString(oauthToken))
  add(query_593904, "userIp", newJString(userIp))
  add(query_593904, "key", newJString(key))
  add(query_593904, "prettyPrint", newJBool(prettyPrint))
  result = call_593903.call(nil, query_593904, nil, nil, nil)

var webmastersSitesList* = Call_WebmastersSitesList_593676(
    name: "webmastersSitesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/sites",
    validator: validate_WebmastersSitesList_593677, base: "/webmasters/v3",
    url: url_WebmastersSitesList_593678, schemes: {Scheme.Https})
type
  Call_WebmastersSitesAdd_593973 = ref object of OpenApiRestCall_593408
proc url_WebmastersSitesAdd_593975(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "siteUrl" in path, "`siteUrl` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sites/"),
               (kind: VariableSegment, value: "siteUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebmastersSitesAdd_593974(path: JsonNode; query: JsonNode;
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
  var valid_593976 = path.getOrDefault("siteUrl")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "siteUrl", valid_593976
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
  var valid_593977 = query.getOrDefault("fields")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "fields", valid_593977
  var valid_593978 = query.getOrDefault("quotaUser")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = nil)
  if valid_593978 != nil:
    section.add "quotaUser", valid_593978
  var valid_593979 = query.getOrDefault("alt")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = newJString("json"))
  if valid_593979 != nil:
    section.add "alt", valid_593979
  var valid_593980 = query.getOrDefault("oauth_token")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = nil)
  if valid_593980 != nil:
    section.add "oauth_token", valid_593980
  var valid_593981 = query.getOrDefault("userIp")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = nil)
  if valid_593981 != nil:
    section.add "userIp", valid_593981
  var valid_593982 = query.getOrDefault("key")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "key", valid_593982
  var valid_593983 = query.getOrDefault("prettyPrint")
  valid_593983 = validateParameter(valid_593983, JBool, required = false,
                                 default = newJBool(true))
  if valid_593983 != nil:
    section.add "prettyPrint", valid_593983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593984: Call_WebmastersSitesAdd_593973; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a site to the set of the user's sites in Search Console.
  ## 
  let valid = call_593984.validator(path, query, header, formData, body)
  let scheme = call_593984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593984.url(scheme.get, call_593984.host, call_593984.base,
                         call_593984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593984, url, valid)

proc call*(call_593985: Call_WebmastersSitesAdd_593973; siteUrl: string;
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
  var path_593986 = newJObject()
  var query_593987 = newJObject()
  add(query_593987, "fields", newJString(fields))
  add(query_593987, "quotaUser", newJString(quotaUser))
  add(path_593986, "siteUrl", newJString(siteUrl))
  add(query_593987, "alt", newJString(alt))
  add(query_593987, "oauth_token", newJString(oauthToken))
  add(query_593987, "userIp", newJString(userIp))
  add(query_593987, "key", newJString(key))
  add(query_593987, "prettyPrint", newJBool(prettyPrint))
  result = call_593985.call(path_593986, query_593987, nil, nil, nil)

var webmastersSitesAdd* = Call_WebmastersSitesAdd_593973(
    name: "webmastersSitesAdd", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/sites/{siteUrl}",
    validator: validate_WebmastersSitesAdd_593974, base: "/webmasters/v3",
    url: url_WebmastersSitesAdd_593975, schemes: {Scheme.Https})
type
  Call_WebmastersSitesGet_593944 = ref object of OpenApiRestCall_593408
proc url_WebmastersSitesGet_593946(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "siteUrl" in path, "`siteUrl` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sites/"),
               (kind: VariableSegment, value: "siteUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebmastersSitesGet_593945(path: JsonNode; query: JsonNode;
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
  var valid_593961 = path.getOrDefault("siteUrl")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "siteUrl", valid_593961
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
  var valid_593962 = query.getOrDefault("fields")
  valid_593962 = validateParameter(valid_593962, JString, required = false,
                                 default = nil)
  if valid_593962 != nil:
    section.add "fields", valid_593962
  var valid_593963 = query.getOrDefault("quotaUser")
  valid_593963 = validateParameter(valid_593963, JString, required = false,
                                 default = nil)
  if valid_593963 != nil:
    section.add "quotaUser", valid_593963
  var valid_593964 = query.getOrDefault("alt")
  valid_593964 = validateParameter(valid_593964, JString, required = false,
                                 default = newJString("json"))
  if valid_593964 != nil:
    section.add "alt", valid_593964
  var valid_593965 = query.getOrDefault("oauth_token")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = nil)
  if valid_593965 != nil:
    section.add "oauth_token", valid_593965
  var valid_593966 = query.getOrDefault("userIp")
  valid_593966 = validateParameter(valid_593966, JString, required = false,
                                 default = nil)
  if valid_593966 != nil:
    section.add "userIp", valid_593966
  var valid_593967 = query.getOrDefault("key")
  valid_593967 = validateParameter(valid_593967, JString, required = false,
                                 default = nil)
  if valid_593967 != nil:
    section.add "key", valid_593967
  var valid_593968 = query.getOrDefault("prettyPrint")
  valid_593968 = validateParameter(valid_593968, JBool, required = false,
                                 default = newJBool(true))
  if valid_593968 != nil:
    section.add "prettyPrint", valid_593968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593969: Call_WebmastersSitesGet_593944; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about specific site.
  ## 
  let valid = call_593969.validator(path, query, header, formData, body)
  let scheme = call_593969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593969.url(scheme.get, call_593969.host, call_593969.base,
                         call_593969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593969, url, valid)

proc call*(call_593970: Call_WebmastersSitesGet_593944; siteUrl: string;
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
  var path_593971 = newJObject()
  var query_593972 = newJObject()
  add(query_593972, "fields", newJString(fields))
  add(query_593972, "quotaUser", newJString(quotaUser))
  add(path_593971, "siteUrl", newJString(siteUrl))
  add(query_593972, "alt", newJString(alt))
  add(query_593972, "oauth_token", newJString(oauthToken))
  add(query_593972, "userIp", newJString(userIp))
  add(query_593972, "key", newJString(key))
  add(query_593972, "prettyPrint", newJBool(prettyPrint))
  result = call_593970.call(path_593971, query_593972, nil, nil, nil)

var webmastersSitesGet* = Call_WebmastersSitesGet_593944(
    name: "webmastersSitesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/sites/{siteUrl}",
    validator: validate_WebmastersSitesGet_593945, base: "/webmasters/v3",
    url: url_WebmastersSitesGet_593946, schemes: {Scheme.Https})
type
  Call_WebmastersSitesDelete_593988 = ref object of OpenApiRestCall_593408
proc url_WebmastersSitesDelete_593990(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "siteUrl" in path, "`siteUrl` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sites/"),
               (kind: VariableSegment, value: "siteUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebmastersSitesDelete_593989(path: JsonNode; query: JsonNode;
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
  var valid_593991 = path.getOrDefault("siteUrl")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "siteUrl", valid_593991
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
  var valid_593992 = query.getOrDefault("fields")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "fields", valid_593992
  var valid_593993 = query.getOrDefault("quotaUser")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "quotaUser", valid_593993
  var valid_593994 = query.getOrDefault("alt")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = newJString("json"))
  if valid_593994 != nil:
    section.add "alt", valid_593994
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
  if body != nil:
    result.add "body", body

proc call*(call_593999: Call_WebmastersSitesDelete_593988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a site from the set of the user's Search Console sites.
  ## 
  let valid = call_593999.validator(path, query, header, formData, body)
  let scheme = call_593999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593999.url(scheme.get, call_593999.host, call_593999.base,
                         call_593999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593999, url, valid)

proc call*(call_594000: Call_WebmastersSitesDelete_593988; siteUrl: string;
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
  var path_594001 = newJObject()
  var query_594002 = newJObject()
  add(query_594002, "fields", newJString(fields))
  add(query_594002, "quotaUser", newJString(quotaUser))
  add(path_594001, "siteUrl", newJString(siteUrl))
  add(query_594002, "alt", newJString(alt))
  add(query_594002, "oauth_token", newJString(oauthToken))
  add(query_594002, "userIp", newJString(userIp))
  add(query_594002, "key", newJString(key))
  add(query_594002, "prettyPrint", newJBool(prettyPrint))
  result = call_594000.call(path_594001, query_594002, nil, nil, nil)

var webmastersSitesDelete* = Call_WebmastersSitesDelete_593988(
    name: "webmastersSitesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/sites/{siteUrl}",
    validator: validate_WebmastersSitesDelete_593989, base: "/webmasters/v3",
    url: url_WebmastersSitesDelete_593990, schemes: {Scheme.Https})
type
  Call_WebmastersSearchanalyticsQuery_594003 = ref object of OpenApiRestCall_593408
proc url_WebmastersSearchanalyticsQuery_594005(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_WebmastersSearchanalyticsQuery_594004(path: JsonNode;
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
  var valid_594006 = path.getOrDefault("siteUrl")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "siteUrl", valid_594006
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
  var valid_594010 = query.getOrDefault("oauth_token")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "oauth_token", valid_594010
  var valid_594011 = query.getOrDefault("userIp")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "userIp", valid_594011
  var valid_594012 = query.getOrDefault("key")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "key", valid_594012
  var valid_594013 = query.getOrDefault("prettyPrint")
  valid_594013 = validateParameter(valid_594013, JBool, required = false,
                                 default = newJBool(true))
  if valid_594013 != nil:
    section.add "prettyPrint", valid_594013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594015: Call_WebmastersSearchanalyticsQuery_594003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query your data with filters and parameters that you define. Returns zero or more rows grouped by the row keys that you define. You must define a date range of one or more days.
  ## 
  ## When date is one of the group by values, any days without data are omitted from the result list. If you need to know which days have data, issue a broad date range query grouped by date for any metric, and see which day rows are returned.
  ## 
  let valid = call_594015.validator(path, query, header, formData, body)
  let scheme = call_594015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594015.url(scheme.get, call_594015.host, call_594015.base,
                         call_594015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594015, url, valid)

proc call*(call_594016: Call_WebmastersSearchanalyticsQuery_594003;
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
  var path_594017 = newJObject()
  var query_594018 = newJObject()
  var body_594019 = newJObject()
  add(query_594018, "fields", newJString(fields))
  add(query_594018, "quotaUser", newJString(quotaUser))
  add(path_594017, "siteUrl", newJString(siteUrl))
  add(query_594018, "alt", newJString(alt))
  add(query_594018, "oauth_token", newJString(oauthToken))
  add(query_594018, "userIp", newJString(userIp))
  add(query_594018, "key", newJString(key))
  if body != nil:
    body_594019 = body
  add(query_594018, "prettyPrint", newJBool(prettyPrint))
  result = call_594016.call(path_594017, query_594018, nil, nil, body_594019)

var webmastersSearchanalyticsQuery* = Call_WebmastersSearchanalyticsQuery_594003(
    name: "webmastersSearchanalyticsQuery", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/sites/{siteUrl}/searchAnalytics/query",
    validator: validate_WebmastersSearchanalyticsQuery_594004,
    base: "/webmasters/v3", url: url_WebmastersSearchanalyticsQuery_594005,
    schemes: {Scheme.Https})
type
  Call_WebmastersSitemapsList_594020 = ref object of OpenApiRestCall_593408
proc url_WebmastersSitemapsList_594022(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_WebmastersSitemapsList_594021(path: JsonNode; query: JsonNode;
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
  var valid_594023 = path.getOrDefault("siteUrl")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "siteUrl", valid_594023
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
  var valid_594024 = query.getOrDefault("fields")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "fields", valid_594024
  var valid_594025 = query.getOrDefault("quotaUser")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "quotaUser", valid_594025
  var valid_594026 = query.getOrDefault("alt")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = newJString("json"))
  if valid_594026 != nil:
    section.add "alt", valid_594026
  var valid_594027 = query.getOrDefault("sitemapIndex")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "sitemapIndex", valid_594027
  var valid_594028 = query.getOrDefault("oauth_token")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "oauth_token", valid_594028
  var valid_594029 = query.getOrDefault("userIp")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "userIp", valid_594029
  var valid_594030 = query.getOrDefault("key")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "key", valid_594030
  var valid_594031 = query.getOrDefault("prettyPrint")
  valid_594031 = validateParameter(valid_594031, JBool, required = false,
                                 default = newJBool(true))
  if valid_594031 != nil:
    section.add "prettyPrint", valid_594031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594032: Call_WebmastersSitemapsList_594020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the sitemaps-entries submitted for this site, or included in the sitemap index file (if sitemapIndex is specified in the request).
  ## 
  let valid = call_594032.validator(path, query, header, formData, body)
  let scheme = call_594032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594032.url(scheme.get, call_594032.host, call_594032.base,
                         call_594032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594032, url, valid)

proc call*(call_594033: Call_WebmastersSitemapsList_594020; siteUrl: string;
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
  var path_594034 = newJObject()
  var query_594035 = newJObject()
  add(query_594035, "fields", newJString(fields))
  add(query_594035, "quotaUser", newJString(quotaUser))
  add(path_594034, "siteUrl", newJString(siteUrl))
  add(query_594035, "alt", newJString(alt))
  add(query_594035, "sitemapIndex", newJString(sitemapIndex))
  add(query_594035, "oauth_token", newJString(oauthToken))
  add(query_594035, "userIp", newJString(userIp))
  add(query_594035, "key", newJString(key))
  add(query_594035, "prettyPrint", newJBool(prettyPrint))
  result = call_594033.call(path_594034, query_594035, nil, nil, nil)

var webmastersSitemapsList* = Call_WebmastersSitemapsList_594020(
    name: "webmastersSitemapsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/sites/{siteUrl}/sitemaps",
    validator: validate_WebmastersSitemapsList_594021, base: "/webmasters/v3",
    url: url_WebmastersSitemapsList_594022, schemes: {Scheme.Https})
type
  Call_WebmastersSitemapsSubmit_594052 = ref object of OpenApiRestCall_593408
proc url_WebmastersSitemapsSubmit_594054(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_WebmastersSitemapsSubmit_594053(path: JsonNode; query: JsonNode;
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
  var valid_594055 = path.getOrDefault("feedpath")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "feedpath", valid_594055
  var valid_594056 = path.getOrDefault("siteUrl")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "siteUrl", valid_594056
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
  var valid_594057 = query.getOrDefault("fields")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "fields", valid_594057
  var valid_594058 = query.getOrDefault("quotaUser")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "quotaUser", valid_594058
  var valid_594059 = query.getOrDefault("alt")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = newJString("json"))
  if valid_594059 != nil:
    section.add "alt", valid_594059
  var valid_594060 = query.getOrDefault("oauth_token")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "oauth_token", valid_594060
  var valid_594061 = query.getOrDefault("userIp")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "userIp", valid_594061
  var valid_594062 = query.getOrDefault("key")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "key", valid_594062
  var valid_594063 = query.getOrDefault("prettyPrint")
  valid_594063 = validateParameter(valid_594063, JBool, required = false,
                                 default = newJBool(true))
  if valid_594063 != nil:
    section.add "prettyPrint", valid_594063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594064: Call_WebmastersSitemapsSubmit_594052; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a sitemap for a site.
  ## 
  let valid = call_594064.validator(path, query, header, formData, body)
  let scheme = call_594064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594064.url(scheme.get, call_594064.host, call_594064.base,
                         call_594064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594064, url, valid)

proc call*(call_594065: Call_WebmastersSitemapsSubmit_594052; feedpath: string;
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
  var path_594066 = newJObject()
  var query_594067 = newJObject()
  add(path_594066, "feedpath", newJString(feedpath))
  add(query_594067, "fields", newJString(fields))
  add(query_594067, "quotaUser", newJString(quotaUser))
  add(path_594066, "siteUrl", newJString(siteUrl))
  add(query_594067, "alt", newJString(alt))
  add(query_594067, "oauth_token", newJString(oauthToken))
  add(query_594067, "userIp", newJString(userIp))
  add(query_594067, "key", newJString(key))
  add(query_594067, "prettyPrint", newJBool(prettyPrint))
  result = call_594065.call(path_594066, query_594067, nil, nil, nil)

var webmastersSitemapsSubmit* = Call_WebmastersSitemapsSubmit_594052(
    name: "webmastersSitemapsSubmit", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/sites/{siteUrl}/sitemaps/{feedpath}",
    validator: validate_WebmastersSitemapsSubmit_594053, base: "/webmasters/v3",
    url: url_WebmastersSitemapsSubmit_594054, schemes: {Scheme.Https})
type
  Call_WebmastersSitemapsGet_594036 = ref object of OpenApiRestCall_593408
proc url_WebmastersSitemapsGet_594038(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_WebmastersSitemapsGet_594037(path: JsonNode; query: JsonNode;
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
  var valid_594039 = path.getOrDefault("feedpath")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "feedpath", valid_594039
  var valid_594040 = path.getOrDefault("siteUrl")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "siteUrl", valid_594040
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
  var valid_594041 = query.getOrDefault("fields")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "fields", valid_594041
  var valid_594042 = query.getOrDefault("quotaUser")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "quotaUser", valid_594042
  var valid_594043 = query.getOrDefault("alt")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = newJString("json"))
  if valid_594043 != nil:
    section.add "alt", valid_594043
  var valid_594044 = query.getOrDefault("oauth_token")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "oauth_token", valid_594044
  var valid_594045 = query.getOrDefault("userIp")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "userIp", valid_594045
  var valid_594046 = query.getOrDefault("key")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "key", valid_594046
  var valid_594047 = query.getOrDefault("prettyPrint")
  valid_594047 = validateParameter(valid_594047, JBool, required = false,
                                 default = newJBool(true))
  if valid_594047 != nil:
    section.add "prettyPrint", valid_594047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594048: Call_WebmastersSitemapsGet_594036; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about a specific sitemap.
  ## 
  let valid = call_594048.validator(path, query, header, formData, body)
  let scheme = call_594048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594048.url(scheme.get, call_594048.host, call_594048.base,
                         call_594048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594048, url, valid)

proc call*(call_594049: Call_WebmastersSitemapsGet_594036; feedpath: string;
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
  var path_594050 = newJObject()
  var query_594051 = newJObject()
  add(path_594050, "feedpath", newJString(feedpath))
  add(query_594051, "fields", newJString(fields))
  add(query_594051, "quotaUser", newJString(quotaUser))
  add(path_594050, "siteUrl", newJString(siteUrl))
  add(query_594051, "alt", newJString(alt))
  add(query_594051, "oauth_token", newJString(oauthToken))
  add(query_594051, "userIp", newJString(userIp))
  add(query_594051, "key", newJString(key))
  add(query_594051, "prettyPrint", newJBool(prettyPrint))
  result = call_594049.call(path_594050, query_594051, nil, nil, nil)

var webmastersSitemapsGet* = Call_WebmastersSitemapsGet_594036(
    name: "webmastersSitemapsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/sites/{siteUrl}/sitemaps/{feedpath}",
    validator: validate_WebmastersSitemapsGet_594037, base: "/webmasters/v3",
    url: url_WebmastersSitemapsGet_594038, schemes: {Scheme.Https})
type
  Call_WebmastersSitemapsDelete_594068 = ref object of OpenApiRestCall_593408
proc url_WebmastersSitemapsDelete_594070(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_WebmastersSitemapsDelete_594069(path: JsonNode; query: JsonNode;
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
  var valid_594071 = path.getOrDefault("feedpath")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "feedpath", valid_594071
  var valid_594072 = path.getOrDefault("siteUrl")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "siteUrl", valid_594072
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
  var valid_594073 = query.getOrDefault("fields")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "fields", valid_594073
  var valid_594074 = query.getOrDefault("quotaUser")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "quotaUser", valid_594074
  var valid_594075 = query.getOrDefault("alt")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = newJString("json"))
  if valid_594075 != nil:
    section.add "alt", valid_594075
  var valid_594076 = query.getOrDefault("oauth_token")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "oauth_token", valid_594076
  var valid_594077 = query.getOrDefault("userIp")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "userIp", valid_594077
  var valid_594078 = query.getOrDefault("key")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "key", valid_594078
  var valid_594079 = query.getOrDefault("prettyPrint")
  valid_594079 = validateParameter(valid_594079, JBool, required = false,
                                 default = newJBool(true))
  if valid_594079 != nil:
    section.add "prettyPrint", valid_594079
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594080: Call_WebmastersSitemapsDelete_594068; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a sitemap from this site.
  ## 
  let valid = call_594080.validator(path, query, header, formData, body)
  let scheme = call_594080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594080.url(scheme.get, call_594080.host, call_594080.base,
                         call_594080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594080, url, valid)

proc call*(call_594081: Call_WebmastersSitemapsDelete_594068; feedpath: string;
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
  var path_594082 = newJObject()
  var query_594083 = newJObject()
  add(path_594082, "feedpath", newJString(feedpath))
  add(query_594083, "fields", newJString(fields))
  add(query_594083, "quotaUser", newJString(quotaUser))
  add(path_594082, "siteUrl", newJString(siteUrl))
  add(query_594083, "alt", newJString(alt))
  add(query_594083, "oauth_token", newJString(oauthToken))
  add(query_594083, "userIp", newJString(userIp))
  add(query_594083, "key", newJString(key))
  add(query_594083, "prettyPrint", newJBool(prettyPrint))
  result = call_594081.call(path_594082, query_594083, nil, nil, nil)

var webmastersSitemapsDelete* = Call_WebmastersSitemapsDelete_594068(
    name: "webmastersSitemapsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/sites/{siteUrl}/sitemaps/{feedpath}",
    validator: validate_WebmastersSitemapsDelete_594069, base: "/webmasters/v3",
    url: url_WebmastersSitemapsDelete_594070, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
