
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

  OpenApiRestCall_579424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579424): Option[Scheme] {.used.} =
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
  gcpServiceName = "drive"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DriveAboutGet_579692 = ref object of OpenApiRestCall_579424
proc url_DriveAboutGet_579694(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveAboutGet_579693(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_579806 = query.getOrDefault("fields")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "fields", valid_579806
  var valid_579807 = query.getOrDefault("quotaUser")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "quotaUser", valid_579807
  var valid_579821 = query.getOrDefault("alt")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = newJString("json"))
  if valid_579821 != nil:
    section.add "alt", valid_579821
  var valid_579822 = query.getOrDefault("oauth_token")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "oauth_token", valid_579822
  var valid_579823 = query.getOrDefault("userIp")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "userIp", valid_579823
  var valid_579824 = query.getOrDefault("maxChangeIdCount")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = newJString("1"))
  if valid_579824 != nil:
    section.add "maxChangeIdCount", valid_579824
  var valid_579825 = query.getOrDefault("includeSubscribed")
  valid_579825 = validateParameter(valid_579825, JBool, required = false,
                                 default = newJBool(true))
  if valid_579825 != nil:
    section.add "includeSubscribed", valid_579825
  var valid_579826 = query.getOrDefault("key")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "key", valid_579826
  var valid_579827 = query.getOrDefault("prettyPrint")
  valid_579827 = validateParameter(valid_579827, JBool, required = false,
                                 default = newJBool(true))
  if valid_579827 != nil:
    section.add "prettyPrint", valid_579827
  var valid_579828 = query.getOrDefault("startChangeId")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = nil)
  if valid_579828 != nil:
    section.add "startChangeId", valid_579828
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579851: Call_DriveAboutGet_579692; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the current user along with Drive API settings
  ## 
  let valid = call_579851.validator(path, query, header, formData, body)
  let scheme = call_579851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579851.url(scheme.get, call_579851.host, call_579851.base,
                         call_579851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579851, url, valid)

proc call*(call_579922: Call_DriveAboutGet_579692; fields: string = "";
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
  var query_579923 = newJObject()
  add(query_579923, "fields", newJString(fields))
  add(query_579923, "quotaUser", newJString(quotaUser))
  add(query_579923, "alt", newJString(alt))
  add(query_579923, "oauth_token", newJString(oauthToken))
  add(query_579923, "userIp", newJString(userIp))
  add(query_579923, "maxChangeIdCount", newJString(maxChangeIdCount))
  add(query_579923, "includeSubscribed", newJBool(includeSubscribed))
  add(query_579923, "key", newJString(key))
  add(query_579923, "prettyPrint", newJBool(prettyPrint))
  add(query_579923, "startChangeId", newJString(startChangeId))
  result = call_579922.call(nil, query_579923, nil, nil, nil)

var driveAboutGet* = Call_DriveAboutGet_579692(name: "driveAboutGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/about",
    validator: validate_DriveAboutGet_579693, base: "/drive/v2",
    url: url_DriveAboutGet_579694, schemes: {Scheme.Https})
type
  Call_DriveAppsList_579963 = ref object of OpenApiRestCall_579424
proc url_DriveAppsList_579965(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveAppsList_579964(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_579966 = query.getOrDefault("fields")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "fields", valid_579966
  var valid_579967 = query.getOrDefault("quotaUser")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "quotaUser", valid_579967
  var valid_579968 = query.getOrDefault("alt")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = newJString("json"))
  if valid_579968 != nil:
    section.add "alt", valid_579968
  var valid_579969 = query.getOrDefault("appFilterExtensions")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = newJString(""))
  if valid_579969 != nil:
    section.add "appFilterExtensions", valid_579969
  var valid_579970 = query.getOrDefault("oauth_token")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "oauth_token", valid_579970
  var valid_579971 = query.getOrDefault("userIp")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "userIp", valid_579971
  var valid_579972 = query.getOrDefault("key")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "key", valid_579972
  var valid_579973 = query.getOrDefault("appFilterMimeTypes")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = newJString(""))
  if valid_579973 != nil:
    section.add "appFilterMimeTypes", valid_579973
  var valid_579974 = query.getOrDefault("languageCode")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "languageCode", valid_579974
  var valid_579975 = query.getOrDefault("prettyPrint")
  valid_579975 = validateParameter(valid_579975, JBool, required = false,
                                 default = newJBool(true))
  if valid_579975 != nil:
    section.add "prettyPrint", valid_579975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579976: Call_DriveAppsList_579963; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a user's installed apps.
  ## 
  let valid = call_579976.validator(path, query, header, formData, body)
  let scheme = call_579976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579976.url(scheme.get, call_579976.host, call_579976.base,
                         call_579976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579976, url, valid)

proc call*(call_579977: Call_DriveAppsList_579963; fields: string = "";
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
  var query_579978 = newJObject()
  add(query_579978, "fields", newJString(fields))
  add(query_579978, "quotaUser", newJString(quotaUser))
  add(query_579978, "alt", newJString(alt))
  add(query_579978, "appFilterExtensions", newJString(appFilterExtensions))
  add(query_579978, "oauth_token", newJString(oauthToken))
  add(query_579978, "userIp", newJString(userIp))
  add(query_579978, "key", newJString(key))
  add(query_579978, "appFilterMimeTypes", newJString(appFilterMimeTypes))
  add(query_579978, "languageCode", newJString(languageCode))
  add(query_579978, "prettyPrint", newJBool(prettyPrint))
  result = call_579977.call(nil, query_579978, nil, nil, nil)

var driveAppsList* = Call_DriveAppsList_579963(name: "driveAppsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/apps",
    validator: validate_DriveAppsList_579964, base: "/drive/v2",
    url: url_DriveAppsList_579965, schemes: {Scheme.Https})
type
  Call_DriveAppsGet_579979 = ref object of OpenApiRestCall_579424
proc url_DriveAppsGet_579981(protocol: Scheme; host: string; base: string;
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

proc validate_DriveAppsGet_579980(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_579996 = path.getOrDefault("appId")
  valid_579996 = validateParameter(valid_579996, JString, required = true,
                                 default = nil)
  if valid_579996 != nil:
    section.add "appId", valid_579996
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
  var valid_579997 = query.getOrDefault("fields")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "fields", valid_579997
  var valid_579998 = query.getOrDefault("quotaUser")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "quotaUser", valid_579998
  var valid_579999 = query.getOrDefault("alt")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = newJString("json"))
  if valid_579999 != nil:
    section.add "alt", valid_579999
  var valid_580000 = query.getOrDefault("oauth_token")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "oauth_token", valid_580000
  var valid_580001 = query.getOrDefault("userIp")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "userIp", valid_580001
  var valid_580002 = query.getOrDefault("key")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "key", valid_580002
  var valid_580003 = query.getOrDefault("prettyPrint")
  valid_580003 = validateParameter(valid_580003, JBool, required = false,
                                 default = newJBool(true))
  if valid_580003 != nil:
    section.add "prettyPrint", valid_580003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580004: Call_DriveAppsGet_579979; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific app.
  ## 
  let valid = call_580004.validator(path, query, header, formData, body)
  let scheme = call_580004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580004.url(scheme.get, call_580004.host, call_580004.base,
                         call_580004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580004, url, valid)

proc call*(call_580005: Call_DriveAppsGet_579979; appId: string; fields: string = "";
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
  var path_580006 = newJObject()
  var query_580007 = newJObject()
  add(query_580007, "fields", newJString(fields))
  add(query_580007, "quotaUser", newJString(quotaUser))
  add(query_580007, "alt", newJString(alt))
  add(query_580007, "oauth_token", newJString(oauthToken))
  add(query_580007, "userIp", newJString(userIp))
  add(path_580006, "appId", newJString(appId))
  add(query_580007, "key", newJString(key))
  add(query_580007, "prettyPrint", newJBool(prettyPrint))
  result = call_580005.call(path_580006, query_580007, nil, nil, nil)

var driveAppsGet* = Call_DriveAppsGet_579979(name: "driveAppsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/apps/{appId}",
    validator: validate_DriveAppsGet_579980, base: "/drive/v2",
    url: url_DriveAppsGet_579981, schemes: {Scheme.Https})
type
  Call_DriveChangesList_580008 = ref object of OpenApiRestCall_579424
proc url_DriveChangesList_580010(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveChangesList_580009(path: JsonNode; query: JsonNode;
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
  var valid_580011 = query.getOrDefault("driveId")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "driveId", valid_580011
  var valid_580012 = query.getOrDefault("supportsAllDrives")
  valid_580012 = validateParameter(valid_580012, JBool, required = false,
                                 default = newJBool(false))
  if valid_580012 != nil:
    section.add "supportsAllDrives", valid_580012
  var valid_580013 = query.getOrDefault("fields")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "fields", valid_580013
  var valid_580014 = query.getOrDefault("pageToken")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "pageToken", valid_580014
  var valid_580015 = query.getOrDefault("quotaUser")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "quotaUser", valid_580015
  var valid_580016 = query.getOrDefault("alt")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = newJString("json"))
  if valid_580016 != nil:
    section.add "alt", valid_580016
  var valid_580017 = query.getOrDefault("oauth_token")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "oauth_token", valid_580017
  var valid_580018 = query.getOrDefault("includeItemsFromAllDrives")
  valid_580018 = validateParameter(valid_580018, JBool, required = false,
                                 default = newJBool(false))
  if valid_580018 != nil:
    section.add "includeItemsFromAllDrives", valid_580018
  var valid_580019 = query.getOrDefault("userIp")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "userIp", valid_580019
  var valid_580020 = query.getOrDefault("includeTeamDriveItems")
  valid_580020 = validateParameter(valid_580020, JBool, required = false,
                                 default = newJBool(false))
  if valid_580020 != nil:
    section.add "includeTeamDriveItems", valid_580020
  var valid_580021 = query.getOrDefault("teamDriveId")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "teamDriveId", valid_580021
  var valid_580022 = query.getOrDefault("includeSubscribed")
  valid_580022 = validateParameter(valid_580022, JBool, required = false,
                                 default = newJBool(true))
  if valid_580022 != nil:
    section.add "includeSubscribed", valid_580022
  var valid_580024 = query.getOrDefault("maxResults")
  valid_580024 = validateParameter(valid_580024, JInt, required = false,
                                 default = newJInt(100))
  if valid_580024 != nil:
    section.add "maxResults", valid_580024
  var valid_580025 = query.getOrDefault("supportsTeamDrives")
  valid_580025 = validateParameter(valid_580025, JBool, required = false,
                                 default = newJBool(false))
  if valid_580025 != nil:
    section.add "supportsTeamDrives", valid_580025
  var valid_580026 = query.getOrDefault("key")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "key", valid_580026
  var valid_580027 = query.getOrDefault("includeDeleted")
  valid_580027 = validateParameter(valid_580027, JBool, required = false,
                                 default = newJBool(true))
  if valid_580027 != nil:
    section.add "includeDeleted", valid_580027
  var valid_580028 = query.getOrDefault("spaces")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "spaces", valid_580028
  var valid_580029 = query.getOrDefault("prettyPrint")
  valid_580029 = validateParameter(valid_580029, JBool, required = false,
                                 default = newJBool(true))
  if valid_580029 != nil:
    section.add "prettyPrint", valid_580029
  var valid_580030 = query.getOrDefault("startChangeId")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "startChangeId", valid_580030
  var valid_580031 = query.getOrDefault("includeCorpusRemovals")
  valid_580031 = validateParameter(valid_580031, JBool, required = false,
                                 default = newJBool(false))
  if valid_580031 != nil:
    section.add "includeCorpusRemovals", valid_580031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580032: Call_DriveChangesList_580008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the changes for a user or shared drive.
  ## 
  let valid = call_580032.validator(path, query, header, formData, body)
  let scheme = call_580032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580032.url(scheme.get, call_580032.host, call_580032.base,
                         call_580032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580032, url, valid)

proc call*(call_580033: Call_DriveChangesList_580008; driveId: string = "";
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
  var query_580034 = newJObject()
  add(query_580034, "driveId", newJString(driveId))
  add(query_580034, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580034, "fields", newJString(fields))
  add(query_580034, "pageToken", newJString(pageToken))
  add(query_580034, "quotaUser", newJString(quotaUser))
  add(query_580034, "alt", newJString(alt))
  add(query_580034, "oauth_token", newJString(oauthToken))
  add(query_580034, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_580034, "userIp", newJString(userIp))
  add(query_580034, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  add(query_580034, "teamDriveId", newJString(teamDriveId))
  add(query_580034, "includeSubscribed", newJBool(includeSubscribed))
  add(query_580034, "maxResults", newJInt(maxResults))
  add(query_580034, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580034, "key", newJString(key))
  add(query_580034, "includeDeleted", newJBool(includeDeleted))
  add(query_580034, "spaces", newJString(spaces))
  add(query_580034, "prettyPrint", newJBool(prettyPrint))
  add(query_580034, "startChangeId", newJString(startChangeId))
  add(query_580034, "includeCorpusRemovals", newJBool(includeCorpusRemovals))
  result = call_580033.call(nil, query_580034, nil, nil, nil)

var driveChangesList* = Call_DriveChangesList_580008(name: "driveChangesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/changes",
    validator: validate_DriveChangesList_580009, base: "/drive/v2",
    url: url_DriveChangesList_580010, schemes: {Scheme.Https})
type
  Call_DriveChangesGetStartPageToken_580035 = ref object of OpenApiRestCall_579424
proc url_DriveChangesGetStartPageToken_580037(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveChangesGetStartPageToken_580036(path: JsonNode; query: JsonNode;
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
  var valid_580038 = query.getOrDefault("driveId")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "driveId", valid_580038
  var valid_580039 = query.getOrDefault("supportsAllDrives")
  valid_580039 = validateParameter(valid_580039, JBool, required = false,
                                 default = newJBool(false))
  if valid_580039 != nil:
    section.add "supportsAllDrives", valid_580039
  var valid_580040 = query.getOrDefault("fields")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "fields", valid_580040
  var valid_580041 = query.getOrDefault("quotaUser")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "quotaUser", valid_580041
  var valid_580042 = query.getOrDefault("alt")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = newJString("json"))
  if valid_580042 != nil:
    section.add "alt", valid_580042
  var valid_580043 = query.getOrDefault("oauth_token")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "oauth_token", valid_580043
  var valid_580044 = query.getOrDefault("userIp")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "userIp", valid_580044
  var valid_580045 = query.getOrDefault("teamDriveId")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "teamDriveId", valid_580045
  var valid_580046 = query.getOrDefault("supportsTeamDrives")
  valid_580046 = validateParameter(valid_580046, JBool, required = false,
                                 default = newJBool(false))
  if valid_580046 != nil:
    section.add "supportsTeamDrives", valid_580046
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580049: Call_DriveChangesGetStartPageToken_580035; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the starting pageToken for listing future changes.
  ## 
  let valid = call_580049.validator(path, query, header, formData, body)
  let scheme = call_580049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580049.url(scheme.get, call_580049.host, call_580049.base,
                         call_580049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580049, url, valid)

proc call*(call_580050: Call_DriveChangesGetStartPageToken_580035;
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
  var query_580051 = newJObject()
  add(query_580051, "driveId", newJString(driveId))
  add(query_580051, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580051, "fields", newJString(fields))
  add(query_580051, "quotaUser", newJString(quotaUser))
  add(query_580051, "alt", newJString(alt))
  add(query_580051, "oauth_token", newJString(oauthToken))
  add(query_580051, "userIp", newJString(userIp))
  add(query_580051, "teamDriveId", newJString(teamDriveId))
  add(query_580051, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580051, "key", newJString(key))
  add(query_580051, "prettyPrint", newJBool(prettyPrint))
  result = call_580050.call(nil, query_580051, nil, nil, nil)

var driveChangesGetStartPageToken* = Call_DriveChangesGetStartPageToken_580035(
    name: "driveChangesGetStartPageToken", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/changes/startPageToken",
    validator: validate_DriveChangesGetStartPageToken_580036, base: "/drive/v2",
    url: url_DriveChangesGetStartPageToken_580037, schemes: {Scheme.Https})
type
  Call_DriveChangesWatch_580052 = ref object of OpenApiRestCall_579424
proc url_DriveChangesWatch_580054(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveChangesWatch_580053(path: JsonNode; query: JsonNode;
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
  var valid_580055 = query.getOrDefault("driveId")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "driveId", valid_580055
  var valid_580056 = query.getOrDefault("supportsAllDrives")
  valid_580056 = validateParameter(valid_580056, JBool, required = false,
                                 default = newJBool(false))
  if valid_580056 != nil:
    section.add "supportsAllDrives", valid_580056
  var valid_580057 = query.getOrDefault("fields")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "fields", valid_580057
  var valid_580058 = query.getOrDefault("pageToken")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "pageToken", valid_580058
  var valid_580059 = query.getOrDefault("quotaUser")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "quotaUser", valid_580059
  var valid_580060 = query.getOrDefault("alt")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = newJString("json"))
  if valid_580060 != nil:
    section.add "alt", valid_580060
  var valid_580061 = query.getOrDefault("oauth_token")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "oauth_token", valid_580061
  var valid_580062 = query.getOrDefault("includeItemsFromAllDrives")
  valid_580062 = validateParameter(valid_580062, JBool, required = false,
                                 default = newJBool(false))
  if valid_580062 != nil:
    section.add "includeItemsFromAllDrives", valid_580062
  var valid_580063 = query.getOrDefault("userIp")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "userIp", valid_580063
  var valid_580064 = query.getOrDefault("includeTeamDriveItems")
  valid_580064 = validateParameter(valid_580064, JBool, required = false,
                                 default = newJBool(false))
  if valid_580064 != nil:
    section.add "includeTeamDriveItems", valid_580064
  var valid_580065 = query.getOrDefault("teamDriveId")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "teamDriveId", valid_580065
  var valid_580066 = query.getOrDefault("includeSubscribed")
  valid_580066 = validateParameter(valid_580066, JBool, required = false,
                                 default = newJBool(true))
  if valid_580066 != nil:
    section.add "includeSubscribed", valid_580066
  var valid_580067 = query.getOrDefault("maxResults")
  valid_580067 = validateParameter(valid_580067, JInt, required = false,
                                 default = newJInt(100))
  if valid_580067 != nil:
    section.add "maxResults", valid_580067
  var valid_580068 = query.getOrDefault("supportsTeamDrives")
  valid_580068 = validateParameter(valid_580068, JBool, required = false,
                                 default = newJBool(false))
  if valid_580068 != nil:
    section.add "supportsTeamDrives", valid_580068
  var valid_580069 = query.getOrDefault("key")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "key", valid_580069
  var valid_580070 = query.getOrDefault("includeDeleted")
  valid_580070 = validateParameter(valid_580070, JBool, required = false,
                                 default = newJBool(true))
  if valid_580070 != nil:
    section.add "includeDeleted", valid_580070
  var valid_580071 = query.getOrDefault("spaces")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "spaces", valid_580071
  var valid_580072 = query.getOrDefault("prettyPrint")
  valid_580072 = validateParameter(valid_580072, JBool, required = false,
                                 default = newJBool(true))
  if valid_580072 != nil:
    section.add "prettyPrint", valid_580072
  var valid_580073 = query.getOrDefault("startChangeId")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "startChangeId", valid_580073
  var valid_580074 = query.getOrDefault("includeCorpusRemovals")
  valid_580074 = validateParameter(valid_580074, JBool, required = false,
                                 default = newJBool(false))
  if valid_580074 != nil:
    section.add "includeCorpusRemovals", valid_580074
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

proc call*(call_580076: Call_DriveChangesWatch_580052; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Subscribe to changes for a user.
  ## 
  let valid = call_580076.validator(path, query, header, formData, body)
  let scheme = call_580076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580076.url(scheme.get, call_580076.host, call_580076.base,
                         call_580076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580076, url, valid)

proc call*(call_580077: Call_DriveChangesWatch_580052; driveId: string = "";
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
  var query_580078 = newJObject()
  var body_580079 = newJObject()
  add(query_580078, "driveId", newJString(driveId))
  add(query_580078, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580078, "fields", newJString(fields))
  add(query_580078, "pageToken", newJString(pageToken))
  add(query_580078, "quotaUser", newJString(quotaUser))
  add(query_580078, "alt", newJString(alt))
  add(query_580078, "oauth_token", newJString(oauthToken))
  add(query_580078, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_580078, "userIp", newJString(userIp))
  add(query_580078, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  add(query_580078, "teamDriveId", newJString(teamDriveId))
  add(query_580078, "includeSubscribed", newJBool(includeSubscribed))
  add(query_580078, "maxResults", newJInt(maxResults))
  add(query_580078, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580078, "key", newJString(key))
  add(query_580078, "includeDeleted", newJBool(includeDeleted))
  add(query_580078, "spaces", newJString(spaces))
  if resource != nil:
    body_580079 = resource
  add(query_580078, "prettyPrint", newJBool(prettyPrint))
  add(query_580078, "startChangeId", newJString(startChangeId))
  add(query_580078, "includeCorpusRemovals", newJBool(includeCorpusRemovals))
  result = call_580077.call(nil, query_580078, nil, nil, body_580079)

var driveChangesWatch* = Call_DriveChangesWatch_580052(name: "driveChangesWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/changes/watch",
    validator: validate_DriveChangesWatch_580053, base: "/drive/v2",
    url: url_DriveChangesWatch_580054, schemes: {Scheme.Https})
type
  Call_DriveChangesGet_580080 = ref object of OpenApiRestCall_579424
proc url_DriveChangesGet_580082(protocol: Scheme; host: string; base: string;
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

proc validate_DriveChangesGet_580081(path: JsonNode; query: JsonNode;
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
  var valid_580083 = path.getOrDefault("changeId")
  valid_580083 = validateParameter(valid_580083, JString, required = true,
                                 default = nil)
  if valid_580083 != nil:
    section.add "changeId", valid_580083
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
  var valid_580084 = query.getOrDefault("driveId")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "driveId", valid_580084
  var valid_580085 = query.getOrDefault("supportsAllDrives")
  valid_580085 = validateParameter(valid_580085, JBool, required = false,
                                 default = newJBool(false))
  if valid_580085 != nil:
    section.add "supportsAllDrives", valid_580085
  var valid_580086 = query.getOrDefault("fields")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "fields", valid_580086
  var valid_580087 = query.getOrDefault("quotaUser")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "quotaUser", valid_580087
  var valid_580088 = query.getOrDefault("alt")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = newJString("json"))
  if valid_580088 != nil:
    section.add "alt", valid_580088
  var valid_580089 = query.getOrDefault("oauth_token")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "oauth_token", valid_580089
  var valid_580090 = query.getOrDefault("userIp")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "userIp", valid_580090
  var valid_580091 = query.getOrDefault("teamDriveId")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "teamDriveId", valid_580091
  var valid_580092 = query.getOrDefault("supportsTeamDrives")
  valid_580092 = validateParameter(valid_580092, JBool, required = false,
                                 default = newJBool(false))
  if valid_580092 != nil:
    section.add "supportsTeamDrives", valid_580092
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580095: Call_DriveChangesGet_580080; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated - Use changes.getStartPageToken and changes.list to retrieve recent changes.
  ## 
  let valid = call_580095.validator(path, query, header, formData, body)
  let scheme = call_580095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580095.url(scheme.get, call_580095.host, call_580095.base,
                         call_580095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580095, url, valid)

proc call*(call_580096: Call_DriveChangesGet_580080; changeId: string;
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
  var path_580097 = newJObject()
  var query_580098 = newJObject()
  add(query_580098, "driveId", newJString(driveId))
  add(query_580098, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580098, "fields", newJString(fields))
  add(path_580097, "changeId", newJString(changeId))
  add(query_580098, "quotaUser", newJString(quotaUser))
  add(query_580098, "alt", newJString(alt))
  add(query_580098, "oauth_token", newJString(oauthToken))
  add(query_580098, "userIp", newJString(userIp))
  add(query_580098, "teamDriveId", newJString(teamDriveId))
  add(query_580098, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580098, "key", newJString(key))
  add(query_580098, "prettyPrint", newJBool(prettyPrint))
  result = call_580096.call(path_580097, query_580098, nil, nil, nil)

var driveChangesGet* = Call_DriveChangesGet_580080(name: "driveChangesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/changes/{changeId}", validator: validate_DriveChangesGet_580081,
    base: "/drive/v2", url: url_DriveChangesGet_580082, schemes: {Scheme.Https})
type
  Call_DriveChannelsStop_580099 = ref object of OpenApiRestCall_579424
proc url_DriveChannelsStop_580101(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveChannelsStop_580100(path: JsonNode; query: JsonNode;
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
  var valid_580102 = query.getOrDefault("fields")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "fields", valid_580102
  var valid_580103 = query.getOrDefault("quotaUser")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "quotaUser", valid_580103
  var valid_580104 = query.getOrDefault("alt")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = newJString("json"))
  if valid_580104 != nil:
    section.add "alt", valid_580104
  var valid_580105 = query.getOrDefault("oauth_token")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "oauth_token", valid_580105
  var valid_580106 = query.getOrDefault("userIp")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "userIp", valid_580106
  var valid_580107 = query.getOrDefault("key")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "key", valid_580107
  var valid_580108 = query.getOrDefault("prettyPrint")
  valid_580108 = validateParameter(valid_580108, JBool, required = false,
                                 default = newJBool(true))
  if valid_580108 != nil:
    section.add "prettyPrint", valid_580108
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

proc call*(call_580110: Call_DriveChannelsStop_580099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_580110.validator(path, query, header, formData, body)
  let scheme = call_580110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580110.url(scheme.get, call_580110.host, call_580110.base,
                         call_580110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580110, url, valid)

proc call*(call_580111: Call_DriveChannelsStop_580099; fields: string = "";
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
  var query_580112 = newJObject()
  var body_580113 = newJObject()
  add(query_580112, "fields", newJString(fields))
  add(query_580112, "quotaUser", newJString(quotaUser))
  add(query_580112, "alt", newJString(alt))
  add(query_580112, "oauth_token", newJString(oauthToken))
  add(query_580112, "userIp", newJString(userIp))
  add(query_580112, "key", newJString(key))
  if resource != nil:
    body_580113 = resource
  add(query_580112, "prettyPrint", newJBool(prettyPrint))
  result = call_580111.call(nil, query_580112, nil, nil, body_580113)

var driveChannelsStop* = Call_DriveChannelsStop_580099(name: "driveChannelsStop",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/channels/stop",
    validator: validate_DriveChannelsStop_580100, base: "/drive/v2",
    url: url_DriveChannelsStop_580101, schemes: {Scheme.Https})
type
  Call_DriveDrivesInsert_580131 = ref object of OpenApiRestCall_579424
proc url_DriveDrivesInsert_580133(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveDrivesInsert_580132(path: JsonNode; query: JsonNode;
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
  var valid_580134 = query.getOrDefault("fields")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "fields", valid_580134
  assert query != nil,
        "query argument is necessary due to required `requestId` field"
  var valid_580135 = query.getOrDefault("requestId")
  valid_580135 = validateParameter(valid_580135, JString, required = true,
                                 default = nil)
  if valid_580135 != nil:
    section.add "requestId", valid_580135
  var valid_580136 = query.getOrDefault("quotaUser")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "quotaUser", valid_580136
  var valid_580137 = query.getOrDefault("alt")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = newJString("json"))
  if valid_580137 != nil:
    section.add "alt", valid_580137
  var valid_580138 = query.getOrDefault("oauth_token")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "oauth_token", valid_580138
  var valid_580139 = query.getOrDefault("userIp")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "userIp", valid_580139
  var valid_580140 = query.getOrDefault("key")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "key", valid_580140
  var valid_580141 = query.getOrDefault("prettyPrint")
  valid_580141 = validateParameter(valid_580141, JBool, required = false,
                                 default = newJBool(true))
  if valid_580141 != nil:
    section.add "prettyPrint", valid_580141
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

proc call*(call_580143: Call_DriveDrivesInsert_580131; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new shared drive.
  ## 
  let valid = call_580143.validator(path, query, header, formData, body)
  let scheme = call_580143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580143.url(scheme.get, call_580143.host, call_580143.base,
                         call_580143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580143, url, valid)

proc call*(call_580144: Call_DriveDrivesInsert_580131; requestId: string;
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
  var query_580145 = newJObject()
  var body_580146 = newJObject()
  add(query_580145, "fields", newJString(fields))
  add(query_580145, "requestId", newJString(requestId))
  add(query_580145, "quotaUser", newJString(quotaUser))
  add(query_580145, "alt", newJString(alt))
  add(query_580145, "oauth_token", newJString(oauthToken))
  add(query_580145, "userIp", newJString(userIp))
  add(query_580145, "key", newJString(key))
  if body != nil:
    body_580146 = body
  add(query_580145, "prettyPrint", newJBool(prettyPrint))
  result = call_580144.call(nil, query_580145, nil, nil, body_580146)

var driveDrivesInsert* = Call_DriveDrivesInsert_580131(name: "driveDrivesInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/drives",
    validator: validate_DriveDrivesInsert_580132, base: "/drive/v2",
    url: url_DriveDrivesInsert_580133, schemes: {Scheme.Https})
type
  Call_DriveDrivesList_580114 = ref object of OpenApiRestCall_579424
proc url_DriveDrivesList_580116(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveDrivesList_580115(path: JsonNode; query: JsonNode;
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
  var valid_580117 = query.getOrDefault("fields")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "fields", valid_580117
  var valid_580118 = query.getOrDefault("pageToken")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "pageToken", valid_580118
  var valid_580119 = query.getOrDefault("quotaUser")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "quotaUser", valid_580119
  var valid_580120 = query.getOrDefault("alt")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = newJString("json"))
  if valid_580120 != nil:
    section.add "alt", valid_580120
  var valid_580121 = query.getOrDefault("oauth_token")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "oauth_token", valid_580121
  var valid_580122 = query.getOrDefault("userIp")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "userIp", valid_580122
  var valid_580123 = query.getOrDefault("maxResults")
  valid_580123 = validateParameter(valid_580123, JInt, required = false,
                                 default = newJInt(10))
  if valid_580123 != nil:
    section.add "maxResults", valid_580123
  var valid_580124 = query.getOrDefault("q")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "q", valid_580124
  var valid_580125 = query.getOrDefault("key")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "key", valid_580125
  var valid_580126 = query.getOrDefault("useDomainAdminAccess")
  valid_580126 = validateParameter(valid_580126, JBool, required = false,
                                 default = newJBool(false))
  if valid_580126 != nil:
    section.add "useDomainAdminAccess", valid_580126
  var valid_580127 = query.getOrDefault("prettyPrint")
  valid_580127 = validateParameter(valid_580127, JBool, required = false,
                                 default = newJBool(true))
  if valid_580127 != nil:
    section.add "prettyPrint", valid_580127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580128: Call_DriveDrivesList_580114; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the user's shared drives.
  ## 
  let valid = call_580128.validator(path, query, header, formData, body)
  let scheme = call_580128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580128.url(scheme.get, call_580128.host, call_580128.base,
                         call_580128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580128, url, valid)

proc call*(call_580129: Call_DriveDrivesList_580114; fields: string = "";
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
  var query_580130 = newJObject()
  add(query_580130, "fields", newJString(fields))
  add(query_580130, "pageToken", newJString(pageToken))
  add(query_580130, "quotaUser", newJString(quotaUser))
  add(query_580130, "alt", newJString(alt))
  add(query_580130, "oauth_token", newJString(oauthToken))
  add(query_580130, "userIp", newJString(userIp))
  add(query_580130, "maxResults", newJInt(maxResults))
  add(query_580130, "q", newJString(q))
  add(query_580130, "key", newJString(key))
  add(query_580130, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580130, "prettyPrint", newJBool(prettyPrint))
  result = call_580129.call(nil, query_580130, nil, nil, nil)

var driveDrivesList* = Call_DriveDrivesList_580114(name: "driveDrivesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/drives",
    validator: validate_DriveDrivesList_580115, base: "/drive/v2",
    url: url_DriveDrivesList_580116, schemes: {Scheme.Https})
type
  Call_DriveDrivesUpdate_580163 = ref object of OpenApiRestCall_579424
proc url_DriveDrivesUpdate_580165(protocol: Scheme; host: string; base: string;
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

proc validate_DriveDrivesUpdate_580164(path: JsonNode; query: JsonNode;
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
  var valid_580166 = path.getOrDefault("driveId")
  valid_580166 = validateParameter(valid_580166, JString, required = true,
                                 default = nil)
  if valid_580166 != nil:
    section.add "driveId", valid_580166
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
  var valid_580167 = query.getOrDefault("fields")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "fields", valid_580167
  var valid_580168 = query.getOrDefault("quotaUser")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "quotaUser", valid_580168
  var valid_580169 = query.getOrDefault("alt")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = newJString("json"))
  if valid_580169 != nil:
    section.add "alt", valid_580169
  var valid_580170 = query.getOrDefault("oauth_token")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "oauth_token", valid_580170
  var valid_580171 = query.getOrDefault("userIp")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "userIp", valid_580171
  var valid_580172 = query.getOrDefault("key")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "key", valid_580172
  var valid_580173 = query.getOrDefault("useDomainAdminAccess")
  valid_580173 = validateParameter(valid_580173, JBool, required = false,
                                 default = newJBool(false))
  if valid_580173 != nil:
    section.add "useDomainAdminAccess", valid_580173
  var valid_580174 = query.getOrDefault("prettyPrint")
  valid_580174 = validateParameter(valid_580174, JBool, required = false,
                                 default = newJBool(true))
  if valid_580174 != nil:
    section.add "prettyPrint", valid_580174
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

proc call*(call_580176: Call_DriveDrivesUpdate_580163; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the metadata for a shared drive.
  ## 
  let valid = call_580176.validator(path, query, header, formData, body)
  let scheme = call_580176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580176.url(scheme.get, call_580176.host, call_580176.base,
                         call_580176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580176, url, valid)

proc call*(call_580177: Call_DriveDrivesUpdate_580163; driveId: string;
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
  var path_580178 = newJObject()
  var query_580179 = newJObject()
  var body_580180 = newJObject()
  add(query_580179, "fields", newJString(fields))
  add(path_580178, "driveId", newJString(driveId))
  add(query_580179, "quotaUser", newJString(quotaUser))
  add(query_580179, "alt", newJString(alt))
  add(query_580179, "oauth_token", newJString(oauthToken))
  add(query_580179, "userIp", newJString(userIp))
  add(query_580179, "key", newJString(key))
  add(query_580179, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  if body != nil:
    body_580180 = body
  add(query_580179, "prettyPrint", newJBool(prettyPrint))
  result = call_580177.call(path_580178, query_580179, nil, nil, body_580180)

var driveDrivesUpdate* = Call_DriveDrivesUpdate_580163(name: "driveDrivesUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesUpdate_580164,
    base: "/drive/v2", url: url_DriveDrivesUpdate_580165, schemes: {Scheme.Https})
type
  Call_DriveDrivesGet_580147 = ref object of OpenApiRestCall_579424
proc url_DriveDrivesGet_580149(protocol: Scheme; host: string; base: string;
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

proc validate_DriveDrivesGet_580148(path: JsonNode; query: JsonNode;
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
  var valid_580150 = path.getOrDefault("driveId")
  valid_580150 = validateParameter(valid_580150, JString, required = true,
                                 default = nil)
  if valid_580150 != nil:
    section.add "driveId", valid_580150
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
  var valid_580151 = query.getOrDefault("fields")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "fields", valid_580151
  var valid_580152 = query.getOrDefault("quotaUser")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "quotaUser", valid_580152
  var valid_580153 = query.getOrDefault("alt")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = newJString("json"))
  if valid_580153 != nil:
    section.add "alt", valid_580153
  var valid_580154 = query.getOrDefault("oauth_token")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "oauth_token", valid_580154
  var valid_580155 = query.getOrDefault("userIp")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "userIp", valid_580155
  var valid_580156 = query.getOrDefault("key")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "key", valid_580156
  var valid_580157 = query.getOrDefault("useDomainAdminAccess")
  valid_580157 = validateParameter(valid_580157, JBool, required = false,
                                 default = newJBool(false))
  if valid_580157 != nil:
    section.add "useDomainAdminAccess", valid_580157
  var valid_580158 = query.getOrDefault("prettyPrint")
  valid_580158 = validateParameter(valid_580158, JBool, required = false,
                                 default = newJBool(true))
  if valid_580158 != nil:
    section.add "prettyPrint", valid_580158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580159: Call_DriveDrivesGet_580147; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a shared drive's metadata by ID.
  ## 
  let valid = call_580159.validator(path, query, header, formData, body)
  let scheme = call_580159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580159.url(scheme.get, call_580159.host, call_580159.base,
                         call_580159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580159, url, valid)

proc call*(call_580160: Call_DriveDrivesGet_580147; driveId: string;
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
  var path_580161 = newJObject()
  var query_580162 = newJObject()
  add(query_580162, "fields", newJString(fields))
  add(path_580161, "driveId", newJString(driveId))
  add(query_580162, "quotaUser", newJString(quotaUser))
  add(query_580162, "alt", newJString(alt))
  add(query_580162, "oauth_token", newJString(oauthToken))
  add(query_580162, "userIp", newJString(userIp))
  add(query_580162, "key", newJString(key))
  add(query_580162, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580162, "prettyPrint", newJBool(prettyPrint))
  result = call_580160.call(path_580161, query_580162, nil, nil, nil)

var driveDrivesGet* = Call_DriveDrivesGet_580147(name: "driveDrivesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesGet_580148,
    base: "/drive/v2", url: url_DriveDrivesGet_580149, schemes: {Scheme.Https})
type
  Call_DriveDrivesDelete_580181 = ref object of OpenApiRestCall_579424
proc url_DriveDrivesDelete_580183(protocol: Scheme; host: string; base: string;
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

proc validate_DriveDrivesDelete_580182(path: JsonNode; query: JsonNode;
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
  var valid_580184 = path.getOrDefault("driveId")
  valid_580184 = validateParameter(valid_580184, JString, required = true,
                                 default = nil)
  if valid_580184 != nil:
    section.add "driveId", valid_580184
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
  var valid_580185 = query.getOrDefault("fields")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "fields", valid_580185
  var valid_580186 = query.getOrDefault("quotaUser")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "quotaUser", valid_580186
  var valid_580187 = query.getOrDefault("alt")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = newJString("json"))
  if valid_580187 != nil:
    section.add "alt", valid_580187
  var valid_580188 = query.getOrDefault("oauth_token")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "oauth_token", valid_580188
  var valid_580189 = query.getOrDefault("userIp")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "userIp", valid_580189
  var valid_580190 = query.getOrDefault("key")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "key", valid_580190
  var valid_580191 = query.getOrDefault("prettyPrint")
  valid_580191 = validateParameter(valid_580191, JBool, required = false,
                                 default = newJBool(true))
  if valid_580191 != nil:
    section.add "prettyPrint", valid_580191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580192: Call_DriveDrivesDelete_580181; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a shared drive for which the user is an organizer. The shared drive cannot contain any untrashed items.
  ## 
  let valid = call_580192.validator(path, query, header, formData, body)
  let scheme = call_580192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580192.url(scheme.get, call_580192.host, call_580192.base,
                         call_580192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580192, url, valid)

proc call*(call_580193: Call_DriveDrivesDelete_580181; driveId: string;
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
  var path_580194 = newJObject()
  var query_580195 = newJObject()
  add(query_580195, "fields", newJString(fields))
  add(path_580194, "driveId", newJString(driveId))
  add(query_580195, "quotaUser", newJString(quotaUser))
  add(query_580195, "alt", newJString(alt))
  add(query_580195, "oauth_token", newJString(oauthToken))
  add(query_580195, "userIp", newJString(userIp))
  add(query_580195, "key", newJString(key))
  add(query_580195, "prettyPrint", newJBool(prettyPrint))
  result = call_580193.call(path_580194, query_580195, nil, nil, nil)

var driveDrivesDelete* = Call_DriveDrivesDelete_580181(name: "driveDrivesDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesDelete_580182,
    base: "/drive/v2", url: url_DriveDrivesDelete_580183, schemes: {Scheme.Https})
type
  Call_DriveDrivesHide_580196 = ref object of OpenApiRestCall_579424
proc url_DriveDrivesHide_580198(protocol: Scheme; host: string; base: string;
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

proc validate_DriveDrivesHide_580197(path: JsonNode; query: JsonNode;
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
  var valid_580199 = path.getOrDefault("driveId")
  valid_580199 = validateParameter(valid_580199, JString, required = true,
                                 default = nil)
  if valid_580199 != nil:
    section.add "driveId", valid_580199
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
  var valid_580200 = query.getOrDefault("fields")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "fields", valid_580200
  var valid_580201 = query.getOrDefault("quotaUser")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "quotaUser", valid_580201
  var valid_580202 = query.getOrDefault("alt")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = newJString("json"))
  if valid_580202 != nil:
    section.add "alt", valid_580202
  var valid_580203 = query.getOrDefault("oauth_token")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "oauth_token", valid_580203
  var valid_580204 = query.getOrDefault("userIp")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "userIp", valid_580204
  var valid_580205 = query.getOrDefault("key")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "key", valid_580205
  var valid_580206 = query.getOrDefault("prettyPrint")
  valid_580206 = validateParameter(valid_580206, JBool, required = false,
                                 default = newJBool(true))
  if valid_580206 != nil:
    section.add "prettyPrint", valid_580206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580207: Call_DriveDrivesHide_580196; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Hides a shared drive from the default view.
  ## 
  let valid = call_580207.validator(path, query, header, formData, body)
  let scheme = call_580207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580207.url(scheme.get, call_580207.host, call_580207.base,
                         call_580207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580207, url, valid)

proc call*(call_580208: Call_DriveDrivesHide_580196; driveId: string;
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
  var path_580209 = newJObject()
  var query_580210 = newJObject()
  add(query_580210, "fields", newJString(fields))
  add(path_580209, "driveId", newJString(driveId))
  add(query_580210, "quotaUser", newJString(quotaUser))
  add(query_580210, "alt", newJString(alt))
  add(query_580210, "oauth_token", newJString(oauthToken))
  add(query_580210, "userIp", newJString(userIp))
  add(query_580210, "key", newJString(key))
  add(query_580210, "prettyPrint", newJBool(prettyPrint))
  result = call_580208.call(path_580209, query_580210, nil, nil, nil)

var driveDrivesHide* = Call_DriveDrivesHide_580196(name: "driveDrivesHide",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/drives/{driveId}/hide", validator: validate_DriveDrivesHide_580197,
    base: "/drive/v2", url: url_DriveDrivesHide_580198, schemes: {Scheme.Https})
type
  Call_DriveDrivesUnhide_580211 = ref object of OpenApiRestCall_579424
proc url_DriveDrivesUnhide_580213(protocol: Scheme; host: string; base: string;
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

proc validate_DriveDrivesUnhide_580212(path: JsonNode; query: JsonNode;
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
  var valid_580214 = path.getOrDefault("driveId")
  valid_580214 = validateParameter(valid_580214, JString, required = true,
                                 default = nil)
  if valid_580214 != nil:
    section.add "driveId", valid_580214
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
  var valid_580215 = query.getOrDefault("fields")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "fields", valid_580215
  var valid_580216 = query.getOrDefault("quotaUser")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "quotaUser", valid_580216
  var valid_580217 = query.getOrDefault("alt")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = newJString("json"))
  if valid_580217 != nil:
    section.add "alt", valid_580217
  var valid_580218 = query.getOrDefault("oauth_token")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "oauth_token", valid_580218
  var valid_580219 = query.getOrDefault("userIp")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "userIp", valid_580219
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580222: Call_DriveDrivesUnhide_580211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a shared drive to the default view.
  ## 
  let valid = call_580222.validator(path, query, header, formData, body)
  let scheme = call_580222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580222.url(scheme.get, call_580222.host, call_580222.base,
                         call_580222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580222, url, valid)

proc call*(call_580223: Call_DriveDrivesUnhide_580211; driveId: string;
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
  var path_580224 = newJObject()
  var query_580225 = newJObject()
  add(query_580225, "fields", newJString(fields))
  add(path_580224, "driveId", newJString(driveId))
  add(query_580225, "quotaUser", newJString(quotaUser))
  add(query_580225, "alt", newJString(alt))
  add(query_580225, "oauth_token", newJString(oauthToken))
  add(query_580225, "userIp", newJString(userIp))
  add(query_580225, "key", newJString(key))
  add(query_580225, "prettyPrint", newJBool(prettyPrint))
  result = call_580223.call(path_580224, query_580225, nil, nil, nil)

var driveDrivesUnhide* = Call_DriveDrivesUnhide_580211(name: "driveDrivesUnhide",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/drives/{driveId}/unhide", validator: validate_DriveDrivesUnhide_580212,
    base: "/drive/v2", url: url_DriveDrivesUnhide_580213, schemes: {Scheme.Https})
type
  Call_DriveFilesInsert_580253 = ref object of OpenApiRestCall_579424
proc url_DriveFilesInsert_580255(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveFilesInsert_580254(path: JsonNode; query: JsonNode;
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
  var valid_580256 = query.getOrDefault("supportsAllDrives")
  valid_580256 = validateParameter(valid_580256, JBool, required = false,
                                 default = newJBool(false))
  if valid_580256 != nil:
    section.add "supportsAllDrives", valid_580256
  var valid_580257 = query.getOrDefault("fields")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "fields", valid_580257
  var valid_580258 = query.getOrDefault("quotaUser")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "quotaUser", valid_580258
  var valid_580259 = query.getOrDefault("alt")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = newJString("json"))
  if valid_580259 != nil:
    section.add "alt", valid_580259
  var valid_580260 = query.getOrDefault("pinned")
  valid_580260 = validateParameter(valid_580260, JBool, required = false,
                                 default = newJBool(false))
  if valid_580260 != nil:
    section.add "pinned", valid_580260
  var valid_580261 = query.getOrDefault("oauth_token")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "oauth_token", valid_580261
  var valid_580262 = query.getOrDefault("userIp")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "userIp", valid_580262
  var valid_580263 = query.getOrDefault("ocr")
  valid_580263 = validateParameter(valid_580263, JBool, required = false,
                                 default = newJBool(false))
  if valid_580263 != nil:
    section.add "ocr", valid_580263
  var valid_580264 = query.getOrDefault("timedTextLanguage")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "timedTextLanguage", valid_580264
  var valid_580265 = query.getOrDefault("supportsTeamDrives")
  valid_580265 = validateParameter(valid_580265, JBool, required = false,
                                 default = newJBool(false))
  if valid_580265 != nil:
    section.add "supportsTeamDrives", valid_580265
  var valid_580266 = query.getOrDefault("key")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "key", valid_580266
  var valid_580267 = query.getOrDefault("convert")
  valid_580267 = validateParameter(valid_580267, JBool, required = false,
                                 default = newJBool(false))
  if valid_580267 != nil:
    section.add "convert", valid_580267
  var valid_580268 = query.getOrDefault("useContentAsIndexableText")
  valid_580268 = validateParameter(valid_580268, JBool, required = false,
                                 default = newJBool(false))
  if valid_580268 != nil:
    section.add "useContentAsIndexableText", valid_580268
  var valid_580269 = query.getOrDefault("prettyPrint")
  valid_580269 = validateParameter(valid_580269, JBool, required = false,
                                 default = newJBool(true))
  if valid_580269 != nil:
    section.add "prettyPrint", valid_580269
  var valid_580270 = query.getOrDefault("ocrLanguage")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "ocrLanguage", valid_580270
  var valid_580271 = query.getOrDefault("timedTextTrackName")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "timedTextTrackName", valid_580271
  var valid_580272 = query.getOrDefault("visibility")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = newJString("DEFAULT"))
  if valid_580272 != nil:
    section.add "visibility", valid_580272
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

proc call*(call_580274: Call_DriveFilesInsert_580253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Insert a new file.
  ## 
  let valid = call_580274.validator(path, query, header, formData, body)
  let scheme = call_580274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580274.url(scheme.get, call_580274.host, call_580274.base,
                         call_580274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580274, url, valid)

proc call*(call_580275: Call_DriveFilesInsert_580253;
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
  var query_580276 = newJObject()
  var body_580277 = newJObject()
  add(query_580276, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580276, "fields", newJString(fields))
  add(query_580276, "quotaUser", newJString(quotaUser))
  add(query_580276, "alt", newJString(alt))
  add(query_580276, "pinned", newJBool(pinned))
  add(query_580276, "oauth_token", newJString(oauthToken))
  add(query_580276, "userIp", newJString(userIp))
  add(query_580276, "ocr", newJBool(ocr))
  add(query_580276, "timedTextLanguage", newJString(timedTextLanguage))
  add(query_580276, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580276, "key", newJString(key))
  add(query_580276, "convert", newJBool(convert))
  add(query_580276, "useContentAsIndexableText",
      newJBool(useContentAsIndexableText))
  if body != nil:
    body_580277 = body
  add(query_580276, "prettyPrint", newJBool(prettyPrint))
  add(query_580276, "ocrLanguage", newJString(ocrLanguage))
  add(query_580276, "timedTextTrackName", newJString(timedTextTrackName))
  add(query_580276, "visibility", newJString(visibility))
  result = call_580275.call(nil, query_580276, nil, nil, body_580277)

var driveFilesInsert* = Call_DriveFilesInsert_580253(name: "driveFilesInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/files",
    validator: validate_DriveFilesInsert_580254, base: "/drive/v2",
    url: url_DriveFilesInsert_580255, schemes: {Scheme.Https})
type
  Call_DriveFilesList_580226 = ref object of OpenApiRestCall_579424
proc url_DriveFilesList_580228(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveFilesList_580227(path: JsonNode; query: JsonNode;
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
  var valid_580229 = query.getOrDefault("driveId")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "driveId", valid_580229
  var valid_580230 = query.getOrDefault("supportsAllDrives")
  valid_580230 = validateParameter(valid_580230, JBool, required = false,
                                 default = newJBool(false))
  if valid_580230 != nil:
    section.add "supportsAllDrives", valid_580230
  var valid_580231 = query.getOrDefault("fields")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "fields", valid_580231
  var valid_580232 = query.getOrDefault("pageToken")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "pageToken", valid_580232
  var valid_580233 = query.getOrDefault("quotaUser")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "quotaUser", valid_580233
  var valid_580234 = query.getOrDefault("alt")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = newJString("json"))
  if valid_580234 != nil:
    section.add "alt", valid_580234
  var valid_580235 = query.getOrDefault("oauth_token")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "oauth_token", valid_580235
  var valid_580236 = query.getOrDefault("includeItemsFromAllDrives")
  valid_580236 = validateParameter(valid_580236, JBool, required = false,
                                 default = newJBool(false))
  if valid_580236 != nil:
    section.add "includeItemsFromAllDrives", valid_580236
  var valid_580237 = query.getOrDefault("userIp")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "userIp", valid_580237
  var valid_580238 = query.getOrDefault("includeTeamDriveItems")
  valid_580238 = validateParameter(valid_580238, JBool, required = false,
                                 default = newJBool(false))
  if valid_580238 != nil:
    section.add "includeTeamDriveItems", valid_580238
  var valid_580239 = query.getOrDefault("teamDriveId")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "teamDriveId", valid_580239
  var valid_580240 = query.getOrDefault("corpus")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = newJString("DEFAULT"))
  if valid_580240 != nil:
    section.add "corpus", valid_580240
  var valid_580241 = query.getOrDefault("maxResults")
  valid_580241 = validateParameter(valid_580241, JInt, required = false,
                                 default = newJInt(100))
  if valid_580241 != nil:
    section.add "maxResults", valid_580241
  var valid_580242 = query.getOrDefault("orderBy")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "orderBy", valid_580242
  var valid_580243 = query.getOrDefault("q")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "q", valid_580243
  var valid_580244 = query.getOrDefault("supportsTeamDrives")
  valid_580244 = validateParameter(valid_580244, JBool, required = false,
                                 default = newJBool(false))
  if valid_580244 != nil:
    section.add "supportsTeamDrives", valid_580244
  var valid_580245 = query.getOrDefault("key")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "key", valid_580245
  var valid_580246 = query.getOrDefault("spaces")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "spaces", valid_580246
  var valid_580247 = query.getOrDefault("projection")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580247 != nil:
    section.add "projection", valid_580247
  var valid_580248 = query.getOrDefault("corpora")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "corpora", valid_580248
  var valid_580249 = query.getOrDefault("prettyPrint")
  valid_580249 = validateParameter(valid_580249, JBool, required = false,
                                 default = newJBool(true))
  if valid_580249 != nil:
    section.add "prettyPrint", valid_580249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580250: Call_DriveFilesList_580226; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the user's files.
  ## 
  let valid = call_580250.validator(path, query, header, formData, body)
  let scheme = call_580250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580250.url(scheme.get, call_580250.host, call_580250.base,
                         call_580250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580250, url, valid)

proc call*(call_580251: Call_DriveFilesList_580226; driveId: string = "";
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
  var query_580252 = newJObject()
  add(query_580252, "driveId", newJString(driveId))
  add(query_580252, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580252, "fields", newJString(fields))
  add(query_580252, "pageToken", newJString(pageToken))
  add(query_580252, "quotaUser", newJString(quotaUser))
  add(query_580252, "alt", newJString(alt))
  add(query_580252, "oauth_token", newJString(oauthToken))
  add(query_580252, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_580252, "userIp", newJString(userIp))
  add(query_580252, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  add(query_580252, "teamDriveId", newJString(teamDriveId))
  add(query_580252, "corpus", newJString(corpus))
  add(query_580252, "maxResults", newJInt(maxResults))
  add(query_580252, "orderBy", newJString(orderBy))
  add(query_580252, "q", newJString(q))
  add(query_580252, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580252, "key", newJString(key))
  add(query_580252, "spaces", newJString(spaces))
  add(query_580252, "projection", newJString(projection))
  add(query_580252, "corpora", newJString(corpora))
  add(query_580252, "prettyPrint", newJBool(prettyPrint))
  result = call_580251.call(nil, query_580252, nil, nil, nil)

var driveFilesList* = Call_DriveFilesList_580226(name: "driveFilesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/files",
    validator: validate_DriveFilesList_580227, base: "/drive/v2",
    url: url_DriveFilesList_580228, schemes: {Scheme.Https})
type
  Call_DriveFilesGenerateIds_580278 = ref object of OpenApiRestCall_579424
proc url_DriveFilesGenerateIds_580280(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveFilesGenerateIds_580279(path: JsonNode; query: JsonNode;
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
  var valid_580281 = query.getOrDefault("fields")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "fields", valid_580281
  var valid_580282 = query.getOrDefault("quotaUser")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "quotaUser", valid_580282
  var valid_580283 = query.getOrDefault("alt")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = newJString("json"))
  if valid_580283 != nil:
    section.add "alt", valid_580283
  var valid_580284 = query.getOrDefault("oauth_token")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "oauth_token", valid_580284
  var valid_580285 = query.getOrDefault("space")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = newJString("drive"))
  if valid_580285 != nil:
    section.add "space", valid_580285
  var valid_580286 = query.getOrDefault("userIp")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "userIp", valid_580286
  var valid_580287 = query.getOrDefault("maxResults")
  valid_580287 = validateParameter(valid_580287, JInt, required = false,
                                 default = newJInt(10))
  if valid_580287 != nil:
    section.add "maxResults", valid_580287
  var valid_580288 = query.getOrDefault("key")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "key", valid_580288
  var valid_580289 = query.getOrDefault("prettyPrint")
  valid_580289 = validateParameter(valid_580289, JBool, required = false,
                                 default = newJBool(true))
  if valid_580289 != nil:
    section.add "prettyPrint", valid_580289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580290: Call_DriveFilesGenerateIds_580278; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates a set of file IDs which can be provided in insert or copy requests.
  ## 
  let valid = call_580290.validator(path, query, header, formData, body)
  let scheme = call_580290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580290.url(scheme.get, call_580290.host, call_580290.base,
                         call_580290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580290, url, valid)

proc call*(call_580291: Call_DriveFilesGenerateIds_580278; fields: string = "";
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
  var query_580292 = newJObject()
  add(query_580292, "fields", newJString(fields))
  add(query_580292, "quotaUser", newJString(quotaUser))
  add(query_580292, "alt", newJString(alt))
  add(query_580292, "oauth_token", newJString(oauthToken))
  add(query_580292, "space", newJString(space))
  add(query_580292, "userIp", newJString(userIp))
  add(query_580292, "maxResults", newJInt(maxResults))
  add(query_580292, "key", newJString(key))
  add(query_580292, "prettyPrint", newJBool(prettyPrint))
  result = call_580291.call(nil, query_580292, nil, nil, nil)

var driveFilesGenerateIds* = Call_DriveFilesGenerateIds_580278(
    name: "driveFilesGenerateIds", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/generateIds",
    validator: validate_DriveFilesGenerateIds_580279, base: "/drive/v2",
    url: url_DriveFilesGenerateIds_580280, schemes: {Scheme.Https})
type
  Call_DriveFilesEmptyTrash_580293 = ref object of OpenApiRestCall_579424
proc url_DriveFilesEmptyTrash_580295(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveFilesEmptyTrash_580294(path: JsonNode; query: JsonNode;
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
  var valid_580296 = query.getOrDefault("fields")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = nil)
  if valid_580296 != nil:
    section.add "fields", valid_580296
  var valid_580297 = query.getOrDefault("quotaUser")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "quotaUser", valid_580297
  var valid_580298 = query.getOrDefault("alt")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = newJString("json"))
  if valid_580298 != nil:
    section.add "alt", valid_580298
  var valid_580299 = query.getOrDefault("oauth_token")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "oauth_token", valid_580299
  var valid_580300 = query.getOrDefault("userIp")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "userIp", valid_580300
  var valid_580301 = query.getOrDefault("key")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "key", valid_580301
  var valid_580302 = query.getOrDefault("prettyPrint")
  valid_580302 = validateParameter(valid_580302, JBool, required = false,
                                 default = newJBool(true))
  if valid_580302 != nil:
    section.add "prettyPrint", valid_580302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580303: Call_DriveFilesEmptyTrash_580293; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes all of the user's trashed files.
  ## 
  let valid = call_580303.validator(path, query, header, formData, body)
  let scheme = call_580303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580303.url(scheme.get, call_580303.host, call_580303.base,
                         call_580303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580303, url, valid)

proc call*(call_580304: Call_DriveFilesEmptyTrash_580293; fields: string = "";
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
  var query_580305 = newJObject()
  add(query_580305, "fields", newJString(fields))
  add(query_580305, "quotaUser", newJString(quotaUser))
  add(query_580305, "alt", newJString(alt))
  add(query_580305, "oauth_token", newJString(oauthToken))
  add(query_580305, "userIp", newJString(userIp))
  add(query_580305, "key", newJString(key))
  add(query_580305, "prettyPrint", newJBool(prettyPrint))
  result = call_580304.call(nil, query_580305, nil, nil, nil)

var driveFilesEmptyTrash* = Call_DriveFilesEmptyTrash_580293(
    name: "driveFilesEmptyTrash", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/trash",
    validator: validate_DriveFilesEmptyTrash_580294, base: "/drive/v2",
    url: url_DriveFilesEmptyTrash_580295, schemes: {Scheme.Https})
type
  Call_DriveFilesUpdate_580327 = ref object of OpenApiRestCall_579424
proc url_DriveFilesUpdate_580329(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesUpdate_580328(path: JsonNode; query: JsonNode;
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
  var valid_580330 = path.getOrDefault("fileId")
  valid_580330 = validateParameter(valid_580330, JString, required = true,
                                 default = nil)
  if valid_580330 != nil:
    section.add "fileId", valid_580330
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
  var valid_580331 = query.getOrDefault("supportsAllDrives")
  valid_580331 = validateParameter(valid_580331, JBool, required = false,
                                 default = newJBool(false))
  if valid_580331 != nil:
    section.add "supportsAllDrives", valid_580331
  var valid_580332 = query.getOrDefault("fields")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = nil)
  if valid_580332 != nil:
    section.add "fields", valid_580332
  var valid_580333 = query.getOrDefault("quotaUser")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "quotaUser", valid_580333
  var valid_580334 = query.getOrDefault("alt")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = newJString("json"))
  if valid_580334 != nil:
    section.add "alt", valid_580334
  var valid_580335 = query.getOrDefault("setModifiedDate")
  valid_580335 = validateParameter(valid_580335, JBool, required = false,
                                 default = newJBool(false))
  if valid_580335 != nil:
    section.add "setModifiedDate", valid_580335
  var valid_580336 = query.getOrDefault("pinned")
  valid_580336 = validateParameter(valid_580336, JBool, required = false,
                                 default = newJBool(false))
  if valid_580336 != nil:
    section.add "pinned", valid_580336
  var valid_580337 = query.getOrDefault("oauth_token")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "oauth_token", valid_580337
  var valid_580338 = query.getOrDefault("userIp")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "userIp", valid_580338
  var valid_580339 = query.getOrDefault("ocr")
  valid_580339 = validateParameter(valid_580339, JBool, required = false,
                                 default = newJBool(false))
  if valid_580339 != nil:
    section.add "ocr", valid_580339
  var valid_580340 = query.getOrDefault("timedTextLanguage")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = nil)
  if valid_580340 != nil:
    section.add "timedTextLanguage", valid_580340
  var valid_580341 = query.getOrDefault("supportsTeamDrives")
  valid_580341 = validateParameter(valid_580341, JBool, required = false,
                                 default = newJBool(false))
  if valid_580341 != nil:
    section.add "supportsTeamDrives", valid_580341
  var valid_580342 = query.getOrDefault("key")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "key", valid_580342
  var valid_580343 = query.getOrDefault("convert")
  valid_580343 = validateParameter(valid_580343, JBool, required = false,
                                 default = newJBool(false))
  if valid_580343 != nil:
    section.add "convert", valid_580343
  var valid_580344 = query.getOrDefault("modifiedDateBehavior")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = newJString("fromBody"))
  if valid_580344 != nil:
    section.add "modifiedDateBehavior", valid_580344
  var valid_580345 = query.getOrDefault("updateViewedDate")
  valid_580345 = validateParameter(valid_580345, JBool, required = false,
                                 default = newJBool(true))
  if valid_580345 != nil:
    section.add "updateViewedDate", valid_580345
  var valid_580346 = query.getOrDefault("useContentAsIndexableText")
  valid_580346 = validateParameter(valid_580346, JBool, required = false,
                                 default = newJBool(false))
  if valid_580346 != nil:
    section.add "useContentAsIndexableText", valid_580346
  var valid_580347 = query.getOrDefault("addParents")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = nil)
  if valid_580347 != nil:
    section.add "addParents", valid_580347
  var valid_580348 = query.getOrDefault("prettyPrint")
  valid_580348 = validateParameter(valid_580348, JBool, required = false,
                                 default = newJBool(true))
  if valid_580348 != nil:
    section.add "prettyPrint", valid_580348
  var valid_580349 = query.getOrDefault("removeParents")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "removeParents", valid_580349
  var valid_580350 = query.getOrDefault("newRevision")
  valid_580350 = validateParameter(valid_580350, JBool, required = false,
                                 default = newJBool(true))
  if valid_580350 != nil:
    section.add "newRevision", valid_580350
  var valid_580351 = query.getOrDefault("ocrLanguage")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "ocrLanguage", valid_580351
  var valid_580352 = query.getOrDefault("timedTextTrackName")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = nil)
  if valid_580352 != nil:
    section.add "timedTextTrackName", valid_580352
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

proc call*(call_580354: Call_DriveFilesUpdate_580327; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates file metadata and/or content.
  ## 
  let valid = call_580354.validator(path, query, header, formData, body)
  let scheme = call_580354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580354.url(scheme.get, call_580354.host, call_580354.base,
                         call_580354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580354, url, valid)

proc call*(call_580355: Call_DriveFilesUpdate_580327; fileId: string;
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
  var path_580356 = newJObject()
  var query_580357 = newJObject()
  var body_580358 = newJObject()
  add(query_580357, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580357, "fields", newJString(fields))
  add(query_580357, "quotaUser", newJString(quotaUser))
  add(path_580356, "fileId", newJString(fileId))
  add(query_580357, "alt", newJString(alt))
  add(query_580357, "setModifiedDate", newJBool(setModifiedDate))
  add(query_580357, "pinned", newJBool(pinned))
  add(query_580357, "oauth_token", newJString(oauthToken))
  add(query_580357, "userIp", newJString(userIp))
  add(query_580357, "ocr", newJBool(ocr))
  add(query_580357, "timedTextLanguage", newJString(timedTextLanguage))
  add(query_580357, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580357, "key", newJString(key))
  add(query_580357, "convert", newJBool(convert))
  add(query_580357, "modifiedDateBehavior", newJString(modifiedDateBehavior))
  add(query_580357, "updateViewedDate", newJBool(updateViewedDate))
  add(query_580357, "useContentAsIndexableText",
      newJBool(useContentAsIndexableText))
  add(query_580357, "addParents", newJString(addParents))
  add(query_580357, "prettyPrint", newJBool(prettyPrint))
  if body != nil:
    body_580358 = body
  add(query_580357, "removeParents", newJString(removeParents))
  add(query_580357, "newRevision", newJBool(newRevision))
  add(query_580357, "ocrLanguage", newJString(ocrLanguage))
  add(query_580357, "timedTextTrackName", newJString(timedTextTrackName))
  result = call_580355.call(path_580356, query_580357, nil, nil, body_580358)

var driveFilesUpdate* = Call_DriveFilesUpdate_580327(name: "driveFilesUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/files/{fileId}",
    validator: validate_DriveFilesUpdate_580328, base: "/drive/v2",
    url: url_DriveFilesUpdate_580329, schemes: {Scheme.Https})
type
  Call_DriveFilesGet_580306 = ref object of OpenApiRestCall_579424
proc url_DriveFilesGet_580308(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesGet_580307(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_580309 = path.getOrDefault("fileId")
  valid_580309 = validateParameter(valid_580309, JString, required = true,
                                 default = nil)
  if valid_580309 != nil:
    section.add "fileId", valid_580309
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
  var valid_580310 = query.getOrDefault("supportsAllDrives")
  valid_580310 = validateParameter(valid_580310, JBool, required = false,
                                 default = newJBool(false))
  if valid_580310 != nil:
    section.add "supportsAllDrives", valid_580310
  var valid_580311 = query.getOrDefault("fields")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "fields", valid_580311
  var valid_580312 = query.getOrDefault("quotaUser")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "quotaUser", valid_580312
  var valid_580313 = query.getOrDefault("alt")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = newJString("json"))
  if valid_580313 != nil:
    section.add "alt", valid_580313
  var valid_580314 = query.getOrDefault("acknowledgeAbuse")
  valid_580314 = validateParameter(valid_580314, JBool, required = false,
                                 default = newJBool(false))
  if valid_580314 != nil:
    section.add "acknowledgeAbuse", valid_580314
  var valid_580315 = query.getOrDefault("oauth_token")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "oauth_token", valid_580315
  var valid_580316 = query.getOrDefault("userIp")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "userIp", valid_580316
  var valid_580317 = query.getOrDefault("supportsTeamDrives")
  valid_580317 = validateParameter(valid_580317, JBool, required = false,
                                 default = newJBool(false))
  if valid_580317 != nil:
    section.add "supportsTeamDrives", valid_580317
  var valid_580318 = query.getOrDefault("key")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "key", valid_580318
  var valid_580319 = query.getOrDefault("updateViewedDate")
  valid_580319 = validateParameter(valid_580319, JBool, required = false,
                                 default = newJBool(false))
  if valid_580319 != nil:
    section.add "updateViewedDate", valid_580319
  var valid_580320 = query.getOrDefault("projection")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580320 != nil:
    section.add "projection", valid_580320
  var valid_580321 = query.getOrDefault("revisionId")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "revisionId", valid_580321
  var valid_580322 = query.getOrDefault("prettyPrint")
  valid_580322 = validateParameter(valid_580322, JBool, required = false,
                                 default = newJBool(true))
  if valid_580322 != nil:
    section.add "prettyPrint", valid_580322
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580323: Call_DriveFilesGet_580306; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a file's metadata by ID.
  ## 
  let valid = call_580323.validator(path, query, header, formData, body)
  let scheme = call_580323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580323.url(scheme.get, call_580323.host, call_580323.base,
                         call_580323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580323, url, valid)

proc call*(call_580324: Call_DriveFilesGet_580306; fileId: string;
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
  var path_580325 = newJObject()
  var query_580326 = newJObject()
  add(query_580326, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580326, "fields", newJString(fields))
  add(query_580326, "quotaUser", newJString(quotaUser))
  add(path_580325, "fileId", newJString(fileId))
  add(query_580326, "alt", newJString(alt))
  add(query_580326, "acknowledgeAbuse", newJBool(acknowledgeAbuse))
  add(query_580326, "oauth_token", newJString(oauthToken))
  add(query_580326, "userIp", newJString(userIp))
  add(query_580326, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580326, "key", newJString(key))
  add(query_580326, "updateViewedDate", newJBool(updateViewedDate))
  add(query_580326, "projection", newJString(projection))
  add(query_580326, "revisionId", newJString(revisionId))
  add(query_580326, "prettyPrint", newJBool(prettyPrint))
  result = call_580324.call(path_580325, query_580326, nil, nil, nil)

var driveFilesGet* = Call_DriveFilesGet_580306(name: "driveFilesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/files/{fileId}",
    validator: validate_DriveFilesGet_580307, base: "/drive/v2",
    url: url_DriveFilesGet_580308, schemes: {Scheme.Https})
type
  Call_DriveFilesPatch_580376 = ref object of OpenApiRestCall_579424
proc url_DriveFilesPatch_580378(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesPatch_580377(path: JsonNode; query: JsonNode;
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
  var valid_580379 = path.getOrDefault("fileId")
  valid_580379 = validateParameter(valid_580379, JString, required = true,
                                 default = nil)
  if valid_580379 != nil:
    section.add "fileId", valid_580379
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
  var valid_580380 = query.getOrDefault("supportsAllDrives")
  valid_580380 = validateParameter(valid_580380, JBool, required = false,
                                 default = newJBool(false))
  if valid_580380 != nil:
    section.add "supportsAllDrives", valid_580380
  var valid_580381 = query.getOrDefault("fields")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "fields", valid_580381
  var valid_580382 = query.getOrDefault("quotaUser")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = nil)
  if valid_580382 != nil:
    section.add "quotaUser", valid_580382
  var valid_580383 = query.getOrDefault("alt")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = newJString("json"))
  if valid_580383 != nil:
    section.add "alt", valid_580383
  var valid_580384 = query.getOrDefault("setModifiedDate")
  valid_580384 = validateParameter(valid_580384, JBool, required = false,
                                 default = newJBool(false))
  if valid_580384 != nil:
    section.add "setModifiedDate", valid_580384
  var valid_580385 = query.getOrDefault("pinned")
  valid_580385 = validateParameter(valid_580385, JBool, required = false,
                                 default = newJBool(false))
  if valid_580385 != nil:
    section.add "pinned", valid_580385
  var valid_580386 = query.getOrDefault("oauth_token")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = nil)
  if valid_580386 != nil:
    section.add "oauth_token", valid_580386
  var valid_580387 = query.getOrDefault("userIp")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "userIp", valid_580387
  var valid_580388 = query.getOrDefault("ocr")
  valid_580388 = validateParameter(valid_580388, JBool, required = false,
                                 default = newJBool(false))
  if valid_580388 != nil:
    section.add "ocr", valid_580388
  var valid_580389 = query.getOrDefault("timedTextLanguage")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "timedTextLanguage", valid_580389
  var valid_580390 = query.getOrDefault("supportsTeamDrives")
  valid_580390 = validateParameter(valid_580390, JBool, required = false,
                                 default = newJBool(false))
  if valid_580390 != nil:
    section.add "supportsTeamDrives", valid_580390
  var valid_580391 = query.getOrDefault("key")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "key", valid_580391
  var valid_580392 = query.getOrDefault("convert")
  valid_580392 = validateParameter(valid_580392, JBool, required = false,
                                 default = newJBool(false))
  if valid_580392 != nil:
    section.add "convert", valid_580392
  var valid_580393 = query.getOrDefault("modifiedDateBehavior")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = newJString("fromBody"))
  if valid_580393 != nil:
    section.add "modifiedDateBehavior", valid_580393
  var valid_580394 = query.getOrDefault("updateViewedDate")
  valid_580394 = validateParameter(valid_580394, JBool, required = false,
                                 default = newJBool(true))
  if valid_580394 != nil:
    section.add "updateViewedDate", valid_580394
  var valid_580395 = query.getOrDefault("useContentAsIndexableText")
  valid_580395 = validateParameter(valid_580395, JBool, required = false,
                                 default = newJBool(false))
  if valid_580395 != nil:
    section.add "useContentAsIndexableText", valid_580395
  var valid_580396 = query.getOrDefault("addParents")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = nil)
  if valid_580396 != nil:
    section.add "addParents", valid_580396
  var valid_580397 = query.getOrDefault("prettyPrint")
  valid_580397 = validateParameter(valid_580397, JBool, required = false,
                                 default = newJBool(true))
  if valid_580397 != nil:
    section.add "prettyPrint", valid_580397
  var valid_580398 = query.getOrDefault("removeParents")
  valid_580398 = validateParameter(valid_580398, JString, required = false,
                                 default = nil)
  if valid_580398 != nil:
    section.add "removeParents", valid_580398
  var valid_580399 = query.getOrDefault("newRevision")
  valid_580399 = validateParameter(valid_580399, JBool, required = false,
                                 default = newJBool(true))
  if valid_580399 != nil:
    section.add "newRevision", valid_580399
  var valid_580400 = query.getOrDefault("ocrLanguage")
  valid_580400 = validateParameter(valid_580400, JString, required = false,
                                 default = nil)
  if valid_580400 != nil:
    section.add "ocrLanguage", valid_580400
  var valid_580401 = query.getOrDefault("timedTextTrackName")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "timedTextTrackName", valid_580401
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

proc call*(call_580403: Call_DriveFilesPatch_580376; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates file metadata and/or content. This method supports patch semantics.
  ## 
  let valid = call_580403.validator(path, query, header, formData, body)
  let scheme = call_580403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580403.url(scheme.get, call_580403.host, call_580403.base,
                         call_580403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580403, url, valid)

proc call*(call_580404: Call_DriveFilesPatch_580376; fileId: string;
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
  var path_580405 = newJObject()
  var query_580406 = newJObject()
  var body_580407 = newJObject()
  add(query_580406, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580406, "fields", newJString(fields))
  add(query_580406, "quotaUser", newJString(quotaUser))
  add(path_580405, "fileId", newJString(fileId))
  add(query_580406, "alt", newJString(alt))
  add(query_580406, "setModifiedDate", newJBool(setModifiedDate))
  add(query_580406, "pinned", newJBool(pinned))
  add(query_580406, "oauth_token", newJString(oauthToken))
  add(query_580406, "userIp", newJString(userIp))
  add(query_580406, "ocr", newJBool(ocr))
  add(query_580406, "timedTextLanguage", newJString(timedTextLanguage))
  add(query_580406, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580406, "key", newJString(key))
  add(query_580406, "convert", newJBool(convert))
  add(query_580406, "modifiedDateBehavior", newJString(modifiedDateBehavior))
  add(query_580406, "updateViewedDate", newJBool(updateViewedDate))
  add(query_580406, "useContentAsIndexableText",
      newJBool(useContentAsIndexableText))
  add(query_580406, "addParents", newJString(addParents))
  add(query_580406, "prettyPrint", newJBool(prettyPrint))
  if body != nil:
    body_580407 = body
  add(query_580406, "removeParents", newJString(removeParents))
  add(query_580406, "newRevision", newJBool(newRevision))
  add(query_580406, "ocrLanguage", newJString(ocrLanguage))
  add(query_580406, "timedTextTrackName", newJString(timedTextTrackName))
  result = call_580404.call(path_580405, query_580406, nil, nil, body_580407)

var driveFilesPatch* = Call_DriveFilesPatch_580376(name: "driveFilesPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/files/{fileId}", validator: validate_DriveFilesPatch_580377,
    base: "/drive/v2", url: url_DriveFilesPatch_580378, schemes: {Scheme.Https})
type
  Call_DriveFilesDelete_580359 = ref object of OpenApiRestCall_579424
proc url_DriveFilesDelete_580361(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesDelete_580360(path: JsonNode; query: JsonNode;
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
  var valid_580362 = path.getOrDefault("fileId")
  valid_580362 = validateParameter(valid_580362, JString, required = true,
                                 default = nil)
  if valid_580362 != nil:
    section.add "fileId", valid_580362
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
  var valid_580363 = query.getOrDefault("supportsAllDrives")
  valid_580363 = validateParameter(valid_580363, JBool, required = false,
                                 default = newJBool(false))
  if valid_580363 != nil:
    section.add "supportsAllDrives", valid_580363
  var valid_580364 = query.getOrDefault("fields")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "fields", valid_580364
  var valid_580365 = query.getOrDefault("quotaUser")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "quotaUser", valid_580365
  var valid_580366 = query.getOrDefault("alt")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = newJString("json"))
  if valid_580366 != nil:
    section.add "alt", valid_580366
  var valid_580367 = query.getOrDefault("oauth_token")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "oauth_token", valid_580367
  var valid_580368 = query.getOrDefault("userIp")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "userIp", valid_580368
  var valid_580369 = query.getOrDefault("supportsTeamDrives")
  valid_580369 = validateParameter(valid_580369, JBool, required = false,
                                 default = newJBool(false))
  if valid_580369 != nil:
    section.add "supportsTeamDrives", valid_580369
  var valid_580370 = query.getOrDefault("key")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "key", valid_580370
  var valid_580371 = query.getOrDefault("prettyPrint")
  valid_580371 = validateParameter(valid_580371, JBool, required = false,
                                 default = newJBool(true))
  if valid_580371 != nil:
    section.add "prettyPrint", valid_580371
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580372: Call_DriveFilesDelete_580359; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a file by ID. Skips the trash. The currently authenticated user must own the file or be an organizer on the parent for shared drive files.
  ## 
  let valid = call_580372.validator(path, query, header, formData, body)
  let scheme = call_580372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580372.url(scheme.get, call_580372.host, call_580372.base,
                         call_580372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580372, url, valid)

proc call*(call_580373: Call_DriveFilesDelete_580359; fileId: string;
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
  var path_580374 = newJObject()
  var query_580375 = newJObject()
  add(query_580375, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580375, "fields", newJString(fields))
  add(query_580375, "quotaUser", newJString(quotaUser))
  add(path_580374, "fileId", newJString(fileId))
  add(query_580375, "alt", newJString(alt))
  add(query_580375, "oauth_token", newJString(oauthToken))
  add(query_580375, "userIp", newJString(userIp))
  add(query_580375, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580375, "key", newJString(key))
  add(query_580375, "prettyPrint", newJBool(prettyPrint))
  result = call_580373.call(path_580374, query_580375, nil, nil, nil)

var driveFilesDelete* = Call_DriveFilesDelete_580359(name: "driveFilesDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/files/{fileId}", validator: validate_DriveFilesDelete_580360,
    base: "/drive/v2", url: url_DriveFilesDelete_580361, schemes: {Scheme.Https})
type
  Call_DriveCommentsInsert_580427 = ref object of OpenApiRestCall_579424
proc url_DriveCommentsInsert_580429(protocol: Scheme; host: string; base: string;
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

proc validate_DriveCommentsInsert_580428(path: JsonNode; query: JsonNode;
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
  var valid_580430 = path.getOrDefault("fileId")
  valid_580430 = validateParameter(valid_580430, JString, required = true,
                                 default = nil)
  if valid_580430 != nil:
    section.add "fileId", valid_580430
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
  var valid_580431 = query.getOrDefault("fields")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "fields", valid_580431
  var valid_580432 = query.getOrDefault("quotaUser")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "quotaUser", valid_580432
  var valid_580433 = query.getOrDefault("alt")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = newJString("json"))
  if valid_580433 != nil:
    section.add "alt", valid_580433
  var valid_580434 = query.getOrDefault("oauth_token")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = nil)
  if valid_580434 != nil:
    section.add "oauth_token", valid_580434
  var valid_580435 = query.getOrDefault("userIp")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "userIp", valid_580435
  var valid_580436 = query.getOrDefault("key")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "key", valid_580436
  var valid_580437 = query.getOrDefault("prettyPrint")
  valid_580437 = validateParameter(valid_580437, JBool, required = false,
                                 default = newJBool(true))
  if valid_580437 != nil:
    section.add "prettyPrint", valid_580437
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

proc call*(call_580439: Call_DriveCommentsInsert_580427; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new comment on the given file.
  ## 
  let valid = call_580439.validator(path, query, header, formData, body)
  let scheme = call_580439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580439.url(scheme.get, call_580439.host, call_580439.base,
                         call_580439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580439, url, valid)

proc call*(call_580440: Call_DriveCommentsInsert_580427; fileId: string;
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
  var path_580441 = newJObject()
  var query_580442 = newJObject()
  var body_580443 = newJObject()
  add(query_580442, "fields", newJString(fields))
  add(query_580442, "quotaUser", newJString(quotaUser))
  add(path_580441, "fileId", newJString(fileId))
  add(query_580442, "alt", newJString(alt))
  add(query_580442, "oauth_token", newJString(oauthToken))
  add(query_580442, "userIp", newJString(userIp))
  add(query_580442, "key", newJString(key))
  if body != nil:
    body_580443 = body
  add(query_580442, "prettyPrint", newJBool(prettyPrint))
  result = call_580440.call(path_580441, query_580442, nil, nil, body_580443)

var driveCommentsInsert* = Call_DriveCommentsInsert_580427(
    name: "driveCommentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/comments",
    validator: validate_DriveCommentsInsert_580428, base: "/drive/v2",
    url: url_DriveCommentsInsert_580429, schemes: {Scheme.Https})
type
  Call_DriveCommentsList_580408 = ref object of OpenApiRestCall_579424
proc url_DriveCommentsList_580410(protocol: Scheme; host: string; base: string;
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

proc validate_DriveCommentsList_580409(path: JsonNode; query: JsonNode;
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
  var valid_580411 = path.getOrDefault("fileId")
  valid_580411 = validateParameter(valid_580411, JString, required = true,
                                 default = nil)
  if valid_580411 != nil:
    section.add "fileId", valid_580411
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
  var valid_580412 = query.getOrDefault("fields")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = nil)
  if valid_580412 != nil:
    section.add "fields", valid_580412
  var valid_580413 = query.getOrDefault("pageToken")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = nil)
  if valid_580413 != nil:
    section.add "pageToken", valid_580413
  var valid_580414 = query.getOrDefault("quotaUser")
  valid_580414 = validateParameter(valid_580414, JString, required = false,
                                 default = nil)
  if valid_580414 != nil:
    section.add "quotaUser", valid_580414
  var valid_580415 = query.getOrDefault("alt")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = newJString("json"))
  if valid_580415 != nil:
    section.add "alt", valid_580415
  var valid_580416 = query.getOrDefault("oauth_token")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = nil)
  if valid_580416 != nil:
    section.add "oauth_token", valid_580416
  var valid_580417 = query.getOrDefault("userIp")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "userIp", valid_580417
  var valid_580418 = query.getOrDefault("maxResults")
  valid_580418 = validateParameter(valid_580418, JInt, required = false,
                                 default = newJInt(20))
  if valid_580418 != nil:
    section.add "maxResults", valid_580418
  var valid_580419 = query.getOrDefault("updatedMin")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = nil)
  if valid_580419 != nil:
    section.add "updatedMin", valid_580419
  var valid_580420 = query.getOrDefault("key")
  valid_580420 = validateParameter(valid_580420, JString, required = false,
                                 default = nil)
  if valid_580420 != nil:
    section.add "key", valid_580420
  var valid_580421 = query.getOrDefault("includeDeleted")
  valid_580421 = validateParameter(valid_580421, JBool, required = false,
                                 default = newJBool(false))
  if valid_580421 != nil:
    section.add "includeDeleted", valid_580421
  var valid_580422 = query.getOrDefault("prettyPrint")
  valid_580422 = validateParameter(valid_580422, JBool, required = false,
                                 default = newJBool(true))
  if valid_580422 != nil:
    section.add "prettyPrint", valid_580422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580423: Call_DriveCommentsList_580408; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's comments.
  ## 
  let valid = call_580423.validator(path, query, header, formData, body)
  let scheme = call_580423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580423.url(scheme.get, call_580423.host, call_580423.base,
                         call_580423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580423, url, valid)

proc call*(call_580424: Call_DriveCommentsList_580408; fileId: string;
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
  var path_580425 = newJObject()
  var query_580426 = newJObject()
  add(query_580426, "fields", newJString(fields))
  add(query_580426, "pageToken", newJString(pageToken))
  add(query_580426, "quotaUser", newJString(quotaUser))
  add(path_580425, "fileId", newJString(fileId))
  add(query_580426, "alt", newJString(alt))
  add(query_580426, "oauth_token", newJString(oauthToken))
  add(query_580426, "userIp", newJString(userIp))
  add(query_580426, "maxResults", newJInt(maxResults))
  add(query_580426, "updatedMin", newJString(updatedMin))
  add(query_580426, "key", newJString(key))
  add(query_580426, "includeDeleted", newJBool(includeDeleted))
  add(query_580426, "prettyPrint", newJBool(prettyPrint))
  result = call_580424.call(path_580425, query_580426, nil, nil, nil)

var driveCommentsList* = Call_DriveCommentsList_580408(name: "driveCommentsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments", validator: validate_DriveCommentsList_580409,
    base: "/drive/v2", url: url_DriveCommentsList_580410, schemes: {Scheme.Https})
type
  Call_DriveCommentsUpdate_580461 = ref object of OpenApiRestCall_579424
proc url_DriveCommentsUpdate_580463(protocol: Scheme; host: string; base: string;
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

proc validate_DriveCommentsUpdate_580462(path: JsonNode; query: JsonNode;
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
  var valid_580464 = path.getOrDefault("fileId")
  valid_580464 = validateParameter(valid_580464, JString, required = true,
                                 default = nil)
  if valid_580464 != nil:
    section.add "fileId", valid_580464
  var valid_580465 = path.getOrDefault("commentId")
  valid_580465 = validateParameter(valid_580465, JString, required = true,
                                 default = nil)
  if valid_580465 != nil:
    section.add "commentId", valid_580465
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
  var valid_580466 = query.getOrDefault("fields")
  valid_580466 = validateParameter(valid_580466, JString, required = false,
                                 default = nil)
  if valid_580466 != nil:
    section.add "fields", valid_580466
  var valid_580467 = query.getOrDefault("quotaUser")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = nil)
  if valid_580467 != nil:
    section.add "quotaUser", valid_580467
  var valid_580468 = query.getOrDefault("alt")
  valid_580468 = validateParameter(valid_580468, JString, required = false,
                                 default = newJString("json"))
  if valid_580468 != nil:
    section.add "alt", valid_580468
  var valid_580469 = query.getOrDefault("oauth_token")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = nil)
  if valid_580469 != nil:
    section.add "oauth_token", valid_580469
  var valid_580470 = query.getOrDefault("userIp")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = nil)
  if valid_580470 != nil:
    section.add "userIp", valid_580470
  var valid_580471 = query.getOrDefault("key")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = nil)
  if valid_580471 != nil:
    section.add "key", valid_580471
  var valid_580472 = query.getOrDefault("prettyPrint")
  valid_580472 = validateParameter(valid_580472, JBool, required = false,
                                 default = newJBool(true))
  if valid_580472 != nil:
    section.add "prettyPrint", valid_580472
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

proc call*(call_580474: Call_DriveCommentsUpdate_580461; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing comment.
  ## 
  let valid = call_580474.validator(path, query, header, formData, body)
  let scheme = call_580474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580474.url(scheme.get, call_580474.host, call_580474.base,
                         call_580474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580474, url, valid)

proc call*(call_580475: Call_DriveCommentsUpdate_580461; fileId: string;
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
  var path_580476 = newJObject()
  var query_580477 = newJObject()
  var body_580478 = newJObject()
  add(query_580477, "fields", newJString(fields))
  add(query_580477, "quotaUser", newJString(quotaUser))
  add(path_580476, "fileId", newJString(fileId))
  add(query_580477, "alt", newJString(alt))
  add(query_580477, "oauth_token", newJString(oauthToken))
  add(query_580477, "userIp", newJString(userIp))
  add(query_580477, "key", newJString(key))
  add(path_580476, "commentId", newJString(commentId))
  if body != nil:
    body_580478 = body
  add(query_580477, "prettyPrint", newJBool(prettyPrint))
  result = call_580475.call(path_580476, query_580477, nil, nil, body_580478)

var driveCommentsUpdate* = Call_DriveCommentsUpdate_580461(
    name: "driveCommentsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsUpdate_580462, base: "/drive/v2",
    url: url_DriveCommentsUpdate_580463, schemes: {Scheme.Https})
type
  Call_DriveCommentsGet_580444 = ref object of OpenApiRestCall_579424
proc url_DriveCommentsGet_580446(protocol: Scheme; host: string; base: string;
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

proc validate_DriveCommentsGet_580445(path: JsonNode; query: JsonNode;
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
  var valid_580447 = path.getOrDefault("fileId")
  valid_580447 = validateParameter(valid_580447, JString, required = true,
                                 default = nil)
  if valid_580447 != nil:
    section.add "fileId", valid_580447
  var valid_580448 = path.getOrDefault("commentId")
  valid_580448 = validateParameter(valid_580448, JString, required = true,
                                 default = nil)
  if valid_580448 != nil:
    section.add "commentId", valid_580448
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
  var valid_580449 = query.getOrDefault("fields")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "fields", valid_580449
  var valid_580450 = query.getOrDefault("quotaUser")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = nil)
  if valid_580450 != nil:
    section.add "quotaUser", valid_580450
  var valid_580451 = query.getOrDefault("alt")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = newJString("json"))
  if valid_580451 != nil:
    section.add "alt", valid_580451
  var valid_580452 = query.getOrDefault("oauth_token")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "oauth_token", valid_580452
  var valid_580453 = query.getOrDefault("userIp")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "userIp", valid_580453
  var valid_580454 = query.getOrDefault("key")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = nil)
  if valid_580454 != nil:
    section.add "key", valid_580454
  var valid_580455 = query.getOrDefault("includeDeleted")
  valid_580455 = validateParameter(valid_580455, JBool, required = false,
                                 default = newJBool(false))
  if valid_580455 != nil:
    section.add "includeDeleted", valid_580455
  var valid_580456 = query.getOrDefault("prettyPrint")
  valid_580456 = validateParameter(valid_580456, JBool, required = false,
                                 default = newJBool(true))
  if valid_580456 != nil:
    section.add "prettyPrint", valid_580456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580457: Call_DriveCommentsGet_580444; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a comment by ID.
  ## 
  let valid = call_580457.validator(path, query, header, formData, body)
  let scheme = call_580457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580457.url(scheme.get, call_580457.host, call_580457.base,
                         call_580457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580457, url, valid)

proc call*(call_580458: Call_DriveCommentsGet_580444; fileId: string;
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
  var path_580459 = newJObject()
  var query_580460 = newJObject()
  add(query_580460, "fields", newJString(fields))
  add(query_580460, "quotaUser", newJString(quotaUser))
  add(path_580459, "fileId", newJString(fileId))
  add(query_580460, "alt", newJString(alt))
  add(query_580460, "oauth_token", newJString(oauthToken))
  add(query_580460, "userIp", newJString(userIp))
  add(query_580460, "key", newJString(key))
  add(path_580459, "commentId", newJString(commentId))
  add(query_580460, "includeDeleted", newJBool(includeDeleted))
  add(query_580460, "prettyPrint", newJBool(prettyPrint))
  result = call_580458.call(path_580459, query_580460, nil, nil, nil)

var driveCommentsGet* = Call_DriveCommentsGet_580444(name: "driveCommentsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsGet_580445, base: "/drive/v2",
    url: url_DriveCommentsGet_580446, schemes: {Scheme.Https})
type
  Call_DriveCommentsPatch_580495 = ref object of OpenApiRestCall_579424
proc url_DriveCommentsPatch_580497(protocol: Scheme; host: string; base: string;
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

proc validate_DriveCommentsPatch_580496(path: JsonNode; query: JsonNode;
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
  var valid_580498 = path.getOrDefault("fileId")
  valid_580498 = validateParameter(valid_580498, JString, required = true,
                                 default = nil)
  if valid_580498 != nil:
    section.add "fileId", valid_580498
  var valid_580499 = path.getOrDefault("commentId")
  valid_580499 = validateParameter(valid_580499, JString, required = true,
                                 default = nil)
  if valid_580499 != nil:
    section.add "commentId", valid_580499
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
  var valid_580500 = query.getOrDefault("fields")
  valid_580500 = validateParameter(valid_580500, JString, required = false,
                                 default = nil)
  if valid_580500 != nil:
    section.add "fields", valid_580500
  var valid_580501 = query.getOrDefault("quotaUser")
  valid_580501 = validateParameter(valid_580501, JString, required = false,
                                 default = nil)
  if valid_580501 != nil:
    section.add "quotaUser", valid_580501
  var valid_580502 = query.getOrDefault("alt")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = newJString("json"))
  if valid_580502 != nil:
    section.add "alt", valid_580502
  var valid_580503 = query.getOrDefault("oauth_token")
  valid_580503 = validateParameter(valid_580503, JString, required = false,
                                 default = nil)
  if valid_580503 != nil:
    section.add "oauth_token", valid_580503
  var valid_580504 = query.getOrDefault("userIp")
  valid_580504 = validateParameter(valid_580504, JString, required = false,
                                 default = nil)
  if valid_580504 != nil:
    section.add "userIp", valid_580504
  var valid_580505 = query.getOrDefault("key")
  valid_580505 = validateParameter(valid_580505, JString, required = false,
                                 default = nil)
  if valid_580505 != nil:
    section.add "key", valid_580505
  var valid_580506 = query.getOrDefault("prettyPrint")
  valid_580506 = validateParameter(valid_580506, JBool, required = false,
                                 default = newJBool(true))
  if valid_580506 != nil:
    section.add "prettyPrint", valid_580506
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

proc call*(call_580508: Call_DriveCommentsPatch_580495; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing comment. This method supports patch semantics.
  ## 
  let valid = call_580508.validator(path, query, header, formData, body)
  let scheme = call_580508.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580508.url(scheme.get, call_580508.host, call_580508.base,
                         call_580508.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580508, url, valid)

proc call*(call_580509: Call_DriveCommentsPatch_580495; fileId: string;
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
  var path_580510 = newJObject()
  var query_580511 = newJObject()
  var body_580512 = newJObject()
  add(query_580511, "fields", newJString(fields))
  add(query_580511, "quotaUser", newJString(quotaUser))
  add(path_580510, "fileId", newJString(fileId))
  add(query_580511, "alt", newJString(alt))
  add(query_580511, "oauth_token", newJString(oauthToken))
  add(query_580511, "userIp", newJString(userIp))
  add(query_580511, "key", newJString(key))
  add(path_580510, "commentId", newJString(commentId))
  if body != nil:
    body_580512 = body
  add(query_580511, "prettyPrint", newJBool(prettyPrint))
  result = call_580509.call(path_580510, query_580511, nil, nil, body_580512)

var driveCommentsPatch* = Call_DriveCommentsPatch_580495(
    name: "driveCommentsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsPatch_580496, base: "/drive/v2",
    url: url_DriveCommentsPatch_580497, schemes: {Scheme.Https})
type
  Call_DriveCommentsDelete_580479 = ref object of OpenApiRestCall_579424
proc url_DriveCommentsDelete_580481(protocol: Scheme; host: string; base: string;
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

proc validate_DriveCommentsDelete_580480(path: JsonNode; query: JsonNode;
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
  var valid_580482 = path.getOrDefault("fileId")
  valid_580482 = validateParameter(valid_580482, JString, required = true,
                                 default = nil)
  if valid_580482 != nil:
    section.add "fileId", valid_580482
  var valid_580483 = path.getOrDefault("commentId")
  valid_580483 = validateParameter(valid_580483, JString, required = true,
                                 default = nil)
  if valid_580483 != nil:
    section.add "commentId", valid_580483
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
  var valid_580484 = query.getOrDefault("fields")
  valid_580484 = validateParameter(valid_580484, JString, required = false,
                                 default = nil)
  if valid_580484 != nil:
    section.add "fields", valid_580484
  var valid_580485 = query.getOrDefault("quotaUser")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = nil)
  if valid_580485 != nil:
    section.add "quotaUser", valid_580485
  var valid_580486 = query.getOrDefault("alt")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = newJString("json"))
  if valid_580486 != nil:
    section.add "alt", valid_580486
  var valid_580487 = query.getOrDefault("oauth_token")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = nil)
  if valid_580487 != nil:
    section.add "oauth_token", valid_580487
  var valid_580488 = query.getOrDefault("userIp")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "userIp", valid_580488
  var valid_580489 = query.getOrDefault("key")
  valid_580489 = validateParameter(valid_580489, JString, required = false,
                                 default = nil)
  if valid_580489 != nil:
    section.add "key", valid_580489
  var valid_580490 = query.getOrDefault("prettyPrint")
  valid_580490 = validateParameter(valid_580490, JBool, required = false,
                                 default = newJBool(true))
  if valid_580490 != nil:
    section.add "prettyPrint", valid_580490
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580491: Call_DriveCommentsDelete_580479; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a comment.
  ## 
  let valid = call_580491.validator(path, query, header, formData, body)
  let scheme = call_580491.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580491.url(scheme.get, call_580491.host, call_580491.base,
                         call_580491.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580491, url, valid)

proc call*(call_580492: Call_DriveCommentsDelete_580479; fileId: string;
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
  var path_580493 = newJObject()
  var query_580494 = newJObject()
  add(query_580494, "fields", newJString(fields))
  add(query_580494, "quotaUser", newJString(quotaUser))
  add(path_580493, "fileId", newJString(fileId))
  add(query_580494, "alt", newJString(alt))
  add(query_580494, "oauth_token", newJString(oauthToken))
  add(query_580494, "userIp", newJString(userIp))
  add(query_580494, "key", newJString(key))
  add(path_580493, "commentId", newJString(commentId))
  add(query_580494, "prettyPrint", newJBool(prettyPrint))
  result = call_580492.call(path_580493, query_580494, nil, nil, nil)

var driveCommentsDelete* = Call_DriveCommentsDelete_580479(
    name: "driveCommentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsDelete_580480, base: "/drive/v2",
    url: url_DriveCommentsDelete_580481, schemes: {Scheme.Https})
type
  Call_DriveRepliesInsert_580532 = ref object of OpenApiRestCall_579424
proc url_DriveRepliesInsert_580534(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRepliesInsert_580533(path: JsonNode; query: JsonNode;
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
  var valid_580535 = path.getOrDefault("fileId")
  valid_580535 = validateParameter(valid_580535, JString, required = true,
                                 default = nil)
  if valid_580535 != nil:
    section.add "fileId", valid_580535
  var valid_580536 = path.getOrDefault("commentId")
  valid_580536 = validateParameter(valid_580536, JString, required = true,
                                 default = nil)
  if valid_580536 != nil:
    section.add "commentId", valid_580536
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
  var valid_580537 = query.getOrDefault("fields")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = nil)
  if valid_580537 != nil:
    section.add "fields", valid_580537
  var valid_580538 = query.getOrDefault("quotaUser")
  valid_580538 = validateParameter(valid_580538, JString, required = false,
                                 default = nil)
  if valid_580538 != nil:
    section.add "quotaUser", valid_580538
  var valid_580539 = query.getOrDefault("alt")
  valid_580539 = validateParameter(valid_580539, JString, required = false,
                                 default = newJString("json"))
  if valid_580539 != nil:
    section.add "alt", valid_580539
  var valid_580540 = query.getOrDefault("oauth_token")
  valid_580540 = validateParameter(valid_580540, JString, required = false,
                                 default = nil)
  if valid_580540 != nil:
    section.add "oauth_token", valid_580540
  var valid_580541 = query.getOrDefault("userIp")
  valid_580541 = validateParameter(valid_580541, JString, required = false,
                                 default = nil)
  if valid_580541 != nil:
    section.add "userIp", valid_580541
  var valid_580542 = query.getOrDefault("key")
  valid_580542 = validateParameter(valid_580542, JString, required = false,
                                 default = nil)
  if valid_580542 != nil:
    section.add "key", valid_580542
  var valid_580543 = query.getOrDefault("prettyPrint")
  valid_580543 = validateParameter(valid_580543, JBool, required = false,
                                 default = newJBool(true))
  if valid_580543 != nil:
    section.add "prettyPrint", valid_580543
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

proc call*(call_580545: Call_DriveRepliesInsert_580532; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new reply to the given comment.
  ## 
  let valid = call_580545.validator(path, query, header, formData, body)
  let scheme = call_580545.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580545.url(scheme.get, call_580545.host, call_580545.base,
                         call_580545.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580545, url, valid)

proc call*(call_580546: Call_DriveRepliesInsert_580532; fileId: string;
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
  var path_580547 = newJObject()
  var query_580548 = newJObject()
  var body_580549 = newJObject()
  add(query_580548, "fields", newJString(fields))
  add(query_580548, "quotaUser", newJString(quotaUser))
  add(path_580547, "fileId", newJString(fileId))
  add(query_580548, "alt", newJString(alt))
  add(query_580548, "oauth_token", newJString(oauthToken))
  add(query_580548, "userIp", newJString(userIp))
  add(query_580548, "key", newJString(key))
  add(path_580547, "commentId", newJString(commentId))
  if body != nil:
    body_580549 = body
  add(query_580548, "prettyPrint", newJBool(prettyPrint))
  result = call_580546.call(path_580547, query_580548, nil, nil, body_580549)

var driveRepliesInsert* = Call_DriveRepliesInsert_580532(
    name: "driveRepliesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies",
    validator: validate_DriveRepliesInsert_580533, base: "/drive/v2",
    url: url_DriveRepliesInsert_580534, schemes: {Scheme.Https})
type
  Call_DriveRepliesList_580513 = ref object of OpenApiRestCall_579424
proc url_DriveRepliesList_580515(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRepliesList_580514(path: JsonNode; query: JsonNode;
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
  var valid_580516 = path.getOrDefault("fileId")
  valid_580516 = validateParameter(valid_580516, JString, required = true,
                                 default = nil)
  if valid_580516 != nil:
    section.add "fileId", valid_580516
  var valid_580517 = path.getOrDefault("commentId")
  valid_580517 = validateParameter(valid_580517, JString, required = true,
                                 default = nil)
  if valid_580517 != nil:
    section.add "commentId", valid_580517
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
  var valid_580518 = query.getOrDefault("fields")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = nil)
  if valid_580518 != nil:
    section.add "fields", valid_580518
  var valid_580519 = query.getOrDefault("pageToken")
  valid_580519 = validateParameter(valid_580519, JString, required = false,
                                 default = nil)
  if valid_580519 != nil:
    section.add "pageToken", valid_580519
  var valid_580520 = query.getOrDefault("quotaUser")
  valid_580520 = validateParameter(valid_580520, JString, required = false,
                                 default = nil)
  if valid_580520 != nil:
    section.add "quotaUser", valid_580520
  var valid_580521 = query.getOrDefault("alt")
  valid_580521 = validateParameter(valid_580521, JString, required = false,
                                 default = newJString("json"))
  if valid_580521 != nil:
    section.add "alt", valid_580521
  var valid_580522 = query.getOrDefault("oauth_token")
  valid_580522 = validateParameter(valid_580522, JString, required = false,
                                 default = nil)
  if valid_580522 != nil:
    section.add "oauth_token", valid_580522
  var valid_580523 = query.getOrDefault("userIp")
  valid_580523 = validateParameter(valid_580523, JString, required = false,
                                 default = nil)
  if valid_580523 != nil:
    section.add "userIp", valid_580523
  var valid_580524 = query.getOrDefault("maxResults")
  valid_580524 = validateParameter(valid_580524, JInt, required = false,
                                 default = newJInt(20))
  if valid_580524 != nil:
    section.add "maxResults", valid_580524
  var valid_580525 = query.getOrDefault("key")
  valid_580525 = validateParameter(valid_580525, JString, required = false,
                                 default = nil)
  if valid_580525 != nil:
    section.add "key", valid_580525
  var valid_580526 = query.getOrDefault("includeDeleted")
  valid_580526 = validateParameter(valid_580526, JBool, required = false,
                                 default = newJBool(false))
  if valid_580526 != nil:
    section.add "includeDeleted", valid_580526
  var valid_580527 = query.getOrDefault("prettyPrint")
  valid_580527 = validateParameter(valid_580527, JBool, required = false,
                                 default = newJBool(true))
  if valid_580527 != nil:
    section.add "prettyPrint", valid_580527
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580528: Call_DriveRepliesList_580513; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the replies to a comment.
  ## 
  let valid = call_580528.validator(path, query, header, formData, body)
  let scheme = call_580528.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580528.url(scheme.get, call_580528.host, call_580528.base,
                         call_580528.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580528, url, valid)

proc call*(call_580529: Call_DriveRepliesList_580513; fileId: string;
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
  var path_580530 = newJObject()
  var query_580531 = newJObject()
  add(query_580531, "fields", newJString(fields))
  add(query_580531, "pageToken", newJString(pageToken))
  add(query_580531, "quotaUser", newJString(quotaUser))
  add(path_580530, "fileId", newJString(fileId))
  add(query_580531, "alt", newJString(alt))
  add(query_580531, "oauth_token", newJString(oauthToken))
  add(query_580531, "userIp", newJString(userIp))
  add(query_580531, "maxResults", newJInt(maxResults))
  add(query_580531, "key", newJString(key))
  add(path_580530, "commentId", newJString(commentId))
  add(query_580531, "includeDeleted", newJBool(includeDeleted))
  add(query_580531, "prettyPrint", newJBool(prettyPrint))
  result = call_580529.call(path_580530, query_580531, nil, nil, nil)

var driveRepliesList* = Call_DriveRepliesList_580513(name: "driveRepliesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies",
    validator: validate_DriveRepliesList_580514, base: "/drive/v2",
    url: url_DriveRepliesList_580515, schemes: {Scheme.Https})
type
  Call_DriveRepliesUpdate_580568 = ref object of OpenApiRestCall_579424
proc url_DriveRepliesUpdate_580570(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRepliesUpdate_580569(path: JsonNode; query: JsonNode;
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
  var valid_580571 = path.getOrDefault("fileId")
  valid_580571 = validateParameter(valid_580571, JString, required = true,
                                 default = nil)
  if valid_580571 != nil:
    section.add "fileId", valid_580571
  var valid_580572 = path.getOrDefault("replyId")
  valid_580572 = validateParameter(valid_580572, JString, required = true,
                                 default = nil)
  if valid_580572 != nil:
    section.add "replyId", valid_580572
  var valid_580573 = path.getOrDefault("commentId")
  valid_580573 = validateParameter(valid_580573, JString, required = true,
                                 default = nil)
  if valid_580573 != nil:
    section.add "commentId", valid_580573
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
  var valid_580574 = query.getOrDefault("fields")
  valid_580574 = validateParameter(valid_580574, JString, required = false,
                                 default = nil)
  if valid_580574 != nil:
    section.add "fields", valid_580574
  var valid_580575 = query.getOrDefault("quotaUser")
  valid_580575 = validateParameter(valid_580575, JString, required = false,
                                 default = nil)
  if valid_580575 != nil:
    section.add "quotaUser", valid_580575
  var valid_580576 = query.getOrDefault("alt")
  valid_580576 = validateParameter(valid_580576, JString, required = false,
                                 default = newJString("json"))
  if valid_580576 != nil:
    section.add "alt", valid_580576
  var valid_580577 = query.getOrDefault("oauth_token")
  valid_580577 = validateParameter(valid_580577, JString, required = false,
                                 default = nil)
  if valid_580577 != nil:
    section.add "oauth_token", valid_580577
  var valid_580578 = query.getOrDefault("userIp")
  valid_580578 = validateParameter(valid_580578, JString, required = false,
                                 default = nil)
  if valid_580578 != nil:
    section.add "userIp", valid_580578
  var valid_580579 = query.getOrDefault("key")
  valid_580579 = validateParameter(valid_580579, JString, required = false,
                                 default = nil)
  if valid_580579 != nil:
    section.add "key", valid_580579
  var valid_580580 = query.getOrDefault("prettyPrint")
  valid_580580 = validateParameter(valid_580580, JBool, required = false,
                                 default = newJBool(true))
  if valid_580580 != nil:
    section.add "prettyPrint", valid_580580
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

proc call*(call_580582: Call_DriveRepliesUpdate_580568; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing reply.
  ## 
  let valid = call_580582.validator(path, query, header, formData, body)
  let scheme = call_580582.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580582.url(scheme.get, call_580582.host, call_580582.base,
                         call_580582.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580582, url, valid)

proc call*(call_580583: Call_DriveRepliesUpdate_580568; fileId: string;
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
  var path_580584 = newJObject()
  var query_580585 = newJObject()
  var body_580586 = newJObject()
  add(query_580585, "fields", newJString(fields))
  add(query_580585, "quotaUser", newJString(quotaUser))
  add(path_580584, "fileId", newJString(fileId))
  add(query_580585, "alt", newJString(alt))
  add(query_580585, "oauth_token", newJString(oauthToken))
  add(query_580585, "userIp", newJString(userIp))
  add(query_580585, "key", newJString(key))
  add(path_580584, "replyId", newJString(replyId))
  add(path_580584, "commentId", newJString(commentId))
  if body != nil:
    body_580586 = body
  add(query_580585, "prettyPrint", newJBool(prettyPrint))
  result = call_580583.call(path_580584, query_580585, nil, nil, body_580586)

var driveRepliesUpdate* = Call_DriveRepliesUpdate_580568(
    name: "driveRepliesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesUpdate_580569, base: "/drive/v2",
    url: url_DriveRepliesUpdate_580570, schemes: {Scheme.Https})
type
  Call_DriveRepliesGet_580550 = ref object of OpenApiRestCall_579424
proc url_DriveRepliesGet_580552(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRepliesGet_580551(path: JsonNode; query: JsonNode;
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
  var valid_580553 = path.getOrDefault("fileId")
  valid_580553 = validateParameter(valid_580553, JString, required = true,
                                 default = nil)
  if valid_580553 != nil:
    section.add "fileId", valid_580553
  var valid_580554 = path.getOrDefault("replyId")
  valid_580554 = validateParameter(valid_580554, JString, required = true,
                                 default = nil)
  if valid_580554 != nil:
    section.add "replyId", valid_580554
  var valid_580555 = path.getOrDefault("commentId")
  valid_580555 = validateParameter(valid_580555, JString, required = true,
                                 default = nil)
  if valid_580555 != nil:
    section.add "commentId", valid_580555
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
  var valid_580556 = query.getOrDefault("fields")
  valid_580556 = validateParameter(valid_580556, JString, required = false,
                                 default = nil)
  if valid_580556 != nil:
    section.add "fields", valid_580556
  var valid_580557 = query.getOrDefault("quotaUser")
  valid_580557 = validateParameter(valid_580557, JString, required = false,
                                 default = nil)
  if valid_580557 != nil:
    section.add "quotaUser", valid_580557
  var valid_580558 = query.getOrDefault("alt")
  valid_580558 = validateParameter(valid_580558, JString, required = false,
                                 default = newJString("json"))
  if valid_580558 != nil:
    section.add "alt", valid_580558
  var valid_580559 = query.getOrDefault("oauth_token")
  valid_580559 = validateParameter(valid_580559, JString, required = false,
                                 default = nil)
  if valid_580559 != nil:
    section.add "oauth_token", valid_580559
  var valid_580560 = query.getOrDefault("userIp")
  valid_580560 = validateParameter(valid_580560, JString, required = false,
                                 default = nil)
  if valid_580560 != nil:
    section.add "userIp", valid_580560
  var valid_580561 = query.getOrDefault("key")
  valid_580561 = validateParameter(valid_580561, JString, required = false,
                                 default = nil)
  if valid_580561 != nil:
    section.add "key", valid_580561
  var valid_580562 = query.getOrDefault("includeDeleted")
  valid_580562 = validateParameter(valid_580562, JBool, required = false,
                                 default = newJBool(false))
  if valid_580562 != nil:
    section.add "includeDeleted", valid_580562
  var valid_580563 = query.getOrDefault("prettyPrint")
  valid_580563 = validateParameter(valid_580563, JBool, required = false,
                                 default = newJBool(true))
  if valid_580563 != nil:
    section.add "prettyPrint", valid_580563
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580564: Call_DriveRepliesGet_580550; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a reply.
  ## 
  let valid = call_580564.validator(path, query, header, formData, body)
  let scheme = call_580564.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580564.url(scheme.get, call_580564.host, call_580564.base,
                         call_580564.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580564, url, valid)

proc call*(call_580565: Call_DriveRepliesGet_580550; fileId: string; replyId: string;
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
  var path_580566 = newJObject()
  var query_580567 = newJObject()
  add(query_580567, "fields", newJString(fields))
  add(query_580567, "quotaUser", newJString(quotaUser))
  add(path_580566, "fileId", newJString(fileId))
  add(query_580567, "alt", newJString(alt))
  add(query_580567, "oauth_token", newJString(oauthToken))
  add(query_580567, "userIp", newJString(userIp))
  add(query_580567, "key", newJString(key))
  add(path_580566, "replyId", newJString(replyId))
  add(path_580566, "commentId", newJString(commentId))
  add(query_580567, "includeDeleted", newJBool(includeDeleted))
  add(query_580567, "prettyPrint", newJBool(prettyPrint))
  result = call_580565.call(path_580566, query_580567, nil, nil, nil)

var driveRepliesGet* = Call_DriveRepliesGet_580550(name: "driveRepliesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesGet_580551, base: "/drive/v2",
    url: url_DriveRepliesGet_580552, schemes: {Scheme.Https})
type
  Call_DriveRepliesPatch_580604 = ref object of OpenApiRestCall_579424
proc url_DriveRepliesPatch_580606(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRepliesPatch_580605(path: JsonNode; query: JsonNode;
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
  var valid_580607 = path.getOrDefault("fileId")
  valid_580607 = validateParameter(valid_580607, JString, required = true,
                                 default = nil)
  if valid_580607 != nil:
    section.add "fileId", valid_580607
  var valid_580608 = path.getOrDefault("replyId")
  valid_580608 = validateParameter(valid_580608, JString, required = true,
                                 default = nil)
  if valid_580608 != nil:
    section.add "replyId", valid_580608
  var valid_580609 = path.getOrDefault("commentId")
  valid_580609 = validateParameter(valid_580609, JString, required = true,
                                 default = nil)
  if valid_580609 != nil:
    section.add "commentId", valid_580609
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
  var valid_580610 = query.getOrDefault("fields")
  valid_580610 = validateParameter(valid_580610, JString, required = false,
                                 default = nil)
  if valid_580610 != nil:
    section.add "fields", valid_580610
  var valid_580611 = query.getOrDefault("quotaUser")
  valid_580611 = validateParameter(valid_580611, JString, required = false,
                                 default = nil)
  if valid_580611 != nil:
    section.add "quotaUser", valid_580611
  var valid_580612 = query.getOrDefault("alt")
  valid_580612 = validateParameter(valid_580612, JString, required = false,
                                 default = newJString("json"))
  if valid_580612 != nil:
    section.add "alt", valid_580612
  var valid_580613 = query.getOrDefault("oauth_token")
  valid_580613 = validateParameter(valid_580613, JString, required = false,
                                 default = nil)
  if valid_580613 != nil:
    section.add "oauth_token", valid_580613
  var valid_580614 = query.getOrDefault("userIp")
  valid_580614 = validateParameter(valid_580614, JString, required = false,
                                 default = nil)
  if valid_580614 != nil:
    section.add "userIp", valid_580614
  var valid_580615 = query.getOrDefault("key")
  valid_580615 = validateParameter(valid_580615, JString, required = false,
                                 default = nil)
  if valid_580615 != nil:
    section.add "key", valid_580615
  var valid_580616 = query.getOrDefault("prettyPrint")
  valid_580616 = validateParameter(valid_580616, JBool, required = false,
                                 default = newJBool(true))
  if valid_580616 != nil:
    section.add "prettyPrint", valid_580616
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

proc call*(call_580618: Call_DriveRepliesPatch_580604; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing reply. This method supports patch semantics.
  ## 
  let valid = call_580618.validator(path, query, header, formData, body)
  let scheme = call_580618.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580618.url(scheme.get, call_580618.host, call_580618.base,
                         call_580618.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580618, url, valid)

proc call*(call_580619: Call_DriveRepliesPatch_580604; fileId: string;
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
  var path_580620 = newJObject()
  var query_580621 = newJObject()
  var body_580622 = newJObject()
  add(query_580621, "fields", newJString(fields))
  add(query_580621, "quotaUser", newJString(quotaUser))
  add(path_580620, "fileId", newJString(fileId))
  add(query_580621, "alt", newJString(alt))
  add(query_580621, "oauth_token", newJString(oauthToken))
  add(query_580621, "userIp", newJString(userIp))
  add(query_580621, "key", newJString(key))
  add(path_580620, "replyId", newJString(replyId))
  add(path_580620, "commentId", newJString(commentId))
  if body != nil:
    body_580622 = body
  add(query_580621, "prettyPrint", newJBool(prettyPrint))
  result = call_580619.call(path_580620, query_580621, nil, nil, body_580622)

var driveRepliesPatch* = Call_DriveRepliesPatch_580604(name: "driveRepliesPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesPatch_580605, base: "/drive/v2",
    url: url_DriveRepliesPatch_580606, schemes: {Scheme.Https})
type
  Call_DriveRepliesDelete_580587 = ref object of OpenApiRestCall_579424
proc url_DriveRepliesDelete_580589(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRepliesDelete_580588(path: JsonNode; query: JsonNode;
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
  var valid_580590 = path.getOrDefault("fileId")
  valid_580590 = validateParameter(valid_580590, JString, required = true,
                                 default = nil)
  if valid_580590 != nil:
    section.add "fileId", valid_580590
  var valid_580591 = path.getOrDefault("replyId")
  valid_580591 = validateParameter(valid_580591, JString, required = true,
                                 default = nil)
  if valid_580591 != nil:
    section.add "replyId", valid_580591
  var valid_580592 = path.getOrDefault("commentId")
  valid_580592 = validateParameter(valid_580592, JString, required = true,
                                 default = nil)
  if valid_580592 != nil:
    section.add "commentId", valid_580592
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
  var valid_580593 = query.getOrDefault("fields")
  valid_580593 = validateParameter(valid_580593, JString, required = false,
                                 default = nil)
  if valid_580593 != nil:
    section.add "fields", valid_580593
  var valid_580594 = query.getOrDefault("quotaUser")
  valid_580594 = validateParameter(valid_580594, JString, required = false,
                                 default = nil)
  if valid_580594 != nil:
    section.add "quotaUser", valid_580594
  var valid_580595 = query.getOrDefault("alt")
  valid_580595 = validateParameter(valid_580595, JString, required = false,
                                 default = newJString("json"))
  if valid_580595 != nil:
    section.add "alt", valid_580595
  var valid_580596 = query.getOrDefault("oauth_token")
  valid_580596 = validateParameter(valid_580596, JString, required = false,
                                 default = nil)
  if valid_580596 != nil:
    section.add "oauth_token", valid_580596
  var valid_580597 = query.getOrDefault("userIp")
  valid_580597 = validateParameter(valid_580597, JString, required = false,
                                 default = nil)
  if valid_580597 != nil:
    section.add "userIp", valid_580597
  var valid_580598 = query.getOrDefault("key")
  valid_580598 = validateParameter(valid_580598, JString, required = false,
                                 default = nil)
  if valid_580598 != nil:
    section.add "key", valid_580598
  var valid_580599 = query.getOrDefault("prettyPrint")
  valid_580599 = validateParameter(valid_580599, JBool, required = false,
                                 default = newJBool(true))
  if valid_580599 != nil:
    section.add "prettyPrint", valid_580599
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580600: Call_DriveRepliesDelete_580587; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a reply.
  ## 
  let valid = call_580600.validator(path, query, header, formData, body)
  let scheme = call_580600.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580600.url(scheme.get, call_580600.host, call_580600.base,
                         call_580600.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580600, url, valid)

proc call*(call_580601: Call_DriveRepliesDelete_580587; fileId: string;
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
  var path_580602 = newJObject()
  var query_580603 = newJObject()
  add(query_580603, "fields", newJString(fields))
  add(query_580603, "quotaUser", newJString(quotaUser))
  add(path_580602, "fileId", newJString(fileId))
  add(query_580603, "alt", newJString(alt))
  add(query_580603, "oauth_token", newJString(oauthToken))
  add(query_580603, "userIp", newJString(userIp))
  add(query_580603, "key", newJString(key))
  add(path_580602, "replyId", newJString(replyId))
  add(path_580602, "commentId", newJString(commentId))
  add(query_580603, "prettyPrint", newJBool(prettyPrint))
  result = call_580601.call(path_580602, query_580603, nil, nil, nil)

var driveRepliesDelete* = Call_DriveRepliesDelete_580587(
    name: "driveRepliesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesDelete_580588, base: "/drive/v2",
    url: url_DriveRepliesDelete_580589, schemes: {Scheme.Https})
type
  Call_DriveFilesCopy_580623 = ref object of OpenApiRestCall_579424
proc url_DriveFilesCopy_580625(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesCopy_580624(path: JsonNode; query: JsonNode;
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
  var valid_580626 = path.getOrDefault("fileId")
  valid_580626 = validateParameter(valid_580626, JString, required = true,
                                 default = nil)
  if valid_580626 != nil:
    section.add "fileId", valid_580626
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
  var valid_580627 = query.getOrDefault("supportsAllDrives")
  valid_580627 = validateParameter(valid_580627, JBool, required = false,
                                 default = newJBool(false))
  if valid_580627 != nil:
    section.add "supportsAllDrives", valid_580627
  var valid_580628 = query.getOrDefault("fields")
  valid_580628 = validateParameter(valid_580628, JString, required = false,
                                 default = nil)
  if valid_580628 != nil:
    section.add "fields", valid_580628
  var valid_580629 = query.getOrDefault("quotaUser")
  valid_580629 = validateParameter(valid_580629, JString, required = false,
                                 default = nil)
  if valid_580629 != nil:
    section.add "quotaUser", valid_580629
  var valid_580630 = query.getOrDefault("alt")
  valid_580630 = validateParameter(valid_580630, JString, required = false,
                                 default = newJString("json"))
  if valid_580630 != nil:
    section.add "alt", valid_580630
  var valid_580631 = query.getOrDefault("pinned")
  valid_580631 = validateParameter(valid_580631, JBool, required = false,
                                 default = newJBool(false))
  if valid_580631 != nil:
    section.add "pinned", valid_580631
  var valid_580632 = query.getOrDefault("oauth_token")
  valid_580632 = validateParameter(valid_580632, JString, required = false,
                                 default = nil)
  if valid_580632 != nil:
    section.add "oauth_token", valid_580632
  var valid_580633 = query.getOrDefault("userIp")
  valid_580633 = validateParameter(valid_580633, JString, required = false,
                                 default = nil)
  if valid_580633 != nil:
    section.add "userIp", valid_580633
  var valid_580634 = query.getOrDefault("ocr")
  valid_580634 = validateParameter(valid_580634, JBool, required = false,
                                 default = newJBool(false))
  if valid_580634 != nil:
    section.add "ocr", valid_580634
  var valid_580635 = query.getOrDefault("timedTextLanguage")
  valid_580635 = validateParameter(valid_580635, JString, required = false,
                                 default = nil)
  if valid_580635 != nil:
    section.add "timedTextLanguage", valid_580635
  var valid_580636 = query.getOrDefault("supportsTeamDrives")
  valid_580636 = validateParameter(valid_580636, JBool, required = false,
                                 default = newJBool(false))
  if valid_580636 != nil:
    section.add "supportsTeamDrives", valid_580636
  var valid_580637 = query.getOrDefault("key")
  valid_580637 = validateParameter(valid_580637, JString, required = false,
                                 default = nil)
  if valid_580637 != nil:
    section.add "key", valid_580637
  var valid_580638 = query.getOrDefault("convert")
  valid_580638 = validateParameter(valid_580638, JBool, required = false,
                                 default = newJBool(false))
  if valid_580638 != nil:
    section.add "convert", valid_580638
  var valid_580639 = query.getOrDefault("prettyPrint")
  valid_580639 = validateParameter(valid_580639, JBool, required = false,
                                 default = newJBool(true))
  if valid_580639 != nil:
    section.add "prettyPrint", valid_580639
  var valid_580640 = query.getOrDefault("ocrLanguage")
  valid_580640 = validateParameter(valid_580640, JString, required = false,
                                 default = nil)
  if valid_580640 != nil:
    section.add "ocrLanguage", valid_580640
  var valid_580641 = query.getOrDefault("timedTextTrackName")
  valid_580641 = validateParameter(valid_580641, JString, required = false,
                                 default = nil)
  if valid_580641 != nil:
    section.add "timedTextTrackName", valid_580641
  var valid_580642 = query.getOrDefault("visibility")
  valid_580642 = validateParameter(valid_580642, JString, required = false,
                                 default = newJString("DEFAULT"))
  if valid_580642 != nil:
    section.add "visibility", valid_580642
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

proc call*(call_580644: Call_DriveFilesCopy_580623; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a copy of the specified file.
  ## 
  let valid = call_580644.validator(path, query, header, formData, body)
  let scheme = call_580644.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580644.url(scheme.get, call_580644.host, call_580644.base,
                         call_580644.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580644, url, valid)

proc call*(call_580645: Call_DriveFilesCopy_580623; fileId: string;
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
  var path_580646 = newJObject()
  var query_580647 = newJObject()
  var body_580648 = newJObject()
  add(query_580647, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580647, "fields", newJString(fields))
  add(query_580647, "quotaUser", newJString(quotaUser))
  add(path_580646, "fileId", newJString(fileId))
  add(query_580647, "alt", newJString(alt))
  add(query_580647, "pinned", newJBool(pinned))
  add(query_580647, "oauth_token", newJString(oauthToken))
  add(query_580647, "userIp", newJString(userIp))
  add(query_580647, "ocr", newJBool(ocr))
  add(query_580647, "timedTextLanguage", newJString(timedTextLanguage))
  add(query_580647, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580647, "key", newJString(key))
  add(query_580647, "convert", newJBool(convert))
  if body != nil:
    body_580648 = body
  add(query_580647, "prettyPrint", newJBool(prettyPrint))
  add(query_580647, "ocrLanguage", newJString(ocrLanguage))
  add(query_580647, "timedTextTrackName", newJString(timedTextTrackName))
  add(query_580647, "visibility", newJString(visibility))
  result = call_580645.call(path_580646, query_580647, nil, nil, body_580648)

var driveFilesCopy* = Call_DriveFilesCopy_580623(name: "driveFilesCopy",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/copy", validator: validate_DriveFilesCopy_580624,
    base: "/drive/v2", url: url_DriveFilesCopy_580625, schemes: {Scheme.Https})
type
  Call_DriveFilesExport_580649 = ref object of OpenApiRestCall_579424
proc url_DriveFilesExport_580651(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesExport_580650(path: JsonNode; query: JsonNode;
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
  var valid_580652 = path.getOrDefault("fileId")
  valid_580652 = validateParameter(valid_580652, JString, required = true,
                                 default = nil)
  if valid_580652 != nil:
    section.add "fileId", valid_580652
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
  var valid_580653 = query.getOrDefault("fields")
  valid_580653 = validateParameter(valid_580653, JString, required = false,
                                 default = nil)
  if valid_580653 != nil:
    section.add "fields", valid_580653
  var valid_580654 = query.getOrDefault("quotaUser")
  valid_580654 = validateParameter(valid_580654, JString, required = false,
                                 default = nil)
  if valid_580654 != nil:
    section.add "quotaUser", valid_580654
  var valid_580655 = query.getOrDefault("alt")
  valid_580655 = validateParameter(valid_580655, JString, required = false,
                                 default = newJString("json"))
  if valid_580655 != nil:
    section.add "alt", valid_580655
  var valid_580656 = query.getOrDefault("oauth_token")
  valid_580656 = validateParameter(valid_580656, JString, required = false,
                                 default = nil)
  if valid_580656 != nil:
    section.add "oauth_token", valid_580656
  var valid_580657 = query.getOrDefault("userIp")
  valid_580657 = validateParameter(valid_580657, JString, required = false,
                                 default = nil)
  if valid_580657 != nil:
    section.add "userIp", valid_580657
  assert query != nil,
        "query argument is necessary due to required `mimeType` field"
  var valid_580658 = query.getOrDefault("mimeType")
  valid_580658 = validateParameter(valid_580658, JString, required = true,
                                 default = nil)
  if valid_580658 != nil:
    section.add "mimeType", valid_580658
  var valid_580659 = query.getOrDefault("key")
  valid_580659 = validateParameter(valid_580659, JString, required = false,
                                 default = nil)
  if valid_580659 != nil:
    section.add "key", valid_580659
  var valid_580660 = query.getOrDefault("prettyPrint")
  valid_580660 = validateParameter(valid_580660, JBool, required = false,
                                 default = newJBool(true))
  if valid_580660 != nil:
    section.add "prettyPrint", valid_580660
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580661: Call_DriveFilesExport_580649; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports a Google Doc to the requested MIME type and returns the exported content. Please note that the exported content is limited to 10MB.
  ## 
  let valid = call_580661.validator(path, query, header, formData, body)
  let scheme = call_580661.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580661.url(scheme.get, call_580661.host, call_580661.base,
                         call_580661.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580661, url, valid)

proc call*(call_580662: Call_DriveFilesExport_580649; fileId: string;
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
  var path_580663 = newJObject()
  var query_580664 = newJObject()
  add(query_580664, "fields", newJString(fields))
  add(query_580664, "quotaUser", newJString(quotaUser))
  add(path_580663, "fileId", newJString(fileId))
  add(query_580664, "alt", newJString(alt))
  add(query_580664, "oauth_token", newJString(oauthToken))
  add(query_580664, "userIp", newJString(userIp))
  add(query_580664, "mimeType", newJString(mimeType))
  add(query_580664, "key", newJString(key))
  add(query_580664, "prettyPrint", newJBool(prettyPrint))
  result = call_580662.call(path_580663, query_580664, nil, nil, nil)

var driveFilesExport* = Call_DriveFilesExport_580649(name: "driveFilesExport",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/export", validator: validate_DriveFilesExport_580650,
    base: "/drive/v2", url: url_DriveFilesExport_580651, schemes: {Scheme.Https})
type
  Call_DriveParentsInsert_580680 = ref object of OpenApiRestCall_579424
proc url_DriveParentsInsert_580682(protocol: Scheme; host: string; base: string;
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

proc validate_DriveParentsInsert_580681(path: JsonNode; query: JsonNode;
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
  var valid_580683 = path.getOrDefault("fileId")
  valid_580683 = validateParameter(valid_580683, JString, required = true,
                                 default = nil)
  if valid_580683 != nil:
    section.add "fileId", valid_580683
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
  var valid_580684 = query.getOrDefault("supportsAllDrives")
  valid_580684 = validateParameter(valid_580684, JBool, required = false,
                                 default = newJBool(false))
  if valid_580684 != nil:
    section.add "supportsAllDrives", valid_580684
  var valid_580685 = query.getOrDefault("fields")
  valid_580685 = validateParameter(valid_580685, JString, required = false,
                                 default = nil)
  if valid_580685 != nil:
    section.add "fields", valid_580685
  var valid_580686 = query.getOrDefault("quotaUser")
  valid_580686 = validateParameter(valid_580686, JString, required = false,
                                 default = nil)
  if valid_580686 != nil:
    section.add "quotaUser", valid_580686
  var valid_580687 = query.getOrDefault("alt")
  valid_580687 = validateParameter(valid_580687, JString, required = false,
                                 default = newJString("json"))
  if valid_580687 != nil:
    section.add "alt", valid_580687
  var valid_580688 = query.getOrDefault("oauth_token")
  valid_580688 = validateParameter(valid_580688, JString, required = false,
                                 default = nil)
  if valid_580688 != nil:
    section.add "oauth_token", valid_580688
  var valid_580689 = query.getOrDefault("userIp")
  valid_580689 = validateParameter(valid_580689, JString, required = false,
                                 default = nil)
  if valid_580689 != nil:
    section.add "userIp", valid_580689
  var valid_580690 = query.getOrDefault("supportsTeamDrives")
  valid_580690 = validateParameter(valid_580690, JBool, required = false,
                                 default = newJBool(false))
  if valid_580690 != nil:
    section.add "supportsTeamDrives", valid_580690
  var valid_580691 = query.getOrDefault("key")
  valid_580691 = validateParameter(valid_580691, JString, required = false,
                                 default = nil)
  if valid_580691 != nil:
    section.add "key", valid_580691
  var valid_580692 = query.getOrDefault("prettyPrint")
  valid_580692 = validateParameter(valid_580692, JBool, required = false,
                                 default = newJBool(true))
  if valid_580692 != nil:
    section.add "prettyPrint", valid_580692
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

proc call*(call_580694: Call_DriveParentsInsert_580680; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a parent folder for a file.
  ## 
  let valid = call_580694.validator(path, query, header, formData, body)
  let scheme = call_580694.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580694.url(scheme.get, call_580694.host, call_580694.base,
                         call_580694.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580694, url, valid)

proc call*(call_580695: Call_DriveParentsInsert_580680; fileId: string;
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
  var path_580696 = newJObject()
  var query_580697 = newJObject()
  var body_580698 = newJObject()
  add(query_580697, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580697, "fields", newJString(fields))
  add(query_580697, "quotaUser", newJString(quotaUser))
  add(path_580696, "fileId", newJString(fileId))
  add(query_580697, "alt", newJString(alt))
  add(query_580697, "oauth_token", newJString(oauthToken))
  add(query_580697, "userIp", newJString(userIp))
  add(query_580697, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580697, "key", newJString(key))
  if body != nil:
    body_580698 = body
  add(query_580697, "prettyPrint", newJBool(prettyPrint))
  result = call_580695.call(path_580696, query_580697, nil, nil, body_580698)

var driveParentsInsert* = Call_DriveParentsInsert_580680(
    name: "driveParentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/parents",
    validator: validate_DriveParentsInsert_580681, base: "/drive/v2",
    url: url_DriveParentsInsert_580682, schemes: {Scheme.Https})
type
  Call_DriveParentsList_580665 = ref object of OpenApiRestCall_579424
proc url_DriveParentsList_580667(protocol: Scheme; host: string; base: string;
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

proc validate_DriveParentsList_580666(path: JsonNode; query: JsonNode;
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
  var valid_580668 = path.getOrDefault("fileId")
  valid_580668 = validateParameter(valid_580668, JString, required = true,
                                 default = nil)
  if valid_580668 != nil:
    section.add "fileId", valid_580668
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
  var valid_580669 = query.getOrDefault("fields")
  valid_580669 = validateParameter(valid_580669, JString, required = false,
                                 default = nil)
  if valid_580669 != nil:
    section.add "fields", valid_580669
  var valid_580670 = query.getOrDefault("quotaUser")
  valid_580670 = validateParameter(valid_580670, JString, required = false,
                                 default = nil)
  if valid_580670 != nil:
    section.add "quotaUser", valid_580670
  var valid_580671 = query.getOrDefault("alt")
  valid_580671 = validateParameter(valid_580671, JString, required = false,
                                 default = newJString("json"))
  if valid_580671 != nil:
    section.add "alt", valid_580671
  var valid_580672 = query.getOrDefault("oauth_token")
  valid_580672 = validateParameter(valid_580672, JString, required = false,
                                 default = nil)
  if valid_580672 != nil:
    section.add "oauth_token", valid_580672
  var valid_580673 = query.getOrDefault("userIp")
  valid_580673 = validateParameter(valid_580673, JString, required = false,
                                 default = nil)
  if valid_580673 != nil:
    section.add "userIp", valid_580673
  var valid_580674 = query.getOrDefault("key")
  valid_580674 = validateParameter(valid_580674, JString, required = false,
                                 default = nil)
  if valid_580674 != nil:
    section.add "key", valid_580674
  var valid_580675 = query.getOrDefault("prettyPrint")
  valid_580675 = validateParameter(valid_580675, JBool, required = false,
                                 default = newJBool(true))
  if valid_580675 != nil:
    section.add "prettyPrint", valid_580675
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580676: Call_DriveParentsList_580665; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's parents.
  ## 
  let valid = call_580676.validator(path, query, header, formData, body)
  let scheme = call_580676.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580676.url(scheme.get, call_580676.host, call_580676.base,
                         call_580676.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580676, url, valid)

proc call*(call_580677: Call_DriveParentsList_580665; fileId: string;
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
  var path_580678 = newJObject()
  var query_580679 = newJObject()
  add(query_580679, "fields", newJString(fields))
  add(query_580679, "quotaUser", newJString(quotaUser))
  add(path_580678, "fileId", newJString(fileId))
  add(query_580679, "alt", newJString(alt))
  add(query_580679, "oauth_token", newJString(oauthToken))
  add(query_580679, "userIp", newJString(userIp))
  add(query_580679, "key", newJString(key))
  add(query_580679, "prettyPrint", newJBool(prettyPrint))
  result = call_580677.call(path_580678, query_580679, nil, nil, nil)

var driveParentsList* = Call_DriveParentsList_580665(name: "driveParentsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/parents", validator: validate_DriveParentsList_580666,
    base: "/drive/v2", url: url_DriveParentsList_580667, schemes: {Scheme.Https})
type
  Call_DriveParentsGet_580699 = ref object of OpenApiRestCall_579424
proc url_DriveParentsGet_580701(protocol: Scheme; host: string; base: string;
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

proc validate_DriveParentsGet_580700(path: JsonNode; query: JsonNode;
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
  var valid_580702 = path.getOrDefault("fileId")
  valid_580702 = validateParameter(valid_580702, JString, required = true,
                                 default = nil)
  if valid_580702 != nil:
    section.add "fileId", valid_580702
  var valid_580703 = path.getOrDefault("parentId")
  valid_580703 = validateParameter(valid_580703, JString, required = true,
                                 default = nil)
  if valid_580703 != nil:
    section.add "parentId", valid_580703
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
  var valid_580704 = query.getOrDefault("fields")
  valid_580704 = validateParameter(valid_580704, JString, required = false,
                                 default = nil)
  if valid_580704 != nil:
    section.add "fields", valid_580704
  var valid_580705 = query.getOrDefault("quotaUser")
  valid_580705 = validateParameter(valid_580705, JString, required = false,
                                 default = nil)
  if valid_580705 != nil:
    section.add "quotaUser", valid_580705
  var valid_580706 = query.getOrDefault("alt")
  valid_580706 = validateParameter(valid_580706, JString, required = false,
                                 default = newJString("json"))
  if valid_580706 != nil:
    section.add "alt", valid_580706
  var valid_580707 = query.getOrDefault("oauth_token")
  valid_580707 = validateParameter(valid_580707, JString, required = false,
                                 default = nil)
  if valid_580707 != nil:
    section.add "oauth_token", valid_580707
  var valid_580708 = query.getOrDefault("userIp")
  valid_580708 = validateParameter(valid_580708, JString, required = false,
                                 default = nil)
  if valid_580708 != nil:
    section.add "userIp", valid_580708
  var valid_580709 = query.getOrDefault("key")
  valid_580709 = validateParameter(valid_580709, JString, required = false,
                                 default = nil)
  if valid_580709 != nil:
    section.add "key", valid_580709
  var valid_580710 = query.getOrDefault("prettyPrint")
  valid_580710 = validateParameter(valid_580710, JBool, required = false,
                                 default = newJBool(true))
  if valid_580710 != nil:
    section.add "prettyPrint", valid_580710
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580711: Call_DriveParentsGet_580699; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific parent reference.
  ## 
  let valid = call_580711.validator(path, query, header, formData, body)
  let scheme = call_580711.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580711.url(scheme.get, call_580711.host, call_580711.base,
                         call_580711.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580711, url, valid)

proc call*(call_580712: Call_DriveParentsGet_580699; fileId: string;
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
  var path_580713 = newJObject()
  var query_580714 = newJObject()
  add(query_580714, "fields", newJString(fields))
  add(query_580714, "quotaUser", newJString(quotaUser))
  add(path_580713, "fileId", newJString(fileId))
  add(query_580714, "alt", newJString(alt))
  add(path_580713, "parentId", newJString(parentId))
  add(query_580714, "oauth_token", newJString(oauthToken))
  add(query_580714, "userIp", newJString(userIp))
  add(query_580714, "key", newJString(key))
  add(query_580714, "prettyPrint", newJBool(prettyPrint))
  result = call_580712.call(path_580713, query_580714, nil, nil, nil)

var driveParentsGet* = Call_DriveParentsGet_580699(name: "driveParentsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/parents/{parentId}",
    validator: validate_DriveParentsGet_580700, base: "/drive/v2",
    url: url_DriveParentsGet_580701, schemes: {Scheme.Https})
type
  Call_DriveParentsDelete_580715 = ref object of OpenApiRestCall_579424
proc url_DriveParentsDelete_580717(protocol: Scheme; host: string; base: string;
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

proc validate_DriveParentsDelete_580716(path: JsonNode; query: JsonNode;
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
  var valid_580718 = path.getOrDefault("fileId")
  valid_580718 = validateParameter(valid_580718, JString, required = true,
                                 default = nil)
  if valid_580718 != nil:
    section.add "fileId", valid_580718
  var valid_580719 = path.getOrDefault("parentId")
  valid_580719 = validateParameter(valid_580719, JString, required = true,
                                 default = nil)
  if valid_580719 != nil:
    section.add "parentId", valid_580719
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
  var valid_580720 = query.getOrDefault("fields")
  valid_580720 = validateParameter(valid_580720, JString, required = false,
                                 default = nil)
  if valid_580720 != nil:
    section.add "fields", valid_580720
  var valid_580721 = query.getOrDefault("quotaUser")
  valid_580721 = validateParameter(valid_580721, JString, required = false,
                                 default = nil)
  if valid_580721 != nil:
    section.add "quotaUser", valid_580721
  var valid_580722 = query.getOrDefault("alt")
  valid_580722 = validateParameter(valid_580722, JString, required = false,
                                 default = newJString("json"))
  if valid_580722 != nil:
    section.add "alt", valid_580722
  var valid_580723 = query.getOrDefault("oauth_token")
  valid_580723 = validateParameter(valid_580723, JString, required = false,
                                 default = nil)
  if valid_580723 != nil:
    section.add "oauth_token", valid_580723
  var valid_580724 = query.getOrDefault("userIp")
  valid_580724 = validateParameter(valid_580724, JString, required = false,
                                 default = nil)
  if valid_580724 != nil:
    section.add "userIp", valid_580724
  var valid_580725 = query.getOrDefault("key")
  valid_580725 = validateParameter(valid_580725, JString, required = false,
                                 default = nil)
  if valid_580725 != nil:
    section.add "key", valid_580725
  var valid_580726 = query.getOrDefault("prettyPrint")
  valid_580726 = validateParameter(valid_580726, JBool, required = false,
                                 default = newJBool(true))
  if valid_580726 != nil:
    section.add "prettyPrint", valid_580726
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580727: Call_DriveParentsDelete_580715; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a parent from a file.
  ## 
  let valid = call_580727.validator(path, query, header, formData, body)
  let scheme = call_580727.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580727.url(scheme.get, call_580727.host, call_580727.base,
                         call_580727.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580727, url, valid)

proc call*(call_580728: Call_DriveParentsDelete_580715; fileId: string;
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
  var path_580729 = newJObject()
  var query_580730 = newJObject()
  add(query_580730, "fields", newJString(fields))
  add(query_580730, "quotaUser", newJString(quotaUser))
  add(path_580729, "fileId", newJString(fileId))
  add(query_580730, "alt", newJString(alt))
  add(path_580729, "parentId", newJString(parentId))
  add(query_580730, "oauth_token", newJString(oauthToken))
  add(query_580730, "userIp", newJString(userIp))
  add(query_580730, "key", newJString(key))
  add(query_580730, "prettyPrint", newJBool(prettyPrint))
  result = call_580728.call(path_580729, query_580730, nil, nil, nil)

var driveParentsDelete* = Call_DriveParentsDelete_580715(
    name: "driveParentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/parents/{parentId}",
    validator: validate_DriveParentsDelete_580716, base: "/drive/v2",
    url: url_DriveParentsDelete_580717, schemes: {Scheme.Https})
type
  Call_DrivePermissionsInsert_580751 = ref object of OpenApiRestCall_579424
proc url_DrivePermissionsInsert_580753(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePermissionsInsert_580752(path: JsonNode; query: JsonNode;
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
  var valid_580754 = path.getOrDefault("fileId")
  valid_580754 = validateParameter(valid_580754, JString, required = true,
                                 default = nil)
  if valid_580754 != nil:
    section.add "fileId", valid_580754
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
  var valid_580755 = query.getOrDefault("supportsAllDrives")
  valid_580755 = validateParameter(valid_580755, JBool, required = false,
                                 default = newJBool(false))
  if valid_580755 != nil:
    section.add "supportsAllDrives", valid_580755
  var valid_580756 = query.getOrDefault("fields")
  valid_580756 = validateParameter(valid_580756, JString, required = false,
                                 default = nil)
  if valid_580756 != nil:
    section.add "fields", valid_580756
  var valid_580757 = query.getOrDefault("quotaUser")
  valid_580757 = validateParameter(valid_580757, JString, required = false,
                                 default = nil)
  if valid_580757 != nil:
    section.add "quotaUser", valid_580757
  var valid_580758 = query.getOrDefault("alt")
  valid_580758 = validateParameter(valid_580758, JString, required = false,
                                 default = newJString("json"))
  if valid_580758 != nil:
    section.add "alt", valid_580758
  var valid_580759 = query.getOrDefault("oauth_token")
  valid_580759 = validateParameter(valid_580759, JString, required = false,
                                 default = nil)
  if valid_580759 != nil:
    section.add "oauth_token", valid_580759
  var valid_580760 = query.getOrDefault("sendNotificationEmails")
  valid_580760 = validateParameter(valid_580760, JBool, required = false,
                                 default = newJBool(true))
  if valid_580760 != nil:
    section.add "sendNotificationEmails", valid_580760
  var valid_580761 = query.getOrDefault("userIp")
  valid_580761 = validateParameter(valid_580761, JString, required = false,
                                 default = nil)
  if valid_580761 != nil:
    section.add "userIp", valid_580761
  var valid_580762 = query.getOrDefault("supportsTeamDrives")
  valid_580762 = validateParameter(valid_580762, JBool, required = false,
                                 default = newJBool(false))
  if valid_580762 != nil:
    section.add "supportsTeamDrives", valid_580762
  var valid_580763 = query.getOrDefault("key")
  valid_580763 = validateParameter(valid_580763, JString, required = false,
                                 default = nil)
  if valid_580763 != nil:
    section.add "key", valid_580763
  var valid_580764 = query.getOrDefault("useDomainAdminAccess")
  valid_580764 = validateParameter(valid_580764, JBool, required = false,
                                 default = newJBool(false))
  if valid_580764 != nil:
    section.add "useDomainAdminAccess", valid_580764
  var valid_580765 = query.getOrDefault("emailMessage")
  valid_580765 = validateParameter(valid_580765, JString, required = false,
                                 default = nil)
  if valid_580765 != nil:
    section.add "emailMessage", valid_580765
  var valid_580766 = query.getOrDefault("prettyPrint")
  valid_580766 = validateParameter(valid_580766, JBool, required = false,
                                 default = newJBool(true))
  if valid_580766 != nil:
    section.add "prettyPrint", valid_580766
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

proc call*(call_580768: Call_DrivePermissionsInsert_580751; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a permission for a file or shared drive.
  ## 
  let valid = call_580768.validator(path, query, header, formData, body)
  let scheme = call_580768.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580768.url(scheme.get, call_580768.host, call_580768.base,
                         call_580768.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580768, url, valid)

proc call*(call_580769: Call_DrivePermissionsInsert_580751; fileId: string;
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
  var path_580770 = newJObject()
  var query_580771 = newJObject()
  var body_580772 = newJObject()
  add(query_580771, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580771, "fields", newJString(fields))
  add(query_580771, "quotaUser", newJString(quotaUser))
  add(path_580770, "fileId", newJString(fileId))
  add(query_580771, "alt", newJString(alt))
  add(query_580771, "oauth_token", newJString(oauthToken))
  add(query_580771, "sendNotificationEmails", newJBool(sendNotificationEmails))
  add(query_580771, "userIp", newJString(userIp))
  add(query_580771, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580771, "key", newJString(key))
  add(query_580771, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580771, "emailMessage", newJString(emailMessage))
  if body != nil:
    body_580772 = body
  add(query_580771, "prettyPrint", newJBool(prettyPrint))
  result = call_580769.call(path_580770, query_580771, nil, nil, body_580772)

var drivePermissionsInsert* = Call_DrivePermissionsInsert_580751(
    name: "drivePermissionsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/permissions",
    validator: validate_DrivePermissionsInsert_580752, base: "/drive/v2",
    url: url_DrivePermissionsInsert_580753, schemes: {Scheme.Https})
type
  Call_DrivePermissionsList_580731 = ref object of OpenApiRestCall_579424
proc url_DrivePermissionsList_580733(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePermissionsList_580732(path: JsonNode; query: JsonNode;
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
  var valid_580734 = path.getOrDefault("fileId")
  valid_580734 = validateParameter(valid_580734, JString, required = true,
                                 default = nil)
  if valid_580734 != nil:
    section.add "fileId", valid_580734
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
  var valid_580735 = query.getOrDefault("supportsAllDrives")
  valid_580735 = validateParameter(valid_580735, JBool, required = false,
                                 default = newJBool(false))
  if valid_580735 != nil:
    section.add "supportsAllDrives", valid_580735
  var valid_580736 = query.getOrDefault("fields")
  valid_580736 = validateParameter(valid_580736, JString, required = false,
                                 default = nil)
  if valid_580736 != nil:
    section.add "fields", valid_580736
  var valid_580737 = query.getOrDefault("pageToken")
  valid_580737 = validateParameter(valid_580737, JString, required = false,
                                 default = nil)
  if valid_580737 != nil:
    section.add "pageToken", valid_580737
  var valid_580738 = query.getOrDefault("quotaUser")
  valid_580738 = validateParameter(valid_580738, JString, required = false,
                                 default = nil)
  if valid_580738 != nil:
    section.add "quotaUser", valid_580738
  var valid_580739 = query.getOrDefault("alt")
  valid_580739 = validateParameter(valid_580739, JString, required = false,
                                 default = newJString("json"))
  if valid_580739 != nil:
    section.add "alt", valid_580739
  var valid_580740 = query.getOrDefault("oauth_token")
  valid_580740 = validateParameter(valid_580740, JString, required = false,
                                 default = nil)
  if valid_580740 != nil:
    section.add "oauth_token", valid_580740
  var valid_580741 = query.getOrDefault("userIp")
  valid_580741 = validateParameter(valid_580741, JString, required = false,
                                 default = nil)
  if valid_580741 != nil:
    section.add "userIp", valid_580741
  var valid_580742 = query.getOrDefault("maxResults")
  valid_580742 = validateParameter(valid_580742, JInt, required = false, default = nil)
  if valid_580742 != nil:
    section.add "maxResults", valid_580742
  var valid_580743 = query.getOrDefault("supportsTeamDrives")
  valid_580743 = validateParameter(valid_580743, JBool, required = false,
                                 default = newJBool(false))
  if valid_580743 != nil:
    section.add "supportsTeamDrives", valid_580743
  var valid_580744 = query.getOrDefault("key")
  valid_580744 = validateParameter(valid_580744, JString, required = false,
                                 default = nil)
  if valid_580744 != nil:
    section.add "key", valid_580744
  var valid_580745 = query.getOrDefault("useDomainAdminAccess")
  valid_580745 = validateParameter(valid_580745, JBool, required = false,
                                 default = newJBool(false))
  if valid_580745 != nil:
    section.add "useDomainAdminAccess", valid_580745
  var valid_580746 = query.getOrDefault("prettyPrint")
  valid_580746 = validateParameter(valid_580746, JBool, required = false,
                                 default = newJBool(true))
  if valid_580746 != nil:
    section.add "prettyPrint", valid_580746
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580747: Call_DrivePermissionsList_580731; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's or shared drive's permissions.
  ## 
  let valid = call_580747.validator(path, query, header, formData, body)
  let scheme = call_580747.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580747.url(scheme.get, call_580747.host, call_580747.base,
                         call_580747.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580747, url, valid)

proc call*(call_580748: Call_DrivePermissionsList_580731; fileId: string;
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
  var path_580749 = newJObject()
  var query_580750 = newJObject()
  add(query_580750, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580750, "fields", newJString(fields))
  add(query_580750, "pageToken", newJString(pageToken))
  add(query_580750, "quotaUser", newJString(quotaUser))
  add(path_580749, "fileId", newJString(fileId))
  add(query_580750, "alt", newJString(alt))
  add(query_580750, "oauth_token", newJString(oauthToken))
  add(query_580750, "userIp", newJString(userIp))
  add(query_580750, "maxResults", newJInt(maxResults))
  add(query_580750, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580750, "key", newJString(key))
  add(query_580750, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580750, "prettyPrint", newJBool(prettyPrint))
  result = call_580748.call(path_580749, query_580750, nil, nil, nil)

var drivePermissionsList* = Call_DrivePermissionsList_580731(
    name: "drivePermissionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/permissions",
    validator: validate_DrivePermissionsList_580732, base: "/drive/v2",
    url: url_DrivePermissionsList_580733, schemes: {Scheme.Https})
type
  Call_DrivePermissionsUpdate_580792 = ref object of OpenApiRestCall_579424
proc url_DrivePermissionsUpdate_580794(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePermissionsUpdate_580793(path: JsonNode; query: JsonNode;
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
  var valid_580795 = path.getOrDefault("fileId")
  valid_580795 = validateParameter(valid_580795, JString, required = true,
                                 default = nil)
  if valid_580795 != nil:
    section.add "fileId", valid_580795
  var valid_580796 = path.getOrDefault("permissionId")
  valid_580796 = validateParameter(valid_580796, JString, required = true,
                                 default = nil)
  if valid_580796 != nil:
    section.add "permissionId", valid_580796
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
  var valid_580797 = query.getOrDefault("supportsAllDrives")
  valid_580797 = validateParameter(valid_580797, JBool, required = false,
                                 default = newJBool(false))
  if valid_580797 != nil:
    section.add "supportsAllDrives", valid_580797
  var valid_580798 = query.getOrDefault("fields")
  valid_580798 = validateParameter(valid_580798, JString, required = false,
                                 default = nil)
  if valid_580798 != nil:
    section.add "fields", valid_580798
  var valid_580799 = query.getOrDefault("quotaUser")
  valid_580799 = validateParameter(valid_580799, JString, required = false,
                                 default = nil)
  if valid_580799 != nil:
    section.add "quotaUser", valid_580799
  var valid_580800 = query.getOrDefault("alt")
  valid_580800 = validateParameter(valid_580800, JString, required = false,
                                 default = newJString("json"))
  if valid_580800 != nil:
    section.add "alt", valid_580800
  var valid_580801 = query.getOrDefault("oauth_token")
  valid_580801 = validateParameter(valid_580801, JString, required = false,
                                 default = nil)
  if valid_580801 != nil:
    section.add "oauth_token", valid_580801
  var valid_580802 = query.getOrDefault("removeExpiration")
  valid_580802 = validateParameter(valid_580802, JBool, required = false,
                                 default = newJBool(false))
  if valid_580802 != nil:
    section.add "removeExpiration", valid_580802
  var valid_580803 = query.getOrDefault("userIp")
  valid_580803 = validateParameter(valid_580803, JString, required = false,
                                 default = nil)
  if valid_580803 != nil:
    section.add "userIp", valid_580803
  var valid_580804 = query.getOrDefault("supportsTeamDrives")
  valid_580804 = validateParameter(valid_580804, JBool, required = false,
                                 default = newJBool(false))
  if valid_580804 != nil:
    section.add "supportsTeamDrives", valid_580804
  var valid_580805 = query.getOrDefault("key")
  valid_580805 = validateParameter(valid_580805, JString, required = false,
                                 default = nil)
  if valid_580805 != nil:
    section.add "key", valid_580805
  var valid_580806 = query.getOrDefault("useDomainAdminAccess")
  valid_580806 = validateParameter(valid_580806, JBool, required = false,
                                 default = newJBool(false))
  if valid_580806 != nil:
    section.add "useDomainAdminAccess", valid_580806
  var valid_580807 = query.getOrDefault("transferOwnership")
  valid_580807 = validateParameter(valid_580807, JBool, required = false,
                                 default = newJBool(false))
  if valid_580807 != nil:
    section.add "transferOwnership", valid_580807
  var valid_580808 = query.getOrDefault("prettyPrint")
  valid_580808 = validateParameter(valid_580808, JBool, required = false,
                                 default = newJBool(true))
  if valid_580808 != nil:
    section.add "prettyPrint", valid_580808
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

proc call*(call_580810: Call_DrivePermissionsUpdate_580792; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a permission.
  ## 
  let valid = call_580810.validator(path, query, header, formData, body)
  let scheme = call_580810.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580810.url(scheme.get, call_580810.host, call_580810.base,
                         call_580810.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580810, url, valid)

proc call*(call_580811: Call_DrivePermissionsUpdate_580792; fileId: string;
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
  var path_580812 = newJObject()
  var query_580813 = newJObject()
  var body_580814 = newJObject()
  add(query_580813, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580813, "fields", newJString(fields))
  add(query_580813, "quotaUser", newJString(quotaUser))
  add(path_580812, "fileId", newJString(fileId))
  add(query_580813, "alt", newJString(alt))
  add(query_580813, "oauth_token", newJString(oauthToken))
  add(path_580812, "permissionId", newJString(permissionId))
  add(query_580813, "removeExpiration", newJBool(removeExpiration))
  add(query_580813, "userIp", newJString(userIp))
  add(query_580813, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580813, "key", newJString(key))
  add(query_580813, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580813, "transferOwnership", newJBool(transferOwnership))
  if body != nil:
    body_580814 = body
  add(query_580813, "prettyPrint", newJBool(prettyPrint))
  result = call_580811.call(path_580812, query_580813, nil, nil, body_580814)

var drivePermissionsUpdate* = Call_DrivePermissionsUpdate_580792(
    name: "drivePermissionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsUpdate_580793, base: "/drive/v2",
    url: url_DrivePermissionsUpdate_580794, schemes: {Scheme.Https})
type
  Call_DrivePermissionsGet_580773 = ref object of OpenApiRestCall_579424
proc url_DrivePermissionsGet_580775(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePermissionsGet_580774(path: JsonNode; query: JsonNode;
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
  var valid_580776 = path.getOrDefault("fileId")
  valid_580776 = validateParameter(valid_580776, JString, required = true,
                                 default = nil)
  if valid_580776 != nil:
    section.add "fileId", valid_580776
  var valid_580777 = path.getOrDefault("permissionId")
  valid_580777 = validateParameter(valid_580777, JString, required = true,
                                 default = nil)
  if valid_580777 != nil:
    section.add "permissionId", valid_580777
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
  var valid_580778 = query.getOrDefault("supportsAllDrives")
  valid_580778 = validateParameter(valid_580778, JBool, required = false,
                                 default = newJBool(false))
  if valid_580778 != nil:
    section.add "supportsAllDrives", valid_580778
  var valid_580779 = query.getOrDefault("fields")
  valid_580779 = validateParameter(valid_580779, JString, required = false,
                                 default = nil)
  if valid_580779 != nil:
    section.add "fields", valid_580779
  var valid_580780 = query.getOrDefault("quotaUser")
  valid_580780 = validateParameter(valid_580780, JString, required = false,
                                 default = nil)
  if valid_580780 != nil:
    section.add "quotaUser", valid_580780
  var valid_580781 = query.getOrDefault("alt")
  valid_580781 = validateParameter(valid_580781, JString, required = false,
                                 default = newJString("json"))
  if valid_580781 != nil:
    section.add "alt", valid_580781
  var valid_580782 = query.getOrDefault("oauth_token")
  valid_580782 = validateParameter(valid_580782, JString, required = false,
                                 default = nil)
  if valid_580782 != nil:
    section.add "oauth_token", valid_580782
  var valid_580783 = query.getOrDefault("userIp")
  valid_580783 = validateParameter(valid_580783, JString, required = false,
                                 default = nil)
  if valid_580783 != nil:
    section.add "userIp", valid_580783
  var valid_580784 = query.getOrDefault("supportsTeamDrives")
  valid_580784 = validateParameter(valid_580784, JBool, required = false,
                                 default = newJBool(false))
  if valid_580784 != nil:
    section.add "supportsTeamDrives", valid_580784
  var valid_580785 = query.getOrDefault("key")
  valid_580785 = validateParameter(valid_580785, JString, required = false,
                                 default = nil)
  if valid_580785 != nil:
    section.add "key", valid_580785
  var valid_580786 = query.getOrDefault("useDomainAdminAccess")
  valid_580786 = validateParameter(valid_580786, JBool, required = false,
                                 default = newJBool(false))
  if valid_580786 != nil:
    section.add "useDomainAdminAccess", valid_580786
  var valid_580787 = query.getOrDefault("prettyPrint")
  valid_580787 = validateParameter(valid_580787, JBool, required = false,
                                 default = newJBool(true))
  if valid_580787 != nil:
    section.add "prettyPrint", valid_580787
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580788: Call_DrivePermissionsGet_580773; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a permission by ID.
  ## 
  let valid = call_580788.validator(path, query, header, formData, body)
  let scheme = call_580788.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580788.url(scheme.get, call_580788.host, call_580788.base,
                         call_580788.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580788, url, valid)

proc call*(call_580789: Call_DrivePermissionsGet_580773; fileId: string;
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
  var path_580790 = newJObject()
  var query_580791 = newJObject()
  add(query_580791, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580791, "fields", newJString(fields))
  add(query_580791, "quotaUser", newJString(quotaUser))
  add(path_580790, "fileId", newJString(fileId))
  add(query_580791, "alt", newJString(alt))
  add(query_580791, "oauth_token", newJString(oauthToken))
  add(path_580790, "permissionId", newJString(permissionId))
  add(query_580791, "userIp", newJString(userIp))
  add(query_580791, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580791, "key", newJString(key))
  add(query_580791, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580791, "prettyPrint", newJBool(prettyPrint))
  result = call_580789.call(path_580790, query_580791, nil, nil, nil)

var drivePermissionsGet* = Call_DrivePermissionsGet_580773(
    name: "drivePermissionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsGet_580774, base: "/drive/v2",
    url: url_DrivePermissionsGet_580775, schemes: {Scheme.Https})
type
  Call_DrivePermissionsPatch_580834 = ref object of OpenApiRestCall_579424
proc url_DrivePermissionsPatch_580836(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePermissionsPatch_580835(path: JsonNode; query: JsonNode;
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
  var valid_580837 = path.getOrDefault("fileId")
  valid_580837 = validateParameter(valid_580837, JString, required = true,
                                 default = nil)
  if valid_580837 != nil:
    section.add "fileId", valid_580837
  var valid_580838 = path.getOrDefault("permissionId")
  valid_580838 = validateParameter(valid_580838, JString, required = true,
                                 default = nil)
  if valid_580838 != nil:
    section.add "permissionId", valid_580838
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
  var valid_580839 = query.getOrDefault("supportsAllDrives")
  valid_580839 = validateParameter(valid_580839, JBool, required = false,
                                 default = newJBool(false))
  if valid_580839 != nil:
    section.add "supportsAllDrives", valid_580839
  var valid_580840 = query.getOrDefault("fields")
  valid_580840 = validateParameter(valid_580840, JString, required = false,
                                 default = nil)
  if valid_580840 != nil:
    section.add "fields", valid_580840
  var valid_580841 = query.getOrDefault("quotaUser")
  valid_580841 = validateParameter(valid_580841, JString, required = false,
                                 default = nil)
  if valid_580841 != nil:
    section.add "quotaUser", valid_580841
  var valid_580842 = query.getOrDefault("alt")
  valid_580842 = validateParameter(valid_580842, JString, required = false,
                                 default = newJString("json"))
  if valid_580842 != nil:
    section.add "alt", valid_580842
  var valid_580843 = query.getOrDefault("oauth_token")
  valid_580843 = validateParameter(valid_580843, JString, required = false,
                                 default = nil)
  if valid_580843 != nil:
    section.add "oauth_token", valid_580843
  var valid_580844 = query.getOrDefault("removeExpiration")
  valid_580844 = validateParameter(valid_580844, JBool, required = false,
                                 default = newJBool(false))
  if valid_580844 != nil:
    section.add "removeExpiration", valid_580844
  var valid_580845 = query.getOrDefault("userIp")
  valid_580845 = validateParameter(valid_580845, JString, required = false,
                                 default = nil)
  if valid_580845 != nil:
    section.add "userIp", valid_580845
  var valid_580846 = query.getOrDefault("supportsTeamDrives")
  valid_580846 = validateParameter(valid_580846, JBool, required = false,
                                 default = newJBool(false))
  if valid_580846 != nil:
    section.add "supportsTeamDrives", valid_580846
  var valid_580847 = query.getOrDefault("key")
  valid_580847 = validateParameter(valid_580847, JString, required = false,
                                 default = nil)
  if valid_580847 != nil:
    section.add "key", valid_580847
  var valid_580848 = query.getOrDefault("useDomainAdminAccess")
  valid_580848 = validateParameter(valid_580848, JBool, required = false,
                                 default = newJBool(false))
  if valid_580848 != nil:
    section.add "useDomainAdminAccess", valid_580848
  var valid_580849 = query.getOrDefault("transferOwnership")
  valid_580849 = validateParameter(valid_580849, JBool, required = false,
                                 default = newJBool(false))
  if valid_580849 != nil:
    section.add "transferOwnership", valid_580849
  var valid_580850 = query.getOrDefault("prettyPrint")
  valid_580850 = validateParameter(valid_580850, JBool, required = false,
                                 default = newJBool(true))
  if valid_580850 != nil:
    section.add "prettyPrint", valid_580850
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

proc call*(call_580852: Call_DrivePermissionsPatch_580834; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a permission using patch semantics.
  ## 
  let valid = call_580852.validator(path, query, header, formData, body)
  let scheme = call_580852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580852.url(scheme.get, call_580852.host, call_580852.base,
                         call_580852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580852, url, valid)

proc call*(call_580853: Call_DrivePermissionsPatch_580834; fileId: string;
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
  var path_580854 = newJObject()
  var query_580855 = newJObject()
  var body_580856 = newJObject()
  add(query_580855, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580855, "fields", newJString(fields))
  add(query_580855, "quotaUser", newJString(quotaUser))
  add(path_580854, "fileId", newJString(fileId))
  add(query_580855, "alt", newJString(alt))
  add(query_580855, "oauth_token", newJString(oauthToken))
  add(path_580854, "permissionId", newJString(permissionId))
  add(query_580855, "removeExpiration", newJBool(removeExpiration))
  add(query_580855, "userIp", newJString(userIp))
  add(query_580855, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580855, "key", newJString(key))
  add(query_580855, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580855, "transferOwnership", newJBool(transferOwnership))
  if body != nil:
    body_580856 = body
  add(query_580855, "prettyPrint", newJBool(prettyPrint))
  result = call_580853.call(path_580854, query_580855, nil, nil, body_580856)

var drivePermissionsPatch* = Call_DrivePermissionsPatch_580834(
    name: "drivePermissionsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsPatch_580835, base: "/drive/v2",
    url: url_DrivePermissionsPatch_580836, schemes: {Scheme.Https})
type
  Call_DrivePermissionsDelete_580815 = ref object of OpenApiRestCall_579424
proc url_DrivePermissionsDelete_580817(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePermissionsDelete_580816(path: JsonNode; query: JsonNode;
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
  var valid_580818 = path.getOrDefault("fileId")
  valid_580818 = validateParameter(valid_580818, JString, required = true,
                                 default = nil)
  if valid_580818 != nil:
    section.add "fileId", valid_580818
  var valid_580819 = path.getOrDefault("permissionId")
  valid_580819 = validateParameter(valid_580819, JString, required = true,
                                 default = nil)
  if valid_580819 != nil:
    section.add "permissionId", valid_580819
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
  var valid_580820 = query.getOrDefault("supportsAllDrives")
  valid_580820 = validateParameter(valid_580820, JBool, required = false,
                                 default = newJBool(false))
  if valid_580820 != nil:
    section.add "supportsAllDrives", valid_580820
  var valid_580821 = query.getOrDefault("fields")
  valid_580821 = validateParameter(valid_580821, JString, required = false,
                                 default = nil)
  if valid_580821 != nil:
    section.add "fields", valid_580821
  var valid_580822 = query.getOrDefault("quotaUser")
  valid_580822 = validateParameter(valid_580822, JString, required = false,
                                 default = nil)
  if valid_580822 != nil:
    section.add "quotaUser", valid_580822
  var valid_580823 = query.getOrDefault("alt")
  valid_580823 = validateParameter(valid_580823, JString, required = false,
                                 default = newJString("json"))
  if valid_580823 != nil:
    section.add "alt", valid_580823
  var valid_580824 = query.getOrDefault("oauth_token")
  valid_580824 = validateParameter(valid_580824, JString, required = false,
                                 default = nil)
  if valid_580824 != nil:
    section.add "oauth_token", valid_580824
  var valid_580825 = query.getOrDefault("userIp")
  valid_580825 = validateParameter(valid_580825, JString, required = false,
                                 default = nil)
  if valid_580825 != nil:
    section.add "userIp", valid_580825
  var valid_580826 = query.getOrDefault("supportsTeamDrives")
  valid_580826 = validateParameter(valid_580826, JBool, required = false,
                                 default = newJBool(false))
  if valid_580826 != nil:
    section.add "supportsTeamDrives", valid_580826
  var valid_580827 = query.getOrDefault("key")
  valid_580827 = validateParameter(valid_580827, JString, required = false,
                                 default = nil)
  if valid_580827 != nil:
    section.add "key", valid_580827
  var valid_580828 = query.getOrDefault("useDomainAdminAccess")
  valid_580828 = validateParameter(valid_580828, JBool, required = false,
                                 default = newJBool(false))
  if valid_580828 != nil:
    section.add "useDomainAdminAccess", valid_580828
  var valid_580829 = query.getOrDefault("prettyPrint")
  valid_580829 = validateParameter(valid_580829, JBool, required = false,
                                 default = newJBool(true))
  if valid_580829 != nil:
    section.add "prettyPrint", valid_580829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580830: Call_DrivePermissionsDelete_580815; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a permission from a file or shared drive.
  ## 
  let valid = call_580830.validator(path, query, header, formData, body)
  let scheme = call_580830.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580830.url(scheme.get, call_580830.host, call_580830.base,
                         call_580830.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580830, url, valid)

proc call*(call_580831: Call_DrivePermissionsDelete_580815; fileId: string;
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
  var path_580832 = newJObject()
  var query_580833 = newJObject()
  add(query_580833, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580833, "fields", newJString(fields))
  add(query_580833, "quotaUser", newJString(quotaUser))
  add(path_580832, "fileId", newJString(fileId))
  add(query_580833, "alt", newJString(alt))
  add(query_580833, "oauth_token", newJString(oauthToken))
  add(path_580832, "permissionId", newJString(permissionId))
  add(query_580833, "userIp", newJString(userIp))
  add(query_580833, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580833, "key", newJString(key))
  add(query_580833, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580833, "prettyPrint", newJBool(prettyPrint))
  result = call_580831.call(path_580832, query_580833, nil, nil, nil)

var drivePermissionsDelete* = Call_DrivePermissionsDelete_580815(
    name: "drivePermissionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsDelete_580816, base: "/drive/v2",
    url: url_DrivePermissionsDelete_580817, schemes: {Scheme.Https})
type
  Call_DrivePropertiesInsert_580872 = ref object of OpenApiRestCall_579424
proc url_DrivePropertiesInsert_580874(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePropertiesInsert_580873(path: JsonNode; query: JsonNode;
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
  var valid_580875 = path.getOrDefault("fileId")
  valid_580875 = validateParameter(valid_580875, JString, required = true,
                                 default = nil)
  if valid_580875 != nil:
    section.add "fileId", valid_580875
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
  var valid_580876 = query.getOrDefault("fields")
  valid_580876 = validateParameter(valid_580876, JString, required = false,
                                 default = nil)
  if valid_580876 != nil:
    section.add "fields", valid_580876
  var valid_580877 = query.getOrDefault("quotaUser")
  valid_580877 = validateParameter(valid_580877, JString, required = false,
                                 default = nil)
  if valid_580877 != nil:
    section.add "quotaUser", valid_580877
  var valid_580878 = query.getOrDefault("alt")
  valid_580878 = validateParameter(valid_580878, JString, required = false,
                                 default = newJString("json"))
  if valid_580878 != nil:
    section.add "alt", valid_580878
  var valid_580879 = query.getOrDefault("oauth_token")
  valid_580879 = validateParameter(valid_580879, JString, required = false,
                                 default = nil)
  if valid_580879 != nil:
    section.add "oauth_token", valid_580879
  var valid_580880 = query.getOrDefault("userIp")
  valid_580880 = validateParameter(valid_580880, JString, required = false,
                                 default = nil)
  if valid_580880 != nil:
    section.add "userIp", valid_580880
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

proc call*(call_580884: Call_DrivePropertiesInsert_580872; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a property to a file, or updates it if it already exists.
  ## 
  let valid = call_580884.validator(path, query, header, formData, body)
  let scheme = call_580884.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580884.url(scheme.get, call_580884.host, call_580884.base,
                         call_580884.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580884, url, valid)

proc call*(call_580885: Call_DrivePropertiesInsert_580872; fileId: string;
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
  var path_580886 = newJObject()
  var query_580887 = newJObject()
  var body_580888 = newJObject()
  add(query_580887, "fields", newJString(fields))
  add(query_580887, "quotaUser", newJString(quotaUser))
  add(path_580886, "fileId", newJString(fileId))
  add(query_580887, "alt", newJString(alt))
  add(query_580887, "oauth_token", newJString(oauthToken))
  add(query_580887, "userIp", newJString(userIp))
  add(query_580887, "key", newJString(key))
  if body != nil:
    body_580888 = body
  add(query_580887, "prettyPrint", newJBool(prettyPrint))
  result = call_580885.call(path_580886, query_580887, nil, nil, body_580888)

var drivePropertiesInsert* = Call_DrivePropertiesInsert_580872(
    name: "drivePropertiesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/properties",
    validator: validate_DrivePropertiesInsert_580873, base: "/drive/v2",
    url: url_DrivePropertiesInsert_580874, schemes: {Scheme.Https})
type
  Call_DrivePropertiesList_580857 = ref object of OpenApiRestCall_579424
proc url_DrivePropertiesList_580859(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePropertiesList_580858(path: JsonNode; query: JsonNode;
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
  var valid_580860 = path.getOrDefault("fileId")
  valid_580860 = validateParameter(valid_580860, JString, required = true,
                                 default = nil)
  if valid_580860 != nil:
    section.add "fileId", valid_580860
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
  var valid_580861 = query.getOrDefault("fields")
  valid_580861 = validateParameter(valid_580861, JString, required = false,
                                 default = nil)
  if valid_580861 != nil:
    section.add "fields", valid_580861
  var valid_580862 = query.getOrDefault("quotaUser")
  valid_580862 = validateParameter(valid_580862, JString, required = false,
                                 default = nil)
  if valid_580862 != nil:
    section.add "quotaUser", valid_580862
  var valid_580863 = query.getOrDefault("alt")
  valid_580863 = validateParameter(valid_580863, JString, required = false,
                                 default = newJString("json"))
  if valid_580863 != nil:
    section.add "alt", valid_580863
  var valid_580864 = query.getOrDefault("oauth_token")
  valid_580864 = validateParameter(valid_580864, JString, required = false,
                                 default = nil)
  if valid_580864 != nil:
    section.add "oauth_token", valid_580864
  var valid_580865 = query.getOrDefault("userIp")
  valid_580865 = validateParameter(valid_580865, JString, required = false,
                                 default = nil)
  if valid_580865 != nil:
    section.add "userIp", valid_580865
  var valid_580866 = query.getOrDefault("key")
  valid_580866 = validateParameter(valid_580866, JString, required = false,
                                 default = nil)
  if valid_580866 != nil:
    section.add "key", valid_580866
  var valid_580867 = query.getOrDefault("prettyPrint")
  valid_580867 = validateParameter(valid_580867, JBool, required = false,
                                 default = newJBool(true))
  if valid_580867 != nil:
    section.add "prettyPrint", valid_580867
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580868: Call_DrivePropertiesList_580857; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's properties.
  ## 
  let valid = call_580868.validator(path, query, header, formData, body)
  let scheme = call_580868.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580868.url(scheme.get, call_580868.host, call_580868.base,
                         call_580868.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580868, url, valid)

proc call*(call_580869: Call_DrivePropertiesList_580857; fileId: string;
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
  var path_580870 = newJObject()
  var query_580871 = newJObject()
  add(query_580871, "fields", newJString(fields))
  add(query_580871, "quotaUser", newJString(quotaUser))
  add(path_580870, "fileId", newJString(fileId))
  add(query_580871, "alt", newJString(alt))
  add(query_580871, "oauth_token", newJString(oauthToken))
  add(query_580871, "userIp", newJString(userIp))
  add(query_580871, "key", newJString(key))
  add(query_580871, "prettyPrint", newJBool(prettyPrint))
  result = call_580869.call(path_580870, query_580871, nil, nil, nil)

var drivePropertiesList* = Call_DrivePropertiesList_580857(
    name: "drivePropertiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/properties",
    validator: validate_DrivePropertiesList_580858, base: "/drive/v2",
    url: url_DrivePropertiesList_580859, schemes: {Scheme.Https})
type
  Call_DrivePropertiesUpdate_580906 = ref object of OpenApiRestCall_579424
proc url_DrivePropertiesUpdate_580908(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePropertiesUpdate_580907(path: JsonNode; query: JsonNode;
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
  var valid_580909 = path.getOrDefault("fileId")
  valid_580909 = validateParameter(valid_580909, JString, required = true,
                                 default = nil)
  if valid_580909 != nil:
    section.add "fileId", valid_580909
  var valid_580910 = path.getOrDefault("propertyKey")
  valid_580910 = validateParameter(valid_580910, JString, required = true,
                                 default = nil)
  if valid_580910 != nil:
    section.add "propertyKey", valid_580910
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
  var valid_580911 = query.getOrDefault("fields")
  valid_580911 = validateParameter(valid_580911, JString, required = false,
                                 default = nil)
  if valid_580911 != nil:
    section.add "fields", valid_580911
  var valid_580912 = query.getOrDefault("quotaUser")
  valid_580912 = validateParameter(valid_580912, JString, required = false,
                                 default = nil)
  if valid_580912 != nil:
    section.add "quotaUser", valid_580912
  var valid_580913 = query.getOrDefault("alt")
  valid_580913 = validateParameter(valid_580913, JString, required = false,
                                 default = newJString("json"))
  if valid_580913 != nil:
    section.add "alt", valid_580913
  var valid_580914 = query.getOrDefault("oauth_token")
  valid_580914 = validateParameter(valid_580914, JString, required = false,
                                 default = nil)
  if valid_580914 != nil:
    section.add "oauth_token", valid_580914
  var valid_580915 = query.getOrDefault("userIp")
  valid_580915 = validateParameter(valid_580915, JString, required = false,
                                 default = nil)
  if valid_580915 != nil:
    section.add "userIp", valid_580915
  var valid_580916 = query.getOrDefault("key")
  valid_580916 = validateParameter(valid_580916, JString, required = false,
                                 default = nil)
  if valid_580916 != nil:
    section.add "key", valid_580916
  var valid_580917 = query.getOrDefault("prettyPrint")
  valid_580917 = validateParameter(valid_580917, JBool, required = false,
                                 default = newJBool(true))
  if valid_580917 != nil:
    section.add "prettyPrint", valid_580917
  var valid_580918 = query.getOrDefault("visibility")
  valid_580918 = validateParameter(valid_580918, JString, required = false,
                                 default = newJString("private"))
  if valid_580918 != nil:
    section.add "visibility", valid_580918
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

proc call*(call_580920: Call_DrivePropertiesUpdate_580906; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a property.
  ## 
  let valid = call_580920.validator(path, query, header, formData, body)
  let scheme = call_580920.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580920.url(scheme.get, call_580920.host, call_580920.base,
                         call_580920.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580920, url, valid)

proc call*(call_580921: Call_DrivePropertiesUpdate_580906; fileId: string;
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
  var path_580922 = newJObject()
  var query_580923 = newJObject()
  var body_580924 = newJObject()
  add(query_580923, "fields", newJString(fields))
  add(query_580923, "quotaUser", newJString(quotaUser))
  add(path_580922, "fileId", newJString(fileId))
  add(query_580923, "alt", newJString(alt))
  add(query_580923, "oauth_token", newJString(oauthToken))
  add(query_580923, "userIp", newJString(userIp))
  add(query_580923, "key", newJString(key))
  add(path_580922, "propertyKey", newJString(propertyKey))
  if body != nil:
    body_580924 = body
  add(query_580923, "prettyPrint", newJBool(prettyPrint))
  add(query_580923, "visibility", newJString(visibility))
  result = call_580921.call(path_580922, query_580923, nil, nil, body_580924)

var drivePropertiesUpdate* = Call_DrivePropertiesUpdate_580906(
    name: "drivePropertiesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/files/{fileId}/properties/{propertyKey}",
    validator: validate_DrivePropertiesUpdate_580907, base: "/drive/v2",
    url: url_DrivePropertiesUpdate_580908, schemes: {Scheme.Https})
type
  Call_DrivePropertiesGet_580889 = ref object of OpenApiRestCall_579424
proc url_DrivePropertiesGet_580891(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePropertiesGet_580890(path: JsonNode; query: JsonNode;
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
  var valid_580892 = path.getOrDefault("fileId")
  valid_580892 = validateParameter(valid_580892, JString, required = true,
                                 default = nil)
  if valid_580892 != nil:
    section.add "fileId", valid_580892
  var valid_580893 = path.getOrDefault("propertyKey")
  valid_580893 = validateParameter(valid_580893, JString, required = true,
                                 default = nil)
  if valid_580893 != nil:
    section.add "propertyKey", valid_580893
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
  var valid_580894 = query.getOrDefault("fields")
  valid_580894 = validateParameter(valid_580894, JString, required = false,
                                 default = nil)
  if valid_580894 != nil:
    section.add "fields", valid_580894
  var valid_580895 = query.getOrDefault("quotaUser")
  valid_580895 = validateParameter(valid_580895, JString, required = false,
                                 default = nil)
  if valid_580895 != nil:
    section.add "quotaUser", valid_580895
  var valid_580896 = query.getOrDefault("alt")
  valid_580896 = validateParameter(valid_580896, JString, required = false,
                                 default = newJString("json"))
  if valid_580896 != nil:
    section.add "alt", valid_580896
  var valid_580897 = query.getOrDefault("oauth_token")
  valid_580897 = validateParameter(valid_580897, JString, required = false,
                                 default = nil)
  if valid_580897 != nil:
    section.add "oauth_token", valid_580897
  var valid_580898 = query.getOrDefault("userIp")
  valid_580898 = validateParameter(valid_580898, JString, required = false,
                                 default = nil)
  if valid_580898 != nil:
    section.add "userIp", valid_580898
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
  var valid_580901 = query.getOrDefault("visibility")
  valid_580901 = validateParameter(valid_580901, JString, required = false,
                                 default = newJString("private"))
  if valid_580901 != nil:
    section.add "visibility", valid_580901
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580902: Call_DrivePropertiesGet_580889; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a property by its key.
  ## 
  let valid = call_580902.validator(path, query, header, formData, body)
  let scheme = call_580902.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580902.url(scheme.get, call_580902.host, call_580902.base,
                         call_580902.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580902, url, valid)

proc call*(call_580903: Call_DrivePropertiesGet_580889; fileId: string;
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
  var path_580904 = newJObject()
  var query_580905 = newJObject()
  add(query_580905, "fields", newJString(fields))
  add(query_580905, "quotaUser", newJString(quotaUser))
  add(path_580904, "fileId", newJString(fileId))
  add(query_580905, "alt", newJString(alt))
  add(query_580905, "oauth_token", newJString(oauthToken))
  add(query_580905, "userIp", newJString(userIp))
  add(query_580905, "key", newJString(key))
  add(path_580904, "propertyKey", newJString(propertyKey))
  add(query_580905, "prettyPrint", newJBool(prettyPrint))
  add(query_580905, "visibility", newJString(visibility))
  result = call_580903.call(path_580904, query_580905, nil, nil, nil)

var drivePropertiesGet* = Call_DrivePropertiesGet_580889(
    name: "drivePropertiesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/properties/{propertyKey}",
    validator: validate_DrivePropertiesGet_580890, base: "/drive/v2",
    url: url_DrivePropertiesGet_580891, schemes: {Scheme.Https})
type
  Call_DrivePropertiesPatch_580942 = ref object of OpenApiRestCall_579424
proc url_DrivePropertiesPatch_580944(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePropertiesPatch_580943(path: JsonNode; query: JsonNode;
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
  var valid_580945 = path.getOrDefault("fileId")
  valid_580945 = validateParameter(valid_580945, JString, required = true,
                                 default = nil)
  if valid_580945 != nil:
    section.add "fileId", valid_580945
  var valid_580946 = path.getOrDefault("propertyKey")
  valid_580946 = validateParameter(valid_580946, JString, required = true,
                                 default = nil)
  if valid_580946 != nil:
    section.add "propertyKey", valid_580946
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
  var valid_580947 = query.getOrDefault("fields")
  valid_580947 = validateParameter(valid_580947, JString, required = false,
                                 default = nil)
  if valid_580947 != nil:
    section.add "fields", valid_580947
  var valid_580948 = query.getOrDefault("quotaUser")
  valid_580948 = validateParameter(valid_580948, JString, required = false,
                                 default = nil)
  if valid_580948 != nil:
    section.add "quotaUser", valid_580948
  var valid_580949 = query.getOrDefault("alt")
  valid_580949 = validateParameter(valid_580949, JString, required = false,
                                 default = newJString("json"))
  if valid_580949 != nil:
    section.add "alt", valid_580949
  var valid_580950 = query.getOrDefault("oauth_token")
  valid_580950 = validateParameter(valid_580950, JString, required = false,
                                 default = nil)
  if valid_580950 != nil:
    section.add "oauth_token", valid_580950
  var valid_580951 = query.getOrDefault("userIp")
  valid_580951 = validateParameter(valid_580951, JString, required = false,
                                 default = nil)
  if valid_580951 != nil:
    section.add "userIp", valid_580951
  var valid_580952 = query.getOrDefault("key")
  valid_580952 = validateParameter(valid_580952, JString, required = false,
                                 default = nil)
  if valid_580952 != nil:
    section.add "key", valid_580952
  var valid_580953 = query.getOrDefault("prettyPrint")
  valid_580953 = validateParameter(valid_580953, JBool, required = false,
                                 default = newJBool(true))
  if valid_580953 != nil:
    section.add "prettyPrint", valid_580953
  var valid_580954 = query.getOrDefault("visibility")
  valid_580954 = validateParameter(valid_580954, JString, required = false,
                                 default = newJString("private"))
  if valid_580954 != nil:
    section.add "visibility", valid_580954
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

proc call*(call_580956: Call_DrivePropertiesPatch_580942; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a property.
  ## 
  let valid = call_580956.validator(path, query, header, formData, body)
  let scheme = call_580956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580956.url(scheme.get, call_580956.host, call_580956.base,
                         call_580956.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580956, url, valid)

proc call*(call_580957: Call_DrivePropertiesPatch_580942; fileId: string;
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
  var path_580958 = newJObject()
  var query_580959 = newJObject()
  var body_580960 = newJObject()
  add(query_580959, "fields", newJString(fields))
  add(query_580959, "quotaUser", newJString(quotaUser))
  add(path_580958, "fileId", newJString(fileId))
  add(query_580959, "alt", newJString(alt))
  add(query_580959, "oauth_token", newJString(oauthToken))
  add(query_580959, "userIp", newJString(userIp))
  add(query_580959, "key", newJString(key))
  add(path_580958, "propertyKey", newJString(propertyKey))
  if body != nil:
    body_580960 = body
  add(query_580959, "prettyPrint", newJBool(prettyPrint))
  add(query_580959, "visibility", newJString(visibility))
  result = call_580957.call(path_580958, query_580959, nil, nil, body_580960)

var drivePropertiesPatch* = Call_DrivePropertiesPatch_580942(
    name: "drivePropertiesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/files/{fileId}/properties/{propertyKey}",
    validator: validate_DrivePropertiesPatch_580943, base: "/drive/v2",
    url: url_DrivePropertiesPatch_580944, schemes: {Scheme.Https})
type
  Call_DrivePropertiesDelete_580925 = ref object of OpenApiRestCall_579424
proc url_DrivePropertiesDelete_580927(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePropertiesDelete_580926(path: JsonNode; query: JsonNode;
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
  var valid_580928 = path.getOrDefault("fileId")
  valid_580928 = validateParameter(valid_580928, JString, required = true,
                                 default = nil)
  if valid_580928 != nil:
    section.add "fileId", valid_580928
  var valid_580929 = path.getOrDefault("propertyKey")
  valid_580929 = validateParameter(valid_580929, JString, required = true,
                                 default = nil)
  if valid_580929 != nil:
    section.add "propertyKey", valid_580929
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
  var valid_580930 = query.getOrDefault("fields")
  valid_580930 = validateParameter(valid_580930, JString, required = false,
                                 default = nil)
  if valid_580930 != nil:
    section.add "fields", valid_580930
  var valid_580931 = query.getOrDefault("quotaUser")
  valid_580931 = validateParameter(valid_580931, JString, required = false,
                                 default = nil)
  if valid_580931 != nil:
    section.add "quotaUser", valid_580931
  var valid_580932 = query.getOrDefault("alt")
  valid_580932 = validateParameter(valid_580932, JString, required = false,
                                 default = newJString("json"))
  if valid_580932 != nil:
    section.add "alt", valid_580932
  var valid_580933 = query.getOrDefault("oauth_token")
  valid_580933 = validateParameter(valid_580933, JString, required = false,
                                 default = nil)
  if valid_580933 != nil:
    section.add "oauth_token", valid_580933
  var valid_580934 = query.getOrDefault("userIp")
  valid_580934 = validateParameter(valid_580934, JString, required = false,
                                 default = nil)
  if valid_580934 != nil:
    section.add "userIp", valid_580934
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
  var valid_580937 = query.getOrDefault("visibility")
  valid_580937 = validateParameter(valid_580937, JString, required = false,
                                 default = newJString("private"))
  if valid_580937 != nil:
    section.add "visibility", valid_580937
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580938: Call_DrivePropertiesDelete_580925; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a property.
  ## 
  let valid = call_580938.validator(path, query, header, formData, body)
  let scheme = call_580938.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580938.url(scheme.get, call_580938.host, call_580938.base,
                         call_580938.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580938, url, valid)

proc call*(call_580939: Call_DrivePropertiesDelete_580925; fileId: string;
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
  var path_580940 = newJObject()
  var query_580941 = newJObject()
  add(query_580941, "fields", newJString(fields))
  add(query_580941, "quotaUser", newJString(quotaUser))
  add(path_580940, "fileId", newJString(fileId))
  add(query_580941, "alt", newJString(alt))
  add(query_580941, "oauth_token", newJString(oauthToken))
  add(query_580941, "userIp", newJString(userIp))
  add(query_580941, "key", newJString(key))
  add(path_580940, "propertyKey", newJString(propertyKey))
  add(query_580941, "prettyPrint", newJBool(prettyPrint))
  add(query_580941, "visibility", newJString(visibility))
  result = call_580939.call(path_580940, query_580941, nil, nil, nil)

var drivePropertiesDelete* = Call_DrivePropertiesDelete_580925(
    name: "drivePropertiesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/properties/{propertyKey}",
    validator: validate_DrivePropertiesDelete_580926, base: "/drive/v2",
    url: url_DrivePropertiesDelete_580927, schemes: {Scheme.Https})
type
  Call_DriveRealtimeUpdate_580977 = ref object of OpenApiRestCall_579424
proc url_DriveRealtimeUpdate_580979(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRealtimeUpdate_580978(path: JsonNode; query: JsonNode;
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
  var valid_580980 = path.getOrDefault("fileId")
  valid_580980 = validateParameter(valid_580980, JString, required = true,
                                 default = nil)
  if valid_580980 != nil:
    section.add "fileId", valid_580980
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
  var valid_580981 = query.getOrDefault("fields")
  valid_580981 = validateParameter(valid_580981, JString, required = false,
                                 default = nil)
  if valid_580981 != nil:
    section.add "fields", valid_580981
  var valid_580982 = query.getOrDefault("quotaUser")
  valid_580982 = validateParameter(valid_580982, JString, required = false,
                                 default = nil)
  if valid_580982 != nil:
    section.add "quotaUser", valid_580982
  var valid_580983 = query.getOrDefault("alt")
  valid_580983 = validateParameter(valid_580983, JString, required = false,
                                 default = newJString("json"))
  if valid_580983 != nil:
    section.add "alt", valid_580983
  var valid_580984 = query.getOrDefault("oauth_token")
  valid_580984 = validateParameter(valid_580984, JString, required = false,
                                 default = nil)
  if valid_580984 != nil:
    section.add "oauth_token", valid_580984
  var valid_580985 = query.getOrDefault("baseRevision")
  valid_580985 = validateParameter(valid_580985, JString, required = false,
                                 default = nil)
  if valid_580985 != nil:
    section.add "baseRevision", valid_580985
  var valid_580986 = query.getOrDefault("userIp")
  valid_580986 = validateParameter(valid_580986, JString, required = false,
                                 default = nil)
  if valid_580986 != nil:
    section.add "userIp", valid_580986
  var valid_580987 = query.getOrDefault("key")
  valid_580987 = validateParameter(valid_580987, JString, required = false,
                                 default = nil)
  if valid_580987 != nil:
    section.add "key", valid_580987
  var valid_580988 = query.getOrDefault("prettyPrint")
  valid_580988 = validateParameter(valid_580988, JBool, required = false,
                                 default = newJBool(true))
  if valid_580988 != nil:
    section.add "prettyPrint", valid_580988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580989: Call_DriveRealtimeUpdate_580977; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Overwrites the Realtime API data model associated with this file with the provided JSON data model.
  ## 
  let valid = call_580989.validator(path, query, header, formData, body)
  let scheme = call_580989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580989.url(scheme.get, call_580989.host, call_580989.base,
                         call_580989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580989, url, valid)

proc call*(call_580990: Call_DriveRealtimeUpdate_580977; fileId: string;
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
  var path_580991 = newJObject()
  var query_580992 = newJObject()
  add(query_580992, "fields", newJString(fields))
  add(query_580992, "quotaUser", newJString(quotaUser))
  add(path_580991, "fileId", newJString(fileId))
  add(query_580992, "alt", newJString(alt))
  add(query_580992, "oauth_token", newJString(oauthToken))
  add(query_580992, "baseRevision", newJString(baseRevision))
  add(query_580992, "userIp", newJString(userIp))
  add(query_580992, "key", newJString(key))
  add(query_580992, "prettyPrint", newJBool(prettyPrint))
  result = call_580990.call(path_580991, query_580992, nil, nil, nil)

var driveRealtimeUpdate* = Call_DriveRealtimeUpdate_580977(
    name: "driveRealtimeUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/files/{fileId}/realtime",
    validator: validate_DriveRealtimeUpdate_580978, base: "/drive/v2",
    url: url_DriveRealtimeUpdate_580979, schemes: {Scheme.Https})
type
  Call_DriveRealtimeGet_580961 = ref object of OpenApiRestCall_579424
proc url_DriveRealtimeGet_580963(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRealtimeGet_580962(path: JsonNode; query: JsonNode;
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
  var valid_580964 = path.getOrDefault("fileId")
  valid_580964 = validateParameter(valid_580964, JString, required = true,
                                 default = nil)
  if valid_580964 != nil:
    section.add "fileId", valid_580964
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
  var valid_580965 = query.getOrDefault("fields")
  valid_580965 = validateParameter(valid_580965, JString, required = false,
                                 default = nil)
  if valid_580965 != nil:
    section.add "fields", valid_580965
  var valid_580966 = query.getOrDefault("quotaUser")
  valid_580966 = validateParameter(valid_580966, JString, required = false,
                                 default = nil)
  if valid_580966 != nil:
    section.add "quotaUser", valid_580966
  var valid_580967 = query.getOrDefault("alt")
  valid_580967 = validateParameter(valid_580967, JString, required = false,
                                 default = newJString("json"))
  if valid_580967 != nil:
    section.add "alt", valid_580967
  var valid_580968 = query.getOrDefault("oauth_token")
  valid_580968 = validateParameter(valid_580968, JString, required = false,
                                 default = nil)
  if valid_580968 != nil:
    section.add "oauth_token", valid_580968
  var valid_580969 = query.getOrDefault("userIp")
  valid_580969 = validateParameter(valid_580969, JString, required = false,
                                 default = nil)
  if valid_580969 != nil:
    section.add "userIp", valid_580969
  var valid_580970 = query.getOrDefault("revision")
  valid_580970 = validateParameter(valid_580970, JInt, required = false, default = nil)
  if valid_580970 != nil:
    section.add "revision", valid_580970
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580973: Call_DriveRealtimeGet_580961; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports the contents of the Realtime API data model associated with this file as JSON.
  ## 
  let valid = call_580973.validator(path, query, header, formData, body)
  let scheme = call_580973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580973.url(scheme.get, call_580973.host, call_580973.base,
                         call_580973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580973, url, valid)

proc call*(call_580974: Call_DriveRealtimeGet_580961; fileId: string;
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
  var path_580975 = newJObject()
  var query_580976 = newJObject()
  add(query_580976, "fields", newJString(fields))
  add(query_580976, "quotaUser", newJString(quotaUser))
  add(path_580975, "fileId", newJString(fileId))
  add(query_580976, "alt", newJString(alt))
  add(query_580976, "oauth_token", newJString(oauthToken))
  add(query_580976, "userIp", newJString(userIp))
  add(query_580976, "revision", newJInt(revision))
  add(query_580976, "key", newJString(key))
  add(query_580976, "prettyPrint", newJBool(prettyPrint))
  result = call_580974.call(path_580975, query_580976, nil, nil, nil)

var driveRealtimeGet* = Call_DriveRealtimeGet_580961(name: "driveRealtimeGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/realtime", validator: validate_DriveRealtimeGet_580962,
    base: "/drive/v2", url: url_DriveRealtimeGet_580963, schemes: {Scheme.Https})
type
  Call_DriveRevisionsList_580993 = ref object of OpenApiRestCall_579424
proc url_DriveRevisionsList_580995(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRevisionsList_580994(path: JsonNode; query: JsonNode;
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
  var valid_580996 = path.getOrDefault("fileId")
  valid_580996 = validateParameter(valid_580996, JString, required = true,
                                 default = nil)
  if valid_580996 != nil:
    section.add "fileId", valid_580996
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
  var valid_580997 = query.getOrDefault("fields")
  valid_580997 = validateParameter(valid_580997, JString, required = false,
                                 default = nil)
  if valid_580997 != nil:
    section.add "fields", valid_580997
  var valid_580998 = query.getOrDefault("pageToken")
  valid_580998 = validateParameter(valid_580998, JString, required = false,
                                 default = nil)
  if valid_580998 != nil:
    section.add "pageToken", valid_580998
  var valid_580999 = query.getOrDefault("quotaUser")
  valid_580999 = validateParameter(valid_580999, JString, required = false,
                                 default = nil)
  if valid_580999 != nil:
    section.add "quotaUser", valid_580999
  var valid_581000 = query.getOrDefault("alt")
  valid_581000 = validateParameter(valid_581000, JString, required = false,
                                 default = newJString("json"))
  if valid_581000 != nil:
    section.add "alt", valid_581000
  var valid_581001 = query.getOrDefault("oauth_token")
  valid_581001 = validateParameter(valid_581001, JString, required = false,
                                 default = nil)
  if valid_581001 != nil:
    section.add "oauth_token", valid_581001
  var valid_581002 = query.getOrDefault("userIp")
  valid_581002 = validateParameter(valid_581002, JString, required = false,
                                 default = nil)
  if valid_581002 != nil:
    section.add "userIp", valid_581002
  var valid_581003 = query.getOrDefault("maxResults")
  valid_581003 = validateParameter(valid_581003, JInt, required = false,
                                 default = newJInt(200))
  if valid_581003 != nil:
    section.add "maxResults", valid_581003
  var valid_581004 = query.getOrDefault("key")
  valid_581004 = validateParameter(valid_581004, JString, required = false,
                                 default = nil)
  if valid_581004 != nil:
    section.add "key", valid_581004
  var valid_581005 = query.getOrDefault("prettyPrint")
  valid_581005 = validateParameter(valid_581005, JBool, required = false,
                                 default = newJBool(true))
  if valid_581005 != nil:
    section.add "prettyPrint", valid_581005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581006: Call_DriveRevisionsList_580993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's revisions.
  ## 
  let valid = call_581006.validator(path, query, header, formData, body)
  let scheme = call_581006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581006.url(scheme.get, call_581006.host, call_581006.base,
                         call_581006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581006, url, valid)

proc call*(call_581007: Call_DriveRevisionsList_580993; fileId: string;
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
  var path_581008 = newJObject()
  var query_581009 = newJObject()
  add(query_581009, "fields", newJString(fields))
  add(query_581009, "pageToken", newJString(pageToken))
  add(query_581009, "quotaUser", newJString(quotaUser))
  add(path_581008, "fileId", newJString(fileId))
  add(query_581009, "alt", newJString(alt))
  add(query_581009, "oauth_token", newJString(oauthToken))
  add(query_581009, "userIp", newJString(userIp))
  add(query_581009, "maxResults", newJInt(maxResults))
  add(query_581009, "key", newJString(key))
  add(query_581009, "prettyPrint", newJBool(prettyPrint))
  result = call_581007.call(path_581008, query_581009, nil, nil, nil)

var driveRevisionsList* = Call_DriveRevisionsList_580993(
    name: "driveRevisionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions",
    validator: validate_DriveRevisionsList_580994, base: "/drive/v2",
    url: url_DriveRevisionsList_580995, schemes: {Scheme.Https})
type
  Call_DriveRevisionsUpdate_581026 = ref object of OpenApiRestCall_579424
proc url_DriveRevisionsUpdate_581028(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRevisionsUpdate_581027(path: JsonNode; query: JsonNode;
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
  var valid_581029 = path.getOrDefault("fileId")
  valid_581029 = validateParameter(valid_581029, JString, required = true,
                                 default = nil)
  if valid_581029 != nil:
    section.add "fileId", valid_581029
  var valid_581030 = path.getOrDefault("revisionId")
  valid_581030 = validateParameter(valid_581030, JString, required = true,
                                 default = nil)
  if valid_581030 != nil:
    section.add "revisionId", valid_581030
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
  var valid_581031 = query.getOrDefault("fields")
  valid_581031 = validateParameter(valid_581031, JString, required = false,
                                 default = nil)
  if valid_581031 != nil:
    section.add "fields", valid_581031
  var valid_581032 = query.getOrDefault("quotaUser")
  valid_581032 = validateParameter(valid_581032, JString, required = false,
                                 default = nil)
  if valid_581032 != nil:
    section.add "quotaUser", valid_581032
  var valid_581033 = query.getOrDefault("alt")
  valid_581033 = validateParameter(valid_581033, JString, required = false,
                                 default = newJString("json"))
  if valid_581033 != nil:
    section.add "alt", valid_581033
  var valid_581034 = query.getOrDefault("oauth_token")
  valid_581034 = validateParameter(valid_581034, JString, required = false,
                                 default = nil)
  if valid_581034 != nil:
    section.add "oauth_token", valid_581034
  var valid_581035 = query.getOrDefault("userIp")
  valid_581035 = validateParameter(valid_581035, JString, required = false,
                                 default = nil)
  if valid_581035 != nil:
    section.add "userIp", valid_581035
  var valid_581036 = query.getOrDefault("key")
  valid_581036 = validateParameter(valid_581036, JString, required = false,
                                 default = nil)
  if valid_581036 != nil:
    section.add "key", valid_581036
  var valid_581037 = query.getOrDefault("prettyPrint")
  valid_581037 = validateParameter(valid_581037, JBool, required = false,
                                 default = newJBool(true))
  if valid_581037 != nil:
    section.add "prettyPrint", valid_581037
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

proc call*(call_581039: Call_DriveRevisionsUpdate_581026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a revision.
  ## 
  let valid = call_581039.validator(path, query, header, formData, body)
  let scheme = call_581039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581039.url(scheme.get, call_581039.host, call_581039.base,
                         call_581039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581039, url, valid)

proc call*(call_581040: Call_DriveRevisionsUpdate_581026; fileId: string;
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
  var path_581041 = newJObject()
  var query_581042 = newJObject()
  var body_581043 = newJObject()
  add(query_581042, "fields", newJString(fields))
  add(query_581042, "quotaUser", newJString(quotaUser))
  add(path_581041, "fileId", newJString(fileId))
  add(query_581042, "alt", newJString(alt))
  add(query_581042, "oauth_token", newJString(oauthToken))
  add(path_581041, "revisionId", newJString(revisionId))
  add(query_581042, "userIp", newJString(userIp))
  add(query_581042, "key", newJString(key))
  if body != nil:
    body_581043 = body
  add(query_581042, "prettyPrint", newJBool(prettyPrint))
  result = call_581040.call(path_581041, query_581042, nil, nil, body_581043)

var driveRevisionsUpdate* = Call_DriveRevisionsUpdate_581026(
    name: "driveRevisionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsUpdate_581027, base: "/drive/v2",
    url: url_DriveRevisionsUpdate_581028, schemes: {Scheme.Https})
type
  Call_DriveRevisionsGet_581010 = ref object of OpenApiRestCall_579424
proc url_DriveRevisionsGet_581012(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRevisionsGet_581011(path: JsonNode; query: JsonNode;
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
  var valid_581013 = path.getOrDefault("fileId")
  valid_581013 = validateParameter(valid_581013, JString, required = true,
                                 default = nil)
  if valid_581013 != nil:
    section.add "fileId", valid_581013
  var valid_581014 = path.getOrDefault("revisionId")
  valid_581014 = validateParameter(valid_581014, JString, required = true,
                                 default = nil)
  if valid_581014 != nil:
    section.add "revisionId", valid_581014
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
  var valid_581015 = query.getOrDefault("fields")
  valid_581015 = validateParameter(valid_581015, JString, required = false,
                                 default = nil)
  if valid_581015 != nil:
    section.add "fields", valid_581015
  var valid_581016 = query.getOrDefault("quotaUser")
  valid_581016 = validateParameter(valid_581016, JString, required = false,
                                 default = nil)
  if valid_581016 != nil:
    section.add "quotaUser", valid_581016
  var valid_581017 = query.getOrDefault("alt")
  valid_581017 = validateParameter(valid_581017, JString, required = false,
                                 default = newJString("json"))
  if valid_581017 != nil:
    section.add "alt", valid_581017
  var valid_581018 = query.getOrDefault("oauth_token")
  valid_581018 = validateParameter(valid_581018, JString, required = false,
                                 default = nil)
  if valid_581018 != nil:
    section.add "oauth_token", valid_581018
  var valid_581019 = query.getOrDefault("userIp")
  valid_581019 = validateParameter(valid_581019, JString, required = false,
                                 default = nil)
  if valid_581019 != nil:
    section.add "userIp", valid_581019
  var valid_581020 = query.getOrDefault("key")
  valid_581020 = validateParameter(valid_581020, JString, required = false,
                                 default = nil)
  if valid_581020 != nil:
    section.add "key", valid_581020
  var valid_581021 = query.getOrDefault("prettyPrint")
  valid_581021 = validateParameter(valid_581021, JBool, required = false,
                                 default = newJBool(true))
  if valid_581021 != nil:
    section.add "prettyPrint", valid_581021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581022: Call_DriveRevisionsGet_581010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific revision.
  ## 
  let valid = call_581022.validator(path, query, header, formData, body)
  let scheme = call_581022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581022.url(scheme.get, call_581022.host, call_581022.base,
                         call_581022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581022, url, valid)

proc call*(call_581023: Call_DriveRevisionsGet_581010; fileId: string;
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
  var path_581024 = newJObject()
  var query_581025 = newJObject()
  add(query_581025, "fields", newJString(fields))
  add(query_581025, "quotaUser", newJString(quotaUser))
  add(path_581024, "fileId", newJString(fileId))
  add(query_581025, "alt", newJString(alt))
  add(query_581025, "oauth_token", newJString(oauthToken))
  add(path_581024, "revisionId", newJString(revisionId))
  add(query_581025, "userIp", newJString(userIp))
  add(query_581025, "key", newJString(key))
  add(query_581025, "prettyPrint", newJBool(prettyPrint))
  result = call_581023.call(path_581024, query_581025, nil, nil, nil)

var driveRevisionsGet* = Call_DriveRevisionsGet_581010(name: "driveRevisionsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsGet_581011, base: "/drive/v2",
    url: url_DriveRevisionsGet_581012, schemes: {Scheme.Https})
type
  Call_DriveRevisionsPatch_581060 = ref object of OpenApiRestCall_579424
proc url_DriveRevisionsPatch_581062(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRevisionsPatch_581061(path: JsonNode; query: JsonNode;
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
  var valid_581063 = path.getOrDefault("fileId")
  valid_581063 = validateParameter(valid_581063, JString, required = true,
                                 default = nil)
  if valid_581063 != nil:
    section.add "fileId", valid_581063
  var valid_581064 = path.getOrDefault("revisionId")
  valid_581064 = validateParameter(valid_581064, JString, required = true,
                                 default = nil)
  if valid_581064 != nil:
    section.add "revisionId", valid_581064
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
  var valid_581065 = query.getOrDefault("fields")
  valid_581065 = validateParameter(valid_581065, JString, required = false,
                                 default = nil)
  if valid_581065 != nil:
    section.add "fields", valid_581065
  var valid_581066 = query.getOrDefault("quotaUser")
  valid_581066 = validateParameter(valid_581066, JString, required = false,
                                 default = nil)
  if valid_581066 != nil:
    section.add "quotaUser", valid_581066
  var valid_581067 = query.getOrDefault("alt")
  valid_581067 = validateParameter(valid_581067, JString, required = false,
                                 default = newJString("json"))
  if valid_581067 != nil:
    section.add "alt", valid_581067
  var valid_581068 = query.getOrDefault("oauth_token")
  valid_581068 = validateParameter(valid_581068, JString, required = false,
                                 default = nil)
  if valid_581068 != nil:
    section.add "oauth_token", valid_581068
  var valid_581069 = query.getOrDefault("userIp")
  valid_581069 = validateParameter(valid_581069, JString, required = false,
                                 default = nil)
  if valid_581069 != nil:
    section.add "userIp", valid_581069
  var valid_581070 = query.getOrDefault("key")
  valid_581070 = validateParameter(valid_581070, JString, required = false,
                                 default = nil)
  if valid_581070 != nil:
    section.add "key", valid_581070
  var valid_581071 = query.getOrDefault("prettyPrint")
  valid_581071 = validateParameter(valid_581071, JBool, required = false,
                                 default = newJBool(true))
  if valid_581071 != nil:
    section.add "prettyPrint", valid_581071
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

proc call*(call_581073: Call_DriveRevisionsPatch_581060; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a revision. This method supports patch semantics.
  ## 
  let valid = call_581073.validator(path, query, header, formData, body)
  let scheme = call_581073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581073.url(scheme.get, call_581073.host, call_581073.base,
                         call_581073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581073, url, valid)

proc call*(call_581074: Call_DriveRevisionsPatch_581060; fileId: string;
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
  var path_581075 = newJObject()
  var query_581076 = newJObject()
  var body_581077 = newJObject()
  add(query_581076, "fields", newJString(fields))
  add(query_581076, "quotaUser", newJString(quotaUser))
  add(path_581075, "fileId", newJString(fileId))
  add(query_581076, "alt", newJString(alt))
  add(query_581076, "oauth_token", newJString(oauthToken))
  add(path_581075, "revisionId", newJString(revisionId))
  add(query_581076, "userIp", newJString(userIp))
  add(query_581076, "key", newJString(key))
  if body != nil:
    body_581077 = body
  add(query_581076, "prettyPrint", newJBool(prettyPrint))
  result = call_581074.call(path_581075, query_581076, nil, nil, body_581077)

var driveRevisionsPatch* = Call_DriveRevisionsPatch_581060(
    name: "driveRevisionsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsPatch_581061, base: "/drive/v2",
    url: url_DriveRevisionsPatch_581062, schemes: {Scheme.Https})
type
  Call_DriveRevisionsDelete_581044 = ref object of OpenApiRestCall_579424
proc url_DriveRevisionsDelete_581046(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRevisionsDelete_581045(path: JsonNode; query: JsonNode;
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
  var valid_581047 = path.getOrDefault("fileId")
  valid_581047 = validateParameter(valid_581047, JString, required = true,
                                 default = nil)
  if valid_581047 != nil:
    section.add "fileId", valid_581047
  var valid_581048 = path.getOrDefault("revisionId")
  valid_581048 = validateParameter(valid_581048, JString, required = true,
                                 default = nil)
  if valid_581048 != nil:
    section.add "revisionId", valid_581048
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
  var valid_581049 = query.getOrDefault("fields")
  valid_581049 = validateParameter(valid_581049, JString, required = false,
                                 default = nil)
  if valid_581049 != nil:
    section.add "fields", valid_581049
  var valid_581050 = query.getOrDefault("quotaUser")
  valid_581050 = validateParameter(valid_581050, JString, required = false,
                                 default = nil)
  if valid_581050 != nil:
    section.add "quotaUser", valid_581050
  var valid_581051 = query.getOrDefault("alt")
  valid_581051 = validateParameter(valid_581051, JString, required = false,
                                 default = newJString("json"))
  if valid_581051 != nil:
    section.add "alt", valid_581051
  var valid_581052 = query.getOrDefault("oauth_token")
  valid_581052 = validateParameter(valid_581052, JString, required = false,
                                 default = nil)
  if valid_581052 != nil:
    section.add "oauth_token", valid_581052
  var valid_581053 = query.getOrDefault("userIp")
  valid_581053 = validateParameter(valid_581053, JString, required = false,
                                 default = nil)
  if valid_581053 != nil:
    section.add "userIp", valid_581053
  var valid_581054 = query.getOrDefault("key")
  valid_581054 = validateParameter(valid_581054, JString, required = false,
                                 default = nil)
  if valid_581054 != nil:
    section.add "key", valid_581054
  var valid_581055 = query.getOrDefault("prettyPrint")
  valid_581055 = validateParameter(valid_581055, JBool, required = false,
                                 default = newJBool(true))
  if valid_581055 != nil:
    section.add "prettyPrint", valid_581055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581056: Call_DriveRevisionsDelete_581044; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a file version. You can only delete revisions for files with binary content, like images or videos. Revisions for other files, like Google Docs or Sheets, and the last remaining file version can't be deleted.
  ## 
  let valid = call_581056.validator(path, query, header, formData, body)
  let scheme = call_581056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581056.url(scheme.get, call_581056.host, call_581056.base,
                         call_581056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581056, url, valid)

proc call*(call_581057: Call_DriveRevisionsDelete_581044; fileId: string;
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
  var path_581058 = newJObject()
  var query_581059 = newJObject()
  add(query_581059, "fields", newJString(fields))
  add(query_581059, "quotaUser", newJString(quotaUser))
  add(path_581058, "fileId", newJString(fileId))
  add(query_581059, "alt", newJString(alt))
  add(query_581059, "oauth_token", newJString(oauthToken))
  add(path_581058, "revisionId", newJString(revisionId))
  add(query_581059, "userIp", newJString(userIp))
  add(query_581059, "key", newJString(key))
  add(query_581059, "prettyPrint", newJBool(prettyPrint))
  result = call_581057.call(path_581058, query_581059, nil, nil, nil)

var driveRevisionsDelete* = Call_DriveRevisionsDelete_581044(
    name: "driveRevisionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsDelete_581045, base: "/drive/v2",
    url: url_DriveRevisionsDelete_581046, schemes: {Scheme.Https})
type
  Call_DriveFilesTouch_581078 = ref object of OpenApiRestCall_579424
proc url_DriveFilesTouch_581080(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesTouch_581079(path: JsonNode; query: JsonNode;
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
  var valid_581081 = path.getOrDefault("fileId")
  valid_581081 = validateParameter(valid_581081, JString, required = true,
                                 default = nil)
  if valid_581081 != nil:
    section.add "fileId", valid_581081
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
  var valid_581082 = query.getOrDefault("supportsAllDrives")
  valid_581082 = validateParameter(valid_581082, JBool, required = false,
                                 default = newJBool(false))
  if valid_581082 != nil:
    section.add "supportsAllDrives", valid_581082
  var valid_581083 = query.getOrDefault("fields")
  valid_581083 = validateParameter(valid_581083, JString, required = false,
                                 default = nil)
  if valid_581083 != nil:
    section.add "fields", valid_581083
  var valid_581084 = query.getOrDefault("quotaUser")
  valid_581084 = validateParameter(valid_581084, JString, required = false,
                                 default = nil)
  if valid_581084 != nil:
    section.add "quotaUser", valid_581084
  var valid_581085 = query.getOrDefault("alt")
  valid_581085 = validateParameter(valid_581085, JString, required = false,
                                 default = newJString("json"))
  if valid_581085 != nil:
    section.add "alt", valid_581085
  var valid_581086 = query.getOrDefault("oauth_token")
  valid_581086 = validateParameter(valid_581086, JString, required = false,
                                 default = nil)
  if valid_581086 != nil:
    section.add "oauth_token", valid_581086
  var valid_581087 = query.getOrDefault("userIp")
  valid_581087 = validateParameter(valid_581087, JString, required = false,
                                 default = nil)
  if valid_581087 != nil:
    section.add "userIp", valid_581087
  var valid_581088 = query.getOrDefault("supportsTeamDrives")
  valid_581088 = validateParameter(valid_581088, JBool, required = false,
                                 default = newJBool(false))
  if valid_581088 != nil:
    section.add "supportsTeamDrives", valid_581088
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581091: Call_DriveFilesTouch_581078; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Set the file's updated time to the current server time.
  ## 
  let valid = call_581091.validator(path, query, header, formData, body)
  let scheme = call_581091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581091.url(scheme.get, call_581091.host, call_581091.base,
                         call_581091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581091, url, valid)

proc call*(call_581092: Call_DriveFilesTouch_581078; fileId: string;
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
  var path_581093 = newJObject()
  var query_581094 = newJObject()
  add(query_581094, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_581094, "fields", newJString(fields))
  add(query_581094, "quotaUser", newJString(quotaUser))
  add(path_581093, "fileId", newJString(fileId))
  add(query_581094, "alt", newJString(alt))
  add(query_581094, "oauth_token", newJString(oauthToken))
  add(query_581094, "userIp", newJString(userIp))
  add(query_581094, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_581094, "key", newJString(key))
  add(query_581094, "prettyPrint", newJBool(prettyPrint))
  result = call_581092.call(path_581093, query_581094, nil, nil, nil)

var driveFilesTouch* = Call_DriveFilesTouch_581078(name: "driveFilesTouch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/touch", validator: validate_DriveFilesTouch_581079,
    base: "/drive/v2", url: url_DriveFilesTouch_581080, schemes: {Scheme.Https})
type
  Call_DriveFilesTrash_581095 = ref object of OpenApiRestCall_579424
proc url_DriveFilesTrash_581097(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesTrash_581096(path: JsonNode; query: JsonNode;
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
  var valid_581098 = path.getOrDefault("fileId")
  valid_581098 = validateParameter(valid_581098, JString, required = true,
                                 default = nil)
  if valid_581098 != nil:
    section.add "fileId", valid_581098
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
  var valid_581099 = query.getOrDefault("supportsAllDrives")
  valid_581099 = validateParameter(valid_581099, JBool, required = false,
                                 default = newJBool(false))
  if valid_581099 != nil:
    section.add "supportsAllDrives", valid_581099
  var valid_581100 = query.getOrDefault("fields")
  valid_581100 = validateParameter(valid_581100, JString, required = false,
                                 default = nil)
  if valid_581100 != nil:
    section.add "fields", valid_581100
  var valid_581101 = query.getOrDefault("quotaUser")
  valid_581101 = validateParameter(valid_581101, JString, required = false,
                                 default = nil)
  if valid_581101 != nil:
    section.add "quotaUser", valid_581101
  var valid_581102 = query.getOrDefault("alt")
  valid_581102 = validateParameter(valid_581102, JString, required = false,
                                 default = newJString("json"))
  if valid_581102 != nil:
    section.add "alt", valid_581102
  var valid_581103 = query.getOrDefault("oauth_token")
  valid_581103 = validateParameter(valid_581103, JString, required = false,
                                 default = nil)
  if valid_581103 != nil:
    section.add "oauth_token", valid_581103
  var valid_581104 = query.getOrDefault("userIp")
  valid_581104 = validateParameter(valid_581104, JString, required = false,
                                 default = nil)
  if valid_581104 != nil:
    section.add "userIp", valid_581104
  var valid_581105 = query.getOrDefault("supportsTeamDrives")
  valid_581105 = validateParameter(valid_581105, JBool, required = false,
                                 default = newJBool(false))
  if valid_581105 != nil:
    section.add "supportsTeamDrives", valid_581105
  var valid_581106 = query.getOrDefault("key")
  valid_581106 = validateParameter(valid_581106, JString, required = false,
                                 default = nil)
  if valid_581106 != nil:
    section.add "key", valid_581106
  var valid_581107 = query.getOrDefault("prettyPrint")
  valid_581107 = validateParameter(valid_581107, JBool, required = false,
                                 default = newJBool(true))
  if valid_581107 != nil:
    section.add "prettyPrint", valid_581107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581108: Call_DriveFilesTrash_581095; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves a file to the trash. The currently authenticated user must own the file or be at least a fileOrganizer on the parent for shared drive files.
  ## 
  let valid = call_581108.validator(path, query, header, formData, body)
  let scheme = call_581108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581108.url(scheme.get, call_581108.host, call_581108.base,
                         call_581108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581108, url, valid)

proc call*(call_581109: Call_DriveFilesTrash_581095; fileId: string;
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
  var path_581110 = newJObject()
  var query_581111 = newJObject()
  add(query_581111, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_581111, "fields", newJString(fields))
  add(query_581111, "quotaUser", newJString(quotaUser))
  add(path_581110, "fileId", newJString(fileId))
  add(query_581111, "alt", newJString(alt))
  add(query_581111, "oauth_token", newJString(oauthToken))
  add(query_581111, "userIp", newJString(userIp))
  add(query_581111, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_581111, "key", newJString(key))
  add(query_581111, "prettyPrint", newJBool(prettyPrint))
  result = call_581109.call(path_581110, query_581111, nil, nil, nil)

var driveFilesTrash* = Call_DriveFilesTrash_581095(name: "driveFilesTrash",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/trash", validator: validate_DriveFilesTrash_581096,
    base: "/drive/v2", url: url_DriveFilesTrash_581097, schemes: {Scheme.Https})
type
  Call_DriveFilesUntrash_581112 = ref object of OpenApiRestCall_579424
proc url_DriveFilesUntrash_581114(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesUntrash_581113(path: JsonNode; query: JsonNode;
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
  var valid_581115 = path.getOrDefault("fileId")
  valid_581115 = validateParameter(valid_581115, JString, required = true,
                                 default = nil)
  if valid_581115 != nil:
    section.add "fileId", valid_581115
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
  var valid_581116 = query.getOrDefault("supportsAllDrives")
  valid_581116 = validateParameter(valid_581116, JBool, required = false,
                                 default = newJBool(false))
  if valid_581116 != nil:
    section.add "supportsAllDrives", valid_581116
  var valid_581117 = query.getOrDefault("fields")
  valid_581117 = validateParameter(valid_581117, JString, required = false,
                                 default = nil)
  if valid_581117 != nil:
    section.add "fields", valid_581117
  var valid_581118 = query.getOrDefault("quotaUser")
  valid_581118 = validateParameter(valid_581118, JString, required = false,
                                 default = nil)
  if valid_581118 != nil:
    section.add "quotaUser", valid_581118
  var valid_581119 = query.getOrDefault("alt")
  valid_581119 = validateParameter(valid_581119, JString, required = false,
                                 default = newJString("json"))
  if valid_581119 != nil:
    section.add "alt", valid_581119
  var valid_581120 = query.getOrDefault("oauth_token")
  valid_581120 = validateParameter(valid_581120, JString, required = false,
                                 default = nil)
  if valid_581120 != nil:
    section.add "oauth_token", valid_581120
  var valid_581121 = query.getOrDefault("userIp")
  valid_581121 = validateParameter(valid_581121, JString, required = false,
                                 default = nil)
  if valid_581121 != nil:
    section.add "userIp", valid_581121
  var valid_581122 = query.getOrDefault("supportsTeamDrives")
  valid_581122 = validateParameter(valid_581122, JBool, required = false,
                                 default = newJBool(false))
  if valid_581122 != nil:
    section.add "supportsTeamDrives", valid_581122
  var valid_581123 = query.getOrDefault("key")
  valid_581123 = validateParameter(valid_581123, JString, required = false,
                                 default = nil)
  if valid_581123 != nil:
    section.add "key", valid_581123
  var valid_581124 = query.getOrDefault("prettyPrint")
  valid_581124 = validateParameter(valid_581124, JBool, required = false,
                                 default = newJBool(true))
  if valid_581124 != nil:
    section.add "prettyPrint", valid_581124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581125: Call_DriveFilesUntrash_581112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a file from the trash.
  ## 
  let valid = call_581125.validator(path, query, header, formData, body)
  let scheme = call_581125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581125.url(scheme.get, call_581125.host, call_581125.base,
                         call_581125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581125, url, valid)

proc call*(call_581126: Call_DriveFilesUntrash_581112; fileId: string;
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
  var path_581127 = newJObject()
  var query_581128 = newJObject()
  add(query_581128, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_581128, "fields", newJString(fields))
  add(query_581128, "quotaUser", newJString(quotaUser))
  add(path_581127, "fileId", newJString(fileId))
  add(query_581128, "alt", newJString(alt))
  add(query_581128, "oauth_token", newJString(oauthToken))
  add(query_581128, "userIp", newJString(userIp))
  add(query_581128, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_581128, "key", newJString(key))
  add(query_581128, "prettyPrint", newJBool(prettyPrint))
  result = call_581126.call(path_581127, query_581128, nil, nil, nil)

var driveFilesUntrash* = Call_DriveFilesUntrash_581112(name: "driveFilesUntrash",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/untrash", validator: validate_DriveFilesUntrash_581113,
    base: "/drive/v2", url: url_DriveFilesUntrash_581114, schemes: {Scheme.Https})
type
  Call_DriveFilesWatch_581129 = ref object of OpenApiRestCall_579424
proc url_DriveFilesWatch_581131(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesWatch_581130(path: JsonNode; query: JsonNode;
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
  var valid_581132 = path.getOrDefault("fileId")
  valid_581132 = validateParameter(valid_581132, JString, required = true,
                                 default = nil)
  if valid_581132 != nil:
    section.add "fileId", valid_581132
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
  var valid_581133 = query.getOrDefault("supportsAllDrives")
  valid_581133 = validateParameter(valid_581133, JBool, required = false,
                                 default = newJBool(false))
  if valid_581133 != nil:
    section.add "supportsAllDrives", valid_581133
  var valid_581134 = query.getOrDefault("fields")
  valid_581134 = validateParameter(valid_581134, JString, required = false,
                                 default = nil)
  if valid_581134 != nil:
    section.add "fields", valid_581134
  var valid_581135 = query.getOrDefault("quotaUser")
  valid_581135 = validateParameter(valid_581135, JString, required = false,
                                 default = nil)
  if valid_581135 != nil:
    section.add "quotaUser", valid_581135
  var valid_581136 = query.getOrDefault("alt")
  valid_581136 = validateParameter(valid_581136, JString, required = false,
                                 default = newJString("json"))
  if valid_581136 != nil:
    section.add "alt", valid_581136
  var valid_581137 = query.getOrDefault("acknowledgeAbuse")
  valid_581137 = validateParameter(valid_581137, JBool, required = false,
                                 default = newJBool(false))
  if valid_581137 != nil:
    section.add "acknowledgeAbuse", valid_581137
  var valid_581138 = query.getOrDefault("oauth_token")
  valid_581138 = validateParameter(valid_581138, JString, required = false,
                                 default = nil)
  if valid_581138 != nil:
    section.add "oauth_token", valid_581138
  var valid_581139 = query.getOrDefault("userIp")
  valid_581139 = validateParameter(valid_581139, JString, required = false,
                                 default = nil)
  if valid_581139 != nil:
    section.add "userIp", valid_581139
  var valid_581140 = query.getOrDefault("supportsTeamDrives")
  valid_581140 = validateParameter(valid_581140, JBool, required = false,
                                 default = newJBool(false))
  if valid_581140 != nil:
    section.add "supportsTeamDrives", valid_581140
  var valid_581141 = query.getOrDefault("key")
  valid_581141 = validateParameter(valid_581141, JString, required = false,
                                 default = nil)
  if valid_581141 != nil:
    section.add "key", valid_581141
  var valid_581142 = query.getOrDefault("updateViewedDate")
  valid_581142 = validateParameter(valid_581142, JBool, required = false,
                                 default = newJBool(false))
  if valid_581142 != nil:
    section.add "updateViewedDate", valid_581142
  var valid_581143 = query.getOrDefault("projection")
  valid_581143 = validateParameter(valid_581143, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_581143 != nil:
    section.add "projection", valid_581143
  var valid_581144 = query.getOrDefault("revisionId")
  valid_581144 = validateParameter(valid_581144, JString, required = false,
                                 default = nil)
  if valid_581144 != nil:
    section.add "revisionId", valid_581144
  var valid_581145 = query.getOrDefault("prettyPrint")
  valid_581145 = validateParameter(valid_581145, JBool, required = false,
                                 default = newJBool(true))
  if valid_581145 != nil:
    section.add "prettyPrint", valid_581145
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

proc call*(call_581147: Call_DriveFilesWatch_581129; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Subscribe to changes on a file
  ## 
  let valid = call_581147.validator(path, query, header, formData, body)
  let scheme = call_581147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581147.url(scheme.get, call_581147.host, call_581147.base,
                         call_581147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581147, url, valid)

proc call*(call_581148: Call_DriveFilesWatch_581129; fileId: string;
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
  var path_581149 = newJObject()
  var query_581150 = newJObject()
  var body_581151 = newJObject()
  add(query_581150, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_581150, "fields", newJString(fields))
  add(query_581150, "quotaUser", newJString(quotaUser))
  add(path_581149, "fileId", newJString(fileId))
  add(query_581150, "alt", newJString(alt))
  add(query_581150, "acknowledgeAbuse", newJBool(acknowledgeAbuse))
  add(query_581150, "oauth_token", newJString(oauthToken))
  add(query_581150, "userIp", newJString(userIp))
  add(query_581150, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_581150, "key", newJString(key))
  add(query_581150, "updateViewedDate", newJBool(updateViewedDate))
  add(query_581150, "projection", newJString(projection))
  if resource != nil:
    body_581151 = resource
  add(query_581150, "revisionId", newJString(revisionId))
  add(query_581150, "prettyPrint", newJBool(prettyPrint))
  result = call_581148.call(path_581149, query_581150, nil, nil, body_581151)

var driveFilesWatch* = Call_DriveFilesWatch_581129(name: "driveFilesWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/watch", validator: validate_DriveFilesWatch_581130,
    base: "/drive/v2", url: url_DriveFilesWatch_581131, schemes: {Scheme.Https})
type
  Call_DriveChildrenInsert_581171 = ref object of OpenApiRestCall_579424
proc url_DriveChildrenInsert_581173(protocol: Scheme; host: string; base: string;
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

proc validate_DriveChildrenInsert_581172(path: JsonNode; query: JsonNode;
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
  var valid_581174 = path.getOrDefault("folderId")
  valid_581174 = validateParameter(valid_581174, JString, required = true,
                                 default = nil)
  if valid_581174 != nil:
    section.add "folderId", valid_581174
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
  var valid_581175 = query.getOrDefault("supportsAllDrives")
  valid_581175 = validateParameter(valid_581175, JBool, required = false,
                                 default = newJBool(false))
  if valid_581175 != nil:
    section.add "supportsAllDrives", valid_581175
  var valid_581176 = query.getOrDefault("fields")
  valid_581176 = validateParameter(valid_581176, JString, required = false,
                                 default = nil)
  if valid_581176 != nil:
    section.add "fields", valid_581176
  var valid_581177 = query.getOrDefault("quotaUser")
  valid_581177 = validateParameter(valid_581177, JString, required = false,
                                 default = nil)
  if valid_581177 != nil:
    section.add "quotaUser", valid_581177
  var valid_581178 = query.getOrDefault("alt")
  valid_581178 = validateParameter(valid_581178, JString, required = false,
                                 default = newJString("json"))
  if valid_581178 != nil:
    section.add "alt", valid_581178
  var valid_581179 = query.getOrDefault("oauth_token")
  valid_581179 = validateParameter(valid_581179, JString, required = false,
                                 default = nil)
  if valid_581179 != nil:
    section.add "oauth_token", valid_581179
  var valid_581180 = query.getOrDefault("userIp")
  valid_581180 = validateParameter(valid_581180, JString, required = false,
                                 default = nil)
  if valid_581180 != nil:
    section.add "userIp", valid_581180
  var valid_581181 = query.getOrDefault("supportsTeamDrives")
  valid_581181 = validateParameter(valid_581181, JBool, required = false,
                                 default = newJBool(false))
  if valid_581181 != nil:
    section.add "supportsTeamDrives", valid_581181
  var valid_581182 = query.getOrDefault("key")
  valid_581182 = validateParameter(valid_581182, JString, required = false,
                                 default = nil)
  if valid_581182 != nil:
    section.add "key", valid_581182
  var valid_581183 = query.getOrDefault("prettyPrint")
  valid_581183 = validateParameter(valid_581183, JBool, required = false,
                                 default = newJBool(true))
  if valid_581183 != nil:
    section.add "prettyPrint", valid_581183
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

proc call*(call_581185: Call_DriveChildrenInsert_581171; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a file into a folder.
  ## 
  let valid = call_581185.validator(path, query, header, formData, body)
  let scheme = call_581185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581185.url(scheme.get, call_581185.host, call_581185.base,
                         call_581185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581185, url, valid)

proc call*(call_581186: Call_DriveChildrenInsert_581171; folderId: string;
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
  var path_581187 = newJObject()
  var query_581188 = newJObject()
  var body_581189 = newJObject()
  add(query_581188, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_581188, "fields", newJString(fields))
  add(query_581188, "quotaUser", newJString(quotaUser))
  add(query_581188, "alt", newJString(alt))
  add(query_581188, "oauth_token", newJString(oauthToken))
  add(query_581188, "userIp", newJString(userIp))
  add(path_581187, "folderId", newJString(folderId))
  add(query_581188, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_581188, "key", newJString(key))
  if body != nil:
    body_581189 = body
  add(query_581188, "prettyPrint", newJBool(prettyPrint))
  result = call_581186.call(path_581187, query_581188, nil, nil, body_581189)

var driveChildrenInsert* = Call_DriveChildrenInsert_581171(
    name: "driveChildrenInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{folderId}/children",
    validator: validate_DriveChildrenInsert_581172, base: "/drive/v2",
    url: url_DriveChildrenInsert_581173, schemes: {Scheme.Https})
type
  Call_DriveChildrenList_581152 = ref object of OpenApiRestCall_579424
proc url_DriveChildrenList_581154(protocol: Scheme; host: string; base: string;
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

proc validate_DriveChildrenList_581153(path: JsonNode; query: JsonNode;
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
  var valid_581155 = path.getOrDefault("folderId")
  valid_581155 = validateParameter(valid_581155, JString, required = true,
                                 default = nil)
  if valid_581155 != nil:
    section.add "folderId", valid_581155
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
  var valid_581156 = query.getOrDefault("fields")
  valid_581156 = validateParameter(valid_581156, JString, required = false,
                                 default = nil)
  if valid_581156 != nil:
    section.add "fields", valid_581156
  var valid_581157 = query.getOrDefault("pageToken")
  valid_581157 = validateParameter(valid_581157, JString, required = false,
                                 default = nil)
  if valid_581157 != nil:
    section.add "pageToken", valid_581157
  var valid_581158 = query.getOrDefault("quotaUser")
  valid_581158 = validateParameter(valid_581158, JString, required = false,
                                 default = nil)
  if valid_581158 != nil:
    section.add "quotaUser", valid_581158
  var valid_581159 = query.getOrDefault("alt")
  valid_581159 = validateParameter(valid_581159, JString, required = false,
                                 default = newJString("json"))
  if valid_581159 != nil:
    section.add "alt", valid_581159
  var valid_581160 = query.getOrDefault("oauth_token")
  valid_581160 = validateParameter(valid_581160, JString, required = false,
                                 default = nil)
  if valid_581160 != nil:
    section.add "oauth_token", valid_581160
  var valid_581161 = query.getOrDefault("userIp")
  valid_581161 = validateParameter(valid_581161, JString, required = false,
                                 default = nil)
  if valid_581161 != nil:
    section.add "userIp", valid_581161
  var valid_581162 = query.getOrDefault("maxResults")
  valid_581162 = validateParameter(valid_581162, JInt, required = false,
                                 default = newJInt(100))
  if valid_581162 != nil:
    section.add "maxResults", valid_581162
  var valid_581163 = query.getOrDefault("orderBy")
  valid_581163 = validateParameter(valid_581163, JString, required = false,
                                 default = nil)
  if valid_581163 != nil:
    section.add "orderBy", valid_581163
  var valid_581164 = query.getOrDefault("q")
  valid_581164 = validateParameter(valid_581164, JString, required = false,
                                 default = nil)
  if valid_581164 != nil:
    section.add "q", valid_581164
  var valid_581165 = query.getOrDefault("key")
  valid_581165 = validateParameter(valid_581165, JString, required = false,
                                 default = nil)
  if valid_581165 != nil:
    section.add "key", valid_581165
  var valid_581166 = query.getOrDefault("prettyPrint")
  valid_581166 = validateParameter(valid_581166, JBool, required = false,
                                 default = newJBool(true))
  if valid_581166 != nil:
    section.add "prettyPrint", valid_581166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581167: Call_DriveChildrenList_581152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a folder's children.
  ## 
  let valid = call_581167.validator(path, query, header, formData, body)
  let scheme = call_581167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581167.url(scheme.get, call_581167.host, call_581167.base,
                         call_581167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581167, url, valid)

proc call*(call_581168: Call_DriveChildrenList_581152; folderId: string;
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
  var path_581169 = newJObject()
  var query_581170 = newJObject()
  add(query_581170, "fields", newJString(fields))
  add(query_581170, "pageToken", newJString(pageToken))
  add(query_581170, "quotaUser", newJString(quotaUser))
  add(query_581170, "alt", newJString(alt))
  add(query_581170, "oauth_token", newJString(oauthToken))
  add(query_581170, "userIp", newJString(userIp))
  add(path_581169, "folderId", newJString(folderId))
  add(query_581170, "maxResults", newJInt(maxResults))
  add(query_581170, "orderBy", newJString(orderBy))
  add(query_581170, "q", newJString(q))
  add(query_581170, "key", newJString(key))
  add(query_581170, "prettyPrint", newJBool(prettyPrint))
  result = call_581168.call(path_581169, query_581170, nil, nil, nil)

var driveChildrenList* = Call_DriveChildrenList_581152(name: "driveChildrenList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{folderId}/children", validator: validate_DriveChildrenList_581153,
    base: "/drive/v2", url: url_DriveChildrenList_581154, schemes: {Scheme.Https})
type
  Call_DriveChildrenGet_581190 = ref object of OpenApiRestCall_579424
proc url_DriveChildrenGet_581192(protocol: Scheme; host: string; base: string;
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

proc validate_DriveChildrenGet_581191(path: JsonNode; query: JsonNode;
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
  var valid_581193 = path.getOrDefault("childId")
  valid_581193 = validateParameter(valid_581193, JString, required = true,
                                 default = nil)
  if valid_581193 != nil:
    section.add "childId", valid_581193
  var valid_581194 = path.getOrDefault("folderId")
  valid_581194 = validateParameter(valid_581194, JString, required = true,
                                 default = nil)
  if valid_581194 != nil:
    section.add "folderId", valid_581194
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
  var valid_581195 = query.getOrDefault("fields")
  valid_581195 = validateParameter(valid_581195, JString, required = false,
                                 default = nil)
  if valid_581195 != nil:
    section.add "fields", valid_581195
  var valid_581196 = query.getOrDefault("quotaUser")
  valid_581196 = validateParameter(valid_581196, JString, required = false,
                                 default = nil)
  if valid_581196 != nil:
    section.add "quotaUser", valid_581196
  var valid_581197 = query.getOrDefault("alt")
  valid_581197 = validateParameter(valid_581197, JString, required = false,
                                 default = newJString("json"))
  if valid_581197 != nil:
    section.add "alt", valid_581197
  var valid_581198 = query.getOrDefault("oauth_token")
  valid_581198 = validateParameter(valid_581198, JString, required = false,
                                 default = nil)
  if valid_581198 != nil:
    section.add "oauth_token", valid_581198
  var valid_581199 = query.getOrDefault("userIp")
  valid_581199 = validateParameter(valid_581199, JString, required = false,
                                 default = nil)
  if valid_581199 != nil:
    section.add "userIp", valid_581199
  var valid_581200 = query.getOrDefault("key")
  valid_581200 = validateParameter(valid_581200, JString, required = false,
                                 default = nil)
  if valid_581200 != nil:
    section.add "key", valid_581200
  var valid_581201 = query.getOrDefault("prettyPrint")
  valid_581201 = validateParameter(valid_581201, JBool, required = false,
                                 default = newJBool(true))
  if valid_581201 != nil:
    section.add "prettyPrint", valid_581201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581202: Call_DriveChildrenGet_581190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific child reference.
  ## 
  let valid = call_581202.validator(path, query, header, formData, body)
  let scheme = call_581202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581202.url(scheme.get, call_581202.host, call_581202.base,
                         call_581202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581202, url, valid)

proc call*(call_581203: Call_DriveChildrenGet_581190; childId: string;
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
  var path_581204 = newJObject()
  var query_581205 = newJObject()
  add(query_581205, "fields", newJString(fields))
  add(query_581205, "quotaUser", newJString(quotaUser))
  add(query_581205, "alt", newJString(alt))
  add(query_581205, "oauth_token", newJString(oauthToken))
  add(query_581205, "userIp", newJString(userIp))
  add(path_581204, "childId", newJString(childId))
  add(path_581204, "folderId", newJString(folderId))
  add(query_581205, "key", newJString(key))
  add(query_581205, "prettyPrint", newJBool(prettyPrint))
  result = call_581203.call(path_581204, query_581205, nil, nil, nil)

var driveChildrenGet* = Call_DriveChildrenGet_581190(name: "driveChildrenGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{folderId}/children/{childId}",
    validator: validate_DriveChildrenGet_581191, base: "/drive/v2",
    url: url_DriveChildrenGet_581192, schemes: {Scheme.Https})
type
  Call_DriveChildrenDelete_581206 = ref object of OpenApiRestCall_579424
proc url_DriveChildrenDelete_581208(protocol: Scheme; host: string; base: string;
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

proc validate_DriveChildrenDelete_581207(path: JsonNode; query: JsonNode;
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
  var valid_581209 = path.getOrDefault("childId")
  valid_581209 = validateParameter(valid_581209, JString, required = true,
                                 default = nil)
  if valid_581209 != nil:
    section.add "childId", valid_581209
  var valid_581210 = path.getOrDefault("folderId")
  valid_581210 = validateParameter(valid_581210, JString, required = true,
                                 default = nil)
  if valid_581210 != nil:
    section.add "folderId", valid_581210
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
  var valid_581211 = query.getOrDefault("fields")
  valid_581211 = validateParameter(valid_581211, JString, required = false,
                                 default = nil)
  if valid_581211 != nil:
    section.add "fields", valid_581211
  var valid_581212 = query.getOrDefault("quotaUser")
  valid_581212 = validateParameter(valid_581212, JString, required = false,
                                 default = nil)
  if valid_581212 != nil:
    section.add "quotaUser", valid_581212
  var valid_581213 = query.getOrDefault("alt")
  valid_581213 = validateParameter(valid_581213, JString, required = false,
                                 default = newJString("json"))
  if valid_581213 != nil:
    section.add "alt", valid_581213
  var valid_581214 = query.getOrDefault("oauth_token")
  valid_581214 = validateParameter(valid_581214, JString, required = false,
                                 default = nil)
  if valid_581214 != nil:
    section.add "oauth_token", valid_581214
  var valid_581215 = query.getOrDefault("userIp")
  valid_581215 = validateParameter(valid_581215, JString, required = false,
                                 default = nil)
  if valid_581215 != nil:
    section.add "userIp", valid_581215
  var valid_581216 = query.getOrDefault("key")
  valid_581216 = validateParameter(valid_581216, JString, required = false,
                                 default = nil)
  if valid_581216 != nil:
    section.add "key", valid_581216
  var valid_581217 = query.getOrDefault("prettyPrint")
  valid_581217 = validateParameter(valid_581217, JBool, required = false,
                                 default = newJBool(true))
  if valid_581217 != nil:
    section.add "prettyPrint", valid_581217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581218: Call_DriveChildrenDelete_581206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a child from a folder.
  ## 
  let valid = call_581218.validator(path, query, header, formData, body)
  let scheme = call_581218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581218.url(scheme.get, call_581218.host, call_581218.base,
                         call_581218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581218, url, valid)

proc call*(call_581219: Call_DriveChildrenDelete_581206; childId: string;
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
  var path_581220 = newJObject()
  var query_581221 = newJObject()
  add(query_581221, "fields", newJString(fields))
  add(query_581221, "quotaUser", newJString(quotaUser))
  add(query_581221, "alt", newJString(alt))
  add(query_581221, "oauth_token", newJString(oauthToken))
  add(query_581221, "userIp", newJString(userIp))
  add(path_581220, "childId", newJString(childId))
  add(path_581220, "folderId", newJString(folderId))
  add(query_581221, "key", newJString(key))
  add(query_581221, "prettyPrint", newJBool(prettyPrint))
  result = call_581219.call(path_581220, query_581221, nil, nil, nil)

var driveChildrenDelete* = Call_DriveChildrenDelete_581206(
    name: "driveChildrenDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{folderId}/children/{childId}",
    validator: validate_DriveChildrenDelete_581207, base: "/drive/v2",
    url: url_DriveChildrenDelete_581208, schemes: {Scheme.Https})
type
  Call_DrivePermissionsGetIdForEmail_581222 = ref object of OpenApiRestCall_579424
proc url_DrivePermissionsGetIdForEmail_581224(protocol: Scheme; host: string;
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

proc validate_DrivePermissionsGetIdForEmail_581223(path: JsonNode; query: JsonNode;
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
  var valid_581225 = path.getOrDefault("email")
  valid_581225 = validateParameter(valid_581225, JString, required = true,
                                 default = nil)
  if valid_581225 != nil:
    section.add "email", valid_581225
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
  var valid_581226 = query.getOrDefault("fields")
  valid_581226 = validateParameter(valid_581226, JString, required = false,
                                 default = nil)
  if valid_581226 != nil:
    section.add "fields", valid_581226
  var valid_581227 = query.getOrDefault("quotaUser")
  valid_581227 = validateParameter(valid_581227, JString, required = false,
                                 default = nil)
  if valid_581227 != nil:
    section.add "quotaUser", valid_581227
  var valid_581228 = query.getOrDefault("alt")
  valid_581228 = validateParameter(valid_581228, JString, required = false,
                                 default = newJString("json"))
  if valid_581228 != nil:
    section.add "alt", valid_581228
  var valid_581229 = query.getOrDefault("oauth_token")
  valid_581229 = validateParameter(valid_581229, JString, required = false,
                                 default = nil)
  if valid_581229 != nil:
    section.add "oauth_token", valid_581229
  var valid_581230 = query.getOrDefault("userIp")
  valid_581230 = validateParameter(valid_581230, JString, required = false,
                                 default = nil)
  if valid_581230 != nil:
    section.add "userIp", valid_581230
  var valid_581231 = query.getOrDefault("key")
  valid_581231 = validateParameter(valid_581231, JString, required = false,
                                 default = nil)
  if valid_581231 != nil:
    section.add "key", valid_581231
  var valid_581232 = query.getOrDefault("prettyPrint")
  valid_581232 = validateParameter(valid_581232, JBool, required = false,
                                 default = newJBool(true))
  if valid_581232 != nil:
    section.add "prettyPrint", valid_581232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581233: Call_DrivePermissionsGetIdForEmail_581222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the permission ID for an email address.
  ## 
  let valid = call_581233.validator(path, query, header, formData, body)
  let scheme = call_581233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581233.url(scheme.get, call_581233.host, call_581233.base,
                         call_581233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581233, url, valid)

proc call*(call_581234: Call_DrivePermissionsGetIdForEmail_581222; email: string;
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
  var path_581235 = newJObject()
  var query_581236 = newJObject()
  add(query_581236, "fields", newJString(fields))
  add(query_581236, "quotaUser", newJString(quotaUser))
  add(query_581236, "alt", newJString(alt))
  add(path_581235, "email", newJString(email))
  add(query_581236, "oauth_token", newJString(oauthToken))
  add(query_581236, "userIp", newJString(userIp))
  add(query_581236, "key", newJString(key))
  add(query_581236, "prettyPrint", newJBool(prettyPrint))
  result = call_581234.call(path_581235, query_581236, nil, nil, nil)

var drivePermissionsGetIdForEmail* = Call_DrivePermissionsGetIdForEmail_581222(
    name: "drivePermissionsGetIdForEmail", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/permissionIds/{email}",
    validator: validate_DrivePermissionsGetIdForEmail_581223, base: "/drive/v2",
    url: url_DrivePermissionsGetIdForEmail_581224, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesInsert_581254 = ref object of OpenApiRestCall_579424
proc url_DriveTeamdrivesInsert_581256(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveTeamdrivesInsert_581255(path: JsonNode; query: JsonNode;
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
  var valid_581257 = query.getOrDefault("fields")
  valid_581257 = validateParameter(valid_581257, JString, required = false,
                                 default = nil)
  if valid_581257 != nil:
    section.add "fields", valid_581257
  assert query != nil,
        "query argument is necessary due to required `requestId` field"
  var valid_581258 = query.getOrDefault("requestId")
  valid_581258 = validateParameter(valid_581258, JString, required = true,
                                 default = nil)
  if valid_581258 != nil:
    section.add "requestId", valid_581258
  var valid_581259 = query.getOrDefault("quotaUser")
  valid_581259 = validateParameter(valid_581259, JString, required = false,
                                 default = nil)
  if valid_581259 != nil:
    section.add "quotaUser", valid_581259
  var valid_581260 = query.getOrDefault("alt")
  valid_581260 = validateParameter(valid_581260, JString, required = false,
                                 default = newJString("json"))
  if valid_581260 != nil:
    section.add "alt", valid_581260
  var valid_581261 = query.getOrDefault("oauth_token")
  valid_581261 = validateParameter(valid_581261, JString, required = false,
                                 default = nil)
  if valid_581261 != nil:
    section.add "oauth_token", valid_581261
  var valid_581262 = query.getOrDefault("userIp")
  valid_581262 = validateParameter(valid_581262, JString, required = false,
                                 default = nil)
  if valid_581262 != nil:
    section.add "userIp", valid_581262
  var valid_581263 = query.getOrDefault("key")
  valid_581263 = validateParameter(valid_581263, JString, required = false,
                                 default = nil)
  if valid_581263 != nil:
    section.add "key", valid_581263
  var valid_581264 = query.getOrDefault("prettyPrint")
  valid_581264 = validateParameter(valid_581264, JBool, required = false,
                                 default = newJBool(true))
  if valid_581264 != nil:
    section.add "prettyPrint", valid_581264
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

proc call*(call_581266: Call_DriveTeamdrivesInsert_581254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.insert instead.
  ## 
  let valid = call_581266.validator(path, query, header, formData, body)
  let scheme = call_581266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581266.url(scheme.get, call_581266.host, call_581266.base,
                         call_581266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581266, url, valid)

proc call*(call_581267: Call_DriveTeamdrivesInsert_581254; requestId: string;
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
  var query_581268 = newJObject()
  var body_581269 = newJObject()
  add(query_581268, "fields", newJString(fields))
  add(query_581268, "requestId", newJString(requestId))
  add(query_581268, "quotaUser", newJString(quotaUser))
  add(query_581268, "alt", newJString(alt))
  add(query_581268, "oauth_token", newJString(oauthToken))
  add(query_581268, "userIp", newJString(userIp))
  add(query_581268, "key", newJString(key))
  if body != nil:
    body_581269 = body
  add(query_581268, "prettyPrint", newJBool(prettyPrint))
  result = call_581267.call(nil, query_581268, nil, nil, body_581269)

var driveTeamdrivesInsert* = Call_DriveTeamdrivesInsert_581254(
    name: "driveTeamdrivesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/teamdrives",
    validator: validate_DriveTeamdrivesInsert_581255, base: "/drive/v2",
    url: url_DriveTeamdrivesInsert_581256, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesList_581237 = ref object of OpenApiRestCall_579424
proc url_DriveTeamdrivesList_581239(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveTeamdrivesList_581238(path: JsonNode; query: JsonNode;
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
  var valid_581240 = query.getOrDefault("fields")
  valid_581240 = validateParameter(valid_581240, JString, required = false,
                                 default = nil)
  if valid_581240 != nil:
    section.add "fields", valid_581240
  var valid_581241 = query.getOrDefault("pageToken")
  valid_581241 = validateParameter(valid_581241, JString, required = false,
                                 default = nil)
  if valid_581241 != nil:
    section.add "pageToken", valid_581241
  var valid_581242 = query.getOrDefault("quotaUser")
  valid_581242 = validateParameter(valid_581242, JString, required = false,
                                 default = nil)
  if valid_581242 != nil:
    section.add "quotaUser", valid_581242
  var valid_581243 = query.getOrDefault("alt")
  valid_581243 = validateParameter(valid_581243, JString, required = false,
                                 default = newJString("json"))
  if valid_581243 != nil:
    section.add "alt", valid_581243
  var valid_581244 = query.getOrDefault("oauth_token")
  valid_581244 = validateParameter(valid_581244, JString, required = false,
                                 default = nil)
  if valid_581244 != nil:
    section.add "oauth_token", valid_581244
  var valid_581245 = query.getOrDefault("userIp")
  valid_581245 = validateParameter(valid_581245, JString, required = false,
                                 default = nil)
  if valid_581245 != nil:
    section.add "userIp", valid_581245
  var valid_581246 = query.getOrDefault("maxResults")
  valid_581246 = validateParameter(valid_581246, JInt, required = false,
                                 default = newJInt(10))
  if valid_581246 != nil:
    section.add "maxResults", valid_581246
  var valid_581247 = query.getOrDefault("q")
  valid_581247 = validateParameter(valid_581247, JString, required = false,
                                 default = nil)
  if valid_581247 != nil:
    section.add "q", valid_581247
  var valid_581248 = query.getOrDefault("key")
  valid_581248 = validateParameter(valid_581248, JString, required = false,
                                 default = nil)
  if valid_581248 != nil:
    section.add "key", valid_581248
  var valid_581249 = query.getOrDefault("useDomainAdminAccess")
  valid_581249 = validateParameter(valid_581249, JBool, required = false,
                                 default = newJBool(false))
  if valid_581249 != nil:
    section.add "useDomainAdminAccess", valid_581249
  var valid_581250 = query.getOrDefault("prettyPrint")
  valid_581250 = validateParameter(valid_581250, JBool, required = false,
                                 default = newJBool(true))
  if valid_581250 != nil:
    section.add "prettyPrint", valid_581250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581251: Call_DriveTeamdrivesList_581237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.list instead.
  ## 
  let valid = call_581251.validator(path, query, header, formData, body)
  let scheme = call_581251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581251.url(scheme.get, call_581251.host, call_581251.base,
                         call_581251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581251, url, valid)

proc call*(call_581252: Call_DriveTeamdrivesList_581237; fields: string = "";
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
  var query_581253 = newJObject()
  add(query_581253, "fields", newJString(fields))
  add(query_581253, "pageToken", newJString(pageToken))
  add(query_581253, "quotaUser", newJString(quotaUser))
  add(query_581253, "alt", newJString(alt))
  add(query_581253, "oauth_token", newJString(oauthToken))
  add(query_581253, "userIp", newJString(userIp))
  add(query_581253, "maxResults", newJInt(maxResults))
  add(query_581253, "q", newJString(q))
  add(query_581253, "key", newJString(key))
  add(query_581253, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_581253, "prettyPrint", newJBool(prettyPrint))
  result = call_581252.call(nil, query_581253, nil, nil, nil)

var driveTeamdrivesList* = Call_DriveTeamdrivesList_581237(
    name: "driveTeamdrivesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/teamdrives",
    validator: validate_DriveTeamdrivesList_581238, base: "/drive/v2",
    url: url_DriveTeamdrivesList_581239, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesUpdate_581286 = ref object of OpenApiRestCall_579424
proc url_DriveTeamdrivesUpdate_581288(protocol: Scheme; host: string; base: string;
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

proc validate_DriveTeamdrivesUpdate_581287(path: JsonNode; query: JsonNode;
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
  var valid_581289 = path.getOrDefault("teamDriveId")
  valid_581289 = validateParameter(valid_581289, JString, required = true,
                                 default = nil)
  if valid_581289 != nil:
    section.add "teamDriveId", valid_581289
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
  var valid_581290 = query.getOrDefault("fields")
  valid_581290 = validateParameter(valid_581290, JString, required = false,
                                 default = nil)
  if valid_581290 != nil:
    section.add "fields", valid_581290
  var valid_581291 = query.getOrDefault("quotaUser")
  valid_581291 = validateParameter(valid_581291, JString, required = false,
                                 default = nil)
  if valid_581291 != nil:
    section.add "quotaUser", valid_581291
  var valid_581292 = query.getOrDefault("alt")
  valid_581292 = validateParameter(valid_581292, JString, required = false,
                                 default = newJString("json"))
  if valid_581292 != nil:
    section.add "alt", valid_581292
  var valid_581293 = query.getOrDefault("oauth_token")
  valid_581293 = validateParameter(valid_581293, JString, required = false,
                                 default = nil)
  if valid_581293 != nil:
    section.add "oauth_token", valid_581293
  var valid_581294 = query.getOrDefault("userIp")
  valid_581294 = validateParameter(valid_581294, JString, required = false,
                                 default = nil)
  if valid_581294 != nil:
    section.add "userIp", valid_581294
  var valid_581295 = query.getOrDefault("key")
  valid_581295 = validateParameter(valid_581295, JString, required = false,
                                 default = nil)
  if valid_581295 != nil:
    section.add "key", valid_581295
  var valid_581296 = query.getOrDefault("useDomainAdminAccess")
  valid_581296 = validateParameter(valid_581296, JBool, required = false,
                                 default = newJBool(false))
  if valid_581296 != nil:
    section.add "useDomainAdminAccess", valid_581296
  var valid_581297 = query.getOrDefault("prettyPrint")
  valid_581297 = validateParameter(valid_581297, JBool, required = false,
                                 default = newJBool(true))
  if valid_581297 != nil:
    section.add "prettyPrint", valid_581297
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

proc call*(call_581299: Call_DriveTeamdrivesUpdate_581286; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.update instead.
  ## 
  let valid = call_581299.validator(path, query, header, formData, body)
  let scheme = call_581299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581299.url(scheme.get, call_581299.host, call_581299.base,
                         call_581299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581299, url, valid)

proc call*(call_581300: Call_DriveTeamdrivesUpdate_581286; teamDriveId: string;
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
  var path_581301 = newJObject()
  var query_581302 = newJObject()
  var body_581303 = newJObject()
  add(path_581301, "teamDriveId", newJString(teamDriveId))
  add(query_581302, "fields", newJString(fields))
  add(query_581302, "quotaUser", newJString(quotaUser))
  add(query_581302, "alt", newJString(alt))
  add(query_581302, "oauth_token", newJString(oauthToken))
  add(query_581302, "userIp", newJString(userIp))
  add(query_581302, "key", newJString(key))
  add(query_581302, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  if body != nil:
    body_581303 = body
  add(query_581302, "prettyPrint", newJBool(prettyPrint))
  result = call_581300.call(path_581301, query_581302, nil, nil, body_581303)

var driveTeamdrivesUpdate* = Call_DriveTeamdrivesUpdate_581286(
    name: "driveTeamdrivesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesUpdate_581287, base: "/drive/v2",
    url: url_DriveTeamdrivesUpdate_581288, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesGet_581270 = ref object of OpenApiRestCall_579424
proc url_DriveTeamdrivesGet_581272(protocol: Scheme; host: string; base: string;
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

proc validate_DriveTeamdrivesGet_581271(path: JsonNode; query: JsonNode;
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
  var valid_581273 = path.getOrDefault("teamDriveId")
  valid_581273 = validateParameter(valid_581273, JString, required = true,
                                 default = nil)
  if valid_581273 != nil:
    section.add "teamDriveId", valid_581273
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
  var valid_581274 = query.getOrDefault("fields")
  valid_581274 = validateParameter(valid_581274, JString, required = false,
                                 default = nil)
  if valid_581274 != nil:
    section.add "fields", valid_581274
  var valid_581275 = query.getOrDefault("quotaUser")
  valid_581275 = validateParameter(valid_581275, JString, required = false,
                                 default = nil)
  if valid_581275 != nil:
    section.add "quotaUser", valid_581275
  var valid_581276 = query.getOrDefault("alt")
  valid_581276 = validateParameter(valid_581276, JString, required = false,
                                 default = newJString("json"))
  if valid_581276 != nil:
    section.add "alt", valid_581276
  var valid_581277 = query.getOrDefault("oauth_token")
  valid_581277 = validateParameter(valid_581277, JString, required = false,
                                 default = nil)
  if valid_581277 != nil:
    section.add "oauth_token", valid_581277
  var valid_581278 = query.getOrDefault("userIp")
  valid_581278 = validateParameter(valid_581278, JString, required = false,
                                 default = nil)
  if valid_581278 != nil:
    section.add "userIp", valid_581278
  var valid_581279 = query.getOrDefault("key")
  valid_581279 = validateParameter(valid_581279, JString, required = false,
                                 default = nil)
  if valid_581279 != nil:
    section.add "key", valid_581279
  var valid_581280 = query.getOrDefault("useDomainAdminAccess")
  valid_581280 = validateParameter(valid_581280, JBool, required = false,
                                 default = newJBool(false))
  if valid_581280 != nil:
    section.add "useDomainAdminAccess", valid_581280
  var valid_581281 = query.getOrDefault("prettyPrint")
  valid_581281 = validateParameter(valid_581281, JBool, required = false,
                                 default = newJBool(true))
  if valid_581281 != nil:
    section.add "prettyPrint", valid_581281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581282: Call_DriveTeamdrivesGet_581270; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.get instead.
  ## 
  let valid = call_581282.validator(path, query, header, formData, body)
  let scheme = call_581282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581282.url(scheme.get, call_581282.host, call_581282.base,
                         call_581282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581282, url, valid)

proc call*(call_581283: Call_DriveTeamdrivesGet_581270; teamDriveId: string;
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
  var path_581284 = newJObject()
  var query_581285 = newJObject()
  add(path_581284, "teamDriveId", newJString(teamDriveId))
  add(query_581285, "fields", newJString(fields))
  add(query_581285, "quotaUser", newJString(quotaUser))
  add(query_581285, "alt", newJString(alt))
  add(query_581285, "oauth_token", newJString(oauthToken))
  add(query_581285, "userIp", newJString(userIp))
  add(query_581285, "key", newJString(key))
  add(query_581285, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_581285, "prettyPrint", newJBool(prettyPrint))
  result = call_581283.call(path_581284, query_581285, nil, nil, nil)

var driveTeamdrivesGet* = Call_DriveTeamdrivesGet_581270(
    name: "driveTeamdrivesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesGet_581271, base: "/drive/v2",
    url: url_DriveTeamdrivesGet_581272, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesDelete_581304 = ref object of OpenApiRestCall_579424
proc url_DriveTeamdrivesDelete_581306(protocol: Scheme; host: string; base: string;
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

proc validate_DriveTeamdrivesDelete_581305(path: JsonNode; query: JsonNode;
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
  var valid_581307 = path.getOrDefault("teamDriveId")
  valid_581307 = validateParameter(valid_581307, JString, required = true,
                                 default = nil)
  if valid_581307 != nil:
    section.add "teamDriveId", valid_581307
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
  var valid_581308 = query.getOrDefault("fields")
  valid_581308 = validateParameter(valid_581308, JString, required = false,
                                 default = nil)
  if valid_581308 != nil:
    section.add "fields", valid_581308
  var valid_581309 = query.getOrDefault("quotaUser")
  valid_581309 = validateParameter(valid_581309, JString, required = false,
                                 default = nil)
  if valid_581309 != nil:
    section.add "quotaUser", valid_581309
  var valid_581310 = query.getOrDefault("alt")
  valid_581310 = validateParameter(valid_581310, JString, required = false,
                                 default = newJString("json"))
  if valid_581310 != nil:
    section.add "alt", valid_581310
  var valid_581311 = query.getOrDefault("oauth_token")
  valid_581311 = validateParameter(valid_581311, JString, required = false,
                                 default = nil)
  if valid_581311 != nil:
    section.add "oauth_token", valid_581311
  var valid_581312 = query.getOrDefault("userIp")
  valid_581312 = validateParameter(valid_581312, JString, required = false,
                                 default = nil)
  if valid_581312 != nil:
    section.add "userIp", valid_581312
  var valid_581313 = query.getOrDefault("key")
  valid_581313 = validateParameter(valid_581313, JString, required = false,
                                 default = nil)
  if valid_581313 != nil:
    section.add "key", valid_581313
  var valid_581314 = query.getOrDefault("prettyPrint")
  valid_581314 = validateParameter(valid_581314, JBool, required = false,
                                 default = newJBool(true))
  if valid_581314 != nil:
    section.add "prettyPrint", valid_581314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581315: Call_DriveTeamdrivesDelete_581304; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.delete instead.
  ## 
  let valid = call_581315.validator(path, query, header, formData, body)
  let scheme = call_581315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581315.url(scheme.get, call_581315.host, call_581315.base,
                         call_581315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581315, url, valid)

proc call*(call_581316: Call_DriveTeamdrivesDelete_581304; teamDriveId: string;
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
  var path_581317 = newJObject()
  var query_581318 = newJObject()
  add(path_581317, "teamDriveId", newJString(teamDriveId))
  add(query_581318, "fields", newJString(fields))
  add(query_581318, "quotaUser", newJString(quotaUser))
  add(query_581318, "alt", newJString(alt))
  add(query_581318, "oauth_token", newJString(oauthToken))
  add(query_581318, "userIp", newJString(userIp))
  add(query_581318, "key", newJString(key))
  add(query_581318, "prettyPrint", newJBool(prettyPrint))
  result = call_581316.call(path_581317, query_581318, nil, nil, nil)

var driveTeamdrivesDelete* = Call_DriveTeamdrivesDelete_581304(
    name: "driveTeamdrivesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesDelete_581305, base: "/drive/v2",
    url: url_DriveTeamdrivesDelete_581306, schemes: {Scheme.Https})
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
