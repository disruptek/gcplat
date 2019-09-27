
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DriveAboutGet_593692 = ref object of OpenApiRestCall_593424
proc url_DriveAboutGet_593694(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DriveAboutGet_593693(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593806 = query.getOrDefault("fields")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "fields", valid_593806
  var valid_593807 = query.getOrDefault("quotaUser")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "quotaUser", valid_593807
  var valid_593821 = query.getOrDefault("alt")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = newJString("json"))
  if valid_593821 != nil:
    section.add "alt", valid_593821
  var valid_593822 = query.getOrDefault("oauth_token")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "oauth_token", valid_593822
  var valid_593823 = query.getOrDefault("userIp")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "userIp", valid_593823
  var valid_593824 = query.getOrDefault("maxChangeIdCount")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = newJString("1"))
  if valid_593824 != nil:
    section.add "maxChangeIdCount", valid_593824
  var valid_593825 = query.getOrDefault("includeSubscribed")
  valid_593825 = validateParameter(valid_593825, JBool, required = false,
                                 default = newJBool(true))
  if valid_593825 != nil:
    section.add "includeSubscribed", valid_593825
  var valid_593826 = query.getOrDefault("key")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "key", valid_593826
  var valid_593827 = query.getOrDefault("prettyPrint")
  valid_593827 = validateParameter(valid_593827, JBool, required = false,
                                 default = newJBool(true))
  if valid_593827 != nil:
    section.add "prettyPrint", valid_593827
  var valid_593828 = query.getOrDefault("startChangeId")
  valid_593828 = validateParameter(valid_593828, JString, required = false,
                                 default = nil)
  if valid_593828 != nil:
    section.add "startChangeId", valid_593828
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593851: Call_DriveAboutGet_593692; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the current user along with Drive API settings
  ## 
  let valid = call_593851.validator(path, query, header, formData, body)
  let scheme = call_593851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593851.url(scheme.get, call_593851.host, call_593851.base,
                         call_593851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593851, url, valid)

proc call*(call_593922: Call_DriveAboutGet_593692; fields: string = "";
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
  var query_593923 = newJObject()
  add(query_593923, "fields", newJString(fields))
  add(query_593923, "quotaUser", newJString(quotaUser))
  add(query_593923, "alt", newJString(alt))
  add(query_593923, "oauth_token", newJString(oauthToken))
  add(query_593923, "userIp", newJString(userIp))
  add(query_593923, "maxChangeIdCount", newJString(maxChangeIdCount))
  add(query_593923, "includeSubscribed", newJBool(includeSubscribed))
  add(query_593923, "key", newJString(key))
  add(query_593923, "prettyPrint", newJBool(prettyPrint))
  add(query_593923, "startChangeId", newJString(startChangeId))
  result = call_593922.call(nil, query_593923, nil, nil, nil)

var driveAboutGet* = Call_DriveAboutGet_593692(name: "driveAboutGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/about",
    validator: validate_DriveAboutGet_593693, base: "/drive/v2",
    url: url_DriveAboutGet_593694, schemes: {Scheme.Https})
type
  Call_DriveAppsList_593963 = ref object of OpenApiRestCall_593424
proc url_DriveAppsList_593965(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DriveAppsList_593964(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593966 = query.getOrDefault("fields")
  valid_593966 = validateParameter(valid_593966, JString, required = false,
                                 default = nil)
  if valid_593966 != nil:
    section.add "fields", valid_593966
  var valid_593967 = query.getOrDefault("quotaUser")
  valid_593967 = validateParameter(valid_593967, JString, required = false,
                                 default = nil)
  if valid_593967 != nil:
    section.add "quotaUser", valid_593967
  var valid_593968 = query.getOrDefault("alt")
  valid_593968 = validateParameter(valid_593968, JString, required = false,
                                 default = newJString("json"))
  if valid_593968 != nil:
    section.add "alt", valid_593968
  var valid_593969 = query.getOrDefault("appFilterExtensions")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = newJString(""))
  if valid_593969 != nil:
    section.add "appFilterExtensions", valid_593969
  var valid_593970 = query.getOrDefault("oauth_token")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = nil)
  if valid_593970 != nil:
    section.add "oauth_token", valid_593970
  var valid_593971 = query.getOrDefault("userIp")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "userIp", valid_593971
  var valid_593972 = query.getOrDefault("key")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = nil)
  if valid_593972 != nil:
    section.add "key", valid_593972
  var valid_593973 = query.getOrDefault("appFilterMimeTypes")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = newJString(""))
  if valid_593973 != nil:
    section.add "appFilterMimeTypes", valid_593973
  var valid_593974 = query.getOrDefault("languageCode")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "languageCode", valid_593974
  var valid_593975 = query.getOrDefault("prettyPrint")
  valid_593975 = validateParameter(valid_593975, JBool, required = false,
                                 default = newJBool(true))
  if valid_593975 != nil:
    section.add "prettyPrint", valid_593975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593976: Call_DriveAppsList_593963; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a user's installed apps.
  ## 
  let valid = call_593976.validator(path, query, header, formData, body)
  let scheme = call_593976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593976.url(scheme.get, call_593976.host, call_593976.base,
                         call_593976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593976, url, valid)

proc call*(call_593977: Call_DriveAppsList_593963; fields: string = "";
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
  var query_593978 = newJObject()
  add(query_593978, "fields", newJString(fields))
  add(query_593978, "quotaUser", newJString(quotaUser))
  add(query_593978, "alt", newJString(alt))
  add(query_593978, "appFilterExtensions", newJString(appFilterExtensions))
  add(query_593978, "oauth_token", newJString(oauthToken))
  add(query_593978, "userIp", newJString(userIp))
  add(query_593978, "key", newJString(key))
  add(query_593978, "appFilterMimeTypes", newJString(appFilterMimeTypes))
  add(query_593978, "languageCode", newJString(languageCode))
  add(query_593978, "prettyPrint", newJBool(prettyPrint))
  result = call_593977.call(nil, query_593978, nil, nil, nil)

var driveAppsList* = Call_DriveAppsList_593963(name: "driveAppsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/apps",
    validator: validate_DriveAppsList_593964, base: "/drive/v2",
    url: url_DriveAppsList_593965, schemes: {Scheme.Https})
type
  Call_DriveAppsGet_593979 = ref object of OpenApiRestCall_593424
proc url_DriveAppsGet_593981(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveAppsGet_593980(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593996 = path.getOrDefault("appId")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "appId", valid_593996
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
  var valid_593997 = query.getOrDefault("fields")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "fields", valid_593997
  var valid_593998 = query.getOrDefault("quotaUser")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "quotaUser", valid_593998
  var valid_593999 = query.getOrDefault("alt")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = newJString("json"))
  if valid_593999 != nil:
    section.add "alt", valid_593999
  var valid_594000 = query.getOrDefault("oauth_token")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = nil)
  if valid_594000 != nil:
    section.add "oauth_token", valid_594000
  var valid_594001 = query.getOrDefault("userIp")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "userIp", valid_594001
  var valid_594002 = query.getOrDefault("key")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "key", valid_594002
  var valid_594003 = query.getOrDefault("prettyPrint")
  valid_594003 = validateParameter(valid_594003, JBool, required = false,
                                 default = newJBool(true))
  if valid_594003 != nil:
    section.add "prettyPrint", valid_594003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594004: Call_DriveAppsGet_593979; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific app.
  ## 
  let valid = call_594004.validator(path, query, header, formData, body)
  let scheme = call_594004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594004.url(scheme.get, call_594004.host, call_594004.base,
                         call_594004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594004, url, valid)

proc call*(call_594005: Call_DriveAppsGet_593979; appId: string; fields: string = "";
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
  var path_594006 = newJObject()
  var query_594007 = newJObject()
  add(query_594007, "fields", newJString(fields))
  add(query_594007, "quotaUser", newJString(quotaUser))
  add(query_594007, "alt", newJString(alt))
  add(query_594007, "oauth_token", newJString(oauthToken))
  add(query_594007, "userIp", newJString(userIp))
  add(path_594006, "appId", newJString(appId))
  add(query_594007, "key", newJString(key))
  add(query_594007, "prettyPrint", newJBool(prettyPrint))
  result = call_594005.call(path_594006, query_594007, nil, nil, nil)

var driveAppsGet* = Call_DriveAppsGet_593979(name: "driveAppsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/apps/{appId}",
    validator: validate_DriveAppsGet_593980, base: "/drive/v2",
    url: url_DriveAppsGet_593981, schemes: {Scheme.Https})
type
  Call_DriveChangesList_594008 = ref object of OpenApiRestCall_593424
proc url_DriveChangesList_594010(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DriveChangesList_594009(path: JsonNode; query: JsonNode;
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
  var valid_594011 = query.getOrDefault("driveId")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "driveId", valid_594011
  var valid_594012 = query.getOrDefault("supportsAllDrives")
  valid_594012 = validateParameter(valid_594012, JBool, required = false,
                                 default = newJBool(false))
  if valid_594012 != nil:
    section.add "supportsAllDrives", valid_594012
  var valid_594013 = query.getOrDefault("fields")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "fields", valid_594013
  var valid_594014 = query.getOrDefault("pageToken")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "pageToken", valid_594014
  var valid_594015 = query.getOrDefault("quotaUser")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "quotaUser", valid_594015
  var valid_594016 = query.getOrDefault("alt")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = newJString("json"))
  if valid_594016 != nil:
    section.add "alt", valid_594016
  var valid_594017 = query.getOrDefault("oauth_token")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "oauth_token", valid_594017
  var valid_594018 = query.getOrDefault("includeItemsFromAllDrives")
  valid_594018 = validateParameter(valid_594018, JBool, required = false,
                                 default = newJBool(false))
  if valid_594018 != nil:
    section.add "includeItemsFromAllDrives", valid_594018
  var valid_594019 = query.getOrDefault("userIp")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "userIp", valid_594019
  var valid_594020 = query.getOrDefault("includeTeamDriveItems")
  valid_594020 = validateParameter(valid_594020, JBool, required = false,
                                 default = newJBool(false))
  if valid_594020 != nil:
    section.add "includeTeamDriveItems", valid_594020
  var valid_594021 = query.getOrDefault("teamDriveId")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = nil)
  if valid_594021 != nil:
    section.add "teamDriveId", valid_594021
  var valid_594022 = query.getOrDefault("includeSubscribed")
  valid_594022 = validateParameter(valid_594022, JBool, required = false,
                                 default = newJBool(true))
  if valid_594022 != nil:
    section.add "includeSubscribed", valid_594022
  var valid_594024 = query.getOrDefault("maxResults")
  valid_594024 = validateParameter(valid_594024, JInt, required = false,
                                 default = newJInt(100))
  if valid_594024 != nil:
    section.add "maxResults", valid_594024
  var valid_594025 = query.getOrDefault("supportsTeamDrives")
  valid_594025 = validateParameter(valid_594025, JBool, required = false,
                                 default = newJBool(false))
  if valid_594025 != nil:
    section.add "supportsTeamDrives", valid_594025
  var valid_594026 = query.getOrDefault("key")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "key", valid_594026
  var valid_594027 = query.getOrDefault("includeDeleted")
  valid_594027 = validateParameter(valid_594027, JBool, required = false,
                                 default = newJBool(true))
  if valid_594027 != nil:
    section.add "includeDeleted", valid_594027
  var valid_594028 = query.getOrDefault("spaces")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "spaces", valid_594028
  var valid_594029 = query.getOrDefault("prettyPrint")
  valid_594029 = validateParameter(valid_594029, JBool, required = false,
                                 default = newJBool(true))
  if valid_594029 != nil:
    section.add "prettyPrint", valid_594029
  var valid_594030 = query.getOrDefault("startChangeId")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "startChangeId", valid_594030
  var valid_594031 = query.getOrDefault("includeCorpusRemovals")
  valid_594031 = validateParameter(valid_594031, JBool, required = false,
                                 default = newJBool(false))
  if valid_594031 != nil:
    section.add "includeCorpusRemovals", valid_594031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594032: Call_DriveChangesList_594008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the changes for a user or shared drive.
  ## 
  let valid = call_594032.validator(path, query, header, formData, body)
  let scheme = call_594032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594032.url(scheme.get, call_594032.host, call_594032.base,
                         call_594032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594032, url, valid)

proc call*(call_594033: Call_DriveChangesList_594008; driveId: string = "";
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
  var query_594034 = newJObject()
  add(query_594034, "driveId", newJString(driveId))
  add(query_594034, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594034, "fields", newJString(fields))
  add(query_594034, "pageToken", newJString(pageToken))
  add(query_594034, "quotaUser", newJString(quotaUser))
  add(query_594034, "alt", newJString(alt))
  add(query_594034, "oauth_token", newJString(oauthToken))
  add(query_594034, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_594034, "userIp", newJString(userIp))
  add(query_594034, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  add(query_594034, "teamDriveId", newJString(teamDriveId))
  add(query_594034, "includeSubscribed", newJBool(includeSubscribed))
  add(query_594034, "maxResults", newJInt(maxResults))
  add(query_594034, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594034, "key", newJString(key))
  add(query_594034, "includeDeleted", newJBool(includeDeleted))
  add(query_594034, "spaces", newJString(spaces))
  add(query_594034, "prettyPrint", newJBool(prettyPrint))
  add(query_594034, "startChangeId", newJString(startChangeId))
  add(query_594034, "includeCorpusRemovals", newJBool(includeCorpusRemovals))
  result = call_594033.call(nil, query_594034, nil, nil, nil)

var driveChangesList* = Call_DriveChangesList_594008(name: "driveChangesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/changes",
    validator: validate_DriveChangesList_594009, base: "/drive/v2",
    url: url_DriveChangesList_594010, schemes: {Scheme.Https})
type
  Call_DriveChangesGetStartPageToken_594035 = ref object of OpenApiRestCall_593424
proc url_DriveChangesGetStartPageToken_594037(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DriveChangesGetStartPageToken_594036(path: JsonNode; query: JsonNode;
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
  var valid_594038 = query.getOrDefault("driveId")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "driveId", valid_594038
  var valid_594039 = query.getOrDefault("supportsAllDrives")
  valid_594039 = validateParameter(valid_594039, JBool, required = false,
                                 default = newJBool(false))
  if valid_594039 != nil:
    section.add "supportsAllDrives", valid_594039
  var valid_594040 = query.getOrDefault("fields")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "fields", valid_594040
  var valid_594041 = query.getOrDefault("quotaUser")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "quotaUser", valid_594041
  var valid_594042 = query.getOrDefault("alt")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = newJString("json"))
  if valid_594042 != nil:
    section.add "alt", valid_594042
  var valid_594043 = query.getOrDefault("oauth_token")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "oauth_token", valid_594043
  var valid_594044 = query.getOrDefault("userIp")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "userIp", valid_594044
  var valid_594045 = query.getOrDefault("teamDriveId")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "teamDriveId", valid_594045
  var valid_594046 = query.getOrDefault("supportsTeamDrives")
  valid_594046 = validateParameter(valid_594046, JBool, required = false,
                                 default = newJBool(false))
  if valid_594046 != nil:
    section.add "supportsTeamDrives", valid_594046
  var valid_594047 = query.getOrDefault("key")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "key", valid_594047
  var valid_594048 = query.getOrDefault("prettyPrint")
  valid_594048 = validateParameter(valid_594048, JBool, required = false,
                                 default = newJBool(true))
  if valid_594048 != nil:
    section.add "prettyPrint", valid_594048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594049: Call_DriveChangesGetStartPageToken_594035; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the starting pageToken for listing future changes.
  ## 
  let valid = call_594049.validator(path, query, header, formData, body)
  let scheme = call_594049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594049.url(scheme.get, call_594049.host, call_594049.base,
                         call_594049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594049, url, valid)

proc call*(call_594050: Call_DriveChangesGetStartPageToken_594035;
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
  var query_594051 = newJObject()
  add(query_594051, "driveId", newJString(driveId))
  add(query_594051, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594051, "fields", newJString(fields))
  add(query_594051, "quotaUser", newJString(quotaUser))
  add(query_594051, "alt", newJString(alt))
  add(query_594051, "oauth_token", newJString(oauthToken))
  add(query_594051, "userIp", newJString(userIp))
  add(query_594051, "teamDriveId", newJString(teamDriveId))
  add(query_594051, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594051, "key", newJString(key))
  add(query_594051, "prettyPrint", newJBool(prettyPrint))
  result = call_594050.call(nil, query_594051, nil, nil, nil)

var driveChangesGetStartPageToken* = Call_DriveChangesGetStartPageToken_594035(
    name: "driveChangesGetStartPageToken", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/changes/startPageToken",
    validator: validate_DriveChangesGetStartPageToken_594036, base: "/drive/v2",
    url: url_DriveChangesGetStartPageToken_594037, schemes: {Scheme.Https})
type
  Call_DriveChangesWatch_594052 = ref object of OpenApiRestCall_593424
proc url_DriveChangesWatch_594054(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DriveChangesWatch_594053(path: JsonNode; query: JsonNode;
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
  var valid_594055 = query.getOrDefault("driveId")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "driveId", valid_594055
  var valid_594056 = query.getOrDefault("supportsAllDrives")
  valid_594056 = validateParameter(valid_594056, JBool, required = false,
                                 default = newJBool(false))
  if valid_594056 != nil:
    section.add "supportsAllDrives", valid_594056
  var valid_594057 = query.getOrDefault("fields")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "fields", valid_594057
  var valid_594058 = query.getOrDefault("pageToken")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "pageToken", valid_594058
  var valid_594059 = query.getOrDefault("quotaUser")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "quotaUser", valid_594059
  var valid_594060 = query.getOrDefault("alt")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = newJString("json"))
  if valid_594060 != nil:
    section.add "alt", valid_594060
  var valid_594061 = query.getOrDefault("oauth_token")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "oauth_token", valid_594061
  var valid_594062 = query.getOrDefault("includeItemsFromAllDrives")
  valid_594062 = validateParameter(valid_594062, JBool, required = false,
                                 default = newJBool(false))
  if valid_594062 != nil:
    section.add "includeItemsFromAllDrives", valid_594062
  var valid_594063 = query.getOrDefault("userIp")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "userIp", valid_594063
  var valid_594064 = query.getOrDefault("includeTeamDriveItems")
  valid_594064 = validateParameter(valid_594064, JBool, required = false,
                                 default = newJBool(false))
  if valid_594064 != nil:
    section.add "includeTeamDriveItems", valid_594064
  var valid_594065 = query.getOrDefault("teamDriveId")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "teamDriveId", valid_594065
  var valid_594066 = query.getOrDefault("includeSubscribed")
  valid_594066 = validateParameter(valid_594066, JBool, required = false,
                                 default = newJBool(true))
  if valid_594066 != nil:
    section.add "includeSubscribed", valid_594066
  var valid_594067 = query.getOrDefault("maxResults")
  valid_594067 = validateParameter(valid_594067, JInt, required = false,
                                 default = newJInt(100))
  if valid_594067 != nil:
    section.add "maxResults", valid_594067
  var valid_594068 = query.getOrDefault("supportsTeamDrives")
  valid_594068 = validateParameter(valid_594068, JBool, required = false,
                                 default = newJBool(false))
  if valid_594068 != nil:
    section.add "supportsTeamDrives", valid_594068
  var valid_594069 = query.getOrDefault("key")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "key", valid_594069
  var valid_594070 = query.getOrDefault("includeDeleted")
  valid_594070 = validateParameter(valid_594070, JBool, required = false,
                                 default = newJBool(true))
  if valid_594070 != nil:
    section.add "includeDeleted", valid_594070
  var valid_594071 = query.getOrDefault("spaces")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "spaces", valid_594071
  var valid_594072 = query.getOrDefault("prettyPrint")
  valid_594072 = validateParameter(valid_594072, JBool, required = false,
                                 default = newJBool(true))
  if valid_594072 != nil:
    section.add "prettyPrint", valid_594072
  var valid_594073 = query.getOrDefault("startChangeId")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "startChangeId", valid_594073
  var valid_594074 = query.getOrDefault("includeCorpusRemovals")
  valid_594074 = validateParameter(valid_594074, JBool, required = false,
                                 default = newJBool(false))
  if valid_594074 != nil:
    section.add "includeCorpusRemovals", valid_594074
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

proc call*(call_594076: Call_DriveChangesWatch_594052; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Subscribe to changes for a user.
  ## 
  let valid = call_594076.validator(path, query, header, formData, body)
  let scheme = call_594076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594076.url(scheme.get, call_594076.host, call_594076.base,
                         call_594076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594076, url, valid)

proc call*(call_594077: Call_DriveChangesWatch_594052; driveId: string = "";
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
  var query_594078 = newJObject()
  var body_594079 = newJObject()
  add(query_594078, "driveId", newJString(driveId))
  add(query_594078, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594078, "fields", newJString(fields))
  add(query_594078, "pageToken", newJString(pageToken))
  add(query_594078, "quotaUser", newJString(quotaUser))
  add(query_594078, "alt", newJString(alt))
  add(query_594078, "oauth_token", newJString(oauthToken))
  add(query_594078, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_594078, "userIp", newJString(userIp))
  add(query_594078, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  add(query_594078, "teamDriveId", newJString(teamDriveId))
  add(query_594078, "includeSubscribed", newJBool(includeSubscribed))
  add(query_594078, "maxResults", newJInt(maxResults))
  add(query_594078, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594078, "key", newJString(key))
  add(query_594078, "includeDeleted", newJBool(includeDeleted))
  add(query_594078, "spaces", newJString(spaces))
  if resource != nil:
    body_594079 = resource
  add(query_594078, "prettyPrint", newJBool(prettyPrint))
  add(query_594078, "startChangeId", newJString(startChangeId))
  add(query_594078, "includeCorpusRemovals", newJBool(includeCorpusRemovals))
  result = call_594077.call(nil, query_594078, nil, nil, body_594079)

var driveChangesWatch* = Call_DriveChangesWatch_594052(name: "driveChangesWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/changes/watch",
    validator: validate_DriveChangesWatch_594053, base: "/drive/v2",
    url: url_DriveChangesWatch_594054, schemes: {Scheme.Https})
type
  Call_DriveChangesGet_594080 = ref object of OpenApiRestCall_593424
proc url_DriveChangesGet_594082(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "changeId" in path, "`changeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/changes/"),
               (kind: VariableSegment, value: "changeId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveChangesGet_594081(path: JsonNode; query: JsonNode;
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
  var valid_594083 = path.getOrDefault("changeId")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "changeId", valid_594083
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
  var valid_594084 = query.getOrDefault("driveId")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "driveId", valid_594084
  var valid_594085 = query.getOrDefault("supportsAllDrives")
  valid_594085 = validateParameter(valid_594085, JBool, required = false,
                                 default = newJBool(false))
  if valid_594085 != nil:
    section.add "supportsAllDrives", valid_594085
  var valid_594086 = query.getOrDefault("fields")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "fields", valid_594086
  var valid_594087 = query.getOrDefault("quotaUser")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "quotaUser", valid_594087
  var valid_594088 = query.getOrDefault("alt")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = newJString("json"))
  if valid_594088 != nil:
    section.add "alt", valid_594088
  var valid_594089 = query.getOrDefault("oauth_token")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "oauth_token", valid_594089
  var valid_594090 = query.getOrDefault("userIp")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "userIp", valid_594090
  var valid_594091 = query.getOrDefault("teamDriveId")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "teamDriveId", valid_594091
  var valid_594092 = query.getOrDefault("supportsTeamDrives")
  valid_594092 = validateParameter(valid_594092, JBool, required = false,
                                 default = newJBool(false))
  if valid_594092 != nil:
    section.add "supportsTeamDrives", valid_594092
  var valid_594093 = query.getOrDefault("key")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "key", valid_594093
  var valid_594094 = query.getOrDefault("prettyPrint")
  valid_594094 = validateParameter(valid_594094, JBool, required = false,
                                 default = newJBool(true))
  if valid_594094 != nil:
    section.add "prettyPrint", valid_594094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594095: Call_DriveChangesGet_594080; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated - Use changes.getStartPageToken and changes.list to retrieve recent changes.
  ## 
  let valid = call_594095.validator(path, query, header, formData, body)
  let scheme = call_594095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594095.url(scheme.get, call_594095.host, call_594095.base,
                         call_594095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594095, url, valid)

proc call*(call_594096: Call_DriveChangesGet_594080; changeId: string;
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
  var path_594097 = newJObject()
  var query_594098 = newJObject()
  add(query_594098, "driveId", newJString(driveId))
  add(query_594098, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594098, "fields", newJString(fields))
  add(path_594097, "changeId", newJString(changeId))
  add(query_594098, "quotaUser", newJString(quotaUser))
  add(query_594098, "alt", newJString(alt))
  add(query_594098, "oauth_token", newJString(oauthToken))
  add(query_594098, "userIp", newJString(userIp))
  add(query_594098, "teamDriveId", newJString(teamDriveId))
  add(query_594098, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594098, "key", newJString(key))
  add(query_594098, "prettyPrint", newJBool(prettyPrint))
  result = call_594096.call(path_594097, query_594098, nil, nil, nil)

var driveChangesGet* = Call_DriveChangesGet_594080(name: "driveChangesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/changes/{changeId}", validator: validate_DriveChangesGet_594081,
    base: "/drive/v2", url: url_DriveChangesGet_594082, schemes: {Scheme.Https})
type
  Call_DriveChannelsStop_594099 = ref object of OpenApiRestCall_593424
proc url_DriveChannelsStop_594101(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DriveChannelsStop_594100(path: JsonNode; query: JsonNode;
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
  var valid_594102 = query.getOrDefault("fields")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = nil)
  if valid_594102 != nil:
    section.add "fields", valid_594102
  var valid_594103 = query.getOrDefault("quotaUser")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "quotaUser", valid_594103
  var valid_594104 = query.getOrDefault("alt")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = newJString("json"))
  if valid_594104 != nil:
    section.add "alt", valid_594104
  var valid_594105 = query.getOrDefault("oauth_token")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "oauth_token", valid_594105
  var valid_594106 = query.getOrDefault("userIp")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "userIp", valid_594106
  var valid_594107 = query.getOrDefault("key")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = nil)
  if valid_594107 != nil:
    section.add "key", valid_594107
  var valid_594108 = query.getOrDefault("prettyPrint")
  valid_594108 = validateParameter(valid_594108, JBool, required = false,
                                 default = newJBool(true))
  if valid_594108 != nil:
    section.add "prettyPrint", valid_594108
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

proc call*(call_594110: Call_DriveChannelsStop_594099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_594110.validator(path, query, header, formData, body)
  let scheme = call_594110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594110.url(scheme.get, call_594110.host, call_594110.base,
                         call_594110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594110, url, valid)

proc call*(call_594111: Call_DriveChannelsStop_594099; fields: string = "";
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
  var query_594112 = newJObject()
  var body_594113 = newJObject()
  add(query_594112, "fields", newJString(fields))
  add(query_594112, "quotaUser", newJString(quotaUser))
  add(query_594112, "alt", newJString(alt))
  add(query_594112, "oauth_token", newJString(oauthToken))
  add(query_594112, "userIp", newJString(userIp))
  add(query_594112, "key", newJString(key))
  if resource != nil:
    body_594113 = resource
  add(query_594112, "prettyPrint", newJBool(prettyPrint))
  result = call_594111.call(nil, query_594112, nil, nil, body_594113)

var driveChannelsStop* = Call_DriveChannelsStop_594099(name: "driveChannelsStop",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/channels/stop",
    validator: validate_DriveChannelsStop_594100, base: "/drive/v2",
    url: url_DriveChannelsStop_594101, schemes: {Scheme.Https})
type
  Call_DriveDrivesInsert_594131 = ref object of OpenApiRestCall_593424
proc url_DriveDrivesInsert_594133(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DriveDrivesInsert_594132(path: JsonNode; query: JsonNode;
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
  var valid_594134 = query.getOrDefault("fields")
  valid_594134 = validateParameter(valid_594134, JString, required = false,
                                 default = nil)
  if valid_594134 != nil:
    section.add "fields", valid_594134
  assert query != nil,
        "query argument is necessary due to required `requestId` field"
  var valid_594135 = query.getOrDefault("requestId")
  valid_594135 = validateParameter(valid_594135, JString, required = true,
                                 default = nil)
  if valid_594135 != nil:
    section.add "requestId", valid_594135
  var valid_594136 = query.getOrDefault("quotaUser")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = nil)
  if valid_594136 != nil:
    section.add "quotaUser", valid_594136
  var valid_594137 = query.getOrDefault("alt")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = newJString("json"))
  if valid_594137 != nil:
    section.add "alt", valid_594137
  var valid_594138 = query.getOrDefault("oauth_token")
  valid_594138 = validateParameter(valid_594138, JString, required = false,
                                 default = nil)
  if valid_594138 != nil:
    section.add "oauth_token", valid_594138
  var valid_594139 = query.getOrDefault("userIp")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = nil)
  if valid_594139 != nil:
    section.add "userIp", valid_594139
  var valid_594140 = query.getOrDefault("key")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "key", valid_594140
  var valid_594141 = query.getOrDefault("prettyPrint")
  valid_594141 = validateParameter(valid_594141, JBool, required = false,
                                 default = newJBool(true))
  if valid_594141 != nil:
    section.add "prettyPrint", valid_594141
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

proc call*(call_594143: Call_DriveDrivesInsert_594131; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new shared drive.
  ## 
  let valid = call_594143.validator(path, query, header, formData, body)
  let scheme = call_594143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594143.url(scheme.get, call_594143.host, call_594143.base,
                         call_594143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594143, url, valid)

proc call*(call_594144: Call_DriveDrivesInsert_594131; requestId: string;
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
  var query_594145 = newJObject()
  var body_594146 = newJObject()
  add(query_594145, "fields", newJString(fields))
  add(query_594145, "requestId", newJString(requestId))
  add(query_594145, "quotaUser", newJString(quotaUser))
  add(query_594145, "alt", newJString(alt))
  add(query_594145, "oauth_token", newJString(oauthToken))
  add(query_594145, "userIp", newJString(userIp))
  add(query_594145, "key", newJString(key))
  if body != nil:
    body_594146 = body
  add(query_594145, "prettyPrint", newJBool(prettyPrint))
  result = call_594144.call(nil, query_594145, nil, nil, body_594146)

var driveDrivesInsert* = Call_DriveDrivesInsert_594131(name: "driveDrivesInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/drives",
    validator: validate_DriveDrivesInsert_594132, base: "/drive/v2",
    url: url_DriveDrivesInsert_594133, schemes: {Scheme.Https})
type
  Call_DriveDrivesList_594114 = ref object of OpenApiRestCall_593424
proc url_DriveDrivesList_594116(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DriveDrivesList_594115(path: JsonNode; query: JsonNode;
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
  var valid_594117 = query.getOrDefault("fields")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = nil)
  if valid_594117 != nil:
    section.add "fields", valid_594117
  var valid_594118 = query.getOrDefault("pageToken")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = nil)
  if valid_594118 != nil:
    section.add "pageToken", valid_594118
  var valid_594119 = query.getOrDefault("quotaUser")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "quotaUser", valid_594119
  var valid_594120 = query.getOrDefault("alt")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = newJString("json"))
  if valid_594120 != nil:
    section.add "alt", valid_594120
  var valid_594121 = query.getOrDefault("oauth_token")
  valid_594121 = validateParameter(valid_594121, JString, required = false,
                                 default = nil)
  if valid_594121 != nil:
    section.add "oauth_token", valid_594121
  var valid_594122 = query.getOrDefault("userIp")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = nil)
  if valid_594122 != nil:
    section.add "userIp", valid_594122
  var valid_594123 = query.getOrDefault("maxResults")
  valid_594123 = validateParameter(valid_594123, JInt, required = false,
                                 default = newJInt(10))
  if valid_594123 != nil:
    section.add "maxResults", valid_594123
  var valid_594124 = query.getOrDefault("q")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "q", valid_594124
  var valid_594125 = query.getOrDefault("key")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = nil)
  if valid_594125 != nil:
    section.add "key", valid_594125
  var valid_594126 = query.getOrDefault("useDomainAdminAccess")
  valid_594126 = validateParameter(valid_594126, JBool, required = false,
                                 default = newJBool(false))
  if valid_594126 != nil:
    section.add "useDomainAdminAccess", valid_594126
  var valid_594127 = query.getOrDefault("prettyPrint")
  valid_594127 = validateParameter(valid_594127, JBool, required = false,
                                 default = newJBool(true))
  if valid_594127 != nil:
    section.add "prettyPrint", valid_594127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594128: Call_DriveDrivesList_594114; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the user's shared drives.
  ## 
  let valid = call_594128.validator(path, query, header, formData, body)
  let scheme = call_594128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594128.url(scheme.get, call_594128.host, call_594128.base,
                         call_594128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594128, url, valid)

proc call*(call_594129: Call_DriveDrivesList_594114; fields: string = "";
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
  var query_594130 = newJObject()
  add(query_594130, "fields", newJString(fields))
  add(query_594130, "pageToken", newJString(pageToken))
  add(query_594130, "quotaUser", newJString(quotaUser))
  add(query_594130, "alt", newJString(alt))
  add(query_594130, "oauth_token", newJString(oauthToken))
  add(query_594130, "userIp", newJString(userIp))
  add(query_594130, "maxResults", newJInt(maxResults))
  add(query_594130, "q", newJString(q))
  add(query_594130, "key", newJString(key))
  add(query_594130, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_594130, "prettyPrint", newJBool(prettyPrint))
  result = call_594129.call(nil, query_594130, nil, nil, nil)

var driveDrivesList* = Call_DriveDrivesList_594114(name: "driveDrivesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/drives",
    validator: validate_DriveDrivesList_594115, base: "/drive/v2",
    url: url_DriveDrivesList_594116, schemes: {Scheme.Https})
type
  Call_DriveDrivesUpdate_594163 = ref object of OpenApiRestCall_593424
proc url_DriveDrivesUpdate_594165(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "driveId" in path, "`driveId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/drives/"),
               (kind: VariableSegment, value: "driveId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveDrivesUpdate_594164(path: JsonNode; query: JsonNode;
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
  var valid_594166 = path.getOrDefault("driveId")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "driveId", valid_594166
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
  var valid_594167 = query.getOrDefault("fields")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = nil)
  if valid_594167 != nil:
    section.add "fields", valid_594167
  var valid_594168 = query.getOrDefault("quotaUser")
  valid_594168 = validateParameter(valid_594168, JString, required = false,
                                 default = nil)
  if valid_594168 != nil:
    section.add "quotaUser", valid_594168
  var valid_594169 = query.getOrDefault("alt")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = newJString("json"))
  if valid_594169 != nil:
    section.add "alt", valid_594169
  var valid_594170 = query.getOrDefault("oauth_token")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "oauth_token", valid_594170
  var valid_594171 = query.getOrDefault("userIp")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = nil)
  if valid_594171 != nil:
    section.add "userIp", valid_594171
  var valid_594172 = query.getOrDefault("key")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = nil)
  if valid_594172 != nil:
    section.add "key", valid_594172
  var valid_594173 = query.getOrDefault("useDomainAdminAccess")
  valid_594173 = validateParameter(valid_594173, JBool, required = false,
                                 default = newJBool(false))
  if valid_594173 != nil:
    section.add "useDomainAdminAccess", valid_594173
  var valid_594174 = query.getOrDefault("prettyPrint")
  valid_594174 = validateParameter(valid_594174, JBool, required = false,
                                 default = newJBool(true))
  if valid_594174 != nil:
    section.add "prettyPrint", valid_594174
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

proc call*(call_594176: Call_DriveDrivesUpdate_594163; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the metadata for a shared drive.
  ## 
  let valid = call_594176.validator(path, query, header, formData, body)
  let scheme = call_594176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594176.url(scheme.get, call_594176.host, call_594176.base,
                         call_594176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594176, url, valid)

proc call*(call_594177: Call_DriveDrivesUpdate_594163; driveId: string;
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
  var path_594178 = newJObject()
  var query_594179 = newJObject()
  var body_594180 = newJObject()
  add(query_594179, "fields", newJString(fields))
  add(path_594178, "driveId", newJString(driveId))
  add(query_594179, "quotaUser", newJString(quotaUser))
  add(query_594179, "alt", newJString(alt))
  add(query_594179, "oauth_token", newJString(oauthToken))
  add(query_594179, "userIp", newJString(userIp))
  add(query_594179, "key", newJString(key))
  add(query_594179, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  if body != nil:
    body_594180 = body
  add(query_594179, "prettyPrint", newJBool(prettyPrint))
  result = call_594177.call(path_594178, query_594179, nil, nil, body_594180)

var driveDrivesUpdate* = Call_DriveDrivesUpdate_594163(name: "driveDrivesUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesUpdate_594164,
    base: "/drive/v2", url: url_DriveDrivesUpdate_594165, schemes: {Scheme.Https})
type
  Call_DriveDrivesGet_594147 = ref object of OpenApiRestCall_593424
proc url_DriveDrivesGet_594149(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "driveId" in path, "`driveId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/drives/"),
               (kind: VariableSegment, value: "driveId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveDrivesGet_594148(path: JsonNode; query: JsonNode;
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
  var valid_594150 = path.getOrDefault("driveId")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "driveId", valid_594150
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
  var valid_594151 = query.getOrDefault("fields")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = nil)
  if valid_594151 != nil:
    section.add "fields", valid_594151
  var valid_594152 = query.getOrDefault("quotaUser")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = nil)
  if valid_594152 != nil:
    section.add "quotaUser", valid_594152
  var valid_594153 = query.getOrDefault("alt")
  valid_594153 = validateParameter(valid_594153, JString, required = false,
                                 default = newJString("json"))
  if valid_594153 != nil:
    section.add "alt", valid_594153
  var valid_594154 = query.getOrDefault("oauth_token")
  valid_594154 = validateParameter(valid_594154, JString, required = false,
                                 default = nil)
  if valid_594154 != nil:
    section.add "oauth_token", valid_594154
  var valid_594155 = query.getOrDefault("userIp")
  valid_594155 = validateParameter(valid_594155, JString, required = false,
                                 default = nil)
  if valid_594155 != nil:
    section.add "userIp", valid_594155
  var valid_594156 = query.getOrDefault("key")
  valid_594156 = validateParameter(valid_594156, JString, required = false,
                                 default = nil)
  if valid_594156 != nil:
    section.add "key", valid_594156
  var valid_594157 = query.getOrDefault("useDomainAdminAccess")
  valid_594157 = validateParameter(valid_594157, JBool, required = false,
                                 default = newJBool(false))
  if valid_594157 != nil:
    section.add "useDomainAdminAccess", valid_594157
  var valid_594158 = query.getOrDefault("prettyPrint")
  valid_594158 = validateParameter(valid_594158, JBool, required = false,
                                 default = newJBool(true))
  if valid_594158 != nil:
    section.add "prettyPrint", valid_594158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594159: Call_DriveDrivesGet_594147; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a shared drive's metadata by ID.
  ## 
  let valid = call_594159.validator(path, query, header, formData, body)
  let scheme = call_594159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594159.url(scheme.get, call_594159.host, call_594159.base,
                         call_594159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594159, url, valid)

proc call*(call_594160: Call_DriveDrivesGet_594147; driveId: string;
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
  var path_594161 = newJObject()
  var query_594162 = newJObject()
  add(query_594162, "fields", newJString(fields))
  add(path_594161, "driveId", newJString(driveId))
  add(query_594162, "quotaUser", newJString(quotaUser))
  add(query_594162, "alt", newJString(alt))
  add(query_594162, "oauth_token", newJString(oauthToken))
  add(query_594162, "userIp", newJString(userIp))
  add(query_594162, "key", newJString(key))
  add(query_594162, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_594162, "prettyPrint", newJBool(prettyPrint))
  result = call_594160.call(path_594161, query_594162, nil, nil, nil)

var driveDrivesGet* = Call_DriveDrivesGet_594147(name: "driveDrivesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesGet_594148,
    base: "/drive/v2", url: url_DriveDrivesGet_594149, schemes: {Scheme.Https})
type
  Call_DriveDrivesDelete_594181 = ref object of OpenApiRestCall_593424
proc url_DriveDrivesDelete_594183(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "driveId" in path, "`driveId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/drives/"),
               (kind: VariableSegment, value: "driveId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveDrivesDelete_594182(path: JsonNode; query: JsonNode;
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
  var valid_594184 = path.getOrDefault("driveId")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "driveId", valid_594184
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
  var valid_594185 = query.getOrDefault("fields")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = nil)
  if valid_594185 != nil:
    section.add "fields", valid_594185
  var valid_594186 = query.getOrDefault("quotaUser")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = nil)
  if valid_594186 != nil:
    section.add "quotaUser", valid_594186
  var valid_594187 = query.getOrDefault("alt")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = newJString("json"))
  if valid_594187 != nil:
    section.add "alt", valid_594187
  var valid_594188 = query.getOrDefault("oauth_token")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = nil)
  if valid_594188 != nil:
    section.add "oauth_token", valid_594188
  var valid_594189 = query.getOrDefault("userIp")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = nil)
  if valid_594189 != nil:
    section.add "userIp", valid_594189
  var valid_594190 = query.getOrDefault("key")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = nil)
  if valid_594190 != nil:
    section.add "key", valid_594190
  var valid_594191 = query.getOrDefault("prettyPrint")
  valid_594191 = validateParameter(valid_594191, JBool, required = false,
                                 default = newJBool(true))
  if valid_594191 != nil:
    section.add "prettyPrint", valid_594191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594192: Call_DriveDrivesDelete_594181; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a shared drive for which the user is an organizer. The shared drive cannot contain any untrashed items.
  ## 
  let valid = call_594192.validator(path, query, header, formData, body)
  let scheme = call_594192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594192.url(scheme.get, call_594192.host, call_594192.base,
                         call_594192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594192, url, valid)

proc call*(call_594193: Call_DriveDrivesDelete_594181; driveId: string;
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
  var path_594194 = newJObject()
  var query_594195 = newJObject()
  add(query_594195, "fields", newJString(fields))
  add(path_594194, "driveId", newJString(driveId))
  add(query_594195, "quotaUser", newJString(quotaUser))
  add(query_594195, "alt", newJString(alt))
  add(query_594195, "oauth_token", newJString(oauthToken))
  add(query_594195, "userIp", newJString(userIp))
  add(query_594195, "key", newJString(key))
  add(query_594195, "prettyPrint", newJBool(prettyPrint))
  result = call_594193.call(path_594194, query_594195, nil, nil, nil)

var driveDrivesDelete* = Call_DriveDrivesDelete_594181(name: "driveDrivesDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesDelete_594182,
    base: "/drive/v2", url: url_DriveDrivesDelete_594183, schemes: {Scheme.Https})
type
  Call_DriveDrivesHide_594196 = ref object of OpenApiRestCall_593424
proc url_DriveDrivesHide_594198(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveDrivesHide_594197(path: JsonNode; query: JsonNode;
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
  var valid_594199 = path.getOrDefault("driveId")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "driveId", valid_594199
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
  var valid_594200 = query.getOrDefault("fields")
  valid_594200 = validateParameter(valid_594200, JString, required = false,
                                 default = nil)
  if valid_594200 != nil:
    section.add "fields", valid_594200
  var valid_594201 = query.getOrDefault("quotaUser")
  valid_594201 = validateParameter(valid_594201, JString, required = false,
                                 default = nil)
  if valid_594201 != nil:
    section.add "quotaUser", valid_594201
  var valid_594202 = query.getOrDefault("alt")
  valid_594202 = validateParameter(valid_594202, JString, required = false,
                                 default = newJString("json"))
  if valid_594202 != nil:
    section.add "alt", valid_594202
  var valid_594203 = query.getOrDefault("oauth_token")
  valid_594203 = validateParameter(valid_594203, JString, required = false,
                                 default = nil)
  if valid_594203 != nil:
    section.add "oauth_token", valid_594203
  var valid_594204 = query.getOrDefault("userIp")
  valid_594204 = validateParameter(valid_594204, JString, required = false,
                                 default = nil)
  if valid_594204 != nil:
    section.add "userIp", valid_594204
  var valid_594205 = query.getOrDefault("key")
  valid_594205 = validateParameter(valid_594205, JString, required = false,
                                 default = nil)
  if valid_594205 != nil:
    section.add "key", valid_594205
  var valid_594206 = query.getOrDefault("prettyPrint")
  valid_594206 = validateParameter(valid_594206, JBool, required = false,
                                 default = newJBool(true))
  if valid_594206 != nil:
    section.add "prettyPrint", valid_594206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594207: Call_DriveDrivesHide_594196; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Hides a shared drive from the default view.
  ## 
  let valid = call_594207.validator(path, query, header, formData, body)
  let scheme = call_594207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594207.url(scheme.get, call_594207.host, call_594207.base,
                         call_594207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594207, url, valid)

proc call*(call_594208: Call_DriveDrivesHide_594196; driveId: string;
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
  var path_594209 = newJObject()
  var query_594210 = newJObject()
  add(query_594210, "fields", newJString(fields))
  add(path_594209, "driveId", newJString(driveId))
  add(query_594210, "quotaUser", newJString(quotaUser))
  add(query_594210, "alt", newJString(alt))
  add(query_594210, "oauth_token", newJString(oauthToken))
  add(query_594210, "userIp", newJString(userIp))
  add(query_594210, "key", newJString(key))
  add(query_594210, "prettyPrint", newJBool(prettyPrint))
  result = call_594208.call(path_594209, query_594210, nil, nil, nil)

var driveDrivesHide* = Call_DriveDrivesHide_594196(name: "driveDrivesHide",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/drives/{driveId}/hide", validator: validate_DriveDrivesHide_594197,
    base: "/drive/v2", url: url_DriveDrivesHide_594198, schemes: {Scheme.Https})
type
  Call_DriveDrivesUnhide_594211 = ref object of OpenApiRestCall_593424
proc url_DriveDrivesUnhide_594213(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveDrivesUnhide_594212(path: JsonNode; query: JsonNode;
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
  var valid_594214 = path.getOrDefault("driveId")
  valid_594214 = validateParameter(valid_594214, JString, required = true,
                                 default = nil)
  if valid_594214 != nil:
    section.add "driveId", valid_594214
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
  var valid_594215 = query.getOrDefault("fields")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "fields", valid_594215
  var valid_594216 = query.getOrDefault("quotaUser")
  valid_594216 = validateParameter(valid_594216, JString, required = false,
                                 default = nil)
  if valid_594216 != nil:
    section.add "quotaUser", valid_594216
  var valid_594217 = query.getOrDefault("alt")
  valid_594217 = validateParameter(valid_594217, JString, required = false,
                                 default = newJString("json"))
  if valid_594217 != nil:
    section.add "alt", valid_594217
  var valid_594218 = query.getOrDefault("oauth_token")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = nil)
  if valid_594218 != nil:
    section.add "oauth_token", valid_594218
  var valid_594219 = query.getOrDefault("userIp")
  valid_594219 = validateParameter(valid_594219, JString, required = false,
                                 default = nil)
  if valid_594219 != nil:
    section.add "userIp", valid_594219
  var valid_594220 = query.getOrDefault("key")
  valid_594220 = validateParameter(valid_594220, JString, required = false,
                                 default = nil)
  if valid_594220 != nil:
    section.add "key", valid_594220
  var valid_594221 = query.getOrDefault("prettyPrint")
  valid_594221 = validateParameter(valid_594221, JBool, required = false,
                                 default = newJBool(true))
  if valid_594221 != nil:
    section.add "prettyPrint", valid_594221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594222: Call_DriveDrivesUnhide_594211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a shared drive to the default view.
  ## 
  let valid = call_594222.validator(path, query, header, formData, body)
  let scheme = call_594222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594222.url(scheme.get, call_594222.host, call_594222.base,
                         call_594222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594222, url, valid)

proc call*(call_594223: Call_DriveDrivesUnhide_594211; driveId: string;
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
  var path_594224 = newJObject()
  var query_594225 = newJObject()
  add(query_594225, "fields", newJString(fields))
  add(path_594224, "driveId", newJString(driveId))
  add(query_594225, "quotaUser", newJString(quotaUser))
  add(query_594225, "alt", newJString(alt))
  add(query_594225, "oauth_token", newJString(oauthToken))
  add(query_594225, "userIp", newJString(userIp))
  add(query_594225, "key", newJString(key))
  add(query_594225, "prettyPrint", newJBool(prettyPrint))
  result = call_594223.call(path_594224, query_594225, nil, nil, nil)

var driveDrivesUnhide* = Call_DriveDrivesUnhide_594211(name: "driveDrivesUnhide",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/drives/{driveId}/unhide", validator: validate_DriveDrivesUnhide_594212,
    base: "/drive/v2", url: url_DriveDrivesUnhide_594213, schemes: {Scheme.Https})
type
  Call_DriveFilesInsert_594253 = ref object of OpenApiRestCall_593424
proc url_DriveFilesInsert_594255(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DriveFilesInsert_594254(path: JsonNode; query: JsonNode;
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
  var valid_594256 = query.getOrDefault("supportsAllDrives")
  valid_594256 = validateParameter(valid_594256, JBool, required = false,
                                 default = newJBool(false))
  if valid_594256 != nil:
    section.add "supportsAllDrives", valid_594256
  var valid_594257 = query.getOrDefault("fields")
  valid_594257 = validateParameter(valid_594257, JString, required = false,
                                 default = nil)
  if valid_594257 != nil:
    section.add "fields", valid_594257
  var valid_594258 = query.getOrDefault("quotaUser")
  valid_594258 = validateParameter(valid_594258, JString, required = false,
                                 default = nil)
  if valid_594258 != nil:
    section.add "quotaUser", valid_594258
  var valid_594259 = query.getOrDefault("alt")
  valid_594259 = validateParameter(valid_594259, JString, required = false,
                                 default = newJString("json"))
  if valid_594259 != nil:
    section.add "alt", valid_594259
  var valid_594260 = query.getOrDefault("pinned")
  valid_594260 = validateParameter(valid_594260, JBool, required = false,
                                 default = newJBool(false))
  if valid_594260 != nil:
    section.add "pinned", valid_594260
  var valid_594261 = query.getOrDefault("oauth_token")
  valid_594261 = validateParameter(valid_594261, JString, required = false,
                                 default = nil)
  if valid_594261 != nil:
    section.add "oauth_token", valid_594261
  var valid_594262 = query.getOrDefault("userIp")
  valid_594262 = validateParameter(valid_594262, JString, required = false,
                                 default = nil)
  if valid_594262 != nil:
    section.add "userIp", valid_594262
  var valid_594263 = query.getOrDefault("ocr")
  valid_594263 = validateParameter(valid_594263, JBool, required = false,
                                 default = newJBool(false))
  if valid_594263 != nil:
    section.add "ocr", valid_594263
  var valid_594264 = query.getOrDefault("timedTextLanguage")
  valid_594264 = validateParameter(valid_594264, JString, required = false,
                                 default = nil)
  if valid_594264 != nil:
    section.add "timedTextLanguage", valid_594264
  var valid_594265 = query.getOrDefault("supportsTeamDrives")
  valid_594265 = validateParameter(valid_594265, JBool, required = false,
                                 default = newJBool(false))
  if valid_594265 != nil:
    section.add "supportsTeamDrives", valid_594265
  var valid_594266 = query.getOrDefault("key")
  valid_594266 = validateParameter(valid_594266, JString, required = false,
                                 default = nil)
  if valid_594266 != nil:
    section.add "key", valid_594266
  var valid_594267 = query.getOrDefault("convert")
  valid_594267 = validateParameter(valid_594267, JBool, required = false,
                                 default = newJBool(false))
  if valid_594267 != nil:
    section.add "convert", valid_594267
  var valid_594268 = query.getOrDefault("useContentAsIndexableText")
  valid_594268 = validateParameter(valid_594268, JBool, required = false,
                                 default = newJBool(false))
  if valid_594268 != nil:
    section.add "useContentAsIndexableText", valid_594268
  var valid_594269 = query.getOrDefault("prettyPrint")
  valid_594269 = validateParameter(valid_594269, JBool, required = false,
                                 default = newJBool(true))
  if valid_594269 != nil:
    section.add "prettyPrint", valid_594269
  var valid_594270 = query.getOrDefault("ocrLanguage")
  valid_594270 = validateParameter(valid_594270, JString, required = false,
                                 default = nil)
  if valid_594270 != nil:
    section.add "ocrLanguage", valid_594270
  var valid_594271 = query.getOrDefault("timedTextTrackName")
  valid_594271 = validateParameter(valid_594271, JString, required = false,
                                 default = nil)
  if valid_594271 != nil:
    section.add "timedTextTrackName", valid_594271
  var valid_594272 = query.getOrDefault("visibility")
  valid_594272 = validateParameter(valid_594272, JString, required = false,
                                 default = newJString("DEFAULT"))
  if valid_594272 != nil:
    section.add "visibility", valid_594272
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

proc call*(call_594274: Call_DriveFilesInsert_594253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Insert a new file.
  ## 
  let valid = call_594274.validator(path, query, header, formData, body)
  let scheme = call_594274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594274.url(scheme.get, call_594274.host, call_594274.base,
                         call_594274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594274, url, valid)

proc call*(call_594275: Call_DriveFilesInsert_594253;
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
  var query_594276 = newJObject()
  var body_594277 = newJObject()
  add(query_594276, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594276, "fields", newJString(fields))
  add(query_594276, "quotaUser", newJString(quotaUser))
  add(query_594276, "alt", newJString(alt))
  add(query_594276, "pinned", newJBool(pinned))
  add(query_594276, "oauth_token", newJString(oauthToken))
  add(query_594276, "userIp", newJString(userIp))
  add(query_594276, "ocr", newJBool(ocr))
  add(query_594276, "timedTextLanguage", newJString(timedTextLanguage))
  add(query_594276, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594276, "key", newJString(key))
  add(query_594276, "convert", newJBool(convert))
  add(query_594276, "useContentAsIndexableText",
      newJBool(useContentAsIndexableText))
  if body != nil:
    body_594277 = body
  add(query_594276, "prettyPrint", newJBool(prettyPrint))
  add(query_594276, "ocrLanguage", newJString(ocrLanguage))
  add(query_594276, "timedTextTrackName", newJString(timedTextTrackName))
  add(query_594276, "visibility", newJString(visibility))
  result = call_594275.call(nil, query_594276, nil, nil, body_594277)

var driveFilesInsert* = Call_DriveFilesInsert_594253(name: "driveFilesInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/files",
    validator: validate_DriveFilesInsert_594254, base: "/drive/v2",
    url: url_DriveFilesInsert_594255, schemes: {Scheme.Https})
type
  Call_DriveFilesList_594226 = ref object of OpenApiRestCall_593424
proc url_DriveFilesList_594228(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DriveFilesList_594227(path: JsonNode; query: JsonNode;
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
  var valid_594229 = query.getOrDefault("driveId")
  valid_594229 = validateParameter(valid_594229, JString, required = false,
                                 default = nil)
  if valid_594229 != nil:
    section.add "driveId", valid_594229
  var valid_594230 = query.getOrDefault("supportsAllDrives")
  valid_594230 = validateParameter(valid_594230, JBool, required = false,
                                 default = newJBool(false))
  if valid_594230 != nil:
    section.add "supportsAllDrives", valid_594230
  var valid_594231 = query.getOrDefault("fields")
  valid_594231 = validateParameter(valid_594231, JString, required = false,
                                 default = nil)
  if valid_594231 != nil:
    section.add "fields", valid_594231
  var valid_594232 = query.getOrDefault("pageToken")
  valid_594232 = validateParameter(valid_594232, JString, required = false,
                                 default = nil)
  if valid_594232 != nil:
    section.add "pageToken", valid_594232
  var valid_594233 = query.getOrDefault("quotaUser")
  valid_594233 = validateParameter(valid_594233, JString, required = false,
                                 default = nil)
  if valid_594233 != nil:
    section.add "quotaUser", valid_594233
  var valid_594234 = query.getOrDefault("alt")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = newJString("json"))
  if valid_594234 != nil:
    section.add "alt", valid_594234
  var valid_594235 = query.getOrDefault("oauth_token")
  valid_594235 = validateParameter(valid_594235, JString, required = false,
                                 default = nil)
  if valid_594235 != nil:
    section.add "oauth_token", valid_594235
  var valid_594236 = query.getOrDefault("includeItemsFromAllDrives")
  valid_594236 = validateParameter(valid_594236, JBool, required = false,
                                 default = newJBool(false))
  if valid_594236 != nil:
    section.add "includeItemsFromAllDrives", valid_594236
  var valid_594237 = query.getOrDefault("userIp")
  valid_594237 = validateParameter(valid_594237, JString, required = false,
                                 default = nil)
  if valid_594237 != nil:
    section.add "userIp", valid_594237
  var valid_594238 = query.getOrDefault("includeTeamDriveItems")
  valid_594238 = validateParameter(valid_594238, JBool, required = false,
                                 default = newJBool(false))
  if valid_594238 != nil:
    section.add "includeTeamDriveItems", valid_594238
  var valid_594239 = query.getOrDefault("teamDriveId")
  valid_594239 = validateParameter(valid_594239, JString, required = false,
                                 default = nil)
  if valid_594239 != nil:
    section.add "teamDriveId", valid_594239
  var valid_594240 = query.getOrDefault("corpus")
  valid_594240 = validateParameter(valid_594240, JString, required = false,
                                 default = newJString("DEFAULT"))
  if valid_594240 != nil:
    section.add "corpus", valid_594240
  var valid_594241 = query.getOrDefault("maxResults")
  valid_594241 = validateParameter(valid_594241, JInt, required = false,
                                 default = newJInt(100))
  if valid_594241 != nil:
    section.add "maxResults", valid_594241
  var valid_594242 = query.getOrDefault("orderBy")
  valid_594242 = validateParameter(valid_594242, JString, required = false,
                                 default = nil)
  if valid_594242 != nil:
    section.add "orderBy", valid_594242
  var valid_594243 = query.getOrDefault("q")
  valid_594243 = validateParameter(valid_594243, JString, required = false,
                                 default = nil)
  if valid_594243 != nil:
    section.add "q", valid_594243
  var valid_594244 = query.getOrDefault("supportsTeamDrives")
  valid_594244 = validateParameter(valid_594244, JBool, required = false,
                                 default = newJBool(false))
  if valid_594244 != nil:
    section.add "supportsTeamDrives", valid_594244
  var valid_594245 = query.getOrDefault("key")
  valid_594245 = validateParameter(valid_594245, JString, required = false,
                                 default = nil)
  if valid_594245 != nil:
    section.add "key", valid_594245
  var valid_594246 = query.getOrDefault("spaces")
  valid_594246 = validateParameter(valid_594246, JString, required = false,
                                 default = nil)
  if valid_594246 != nil:
    section.add "spaces", valid_594246
  var valid_594247 = query.getOrDefault("projection")
  valid_594247 = validateParameter(valid_594247, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_594247 != nil:
    section.add "projection", valid_594247
  var valid_594248 = query.getOrDefault("corpora")
  valid_594248 = validateParameter(valid_594248, JString, required = false,
                                 default = nil)
  if valid_594248 != nil:
    section.add "corpora", valid_594248
  var valid_594249 = query.getOrDefault("prettyPrint")
  valid_594249 = validateParameter(valid_594249, JBool, required = false,
                                 default = newJBool(true))
  if valid_594249 != nil:
    section.add "prettyPrint", valid_594249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594250: Call_DriveFilesList_594226; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the user's files.
  ## 
  let valid = call_594250.validator(path, query, header, formData, body)
  let scheme = call_594250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594250.url(scheme.get, call_594250.host, call_594250.base,
                         call_594250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594250, url, valid)

proc call*(call_594251: Call_DriveFilesList_594226; driveId: string = "";
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
  var query_594252 = newJObject()
  add(query_594252, "driveId", newJString(driveId))
  add(query_594252, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594252, "fields", newJString(fields))
  add(query_594252, "pageToken", newJString(pageToken))
  add(query_594252, "quotaUser", newJString(quotaUser))
  add(query_594252, "alt", newJString(alt))
  add(query_594252, "oauth_token", newJString(oauthToken))
  add(query_594252, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_594252, "userIp", newJString(userIp))
  add(query_594252, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  add(query_594252, "teamDriveId", newJString(teamDriveId))
  add(query_594252, "corpus", newJString(corpus))
  add(query_594252, "maxResults", newJInt(maxResults))
  add(query_594252, "orderBy", newJString(orderBy))
  add(query_594252, "q", newJString(q))
  add(query_594252, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594252, "key", newJString(key))
  add(query_594252, "spaces", newJString(spaces))
  add(query_594252, "projection", newJString(projection))
  add(query_594252, "corpora", newJString(corpora))
  add(query_594252, "prettyPrint", newJBool(prettyPrint))
  result = call_594251.call(nil, query_594252, nil, nil, nil)

var driveFilesList* = Call_DriveFilesList_594226(name: "driveFilesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/files",
    validator: validate_DriveFilesList_594227, base: "/drive/v2",
    url: url_DriveFilesList_594228, schemes: {Scheme.Https})
type
  Call_DriveFilesGenerateIds_594278 = ref object of OpenApiRestCall_593424
proc url_DriveFilesGenerateIds_594280(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DriveFilesGenerateIds_594279(path: JsonNode; query: JsonNode;
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
  var valid_594281 = query.getOrDefault("fields")
  valid_594281 = validateParameter(valid_594281, JString, required = false,
                                 default = nil)
  if valid_594281 != nil:
    section.add "fields", valid_594281
  var valid_594282 = query.getOrDefault("quotaUser")
  valid_594282 = validateParameter(valid_594282, JString, required = false,
                                 default = nil)
  if valid_594282 != nil:
    section.add "quotaUser", valid_594282
  var valid_594283 = query.getOrDefault("alt")
  valid_594283 = validateParameter(valid_594283, JString, required = false,
                                 default = newJString("json"))
  if valid_594283 != nil:
    section.add "alt", valid_594283
  var valid_594284 = query.getOrDefault("oauth_token")
  valid_594284 = validateParameter(valid_594284, JString, required = false,
                                 default = nil)
  if valid_594284 != nil:
    section.add "oauth_token", valid_594284
  var valid_594285 = query.getOrDefault("space")
  valid_594285 = validateParameter(valid_594285, JString, required = false,
                                 default = newJString("drive"))
  if valid_594285 != nil:
    section.add "space", valid_594285
  var valid_594286 = query.getOrDefault("userIp")
  valid_594286 = validateParameter(valid_594286, JString, required = false,
                                 default = nil)
  if valid_594286 != nil:
    section.add "userIp", valid_594286
  var valid_594287 = query.getOrDefault("maxResults")
  valid_594287 = validateParameter(valid_594287, JInt, required = false,
                                 default = newJInt(10))
  if valid_594287 != nil:
    section.add "maxResults", valid_594287
  var valid_594288 = query.getOrDefault("key")
  valid_594288 = validateParameter(valid_594288, JString, required = false,
                                 default = nil)
  if valid_594288 != nil:
    section.add "key", valid_594288
  var valid_594289 = query.getOrDefault("prettyPrint")
  valid_594289 = validateParameter(valid_594289, JBool, required = false,
                                 default = newJBool(true))
  if valid_594289 != nil:
    section.add "prettyPrint", valid_594289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594290: Call_DriveFilesGenerateIds_594278; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates a set of file IDs which can be provided in insert or copy requests.
  ## 
  let valid = call_594290.validator(path, query, header, formData, body)
  let scheme = call_594290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594290.url(scheme.get, call_594290.host, call_594290.base,
                         call_594290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594290, url, valid)

proc call*(call_594291: Call_DriveFilesGenerateIds_594278; fields: string = "";
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
  var query_594292 = newJObject()
  add(query_594292, "fields", newJString(fields))
  add(query_594292, "quotaUser", newJString(quotaUser))
  add(query_594292, "alt", newJString(alt))
  add(query_594292, "oauth_token", newJString(oauthToken))
  add(query_594292, "space", newJString(space))
  add(query_594292, "userIp", newJString(userIp))
  add(query_594292, "maxResults", newJInt(maxResults))
  add(query_594292, "key", newJString(key))
  add(query_594292, "prettyPrint", newJBool(prettyPrint))
  result = call_594291.call(nil, query_594292, nil, nil, nil)

var driveFilesGenerateIds* = Call_DriveFilesGenerateIds_594278(
    name: "driveFilesGenerateIds", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/generateIds",
    validator: validate_DriveFilesGenerateIds_594279, base: "/drive/v2",
    url: url_DriveFilesGenerateIds_594280, schemes: {Scheme.Https})
type
  Call_DriveFilesEmptyTrash_594293 = ref object of OpenApiRestCall_593424
proc url_DriveFilesEmptyTrash_594295(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DriveFilesEmptyTrash_594294(path: JsonNode; query: JsonNode;
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
  var valid_594296 = query.getOrDefault("fields")
  valid_594296 = validateParameter(valid_594296, JString, required = false,
                                 default = nil)
  if valid_594296 != nil:
    section.add "fields", valid_594296
  var valid_594297 = query.getOrDefault("quotaUser")
  valid_594297 = validateParameter(valid_594297, JString, required = false,
                                 default = nil)
  if valid_594297 != nil:
    section.add "quotaUser", valid_594297
  var valid_594298 = query.getOrDefault("alt")
  valid_594298 = validateParameter(valid_594298, JString, required = false,
                                 default = newJString("json"))
  if valid_594298 != nil:
    section.add "alt", valid_594298
  var valid_594299 = query.getOrDefault("oauth_token")
  valid_594299 = validateParameter(valid_594299, JString, required = false,
                                 default = nil)
  if valid_594299 != nil:
    section.add "oauth_token", valid_594299
  var valid_594300 = query.getOrDefault("userIp")
  valid_594300 = validateParameter(valid_594300, JString, required = false,
                                 default = nil)
  if valid_594300 != nil:
    section.add "userIp", valid_594300
  var valid_594301 = query.getOrDefault("key")
  valid_594301 = validateParameter(valid_594301, JString, required = false,
                                 default = nil)
  if valid_594301 != nil:
    section.add "key", valid_594301
  var valid_594302 = query.getOrDefault("prettyPrint")
  valid_594302 = validateParameter(valid_594302, JBool, required = false,
                                 default = newJBool(true))
  if valid_594302 != nil:
    section.add "prettyPrint", valid_594302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594303: Call_DriveFilesEmptyTrash_594293; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes all of the user's trashed files.
  ## 
  let valid = call_594303.validator(path, query, header, formData, body)
  let scheme = call_594303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594303.url(scheme.get, call_594303.host, call_594303.base,
                         call_594303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594303, url, valid)

proc call*(call_594304: Call_DriveFilesEmptyTrash_594293; fields: string = "";
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
  var query_594305 = newJObject()
  add(query_594305, "fields", newJString(fields))
  add(query_594305, "quotaUser", newJString(quotaUser))
  add(query_594305, "alt", newJString(alt))
  add(query_594305, "oauth_token", newJString(oauthToken))
  add(query_594305, "userIp", newJString(userIp))
  add(query_594305, "key", newJString(key))
  add(query_594305, "prettyPrint", newJBool(prettyPrint))
  result = call_594304.call(nil, query_594305, nil, nil, nil)

var driveFilesEmptyTrash* = Call_DriveFilesEmptyTrash_594293(
    name: "driveFilesEmptyTrash", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/trash",
    validator: validate_DriveFilesEmptyTrash_594294, base: "/drive/v2",
    url: url_DriveFilesEmptyTrash_594295, schemes: {Scheme.Https})
type
  Call_DriveFilesUpdate_594327 = ref object of OpenApiRestCall_593424
proc url_DriveFilesUpdate_594329(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveFilesUpdate_594328(path: JsonNode; query: JsonNode;
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
  var valid_594330 = path.getOrDefault("fileId")
  valid_594330 = validateParameter(valid_594330, JString, required = true,
                                 default = nil)
  if valid_594330 != nil:
    section.add "fileId", valid_594330
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
  var valid_594331 = query.getOrDefault("supportsAllDrives")
  valid_594331 = validateParameter(valid_594331, JBool, required = false,
                                 default = newJBool(false))
  if valid_594331 != nil:
    section.add "supportsAllDrives", valid_594331
  var valid_594332 = query.getOrDefault("fields")
  valid_594332 = validateParameter(valid_594332, JString, required = false,
                                 default = nil)
  if valid_594332 != nil:
    section.add "fields", valid_594332
  var valid_594333 = query.getOrDefault("quotaUser")
  valid_594333 = validateParameter(valid_594333, JString, required = false,
                                 default = nil)
  if valid_594333 != nil:
    section.add "quotaUser", valid_594333
  var valid_594334 = query.getOrDefault("alt")
  valid_594334 = validateParameter(valid_594334, JString, required = false,
                                 default = newJString("json"))
  if valid_594334 != nil:
    section.add "alt", valid_594334
  var valid_594335 = query.getOrDefault("setModifiedDate")
  valid_594335 = validateParameter(valid_594335, JBool, required = false,
                                 default = newJBool(false))
  if valid_594335 != nil:
    section.add "setModifiedDate", valid_594335
  var valid_594336 = query.getOrDefault("pinned")
  valid_594336 = validateParameter(valid_594336, JBool, required = false,
                                 default = newJBool(false))
  if valid_594336 != nil:
    section.add "pinned", valid_594336
  var valid_594337 = query.getOrDefault("oauth_token")
  valid_594337 = validateParameter(valid_594337, JString, required = false,
                                 default = nil)
  if valid_594337 != nil:
    section.add "oauth_token", valid_594337
  var valid_594338 = query.getOrDefault("userIp")
  valid_594338 = validateParameter(valid_594338, JString, required = false,
                                 default = nil)
  if valid_594338 != nil:
    section.add "userIp", valid_594338
  var valid_594339 = query.getOrDefault("ocr")
  valid_594339 = validateParameter(valid_594339, JBool, required = false,
                                 default = newJBool(false))
  if valid_594339 != nil:
    section.add "ocr", valid_594339
  var valid_594340 = query.getOrDefault("timedTextLanguage")
  valid_594340 = validateParameter(valid_594340, JString, required = false,
                                 default = nil)
  if valid_594340 != nil:
    section.add "timedTextLanguage", valid_594340
  var valid_594341 = query.getOrDefault("supportsTeamDrives")
  valid_594341 = validateParameter(valid_594341, JBool, required = false,
                                 default = newJBool(false))
  if valid_594341 != nil:
    section.add "supportsTeamDrives", valid_594341
  var valid_594342 = query.getOrDefault("key")
  valid_594342 = validateParameter(valid_594342, JString, required = false,
                                 default = nil)
  if valid_594342 != nil:
    section.add "key", valid_594342
  var valid_594343 = query.getOrDefault("convert")
  valid_594343 = validateParameter(valid_594343, JBool, required = false,
                                 default = newJBool(false))
  if valid_594343 != nil:
    section.add "convert", valid_594343
  var valid_594344 = query.getOrDefault("modifiedDateBehavior")
  valid_594344 = validateParameter(valid_594344, JString, required = false,
                                 default = newJString("fromBody"))
  if valid_594344 != nil:
    section.add "modifiedDateBehavior", valid_594344
  var valid_594345 = query.getOrDefault("updateViewedDate")
  valid_594345 = validateParameter(valid_594345, JBool, required = false,
                                 default = newJBool(true))
  if valid_594345 != nil:
    section.add "updateViewedDate", valid_594345
  var valid_594346 = query.getOrDefault("useContentAsIndexableText")
  valid_594346 = validateParameter(valid_594346, JBool, required = false,
                                 default = newJBool(false))
  if valid_594346 != nil:
    section.add "useContentAsIndexableText", valid_594346
  var valid_594347 = query.getOrDefault("addParents")
  valid_594347 = validateParameter(valid_594347, JString, required = false,
                                 default = nil)
  if valid_594347 != nil:
    section.add "addParents", valid_594347
  var valid_594348 = query.getOrDefault("prettyPrint")
  valid_594348 = validateParameter(valid_594348, JBool, required = false,
                                 default = newJBool(true))
  if valid_594348 != nil:
    section.add "prettyPrint", valid_594348
  var valid_594349 = query.getOrDefault("removeParents")
  valid_594349 = validateParameter(valid_594349, JString, required = false,
                                 default = nil)
  if valid_594349 != nil:
    section.add "removeParents", valid_594349
  var valid_594350 = query.getOrDefault("newRevision")
  valid_594350 = validateParameter(valid_594350, JBool, required = false,
                                 default = newJBool(true))
  if valid_594350 != nil:
    section.add "newRevision", valid_594350
  var valid_594351 = query.getOrDefault("ocrLanguage")
  valid_594351 = validateParameter(valid_594351, JString, required = false,
                                 default = nil)
  if valid_594351 != nil:
    section.add "ocrLanguage", valid_594351
  var valid_594352 = query.getOrDefault("timedTextTrackName")
  valid_594352 = validateParameter(valid_594352, JString, required = false,
                                 default = nil)
  if valid_594352 != nil:
    section.add "timedTextTrackName", valid_594352
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

proc call*(call_594354: Call_DriveFilesUpdate_594327; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates file metadata and/or content.
  ## 
  let valid = call_594354.validator(path, query, header, formData, body)
  let scheme = call_594354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594354.url(scheme.get, call_594354.host, call_594354.base,
                         call_594354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594354, url, valid)

proc call*(call_594355: Call_DriveFilesUpdate_594327; fileId: string;
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
  var path_594356 = newJObject()
  var query_594357 = newJObject()
  var body_594358 = newJObject()
  add(query_594357, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594357, "fields", newJString(fields))
  add(query_594357, "quotaUser", newJString(quotaUser))
  add(path_594356, "fileId", newJString(fileId))
  add(query_594357, "alt", newJString(alt))
  add(query_594357, "setModifiedDate", newJBool(setModifiedDate))
  add(query_594357, "pinned", newJBool(pinned))
  add(query_594357, "oauth_token", newJString(oauthToken))
  add(query_594357, "userIp", newJString(userIp))
  add(query_594357, "ocr", newJBool(ocr))
  add(query_594357, "timedTextLanguage", newJString(timedTextLanguage))
  add(query_594357, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594357, "key", newJString(key))
  add(query_594357, "convert", newJBool(convert))
  add(query_594357, "modifiedDateBehavior", newJString(modifiedDateBehavior))
  add(query_594357, "updateViewedDate", newJBool(updateViewedDate))
  add(query_594357, "useContentAsIndexableText",
      newJBool(useContentAsIndexableText))
  add(query_594357, "addParents", newJString(addParents))
  add(query_594357, "prettyPrint", newJBool(prettyPrint))
  if body != nil:
    body_594358 = body
  add(query_594357, "removeParents", newJString(removeParents))
  add(query_594357, "newRevision", newJBool(newRevision))
  add(query_594357, "ocrLanguage", newJString(ocrLanguage))
  add(query_594357, "timedTextTrackName", newJString(timedTextTrackName))
  result = call_594355.call(path_594356, query_594357, nil, nil, body_594358)

var driveFilesUpdate* = Call_DriveFilesUpdate_594327(name: "driveFilesUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/files/{fileId}",
    validator: validate_DriveFilesUpdate_594328, base: "/drive/v2",
    url: url_DriveFilesUpdate_594329, schemes: {Scheme.Https})
type
  Call_DriveFilesGet_594306 = ref object of OpenApiRestCall_593424
proc url_DriveFilesGet_594308(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveFilesGet_594307(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594309 = path.getOrDefault("fileId")
  valid_594309 = validateParameter(valid_594309, JString, required = true,
                                 default = nil)
  if valid_594309 != nil:
    section.add "fileId", valid_594309
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
  var valid_594310 = query.getOrDefault("supportsAllDrives")
  valid_594310 = validateParameter(valid_594310, JBool, required = false,
                                 default = newJBool(false))
  if valid_594310 != nil:
    section.add "supportsAllDrives", valid_594310
  var valid_594311 = query.getOrDefault("fields")
  valid_594311 = validateParameter(valid_594311, JString, required = false,
                                 default = nil)
  if valid_594311 != nil:
    section.add "fields", valid_594311
  var valid_594312 = query.getOrDefault("quotaUser")
  valid_594312 = validateParameter(valid_594312, JString, required = false,
                                 default = nil)
  if valid_594312 != nil:
    section.add "quotaUser", valid_594312
  var valid_594313 = query.getOrDefault("alt")
  valid_594313 = validateParameter(valid_594313, JString, required = false,
                                 default = newJString("json"))
  if valid_594313 != nil:
    section.add "alt", valid_594313
  var valid_594314 = query.getOrDefault("acknowledgeAbuse")
  valid_594314 = validateParameter(valid_594314, JBool, required = false,
                                 default = newJBool(false))
  if valid_594314 != nil:
    section.add "acknowledgeAbuse", valid_594314
  var valid_594315 = query.getOrDefault("oauth_token")
  valid_594315 = validateParameter(valid_594315, JString, required = false,
                                 default = nil)
  if valid_594315 != nil:
    section.add "oauth_token", valid_594315
  var valid_594316 = query.getOrDefault("userIp")
  valid_594316 = validateParameter(valid_594316, JString, required = false,
                                 default = nil)
  if valid_594316 != nil:
    section.add "userIp", valid_594316
  var valid_594317 = query.getOrDefault("supportsTeamDrives")
  valid_594317 = validateParameter(valid_594317, JBool, required = false,
                                 default = newJBool(false))
  if valid_594317 != nil:
    section.add "supportsTeamDrives", valid_594317
  var valid_594318 = query.getOrDefault("key")
  valid_594318 = validateParameter(valid_594318, JString, required = false,
                                 default = nil)
  if valid_594318 != nil:
    section.add "key", valid_594318
  var valid_594319 = query.getOrDefault("updateViewedDate")
  valid_594319 = validateParameter(valid_594319, JBool, required = false,
                                 default = newJBool(false))
  if valid_594319 != nil:
    section.add "updateViewedDate", valid_594319
  var valid_594320 = query.getOrDefault("projection")
  valid_594320 = validateParameter(valid_594320, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_594320 != nil:
    section.add "projection", valid_594320
  var valid_594321 = query.getOrDefault("revisionId")
  valid_594321 = validateParameter(valid_594321, JString, required = false,
                                 default = nil)
  if valid_594321 != nil:
    section.add "revisionId", valid_594321
  var valid_594322 = query.getOrDefault("prettyPrint")
  valid_594322 = validateParameter(valid_594322, JBool, required = false,
                                 default = newJBool(true))
  if valid_594322 != nil:
    section.add "prettyPrint", valid_594322
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594323: Call_DriveFilesGet_594306; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a file's metadata by ID.
  ## 
  let valid = call_594323.validator(path, query, header, formData, body)
  let scheme = call_594323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594323.url(scheme.get, call_594323.host, call_594323.base,
                         call_594323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594323, url, valid)

proc call*(call_594324: Call_DriveFilesGet_594306; fileId: string;
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
  var path_594325 = newJObject()
  var query_594326 = newJObject()
  add(query_594326, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594326, "fields", newJString(fields))
  add(query_594326, "quotaUser", newJString(quotaUser))
  add(path_594325, "fileId", newJString(fileId))
  add(query_594326, "alt", newJString(alt))
  add(query_594326, "acknowledgeAbuse", newJBool(acknowledgeAbuse))
  add(query_594326, "oauth_token", newJString(oauthToken))
  add(query_594326, "userIp", newJString(userIp))
  add(query_594326, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594326, "key", newJString(key))
  add(query_594326, "updateViewedDate", newJBool(updateViewedDate))
  add(query_594326, "projection", newJString(projection))
  add(query_594326, "revisionId", newJString(revisionId))
  add(query_594326, "prettyPrint", newJBool(prettyPrint))
  result = call_594324.call(path_594325, query_594326, nil, nil, nil)

var driveFilesGet* = Call_DriveFilesGet_594306(name: "driveFilesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/files/{fileId}",
    validator: validate_DriveFilesGet_594307, base: "/drive/v2",
    url: url_DriveFilesGet_594308, schemes: {Scheme.Https})
type
  Call_DriveFilesPatch_594376 = ref object of OpenApiRestCall_593424
proc url_DriveFilesPatch_594378(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveFilesPatch_594377(path: JsonNode; query: JsonNode;
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
  var valid_594379 = path.getOrDefault("fileId")
  valid_594379 = validateParameter(valid_594379, JString, required = true,
                                 default = nil)
  if valid_594379 != nil:
    section.add "fileId", valid_594379
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
  var valid_594380 = query.getOrDefault("supportsAllDrives")
  valid_594380 = validateParameter(valid_594380, JBool, required = false,
                                 default = newJBool(false))
  if valid_594380 != nil:
    section.add "supportsAllDrives", valid_594380
  var valid_594381 = query.getOrDefault("fields")
  valid_594381 = validateParameter(valid_594381, JString, required = false,
                                 default = nil)
  if valid_594381 != nil:
    section.add "fields", valid_594381
  var valid_594382 = query.getOrDefault("quotaUser")
  valid_594382 = validateParameter(valid_594382, JString, required = false,
                                 default = nil)
  if valid_594382 != nil:
    section.add "quotaUser", valid_594382
  var valid_594383 = query.getOrDefault("alt")
  valid_594383 = validateParameter(valid_594383, JString, required = false,
                                 default = newJString("json"))
  if valid_594383 != nil:
    section.add "alt", valid_594383
  var valid_594384 = query.getOrDefault("setModifiedDate")
  valid_594384 = validateParameter(valid_594384, JBool, required = false,
                                 default = newJBool(false))
  if valid_594384 != nil:
    section.add "setModifiedDate", valid_594384
  var valid_594385 = query.getOrDefault("pinned")
  valid_594385 = validateParameter(valid_594385, JBool, required = false,
                                 default = newJBool(false))
  if valid_594385 != nil:
    section.add "pinned", valid_594385
  var valid_594386 = query.getOrDefault("oauth_token")
  valid_594386 = validateParameter(valid_594386, JString, required = false,
                                 default = nil)
  if valid_594386 != nil:
    section.add "oauth_token", valid_594386
  var valid_594387 = query.getOrDefault("userIp")
  valid_594387 = validateParameter(valid_594387, JString, required = false,
                                 default = nil)
  if valid_594387 != nil:
    section.add "userIp", valid_594387
  var valid_594388 = query.getOrDefault("ocr")
  valid_594388 = validateParameter(valid_594388, JBool, required = false,
                                 default = newJBool(false))
  if valid_594388 != nil:
    section.add "ocr", valid_594388
  var valid_594389 = query.getOrDefault("timedTextLanguage")
  valid_594389 = validateParameter(valid_594389, JString, required = false,
                                 default = nil)
  if valid_594389 != nil:
    section.add "timedTextLanguage", valid_594389
  var valid_594390 = query.getOrDefault("supportsTeamDrives")
  valid_594390 = validateParameter(valid_594390, JBool, required = false,
                                 default = newJBool(false))
  if valid_594390 != nil:
    section.add "supportsTeamDrives", valid_594390
  var valid_594391 = query.getOrDefault("key")
  valid_594391 = validateParameter(valid_594391, JString, required = false,
                                 default = nil)
  if valid_594391 != nil:
    section.add "key", valid_594391
  var valid_594392 = query.getOrDefault("convert")
  valid_594392 = validateParameter(valid_594392, JBool, required = false,
                                 default = newJBool(false))
  if valid_594392 != nil:
    section.add "convert", valid_594392
  var valid_594393 = query.getOrDefault("modifiedDateBehavior")
  valid_594393 = validateParameter(valid_594393, JString, required = false,
                                 default = newJString("fromBody"))
  if valid_594393 != nil:
    section.add "modifiedDateBehavior", valid_594393
  var valid_594394 = query.getOrDefault("updateViewedDate")
  valid_594394 = validateParameter(valid_594394, JBool, required = false,
                                 default = newJBool(true))
  if valid_594394 != nil:
    section.add "updateViewedDate", valid_594394
  var valid_594395 = query.getOrDefault("useContentAsIndexableText")
  valid_594395 = validateParameter(valid_594395, JBool, required = false,
                                 default = newJBool(false))
  if valid_594395 != nil:
    section.add "useContentAsIndexableText", valid_594395
  var valid_594396 = query.getOrDefault("addParents")
  valid_594396 = validateParameter(valid_594396, JString, required = false,
                                 default = nil)
  if valid_594396 != nil:
    section.add "addParents", valid_594396
  var valid_594397 = query.getOrDefault("prettyPrint")
  valid_594397 = validateParameter(valid_594397, JBool, required = false,
                                 default = newJBool(true))
  if valid_594397 != nil:
    section.add "prettyPrint", valid_594397
  var valid_594398 = query.getOrDefault("removeParents")
  valid_594398 = validateParameter(valid_594398, JString, required = false,
                                 default = nil)
  if valid_594398 != nil:
    section.add "removeParents", valid_594398
  var valid_594399 = query.getOrDefault("newRevision")
  valid_594399 = validateParameter(valid_594399, JBool, required = false,
                                 default = newJBool(true))
  if valid_594399 != nil:
    section.add "newRevision", valid_594399
  var valid_594400 = query.getOrDefault("ocrLanguage")
  valid_594400 = validateParameter(valid_594400, JString, required = false,
                                 default = nil)
  if valid_594400 != nil:
    section.add "ocrLanguage", valid_594400
  var valid_594401 = query.getOrDefault("timedTextTrackName")
  valid_594401 = validateParameter(valid_594401, JString, required = false,
                                 default = nil)
  if valid_594401 != nil:
    section.add "timedTextTrackName", valid_594401
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

proc call*(call_594403: Call_DriveFilesPatch_594376; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates file metadata and/or content. This method supports patch semantics.
  ## 
  let valid = call_594403.validator(path, query, header, formData, body)
  let scheme = call_594403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594403.url(scheme.get, call_594403.host, call_594403.base,
                         call_594403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594403, url, valid)

proc call*(call_594404: Call_DriveFilesPatch_594376; fileId: string;
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
  var path_594405 = newJObject()
  var query_594406 = newJObject()
  var body_594407 = newJObject()
  add(query_594406, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594406, "fields", newJString(fields))
  add(query_594406, "quotaUser", newJString(quotaUser))
  add(path_594405, "fileId", newJString(fileId))
  add(query_594406, "alt", newJString(alt))
  add(query_594406, "setModifiedDate", newJBool(setModifiedDate))
  add(query_594406, "pinned", newJBool(pinned))
  add(query_594406, "oauth_token", newJString(oauthToken))
  add(query_594406, "userIp", newJString(userIp))
  add(query_594406, "ocr", newJBool(ocr))
  add(query_594406, "timedTextLanguage", newJString(timedTextLanguage))
  add(query_594406, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594406, "key", newJString(key))
  add(query_594406, "convert", newJBool(convert))
  add(query_594406, "modifiedDateBehavior", newJString(modifiedDateBehavior))
  add(query_594406, "updateViewedDate", newJBool(updateViewedDate))
  add(query_594406, "useContentAsIndexableText",
      newJBool(useContentAsIndexableText))
  add(query_594406, "addParents", newJString(addParents))
  add(query_594406, "prettyPrint", newJBool(prettyPrint))
  if body != nil:
    body_594407 = body
  add(query_594406, "removeParents", newJString(removeParents))
  add(query_594406, "newRevision", newJBool(newRevision))
  add(query_594406, "ocrLanguage", newJString(ocrLanguage))
  add(query_594406, "timedTextTrackName", newJString(timedTextTrackName))
  result = call_594404.call(path_594405, query_594406, nil, nil, body_594407)

var driveFilesPatch* = Call_DriveFilesPatch_594376(name: "driveFilesPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/files/{fileId}", validator: validate_DriveFilesPatch_594377,
    base: "/drive/v2", url: url_DriveFilesPatch_594378, schemes: {Scheme.Https})
type
  Call_DriveFilesDelete_594359 = ref object of OpenApiRestCall_593424
proc url_DriveFilesDelete_594361(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveFilesDelete_594360(path: JsonNode; query: JsonNode;
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
  var valid_594362 = path.getOrDefault("fileId")
  valid_594362 = validateParameter(valid_594362, JString, required = true,
                                 default = nil)
  if valid_594362 != nil:
    section.add "fileId", valid_594362
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
  var valid_594363 = query.getOrDefault("supportsAllDrives")
  valid_594363 = validateParameter(valid_594363, JBool, required = false,
                                 default = newJBool(false))
  if valid_594363 != nil:
    section.add "supportsAllDrives", valid_594363
  var valid_594364 = query.getOrDefault("fields")
  valid_594364 = validateParameter(valid_594364, JString, required = false,
                                 default = nil)
  if valid_594364 != nil:
    section.add "fields", valid_594364
  var valid_594365 = query.getOrDefault("quotaUser")
  valid_594365 = validateParameter(valid_594365, JString, required = false,
                                 default = nil)
  if valid_594365 != nil:
    section.add "quotaUser", valid_594365
  var valid_594366 = query.getOrDefault("alt")
  valid_594366 = validateParameter(valid_594366, JString, required = false,
                                 default = newJString("json"))
  if valid_594366 != nil:
    section.add "alt", valid_594366
  var valid_594367 = query.getOrDefault("oauth_token")
  valid_594367 = validateParameter(valid_594367, JString, required = false,
                                 default = nil)
  if valid_594367 != nil:
    section.add "oauth_token", valid_594367
  var valid_594368 = query.getOrDefault("userIp")
  valid_594368 = validateParameter(valid_594368, JString, required = false,
                                 default = nil)
  if valid_594368 != nil:
    section.add "userIp", valid_594368
  var valid_594369 = query.getOrDefault("supportsTeamDrives")
  valid_594369 = validateParameter(valid_594369, JBool, required = false,
                                 default = newJBool(false))
  if valid_594369 != nil:
    section.add "supportsTeamDrives", valid_594369
  var valid_594370 = query.getOrDefault("key")
  valid_594370 = validateParameter(valid_594370, JString, required = false,
                                 default = nil)
  if valid_594370 != nil:
    section.add "key", valid_594370
  var valid_594371 = query.getOrDefault("prettyPrint")
  valid_594371 = validateParameter(valid_594371, JBool, required = false,
                                 default = newJBool(true))
  if valid_594371 != nil:
    section.add "prettyPrint", valid_594371
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594372: Call_DriveFilesDelete_594359; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a file by ID. Skips the trash. The currently authenticated user must own the file or be an organizer on the parent for shared drive files.
  ## 
  let valid = call_594372.validator(path, query, header, formData, body)
  let scheme = call_594372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594372.url(scheme.get, call_594372.host, call_594372.base,
                         call_594372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594372, url, valid)

proc call*(call_594373: Call_DriveFilesDelete_594359; fileId: string;
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
  var path_594374 = newJObject()
  var query_594375 = newJObject()
  add(query_594375, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594375, "fields", newJString(fields))
  add(query_594375, "quotaUser", newJString(quotaUser))
  add(path_594374, "fileId", newJString(fileId))
  add(query_594375, "alt", newJString(alt))
  add(query_594375, "oauth_token", newJString(oauthToken))
  add(query_594375, "userIp", newJString(userIp))
  add(query_594375, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594375, "key", newJString(key))
  add(query_594375, "prettyPrint", newJBool(prettyPrint))
  result = call_594373.call(path_594374, query_594375, nil, nil, nil)

var driveFilesDelete* = Call_DriveFilesDelete_594359(name: "driveFilesDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/files/{fileId}", validator: validate_DriveFilesDelete_594360,
    base: "/drive/v2", url: url_DriveFilesDelete_594361, schemes: {Scheme.Https})
type
  Call_DriveCommentsInsert_594427 = ref object of OpenApiRestCall_593424
proc url_DriveCommentsInsert_594429(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveCommentsInsert_594428(path: JsonNode; query: JsonNode;
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
  var valid_594430 = path.getOrDefault("fileId")
  valid_594430 = validateParameter(valid_594430, JString, required = true,
                                 default = nil)
  if valid_594430 != nil:
    section.add "fileId", valid_594430
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
  var valid_594431 = query.getOrDefault("fields")
  valid_594431 = validateParameter(valid_594431, JString, required = false,
                                 default = nil)
  if valid_594431 != nil:
    section.add "fields", valid_594431
  var valid_594432 = query.getOrDefault("quotaUser")
  valid_594432 = validateParameter(valid_594432, JString, required = false,
                                 default = nil)
  if valid_594432 != nil:
    section.add "quotaUser", valid_594432
  var valid_594433 = query.getOrDefault("alt")
  valid_594433 = validateParameter(valid_594433, JString, required = false,
                                 default = newJString("json"))
  if valid_594433 != nil:
    section.add "alt", valid_594433
  var valid_594434 = query.getOrDefault("oauth_token")
  valid_594434 = validateParameter(valid_594434, JString, required = false,
                                 default = nil)
  if valid_594434 != nil:
    section.add "oauth_token", valid_594434
  var valid_594435 = query.getOrDefault("userIp")
  valid_594435 = validateParameter(valid_594435, JString, required = false,
                                 default = nil)
  if valid_594435 != nil:
    section.add "userIp", valid_594435
  var valid_594436 = query.getOrDefault("key")
  valid_594436 = validateParameter(valid_594436, JString, required = false,
                                 default = nil)
  if valid_594436 != nil:
    section.add "key", valid_594436
  var valid_594437 = query.getOrDefault("prettyPrint")
  valid_594437 = validateParameter(valid_594437, JBool, required = false,
                                 default = newJBool(true))
  if valid_594437 != nil:
    section.add "prettyPrint", valid_594437
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

proc call*(call_594439: Call_DriveCommentsInsert_594427; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new comment on the given file.
  ## 
  let valid = call_594439.validator(path, query, header, formData, body)
  let scheme = call_594439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594439.url(scheme.get, call_594439.host, call_594439.base,
                         call_594439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594439, url, valid)

proc call*(call_594440: Call_DriveCommentsInsert_594427; fileId: string;
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
  var path_594441 = newJObject()
  var query_594442 = newJObject()
  var body_594443 = newJObject()
  add(query_594442, "fields", newJString(fields))
  add(query_594442, "quotaUser", newJString(quotaUser))
  add(path_594441, "fileId", newJString(fileId))
  add(query_594442, "alt", newJString(alt))
  add(query_594442, "oauth_token", newJString(oauthToken))
  add(query_594442, "userIp", newJString(userIp))
  add(query_594442, "key", newJString(key))
  if body != nil:
    body_594443 = body
  add(query_594442, "prettyPrint", newJBool(prettyPrint))
  result = call_594440.call(path_594441, query_594442, nil, nil, body_594443)

var driveCommentsInsert* = Call_DriveCommentsInsert_594427(
    name: "driveCommentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/comments",
    validator: validate_DriveCommentsInsert_594428, base: "/drive/v2",
    url: url_DriveCommentsInsert_594429, schemes: {Scheme.Https})
type
  Call_DriveCommentsList_594408 = ref object of OpenApiRestCall_593424
proc url_DriveCommentsList_594410(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveCommentsList_594409(path: JsonNode; query: JsonNode;
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
  var valid_594411 = path.getOrDefault("fileId")
  valid_594411 = validateParameter(valid_594411, JString, required = true,
                                 default = nil)
  if valid_594411 != nil:
    section.add "fileId", valid_594411
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
  var valid_594412 = query.getOrDefault("fields")
  valid_594412 = validateParameter(valid_594412, JString, required = false,
                                 default = nil)
  if valid_594412 != nil:
    section.add "fields", valid_594412
  var valid_594413 = query.getOrDefault("pageToken")
  valid_594413 = validateParameter(valid_594413, JString, required = false,
                                 default = nil)
  if valid_594413 != nil:
    section.add "pageToken", valid_594413
  var valid_594414 = query.getOrDefault("quotaUser")
  valid_594414 = validateParameter(valid_594414, JString, required = false,
                                 default = nil)
  if valid_594414 != nil:
    section.add "quotaUser", valid_594414
  var valid_594415 = query.getOrDefault("alt")
  valid_594415 = validateParameter(valid_594415, JString, required = false,
                                 default = newJString("json"))
  if valid_594415 != nil:
    section.add "alt", valid_594415
  var valid_594416 = query.getOrDefault("oauth_token")
  valid_594416 = validateParameter(valid_594416, JString, required = false,
                                 default = nil)
  if valid_594416 != nil:
    section.add "oauth_token", valid_594416
  var valid_594417 = query.getOrDefault("userIp")
  valid_594417 = validateParameter(valid_594417, JString, required = false,
                                 default = nil)
  if valid_594417 != nil:
    section.add "userIp", valid_594417
  var valid_594418 = query.getOrDefault("maxResults")
  valid_594418 = validateParameter(valid_594418, JInt, required = false,
                                 default = newJInt(20))
  if valid_594418 != nil:
    section.add "maxResults", valid_594418
  var valid_594419 = query.getOrDefault("updatedMin")
  valid_594419 = validateParameter(valid_594419, JString, required = false,
                                 default = nil)
  if valid_594419 != nil:
    section.add "updatedMin", valid_594419
  var valid_594420 = query.getOrDefault("key")
  valid_594420 = validateParameter(valid_594420, JString, required = false,
                                 default = nil)
  if valid_594420 != nil:
    section.add "key", valid_594420
  var valid_594421 = query.getOrDefault("includeDeleted")
  valid_594421 = validateParameter(valid_594421, JBool, required = false,
                                 default = newJBool(false))
  if valid_594421 != nil:
    section.add "includeDeleted", valid_594421
  var valid_594422 = query.getOrDefault("prettyPrint")
  valid_594422 = validateParameter(valid_594422, JBool, required = false,
                                 default = newJBool(true))
  if valid_594422 != nil:
    section.add "prettyPrint", valid_594422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594423: Call_DriveCommentsList_594408; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's comments.
  ## 
  let valid = call_594423.validator(path, query, header, formData, body)
  let scheme = call_594423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594423.url(scheme.get, call_594423.host, call_594423.base,
                         call_594423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594423, url, valid)

proc call*(call_594424: Call_DriveCommentsList_594408; fileId: string;
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
  var path_594425 = newJObject()
  var query_594426 = newJObject()
  add(query_594426, "fields", newJString(fields))
  add(query_594426, "pageToken", newJString(pageToken))
  add(query_594426, "quotaUser", newJString(quotaUser))
  add(path_594425, "fileId", newJString(fileId))
  add(query_594426, "alt", newJString(alt))
  add(query_594426, "oauth_token", newJString(oauthToken))
  add(query_594426, "userIp", newJString(userIp))
  add(query_594426, "maxResults", newJInt(maxResults))
  add(query_594426, "updatedMin", newJString(updatedMin))
  add(query_594426, "key", newJString(key))
  add(query_594426, "includeDeleted", newJBool(includeDeleted))
  add(query_594426, "prettyPrint", newJBool(prettyPrint))
  result = call_594424.call(path_594425, query_594426, nil, nil, nil)

var driveCommentsList* = Call_DriveCommentsList_594408(name: "driveCommentsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments", validator: validate_DriveCommentsList_594409,
    base: "/drive/v2", url: url_DriveCommentsList_594410, schemes: {Scheme.Https})
type
  Call_DriveCommentsUpdate_594461 = ref object of OpenApiRestCall_593424
proc url_DriveCommentsUpdate_594463(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveCommentsUpdate_594462(path: JsonNode; query: JsonNode;
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
  var valid_594464 = path.getOrDefault("fileId")
  valid_594464 = validateParameter(valid_594464, JString, required = true,
                                 default = nil)
  if valid_594464 != nil:
    section.add "fileId", valid_594464
  var valid_594465 = path.getOrDefault("commentId")
  valid_594465 = validateParameter(valid_594465, JString, required = true,
                                 default = nil)
  if valid_594465 != nil:
    section.add "commentId", valid_594465
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
  var valid_594466 = query.getOrDefault("fields")
  valid_594466 = validateParameter(valid_594466, JString, required = false,
                                 default = nil)
  if valid_594466 != nil:
    section.add "fields", valid_594466
  var valid_594467 = query.getOrDefault("quotaUser")
  valid_594467 = validateParameter(valid_594467, JString, required = false,
                                 default = nil)
  if valid_594467 != nil:
    section.add "quotaUser", valid_594467
  var valid_594468 = query.getOrDefault("alt")
  valid_594468 = validateParameter(valid_594468, JString, required = false,
                                 default = newJString("json"))
  if valid_594468 != nil:
    section.add "alt", valid_594468
  var valid_594469 = query.getOrDefault("oauth_token")
  valid_594469 = validateParameter(valid_594469, JString, required = false,
                                 default = nil)
  if valid_594469 != nil:
    section.add "oauth_token", valid_594469
  var valid_594470 = query.getOrDefault("userIp")
  valid_594470 = validateParameter(valid_594470, JString, required = false,
                                 default = nil)
  if valid_594470 != nil:
    section.add "userIp", valid_594470
  var valid_594471 = query.getOrDefault("key")
  valid_594471 = validateParameter(valid_594471, JString, required = false,
                                 default = nil)
  if valid_594471 != nil:
    section.add "key", valid_594471
  var valid_594472 = query.getOrDefault("prettyPrint")
  valid_594472 = validateParameter(valid_594472, JBool, required = false,
                                 default = newJBool(true))
  if valid_594472 != nil:
    section.add "prettyPrint", valid_594472
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

proc call*(call_594474: Call_DriveCommentsUpdate_594461; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing comment.
  ## 
  let valid = call_594474.validator(path, query, header, formData, body)
  let scheme = call_594474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594474.url(scheme.get, call_594474.host, call_594474.base,
                         call_594474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594474, url, valid)

proc call*(call_594475: Call_DriveCommentsUpdate_594461; fileId: string;
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
  var path_594476 = newJObject()
  var query_594477 = newJObject()
  var body_594478 = newJObject()
  add(query_594477, "fields", newJString(fields))
  add(query_594477, "quotaUser", newJString(quotaUser))
  add(path_594476, "fileId", newJString(fileId))
  add(query_594477, "alt", newJString(alt))
  add(query_594477, "oauth_token", newJString(oauthToken))
  add(query_594477, "userIp", newJString(userIp))
  add(query_594477, "key", newJString(key))
  add(path_594476, "commentId", newJString(commentId))
  if body != nil:
    body_594478 = body
  add(query_594477, "prettyPrint", newJBool(prettyPrint))
  result = call_594475.call(path_594476, query_594477, nil, nil, body_594478)

var driveCommentsUpdate* = Call_DriveCommentsUpdate_594461(
    name: "driveCommentsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsUpdate_594462, base: "/drive/v2",
    url: url_DriveCommentsUpdate_594463, schemes: {Scheme.Https})
type
  Call_DriveCommentsGet_594444 = ref object of OpenApiRestCall_593424
proc url_DriveCommentsGet_594446(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveCommentsGet_594445(path: JsonNode; query: JsonNode;
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
  var valid_594447 = path.getOrDefault("fileId")
  valid_594447 = validateParameter(valid_594447, JString, required = true,
                                 default = nil)
  if valid_594447 != nil:
    section.add "fileId", valid_594447
  var valid_594448 = path.getOrDefault("commentId")
  valid_594448 = validateParameter(valid_594448, JString, required = true,
                                 default = nil)
  if valid_594448 != nil:
    section.add "commentId", valid_594448
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
  var valid_594449 = query.getOrDefault("fields")
  valid_594449 = validateParameter(valid_594449, JString, required = false,
                                 default = nil)
  if valid_594449 != nil:
    section.add "fields", valid_594449
  var valid_594450 = query.getOrDefault("quotaUser")
  valid_594450 = validateParameter(valid_594450, JString, required = false,
                                 default = nil)
  if valid_594450 != nil:
    section.add "quotaUser", valid_594450
  var valid_594451 = query.getOrDefault("alt")
  valid_594451 = validateParameter(valid_594451, JString, required = false,
                                 default = newJString("json"))
  if valid_594451 != nil:
    section.add "alt", valid_594451
  var valid_594452 = query.getOrDefault("oauth_token")
  valid_594452 = validateParameter(valid_594452, JString, required = false,
                                 default = nil)
  if valid_594452 != nil:
    section.add "oauth_token", valid_594452
  var valid_594453 = query.getOrDefault("userIp")
  valid_594453 = validateParameter(valid_594453, JString, required = false,
                                 default = nil)
  if valid_594453 != nil:
    section.add "userIp", valid_594453
  var valid_594454 = query.getOrDefault("key")
  valid_594454 = validateParameter(valid_594454, JString, required = false,
                                 default = nil)
  if valid_594454 != nil:
    section.add "key", valid_594454
  var valid_594455 = query.getOrDefault("includeDeleted")
  valid_594455 = validateParameter(valid_594455, JBool, required = false,
                                 default = newJBool(false))
  if valid_594455 != nil:
    section.add "includeDeleted", valid_594455
  var valid_594456 = query.getOrDefault("prettyPrint")
  valid_594456 = validateParameter(valid_594456, JBool, required = false,
                                 default = newJBool(true))
  if valid_594456 != nil:
    section.add "prettyPrint", valid_594456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594457: Call_DriveCommentsGet_594444; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a comment by ID.
  ## 
  let valid = call_594457.validator(path, query, header, formData, body)
  let scheme = call_594457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594457.url(scheme.get, call_594457.host, call_594457.base,
                         call_594457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594457, url, valid)

proc call*(call_594458: Call_DriveCommentsGet_594444; fileId: string;
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
  var path_594459 = newJObject()
  var query_594460 = newJObject()
  add(query_594460, "fields", newJString(fields))
  add(query_594460, "quotaUser", newJString(quotaUser))
  add(path_594459, "fileId", newJString(fileId))
  add(query_594460, "alt", newJString(alt))
  add(query_594460, "oauth_token", newJString(oauthToken))
  add(query_594460, "userIp", newJString(userIp))
  add(query_594460, "key", newJString(key))
  add(path_594459, "commentId", newJString(commentId))
  add(query_594460, "includeDeleted", newJBool(includeDeleted))
  add(query_594460, "prettyPrint", newJBool(prettyPrint))
  result = call_594458.call(path_594459, query_594460, nil, nil, nil)

var driveCommentsGet* = Call_DriveCommentsGet_594444(name: "driveCommentsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsGet_594445, base: "/drive/v2",
    url: url_DriveCommentsGet_594446, schemes: {Scheme.Https})
type
  Call_DriveCommentsPatch_594495 = ref object of OpenApiRestCall_593424
proc url_DriveCommentsPatch_594497(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveCommentsPatch_594496(path: JsonNode; query: JsonNode;
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
  var valid_594498 = path.getOrDefault("fileId")
  valid_594498 = validateParameter(valid_594498, JString, required = true,
                                 default = nil)
  if valid_594498 != nil:
    section.add "fileId", valid_594498
  var valid_594499 = path.getOrDefault("commentId")
  valid_594499 = validateParameter(valid_594499, JString, required = true,
                                 default = nil)
  if valid_594499 != nil:
    section.add "commentId", valid_594499
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
  var valid_594500 = query.getOrDefault("fields")
  valid_594500 = validateParameter(valid_594500, JString, required = false,
                                 default = nil)
  if valid_594500 != nil:
    section.add "fields", valid_594500
  var valid_594501 = query.getOrDefault("quotaUser")
  valid_594501 = validateParameter(valid_594501, JString, required = false,
                                 default = nil)
  if valid_594501 != nil:
    section.add "quotaUser", valid_594501
  var valid_594502 = query.getOrDefault("alt")
  valid_594502 = validateParameter(valid_594502, JString, required = false,
                                 default = newJString("json"))
  if valid_594502 != nil:
    section.add "alt", valid_594502
  var valid_594503 = query.getOrDefault("oauth_token")
  valid_594503 = validateParameter(valid_594503, JString, required = false,
                                 default = nil)
  if valid_594503 != nil:
    section.add "oauth_token", valid_594503
  var valid_594504 = query.getOrDefault("userIp")
  valid_594504 = validateParameter(valid_594504, JString, required = false,
                                 default = nil)
  if valid_594504 != nil:
    section.add "userIp", valid_594504
  var valid_594505 = query.getOrDefault("key")
  valid_594505 = validateParameter(valid_594505, JString, required = false,
                                 default = nil)
  if valid_594505 != nil:
    section.add "key", valid_594505
  var valid_594506 = query.getOrDefault("prettyPrint")
  valid_594506 = validateParameter(valid_594506, JBool, required = false,
                                 default = newJBool(true))
  if valid_594506 != nil:
    section.add "prettyPrint", valid_594506
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

proc call*(call_594508: Call_DriveCommentsPatch_594495; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing comment. This method supports patch semantics.
  ## 
  let valid = call_594508.validator(path, query, header, formData, body)
  let scheme = call_594508.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594508.url(scheme.get, call_594508.host, call_594508.base,
                         call_594508.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594508, url, valid)

proc call*(call_594509: Call_DriveCommentsPatch_594495; fileId: string;
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
  var path_594510 = newJObject()
  var query_594511 = newJObject()
  var body_594512 = newJObject()
  add(query_594511, "fields", newJString(fields))
  add(query_594511, "quotaUser", newJString(quotaUser))
  add(path_594510, "fileId", newJString(fileId))
  add(query_594511, "alt", newJString(alt))
  add(query_594511, "oauth_token", newJString(oauthToken))
  add(query_594511, "userIp", newJString(userIp))
  add(query_594511, "key", newJString(key))
  add(path_594510, "commentId", newJString(commentId))
  if body != nil:
    body_594512 = body
  add(query_594511, "prettyPrint", newJBool(prettyPrint))
  result = call_594509.call(path_594510, query_594511, nil, nil, body_594512)

var driveCommentsPatch* = Call_DriveCommentsPatch_594495(
    name: "driveCommentsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsPatch_594496, base: "/drive/v2",
    url: url_DriveCommentsPatch_594497, schemes: {Scheme.Https})
type
  Call_DriveCommentsDelete_594479 = ref object of OpenApiRestCall_593424
proc url_DriveCommentsDelete_594481(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveCommentsDelete_594480(path: JsonNode; query: JsonNode;
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
  var valid_594482 = path.getOrDefault("fileId")
  valid_594482 = validateParameter(valid_594482, JString, required = true,
                                 default = nil)
  if valid_594482 != nil:
    section.add "fileId", valid_594482
  var valid_594483 = path.getOrDefault("commentId")
  valid_594483 = validateParameter(valid_594483, JString, required = true,
                                 default = nil)
  if valid_594483 != nil:
    section.add "commentId", valid_594483
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
  var valid_594484 = query.getOrDefault("fields")
  valid_594484 = validateParameter(valid_594484, JString, required = false,
                                 default = nil)
  if valid_594484 != nil:
    section.add "fields", valid_594484
  var valid_594485 = query.getOrDefault("quotaUser")
  valid_594485 = validateParameter(valid_594485, JString, required = false,
                                 default = nil)
  if valid_594485 != nil:
    section.add "quotaUser", valid_594485
  var valid_594486 = query.getOrDefault("alt")
  valid_594486 = validateParameter(valid_594486, JString, required = false,
                                 default = newJString("json"))
  if valid_594486 != nil:
    section.add "alt", valid_594486
  var valid_594487 = query.getOrDefault("oauth_token")
  valid_594487 = validateParameter(valid_594487, JString, required = false,
                                 default = nil)
  if valid_594487 != nil:
    section.add "oauth_token", valid_594487
  var valid_594488 = query.getOrDefault("userIp")
  valid_594488 = validateParameter(valid_594488, JString, required = false,
                                 default = nil)
  if valid_594488 != nil:
    section.add "userIp", valid_594488
  var valid_594489 = query.getOrDefault("key")
  valid_594489 = validateParameter(valid_594489, JString, required = false,
                                 default = nil)
  if valid_594489 != nil:
    section.add "key", valid_594489
  var valid_594490 = query.getOrDefault("prettyPrint")
  valid_594490 = validateParameter(valid_594490, JBool, required = false,
                                 default = newJBool(true))
  if valid_594490 != nil:
    section.add "prettyPrint", valid_594490
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594491: Call_DriveCommentsDelete_594479; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a comment.
  ## 
  let valid = call_594491.validator(path, query, header, formData, body)
  let scheme = call_594491.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594491.url(scheme.get, call_594491.host, call_594491.base,
                         call_594491.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594491, url, valid)

proc call*(call_594492: Call_DriveCommentsDelete_594479; fileId: string;
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
  var path_594493 = newJObject()
  var query_594494 = newJObject()
  add(query_594494, "fields", newJString(fields))
  add(query_594494, "quotaUser", newJString(quotaUser))
  add(path_594493, "fileId", newJString(fileId))
  add(query_594494, "alt", newJString(alt))
  add(query_594494, "oauth_token", newJString(oauthToken))
  add(query_594494, "userIp", newJString(userIp))
  add(query_594494, "key", newJString(key))
  add(path_594493, "commentId", newJString(commentId))
  add(query_594494, "prettyPrint", newJBool(prettyPrint))
  result = call_594492.call(path_594493, query_594494, nil, nil, nil)

var driveCommentsDelete* = Call_DriveCommentsDelete_594479(
    name: "driveCommentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsDelete_594480, base: "/drive/v2",
    url: url_DriveCommentsDelete_594481, schemes: {Scheme.Https})
type
  Call_DriveRepliesInsert_594532 = ref object of OpenApiRestCall_593424
proc url_DriveRepliesInsert_594534(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveRepliesInsert_594533(path: JsonNode; query: JsonNode;
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
  var valid_594535 = path.getOrDefault("fileId")
  valid_594535 = validateParameter(valid_594535, JString, required = true,
                                 default = nil)
  if valid_594535 != nil:
    section.add "fileId", valid_594535
  var valid_594536 = path.getOrDefault("commentId")
  valid_594536 = validateParameter(valid_594536, JString, required = true,
                                 default = nil)
  if valid_594536 != nil:
    section.add "commentId", valid_594536
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
  var valid_594537 = query.getOrDefault("fields")
  valid_594537 = validateParameter(valid_594537, JString, required = false,
                                 default = nil)
  if valid_594537 != nil:
    section.add "fields", valid_594537
  var valid_594538 = query.getOrDefault("quotaUser")
  valid_594538 = validateParameter(valid_594538, JString, required = false,
                                 default = nil)
  if valid_594538 != nil:
    section.add "quotaUser", valid_594538
  var valid_594539 = query.getOrDefault("alt")
  valid_594539 = validateParameter(valid_594539, JString, required = false,
                                 default = newJString("json"))
  if valid_594539 != nil:
    section.add "alt", valid_594539
  var valid_594540 = query.getOrDefault("oauth_token")
  valid_594540 = validateParameter(valid_594540, JString, required = false,
                                 default = nil)
  if valid_594540 != nil:
    section.add "oauth_token", valid_594540
  var valid_594541 = query.getOrDefault("userIp")
  valid_594541 = validateParameter(valid_594541, JString, required = false,
                                 default = nil)
  if valid_594541 != nil:
    section.add "userIp", valid_594541
  var valid_594542 = query.getOrDefault("key")
  valid_594542 = validateParameter(valid_594542, JString, required = false,
                                 default = nil)
  if valid_594542 != nil:
    section.add "key", valid_594542
  var valid_594543 = query.getOrDefault("prettyPrint")
  valid_594543 = validateParameter(valid_594543, JBool, required = false,
                                 default = newJBool(true))
  if valid_594543 != nil:
    section.add "prettyPrint", valid_594543
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

proc call*(call_594545: Call_DriveRepliesInsert_594532; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new reply to the given comment.
  ## 
  let valid = call_594545.validator(path, query, header, formData, body)
  let scheme = call_594545.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594545.url(scheme.get, call_594545.host, call_594545.base,
                         call_594545.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594545, url, valid)

proc call*(call_594546: Call_DriveRepliesInsert_594532; fileId: string;
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
  var path_594547 = newJObject()
  var query_594548 = newJObject()
  var body_594549 = newJObject()
  add(query_594548, "fields", newJString(fields))
  add(query_594548, "quotaUser", newJString(quotaUser))
  add(path_594547, "fileId", newJString(fileId))
  add(query_594548, "alt", newJString(alt))
  add(query_594548, "oauth_token", newJString(oauthToken))
  add(query_594548, "userIp", newJString(userIp))
  add(query_594548, "key", newJString(key))
  add(path_594547, "commentId", newJString(commentId))
  if body != nil:
    body_594549 = body
  add(query_594548, "prettyPrint", newJBool(prettyPrint))
  result = call_594546.call(path_594547, query_594548, nil, nil, body_594549)

var driveRepliesInsert* = Call_DriveRepliesInsert_594532(
    name: "driveRepliesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies",
    validator: validate_DriveRepliesInsert_594533, base: "/drive/v2",
    url: url_DriveRepliesInsert_594534, schemes: {Scheme.Https})
type
  Call_DriveRepliesList_594513 = ref object of OpenApiRestCall_593424
proc url_DriveRepliesList_594515(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveRepliesList_594514(path: JsonNode; query: JsonNode;
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
  var valid_594516 = path.getOrDefault("fileId")
  valid_594516 = validateParameter(valid_594516, JString, required = true,
                                 default = nil)
  if valid_594516 != nil:
    section.add "fileId", valid_594516
  var valid_594517 = path.getOrDefault("commentId")
  valid_594517 = validateParameter(valid_594517, JString, required = true,
                                 default = nil)
  if valid_594517 != nil:
    section.add "commentId", valid_594517
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
  var valid_594518 = query.getOrDefault("fields")
  valid_594518 = validateParameter(valid_594518, JString, required = false,
                                 default = nil)
  if valid_594518 != nil:
    section.add "fields", valid_594518
  var valid_594519 = query.getOrDefault("pageToken")
  valid_594519 = validateParameter(valid_594519, JString, required = false,
                                 default = nil)
  if valid_594519 != nil:
    section.add "pageToken", valid_594519
  var valid_594520 = query.getOrDefault("quotaUser")
  valid_594520 = validateParameter(valid_594520, JString, required = false,
                                 default = nil)
  if valid_594520 != nil:
    section.add "quotaUser", valid_594520
  var valid_594521 = query.getOrDefault("alt")
  valid_594521 = validateParameter(valid_594521, JString, required = false,
                                 default = newJString("json"))
  if valid_594521 != nil:
    section.add "alt", valid_594521
  var valid_594522 = query.getOrDefault("oauth_token")
  valid_594522 = validateParameter(valid_594522, JString, required = false,
                                 default = nil)
  if valid_594522 != nil:
    section.add "oauth_token", valid_594522
  var valid_594523 = query.getOrDefault("userIp")
  valid_594523 = validateParameter(valid_594523, JString, required = false,
                                 default = nil)
  if valid_594523 != nil:
    section.add "userIp", valid_594523
  var valid_594524 = query.getOrDefault("maxResults")
  valid_594524 = validateParameter(valid_594524, JInt, required = false,
                                 default = newJInt(20))
  if valid_594524 != nil:
    section.add "maxResults", valid_594524
  var valid_594525 = query.getOrDefault("key")
  valid_594525 = validateParameter(valid_594525, JString, required = false,
                                 default = nil)
  if valid_594525 != nil:
    section.add "key", valid_594525
  var valid_594526 = query.getOrDefault("includeDeleted")
  valid_594526 = validateParameter(valid_594526, JBool, required = false,
                                 default = newJBool(false))
  if valid_594526 != nil:
    section.add "includeDeleted", valid_594526
  var valid_594527 = query.getOrDefault("prettyPrint")
  valid_594527 = validateParameter(valid_594527, JBool, required = false,
                                 default = newJBool(true))
  if valid_594527 != nil:
    section.add "prettyPrint", valid_594527
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594528: Call_DriveRepliesList_594513; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the replies to a comment.
  ## 
  let valid = call_594528.validator(path, query, header, formData, body)
  let scheme = call_594528.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594528.url(scheme.get, call_594528.host, call_594528.base,
                         call_594528.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594528, url, valid)

proc call*(call_594529: Call_DriveRepliesList_594513; fileId: string;
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
  var path_594530 = newJObject()
  var query_594531 = newJObject()
  add(query_594531, "fields", newJString(fields))
  add(query_594531, "pageToken", newJString(pageToken))
  add(query_594531, "quotaUser", newJString(quotaUser))
  add(path_594530, "fileId", newJString(fileId))
  add(query_594531, "alt", newJString(alt))
  add(query_594531, "oauth_token", newJString(oauthToken))
  add(query_594531, "userIp", newJString(userIp))
  add(query_594531, "maxResults", newJInt(maxResults))
  add(query_594531, "key", newJString(key))
  add(path_594530, "commentId", newJString(commentId))
  add(query_594531, "includeDeleted", newJBool(includeDeleted))
  add(query_594531, "prettyPrint", newJBool(prettyPrint))
  result = call_594529.call(path_594530, query_594531, nil, nil, nil)

var driveRepliesList* = Call_DriveRepliesList_594513(name: "driveRepliesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies",
    validator: validate_DriveRepliesList_594514, base: "/drive/v2",
    url: url_DriveRepliesList_594515, schemes: {Scheme.Https})
type
  Call_DriveRepliesUpdate_594568 = ref object of OpenApiRestCall_593424
proc url_DriveRepliesUpdate_594570(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveRepliesUpdate_594569(path: JsonNode; query: JsonNode;
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
  var valid_594571 = path.getOrDefault("fileId")
  valid_594571 = validateParameter(valid_594571, JString, required = true,
                                 default = nil)
  if valid_594571 != nil:
    section.add "fileId", valid_594571
  var valid_594572 = path.getOrDefault("replyId")
  valid_594572 = validateParameter(valid_594572, JString, required = true,
                                 default = nil)
  if valid_594572 != nil:
    section.add "replyId", valid_594572
  var valid_594573 = path.getOrDefault("commentId")
  valid_594573 = validateParameter(valid_594573, JString, required = true,
                                 default = nil)
  if valid_594573 != nil:
    section.add "commentId", valid_594573
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
  var valid_594574 = query.getOrDefault("fields")
  valid_594574 = validateParameter(valid_594574, JString, required = false,
                                 default = nil)
  if valid_594574 != nil:
    section.add "fields", valid_594574
  var valid_594575 = query.getOrDefault("quotaUser")
  valid_594575 = validateParameter(valid_594575, JString, required = false,
                                 default = nil)
  if valid_594575 != nil:
    section.add "quotaUser", valid_594575
  var valid_594576 = query.getOrDefault("alt")
  valid_594576 = validateParameter(valid_594576, JString, required = false,
                                 default = newJString("json"))
  if valid_594576 != nil:
    section.add "alt", valid_594576
  var valid_594577 = query.getOrDefault("oauth_token")
  valid_594577 = validateParameter(valid_594577, JString, required = false,
                                 default = nil)
  if valid_594577 != nil:
    section.add "oauth_token", valid_594577
  var valid_594578 = query.getOrDefault("userIp")
  valid_594578 = validateParameter(valid_594578, JString, required = false,
                                 default = nil)
  if valid_594578 != nil:
    section.add "userIp", valid_594578
  var valid_594579 = query.getOrDefault("key")
  valid_594579 = validateParameter(valid_594579, JString, required = false,
                                 default = nil)
  if valid_594579 != nil:
    section.add "key", valid_594579
  var valid_594580 = query.getOrDefault("prettyPrint")
  valid_594580 = validateParameter(valid_594580, JBool, required = false,
                                 default = newJBool(true))
  if valid_594580 != nil:
    section.add "prettyPrint", valid_594580
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

proc call*(call_594582: Call_DriveRepliesUpdate_594568; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing reply.
  ## 
  let valid = call_594582.validator(path, query, header, formData, body)
  let scheme = call_594582.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594582.url(scheme.get, call_594582.host, call_594582.base,
                         call_594582.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594582, url, valid)

proc call*(call_594583: Call_DriveRepliesUpdate_594568; fileId: string;
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
  var path_594584 = newJObject()
  var query_594585 = newJObject()
  var body_594586 = newJObject()
  add(query_594585, "fields", newJString(fields))
  add(query_594585, "quotaUser", newJString(quotaUser))
  add(path_594584, "fileId", newJString(fileId))
  add(query_594585, "alt", newJString(alt))
  add(query_594585, "oauth_token", newJString(oauthToken))
  add(query_594585, "userIp", newJString(userIp))
  add(query_594585, "key", newJString(key))
  add(path_594584, "replyId", newJString(replyId))
  add(path_594584, "commentId", newJString(commentId))
  if body != nil:
    body_594586 = body
  add(query_594585, "prettyPrint", newJBool(prettyPrint))
  result = call_594583.call(path_594584, query_594585, nil, nil, body_594586)

var driveRepliesUpdate* = Call_DriveRepliesUpdate_594568(
    name: "driveRepliesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesUpdate_594569, base: "/drive/v2",
    url: url_DriveRepliesUpdate_594570, schemes: {Scheme.Https})
type
  Call_DriveRepliesGet_594550 = ref object of OpenApiRestCall_593424
proc url_DriveRepliesGet_594552(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveRepliesGet_594551(path: JsonNode; query: JsonNode;
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
  var valid_594553 = path.getOrDefault("fileId")
  valid_594553 = validateParameter(valid_594553, JString, required = true,
                                 default = nil)
  if valid_594553 != nil:
    section.add "fileId", valid_594553
  var valid_594554 = path.getOrDefault("replyId")
  valid_594554 = validateParameter(valid_594554, JString, required = true,
                                 default = nil)
  if valid_594554 != nil:
    section.add "replyId", valid_594554
  var valid_594555 = path.getOrDefault("commentId")
  valid_594555 = validateParameter(valid_594555, JString, required = true,
                                 default = nil)
  if valid_594555 != nil:
    section.add "commentId", valid_594555
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
  var valid_594556 = query.getOrDefault("fields")
  valid_594556 = validateParameter(valid_594556, JString, required = false,
                                 default = nil)
  if valid_594556 != nil:
    section.add "fields", valid_594556
  var valid_594557 = query.getOrDefault("quotaUser")
  valid_594557 = validateParameter(valid_594557, JString, required = false,
                                 default = nil)
  if valid_594557 != nil:
    section.add "quotaUser", valid_594557
  var valid_594558 = query.getOrDefault("alt")
  valid_594558 = validateParameter(valid_594558, JString, required = false,
                                 default = newJString("json"))
  if valid_594558 != nil:
    section.add "alt", valid_594558
  var valid_594559 = query.getOrDefault("oauth_token")
  valid_594559 = validateParameter(valid_594559, JString, required = false,
                                 default = nil)
  if valid_594559 != nil:
    section.add "oauth_token", valid_594559
  var valid_594560 = query.getOrDefault("userIp")
  valid_594560 = validateParameter(valid_594560, JString, required = false,
                                 default = nil)
  if valid_594560 != nil:
    section.add "userIp", valid_594560
  var valid_594561 = query.getOrDefault("key")
  valid_594561 = validateParameter(valid_594561, JString, required = false,
                                 default = nil)
  if valid_594561 != nil:
    section.add "key", valid_594561
  var valid_594562 = query.getOrDefault("includeDeleted")
  valid_594562 = validateParameter(valid_594562, JBool, required = false,
                                 default = newJBool(false))
  if valid_594562 != nil:
    section.add "includeDeleted", valid_594562
  var valid_594563 = query.getOrDefault("prettyPrint")
  valid_594563 = validateParameter(valid_594563, JBool, required = false,
                                 default = newJBool(true))
  if valid_594563 != nil:
    section.add "prettyPrint", valid_594563
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594564: Call_DriveRepliesGet_594550; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a reply.
  ## 
  let valid = call_594564.validator(path, query, header, formData, body)
  let scheme = call_594564.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594564.url(scheme.get, call_594564.host, call_594564.base,
                         call_594564.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594564, url, valid)

proc call*(call_594565: Call_DriveRepliesGet_594550; fileId: string; replyId: string;
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
  var path_594566 = newJObject()
  var query_594567 = newJObject()
  add(query_594567, "fields", newJString(fields))
  add(query_594567, "quotaUser", newJString(quotaUser))
  add(path_594566, "fileId", newJString(fileId))
  add(query_594567, "alt", newJString(alt))
  add(query_594567, "oauth_token", newJString(oauthToken))
  add(query_594567, "userIp", newJString(userIp))
  add(query_594567, "key", newJString(key))
  add(path_594566, "replyId", newJString(replyId))
  add(path_594566, "commentId", newJString(commentId))
  add(query_594567, "includeDeleted", newJBool(includeDeleted))
  add(query_594567, "prettyPrint", newJBool(prettyPrint))
  result = call_594565.call(path_594566, query_594567, nil, nil, nil)

var driveRepliesGet* = Call_DriveRepliesGet_594550(name: "driveRepliesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesGet_594551, base: "/drive/v2",
    url: url_DriveRepliesGet_594552, schemes: {Scheme.Https})
type
  Call_DriveRepliesPatch_594604 = ref object of OpenApiRestCall_593424
proc url_DriveRepliesPatch_594606(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveRepliesPatch_594605(path: JsonNode; query: JsonNode;
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
  var valid_594607 = path.getOrDefault("fileId")
  valid_594607 = validateParameter(valid_594607, JString, required = true,
                                 default = nil)
  if valid_594607 != nil:
    section.add "fileId", valid_594607
  var valid_594608 = path.getOrDefault("replyId")
  valid_594608 = validateParameter(valid_594608, JString, required = true,
                                 default = nil)
  if valid_594608 != nil:
    section.add "replyId", valid_594608
  var valid_594609 = path.getOrDefault("commentId")
  valid_594609 = validateParameter(valid_594609, JString, required = true,
                                 default = nil)
  if valid_594609 != nil:
    section.add "commentId", valid_594609
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
  var valid_594610 = query.getOrDefault("fields")
  valid_594610 = validateParameter(valid_594610, JString, required = false,
                                 default = nil)
  if valid_594610 != nil:
    section.add "fields", valid_594610
  var valid_594611 = query.getOrDefault("quotaUser")
  valid_594611 = validateParameter(valid_594611, JString, required = false,
                                 default = nil)
  if valid_594611 != nil:
    section.add "quotaUser", valid_594611
  var valid_594612 = query.getOrDefault("alt")
  valid_594612 = validateParameter(valid_594612, JString, required = false,
                                 default = newJString("json"))
  if valid_594612 != nil:
    section.add "alt", valid_594612
  var valid_594613 = query.getOrDefault("oauth_token")
  valid_594613 = validateParameter(valid_594613, JString, required = false,
                                 default = nil)
  if valid_594613 != nil:
    section.add "oauth_token", valid_594613
  var valid_594614 = query.getOrDefault("userIp")
  valid_594614 = validateParameter(valid_594614, JString, required = false,
                                 default = nil)
  if valid_594614 != nil:
    section.add "userIp", valid_594614
  var valid_594615 = query.getOrDefault("key")
  valid_594615 = validateParameter(valid_594615, JString, required = false,
                                 default = nil)
  if valid_594615 != nil:
    section.add "key", valid_594615
  var valid_594616 = query.getOrDefault("prettyPrint")
  valid_594616 = validateParameter(valid_594616, JBool, required = false,
                                 default = newJBool(true))
  if valid_594616 != nil:
    section.add "prettyPrint", valid_594616
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

proc call*(call_594618: Call_DriveRepliesPatch_594604; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing reply. This method supports patch semantics.
  ## 
  let valid = call_594618.validator(path, query, header, formData, body)
  let scheme = call_594618.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594618.url(scheme.get, call_594618.host, call_594618.base,
                         call_594618.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594618, url, valid)

proc call*(call_594619: Call_DriveRepliesPatch_594604; fileId: string;
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
  var path_594620 = newJObject()
  var query_594621 = newJObject()
  var body_594622 = newJObject()
  add(query_594621, "fields", newJString(fields))
  add(query_594621, "quotaUser", newJString(quotaUser))
  add(path_594620, "fileId", newJString(fileId))
  add(query_594621, "alt", newJString(alt))
  add(query_594621, "oauth_token", newJString(oauthToken))
  add(query_594621, "userIp", newJString(userIp))
  add(query_594621, "key", newJString(key))
  add(path_594620, "replyId", newJString(replyId))
  add(path_594620, "commentId", newJString(commentId))
  if body != nil:
    body_594622 = body
  add(query_594621, "prettyPrint", newJBool(prettyPrint))
  result = call_594619.call(path_594620, query_594621, nil, nil, body_594622)

var driveRepliesPatch* = Call_DriveRepliesPatch_594604(name: "driveRepliesPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesPatch_594605, base: "/drive/v2",
    url: url_DriveRepliesPatch_594606, schemes: {Scheme.Https})
type
  Call_DriveRepliesDelete_594587 = ref object of OpenApiRestCall_593424
proc url_DriveRepliesDelete_594589(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveRepliesDelete_594588(path: JsonNode; query: JsonNode;
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
  var valid_594590 = path.getOrDefault("fileId")
  valid_594590 = validateParameter(valid_594590, JString, required = true,
                                 default = nil)
  if valid_594590 != nil:
    section.add "fileId", valid_594590
  var valid_594591 = path.getOrDefault("replyId")
  valid_594591 = validateParameter(valid_594591, JString, required = true,
                                 default = nil)
  if valid_594591 != nil:
    section.add "replyId", valid_594591
  var valid_594592 = path.getOrDefault("commentId")
  valid_594592 = validateParameter(valid_594592, JString, required = true,
                                 default = nil)
  if valid_594592 != nil:
    section.add "commentId", valid_594592
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
  var valid_594593 = query.getOrDefault("fields")
  valid_594593 = validateParameter(valid_594593, JString, required = false,
                                 default = nil)
  if valid_594593 != nil:
    section.add "fields", valid_594593
  var valid_594594 = query.getOrDefault("quotaUser")
  valid_594594 = validateParameter(valid_594594, JString, required = false,
                                 default = nil)
  if valid_594594 != nil:
    section.add "quotaUser", valid_594594
  var valid_594595 = query.getOrDefault("alt")
  valid_594595 = validateParameter(valid_594595, JString, required = false,
                                 default = newJString("json"))
  if valid_594595 != nil:
    section.add "alt", valid_594595
  var valid_594596 = query.getOrDefault("oauth_token")
  valid_594596 = validateParameter(valid_594596, JString, required = false,
                                 default = nil)
  if valid_594596 != nil:
    section.add "oauth_token", valid_594596
  var valid_594597 = query.getOrDefault("userIp")
  valid_594597 = validateParameter(valid_594597, JString, required = false,
                                 default = nil)
  if valid_594597 != nil:
    section.add "userIp", valid_594597
  var valid_594598 = query.getOrDefault("key")
  valid_594598 = validateParameter(valid_594598, JString, required = false,
                                 default = nil)
  if valid_594598 != nil:
    section.add "key", valid_594598
  var valid_594599 = query.getOrDefault("prettyPrint")
  valid_594599 = validateParameter(valid_594599, JBool, required = false,
                                 default = newJBool(true))
  if valid_594599 != nil:
    section.add "prettyPrint", valid_594599
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594600: Call_DriveRepliesDelete_594587; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a reply.
  ## 
  let valid = call_594600.validator(path, query, header, formData, body)
  let scheme = call_594600.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594600.url(scheme.get, call_594600.host, call_594600.base,
                         call_594600.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594600, url, valid)

proc call*(call_594601: Call_DriveRepliesDelete_594587; fileId: string;
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
  var path_594602 = newJObject()
  var query_594603 = newJObject()
  add(query_594603, "fields", newJString(fields))
  add(query_594603, "quotaUser", newJString(quotaUser))
  add(path_594602, "fileId", newJString(fileId))
  add(query_594603, "alt", newJString(alt))
  add(query_594603, "oauth_token", newJString(oauthToken))
  add(query_594603, "userIp", newJString(userIp))
  add(query_594603, "key", newJString(key))
  add(path_594602, "replyId", newJString(replyId))
  add(path_594602, "commentId", newJString(commentId))
  add(query_594603, "prettyPrint", newJBool(prettyPrint))
  result = call_594601.call(path_594602, query_594603, nil, nil, nil)

var driveRepliesDelete* = Call_DriveRepliesDelete_594587(
    name: "driveRepliesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesDelete_594588, base: "/drive/v2",
    url: url_DriveRepliesDelete_594589, schemes: {Scheme.Https})
type
  Call_DriveFilesCopy_594623 = ref object of OpenApiRestCall_593424
proc url_DriveFilesCopy_594625(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveFilesCopy_594624(path: JsonNode; query: JsonNode;
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
  var valid_594626 = path.getOrDefault("fileId")
  valid_594626 = validateParameter(valid_594626, JString, required = true,
                                 default = nil)
  if valid_594626 != nil:
    section.add "fileId", valid_594626
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
  var valid_594627 = query.getOrDefault("supportsAllDrives")
  valid_594627 = validateParameter(valid_594627, JBool, required = false,
                                 default = newJBool(false))
  if valid_594627 != nil:
    section.add "supportsAllDrives", valid_594627
  var valid_594628 = query.getOrDefault("fields")
  valid_594628 = validateParameter(valid_594628, JString, required = false,
                                 default = nil)
  if valid_594628 != nil:
    section.add "fields", valid_594628
  var valid_594629 = query.getOrDefault("quotaUser")
  valid_594629 = validateParameter(valid_594629, JString, required = false,
                                 default = nil)
  if valid_594629 != nil:
    section.add "quotaUser", valid_594629
  var valid_594630 = query.getOrDefault("alt")
  valid_594630 = validateParameter(valid_594630, JString, required = false,
                                 default = newJString("json"))
  if valid_594630 != nil:
    section.add "alt", valid_594630
  var valid_594631 = query.getOrDefault("pinned")
  valid_594631 = validateParameter(valid_594631, JBool, required = false,
                                 default = newJBool(false))
  if valid_594631 != nil:
    section.add "pinned", valid_594631
  var valid_594632 = query.getOrDefault("oauth_token")
  valid_594632 = validateParameter(valid_594632, JString, required = false,
                                 default = nil)
  if valid_594632 != nil:
    section.add "oauth_token", valid_594632
  var valid_594633 = query.getOrDefault("userIp")
  valid_594633 = validateParameter(valid_594633, JString, required = false,
                                 default = nil)
  if valid_594633 != nil:
    section.add "userIp", valid_594633
  var valid_594634 = query.getOrDefault("ocr")
  valid_594634 = validateParameter(valid_594634, JBool, required = false,
                                 default = newJBool(false))
  if valid_594634 != nil:
    section.add "ocr", valid_594634
  var valid_594635 = query.getOrDefault("timedTextLanguage")
  valid_594635 = validateParameter(valid_594635, JString, required = false,
                                 default = nil)
  if valid_594635 != nil:
    section.add "timedTextLanguage", valid_594635
  var valid_594636 = query.getOrDefault("supportsTeamDrives")
  valid_594636 = validateParameter(valid_594636, JBool, required = false,
                                 default = newJBool(false))
  if valid_594636 != nil:
    section.add "supportsTeamDrives", valid_594636
  var valid_594637 = query.getOrDefault("key")
  valid_594637 = validateParameter(valid_594637, JString, required = false,
                                 default = nil)
  if valid_594637 != nil:
    section.add "key", valid_594637
  var valid_594638 = query.getOrDefault("convert")
  valid_594638 = validateParameter(valid_594638, JBool, required = false,
                                 default = newJBool(false))
  if valid_594638 != nil:
    section.add "convert", valid_594638
  var valid_594639 = query.getOrDefault("prettyPrint")
  valid_594639 = validateParameter(valid_594639, JBool, required = false,
                                 default = newJBool(true))
  if valid_594639 != nil:
    section.add "prettyPrint", valid_594639
  var valid_594640 = query.getOrDefault("ocrLanguage")
  valid_594640 = validateParameter(valid_594640, JString, required = false,
                                 default = nil)
  if valid_594640 != nil:
    section.add "ocrLanguage", valid_594640
  var valid_594641 = query.getOrDefault("timedTextTrackName")
  valid_594641 = validateParameter(valid_594641, JString, required = false,
                                 default = nil)
  if valid_594641 != nil:
    section.add "timedTextTrackName", valid_594641
  var valid_594642 = query.getOrDefault("visibility")
  valid_594642 = validateParameter(valid_594642, JString, required = false,
                                 default = newJString("DEFAULT"))
  if valid_594642 != nil:
    section.add "visibility", valid_594642
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

proc call*(call_594644: Call_DriveFilesCopy_594623; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a copy of the specified file.
  ## 
  let valid = call_594644.validator(path, query, header, formData, body)
  let scheme = call_594644.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594644.url(scheme.get, call_594644.host, call_594644.base,
                         call_594644.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594644, url, valid)

proc call*(call_594645: Call_DriveFilesCopy_594623; fileId: string;
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
  var path_594646 = newJObject()
  var query_594647 = newJObject()
  var body_594648 = newJObject()
  add(query_594647, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594647, "fields", newJString(fields))
  add(query_594647, "quotaUser", newJString(quotaUser))
  add(path_594646, "fileId", newJString(fileId))
  add(query_594647, "alt", newJString(alt))
  add(query_594647, "pinned", newJBool(pinned))
  add(query_594647, "oauth_token", newJString(oauthToken))
  add(query_594647, "userIp", newJString(userIp))
  add(query_594647, "ocr", newJBool(ocr))
  add(query_594647, "timedTextLanguage", newJString(timedTextLanguage))
  add(query_594647, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594647, "key", newJString(key))
  add(query_594647, "convert", newJBool(convert))
  if body != nil:
    body_594648 = body
  add(query_594647, "prettyPrint", newJBool(prettyPrint))
  add(query_594647, "ocrLanguage", newJString(ocrLanguage))
  add(query_594647, "timedTextTrackName", newJString(timedTextTrackName))
  add(query_594647, "visibility", newJString(visibility))
  result = call_594645.call(path_594646, query_594647, nil, nil, body_594648)

var driveFilesCopy* = Call_DriveFilesCopy_594623(name: "driveFilesCopy",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/copy", validator: validate_DriveFilesCopy_594624,
    base: "/drive/v2", url: url_DriveFilesCopy_594625, schemes: {Scheme.Https})
type
  Call_DriveFilesExport_594649 = ref object of OpenApiRestCall_593424
proc url_DriveFilesExport_594651(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveFilesExport_594650(path: JsonNode; query: JsonNode;
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
  var valid_594652 = path.getOrDefault("fileId")
  valid_594652 = validateParameter(valid_594652, JString, required = true,
                                 default = nil)
  if valid_594652 != nil:
    section.add "fileId", valid_594652
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
  var valid_594653 = query.getOrDefault("fields")
  valid_594653 = validateParameter(valid_594653, JString, required = false,
                                 default = nil)
  if valid_594653 != nil:
    section.add "fields", valid_594653
  var valid_594654 = query.getOrDefault("quotaUser")
  valid_594654 = validateParameter(valid_594654, JString, required = false,
                                 default = nil)
  if valid_594654 != nil:
    section.add "quotaUser", valid_594654
  var valid_594655 = query.getOrDefault("alt")
  valid_594655 = validateParameter(valid_594655, JString, required = false,
                                 default = newJString("json"))
  if valid_594655 != nil:
    section.add "alt", valid_594655
  var valid_594656 = query.getOrDefault("oauth_token")
  valid_594656 = validateParameter(valid_594656, JString, required = false,
                                 default = nil)
  if valid_594656 != nil:
    section.add "oauth_token", valid_594656
  var valid_594657 = query.getOrDefault("userIp")
  valid_594657 = validateParameter(valid_594657, JString, required = false,
                                 default = nil)
  if valid_594657 != nil:
    section.add "userIp", valid_594657
  assert query != nil,
        "query argument is necessary due to required `mimeType` field"
  var valid_594658 = query.getOrDefault("mimeType")
  valid_594658 = validateParameter(valid_594658, JString, required = true,
                                 default = nil)
  if valid_594658 != nil:
    section.add "mimeType", valid_594658
  var valid_594659 = query.getOrDefault("key")
  valid_594659 = validateParameter(valid_594659, JString, required = false,
                                 default = nil)
  if valid_594659 != nil:
    section.add "key", valid_594659
  var valid_594660 = query.getOrDefault("prettyPrint")
  valid_594660 = validateParameter(valid_594660, JBool, required = false,
                                 default = newJBool(true))
  if valid_594660 != nil:
    section.add "prettyPrint", valid_594660
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594661: Call_DriveFilesExport_594649; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports a Google Doc to the requested MIME type and returns the exported content. Please note that the exported content is limited to 10MB.
  ## 
  let valid = call_594661.validator(path, query, header, formData, body)
  let scheme = call_594661.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594661.url(scheme.get, call_594661.host, call_594661.base,
                         call_594661.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594661, url, valid)

proc call*(call_594662: Call_DriveFilesExport_594649; fileId: string;
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
  var path_594663 = newJObject()
  var query_594664 = newJObject()
  add(query_594664, "fields", newJString(fields))
  add(query_594664, "quotaUser", newJString(quotaUser))
  add(path_594663, "fileId", newJString(fileId))
  add(query_594664, "alt", newJString(alt))
  add(query_594664, "oauth_token", newJString(oauthToken))
  add(query_594664, "userIp", newJString(userIp))
  add(query_594664, "mimeType", newJString(mimeType))
  add(query_594664, "key", newJString(key))
  add(query_594664, "prettyPrint", newJBool(prettyPrint))
  result = call_594662.call(path_594663, query_594664, nil, nil, nil)

var driveFilesExport* = Call_DriveFilesExport_594649(name: "driveFilesExport",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/export", validator: validate_DriveFilesExport_594650,
    base: "/drive/v2", url: url_DriveFilesExport_594651, schemes: {Scheme.Https})
type
  Call_DriveParentsInsert_594680 = ref object of OpenApiRestCall_593424
proc url_DriveParentsInsert_594682(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveParentsInsert_594681(path: JsonNode; query: JsonNode;
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
  var valid_594683 = path.getOrDefault("fileId")
  valid_594683 = validateParameter(valid_594683, JString, required = true,
                                 default = nil)
  if valid_594683 != nil:
    section.add "fileId", valid_594683
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
  var valid_594684 = query.getOrDefault("supportsAllDrives")
  valid_594684 = validateParameter(valid_594684, JBool, required = false,
                                 default = newJBool(false))
  if valid_594684 != nil:
    section.add "supportsAllDrives", valid_594684
  var valid_594685 = query.getOrDefault("fields")
  valid_594685 = validateParameter(valid_594685, JString, required = false,
                                 default = nil)
  if valid_594685 != nil:
    section.add "fields", valid_594685
  var valid_594686 = query.getOrDefault("quotaUser")
  valid_594686 = validateParameter(valid_594686, JString, required = false,
                                 default = nil)
  if valid_594686 != nil:
    section.add "quotaUser", valid_594686
  var valid_594687 = query.getOrDefault("alt")
  valid_594687 = validateParameter(valid_594687, JString, required = false,
                                 default = newJString("json"))
  if valid_594687 != nil:
    section.add "alt", valid_594687
  var valid_594688 = query.getOrDefault("oauth_token")
  valid_594688 = validateParameter(valid_594688, JString, required = false,
                                 default = nil)
  if valid_594688 != nil:
    section.add "oauth_token", valid_594688
  var valid_594689 = query.getOrDefault("userIp")
  valid_594689 = validateParameter(valid_594689, JString, required = false,
                                 default = nil)
  if valid_594689 != nil:
    section.add "userIp", valid_594689
  var valid_594690 = query.getOrDefault("supportsTeamDrives")
  valid_594690 = validateParameter(valid_594690, JBool, required = false,
                                 default = newJBool(false))
  if valid_594690 != nil:
    section.add "supportsTeamDrives", valid_594690
  var valid_594691 = query.getOrDefault("key")
  valid_594691 = validateParameter(valid_594691, JString, required = false,
                                 default = nil)
  if valid_594691 != nil:
    section.add "key", valid_594691
  var valid_594692 = query.getOrDefault("prettyPrint")
  valid_594692 = validateParameter(valid_594692, JBool, required = false,
                                 default = newJBool(true))
  if valid_594692 != nil:
    section.add "prettyPrint", valid_594692
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

proc call*(call_594694: Call_DriveParentsInsert_594680; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a parent folder for a file.
  ## 
  let valid = call_594694.validator(path, query, header, formData, body)
  let scheme = call_594694.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594694.url(scheme.get, call_594694.host, call_594694.base,
                         call_594694.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594694, url, valid)

proc call*(call_594695: Call_DriveParentsInsert_594680; fileId: string;
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
  var path_594696 = newJObject()
  var query_594697 = newJObject()
  var body_594698 = newJObject()
  add(query_594697, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594697, "fields", newJString(fields))
  add(query_594697, "quotaUser", newJString(quotaUser))
  add(path_594696, "fileId", newJString(fileId))
  add(query_594697, "alt", newJString(alt))
  add(query_594697, "oauth_token", newJString(oauthToken))
  add(query_594697, "userIp", newJString(userIp))
  add(query_594697, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594697, "key", newJString(key))
  if body != nil:
    body_594698 = body
  add(query_594697, "prettyPrint", newJBool(prettyPrint))
  result = call_594695.call(path_594696, query_594697, nil, nil, body_594698)

var driveParentsInsert* = Call_DriveParentsInsert_594680(
    name: "driveParentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/parents",
    validator: validate_DriveParentsInsert_594681, base: "/drive/v2",
    url: url_DriveParentsInsert_594682, schemes: {Scheme.Https})
type
  Call_DriveParentsList_594665 = ref object of OpenApiRestCall_593424
proc url_DriveParentsList_594667(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveParentsList_594666(path: JsonNode; query: JsonNode;
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
  var valid_594668 = path.getOrDefault("fileId")
  valid_594668 = validateParameter(valid_594668, JString, required = true,
                                 default = nil)
  if valid_594668 != nil:
    section.add "fileId", valid_594668
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
  var valid_594669 = query.getOrDefault("fields")
  valid_594669 = validateParameter(valid_594669, JString, required = false,
                                 default = nil)
  if valid_594669 != nil:
    section.add "fields", valid_594669
  var valid_594670 = query.getOrDefault("quotaUser")
  valid_594670 = validateParameter(valid_594670, JString, required = false,
                                 default = nil)
  if valid_594670 != nil:
    section.add "quotaUser", valid_594670
  var valid_594671 = query.getOrDefault("alt")
  valid_594671 = validateParameter(valid_594671, JString, required = false,
                                 default = newJString("json"))
  if valid_594671 != nil:
    section.add "alt", valid_594671
  var valid_594672 = query.getOrDefault("oauth_token")
  valid_594672 = validateParameter(valid_594672, JString, required = false,
                                 default = nil)
  if valid_594672 != nil:
    section.add "oauth_token", valid_594672
  var valid_594673 = query.getOrDefault("userIp")
  valid_594673 = validateParameter(valid_594673, JString, required = false,
                                 default = nil)
  if valid_594673 != nil:
    section.add "userIp", valid_594673
  var valid_594674 = query.getOrDefault("key")
  valid_594674 = validateParameter(valid_594674, JString, required = false,
                                 default = nil)
  if valid_594674 != nil:
    section.add "key", valid_594674
  var valid_594675 = query.getOrDefault("prettyPrint")
  valid_594675 = validateParameter(valid_594675, JBool, required = false,
                                 default = newJBool(true))
  if valid_594675 != nil:
    section.add "prettyPrint", valid_594675
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594676: Call_DriveParentsList_594665; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's parents.
  ## 
  let valid = call_594676.validator(path, query, header, formData, body)
  let scheme = call_594676.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594676.url(scheme.get, call_594676.host, call_594676.base,
                         call_594676.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594676, url, valid)

proc call*(call_594677: Call_DriveParentsList_594665; fileId: string;
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
  var path_594678 = newJObject()
  var query_594679 = newJObject()
  add(query_594679, "fields", newJString(fields))
  add(query_594679, "quotaUser", newJString(quotaUser))
  add(path_594678, "fileId", newJString(fileId))
  add(query_594679, "alt", newJString(alt))
  add(query_594679, "oauth_token", newJString(oauthToken))
  add(query_594679, "userIp", newJString(userIp))
  add(query_594679, "key", newJString(key))
  add(query_594679, "prettyPrint", newJBool(prettyPrint))
  result = call_594677.call(path_594678, query_594679, nil, nil, nil)

var driveParentsList* = Call_DriveParentsList_594665(name: "driveParentsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/parents", validator: validate_DriveParentsList_594666,
    base: "/drive/v2", url: url_DriveParentsList_594667, schemes: {Scheme.Https})
type
  Call_DriveParentsGet_594699 = ref object of OpenApiRestCall_593424
proc url_DriveParentsGet_594701(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveParentsGet_594700(path: JsonNode; query: JsonNode;
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
  var valid_594702 = path.getOrDefault("fileId")
  valid_594702 = validateParameter(valid_594702, JString, required = true,
                                 default = nil)
  if valid_594702 != nil:
    section.add "fileId", valid_594702
  var valid_594703 = path.getOrDefault("parentId")
  valid_594703 = validateParameter(valid_594703, JString, required = true,
                                 default = nil)
  if valid_594703 != nil:
    section.add "parentId", valid_594703
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
  var valid_594704 = query.getOrDefault("fields")
  valid_594704 = validateParameter(valid_594704, JString, required = false,
                                 default = nil)
  if valid_594704 != nil:
    section.add "fields", valid_594704
  var valid_594705 = query.getOrDefault("quotaUser")
  valid_594705 = validateParameter(valid_594705, JString, required = false,
                                 default = nil)
  if valid_594705 != nil:
    section.add "quotaUser", valid_594705
  var valid_594706 = query.getOrDefault("alt")
  valid_594706 = validateParameter(valid_594706, JString, required = false,
                                 default = newJString("json"))
  if valid_594706 != nil:
    section.add "alt", valid_594706
  var valid_594707 = query.getOrDefault("oauth_token")
  valid_594707 = validateParameter(valid_594707, JString, required = false,
                                 default = nil)
  if valid_594707 != nil:
    section.add "oauth_token", valid_594707
  var valid_594708 = query.getOrDefault("userIp")
  valid_594708 = validateParameter(valid_594708, JString, required = false,
                                 default = nil)
  if valid_594708 != nil:
    section.add "userIp", valid_594708
  var valid_594709 = query.getOrDefault("key")
  valid_594709 = validateParameter(valid_594709, JString, required = false,
                                 default = nil)
  if valid_594709 != nil:
    section.add "key", valid_594709
  var valid_594710 = query.getOrDefault("prettyPrint")
  valid_594710 = validateParameter(valid_594710, JBool, required = false,
                                 default = newJBool(true))
  if valid_594710 != nil:
    section.add "prettyPrint", valid_594710
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594711: Call_DriveParentsGet_594699; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific parent reference.
  ## 
  let valid = call_594711.validator(path, query, header, formData, body)
  let scheme = call_594711.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594711.url(scheme.get, call_594711.host, call_594711.base,
                         call_594711.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594711, url, valid)

proc call*(call_594712: Call_DriveParentsGet_594699; fileId: string;
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
  var path_594713 = newJObject()
  var query_594714 = newJObject()
  add(query_594714, "fields", newJString(fields))
  add(query_594714, "quotaUser", newJString(quotaUser))
  add(path_594713, "fileId", newJString(fileId))
  add(query_594714, "alt", newJString(alt))
  add(path_594713, "parentId", newJString(parentId))
  add(query_594714, "oauth_token", newJString(oauthToken))
  add(query_594714, "userIp", newJString(userIp))
  add(query_594714, "key", newJString(key))
  add(query_594714, "prettyPrint", newJBool(prettyPrint))
  result = call_594712.call(path_594713, query_594714, nil, nil, nil)

var driveParentsGet* = Call_DriveParentsGet_594699(name: "driveParentsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/parents/{parentId}",
    validator: validate_DriveParentsGet_594700, base: "/drive/v2",
    url: url_DriveParentsGet_594701, schemes: {Scheme.Https})
type
  Call_DriveParentsDelete_594715 = ref object of OpenApiRestCall_593424
proc url_DriveParentsDelete_594717(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveParentsDelete_594716(path: JsonNode; query: JsonNode;
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
  var valid_594718 = path.getOrDefault("fileId")
  valid_594718 = validateParameter(valid_594718, JString, required = true,
                                 default = nil)
  if valid_594718 != nil:
    section.add "fileId", valid_594718
  var valid_594719 = path.getOrDefault("parentId")
  valid_594719 = validateParameter(valid_594719, JString, required = true,
                                 default = nil)
  if valid_594719 != nil:
    section.add "parentId", valid_594719
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
  var valid_594720 = query.getOrDefault("fields")
  valid_594720 = validateParameter(valid_594720, JString, required = false,
                                 default = nil)
  if valid_594720 != nil:
    section.add "fields", valid_594720
  var valid_594721 = query.getOrDefault("quotaUser")
  valid_594721 = validateParameter(valid_594721, JString, required = false,
                                 default = nil)
  if valid_594721 != nil:
    section.add "quotaUser", valid_594721
  var valid_594722 = query.getOrDefault("alt")
  valid_594722 = validateParameter(valid_594722, JString, required = false,
                                 default = newJString("json"))
  if valid_594722 != nil:
    section.add "alt", valid_594722
  var valid_594723 = query.getOrDefault("oauth_token")
  valid_594723 = validateParameter(valid_594723, JString, required = false,
                                 default = nil)
  if valid_594723 != nil:
    section.add "oauth_token", valid_594723
  var valid_594724 = query.getOrDefault("userIp")
  valid_594724 = validateParameter(valid_594724, JString, required = false,
                                 default = nil)
  if valid_594724 != nil:
    section.add "userIp", valid_594724
  var valid_594725 = query.getOrDefault("key")
  valid_594725 = validateParameter(valid_594725, JString, required = false,
                                 default = nil)
  if valid_594725 != nil:
    section.add "key", valid_594725
  var valid_594726 = query.getOrDefault("prettyPrint")
  valid_594726 = validateParameter(valid_594726, JBool, required = false,
                                 default = newJBool(true))
  if valid_594726 != nil:
    section.add "prettyPrint", valid_594726
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594727: Call_DriveParentsDelete_594715; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a parent from a file.
  ## 
  let valid = call_594727.validator(path, query, header, formData, body)
  let scheme = call_594727.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594727.url(scheme.get, call_594727.host, call_594727.base,
                         call_594727.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594727, url, valid)

proc call*(call_594728: Call_DriveParentsDelete_594715; fileId: string;
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
  var path_594729 = newJObject()
  var query_594730 = newJObject()
  add(query_594730, "fields", newJString(fields))
  add(query_594730, "quotaUser", newJString(quotaUser))
  add(path_594729, "fileId", newJString(fileId))
  add(query_594730, "alt", newJString(alt))
  add(path_594729, "parentId", newJString(parentId))
  add(query_594730, "oauth_token", newJString(oauthToken))
  add(query_594730, "userIp", newJString(userIp))
  add(query_594730, "key", newJString(key))
  add(query_594730, "prettyPrint", newJBool(prettyPrint))
  result = call_594728.call(path_594729, query_594730, nil, nil, nil)

var driveParentsDelete* = Call_DriveParentsDelete_594715(
    name: "driveParentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/parents/{parentId}",
    validator: validate_DriveParentsDelete_594716, base: "/drive/v2",
    url: url_DriveParentsDelete_594717, schemes: {Scheme.Https})
type
  Call_DrivePermissionsInsert_594751 = ref object of OpenApiRestCall_593424
proc url_DrivePermissionsInsert_594753(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DrivePermissionsInsert_594752(path: JsonNode; query: JsonNode;
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
  var valid_594754 = path.getOrDefault("fileId")
  valid_594754 = validateParameter(valid_594754, JString, required = true,
                                 default = nil)
  if valid_594754 != nil:
    section.add "fileId", valid_594754
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
  var valid_594755 = query.getOrDefault("supportsAllDrives")
  valid_594755 = validateParameter(valid_594755, JBool, required = false,
                                 default = newJBool(false))
  if valid_594755 != nil:
    section.add "supportsAllDrives", valid_594755
  var valid_594756 = query.getOrDefault("fields")
  valid_594756 = validateParameter(valid_594756, JString, required = false,
                                 default = nil)
  if valid_594756 != nil:
    section.add "fields", valid_594756
  var valid_594757 = query.getOrDefault("quotaUser")
  valid_594757 = validateParameter(valid_594757, JString, required = false,
                                 default = nil)
  if valid_594757 != nil:
    section.add "quotaUser", valid_594757
  var valid_594758 = query.getOrDefault("alt")
  valid_594758 = validateParameter(valid_594758, JString, required = false,
                                 default = newJString("json"))
  if valid_594758 != nil:
    section.add "alt", valid_594758
  var valid_594759 = query.getOrDefault("oauth_token")
  valid_594759 = validateParameter(valid_594759, JString, required = false,
                                 default = nil)
  if valid_594759 != nil:
    section.add "oauth_token", valid_594759
  var valid_594760 = query.getOrDefault("sendNotificationEmails")
  valid_594760 = validateParameter(valid_594760, JBool, required = false,
                                 default = newJBool(true))
  if valid_594760 != nil:
    section.add "sendNotificationEmails", valid_594760
  var valid_594761 = query.getOrDefault("userIp")
  valid_594761 = validateParameter(valid_594761, JString, required = false,
                                 default = nil)
  if valid_594761 != nil:
    section.add "userIp", valid_594761
  var valid_594762 = query.getOrDefault("supportsTeamDrives")
  valid_594762 = validateParameter(valid_594762, JBool, required = false,
                                 default = newJBool(false))
  if valid_594762 != nil:
    section.add "supportsTeamDrives", valid_594762
  var valid_594763 = query.getOrDefault("key")
  valid_594763 = validateParameter(valid_594763, JString, required = false,
                                 default = nil)
  if valid_594763 != nil:
    section.add "key", valid_594763
  var valid_594764 = query.getOrDefault("useDomainAdminAccess")
  valid_594764 = validateParameter(valid_594764, JBool, required = false,
                                 default = newJBool(false))
  if valid_594764 != nil:
    section.add "useDomainAdminAccess", valid_594764
  var valid_594765 = query.getOrDefault("emailMessage")
  valid_594765 = validateParameter(valid_594765, JString, required = false,
                                 default = nil)
  if valid_594765 != nil:
    section.add "emailMessage", valid_594765
  var valid_594766 = query.getOrDefault("prettyPrint")
  valid_594766 = validateParameter(valid_594766, JBool, required = false,
                                 default = newJBool(true))
  if valid_594766 != nil:
    section.add "prettyPrint", valid_594766
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

proc call*(call_594768: Call_DrivePermissionsInsert_594751; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a permission for a file or shared drive.
  ## 
  let valid = call_594768.validator(path, query, header, formData, body)
  let scheme = call_594768.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594768.url(scheme.get, call_594768.host, call_594768.base,
                         call_594768.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594768, url, valid)

proc call*(call_594769: Call_DrivePermissionsInsert_594751; fileId: string;
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
  var path_594770 = newJObject()
  var query_594771 = newJObject()
  var body_594772 = newJObject()
  add(query_594771, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594771, "fields", newJString(fields))
  add(query_594771, "quotaUser", newJString(quotaUser))
  add(path_594770, "fileId", newJString(fileId))
  add(query_594771, "alt", newJString(alt))
  add(query_594771, "oauth_token", newJString(oauthToken))
  add(query_594771, "sendNotificationEmails", newJBool(sendNotificationEmails))
  add(query_594771, "userIp", newJString(userIp))
  add(query_594771, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594771, "key", newJString(key))
  add(query_594771, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_594771, "emailMessage", newJString(emailMessage))
  if body != nil:
    body_594772 = body
  add(query_594771, "prettyPrint", newJBool(prettyPrint))
  result = call_594769.call(path_594770, query_594771, nil, nil, body_594772)

var drivePermissionsInsert* = Call_DrivePermissionsInsert_594751(
    name: "drivePermissionsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/permissions",
    validator: validate_DrivePermissionsInsert_594752, base: "/drive/v2",
    url: url_DrivePermissionsInsert_594753, schemes: {Scheme.Https})
type
  Call_DrivePermissionsList_594731 = ref object of OpenApiRestCall_593424
proc url_DrivePermissionsList_594733(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DrivePermissionsList_594732(path: JsonNode; query: JsonNode;
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
  var valid_594734 = path.getOrDefault("fileId")
  valid_594734 = validateParameter(valid_594734, JString, required = true,
                                 default = nil)
  if valid_594734 != nil:
    section.add "fileId", valid_594734
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
  var valid_594735 = query.getOrDefault("supportsAllDrives")
  valid_594735 = validateParameter(valid_594735, JBool, required = false,
                                 default = newJBool(false))
  if valid_594735 != nil:
    section.add "supportsAllDrives", valid_594735
  var valid_594736 = query.getOrDefault("fields")
  valid_594736 = validateParameter(valid_594736, JString, required = false,
                                 default = nil)
  if valid_594736 != nil:
    section.add "fields", valid_594736
  var valid_594737 = query.getOrDefault("pageToken")
  valid_594737 = validateParameter(valid_594737, JString, required = false,
                                 default = nil)
  if valid_594737 != nil:
    section.add "pageToken", valid_594737
  var valid_594738 = query.getOrDefault("quotaUser")
  valid_594738 = validateParameter(valid_594738, JString, required = false,
                                 default = nil)
  if valid_594738 != nil:
    section.add "quotaUser", valid_594738
  var valid_594739 = query.getOrDefault("alt")
  valid_594739 = validateParameter(valid_594739, JString, required = false,
                                 default = newJString("json"))
  if valid_594739 != nil:
    section.add "alt", valid_594739
  var valid_594740 = query.getOrDefault("oauth_token")
  valid_594740 = validateParameter(valid_594740, JString, required = false,
                                 default = nil)
  if valid_594740 != nil:
    section.add "oauth_token", valid_594740
  var valid_594741 = query.getOrDefault("userIp")
  valid_594741 = validateParameter(valid_594741, JString, required = false,
                                 default = nil)
  if valid_594741 != nil:
    section.add "userIp", valid_594741
  var valid_594742 = query.getOrDefault("maxResults")
  valid_594742 = validateParameter(valid_594742, JInt, required = false, default = nil)
  if valid_594742 != nil:
    section.add "maxResults", valid_594742
  var valid_594743 = query.getOrDefault("supportsTeamDrives")
  valid_594743 = validateParameter(valid_594743, JBool, required = false,
                                 default = newJBool(false))
  if valid_594743 != nil:
    section.add "supportsTeamDrives", valid_594743
  var valid_594744 = query.getOrDefault("key")
  valid_594744 = validateParameter(valid_594744, JString, required = false,
                                 default = nil)
  if valid_594744 != nil:
    section.add "key", valid_594744
  var valid_594745 = query.getOrDefault("useDomainAdminAccess")
  valid_594745 = validateParameter(valid_594745, JBool, required = false,
                                 default = newJBool(false))
  if valid_594745 != nil:
    section.add "useDomainAdminAccess", valid_594745
  var valid_594746 = query.getOrDefault("prettyPrint")
  valid_594746 = validateParameter(valid_594746, JBool, required = false,
                                 default = newJBool(true))
  if valid_594746 != nil:
    section.add "prettyPrint", valid_594746
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594747: Call_DrivePermissionsList_594731; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's or shared drive's permissions.
  ## 
  let valid = call_594747.validator(path, query, header, formData, body)
  let scheme = call_594747.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594747.url(scheme.get, call_594747.host, call_594747.base,
                         call_594747.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594747, url, valid)

proc call*(call_594748: Call_DrivePermissionsList_594731; fileId: string;
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
  var path_594749 = newJObject()
  var query_594750 = newJObject()
  add(query_594750, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594750, "fields", newJString(fields))
  add(query_594750, "pageToken", newJString(pageToken))
  add(query_594750, "quotaUser", newJString(quotaUser))
  add(path_594749, "fileId", newJString(fileId))
  add(query_594750, "alt", newJString(alt))
  add(query_594750, "oauth_token", newJString(oauthToken))
  add(query_594750, "userIp", newJString(userIp))
  add(query_594750, "maxResults", newJInt(maxResults))
  add(query_594750, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594750, "key", newJString(key))
  add(query_594750, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_594750, "prettyPrint", newJBool(prettyPrint))
  result = call_594748.call(path_594749, query_594750, nil, nil, nil)

var drivePermissionsList* = Call_DrivePermissionsList_594731(
    name: "drivePermissionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/permissions",
    validator: validate_DrivePermissionsList_594732, base: "/drive/v2",
    url: url_DrivePermissionsList_594733, schemes: {Scheme.Https})
type
  Call_DrivePermissionsUpdate_594792 = ref object of OpenApiRestCall_593424
proc url_DrivePermissionsUpdate_594794(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DrivePermissionsUpdate_594793(path: JsonNode; query: JsonNode;
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
  var valid_594795 = path.getOrDefault("fileId")
  valid_594795 = validateParameter(valid_594795, JString, required = true,
                                 default = nil)
  if valid_594795 != nil:
    section.add "fileId", valid_594795
  var valid_594796 = path.getOrDefault("permissionId")
  valid_594796 = validateParameter(valid_594796, JString, required = true,
                                 default = nil)
  if valid_594796 != nil:
    section.add "permissionId", valid_594796
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
  var valid_594797 = query.getOrDefault("supportsAllDrives")
  valid_594797 = validateParameter(valid_594797, JBool, required = false,
                                 default = newJBool(false))
  if valid_594797 != nil:
    section.add "supportsAllDrives", valid_594797
  var valid_594798 = query.getOrDefault("fields")
  valid_594798 = validateParameter(valid_594798, JString, required = false,
                                 default = nil)
  if valid_594798 != nil:
    section.add "fields", valid_594798
  var valid_594799 = query.getOrDefault("quotaUser")
  valid_594799 = validateParameter(valid_594799, JString, required = false,
                                 default = nil)
  if valid_594799 != nil:
    section.add "quotaUser", valid_594799
  var valid_594800 = query.getOrDefault("alt")
  valid_594800 = validateParameter(valid_594800, JString, required = false,
                                 default = newJString("json"))
  if valid_594800 != nil:
    section.add "alt", valid_594800
  var valid_594801 = query.getOrDefault("oauth_token")
  valid_594801 = validateParameter(valid_594801, JString, required = false,
                                 default = nil)
  if valid_594801 != nil:
    section.add "oauth_token", valid_594801
  var valid_594802 = query.getOrDefault("removeExpiration")
  valid_594802 = validateParameter(valid_594802, JBool, required = false,
                                 default = newJBool(false))
  if valid_594802 != nil:
    section.add "removeExpiration", valid_594802
  var valid_594803 = query.getOrDefault("userIp")
  valid_594803 = validateParameter(valid_594803, JString, required = false,
                                 default = nil)
  if valid_594803 != nil:
    section.add "userIp", valid_594803
  var valid_594804 = query.getOrDefault("supportsTeamDrives")
  valid_594804 = validateParameter(valid_594804, JBool, required = false,
                                 default = newJBool(false))
  if valid_594804 != nil:
    section.add "supportsTeamDrives", valid_594804
  var valid_594805 = query.getOrDefault("key")
  valid_594805 = validateParameter(valid_594805, JString, required = false,
                                 default = nil)
  if valid_594805 != nil:
    section.add "key", valid_594805
  var valid_594806 = query.getOrDefault("useDomainAdminAccess")
  valid_594806 = validateParameter(valid_594806, JBool, required = false,
                                 default = newJBool(false))
  if valid_594806 != nil:
    section.add "useDomainAdminAccess", valid_594806
  var valid_594807 = query.getOrDefault("transferOwnership")
  valid_594807 = validateParameter(valid_594807, JBool, required = false,
                                 default = newJBool(false))
  if valid_594807 != nil:
    section.add "transferOwnership", valid_594807
  var valid_594808 = query.getOrDefault("prettyPrint")
  valid_594808 = validateParameter(valid_594808, JBool, required = false,
                                 default = newJBool(true))
  if valid_594808 != nil:
    section.add "prettyPrint", valid_594808
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

proc call*(call_594810: Call_DrivePermissionsUpdate_594792; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a permission.
  ## 
  let valid = call_594810.validator(path, query, header, formData, body)
  let scheme = call_594810.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594810.url(scheme.get, call_594810.host, call_594810.base,
                         call_594810.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594810, url, valid)

proc call*(call_594811: Call_DrivePermissionsUpdate_594792; fileId: string;
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
  var path_594812 = newJObject()
  var query_594813 = newJObject()
  var body_594814 = newJObject()
  add(query_594813, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594813, "fields", newJString(fields))
  add(query_594813, "quotaUser", newJString(quotaUser))
  add(path_594812, "fileId", newJString(fileId))
  add(query_594813, "alt", newJString(alt))
  add(query_594813, "oauth_token", newJString(oauthToken))
  add(path_594812, "permissionId", newJString(permissionId))
  add(query_594813, "removeExpiration", newJBool(removeExpiration))
  add(query_594813, "userIp", newJString(userIp))
  add(query_594813, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594813, "key", newJString(key))
  add(query_594813, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_594813, "transferOwnership", newJBool(transferOwnership))
  if body != nil:
    body_594814 = body
  add(query_594813, "prettyPrint", newJBool(prettyPrint))
  result = call_594811.call(path_594812, query_594813, nil, nil, body_594814)

var drivePermissionsUpdate* = Call_DrivePermissionsUpdate_594792(
    name: "drivePermissionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsUpdate_594793, base: "/drive/v2",
    url: url_DrivePermissionsUpdate_594794, schemes: {Scheme.Https})
type
  Call_DrivePermissionsGet_594773 = ref object of OpenApiRestCall_593424
proc url_DrivePermissionsGet_594775(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DrivePermissionsGet_594774(path: JsonNode; query: JsonNode;
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
  var valid_594776 = path.getOrDefault("fileId")
  valid_594776 = validateParameter(valid_594776, JString, required = true,
                                 default = nil)
  if valid_594776 != nil:
    section.add "fileId", valid_594776
  var valid_594777 = path.getOrDefault("permissionId")
  valid_594777 = validateParameter(valid_594777, JString, required = true,
                                 default = nil)
  if valid_594777 != nil:
    section.add "permissionId", valid_594777
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
  var valid_594778 = query.getOrDefault("supportsAllDrives")
  valid_594778 = validateParameter(valid_594778, JBool, required = false,
                                 default = newJBool(false))
  if valid_594778 != nil:
    section.add "supportsAllDrives", valid_594778
  var valid_594779 = query.getOrDefault("fields")
  valid_594779 = validateParameter(valid_594779, JString, required = false,
                                 default = nil)
  if valid_594779 != nil:
    section.add "fields", valid_594779
  var valid_594780 = query.getOrDefault("quotaUser")
  valid_594780 = validateParameter(valid_594780, JString, required = false,
                                 default = nil)
  if valid_594780 != nil:
    section.add "quotaUser", valid_594780
  var valid_594781 = query.getOrDefault("alt")
  valid_594781 = validateParameter(valid_594781, JString, required = false,
                                 default = newJString("json"))
  if valid_594781 != nil:
    section.add "alt", valid_594781
  var valid_594782 = query.getOrDefault("oauth_token")
  valid_594782 = validateParameter(valid_594782, JString, required = false,
                                 default = nil)
  if valid_594782 != nil:
    section.add "oauth_token", valid_594782
  var valid_594783 = query.getOrDefault("userIp")
  valid_594783 = validateParameter(valid_594783, JString, required = false,
                                 default = nil)
  if valid_594783 != nil:
    section.add "userIp", valid_594783
  var valid_594784 = query.getOrDefault("supportsTeamDrives")
  valid_594784 = validateParameter(valid_594784, JBool, required = false,
                                 default = newJBool(false))
  if valid_594784 != nil:
    section.add "supportsTeamDrives", valid_594784
  var valid_594785 = query.getOrDefault("key")
  valid_594785 = validateParameter(valid_594785, JString, required = false,
                                 default = nil)
  if valid_594785 != nil:
    section.add "key", valid_594785
  var valid_594786 = query.getOrDefault("useDomainAdminAccess")
  valid_594786 = validateParameter(valid_594786, JBool, required = false,
                                 default = newJBool(false))
  if valid_594786 != nil:
    section.add "useDomainAdminAccess", valid_594786
  var valid_594787 = query.getOrDefault("prettyPrint")
  valid_594787 = validateParameter(valid_594787, JBool, required = false,
                                 default = newJBool(true))
  if valid_594787 != nil:
    section.add "prettyPrint", valid_594787
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594788: Call_DrivePermissionsGet_594773; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a permission by ID.
  ## 
  let valid = call_594788.validator(path, query, header, formData, body)
  let scheme = call_594788.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594788.url(scheme.get, call_594788.host, call_594788.base,
                         call_594788.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594788, url, valid)

proc call*(call_594789: Call_DrivePermissionsGet_594773; fileId: string;
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
  var path_594790 = newJObject()
  var query_594791 = newJObject()
  add(query_594791, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594791, "fields", newJString(fields))
  add(query_594791, "quotaUser", newJString(quotaUser))
  add(path_594790, "fileId", newJString(fileId))
  add(query_594791, "alt", newJString(alt))
  add(query_594791, "oauth_token", newJString(oauthToken))
  add(path_594790, "permissionId", newJString(permissionId))
  add(query_594791, "userIp", newJString(userIp))
  add(query_594791, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594791, "key", newJString(key))
  add(query_594791, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_594791, "prettyPrint", newJBool(prettyPrint))
  result = call_594789.call(path_594790, query_594791, nil, nil, nil)

var drivePermissionsGet* = Call_DrivePermissionsGet_594773(
    name: "drivePermissionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsGet_594774, base: "/drive/v2",
    url: url_DrivePermissionsGet_594775, schemes: {Scheme.Https})
type
  Call_DrivePermissionsPatch_594834 = ref object of OpenApiRestCall_593424
proc url_DrivePermissionsPatch_594836(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DrivePermissionsPatch_594835(path: JsonNode; query: JsonNode;
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
  var valid_594837 = path.getOrDefault("fileId")
  valid_594837 = validateParameter(valid_594837, JString, required = true,
                                 default = nil)
  if valid_594837 != nil:
    section.add "fileId", valid_594837
  var valid_594838 = path.getOrDefault("permissionId")
  valid_594838 = validateParameter(valid_594838, JString, required = true,
                                 default = nil)
  if valid_594838 != nil:
    section.add "permissionId", valid_594838
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
  var valid_594839 = query.getOrDefault("supportsAllDrives")
  valid_594839 = validateParameter(valid_594839, JBool, required = false,
                                 default = newJBool(false))
  if valid_594839 != nil:
    section.add "supportsAllDrives", valid_594839
  var valid_594840 = query.getOrDefault("fields")
  valid_594840 = validateParameter(valid_594840, JString, required = false,
                                 default = nil)
  if valid_594840 != nil:
    section.add "fields", valid_594840
  var valid_594841 = query.getOrDefault("quotaUser")
  valid_594841 = validateParameter(valid_594841, JString, required = false,
                                 default = nil)
  if valid_594841 != nil:
    section.add "quotaUser", valid_594841
  var valid_594842 = query.getOrDefault("alt")
  valid_594842 = validateParameter(valid_594842, JString, required = false,
                                 default = newJString("json"))
  if valid_594842 != nil:
    section.add "alt", valid_594842
  var valid_594843 = query.getOrDefault("oauth_token")
  valid_594843 = validateParameter(valid_594843, JString, required = false,
                                 default = nil)
  if valid_594843 != nil:
    section.add "oauth_token", valid_594843
  var valid_594844 = query.getOrDefault("removeExpiration")
  valid_594844 = validateParameter(valid_594844, JBool, required = false,
                                 default = newJBool(false))
  if valid_594844 != nil:
    section.add "removeExpiration", valid_594844
  var valid_594845 = query.getOrDefault("userIp")
  valid_594845 = validateParameter(valid_594845, JString, required = false,
                                 default = nil)
  if valid_594845 != nil:
    section.add "userIp", valid_594845
  var valid_594846 = query.getOrDefault("supportsTeamDrives")
  valid_594846 = validateParameter(valid_594846, JBool, required = false,
                                 default = newJBool(false))
  if valid_594846 != nil:
    section.add "supportsTeamDrives", valid_594846
  var valid_594847 = query.getOrDefault("key")
  valid_594847 = validateParameter(valid_594847, JString, required = false,
                                 default = nil)
  if valid_594847 != nil:
    section.add "key", valid_594847
  var valid_594848 = query.getOrDefault("useDomainAdminAccess")
  valid_594848 = validateParameter(valid_594848, JBool, required = false,
                                 default = newJBool(false))
  if valid_594848 != nil:
    section.add "useDomainAdminAccess", valid_594848
  var valid_594849 = query.getOrDefault("transferOwnership")
  valid_594849 = validateParameter(valid_594849, JBool, required = false,
                                 default = newJBool(false))
  if valid_594849 != nil:
    section.add "transferOwnership", valid_594849
  var valid_594850 = query.getOrDefault("prettyPrint")
  valid_594850 = validateParameter(valid_594850, JBool, required = false,
                                 default = newJBool(true))
  if valid_594850 != nil:
    section.add "prettyPrint", valid_594850
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

proc call*(call_594852: Call_DrivePermissionsPatch_594834; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a permission using patch semantics.
  ## 
  let valid = call_594852.validator(path, query, header, formData, body)
  let scheme = call_594852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594852.url(scheme.get, call_594852.host, call_594852.base,
                         call_594852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594852, url, valid)

proc call*(call_594853: Call_DrivePermissionsPatch_594834; fileId: string;
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
  var path_594854 = newJObject()
  var query_594855 = newJObject()
  var body_594856 = newJObject()
  add(query_594855, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594855, "fields", newJString(fields))
  add(query_594855, "quotaUser", newJString(quotaUser))
  add(path_594854, "fileId", newJString(fileId))
  add(query_594855, "alt", newJString(alt))
  add(query_594855, "oauth_token", newJString(oauthToken))
  add(path_594854, "permissionId", newJString(permissionId))
  add(query_594855, "removeExpiration", newJBool(removeExpiration))
  add(query_594855, "userIp", newJString(userIp))
  add(query_594855, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594855, "key", newJString(key))
  add(query_594855, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_594855, "transferOwnership", newJBool(transferOwnership))
  if body != nil:
    body_594856 = body
  add(query_594855, "prettyPrint", newJBool(prettyPrint))
  result = call_594853.call(path_594854, query_594855, nil, nil, body_594856)

var drivePermissionsPatch* = Call_DrivePermissionsPatch_594834(
    name: "drivePermissionsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsPatch_594835, base: "/drive/v2",
    url: url_DrivePermissionsPatch_594836, schemes: {Scheme.Https})
type
  Call_DrivePermissionsDelete_594815 = ref object of OpenApiRestCall_593424
proc url_DrivePermissionsDelete_594817(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DrivePermissionsDelete_594816(path: JsonNode; query: JsonNode;
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
  var valid_594818 = path.getOrDefault("fileId")
  valid_594818 = validateParameter(valid_594818, JString, required = true,
                                 default = nil)
  if valid_594818 != nil:
    section.add "fileId", valid_594818
  var valid_594819 = path.getOrDefault("permissionId")
  valid_594819 = validateParameter(valid_594819, JString, required = true,
                                 default = nil)
  if valid_594819 != nil:
    section.add "permissionId", valid_594819
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
  var valid_594820 = query.getOrDefault("supportsAllDrives")
  valid_594820 = validateParameter(valid_594820, JBool, required = false,
                                 default = newJBool(false))
  if valid_594820 != nil:
    section.add "supportsAllDrives", valid_594820
  var valid_594821 = query.getOrDefault("fields")
  valid_594821 = validateParameter(valid_594821, JString, required = false,
                                 default = nil)
  if valid_594821 != nil:
    section.add "fields", valid_594821
  var valid_594822 = query.getOrDefault("quotaUser")
  valid_594822 = validateParameter(valid_594822, JString, required = false,
                                 default = nil)
  if valid_594822 != nil:
    section.add "quotaUser", valid_594822
  var valid_594823 = query.getOrDefault("alt")
  valid_594823 = validateParameter(valid_594823, JString, required = false,
                                 default = newJString("json"))
  if valid_594823 != nil:
    section.add "alt", valid_594823
  var valid_594824 = query.getOrDefault("oauth_token")
  valid_594824 = validateParameter(valid_594824, JString, required = false,
                                 default = nil)
  if valid_594824 != nil:
    section.add "oauth_token", valid_594824
  var valid_594825 = query.getOrDefault("userIp")
  valid_594825 = validateParameter(valid_594825, JString, required = false,
                                 default = nil)
  if valid_594825 != nil:
    section.add "userIp", valid_594825
  var valid_594826 = query.getOrDefault("supportsTeamDrives")
  valid_594826 = validateParameter(valid_594826, JBool, required = false,
                                 default = newJBool(false))
  if valid_594826 != nil:
    section.add "supportsTeamDrives", valid_594826
  var valid_594827 = query.getOrDefault("key")
  valid_594827 = validateParameter(valid_594827, JString, required = false,
                                 default = nil)
  if valid_594827 != nil:
    section.add "key", valid_594827
  var valid_594828 = query.getOrDefault("useDomainAdminAccess")
  valid_594828 = validateParameter(valid_594828, JBool, required = false,
                                 default = newJBool(false))
  if valid_594828 != nil:
    section.add "useDomainAdminAccess", valid_594828
  var valid_594829 = query.getOrDefault("prettyPrint")
  valid_594829 = validateParameter(valid_594829, JBool, required = false,
                                 default = newJBool(true))
  if valid_594829 != nil:
    section.add "prettyPrint", valid_594829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594830: Call_DrivePermissionsDelete_594815; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a permission from a file or shared drive.
  ## 
  let valid = call_594830.validator(path, query, header, formData, body)
  let scheme = call_594830.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594830.url(scheme.get, call_594830.host, call_594830.base,
                         call_594830.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594830, url, valid)

proc call*(call_594831: Call_DrivePermissionsDelete_594815; fileId: string;
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
  var path_594832 = newJObject()
  var query_594833 = newJObject()
  add(query_594833, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594833, "fields", newJString(fields))
  add(query_594833, "quotaUser", newJString(quotaUser))
  add(path_594832, "fileId", newJString(fileId))
  add(query_594833, "alt", newJString(alt))
  add(query_594833, "oauth_token", newJString(oauthToken))
  add(path_594832, "permissionId", newJString(permissionId))
  add(query_594833, "userIp", newJString(userIp))
  add(query_594833, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594833, "key", newJString(key))
  add(query_594833, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_594833, "prettyPrint", newJBool(prettyPrint))
  result = call_594831.call(path_594832, query_594833, nil, nil, nil)

var drivePermissionsDelete* = Call_DrivePermissionsDelete_594815(
    name: "drivePermissionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsDelete_594816, base: "/drive/v2",
    url: url_DrivePermissionsDelete_594817, schemes: {Scheme.Https})
type
  Call_DrivePropertiesInsert_594872 = ref object of OpenApiRestCall_593424
proc url_DrivePropertiesInsert_594874(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DrivePropertiesInsert_594873(path: JsonNode; query: JsonNode;
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
  var valid_594875 = path.getOrDefault("fileId")
  valid_594875 = validateParameter(valid_594875, JString, required = true,
                                 default = nil)
  if valid_594875 != nil:
    section.add "fileId", valid_594875
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
  var valid_594876 = query.getOrDefault("fields")
  valid_594876 = validateParameter(valid_594876, JString, required = false,
                                 default = nil)
  if valid_594876 != nil:
    section.add "fields", valid_594876
  var valid_594877 = query.getOrDefault("quotaUser")
  valid_594877 = validateParameter(valid_594877, JString, required = false,
                                 default = nil)
  if valid_594877 != nil:
    section.add "quotaUser", valid_594877
  var valid_594878 = query.getOrDefault("alt")
  valid_594878 = validateParameter(valid_594878, JString, required = false,
                                 default = newJString("json"))
  if valid_594878 != nil:
    section.add "alt", valid_594878
  var valid_594879 = query.getOrDefault("oauth_token")
  valid_594879 = validateParameter(valid_594879, JString, required = false,
                                 default = nil)
  if valid_594879 != nil:
    section.add "oauth_token", valid_594879
  var valid_594880 = query.getOrDefault("userIp")
  valid_594880 = validateParameter(valid_594880, JString, required = false,
                                 default = nil)
  if valid_594880 != nil:
    section.add "userIp", valid_594880
  var valid_594881 = query.getOrDefault("key")
  valid_594881 = validateParameter(valid_594881, JString, required = false,
                                 default = nil)
  if valid_594881 != nil:
    section.add "key", valid_594881
  var valid_594882 = query.getOrDefault("prettyPrint")
  valid_594882 = validateParameter(valid_594882, JBool, required = false,
                                 default = newJBool(true))
  if valid_594882 != nil:
    section.add "prettyPrint", valid_594882
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

proc call*(call_594884: Call_DrivePropertiesInsert_594872; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a property to a file, or updates it if it already exists.
  ## 
  let valid = call_594884.validator(path, query, header, formData, body)
  let scheme = call_594884.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594884.url(scheme.get, call_594884.host, call_594884.base,
                         call_594884.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594884, url, valid)

proc call*(call_594885: Call_DrivePropertiesInsert_594872; fileId: string;
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
  var path_594886 = newJObject()
  var query_594887 = newJObject()
  var body_594888 = newJObject()
  add(query_594887, "fields", newJString(fields))
  add(query_594887, "quotaUser", newJString(quotaUser))
  add(path_594886, "fileId", newJString(fileId))
  add(query_594887, "alt", newJString(alt))
  add(query_594887, "oauth_token", newJString(oauthToken))
  add(query_594887, "userIp", newJString(userIp))
  add(query_594887, "key", newJString(key))
  if body != nil:
    body_594888 = body
  add(query_594887, "prettyPrint", newJBool(prettyPrint))
  result = call_594885.call(path_594886, query_594887, nil, nil, body_594888)

var drivePropertiesInsert* = Call_DrivePropertiesInsert_594872(
    name: "drivePropertiesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/properties",
    validator: validate_DrivePropertiesInsert_594873, base: "/drive/v2",
    url: url_DrivePropertiesInsert_594874, schemes: {Scheme.Https})
type
  Call_DrivePropertiesList_594857 = ref object of OpenApiRestCall_593424
proc url_DrivePropertiesList_594859(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DrivePropertiesList_594858(path: JsonNode; query: JsonNode;
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
  var valid_594860 = path.getOrDefault("fileId")
  valid_594860 = validateParameter(valid_594860, JString, required = true,
                                 default = nil)
  if valid_594860 != nil:
    section.add "fileId", valid_594860
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
  var valid_594861 = query.getOrDefault("fields")
  valid_594861 = validateParameter(valid_594861, JString, required = false,
                                 default = nil)
  if valid_594861 != nil:
    section.add "fields", valid_594861
  var valid_594862 = query.getOrDefault("quotaUser")
  valid_594862 = validateParameter(valid_594862, JString, required = false,
                                 default = nil)
  if valid_594862 != nil:
    section.add "quotaUser", valid_594862
  var valid_594863 = query.getOrDefault("alt")
  valid_594863 = validateParameter(valid_594863, JString, required = false,
                                 default = newJString("json"))
  if valid_594863 != nil:
    section.add "alt", valid_594863
  var valid_594864 = query.getOrDefault("oauth_token")
  valid_594864 = validateParameter(valid_594864, JString, required = false,
                                 default = nil)
  if valid_594864 != nil:
    section.add "oauth_token", valid_594864
  var valid_594865 = query.getOrDefault("userIp")
  valid_594865 = validateParameter(valid_594865, JString, required = false,
                                 default = nil)
  if valid_594865 != nil:
    section.add "userIp", valid_594865
  var valid_594866 = query.getOrDefault("key")
  valid_594866 = validateParameter(valid_594866, JString, required = false,
                                 default = nil)
  if valid_594866 != nil:
    section.add "key", valid_594866
  var valid_594867 = query.getOrDefault("prettyPrint")
  valid_594867 = validateParameter(valid_594867, JBool, required = false,
                                 default = newJBool(true))
  if valid_594867 != nil:
    section.add "prettyPrint", valid_594867
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594868: Call_DrivePropertiesList_594857; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's properties.
  ## 
  let valid = call_594868.validator(path, query, header, formData, body)
  let scheme = call_594868.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594868.url(scheme.get, call_594868.host, call_594868.base,
                         call_594868.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594868, url, valid)

proc call*(call_594869: Call_DrivePropertiesList_594857; fileId: string;
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
  var path_594870 = newJObject()
  var query_594871 = newJObject()
  add(query_594871, "fields", newJString(fields))
  add(query_594871, "quotaUser", newJString(quotaUser))
  add(path_594870, "fileId", newJString(fileId))
  add(query_594871, "alt", newJString(alt))
  add(query_594871, "oauth_token", newJString(oauthToken))
  add(query_594871, "userIp", newJString(userIp))
  add(query_594871, "key", newJString(key))
  add(query_594871, "prettyPrint", newJBool(prettyPrint))
  result = call_594869.call(path_594870, query_594871, nil, nil, nil)

var drivePropertiesList* = Call_DrivePropertiesList_594857(
    name: "drivePropertiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/properties",
    validator: validate_DrivePropertiesList_594858, base: "/drive/v2",
    url: url_DrivePropertiesList_594859, schemes: {Scheme.Https})
type
  Call_DrivePropertiesUpdate_594906 = ref object of OpenApiRestCall_593424
proc url_DrivePropertiesUpdate_594908(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DrivePropertiesUpdate_594907(path: JsonNode; query: JsonNode;
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
  var valid_594909 = path.getOrDefault("fileId")
  valid_594909 = validateParameter(valid_594909, JString, required = true,
                                 default = nil)
  if valid_594909 != nil:
    section.add "fileId", valid_594909
  var valid_594910 = path.getOrDefault("propertyKey")
  valid_594910 = validateParameter(valid_594910, JString, required = true,
                                 default = nil)
  if valid_594910 != nil:
    section.add "propertyKey", valid_594910
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
  var valid_594911 = query.getOrDefault("fields")
  valid_594911 = validateParameter(valid_594911, JString, required = false,
                                 default = nil)
  if valid_594911 != nil:
    section.add "fields", valid_594911
  var valid_594912 = query.getOrDefault("quotaUser")
  valid_594912 = validateParameter(valid_594912, JString, required = false,
                                 default = nil)
  if valid_594912 != nil:
    section.add "quotaUser", valid_594912
  var valid_594913 = query.getOrDefault("alt")
  valid_594913 = validateParameter(valid_594913, JString, required = false,
                                 default = newJString("json"))
  if valid_594913 != nil:
    section.add "alt", valid_594913
  var valid_594914 = query.getOrDefault("oauth_token")
  valid_594914 = validateParameter(valid_594914, JString, required = false,
                                 default = nil)
  if valid_594914 != nil:
    section.add "oauth_token", valid_594914
  var valid_594915 = query.getOrDefault("userIp")
  valid_594915 = validateParameter(valid_594915, JString, required = false,
                                 default = nil)
  if valid_594915 != nil:
    section.add "userIp", valid_594915
  var valid_594916 = query.getOrDefault("key")
  valid_594916 = validateParameter(valid_594916, JString, required = false,
                                 default = nil)
  if valid_594916 != nil:
    section.add "key", valid_594916
  var valid_594917 = query.getOrDefault("prettyPrint")
  valid_594917 = validateParameter(valid_594917, JBool, required = false,
                                 default = newJBool(true))
  if valid_594917 != nil:
    section.add "prettyPrint", valid_594917
  var valid_594918 = query.getOrDefault("visibility")
  valid_594918 = validateParameter(valid_594918, JString, required = false,
                                 default = newJString("private"))
  if valid_594918 != nil:
    section.add "visibility", valid_594918
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

proc call*(call_594920: Call_DrivePropertiesUpdate_594906; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a property.
  ## 
  let valid = call_594920.validator(path, query, header, formData, body)
  let scheme = call_594920.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594920.url(scheme.get, call_594920.host, call_594920.base,
                         call_594920.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594920, url, valid)

proc call*(call_594921: Call_DrivePropertiesUpdate_594906; fileId: string;
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
  var path_594922 = newJObject()
  var query_594923 = newJObject()
  var body_594924 = newJObject()
  add(query_594923, "fields", newJString(fields))
  add(query_594923, "quotaUser", newJString(quotaUser))
  add(path_594922, "fileId", newJString(fileId))
  add(query_594923, "alt", newJString(alt))
  add(query_594923, "oauth_token", newJString(oauthToken))
  add(query_594923, "userIp", newJString(userIp))
  add(query_594923, "key", newJString(key))
  add(path_594922, "propertyKey", newJString(propertyKey))
  if body != nil:
    body_594924 = body
  add(query_594923, "prettyPrint", newJBool(prettyPrint))
  add(query_594923, "visibility", newJString(visibility))
  result = call_594921.call(path_594922, query_594923, nil, nil, body_594924)

var drivePropertiesUpdate* = Call_DrivePropertiesUpdate_594906(
    name: "drivePropertiesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/files/{fileId}/properties/{propertyKey}",
    validator: validate_DrivePropertiesUpdate_594907, base: "/drive/v2",
    url: url_DrivePropertiesUpdate_594908, schemes: {Scheme.Https})
type
  Call_DrivePropertiesGet_594889 = ref object of OpenApiRestCall_593424
proc url_DrivePropertiesGet_594891(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DrivePropertiesGet_594890(path: JsonNode; query: JsonNode;
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
  var valid_594892 = path.getOrDefault("fileId")
  valid_594892 = validateParameter(valid_594892, JString, required = true,
                                 default = nil)
  if valid_594892 != nil:
    section.add "fileId", valid_594892
  var valid_594893 = path.getOrDefault("propertyKey")
  valid_594893 = validateParameter(valid_594893, JString, required = true,
                                 default = nil)
  if valid_594893 != nil:
    section.add "propertyKey", valid_594893
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
  var valid_594894 = query.getOrDefault("fields")
  valid_594894 = validateParameter(valid_594894, JString, required = false,
                                 default = nil)
  if valid_594894 != nil:
    section.add "fields", valid_594894
  var valid_594895 = query.getOrDefault("quotaUser")
  valid_594895 = validateParameter(valid_594895, JString, required = false,
                                 default = nil)
  if valid_594895 != nil:
    section.add "quotaUser", valid_594895
  var valid_594896 = query.getOrDefault("alt")
  valid_594896 = validateParameter(valid_594896, JString, required = false,
                                 default = newJString("json"))
  if valid_594896 != nil:
    section.add "alt", valid_594896
  var valid_594897 = query.getOrDefault("oauth_token")
  valid_594897 = validateParameter(valid_594897, JString, required = false,
                                 default = nil)
  if valid_594897 != nil:
    section.add "oauth_token", valid_594897
  var valid_594898 = query.getOrDefault("userIp")
  valid_594898 = validateParameter(valid_594898, JString, required = false,
                                 default = nil)
  if valid_594898 != nil:
    section.add "userIp", valid_594898
  var valid_594899 = query.getOrDefault("key")
  valid_594899 = validateParameter(valid_594899, JString, required = false,
                                 default = nil)
  if valid_594899 != nil:
    section.add "key", valid_594899
  var valid_594900 = query.getOrDefault("prettyPrint")
  valid_594900 = validateParameter(valid_594900, JBool, required = false,
                                 default = newJBool(true))
  if valid_594900 != nil:
    section.add "prettyPrint", valid_594900
  var valid_594901 = query.getOrDefault("visibility")
  valid_594901 = validateParameter(valid_594901, JString, required = false,
                                 default = newJString("private"))
  if valid_594901 != nil:
    section.add "visibility", valid_594901
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594902: Call_DrivePropertiesGet_594889; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a property by its key.
  ## 
  let valid = call_594902.validator(path, query, header, formData, body)
  let scheme = call_594902.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594902.url(scheme.get, call_594902.host, call_594902.base,
                         call_594902.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594902, url, valid)

proc call*(call_594903: Call_DrivePropertiesGet_594889; fileId: string;
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
  var path_594904 = newJObject()
  var query_594905 = newJObject()
  add(query_594905, "fields", newJString(fields))
  add(query_594905, "quotaUser", newJString(quotaUser))
  add(path_594904, "fileId", newJString(fileId))
  add(query_594905, "alt", newJString(alt))
  add(query_594905, "oauth_token", newJString(oauthToken))
  add(query_594905, "userIp", newJString(userIp))
  add(query_594905, "key", newJString(key))
  add(path_594904, "propertyKey", newJString(propertyKey))
  add(query_594905, "prettyPrint", newJBool(prettyPrint))
  add(query_594905, "visibility", newJString(visibility))
  result = call_594903.call(path_594904, query_594905, nil, nil, nil)

var drivePropertiesGet* = Call_DrivePropertiesGet_594889(
    name: "drivePropertiesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/properties/{propertyKey}",
    validator: validate_DrivePropertiesGet_594890, base: "/drive/v2",
    url: url_DrivePropertiesGet_594891, schemes: {Scheme.Https})
type
  Call_DrivePropertiesPatch_594942 = ref object of OpenApiRestCall_593424
proc url_DrivePropertiesPatch_594944(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DrivePropertiesPatch_594943(path: JsonNode; query: JsonNode;
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
  var valid_594945 = path.getOrDefault("fileId")
  valid_594945 = validateParameter(valid_594945, JString, required = true,
                                 default = nil)
  if valid_594945 != nil:
    section.add "fileId", valid_594945
  var valid_594946 = path.getOrDefault("propertyKey")
  valid_594946 = validateParameter(valid_594946, JString, required = true,
                                 default = nil)
  if valid_594946 != nil:
    section.add "propertyKey", valid_594946
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
  var valid_594947 = query.getOrDefault("fields")
  valid_594947 = validateParameter(valid_594947, JString, required = false,
                                 default = nil)
  if valid_594947 != nil:
    section.add "fields", valid_594947
  var valid_594948 = query.getOrDefault("quotaUser")
  valid_594948 = validateParameter(valid_594948, JString, required = false,
                                 default = nil)
  if valid_594948 != nil:
    section.add "quotaUser", valid_594948
  var valid_594949 = query.getOrDefault("alt")
  valid_594949 = validateParameter(valid_594949, JString, required = false,
                                 default = newJString("json"))
  if valid_594949 != nil:
    section.add "alt", valid_594949
  var valid_594950 = query.getOrDefault("oauth_token")
  valid_594950 = validateParameter(valid_594950, JString, required = false,
                                 default = nil)
  if valid_594950 != nil:
    section.add "oauth_token", valid_594950
  var valid_594951 = query.getOrDefault("userIp")
  valid_594951 = validateParameter(valid_594951, JString, required = false,
                                 default = nil)
  if valid_594951 != nil:
    section.add "userIp", valid_594951
  var valid_594952 = query.getOrDefault("key")
  valid_594952 = validateParameter(valid_594952, JString, required = false,
                                 default = nil)
  if valid_594952 != nil:
    section.add "key", valid_594952
  var valid_594953 = query.getOrDefault("prettyPrint")
  valid_594953 = validateParameter(valid_594953, JBool, required = false,
                                 default = newJBool(true))
  if valid_594953 != nil:
    section.add "prettyPrint", valid_594953
  var valid_594954 = query.getOrDefault("visibility")
  valid_594954 = validateParameter(valid_594954, JString, required = false,
                                 default = newJString("private"))
  if valid_594954 != nil:
    section.add "visibility", valid_594954
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

proc call*(call_594956: Call_DrivePropertiesPatch_594942; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a property.
  ## 
  let valid = call_594956.validator(path, query, header, formData, body)
  let scheme = call_594956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594956.url(scheme.get, call_594956.host, call_594956.base,
                         call_594956.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594956, url, valid)

proc call*(call_594957: Call_DrivePropertiesPatch_594942; fileId: string;
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
  var path_594958 = newJObject()
  var query_594959 = newJObject()
  var body_594960 = newJObject()
  add(query_594959, "fields", newJString(fields))
  add(query_594959, "quotaUser", newJString(quotaUser))
  add(path_594958, "fileId", newJString(fileId))
  add(query_594959, "alt", newJString(alt))
  add(query_594959, "oauth_token", newJString(oauthToken))
  add(query_594959, "userIp", newJString(userIp))
  add(query_594959, "key", newJString(key))
  add(path_594958, "propertyKey", newJString(propertyKey))
  if body != nil:
    body_594960 = body
  add(query_594959, "prettyPrint", newJBool(prettyPrint))
  add(query_594959, "visibility", newJString(visibility))
  result = call_594957.call(path_594958, query_594959, nil, nil, body_594960)

var drivePropertiesPatch* = Call_DrivePropertiesPatch_594942(
    name: "drivePropertiesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/files/{fileId}/properties/{propertyKey}",
    validator: validate_DrivePropertiesPatch_594943, base: "/drive/v2",
    url: url_DrivePropertiesPatch_594944, schemes: {Scheme.Https})
type
  Call_DrivePropertiesDelete_594925 = ref object of OpenApiRestCall_593424
proc url_DrivePropertiesDelete_594927(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DrivePropertiesDelete_594926(path: JsonNode; query: JsonNode;
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
  var valid_594928 = path.getOrDefault("fileId")
  valid_594928 = validateParameter(valid_594928, JString, required = true,
                                 default = nil)
  if valid_594928 != nil:
    section.add "fileId", valid_594928
  var valid_594929 = path.getOrDefault("propertyKey")
  valid_594929 = validateParameter(valid_594929, JString, required = true,
                                 default = nil)
  if valid_594929 != nil:
    section.add "propertyKey", valid_594929
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
  var valid_594930 = query.getOrDefault("fields")
  valid_594930 = validateParameter(valid_594930, JString, required = false,
                                 default = nil)
  if valid_594930 != nil:
    section.add "fields", valid_594930
  var valid_594931 = query.getOrDefault("quotaUser")
  valid_594931 = validateParameter(valid_594931, JString, required = false,
                                 default = nil)
  if valid_594931 != nil:
    section.add "quotaUser", valid_594931
  var valid_594932 = query.getOrDefault("alt")
  valid_594932 = validateParameter(valid_594932, JString, required = false,
                                 default = newJString("json"))
  if valid_594932 != nil:
    section.add "alt", valid_594932
  var valid_594933 = query.getOrDefault("oauth_token")
  valid_594933 = validateParameter(valid_594933, JString, required = false,
                                 default = nil)
  if valid_594933 != nil:
    section.add "oauth_token", valid_594933
  var valid_594934 = query.getOrDefault("userIp")
  valid_594934 = validateParameter(valid_594934, JString, required = false,
                                 default = nil)
  if valid_594934 != nil:
    section.add "userIp", valid_594934
  var valid_594935 = query.getOrDefault("key")
  valid_594935 = validateParameter(valid_594935, JString, required = false,
                                 default = nil)
  if valid_594935 != nil:
    section.add "key", valid_594935
  var valid_594936 = query.getOrDefault("prettyPrint")
  valid_594936 = validateParameter(valid_594936, JBool, required = false,
                                 default = newJBool(true))
  if valid_594936 != nil:
    section.add "prettyPrint", valid_594936
  var valid_594937 = query.getOrDefault("visibility")
  valid_594937 = validateParameter(valid_594937, JString, required = false,
                                 default = newJString("private"))
  if valid_594937 != nil:
    section.add "visibility", valid_594937
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594938: Call_DrivePropertiesDelete_594925; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a property.
  ## 
  let valid = call_594938.validator(path, query, header, formData, body)
  let scheme = call_594938.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594938.url(scheme.get, call_594938.host, call_594938.base,
                         call_594938.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594938, url, valid)

proc call*(call_594939: Call_DrivePropertiesDelete_594925; fileId: string;
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
  var path_594940 = newJObject()
  var query_594941 = newJObject()
  add(query_594941, "fields", newJString(fields))
  add(query_594941, "quotaUser", newJString(quotaUser))
  add(path_594940, "fileId", newJString(fileId))
  add(query_594941, "alt", newJString(alt))
  add(query_594941, "oauth_token", newJString(oauthToken))
  add(query_594941, "userIp", newJString(userIp))
  add(query_594941, "key", newJString(key))
  add(path_594940, "propertyKey", newJString(propertyKey))
  add(query_594941, "prettyPrint", newJBool(prettyPrint))
  add(query_594941, "visibility", newJString(visibility))
  result = call_594939.call(path_594940, query_594941, nil, nil, nil)

var drivePropertiesDelete* = Call_DrivePropertiesDelete_594925(
    name: "drivePropertiesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/properties/{propertyKey}",
    validator: validate_DrivePropertiesDelete_594926, base: "/drive/v2",
    url: url_DrivePropertiesDelete_594927, schemes: {Scheme.Https})
type
  Call_DriveRealtimeUpdate_594977 = ref object of OpenApiRestCall_593424
proc url_DriveRealtimeUpdate_594979(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveRealtimeUpdate_594978(path: JsonNode; query: JsonNode;
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
  var valid_594980 = path.getOrDefault("fileId")
  valid_594980 = validateParameter(valid_594980, JString, required = true,
                                 default = nil)
  if valid_594980 != nil:
    section.add "fileId", valid_594980
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
  var valid_594981 = query.getOrDefault("fields")
  valid_594981 = validateParameter(valid_594981, JString, required = false,
                                 default = nil)
  if valid_594981 != nil:
    section.add "fields", valid_594981
  var valid_594982 = query.getOrDefault("quotaUser")
  valid_594982 = validateParameter(valid_594982, JString, required = false,
                                 default = nil)
  if valid_594982 != nil:
    section.add "quotaUser", valid_594982
  var valid_594983 = query.getOrDefault("alt")
  valid_594983 = validateParameter(valid_594983, JString, required = false,
                                 default = newJString("json"))
  if valid_594983 != nil:
    section.add "alt", valid_594983
  var valid_594984 = query.getOrDefault("oauth_token")
  valid_594984 = validateParameter(valid_594984, JString, required = false,
                                 default = nil)
  if valid_594984 != nil:
    section.add "oauth_token", valid_594984
  var valid_594985 = query.getOrDefault("baseRevision")
  valid_594985 = validateParameter(valid_594985, JString, required = false,
                                 default = nil)
  if valid_594985 != nil:
    section.add "baseRevision", valid_594985
  var valid_594986 = query.getOrDefault("userIp")
  valid_594986 = validateParameter(valid_594986, JString, required = false,
                                 default = nil)
  if valid_594986 != nil:
    section.add "userIp", valid_594986
  var valid_594987 = query.getOrDefault("key")
  valid_594987 = validateParameter(valid_594987, JString, required = false,
                                 default = nil)
  if valid_594987 != nil:
    section.add "key", valid_594987
  var valid_594988 = query.getOrDefault("prettyPrint")
  valid_594988 = validateParameter(valid_594988, JBool, required = false,
                                 default = newJBool(true))
  if valid_594988 != nil:
    section.add "prettyPrint", valid_594988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594989: Call_DriveRealtimeUpdate_594977; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Overwrites the Realtime API data model associated with this file with the provided JSON data model.
  ## 
  let valid = call_594989.validator(path, query, header, formData, body)
  let scheme = call_594989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594989.url(scheme.get, call_594989.host, call_594989.base,
                         call_594989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594989, url, valid)

proc call*(call_594990: Call_DriveRealtimeUpdate_594977; fileId: string;
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
  var path_594991 = newJObject()
  var query_594992 = newJObject()
  add(query_594992, "fields", newJString(fields))
  add(query_594992, "quotaUser", newJString(quotaUser))
  add(path_594991, "fileId", newJString(fileId))
  add(query_594992, "alt", newJString(alt))
  add(query_594992, "oauth_token", newJString(oauthToken))
  add(query_594992, "baseRevision", newJString(baseRevision))
  add(query_594992, "userIp", newJString(userIp))
  add(query_594992, "key", newJString(key))
  add(query_594992, "prettyPrint", newJBool(prettyPrint))
  result = call_594990.call(path_594991, query_594992, nil, nil, nil)

var driveRealtimeUpdate* = Call_DriveRealtimeUpdate_594977(
    name: "driveRealtimeUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/files/{fileId}/realtime",
    validator: validate_DriveRealtimeUpdate_594978, base: "/drive/v2",
    url: url_DriveRealtimeUpdate_594979, schemes: {Scheme.Https})
type
  Call_DriveRealtimeGet_594961 = ref object of OpenApiRestCall_593424
proc url_DriveRealtimeGet_594963(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveRealtimeGet_594962(path: JsonNode; query: JsonNode;
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
  var valid_594964 = path.getOrDefault("fileId")
  valid_594964 = validateParameter(valid_594964, JString, required = true,
                                 default = nil)
  if valid_594964 != nil:
    section.add "fileId", valid_594964
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
  var valid_594965 = query.getOrDefault("fields")
  valid_594965 = validateParameter(valid_594965, JString, required = false,
                                 default = nil)
  if valid_594965 != nil:
    section.add "fields", valid_594965
  var valid_594966 = query.getOrDefault("quotaUser")
  valid_594966 = validateParameter(valid_594966, JString, required = false,
                                 default = nil)
  if valid_594966 != nil:
    section.add "quotaUser", valid_594966
  var valid_594967 = query.getOrDefault("alt")
  valid_594967 = validateParameter(valid_594967, JString, required = false,
                                 default = newJString("json"))
  if valid_594967 != nil:
    section.add "alt", valid_594967
  var valid_594968 = query.getOrDefault("oauth_token")
  valid_594968 = validateParameter(valid_594968, JString, required = false,
                                 default = nil)
  if valid_594968 != nil:
    section.add "oauth_token", valid_594968
  var valid_594969 = query.getOrDefault("userIp")
  valid_594969 = validateParameter(valid_594969, JString, required = false,
                                 default = nil)
  if valid_594969 != nil:
    section.add "userIp", valid_594969
  var valid_594970 = query.getOrDefault("revision")
  valid_594970 = validateParameter(valid_594970, JInt, required = false, default = nil)
  if valid_594970 != nil:
    section.add "revision", valid_594970
  var valid_594971 = query.getOrDefault("key")
  valid_594971 = validateParameter(valid_594971, JString, required = false,
                                 default = nil)
  if valid_594971 != nil:
    section.add "key", valid_594971
  var valid_594972 = query.getOrDefault("prettyPrint")
  valid_594972 = validateParameter(valid_594972, JBool, required = false,
                                 default = newJBool(true))
  if valid_594972 != nil:
    section.add "prettyPrint", valid_594972
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594973: Call_DriveRealtimeGet_594961; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports the contents of the Realtime API data model associated with this file as JSON.
  ## 
  let valid = call_594973.validator(path, query, header, formData, body)
  let scheme = call_594973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594973.url(scheme.get, call_594973.host, call_594973.base,
                         call_594973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594973, url, valid)

proc call*(call_594974: Call_DriveRealtimeGet_594961; fileId: string;
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
  var path_594975 = newJObject()
  var query_594976 = newJObject()
  add(query_594976, "fields", newJString(fields))
  add(query_594976, "quotaUser", newJString(quotaUser))
  add(path_594975, "fileId", newJString(fileId))
  add(query_594976, "alt", newJString(alt))
  add(query_594976, "oauth_token", newJString(oauthToken))
  add(query_594976, "userIp", newJString(userIp))
  add(query_594976, "revision", newJInt(revision))
  add(query_594976, "key", newJString(key))
  add(query_594976, "prettyPrint", newJBool(prettyPrint))
  result = call_594974.call(path_594975, query_594976, nil, nil, nil)

var driveRealtimeGet* = Call_DriveRealtimeGet_594961(name: "driveRealtimeGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/realtime", validator: validate_DriveRealtimeGet_594962,
    base: "/drive/v2", url: url_DriveRealtimeGet_594963, schemes: {Scheme.Https})
type
  Call_DriveRevisionsList_594993 = ref object of OpenApiRestCall_593424
proc url_DriveRevisionsList_594995(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveRevisionsList_594994(path: JsonNode; query: JsonNode;
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
  var valid_594996 = path.getOrDefault("fileId")
  valid_594996 = validateParameter(valid_594996, JString, required = true,
                                 default = nil)
  if valid_594996 != nil:
    section.add "fileId", valid_594996
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
  var valid_594997 = query.getOrDefault("fields")
  valid_594997 = validateParameter(valid_594997, JString, required = false,
                                 default = nil)
  if valid_594997 != nil:
    section.add "fields", valid_594997
  var valid_594998 = query.getOrDefault("pageToken")
  valid_594998 = validateParameter(valid_594998, JString, required = false,
                                 default = nil)
  if valid_594998 != nil:
    section.add "pageToken", valid_594998
  var valid_594999 = query.getOrDefault("quotaUser")
  valid_594999 = validateParameter(valid_594999, JString, required = false,
                                 default = nil)
  if valid_594999 != nil:
    section.add "quotaUser", valid_594999
  var valid_595000 = query.getOrDefault("alt")
  valid_595000 = validateParameter(valid_595000, JString, required = false,
                                 default = newJString("json"))
  if valid_595000 != nil:
    section.add "alt", valid_595000
  var valid_595001 = query.getOrDefault("oauth_token")
  valid_595001 = validateParameter(valid_595001, JString, required = false,
                                 default = nil)
  if valid_595001 != nil:
    section.add "oauth_token", valid_595001
  var valid_595002 = query.getOrDefault("userIp")
  valid_595002 = validateParameter(valid_595002, JString, required = false,
                                 default = nil)
  if valid_595002 != nil:
    section.add "userIp", valid_595002
  var valid_595003 = query.getOrDefault("maxResults")
  valid_595003 = validateParameter(valid_595003, JInt, required = false,
                                 default = newJInt(200))
  if valid_595003 != nil:
    section.add "maxResults", valid_595003
  var valid_595004 = query.getOrDefault("key")
  valid_595004 = validateParameter(valid_595004, JString, required = false,
                                 default = nil)
  if valid_595004 != nil:
    section.add "key", valid_595004
  var valid_595005 = query.getOrDefault("prettyPrint")
  valid_595005 = validateParameter(valid_595005, JBool, required = false,
                                 default = newJBool(true))
  if valid_595005 != nil:
    section.add "prettyPrint", valid_595005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595006: Call_DriveRevisionsList_594993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's revisions.
  ## 
  let valid = call_595006.validator(path, query, header, formData, body)
  let scheme = call_595006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595006.url(scheme.get, call_595006.host, call_595006.base,
                         call_595006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595006, url, valid)

proc call*(call_595007: Call_DriveRevisionsList_594993; fileId: string;
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
  var path_595008 = newJObject()
  var query_595009 = newJObject()
  add(query_595009, "fields", newJString(fields))
  add(query_595009, "pageToken", newJString(pageToken))
  add(query_595009, "quotaUser", newJString(quotaUser))
  add(path_595008, "fileId", newJString(fileId))
  add(query_595009, "alt", newJString(alt))
  add(query_595009, "oauth_token", newJString(oauthToken))
  add(query_595009, "userIp", newJString(userIp))
  add(query_595009, "maxResults", newJInt(maxResults))
  add(query_595009, "key", newJString(key))
  add(query_595009, "prettyPrint", newJBool(prettyPrint))
  result = call_595007.call(path_595008, query_595009, nil, nil, nil)

var driveRevisionsList* = Call_DriveRevisionsList_594993(
    name: "driveRevisionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions",
    validator: validate_DriveRevisionsList_594994, base: "/drive/v2",
    url: url_DriveRevisionsList_594995, schemes: {Scheme.Https})
type
  Call_DriveRevisionsUpdate_595026 = ref object of OpenApiRestCall_593424
proc url_DriveRevisionsUpdate_595028(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveRevisionsUpdate_595027(path: JsonNode; query: JsonNode;
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
  var valid_595029 = path.getOrDefault("fileId")
  valid_595029 = validateParameter(valid_595029, JString, required = true,
                                 default = nil)
  if valid_595029 != nil:
    section.add "fileId", valid_595029
  var valid_595030 = path.getOrDefault("revisionId")
  valid_595030 = validateParameter(valid_595030, JString, required = true,
                                 default = nil)
  if valid_595030 != nil:
    section.add "revisionId", valid_595030
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
  var valid_595031 = query.getOrDefault("fields")
  valid_595031 = validateParameter(valid_595031, JString, required = false,
                                 default = nil)
  if valid_595031 != nil:
    section.add "fields", valid_595031
  var valid_595032 = query.getOrDefault("quotaUser")
  valid_595032 = validateParameter(valid_595032, JString, required = false,
                                 default = nil)
  if valid_595032 != nil:
    section.add "quotaUser", valid_595032
  var valid_595033 = query.getOrDefault("alt")
  valid_595033 = validateParameter(valid_595033, JString, required = false,
                                 default = newJString("json"))
  if valid_595033 != nil:
    section.add "alt", valid_595033
  var valid_595034 = query.getOrDefault("oauth_token")
  valid_595034 = validateParameter(valid_595034, JString, required = false,
                                 default = nil)
  if valid_595034 != nil:
    section.add "oauth_token", valid_595034
  var valid_595035 = query.getOrDefault("userIp")
  valid_595035 = validateParameter(valid_595035, JString, required = false,
                                 default = nil)
  if valid_595035 != nil:
    section.add "userIp", valid_595035
  var valid_595036 = query.getOrDefault("key")
  valid_595036 = validateParameter(valid_595036, JString, required = false,
                                 default = nil)
  if valid_595036 != nil:
    section.add "key", valid_595036
  var valid_595037 = query.getOrDefault("prettyPrint")
  valid_595037 = validateParameter(valid_595037, JBool, required = false,
                                 default = newJBool(true))
  if valid_595037 != nil:
    section.add "prettyPrint", valid_595037
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

proc call*(call_595039: Call_DriveRevisionsUpdate_595026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a revision.
  ## 
  let valid = call_595039.validator(path, query, header, formData, body)
  let scheme = call_595039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595039.url(scheme.get, call_595039.host, call_595039.base,
                         call_595039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595039, url, valid)

proc call*(call_595040: Call_DriveRevisionsUpdate_595026; fileId: string;
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
  var path_595041 = newJObject()
  var query_595042 = newJObject()
  var body_595043 = newJObject()
  add(query_595042, "fields", newJString(fields))
  add(query_595042, "quotaUser", newJString(quotaUser))
  add(path_595041, "fileId", newJString(fileId))
  add(query_595042, "alt", newJString(alt))
  add(query_595042, "oauth_token", newJString(oauthToken))
  add(path_595041, "revisionId", newJString(revisionId))
  add(query_595042, "userIp", newJString(userIp))
  add(query_595042, "key", newJString(key))
  if body != nil:
    body_595043 = body
  add(query_595042, "prettyPrint", newJBool(prettyPrint))
  result = call_595040.call(path_595041, query_595042, nil, nil, body_595043)

var driveRevisionsUpdate* = Call_DriveRevisionsUpdate_595026(
    name: "driveRevisionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsUpdate_595027, base: "/drive/v2",
    url: url_DriveRevisionsUpdate_595028, schemes: {Scheme.Https})
type
  Call_DriveRevisionsGet_595010 = ref object of OpenApiRestCall_593424
proc url_DriveRevisionsGet_595012(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveRevisionsGet_595011(path: JsonNode; query: JsonNode;
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
  var valid_595013 = path.getOrDefault("fileId")
  valid_595013 = validateParameter(valid_595013, JString, required = true,
                                 default = nil)
  if valid_595013 != nil:
    section.add "fileId", valid_595013
  var valid_595014 = path.getOrDefault("revisionId")
  valid_595014 = validateParameter(valid_595014, JString, required = true,
                                 default = nil)
  if valid_595014 != nil:
    section.add "revisionId", valid_595014
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
  var valid_595015 = query.getOrDefault("fields")
  valid_595015 = validateParameter(valid_595015, JString, required = false,
                                 default = nil)
  if valid_595015 != nil:
    section.add "fields", valid_595015
  var valid_595016 = query.getOrDefault("quotaUser")
  valid_595016 = validateParameter(valid_595016, JString, required = false,
                                 default = nil)
  if valid_595016 != nil:
    section.add "quotaUser", valid_595016
  var valid_595017 = query.getOrDefault("alt")
  valid_595017 = validateParameter(valid_595017, JString, required = false,
                                 default = newJString("json"))
  if valid_595017 != nil:
    section.add "alt", valid_595017
  var valid_595018 = query.getOrDefault("oauth_token")
  valid_595018 = validateParameter(valid_595018, JString, required = false,
                                 default = nil)
  if valid_595018 != nil:
    section.add "oauth_token", valid_595018
  var valid_595019 = query.getOrDefault("userIp")
  valid_595019 = validateParameter(valid_595019, JString, required = false,
                                 default = nil)
  if valid_595019 != nil:
    section.add "userIp", valid_595019
  var valid_595020 = query.getOrDefault("key")
  valid_595020 = validateParameter(valid_595020, JString, required = false,
                                 default = nil)
  if valid_595020 != nil:
    section.add "key", valid_595020
  var valid_595021 = query.getOrDefault("prettyPrint")
  valid_595021 = validateParameter(valid_595021, JBool, required = false,
                                 default = newJBool(true))
  if valid_595021 != nil:
    section.add "prettyPrint", valid_595021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595022: Call_DriveRevisionsGet_595010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific revision.
  ## 
  let valid = call_595022.validator(path, query, header, formData, body)
  let scheme = call_595022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595022.url(scheme.get, call_595022.host, call_595022.base,
                         call_595022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595022, url, valid)

proc call*(call_595023: Call_DriveRevisionsGet_595010; fileId: string;
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
  var path_595024 = newJObject()
  var query_595025 = newJObject()
  add(query_595025, "fields", newJString(fields))
  add(query_595025, "quotaUser", newJString(quotaUser))
  add(path_595024, "fileId", newJString(fileId))
  add(query_595025, "alt", newJString(alt))
  add(query_595025, "oauth_token", newJString(oauthToken))
  add(path_595024, "revisionId", newJString(revisionId))
  add(query_595025, "userIp", newJString(userIp))
  add(query_595025, "key", newJString(key))
  add(query_595025, "prettyPrint", newJBool(prettyPrint))
  result = call_595023.call(path_595024, query_595025, nil, nil, nil)

var driveRevisionsGet* = Call_DriveRevisionsGet_595010(name: "driveRevisionsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsGet_595011, base: "/drive/v2",
    url: url_DriveRevisionsGet_595012, schemes: {Scheme.Https})
type
  Call_DriveRevisionsPatch_595060 = ref object of OpenApiRestCall_593424
proc url_DriveRevisionsPatch_595062(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveRevisionsPatch_595061(path: JsonNode; query: JsonNode;
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
  var valid_595063 = path.getOrDefault("fileId")
  valid_595063 = validateParameter(valid_595063, JString, required = true,
                                 default = nil)
  if valid_595063 != nil:
    section.add "fileId", valid_595063
  var valid_595064 = path.getOrDefault("revisionId")
  valid_595064 = validateParameter(valid_595064, JString, required = true,
                                 default = nil)
  if valid_595064 != nil:
    section.add "revisionId", valid_595064
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
  var valid_595065 = query.getOrDefault("fields")
  valid_595065 = validateParameter(valid_595065, JString, required = false,
                                 default = nil)
  if valid_595065 != nil:
    section.add "fields", valid_595065
  var valid_595066 = query.getOrDefault("quotaUser")
  valid_595066 = validateParameter(valid_595066, JString, required = false,
                                 default = nil)
  if valid_595066 != nil:
    section.add "quotaUser", valid_595066
  var valid_595067 = query.getOrDefault("alt")
  valid_595067 = validateParameter(valid_595067, JString, required = false,
                                 default = newJString("json"))
  if valid_595067 != nil:
    section.add "alt", valid_595067
  var valid_595068 = query.getOrDefault("oauth_token")
  valid_595068 = validateParameter(valid_595068, JString, required = false,
                                 default = nil)
  if valid_595068 != nil:
    section.add "oauth_token", valid_595068
  var valid_595069 = query.getOrDefault("userIp")
  valid_595069 = validateParameter(valid_595069, JString, required = false,
                                 default = nil)
  if valid_595069 != nil:
    section.add "userIp", valid_595069
  var valid_595070 = query.getOrDefault("key")
  valid_595070 = validateParameter(valid_595070, JString, required = false,
                                 default = nil)
  if valid_595070 != nil:
    section.add "key", valid_595070
  var valid_595071 = query.getOrDefault("prettyPrint")
  valid_595071 = validateParameter(valid_595071, JBool, required = false,
                                 default = newJBool(true))
  if valid_595071 != nil:
    section.add "prettyPrint", valid_595071
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

proc call*(call_595073: Call_DriveRevisionsPatch_595060; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a revision. This method supports patch semantics.
  ## 
  let valid = call_595073.validator(path, query, header, formData, body)
  let scheme = call_595073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595073.url(scheme.get, call_595073.host, call_595073.base,
                         call_595073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595073, url, valid)

proc call*(call_595074: Call_DriveRevisionsPatch_595060; fileId: string;
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
  var path_595075 = newJObject()
  var query_595076 = newJObject()
  var body_595077 = newJObject()
  add(query_595076, "fields", newJString(fields))
  add(query_595076, "quotaUser", newJString(quotaUser))
  add(path_595075, "fileId", newJString(fileId))
  add(query_595076, "alt", newJString(alt))
  add(query_595076, "oauth_token", newJString(oauthToken))
  add(path_595075, "revisionId", newJString(revisionId))
  add(query_595076, "userIp", newJString(userIp))
  add(query_595076, "key", newJString(key))
  if body != nil:
    body_595077 = body
  add(query_595076, "prettyPrint", newJBool(prettyPrint))
  result = call_595074.call(path_595075, query_595076, nil, nil, body_595077)

var driveRevisionsPatch* = Call_DriveRevisionsPatch_595060(
    name: "driveRevisionsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsPatch_595061, base: "/drive/v2",
    url: url_DriveRevisionsPatch_595062, schemes: {Scheme.Https})
type
  Call_DriveRevisionsDelete_595044 = ref object of OpenApiRestCall_593424
proc url_DriveRevisionsDelete_595046(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveRevisionsDelete_595045(path: JsonNode; query: JsonNode;
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
  var valid_595047 = path.getOrDefault("fileId")
  valid_595047 = validateParameter(valid_595047, JString, required = true,
                                 default = nil)
  if valid_595047 != nil:
    section.add "fileId", valid_595047
  var valid_595048 = path.getOrDefault("revisionId")
  valid_595048 = validateParameter(valid_595048, JString, required = true,
                                 default = nil)
  if valid_595048 != nil:
    section.add "revisionId", valid_595048
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
  var valid_595049 = query.getOrDefault("fields")
  valid_595049 = validateParameter(valid_595049, JString, required = false,
                                 default = nil)
  if valid_595049 != nil:
    section.add "fields", valid_595049
  var valid_595050 = query.getOrDefault("quotaUser")
  valid_595050 = validateParameter(valid_595050, JString, required = false,
                                 default = nil)
  if valid_595050 != nil:
    section.add "quotaUser", valid_595050
  var valid_595051 = query.getOrDefault("alt")
  valid_595051 = validateParameter(valid_595051, JString, required = false,
                                 default = newJString("json"))
  if valid_595051 != nil:
    section.add "alt", valid_595051
  var valid_595052 = query.getOrDefault("oauth_token")
  valid_595052 = validateParameter(valid_595052, JString, required = false,
                                 default = nil)
  if valid_595052 != nil:
    section.add "oauth_token", valid_595052
  var valid_595053 = query.getOrDefault("userIp")
  valid_595053 = validateParameter(valid_595053, JString, required = false,
                                 default = nil)
  if valid_595053 != nil:
    section.add "userIp", valid_595053
  var valid_595054 = query.getOrDefault("key")
  valid_595054 = validateParameter(valid_595054, JString, required = false,
                                 default = nil)
  if valid_595054 != nil:
    section.add "key", valid_595054
  var valid_595055 = query.getOrDefault("prettyPrint")
  valid_595055 = validateParameter(valid_595055, JBool, required = false,
                                 default = newJBool(true))
  if valid_595055 != nil:
    section.add "prettyPrint", valid_595055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595056: Call_DriveRevisionsDelete_595044; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a file version. You can only delete revisions for files with binary content, like images or videos. Revisions for other files, like Google Docs or Sheets, and the last remaining file version can't be deleted.
  ## 
  let valid = call_595056.validator(path, query, header, formData, body)
  let scheme = call_595056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595056.url(scheme.get, call_595056.host, call_595056.base,
                         call_595056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595056, url, valid)

proc call*(call_595057: Call_DriveRevisionsDelete_595044; fileId: string;
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
  var path_595058 = newJObject()
  var query_595059 = newJObject()
  add(query_595059, "fields", newJString(fields))
  add(query_595059, "quotaUser", newJString(quotaUser))
  add(path_595058, "fileId", newJString(fileId))
  add(query_595059, "alt", newJString(alt))
  add(query_595059, "oauth_token", newJString(oauthToken))
  add(path_595058, "revisionId", newJString(revisionId))
  add(query_595059, "userIp", newJString(userIp))
  add(query_595059, "key", newJString(key))
  add(query_595059, "prettyPrint", newJBool(prettyPrint))
  result = call_595057.call(path_595058, query_595059, nil, nil, nil)

var driveRevisionsDelete* = Call_DriveRevisionsDelete_595044(
    name: "driveRevisionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsDelete_595045, base: "/drive/v2",
    url: url_DriveRevisionsDelete_595046, schemes: {Scheme.Https})
type
  Call_DriveFilesTouch_595078 = ref object of OpenApiRestCall_593424
proc url_DriveFilesTouch_595080(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveFilesTouch_595079(path: JsonNode; query: JsonNode;
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
  var valid_595081 = path.getOrDefault("fileId")
  valid_595081 = validateParameter(valid_595081, JString, required = true,
                                 default = nil)
  if valid_595081 != nil:
    section.add "fileId", valid_595081
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
  var valid_595082 = query.getOrDefault("supportsAllDrives")
  valid_595082 = validateParameter(valid_595082, JBool, required = false,
                                 default = newJBool(false))
  if valid_595082 != nil:
    section.add "supportsAllDrives", valid_595082
  var valid_595083 = query.getOrDefault("fields")
  valid_595083 = validateParameter(valid_595083, JString, required = false,
                                 default = nil)
  if valid_595083 != nil:
    section.add "fields", valid_595083
  var valid_595084 = query.getOrDefault("quotaUser")
  valid_595084 = validateParameter(valid_595084, JString, required = false,
                                 default = nil)
  if valid_595084 != nil:
    section.add "quotaUser", valid_595084
  var valid_595085 = query.getOrDefault("alt")
  valid_595085 = validateParameter(valid_595085, JString, required = false,
                                 default = newJString("json"))
  if valid_595085 != nil:
    section.add "alt", valid_595085
  var valid_595086 = query.getOrDefault("oauth_token")
  valid_595086 = validateParameter(valid_595086, JString, required = false,
                                 default = nil)
  if valid_595086 != nil:
    section.add "oauth_token", valid_595086
  var valid_595087 = query.getOrDefault("userIp")
  valid_595087 = validateParameter(valid_595087, JString, required = false,
                                 default = nil)
  if valid_595087 != nil:
    section.add "userIp", valid_595087
  var valid_595088 = query.getOrDefault("supportsTeamDrives")
  valid_595088 = validateParameter(valid_595088, JBool, required = false,
                                 default = newJBool(false))
  if valid_595088 != nil:
    section.add "supportsTeamDrives", valid_595088
  var valid_595089 = query.getOrDefault("key")
  valid_595089 = validateParameter(valid_595089, JString, required = false,
                                 default = nil)
  if valid_595089 != nil:
    section.add "key", valid_595089
  var valid_595090 = query.getOrDefault("prettyPrint")
  valid_595090 = validateParameter(valid_595090, JBool, required = false,
                                 default = newJBool(true))
  if valid_595090 != nil:
    section.add "prettyPrint", valid_595090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595091: Call_DriveFilesTouch_595078; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Set the file's updated time to the current server time.
  ## 
  let valid = call_595091.validator(path, query, header, formData, body)
  let scheme = call_595091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595091.url(scheme.get, call_595091.host, call_595091.base,
                         call_595091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595091, url, valid)

proc call*(call_595092: Call_DriveFilesTouch_595078; fileId: string;
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
  var path_595093 = newJObject()
  var query_595094 = newJObject()
  add(query_595094, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_595094, "fields", newJString(fields))
  add(query_595094, "quotaUser", newJString(quotaUser))
  add(path_595093, "fileId", newJString(fileId))
  add(query_595094, "alt", newJString(alt))
  add(query_595094, "oauth_token", newJString(oauthToken))
  add(query_595094, "userIp", newJString(userIp))
  add(query_595094, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_595094, "key", newJString(key))
  add(query_595094, "prettyPrint", newJBool(prettyPrint))
  result = call_595092.call(path_595093, query_595094, nil, nil, nil)

var driveFilesTouch* = Call_DriveFilesTouch_595078(name: "driveFilesTouch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/touch", validator: validate_DriveFilesTouch_595079,
    base: "/drive/v2", url: url_DriveFilesTouch_595080, schemes: {Scheme.Https})
type
  Call_DriveFilesTrash_595095 = ref object of OpenApiRestCall_593424
proc url_DriveFilesTrash_595097(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveFilesTrash_595096(path: JsonNode; query: JsonNode;
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
  var valid_595098 = path.getOrDefault("fileId")
  valid_595098 = validateParameter(valid_595098, JString, required = true,
                                 default = nil)
  if valid_595098 != nil:
    section.add "fileId", valid_595098
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
  var valid_595099 = query.getOrDefault("supportsAllDrives")
  valid_595099 = validateParameter(valid_595099, JBool, required = false,
                                 default = newJBool(false))
  if valid_595099 != nil:
    section.add "supportsAllDrives", valid_595099
  var valid_595100 = query.getOrDefault("fields")
  valid_595100 = validateParameter(valid_595100, JString, required = false,
                                 default = nil)
  if valid_595100 != nil:
    section.add "fields", valid_595100
  var valid_595101 = query.getOrDefault("quotaUser")
  valid_595101 = validateParameter(valid_595101, JString, required = false,
                                 default = nil)
  if valid_595101 != nil:
    section.add "quotaUser", valid_595101
  var valid_595102 = query.getOrDefault("alt")
  valid_595102 = validateParameter(valid_595102, JString, required = false,
                                 default = newJString("json"))
  if valid_595102 != nil:
    section.add "alt", valid_595102
  var valid_595103 = query.getOrDefault("oauth_token")
  valid_595103 = validateParameter(valid_595103, JString, required = false,
                                 default = nil)
  if valid_595103 != nil:
    section.add "oauth_token", valid_595103
  var valid_595104 = query.getOrDefault("userIp")
  valid_595104 = validateParameter(valid_595104, JString, required = false,
                                 default = nil)
  if valid_595104 != nil:
    section.add "userIp", valid_595104
  var valid_595105 = query.getOrDefault("supportsTeamDrives")
  valid_595105 = validateParameter(valid_595105, JBool, required = false,
                                 default = newJBool(false))
  if valid_595105 != nil:
    section.add "supportsTeamDrives", valid_595105
  var valid_595106 = query.getOrDefault("key")
  valid_595106 = validateParameter(valid_595106, JString, required = false,
                                 default = nil)
  if valid_595106 != nil:
    section.add "key", valid_595106
  var valid_595107 = query.getOrDefault("prettyPrint")
  valid_595107 = validateParameter(valid_595107, JBool, required = false,
                                 default = newJBool(true))
  if valid_595107 != nil:
    section.add "prettyPrint", valid_595107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595108: Call_DriveFilesTrash_595095; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves a file to the trash. The currently authenticated user must own the file or be at least a fileOrganizer on the parent for shared drive files.
  ## 
  let valid = call_595108.validator(path, query, header, formData, body)
  let scheme = call_595108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595108.url(scheme.get, call_595108.host, call_595108.base,
                         call_595108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595108, url, valid)

proc call*(call_595109: Call_DriveFilesTrash_595095; fileId: string;
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
  var path_595110 = newJObject()
  var query_595111 = newJObject()
  add(query_595111, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_595111, "fields", newJString(fields))
  add(query_595111, "quotaUser", newJString(quotaUser))
  add(path_595110, "fileId", newJString(fileId))
  add(query_595111, "alt", newJString(alt))
  add(query_595111, "oauth_token", newJString(oauthToken))
  add(query_595111, "userIp", newJString(userIp))
  add(query_595111, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_595111, "key", newJString(key))
  add(query_595111, "prettyPrint", newJBool(prettyPrint))
  result = call_595109.call(path_595110, query_595111, nil, nil, nil)

var driveFilesTrash* = Call_DriveFilesTrash_595095(name: "driveFilesTrash",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/trash", validator: validate_DriveFilesTrash_595096,
    base: "/drive/v2", url: url_DriveFilesTrash_595097, schemes: {Scheme.Https})
type
  Call_DriveFilesUntrash_595112 = ref object of OpenApiRestCall_593424
proc url_DriveFilesUntrash_595114(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveFilesUntrash_595113(path: JsonNode; query: JsonNode;
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
  var valid_595115 = path.getOrDefault("fileId")
  valid_595115 = validateParameter(valid_595115, JString, required = true,
                                 default = nil)
  if valid_595115 != nil:
    section.add "fileId", valid_595115
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
  var valid_595116 = query.getOrDefault("supportsAllDrives")
  valid_595116 = validateParameter(valid_595116, JBool, required = false,
                                 default = newJBool(false))
  if valid_595116 != nil:
    section.add "supportsAllDrives", valid_595116
  var valid_595117 = query.getOrDefault("fields")
  valid_595117 = validateParameter(valid_595117, JString, required = false,
                                 default = nil)
  if valid_595117 != nil:
    section.add "fields", valid_595117
  var valid_595118 = query.getOrDefault("quotaUser")
  valid_595118 = validateParameter(valid_595118, JString, required = false,
                                 default = nil)
  if valid_595118 != nil:
    section.add "quotaUser", valid_595118
  var valid_595119 = query.getOrDefault("alt")
  valid_595119 = validateParameter(valid_595119, JString, required = false,
                                 default = newJString("json"))
  if valid_595119 != nil:
    section.add "alt", valid_595119
  var valid_595120 = query.getOrDefault("oauth_token")
  valid_595120 = validateParameter(valid_595120, JString, required = false,
                                 default = nil)
  if valid_595120 != nil:
    section.add "oauth_token", valid_595120
  var valid_595121 = query.getOrDefault("userIp")
  valid_595121 = validateParameter(valid_595121, JString, required = false,
                                 default = nil)
  if valid_595121 != nil:
    section.add "userIp", valid_595121
  var valid_595122 = query.getOrDefault("supportsTeamDrives")
  valid_595122 = validateParameter(valid_595122, JBool, required = false,
                                 default = newJBool(false))
  if valid_595122 != nil:
    section.add "supportsTeamDrives", valid_595122
  var valid_595123 = query.getOrDefault("key")
  valid_595123 = validateParameter(valid_595123, JString, required = false,
                                 default = nil)
  if valid_595123 != nil:
    section.add "key", valid_595123
  var valid_595124 = query.getOrDefault("prettyPrint")
  valid_595124 = validateParameter(valid_595124, JBool, required = false,
                                 default = newJBool(true))
  if valid_595124 != nil:
    section.add "prettyPrint", valid_595124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595125: Call_DriveFilesUntrash_595112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a file from the trash.
  ## 
  let valid = call_595125.validator(path, query, header, formData, body)
  let scheme = call_595125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595125.url(scheme.get, call_595125.host, call_595125.base,
                         call_595125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595125, url, valid)

proc call*(call_595126: Call_DriveFilesUntrash_595112; fileId: string;
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
  var path_595127 = newJObject()
  var query_595128 = newJObject()
  add(query_595128, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_595128, "fields", newJString(fields))
  add(query_595128, "quotaUser", newJString(quotaUser))
  add(path_595127, "fileId", newJString(fileId))
  add(query_595128, "alt", newJString(alt))
  add(query_595128, "oauth_token", newJString(oauthToken))
  add(query_595128, "userIp", newJString(userIp))
  add(query_595128, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_595128, "key", newJString(key))
  add(query_595128, "prettyPrint", newJBool(prettyPrint))
  result = call_595126.call(path_595127, query_595128, nil, nil, nil)

var driveFilesUntrash* = Call_DriveFilesUntrash_595112(name: "driveFilesUntrash",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/untrash", validator: validate_DriveFilesUntrash_595113,
    base: "/drive/v2", url: url_DriveFilesUntrash_595114, schemes: {Scheme.Https})
type
  Call_DriveFilesWatch_595129 = ref object of OpenApiRestCall_593424
proc url_DriveFilesWatch_595131(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveFilesWatch_595130(path: JsonNode; query: JsonNode;
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
  var valid_595132 = path.getOrDefault("fileId")
  valid_595132 = validateParameter(valid_595132, JString, required = true,
                                 default = nil)
  if valid_595132 != nil:
    section.add "fileId", valid_595132
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
  var valid_595133 = query.getOrDefault("supportsAllDrives")
  valid_595133 = validateParameter(valid_595133, JBool, required = false,
                                 default = newJBool(false))
  if valid_595133 != nil:
    section.add "supportsAllDrives", valid_595133
  var valid_595134 = query.getOrDefault("fields")
  valid_595134 = validateParameter(valid_595134, JString, required = false,
                                 default = nil)
  if valid_595134 != nil:
    section.add "fields", valid_595134
  var valid_595135 = query.getOrDefault("quotaUser")
  valid_595135 = validateParameter(valid_595135, JString, required = false,
                                 default = nil)
  if valid_595135 != nil:
    section.add "quotaUser", valid_595135
  var valid_595136 = query.getOrDefault("alt")
  valid_595136 = validateParameter(valid_595136, JString, required = false,
                                 default = newJString("json"))
  if valid_595136 != nil:
    section.add "alt", valid_595136
  var valid_595137 = query.getOrDefault("acknowledgeAbuse")
  valid_595137 = validateParameter(valid_595137, JBool, required = false,
                                 default = newJBool(false))
  if valid_595137 != nil:
    section.add "acknowledgeAbuse", valid_595137
  var valid_595138 = query.getOrDefault("oauth_token")
  valid_595138 = validateParameter(valid_595138, JString, required = false,
                                 default = nil)
  if valid_595138 != nil:
    section.add "oauth_token", valid_595138
  var valid_595139 = query.getOrDefault("userIp")
  valid_595139 = validateParameter(valid_595139, JString, required = false,
                                 default = nil)
  if valid_595139 != nil:
    section.add "userIp", valid_595139
  var valid_595140 = query.getOrDefault("supportsTeamDrives")
  valid_595140 = validateParameter(valid_595140, JBool, required = false,
                                 default = newJBool(false))
  if valid_595140 != nil:
    section.add "supportsTeamDrives", valid_595140
  var valid_595141 = query.getOrDefault("key")
  valid_595141 = validateParameter(valid_595141, JString, required = false,
                                 default = nil)
  if valid_595141 != nil:
    section.add "key", valid_595141
  var valid_595142 = query.getOrDefault("updateViewedDate")
  valid_595142 = validateParameter(valid_595142, JBool, required = false,
                                 default = newJBool(false))
  if valid_595142 != nil:
    section.add "updateViewedDate", valid_595142
  var valid_595143 = query.getOrDefault("projection")
  valid_595143 = validateParameter(valid_595143, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_595143 != nil:
    section.add "projection", valid_595143
  var valid_595144 = query.getOrDefault("revisionId")
  valid_595144 = validateParameter(valid_595144, JString, required = false,
                                 default = nil)
  if valid_595144 != nil:
    section.add "revisionId", valid_595144
  var valid_595145 = query.getOrDefault("prettyPrint")
  valid_595145 = validateParameter(valid_595145, JBool, required = false,
                                 default = newJBool(true))
  if valid_595145 != nil:
    section.add "prettyPrint", valid_595145
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

proc call*(call_595147: Call_DriveFilesWatch_595129; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Subscribe to changes on a file
  ## 
  let valid = call_595147.validator(path, query, header, formData, body)
  let scheme = call_595147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595147.url(scheme.get, call_595147.host, call_595147.base,
                         call_595147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595147, url, valid)

proc call*(call_595148: Call_DriveFilesWatch_595129; fileId: string;
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
  var path_595149 = newJObject()
  var query_595150 = newJObject()
  var body_595151 = newJObject()
  add(query_595150, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_595150, "fields", newJString(fields))
  add(query_595150, "quotaUser", newJString(quotaUser))
  add(path_595149, "fileId", newJString(fileId))
  add(query_595150, "alt", newJString(alt))
  add(query_595150, "acknowledgeAbuse", newJBool(acknowledgeAbuse))
  add(query_595150, "oauth_token", newJString(oauthToken))
  add(query_595150, "userIp", newJString(userIp))
  add(query_595150, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_595150, "key", newJString(key))
  add(query_595150, "updateViewedDate", newJBool(updateViewedDate))
  add(query_595150, "projection", newJString(projection))
  if resource != nil:
    body_595151 = resource
  add(query_595150, "revisionId", newJString(revisionId))
  add(query_595150, "prettyPrint", newJBool(prettyPrint))
  result = call_595148.call(path_595149, query_595150, nil, nil, body_595151)

var driveFilesWatch* = Call_DriveFilesWatch_595129(name: "driveFilesWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/watch", validator: validate_DriveFilesWatch_595130,
    base: "/drive/v2", url: url_DriveFilesWatch_595131, schemes: {Scheme.Https})
type
  Call_DriveChildrenInsert_595171 = ref object of OpenApiRestCall_593424
proc url_DriveChildrenInsert_595173(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveChildrenInsert_595172(path: JsonNode; query: JsonNode;
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
  var valid_595174 = path.getOrDefault("folderId")
  valid_595174 = validateParameter(valid_595174, JString, required = true,
                                 default = nil)
  if valid_595174 != nil:
    section.add "folderId", valid_595174
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
  var valid_595175 = query.getOrDefault("supportsAllDrives")
  valid_595175 = validateParameter(valid_595175, JBool, required = false,
                                 default = newJBool(false))
  if valid_595175 != nil:
    section.add "supportsAllDrives", valid_595175
  var valid_595176 = query.getOrDefault("fields")
  valid_595176 = validateParameter(valid_595176, JString, required = false,
                                 default = nil)
  if valid_595176 != nil:
    section.add "fields", valid_595176
  var valid_595177 = query.getOrDefault("quotaUser")
  valid_595177 = validateParameter(valid_595177, JString, required = false,
                                 default = nil)
  if valid_595177 != nil:
    section.add "quotaUser", valid_595177
  var valid_595178 = query.getOrDefault("alt")
  valid_595178 = validateParameter(valid_595178, JString, required = false,
                                 default = newJString("json"))
  if valid_595178 != nil:
    section.add "alt", valid_595178
  var valid_595179 = query.getOrDefault("oauth_token")
  valid_595179 = validateParameter(valid_595179, JString, required = false,
                                 default = nil)
  if valid_595179 != nil:
    section.add "oauth_token", valid_595179
  var valid_595180 = query.getOrDefault("userIp")
  valid_595180 = validateParameter(valid_595180, JString, required = false,
                                 default = nil)
  if valid_595180 != nil:
    section.add "userIp", valid_595180
  var valid_595181 = query.getOrDefault("supportsTeamDrives")
  valid_595181 = validateParameter(valid_595181, JBool, required = false,
                                 default = newJBool(false))
  if valid_595181 != nil:
    section.add "supportsTeamDrives", valid_595181
  var valid_595182 = query.getOrDefault("key")
  valid_595182 = validateParameter(valid_595182, JString, required = false,
                                 default = nil)
  if valid_595182 != nil:
    section.add "key", valid_595182
  var valid_595183 = query.getOrDefault("prettyPrint")
  valid_595183 = validateParameter(valid_595183, JBool, required = false,
                                 default = newJBool(true))
  if valid_595183 != nil:
    section.add "prettyPrint", valid_595183
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

proc call*(call_595185: Call_DriveChildrenInsert_595171; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a file into a folder.
  ## 
  let valid = call_595185.validator(path, query, header, formData, body)
  let scheme = call_595185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595185.url(scheme.get, call_595185.host, call_595185.base,
                         call_595185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595185, url, valid)

proc call*(call_595186: Call_DriveChildrenInsert_595171; folderId: string;
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
  var path_595187 = newJObject()
  var query_595188 = newJObject()
  var body_595189 = newJObject()
  add(query_595188, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_595188, "fields", newJString(fields))
  add(query_595188, "quotaUser", newJString(quotaUser))
  add(query_595188, "alt", newJString(alt))
  add(query_595188, "oauth_token", newJString(oauthToken))
  add(query_595188, "userIp", newJString(userIp))
  add(path_595187, "folderId", newJString(folderId))
  add(query_595188, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_595188, "key", newJString(key))
  if body != nil:
    body_595189 = body
  add(query_595188, "prettyPrint", newJBool(prettyPrint))
  result = call_595186.call(path_595187, query_595188, nil, nil, body_595189)

var driveChildrenInsert* = Call_DriveChildrenInsert_595171(
    name: "driveChildrenInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{folderId}/children",
    validator: validate_DriveChildrenInsert_595172, base: "/drive/v2",
    url: url_DriveChildrenInsert_595173, schemes: {Scheme.Https})
type
  Call_DriveChildrenList_595152 = ref object of OpenApiRestCall_593424
proc url_DriveChildrenList_595154(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveChildrenList_595153(path: JsonNode; query: JsonNode;
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
  var valid_595155 = path.getOrDefault("folderId")
  valid_595155 = validateParameter(valid_595155, JString, required = true,
                                 default = nil)
  if valid_595155 != nil:
    section.add "folderId", valid_595155
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
  var valid_595156 = query.getOrDefault("fields")
  valid_595156 = validateParameter(valid_595156, JString, required = false,
                                 default = nil)
  if valid_595156 != nil:
    section.add "fields", valid_595156
  var valid_595157 = query.getOrDefault("pageToken")
  valid_595157 = validateParameter(valid_595157, JString, required = false,
                                 default = nil)
  if valid_595157 != nil:
    section.add "pageToken", valid_595157
  var valid_595158 = query.getOrDefault("quotaUser")
  valid_595158 = validateParameter(valid_595158, JString, required = false,
                                 default = nil)
  if valid_595158 != nil:
    section.add "quotaUser", valid_595158
  var valid_595159 = query.getOrDefault("alt")
  valid_595159 = validateParameter(valid_595159, JString, required = false,
                                 default = newJString("json"))
  if valid_595159 != nil:
    section.add "alt", valid_595159
  var valid_595160 = query.getOrDefault("oauth_token")
  valid_595160 = validateParameter(valid_595160, JString, required = false,
                                 default = nil)
  if valid_595160 != nil:
    section.add "oauth_token", valid_595160
  var valid_595161 = query.getOrDefault("userIp")
  valid_595161 = validateParameter(valid_595161, JString, required = false,
                                 default = nil)
  if valid_595161 != nil:
    section.add "userIp", valid_595161
  var valid_595162 = query.getOrDefault("maxResults")
  valid_595162 = validateParameter(valid_595162, JInt, required = false,
                                 default = newJInt(100))
  if valid_595162 != nil:
    section.add "maxResults", valid_595162
  var valid_595163 = query.getOrDefault("orderBy")
  valid_595163 = validateParameter(valid_595163, JString, required = false,
                                 default = nil)
  if valid_595163 != nil:
    section.add "orderBy", valid_595163
  var valid_595164 = query.getOrDefault("q")
  valid_595164 = validateParameter(valid_595164, JString, required = false,
                                 default = nil)
  if valid_595164 != nil:
    section.add "q", valid_595164
  var valid_595165 = query.getOrDefault("key")
  valid_595165 = validateParameter(valid_595165, JString, required = false,
                                 default = nil)
  if valid_595165 != nil:
    section.add "key", valid_595165
  var valid_595166 = query.getOrDefault("prettyPrint")
  valid_595166 = validateParameter(valid_595166, JBool, required = false,
                                 default = newJBool(true))
  if valid_595166 != nil:
    section.add "prettyPrint", valid_595166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595167: Call_DriveChildrenList_595152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a folder's children.
  ## 
  let valid = call_595167.validator(path, query, header, formData, body)
  let scheme = call_595167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595167.url(scheme.get, call_595167.host, call_595167.base,
                         call_595167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595167, url, valid)

proc call*(call_595168: Call_DriveChildrenList_595152; folderId: string;
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
  var path_595169 = newJObject()
  var query_595170 = newJObject()
  add(query_595170, "fields", newJString(fields))
  add(query_595170, "pageToken", newJString(pageToken))
  add(query_595170, "quotaUser", newJString(quotaUser))
  add(query_595170, "alt", newJString(alt))
  add(query_595170, "oauth_token", newJString(oauthToken))
  add(query_595170, "userIp", newJString(userIp))
  add(path_595169, "folderId", newJString(folderId))
  add(query_595170, "maxResults", newJInt(maxResults))
  add(query_595170, "orderBy", newJString(orderBy))
  add(query_595170, "q", newJString(q))
  add(query_595170, "key", newJString(key))
  add(query_595170, "prettyPrint", newJBool(prettyPrint))
  result = call_595168.call(path_595169, query_595170, nil, nil, nil)

var driveChildrenList* = Call_DriveChildrenList_595152(name: "driveChildrenList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{folderId}/children", validator: validate_DriveChildrenList_595153,
    base: "/drive/v2", url: url_DriveChildrenList_595154, schemes: {Scheme.Https})
type
  Call_DriveChildrenGet_595190 = ref object of OpenApiRestCall_593424
proc url_DriveChildrenGet_595192(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveChildrenGet_595191(path: JsonNode; query: JsonNode;
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
  var valid_595193 = path.getOrDefault("childId")
  valid_595193 = validateParameter(valid_595193, JString, required = true,
                                 default = nil)
  if valid_595193 != nil:
    section.add "childId", valid_595193
  var valid_595194 = path.getOrDefault("folderId")
  valid_595194 = validateParameter(valid_595194, JString, required = true,
                                 default = nil)
  if valid_595194 != nil:
    section.add "folderId", valid_595194
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
  var valid_595195 = query.getOrDefault("fields")
  valid_595195 = validateParameter(valid_595195, JString, required = false,
                                 default = nil)
  if valid_595195 != nil:
    section.add "fields", valid_595195
  var valid_595196 = query.getOrDefault("quotaUser")
  valid_595196 = validateParameter(valid_595196, JString, required = false,
                                 default = nil)
  if valid_595196 != nil:
    section.add "quotaUser", valid_595196
  var valid_595197 = query.getOrDefault("alt")
  valid_595197 = validateParameter(valid_595197, JString, required = false,
                                 default = newJString("json"))
  if valid_595197 != nil:
    section.add "alt", valid_595197
  var valid_595198 = query.getOrDefault("oauth_token")
  valid_595198 = validateParameter(valid_595198, JString, required = false,
                                 default = nil)
  if valid_595198 != nil:
    section.add "oauth_token", valid_595198
  var valid_595199 = query.getOrDefault("userIp")
  valid_595199 = validateParameter(valid_595199, JString, required = false,
                                 default = nil)
  if valid_595199 != nil:
    section.add "userIp", valid_595199
  var valid_595200 = query.getOrDefault("key")
  valid_595200 = validateParameter(valid_595200, JString, required = false,
                                 default = nil)
  if valid_595200 != nil:
    section.add "key", valid_595200
  var valid_595201 = query.getOrDefault("prettyPrint")
  valid_595201 = validateParameter(valid_595201, JBool, required = false,
                                 default = newJBool(true))
  if valid_595201 != nil:
    section.add "prettyPrint", valid_595201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595202: Call_DriveChildrenGet_595190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific child reference.
  ## 
  let valid = call_595202.validator(path, query, header, formData, body)
  let scheme = call_595202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595202.url(scheme.get, call_595202.host, call_595202.base,
                         call_595202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595202, url, valid)

proc call*(call_595203: Call_DriveChildrenGet_595190; childId: string;
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
  var path_595204 = newJObject()
  var query_595205 = newJObject()
  add(query_595205, "fields", newJString(fields))
  add(query_595205, "quotaUser", newJString(quotaUser))
  add(query_595205, "alt", newJString(alt))
  add(query_595205, "oauth_token", newJString(oauthToken))
  add(query_595205, "userIp", newJString(userIp))
  add(path_595204, "childId", newJString(childId))
  add(path_595204, "folderId", newJString(folderId))
  add(query_595205, "key", newJString(key))
  add(query_595205, "prettyPrint", newJBool(prettyPrint))
  result = call_595203.call(path_595204, query_595205, nil, nil, nil)

var driveChildrenGet* = Call_DriveChildrenGet_595190(name: "driveChildrenGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{folderId}/children/{childId}",
    validator: validate_DriveChildrenGet_595191, base: "/drive/v2",
    url: url_DriveChildrenGet_595192, schemes: {Scheme.Https})
type
  Call_DriveChildrenDelete_595206 = ref object of OpenApiRestCall_593424
proc url_DriveChildrenDelete_595208(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DriveChildrenDelete_595207(path: JsonNode; query: JsonNode;
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
  var valid_595209 = path.getOrDefault("childId")
  valid_595209 = validateParameter(valid_595209, JString, required = true,
                                 default = nil)
  if valid_595209 != nil:
    section.add "childId", valid_595209
  var valid_595210 = path.getOrDefault("folderId")
  valid_595210 = validateParameter(valid_595210, JString, required = true,
                                 default = nil)
  if valid_595210 != nil:
    section.add "folderId", valid_595210
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
  var valid_595211 = query.getOrDefault("fields")
  valid_595211 = validateParameter(valid_595211, JString, required = false,
                                 default = nil)
  if valid_595211 != nil:
    section.add "fields", valid_595211
  var valid_595212 = query.getOrDefault("quotaUser")
  valid_595212 = validateParameter(valid_595212, JString, required = false,
                                 default = nil)
  if valid_595212 != nil:
    section.add "quotaUser", valid_595212
  var valid_595213 = query.getOrDefault("alt")
  valid_595213 = validateParameter(valid_595213, JString, required = false,
                                 default = newJString("json"))
  if valid_595213 != nil:
    section.add "alt", valid_595213
  var valid_595214 = query.getOrDefault("oauth_token")
  valid_595214 = validateParameter(valid_595214, JString, required = false,
                                 default = nil)
  if valid_595214 != nil:
    section.add "oauth_token", valid_595214
  var valid_595215 = query.getOrDefault("userIp")
  valid_595215 = validateParameter(valid_595215, JString, required = false,
                                 default = nil)
  if valid_595215 != nil:
    section.add "userIp", valid_595215
  var valid_595216 = query.getOrDefault("key")
  valid_595216 = validateParameter(valid_595216, JString, required = false,
                                 default = nil)
  if valid_595216 != nil:
    section.add "key", valid_595216
  var valid_595217 = query.getOrDefault("prettyPrint")
  valid_595217 = validateParameter(valid_595217, JBool, required = false,
                                 default = newJBool(true))
  if valid_595217 != nil:
    section.add "prettyPrint", valid_595217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595218: Call_DriveChildrenDelete_595206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a child from a folder.
  ## 
  let valid = call_595218.validator(path, query, header, formData, body)
  let scheme = call_595218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595218.url(scheme.get, call_595218.host, call_595218.base,
                         call_595218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595218, url, valid)

proc call*(call_595219: Call_DriveChildrenDelete_595206; childId: string;
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
  var path_595220 = newJObject()
  var query_595221 = newJObject()
  add(query_595221, "fields", newJString(fields))
  add(query_595221, "quotaUser", newJString(quotaUser))
  add(query_595221, "alt", newJString(alt))
  add(query_595221, "oauth_token", newJString(oauthToken))
  add(query_595221, "userIp", newJString(userIp))
  add(path_595220, "childId", newJString(childId))
  add(path_595220, "folderId", newJString(folderId))
  add(query_595221, "key", newJString(key))
  add(query_595221, "prettyPrint", newJBool(prettyPrint))
  result = call_595219.call(path_595220, query_595221, nil, nil, nil)

var driveChildrenDelete* = Call_DriveChildrenDelete_595206(
    name: "driveChildrenDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{folderId}/children/{childId}",
    validator: validate_DriveChildrenDelete_595207, base: "/drive/v2",
    url: url_DriveChildrenDelete_595208, schemes: {Scheme.Https})
type
  Call_DrivePermissionsGetIdForEmail_595222 = ref object of OpenApiRestCall_593424
proc url_DrivePermissionsGetIdForEmail_595224(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "email" in path, "`email` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/permissionIds/"),
               (kind: VariableSegment, value: "email")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DrivePermissionsGetIdForEmail_595223(path: JsonNode; query: JsonNode;
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
  var valid_595225 = path.getOrDefault("email")
  valid_595225 = validateParameter(valid_595225, JString, required = true,
                                 default = nil)
  if valid_595225 != nil:
    section.add "email", valid_595225
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
  var valid_595226 = query.getOrDefault("fields")
  valid_595226 = validateParameter(valid_595226, JString, required = false,
                                 default = nil)
  if valid_595226 != nil:
    section.add "fields", valid_595226
  var valid_595227 = query.getOrDefault("quotaUser")
  valid_595227 = validateParameter(valid_595227, JString, required = false,
                                 default = nil)
  if valid_595227 != nil:
    section.add "quotaUser", valid_595227
  var valid_595228 = query.getOrDefault("alt")
  valid_595228 = validateParameter(valid_595228, JString, required = false,
                                 default = newJString("json"))
  if valid_595228 != nil:
    section.add "alt", valid_595228
  var valid_595229 = query.getOrDefault("oauth_token")
  valid_595229 = validateParameter(valid_595229, JString, required = false,
                                 default = nil)
  if valid_595229 != nil:
    section.add "oauth_token", valid_595229
  var valid_595230 = query.getOrDefault("userIp")
  valid_595230 = validateParameter(valid_595230, JString, required = false,
                                 default = nil)
  if valid_595230 != nil:
    section.add "userIp", valid_595230
  var valid_595231 = query.getOrDefault("key")
  valid_595231 = validateParameter(valid_595231, JString, required = false,
                                 default = nil)
  if valid_595231 != nil:
    section.add "key", valid_595231
  var valid_595232 = query.getOrDefault("prettyPrint")
  valid_595232 = validateParameter(valid_595232, JBool, required = false,
                                 default = newJBool(true))
  if valid_595232 != nil:
    section.add "prettyPrint", valid_595232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595233: Call_DrivePermissionsGetIdForEmail_595222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the permission ID for an email address.
  ## 
  let valid = call_595233.validator(path, query, header, formData, body)
  let scheme = call_595233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595233.url(scheme.get, call_595233.host, call_595233.base,
                         call_595233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595233, url, valid)

proc call*(call_595234: Call_DrivePermissionsGetIdForEmail_595222; email: string;
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
  var path_595235 = newJObject()
  var query_595236 = newJObject()
  add(query_595236, "fields", newJString(fields))
  add(query_595236, "quotaUser", newJString(quotaUser))
  add(query_595236, "alt", newJString(alt))
  add(path_595235, "email", newJString(email))
  add(query_595236, "oauth_token", newJString(oauthToken))
  add(query_595236, "userIp", newJString(userIp))
  add(query_595236, "key", newJString(key))
  add(query_595236, "prettyPrint", newJBool(prettyPrint))
  result = call_595234.call(path_595235, query_595236, nil, nil, nil)

var drivePermissionsGetIdForEmail* = Call_DrivePermissionsGetIdForEmail_595222(
    name: "drivePermissionsGetIdForEmail", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/permissionIds/{email}",
    validator: validate_DrivePermissionsGetIdForEmail_595223, base: "/drive/v2",
    url: url_DrivePermissionsGetIdForEmail_595224, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesInsert_595254 = ref object of OpenApiRestCall_593424
proc url_DriveTeamdrivesInsert_595256(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DriveTeamdrivesInsert_595255(path: JsonNode; query: JsonNode;
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
  var valid_595257 = query.getOrDefault("fields")
  valid_595257 = validateParameter(valid_595257, JString, required = false,
                                 default = nil)
  if valid_595257 != nil:
    section.add "fields", valid_595257
  assert query != nil,
        "query argument is necessary due to required `requestId` field"
  var valid_595258 = query.getOrDefault("requestId")
  valid_595258 = validateParameter(valid_595258, JString, required = true,
                                 default = nil)
  if valid_595258 != nil:
    section.add "requestId", valid_595258
  var valid_595259 = query.getOrDefault("quotaUser")
  valid_595259 = validateParameter(valid_595259, JString, required = false,
                                 default = nil)
  if valid_595259 != nil:
    section.add "quotaUser", valid_595259
  var valid_595260 = query.getOrDefault("alt")
  valid_595260 = validateParameter(valid_595260, JString, required = false,
                                 default = newJString("json"))
  if valid_595260 != nil:
    section.add "alt", valid_595260
  var valid_595261 = query.getOrDefault("oauth_token")
  valid_595261 = validateParameter(valid_595261, JString, required = false,
                                 default = nil)
  if valid_595261 != nil:
    section.add "oauth_token", valid_595261
  var valid_595262 = query.getOrDefault("userIp")
  valid_595262 = validateParameter(valid_595262, JString, required = false,
                                 default = nil)
  if valid_595262 != nil:
    section.add "userIp", valid_595262
  var valid_595263 = query.getOrDefault("key")
  valid_595263 = validateParameter(valid_595263, JString, required = false,
                                 default = nil)
  if valid_595263 != nil:
    section.add "key", valid_595263
  var valid_595264 = query.getOrDefault("prettyPrint")
  valid_595264 = validateParameter(valid_595264, JBool, required = false,
                                 default = newJBool(true))
  if valid_595264 != nil:
    section.add "prettyPrint", valid_595264
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

proc call*(call_595266: Call_DriveTeamdrivesInsert_595254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.insert instead.
  ## 
  let valid = call_595266.validator(path, query, header, formData, body)
  let scheme = call_595266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595266.url(scheme.get, call_595266.host, call_595266.base,
                         call_595266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595266, url, valid)

proc call*(call_595267: Call_DriveTeamdrivesInsert_595254; requestId: string;
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
  var query_595268 = newJObject()
  var body_595269 = newJObject()
  add(query_595268, "fields", newJString(fields))
  add(query_595268, "requestId", newJString(requestId))
  add(query_595268, "quotaUser", newJString(quotaUser))
  add(query_595268, "alt", newJString(alt))
  add(query_595268, "oauth_token", newJString(oauthToken))
  add(query_595268, "userIp", newJString(userIp))
  add(query_595268, "key", newJString(key))
  if body != nil:
    body_595269 = body
  add(query_595268, "prettyPrint", newJBool(prettyPrint))
  result = call_595267.call(nil, query_595268, nil, nil, body_595269)

var driveTeamdrivesInsert* = Call_DriveTeamdrivesInsert_595254(
    name: "driveTeamdrivesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/teamdrives",
    validator: validate_DriveTeamdrivesInsert_595255, base: "/drive/v2",
    url: url_DriveTeamdrivesInsert_595256, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesList_595237 = ref object of OpenApiRestCall_593424
proc url_DriveTeamdrivesList_595239(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DriveTeamdrivesList_595238(path: JsonNode; query: JsonNode;
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
  var valid_595240 = query.getOrDefault("fields")
  valid_595240 = validateParameter(valid_595240, JString, required = false,
                                 default = nil)
  if valid_595240 != nil:
    section.add "fields", valid_595240
  var valid_595241 = query.getOrDefault("pageToken")
  valid_595241 = validateParameter(valid_595241, JString, required = false,
                                 default = nil)
  if valid_595241 != nil:
    section.add "pageToken", valid_595241
  var valid_595242 = query.getOrDefault("quotaUser")
  valid_595242 = validateParameter(valid_595242, JString, required = false,
                                 default = nil)
  if valid_595242 != nil:
    section.add "quotaUser", valid_595242
  var valid_595243 = query.getOrDefault("alt")
  valid_595243 = validateParameter(valid_595243, JString, required = false,
                                 default = newJString("json"))
  if valid_595243 != nil:
    section.add "alt", valid_595243
  var valid_595244 = query.getOrDefault("oauth_token")
  valid_595244 = validateParameter(valid_595244, JString, required = false,
                                 default = nil)
  if valid_595244 != nil:
    section.add "oauth_token", valid_595244
  var valid_595245 = query.getOrDefault("userIp")
  valid_595245 = validateParameter(valid_595245, JString, required = false,
                                 default = nil)
  if valid_595245 != nil:
    section.add "userIp", valid_595245
  var valid_595246 = query.getOrDefault("maxResults")
  valid_595246 = validateParameter(valid_595246, JInt, required = false,
                                 default = newJInt(10))
  if valid_595246 != nil:
    section.add "maxResults", valid_595246
  var valid_595247 = query.getOrDefault("q")
  valid_595247 = validateParameter(valid_595247, JString, required = false,
                                 default = nil)
  if valid_595247 != nil:
    section.add "q", valid_595247
  var valid_595248 = query.getOrDefault("key")
  valid_595248 = validateParameter(valid_595248, JString, required = false,
                                 default = nil)
  if valid_595248 != nil:
    section.add "key", valid_595248
  var valid_595249 = query.getOrDefault("useDomainAdminAccess")
  valid_595249 = validateParameter(valid_595249, JBool, required = false,
                                 default = newJBool(false))
  if valid_595249 != nil:
    section.add "useDomainAdminAccess", valid_595249
  var valid_595250 = query.getOrDefault("prettyPrint")
  valid_595250 = validateParameter(valid_595250, JBool, required = false,
                                 default = newJBool(true))
  if valid_595250 != nil:
    section.add "prettyPrint", valid_595250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595251: Call_DriveTeamdrivesList_595237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.list instead.
  ## 
  let valid = call_595251.validator(path, query, header, formData, body)
  let scheme = call_595251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595251.url(scheme.get, call_595251.host, call_595251.base,
                         call_595251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595251, url, valid)

proc call*(call_595252: Call_DriveTeamdrivesList_595237; fields: string = "";
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
  var query_595253 = newJObject()
  add(query_595253, "fields", newJString(fields))
  add(query_595253, "pageToken", newJString(pageToken))
  add(query_595253, "quotaUser", newJString(quotaUser))
  add(query_595253, "alt", newJString(alt))
  add(query_595253, "oauth_token", newJString(oauthToken))
  add(query_595253, "userIp", newJString(userIp))
  add(query_595253, "maxResults", newJInt(maxResults))
  add(query_595253, "q", newJString(q))
  add(query_595253, "key", newJString(key))
  add(query_595253, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_595253, "prettyPrint", newJBool(prettyPrint))
  result = call_595252.call(nil, query_595253, nil, nil, nil)

var driveTeamdrivesList* = Call_DriveTeamdrivesList_595237(
    name: "driveTeamdrivesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/teamdrives",
    validator: validate_DriveTeamdrivesList_595238, base: "/drive/v2",
    url: url_DriveTeamdrivesList_595239, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesUpdate_595286 = ref object of OpenApiRestCall_593424
proc url_DriveTeamdrivesUpdate_595288(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "teamDriveId" in path, "`teamDriveId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/teamdrives/"),
               (kind: VariableSegment, value: "teamDriveId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveTeamdrivesUpdate_595287(path: JsonNode; query: JsonNode;
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
  var valid_595289 = path.getOrDefault("teamDriveId")
  valid_595289 = validateParameter(valid_595289, JString, required = true,
                                 default = nil)
  if valid_595289 != nil:
    section.add "teamDriveId", valid_595289
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
  var valid_595290 = query.getOrDefault("fields")
  valid_595290 = validateParameter(valid_595290, JString, required = false,
                                 default = nil)
  if valid_595290 != nil:
    section.add "fields", valid_595290
  var valid_595291 = query.getOrDefault("quotaUser")
  valid_595291 = validateParameter(valid_595291, JString, required = false,
                                 default = nil)
  if valid_595291 != nil:
    section.add "quotaUser", valid_595291
  var valid_595292 = query.getOrDefault("alt")
  valid_595292 = validateParameter(valid_595292, JString, required = false,
                                 default = newJString("json"))
  if valid_595292 != nil:
    section.add "alt", valid_595292
  var valid_595293 = query.getOrDefault("oauth_token")
  valid_595293 = validateParameter(valid_595293, JString, required = false,
                                 default = nil)
  if valid_595293 != nil:
    section.add "oauth_token", valid_595293
  var valid_595294 = query.getOrDefault("userIp")
  valid_595294 = validateParameter(valid_595294, JString, required = false,
                                 default = nil)
  if valid_595294 != nil:
    section.add "userIp", valid_595294
  var valid_595295 = query.getOrDefault("key")
  valid_595295 = validateParameter(valid_595295, JString, required = false,
                                 default = nil)
  if valid_595295 != nil:
    section.add "key", valid_595295
  var valid_595296 = query.getOrDefault("useDomainAdminAccess")
  valid_595296 = validateParameter(valid_595296, JBool, required = false,
                                 default = newJBool(false))
  if valid_595296 != nil:
    section.add "useDomainAdminAccess", valid_595296
  var valid_595297 = query.getOrDefault("prettyPrint")
  valid_595297 = validateParameter(valid_595297, JBool, required = false,
                                 default = newJBool(true))
  if valid_595297 != nil:
    section.add "prettyPrint", valid_595297
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

proc call*(call_595299: Call_DriveTeamdrivesUpdate_595286; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.update instead.
  ## 
  let valid = call_595299.validator(path, query, header, formData, body)
  let scheme = call_595299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595299.url(scheme.get, call_595299.host, call_595299.base,
                         call_595299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595299, url, valid)

proc call*(call_595300: Call_DriveTeamdrivesUpdate_595286; teamDriveId: string;
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
  var path_595301 = newJObject()
  var query_595302 = newJObject()
  var body_595303 = newJObject()
  add(path_595301, "teamDriveId", newJString(teamDriveId))
  add(query_595302, "fields", newJString(fields))
  add(query_595302, "quotaUser", newJString(quotaUser))
  add(query_595302, "alt", newJString(alt))
  add(query_595302, "oauth_token", newJString(oauthToken))
  add(query_595302, "userIp", newJString(userIp))
  add(query_595302, "key", newJString(key))
  add(query_595302, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  if body != nil:
    body_595303 = body
  add(query_595302, "prettyPrint", newJBool(prettyPrint))
  result = call_595300.call(path_595301, query_595302, nil, nil, body_595303)

var driveTeamdrivesUpdate* = Call_DriveTeamdrivesUpdate_595286(
    name: "driveTeamdrivesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesUpdate_595287, base: "/drive/v2",
    url: url_DriveTeamdrivesUpdate_595288, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesGet_595270 = ref object of OpenApiRestCall_593424
proc url_DriveTeamdrivesGet_595272(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "teamDriveId" in path, "`teamDriveId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/teamdrives/"),
               (kind: VariableSegment, value: "teamDriveId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveTeamdrivesGet_595271(path: JsonNode; query: JsonNode;
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
  var valid_595273 = path.getOrDefault("teamDriveId")
  valid_595273 = validateParameter(valid_595273, JString, required = true,
                                 default = nil)
  if valid_595273 != nil:
    section.add "teamDriveId", valid_595273
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
  var valid_595274 = query.getOrDefault("fields")
  valid_595274 = validateParameter(valid_595274, JString, required = false,
                                 default = nil)
  if valid_595274 != nil:
    section.add "fields", valid_595274
  var valid_595275 = query.getOrDefault("quotaUser")
  valid_595275 = validateParameter(valid_595275, JString, required = false,
                                 default = nil)
  if valid_595275 != nil:
    section.add "quotaUser", valid_595275
  var valid_595276 = query.getOrDefault("alt")
  valid_595276 = validateParameter(valid_595276, JString, required = false,
                                 default = newJString("json"))
  if valid_595276 != nil:
    section.add "alt", valid_595276
  var valid_595277 = query.getOrDefault("oauth_token")
  valid_595277 = validateParameter(valid_595277, JString, required = false,
                                 default = nil)
  if valid_595277 != nil:
    section.add "oauth_token", valid_595277
  var valid_595278 = query.getOrDefault("userIp")
  valid_595278 = validateParameter(valid_595278, JString, required = false,
                                 default = nil)
  if valid_595278 != nil:
    section.add "userIp", valid_595278
  var valid_595279 = query.getOrDefault("key")
  valid_595279 = validateParameter(valid_595279, JString, required = false,
                                 default = nil)
  if valid_595279 != nil:
    section.add "key", valid_595279
  var valid_595280 = query.getOrDefault("useDomainAdminAccess")
  valid_595280 = validateParameter(valid_595280, JBool, required = false,
                                 default = newJBool(false))
  if valid_595280 != nil:
    section.add "useDomainAdminAccess", valid_595280
  var valid_595281 = query.getOrDefault("prettyPrint")
  valid_595281 = validateParameter(valid_595281, JBool, required = false,
                                 default = newJBool(true))
  if valid_595281 != nil:
    section.add "prettyPrint", valid_595281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595282: Call_DriveTeamdrivesGet_595270; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.get instead.
  ## 
  let valid = call_595282.validator(path, query, header, formData, body)
  let scheme = call_595282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595282.url(scheme.get, call_595282.host, call_595282.base,
                         call_595282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595282, url, valid)

proc call*(call_595283: Call_DriveTeamdrivesGet_595270; teamDriveId: string;
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
  var path_595284 = newJObject()
  var query_595285 = newJObject()
  add(path_595284, "teamDriveId", newJString(teamDriveId))
  add(query_595285, "fields", newJString(fields))
  add(query_595285, "quotaUser", newJString(quotaUser))
  add(query_595285, "alt", newJString(alt))
  add(query_595285, "oauth_token", newJString(oauthToken))
  add(query_595285, "userIp", newJString(userIp))
  add(query_595285, "key", newJString(key))
  add(query_595285, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_595285, "prettyPrint", newJBool(prettyPrint))
  result = call_595283.call(path_595284, query_595285, nil, nil, nil)

var driveTeamdrivesGet* = Call_DriveTeamdrivesGet_595270(
    name: "driveTeamdrivesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesGet_595271, base: "/drive/v2",
    url: url_DriveTeamdrivesGet_595272, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesDelete_595304 = ref object of OpenApiRestCall_593424
proc url_DriveTeamdrivesDelete_595306(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "teamDriveId" in path, "`teamDriveId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/teamdrives/"),
               (kind: VariableSegment, value: "teamDriveId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveTeamdrivesDelete_595305(path: JsonNode; query: JsonNode;
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
  var valid_595307 = path.getOrDefault("teamDriveId")
  valid_595307 = validateParameter(valid_595307, JString, required = true,
                                 default = nil)
  if valid_595307 != nil:
    section.add "teamDriveId", valid_595307
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
  var valid_595308 = query.getOrDefault("fields")
  valid_595308 = validateParameter(valid_595308, JString, required = false,
                                 default = nil)
  if valid_595308 != nil:
    section.add "fields", valid_595308
  var valid_595309 = query.getOrDefault("quotaUser")
  valid_595309 = validateParameter(valid_595309, JString, required = false,
                                 default = nil)
  if valid_595309 != nil:
    section.add "quotaUser", valid_595309
  var valid_595310 = query.getOrDefault("alt")
  valid_595310 = validateParameter(valid_595310, JString, required = false,
                                 default = newJString("json"))
  if valid_595310 != nil:
    section.add "alt", valid_595310
  var valid_595311 = query.getOrDefault("oauth_token")
  valid_595311 = validateParameter(valid_595311, JString, required = false,
                                 default = nil)
  if valid_595311 != nil:
    section.add "oauth_token", valid_595311
  var valid_595312 = query.getOrDefault("userIp")
  valid_595312 = validateParameter(valid_595312, JString, required = false,
                                 default = nil)
  if valid_595312 != nil:
    section.add "userIp", valid_595312
  var valid_595313 = query.getOrDefault("key")
  valid_595313 = validateParameter(valid_595313, JString, required = false,
                                 default = nil)
  if valid_595313 != nil:
    section.add "key", valid_595313
  var valid_595314 = query.getOrDefault("prettyPrint")
  valid_595314 = validateParameter(valid_595314, JBool, required = false,
                                 default = newJBool(true))
  if valid_595314 != nil:
    section.add "prettyPrint", valid_595314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595315: Call_DriveTeamdrivesDelete_595304; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.delete instead.
  ## 
  let valid = call_595315.validator(path, query, header, formData, body)
  let scheme = call_595315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595315.url(scheme.get, call_595315.host, call_595315.base,
                         call_595315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595315, url, valid)

proc call*(call_595316: Call_DriveTeamdrivesDelete_595304; teamDriveId: string;
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
  var path_595317 = newJObject()
  var query_595318 = newJObject()
  add(path_595317, "teamDriveId", newJString(teamDriveId))
  add(query_595318, "fields", newJString(fields))
  add(query_595318, "quotaUser", newJString(quotaUser))
  add(query_595318, "alt", newJString(alt))
  add(query_595318, "oauth_token", newJString(oauthToken))
  add(query_595318, "userIp", newJString(userIp))
  add(query_595318, "key", newJString(key))
  add(query_595318, "prettyPrint", newJBool(prettyPrint))
  result = call_595316.call(path_595317, query_595318, nil, nil, nil)

var driveTeamdrivesDelete* = Call_DriveTeamdrivesDelete_595304(
    name: "driveTeamdrivesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesDelete_595305, base: "/drive/v2",
    url: url_DriveTeamdrivesDelete_595306, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
