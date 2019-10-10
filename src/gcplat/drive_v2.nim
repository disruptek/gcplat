
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Drive
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Manages files in Drive including uploading, downloading, searching, detecting changes, and updating sharing permissions.
## 
## https://developers.google.com/drive/
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

  OpenApiRestCall_588457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588457): Option[Scheme] {.used.} =
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
  gcpServiceName = "drive"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DriveAboutGet_588725 = ref object of OpenApiRestCall_588457
proc url_DriveAboutGet_588727(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveAboutGet_588726(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about the current user along with Drive API settings
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
  ##   maxChangeIdCount: JString
  ##                   : Maximum number of remaining change IDs to count
  ##   includeSubscribed: JBool
  ##                    : Whether to count changes outside the My Drive hierarchy. When set to false, changes to files such as those in the Application Data folder or shared files which have not been added to My Drive will be omitted from the maxChangeIdCount.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startChangeId: JString
  ##                : Change ID to start counting from when calculating number of remaining change IDs
  section = newJObject()
  var valid_588839 = query.getOrDefault("fields")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "fields", valid_588839
  var valid_588840 = query.getOrDefault("quotaUser")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "quotaUser", valid_588840
  var valid_588854 = query.getOrDefault("alt")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = newJString("json"))
  if valid_588854 != nil:
    section.add "alt", valid_588854
  var valid_588855 = query.getOrDefault("oauth_token")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = nil)
  if valid_588855 != nil:
    section.add "oauth_token", valid_588855
  var valid_588856 = query.getOrDefault("userIp")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "userIp", valid_588856
  var valid_588857 = query.getOrDefault("maxChangeIdCount")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = newJString("1"))
  if valid_588857 != nil:
    section.add "maxChangeIdCount", valid_588857
  var valid_588858 = query.getOrDefault("includeSubscribed")
  valid_588858 = validateParameter(valid_588858, JBool, required = false,
                                 default = newJBool(true))
  if valid_588858 != nil:
    section.add "includeSubscribed", valid_588858
  var valid_588859 = query.getOrDefault("key")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "key", valid_588859
  var valid_588860 = query.getOrDefault("prettyPrint")
  valid_588860 = validateParameter(valid_588860, JBool, required = false,
                                 default = newJBool(true))
  if valid_588860 != nil:
    section.add "prettyPrint", valid_588860
  var valid_588861 = query.getOrDefault("startChangeId")
  valid_588861 = validateParameter(valid_588861, JString, required = false,
                                 default = nil)
  if valid_588861 != nil:
    section.add "startChangeId", valid_588861
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588884: Call_DriveAboutGet_588725; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the current user along with Drive API settings
  ## 
  let valid = call_588884.validator(path, query, header, formData, body)
  let scheme = call_588884.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588884.url(scheme.get, call_588884.host, call_588884.base,
                         call_588884.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588884, url, valid)

proc call*(call_588955: Call_DriveAboutGet_588725; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxChangeIdCount: string = "1";
          includeSubscribed: bool = true; key: string = ""; prettyPrint: bool = true;
          startChangeId: string = ""): Recallable =
  ## driveAboutGet
  ## Gets the information about the current user along with Drive API settings
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
  ##   maxChangeIdCount: string
  ##                   : Maximum number of remaining change IDs to count
  ##   includeSubscribed: bool
  ##                    : Whether to count changes outside the My Drive hierarchy. When set to false, changes to files such as those in the Application Data folder or shared files which have not been added to My Drive will be omitted from the maxChangeIdCount.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startChangeId: string
  ##                : Change ID to start counting from when calculating number of remaining change IDs
  var query_588956 = newJObject()
  add(query_588956, "fields", newJString(fields))
  add(query_588956, "quotaUser", newJString(quotaUser))
  add(query_588956, "alt", newJString(alt))
  add(query_588956, "oauth_token", newJString(oauthToken))
  add(query_588956, "userIp", newJString(userIp))
  add(query_588956, "maxChangeIdCount", newJString(maxChangeIdCount))
  add(query_588956, "includeSubscribed", newJBool(includeSubscribed))
  add(query_588956, "key", newJString(key))
  add(query_588956, "prettyPrint", newJBool(prettyPrint))
  add(query_588956, "startChangeId", newJString(startChangeId))
  result = call_588955.call(nil, query_588956, nil, nil, nil)

var driveAboutGet* = Call_DriveAboutGet_588725(name: "driveAboutGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/about",
    validator: validate_DriveAboutGet_588726, base: "/drive/v2",
    url: url_DriveAboutGet_588727, schemes: {Scheme.Https})
type
  Call_DriveAppsList_588996 = ref object of OpenApiRestCall_588457
proc url_DriveAppsList_588998(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveAppsList_588997(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a user's installed apps.
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
  ##   appFilterExtensions: JString
  ##                      : A comma-separated list of file extensions for open with filtering. All apps within the given app query scope which can open any of the given file extensions will be included in the response. If appFilterMimeTypes are provided as well, the result is a union of the two resulting app lists.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appFilterMimeTypes: JString
  ##                     : A comma-separated list of MIME types for open with filtering. All apps within the given app query scope which can open any of the given MIME types will be included in the response. If appFilterExtensions are provided as well, the result is a union of the two resulting app lists.
  ##   languageCode: JString
  ##               : A language or locale code, as defined by BCP 47, with some extensions from Unicode's LDML format (http://www.unicode.org/reports/tr35/).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588999 = query.getOrDefault("fields")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = nil)
  if valid_588999 != nil:
    section.add "fields", valid_588999
  var valid_589000 = query.getOrDefault("quotaUser")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "quotaUser", valid_589000
  var valid_589001 = query.getOrDefault("alt")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = newJString("json"))
  if valid_589001 != nil:
    section.add "alt", valid_589001
  var valid_589002 = query.getOrDefault("appFilterExtensions")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = newJString(""))
  if valid_589002 != nil:
    section.add "appFilterExtensions", valid_589002
  var valid_589003 = query.getOrDefault("oauth_token")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "oauth_token", valid_589003
  var valid_589004 = query.getOrDefault("userIp")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "userIp", valid_589004
  var valid_589005 = query.getOrDefault("key")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "key", valid_589005
  var valid_589006 = query.getOrDefault("appFilterMimeTypes")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = newJString(""))
  if valid_589006 != nil:
    section.add "appFilterMimeTypes", valid_589006
  var valid_589007 = query.getOrDefault("languageCode")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "languageCode", valid_589007
  var valid_589008 = query.getOrDefault("prettyPrint")
  valid_589008 = validateParameter(valid_589008, JBool, required = false,
                                 default = newJBool(true))
  if valid_589008 != nil:
    section.add "prettyPrint", valid_589008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589009: Call_DriveAppsList_588996; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a user's installed apps.
  ## 
  let valid = call_589009.validator(path, query, header, formData, body)
  let scheme = call_589009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589009.url(scheme.get, call_589009.host, call_589009.base,
                         call_589009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589009, url, valid)

proc call*(call_589010: Call_DriveAppsList_588996; fields: string = "";
          quotaUser: string = ""; alt: string = "json";
          appFilterExtensions: string = ""; oauthToken: string = "";
          userIp: string = ""; key: string = ""; appFilterMimeTypes: string = "";
          languageCode: string = ""; prettyPrint: bool = true): Recallable =
  ## driveAppsList
  ## Lists a user's installed apps.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   appFilterExtensions: string
  ##                      : A comma-separated list of file extensions for open with filtering. All apps within the given app query scope which can open any of the given file extensions will be included in the response. If appFilterMimeTypes are provided as well, the result is a union of the two resulting app lists.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appFilterMimeTypes: string
  ##                     : A comma-separated list of MIME types for open with filtering. All apps within the given app query scope which can open any of the given MIME types will be included in the response. If appFilterExtensions are provided as well, the result is a union of the two resulting app lists.
  ##   languageCode: string
  ##               : A language or locale code, as defined by BCP 47, with some extensions from Unicode's LDML format (http://www.unicode.org/reports/tr35/).
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589011 = newJObject()
  add(query_589011, "fields", newJString(fields))
  add(query_589011, "quotaUser", newJString(quotaUser))
  add(query_589011, "alt", newJString(alt))
  add(query_589011, "appFilterExtensions", newJString(appFilterExtensions))
  add(query_589011, "oauth_token", newJString(oauthToken))
  add(query_589011, "userIp", newJString(userIp))
  add(query_589011, "key", newJString(key))
  add(query_589011, "appFilterMimeTypes", newJString(appFilterMimeTypes))
  add(query_589011, "languageCode", newJString(languageCode))
  add(query_589011, "prettyPrint", newJBool(prettyPrint))
  result = call_589010.call(nil, query_589011, nil, nil, nil)

var driveAppsList* = Call_DriveAppsList_588996(name: "driveAppsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/apps",
    validator: validate_DriveAppsList_588997, base: "/drive/v2",
    url: url_DriveAppsList_588998, schemes: {Scheme.Https})
type
  Call_DriveAppsGet_589012 = ref object of OpenApiRestCall_588457
proc url_DriveAppsGet_589014(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveAppsGet_589013(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a specific app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The ID of the app.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_589029 = path.getOrDefault("appId")
  valid_589029 = validateParameter(valid_589029, JString, required = true,
                                 default = nil)
  if valid_589029 != nil:
    section.add "appId", valid_589029
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
  var valid_589030 = query.getOrDefault("fields")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "fields", valid_589030
  var valid_589031 = query.getOrDefault("quotaUser")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "quotaUser", valid_589031
  var valid_589032 = query.getOrDefault("alt")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = newJString("json"))
  if valid_589032 != nil:
    section.add "alt", valid_589032
  var valid_589033 = query.getOrDefault("oauth_token")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "oauth_token", valid_589033
  var valid_589034 = query.getOrDefault("userIp")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "userIp", valid_589034
  var valid_589035 = query.getOrDefault("key")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "key", valid_589035
  var valid_589036 = query.getOrDefault("prettyPrint")
  valid_589036 = validateParameter(valid_589036, JBool, required = false,
                                 default = newJBool(true))
  if valid_589036 != nil:
    section.add "prettyPrint", valid_589036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589037: Call_DriveAppsGet_589012; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific app.
  ## 
  let valid = call_589037.validator(path, query, header, formData, body)
  let scheme = call_589037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589037.url(scheme.get, call_589037.host, call_589037.base,
                         call_589037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589037, url, valid)

proc call*(call_589038: Call_DriveAppsGet_589012; appId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveAppsGet
  ## Gets a specific app.
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
  ##   appId: string (required)
  ##        : The ID of the app.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589039 = newJObject()
  var query_589040 = newJObject()
  add(query_589040, "fields", newJString(fields))
  add(query_589040, "quotaUser", newJString(quotaUser))
  add(query_589040, "alt", newJString(alt))
  add(query_589040, "oauth_token", newJString(oauthToken))
  add(query_589040, "userIp", newJString(userIp))
  add(path_589039, "appId", newJString(appId))
  add(query_589040, "key", newJString(key))
  add(query_589040, "prettyPrint", newJBool(prettyPrint))
  result = call_589038.call(path_589039, query_589040, nil, nil, nil)

var driveAppsGet* = Call_DriveAppsGet_589012(name: "driveAppsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/apps/{appId}",
    validator: validate_DriveAppsGet_589013, base: "/drive/v2",
    url: url_DriveAppsGet_589014, schemes: {Scheme.Https})
type
  Call_DriveChangesList_589041 = ref object of OpenApiRestCall_588457
proc url_DriveChangesList_589043(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveChangesList_589042(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists the changes for a user or shared drive.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   driveId: JString
  ##          : The shared drive from which changes will be returned. If specified the change IDs will be reflective of the shared drive; use the combined drive ID and change ID as an identifier.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response or to the response from the getStartPageToken method.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   includeItemsFromAllDrives: JBool
  ##                            : Deprecated - Whether both My Drive and shared drive items should be included in results. This parameter will only be effective until June 1, 2020. Afterwards shared drive items will be included in the results.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   includeTeamDriveItems: JBool
  ##                        : Deprecated use includeItemsFromAllDrives instead.
  ##   teamDriveId: JString
  ##              : Deprecated use driveId instead.
  ##   includeSubscribed: JBool
  ##                    : Whether to include changes outside the My Drive hierarchy in the result. When set to false, changes to files such as those in the Application Data folder or shared files which have not been added to My Drive will be omitted from the result.
  ##   maxResults: JInt
  ##             : Maximum number of changes to return.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeDeleted: JBool
  ##                 : Whether to include changes indicating that items have been removed from the list of changes, for example by deletion or loss of access.
  ##   spaces: JString
  ##         : A comma-separated list of spaces to query. Supported values are 'drive', 'appDataFolder' and 'photos'.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startChangeId: JString
  ##                : Deprecated - use pageToken instead.
  ##   includeCorpusRemovals: JBool
  ##                        : Whether changes should include the file resource if the file is still accessible by the user at the time of the request, even when a file was removed from the list of changes and there will be no further change entries for this file.
  section = newJObject()
  var valid_589044 = query.getOrDefault("driveId")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "driveId", valid_589044
  var valid_589045 = query.getOrDefault("supportsAllDrives")
  valid_589045 = validateParameter(valid_589045, JBool, required = false,
                                 default = newJBool(false))
  if valid_589045 != nil:
    section.add "supportsAllDrives", valid_589045
  var valid_589046 = query.getOrDefault("fields")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "fields", valid_589046
  var valid_589047 = query.getOrDefault("pageToken")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "pageToken", valid_589047
  var valid_589048 = query.getOrDefault("quotaUser")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "quotaUser", valid_589048
  var valid_589049 = query.getOrDefault("alt")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = newJString("json"))
  if valid_589049 != nil:
    section.add "alt", valid_589049
  var valid_589050 = query.getOrDefault("oauth_token")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "oauth_token", valid_589050
  var valid_589051 = query.getOrDefault("includeItemsFromAllDrives")
  valid_589051 = validateParameter(valid_589051, JBool, required = false,
                                 default = newJBool(false))
  if valid_589051 != nil:
    section.add "includeItemsFromAllDrives", valid_589051
  var valid_589052 = query.getOrDefault("userIp")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "userIp", valid_589052
  var valid_589053 = query.getOrDefault("includeTeamDriveItems")
  valid_589053 = validateParameter(valid_589053, JBool, required = false,
                                 default = newJBool(false))
  if valid_589053 != nil:
    section.add "includeTeamDriveItems", valid_589053
  var valid_589054 = query.getOrDefault("teamDriveId")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "teamDriveId", valid_589054
  var valid_589055 = query.getOrDefault("includeSubscribed")
  valid_589055 = validateParameter(valid_589055, JBool, required = false,
                                 default = newJBool(true))
  if valid_589055 != nil:
    section.add "includeSubscribed", valid_589055
  var valid_589057 = query.getOrDefault("maxResults")
  valid_589057 = validateParameter(valid_589057, JInt, required = false,
                                 default = newJInt(100))
  if valid_589057 != nil:
    section.add "maxResults", valid_589057
  var valid_589058 = query.getOrDefault("supportsTeamDrives")
  valid_589058 = validateParameter(valid_589058, JBool, required = false,
                                 default = newJBool(false))
  if valid_589058 != nil:
    section.add "supportsTeamDrives", valid_589058
  var valid_589059 = query.getOrDefault("key")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "key", valid_589059
  var valid_589060 = query.getOrDefault("includeDeleted")
  valid_589060 = validateParameter(valid_589060, JBool, required = false,
                                 default = newJBool(true))
  if valid_589060 != nil:
    section.add "includeDeleted", valid_589060
  var valid_589061 = query.getOrDefault("spaces")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "spaces", valid_589061
  var valid_589062 = query.getOrDefault("prettyPrint")
  valid_589062 = validateParameter(valid_589062, JBool, required = false,
                                 default = newJBool(true))
  if valid_589062 != nil:
    section.add "prettyPrint", valid_589062
  var valid_589063 = query.getOrDefault("startChangeId")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "startChangeId", valid_589063
  var valid_589064 = query.getOrDefault("includeCorpusRemovals")
  valid_589064 = validateParameter(valid_589064, JBool, required = false,
                                 default = newJBool(false))
  if valid_589064 != nil:
    section.add "includeCorpusRemovals", valid_589064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589065: Call_DriveChangesList_589041; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the changes for a user or shared drive.
  ## 
  let valid = call_589065.validator(path, query, header, formData, body)
  let scheme = call_589065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589065.url(scheme.get, call_589065.host, call_589065.base,
                         call_589065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589065, url, valid)

proc call*(call_589066: Call_DriveChangesList_589041; driveId: string = "";
          supportsAllDrives: bool = false; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          includeItemsFromAllDrives: bool = false; userIp: string = "";
          includeTeamDriveItems: bool = false; teamDriveId: string = "";
          includeSubscribed: bool = true; maxResults: int = 100;
          supportsTeamDrives: bool = false; key: string = "";
          includeDeleted: bool = true; spaces: string = ""; prettyPrint: bool = true;
          startChangeId: string = ""; includeCorpusRemovals: bool = false): Recallable =
  ## driveChangesList
  ## Lists the changes for a user or shared drive.
  ##   driveId: string
  ##          : The shared drive from which changes will be returned. If specified the change IDs will be reflective of the shared drive; use the combined drive ID and change ID as an identifier.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response or to the response from the getStartPageToken method.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   includeItemsFromAllDrives: bool
  ##                            : Deprecated - Whether both My Drive and shared drive items should be included in results. This parameter will only be effective until June 1, 2020. Afterwards shared drive items will be included in the results.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   includeTeamDriveItems: bool
  ##                        : Deprecated use includeItemsFromAllDrives instead.
  ##   teamDriveId: string
  ##              : Deprecated use driveId instead.
  ##   includeSubscribed: bool
  ##                    : Whether to include changes outside the My Drive hierarchy in the result. When set to false, changes to files such as those in the Application Data folder or shared files which have not been added to My Drive will be omitted from the result.
  ##   maxResults: int
  ##             : Maximum number of changes to return.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeDeleted: bool
  ##                 : Whether to include changes indicating that items have been removed from the list of changes, for example by deletion or loss of access.
  ##   spaces: string
  ##         : A comma-separated list of spaces to query. Supported values are 'drive', 'appDataFolder' and 'photos'.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startChangeId: string
  ##                : Deprecated - use pageToken instead.
  ##   includeCorpusRemovals: bool
  ##                        : Whether changes should include the file resource if the file is still accessible by the user at the time of the request, even when a file was removed from the list of changes and there will be no further change entries for this file.
  var query_589067 = newJObject()
  add(query_589067, "driveId", newJString(driveId))
  add(query_589067, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589067, "fields", newJString(fields))
  add(query_589067, "pageToken", newJString(pageToken))
  add(query_589067, "quotaUser", newJString(quotaUser))
  add(query_589067, "alt", newJString(alt))
  add(query_589067, "oauth_token", newJString(oauthToken))
  add(query_589067, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_589067, "userIp", newJString(userIp))
  add(query_589067, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  add(query_589067, "teamDriveId", newJString(teamDriveId))
  add(query_589067, "includeSubscribed", newJBool(includeSubscribed))
  add(query_589067, "maxResults", newJInt(maxResults))
  add(query_589067, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589067, "key", newJString(key))
  add(query_589067, "includeDeleted", newJBool(includeDeleted))
  add(query_589067, "spaces", newJString(spaces))
  add(query_589067, "prettyPrint", newJBool(prettyPrint))
  add(query_589067, "startChangeId", newJString(startChangeId))
  add(query_589067, "includeCorpusRemovals", newJBool(includeCorpusRemovals))
  result = call_589066.call(nil, query_589067, nil, nil, nil)

var driveChangesList* = Call_DriveChangesList_589041(name: "driveChangesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/changes",
    validator: validate_DriveChangesList_589042, base: "/drive/v2",
    url: url_DriveChangesList_589043, schemes: {Scheme.Https})
type
  Call_DriveChangesGetStartPageToken_589068 = ref object of OpenApiRestCall_588457
proc url_DriveChangesGetStartPageToken_589070(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveChangesGetStartPageToken_589069(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the starting pageToken for listing future changes.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   driveId: JString
  ##          : The ID of the shared drive for which the starting pageToken for listing future changes from that shared drive will be returned.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
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
  ##   teamDriveId: JString
  ##              : Deprecated use driveId instead.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589071 = query.getOrDefault("driveId")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "driveId", valid_589071
  var valid_589072 = query.getOrDefault("supportsAllDrives")
  valid_589072 = validateParameter(valid_589072, JBool, required = false,
                                 default = newJBool(false))
  if valid_589072 != nil:
    section.add "supportsAllDrives", valid_589072
  var valid_589073 = query.getOrDefault("fields")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "fields", valid_589073
  var valid_589074 = query.getOrDefault("quotaUser")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "quotaUser", valid_589074
  var valid_589075 = query.getOrDefault("alt")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = newJString("json"))
  if valid_589075 != nil:
    section.add "alt", valid_589075
  var valid_589076 = query.getOrDefault("oauth_token")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "oauth_token", valid_589076
  var valid_589077 = query.getOrDefault("userIp")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "userIp", valid_589077
  var valid_589078 = query.getOrDefault("teamDriveId")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "teamDriveId", valid_589078
  var valid_589079 = query.getOrDefault("supportsTeamDrives")
  valid_589079 = validateParameter(valid_589079, JBool, required = false,
                                 default = newJBool(false))
  if valid_589079 != nil:
    section.add "supportsTeamDrives", valid_589079
  var valid_589080 = query.getOrDefault("key")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "key", valid_589080
  var valid_589081 = query.getOrDefault("prettyPrint")
  valid_589081 = validateParameter(valid_589081, JBool, required = false,
                                 default = newJBool(true))
  if valid_589081 != nil:
    section.add "prettyPrint", valid_589081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589082: Call_DriveChangesGetStartPageToken_589068; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the starting pageToken for listing future changes.
  ## 
  let valid = call_589082.validator(path, query, header, formData, body)
  let scheme = call_589082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589082.url(scheme.get, call_589082.host, call_589082.base,
                         call_589082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589082, url, valid)

proc call*(call_589083: Call_DriveChangesGetStartPageToken_589068;
          driveId: string = ""; supportsAllDrives: bool = false; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; teamDriveId: string = "";
          supportsTeamDrives: bool = false; key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveChangesGetStartPageToken
  ## Gets the starting pageToken for listing future changes.
  ##   driveId: string
  ##          : The ID of the shared drive for which the starting pageToken for listing future changes from that shared drive will be returned.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
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
  ##   teamDriveId: string
  ##              : Deprecated use driveId instead.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589084 = newJObject()
  add(query_589084, "driveId", newJString(driveId))
  add(query_589084, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589084, "fields", newJString(fields))
  add(query_589084, "quotaUser", newJString(quotaUser))
  add(query_589084, "alt", newJString(alt))
  add(query_589084, "oauth_token", newJString(oauthToken))
  add(query_589084, "userIp", newJString(userIp))
  add(query_589084, "teamDriveId", newJString(teamDriveId))
  add(query_589084, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589084, "key", newJString(key))
  add(query_589084, "prettyPrint", newJBool(prettyPrint))
  result = call_589083.call(nil, query_589084, nil, nil, nil)

var driveChangesGetStartPageToken* = Call_DriveChangesGetStartPageToken_589068(
    name: "driveChangesGetStartPageToken", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/changes/startPageToken",
    validator: validate_DriveChangesGetStartPageToken_589069, base: "/drive/v2",
    url: url_DriveChangesGetStartPageToken_589070, schemes: {Scheme.Https})
type
  Call_DriveChangesWatch_589085 = ref object of OpenApiRestCall_588457
proc url_DriveChangesWatch_589087(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveChangesWatch_589086(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Subscribe to changes for a user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   driveId: JString
  ##          : The shared drive from which changes will be returned. If specified the change IDs will be reflective of the shared drive; use the combined drive ID and change ID as an identifier.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response or to the response from the getStartPageToken method.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   includeItemsFromAllDrives: JBool
  ##                            : Deprecated - Whether both My Drive and shared drive items should be included in results. This parameter will only be effective until June 1, 2020. Afterwards shared drive items will be included in the results.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   includeTeamDriveItems: JBool
  ##                        : Deprecated use includeItemsFromAllDrives instead.
  ##   teamDriveId: JString
  ##              : Deprecated use driveId instead.
  ##   includeSubscribed: JBool
  ##                    : Whether to include changes outside the My Drive hierarchy in the result. When set to false, changes to files such as those in the Application Data folder or shared files which have not been added to My Drive will be omitted from the result.
  ##   maxResults: JInt
  ##             : Maximum number of changes to return.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeDeleted: JBool
  ##                 : Whether to include changes indicating that items have been removed from the list of changes, for example by deletion or loss of access.
  ##   spaces: JString
  ##         : A comma-separated list of spaces to query. Supported values are 'drive', 'appDataFolder' and 'photos'.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startChangeId: JString
  ##                : Deprecated - use pageToken instead.
  ##   includeCorpusRemovals: JBool
  ##                        : Whether changes should include the file resource if the file is still accessible by the user at the time of the request, even when a file was removed from the list of changes and there will be no further change entries for this file.
  section = newJObject()
  var valid_589088 = query.getOrDefault("driveId")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "driveId", valid_589088
  var valid_589089 = query.getOrDefault("supportsAllDrives")
  valid_589089 = validateParameter(valid_589089, JBool, required = false,
                                 default = newJBool(false))
  if valid_589089 != nil:
    section.add "supportsAllDrives", valid_589089
  var valid_589090 = query.getOrDefault("fields")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "fields", valid_589090
  var valid_589091 = query.getOrDefault("pageToken")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "pageToken", valid_589091
  var valid_589092 = query.getOrDefault("quotaUser")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "quotaUser", valid_589092
  var valid_589093 = query.getOrDefault("alt")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = newJString("json"))
  if valid_589093 != nil:
    section.add "alt", valid_589093
  var valid_589094 = query.getOrDefault("oauth_token")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "oauth_token", valid_589094
  var valid_589095 = query.getOrDefault("includeItemsFromAllDrives")
  valid_589095 = validateParameter(valid_589095, JBool, required = false,
                                 default = newJBool(false))
  if valid_589095 != nil:
    section.add "includeItemsFromAllDrives", valid_589095
  var valid_589096 = query.getOrDefault("userIp")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "userIp", valid_589096
  var valid_589097 = query.getOrDefault("includeTeamDriveItems")
  valid_589097 = validateParameter(valid_589097, JBool, required = false,
                                 default = newJBool(false))
  if valid_589097 != nil:
    section.add "includeTeamDriveItems", valid_589097
  var valid_589098 = query.getOrDefault("teamDriveId")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "teamDriveId", valid_589098
  var valid_589099 = query.getOrDefault("includeSubscribed")
  valid_589099 = validateParameter(valid_589099, JBool, required = false,
                                 default = newJBool(true))
  if valid_589099 != nil:
    section.add "includeSubscribed", valid_589099
  var valid_589100 = query.getOrDefault("maxResults")
  valid_589100 = validateParameter(valid_589100, JInt, required = false,
                                 default = newJInt(100))
  if valid_589100 != nil:
    section.add "maxResults", valid_589100
  var valid_589101 = query.getOrDefault("supportsTeamDrives")
  valid_589101 = validateParameter(valid_589101, JBool, required = false,
                                 default = newJBool(false))
  if valid_589101 != nil:
    section.add "supportsTeamDrives", valid_589101
  var valid_589102 = query.getOrDefault("key")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "key", valid_589102
  var valid_589103 = query.getOrDefault("includeDeleted")
  valid_589103 = validateParameter(valid_589103, JBool, required = false,
                                 default = newJBool(true))
  if valid_589103 != nil:
    section.add "includeDeleted", valid_589103
  var valid_589104 = query.getOrDefault("spaces")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "spaces", valid_589104
  var valid_589105 = query.getOrDefault("prettyPrint")
  valid_589105 = validateParameter(valid_589105, JBool, required = false,
                                 default = newJBool(true))
  if valid_589105 != nil:
    section.add "prettyPrint", valid_589105
  var valid_589106 = query.getOrDefault("startChangeId")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "startChangeId", valid_589106
  var valid_589107 = query.getOrDefault("includeCorpusRemovals")
  valid_589107 = validateParameter(valid_589107, JBool, required = false,
                                 default = newJBool(false))
  if valid_589107 != nil:
    section.add "includeCorpusRemovals", valid_589107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resource: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589109: Call_DriveChangesWatch_589085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Subscribe to changes for a user.
  ## 
  let valid = call_589109.validator(path, query, header, formData, body)
  let scheme = call_589109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589109.url(scheme.get, call_589109.host, call_589109.base,
                         call_589109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589109, url, valid)

proc call*(call_589110: Call_DriveChangesWatch_589085; driveId: string = "";
          supportsAllDrives: bool = false; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          includeItemsFromAllDrives: bool = false; userIp: string = "";
          includeTeamDriveItems: bool = false; teamDriveId: string = "";
          includeSubscribed: bool = true; maxResults: int = 100;
          supportsTeamDrives: bool = false; key: string = "";
          includeDeleted: bool = true; spaces: string = ""; resource: JsonNode = nil;
          prettyPrint: bool = true; startChangeId: string = "";
          includeCorpusRemovals: bool = false): Recallable =
  ## driveChangesWatch
  ## Subscribe to changes for a user.
  ##   driveId: string
  ##          : The shared drive from which changes will be returned. If specified the change IDs will be reflective of the shared drive; use the combined drive ID and change ID as an identifier.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response or to the response from the getStartPageToken method.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   includeItemsFromAllDrives: bool
  ##                            : Deprecated - Whether both My Drive and shared drive items should be included in results. This parameter will only be effective until June 1, 2020. Afterwards shared drive items will be included in the results.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   includeTeamDriveItems: bool
  ##                        : Deprecated use includeItemsFromAllDrives instead.
  ##   teamDriveId: string
  ##              : Deprecated use driveId instead.
  ##   includeSubscribed: bool
  ##                    : Whether to include changes outside the My Drive hierarchy in the result. When set to false, changes to files such as those in the Application Data folder or shared files which have not been added to My Drive will be omitted from the result.
  ##   maxResults: int
  ##             : Maximum number of changes to return.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeDeleted: bool
  ##                 : Whether to include changes indicating that items have been removed from the list of changes, for example by deletion or loss of access.
  ##   spaces: string
  ##         : A comma-separated list of spaces to query. Supported values are 'drive', 'appDataFolder' and 'photos'.
  ##   resource: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startChangeId: string
  ##                : Deprecated - use pageToken instead.
  ##   includeCorpusRemovals: bool
  ##                        : Whether changes should include the file resource if the file is still accessible by the user at the time of the request, even when a file was removed from the list of changes and there will be no further change entries for this file.
  var query_589111 = newJObject()
  var body_589112 = newJObject()
  add(query_589111, "driveId", newJString(driveId))
  add(query_589111, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589111, "fields", newJString(fields))
  add(query_589111, "pageToken", newJString(pageToken))
  add(query_589111, "quotaUser", newJString(quotaUser))
  add(query_589111, "alt", newJString(alt))
  add(query_589111, "oauth_token", newJString(oauthToken))
  add(query_589111, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_589111, "userIp", newJString(userIp))
  add(query_589111, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  add(query_589111, "teamDriveId", newJString(teamDriveId))
  add(query_589111, "includeSubscribed", newJBool(includeSubscribed))
  add(query_589111, "maxResults", newJInt(maxResults))
  add(query_589111, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589111, "key", newJString(key))
  add(query_589111, "includeDeleted", newJBool(includeDeleted))
  add(query_589111, "spaces", newJString(spaces))
  if resource != nil:
    body_589112 = resource
  add(query_589111, "prettyPrint", newJBool(prettyPrint))
  add(query_589111, "startChangeId", newJString(startChangeId))
  add(query_589111, "includeCorpusRemovals", newJBool(includeCorpusRemovals))
  result = call_589110.call(nil, query_589111, nil, nil, body_589112)

var driveChangesWatch* = Call_DriveChangesWatch_589085(name: "driveChangesWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/changes/watch",
    validator: validate_DriveChangesWatch_589086, base: "/drive/v2",
    url: url_DriveChangesWatch_589087, schemes: {Scheme.Https})
type
  Call_DriveChangesGet_589113 = ref object of OpenApiRestCall_588457
proc url_DriveChangesGet_589115(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "changeId" in path, "`changeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/changes/"),
               (kind: VariableSegment, value: "changeId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveChangesGet_589114(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deprecated - Use changes.getStartPageToken and changes.list to retrieve recent changes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   changeId: JString (required)
  ##           : The ID of the change.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `changeId` field"
  var valid_589116 = path.getOrDefault("changeId")
  valid_589116 = validateParameter(valid_589116, JString, required = true,
                                 default = nil)
  if valid_589116 != nil:
    section.add "changeId", valid_589116
  result.add "path", section
  ## parameters in `query` object:
  ##   driveId: JString
  ##          : The shared drive from which the change will be returned.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
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
  ##   teamDriveId: JString
  ##              : Deprecated use driveId instead.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589117 = query.getOrDefault("driveId")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "driveId", valid_589117
  var valid_589118 = query.getOrDefault("supportsAllDrives")
  valid_589118 = validateParameter(valid_589118, JBool, required = false,
                                 default = newJBool(false))
  if valid_589118 != nil:
    section.add "supportsAllDrives", valid_589118
  var valid_589119 = query.getOrDefault("fields")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "fields", valid_589119
  var valid_589120 = query.getOrDefault("quotaUser")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "quotaUser", valid_589120
  var valid_589121 = query.getOrDefault("alt")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = newJString("json"))
  if valid_589121 != nil:
    section.add "alt", valid_589121
  var valid_589122 = query.getOrDefault("oauth_token")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "oauth_token", valid_589122
  var valid_589123 = query.getOrDefault("userIp")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "userIp", valid_589123
  var valid_589124 = query.getOrDefault("teamDriveId")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "teamDriveId", valid_589124
  var valid_589125 = query.getOrDefault("supportsTeamDrives")
  valid_589125 = validateParameter(valid_589125, JBool, required = false,
                                 default = newJBool(false))
  if valid_589125 != nil:
    section.add "supportsTeamDrives", valid_589125
  var valid_589126 = query.getOrDefault("key")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "key", valid_589126
  var valid_589127 = query.getOrDefault("prettyPrint")
  valid_589127 = validateParameter(valid_589127, JBool, required = false,
                                 default = newJBool(true))
  if valid_589127 != nil:
    section.add "prettyPrint", valid_589127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589128: Call_DriveChangesGet_589113; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated - Use changes.getStartPageToken and changes.list to retrieve recent changes.
  ## 
  let valid = call_589128.validator(path, query, header, formData, body)
  let scheme = call_589128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589128.url(scheme.get, call_589128.host, call_589128.base,
                         call_589128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589128, url, valid)

proc call*(call_589129: Call_DriveChangesGet_589113; changeId: string;
          driveId: string = ""; supportsAllDrives: bool = false; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; teamDriveId: string = "";
          supportsTeamDrives: bool = false; key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveChangesGet
  ## Deprecated - Use changes.getStartPageToken and changes.list to retrieve recent changes.
  ##   driveId: string
  ##          : The shared drive from which the change will be returned.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   changeId: string (required)
  ##           : The ID of the change.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   teamDriveId: string
  ##              : Deprecated use driveId instead.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589130 = newJObject()
  var query_589131 = newJObject()
  add(query_589131, "driveId", newJString(driveId))
  add(query_589131, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589131, "fields", newJString(fields))
  add(path_589130, "changeId", newJString(changeId))
  add(query_589131, "quotaUser", newJString(quotaUser))
  add(query_589131, "alt", newJString(alt))
  add(query_589131, "oauth_token", newJString(oauthToken))
  add(query_589131, "userIp", newJString(userIp))
  add(query_589131, "teamDriveId", newJString(teamDriveId))
  add(query_589131, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589131, "key", newJString(key))
  add(query_589131, "prettyPrint", newJBool(prettyPrint))
  result = call_589129.call(path_589130, query_589131, nil, nil, nil)

var driveChangesGet* = Call_DriveChangesGet_589113(name: "driveChangesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/changes/{changeId}", validator: validate_DriveChangesGet_589114,
    base: "/drive/v2", url: url_DriveChangesGet_589115, schemes: {Scheme.Https})
type
  Call_DriveChannelsStop_589132 = ref object of OpenApiRestCall_588457
proc url_DriveChannelsStop_589134(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveChannelsStop_589133(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Stop watching resources through this channel
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
  var valid_589135 = query.getOrDefault("fields")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "fields", valid_589135
  var valid_589136 = query.getOrDefault("quotaUser")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "quotaUser", valid_589136
  var valid_589137 = query.getOrDefault("alt")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = newJString("json"))
  if valid_589137 != nil:
    section.add "alt", valid_589137
  var valid_589138 = query.getOrDefault("oauth_token")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "oauth_token", valid_589138
  var valid_589139 = query.getOrDefault("userIp")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "userIp", valid_589139
  var valid_589140 = query.getOrDefault("key")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "key", valid_589140
  var valid_589141 = query.getOrDefault("prettyPrint")
  valid_589141 = validateParameter(valid_589141, JBool, required = false,
                                 default = newJBool(true))
  if valid_589141 != nil:
    section.add "prettyPrint", valid_589141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resource: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589143: Call_DriveChannelsStop_589132; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_589143.validator(path, query, header, formData, body)
  let scheme = call_589143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589143.url(scheme.get, call_589143.host, call_589143.base,
                         call_589143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589143, url, valid)

proc call*(call_589144: Call_DriveChannelsStop_589132; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; resource: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## driveChannelsStop
  ## Stop watching resources through this channel
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
  ##   resource: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589145 = newJObject()
  var body_589146 = newJObject()
  add(query_589145, "fields", newJString(fields))
  add(query_589145, "quotaUser", newJString(quotaUser))
  add(query_589145, "alt", newJString(alt))
  add(query_589145, "oauth_token", newJString(oauthToken))
  add(query_589145, "userIp", newJString(userIp))
  add(query_589145, "key", newJString(key))
  if resource != nil:
    body_589146 = resource
  add(query_589145, "prettyPrint", newJBool(prettyPrint))
  result = call_589144.call(nil, query_589145, nil, nil, body_589146)

var driveChannelsStop* = Call_DriveChannelsStop_589132(name: "driveChannelsStop",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/channels/stop",
    validator: validate_DriveChannelsStop_589133, base: "/drive/v2",
    url: url_DriveChannelsStop_589134, schemes: {Scheme.Https})
type
  Call_DriveDrivesInsert_589164 = ref object of OpenApiRestCall_588457
proc url_DriveDrivesInsert_589166(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveDrivesInsert_589165(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates a new shared drive.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: JString (required)
  ##            : An ID, such as a random UUID, which uniquely identifies this user's request for idempotent creation of a shared drive. A repeated request by the same user and with the same request ID will avoid creating duplicates by attempting to create the same shared drive. If the shared drive already exists a 409 error will be returned.
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
  var valid_589167 = query.getOrDefault("fields")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "fields", valid_589167
  assert query != nil,
        "query argument is necessary due to required `requestId` field"
  var valid_589168 = query.getOrDefault("requestId")
  valid_589168 = validateParameter(valid_589168, JString, required = true,
                                 default = nil)
  if valid_589168 != nil:
    section.add "requestId", valid_589168
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

proc call*(call_589176: Call_DriveDrivesInsert_589164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new shared drive.
  ## 
  let valid = call_589176.validator(path, query, header, formData, body)
  let scheme = call_589176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589176.url(scheme.get, call_589176.host, call_589176.base,
                         call_589176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589176, url, valid)

proc call*(call_589177: Call_DriveDrivesInsert_589164; requestId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## driveDrivesInsert
  ## Creates a new shared drive.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: string (required)
  ##            : An ID, such as a random UUID, which uniquely identifies this user's request for idempotent creation of a shared drive. A repeated request by the same user and with the same request ID will avoid creating duplicates by attempting to create the same shared drive. If the shared drive already exists a 409 error will be returned.
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
  add(query_589178, "requestId", newJString(requestId))
  add(query_589178, "quotaUser", newJString(quotaUser))
  add(query_589178, "alt", newJString(alt))
  add(query_589178, "oauth_token", newJString(oauthToken))
  add(query_589178, "userIp", newJString(userIp))
  add(query_589178, "key", newJString(key))
  if body != nil:
    body_589179 = body
  add(query_589178, "prettyPrint", newJBool(prettyPrint))
  result = call_589177.call(nil, query_589178, nil, nil, body_589179)

var driveDrivesInsert* = Call_DriveDrivesInsert_589164(name: "driveDrivesInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/drives",
    validator: validate_DriveDrivesInsert_589165, base: "/drive/v2",
    url: url_DriveDrivesInsert_589166, schemes: {Scheme.Https})
type
  Call_DriveDrivesList_589147 = ref object of OpenApiRestCall_588457
proc url_DriveDrivesList_589149(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveDrivesList_589148(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Lists the user's shared drives.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Page token for shared drives.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of shared drives to return.
  ##   q: JString
  ##    : Query string for searching shared drives.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then all shared drives of the domain in which the requester is an administrator are returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589150 = query.getOrDefault("fields")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "fields", valid_589150
  var valid_589151 = query.getOrDefault("pageToken")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "pageToken", valid_589151
  var valid_589152 = query.getOrDefault("quotaUser")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "quotaUser", valid_589152
  var valid_589153 = query.getOrDefault("alt")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = newJString("json"))
  if valid_589153 != nil:
    section.add "alt", valid_589153
  var valid_589154 = query.getOrDefault("oauth_token")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "oauth_token", valid_589154
  var valid_589155 = query.getOrDefault("userIp")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "userIp", valid_589155
  var valid_589156 = query.getOrDefault("maxResults")
  valid_589156 = validateParameter(valid_589156, JInt, required = false,
                                 default = newJInt(10))
  if valid_589156 != nil:
    section.add "maxResults", valid_589156
  var valid_589157 = query.getOrDefault("q")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "q", valid_589157
  var valid_589158 = query.getOrDefault("key")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "key", valid_589158
  var valid_589159 = query.getOrDefault("useDomainAdminAccess")
  valid_589159 = validateParameter(valid_589159, JBool, required = false,
                                 default = newJBool(false))
  if valid_589159 != nil:
    section.add "useDomainAdminAccess", valid_589159
  var valid_589160 = query.getOrDefault("prettyPrint")
  valid_589160 = validateParameter(valid_589160, JBool, required = false,
                                 default = newJBool(true))
  if valid_589160 != nil:
    section.add "prettyPrint", valid_589160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589161: Call_DriveDrivesList_589147; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the user's shared drives.
  ## 
  let valid = call_589161.validator(path, query, header, formData, body)
  let scheme = call_589161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589161.url(scheme.get, call_589161.host, call_589161.base,
                         call_589161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589161, url, valid)

proc call*(call_589162: Call_DriveDrivesList_589147; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 10;
          q: string = ""; key: string = ""; useDomainAdminAccess: bool = false;
          prettyPrint: bool = true): Recallable =
  ## driveDrivesList
  ## Lists the user's shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Page token for shared drives.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of shared drives to return.
  ##   q: string
  ##    : Query string for searching shared drives.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then all shared drives of the domain in which the requester is an administrator are returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589163 = newJObject()
  add(query_589163, "fields", newJString(fields))
  add(query_589163, "pageToken", newJString(pageToken))
  add(query_589163, "quotaUser", newJString(quotaUser))
  add(query_589163, "alt", newJString(alt))
  add(query_589163, "oauth_token", newJString(oauthToken))
  add(query_589163, "userIp", newJString(userIp))
  add(query_589163, "maxResults", newJInt(maxResults))
  add(query_589163, "q", newJString(q))
  add(query_589163, "key", newJString(key))
  add(query_589163, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_589163, "prettyPrint", newJBool(prettyPrint))
  result = call_589162.call(nil, query_589163, nil, nil, nil)

var driveDrivesList* = Call_DriveDrivesList_589147(name: "driveDrivesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/drives",
    validator: validate_DriveDrivesList_589148, base: "/drive/v2",
    url: url_DriveDrivesList_589149, schemes: {Scheme.Https})
type
  Call_DriveDrivesUpdate_589196 = ref object of OpenApiRestCall_588457
proc url_DriveDrivesUpdate_589198(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "driveId" in path, "`driveId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/drives/"),
               (kind: VariableSegment, value: "driveId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveDrivesUpdate_589197(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates the metadata for a shared drive.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   driveId: JString (required)
  ##          : The ID of the shared drive.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `driveId` field"
  var valid_589199 = path.getOrDefault("driveId")
  valid_589199 = validateParameter(valid_589199, JString, required = true,
                                 default = nil)
  if valid_589199 != nil:
    section.add "driveId", valid_589199
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
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the shared drive belongs.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589200 = query.getOrDefault("fields")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "fields", valid_589200
  var valid_589201 = query.getOrDefault("quotaUser")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "quotaUser", valid_589201
  var valid_589202 = query.getOrDefault("alt")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = newJString("json"))
  if valid_589202 != nil:
    section.add "alt", valid_589202
  var valid_589203 = query.getOrDefault("oauth_token")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "oauth_token", valid_589203
  var valid_589204 = query.getOrDefault("userIp")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "userIp", valid_589204
  var valid_589205 = query.getOrDefault("key")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "key", valid_589205
  var valid_589206 = query.getOrDefault("useDomainAdminAccess")
  valid_589206 = validateParameter(valid_589206, JBool, required = false,
                                 default = newJBool(false))
  if valid_589206 != nil:
    section.add "useDomainAdminAccess", valid_589206
  var valid_589207 = query.getOrDefault("prettyPrint")
  valid_589207 = validateParameter(valid_589207, JBool, required = false,
                                 default = newJBool(true))
  if valid_589207 != nil:
    section.add "prettyPrint", valid_589207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589209: Call_DriveDrivesUpdate_589196; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the metadata for a shared drive.
  ## 
  let valid = call_589209.validator(path, query, header, formData, body)
  let scheme = call_589209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589209.url(scheme.get, call_589209.host, call_589209.base,
                         call_589209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589209, url, valid)

proc call*(call_589210: Call_DriveDrivesUpdate_589196; driveId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          useDomainAdminAccess: bool = false; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## driveDrivesUpdate
  ## Updates the metadata for a shared drive.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   driveId: string (required)
  ##          : The ID of the shared drive.
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
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the shared drive belongs.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589211 = newJObject()
  var query_589212 = newJObject()
  var body_589213 = newJObject()
  add(query_589212, "fields", newJString(fields))
  add(path_589211, "driveId", newJString(driveId))
  add(query_589212, "quotaUser", newJString(quotaUser))
  add(query_589212, "alt", newJString(alt))
  add(query_589212, "oauth_token", newJString(oauthToken))
  add(query_589212, "userIp", newJString(userIp))
  add(query_589212, "key", newJString(key))
  add(query_589212, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  if body != nil:
    body_589213 = body
  add(query_589212, "prettyPrint", newJBool(prettyPrint))
  result = call_589210.call(path_589211, query_589212, nil, nil, body_589213)

var driveDrivesUpdate* = Call_DriveDrivesUpdate_589196(name: "driveDrivesUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesUpdate_589197,
    base: "/drive/v2", url: url_DriveDrivesUpdate_589198, schemes: {Scheme.Https})
type
  Call_DriveDrivesGet_589180 = ref object of OpenApiRestCall_588457
proc url_DriveDrivesGet_589182(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "driveId" in path, "`driveId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/drives/"),
               (kind: VariableSegment, value: "driveId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveDrivesGet_589181(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets a shared drive's metadata by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   driveId: JString (required)
  ##          : The ID of the shared drive.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `driveId` field"
  var valid_589183 = path.getOrDefault("driveId")
  valid_589183 = validateParameter(valid_589183, JString, required = true,
                                 default = nil)
  if valid_589183 != nil:
    section.add "driveId", valid_589183
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
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the shared drive belongs.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589184 = query.getOrDefault("fields")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "fields", valid_589184
  var valid_589185 = query.getOrDefault("quotaUser")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "quotaUser", valid_589185
  var valid_589186 = query.getOrDefault("alt")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = newJString("json"))
  if valid_589186 != nil:
    section.add "alt", valid_589186
  var valid_589187 = query.getOrDefault("oauth_token")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "oauth_token", valid_589187
  var valid_589188 = query.getOrDefault("userIp")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "userIp", valid_589188
  var valid_589189 = query.getOrDefault("key")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "key", valid_589189
  var valid_589190 = query.getOrDefault("useDomainAdminAccess")
  valid_589190 = validateParameter(valid_589190, JBool, required = false,
                                 default = newJBool(false))
  if valid_589190 != nil:
    section.add "useDomainAdminAccess", valid_589190
  var valid_589191 = query.getOrDefault("prettyPrint")
  valid_589191 = validateParameter(valid_589191, JBool, required = false,
                                 default = newJBool(true))
  if valid_589191 != nil:
    section.add "prettyPrint", valid_589191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589192: Call_DriveDrivesGet_589180; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a shared drive's metadata by ID.
  ## 
  let valid = call_589192.validator(path, query, header, formData, body)
  let scheme = call_589192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589192.url(scheme.get, call_589192.host, call_589192.base,
                         call_589192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589192, url, valid)

proc call*(call_589193: Call_DriveDrivesGet_589180; driveId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          useDomainAdminAccess: bool = false; prettyPrint: bool = true): Recallable =
  ## driveDrivesGet
  ## Gets a shared drive's metadata by ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   driveId: string (required)
  ##          : The ID of the shared drive.
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
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the shared drive belongs.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589194 = newJObject()
  var query_589195 = newJObject()
  add(query_589195, "fields", newJString(fields))
  add(path_589194, "driveId", newJString(driveId))
  add(query_589195, "quotaUser", newJString(quotaUser))
  add(query_589195, "alt", newJString(alt))
  add(query_589195, "oauth_token", newJString(oauthToken))
  add(query_589195, "userIp", newJString(userIp))
  add(query_589195, "key", newJString(key))
  add(query_589195, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_589195, "prettyPrint", newJBool(prettyPrint))
  result = call_589193.call(path_589194, query_589195, nil, nil, nil)

var driveDrivesGet* = Call_DriveDrivesGet_589180(name: "driveDrivesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesGet_589181,
    base: "/drive/v2", url: url_DriveDrivesGet_589182, schemes: {Scheme.Https})
type
  Call_DriveDrivesDelete_589214 = ref object of OpenApiRestCall_588457
proc url_DriveDrivesDelete_589216(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "driveId" in path, "`driveId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/drives/"),
               (kind: VariableSegment, value: "driveId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveDrivesDelete_589215(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Permanently deletes a shared drive for which the user is an organizer. The shared drive cannot contain any untrashed items.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   driveId: JString (required)
  ##          : The ID of the shared drive.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `driveId` field"
  var valid_589217 = path.getOrDefault("driveId")
  valid_589217 = validateParameter(valid_589217, JString, required = true,
                                 default = nil)
  if valid_589217 != nil:
    section.add "driveId", valid_589217
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
  var valid_589218 = query.getOrDefault("fields")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "fields", valid_589218
  var valid_589219 = query.getOrDefault("quotaUser")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "quotaUser", valid_589219
  var valid_589220 = query.getOrDefault("alt")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = newJString("json"))
  if valid_589220 != nil:
    section.add "alt", valid_589220
  var valid_589221 = query.getOrDefault("oauth_token")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "oauth_token", valid_589221
  var valid_589222 = query.getOrDefault("userIp")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "userIp", valid_589222
  var valid_589223 = query.getOrDefault("key")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "key", valid_589223
  var valid_589224 = query.getOrDefault("prettyPrint")
  valid_589224 = validateParameter(valid_589224, JBool, required = false,
                                 default = newJBool(true))
  if valid_589224 != nil:
    section.add "prettyPrint", valid_589224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589225: Call_DriveDrivesDelete_589214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a shared drive for which the user is an organizer. The shared drive cannot contain any untrashed items.
  ## 
  let valid = call_589225.validator(path, query, header, formData, body)
  let scheme = call_589225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589225.url(scheme.get, call_589225.host, call_589225.base,
                         call_589225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589225, url, valid)

proc call*(call_589226: Call_DriveDrivesDelete_589214; driveId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## driveDrivesDelete
  ## Permanently deletes a shared drive for which the user is an organizer. The shared drive cannot contain any untrashed items.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   driveId: string (required)
  ##          : The ID of the shared drive.
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
  var path_589227 = newJObject()
  var query_589228 = newJObject()
  add(query_589228, "fields", newJString(fields))
  add(path_589227, "driveId", newJString(driveId))
  add(query_589228, "quotaUser", newJString(quotaUser))
  add(query_589228, "alt", newJString(alt))
  add(query_589228, "oauth_token", newJString(oauthToken))
  add(query_589228, "userIp", newJString(userIp))
  add(query_589228, "key", newJString(key))
  add(query_589228, "prettyPrint", newJBool(prettyPrint))
  result = call_589226.call(path_589227, query_589228, nil, nil, nil)

var driveDrivesDelete* = Call_DriveDrivesDelete_589214(name: "driveDrivesDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesDelete_589215,
    base: "/drive/v2", url: url_DriveDrivesDelete_589216, schemes: {Scheme.Https})
type
  Call_DriveDrivesHide_589229 = ref object of OpenApiRestCall_588457
proc url_DriveDrivesHide_589231(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "driveId" in path, "`driveId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/drives/"),
               (kind: VariableSegment, value: "driveId"),
               (kind: ConstantSegment, value: "/hide")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveDrivesHide_589230(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Hides a shared drive from the default view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   driveId: JString (required)
  ##          : The ID of the shared drive.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `driveId` field"
  var valid_589232 = path.getOrDefault("driveId")
  valid_589232 = validateParameter(valid_589232, JString, required = true,
                                 default = nil)
  if valid_589232 != nil:
    section.add "driveId", valid_589232
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
  var valid_589233 = query.getOrDefault("fields")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = nil)
  if valid_589233 != nil:
    section.add "fields", valid_589233
  var valid_589234 = query.getOrDefault("quotaUser")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "quotaUser", valid_589234
  var valid_589235 = query.getOrDefault("alt")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = newJString("json"))
  if valid_589235 != nil:
    section.add "alt", valid_589235
  var valid_589236 = query.getOrDefault("oauth_token")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "oauth_token", valid_589236
  var valid_589237 = query.getOrDefault("userIp")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "userIp", valid_589237
  var valid_589238 = query.getOrDefault("key")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "key", valid_589238
  var valid_589239 = query.getOrDefault("prettyPrint")
  valid_589239 = validateParameter(valid_589239, JBool, required = false,
                                 default = newJBool(true))
  if valid_589239 != nil:
    section.add "prettyPrint", valid_589239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589240: Call_DriveDrivesHide_589229; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Hides a shared drive from the default view.
  ## 
  let valid = call_589240.validator(path, query, header, formData, body)
  let scheme = call_589240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589240.url(scheme.get, call_589240.host, call_589240.base,
                         call_589240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589240, url, valid)

proc call*(call_589241: Call_DriveDrivesHide_589229; driveId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## driveDrivesHide
  ## Hides a shared drive from the default view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   driveId: string (required)
  ##          : The ID of the shared drive.
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
  var path_589242 = newJObject()
  var query_589243 = newJObject()
  add(query_589243, "fields", newJString(fields))
  add(path_589242, "driveId", newJString(driveId))
  add(query_589243, "quotaUser", newJString(quotaUser))
  add(query_589243, "alt", newJString(alt))
  add(query_589243, "oauth_token", newJString(oauthToken))
  add(query_589243, "userIp", newJString(userIp))
  add(query_589243, "key", newJString(key))
  add(query_589243, "prettyPrint", newJBool(prettyPrint))
  result = call_589241.call(path_589242, query_589243, nil, nil, nil)

var driveDrivesHide* = Call_DriveDrivesHide_589229(name: "driveDrivesHide",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/drives/{driveId}/hide", validator: validate_DriveDrivesHide_589230,
    base: "/drive/v2", url: url_DriveDrivesHide_589231, schemes: {Scheme.Https})
type
  Call_DriveDrivesUnhide_589244 = ref object of OpenApiRestCall_588457
proc url_DriveDrivesUnhide_589246(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "driveId" in path, "`driveId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/drives/"),
               (kind: VariableSegment, value: "driveId"),
               (kind: ConstantSegment, value: "/unhide")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveDrivesUnhide_589245(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Restores a shared drive to the default view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   driveId: JString (required)
  ##          : The ID of the shared drive.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `driveId` field"
  var valid_589247 = path.getOrDefault("driveId")
  valid_589247 = validateParameter(valid_589247, JString, required = true,
                                 default = nil)
  if valid_589247 != nil:
    section.add "driveId", valid_589247
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

proc call*(call_589255: Call_DriveDrivesUnhide_589244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a shared drive to the default view.
  ## 
  let valid = call_589255.validator(path, query, header, formData, body)
  let scheme = call_589255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589255.url(scheme.get, call_589255.host, call_589255.base,
                         call_589255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589255, url, valid)

proc call*(call_589256: Call_DriveDrivesUnhide_589244; driveId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## driveDrivesUnhide
  ## Restores a shared drive to the default view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   driveId: string (required)
  ##          : The ID of the shared drive.
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
  var path_589257 = newJObject()
  var query_589258 = newJObject()
  add(query_589258, "fields", newJString(fields))
  add(path_589257, "driveId", newJString(driveId))
  add(query_589258, "quotaUser", newJString(quotaUser))
  add(query_589258, "alt", newJString(alt))
  add(query_589258, "oauth_token", newJString(oauthToken))
  add(query_589258, "userIp", newJString(userIp))
  add(query_589258, "key", newJString(key))
  add(query_589258, "prettyPrint", newJBool(prettyPrint))
  result = call_589256.call(path_589257, query_589258, nil, nil, nil)

var driveDrivesUnhide* = Call_DriveDrivesUnhide_589244(name: "driveDrivesUnhide",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/drives/{driveId}/unhide", validator: validate_DriveDrivesUnhide_589245,
    base: "/drive/v2", url: url_DriveDrivesUnhide_589246, schemes: {Scheme.Https})
type
  Call_DriveFilesInsert_589286 = ref object of OpenApiRestCall_588457
proc url_DriveFilesInsert_589288(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveFilesInsert_589287(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Insert a new file.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   pinned: JBool
  ##         : Whether to pin the head revision of the uploaded file. A file can have a maximum of 200 pinned revisions.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   ocr: JBool
  ##      : Whether to attempt OCR on .jpg, .png, .gif, or .pdf uploads.
  ##   timedTextLanguage: JString
  ##                    : The language of the timed text.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   convert: JBool
  ##          : Whether to convert this file to the corresponding Google Docs format.
  ##   useContentAsIndexableText: JBool
  ##                            : Whether to use the content as indexable text.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ocrLanguage: JString
  ##              : If ocr is true, hints at the language to use. Valid values are BCP 47 codes.
  ##   timedTextTrackName: JString
  ##                     : The timed text track name.
  ##   visibility: JString
  ##             : The visibility of the new file. This parameter is only relevant when convert=false.
  section = newJObject()
  var valid_589289 = query.getOrDefault("supportsAllDrives")
  valid_589289 = validateParameter(valid_589289, JBool, required = false,
                                 default = newJBool(false))
  if valid_589289 != nil:
    section.add "supportsAllDrives", valid_589289
  var valid_589290 = query.getOrDefault("fields")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = nil)
  if valid_589290 != nil:
    section.add "fields", valid_589290
  var valid_589291 = query.getOrDefault("quotaUser")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = nil)
  if valid_589291 != nil:
    section.add "quotaUser", valid_589291
  var valid_589292 = query.getOrDefault("alt")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = newJString("json"))
  if valid_589292 != nil:
    section.add "alt", valid_589292
  var valid_589293 = query.getOrDefault("pinned")
  valid_589293 = validateParameter(valid_589293, JBool, required = false,
                                 default = newJBool(false))
  if valid_589293 != nil:
    section.add "pinned", valid_589293
  var valid_589294 = query.getOrDefault("oauth_token")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "oauth_token", valid_589294
  var valid_589295 = query.getOrDefault("userIp")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "userIp", valid_589295
  var valid_589296 = query.getOrDefault("ocr")
  valid_589296 = validateParameter(valid_589296, JBool, required = false,
                                 default = newJBool(false))
  if valid_589296 != nil:
    section.add "ocr", valid_589296
  var valid_589297 = query.getOrDefault("timedTextLanguage")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = nil)
  if valid_589297 != nil:
    section.add "timedTextLanguage", valid_589297
  var valid_589298 = query.getOrDefault("supportsTeamDrives")
  valid_589298 = validateParameter(valid_589298, JBool, required = false,
                                 default = newJBool(false))
  if valid_589298 != nil:
    section.add "supportsTeamDrives", valid_589298
  var valid_589299 = query.getOrDefault("key")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = nil)
  if valid_589299 != nil:
    section.add "key", valid_589299
  var valid_589300 = query.getOrDefault("convert")
  valid_589300 = validateParameter(valid_589300, JBool, required = false,
                                 default = newJBool(false))
  if valid_589300 != nil:
    section.add "convert", valid_589300
  var valid_589301 = query.getOrDefault("useContentAsIndexableText")
  valid_589301 = validateParameter(valid_589301, JBool, required = false,
                                 default = newJBool(false))
  if valid_589301 != nil:
    section.add "useContentAsIndexableText", valid_589301
  var valid_589302 = query.getOrDefault("prettyPrint")
  valid_589302 = validateParameter(valid_589302, JBool, required = false,
                                 default = newJBool(true))
  if valid_589302 != nil:
    section.add "prettyPrint", valid_589302
  var valid_589303 = query.getOrDefault("ocrLanguage")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = nil)
  if valid_589303 != nil:
    section.add "ocrLanguage", valid_589303
  var valid_589304 = query.getOrDefault("timedTextTrackName")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = nil)
  if valid_589304 != nil:
    section.add "timedTextTrackName", valid_589304
  var valid_589305 = query.getOrDefault("visibility")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = newJString("DEFAULT"))
  if valid_589305 != nil:
    section.add "visibility", valid_589305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589307: Call_DriveFilesInsert_589286; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Insert a new file.
  ## 
  let valid = call_589307.validator(path, query, header, formData, body)
  let scheme = call_589307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589307.url(scheme.get, call_589307.host, call_589307.base,
                         call_589307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589307, url, valid)

proc call*(call_589308: Call_DriveFilesInsert_589286;
          supportsAllDrives: bool = false; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pinned: bool = false; oauthToken: string = "";
          userIp: string = ""; ocr: bool = false; timedTextLanguage: string = "";
          supportsTeamDrives: bool = false; key: string = ""; convert: bool = false;
          useContentAsIndexableText: bool = false; body: JsonNode = nil;
          prettyPrint: bool = true; ocrLanguage: string = "";
          timedTextTrackName: string = ""; visibility: string = "DEFAULT"): Recallable =
  ## driveFilesInsert
  ## Insert a new file.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   pinned: bool
  ##         : Whether to pin the head revision of the uploaded file. A file can have a maximum of 200 pinned revisions.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   ocr: bool
  ##      : Whether to attempt OCR on .jpg, .png, .gif, or .pdf uploads.
  ##   timedTextLanguage: string
  ##                    : The language of the timed text.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   convert: bool
  ##          : Whether to convert this file to the corresponding Google Docs format.
  ##   useContentAsIndexableText: bool
  ##                            : Whether to use the content as indexable text.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ocrLanguage: string
  ##              : If ocr is true, hints at the language to use. Valid values are BCP 47 codes.
  ##   timedTextTrackName: string
  ##                     : The timed text track name.
  ##   visibility: string
  ##             : The visibility of the new file. This parameter is only relevant when convert=false.
  var query_589309 = newJObject()
  var body_589310 = newJObject()
  add(query_589309, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589309, "fields", newJString(fields))
  add(query_589309, "quotaUser", newJString(quotaUser))
  add(query_589309, "alt", newJString(alt))
  add(query_589309, "pinned", newJBool(pinned))
  add(query_589309, "oauth_token", newJString(oauthToken))
  add(query_589309, "userIp", newJString(userIp))
  add(query_589309, "ocr", newJBool(ocr))
  add(query_589309, "timedTextLanguage", newJString(timedTextLanguage))
  add(query_589309, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589309, "key", newJString(key))
  add(query_589309, "convert", newJBool(convert))
  add(query_589309, "useContentAsIndexableText",
      newJBool(useContentAsIndexableText))
  if body != nil:
    body_589310 = body
  add(query_589309, "prettyPrint", newJBool(prettyPrint))
  add(query_589309, "ocrLanguage", newJString(ocrLanguage))
  add(query_589309, "timedTextTrackName", newJString(timedTextTrackName))
  add(query_589309, "visibility", newJString(visibility))
  result = call_589308.call(nil, query_589309, nil, nil, body_589310)

var driveFilesInsert* = Call_DriveFilesInsert_589286(name: "driveFilesInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/files",
    validator: validate_DriveFilesInsert_589287, base: "/drive/v2",
    url: url_DriveFilesInsert_589288, schemes: {Scheme.Https})
type
  Call_DriveFilesList_589259 = ref object of OpenApiRestCall_588457
proc url_DriveFilesList_589261(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveFilesList_589260(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists the user's files.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   driveId: JString
  ##          : ID of the shared drive to search.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Page token for files.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   includeItemsFromAllDrives: JBool
  ##                            : Deprecated - Whether both My Drive and shared drive items should be included in results. This parameter will only be effective until June 1, 2020. Afterwards shared drive items will be included in the results.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   includeTeamDriveItems: JBool
  ##                        : Deprecated use includeItemsFromAllDrives instead.
  ##   teamDriveId: JString
  ##              : Deprecated use driveId instead.
  ##   corpus: JString
  ##         : The body of items (files/documents) to which the query applies. Deprecated: use 'corpora' instead.
  ##   maxResults: JInt
  ##             : The maximum number of files to return per page. Partial or empty result pages are possible even before the end of the files list has been reached.
  ##   orderBy: JString
  ##          : A comma-separated list of sort keys. Valid keys are 'createdDate', 'folder', 'lastViewedByMeDate', 'modifiedByMeDate', 'modifiedDate', 'quotaBytesUsed', 'recency', 'sharedWithMeDate', 'starred', 'title', and 'title_natural'. Each key sorts ascending by default, but may be reversed with the 'desc' modifier. Example usage: ?orderBy=folder,modifiedDate desc,title. Please note that there is a current limitation for users with approximately one million files in which the requested sort order is ignored.
  ##   q: JString
  ##    : Query string for searching files.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   spaces: JString
  ##         : A comma-separated list of spaces to query. Supported values are 'drive', 'appDataFolder' and 'photos'.
  ##   projection: JString
  ##             : This parameter is deprecated and has no function.
  ##   corpora: JString
  ##          : Bodies of items (files/documents) to which the query applies. Supported bodies are 'default', 'domain', 'drive' and 'allDrives'. Prefer 'default' or 'drive' to 'allDrives' for efficiency.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589262 = query.getOrDefault("driveId")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "driveId", valid_589262
  var valid_589263 = query.getOrDefault("supportsAllDrives")
  valid_589263 = validateParameter(valid_589263, JBool, required = false,
                                 default = newJBool(false))
  if valid_589263 != nil:
    section.add "supportsAllDrives", valid_589263
  var valid_589264 = query.getOrDefault("fields")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "fields", valid_589264
  var valid_589265 = query.getOrDefault("pageToken")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "pageToken", valid_589265
  var valid_589266 = query.getOrDefault("quotaUser")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = nil)
  if valid_589266 != nil:
    section.add "quotaUser", valid_589266
  var valid_589267 = query.getOrDefault("alt")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = newJString("json"))
  if valid_589267 != nil:
    section.add "alt", valid_589267
  var valid_589268 = query.getOrDefault("oauth_token")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = nil)
  if valid_589268 != nil:
    section.add "oauth_token", valid_589268
  var valid_589269 = query.getOrDefault("includeItemsFromAllDrives")
  valid_589269 = validateParameter(valid_589269, JBool, required = false,
                                 default = newJBool(false))
  if valid_589269 != nil:
    section.add "includeItemsFromAllDrives", valid_589269
  var valid_589270 = query.getOrDefault("userIp")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "userIp", valid_589270
  var valid_589271 = query.getOrDefault("includeTeamDriveItems")
  valid_589271 = validateParameter(valid_589271, JBool, required = false,
                                 default = newJBool(false))
  if valid_589271 != nil:
    section.add "includeTeamDriveItems", valid_589271
  var valid_589272 = query.getOrDefault("teamDriveId")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "teamDriveId", valid_589272
  var valid_589273 = query.getOrDefault("corpus")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = newJString("DEFAULT"))
  if valid_589273 != nil:
    section.add "corpus", valid_589273
  var valid_589274 = query.getOrDefault("maxResults")
  valid_589274 = validateParameter(valid_589274, JInt, required = false,
                                 default = newJInt(100))
  if valid_589274 != nil:
    section.add "maxResults", valid_589274
  var valid_589275 = query.getOrDefault("orderBy")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "orderBy", valid_589275
  var valid_589276 = query.getOrDefault("q")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = nil)
  if valid_589276 != nil:
    section.add "q", valid_589276
  var valid_589277 = query.getOrDefault("supportsTeamDrives")
  valid_589277 = validateParameter(valid_589277, JBool, required = false,
                                 default = newJBool(false))
  if valid_589277 != nil:
    section.add "supportsTeamDrives", valid_589277
  var valid_589278 = query.getOrDefault("key")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "key", valid_589278
  var valid_589279 = query.getOrDefault("spaces")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "spaces", valid_589279
  var valid_589280 = query.getOrDefault("projection")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_589280 != nil:
    section.add "projection", valid_589280
  var valid_589281 = query.getOrDefault("corpora")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = nil)
  if valid_589281 != nil:
    section.add "corpora", valid_589281
  var valid_589282 = query.getOrDefault("prettyPrint")
  valid_589282 = validateParameter(valid_589282, JBool, required = false,
                                 default = newJBool(true))
  if valid_589282 != nil:
    section.add "prettyPrint", valid_589282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589283: Call_DriveFilesList_589259; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the user's files.
  ## 
  let valid = call_589283.validator(path, query, header, formData, body)
  let scheme = call_589283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589283.url(scheme.get, call_589283.host, call_589283.base,
                         call_589283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589283, url, valid)

proc call*(call_589284: Call_DriveFilesList_589259; driveId: string = "";
          supportsAllDrives: bool = false; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          includeItemsFromAllDrives: bool = false; userIp: string = "";
          includeTeamDriveItems: bool = false; teamDriveId: string = "";
          corpus: string = "DEFAULT"; maxResults: int = 100; orderBy: string = "";
          q: string = ""; supportsTeamDrives: bool = false; key: string = "";
          spaces: string = ""; projection: string = "BASIC"; corpora: string = "";
          prettyPrint: bool = true): Recallable =
  ## driveFilesList
  ## Lists the user's files.
  ##   driveId: string
  ##          : ID of the shared drive to search.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Page token for files.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   includeItemsFromAllDrives: bool
  ##                            : Deprecated - Whether both My Drive and shared drive items should be included in results. This parameter will only be effective until June 1, 2020. Afterwards shared drive items will be included in the results.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   includeTeamDriveItems: bool
  ##                        : Deprecated use includeItemsFromAllDrives instead.
  ##   teamDriveId: string
  ##              : Deprecated use driveId instead.
  ##   corpus: string
  ##         : The body of items (files/documents) to which the query applies. Deprecated: use 'corpora' instead.
  ##   maxResults: int
  ##             : The maximum number of files to return per page. Partial or empty result pages are possible even before the end of the files list has been reached.
  ##   orderBy: string
  ##          : A comma-separated list of sort keys. Valid keys are 'createdDate', 'folder', 'lastViewedByMeDate', 'modifiedByMeDate', 'modifiedDate', 'quotaBytesUsed', 'recency', 'sharedWithMeDate', 'starred', 'title', and 'title_natural'. Each key sorts ascending by default, but may be reversed with the 'desc' modifier. Example usage: ?orderBy=folder,modifiedDate desc,title. Please note that there is a current limitation for users with approximately one million files in which the requested sort order is ignored.
  ##   q: string
  ##    : Query string for searching files.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   spaces: string
  ##         : A comma-separated list of spaces to query. Supported values are 'drive', 'appDataFolder' and 'photos'.
  ##   projection: string
  ##             : This parameter is deprecated and has no function.
  ##   corpora: string
  ##          : Bodies of items (files/documents) to which the query applies. Supported bodies are 'default', 'domain', 'drive' and 'allDrives'. Prefer 'default' or 'drive' to 'allDrives' for efficiency.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589285 = newJObject()
  add(query_589285, "driveId", newJString(driveId))
  add(query_589285, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589285, "fields", newJString(fields))
  add(query_589285, "pageToken", newJString(pageToken))
  add(query_589285, "quotaUser", newJString(quotaUser))
  add(query_589285, "alt", newJString(alt))
  add(query_589285, "oauth_token", newJString(oauthToken))
  add(query_589285, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_589285, "userIp", newJString(userIp))
  add(query_589285, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  add(query_589285, "teamDriveId", newJString(teamDriveId))
  add(query_589285, "corpus", newJString(corpus))
  add(query_589285, "maxResults", newJInt(maxResults))
  add(query_589285, "orderBy", newJString(orderBy))
  add(query_589285, "q", newJString(q))
  add(query_589285, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589285, "key", newJString(key))
  add(query_589285, "spaces", newJString(spaces))
  add(query_589285, "projection", newJString(projection))
  add(query_589285, "corpora", newJString(corpora))
  add(query_589285, "prettyPrint", newJBool(prettyPrint))
  result = call_589284.call(nil, query_589285, nil, nil, nil)

var driveFilesList* = Call_DriveFilesList_589259(name: "driveFilesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/files",
    validator: validate_DriveFilesList_589260, base: "/drive/v2",
    url: url_DriveFilesList_589261, schemes: {Scheme.Https})
type
  Call_DriveFilesGenerateIds_589311 = ref object of OpenApiRestCall_588457
proc url_DriveFilesGenerateIds_589313(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveFilesGenerateIds_589312(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates a set of file IDs which can be provided in insert or copy requests.
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
  ##   space: JString
  ##        : The space in which the IDs can be used to create new files. Supported values are 'drive' and 'appDataFolder'.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of IDs to return.
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
  var valid_589318 = query.getOrDefault("space")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = newJString("drive"))
  if valid_589318 != nil:
    section.add "space", valid_589318
  var valid_589319 = query.getOrDefault("userIp")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = nil)
  if valid_589319 != nil:
    section.add "userIp", valid_589319
  var valid_589320 = query.getOrDefault("maxResults")
  valid_589320 = validateParameter(valid_589320, JInt, required = false,
                                 default = newJInt(10))
  if valid_589320 != nil:
    section.add "maxResults", valid_589320
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
  if body != nil:
    result.add "body", body

proc call*(call_589323: Call_DriveFilesGenerateIds_589311; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates a set of file IDs which can be provided in insert or copy requests.
  ## 
  let valid = call_589323.validator(path, query, header, formData, body)
  let scheme = call_589323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589323.url(scheme.get, call_589323.host, call_589323.base,
                         call_589323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589323, url, valid)

proc call*(call_589324: Call_DriveFilesGenerateIds_589311; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          space: string = "drive"; userIp: string = ""; maxResults: int = 10;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveFilesGenerateIds
  ## Generates a set of file IDs which can be provided in insert or copy requests.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   space: string
  ##        : The space in which the IDs can be used to create new files. Supported values are 'drive' and 'appDataFolder'.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of IDs to return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589325 = newJObject()
  add(query_589325, "fields", newJString(fields))
  add(query_589325, "quotaUser", newJString(quotaUser))
  add(query_589325, "alt", newJString(alt))
  add(query_589325, "oauth_token", newJString(oauthToken))
  add(query_589325, "space", newJString(space))
  add(query_589325, "userIp", newJString(userIp))
  add(query_589325, "maxResults", newJInt(maxResults))
  add(query_589325, "key", newJString(key))
  add(query_589325, "prettyPrint", newJBool(prettyPrint))
  result = call_589324.call(nil, query_589325, nil, nil, nil)

var driveFilesGenerateIds* = Call_DriveFilesGenerateIds_589311(
    name: "driveFilesGenerateIds", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/generateIds",
    validator: validate_DriveFilesGenerateIds_589312, base: "/drive/v2",
    url: url_DriveFilesGenerateIds_589313, schemes: {Scheme.Https})
type
  Call_DriveFilesEmptyTrash_589326 = ref object of OpenApiRestCall_588457
proc url_DriveFilesEmptyTrash_589328(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveFilesEmptyTrash_589327(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Permanently deletes all of the user's trashed files.
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
  var valid_589329 = query.getOrDefault("fields")
  valid_589329 = validateParameter(valid_589329, JString, required = false,
                                 default = nil)
  if valid_589329 != nil:
    section.add "fields", valid_589329
  var valid_589330 = query.getOrDefault("quotaUser")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = nil)
  if valid_589330 != nil:
    section.add "quotaUser", valid_589330
  var valid_589331 = query.getOrDefault("alt")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = newJString("json"))
  if valid_589331 != nil:
    section.add "alt", valid_589331
  var valid_589332 = query.getOrDefault("oauth_token")
  valid_589332 = validateParameter(valid_589332, JString, required = false,
                                 default = nil)
  if valid_589332 != nil:
    section.add "oauth_token", valid_589332
  var valid_589333 = query.getOrDefault("userIp")
  valid_589333 = validateParameter(valid_589333, JString, required = false,
                                 default = nil)
  if valid_589333 != nil:
    section.add "userIp", valid_589333
  var valid_589334 = query.getOrDefault("key")
  valid_589334 = validateParameter(valid_589334, JString, required = false,
                                 default = nil)
  if valid_589334 != nil:
    section.add "key", valid_589334
  var valid_589335 = query.getOrDefault("prettyPrint")
  valid_589335 = validateParameter(valid_589335, JBool, required = false,
                                 default = newJBool(true))
  if valid_589335 != nil:
    section.add "prettyPrint", valid_589335
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589336: Call_DriveFilesEmptyTrash_589326; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes all of the user's trashed files.
  ## 
  let valid = call_589336.validator(path, query, header, formData, body)
  let scheme = call_589336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589336.url(scheme.get, call_589336.host, call_589336.base,
                         call_589336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589336, url, valid)

proc call*(call_589337: Call_DriveFilesEmptyTrash_589326; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveFilesEmptyTrash
  ## Permanently deletes all of the user's trashed files.
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
  var query_589338 = newJObject()
  add(query_589338, "fields", newJString(fields))
  add(query_589338, "quotaUser", newJString(quotaUser))
  add(query_589338, "alt", newJString(alt))
  add(query_589338, "oauth_token", newJString(oauthToken))
  add(query_589338, "userIp", newJString(userIp))
  add(query_589338, "key", newJString(key))
  add(query_589338, "prettyPrint", newJBool(prettyPrint))
  result = call_589337.call(nil, query_589338, nil, nil, nil)

var driveFilesEmptyTrash* = Call_DriveFilesEmptyTrash_589326(
    name: "driveFilesEmptyTrash", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/trash",
    validator: validate_DriveFilesEmptyTrash_589327, base: "/drive/v2",
    url: url_DriveFilesEmptyTrash_589328, schemes: {Scheme.Https})
type
  Call_DriveFilesUpdate_589360 = ref object of OpenApiRestCall_588457
proc url_DriveFilesUpdate_589362(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveFilesUpdate_589361(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates file metadata and/or content.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589363 = path.getOrDefault("fileId")
  valid_589363 = validateParameter(valid_589363, JString, required = true,
                                 default = nil)
  if valid_589363 != nil:
    section.add "fileId", valid_589363
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   setModifiedDate: JBool
  ##                  : Whether to set the modified date using the value supplied in the request body. Setting this field to true is equivalent to modifiedDateBehavior=fromBodyOrNow, and false is equivalent to modifiedDateBehavior=now. To prevent any changes to the modified date set modifiedDateBehavior=noChange.
  ##   pinned: JBool
  ##         : Whether to pin the new revision. A file can have a maximum of 200 pinned revisions.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   ocr: JBool
  ##      : Whether to attempt OCR on .jpg, .png, .gif, or .pdf uploads.
  ##   timedTextLanguage: JString
  ##                    : The language of the timed text.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   convert: JBool
  ##          : This parameter is deprecated and has no function.
  ##   modifiedDateBehavior: JString
  ##                       : Determines the behavior in which modifiedDate is updated. This overrides setModifiedDate.
  ##   updateViewedDate: JBool
  ##                   : Whether to update the view date after successfully updating the file.
  ##   useContentAsIndexableText: JBool
  ##                            : Whether to use the content as indexable text.
  ##   addParents: JString
  ##             : Comma-separated list of parent IDs to add.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   removeParents: JString
  ##                : Comma-separated list of parent IDs to remove.
  ##   newRevision: JBool
  ##              : Whether a blob upload should create a new revision. If false, the blob data in the current head revision is replaced. If true or not set, a new blob is created as head revision, and previous unpinned revisions are preserved for a short period of time. Pinned revisions are stored indefinitely, using additional storage quota, up to a maximum of 200 revisions. For details on how revisions are retained, see the Drive Help Center.
  ##   ocrLanguage: JString
  ##              : If ocr is true, hints at the language to use. Valid values are BCP 47 codes.
  ##   timedTextTrackName: JString
  ##                     : The timed text track name.
  section = newJObject()
  var valid_589364 = query.getOrDefault("supportsAllDrives")
  valid_589364 = validateParameter(valid_589364, JBool, required = false,
                                 default = newJBool(false))
  if valid_589364 != nil:
    section.add "supportsAllDrives", valid_589364
  var valid_589365 = query.getOrDefault("fields")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = nil)
  if valid_589365 != nil:
    section.add "fields", valid_589365
  var valid_589366 = query.getOrDefault("quotaUser")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = nil)
  if valid_589366 != nil:
    section.add "quotaUser", valid_589366
  var valid_589367 = query.getOrDefault("alt")
  valid_589367 = validateParameter(valid_589367, JString, required = false,
                                 default = newJString("json"))
  if valid_589367 != nil:
    section.add "alt", valid_589367
  var valid_589368 = query.getOrDefault("setModifiedDate")
  valid_589368 = validateParameter(valid_589368, JBool, required = false,
                                 default = newJBool(false))
  if valid_589368 != nil:
    section.add "setModifiedDate", valid_589368
  var valid_589369 = query.getOrDefault("pinned")
  valid_589369 = validateParameter(valid_589369, JBool, required = false,
                                 default = newJBool(false))
  if valid_589369 != nil:
    section.add "pinned", valid_589369
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
  var valid_589372 = query.getOrDefault("ocr")
  valid_589372 = validateParameter(valid_589372, JBool, required = false,
                                 default = newJBool(false))
  if valid_589372 != nil:
    section.add "ocr", valid_589372
  var valid_589373 = query.getOrDefault("timedTextLanguage")
  valid_589373 = validateParameter(valid_589373, JString, required = false,
                                 default = nil)
  if valid_589373 != nil:
    section.add "timedTextLanguage", valid_589373
  var valid_589374 = query.getOrDefault("supportsTeamDrives")
  valid_589374 = validateParameter(valid_589374, JBool, required = false,
                                 default = newJBool(false))
  if valid_589374 != nil:
    section.add "supportsTeamDrives", valid_589374
  var valid_589375 = query.getOrDefault("key")
  valid_589375 = validateParameter(valid_589375, JString, required = false,
                                 default = nil)
  if valid_589375 != nil:
    section.add "key", valid_589375
  var valid_589376 = query.getOrDefault("convert")
  valid_589376 = validateParameter(valid_589376, JBool, required = false,
                                 default = newJBool(false))
  if valid_589376 != nil:
    section.add "convert", valid_589376
  var valid_589377 = query.getOrDefault("modifiedDateBehavior")
  valid_589377 = validateParameter(valid_589377, JString, required = false,
                                 default = newJString("fromBody"))
  if valid_589377 != nil:
    section.add "modifiedDateBehavior", valid_589377
  var valid_589378 = query.getOrDefault("updateViewedDate")
  valid_589378 = validateParameter(valid_589378, JBool, required = false,
                                 default = newJBool(true))
  if valid_589378 != nil:
    section.add "updateViewedDate", valid_589378
  var valid_589379 = query.getOrDefault("useContentAsIndexableText")
  valid_589379 = validateParameter(valid_589379, JBool, required = false,
                                 default = newJBool(false))
  if valid_589379 != nil:
    section.add "useContentAsIndexableText", valid_589379
  var valid_589380 = query.getOrDefault("addParents")
  valid_589380 = validateParameter(valid_589380, JString, required = false,
                                 default = nil)
  if valid_589380 != nil:
    section.add "addParents", valid_589380
  var valid_589381 = query.getOrDefault("prettyPrint")
  valid_589381 = validateParameter(valid_589381, JBool, required = false,
                                 default = newJBool(true))
  if valid_589381 != nil:
    section.add "prettyPrint", valid_589381
  var valid_589382 = query.getOrDefault("removeParents")
  valid_589382 = validateParameter(valid_589382, JString, required = false,
                                 default = nil)
  if valid_589382 != nil:
    section.add "removeParents", valid_589382
  var valid_589383 = query.getOrDefault("newRevision")
  valid_589383 = validateParameter(valid_589383, JBool, required = false,
                                 default = newJBool(true))
  if valid_589383 != nil:
    section.add "newRevision", valid_589383
  var valid_589384 = query.getOrDefault("ocrLanguage")
  valid_589384 = validateParameter(valid_589384, JString, required = false,
                                 default = nil)
  if valid_589384 != nil:
    section.add "ocrLanguage", valid_589384
  var valid_589385 = query.getOrDefault("timedTextTrackName")
  valid_589385 = validateParameter(valid_589385, JString, required = false,
                                 default = nil)
  if valid_589385 != nil:
    section.add "timedTextTrackName", valid_589385
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589387: Call_DriveFilesUpdate_589360; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates file metadata and/or content.
  ## 
  let valid = call_589387.validator(path, query, header, formData, body)
  let scheme = call_589387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589387.url(scheme.get, call_589387.host, call_589387.base,
                         call_589387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589387, url, valid)

proc call*(call_589388: Call_DriveFilesUpdate_589360; fileId: string;
          supportsAllDrives: bool = false; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; setModifiedDate: bool = false; pinned: bool = false;
          oauthToken: string = ""; userIp: string = ""; ocr: bool = false;
          timedTextLanguage: string = ""; supportsTeamDrives: bool = false;
          key: string = ""; convert: bool = false;
          modifiedDateBehavior: string = "fromBody"; updateViewedDate: bool = true;
          useContentAsIndexableText: bool = false; addParents: string = "";
          prettyPrint: bool = true; body: JsonNode = nil; removeParents: string = "";
          newRevision: bool = true; ocrLanguage: string = "";
          timedTextTrackName: string = ""): Recallable =
  ## driveFilesUpdate
  ## Updates file metadata and/or content.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file to update.
  ##   alt: string
  ##      : Data format for the response.
  ##   setModifiedDate: bool
  ##                  : Whether to set the modified date using the value supplied in the request body. Setting this field to true is equivalent to modifiedDateBehavior=fromBodyOrNow, and false is equivalent to modifiedDateBehavior=now. To prevent any changes to the modified date set modifiedDateBehavior=noChange.
  ##   pinned: bool
  ##         : Whether to pin the new revision. A file can have a maximum of 200 pinned revisions.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   ocr: bool
  ##      : Whether to attempt OCR on .jpg, .png, .gif, or .pdf uploads.
  ##   timedTextLanguage: string
  ##                    : The language of the timed text.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   convert: bool
  ##          : This parameter is deprecated and has no function.
  ##   modifiedDateBehavior: string
  ##                       : Determines the behavior in which modifiedDate is updated. This overrides setModifiedDate.
  ##   updateViewedDate: bool
  ##                   : Whether to update the view date after successfully updating the file.
  ##   useContentAsIndexableText: bool
  ##                            : Whether to use the content as indexable text.
  ##   addParents: string
  ##             : Comma-separated list of parent IDs to add.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   body: JObject
  ##   removeParents: string
  ##                : Comma-separated list of parent IDs to remove.
  ##   newRevision: bool
  ##              : Whether a blob upload should create a new revision. If false, the blob data in the current head revision is replaced. If true or not set, a new blob is created as head revision, and previous unpinned revisions are preserved for a short period of time. Pinned revisions are stored indefinitely, using additional storage quota, up to a maximum of 200 revisions. For details on how revisions are retained, see the Drive Help Center.
  ##   ocrLanguage: string
  ##              : If ocr is true, hints at the language to use. Valid values are BCP 47 codes.
  ##   timedTextTrackName: string
  ##                     : The timed text track name.
  var path_589389 = newJObject()
  var query_589390 = newJObject()
  var body_589391 = newJObject()
  add(query_589390, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589390, "fields", newJString(fields))
  add(query_589390, "quotaUser", newJString(quotaUser))
  add(path_589389, "fileId", newJString(fileId))
  add(query_589390, "alt", newJString(alt))
  add(query_589390, "setModifiedDate", newJBool(setModifiedDate))
  add(query_589390, "pinned", newJBool(pinned))
  add(query_589390, "oauth_token", newJString(oauthToken))
  add(query_589390, "userIp", newJString(userIp))
  add(query_589390, "ocr", newJBool(ocr))
  add(query_589390, "timedTextLanguage", newJString(timedTextLanguage))
  add(query_589390, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589390, "key", newJString(key))
  add(query_589390, "convert", newJBool(convert))
  add(query_589390, "modifiedDateBehavior", newJString(modifiedDateBehavior))
  add(query_589390, "updateViewedDate", newJBool(updateViewedDate))
  add(query_589390, "useContentAsIndexableText",
      newJBool(useContentAsIndexableText))
  add(query_589390, "addParents", newJString(addParents))
  add(query_589390, "prettyPrint", newJBool(prettyPrint))
  if body != nil:
    body_589391 = body
  add(query_589390, "removeParents", newJString(removeParents))
  add(query_589390, "newRevision", newJBool(newRevision))
  add(query_589390, "ocrLanguage", newJString(ocrLanguage))
  add(query_589390, "timedTextTrackName", newJString(timedTextTrackName))
  result = call_589388.call(path_589389, query_589390, nil, nil, body_589391)

var driveFilesUpdate* = Call_DriveFilesUpdate_589360(name: "driveFilesUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/files/{fileId}",
    validator: validate_DriveFilesUpdate_589361, base: "/drive/v2",
    url: url_DriveFilesUpdate_589362, schemes: {Scheme.Https})
type
  Call_DriveFilesGet_589339 = ref object of OpenApiRestCall_588457
proc url_DriveFilesGet_589341(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveFilesGet_589340(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a file's metadata by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID for the file in question.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589342 = path.getOrDefault("fileId")
  valid_589342 = validateParameter(valid_589342, JString, required = true,
                                 default = nil)
  if valid_589342 != nil:
    section.add "fileId", valid_589342
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   acknowledgeAbuse: JBool
  ##                   : Whether the user is acknowledging the risk of downloading known malware or other abusive files.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   updateViewedDate: JBool
  ##                   : Deprecated: Use files.update with modifiedDateBehavior=noChange, updateViewedDate=true and an empty request body.
  ##   projection: JString
  ##             : This parameter is deprecated and has no function.
  ##   revisionId: JString
  ##             : Specifies the Revision ID that should be downloaded. Ignored unless alt=media is specified.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589343 = query.getOrDefault("supportsAllDrives")
  valid_589343 = validateParameter(valid_589343, JBool, required = false,
                                 default = newJBool(false))
  if valid_589343 != nil:
    section.add "supportsAllDrives", valid_589343
  var valid_589344 = query.getOrDefault("fields")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = nil)
  if valid_589344 != nil:
    section.add "fields", valid_589344
  var valid_589345 = query.getOrDefault("quotaUser")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = nil)
  if valid_589345 != nil:
    section.add "quotaUser", valid_589345
  var valid_589346 = query.getOrDefault("alt")
  valid_589346 = validateParameter(valid_589346, JString, required = false,
                                 default = newJString("json"))
  if valid_589346 != nil:
    section.add "alt", valid_589346
  var valid_589347 = query.getOrDefault("acknowledgeAbuse")
  valid_589347 = validateParameter(valid_589347, JBool, required = false,
                                 default = newJBool(false))
  if valid_589347 != nil:
    section.add "acknowledgeAbuse", valid_589347
  var valid_589348 = query.getOrDefault("oauth_token")
  valid_589348 = validateParameter(valid_589348, JString, required = false,
                                 default = nil)
  if valid_589348 != nil:
    section.add "oauth_token", valid_589348
  var valid_589349 = query.getOrDefault("userIp")
  valid_589349 = validateParameter(valid_589349, JString, required = false,
                                 default = nil)
  if valid_589349 != nil:
    section.add "userIp", valid_589349
  var valid_589350 = query.getOrDefault("supportsTeamDrives")
  valid_589350 = validateParameter(valid_589350, JBool, required = false,
                                 default = newJBool(false))
  if valid_589350 != nil:
    section.add "supportsTeamDrives", valid_589350
  var valid_589351 = query.getOrDefault("key")
  valid_589351 = validateParameter(valid_589351, JString, required = false,
                                 default = nil)
  if valid_589351 != nil:
    section.add "key", valid_589351
  var valid_589352 = query.getOrDefault("updateViewedDate")
  valid_589352 = validateParameter(valid_589352, JBool, required = false,
                                 default = newJBool(false))
  if valid_589352 != nil:
    section.add "updateViewedDate", valid_589352
  var valid_589353 = query.getOrDefault("projection")
  valid_589353 = validateParameter(valid_589353, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_589353 != nil:
    section.add "projection", valid_589353
  var valid_589354 = query.getOrDefault("revisionId")
  valid_589354 = validateParameter(valid_589354, JString, required = false,
                                 default = nil)
  if valid_589354 != nil:
    section.add "revisionId", valid_589354
  var valid_589355 = query.getOrDefault("prettyPrint")
  valid_589355 = validateParameter(valid_589355, JBool, required = false,
                                 default = newJBool(true))
  if valid_589355 != nil:
    section.add "prettyPrint", valid_589355
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589356: Call_DriveFilesGet_589339; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a file's metadata by ID.
  ## 
  let valid = call_589356.validator(path, query, header, formData, body)
  let scheme = call_589356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589356.url(scheme.get, call_589356.host, call_589356.base,
                         call_589356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589356, url, valid)

proc call*(call_589357: Call_DriveFilesGet_589339; fileId: string;
          supportsAllDrives: bool = false; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; acknowledgeAbuse: bool = false; oauthToken: string = "";
          userIp: string = ""; supportsTeamDrives: bool = false; key: string = "";
          updateViewedDate: bool = false; projection: string = "BASIC";
          revisionId: string = ""; prettyPrint: bool = true): Recallable =
  ## driveFilesGet
  ## Gets a file's metadata by ID.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID for the file in question.
  ##   alt: string
  ##      : Data format for the response.
  ##   acknowledgeAbuse: bool
  ##                   : Whether the user is acknowledging the risk of downloading known malware or other abusive files.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   updateViewedDate: bool
  ##                   : Deprecated: Use files.update with modifiedDateBehavior=noChange, updateViewedDate=true and an empty request body.
  ##   projection: string
  ##             : This parameter is deprecated and has no function.
  ##   revisionId: string
  ##             : Specifies the Revision ID that should be downloaded. Ignored unless alt=media is specified.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589358 = newJObject()
  var query_589359 = newJObject()
  add(query_589359, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589359, "fields", newJString(fields))
  add(query_589359, "quotaUser", newJString(quotaUser))
  add(path_589358, "fileId", newJString(fileId))
  add(query_589359, "alt", newJString(alt))
  add(query_589359, "acknowledgeAbuse", newJBool(acknowledgeAbuse))
  add(query_589359, "oauth_token", newJString(oauthToken))
  add(query_589359, "userIp", newJString(userIp))
  add(query_589359, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589359, "key", newJString(key))
  add(query_589359, "updateViewedDate", newJBool(updateViewedDate))
  add(query_589359, "projection", newJString(projection))
  add(query_589359, "revisionId", newJString(revisionId))
  add(query_589359, "prettyPrint", newJBool(prettyPrint))
  result = call_589357.call(path_589358, query_589359, nil, nil, nil)

var driveFilesGet* = Call_DriveFilesGet_589339(name: "driveFilesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/files/{fileId}",
    validator: validate_DriveFilesGet_589340, base: "/drive/v2",
    url: url_DriveFilesGet_589341, schemes: {Scheme.Https})
type
  Call_DriveFilesPatch_589409 = ref object of OpenApiRestCall_588457
proc url_DriveFilesPatch_589411(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveFilesPatch_589410(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Updates file metadata and/or content. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589412 = path.getOrDefault("fileId")
  valid_589412 = validateParameter(valid_589412, JString, required = true,
                                 default = nil)
  if valid_589412 != nil:
    section.add "fileId", valid_589412
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   setModifiedDate: JBool
  ##                  : Whether to set the modified date using the value supplied in the request body. Setting this field to true is equivalent to modifiedDateBehavior=fromBodyOrNow, and false is equivalent to modifiedDateBehavior=now. To prevent any changes to the modified date set modifiedDateBehavior=noChange.
  ##   pinned: JBool
  ##         : Whether to pin the new revision. A file can have a maximum of 200 pinned revisions.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   ocr: JBool
  ##      : Whether to attempt OCR on .jpg, .png, .gif, or .pdf uploads.
  ##   timedTextLanguage: JString
  ##                    : The language of the timed text.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   convert: JBool
  ##          : This parameter is deprecated and has no function.
  ##   modifiedDateBehavior: JString
  ##                       : Determines the behavior in which modifiedDate is updated. This overrides setModifiedDate.
  ##   updateViewedDate: JBool
  ##                   : Whether to update the view date after successfully updating the file.
  ##   useContentAsIndexableText: JBool
  ##                            : Whether to use the content as indexable text.
  ##   addParents: JString
  ##             : Comma-separated list of parent IDs to add.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   removeParents: JString
  ##                : Comma-separated list of parent IDs to remove.
  ##   newRevision: JBool
  ##              : Whether a blob upload should create a new revision. If false, the blob data in the current head revision is replaced. If true or not set, a new blob is created as head revision, and previous unpinned revisions are preserved for a short period of time. Pinned revisions are stored indefinitely, using additional storage quota, up to a maximum of 200 revisions. For details on how revisions are retained, see the Drive Help Center.
  ##   ocrLanguage: JString
  ##              : If ocr is true, hints at the language to use. Valid values are BCP 47 codes.
  ##   timedTextTrackName: JString
  ##                     : The timed text track name.
  section = newJObject()
  var valid_589413 = query.getOrDefault("supportsAllDrives")
  valid_589413 = validateParameter(valid_589413, JBool, required = false,
                                 default = newJBool(false))
  if valid_589413 != nil:
    section.add "supportsAllDrives", valid_589413
  var valid_589414 = query.getOrDefault("fields")
  valid_589414 = validateParameter(valid_589414, JString, required = false,
                                 default = nil)
  if valid_589414 != nil:
    section.add "fields", valid_589414
  var valid_589415 = query.getOrDefault("quotaUser")
  valid_589415 = validateParameter(valid_589415, JString, required = false,
                                 default = nil)
  if valid_589415 != nil:
    section.add "quotaUser", valid_589415
  var valid_589416 = query.getOrDefault("alt")
  valid_589416 = validateParameter(valid_589416, JString, required = false,
                                 default = newJString("json"))
  if valid_589416 != nil:
    section.add "alt", valid_589416
  var valid_589417 = query.getOrDefault("setModifiedDate")
  valid_589417 = validateParameter(valid_589417, JBool, required = false,
                                 default = newJBool(false))
  if valid_589417 != nil:
    section.add "setModifiedDate", valid_589417
  var valid_589418 = query.getOrDefault("pinned")
  valid_589418 = validateParameter(valid_589418, JBool, required = false,
                                 default = newJBool(false))
  if valid_589418 != nil:
    section.add "pinned", valid_589418
  var valid_589419 = query.getOrDefault("oauth_token")
  valid_589419 = validateParameter(valid_589419, JString, required = false,
                                 default = nil)
  if valid_589419 != nil:
    section.add "oauth_token", valid_589419
  var valid_589420 = query.getOrDefault("userIp")
  valid_589420 = validateParameter(valid_589420, JString, required = false,
                                 default = nil)
  if valid_589420 != nil:
    section.add "userIp", valid_589420
  var valid_589421 = query.getOrDefault("ocr")
  valid_589421 = validateParameter(valid_589421, JBool, required = false,
                                 default = newJBool(false))
  if valid_589421 != nil:
    section.add "ocr", valid_589421
  var valid_589422 = query.getOrDefault("timedTextLanguage")
  valid_589422 = validateParameter(valid_589422, JString, required = false,
                                 default = nil)
  if valid_589422 != nil:
    section.add "timedTextLanguage", valid_589422
  var valid_589423 = query.getOrDefault("supportsTeamDrives")
  valid_589423 = validateParameter(valid_589423, JBool, required = false,
                                 default = newJBool(false))
  if valid_589423 != nil:
    section.add "supportsTeamDrives", valid_589423
  var valid_589424 = query.getOrDefault("key")
  valid_589424 = validateParameter(valid_589424, JString, required = false,
                                 default = nil)
  if valid_589424 != nil:
    section.add "key", valid_589424
  var valid_589425 = query.getOrDefault("convert")
  valid_589425 = validateParameter(valid_589425, JBool, required = false,
                                 default = newJBool(false))
  if valid_589425 != nil:
    section.add "convert", valid_589425
  var valid_589426 = query.getOrDefault("modifiedDateBehavior")
  valid_589426 = validateParameter(valid_589426, JString, required = false,
                                 default = newJString("fromBody"))
  if valid_589426 != nil:
    section.add "modifiedDateBehavior", valid_589426
  var valid_589427 = query.getOrDefault("updateViewedDate")
  valid_589427 = validateParameter(valid_589427, JBool, required = false,
                                 default = newJBool(true))
  if valid_589427 != nil:
    section.add "updateViewedDate", valid_589427
  var valid_589428 = query.getOrDefault("useContentAsIndexableText")
  valid_589428 = validateParameter(valid_589428, JBool, required = false,
                                 default = newJBool(false))
  if valid_589428 != nil:
    section.add "useContentAsIndexableText", valid_589428
  var valid_589429 = query.getOrDefault("addParents")
  valid_589429 = validateParameter(valid_589429, JString, required = false,
                                 default = nil)
  if valid_589429 != nil:
    section.add "addParents", valid_589429
  var valid_589430 = query.getOrDefault("prettyPrint")
  valid_589430 = validateParameter(valid_589430, JBool, required = false,
                                 default = newJBool(true))
  if valid_589430 != nil:
    section.add "prettyPrint", valid_589430
  var valid_589431 = query.getOrDefault("removeParents")
  valid_589431 = validateParameter(valid_589431, JString, required = false,
                                 default = nil)
  if valid_589431 != nil:
    section.add "removeParents", valid_589431
  var valid_589432 = query.getOrDefault("newRevision")
  valid_589432 = validateParameter(valid_589432, JBool, required = false,
                                 default = newJBool(true))
  if valid_589432 != nil:
    section.add "newRevision", valid_589432
  var valid_589433 = query.getOrDefault("ocrLanguage")
  valid_589433 = validateParameter(valid_589433, JString, required = false,
                                 default = nil)
  if valid_589433 != nil:
    section.add "ocrLanguage", valid_589433
  var valid_589434 = query.getOrDefault("timedTextTrackName")
  valid_589434 = validateParameter(valid_589434, JString, required = false,
                                 default = nil)
  if valid_589434 != nil:
    section.add "timedTextTrackName", valid_589434
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589436: Call_DriveFilesPatch_589409; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates file metadata and/or content. This method supports patch semantics.
  ## 
  let valid = call_589436.validator(path, query, header, formData, body)
  let scheme = call_589436.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589436.url(scheme.get, call_589436.host, call_589436.base,
                         call_589436.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589436, url, valid)

proc call*(call_589437: Call_DriveFilesPatch_589409; fileId: string;
          supportsAllDrives: bool = false; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; setModifiedDate: bool = false; pinned: bool = false;
          oauthToken: string = ""; userIp: string = ""; ocr: bool = false;
          timedTextLanguage: string = ""; supportsTeamDrives: bool = false;
          key: string = ""; convert: bool = false;
          modifiedDateBehavior: string = "fromBody"; updateViewedDate: bool = true;
          useContentAsIndexableText: bool = false; addParents: string = "";
          prettyPrint: bool = true; body: JsonNode = nil; removeParents: string = "";
          newRevision: bool = true; ocrLanguage: string = "";
          timedTextTrackName: string = ""): Recallable =
  ## driveFilesPatch
  ## Updates file metadata and/or content. This method supports patch semantics.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file to update.
  ##   alt: string
  ##      : Data format for the response.
  ##   setModifiedDate: bool
  ##                  : Whether to set the modified date using the value supplied in the request body. Setting this field to true is equivalent to modifiedDateBehavior=fromBodyOrNow, and false is equivalent to modifiedDateBehavior=now. To prevent any changes to the modified date set modifiedDateBehavior=noChange.
  ##   pinned: bool
  ##         : Whether to pin the new revision. A file can have a maximum of 200 pinned revisions.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   ocr: bool
  ##      : Whether to attempt OCR on .jpg, .png, .gif, or .pdf uploads.
  ##   timedTextLanguage: string
  ##                    : The language of the timed text.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   convert: bool
  ##          : This parameter is deprecated and has no function.
  ##   modifiedDateBehavior: string
  ##                       : Determines the behavior in which modifiedDate is updated. This overrides setModifiedDate.
  ##   updateViewedDate: bool
  ##                   : Whether to update the view date after successfully updating the file.
  ##   useContentAsIndexableText: bool
  ##                            : Whether to use the content as indexable text.
  ##   addParents: string
  ##             : Comma-separated list of parent IDs to add.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   body: JObject
  ##   removeParents: string
  ##                : Comma-separated list of parent IDs to remove.
  ##   newRevision: bool
  ##              : Whether a blob upload should create a new revision. If false, the blob data in the current head revision is replaced. If true or not set, a new blob is created as head revision, and previous unpinned revisions are preserved for a short period of time. Pinned revisions are stored indefinitely, using additional storage quota, up to a maximum of 200 revisions. For details on how revisions are retained, see the Drive Help Center.
  ##   ocrLanguage: string
  ##              : If ocr is true, hints at the language to use. Valid values are BCP 47 codes.
  ##   timedTextTrackName: string
  ##                     : The timed text track name.
  var path_589438 = newJObject()
  var query_589439 = newJObject()
  var body_589440 = newJObject()
  add(query_589439, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589439, "fields", newJString(fields))
  add(query_589439, "quotaUser", newJString(quotaUser))
  add(path_589438, "fileId", newJString(fileId))
  add(query_589439, "alt", newJString(alt))
  add(query_589439, "setModifiedDate", newJBool(setModifiedDate))
  add(query_589439, "pinned", newJBool(pinned))
  add(query_589439, "oauth_token", newJString(oauthToken))
  add(query_589439, "userIp", newJString(userIp))
  add(query_589439, "ocr", newJBool(ocr))
  add(query_589439, "timedTextLanguage", newJString(timedTextLanguage))
  add(query_589439, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589439, "key", newJString(key))
  add(query_589439, "convert", newJBool(convert))
  add(query_589439, "modifiedDateBehavior", newJString(modifiedDateBehavior))
  add(query_589439, "updateViewedDate", newJBool(updateViewedDate))
  add(query_589439, "useContentAsIndexableText",
      newJBool(useContentAsIndexableText))
  add(query_589439, "addParents", newJString(addParents))
  add(query_589439, "prettyPrint", newJBool(prettyPrint))
  if body != nil:
    body_589440 = body
  add(query_589439, "removeParents", newJString(removeParents))
  add(query_589439, "newRevision", newJBool(newRevision))
  add(query_589439, "ocrLanguage", newJString(ocrLanguage))
  add(query_589439, "timedTextTrackName", newJString(timedTextTrackName))
  result = call_589437.call(path_589438, query_589439, nil, nil, body_589440)

var driveFilesPatch* = Call_DriveFilesPatch_589409(name: "driveFilesPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/files/{fileId}", validator: validate_DriveFilesPatch_589410,
    base: "/drive/v2", url: url_DriveFilesPatch_589411, schemes: {Scheme.Https})
type
  Call_DriveFilesDelete_589392 = ref object of OpenApiRestCall_588457
proc url_DriveFilesDelete_589394(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveFilesDelete_589393(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Permanently deletes a file by ID. Skips the trash. The currently authenticated user must own the file or be an organizer on the parent for shared drive files.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589395 = path.getOrDefault("fileId")
  valid_589395 = validateParameter(valid_589395, JString, required = true,
                                 default = nil)
  if valid_589395 != nil:
    section.add "fileId", valid_589395
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
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
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589396 = query.getOrDefault("supportsAllDrives")
  valid_589396 = validateParameter(valid_589396, JBool, required = false,
                                 default = newJBool(false))
  if valid_589396 != nil:
    section.add "supportsAllDrives", valid_589396
  var valid_589397 = query.getOrDefault("fields")
  valid_589397 = validateParameter(valid_589397, JString, required = false,
                                 default = nil)
  if valid_589397 != nil:
    section.add "fields", valid_589397
  var valid_589398 = query.getOrDefault("quotaUser")
  valid_589398 = validateParameter(valid_589398, JString, required = false,
                                 default = nil)
  if valid_589398 != nil:
    section.add "quotaUser", valid_589398
  var valid_589399 = query.getOrDefault("alt")
  valid_589399 = validateParameter(valid_589399, JString, required = false,
                                 default = newJString("json"))
  if valid_589399 != nil:
    section.add "alt", valid_589399
  var valid_589400 = query.getOrDefault("oauth_token")
  valid_589400 = validateParameter(valid_589400, JString, required = false,
                                 default = nil)
  if valid_589400 != nil:
    section.add "oauth_token", valid_589400
  var valid_589401 = query.getOrDefault("userIp")
  valid_589401 = validateParameter(valid_589401, JString, required = false,
                                 default = nil)
  if valid_589401 != nil:
    section.add "userIp", valid_589401
  var valid_589402 = query.getOrDefault("supportsTeamDrives")
  valid_589402 = validateParameter(valid_589402, JBool, required = false,
                                 default = newJBool(false))
  if valid_589402 != nil:
    section.add "supportsTeamDrives", valid_589402
  var valid_589403 = query.getOrDefault("key")
  valid_589403 = validateParameter(valid_589403, JString, required = false,
                                 default = nil)
  if valid_589403 != nil:
    section.add "key", valid_589403
  var valid_589404 = query.getOrDefault("prettyPrint")
  valid_589404 = validateParameter(valid_589404, JBool, required = false,
                                 default = newJBool(true))
  if valid_589404 != nil:
    section.add "prettyPrint", valid_589404
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589405: Call_DriveFilesDelete_589392; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a file by ID. Skips the trash. The currently authenticated user must own the file or be an organizer on the parent for shared drive files.
  ## 
  let valid = call_589405.validator(path, query, header, formData, body)
  let scheme = call_589405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589405.url(scheme.get, call_589405.host, call_589405.base,
                         call_589405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589405, url, valid)

proc call*(call_589406: Call_DriveFilesDelete_589392; fileId: string;
          supportsAllDrives: bool = false; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          supportsTeamDrives: bool = false; key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveFilesDelete
  ## Permanently deletes a file by ID. Skips the trash. The currently authenticated user must own the file or be an organizer on the parent for shared drive files.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file to delete.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589407 = newJObject()
  var query_589408 = newJObject()
  add(query_589408, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589408, "fields", newJString(fields))
  add(query_589408, "quotaUser", newJString(quotaUser))
  add(path_589407, "fileId", newJString(fileId))
  add(query_589408, "alt", newJString(alt))
  add(query_589408, "oauth_token", newJString(oauthToken))
  add(query_589408, "userIp", newJString(userIp))
  add(query_589408, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589408, "key", newJString(key))
  add(query_589408, "prettyPrint", newJBool(prettyPrint))
  result = call_589406.call(path_589407, query_589408, nil, nil, nil)

var driveFilesDelete* = Call_DriveFilesDelete_589392(name: "driveFilesDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/files/{fileId}", validator: validate_DriveFilesDelete_589393,
    base: "/drive/v2", url: url_DriveFilesDelete_589394, schemes: {Scheme.Https})
type
  Call_DriveCommentsInsert_589460 = ref object of OpenApiRestCall_588457
proc url_DriveCommentsInsert_589462(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/comments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveCommentsInsert_589461(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates a new comment on the given file.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589463 = path.getOrDefault("fileId")
  valid_589463 = validateParameter(valid_589463, JString, required = true,
                                 default = nil)
  if valid_589463 != nil:
    section.add "fileId", valid_589463
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
  var valid_589464 = query.getOrDefault("fields")
  valid_589464 = validateParameter(valid_589464, JString, required = false,
                                 default = nil)
  if valid_589464 != nil:
    section.add "fields", valid_589464
  var valid_589465 = query.getOrDefault("quotaUser")
  valid_589465 = validateParameter(valid_589465, JString, required = false,
                                 default = nil)
  if valid_589465 != nil:
    section.add "quotaUser", valid_589465
  var valid_589466 = query.getOrDefault("alt")
  valid_589466 = validateParameter(valid_589466, JString, required = false,
                                 default = newJString("json"))
  if valid_589466 != nil:
    section.add "alt", valid_589466
  var valid_589467 = query.getOrDefault("oauth_token")
  valid_589467 = validateParameter(valid_589467, JString, required = false,
                                 default = nil)
  if valid_589467 != nil:
    section.add "oauth_token", valid_589467
  var valid_589468 = query.getOrDefault("userIp")
  valid_589468 = validateParameter(valid_589468, JString, required = false,
                                 default = nil)
  if valid_589468 != nil:
    section.add "userIp", valid_589468
  var valid_589469 = query.getOrDefault("key")
  valid_589469 = validateParameter(valid_589469, JString, required = false,
                                 default = nil)
  if valid_589469 != nil:
    section.add "key", valid_589469
  var valid_589470 = query.getOrDefault("prettyPrint")
  valid_589470 = validateParameter(valid_589470, JBool, required = false,
                                 default = newJBool(true))
  if valid_589470 != nil:
    section.add "prettyPrint", valid_589470
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589472: Call_DriveCommentsInsert_589460; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new comment on the given file.
  ## 
  let valid = call_589472.validator(path, query, header, formData, body)
  let scheme = call_589472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589472.url(scheme.get, call_589472.host, call_589472.base,
                         call_589472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589472, url, valid)

proc call*(call_589473: Call_DriveCommentsInsert_589460; fileId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## driveCommentsInsert
  ## Creates a new comment on the given file.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
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
  var path_589474 = newJObject()
  var query_589475 = newJObject()
  var body_589476 = newJObject()
  add(query_589475, "fields", newJString(fields))
  add(query_589475, "quotaUser", newJString(quotaUser))
  add(path_589474, "fileId", newJString(fileId))
  add(query_589475, "alt", newJString(alt))
  add(query_589475, "oauth_token", newJString(oauthToken))
  add(query_589475, "userIp", newJString(userIp))
  add(query_589475, "key", newJString(key))
  if body != nil:
    body_589476 = body
  add(query_589475, "prettyPrint", newJBool(prettyPrint))
  result = call_589473.call(path_589474, query_589475, nil, nil, body_589476)

var driveCommentsInsert* = Call_DriveCommentsInsert_589460(
    name: "driveCommentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/comments",
    validator: validate_DriveCommentsInsert_589461, base: "/drive/v2",
    url: url_DriveCommentsInsert_589462, schemes: {Scheme.Https})
type
  Call_DriveCommentsList_589441 = ref object of OpenApiRestCall_588457
proc url_DriveCommentsList_589443(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/comments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveCommentsList_589442(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists a file's comments.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589444 = path.getOrDefault("fileId")
  valid_589444 = validateParameter(valid_589444, JString, required = true,
                                 default = nil)
  if valid_589444 != nil:
    section.add "fileId", valid_589444
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The continuation token, used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of discussions to include in the response, used for paging.
  ##   updatedMin: JString
  ##             : Only discussions that were updated after this timestamp will be returned. Formatted as an RFC 3339 timestamp.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeDeleted: JBool
  ##                 : If set, all comments and replies, including deleted comments and replies (with content stripped) will be returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589445 = query.getOrDefault("fields")
  valid_589445 = validateParameter(valid_589445, JString, required = false,
                                 default = nil)
  if valid_589445 != nil:
    section.add "fields", valid_589445
  var valid_589446 = query.getOrDefault("pageToken")
  valid_589446 = validateParameter(valid_589446, JString, required = false,
                                 default = nil)
  if valid_589446 != nil:
    section.add "pageToken", valid_589446
  var valid_589447 = query.getOrDefault("quotaUser")
  valid_589447 = validateParameter(valid_589447, JString, required = false,
                                 default = nil)
  if valid_589447 != nil:
    section.add "quotaUser", valid_589447
  var valid_589448 = query.getOrDefault("alt")
  valid_589448 = validateParameter(valid_589448, JString, required = false,
                                 default = newJString("json"))
  if valid_589448 != nil:
    section.add "alt", valid_589448
  var valid_589449 = query.getOrDefault("oauth_token")
  valid_589449 = validateParameter(valid_589449, JString, required = false,
                                 default = nil)
  if valid_589449 != nil:
    section.add "oauth_token", valid_589449
  var valid_589450 = query.getOrDefault("userIp")
  valid_589450 = validateParameter(valid_589450, JString, required = false,
                                 default = nil)
  if valid_589450 != nil:
    section.add "userIp", valid_589450
  var valid_589451 = query.getOrDefault("maxResults")
  valid_589451 = validateParameter(valid_589451, JInt, required = false,
                                 default = newJInt(20))
  if valid_589451 != nil:
    section.add "maxResults", valid_589451
  var valid_589452 = query.getOrDefault("updatedMin")
  valid_589452 = validateParameter(valid_589452, JString, required = false,
                                 default = nil)
  if valid_589452 != nil:
    section.add "updatedMin", valid_589452
  var valid_589453 = query.getOrDefault("key")
  valid_589453 = validateParameter(valid_589453, JString, required = false,
                                 default = nil)
  if valid_589453 != nil:
    section.add "key", valid_589453
  var valid_589454 = query.getOrDefault("includeDeleted")
  valid_589454 = validateParameter(valid_589454, JBool, required = false,
                                 default = newJBool(false))
  if valid_589454 != nil:
    section.add "includeDeleted", valid_589454
  var valid_589455 = query.getOrDefault("prettyPrint")
  valid_589455 = validateParameter(valid_589455, JBool, required = false,
                                 default = newJBool(true))
  if valid_589455 != nil:
    section.add "prettyPrint", valid_589455
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589456: Call_DriveCommentsList_589441; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's comments.
  ## 
  let valid = call_589456.validator(path, query, header, formData, body)
  let scheme = call_589456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589456.url(scheme.get, call_589456.host, call_589456.base,
                         call_589456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589456, url, valid)

proc call*(call_589457: Call_DriveCommentsList_589441; fileId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 20; updatedMin: string = ""; key: string = "";
          includeDeleted: bool = false; prettyPrint: bool = true): Recallable =
  ## driveCommentsList
  ## Lists a file's comments.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The continuation token, used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of discussions to include in the response, used for paging.
  ##   updatedMin: string
  ##             : Only discussions that were updated after this timestamp will be returned. Formatted as an RFC 3339 timestamp.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeDeleted: bool
  ##                 : If set, all comments and replies, including deleted comments and replies (with content stripped) will be returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589458 = newJObject()
  var query_589459 = newJObject()
  add(query_589459, "fields", newJString(fields))
  add(query_589459, "pageToken", newJString(pageToken))
  add(query_589459, "quotaUser", newJString(quotaUser))
  add(path_589458, "fileId", newJString(fileId))
  add(query_589459, "alt", newJString(alt))
  add(query_589459, "oauth_token", newJString(oauthToken))
  add(query_589459, "userIp", newJString(userIp))
  add(query_589459, "maxResults", newJInt(maxResults))
  add(query_589459, "updatedMin", newJString(updatedMin))
  add(query_589459, "key", newJString(key))
  add(query_589459, "includeDeleted", newJBool(includeDeleted))
  add(query_589459, "prettyPrint", newJBool(prettyPrint))
  result = call_589457.call(path_589458, query_589459, nil, nil, nil)

var driveCommentsList* = Call_DriveCommentsList_589441(name: "driveCommentsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments", validator: validate_DriveCommentsList_589442,
    base: "/drive/v2", url: url_DriveCommentsList_589443, schemes: {Scheme.Https})
type
  Call_DriveCommentsUpdate_589494 = ref object of OpenApiRestCall_588457
proc url_DriveCommentsUpdate_589496(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveCommentsUpdate_589495(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates an existing comment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   commentId: JString (required)
  ##            : The ID of the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589497 = path.getOrDefault("fileId")
  valid_589497 = validateParameter(valid_589497, JString, required = true,
                                 default = nil)
  if valid_589497 != nil:
    section.add "fileId", valid_589497
  var valid_589498 = path.getOrDefault("commentId")
  valid_589498 = validateParameter(valid_589498, JString, required = true,
                                 default = nil)
  if valid_589498 != nil:
    section.add "commentId", valid_589498
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
  var valid_589499 = query.getOrDefault("fields")
  valid_589499 = validateParameter(valid_589499, JString, required = false,
                                 default = nil)
  if valid_589499 != nil:
    section.add "fields", valid_589499
  var valid_589500 = query.getOrDefault("quotaUser")
  valid_589500 = validateParameter(valid_589500, JString, required = false,
                                 default = nil)
  if valid_589500 != nil:
    section.add "quotaUser", valid_589500
  var valid_589501 = query.getOrDefault("alt")
  valid_589501 = validateParameter(valid_589501, JString, required = false,
                                 default = newJString("json"))
  if valid_589501 != nil:
    section.add "alt", valid_589501
  var valid_589502 = query.getOrDefault("oauth_token")
  valid_589502 = validateParameter(valid_589502, JString, required = false,
                                 default = nil)
  if valid_589502 != nil:
    section.add "oauth_token", valid_589502
  var valid_589503 = query.getOrDefault("userIp")
  valid_589503 = validateParameter(valid_589503, JString, required = false,
                                 default = nil)
  if valid_589503 != nil:
    section.add "userIp", valid_589503
  var valid_589504 = query.getOrDefault("key")
  valid_589504 = validateParameter(valid_589504, JString, required = false,
                                 default = nil)
  if valid_589504 != nil:
    section.add "key", valid_589504
  var valid_589505 = query.getOrDefault("prettyPrint")
  valid_589505 = validateParameter(valid_589505, JBool, required = false,
                                 default = newJBool(true))
  if valid_589505 != nil:
    section.add "prettyPrint", valid_589505
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589507: Call_DriveCommentsUpdate_589494; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing comment.
  ## 
  let valid = call_589507.validator(path, query, header, formData, body)
  let scheme = call_589507.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589507.url(scheme.get, call_589507.host, call_589507.base,
                         call_589507.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589507, url, valid)

proc call*(call_589508: Call_DriveCommentsUpdate_589494; fileId: string;
          commentId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## driveCommentsUpdate
  ## Updates an existing comment.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589509 = newJObject()
  var query_589510 = newJObject()
  var body_589511 = newJObject()
  add(query_589510, "fields", newJString(fields))
  add(query_589510, "quotaUser", newJString(quotaUser))
  add(path_589509, "fileId", newJString(fileId))
  add(query_589510, "alt", newJString(alt))
  add(query_589510, "oauth_token", newJString(oauthToken))
  add(query_589510, "userIp", newJString(userIp))
  add(query_589510, "key", newJString(key))
  add(path_589509, "commentId", newJString(commentId))
  if body != nil:
    body_589511 = body
  add(query_589510, "prettyPrint", newJBool(prettyPrint))
  result = call_589508.call(path_589509, query_589510, nil, nil, body_589511)

var driveCommentsUpdate* = Call_DriveCommentsUpdate_589494(
    name: "driveCommentsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsUpdate_589495, base: "/drive/v2",
    url: url_DriveCommentsUpdate_589496, schemes: {Scheme.Https})
type
  Call_DriveCommentsGet_589477 = ref object of OpenApiRestCall_588457
proc url_DriveCommentsGet_589479(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveCommentsGet_589478(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets a comment by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   commentId: JString (required)
  ##            : The ID of the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589480 = path.getOrDefault("fileId")
  valid_589480 = validateParameter(valid_589480, JString, required = true,
                                 default = nil)
  if valid_589480 != nil:
    section.add "fileId", valid_589480
  var valid_589481 = path.getOrDefault("commentId")
  valid_589481 = validateParameter(valid_589481, JString, required = true,
                                 default = nil)
  if valid_589481 != nil:
    section.add "commentId", valid_589481
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
  ##   includeDeleted: JBool
  ##                 : If set, this will succeed when retrieving a deleted comment, and will include any deleted replies.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589482 = query.getOrDefault("fields")
  valid_589482 = validateParameter(valid_589482, JString, required = false,
                                 default = nil)
  if valid_589482 != nil:
    section.add "fields", valid_589482
  var valid_589483 = query.getOrDefault("quotaUser")
  valid_589483 = validateParameter(valid_589483, JString, required = false,
                                 default = nil)
  if valid_589483 != nil:
    section.add "quotaUser", valid_589483
  var valid_589484 = query.getOrDefault("alt")
  valid_589484 = validateParameter(valid_589484, JString, required = false,
                                 default = newJString("json"))
  if valid_589484 != nil:
    section.add "alt", valid_589484
  var valid_589485 = query.getOrDefault("oauth_token")
  valid_589485 = validateParameter(valid_589485, JString, required = false,
                                 default = nil)
  if valid_589485 != nil:
    section.add "oauth_token", valid_589485
  var valid_589486 = query.getOrDefault("userIp")
  valid_589486 = validateParameter(valid_589486, JString, required = false,
                                 default = nil)
  if valid_589486 != nil:
    section.add "userIp", valid_589486
  var valid_589487 = query.getOrDefault("key")
  valid_589487 = validateParameter(valid_589487, JString, required = false,
                                 default = nil)
  if valid_589487 != nil:
    section.add "key", valid_589487
  var valid_589488 = query.getOrDefault("includeDeleted")
  valid_589488 = validateParameter(valid_589488, JBool, required = false,
                                 default = newJBool(false))
  if valid_589488 != nil:
    section.add "includeDeleted", valid_589488
  var valid_589489 = query.getOrDefault("prettyPrint")
  valid_589489 = validateParameter(valid_589489, JBool, required = false,
                                 default = newJBool(true))
  if valid_589489 != nil:
    section.add "prettyPrint", valid_589489
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589490: Call_DriveCommentsGet_589477; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a comment by ID.
  ## 
  let valid = call_589490.validator(path, query, header, formData, body)
  let scheme = call_589490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589490.url(scheme.get, call_589490.host, call_589490.base,
                         call_589490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589490, url, valid)

proc call*(call_589491: Call_DriveCommentsGet_589477; fileId: string;
          commentId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; includeDeleted: bool = false; prettyPrint: bool = true): Recallable =
  ## driveCommentsGet
  ## Gets a comment by ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   includeDeleted: bool
  ##                 : If set, this will succeed when retrieving a deleted comment, and will include any deleted replies.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589492 = newJObject()
  var query_589493 = newJObject()
  add(query_589493, "fields", newJString(fields))
  add(query_589493, "quotaUser", newJString(quotaUser))
  add(path_589492, "fileId", newJString(fileId))
  add(query_589493, "alt", newJString(alt))
  add(query_589493, "oauth_token", newJString(oauthToken))
  add(query_589493, "userIp", newJString(userIp))
  add(query_589493, "key", newJString(key))
  add(path_589492, "commentId", newJString(commentId))
  add(query_589493, "includeDeleted", newJBool(includeDeleted))
  add(query_589493, "prettyPrint", newJBool(prettyPrint))
  result = call_589491.call(path_589492, query_589493, nil, nil, nil)

var driveCommentsGet* = Call_DriveCommentsGet_589477(name: "driveCommentsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsGet_589478, base: "/drive/v2",
    url: url_DriveCommentsGet_589479, schemes: {Scheme.Https})
type
  Call_DriveCommentsPatch_589528 = ref object of OpenApiRestCall_588457
proc url_DriveCommentsPatch_589530(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveCommentsPatch_589529(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates an existing comment. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   commentId: JString (required)
  ##            : The ID of the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589531 = path.getOrDefault("fileId")
  valid_589531 = validateParameter(valid_589531, JString, required = true,
                                 default = nil)
  if valid_589531 != nil:
    section.add "fileId", valid_589531
  var valid_589532 = path.getOrDefault("commentId")
  valid_589532 = validateParameter(valid_589532, JString, required = true,
                                 default = nil)
  if valid_589532 != nil:
    section.add "commentId", valid_589532
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
  var valid_589533 = query.getOrDefault("fields")
  valid_589533 = validateParameter(valid_589533, JString, required = false,
                                 default = nil)
  if valid_589533 != nil:
    section.add "fields", valid_589533
  var valid_589534 = query.getOrDefault("quotaUser")
  valid_589534 = validateParameter(valid_589534, JString, required = false,
                                 default = nil)
  if valid_589534 != nil:
    section.add "quotaUser", valid_589534
  var valid_589535 = query.getOrDefault("alt")
  valid_589535 = validateParameter(valid_589535, JString, required = false,
                                 default = newJString("json"))
  if valid_589535 != nil:
    section.add "alt", valid_589535
  var valid_589536 = query.getOrDefault("oauth_token")
  valid_589536 = validateParameter(valid_589536, JString, required = false,
                                 default = nil)
  if valid_589536 != nil:
    section.add "oauth_token", valid_589536
  var valid_589537 = query.getOrDefault("userIp")
  valid_589537 = validateParameter(valid_589537, JString, required = false,
                                 default = nil)
  if valid_589537 != nil:
    section.add "userIp", valid_589537
  var valid_589538 = query.getOrDefault("key")
  valid_589538 = validateParameter(valid_589538, JString, required = false,
                                 default = nil)
  if valid_589538 != nil:
    section.add "key", valid_589538
  var valid_589539 = query.getOrDefault("prettyPrint")
  valid_589539 = validateParameter(valid_589539, JBool, required = false,
                                 default = newJBool(true))
  if valid_589539 != nil:
    section.add "prettyPrint", valid_589539
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589541: Call_DriveCommentsPatch_589528; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing comment. This method supports patch semantics.
  ## 
  let valid = call_589541.validator(path, query, header, formData, body)
  let scheme = call_589541.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589541.url(scheme.get, call_589541.host, call_589541.base,
                         call_589541.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589541, url, valid)

proc call*(call_589542: Call_DriveCommentsPatch_589528; fileId: string;
          commentId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## driveCommentsPatch
  ## Updates an existing comment. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589543 = newJObject()
  var query_589544 = newJObject()
  var body_589545 = newJObject()
  add(query_589544, "fields", newJString(fields))
  add(query_589544, "quotaUser", newJString(quotaUser))
  add(path_589543, "fileId", newJString(fileId))
  add(query_589544, "alt", newJString(alt))
  add(query_589544, "oauth_token", newJString(oauthToken))
  add(query_589544, "userIp", newJString(userIp))
  add(query_589544, "key", newJString(key))
  add(path_589543, "commentId", newJString(commentId))
  if body != nil:
    body_589545 = body
  add(query_589544, "prettyPrint", newJBool(prettyPrint))
  result = call_589542.call(path_589543, query_589544, nil, nil, body_589545)

var driveCommentsPatch* = Call_DriveCommentsPatch_589528(
    name: "driveCommentsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsPatch_589529, base: "/drive/v2",
    url: url_DriveCommentsPatch_589530, schemes: {Scheme.Https})
type
  Call_DriveCommentsDelete_589512 = ref object of OpenApiRestCall_588457
proc url_DriveCommentsDelete_589514(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveCommentsDelete_589513(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a comment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   commentId: JString (required)
  ##            : The ID of the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589515 = path.getOrDefault("fileId")
  valid_589515 = validateParameter(valid_589515, JString, required = true,
                                 default = nil)
  if valid_589515 != nil:
    section.add "fileId", valid_589515
  var valid_589516 = path.getOrDefault("commentId")
  valid_589516 = validateParameter(valid_589516, JString, required = true,
                                 default = nil)
  if valid_589516 != nil:
    section.add "commentId", valid_589516
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
  var valid_589517 = query.getOrDefault("fields")
  valid_589517 = validateParameter(valid_589517, JString, required = false,
                                 default = nil)
  if valid_589517 != nil:
    section.add "fields", valid_589517
  var valid_589518 = query.getOrDefault("quotaUser")
  valid_589518 = validateParameter(valid_589518, JString, required = false,
                                 default = nil)
  if valid_589518 != nil:
    section.add "quotaUser", valid_589518
  var valid_589519 = query.getOrDefault("alt")
  valid_589519 = validateParameter(valid_589519, JString, required = false,
                                 default = newJString("json"))
  if valid_589519 != nil:
    section.add "alt", valid_589519
  var valid_589520 = query.getOrDefault("oauth_token")
  valid_589520 = validateParameter(valid_589520, JString, required = false,
                                 default = nil)
  if valid_589520 != nil:
    section.add "oauth_token", valid_589520
  var valid_589521 = query.getOrDefault("userIp")
  valid_589521 = validateParameter(valid_589521, JString, required = false,
                                 default = nil)
  if valid_589521 != nil:
    section.add "userIp", valid_589521
  var valid_589522 = query.getOrDefault("key")
  valid_589522 = validateParameter(valid_589522, JString, required = false,
                                 default = nil)
  if valid_589522 != nil:
    section.add "key", valid_589522
  var valid_589523 = query.getOrDefault("prettyPrint")
  valid_589523 = validateParameter(valid_589523, JBool, required = false,
                                 default = newJBool(true))
  if valid_589523 != nil:
    section.add "prettyPrint", valid_589523
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589524: Call_DriveCommentsDelete_589512; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a comment.
  ## 
  let valid = call_589524.validator(path, query, header, formData, body)
  let scheme = call_589524.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589524.url(scheme.get, call_589524.host, call_589524.base,
                         call_589524.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589524, url, valid)

proc call*(call_589525: Call_DriveCommentsDelete_589512; fileId: string;
          commentId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveCommentsDelete
  ## Deletes a comment.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589526 = newJObject()
  var query_589527 = newJObject()
  add(query_589527, "fields", newJString(fields))
  add(query_589527, "quotaUser", newJString(quotaUser))
  add(path_589526, "fileId", newJString(fileId))
  add(query_589527, "alt", newJString(alt))
  add(query_589527, "oauth_token", newJString(oauthToken))
  add(query_589527, "userIp", newJString(userIp))
  add(query_589527, "key", newJString(key))
  add(path_589526, "commentId", newJString(commentId))
  add(query_589527, "prettyPrint", newJBool(prettyPrint))
  result = call_589525.call(path_589526, query_589527, nil, nil, nil)

var driveCommentsDelete* = Call_DriveCommentsDelete_589512(
    name: "driveCommentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsDelete_589513, base: "/drive/v2",
    url: url_DriveCommentsDelete_589514, schemes: {Scheme.Https})
type
  Call_DriveRepliesInsert_589565 = ref object of OpenApiRestCall_588457
proc url_DriveRepliesInsert_589567(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId"),
               (kind: ConstantSegment, value: "/replies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveRepliesInsert_589566(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates a new reply to the given comment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   commentId: JString (required)
  ##            : The ID of the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589568 = path.getOrDefault("fileId")
  valid_589568 = validateParameter(valid_589568, JString, required = true,
                                 default = nil)
  if valid_589568 != nil:
    section.add "fileId", valid_589568
  var valid_589569 = path.getOrDefault("commentId")
  valid_589569 = validateParameter(valid_589569, JString, required = true,
                                 default = nil)
  if valid_589569 != nil:
    section.add "commentId", valid_589569
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
  var valid_589570 = query.getOrDefault("fields")
  valid_589570 = validateParameter(valid_589570, JString, required = false,
                                 default = nil)
  if valid_589570 != nil:
    section.add "fields", valid_589570
  var valid_589571 = query.getOrDefault("quotaUser")
  valid_589571 = validateParameter(valid_589571, JString, required = false,
                                 default = nil)
  if valid_589571 != nil:
    section.add "quotaUser", valid_589571
  var valid_589572 = query.getOrDefault("alt")
  valid_589572 = validateParameter(valid_589572, JString, required = false,
                                 default = newJString("json"))
  if valid_589572 != nil:
    section.add "alt", valid_589572
  var valid_589573 = query.getOrDefault("oauth_token")
  valid_589573 = validateParameter(valid_589573, JString, required = false,
                                 default = nil)
  if valid_589573 != nil:
    section.add "oauth_token", valid_589573
  var valid_589574 = query.getOrDefault("userIp")
  valid_589574 = validateParameter(valid_589574, JString, required = false,
                                 default = nil)
  if valid_589574 != nil:
    section.add "userIp", valid_589574
  var valid_589575 = query.getOrDefault("key")
  valid_589575 = validateParameter(valid_589575, JString, required = false,
                                 default = nil)
  if valid_589575 != nil:
    section.add "key", valid_589575
  var valid_589576 = query.getOrDefault("prettyPrint")
  valid_589576 = validateParameter(valid_589576, JBool, required = false,
                                 default = newJBool(true))
  if valid_589576 != nil:
    section.add "prettyPrint", valid_589576
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589578: Call_DriveRepliesInsert_589565; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new reply to the given comment.
  ## 
  let valid = call_589578.validator(path, query, header, formData, body)
  let scheme = call_589578.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589578.url(scheme.get, call_589578.host, call_589578.base,
                         call_589578.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589578, url, valid)

proc call*(call_589579: Call_DriveRepliesInsert_589565; fileId: string;
          commentId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## driveRepliesInsert
  ## Creates a new reply to the given comment.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589580 = newJObject()
  var query_589581 = newJObject()
  var body_589582 = newJObject()
  add(query_589581, "fields", newJString(fields))
  add(query_589581, "quotaUser", newJString(quotaUser))
  add(path_589580, "fileId", newJString(fileId))
  add(query_589581, "alt", newJString(alt))
  add(query_589581, "oauth_token", newJString(oauthToken))
  add(query_589581, "userIp", newJString(userIp))
  add(query_589581, "key", newJString(key))
  add(path_589580, "commentId", newJString(commentId))
  if body != nil:
    body_589582 = body
  add(query_589581, "prettyPrint", newJBool(prettyPrint))
  result = call_589579.call(path_589580, query_589581, nil, nil, body_589582)

var driveRepliesInsert* = Call_DriveRepliesInsert_589565(
    name: "driveRepliesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies",
    validator: validate_DriveRepliesInsert_589566, base: "/drive/v2",
    url: url_DriveRepliesInsert_589567, schemes: {Scheme.Https})
type
  Call_DriveRepliesList_589546 = ref object of OpenApiRestCall_588457
proc url_DriveRepliesList_589548(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId"),
               (kind: ConstantSegment, value: "/replies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveRepliesList_589547(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists all of the replies to a comment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   commentId: JString (required)
  ##            : The ID of the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589549 = path.getOrDefault("fileId")
  valid_589549 = validateParameter(valid_589549, JString, required = true,
                                 default = nil)
  if valid_589549 != nil:
    section.add "fileId", valid_589549
  var valid_589550 = path.getOrDefault("commentId")
  valid_589550 = validateParameter(valid_589550, JString, required = true,
                                 default = nil)
  if valid_589550 != nil:
    section.add "commentId", valid_589550
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The continuation token, used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of replies to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeDeleted: JBool
  ##                 : If set, all replies, including deleted replies (with content stripped) will be returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589551 = query.getOrDefault("fields")
  valid_589551 = validateParameter(valid_589551, JString, required = false,
                                 default = nil)
  if valid_589551 != nil:
    section.add "fields", valid_589551
  var valid_589552 = query.getOrDefault("pageToken")
  valid_589552 = validateParameter(valid_589552, JString, required = false,
                                 default = nil)
  if valid_589552 != nil:
    section.add "pageToken", valid_589552
  var valid_589553 = query.getOrDefault("quotaUser")
  valid_589553 = validateParameter(valid_589553, JString, required = false,
                                 default = nil)
  if valid_589553 != nil:
    section.add "quotaUser", valid_589553
  var valid_589554 = query.getOrDefault("alt")
  valid_589554 = validateParameter(valid_589554, JString, required = false,
                                 default = newJString("json"))
  if valid_589554 != nil:
    section.add "alt", valid_589554
  var valid_589555 = query.getOrDefault("oauth_token")
  valid_589555 = validateParameter(valid_589555, JString, required = false,
                                 default = nil)
  if valid_589555 != nil:
    section.add "oauth_token", valid_589555
  var valid_589556 = query.getOrDefault("userIp")
  valid_589556 = validateParameter(valid_589556, JString, required = false,
                                 default = nil)
  if valid_589556 != nil:
    section.add "userIp", valid_589556
  var valid_589557 = query.getOrDefault("maxResults")
  valid_589557 = validateParameter(valid_589557, JInt, required = false,
                                 default = newJInt(20))
  if valid_589557 != nil:
    section.add "maxResults", valid_589557
  var valid_589558 = query.getOrDefault("key")
  valid_589558 = validateParameter(valid_589558, JString, required = false,
                                 default = nil)
  if valid_589558 != nil:
    section.add "key", valid_589558
  var valid_589559 = query.getOrDefault("includeDeleted")
  valid_589559 = validateParameter(valid_589559, JBool, required = false,
                                 default = newJBool(false))
  if valid_589559 != nil:
    section.add "includeDeleted", valid_589559
  var valid_589560 = query.getOrDefault("prettyPrint")
  valid_589560 = validateParameter(valid_589560, JBool, required = false,
                                 default = newJBool(true))
  if valid_589560 != nil:
    section.add "prettyPrint", valid_589560
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589561: Call_DriveRepliesList_589546; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the replies to a comment.
  ## 
  let valid = call_589561.validator(path, query, header, formData, body)
  let scheme = call_589561.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589561.url(scheme.get, call_589561.host, call_589561.base,
                         call_589561.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589561, url, valid)

proc call*(call_589562: Call_DriveRepliesList_589546; fileId: string;
          commentId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 20; key: string = "";
          includeDeleted: bool = false; prettyPrint: bool = true): Recallable =
  ## driveRepliesList
  ## Lists all of the replies to a comment.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The continuation token, used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of replies to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   includeDeleted: bool
  ##                 : If set, all replies, including deleted replies (with content stripped) will be returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589563 = newJObject()
  var query_589564 = newJObject()
  add(query_589564, "fields", newJString(fields))
  add(query_589564, "pageToken", newJString(pageToken))
  add(query_589564, "quotaUser", newJString(quotaUser))
  add(path_589563, "fileId", newJString(fileId))
  add(query_589564, "alt", newJString(alt))
  add(query_589564, "oauth_token", newJString(oauthToken))
  add(query_589564, "userIp", newJString(userIp))
  add(query_589564, "maxResults", newJInt(maxResults))
  add(query_589564, "key", newJString(key))
  add(path_589563, "commentId", newJString(commentId))
  add(query_589564, "includeDeleted", newJBool(includeDeleted))
  add(query_589564, "prettyPrint", newJBool(prettyPrint))
  result = call_589562.call(path_589563, query_589564, nil, nil, nil)

var driveRepliesList* = Call_DriveRepliesList_589546(name: "driveRepliesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies",
    validator: validate_DriveRepliesList_589547, base: "/drive/v2",
    url: url_DriveRepliesList_589548, schemes: {Scheme.Https})
type
  Call_DriveRepliesUpdate_589601 = ref object of OpenApiRestCall_588457
proc url_DriveRepliesUpdate_589603(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  assert "replyId" in path, "`replyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId"),
               (kind: ConstantSegment, value: "/replies/"),
               (kind: VariableSegment, value: "replyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveRepliesUpdate_589602(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates an existing reply.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   replyId: JString (required)
  ##          : The ID of the reply.
  ##   commentId: JString (required)
  ##            : The ID of the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589604 = path.getOrDefault("fileId")
  valid_589604 = validateParameter(valid_589604, JString, required = true,
                                 default = nil)
  if valid_589604 != nil:
    section.add "fileId", valid_589604
  var valid_589605 = path.getOrDefault("replyId")
  valid_589605 = validateParameter(valid_589605, JString, required = true,
                                 default = nil)
  if valid_589605 != nil:
    section.add "replyId", valid_589605
  var valid_589606 = path.getOrDefault("commentId")
  valid_589606 = validateParameter(valid_589606, JString, required = true,
                                 default = nil)
  if valid_589606 != nil:
    section.add "commentId", valid_589606
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
  var valid_589607 = query.getOrDefault("fields")
  valid_589607 = validateParameter(valid_589607, JString, required = false,
                                 default = nil)
  if valid_589607 != nil:
    section.add "fields", valid_589607
  var valid_589608 = query.getOrDefault("quotaUser")
  valid_589608 = validateParameter(valid_589608, JString, required = false,
                                 default = nil)
  if valid_589608 != nil:
    section.add "quotaUser", valid_589608
  var valid_589609 = query.getOrDefault("alt")
  valid_589609 = validateParameter(valid_589609, JString, required = false,
                                 default = newJString("json"))
  if valid_589609 != nil:
    section.add "alt", valid_589609
  var valid_589610 = query.getOrDefault("oauth_token")
  valid_589610 = validateParameter(valid_589610, JString, required = false,
                                 default = nil)
  if valid_589610 != nil:
    section.add "oauth_token", valid_589610
  var valid_589611 = query.getOrDefault("userIp")
  valid_589611 = validateParameter(valid_589611, JString, required = false,
                                 default = nil)
  if valid_589611 != nil:
    section.add "userIp", valid_589611
  var valid_589612 = query.getOrDefault("key")
  valid_589612 = validateParameter(valid_589612, JString, required = false,
                                 default = nil)
  if valid_589612 != nil:
    section.add "key", valid_589612
  var valid_589613 = query.getOrDefault("prettyPrint")
  valid_589613 = validateParameter(valid_589613, JBool, required = false,
                                 default = newJBool(true))
  if valid_589613 != nil:
    section.add "prettyPrint", valid_589613
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589615: Call_DriveRepliesUpdate_589601; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing reply.
  ## 
  let valid = call_589615.validator(path, query, header, formData, body)
  let scheme = call_589615.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589615.url(scheme.get, call_589615.host, call_589615.base,
                         call_589615.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589615, url, valid)

proc call*(call_589616: Call_DriveRepliesUpdate_589601; fileId: string;
          replyId: string; commentId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## driveRepliesUpdate
  ## Updates an existing reply.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   replyId: string (required)
  ##          : The ID of the reply.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589617 = newJObject()
  var query_589618 = newJObject()
  var body_589619 = newJObject()
  add(query_589618, "fields", newJString(fields))
  add(query_589618, "quotaUser", newJString(quotaUser))
  add(path_589617, "fileId", newJString(fileId))
  add(query_589618, "alt", newJString(alt))
  add(query_589618, "oauth_token", newJString(oauthToken))
  add(query_589618, "userIp", newJString(userIp))
  add(query_589618, "key", newJString(key))
  add(path_589617, "replyId", newJString(replyId))
  add(path_589617, "commentId", newJString(commentId))
  if body != nil:
    body_589619 = body
  add(query_589618, "prettyPrint", newJBool(prettyPrint))
  result = call_589616.call(path_589617, query_589618, nil, nil, body_589619)

var driveRepliesUpdate* = Call_DriveRepliesUpdate_589601(
    name: "driveRepliesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesUpdate_589602, base: "/drive/v2",
    url: url_DriveRepliesUpdate_589603, schemes: {Scheme.Https})
type
  Call_DriveRepliesGet_589583 = ref object of OpenApiRestCall_588457
proc url_DriveRepliesGet_589585(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  assert "replyId" in path, "`replyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId"),
               (kind: ConstantSegment, value: "/replies/"),
               (kind: VariableSegment, value: "replyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveRepliesGet_589584(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets a reply.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   replyId: JString (required)
  ##          : The ID of the reply.
  ##   commentId: JString (required)
  ##            : The ID of the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589586 = path.getOrDefault("fileId")
  valid_589586 = validateParameter(valid_589586, JString, required = true,
                                 default = nil)
  if valid_589586 != nil:
    section.add "fileId", valid_589586
  var valid_589587 = path.getOrDefault("replyId")
  valid_589587 = validateParameter(valid_589587, JString, required = true,
                                 default = nil)
  if valid_589587 != nil:
    section.add "replyId", valid_589587
  var valid_589588 = path.getOrDefault("commentId")
  valid_589588 = validateParameter(valid_589588, JString, required = true,
                                 default = nil)
  if valid_589588 != nil:
    section.add "commentId", valid_589588
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
  ##   includeDeleted: JBool
  ##                 : If set, this will succeed when retrieving a deleted reply.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589589 = query.getOrDefault("fields")
  valid_589589 = validateParameter(valid_589589, JString, required = false,
                                 default = nil)
  if valid_589589 != nil:
    section.add "fields", valid_589589
  var valid_589590 = query.getOrDefault("quotaUser")
  valid_589590 = validateParameter(valid_589590, JString, required = false,
                                 default = nil)
  if valid_589590 != nil:
    section.add "quotaUser", valid_589590
  var valid_589591 = query.getOrDefault("alt")
  valid_589591 = validateParameter(valid_589591, JString, required = false,
                                 default = newJString("json"))
  if valid_589591 != nil:
    section.add "alt", valid_589591
  var valid_589592 = query.getOrDefault("oauth_token")
  valid_589592 = validateParameter(valid_589592, JString, required = false,
                                 default = nil)
  if valid_589592 != nil:
    section.add "oauth_token", valid_589592
  var valid_589593 = query.getOrDefault("userIp")
  valid_589593 = validateParameter(valid_589593, JString, required = false,
                                 default = nil)
  if valid_589593 != nil:
    section.add "userIp", valid_589593
  var valid_589594 = query.getOrDefault("key")
  valid_589594 = validateParameter(valid_589594, JString, required = false,
                                 default = nil)
  if valid_589594 != nil:
    section.add "key", valid_589594
  var valid_589595 = query.getOrDefault("includeDeleted")
  valid_589595 = validateParameter(valid_589595, JBool, required = false,
                                 default = newJBool(false))
  if valid_589595 != nil:
    section.add "includeDeleted", valid_589595
  var valid_589596 = query.getOrDefault("prettyPrint")
  valid_589596 = validateParameter(valid_589596, JBool, required = false,
                                 default = newJBool(true))
  if valid_589596 != nil:
    section.add "prettyPrint", valid_589596
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589597: Call_DriveRepliesGet_589583; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a reply.
  ## 
  let valid = call_589597.validator(path, query, header, formData, body)
  let scheme = call_589597.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589597.url(scheme.get, call_589597.host, call_589597.base,
                         call_589597.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589597, url, valid)

proc call*(call_589598: Call_DriveRepliesGet_589583; fileId: string; replyId: string;
          commentId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; includeDeleted: bool = false; prettyPrint: bool = true): Recallable =
  ## driveRepliesGet
  ## Gets a reply.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   replyId: string (required)
  ##          : The ID of the reply.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   includeDeleted: bool
  ##                 : If set, this will succeed when retrieving a deleted reply.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589599 = newJObject()
  var query_589600 = newJObject()
  add(query_589600, "fields", newJString(fields))
  add(query_589600, "quotaUser", newJString(quotaUser))
  add(path_589599, "fileId", newJString(fileId))
  add(query_589600, "alt", newJString(alt))
  add(query_589600, "oauth_token", newJString(oauthToken))
  add(query_589600, "userIp", newJString(userIp))
  add(query_589600, "key", newJString(key))
  add(path_589599, "replyId", newJString(replyId))
  add(path_589599, "commentId", newJString(commentId))
  add(query_589600, "includeDeleted", newJBool(includeDeleted))
  add(query_589600, "prettyPrint", newJBool(prettyPrint))
  result = call_589598.call(path_589599, query_589600, nil, nil, nil)

var driveRepliesGet* = Call_DriveRepliesGet_589583(name: "driveRepliesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesGet_589584, base: "/drive/v2",
    url: url_DriveRepliesGet_589585, schemes: {Scheme.Https})
type
  Call_DriveRepliesPatch_589637 = ref object of OpenApiRestCall_588457
proc url_DriveRepliesPatch_589639(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  assert "replyId" in path, "`replyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId"),
               (kind: ConstantSegment, value: "/replies/"),
               (kind: VariableSegment, value: "replyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveRepliesPatch_589638(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates an existing reply. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   replyId: JString (required)
  ##          : The ID of the reply.
  ##   commentId: JString (required)
  ##            : The ID of the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589640 = path.getOrDefault("fileId")
  valid_589640 = validateParameter(valid_589640, JString, required = true,
                                 default = nil)
  if valid_589640 != nil:
    section.add "fileId", valid_589640
  var valid_589641 = path.getOrDefault("replyId")
  valid_589641 = validateParameter(valid_589641, JString, required = true,
                                 default = nil)
  if valid_589641 != nil:
    section.add "replyId", valid_589641
  var valid_589642 = path.getOrDefault("commentId")
  valid_589642 = validateParameter(valid_589642, JString, required = true,
                                 default = nil)
  if valid_589642 != nil:
    section.add "commentId", valid_589642
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
  var valid_589643 = query.getOrDefault("fields")
  valid_589643 = validateParameter(valid_589643, JString, required = false,
                                 default = nil)
  if valid_589643 != nil:
    section.add "fields", valid_589643
  var valid_589644 = query.getOrDefault("quotaUser")
  valid_589644 = validateParameter(valid_589644, JString, required = false,
                                 default = nil)
  if valid_589644 != nil:
    section.add "quotaUser", valid_589644
  var valid_589645 = query.getOrDefault("alt")
  valid_589645 = validateParameter(valid_589645, JString, required = false,
                                 default = newJString("json"))
  if valid_589645 != nil:
    section.add "alt", valid_589645
  var valid_589646 = query.getOrDefault("oauth_token")
  valid_589646 = validateParameter(valid_589646, JString, required = false,
                                 default = nil)
  if valid_589646 != nil:
    section.add "oauth_token", valid_589646
  var valid_589647 = query.getOrDefault("userIp")
  valid_589647 = validateParameter(valid_589647, JString, required = false,
                                 default = nil)
  if valid_589647 != nil:
    section.add "userIp", valid_589647
  var valid_589648 = query.getOrDefault("key")
  valid_589648 = validateParameter(valid_589648, JString, required = false,
                                 default = nil)
  if valid_589648 != nil:
    section.add "key", valid_589648
  var valid_589649 = query.getOrDefault("prettyPrint")
  valid_589649 = validateParameter(valid_589649, JBool, required = false,
                                 default = newJBool(true))
  if valid_589649 != nil:
    section.add "prettyPrint", valid_589649
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589651: Call_DriveRepliesPatch_589637; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing reply. This method supports patch semantics.
  ## 
  let valid = call_589651.validator(path, query, header, formData, body)
  let scheme = call_589651.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589651.url(scheme.get, call_589651.host, call_589651.base,
                         call_589651.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589651, url, valid)

proc call*(call_589652: Call_DriveRepliesPatch_589637; fileId: string;
          replyId: string; commentId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## driveRepliesPatch
  ## Updates an existing reply. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   replyId: string (required)
  ##          : The ID of the reply.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589653 = newJObject()
  var query_589654 = newJObject()
  var body_589655 = newJObject()
  add(query_589654, "fields", newJString(fields))
  add(query_589654, "quotaUser", newJString(quotaUser))
  add(path_589653, "fileId", newJString(fileId))
  add(query_589654, "alt", newJString(alt))
  add(query_589654, "oauth_token", newJString(oauthToken))
  add(query_589654, "userIp", newJString(userIp))
  add(query_589654, "key", newJString(key))
  add(path_589653, "replyId", newJString(replyId))
  add(path_589653, "commentId", newJString(commentId))
  if body != nil:
    body_589655 = body
  add(query_589654, "prettyPrint", newJBool(prettyPrint))
  result = call_589652.call(path_589653, query_589654, nil, nil, body_589655)

var driveRepliesPatch* = Call_DriveRepliesPatch_589637(name: "driveRepliesPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesPatch_589638, base: "/drive/v2",
    url: url_DriveRepliesPatch_589639, schemes: {Scheme.Https})
type
  Call_DriveRepliesDelete_589620 = ref object of OpenApiRestCall_588457
proc url_DriveRepliesDelete_589622(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  assert "replyId" in path, "`replyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId"),
               (kind: ConstantSegment, value: "/replies/"),
               (kind: VariableSegment, value: "replyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveRepliesDelete_589621(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes a reply.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   replyId: JString (required)
  ##          : The ID of the reply.
  ##   commentId: JString (required)
  ##            : The ID of the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589623 = path.getOrDefault("fileId")
  valid_589623 = validateParameter(valid_589623, JString, required = true,
                                 default = nil)
  if valid_589623 != nil:
    section.add "fileId", valid_589623
  var valid_589624 = path.getOrDefault("replyId")
  valid_589624 = validateParameter(valid_589624, JString, required = true,
                                 default = nil)
  if valid_589624 != nil:
    section.add "replyId", valid_589624
  var valid_589625 = path.getOrDefault("commentId")
  valid_589625 = validateParameter(valid_589625, JString, required = true,
                                 default = nil)
  if valid_589625 != nil:
    section.add "commentId", valid_589625
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
  var valid_589626 = query.getOrDefault("fields")
  valid_589626 = validateParameter(valid_589626, JString, required = false,
                                 default = nil)
  if valid_589626 != nil:
    section.add "fields", valid_589626
  var valid_589627 = query.getOrDefault("quotaUser")
  valid_589627 = validateParameter(valid_589627, JString, required = false,
                                 default = nil)
  if valid_589627 != nil:
    section.add "quotaUser", valid_589627
  var valid_589628 = query.getOrDefault("alt")
  valid_589628 = validateParameter(valid_589628, JString, required = false,
                                 default = newJString("json"))
  if valid_589628 != nil:
    section.add "alt", valid_589628
  var valid_589629 = query.getOrDefault("oauth_token")
  valid_589629 = validateParameter(valid_589629, JString, required = false,
                                 default = nil)
  if valid_589629 != nil:
    section.add "oauth_token", valid_589629
  var valid_589630 = query.getOrDefault("userIp")
  valid_589630 = validateParameter(valid_589630, JString, required = false,
                                 default = nil)
  if valid_589630 != nil:
    section.add "userIp", valid_589630
  var valid_589631 = query.getOrDefault("key")
  valid_589631 = validateParameter(valid_589631, JString, required = false,
                                 default = nil)
  if valid_589631 != nil:
    section.add "key", valid_589631
  var valid_589632 = query.getOrDefault("prettyPrint")
  valid_589632 = validateParameter(valid_589632, JBool, required = false,
                                 default = newJBool(true))
  if valid_589632 != nil:
    section.add "prettyPrint", valid_589632
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589633: Call_DriveRepliesDelete_589620; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a reply.
  ## 
  let valid = call_589633.validator(path, query, header, formData, body)
  let scheme = call_589633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589633.url(scheme.get, call_589633.host, call_589633.base,
                         call_589633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589633, url, valid)

proc call*(call_589634: Call_DriveRepliesDelete_589620; fileId: string;
          replyId: string; commentId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveRepliesDelete
  ## Deletes a reply.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   replyId: string (required)
  ##          : The ID of the reply.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589635 = newJObject()
  var query_589636 = newJObject()
  add(query_589636, "fields", newJString(fields))
  add(query_589636, "quotaUser", newJString(quotaUser))
  add(path_589635, "fileId", newJString(fileId))
  add(query_589636, "alt", newJString(alt))
  add(query_589636, "oauth_token", newJString(oauthToken))
  add(query_589636, "userIp", newJString(userIp))
  add(query_589636, "key", newJString(key))
  add(path_589635, "replyId", newJString(replyId))
  add(path_589635, "commentId", newJString(commentId))
  add(query_589636, "prettyPrint", newJBool(prettyPrint))
  result = call_589634.call(path_589635, query_589636, nil, nil, nil)

var driveRepliesDelete* = Call_DriveRepliesDelete_589620(
    name: "driveRepliesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesDelete_589621, base: "/drive/v2",
    url: url_DriveRepliesDelete_589622, schemes: {Scheme.Https})
type
  Call_DriveFilesCopy_589656 = ref object of OpenApiRestCall_588457
proc url_DriveFilesCopy_589658(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/copy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveFilesCopy_589657(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Creates a copy of the specified file.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file to copy.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589659 = path.getOrDefault("fileId")
  valid_589659 = validateParameter(valid_589659, JString, required = true,
                                 default = nil)
  if valid_589659 != nil:
    section.add "fileId", valid_589659
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   pinned: JBool
  ##         : Whether to pin the head revision of the new copy. A file can have a maximum of 200 pinned revisions.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   ocr: JBool
  ##      : Whether to attempt OCR on .jpg, .png, .gif, or .pdf uploads.
  ##   timedTextLanguage: JString
  ##                    : The language of the timed text.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   convert: JBool
  ##          : Whether to convert this file to the corresponding Google Docs format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ocrLanguage: JString
  ##              : If ocr is true, hints at the language to use. Valid values are BCP 47 codes.
  ##   timedTextTrackName: JString
  ##                     : The timed text track name.
  ##   visibility: JString
  ##             : The visibility of the new file. This parameter is only relevant when the source is not a native Google Doc and convert=false.
  section = newJObject()
  var valid_589660 = query.getOrDefault("supportsAllDrives")
  valid_589660 = validateParameter(valid_589660, JBool, required = false,
                                 default = newJBool(false))
  if valid_589660 != nil:
    section.add "supportsAllDrives", valid_589660
  var valid_589661 = query.getOrDefault("fields")
  valid_589661 = validateParameter(valid_589661, JString, required = false,
                                 default = nil)
  if valid_589661 != nil:
    section.add "fields", valid_589661
  var valid_589662 = query.getOrDefault("quotaUser")
  valid_589662 = validateParameter(valid_589662, JString, required = false,
                                 default = nil)
  if valid_589662 != nil:
    section.add "quotaUser", valid_589662
  var valid_589663 = query.getOrDefault("alt")
  valid_589663 = validateParameter(valid_589663, JString, required = false,
                                 default = newJString("json"))
  if valid_589663 != nil:
    section.add "alt", valid_589663
  var valid_589664 = query.getOrDefault("pinned")
  valid_589664 = validateParameter(valid_589664, JBool, required = false,
                                 default = newJBool(false))
  if valid_589664 != nil:
    section.add "pinned", valid_589664
  var valid_589665 = query.getOrDefault("oauth_token")
  valid_589665 = validateParameter(valid_589665, JString, required = false,
                                 default = nil)
  if valid_589665 != nil:
    section.add "oauth_token", valid_589665
  var valid_589666 = query.getOrDefault("userIp")
  valid_589666 = validateParameter(valid_589666, JString, required = false,
                                 default = nil)
  if valid_589666 != nil:
    section.add "userIp", valid_589666
  var valid_589667 = query.getOrDefault("ocr")
  valid_589667 = validateParameter(valid_589667, JBool, required = false,
                                 default = newJBool(false))
  if valid_589667 != nil:
    section.add "ocr", valid_589667
  var valid_589668 = query.getOrDefault("timedTextLanguage")
  valid_589668 = validateParameter(valid_589668, JString, required = false,
                                 default = nil)
  if valid_589668 != nil:
    section.add "timedTextLanguage", valid_589668
  var valid_589669 = query.getOrDefault("supportsTeamDrives")
  valid_589669 = validateParameter(valid_589669, JBool, required = false,
                                 default = newJBool(false))
  if valid_589669 != nil:
    section.add "supportsTeamDrives", valid_589669
  var valid_589670 = query.getOrDefault("key")
  valid_589670 = validateParameter(valid_589670, JString, required = false,
                                 default = nil)
  if valid_589670 != nil:
    section.add "key", valid_589670
  var valid_589671 = query.getOrDefault("convert")
  valid_589671 = validateParameter(valid_589671, JBool, required = false,
                                 default = newJBool(false))
  if valid_589671 != nil:
    section.add "convert", valid_589671
  var valid_589672 = query.getOrDefault("prettyPrint")
  valid_589672 = validateParameter(valid_589672, JBool, required = false,
                                 default = newJBool(true))
  if valid_589672 != nil:
    section.add "prettyPrint", valid_589672
  var valid_589673 = query.getOrDefault("ocrLanguage")
  valid_589673 = validateParameter(valid_589673, JString, required = false,
                                 default = nil)
  if valid_589673 != nil:
    section.add "ocrLanguage", valid_589673
  var valid_589674 = query.getOrDefault("timedTextTrackName")
  valid_589674 = validateParameter(valid_589674, JString, required = false,
                                 default = nil)
  if valid_589674 != nil:
    section.add "timedTextTrackName", valid_589674
  var valid_589675 = query.getOrDefault("visibility")
  valid_589675 = validateParameter(valid_589675, JString, required = false,
                                 default = newJString("DEFAULT"))
  if valid_589675 != nil:
    section.add "visibility", valid_589675
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589677: Call_DriveFilesCopy_589656; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a copy of the specified file.
  ## 
  let valid = call_589677.validator(path, query, header, formData, body)
  let scheme = call_589677.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589677.url(scheme.get, call_589677.host, call_589677.base,
                         call_589677.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589677, url, valid)

proc call*(call_589678: Call_DriveFilesCopy_589656; fileId: string;
          supportsAllDrives: bool = false; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pinned: bool = false; oauthToken: string = "";
          userIp: string = ""; ocr: bool = false; timedTextLanguage: string = "";
          supportsTeamDrives: bool = false; key: string = ""; convert: bool = false;
          body: JsonNode = nil; prettyPrint: bool = true; ocrLanguage: string = "";
          timedTextTrackName: string = ""; visibility: string = "DEFAULT"): Recallable =
  ## driveFilesCopy
  ## Creates a copy of the specified file.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file to copy.
  ##   alt: string
  ##      : Data format for the response.
  ##   pinned: bool
  ##         : Whether to pin the head revision of the new copy. A file can have a maximum of 200 pinned revisions.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   ocr: bool
  ##      : Whether to attempt OCR on .jpg, .png, .gif, or .pdf uploads.
  ##   timedTextLanguage: string
  ##                    : The language of the timed text.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   convert: bool
  ##          : Whether to convert this file to the corresponding Google Docs format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ocrLanguage: string
  ##              : If ocr is true, hints at the language to use. Valid values are BCP 47 codes.
  ##   timedTextTrackName: string
  ##                     : The timed text track name.
  ##   visibility: string
  ##             : The visibility of the new file. This parameter is only relevant when the source is not a native Google Doc and convert=false.
  var path_589679 = newJObject()
  var query_589680 = newJObject()
  var body_589681 = newJObject()
  add(query_589680, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589680, "fields", newJString(fields))
  add(query_589680, "quotaUser", newJString(quotaUser))
  add(path_589679, "fileId", newJString(fileId))
  add(query_589680, "alt", newJString(alt))
  add(query_589680, "pinned", newJBool(pinned))
  add(query_589680, "oauth_token", newJString(oauthToken))
  add(query_589680, "userIp", newJString(userIp))
  add(query_589680, "ocr", newJBool(ocr))
  add(query_589680, "timedTextLanguage", newJString(timedTextLanguage))
  add(query_589680, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589680, "key", newJString(key))
  add(query_589680, "convert", newJBool(convert))
  if body != nil:
    body_589681 = body
  add(query_589680, "prettyPrint", newJBool(prettyPrint))
  add(query_589680, "ocrLanguage", newJString(ocrLanguage))
  add(query_589680, "timedTextTrackName", newJString(timedTextTrackName))
  add(query_589680, "visibility", newJString(visibility))
  result = call_589678.call(path_589679, query_589680, nil, nil, body_589681)

var driveFilesCopy* = Call_DriveFilesCopy_589656(name: "driveFilesCopy",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/copy", validator: validate_DriveFilesCopy_589657,
    base: "/drive/v2", url: url_DriveFilesCopy_589658, schemes: {Scheme.Https})
type
  Call_DriveFilesExport_589682 = ref object of OpenApiRestCall_588457
proc url_DriveFilesExport_589684(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/export")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveFilesExport_589683(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Exports a Google Doc to the requested MIME type and returns the exported content. Please note that the exported content is limited to 10MB.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589685 = path.getOrDefault("fileId")
  valid_589685 = validateParameter(valid_589685, JString, required = true,
                                 default = nil)
  if valid_589685 != nil:
    section.add "fileId", valid_589685
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
  ##   mimeType: JString (required)
  ##           : The MIME type of the format requested for this export.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589686 = query.getOrDefault("fields")
  valid_589686 = validateParameter(valid_589686, JString, required = false,
                                 default = nil)
  if valid_589686 != nil:
    section.add "fields", valid_589686
  var valid_589687 = query.getOrDefault("quotaUser")
  valid_589687 = validateParameter(valid_589687, JString, required = false,
                                 default = nil)
  if valid_589687 != nil:
    section.add "quotaUser", valid_589687
  var valid_589688 = query.getOrDefault("alt")
  valid_589688 = validateParameter(valid_589688, JString, required = false,
                                 default = newJString("json"))
  if valid_589688 != nil:
    section.add "alt", valid_589688
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
  assert query != nil,
        "query argument is necessary due to required `mimeType` field"
  var valid_589691 = query.getOrDefault("mimeType")
  valid_589691 = validateParameter(valid_589691, JString, required = true,
                                 default = nil)
  if valid_589691 != nil:
    section.add "mimeType", valid_589691
  var valid_589692 = query.getOrDefault("key")
  valid_589692 = validateParameter(valid_589692, JString, required = false,
                                 default = nil)
  if valid_589692 != nil:
    section.add "key", valid_589692
  var valid_589693 = query.getOrDefault("prettyPrint")
  valid_589693 = validateParameter(valid_589693, JBool, required = false,
                                 default = newJBool(true))
  if valid_589693 != nil:
    section.add "prettyPrint", valid_589693
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589694: Call_DriveFilesExport_589682; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports a Google Doc to the requested MIME type and returns the exported content. Please note that the exported content is limited to 10MB.
  ## 
  let valid = call_589694.validator(path, query, header, formData, body)
  let scheme = call_589694.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589694.url(scheme.get, call_589694.host, call_589694.base,
                         call_589694.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589694, url, valid)

proc call*(call_589695: Call_DriveFilesExport_589682; fileId: string;
          mimeType: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveFilesExport
  ## Exports a Google Doc to the requested MIME type and returns the exported content. Please note that the exported content is limited to 10MB.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   mimeType: string (required)
  ##           : The MIME type of the format requested for this export.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589696 = newJObject()
  var query_589697 = newJObject()
  add(query_589697, "fields", newJString(fields))
  add(query_589697, "quotaUser", newJString(quotaUser))
  add(path_589696, "fileId", newJString(fileId))
  add(query_589697, "alt", newJString(alt))
  add(query_589697, "oauth_token", newJString(oauthToken))
  add(query_589697, "userIp", newJString(userIp))
  add(query_589697, "mimeType", newJString(mimeType))
  add(query_589697, "key", newJString(key))
  add(query_589697, "prettyPrint", newJBool(prettyPrint))
  result = call_589695.call(path_589696, query_589697, nil, nil, nil)

var driveFilesExport* = Call_DriveFilesExport_589682(name: "driveFilesExport",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/export", validator: validate_DriveFilesExport_589683,
    base: "/drive/v2", url: url_DriveFilesExport_589684, schemes: {Scheme.Https})
type
  Call_DriveParentsInsert_589713 = ref object of OpenApiRestCall_588457
proc url_DriveParentsInsert_589715(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/parents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveParentsInsert_589714(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Adds a parent folder for a file.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589716 = path.getOrDefault("fileId")
  valid_589716 = validateParameter(valid_589716, JString, required = true,
                                 default = nil)
  if valid_589716 != nil:
    section.add "fileId", valid_589716
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
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
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589717 = query.getOrDefault("supportsAllDrives")
  valid_589717 = validateParameter(valid_589717, JBool, required = false,
                                 default = newJBool(false))
  if valid_589717 != nil:
    section.add "supportsAllDrives", valid_589717
  var valid_589718 = query.getOrDefault("fields")
  valid_589718 = validateParameter(valid_589718, JString, required = false,
                                 default = nil)
  if valid_589718 != nil:
    section.add "fields", valid_589718
  var valid_589719 = query.getOrDefault("quotaUser")
  valid_589719 = validateParameter(valid_589719, JString, required = false,
                                 default = nil)
  if valid_589719 != nil:
    section.add "quotaUser", valid_589719
  var valid_589720 = query.getOrDefault("alt")
  valid_589720 = validateParameter(valid_589720, JString, required = false,
                                 default = newJString("json"))
  if valid_589720 != nil:
    section.add "alt", valid_589720
  var valid_589721 = query.getOrDefault("oauth_token")
  valid_589721 = validateParameter(valid_589721, JString, required = false,
                                 default = nil)
  if valid_589721 != nil:
    section.add "oauth_token", valid_589721
  var valid_589722 = query.getOrDefault("userIp")
  valid_589722 = validateParameter(valid_589722, JString, required = false,
                                 default = nil)
  if valid_589722 != nil:
    section.add "userIp", valid_589722
  var valid_589723 = query.getOrDefault("supportsTeamDrives")
  valid_589723 = validateParameter(valid_589723, JBool, required = false,
                                 default = newJBool(false))
  if valid_589723 != nil:
    section.add "supportsTeamDrives", valid_589723
  var valid_589724 = query.getOrDefault("key")
  valid_589724 = validateParameter(valid_589724, JString, required = false,
                                 default = nil)
  if valid_589724 != nil:
    section.add "key", valid_589724
  var valid_589725 = query.getOrDefault("prettyPrint")
  valid_589725 = validateParameter(valid_589725, JBool, required = false,
                                 default = newJBool(true))
  if valid_589725 != nil:
    section.add "prettyPrint", valid_589725
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589727: Call_DriveParentsInsert_589713; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a parent folder for a file.
  ## 
  let valid = call_589727.validator(path, query, header, formData, body)
  let scheme = call_589727.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589727.url(scheme.get, call_589727.host, call_589727.base,
                         call_589727.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589727, url, valid)

proc call*(call_589728: Call_DriveParentsInsert_589713; fileId: string;
          supportsAllDrives: bool = false; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          supportsTeamDrives: bool = false; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## driveParentsInsert
  ## Adds a parent folder for a file.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589729 = newJObject()
  var query_589730 = newJObject()
  var body_589731 = newJObject()
  add(query_589730, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589730, "fields", newJString(fields))
  add(query_589730, "quotaUser", newJString(quotaUser))
  add(path_589729, "fileId", newJString(fileId))
  add(query_589730, "alt", newJString(alt))
  add(query_589730, "oauth_token", newJString(oauthToken))
  add(query_589730, "userIp", newJString(userIp))
  add(query_589730, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589730, "key", newJString(key))
  if body != nil:
    body_589731 = body
  add(query_589730, "prettyPrint", newJBool(prettyPrint))
  result = call_589728.call(path_589729, query_589730, nil, nil, body_589731)

var driveParentsInsert* = Call_DriveParentsInsert_589713(
    name: "driveParentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/parents",
    validator: validate_DriveParentsInsert_589714, base: "/drive/v2",
    url: url_DriveParentsInsert_589715, schemes: {Scheme.Https})
type
  Call_DriveParentsList_589698 = ref object of OpenApiRestCall_588457
proc url_DriveParentsList_589700(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/parents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveParentsList_589699(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists a file's parents.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589701 = path.getOrDefault("fileId")
  valid_589701 = validateParameter(valid_589701, JString, required = true,
                                 default = nil)
  if valid_589701 != nil:
    section.add "fileId", valid_589701
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
  var valid_589702 = query.getOrDefault("fields")
  valid_589702 = validateParameter(valid_589702, JString, required = false,
                                 default = nil)
  if valid_589702 != nil:
    section.add "fields", valid_589702
  var valid_589703 = query.getOrDefault("quotaUser")
  valid_589703 = validateParameter(valid_589703, JString, required = false,
                                 default = nil)
  if valid_589703 != nil:
    section.add "quotaUser", valid_589703
  var valid_589704 = query.getOrDefault("alt")
  valid_589704 = validateParameter(valid_589704, JString, required = false,
                                 default = newJString("json"))
  if valid_589704 != nil:
    section.add "alt", valid_589704
  var valid_589705 = query.getOrDefault("oauth_token")
  valid_589705 = validateParameter(valid_589705, JString, required = false,
                                 default = nil)
  if valid_589705 != nil:
    section.add "oauth_token", valid_589705
  var valid_589706 = query.getOrDefault("userIp")
  valid_589706 = validateParameter(valid_589706, JString, required = false,
                                 default = nil)
  if valid_589706 != nil:
    section.add "userIp", valid_589706
  var valid_589707 = query.getOrDefault("key")
  valid_589707 = validateParameter(valid_589707, JString, required = false,
                                 default = nil)
  if valid_589707 != nil:
    section.add "key", valid_589707
  var valid_589708 = query.getOrDefault("prettyPrint")
  valid_589708 = validateParameter(valid_589708, JBool, required = false,
                                 default = newJBool(true))
  if valid_589708 != nil:
    section.add "prettyPrint", valid_589708
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589709: Call_DriveParentsList_589698; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's parents.
  ## 
  let valid = call_589709.validator(path, query, header, formData, body)
  let scheme = call_589709.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589709.url(scheme.get, call_589709.host, call_589709.base,
                         call_589709.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589709, url, valid)

proc call*(call_589710: Call_DriveParentsList_589698; fileId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## driveParentsList
  ## Lists a file's parents.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
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
  var path_589711 = newJObject()
  var query_589712 = newJObject()
  add(query_589712, "fields", newJString(fields))
  add(query_589712, "quotaUser", newJString(quotaUser))
  add(path_589711, "fileId", newJString(fileId))
  add(query_589712, "alt", newJString(alt))
  add(query_589712, "oauth_token", newJString(oauthToken))
  add(query_589712, "userIp", newJString(userIp))
  add(query_589712, "key", newJString(key))
  add(query_589712, "prettyPrint", newJBool(prettyPrint))
  result = call_589710.call(path_589711, query_589712, nil, nil, nil)

var driveParentsList* = Call_DriveParentsList_589698(name: "driveParentsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/parents", validator: validate_DriveParentsList_589699,
    base: "/drive/v2", url: url_DriveParentsList_589700, schemes: {Scheme.Https})
type
  Call_DriveParentsGet_589732 = ref object of OpenApiRestCall_588457
proc url_DriveParentsGet_589734(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "parentId" in path, "`parentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/parents/"),
               (kind: VariableSegment, value: "parentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveParentsGet_589733(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets a specific parent reference.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   parentId: JString (required)
  ##           : The ID of the parent.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589735 = path.getOrDefault("fileId")
  valid_589735 = validateParameter(valid_589735, JString, required = true,
                                 default = nil)
  if valid_589735 != nil:
    section.add "fileId", valid_589735
  var valid_589736 = path.getOrDefault("parentId")
  valid_589736 = validateParameter(valid_589736, JString, required = true,
                                 default = nil)
  if valid_589736 != nil:
    section.add "parentId", valid_589736
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
  var valid_589737 = query.getOrDefault("fields")
  valid_589737 = validateParameter(valid_589737, JString, required = false,
                                 default = nil)
  if valid_589737 != nil:
    section.add "fields", valid_589737
  var valid_589738 = query.getOrDefault("quotaUser")
  valid_589738 = validateParameter(valid_589738, JString, required = false,
                                 default = nil)
  if valid_589738 != nil:
    section.add "quotaUser", valid_589738
  var valid_589739 = query.getOrDefault("alt")
  valid_589739 = validateParameter(valid_589739, JString, required = false,
                                 default = newJString("json"))
  if valid_589739 != nil:
    section.add "alt", valid_589739
  var valid_589740 = query.getOrDefault("oauth_token")
  valid_589740 = validateParameter(valid_589740, JString, required = false,
                                 default = nil)
  if valid_589740 != nil:
    section.add "oauth_token", valid_589740
  var valid_589741 = query.getOrDefault("userIp")
  valid_589741 = validateParameter(valid_589741, JString, required = false,
                                 default = nil)
  if valid_589741 != nil:
    section.add "userIp", valid_589741
  var valid_589742 = query.getOrDefault("key")
  valid_589742 = validateParameter(valid_589742, JString, required = false,
                                 default = nil)
  if valid_589742 != nil:
    section.add "key", valid_589742
  var valid_589743 = query.getOrDefault("prettyPrint")
  valid_589743 = validateParameter(valid_589743, JBool, required = false,
                                 default = newJBool(true))
  if valid_589743 != nil:
    section.add "prettyPrint", valid_589743
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589744: Call_DriveParentsGet_589732; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific parent reference.
  ## 
  let valid = call_589744.validator(path, query, header, formData, body)
  let scheme = call_589744.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589744.url(scheme.get, call_589744.host, call_589744.base,
                         call_589744.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589744, url, valid)

proc call*(call_589745: Call_DriveParentsGet_589732; fileId: string;
          parentId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveParentsGet
  ## Gets a specific parent reference.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   parentId: string (required)
  ##           : The ID of the parent.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589746 = newJObject()
  var query_589747 = newJObject()
  add(query_589747, "fields", newJString(fields))
  add(query_589747, "quotaUser", newJString(quotaUser))
  add(path_589746, "fileId", newJString(fileId))
  add(query_589747, "alt", newJString(alt))
  add(path_589746, "parentId", newJString(parentId))
  add(query_589747, "oauth_token", newJString(oauthToken))
  add(query_589747, "userIp", newJString(userIp))
  add(query_589747, "key", newJString(key))
  add(query_589747, "prettyPrint", newJBool(prettyPrint))
  result = call_589745.call(path_589746, query_589747, nil, nil, nil)

var driveParentsGet* = Call_DriveParentsGet_589732(name: "driveParentsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/parents/{parentId}",
    validator: validate_DriveParentsGet_589733, base: "/drive/v2",
    url: url_DriveParentsGet_589734, schemes: {Scheme.Https})
type
  Call_DriveParentsDelete_589748 = ref object of OpenApiRestCall_588457
proc url_DriveParentsDelete_589750(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "parentId" in path, "`parentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/parents/"),
               (kind: VariableSegment, value: "parentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveParentsDelete_589749(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Removes a parent from a file.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   parentId: JString (required)
  ##           : The ID of the parent.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589751 = path.getOrDefault("fileId")
  valid_589751 = validateParameter(valid_589751, JString, required = true,
                                 default = nil)
  if valid_589751 != nil:
    section.add "fileId", valid_589751
  var valid_589752 = path.getOrDefault("parentId")
  valid_589752 = validateParameter(valid_589752, JString, required = true,
                                 default = nil)
  if valid_589752 != nil:
    section.add "parentId", valid_589752
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
  var valid_589753 = query.getOrDefault("fields")
  valid_589753 = validateParameter(valid_589753, JString, required = false,
                                 default = nil)
  if valid_589753 != nil:
    section.add "fields", valid_589753
  var valid_589754 = query.getOrDefault("quotaUser")
  valid_589754 = validateParameter(valid_589754, JString, required = false,
                                 default = nil)
  if valid_589754 != nil:
    section.add "quotaUser", valid_589754
  var valid_589755 = query.getOrDefault("alt")
  valid_589755 = validateParameter(valid_589755, JString, required = false,
                                 default = newJString("json"))
  if valid_589755 != nil:
    section.add "alt", valid_589755
  var valid_589756 = query.getOrDefault("oauth_token")
  valid_589756 = validateParameter(valid_589756, JString, required = false,
                                 default = nil)
  if valid_589756 != nil:
    section.add "oauth_token", valid_589756
  var valid_589757 = query.getOrDefault("userIp")
  valid_589757 = validateParameter(valid_589757, JString, required = false,
                                 default = nil)
  if valid_589757 != nil:
    section.add "userIp", valid_589757
  var valid_589758 = query.getOrDefault("key")
  valid_589758 = validateParameter(valid_589758, JString, required = false,
                                 default = nil)
  if valid_589758 != nil:
    section.add "key", valid_589758
  var valid_589759 = query.getOrDefault("prettyPrint")
  valid_589759 = validateParameter(valid_589759, JBool, required = false,
                                 default = newJBool(true))
  if valid_589759 != nil:
    section.add "prettyPrint", valid_589759
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589760: Call_DriveParentsDelete_589748; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a parent from a file.
  ## 
  let valid = call_589760.validator(path, query, header, formData, body)
  let scheme = call_589760.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589760.url(scheme.get, call_589760.host, call_589760.base,
                         call_589760.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589760, url, valid)

proc call*(call_589761: Call_DriveParentsDelete_589748; fileId: string;
          parentId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveParentsDelete
  ## Removes a parent from a file.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   parentId: string (required)
  ##           : The ID of the parent.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589762 = newJObject()
  var query_589763 = newJObject()
  add(query_589763, "fields", newJString(fields))
  add(query_589763, "quotaUser", newJString(quotaUser))
  add(path_589762, "fileId", newJString(fileId))
  add(query_589763, "alt", newJString(alt))
  add(path_589762, "parentId", newJString(parentId))
  add(query_589763, "oauth_token", newJString(oauthToken))
  add(query_589763, "userIp", newJString(userIp))
  add(query_589763, "key", newJString(key))
  add(query_589763, "prettyPrint", newJBool(prettyPrint))
  result = call_589761.call(path_589762, query_589763, nil, nil, nil)

var driveParentsDelete* = Call_DriveParentsDelete_589748(
    name: "driveParentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/parents/{parentId}",
    validator: validate_DriveParentsDelete_589749, base: "/drive/v2",
    url: url_DriveParentsDelete_589750, schemes: {Scheme.Https})
type
  Call_DrivePermissionsInsert_589784 = ref object of OpenApiRestCall_588457
proc url_DrivePermissionsInsert_589786(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/permissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DrivePermissionsInsert_589785(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a permission for a file or shared drive.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID for the file or shared drive.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589787 = path.getOrDefault("fileId")
  valid_589787 = validateParameter(valid_589787, JString, required = true,
                                 default = nil)
  if valid_589787 != nil:
    section.add "fileId", valid_589787
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   sendNotificationEmails: JBool
  ##                         : Whether to send notification emails when sharing to users or groups. This parameter is ignored and an email is sent if the role is owner.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   emailMessage: JString
  ##               : A plain text custom message to include in notification emails.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589788 = query.getOrDefault("supportsAllDrives")
  valid_589788 = validateParameter(valid_589788, JBool, required = false,
                                 default = newJBool(false))
  if valid_589788 != nil:
    section.add "supportsAllDrives", valid_589788
  var valid_589789 = query.getOrDefault("fields")
  valid_589789 = validateParameter(valid_589789, JString, required = false,
                                 default = nil)
  if valid_589789 != nil:
    section.add "fields", valid_589789
  var valid_589790 = query.getOrDefault("quotaUser")
  valid_589790 = validateParameter(valid_589790, JString, required = false,
                                 default = nil)
  if valid_589790 != nil:
    section.add "quotaUser", valid_589790
  var valid_589791 = query.getOrDefault("alt")
  valid_589791 = validateParameter(valid_589791, JString, required = false,
                                 default = newJString("json"))
  if valid_589791 != nil:
    section.add "alt", valid_589791
  var valid_589792 = query.getOrDefault("oauth_token")
  valid_589792 = validateParameter(valid_589792, JString, required = false,
                                 default = nil)
  if valid_589792 != nil:
    section.add "oauth_token", valid_589792
  var valid_589793 = query.getOrDefault("sendNotificationEmails")
  valid_589793 = validateParameter(valid_589793, JBool, required = false,
                                 default = newJBool(true))
  if valid_589793 != nil:
    section.add "sendNotificationEmails", valid_589793
  var valid_589794 = query.getOrDefault("userIp")
  valid_589794 = validateParameter(valid_589794, JString, required = false,
                                 default = nil)
  if valid_589794 != nil:
    section.add "userIp", valid_589794
  var valid_589795 = query.getOrDefault("supportsTeamDrives")
  valid_589795 = validateParameter(valid_589795, JBool, required = false,
                                 default = newJBool(false))
  if valid_589795 != nil:
    section.add "supportsTeamDrives", valid_589795
  var valid_589796 = query.getOrDefault("key")
  valid_589796 = validateParameter(valid_589796, JString, required = false,
                                 default = nil)
  if valid_589796 != nil:
    section.add "key", valid_589796
  var valid_589797 = query.getOrDefault("useDomainAdminAccess")
  valid_589797 = validateParameter(valid_589797, JBool, required = false,
                                 default = newJBool(false))
  if valid_589797 != nil:
    section.add "useDomainAdminAccess", valid_589797
  var valid_589798 = query.getOrDefault("emailMessage")
  valid_589798 = validateParameter(valid_589798, JString, required = false,
                                 default = nil)
  if valid_589798 != nil:
    section.add "emailMessage", valid_589798
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

proc call*(call_589801: Call_DrivePermissionsInsert_589784; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a permission for a file or shared drive.
  ## 
  let valid = call_589801.validator(path, query, header, formData, body)
  let scheme = call_589801.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589801.url(scheme.get, call_589801.host, call_589801.base,
                         call_589801.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589801, url, valid)

proc call*(call_589802: Call_DrivePermissionsInsert_589784; fileId: string;
          supportsAllDrives: bool = false; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = "";
          sendNotificationEmails: bool = true; userIp: string = "";
          supportsTeamDrives: bool = false; key: string = "";
          useDomainAdminAccess: bool = false; emailMessage: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## drivePermissionsInsert
  ## Inserts a permission for a file or shared drive.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID for the file or shared drive.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   sendNotificationEmails: bool
  ##                         : Whether to send notification emails when sharing to users or groups. This parameter is ignored and an email is sent if the role is owner.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   emailMessage: string
  ##               : A plain text custom message to include in notification emails.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589803 = newJObject()
  var query_589804 = newJObject()
  var body_589805 = newJObject()
  add(query_589804, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589804, "fields", newJString(fields))
  add(query_589804, "quotaUser", newJString(quotaUser))
  add(path_589803, "fileId", newJString(fileId))
  add(query_589804, "alt", newJString(alt))
  add(query_589804, "oauth_token", newJString(oauthToken))
  add(query_589804, "sendNotificationEmails", newJBool(sendNotificationEmails))
  add(query_589804, "userIp", newJString(userIp))
  add(query_589804, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589804, "key", newJString(key))
  add(query_589804, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_589804, "emailMessage", newJString(emailMessage))
  if body != nil:
    body_589805 = body
  add(query_589804, "prettyPrint", newJBool(prettyPrint))
  result = call_589802.call(path_589803, query_589804, nil, nil, body_589805)

var drivePermissionsInsert* = Call_DrivePermissionsInsert_589784(
    name: "drivePermissionsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/permissions",
    validator: validate_DrivePermissionsInsert_589785, base: "/drive/v2",
    url: url_DrivePermissionsInsert_589786, schemes: {Scheme.Https})
type
  Call_DrivePermissionsList_589764 = ref object of OpenApiRestCall_588457
proc url_DrivePermissionsList_589766(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/permissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DrivePermissionsList_589765(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a file's or shared drive's permissions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID for the file or shared drive.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589767 = path.getOrDefault("fileId")
  valid_589767 = validateParameter(valid_589767, JString, required = true,
                                 default = nil)
  if valid_589767 != nil:
    section.add "fileId", valid_589767
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of permissions to return per page. When not set for files in a shared drive, at most 100 results will be returned. When not set for files that are not in a shared drive, the entire list will be returned.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589768 = query.getOrDefault("supportsAllDrives")
  valid_589768 = validateParameter(valid_589768, JBool, required = false,
                                 default = newJBool(false))
  if valid_589768 != nil:
    section.add "supportsAllDrives", valid_589768
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
  var valid_589776 = query.getOrDefault("supportsTeamDrives")
  valid_589776 = validateParameter(valid_589776, JBool, required = false,
                                 default = newJBool(false))
  if valid_589776 != nil:
    section.add "supportsTeamDrives", valid_589776
  var valid_589777 = query.getOrDefault("key")
  valid_589777 = validateParameter(valid_589777, JString, required = false,
                                 default = nil)
  if valid_589777 != nil:
    section.add "key", valid_589777
  var valid_589778 = query.getOrDefault("useDomainAdminAccess")
  valid_589778 = validateParameter(valid_589778, JBool, required = false,
                                 default = newJBool(false))
  if valid_589778 != nil:
    section.add "useDomainAdminAccess", valid_589778
  var valid_589779 = query.getOrDefault("prettyPrint")
  valid_589779 = validateParameter(valid_589779, JBool, required = false,
                                 default = newJBool(true))
  if valid_589779 != nil:
    section.add "prettyPrint", valid_589779
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589780: Call_DrivePermissionsList_589764; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's or shared drive's permissions.
  ## 
  let valid = call_589780.validator(path, query, header, formData, body)
  let scheme = call_589780.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589780.url(scheme.get, call_589780.host, call_589780.base,
                         call_589780.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589780, url, valid)

proc call*(call_589781: Call_DrivePermissionsList_589764; fileId: string;
          supportsAllDrives: bool = false; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; supportsTeamDrives: bool = false;
          key: string = ""; useDomainAdminAccess: bool = false; prettyPrint: bool = true): Recallable =
  ## drivePermissionsList
  ## Lists a file's or shared drive's permissions.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID for the file or shared drive.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of permissions to return per page. When not set for files in a shared drive, at most 100 results will be returned. When not set for files that are not in a shared drive, the entire list will be returned.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589782 = newJObject()
  var query_589783 = newJObject()
  add(query_589783, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589783, "fields", newJString(fields))
  add(query_589783, "pageToken", newJString(pageToken))
  add(query_589783, "quotaUser", newJString(quotaUser))
  add(path_589782, "fileId", newJString(fileId))
  add(query_589783, "alt", newJString(alt))
  add(query_589783, "oauth_token", newJString(oauthToken))
  add(query_589783, "userIp", newJString(userIp))
  add(query_589783, "maxResults", newJInt(maxResults))
  add(query_589783, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589783, "key", newJString(key))
  add(query_589783, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_589783, "prettyPrint", newJBool(prettyPrint))
  result = call_589781.call(path_589782, query_589783, nil, nil, nil)

var drivePermissionsList* = Call_DrivePermissionsList_589764(
    name: "drivePermissionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/permissions",
    validator: validate_DrivePermissionsList_589765, base: "/drive/v2",
    url: url_DrivePermissionsList_589766, schemes: {Scheme.Https})
type
  Call_DrivePermissionsUpdate_589825 = ref object of OpenApiRestCall_588457
proc url_DrivePermissionsUpdate_589827(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "permissionId" in path, "`permissionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/permissions/"),
               (kind: VariableSegment, value: "permissionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DrivePermissionsUpdate_589826(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID for the file or shared drive.
  ##   permissionId: JString (required)
  ##               : The ID for the permission.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589828 = path.getOrDefault("fileId")
  valid_589828 = validateParameter(valid_589828, JString, required = true,
                                 default = nil)
  if valid_589828 != nil:
    section.add "fileId", valid_589828
  var valid_589829 = path.getOrDefault("permissionId")
  valid_589829 = validateParameter(valid_589829, JString, required = true,
                                 default = nil)
  if valid_589829 != nil:
    section.add "permissionId", valid_589829
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   removeExpiration: JBool
  ##                   : Whether to remove the expiration date.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   transferOwnership: JBool
  ##                    : Whether changing a role to 'owner' downgrades the current owners to writers. Does nothing if the specified role is not 'owner'.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589830 = query.getOrDefault("supportsAllDrives")
  valid_589830 = validateParameter(valid_589830, JBool, required = false,
                                 default = newJBool(false))
  if valid_589830 != nil:
    section.add "supportsAllDrives", valid_589830
  var valid_589831 = query.getOrDefault("fields")
  valid_589831 = validateParameter(valid_589831, JString, required = false,
                                 default = nil)
  if valid_589831 != nil:
    section.add "fields", valid_589831
  var valid_589832 = query.getOrDefault("quotaUser")
  valid_589832 = validateParameter(valid_589832, JString, required = false,
                                 default = nil)
  if valid_589832 != nil:
    section.add "quotaUser", valid_589832
  var valid_589833 = query.getOrDefault("alt")
  valid_589833 = validateParameter(valid_589833, JString, required = false,
                                 default = newJString("json"))
  if valid_589833 != nil:
    section.add "alt", valid_589833
  var valid_589834 = query.getOrDefault("oauth_token")
  valid_589834 = validateParameter(valid_589834, JString, required = false,
                                 default = nil)
  if valid_589834 != nil:
    section.add "oauth_token", valid_589834
  var valid_589835 = query.getOrDefault("removeExpiration")
  valid_589835 = validateParameter(valid_589835, JBool, required = false,
                                 default = newJBool(false))
  if valid_589835 != nil:
    section.add "removeExpiration", valid_589835
  var valid_589836 = query.getOrDefault("userIp")
  valid_589836 = validateParameter(valid_589836, JString, required = false,
                                 default = nil)
  if valid_589836 != nil:
    section.add "userIp", valid_589836
  var valid_589837 = query.getOrDefault("supportsTeamDrives")
  valid_589837 = validateParameter(valid_589837, JBool, required = false,
                                 default = newJBool(false))
  if valid_589837 != nil:
    section.add "supportsTeamDrives", valid_589837
  var valid_589838 = query.getOrDefault("key")
  valid_589838 = validateParameter(valid_589838, JString, required = false,
                                 default = nil)
  if valid_589838 != nil:
    section.add "key", valid_589838
  var valid_589839 = query.getOrDefault("useDomainAdminAccess")
  valid_589839 = validateParameter(valid_589839, JBool, required = false,
                                 default = newJBool(false))
  if valid_589839 != nil:
    section.add "useDomainAdminAccess", valid_589839
  var valid_589840 = query.getOrDefault("transferOwnership")
  valid_589840 = validateParameter(valid_589840, JBool, required = false,
                                 default = newJBool(false))
  if valid_589840 != nil:
    section.add "transferOwnership", valid_589840
  var valid_589841 = query.getOrDefault("prettyPrint")
  valid_589841 = validateParameter(valid_589841, JBool, required = false,
                                 default = newJBool(true))
  if valid_589841 != nil:
    section.add "prettyPrint", valid_589841
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589843: Call_DrivePermissionsUpdate_589825; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a permission.
  ## 
  let valid = call_589843.validator(path, query, header, formData, body)
  let scheme = call_589843.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589843.url(scheme.get, call_589843.host, call_589843.base,
                         call_589843.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589843, url, valid)

proc call*(call_589844: Call_DrivePermissionsUpdate_589825; fileId: string;
          permissionId: string; supportsAllDrives: bool = false; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          removeExpiration: bool = false; userIp: string = "";
          supportsTeamDrives: bool = false; key: string = "";
          useDomainAdminAccess: bool = false; transferOwnership: bool = false;
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## drivePermissionsUpdate
  ## Updates a permission.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID for the file or shared drive.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   permissionId: string (required)
  ##               : The ID for the permission.
  ##   removeExpiration: bool
  ##                   : Whether to remove the expiration date.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   transferOwnership: bool
  ##                    : Whether changing a role to 'owner' downgrades the current owners to writers. Does nothing if the specified role is not 'owner'.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589845 = newJObject()
  var query_589846 = newJObject()
  var body_589847 = newJObject()
  add(query_589846, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589846, "fields", newJString(fields))
  add(query_589846, "quotaUser", newJString(quotaUser))
  add(path_589845, "fileId", newJString(fileId))
  add(query_589846, "alt", newJString(alt))
  add(query_589846, "oauth_token", newJString(oauthToken))
  add(path_589845, "permissionId", newJString(permissionId))
  add(query_589846, "removeExpiration", newJBool(removeExpiration))
  add(query_589846, "userIp", newJString(userIp))
  add(query_589846, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589846, "key", newJString(key))
  add(query_589846, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_589846, "transferOwnership", newJBool(transferOwnership))
  if body != nil:
    body_589847 = body
  add(query_589846, "prettyPrint", newJBool(prettyPrint))
  result = call_589844.call(path_589845, query_589846, nil, nil, body_589847)

var drivePermissionsUpdate* = Call_DrivePermissionsUpdate_589825(
    name: "drivePermissionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsUpdate_589826, base: "/drive/v2",
    url: url_DrivePermissionsUpdate_589827, schemes: {Scheme.Https})
type
  Call_DrivePermissionsGet_589806 = ref object of OpenApiRestCall_588457
proc url_DrivePermissionsGet_589808(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "permissionId" in path, "`permissionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/permissions/"),
               (kind: VariableSegment, value: "permissionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DrivePermissionsGet_589807(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets a permission by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID for the file or shared drive.
  ##   permissionId: JString (required)
  ##               : The ID for the permission.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589809 = path.getOrDefault("fileId")
  valid_589809 = validateParameter(valid_589809, JString, required = true,
                                 default = nil)
  if valid_589809 != nil:
    section.add "fileId", valid_589809
  var valid_589810 = path.getOrDefault("permissionId")
  valid_589810 = validateParameter(valid_589810, JString, required = true,
                                 default = nil)
  if valid_589810 != nil:
    section.add "permissionId", valid_589810
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
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
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589811 = query.getOrDefault("supportsAllDrives")
  valid_589811 = validateParameter(valid_589811, JBool, required = false,
                                 default = newJBool(false))
  if valid_589811 != nil:
    section.add "supportsAllDrives", valid_589811
  var valid_589812 = query.getOrDefault("fields")
  valid_589812 = validateParameter(valid_589812, JString, required = false,
                                 default = nil)
  if valid_589812 != nil:
    section.add "fields", valid_589812
  var valid_589813 = query.getOrDefault("quotaUser")
  valid_589813 = validateParameter(valid_589813, JString, required = false,
                                 default = nil)
  if valid_589813 != nil:
    section.add "quotaUser", valid_589813
  var valid_589814 = query.getOrDefault("alt")
  valid_589814 = validateParameter(valid_589814, JString, required = false,
                                 default = newJString("json"))
  if valid_589814 != nil:
    section.add "alt", valid_589814
  var valid_589815 = query.getOrDefault("oauth_token")
  valid_589815 = validateParameter(valid_589815, JString, required = false,
                                 default = nil)
  if valid_589815 != nil:
    section.add "oauth_token", valid_589815
  var valid_589816 = query.getOrDefault("userIp")
  valid_589816 = validateParameter(valid_589816, JString, required = false,
                                 default = nil)
  if valid_589816 != nil:
    section.add "userIp", valid_589816
  var valid_589817 = query.getOrDefault("supportsTeamDrives")
  valid_589817 = validateParameter(valid_589817, JBool, required = false,
                                 default = newJBool(false))
  if valid_589817 != nil:
    section.add "supportsTeamDrives", valid_589817
  var valid_589818 = query.getOrDefault("key")
  valid_589818 = validateParameter(valid_589818, JString, required = false,
                                 default = nil)
  if valid_589818 != nil:
    section.add "key", valid_589818
  var valid_589819 = query.getOrDefault("useDomainAdminAccess")
  valid_589819 = validateParameter(valid_589819, JBool, required = false,
                                 default = newJBool(false))
  if valid_589819 != nil:
    section.add "useDomainAdminAccess", valid_589819
  var valid_589820 = query.getOrDefault("prettyPrint")
  valid_589820 = validateParameter(valid_589820, JBool, required = false,
                                 default = newJBool(true))
  if valid_589820 != nil:
    section.add "prettyPrint", valid_589820
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589821: Call_DrivePermissionsGet_589806; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a permission by ID.
  ## 
  let valid = call_589821.validator(path, query, header, formData, body)
  let scheme = call_589821.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589821.url(scheme.get, call_589821.host, call_589821.base,
                         call_589821.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589821, url, valid)

proc call*(call_589822: Call_DrivePermissionsGet_589806; fileId: string;
          permissionId: string; supportsAllDrives: bool = false; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; supportsTeamDrives: bool = false; key: string = "";
          useDomainAdminAccess: bool = false; prettyPrint: bool = true): Recallable =
  ## drivePermissionsGet
  ## Gets a permission by ID.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID for the file or shared drive.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   permissionId: string (required)
  ##               : The ID for the permission.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589823 = newJObject()
  var query_589824 = newJObject()
  add(query_589824, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589824, "fields", newJString(fields))
  add(query_589824, "quotaUser", newJString(quotaUser))
  add(path_589823, "fileId", newJString(fileId))
  add(query_589824, "alt", newJString(alt))
  add(query_589824, "oauth_token", newJString(oauthToken))
  add(path_589823, "permissionId", newJString(permissionId))
  add(query_589824, "userIp", newJString(userIp))
  add(query_589824, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589824, "key", newJString(key))
  add(query_589824, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_589824, "prettyPrint", newJBool(prettyPrint))
  result = call_589822.call(path_589823, query_589824, nil, nil, nil)

var drivePermissionsGet* = Call_DrivePermissionsGet_589806(
    name: "drivePermissionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsGet_589807, base: "/drive/v2",
    url: url_DrivePermissionsGet_589808, schemes: {Scheme.Https})
type
  Call_DrivePermissionsPatch_589867 = ref object of OpenApiRestCall_588457
proc url_DrivePermissionsPatch_589869(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "permissionId" in path, "`permissionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/permissions/"),
               (kind: VariableSegment, value: "permissionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DrivePermissionsPatch_589868(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a permission using patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID for the file or shared drive.
  ##   permissionId: JString (required)
  ##               : The ID for the permission.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589870 = path.getOrDefault("fileId")
  valid_589870 = validateParameter(valid_589870, JString, required = true,
                                 default = nil)
  if valid_589870 != nil:
    section.add "fileId", valid_589870
  var valid_589871 = path.getOrDefault("permissionId")
  valid_589871 = validateParameter(valid_589871, JString, required = true,
                                 default = nil)
  if valid_589871 != nil:
    section.add "permissionId", valid_589871
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   removeExpiration: JBool
  ##                   : Whether to remove the expiration date.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   transferOwnership: JBool
  ##                    : Whether changing a role to 'owner' downgrades the current owners to writers. Does nothing if the specified role is not 'owner'.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589872 = query.getOrDefault("supportsAllDrives")
  valid_589872 = validateParameter(valid_589872, JBool, required = false,
                                 default = newJBool(false))
  if valid_589872 != nil:
    section.add "supportsAllDrives", valid_589872
  var valid_589873 = query.getOrDefault("fields")
  valid_589873 = validateParameter(valid_589873, JString, required = false,
                                 default = nil)
  if valid_589873 != nil:
    section.add "fields", valid_589873
  var valid_589874 = query.getOrDefault("quotaUser")
  valid_589874 = validateParameter(valid_589874, JString, required = false,
                                 default = nil)
  if valid_589874 != nil:
    section.add "quotaUser", valid_589874
  var valid_589875 = query.getOrDefault("alt")
  valid_589875 = validateParameter(valid_589875, JString, required = false,
                                 default = newJString("json"))
  if valid_589875 != nil:
    section.add "alt", valid_589875
  var valid_589876 = query.getOrDefault("oauth_token")
  valid_589876 = validateParameter(valid_589876, JString, required = false,
                                 default = nil)
  if valid_589876 != nil:
    section.add "oauth_token", valid_589876
  var valid_589877 = query.getOrDefault("removeExpiration")
  valid_589877 = validateParameter(valid_589877, JBool, required = false,
                                 default = newJBool(false))
  if valid_589877 != nil:
    section.add "removeExpiration", valid_589877
  var valid_589878 = query.getOrDefault("userIp")
  valid_589878 = validateParameter(valid_589878, JString, required = false,
                                 default = nil)
  if valid_589878 != nil:
    section.add "userIp", valid_589878
  var valid_589879 = query.getOrDefault("supportsTeamDrives")
  valid_589879 = validateParameter(valid_589879, JBool, required = false,
                                 default = newJBool(false))
  if valid_589879 != nil:
    section.add "supportsTeamDrives", valid_589879
  var valid_589880 = query.getOrDefault("key")
  valid_589880 = validateParameter(valid_589880, JString, required = false,
                                 default = nil)
  if valid_589880 != nil:
    section.add "key", valid_589880
  var valid_589881 = query.getOrDefault("useDomainAdminAccess")
  valid_589881 = validateParameter(valid_589881, JBool, required = false,
                                 default = newJBool(false))
  if valid_589881 != nil:
    section.add "useDomainAdminAccess", valid_589881
  var valid_589882 = query.getOrDefault("transferOwnership")
  valid_589882 = validateParameter(valid_589882, JBool, required = false,
                                 default = newJBool(false))
  if valid_589882 != nil:
    section.add "transferOwnership", valid_589882
  var valid_589883 = query.getOrDefault("prettyPrint")
  valid_589883 = validateParameter(valid_589883, JBool, required = false,
                                 default = newJBool(true))
  if valid_589883 != nil:
    section.add "prettyPrint", valid_589883
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589885: Call_DrivePermissionsPatch_589867; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a permission using patch semantics.
  ## 
  let valid = call_589885.validator(path, query, header, formData, body)
  let scheme = call_589885.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589885.url(scheme.get, call_589885.host, call_589885.base,
                         call_589885.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589885, url, valid)

proc call*(call_589886: Call_DrivePermissionsPatch_589867; fileId: string;
          permissionId: string; supportsAllDrives: bool = false; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          removeExpiration: bool = false; userIp: string = "";
          supportsTeamDrives: bool = false; key: string = "";
          useDomainAdminAccess: bool = false; transferOwnership: bool = false;
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## drivePermissionsPatch
  ## Updates a permission using patch semantics.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID for the file or shared drive.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   permissionId: string (required)
  ##               : The ID for the permission.
  ##   removeExpiration: bool
  ##                   : Whether to remove the expiration date.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   transferOwnership: bool
  ##                    : Whether changing a role to 'owner' downgrades the current owners to writers. Does nothing if the specified role is not 'owner'.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589887 = newJObject()
  var query_589888 = newJObject()
  var body_589889 = newJObject()
  add(query_589888, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589888, "fields", newJString(fields))
  add(query_589888, "quotaUser", newJString(quotaUser))
  add(path_589887, "fileId", newJString(fileId))
  add(query_589888, "alt", newJString(alt))
  add(query_589888, "oauth_token", newJString(oauthToken))
  add(path_589887, "permissionId", newJString(permissionId))
  add(query_589888, "removeExpiration", newJBool(removeExpiration))
  add(query_589888, "userIp", newJString(userIp))
  add(query_589888, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589888, "key", newJString(key))
  add(query_589888, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_589888, "transferOwnership", newJBool(transferOwnership))
  if body != nil:
    body_589889 = body
  add(query_589888, "prettyPrint", newJBool(prettyPrint))
  result = call_589886.call(path_589887, query_589888, nil, nil, body_589889)

var drivePermissionsPatch* = Call_DrivePermissionsPatch_589867(
    name: "drivePermissionsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsPatch_589868, base: "/drive/v2",
    url: url_DrivePermissionsPatch_589869, schemes: {Scheme.Https})
type
  Call_DrivePermissionsDelete_589848 = ref object of OpenApiRestCall_588457
proc url_DrivePermissionsDelete_589850(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "permissionId" in path, "`permissionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/permissions/"),
               (kind: VariableSegment, value: "permissionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DrivePermissionsDelete_589849(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a permission from a file or shared drive.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID for the file or shared drive.
  ##   permissionId: JString (required)
  ##               : The ID for the permission.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589851 = path.getOrDefault("fileId")
  valid_589851 = validateParameter(valid_589851, JString, required = true,
                                 default = nil)
  if valid_589851 != nil:
    section.add "fileId", valid_589851
  var valid_589852 = path.getOrDefault("permissionId")
  valid_589852 = validateParameter(valid_589852, JString, required = true,
                                 default = nil)
  if valid_589852 != nil:
    section.add "permissionId", valid_589852
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
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
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589853 = query.getOrDefault("supportsAllDrives")
  valid_589853 = validateParameter(valid_589853, JBool, required = false,
                                 default = newJBool(false))
  if valid_589853 != nil:
    section.add "supportsAllDrives", valid_589853
  var valid_589854 = query.getOrDefault("fields")
  valid_589854 = validateParameter(valid_589854, JString, required = false,
                                 default = nil)
  if valid_589854 != nil:
    section.add "fields", valid_589854
  var valid_589855 = query.getOrDefault("quotaUser")
  valid_589855 = validateParameter(valid_589855, JString, required = false,
                                 default = nil)
  if valid_589855 != nil:
    section.add "quotaUser", valid_589855
  var valid_589856 = query.getOrDefault("alt")
  valid_589856 = validateParameter(valid_589856, JString, required = false,
                                 default = newJString("json"))
  if valid_589856 != nil:
    section.add "alt", valid_589856
  var valid_589857 = query.getOrDefault("oauth_token")
  valid_589857 = validateParameter(valid_589857, JString, required = false,
                                 default = nil)
  if valid_589857 != nil:
    section.add "oauth_token", valid_589857
  var valid_589858 = query.getOrDefault("userIp")
  valid_589858 = validateParameter(valid_589858, JString, required = false,
                                 default = nil)
  if valid_589858 != nil:
    section.add "userIp", valid_589858
  var valid_589859 = query.getOrDefault("supportsTeamDrives")
  valid_589859 = validateParameter(valid_589859, JBool, required = false,
                                 default = newJBool(false))
  if valid_589859 != nil:
    section.add "supportsTeamDrives", valid_589859
  var valid_589860 = query.getOrDefault("key")
  valid_589860 = validateParameter(valid_589860, JString, required = false,
                                 default = nil)
  if valid_589860 != nil:
    section.add "key", valid_589860
  var valid_589861 = query.getOrDefault("useDomainAdminAccess")
  valid_589861 = validateParameter(valid_589861, JBool, required = false,
                                 default = newJBool(false))
  if valid_589861 != nil:
    section.add "useDomainAdminAccess", valid_589861
  var valid_589862 = query.getOrDefault("prettyPrint")
  valid_589862 = validateParameter(valid_589862, JBool, required = false,
                                 default = newJBool(true))
  if valid_589862 != nil:
    section.add "prettyPrint", valid_589862
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589863: Call_DrivePermissionsDelete_589848; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a permission from a file or shared drive.
  ## 
  let valid = call_589863.validator(path, query, header, formData, body)
  let scheme = call_589863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589863.url(scheme.get, call_589863.host, call_589863.base,
                         call_589863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589863, url, valid)

proc call*(call_589864: Call_DrivePermissionsDelete_589848; fileId: string;
          permissionId: string; supportsAllDrives: bool = false; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; supportsTeamDrives: bool = false; key: string = "";
          useDomainAdminAccess: bool = false; prettyPrint: bool = true): Recallable =
  ## drivePermissionsDelete
  ## Deletes a permission from a file or shared drive.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID for the file or shared drive.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   permissionId: string (required)
  ##               : The ID for the permission.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589865 = newJObject()
  var query_589866 = newJObject()
  add(query_589866, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589866, "fields", newJString(fields))
  add(query_589866, "quotaUser", newJString(quotaUser))
  add(path_589865, "fileId", newJString(fileId))
  add(query_589866, "alt", newJString(alt))
  add(query_589866, "oauth_token", newJString(oauthToken))
  add(path_589865, "permissionId", newJString(permissionId))
  add(query_589866, "userIp", newJString(userIp))
  add(query_589866, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589866, "key", newJString(key))
  add(query_589866, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_589866, "prettyPrint", newJBool(prettyPrint))
  result = call_589864.call(path_589865, query_589866, nil, nil, nil)

var drivePermissionsDelete* = Call_DrivePermissionsDelete_589848(
    name: "drivePermissionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsDelete_589849, base: "/drive/v2",
    url: url_DrivePermissionsDelete_589850, schemes: {Scheme.Https})
type
  Call_DrivePropertiesInsert_589905 = ref object of OpenApiRestCall_588457
proc url_DrivePropertiesInsert_589907(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/properties")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DrivePropertiesInsert_589906(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a property to a file, or updates it if it already exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589908 = path.getOrDefault("fileId")
  valid_589908 = validateParameter(valid_589908, JString, required = true,
                                 default = nil)
  if valid_589908 != nil:
    section.add "fileId", valid_589908
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
  var valid_589909 = query.getOrDefault("fields")
  valid_589909 = validateParameter(valid_589909, JString, required = false,
                                 default = nil)
  if valid_589909 != nil:
    section.add "fields", valid_589909
  var valid_589910 = query.getOrDefault("quotaUser")
  valid_589910 = validateParameter(valid_589910, JString, required = false,
                                 default = nil)
  if valid_589910 != nil:
    section.add "quotaUser", valid_589910
  var valid_589911 = query.getOrDefault("alt")
  valid_589911 = validateParameter(valid_589911, JString, required = false,
                                 default = newJString("json"))
  if valid_589911 != nil:
    section.add "alt", valid_589911
  var valid_589912 = query.getOrDefault("oauth_token")
  valid_589912 = validateParameter(valid_589912, JString, required = false,
                                 default = nil)
  if valid_589912 != nil:
    section.add "oauth_token", valid_589912
  var valid_589913 = query.getOrDefault("userIp")
  valid_589913 = validateParameter(valid_589913, JString, required = false,
                                 default = nil)
  if valid_589913 != nil:
    section.add "userIp", valid_589913
  var valid_589914 = query.getOrDefault("key")
  valid_589914 = validateParameter(valid_589914, JString, required = false,
                                 default = nil)
  if valid_589914 != nil:
    section.add "key", valid_589914
  var valid_589915 = query.getOrDefault("prettyPrint")
  valid_589915 = validateParameter(valid_589915, JBool, required = false,
                                 default = newJBool(true))
  if valid_589915 != nil:
    section.add "prettyPrint", valid_589915
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589917: Call_DrivePropertiesInsert_589905; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a property to a file, or updates it if it already exists.
  ## 
  let valid = call_589917.validator(path, query, header, formData, body)
  let scheme = call_589917.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589917.url(scheme.get, call_589917.host, call_589917.base,
                         call_589917.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589917, url, valid)

proc call*(call_589918: Call_DrivePropertiesInsert_589905; fileId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## drivePropertiesInsert
  ## Adds a property to a file, or updates it if it already exists.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
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
  var path_589919 = newJObject()
  var query_589920 = newJObject()
  var body_589921 = newJObject()
  add(query_589920, "fields", newJString(fields))
  add(query_589920, "quotaUser", newJString(quotaUser))
  add(path_589919, "fileId", newJString(fileId))
  add(query_589920, "alt", newJString(alt))
  add(query_589920, "oauth_token", newJString(oauthToken))
  add(query_589920, "userIp", newJString(userIp))
  add(query_589920, "key", newJString(key))
  if body != nil:
    body_589921 = body
  add(query_589920, "prettyPrint", newJBool(prettyPrint))
  result = call_589918.call(path_589919, query_589920, nil, nil, body_589921)

var drivePropertiesInsert* = Call_DrivePropertiesInsert_589905(
    name: "drivePropertiesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/properties",
    validator: validate_DrivePropertiesInsert_589906, base: "/drive/v2",
    url: url_DrivePropertiesInsert_589907, schemes: {Scheme.Https})
type
  Call_DrivePropertiesList_589890 = ref object of OpenApiRestCall_588457
proc url_DrivePropertiesList_589892(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/properties")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DrivePropertiesList_589891(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists a file's properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589893 = path.getOrDefault("fileId")
  valid_589893 = validateParameter(valid_589893, JString, required = true,
                                 default = nil)
  if valid_589893 != nil:
    section.add "fileId", valid_589893
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
  var valid_589894 = query.getOrDefault("fields")
  valid_589894 = validateParameter(valid_589894, JString, required = false,
                                 default = nil)
  if valid_589894 != nil:
    section.add "fields", valid_589894
  var valid_589895 = query.getOrDefault("quotaUser")
  valid_589895 = validateParameter(valid_589895, JString, required = false,
                                 default = nil)
  if valid_589895 != nil:
    section.add "quotaUser", valid_589895
  var valid_589896 = query.getOrDefault("alt")
  valid_589896 = validateParameter(valid_589896, JString, required = false,
                                 default = newJString("json"))
  if valid_589896 != nil:
    section.add "alt", valid_589896
  var valid_589897 = query.getOrDefault("oauth_token")
  valid_589897 = validateParameter(valid_589897, JString, required = false,
                                 default = nil)
  if valid_589897 != nil:
    section.add "oauth_token", valid_589897
  var valid_589898 = query.getOrDefault("userIp")
  valid_589898 = validateParameter(valid_589898, JString, required = false,
                                 default = nil)
  if valid_589898 != nil:
    section.add "userIp", valid_589898
  var valid_589899 = query.getOrDefault("key")
  valid_589899 = validateParameter(valid_589899, JString, required = false,
                                 default = nil)
  if valid_589899 != nil:
    section.add "key", valid_589899
  var valid_589900 = query.getOrDefault("prettyPrint")
  valid_589900 = validateParameter(valid_589900, JBool, required = false,
                                 default = newJBool(true))
  if valid_589900 != nil:
    section.add "prettyPrint", valid_589900
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589901: Call_DrivePropertiesList_589890; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's properties.
  ## 
  let valid = call_589901.validator(path, query, header, formData, body)
  let scheme = call_589901.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589901.url(scheme.get, call_589901.host, call_589901.base,
                         call_589901.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589901, url, valid)

proc call*(call_589902: Call_DrivePropertiesList_589890; fileId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## drivePropertiesList
  ## Lists a file's properties.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
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
  var path_589903 = newJObject()
  var query_589904 = newJObject()
  add(query_589904, "fields", newJString(fields))
  add(query_589904, "quotaUser", newJString(quotaUser))
  add(path_589903, "fileId", newJString(fileId))
  add(query_589904, "alt", newJString(alt))
  add(query_589904, "oauth_token", newJString(oauthToken))
  add(query_589904, "userIp", newJString(userIp))
  add(query_589904, "key", newJString(key))
  add(query_589904, "prettyPrint", newJBool(prettyPrint))
  result = call_589902.call(path_589903, query_589904, nil, nil, nil)

var drivePropertiesList* = Call_DrivePropertiesList_589890(
    name: "drivePropertiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/properties",
    validator: validate_DrivePropertiesList_589891, base: "/drive/v2",
    url: url_DrivePropertiesList_589892, schemes: {Scheme.Https})
type
  Call_DrivePropertiesUpdate_589939 = ref object of OpenApiRestCall_588457
proc url_DrivePropertiesUpdate_589941(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "propertyKey" in path, "`propertyKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/properties/"),
               (kind: VariableSegment, value: "propertyKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DrivePropertiesUpdate_589940(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   propertyKey: JString (required)
  ##              : The key of the property.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589942 = path.getOrDefault("fileId")
  valid_589942 = validateParameter(valid_589942, JString, required = true,
                                 default = nil)
  if valid_589942 != nil:
    section.add "fileId", valid_589942
  var valid_589943 = path.getOrDefault("propertyKey")
  valid_589943 = validateParameter(valid_589943, JString, required = true,
                                 default = nil)
  if valid_589943 != nil:
    section.add "propertyKey", valid_589943
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
  ##   visibility: JString
  ##             : The visibility of the property. Allowed values are PRIVATE and PUBLIC. (Default: PRIVATE)
  section = newJObject()
  var valid_589944 = query.getOrDefault("fields")
  valid_589944 = validateParameter(valid_589944, JString, required = false,
                                 default = nil)
  if valid_589944 != nil:
    section.add "fields", valid_589944
  var valid_589945 = query.getOrDefault("quotaUser")
  valid_589945 = validateParameter(valid_589945, JString, required = false,
                                 default = nil)
  if valid_589945 != nil:
    section.add "quotaUser", valid_589945
  var valid_589946 = query.getOrDefault("alt")
  valid_589946 = validateParameter(valid_589946, JString, required = false,
                                 default = newJString("json"))
  if valid_589946 != nil:
    section.add "alt", valid_589946
  var valid_589947 = query.getOrDefault("oauth_token")
  valid_589947 = validateParameter(valid_589947, JString, required = false,
                                 default = nil)
  if valid_589947 != nil:
    section.add "oauth_token", valid_589947
  var valid_589948 = query.getOrDefault("userIp")
  valid_589948 = validateParameter(valid_589948, JString, required = false,
                                 default = nil)
  if valid_589948 != nil:
    section.add "userIp", valid_589948
  var valid_589949 = query.getOrDefault("key")
  valid_589949 = validateParameter(valid_589949, JString, required = false,
                                 default = nil)
  if valid_589949 != nil:
    section.add "key", valid_589949
  var valid_589950 = query.getOrDefault("prettyPrint")
  valid_589950 = validateParameter(valid_589950, JBool, required = false,
                                 default = newJBool(true))
  if valid_589950 != nil:
    section.add "prettyPrint", valid_589950
  var valid_589951 = query.getOrDefault("visibility")
  valid_589951 = validateParameter(valid_589951, JString, required = false,
                                 default = newJString("private"))
  if valid_589951 != nil:
    section.add "visibility", valid_589951
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589953: Call_DrivePropertiesUpdate_589939; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a property.
  ## 
  let valid = call_589953.validator(path, query, header, formData, body)
  let scheme = call_589953.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589953.url(scheme.get, call_589953.host, call_589953.base,
                         call_589953.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589953, url, valid)

proc call*(call_589954: Call_DrivePropertiesUpdate_589939; fileId: string;
          propertyKey: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true;
          visibility: string = "private"): Recallable =
  ## drivePropertiesUpdate
  ## Updates a property.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   propertyKey: string (required)
  ##              : The key of the property.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   visibility: string
  ##             : The visibility of the property. Allowed values are PRIVATE and PUBLIC. (Default: PRIVATE)
  var path_589955 = newJObject()
  var query_589956 = newJObject()
  var body_589957 = newJObject()
  add(query_589956, "fields", newJString(fields))
  add(query_589956, "quotaUser", newJString(quotaUser))
  add(path_589955, "fileId", newJString(fileId))
  add(query_589956, "alt", newJString(alt))
  add(query_589956, "oauth_token", newJString(oauthToken))
  add(query_589956, "userIp", newJString(userIp))
  add(query_589956, "key", newJString(key))
  add(path_589955, "propertyKey", newJString(propertyKey))
  if body != nil:
    body_589957 = body
  add(query_589956, "prettyPrint", newJBool(prettyPrint))
  add(query_589956, "visibility", newJString(visibility))
  result = call_589954.call(path_589955, query_589956, nil, nil, body_589957)

var drivePropertiesUpdate* = Call_DrivePropertiesUpdate_589939(
    name: "drivePropertiesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/files/{fileId}/properties/{propertyKey}",
    validator: validate_DrivePropertiesUpdate_589940, base: "/drive/v2",
    url: url_DrivePropertiesUpdate_589941, schemes: {Scheme.Https})
type
  Call_DrivePropertiesGet_589922 = ref object of OpenApiRestCall_588457
proc url_DrivePropertiesGet_589924(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "propertyKey" in path, "`propertyKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/properties/"),
               (kind: VariableSegment, value: "propertyKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DrivePropertiesGet_589923(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets a property by its key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   propertyKey: JString (required)
  ##              : The key of the property.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589925 = path.getOrDefault("fileId")
  valid_589925 = validateParameter(valid_589925, JString, required = true,
                                 default = nil)
  if valid_589925 != nil:
    section.add "fileId", valid_589925
  var valid_589926 = path.getOrDefault("propertyKey")
  valid_589926 = validateParameter(valid_589926, JString, required = true,
                                 default = nil)
  if valid_589926 != nil:
    section.add "propertyKey", valid_589926
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
  ##   visibility: JString
  ##             : The visibility of the property.
  section = newJObject()
  var valid_589927 = query.getOrDefault("fields")
  valid_589927 = validateParameter(valid_589927, JString, required = false,
                                 default = nil)
  if valid_589927 != nil:
    section.add "fields", valid_589927
  var valid_589928 = query.getOrDefault("quotaUser")
  valid_589928 = validateParameter(valid_589928, JString, required = false,
                                 default = nil)
  if valid_589928 != nil:
    section.add "quotaUser", valid_589928
  var valid_589929 = query.getOrDefault("alt")
  valid_589929 = validateParameter(valid_589929, JString, required = false,
                                 default = newJString("json"))
  if valid_589929 != nil:
    section.add "alt", valid_589929
  var valid_589930 = query.getOrDefault("oauth_token")
  valid_589930 = validateParameter(valid_589930, JString, required = false,
                                 default = nil)
  if valid_589930 != nil:
    section.add "oauth_token", valid_589930
  var valid_589931 = query.getOrDefault("userIp")
  valid_589931 = validateParameter(valid_589931, JString, required = false,
                                 default = nil)
  if valid_589931 != nil:
    section.add "userIp", valid_589931
  var valid_589932 = query.getOrDefault("key")
  valid_589932 = validateParameter(valid_589932, JString, required = false,
                                 default = nil)
  if valid_589932 != nil:
    section.add "key", valid_589932
  var valid_589933 = query.getOrDefault("prettyPrint")
  valid_589933 = validateParameter(valid_589933, JBool, required = false,
                                 default = newJBool(true))
  if valid_589933 != nil:
    section.add "prettyPrint", valid_589933
  var valid_589934 = query.getOrDefault("visibility")
  valid_589934 = validateParameter(valid_589934, JString, required = false,
                                 default = newJString("private"))
  if valid_589934 != nil:
    section.add "visibility", valid_589934
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589935: Call_DrivePropertiesGet_589922; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a property by its key.
  ## 
  let valid = call_589935.validator(path, query, header, formData, body)
  let scheme = call_589935.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589935.url(scheme.get, call_589935.host, call_589935.base,
                         call_589935.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589935, url, valid)

proc call*(call_589936: Call_DrivePropertiesGet_589922; fileId: string;
          propertyKey: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true; visibility: string = "private"): Recallable =
  ## drivePropertiesGet
  ## Gets a property by its key.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   propertyKey: string (required)
  ##              : The key of the property.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   visibility: string
  ##             : The visibility of the property.
  var path_589937 = newJObject()
  var query_589938 = newJObject()
  add(query_589938, "fields", newJString(fields))
  add(query_589938, "quotaUser", newJString(quotaUser))
  add(path_589937, "fileId", newJString(fileId))
  add(query_589938, "alt", newJString(alt))
  add(query_589938, "oauth_token", newJString(oauthToken))
  add(query_589938, "userIp", newJString(userIp))
  add(query_589938, "key", newJString(key))
  add(path_589937, "propertyKey", newJString(propertyKey))
  add(query_589938, "prettyPrint", newJBool(prettyPrint))
  add(query_589938, "visibility", newJString(visibility))
  result = call_589936.call(path_589937, query_589938, nil, nil, nil)

var drivePropertiesGet* = Call_DrivePropertiesGet_589922(
    name: "drivePropertiesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/properties/{propertyKey}",
    validator: validate_DrivePropertiesGet_589923, base: "/drive/v2",
    url: url_DrivePropertiesGet_589924, schemes: {Scheme.Https})
type
  Call_DrivePropertiesPatch_589975 = ref object of OpenApiRestCall_588457
proc url_DrivePropertiesPatch_589977(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "propertyKey" in path, "`propertyKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/properties/"),
               (kind: VariableSegment, value: "propertyKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DrivePropertiesPatch_589976(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   propertyKey: JString (required)
  ##              : The key of the property.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589978 = path.getOrDefault("fileId")
  valid_589978 = validateParameter(valid_589978, JString, required = true,
                                 default = nil)
  if valid_589978 != nil:
    section.add "fileId", valid_589978
  var valid_589979 = path.getOrDefault("propertyKey")
  valid_589979 = validateParameter(valid_589979, JString, required = true,
                                 default = nil)
  if valid_589979 != nil:
    section.add "propertyKey", valid_589979
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
  ##   visibility: JString
  ##             : The visibility of the property. Allowed values are PRIVATE and PUBLIC. (Default: PRIVATE)
  section = newJObject()
  var valid_589980 = query.getOrDefault("fields")
  valid_589980 = validateParameter(valid_589980, JString, required = false,
                                 default = nil)
  if valid_589980 != nil:
    section.add "fields", valid_589980
  var valid_589981 = query.getOrDefault("quotaUser")
  valid_589981 = validateParameter(valid_589981, JString, required = false,
                                 default = nil)
  if valid_589981 != nil:
    section.add "quotaUser", valid_589981
  var valid_589982 = query.getOrDefault("alt")
  valid_589982 = validateParameter(valid_589982, JString, required = false,
                                 default = newJString("json"))
  if valid_589982 != nil:
    section.add "alt", valid_589982
  var valid_589983 = query.getOrDefault("oauth_token")
  valid_589983 = validateParameter(valid_589983, JString, required = false,
                                 default = nil)
  if valid_589983 != nil:
    section.add "oauth_token", valid_589983
  var valid_589984 = query.getOrDefault("userIp")
  valid_589984 = validateParameter(valid_589984, JString, required = false,
                                 default = nil)
  if valid_589984 != nil:
    section.add "userIp", valid_589984
  var valid_589985 = query.getOrDefault("key")
  valid_589985 = validateParameter(valid_589985, JString, required = false,
                                 default = nil)
  if valid_589985 != nil:
    section.add "key", valid_589985
  var valid_589986 = query.getOrDefault("prettyPrint")
  valid_589986 = validateParameter(valid_589986, JBool, required = false,
                                 default = newJBool(true))
  if valid_589986 != nil:
    section.add "prettyPrint", valid_589986
  var valid_589987 = query.getOrDefault("visibility")
  valid_589987 = validateParameter(valid_589987, JString, required = false,
                                 default = newJString("private"))
  if valid_589987 != nil:
    section.add "visibility", valid_589987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589989: Call_DrivePropertiesPatch_589975; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a property.
  ## 
  let valid = call_589989.validator(path, query, header, formData, body)
  let scheme = call_589989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589989.url(scheme.get, call_589989.host, call_589989.base,
                         call_589989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589989, url, valid)

proc call*(call_589990: Call_DrivePropertiesPatch_589975; fileId: string;
          propertyKey: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true;
          visibility: string = "private"): Recallable =
  ## drivePropertiesPatch
  ## Updates a property.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   propertyKey: string (required)
  ##              : The key of the property.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   visibility: string
  ##             : The visibility of the property. Allowed values are PRIVATE and PUBLIC. (Default: PRIVATE)
  var path_589991 = newJObject()
  var query_589992 = newJObject()
  var body_589993 = newJObject()
  add(query_589992, "fields", newJString(fields))
  add(query_589992, "quotaUser", newJString(quotaUser))
  add(path_589991, "fileId", newJString(fileId))
  add(query_589992, "alt", newJString(alt))
  add(query_589992, "oauth_token", newJString(oauthToken))
  add(query_589992, "userIp", newJString(userIp))
  add(query_589992, "key", newJString(key))
  add(path_589991, "propertyKey", newJString(propertyKey))
  if body != nil:
    body_589993 = body
  add(query_589992, "prettyPrint", newJBool(prettyPrint))
  add(query_589992, "visibility", newJString(visibility))
  result = call_589990.call(path_589991, query_589992, nil, nil, body_589993)

var drivePropertiesPatch* = Call_DrivePropertiesPatch_589975(
    name: "drivePropertiesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/files/{fileId}/properties/{propertyKey}",
    validator: validate_DrivePropertiesPatch_589976, base: "/drive/v2",
    url: url_DrivePropertiesPatch_589977, schemes: {Scheme.Https})
type
  Call_DrivePropertiesDelete_589958 = ref object of OpenApiRestCall_588457
proc url_DrivePropertiesDelete_589960(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "propertyKey" in path, "`propertyKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/properties/"),
               (kind: VariableSegment, value: "propertyKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DrivePropertiesDelete_589959(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   propertyKey: JString (required)
  ##              : The key of the property.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589961 = path.getOrDefault("fileId")
  valid_589961 = validateParameter(valid_589961, JString, required = true,
                                 default = nil)
  if valid_589961 != nil:
    section.add "fileId", valid_589961
  var valid_589962 = path.getOrDefault("propertyKey")
  valid_589962 = validateParameter(valid_589962, JString, required = true,
                                 default = nil)
  if valid_589962 != nil:
    section.add "propertyKey", valid_589962
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
  ##   visibility: JString
  ##             : The visibility of the property.
  section = newJObject()
  var valid_589963 = query.getOrDefault("fields")
  valid_589963 = validateParameter(valid_589963, JString, required = false,
                                 default = nil)
  if valid_589963 != nil:
    section.add "fields", valid_589963
  var valid_589964 = query.getOrDefault("quotaUser")
  valid_589964 = validateParameter(valid_589964, JString, required = false,
                                 default = nil)
  if valid_589964 != nil:
    section.add "quotaUser", valid_589964
  var valid_589965 = query.getOrDefault("alt")
  valid_589965 = validateParameter(valid_589965, JString, required = false,
                                 default = newJString("json"))
  if valid_589965 != nil:
    section.add "alt", valid_589965
  var valid_589966 = query.getOrDefault("oauth_token")
  valid_589966 = validateParameter(valid_589966, JString, required = false,
                                 default = nil)
  if valid_589966 != nil:
    section.add "oauth_token", valid_589966
  var valid_589967 = query.getOrDefault("userIp")
  valid_589967 = validateParameter(valid_589967, JString, required = false,
                                 default = nil)
  if valid_589967 != nil:
    section.add "userIp", valid_589967
  var valid_589968 = query.getOrDefault("key")
  valid_589968 = validateParameter(valid_589968, JString, required = false,
                                 default = nil)
  if valid_589968 != nil:
    section.add "key", valid_589968
  var valid_589969 = query.getOrDefault("prettyPrint")
  valid_589969 = validateParameter(valid_589969, JBool, required = false,
                                 default = newJBool(true))
  if valid_589969 != nil:
    section.add "prettyPrint", valid_589969
  var valid_589970 = query.getOrDefault("visibility")
  valid_589970 = validateParameter(valid_589970, JString, required = false,
                                 default = newJString("private"))
  if valid_589970 != nil:
    section.add "visibility", valid_589970
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589971: Call_DrivePropertiesDelete_589958; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a property.
  ## 
  let valid = call_589971.validator(path, query, header, formData, body)
  let scheme = call_589971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589971.url(scheme.get, call_589971.host, call_589971.base,
                         call_589971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589971, url, valid)

proc call*(call_589972: Call_DrivePropertiesDelete_589958; fileId: string;
          propertyKey: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true; visibility: string = "private"): Recallable =
  ## drivePropertiesDelete
  ## Deletes a property.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   propertyKey: string (required)
  ##              : The key of the property.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   visibility: string
  ##             : The visibility of the property.
  var path_589973 = newJObject()
  var query_589974 = newJObject()
  add(query_589974, "fields", newJString(fields))
  add(query_589974, "quotaUser", newJString(quotaUser))
  add(path_589973, "fileId", newJString(fileId))
  add(query_589974, "alt", newJString(alt))
  add(query_589974, "oauth_token", newJString(oauthToken))
  add(query_589974, "userIp", newJString(userIp))
  add(query_589974, "key", newJString(key))
  add(path_589973, "propertyKey", newJString(propertyKey))
  add(query_589974, "prettyPrint", newJBool(prettyPrint))
  add(query_589974, "visibility", newJString(visibility))
  result = call_589972.call(path_589973, query_589974, nil, nil, nil)

var drivePropertiesDelete* = Call_DrivePropertiesDelete_589958(
    name: "drivePropertiesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/properties/{propertyKey}",
    validator: validate_DrivePropertiesDelete_589959, base: "/drive/v2",
    url: url_DrivePropertiesDelete_589960, schemes: {Scheme.Https})
type
  Call_DriveRealtimeUpdate_590010 = ref object of OpenApiRestCall_588457
proc url_DriveRealtimeUpdate_590012(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/realtime")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveRealtimeUpdate_590011(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Overwrites the Realtime API data model associated with this file with the provided JSON data model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file that the Realtime API data model is associated with.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_590013 = path.getOrDefault("fileId")
  valid_590013 = validateParameter(valid_590013, JString, required = true,
                                 default = nil)
  if valid_590013 != nil:
    section.add "fileId", valid_590013
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
  ##   baseRevision: JString
  ##               : The revision of the model to diff the uploaded model against. If set, the uploaded model is diffed against the provided revision and those differences are merged with any changes made to the model after the provided revision. If not set, the uploaded model replaces the current model on the server.
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
  var valid_590018 = query.getOrDefault("baseRevision")
  valid_590018 = validateParameter(valid_590018, JString, required = false,
                                 default = nil)
  if valid_590018 != nil:
    section.add "baseRevision", valid_590018
  var valid_590019 = query.getOrDefault("userIp")
  valid_590019 = validateParameter(valid_590019, JString, required = false,
                                 default = nil)
  if valid_590019 != nil:
    section.add "userIp", valid_590019
  var valid_590020 = query.getOrDefault("key")
  valid_590020 = validateParameter(valid_590020, JString, required = false,
                                 default = nil)
  if valid_590020 != nil:
    section.add "key", valid_590020
  var valid_590021 = query.getOrDefault("prettyPrint")
  valid_590021 = validateParameter(valid_590021, JBool, required = false,
                                 default = newJBool(true))
  if valid_590021 != nil:
    section.add "prettyPrint", valid_590021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590022: Call_DriveRealtimeUpdate_590010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Overwrites the Realtime API data model associated with this file with the provided JSON data model.
  ## 
  let valid = call_590022.validator(path, query, header, formData, body)
  let scheme = call_590022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590022.url(scheme.get, call_590022.host, call_590022.base,
                         call_590022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590022, url, valid)

proc call*(call_590023: Call_DriveRealtimeUpdate_590010; fileId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; baseRevision: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveRealtimeUpdate
  ## Overwrites the Realtime API data model associated with this file with the provided JSON data model.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file that the Realtime API data model is associated with.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   baseRevision: string
  ##               : The revision of the model to diff the uploaded model against. If set, the uploaded model is diffed against the provided revision and those differences are merged with any changes made to the model after the provided revision. If not set, the uploaded model replaces the current model on the server.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590024 = newJObject()
  var query_590025 = newJObject()
  add(query_590025, "fields", newJString(fields))
  add(query_590025, "quotaUser", newJString(quotaUser))
  add(path_590024, "fileId", newJString(fileId))
  add(query_590025, "alt", newJString(alt))
  add(query_590025, "oauth_token", newJString(oauthToken))
  add(query_590025, "baseRevision", newJString(baseRevision))
  add(query_590025, "userIp", newJString(userIp))
  add(query_590025, "key", newJString(key))
  add(query_590025, "prettyPrint", newJBool(prettyPrint))
  result = call_590023.call(path_590024, query_590025, nil, nil, nil)

var driveRealtimeUpdate* = Call_DriveRealtimeUpdate_590010(
    name: "driveRealtimeUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/files/{fileId}/realtime",
    validator: validate_DriveRealtimeUpdate_590011, base: "/drive/v2",
    url: url_DriveRealtimeUpdate_590012, schemes: {Scheme.Https})
type
  Call_DriveRealtimeGet_589994 = ref object of OpenApiRestCall_588457
proc url_DriveRealtimeGet_589996(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/realtime")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveRealtimeGet_589995(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Exports the contents of the Realtime API data model associated with this file as JSON.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file that the Realtime API data model is associated with.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_589997 = path.getOrDefault("fileId")
  valid_589997 = validateParameter(valid_589997, JString, required = true,
                                 default = nil)
  if valid_589997 != nil:
    section.add "fileId", valid_589997
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
  ##   revision: JInt
  ##           : The revision of the Realtime API data model to export. Revisions start at 1 (the initial empty data model) and are incremented with each change. If this parameter is excluded, the most recent data model will be returned.
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
  var valid_590003 = query.getOrDefault("revision")
  valid_590003 = validateParameter(valid_590003, JInt, required = false, default = nil)
  if valid_590003 != nil:
    section.add "revision", valid_590003
  var valid_590004 = query.getOrDefault("key")
  valid_590004 = validateParameter(valid_590004, JString, required = false,
                                 default = nil)
  if valid_590004 != nil:
    section.add "key", valid_590004
  var valid_590005 = query.getOrDefault("prettyPrint")
  valid_590005 = validateParameter(valid_590005, JBool, required = false,
                                 default = newJBool(true))
  if valid_590005 != nil:
    section.add "prettyPrint", valid_590005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590006: Call_DriveRealtimeGet_589994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports the contents of the Realtime API data model associated with this file as JSON.
  ## 
  let valid = call_590006.validator(path, query, header, formData, body)
  let scheme = call_590006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590006.url(scheme.get, call_590006.host, call_590006.base,
                         call_590006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590006, url, valid)

proc call*(call_590007: Call_DriveRealtimeGet_589994; fileId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; revision: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## driveRealtimeGet
  ## Exports the contents of the Realtime API data model associated with this file as JSON.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file that the Realtime API data model is associated with.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   revision: int
  ##           : The revision of the Realtime API data model to export. Revisions start at 1 (the initial empty data model) and are incremented with each change. If this parameter is excluded, the most recent data model will be returned.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590008 = newJObject()
  var query_590009 = newJObject()
  add(query_590009, "fields", newJString(fields))
  add(query_590009, "quotaUser", newJString(quotaUser))
  add(path_590008, "fileId", newJString(fileId))
  add(query_590009, "alt", newJString(alt))
  add(query_590009, "oauth_token", newJString(oauthToken))
  add(query_590009, "userIp", newJString(userIp))
  add(query_590009, "revision", newJInt(revision))
  add(query_590009, "key", newJString(key))
  add(query_590009, "prettyPrint", newJBool(prettyPrint))
  result = call_590007.call(path_590008, query_590009, nil, nil, nil)

var driveRealtimeGet* = Call_DriveRealtimeGet_589994(name: "driveRealtimeGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/realtime", validator: validate_DriveRealtimeGet_589995,
    base: "/drive/v2", url: url_DriveRealtimeGet_589996, schemes: {Scheme.Https})
type
  Call_DriveRevisionsList_590026 = ref object of OpenApiRestCall_588457
proc url_DriveRevisionsList_590028(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/revisions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveRevisionsList_590027(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists a file's revisions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_590029 = path.getOrDefault("fileId")
  valid_590029 = validateParameter(valid_590029, JString, required = true,
                                 default = nil)
  if valid_590029 != nil:
    section.add "fileId", valid_590029
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Page token for revisions. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of revisions to return.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590030 = query.getOrDefault("fields")
  valid_590030 = validateParameter(valid_590030, JString, required = false,
                                 default = nil)
  if valid_590030 != nil:
    section.add "fields", valid_590030
  var valid_590031 = query.getOrDefault("pageToken")
  valid_590031 = validateParameter(valid_590031, JString, required = false,
                                 default = nil)
  if valid_590031 != nil:
    section.add "pageToken", valid_590031
  var valid_590032 = query.getOrDefault("quotaUser")
  valid_590032 = validateParameter(valid_590032, JString, required = false,
                                 default = nil)
  if valid_590032 != nil:
    section.add "quotaUser", valid_590032
  var valid_590033 = query.getOrDefault("alt")
  valid_590033 = validateParameter(valid_590033, JString, required = false,
                                 default = newJString("json"))
  if valid_590033 != nil:
    section.add "alt", valid_590033
  var valid_590034 = query.getOrDefault("oauth_token")
  valid_590034 = validateParameter(valid_590034, JString, required = false,
                                 default = nil)
  if valid_590034 != nil:
    section.add "oauth_token", valid_590034
  var valid_590035 = query.getOrDefault("userIp")
  valid_590035 = validateParameter(valid_590035, JString, required = false,
                                 default = nil)
  if valid_590035 != nil:
    section.add "userIp", valid_590035
  var valid_590036 = query.getOrDefault("maxResults")
  valid_590036 = validateParameter(valid_590036, JInt, required = false,
                                 default = newJInt(200))
  if valid_590036 != nil:
    section.add "maxResults", valid_590036
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
  if body != nil:
    result.add "body", body

proc call*(call_590039: Call_DriveRevisionsList_590026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's revisions.
  ## 
  let valid = call_590039.validator(path, query, header, formData, body)
  let scheme = call_590039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590039.url(scheme.get, call_590039.host, call_590039.base,
                         call_590039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590039, url, valid)

proc call*(call_590040: Call_DriveRevisionsList_590026; fileId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 200; key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveRevisionsList
  ## Lists a file's revisions.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Page token for revisions. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of revisions to return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590041 = newJObject()
  var query_590042 = newJObject()
  add(query_590042, "fields", newJString(fields))
  add(query_590042, "pageToken", newJString(pageToken))
  add(query_590042, "quotaUser", newJString(quotaUser))
  add(path_590041, "fileId", newJString(fileId))
  add(query_590042, "alt", newJString(alt))
  add(query_590042, "oauth_token", newJString(oauthToken))
  add(query_590042, "userIp", newJString(userIp))
  add(query_590042, "maxResults", newJInt(maxResults))
  add(query_590042, "key", newJString(key))
  add(query_590042, "prettyPrint", newJBool(prettyPrint))
  result = call_590040.call(path_590041, query_590042, nil, nil, nil)

var driveRevisionsList* = Call_DriveRevisionsList_590026(
    name: "driveRevisionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions",
    validator: validate_DriveRevisionsList_590027, base: "/drive/v2",
    url: url_DriveRevisionsList_590028, schemes: {Scheme.Https})
type
  Call_DriveRevisionsUpdate_590059 = ref object of OpenApiRestCall_588457
proc url_DriveRevisionsUpdate_590061(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "revisionId" in path, "`revisionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/revisions/"),
               (kind: VariableSegment, value: "revisionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveRevisionsUpdate_590060(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a revision.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID for the file.
  ##   revisionId: JString (required)
  ##             : The ID for the revision.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_590062 = path.getOrDefault("fileId")
  valid_590062 = validateParameter(valid_590062, JString, required = true,
                                 default = nil)
  if valid_590062 != nil:
    section.add "fileId", valid_590062
  var valid_590063 = path.getOrDefault("revisionId")
  valid_590063 = validateParameter(valid_590063, JString, required = true,
                                 default = nil)
  if valid_590063 != nil:
    section.add "revisionId", valid_590063
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
  var valid_590064 = query.getOrDefault("fields")
  valid_590064 = validateParameter(valid_590064, JString, required = false,
                                 default = nil)
  if valid_590064 != nil:
    section.add "fields", valid_590064
  var valid_590065 = query.getOrDefault("quotaUser")
  valid_590065 = validateParameter(valid_590065, JString, required = false,
                                 default = nil)
  if valid_590065 != nil:
    section.add "quotaUser", valid_590065
  var valid_590066 = query.getOrDefault("alt")
  valid_590066 = validateParameter(valid_590066, JString, required = false,
                                 default = newJString("json"))
  if valid_590066 != nil:
    section.add "alt", valid_590066
  var valid_590067 = query.getOrDefault("oauth_token")
  valid_590067 = validateParameter(valid_590067, JString, required = false,
                                 default = nil)
  if valid_590067 != nil:
    section.add "oauth_token", valid_590067
  var valid_590068 = query.getOrDefault("userIp")
  valid_590068 = validateParameter(valid_590068, JString, required = false,
                                 default = nil)
  if valid_590068 != nil:
    section.add "userIp", valid_590068
  var valid_590069 = query.getOrDefault("key")
  valid_590069 = validateParameter(valid_590069, JString, required = false,
                                 default = nil)
  if valid_590069 != nil:
    section.add "key", valid_590069
  var valid_590070 = query.getOrDefault("prettyPrint")
  valid_590070 = validateParameter(valid_590070, JBool, required = false,
                                 default = newJBool(true))
  if valid_590070 != nil:
    section.add "prettyPrint", valid_590070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590072: Call_DriveRevisionsUpdate_590059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a revision.
  ## 
  let valid = call_590072.validator(path, query, header, formData, body)
  let scheme = call_590072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590072.url(scheme.get, call_590072.host, call_590072.base,
                         call_590072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590072, url, valid)

proc call*(call_590073: Call_DriveRevisionsUpdate_590059; fileId: string;
          revisionId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## driveRevisionsUpdate
  ## Updates a revision.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID for the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   revisionId: string (required)
  ##             : The ID for the revision.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590074 = newJObject()
  var query_590075 = newJObject()
  var body_590076 = newJObject()
  add(query_590075, "fields", newJString(fields))
  add(query_590075, "quotaUser", newJString(quotaUser))
  add(path_590074, "fileId", newJString(fileId))
  add(query_590075, "alt", newJString(alt))
  add(query_590075, "oauth_token", newJString(oauthToken))
  add(path_590074, "revisionId", newJString(revisionId))
  add(query_590075, "userIp", newJString(userIp))
  add(query_590075, "key", newJString(key))
  if body != nil:
    body_590076 = body
  add(query_590075, "prettyPrint", newJBool(prettyPrint))
  result = call_590073.call(path_590074, query_590075, nil, nil, body_590076)

var driveRevisionsUpdate* = Call_DriveRevisionsUpdate_590059(
    name: "driveRevisionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsUpdate_590060, base: "/drive/v2",
    url: url_DriveRevisionsUpdate_590061, schemes: {Scheme.Https})
type
  Call_DriveRevisionsGet_590043 = ref object of OpenApiRestCall_588457
proc url_DriveRevisionsGet_590045(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "revisionId" in path, "`revisionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/revisions/"),
               (kind: VariableSegment, value: "revisionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveRevisionsGet_590044(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a specific revision.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   revisionId: JString (required)
  ##             : The ID of the revision.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_590046 = path.getOrDefault("fileId")
  valid_590046 = validateParameter(valid_590046, JString, required = true,
                                 default = nil)
  if valid_590046 != nil:
    section.add "fileId", valid_590046
  var valid_590047 = path.getOrDefault("revisionId")
  valid_590047 = validateParameter(valid_590047, JString, required = true,
                                 default = nil)
  if valid_590047 != nil:
    section.add "revisionId", valid_590047
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
  var valid_590048 = query.getOrDefault("fields")
  valid_590048 = validateParameter(valid_590048, JString, required = false,
                                 default = nil)
  if valid_590048 != nil:
    section.add "fields", valid_590048
  var valid_590049 = query.getOrDefault("quotaUser")
  valid_590049 = validateParameter(valid_590049, JString, required = false,
                                 default = nil)
  if valid_590049 != nil:
    section.add "quotaUser", valid_590049
  var valid_590050 = query.getOrDefault("alt")
  valid_590050 = validateParameter(valid_590050, JString, required = false,
                                 default = newJString("json"))
  if valid_590050 != nil:
    section.add "alt", valid_590050
  var valid_590051 = query.getOrDefault("oauth_token")
  valid_590051 = validateParameter(valid_590051, JString, required = false,
                                 default = nil)
  if valid_590051 != nil:
    section.add "oauth_token", valid_590051
  var valid_590052 = query.getOrDefault("userIp")
  valid_590052 = validateParameter(valid_590052, JString, required = false,
                                 default = nil)
  if valid_590052 != nil:
    section.add "userIp", valid_590052
  var valid_590053 = query.getOrDefault("key")
  valid_590053 = validateParameter(valid_590053, JString, required = false,
                                 default = nil)
  if valid_590053 != nil:
    section.add "key", valid_590053
  var valid_590054 = query.getOrDefault("prettyPrint")
  valid_590054 = validateParameter(valid_590054, JBool, required = false,
                                 default = newJBool(true))
  if valid_590054 != nil:
    section.add "prettyPrint", valid_590054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590055: Call_DriveRevisionsGet_590043; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific revision.
  ## 
  let valid = call_590055.validator(path, query, header, formData, body)
  let scheme = call_590055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590055.url(scheme.get, call_590055.host, call_590055.base,
                         call_590055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590055, url, valid)

proc call*(call_590056: Call_DriveRevisionsGet_590043; fileId: string;
          revisionId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveRevisionsGet
  ## Gets a specific revision.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   revisionId: string (required)
  ##             : The ID of the revision.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590057 = newJObject()
  var query_590058 = newJObject()
  add(query_590058, "fields", newJString(fields))
  add(query_590058, "quotaUser", newJString(quotaUser))
  add(path_590057, "fileId", newJString(fileId))
  add(query_590058, "alt", newJString(alt))
  add(query_590058, "oauth_token", newJString(oauthToken))
  add(path_590057, "revisionId", newJString(revisionId))
  add(query_590058, "userIp", newJString(userIp))
  add(query_590058, "key", newJString(key))
  add(query_590058, "prettyPrint", newJBool(prettyPrint))
  result = call_590056.call(path_590057, query_590058, nil, nil, nil)

var driveRevisionsGet* = Call_DriveRevisionsGet_590043(name: "driveRevisionsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsGet_590044, base: "/drive/v2",
    url: url_DriveRevisionsGet_590045, schemes: {Scheme.Https})
type
  Call_DriveRevisionsPatch_590093 = ref object of OpenApiRestCall_588457
proc url_DriveRevisionsPatch_590095(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "revisionId" in path, "`revisionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/revisions/"),
               (kind: VariableSegment, value: "revisionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveRevisionsPatch_590094(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates a revision. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID for the file.
  ##   revisionId: JString (required)
  ##             : The ID for the revision.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_590096 = path.getOrDefault("fileId")
  valid_590096 = validateParameter(valid_590096, JString, required = true,
                                 default = nil)
  if valid_590096 != nil:
    section.add "fileId", valid_590096
  var valid_590097 = path.getOrDefault("revisionId")
  valid_590097 = validateParameter(valid_590097, JString, required = true,
                                 default = nil)
  if valid_590097 != nil:
    section.add "revisionId", valid_590097
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
  var valid_590098 = query.getOrDefault("fields")
  valid_590098 = validateParameter(valid_590098, JString, required = false,
                                 default = nil)
  if valid_590098 != nil:
    section.add "fields", valid_590098
  var valid_590099 = query.getOrDefault("quotaUser")
  valid_590099 = validateParameter(valid_590099, JString, required = false,
                                 default = nil)
  if valid_590099 != nil:
    section.add "quotaUser", valid_590099
  var valid_590100 = query.getOrDefault("alt")
  valid_590100 = validateParameter(valid_590100, JString, required = false,
                                 default = newJString("json"))
  if valid_590100 != nil:
    section.add "alt", valid_590100
  var valid_590101 = query.getOrDefault("oauth_token")
  valid_590101 = validateParameter(valid_590101, JString, required = false,
                                 default = nil)
  if valid_590101 != nil:
    section.add "oauth_token", valid_590101
  var valid_590102 = query.getOrDefault("userIp")
  valid_590102 = validateParameter(valid_590102, JString, required = false,
                                 default = nil)
  if valid_590102 != nil:
    section.add "userIp", valid_590102
  var valid_590103 = query.getOrDefault("key")
  valid_590103 = validateParameter(valid_590103, JString, required = false,
                                 default = nil)
  if valid_590103 != nil:
    section.add "key", valid_590103
  var valid_590104 = query.getOrDefault("prettyPrint")
  valid_590104 = validateParameter(valid_590104, JBool, required = false,
                                 default = newJBool(true))
  if valid_590104 != nil:
    section.add "prettyPrint", valid_590104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590106: Call_DriveRevisionsPatch_590093; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a revision. This method supports patch semantics.
  ## 
  let valid = call_590106.validator(path, query, header, formData, body)
  let scheme = call_590106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590106.url(scheme.get, call_590106.host, call_590106.base,
                         call_590106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590106, url, valid)

proc call*(call_590107: Call_DriveRevisionsPatch_590093; fileId: string;
          revisionId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## driveRevisionsPatch
  ## Updates a revision. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID for the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   revisionId: string (required)
  ##             : The ID for the revision.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590108 = newJObject()
  var query_590109 = newJObject()
  var body_590110 = newJObject()
  add(query_590109, "fields", newJString(fields))
  add(query_590109, "quotaUser", newJString(quotaUser))
  add(path_590108, "fileId", newJString(fileId))
  add(query_590109, "alt", newJString(alt))
  add(query_590109, "oauth_token", newJString(oauthToken))
  add(path_590108, "revisionId", newJString(revisionId))
  add(query_590109, "userIp", newJString(userIp))
  add(query_590109, "key", newJString(key))
  if body != nil:
    body_590110 = body
  add(query_590109, "prettyPrint", newJBool(prettyPrint))
  result = call_590107.call(path_590108, query_590109, nil, nil, body_590110)

var driveRevisionsPatch* = Call_DriveRevisionsPatch_590093(
    name: "driveRevisionsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsPatch_590094, base: "/drive/v2",
    url: url_DriveRevisionsPatch_590095, schemes: {Scheme.Https})
type
  Call_DriveRevisionsDelete_590077 = ref object of OpenApiRestCall_588457
proc url_DriveRevisionsDelete_590079(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "revisionId" in path, "`revisionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/revisions/"),
               (kind: VariableSegment, value: "revisionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveRevisionsDelete_590078(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Permanently deletes a file version. You can only delete revisions for files with binary content, like images or videos. Revisions for other files, like Google Docs or Sheets, and the last remaining file version can't be deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   revisionId: JString (required)
  ##             : The ID of the revision.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_590080 = path.getOrDefault("fileId")
  valid_590080 = validateParameter(valid_590080, JString, required = true,
                                 default = nil)
  if valid_590080 != nil:
    section.add "fileId", valid_590080
  var valid_590081 = path.getOrDefault("revisionId")
  valid_590081 = validateParameter(valid_590081, JString, required = true,
                                 default = nil)
  if valid_590081 != nil:
    section.add "revisionId", valid_590081
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
  var valid_590082 = query.getOrDefault("fields")
  valid_590082 = validateParameter(valid_590082, JString, required = false,
                                 default = nil)
  if valid_590082 != nil:
    section.add "fields", valid_590082
  var valid_590083 = query.getOrDefault("quotaUser")
  valid_590083 = validateParameter(valid_590083, JString, required = false,
                                 default = nil)
  if valid_590083 != nil:
    section.add "quotaUser", valid_590083
  var valid_590084 = query.getOrDefault("alt")
  valid_590084 = validateParameter(valid_590084, JString, required = false,
                                 default = newJString("json"))
  if valid_590084 != nil:
    section.add "alt", valid_590084
  var valid_590085 = query.getOrDefault("oauth_token")
  valid_590085 = validateParameter(valid_590085, JString, required = false,
                                 default = nil)
  if valid_590085 != nil:
    section.add "oauth_token", valid_590085
  var valid_590086 = query.getOrDefault("userIp")
  valid_590086 = validateParameter(valid_590086, JString, required = false,
                                 default = nil)
  if valid_590086 != nil:
    section.add "userIp", valid_590086
  var valid_590087 = query.getOrDefault("key")
  valid_590087 = validateParameter(valid_590087, JString, required = false,
                                 default = nil)
  if valid_590087 != nil:
    section.add "key", valid_590087
  var valid_590088 = query.getOrDefault("prettyPrint")
  valid_590088 = validateParameter(valid_590088, JBool, required = false,
                                 default = newJBool(true))
  if valid_590088 != nil:
    section.add "prettyPrint", valid_590088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590089: Call_DriveRevisionsDelete_590077; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a file version. You can only delete revisions for files with binary content, like images or videos. Revisions for other files, like Google Docs or Sheets, and the last remaining file version can't be deleted.
  ## 
  let valid = call_590089.validator(path, query, header, formData, body)
  let scheme = call_590089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590089.url(scheme.get, call_590089.host, call_590089.base,
                         call_590089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590089, url, valid)

proc call*(call_590090: Call_DriveRevisionsDelete_590077; fileId: string;
          revisionId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveRevisionsDelete
  ## Permanently deletes a file version. You can only delete revisions for files with binary content, like images or videos. Revisions for other files, like Google Docs or Sheets, and the last remaining file version can't be deleted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   revisionId: string (required)
  ##             : The ID of the revision.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590091 = newJObject()
  var query_590092 = newJObject()
  add(query_590092, "fields", newJString(fields))
  add(query_590092, "quotaUser", newJString(quotaUser))
  add(path_590091, "fileId", newJString(fileId))
  add(query_590092, "alt", newJString(alt))
  add(query_590092, "oauth_token", newJString(oauthToken))
  add(path_590091, "revisionId", newJString(revisionId))
  add(query_590092, "userIp", newJString(userIp))
  add(query_590092, "key", newJString(key))
  add(query_590092, "prettyPrint", newJBool(prettyPrint))
  result = call_590090.call(path_590091, query_590092, nil, nil, nil)

var driveRevisionsDelete* = Call_DriveRevisionsDelete_590077(
    name: "driveRevisionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsDelete_590078, base: "/drive/v2",
    url: url_DriveRevisionsDelete_590079, schemes: {Scheme.Https})
type
  Call_DriveFilesTouch_590111 = ref object of OpenApiRestCall_588457
proc url_DriveFilesTouch_590113(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/touch")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveFilesTouch_590112(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Set the file's updated time to the current server time.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_590114 = path.getOrDefault("fileId")
  valid_590114 = validateParameter(valid_590114, JString, required = true,
                                 default = nil)
  if valid_590114 != nil:
    section.add "fileId", valid_590114
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
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
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590115 = query.getOrDefault("supportsAllDrives")
  valid_590115 = validateParameter(valid_590115, JBool, required = false,
                                 default = newJBool(false))
  if valid_590115 != nil:
    section.add "supportsAllDrives", valid_590115
  var valid_590116 = query.getOrDefault("fields")
  valid_590116 = validateParameter(valid_590116, JString, required = false,
                                 default = nil)
  if valid_590116 != nil:
    section.add "fields", valid_590116
  var valid_590117 = query.getOrDefault("quotaUser")
  valid_590117 = validateParameter(valid_590117, JString, required = false,
                                 default = nil)
  if valid_590117 != nil:
    section.add "quotaUser", valid_590117
  var valid_590118 = query.getOrDefault("alt")
  valid_590118 = validateParameter(valid_590118, JString, required = false,
                                 default = newJString("json"))
  if valid_590118 != nil:
    section.add "alt", valid_590118
  var valid_590119 = query.getOrDefault("oauth_token")
  valid_590119 = validateParameter(valid_590119, JString, required = false,
                                 default = nil)
  if valid_590119 != nil:
    section.add "oauth_token", valid_590119
  var valid_590120 = query.getOrDefault("userIp")
  valid_590120 = validateParameter(valid_590120, JString, required = false,
                                 default = nil)
  if valid_590120 != nil:
    section.add "userIp", valid_590120
  var valid_590121 = query.getOrDefault("supportsTeamDrives")
  valid_590121 = validateParameter(valid_590121, JBool, required = false,
                                 default = newJBool(false))
  if valid_590121 != nil:
    section.add "supportsTeamDrives", valid_590121
  var valid_590122 = query.getOrDefault("key")
  valid_590122 = validateParameter(valid_590122, JString, required = false,
                                 default = nil)
  if valid_590122 != nil:
    section.add "key", valid_590122
  var valid_590123 = query.getOrDefault("prettyPrint")
  valid_590123 = validateParameter(valid_590123, JBool, required = false,
                                 default = newJBool(true))
  if valid_590123 != nil:
    section.add "prettyPrint", valid_590123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590124: Call_DriveFilesTouch_590111; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Set the file's updated time to the current server time.
  ## 
  let valid = call_590124.validator(path, query, header, formData, body)
  let scheme = call_590124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590124.url(scheme.get, call_590124.host, call_590124.base,
                         call_590124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590124, url, valid)

proc call*(call_590125: Call_DriveFilesTouch_590111; fileId: string;
          supportsAllDrives: bool = false; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          supportsTeamDrives: bool = false; key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveFilesTouch
  ## Set the file's updated time to the current server time.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file to update.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590126 = newJObject()
  var query_590127 = newJObject()
  add(query_590127, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_590127, "fields", newJString(fields))
  add(query_590127, "quotaUser", newJString(quotaUser))
  add(path_590126, "fileId", newJString(fileId))
  add(query_590127, "alt", newJString(alt))
  add(query_590127, "oauth_token", newJString(oauthToken))
  add(query_590127, "userIp", newJString(userIp))
  add(query_590127, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_590127, "key", newJString(key))
  add(query_590127, "prettyPrint", newJBool(prettyPrint))
  result = call_590125.call(path_590126, query_590127, nil, nil, nil)

var driveFilesTouch* = Call_DriveFilesTouch_590111(name: "driveFilesTouch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/touch", validator: validate_DriveFilesTouch_590112,
    base: "/drive/v2", url: url_DriveFilesTouch_590113, schemes: {Scheme.Https})
type
  Call_DriveFilesTrash_590128 = ref object of OpenApiRestCall_588457
proc url_DriveFilesTrash_590130(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/trash")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveFilesTrash_590129(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Moves a file to the trash. The currently authenticated user must own the file or be at least a fileOrganizer on the parent for shared drive files.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file to trash.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_590131 = path.getOrDefault("fileId")
  valid_590131 = validateParameter(valid_590131, JString, required = true,
                                 default = nil)
  if valid_590131 != nil:
    section.add "fileId", valid_590131
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
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
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590132 = query.getOrDefault("supportsAllDrives")
  valid_590132 = validateParameter(valid_590132, JBool, required = false,
                                 default = newJBool(false))
  if valid_590132 != nil:
    section.add "supportsAllDrives", valid_590132
  var valid_590133 = query.getOrDefault("fields")
  valid_590133 = validateParameter(valid_590133, JString, required = false,
                                 default = nil)
  if valid_590133 != nil:
    section.add "fields", valid_590133
  var valid_590134 = query.getOrDefault("quotaUser")
  valid_590134 = validateParameter(valid_590134, JString, required = false,
                                 default = nil)
  if valid_590134 != nil:
    section.add "quotaUser", valid_590134
  var valid_590135 = query.getOrDefault("alt")
  valid_590135 = validateParameter(valid_590135, JString, required = false,
                                 default = newJString("json"))
  if valid_590135 != nil:
    section.add "alt", valid_590135
  var valid_590136 = query.getOrDefault("oauth_token")
  valid_590136 = validateParameter(valid_590136, JString, required = false,
                                 default = nil)
  if valid_590136 != nil:
    section.add "oauth_token", valid_590136
  var valid_590137 = query.getOrDefault("userIp")
  valid_590137 = validateParameter(valid_590137, JString, required = false,
                                 default = nil)
  if valid_590137 != nil:
    section.add "userIp", valid_590137
  var valid_590138 = query.getOrDefault("supportsTeamDrives")
  valid_590138 = validateParameter(valid_590138, JBool, required = false,
                                 default = newJBool(false))
  if valid_590138 != nil:
    section.add "supportsTeamDrives", valid_590138
  var valid_590139 = query.getOrDefault("key")
  valid_590139 = validateParameter(valid_590139, JString, required = false,
                                 default = nil)
  if valid_590139 != nil:
    section.add "key", valid_590139
  var valid_590140 = query.getOrDefault("prettyPrint")
  valid_590140 = validateParameter(valid_590140, JBool, required = false,
                                 default = newJBool(true))
  if valid_590140 != nil:
    section.add "prettyPrint", valid_590140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590141: Call_DriveFilesTrash_590128; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves a file to the trash. The currently authenticated user must own the file or be at least a fileOrganizer on the parent for shared drive files.
  ## 
  let valid = call_590141.validator(path, query, header, formData, body)
  let scheme = call_590141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590141.url(scheme.get, call_590141.host, call_590141.base,
                         call_590141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590141, url, valid)

proc call*(call_590142: Call_DriveFilesTrash_590128; fileId: string;
          supportsAllDrives: bool = false; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          supportsTeamDrives: bool = false; key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveFilesTrash
  ## Moves a file to the trash. The currently authenticated user must own the file or be at least a fileOrganizer on the parent for shared drive files.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file to trash.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590143 = newJObject()
  var query_590144 = newJObject()
  add(query_590144, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_590144, "fields", newJString(fields))
  add(query_590144, "quotaUser", newJString(quotaUser))
  add(path_590143, "fileId", newJString(fileId))
  add(query_590144, "alt", newJString(alt))
  add(query_590144, "oauth_token", newJString(oauthToken))
  add(query_590144, "userIp", newJString(userIp))
  add(query_590144, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_590144, "key", newJString(key))
  add(query_590144, "prettyPrint", newJBool(prettyPrint))
  result = call_590142.call(path_590143, query_590144, nil, nil, nil)

var driveFilesTrash* = Call_DriveFilesTrash_590128(name: "driveFilesTrash",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/trash", validator: validate_DriveFilesTrash_590129,
    base: "/drive/v2", url: url_DriveFilesTrash_590130, schemes: {Scheme.Https})
type
  Call_DriveFilesUntrash_590145 = ref object of OpenApiRestCall_588457
proc url_DriveFilesUntrash_590147(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/untrash")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveFilesUntrash_590146(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Restores a file from the trash.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file to untrash.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_590148 = path.getOrDefault("fileId")
  valid_590148 = validateParameter(valid_590148, JString, required = true,
                                 default = nil)
  if valid_590148 != nil:
    section.add "fileId", valid_590148
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
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
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590149 = query.getOrDefault("supportsAllDrives")
  valid_590149 = validateParameter(valid_590149, JBool, required = false,
                                 default = newJBool(false))
  if valid_590149 != nil:
    section.add "supportsAllDrives", valid_590149
  var valid_590150 = query.getOrDefault("fields")
  valid_590150 = validateParameter(valid_590150, JString, required = false,
                                 default = nil)
  if valid_590150 != nil:
    section.add "fields", valid_590150
  var valid_590151 = query.getOrDefault("quotaUser")
  valid_590151 = validateParameter(valid_590151, JString, required = false,
                                 default = nil)
  if valid_590151 != nil:
    section.add "quotaUser", valid_590151
  var valid_590152 = query.getOrDefault("alt")
  valid_590152 = validateParameter(valid_590152, JString, required = false,
                                 default = newJString("json"))
  if valid_590152 != nil:
    section.add "alt", valid_590152
  var valid_590153 = query.getOrDefault("oauth_token")
  valid_590153 = validateParameter(valid_590153, JString, required = false,
                                 default = nil)
  if valid_590153 != nil:
    section.add "oauth_token", valid_590153
  var valid_590154 = query.getOrDefault("userIp")
  valid_590154 = validateParameter(valid_590154, JString, required = false,
                                 default = nil)
  if valid_590154 != nil:
    section.add "userIp", valid_590154
  var valid_590155 = query.getOrDefault("supportsTeamDrives")
  valid_590155 = validateParameter(valid_590155, JBool, required = false,
                                 default = newJBool(false))
  if valid_590155 != nil:
    section.add "supportsTeamDrives", valid_590155
  var valid_590156 = query.getOrDefault("key")
  valid_590156 = validateParameter(valid_590156, JString, required = false,
                                 default = nil)
  if valid_590156 != nil:
    section.add "key", valid_590156
  var valid_590157 = query.getOrDefault("prettyPrint")
  valid_590157 = validateParameter(valid_590157, JBool, required = false,
                                 default = newJBool(true))
  if valid_590157 != nil:
    section.add "prettyPrint", valid_590157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590158: Call_DriveFilesUntrash_590145; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a file from the trash.
  ## 
  let valid = call_590158.validator(path, query, header, formData, body)
  let scheme = call_590158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590158.url(scheme.get, call_590158.host, call_590158.base,
                         call_590158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590158, url, valid)

proc call*(call_590159: Call_DriveFilesUntrash_590145; fileId: string;
          supportsAllDrives: bool = false; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          supportsTeamDrives: bool = false; key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveFilesUntrash
  ## Restores a file from the trash.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file to untrash.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590160 = newJObject()
  var query_590161 = newJObject()
  add(query_590161, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_590161, "fields", newJString(fields))
  add(query_590161, "quotaUser", newJString(quotaUser))
  add(path_590160, "fileId", newJString(fileId))
  add(query_590161, "alt", newJString(alt))
  add(query_590161, "oauth_token", newJString(oauthToken))
  add(query_590161, "userIp", newJString(userIp))
  add(query_590161, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_590161, "key", newJString(key))
  add(query_590161, "prettyPrint", newJBool(prettyPrint))
  result = call_590159.call(path_590160, query_590161, nil, nil, nil)

var driveFilesUntrash* = Call_DriveFilesUntrash_590145(name: "driveFilesUntrash",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/untrash", validator: validate_DriveFilesUntrash_590146,
    base: "/drive/v2", url: url_DriveFilesUntrash_590147, schemes: {Scheme.Https})
type
  Call_DriveFilesWatch_590162 = ref object of OpenApiRestCall_588457
proc url_DriveFilesWatch_590164(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/watch")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveFilesWatch_590163(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Subscribe to changes on a file
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID for the file in question.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_590165 = path.getOrDefault("fileId")
  valid_590165 = validateParameter(valid_590165, JString, required = true,
                                 default = nil)
  if valid_590165 != nil:
    section.add "fileId", valid_590165
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   acknowledgeAbuse: JBool
  ##                   : Whether the user is acknowledging the risk of downloading known malware or other abusive files.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   updateViewedDate: JBool
  ##                   : Deprecated: Use files.update with modifiedDateBehavior=noChange, updateViewedDate=true and an empty request body.
  ##   projection: JString
  ##             : This parameter is deprecated and has no function.
  ##   revisionId: JString
  ##             : Specifies the Revision ID that should be downloaded. Ignored unless alt=media is specified.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590166 = query.getOrDefault("supportsAllDrives")
  valid_590166 = validateParameter(valid_590166, JBool, required = false,
                                 default = newJBool(false))
  if valid_590166 != nil:
    section.add "supportsAllDrives", valid_590166
  var valid_590167 = query.getOrDefault("fields")
  valid_590167 = validateParameter(valid_590167, JString, required = false,
                                 default = nil)
  if valid_590167 != nil:
    section.add "fields", valid_590167
  var valid_590168 = query.getOrDefault("quotaUser")
  valid_590168 = validateParameter(valid_590168, JString, required = false,
                                 default = nil)
  if valid_590168 != nil:
    section.add "quotaUser", valid_590168
  var valid_590169 = query.getOrDefault("alt")
  valid_590169 = validateParameter(valid_590169, JString, required = false,
                                 default = newJString("json"))
  if valid_590169 != nil:
    section.add "alt", valid_590169
  var valid_590170 = query.getOrDefault("acknowledgeAbuse")
  valid_590170 = validateParameter(valid_590170, JBool, required = false,
                                 default = newJBool(false))
  if valid_590170 != nil:
    section.add "acknowledgeAbuse", valid_590170
  var valid_590171 = query.getOrDefault("oauth_token")
  valid_590171 = validateParameter(valid_590171, JString, required = false,
                                 default = nil)
  if valid_590171 != nil:
    section.add "oauth_token", valid_590171
  var valid_590172 = query.getOrDefault("userIp")
  valid_590172 = validateParameter(valid_590172, JString, required = false,
                                 default = nil)
  if valid_590172 != nil:
    section.add "userIp", valid_590172
  var valid_590173 = query.getOrDefault("supportsTeamDrives")
  valid_590173 = validateParameter(valid_590173, JBool, required = false,
                                 default = newJBool(false))
  if valid_590173 != nil:
    section.add "supportsTeamDrives", valid_590173
  var valid_590174 = query.getOrDefault("key")
  valid_590174 = validateParameter(valid_590174, JString, required = false,
                                 default = nil)
  if valid_590174 != nil:
    section.add "key", valid_590174
  var valid_590175 = query.getOrDefault("updateViewedDate")
  valid_590175 = validateParameter(valid_590175, JBool, required = false,
                                 default = newJBool(false))
  if valid_590175 != nil:
    section.add "updateViewedDate", valid_590175
  var valid_590176 = query.getOrDefault("projection")
  valid_590176 = validateParameter(valid_590176, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_590176 != nil:
    section.add "projection", valid_590176
  var valid_590177 = query.getOrDefault("revisionId")
  valid_590177 = validateParameter(valid_590177, JString, required = false,
                                 default = nil)
  if valid_590177 != nil:
    section.add "revisionId", valid_590177
  var valid_590178 = query.getOrDefault("prettyPrint")
  valid_590178 = validateParameter(valid_590178, JBool, required = false,
                                 default = newJBool(true))
  if valid_590178 != nil:
    section.add "prettyPrint", valid_590178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resource: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590180: Call_DriveFilesWatch_590162; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Subscribe to changes on a file
  ## 
  let valid = call_590180.validator(path, query, header, formData, body)
  let scheme = call_590180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590180.url(scheme.get, call_590180.host, call_590180.base,
                         call_590180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590180, url, valid)

proc call*(call_590181: Call_DriveFilesWatch_590162; fileId: string;
          supportsAllDrives: bool = false; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; acknowledgeAbuse: bool = false; oauthToken: string = "";
          userIp: string = ""; supportsTeamDrives: bool = false; key: string = "";
          updateViewedDate: bool = false; projection: string = "BASIC";
          resource: JsonNode = nil; revisionId: string = ""; prettyPrint: bool = true): Recallable =
  ## driveFilesWatch
  ## Subscribe to changes on a file
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID for the file in question.
  ##   alt: string
  ##      : Data format for the response.
  ##   acknowledgeAbuse: bool
  ##                   : Whether the user is acknowledging the risk of downloading known malware or other abusive files.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   updateViewedDate: bool
  ##                   : Deprecated: Use files.update with modifiedDateBehavior=noChange, updateViewedDate=true and an empty request body.
  ##   projection: string
  ##             : This parameter is deprecated and has no function.
  ##   resource: JObject
  ##   revisionId: string
  ##             : Specifies the Revision ID that should be downloaded. Ignored unless alt=media is specified.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590182 = newJObject()
  var query_590183 = newJObject()
  var body_590184 = newJObject()
  add(query_590183, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_590183, "fields", newJString(fields))
  add(query_590183, "quotaUser", newJString(quotaUser))
  add(path_590182, "fileId", newJString(fileId))
  add(query_590183, "alt", newJString(alt))
  add(query_590183, "acknowledgeAbuse", newJBool(acknowledgeAbuse))
  add(query_590183, "oauth_token", newJString(oauthToken))
  add(query_590183, "userIp", newJString(userIp))
  add(query_590183, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_590183, "key", newJString(key))
  add(query_590183, "updateViewedDate", newJBool(updateViewedDate))
  add(query_590183, "projection", newJString(projection))
  if resource != nil:
    body_590184 = resource
  add(query_590183, "revisionId", newJString(revisionId))
  add(query_590183, "prettyPrint", newJBool(prettyPrint))
  result = call_590181.call(path_590182, query_590183, nil, nil, body_590184)

var driveFilesWatch* = Call_DriveFilesWatch_590162(name: "driveFilesWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/watch", validator: validate_DriveFilesWatch_590163,
    base: "/drive/v2", url: url_DriveFilesWatch_590164, schemes: {Scheme.Https})
type
  Call_DriveChildrenInsert_590204 = ref object of OpenApiRestCall_588457
proc url_DriveChildrenInsert_590206(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "folderId" in path, "`folderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "folderId"),
               (kind: ConstantSegment, value: "/children")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveChildrenInsert_590205(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Inserts a file into a folder.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   folderId: JString (required)
  ##           : The ID of the folder.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `folderId` field"
  var valid_590207 = path.getOrDefault("folderId")
  valid_590207 = validateParameter(valid_590207, JString, required = true,
                                 default = nil)
  if valid_590207 != nil:
    section.add "folderId", valid_590207
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
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
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590208 = query.getOrDefault("supportsAllDrives")
  valid_590208 = validateParameter(valid_590208, JBool, required = false,
                                 default = newJBool(false))
  if valid_590208 != nil:
    section.add "supportsAllDrives", valid_590208
  var valid_590209 = query.getOrDefault("fields")
  valid_590209 = validateParameter(valid_590209, JString, required = false,
                                 default = nil)
  if valid_590209 != nil:
    section.add "fields", valid_590209
  var valid_590210 = query.getOrDefault("quotaUser")
  valid_590210 = validateParameter(valid_590210, JString, required = false,
                                 default = nil)
  if valid_590210 != nil:
    section.add "quotaUser", valid_590210
  var valid_590211 = query.getOrDefault("alt")
  valid_590211 = validateParameter(valid_590211, JString, required = false,
                                 default = newJString("json"))
  if valid_590211 != nil:
    section.add "alt", valid_590211
  var valid_590212 = query.getOrDefault("oauth_token")
  valid_590212 = validateParameter(valid_590212, JString, required = false,
                                 default = nil)
  if valid_590212 != nil:
    section.add "oauth_token", valid_590212
  var valid_590213 = query.getOrDefault("userIp")
  valid_590213 = validateParameter(valid_590213, JString, required = false,
                                 default = nil)
  if valid_590213 != nil:
    section.add "userIp", valid_590213
  var valid_590214 = query.getOrDefault("supportsTeamDrives")
  valid_590214 = validateParameter(valid_590214, JBool, required = false,
                                 default = newJBool(false))
  if valid_590214 != nil:
    section.add "supportsTeamDrives", valid_590214
  var valid_590215 = query.getOrDefault("key")
  valid_590215 = validateParameter(valid_590215, JString, required = false,
                                 default = nil)
  if valid_590215 != nil:
    section.add "key", valid_590215
  var valid_590216 = query.getOrDefault("prettyPrint")
  valid_590216 = validateParameter(valid_590216, JBool, required = false,
                                 default = newJBool(true))
  if valid_590216 != nil:
    section.add "prettyPrint", valid_590216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590218: Call_DriveChildrenInsert_590204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a file into a folder.
  ## 
  let valid = call_590218.validator(path, query, header, formData, body)
  let scheme = call_590218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590218.url(scheme.get, call_590218.host, call_590218.base,
                         call_590218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590218, url, valid)

proc call*(call_590219: Call_DriveChildrenInsert_590204; folderId: string;
          supportsAllDrives: bool = false; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          supportsTeamDrives: bool = false; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## driveChildrenInsert
  ## Inserts a file into a folder.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
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
  ##   folderId: string (required)
  ##           : The ID of the folder.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590220 = newJObject()
  var query_590221 = newJObject()
  var body_590222 = newJObject()
  add(query_590221, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_590221, "fields", newJString(fields))
  add(query_590221, "quotaUser", newJString(quotaUser))
  add(query_590221, "alt", newJString(alt))
  add(query_590221, "oauth_token", newJString(oauthToken))
  add(query_590221, "userIp", newJString(userIp))
  add(path_590220, "folderId", newJString(folderId))
  add(query_590221, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_590221, "key", newJString(key))
  if body != nil:
    body_590222 = body
  add(query_590221, "prettyPrint", newJBool(prettyPrint))
  result = call_590219.call(path_590220, query_590221, nil, nil, body_590222)

var driveChildrenInsert* = Call_DriveChildrenInsert_590204(
    name: "driveChildrenInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{folderId}/children",
    validator: validate_DriveChildrenInsert_590205, base: "/drive/v2",
    url: url_DriveChildrenInsert_590206, schemes: {Scheme.Https})
type
  Call_DriveChildrenList_590185 = ref object of OpenApiRestCall_588457
proc url_DriveChildrenList_590187(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "folderId" in path, "`folderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "folderId"),
               (kind: ConstantSegment, value: "/children")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveChildrenList_590186(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists a folder's children.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   folderId: JString (required)
  ##           : The ID of the folder.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `folderId` field"
  var valid_590188 = path.getOrDefault("folderId")
  valid_590188 = validateParameter(valid_590188, JString, required = true,
                                 default = nil)
  if valid_590188 != nil:
    section.add "folderId", valid_590188
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Page token for children.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of children to return.
  ##   orderBy: JString
  ##          : A comma-separated list of sort keys. Valid keys are 'createdDate', 'folder', 'lastViewedByMeDate', 'modifiedByMeDate', 'modifiedDate', 'quotaBytesUsed', 'recency', 'sharedWithMeDate', 'starred', and 'title'. Each key sorts ascending by default, but may be reversed with the 'desc' modifier. Example usage: ?orderBy=folder,modifiedDate desc,title. Please note that there is a current limitation for users with approximately one million files in which the requested sort order is ignored.
  ##   q: JString
  ##    : Query string for searching children.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590189 = query.getOrDefault("fields")
  valid_590189 = validateParameter(valid_590189, JString, required = false,
                                 default = nil)
  if valid_590189 != nil:
    section.add "fields", valid_590189
  var valid_590190 = query.getOrDefault("pageToken")
  valid_590190 = validateParameter(valid_590190, JString, required = false,
                                 default = nil)
  if valid_590190 != nil:
    section.add "pageToken", valid_590190
  var valid_590191 = query.getOrDefault("quotaUser")
  valid_590191 = validateParameter(valid_590191, JString, required = false,
                                 default = nil)
  if valid_590191 != nil:
    section.add "quotaUser", valid_590191
  var valid_590192 = query.getOrDefault("alt")
  valid_590192 = validateParameter(valid_590192, JString, required = false,
                                 default = newJString("json"))
  if valid_590192 != nil:
    section.add "alt", valid_590192
  var valid_590193 = query.getOrDefault("oauth_token")
  valid_590193 = validateParameter(valid_590193, JString, required = false,
                                 default = nil)
  if valid_590193 != nil:
    section.add "oauth_token", valid_590193
  var valid_590194 = query.getOrDefault("userIp")
  valid_590194 = validateParameter(valid_590194, JString, required = false,
                                 default = nil)
  if valid_590194 != nil:
    section.add "userIp", valid_590194
  var valid_590195 = query.getOrDefault("maxResults")
  valid_590195 = validateParameter(valid_590195, JInt, required = false,
                                 default = newJInt(100))
  if valid_590195 != nil:
    section.add "maxResults", valid_590195
  var valid_590196 = query.getOrDefault("orderBy")
  valid_590196 = validateParameter(valid_590196, JString, required = false,
                                 default = nil)
  if valid_590196 != nil:
    section.add "orderBy", valid_590196
  var valid_590197 = query.getOrDefault("q")
  valid_590197 = validateParameter(valid_590197, JString, required = false,
                                 default = nil)
  if valid_590197 != nil:
    section.add "q", valid_590197
  var valid_590198 = query.getOrDefault("key")
  valid_590198 = validateParameter(valid_590198, JString, required = false,
                                 default = nil)
  if valid_590198 != nil:
    section.add "key", valid_590198
  var valid_590199 = query.getOrDefault("prettyPrint")
  valid_590199 = validateParameter(valid_590199, JBool, required = false,
                                 default = newJBool(true))
  if valid_590199 != nil:
    section.add "prettyPrint", valid_590199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590200: Call_DriveChildrenList_590185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a folder's children.
  ## 
  let valid = call_590200.validator(path, query, header, formData, body)
  let scheme = call_590200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590200.url(scheme.get, call_590200.host, call_590200.base,
                         call_590200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590200, url, valid)

proc call*(call_590201: Call_DriveChildrenList_590185; folderId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 100; orderBy: string = ""; q: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## driveChildrenList
  ## Lists a folder's children.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Page token for children.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   folderId: string (required)
  ##           : The ID of the folder.
  ##   maxResults: int
  ##             : Maximum number of children to return.
  ##   orderBy: string
  ##          : A comma-separated list of sort keys. Valid keys are 'createdDate', 'folder', 'lastViewedByMeDate', 'modifiedByMeDate', 'modifiedDate', 'quotaBytesUsed', 'recency', 'sharedWithMeDate', 'starred', and 'title'. Each key sorts ascending by default, but may be reversed with the 'desc' modifier. Example usage: ?orderBy=folder,modifiedDate desc,title. Please note that there is a current limitation for users with approximately one million files in which the requested sort order is ignored.
  ##   q: string
  ##    : Query string for searching children.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590202 = newJObject()
  var query_590203 = newJObject()
  add(query_590203, "fields", newJString(fields))
  add(query_590203, "pageToken", newJString(pageToken))
  add(query_590203, "quotaUser", newJString(quotaUser))
  add(query_590203, "alt", newJString(alt))
  add(query_590203, "oauth_token", newJString(oauthToken))
  add(query_590203, "userIp", newJString(userIp))
  add(path_590202, "folderId", newJString(folderId))
  add(query_590203, "maxResults", newJInt(maxResults))
  add(query_590203, "orderBy", newJString(orderBy))
  add(query_590203, "q", newJString(q))
  add(query_590203, "key", newJString(key))
  add(query_590203, "prettyPrint", newJBool(prettyPrint))
  result = call_590201.call(path_590202, query_590203, nil, nil, nil)

var driveChildrenList* = Call_DriveChildrenList_590185(name: "driveChildrenList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{folderId}/children", validator: validate_DriveChildrenList_590186,
    base: "/drive/v2", url: url_DriveChildrenList_590187, schemes: {Scheme.Https})
type
  Call_DriveChildrenGet_590223 = ref object of OpenApiRestCall_588457
proc url_DriveChildrenGet_590225(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "folderId" in path, "`folderId` is a required path parameter"
  assert "childId" in path, "`childId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "folderId"),
               (kind: ConstantSegment, value: "/children/"),
               (kind: VariableSegment, value: "childId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveChildrenGet_590224(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets a specific child reference.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   childId: JString (required)
  ##          : The ID of the child.
  ##   folderId: JString (required)
  ##           : The ID of the folder.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `childId` field"
  var valid_590226 = path.getOrDefault("childId")
  valid_590226 = validateParameter(valid_590226, JString, required = true,
                                 default = nil)
  if valid_590226 != nil:
    section.add "childId", valid_590226
  var valid_590227 = path.getOrDefault("folderId")
  valid_590227 = validateParameter(valid_590227, JString, required = true,
                                 default = nil)
  if valid_590227 != nil:
    section.add "folderId", valid_590227
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
  var valid_590228 = query.getOrDefault("fields")
  valid_590228 = validateParameter(valid_590228, JString, required = false,
                                 default = nil)
  if valid_590228 != nil:
    section.add "fields", valid_590228
  var valid_590229 = query.getOrDefault("quotaUser")
  valid_590229 = validateParameter(valid_590229, JString, required = false,
                                 default = nil)
  if valid_590229 != nil:
    section.add "quotaUser", valid_590229
  var valid_590230 = query.getOrDefault("alt")
  valid_590230 = validateParameter(valid_590230, JString, required = false,
                                 default = newJString("json"))
  if valid_590230 != nil:
    section.add "alt", valid_590230
  var valid_590231 = query.getOrDefault("oauth_token")
  valid_590231 = validateParameter(valid_590231, JString, required = false,
                                 default = nil)
  if valid_590231 != nil:
    section.add "oauth_token", valid_590231
  var valid_590232 = query.getOrDefault("userIp")
  valid_590232 = validateParameter(valid_590232, JString, required = false,
                                 default = nil)
  if valid_590232 != nil:
    section.add "userIp", valid_590232
  var valid_590233 = query.getOrDefault("key")
  valid_590233 = validateParameter(valid_590233, JString, required = false,
                                 default = nil)
  if valid_590233 != nil:
    section.add "key", valid_590233
  var valid_590234 = query.getOrDefault("prettyPrint")
  valid_590234 = validateParameter(valid_590234, JBool, required = false,
                                 default = newJBool(true))
  if valid_590234 != nil:
    section.add "prettyPrint", valid_590234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590235: Call_DriveChildrenGet_590223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific child reference.
  ## 
  let valid = call_590235.validator(path, query, header, formData, body)
  let scheme = call_590235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590235.url(scheme.get, call_590235.host, call_590235.base,
                         call_590235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590235, url, valid)

proc call*(call_590236: Call_DriveChildrenGet_590223; childId: string;
          folderId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveChildrenGet
  ## Gets a specific child reference.
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
  ##   childId: string (required)
  ##          : The ID of the child.
  ##   folderId: string (required)
  ##           : The ID of the folder.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590237 = newJObject()
  var query_590238 = newJObject()
  add(query_590238, "fields", newJString(fields))
  add(query_590238, "quotaUser", newJString(quotaUser))
  add(query_590238, "alt", newJString(alt))
  add(query_590238, "oauth_token", newJString(oauthToken))
  add(query_590238, "userIp", newJString(userIp))
  add(path_590237, "childId", newJString(childId))
  add(path_590237, "folderId", newJString(folderId))
  add(query_590238, "key", newJString(key))
  add(query_590238, "prettyPrint", newJBool(prettyPrint))
  result = call_590236.call(path_590237, query_590238, nil, nil, nil)

var driveChildrenGet* = Call_DriveChildrenGet_590223(name: "driveChildrenGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{folderId}/children/{childId}",
    validator: validate_DriveChildrenGet_590224, base: "/drive/v2",
    url: url_DriveChildrenGet_590225, schemes: {Scheme.Https})
type
  Call_DriveChildrenDelete_590239 = ref object of OpenApiRestCall_588457
proc url_DriveChildrenDelete_590241(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "folderId" in path, "`folderId` is a required path parameter"
  assert "childId" in path, "`childId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "folderId"),
               (kind: ConstantSegment, value: "/children/"),
               (kind: VariableSegment, value: "childId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveChildrenDelete_590240(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Removes a child from a folder.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   childId: JString (required)
  ##          : The ID of the child.
  ##   folderId: JString (required)
  ##           : The ID of the folder.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `childId` field"
  var valid_590242 = path.getOrDefault("childId")
  valid_590242 = validateParameter(valid_590242, JString, required = true,
                                 default = nil)
  if valid_590242 != nil:
    section.add "childId", valid_590242
  var valid_590243 = path.getOrDefault("folderId")
  valid_590243 = validateParameter(valid_590243, JString, required = true,
                                 default = nil)
  if valid_590243 != nil:
    section.add "folderId", valid_590243
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
  var valid_590244 = query.getOrDefault("fields")
  valid_590244 = validateParameter(valid_590244, JString, required = false,
                                 default = nil)
  if valid_590244 != nil:
    section.add "fields", valid_590244
  var valid_590245 = query.getOrDefault("quotaUser")
  valid_590245 = validateParameter(valid_590245, JString, required = false,
                                 default = nil)
  if valid_590245 != nil:
    section.add "quotaUser", valid_590245
  var valid_590246 = query.getOrDefault("alt")
  valid_590246 = validateParameter(valid_590246, JString, required = false,
                                 default = newJString("json"))
  if valid_590246 != nil:
    section.add "alt", valid_590246
  var valid_590247 = query.getOrDefault("oauth_token")
  valid_590247 = validateParameter(valid_590247, JString, required = false,
                                 default = nil)
  if valid_590247 != nil:
    section.add "oauth_token", valid_590247
  var valid_590248 = query.getOrDefault("userIp")
  valid_590248 = validateParameter(valid_590248, JString, required = false,
                                 default = nil)
  if valid_590248 != nil:
    section.add "userIp", valid_590248
  var valid_590249 = query.getOrDefault("key")
  valid_590249 = validateParameter(valid_590249, JString, required = false,
                                 default = nil)
  if valid_590249 != nil:
    section.add "key", valid_590249
  var valid_590250 = query.getOrDefault("prettyPrint")
  valid_590250 = validateParameter(valid_590250, JBool, required = false,
                                 default = newJBool(true))
  if valid_590250 != nil:
    section.add "prettyPrint", valid_590250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590251: Call_DriveChildrenDelete_590239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a child from a folder.
  ## 
  let valid = call_590251.validator(path, query, header, formData, body)
  let scheme = call_590251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590251.url(scheme.get, call_590251.host, call_590251.base,
                         call_590251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590251, url, valid)

proc call*(call_590252: Call_DriveChildrenDelete_590239; childId: string;
          folderId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveChildrenDelete
  ## Removes a child from a folder.
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
  ##   childId: string (required)
  ##          : The ID of the child.
  ##   folderId: string (required)
  ##           : The ID of the folder.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590253 = newJObject()
  var query_590254 = newJObject()
  add(query_590254, "fields", newJString(fields))
  add(query_590254, "quotaUser", newJString(quotaUser))
  add(query_590254, "alt", newJString(alt))
  add(query_590254, "oauth_token", newJString(oauthToken))
  add(query_590254, "userIp", newJString(userIp))
  add(path_590253, "childId", newJString(childId))
  add(path_590253, "folderId", newJString(folderId))
  add(query_590254, "key", newJString(key))
  add(query_590254, "prettyPrint", newJBool(prettyPrint))
  result = call_590252.call(path_590253, query_590254, nil, nil, nil)

var driveChildrenDelete* = Call_DriveChildrenDelete_590239(
    name: "driveChildrenDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{folderId}/children/{childId}",
    validator: validate_DriveChildrenDelete_590240, base: "/drive/v2",
    url: url_DriveChildrenDelete_590241, schemes: {Scheme.Https})
type
  Call_DrivePermissionsGetIdForEmail_590255 = ref object of OpenApiRestCall_588457
proc url_DrivePermissionsGetIdForEmail_590257(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "email" in path, "`email` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/permissionIds/"),
               (kind: VariableSegment, value: "email")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DrivePermissionsGetIdForEmail_590256(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the permission ID for an email address.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   email: JString (required)
  ##        : The email address for which to return a permission ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `email` field"
  var valid_590258 = path.getOrDefault("email")
  valid_590258 = validateParameter(valid_590258, JString, required = true,
                                 default = nil)
  if valid_590258 != nil:
    section.add "email", valid_590258
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
  var valid_590259 = query.getOrDefault("fields")
  valid_590259 = validateParameter(valid_590259, JString, required = false,
                                 default = nil)
  if valid_590259 != nil:
    section.add "fields", valid_590259
  var valid_590260 = query.getOrDefault("quotaUser")
  valid_590260 = validateParameter(valid_590260, JString, required = false,
                                 default = nil)
  if valid_590260 != nil:
    section.add "quotaUser", valid_590260
  var valid_590261 = query.getOrDefault("alt")
  valid_590261 = validateParameter(valid_590261, JString, required = false,
                                 default = newJString("json"))
  if valid_590261 != nil:
    section.add "alt", valid_590261
  var valid_590262 = query.getOrDefault("oauth_token")
  valid_590262 = validateParameter(valid_590262, JString, required = false,
                                 default = nil)
  if valid_590262 != nil:
    section.add "oauth_token", valid_590262
  var valid_590263 = query.getOrDefault("userIp")
  valid_590263 = validateParameter(valid_590263, JString, required = false,
                                 default = nil)
  if valid_590263 != nil:
    section.add "userIp", valid_590263
  var valid_590264 = query.getOrDefault("key")
  valid_590264 = validateParameter(valid_590264, JString, required = false,
                                 default = nil)
  if valid_590264 != nil:
    section.add "key", valid_590264
  var valid_590265 = query.getOrDefault("prettyPrint")
  valid_590265 = validateParameter(valid_590265, JBool, required = false,
                                 default = newJBool(true))
  if valid_590265 != nil:
    section.add "prettyPrint", valid_590265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590266: Call_DrivePermissionsGetIdForEmail_590255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the permission ID for an email address.
  ## 
  let valid = call_590266.validator(path, query, header, formData, body)
  let scheme = call_590266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590266.url(scheme.get, call_590266.host, call_590266.base,
                         call_590266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590266, url, valid)

proc call*(call_590267: Call_DrivePermissionsGetIdForEmail_590255; email: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## drivePermissionsGetIdForEmail
  ## Returns the permission ID for an email address.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   email: string (required)
  ##        : The email address for which to return a permission ID
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590268 = newJObject()
  var query_590269 = newJObject()
  add(query_590269, "fields", newJString(fields))
  add(query_590269, "quotaUser", newJString(quotaUser))
  add(query_590269, "alt", newJString(alt))
  add(path_590268, "email", newJString(email))
  add(query_590269, "oauth_token", newJString(oauthToken))
  add(query_590269, "userIp", newJString(userIp))
  add(query_590269, "key", newJString(key))
  add(query_590269, "prettyPrint", newJBool(prettyPrint))
  result = call_590267.call(path_590268, query_590269, nil, nil, nil)

var drivePermissionsGetIdForEmail* = Call_DrivePermissionsGetIdForEmail_590255(
    name: "drivePermissionsGetIdForEmail", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/permissionIds/{email}",
    validator: validate_DrivePermissionsGetIdForEmail_590256, base: "/drive/v2",
    url: url_DrivePermissionsGetIdForEmail_590257, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesInsert_590287 = ref object of OpenApiRestCall_588457
proc url_DriveTeamdrivesInsert_590289(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveTeamdrivesInsert_590288(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deprecated use drives.insert instead.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: JString (required)
  ##            : An ID, such as a random UUID, which uniquely identifies this user's request for idempotent creation of a Team Drive. A repeated request by the same user and with the same request ID will avoid creating duplicates by attempting to create the same Team Drive. If the Team Drive already exists a 409 error will be returned.
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
  var valid_590290 = query.getOrDefault("fields")
  valid_590290 = validateParameter(valid_590290, JString, required = false,
                                 default = nil)
  if valid_590290 != nil:
    section.add "fields", valid_590290
  assert query != nil,
        "query argument is necessary due to required `requestId` field"
  var valid_590291 = query.getOrDefault("requestId")
  valid_590291 = validateParameter(valid_590291, JString, required = true,
                                 default = nil)
  if valid_590291 != nil:
    section.add "requestId", valid_590291
  var valid_590292 = query.getOrDefault("quotaUser")
  valid_590292 = validateParameter(valid_590292, JString, required = false,
                                 default = nil)
  if valid_590292 != nil:
    section.add "quotaUser", valid_590292
  var valid_590293 = query.getOrDefault("alt")
  valid_590293 = validateParameter(valid_590293, JString, required = false,
                                 default = newJString("json"))
  if valid_590293 != nil:
    section.add "alt", valid_590293
  var valid_590294 = query.getOrDefault("oauth_token")
  valid_590294 = validateParameter(valid_590294, JString, required = false,
                                 default = nil)
  if valid_590294 != nil:
    section.add "oauth_token", valid_590294
  var valid_590295 = query.getOrDefault("userIp")
  valid_590295 = validateParameter(valid_590295, JString, required = false,
                                 default = nil)
  if valid_590295 != nil:
    section.add "userIp", valid_590295
  var valid_590296 = query.getOrDefault("key")
  valid_590296 = validateParameter(valid_590296, JString, required = false,
                                 default = nil)
  if valid_590296 != nil:
    section.add "key", valid_590296
  var valid_590297 = query.getOrDefault("prettyPrint")
  valid_590297 = validateParameter(valid_590297, JBool, required = false,
                                 default = newJBool(true))
  if valid_590297 != nil:
    section.add "prettyPrint", valid_590297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590299: Call_DriveTeamdrivesInsert_590287; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.insert instead.
  ## 
  let valid = call_590299.validator(path, query, header, formData, body)
  let scheme = call_590299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590299.url(scheme.get, call_590299.host, call_590299.base,
                         call_590299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590299, url, valid)

proc call*(call_590300: Call_DriveTeamdrivesInsert_590287; requestId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## driveTeamdrivesInsert
  ## Deprecated use drives.insert instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: string (required)
  ##            : An ID, such as a random UUID, which uniquely identifies this user's request for idempotent creation of a Team Drive. A repeated request by the same user and with the same request ID will avoid creating duplicates by attempting to create the same Team Drive. If the Team Drive already exists a 409 error will be returned.
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
  var query_590301 = newJObject()
  var body_590302 = newJObject()
  add(query_590301, "fields", newJString(fields))
  add(query_590301, "requestId", newJString(requestId))
  add(query_590301, "quotaUser", newJString(quotaUser))
  add(query_590301, "alt", newJString(alt))
  add(query_590301, "oauth_token", newJString(oauthToken))
  add(query_590301, "userIp", newJString(userIp))
  add(query_590301, "key", newJString(key))
  if body != nil:
    body_590302 = body
  add(query_590301, "prettyPrint", newJBool(prettyPrint))
  result = call_590300.call(nil, query_590301, nil, nil, body_590302)

var driveTeamdrivesInsert* = Call_DriveTeamdrivesInsert_590287(
    name: "driveTeamdrivesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/teamdrives",
    validator: validate_DriveTeamdrivesInsert_590288, base: "/drive/v2",
    url: url_DriveTeamdrivesInsert_590289, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesList_590270 = ref object of OpenApiRestCall_588457
proc url_DriveTeamdrivesList_590272(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveTeamdrivesList_590271(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deprecated use drives.list instead.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Page token for Team Drives.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of Team Drives to return.
  ##   q: JString
  ##    : Query string for searching Team Drives.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then all Team Drives of the domain in which the requester is an administrator are returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590273 = query.getOrDefault("fields")
  valid_590273 = validateParameter(valid_590273, JString, required = false,
                                 default = nil)
  if valid_590273 != nil:
    section.add "fields", valid_590273
  var valid_590274 = query.getOrDefault("pageToken")
  valid_590274 = validateParameter(valid_590274, JString, required = false,
                                 default = nil)
  if valid_590274 != nil:
    section.add "pageToken", valid_590274
  var valid_590275 = query.getOrDefault("quotaUser")
  valid_590275 = validateParameter(valid_590275, JString, required = false,
                                 default = nil)
  if valid_590275 != nil:
    section.add "quotaUser", valid_590275
  var valid_590276 = query.getOrDefault("alt")
  valid_590276 = validateParameter(valid_590276, JString, required = false,
                                 default = newJString("json"))
  if valid_590276 != nil:
    section.add "alt", valid_590276
  var valid_590277 = query.getOrDefault("oauth_token")
  valid_590277 = validateParameter(valid_590277, JString, required = false,
                                 default = nil)
  if valid_590277 != nil:
    section.add "oauth_token", valid_590277
  var valid_590278 = query.getOrDefault("userIp")
  valid_590278 = validateParameter(valid_590278, JString, required = false,
                                 default = nil)
  if valid_590278 != nil:
    section.add "userIp", valid_590278
  var valid_590279 = query.getOrDefault("maxResults")
  valid_590279 = validateParameter(valid_590279, JInt, required = false,
                                 default = newJInt(10))
  if valid_590279 != nil:
    section.add "maxResults", valid_590279
  var valid_590280 = query.getOrDefault("q")
  valid_590280 = validateParameter(valid_590280, JString, required = false,
                                 default = nil)
  if valid_590280 != nil:
    section.add "q", valid_590280
  var valid_590281 = query.getOrDefault("key")
  valid_590281 = validateParameter(valid_590281, JString, required = false,
                                 default = nil)
  if valid_590281 != nil:
    section.add "key", valid_590281
  var valid_590282 = query.getOrDefault("useDomainAdminAccess")
  valid_590282 = validateParameter(valid_590282, JBool, required = false,
                                 default = newJBool(false))
  if valid_590282 != nil:
    section.add "useDomainAdminAccess", valid_590282
  var valid_590283 = query.getOrDefault("prettyPrint")
  valid_590283 = validateParameter(valid_590283, JBool, required = false,
                                 default = newJBool(true))
  if valid_590283 != nil:
    section.add "prettyPrint", valid_590283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590284: Call_DriveTeamdrivesList_590270; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.list instead.
  ## 
  let valid = call_590284.validator(path, query, header, formData, body)
  let scheme = call_590284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590284.url(scheme.get, call_590284.host, call_590284.base,
                         call_590284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590284, url, valid)

proc call*(call_590285: Call_DriveTeamdrivesList_590270; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 10;
          q: string = ""; key: string = ""; useDomainAdminAccess: bool = false;
          prettyPrint: bool = true): Recallable =
  ## driveTeamdrivesList
  ## Deprecated use drives.list instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Page token for Team Drives.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of Team Drives to return.
  ##   q: string
  ##    : Query string for searching Team Drives.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then all Team Drives of the domain in which the requester is an administrator are returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_590286 = newJObject()
  add(query_590286, "fields", newJString(fields))
  add(query_590286, "pageToken", newJString(pageToken))
  add(query_590286, "quotaUser", newJString(quotaUser))
  add(query_590286, "alt", newJString(alt))
  add(query_590286, "oauth_token", newJString(oauthToken))
  add(query_590286, "userIp", newJString(userIp))
  add(query_590286, "maxResults", newJInt(maxResults))
  add(query_590286, "q", newJString(q))
  add(query_590286, "key", newJString(key))
  add(query_590286, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_590286, "prettyPrint", newJBool(prettyPrint))
  result = call_590285.call(nil, query_590286, nil, nil, nil)

var driveTeamdrivesList* = Call_DriveTeamdrivesList_590270(
    name: "driveTeamdrivesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/teamdrives",
    validator: validate_DriveTeamdrivesList_590271, base: "/drive/v2",
    url: url_DriveTeamdrivesList_590272, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesUpdate_590319 = ref object of OpenApiRestCall_588457
proc url_DriveTeamdrivesUpdate_590321(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "teamDriveId" in path, "`teamDriveId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/teamdrives/"),
               (kind: VariableSegment, value: "teamDriveId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveTeamdrivesUpdate_590320(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deprecated use drives.update instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   teamDriveId: JString (required)
  ##              : The ID of the Team Drive
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `teamDriveId` field"
  var valid_590322 = path.getOrDefault("teamDriveId")
  valid_590322 = validateParameter(valid_590322, JString, required = true,
                                 default = nil)
  if valid_590322 != nil:
    section.add "teamDriveId", valid_590322
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
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the Team Drive belongs.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590323 = query.getOrDefault("fields")
  valid_590323 = validateParameter(valid_590323, JString, required = false,
                                 default = nil)
  if valid_590323 != nil:
    section.add "fields", valid_590323
  var valid_590324 = query.getOrDefault("quotaUser")
  valid_590324 = validateParameter(valid_590324, JString, required = false,
                                 default = nil)
  if valid_590324 != nil:
    section.add "quotaUser", valid_590324
  var valid_590325 = query.getOrDefault("alt")
  valid_590325 = validateParameter(valid_590325, JString, required = false,
                                 default = newJString("json"))
  if valid_590325 != nil:
    section.add "alt", valid_590325
  var valid_590326 = query.getOrDefault("oauth_token")
  valid_590326 = validateParameter(valid_590326, JString, required = false,
                                 default = nil)
  if valid_590326 != nil:
    section.add "oauth_token", valid_590326
  var valid_590327 = query.getOrDefault("userIp")
  valid_590327 = validateParameter(valid_590327, JString, required = false,
                                 default = nil)
  if valid_590327 != nil:
    section.add "userIp", valid_590327
  var valid_590328 = query.getOrDefault("key")
  valid_590328 = validateParameter(valid_590328, JString, required = false,
                                 default = nil)
  if valid_590328 != nil:
    section.add "key", valid_590328
  var valid_590329 = query.getOrDefault("useDomainAdminAccess")
  valid_590329 = validateParameter(valid_590329, JBool, required = false,
                                 default = newJBool(false))
  if valid_590329 != nil:
    section.add "useDomainAdminAccess", valid_590329
  var valid_590330 = query.getOrDefault("prettyPrint")
  valid_590330 = validateParameter(valid_590330, JBool, required = false,
                                 default = newJBool(true))
  if valid_590330 != nil:
    section.add "prettyPrint", valid_590330
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590332: Call_DriveTeamdrivesUpdate_590319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.update instead.
  ## 
  let valid = call_590332.validator(path, query, header, formData, body)
  let scheme = call_590332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590332.url(scheme.get, call_590332.host, call_590332.base,
                         call_590332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590332, url, valid)

proc call*(call_590333: Call_DriveTeamdrivesUpdate_590319; teamDriveId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          useDomainAdminAccess: bool = false; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## driveTeamdrivesUpdate
  ## Deprecated use drives.update instead.
  ##   teamDriveId: string (required)
  ##              : The ID of the Team Drive
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
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the Team Drive belongs.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590334 = newJObject()
  var query_590335 = newJObject()
  var body_590336 = newJObject()
  add(path_590334, "teamDriveId", newJString(teamDriveId))
  add(query_590335, "fields", newJString(fields))
  add(query_590335, "quotaUser", newJString(quotaUser))
  add(query_590335, "alt", newJString(alt))
  add(query_590335, "oauth_token", newJString(oauthToken))
  add(query_590335, "userIp", newJString(userIp))
  add(query_590335, "key", newJString(key))
  add(query_590335, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  if body != nil:
    body_590336 = body
  add(query_590335, "prettyPrint", newJBool(prettyPrint))
  result = call_590333.call(path_590334, query_590335, nil, nil, body_590336)

var driveTeamdrivesUpdate* = Call_DriveTeamdrivesUpdate_590319(
    name: "driveTeamdrivesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesUpdate_590320, base: "/drive/v2",
    url: url_DriveTeamdrivesUpdate_590321, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesGet_590303 = ref object of OpenApiRestCall_588457
proc url_DriveTeamdrivesGet_590305(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "teamDriveId" in path, "`teamDriveId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/teamdrives/"),
               (kind: VariableSegment, value: "teamDriveId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveTeamdrivesGet_590304(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deprecated use drives.get instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   teamDriveId: JString (required)
  ##              : The ID of the Team Drive
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `teamDriveId` field"
  var valid_590306 = path.getOrDefault("teamDriveId")
  valid_590306 = validateParameter(valid_590306, JString, required = true,
                                 default = nil)
  if valid_590306 != nil:
    section.add "teamDriveId", valid_590306
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
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the Team Drive belongs.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590307 = query.getOrDefault("fields")
  valid_590307 = validateParameter(valid_590307, JString, required = false,
                                 default = nil)
  if valid_590307 != nil:
    section.add "fields", valid_590307
  var valid_590308 = query.getOrDefault("quotaUser")
  valid_590308 = validateParameter(valid_590308, JString, required = false,
                                 default = nil)
  if valid_590308 != nil:
    section.add "quotaUser", valid_590308
  var valid_590309 = query.getOrDefault("alt")
  valid_590309 = validateParameter(valid_590309, JString, required = false,
                                 default = newJString("json"))
  if valid_590309 != nil:
    section.add "alt", valid_590309
  var valid_590310 = query.getOrDefault("oauth_token")
  valid_590310 = validateParameter(valid_590310, JString, required = false,
                                 default = nil)
  if valid_590310 != nil:
    section.add "oauth_token", valid_590310
  var valid_590311 = query.getOrDefault("userIp")
  valid_590311 = validateParameter(valid_590311, JString, required = false,
                                 default = nil)
  if valid_590311 != nil:
    section.add "userIp", valid_590311
  var valid_590312 = query.getOrDefault("key")
  valid_590312 = validateParameter(valid_590312, JString, required = false,
                                 default = nil)
  if valid_590312 != nil:
    section.add "key", valid_590312
  var valid_590313 = query.getOrDefault("useDomainAdminAccess")
  valid_590313 = validateParameter(valid_590313, JBool, required = false,
                                 default = newJBool(false))
  if valid_590313 != nil:
    section.add "useDomainAdminAccess", valid_590313
  var valid_590314 = query.getOrDefault("prettyPrint")
  valid_590314 = validateParameter(valid_590314, JBool, required = false,
                                 default = newJBool(true))
  if valid_590314 != nil:
    section.add "prettyPrint", valid_590314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590315: Call_DriveTeamdrivesGet_590303; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.get instead.
  ## 
  let valid = call_590315.validator(path, query, header, formData, body)
  let scheme = call_590315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590315.url(scheme.get, call_590315.host, call_590315.base,
                         call_590315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590315, url, valid)

proc call*(call_590316: Call_DriveTeamdrivesGet_590303; teamDriveId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          useDomainAdminAccess: bool = false; prettyPrint: bool = true): Recallable =
  ## driveTeamdrivesGet
  ## Deprecated use drives.get instead.
  ##   teamDriveId: string (required)
  ##              : The ID of the Team Drive
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
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the Team Drive belongs.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590317 = newJObject()
  var query_590318 = newJObject()
  add(path_590317, "teamDriveId", newJString(teamDriveId))
  add(query_590318, "fields", newJString(fields))
  add(query_590318, "quotaUser", newJString(quotaUser))
  add(query_590318, "alt", newJString(alt))
  add(query_590318, "oauth_token", newJString(oauthToken))
  add(query_590318, "userIp", newJString(userIp))
  add(query_590318, "key", newJString(key))
  add(query_590318, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_590318, "prettyPrint", newJBool(prettyPrint))
  result = call_590316.call(path_590317, query_590318, nil, nil, nil)

var driveTeamdrivesGet* = Call_DriveTeamdrivesGet_590303(
    name: "driveTeamdrivesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesGet_590304, base: "/drive/v2",
    url: url_DriveTeamdrivesGet_590305, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesDelete_590337 = ref object of OpenApiRestCall_588457
proc url_DriveTeamdrivesDelete_590339(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "teamDriveId" in path, "`teamDriveId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/teamdrives/"),
               (kind: VariableSegment, value: "teamDriveId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveTeamdrivesDelete_590338(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deprecated use drives.delete instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   teamDriveId: JString (required)
  ##              : The ID of the Team Drive
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `teamDriveId` field"
  var valid_590340 = path.getOrDefault("teamDriveId")
  valid_590340 = validateParameter(valid_590340, JString, required = true,
                                 default = nil)
  if valid_590340 != nil:
    section.add "teamDriveId", valid_590340
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
  var valid_590341 = query.getOrDefault("fields")
  valid_590341 = validateParameter(valid_590341, JString, required = false,
                                 default = nil)
  if valid_590341 != nil:
    section.add "fields", valid_590341
  var valid_590342 = query.getOrDefault("quotaUser")
  valid_590342 = validateParameter(valid_590342, JString, required = false,
                                 default = nil)
  if valid_590342 != nil:
    section.add "quotaUser", valid_590342
  var valid_590343 = query.getOrDefault("alt")
  valid_590343 = validateParameter(valid_590343, JString, required = false,
                                 default = newJString("json"))
  if valid_590343 != nil:
    section.add "alt", valid_590343
  var valid_590344 = query.getOrDefault("oauth_token")
  valid_590344 = validateParameter(valid_590344, JString, required = false,
                                 default = nil)
  if valid_590344 != nil:
    section.add "oauth_token", valid_590344
  var valid_590345 = query.getOrDefault("userIp")
  valid_590345 = validateParameter(valid_590345, JString, required = false,
                                 default = nil)
  if valid_590345 != nil:
    section.add "userIp", valid_590345
  var valid_590346 = query.getOrDefault("key")
  valid_590346 = validateParameter(valid_590346, JString, required = false,
                                 default = nil)
  if valid_590346 != nil:
    section.add "key", valid_590346
  var valid_590347 = query.getOrDefault("prettyPrint")
  valid_590347 = validateParameter(valid_590347, JBool, required = false,
                                 default = newJBool(true))
  if valid_590347 != nil:
    section.add "prettyPrint", valid_590347
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590348: Call_DriveTeamdrivesDelete_590337; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.delete instead.
  ## 
  let valid = call_590348.validator(path, query, header, formData, body)
  let scheme = call_590348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590348.url(scheme.get, call_590348.host, call_590348.base,
                         call_590348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590348, url, valid)

proc call*(call_590349: Call_DriveTeamdrivesDelete_590337; teamDriveId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## driveTeamdrivesDelete
  ## Deprecated use drives.delete instead.
  ##   teamDriveId: string (required)
  ##              : The ID of the Team Drive
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
  var path_590350 = newJObject()
  var query_590351 = newJObject()
  add(path_590350, "teamDriveId", newJString(teamDriveId))
  add(query_590351, "fields", newJString(fields))
  add(query_590351, "quotaUser", newJString(quotaUser))
  add(query_590351, "alt", newJString(alt))
  add(query_590351, "oauth_token", newJString(oauthToken))
  add(query_590351, "userIp", newJString(userIp))
  add(query_590351, "key", newJString(key))
  add(query_590351, "prettyPrint", newJBool(prettyPrint))
  result = call_590349.call(path_590350, query_590351, nil, nil, nil)

var driveTeamdrivesDelete* = Call_DriveTeamdrivesDelete_590337(
    name: "driveTeamdrivesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesDelete_590338, base: "/drive/v2",
    url: url_DriveTeamdrivesDelete_590339, schemes: {Scheme.Https})
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
